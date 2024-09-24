# 필요한 패키지 설치 및 불러오기
# Install and load necessary packages
# install.packages("WDI")
# install.packages("ggplot2")
# install.packages("sf")
# install.packages("rnaturalearth")
# install.packages("rnaturalearthdata")
# install.packages("countrycode")  # 국가 코드 변환을 위한 패키지

library(WDI)  # World Development Indicators 데이터 가져오기
library(ggplot2)  # 데이터 시각화를 위한 패키지
library(sf)  # 공간 데이터 처리를 위한 패키지
library(rnaturalearth)  # 자연 지구 데이터 가져오기
library(rnaturalearthdata)  # 자연 지구 데이터
library(countrycode)  # 국가 코드 변환

# World Bank에서 빈곤 갭 지표와 교육 성취도 지표 가져오기
# Fetch Poverty Gap and Educational Attainment data from World Bank
# SI.POV.GAPS: Poverty Gap at $3.65 a day (2017 PPP)
# SE.TER.CUAT.DO.ZS: Doctoral education attainment (percentage of population 25+)
education_poverty_data <- WDI(indicator = c("SI.POV.GAPS", "SE.TER.CUAT.DO.ZS"), 
                              country = "all", start = 2020, end = 2020)

# 전세계 국가 데이터 불러오기
# Load world map data
world <- ne_countries(scale = "medium", returnclass = "sf")

# World Bank 데이터에서 2글자 ISO 코드를 3글자 ISO 코드로 변환
# Convert the 2-letter ISO code from WDI to a 3-letter ISO code
education_poverty_data$iso_a3 <- countrycode(education_poverty_data$iso2c, "iso2c", "iso3c")

# World Bank 데이터를 국가 코드로 병합
# Merge World Bank data with world map data using ISO country codes
world <- merge(world, education_poverty_data, by.x = "iso_a3", by.y = "iso_a3", all.x = TRUE)

# 병합 후 NA 값이 있는지 확인 (Check if any NAs remain after the merge)
summary(world$SI.POV.GAPS)  # 빈곤 갭 요약
summary(world$SE.TER.CUAT.DO.ZS)  # 박사 학위 성취도 요약

# 표준화 함수 정의 (Standardization function)
# 평균을 0으로, 표준편차를 1로 변환하여 데이터의 비교 가능성 향상
standardize <- function(x) {
  return((x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE))  # 표준화된 값 계산
}

# 빈곤 갭과 박사 학위 성취도 지표를 표준화
# Standardize the poverty gap and doctoral education attainment indicators
world$poverty_gap_std <- standardize(world$SI.POV.GAPS)
world$doctoral_attainment_std <- standardize(world$SE.TER.CUAT.DO.ZS)

# NA 처리: NA가 아닌 값만 시각화하도록 처리
# Handle NA values to visualize only non-NA regions
world$poverty_gap_std[is.na(world$poverty_gap_std)] <- NA
world$doctoral_attainment_std[is.na(world$doctoral_attainment_std)] <- NA

# 빈곤 갭 시각화 (표준화된 값)
# Visualizing standardized Poverty Gap
ggplot(data = world) +
  geom_sf(aes(fill = poverty_gap_std), color = "white") +
  scale_fill_gradient(low = "blue", high = "red", na.value = "grey90", 
                      name = "Standardized Poverty Gap") +
  labs(title = "Global Standardized Visualization of Poverty Gap",
       subtitle = "$3.65 a day (2017 PPP)",
       caption = "Source: World Bank (WDI)") +
  theme_minimal()

# 시각화 해석: 파란색은 빈곤 갭이 낮음을, 빨간색은 높은 빈곤 갭을 나타냄
# Visualization interpretation: Blue indicates a low poverty gap, while red indicates a high poverty gap.

# 박사 학위 성취도 시각화 (표준화된 값)
# Visualizing standardized Doctoral Education Attainment
ggplot(data = world) +
  geom_sf(aes(fill = doctoral_attainment_std), color = "white") +
  scale_fill_gradient(low = "yellow", high = "green", na.value = "grey90", 
                      name = "Standardized Doctoral Attainment") +
  labs(title = "Global Standardized Visualization of Doctoral Education Attainment",
       subtitle = "Population 25+, total (%) (cumulative)",
       caption = "Source: World Bank (WDI)") +
  theme_minimal()

# 시각화 해석: 노란색은 박사 학위 성취도가 낮음을, 초록색은 높은 성취도를 나타냄
# Visualization interpretation: Yellow indicates low doctoral attainment, while green indicates high attainment.

# MENA 국가 필터링을 위한 ISO 코드 설정 (중동 및 북아프리카 포함)
# Define MENA region ISO codes (includes Middle East and North Africa)
mena_countries <- c("DZA", "EGY", "IRQ", "JOR", "KWT", "LBN", "LBY", "MAR", "OMN", 
                    "QAT", "SAU", "SYR", "TUN", "ARE", "YEM", "BHR", "ISR", "IRN", 
                    "PSE", "TUR", "SDN", "MAU")

# 아프리카 및 중동(MENA) 필터링
# Filter for Africa and MENA regions
africa_mena_countries <- world[world$region_un == "Africa" | world$iso_a3 %in% mena_countries, ]

