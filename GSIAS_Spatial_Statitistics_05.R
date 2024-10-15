# 필수 패키지 설치 및 로드
# Install and load required packages
library(WDI)          # World Development Indicators (WDI) data package
library(dplyr)        # Data manipulation functions
library(sf)           # Simple features for spatial data
library(spatialreg)   # Spatial regression models (SEM and SAR)
library(spdep)        # Spatial dependencies and spatial weights functions
library(ggplot2)      # Data visualization package
library(plotly)       # Interactive plot package
library(lmtest)       # Breusch-Pagan test for heteroscedasticity

# 1. WDI 데이터 다운로드 (GDP 성장률, 교육 지출 비율, 인구 성장률)
# Download WDI data (GDP growth, education expenditure, population growth)
wdi_data <- WDI(indicator = c("NY.GDP.MKTP.KD.ZG", "SE.XPD.TOTL.GD.ZS", "SP.POP.GROW"), 
                start = 2020, end = 2020, extra = TRUE)

# 2. 필요한 변수 선택 및 결측치 제거
# Select required variables and remove missing/invalid coordinate values
data_clean <- wdi_data %>%
  select(iso2c, country, NY.GDP.MKTP.KD.ZG, SE.XPD.TOTL.GD.ZS, SP.POP.GROW, region, income, longitude, latitude) %>%
  filter(!is.na(longitude) & !is.na(latitude)) %>%
  filter(!is.na(iso2c)) %>%
  mutate(longitude = as.numeric(longitude), latitude = as.numeric(latitude)) %>%
  filter(longitude != 0 & latitude != 0) %>%
  filter(between(longitude, -180, 180) & between(latitude, -90, 90)) %>%
  na.omit()

# 3. 공간 데이터 준비 및 좌표 설정
# Prepare spatial data and set coordinates
coords <- cbind(data_clean$longitude, data_clean$latitude)
data_clean_sf <- st_as_sf(data_clean, coords = c("longitude", "latitude"), crs = 4326)

# 4. 공간 가중치 행렬 생성 (K-Nearest Neighbors)
# Create spatial weights matrix using K-nearest neighbors (4 neighbors)
nb <- knn2nb(knearneigh(coords, k = 4))  # 4 nearest neighbors
lw <- nb2listw(nb, style = "W")  # Create row-standardized spatial weights matrix

# 5. Spatial Error Model (SEM) 적용
# Apply SEM with GDP growth as the dependent variable, education expenditure, and population growth as independent variables
sem_model <- errorsarlm(NY.GDP.MKTP.KD.ZG ~ SE.XPD.TOTL.GD.ZS + SP.POP.GROW, 
                        data = data_clean, listw = lw)

# 6. Spatial Lagged y Model (SAR) 적용
# Apply SAR with GDP growth as the dependent variable, education expenditure, and population growth as independent variables
sar_model <- lagsarlm(NY.GDP.MKTP.KD.ZG ~ SE.XPD.TOTL.GD.ZS + SP.POP.GROW, 
                      data = data_clean, listw = lw)

# 7. 모델 검증 및 테스트
# Model validation and tests

# 7.1 Moran's I test on residuals: Check for spatial autocorrelation in residuals
# Moran's I tests if residuals exhibit spatial autocorrelation.
moran_test_sem <- moran.test(sem_model$residuals, lw)
moran_test_sar <- moran.test(sar_model$residuals, lw)

cat("Moran's I test for SEM residuals:\n")
print(moran_test_sem)
cat("Moran's I test for SAR residuals:\n")
print(moran_test_sar)

# 7.2 Lagrange Multiplier test (LM) for spatial error and lag
# Lagrange Multiplier test for spatial error and lag based on OLS model
# Since these tests require an OLS model, first fit an OLS model
ols_model <- lm(NY.GDP.MKTP.KD.ZG ~ SE.XPD.TOTL.GD.ZS + SP.POP.GROW, data = data_clean)

# Perform Lagrange Multiplier tests to check for spatial dependence in the residuals
# Run all LM tests, including LM for lag and error
lm_tests <- lm.RStests(ols_model, listw = lw, test = "all")

# Output LM test results
cat("Lagrange Multiplier Test Results:\n")
print(lm_tests)

# You can also access specific LM test results if needed:
# e.g., LM test for spatial lag
lm_lag_test <- lm_tests$LMlag
cat("LM test for spatial lag:\n")
print(lm_lag_test)

# LM test for spatial error
lm_error_test <- lm_tests$LMerr
cat("LM test for spatial error:\n")
print(lm_error_test)


# 7.3 Breusch-Pagan test for heteroscedasticity: Check for heteroscedasticity
# Breusch-Pagan test checks if residuals are heteroscedastic
# Apply OLS model for heteroscedasticity test
ols_model <- lm(NY.GDP.MKTP.KD.ZG ~ SE.XPD.TOTL.GD.ZS + SP.POP.GROW, data = data_clean)

# Perform Breusch-Pagan test for heteroscedasticity
bp_test_ols <- bptest(ols_model)

# Output Breusch-Pagan test result
cat("Breusch-Pagan Test for OLS Model (Heteroscedasticity):\n")
print(bp_test_ols)

# 8. SEM 및 SAR 모델 결과 해석
# Interpretation of SEM and SAR model results

# SEM 모델에서 공간적 상관성 계수 λ 출력
# Print the spatial autocorrelation coefficient (lambda) from SEM
lambda <- sem_model$lambda
cat("Spatial autocorrelation λ value (SEM): ", lambda, "\n")

# SAR 모델에서 공간 지연 계수 rho 출력
# Print the spatial lag coefficient (rho) from SAR
rho <- sar_model$rho
cat("Spatial lag coefficient (rho) value (SAR): ", rho, "\n")

# 각 모델의 AIC 및 log-likelihood 값 계산
# Calculate AIC and log-likelihood for both SEM and SAR
aic_value_sem <- AIC(sem_model)
loglik_value_sem <- logLik(sem_model)
aic_value_sar <- AIC(sar_model)
loglik_value_sar <- logLik(sar_model)

cat("AIC value (SEM): ", aic_value_sem, "\n")
cat("Log-likelihood value (SEM): ", loglik_value_sem, "\n")
cat("AIC value (SAR): ", aic_value_sar, "\n")
cat("Log-likelihood value (SAR): ", loglik_value_sar, "\n")

# 9. SEM vs SAR 모델 비교 시각화
# Visualize comparison of SEM and SAR fitted values
fitted_sem <- sem_model$fitted.values
fitted_sar <- sar_model$fitted.values

# Create a comparison data frame
comparison_df <- data.frame(
  country = data_clean$country,
  GDP_growth = data_clean$NY.GDP.MKTP.KD.ZG,
  fitted_SEM = fitted_sem,
  fitted_SAR = fitted_sar
)

# Plot observed vs fitted values for both models
p <- ggplot(comparison_df, aes(x = GDP_growth)) +
  geom_point(aes(y = fitted_SEM, color = "SEM"), size = 3) +
  geom_point(aes(y = fitted_SAR, color = "SAR"), size = 3, shape = 2) +
  labs(title = "Observed vs Fitted GDP Growth: SEM vs SAR",
       x = "Observed GDP Growth",
       y = "Fitted GDP Growth",
       color = "Model") +
  theme_minimal()

# Convert to interactive plot using plotly
ggplotly(p)
