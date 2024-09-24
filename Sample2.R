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

# World Bank에서 도시 인구와 물 스트레스 지표 가져오기
# Fetch Urban Population and Water Stress data from World Bank
# SP.URB.TOTL.IN.ZS: Urban population (% of total population)
# ER.H2O.FWST.ZS: Level of water stress: freshwater withdrawal as a proportion of available freshwater resources
urban_water_data <- WDI(indicator = c("SP.URB.TOTL.IN.ZS", "ER.H2O.FWST.ZS"), 
                        country = "all", start = 2020, end = 2020)

# 전세계 국가 데이터 불러오기
# Load world map data
world <- ne_countries(scale = "medium", returnclass = "sf")

# World Bank 데이터에서 2글자 ISO 코드를 3글자 ISO 코드로 변환
# Convert the 2-letter ISO code from WDI to a 3-letter ISO code
urban_water_data$iso_a3 <- countrycode(urban_water_data$iso2c, "iso2c", "iso3c")

# World Bank 데이터를 국가 코드로 병합
# Merge World Bank data with world map data using ISO country codes
world <- merge(world, urban_water_data, by.x = "iso_a3", by.y = "iso_a3", all.x = TRUE)

# MENA 및 Sub-Saharan Africa 국가 필터링을 위한 ISO 코드 설정
# Define MENA and Sub-Saharan Africa region ISO codes
mena_countries <- c("DZA", "EGY", "IRQ", "JOR", "KWT", "LBN", "LBY", "MAR", "OMN", 
                    "QAT", "SAU", "SYR", "TUN", "ARE", "YEM", "BHR", "ISR", "IRN", 
                    "PSE", "TUR", "SDN", "MAU")

# SSA(Sub-Saharan Africa) 지역 필터링을 위한 World Bank 코드 (World Bank region classification 사용)
ssa_countries <- world$iso_a3[world$region_wb == "Sub-Saharan Africa"]

# MENA와 SSA 모두 포함하는 필터링 적용
# Filter for both MENA and Sub-Saharan Africa regions
africa_mena_countries <- world[world$iso_a3 %in% c(mena_countries, ssa_countries), ]

# 도시 인구 비율 시각화 (MENA 및 SSA)
# Visualizing Urban Population (% of total population) for MENA and SSA
ggplot(data = africa_mena_countries) +
  geom_sf(aes(fill = SP.URB.TOTL.IN.ZS), color = "white") +
  scale_fill_gradient(low = "blue", high = "red", na.value = "grey90", 
                      name = "Urban Population (%)") +
  labs(title = "Urban Population in MENA and Sub-Saharan Africa",
       subtitle = "Urban population as % of total population",
       caption = "Source: World Bank (WDI)") +
  theme_minimal()

# 물 스트레스 수준 시각화 (MENA 및 SSA)
# Visualizing Water Stress Levels for MENA and SSA
ggplot(data = africa_mena_countries) +
  geom_sf(aes(fill = ER.H2O.FWST.ZS), color = "white") +
  scale_fill_gradient(low = "yellow", high = "green", na.value = "grey90", 
                      name = "Water Stress (%)") +
  labs(title = "Water Stress Levels in MENA and Sub-Saharan Africa",
       subtitle = "Freshwater withdrawal as % of available freshwater resources",
       caption = "Source: World Bank (WDI)") +
  theme_minimal()