# 빈곤 갭 시각화 (아프리카 및 중동만)
# Visualizing Poverty Gap (Africa and MENA only)
ggplot(data = africa_mena_countries) +
  geom_sf(aes(fill = SI.POV.GAPS), color = "white") +
  scale_fill_gradient(low = "blue", high = "red", na.value = "grey90", 
                      name = "Poverty Gap (%)") +
  labs(title = "Poverty Gap in Africa and MENA Region",
       subtitle = "$3.65 a day (2017 PPP)",
       caption = "Source: World Bank (WDI)") +
  theme_minimal()

# 시각화 해석: 아프리카 및 중동 지역의 빈곤 상황을 보여주며, 각 국가의 빈곤 갭을 비교 가능하게 함
# Visualization interpretation: Shows the poverty situation in Africa and MENA region, allowing comparison of poverty gaps among countries.

# 박사 학위 성취도 시각화 (아프리카 및 중동만)
# Visualizing Doctoral Education Attainment (Africa and MENA only)
ggplot(data = africa_mena_countries) +
  geom_sf(aes(fill = SE.TER.CUAT.DO.ZS), color = "white") +
  scale_fill_gradient(low = "yellow", high = "green", na.value = "grey90", 
                      name = "Doctoral Education Attainment (%)") +
  labs(title = "Doctoral Education Attainment in Africa and MENA Region",
       subtitle = "Population 25+, total (%) (cumulative)",
       caption = "Source: World Bank (WDI)") +
  theme_minimal()

# 시각화 해석: 아프리카 및 중동 지역의 박사 학위 성취도를 비교 가능하게 보여줌
# Visualization interpretation: Allows comparison of doctoral attainment across the Africa and MENA region.

# 아프리카 및 중동 지역 데이터 로드 (Loading Africa and Middle East region data)
# 전 세계 데이터 불러오기 (Load world data)
world <- ne_countries(returnclass = "sf")

# Sub-Saharan Africa 지도 시각화 
# (Visualizing the map of Sub-Saharan Africa)
sub_saharan_africa <- world %>%
  filter(region_wb %in% c('Sub-Saharan Africa'))

ggplot() +
  geom_sf(data = sub_saharan_africa, fill = "lightgreen", color = "black") +
  labs(title = "Sub-Saharan Africa Map")

# 중동 및 북아프리카 지도 시각화 
# (Visualizing the map of Middle East and North Africa)
middle_east_north_africa <- world %>%
  filter(region_wb %in% c('Middle East & North Africa'))

ggplot() +
  geom_sf(data = middle_east_north_africa, fill = "lightblue", color = "black") +
  labs(title = "Middle East and North Africa Map")

# 특정 국가(케냐)와 인접한 국가들 시각화 (Visualizing Kenya and neighboring countries)
ggplot() +
  geom_sf(data = sub_saharan_africa %>% filter(name == "Kenya"), 
          fill = "red", color = "black") +
  geom_sf(data = sub_saharan_africa %>% filter(name == "Tanzania"), 
          fill = "blue", color = "black", linetype = "dashed") +
  geom_sf(data = sub_saharan_africa %>% filter(name == "Uganda"), 
          fill = "green", color = "black", linetype = "dotted") +
  labs(title = "Kenya, Tanzania, and Uganda Map")

# 시각화 해석: 케냐와 인접한 국가들(탄자니아와 우간다)을 비교하여 지리적 관계를 시각화
# Visualization interpretation: Visualizes the geographical relationships between Kenya and its neighboring countries (Tanzania and Uganda).

# 거리 계산 (Calculating distances)
# 특정 국가를 선택하여 거리 계산 (Calculating distance between specific countries by name)
# 예: 나이지리아와 케냐 간의 거리
nigeria <- world[world$name == "Nigeria", ]
kenya <- world[world$name == "Kenya", ]
distance_nigeria_kenya <- st_distance(nigeria, kenya)
distance_nigeria_kenya_km <- as.numeric(distance_nigeria_kenya) / 1000

# 거리 출력 (Printing the calculated distance in kilometers)
print(paste("The distance between Nigeria and Kenya is:", distance_nigeria_kenya_km, "km"))

# 예: 케냐와 남아프리카공화국 간의 거리
south_africa <- world[world$name == "South Africa", ]
distance_kenya_south_africa <- st_distance(kenya, south_africa)
distance_kenya_south_africa_km <- as.numeric(distance_kenya_south_africa) / 1000

# 거리 출력 (Printing the calculated distance in kilometers)
print(paste("The distance between Kenya and South Africa is:", distance_kenya_south_africa_km, "km"))

# 북아프리카 국가들을 하나로 병합 (Merging North African countries into one spatial object)
north_africa_merged <- st_union(middle_east_north_africa)

# 병합된 영역 시각화 (Visualizing the merged North African region)
ggplot() +
  geom_sf(data = north_africa_merged, fill = "orange", color = "black") +
  labs(title = "Merged North African Region")

# 시각화 해석: 북아프리카 지역을 하나로 통합하여 보여줌
# Visualization interpretation: Merges and visualizes the North African region.

