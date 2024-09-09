# 필요한 패키지 설치 (아직 설치 안 되어 있으면 실행)
# install.packages(c("sf", "ggplot2", "rnaturalearth", "dplyr", "terra"))

# 필요한 패키지 로드 (Load Required Packages)
library(sf)               # 공간 데이터 처리용 (For spatial data handling)
library(ggplot2)          # 지도 그리기용 (For creating the map)
library(rnaturalearth)    # 국가 경계 데이터 다운로드용 (For downloading country boundaries)
library(dplyr)            # 데이터 처리용 (For data manipulation)
library(terra)            # 래스터 데이터 처리를 위한 패키지 (For raster data manipulation)

# 1. 지역 데이터 사용 예시 (Areal Data Example)
# 이 코드는 중동 국가들의 GDP 데이터를 시각화합니다.
# This code example maps GDP data of Middle Eastern countries.

# Step 1: 중동 국가의 지형 데이터 다운로드 (Download shapefile for Middle Eastern countries)
middle_east <- ne_countries(scale = "medium", returnclass = "sf") %>%
  filter(region_un == "Asia" & subregion == "Western Asia")  # 중동 국가 필터링 (Filtering Middle Eastern countries)

# Step 2: 중동 국가들의 예시 GDP 데이터 생성 (Create an example GDP dataset for Middle Eastern countries)
gdp_data <- data.frame(
  country = c("Saudi Arabia", "Iran", "Iraq", "Syria", "Jordan", "Lebanon", "Israel", "Yemen", "Oman", "United Arab Emirates"),
  GDP = c(700, 450, 250, 90, 45, 60, 380, 30, 110, 420)  # 예시 GDP 값 (GDP values in billions)
)

# Step 3: GDP 데이터와 지형 데이터 병합 (Merge GDP data with shapefile data)
middle_east_gdp <- middle_east %>%
  left_join(gdp_data, by = c("name" = "country"))

# Step 4: 중동 국가들의 GDP 분포 시각화 (Plot GDP distribution of Middle Eastern countries)
ggplot(data = middle_east_gdp) +
  geom_sf(aes(fill = GDP)) +  # GDP 값을 이용해 색상을 설정 (Filling map based on GDP values)
  scale_fill_viridis_c(option = "plasma", na.value = "grey50", guide = guide_colorbar(title = "GDP (in billions)")) +  # 색상 조정 (Adjusting color scale)
  theme_minimal() +  # 미니멀 테마 (Minimal theme for the plot)
  labs(title = "GDP Distribution in the Middle East", subtitle = "Fictional Data for Visualization") +  # 제목 및 서브타이틀 설정 (Setting title and subtitle)
  theme(plot.title = element_text(size = 18, face = "bold"), plot.subtitle = element_text(size = 14))

# 4. 중동 및 아프리카 국가의 GDP 시각화 (GDP Visualization for Middle Eastern and African Countries)
# 이 코드는 중동 및 아프리카 국가들의 GDP 데이터를 시각화합니다.
# This code visualizes the GDP of Middle Eastern and African countries.

# Step 1: 전 세계 국가 경계 데이터를 다운로드 (Download world country boundaries)
world <- ne_countries(scale = "medium", returnclass = "sf")

# Step 2: World Bank 지역 분류를 기반으로 중동 및 아프리카 국가 필터링
# Filter for Middle Eastern and African countries based on World Bank region classifications
mid_east_africa <- world %>%
  filter(region_wb %in% c("Middle East & North Africa", "Sub-Saharan Africa"))

# Step 3: 데이터셋에서 사용할 수 있는 컬럼 확인 (Check available columns in the dataset)
colnames(mid_east_africa)

# Step 4: GDP 데이터를 이용해 중동 및 아프리카 국가들의 GDP 분포를 시각화
# Visualize the GDP distribution using the 'gdp_md' column
ggplot(data = mid_east_africa) +
  geom_sf(aes(fill = gdp_md), color = "black") +  # GDP에 기반해 색상 채우기 (Fill color based on GDP)
  scale_fill_continuous(name = "GDP (in billions)", 
                        low = "lightyellow", high = "darkgreen", 
                        na.value = "grey50", labels = scales::comma_format(scale = 0.001)) +  # 단위를 백만에서 십억으로 변환 (Scale to billions)
  theme_minimal() +
  labs(title = "GDP Distribution in the Middle East and Africa",  # 지도 제목 (Map title)
       caption = "Source: Natural Earth (gdp_md field)") +  # 출처 표시 (Source caption)
  theme(legend.position = "right")  # 범례 위치 설정 (Legend position on the right)
# 2. 격자 데이터 사용 예시 (Lattice Data Example)
# 이 코드는 중동 지역의 임의 데이터를 격자 형태로 시각화합니다.
# This code demonstrates how to plot lattice (grid) data over the Middle East region.

# Step 1: 중동 지역의 격자 데이터 생성 (Create raster grid for the Middle East)
middle_east_grid <- rast(nrows = 15, ncols = 20, xmin = 25, xmax = 60, ymin = 10, ymax = 40)

# Step 2: 격자 셀에 임의의 값 할당 (Assign random values to grid cells, e.g., air quality or temperature)
values(middle_east_grid) <- runif(n = ncell(middle_east_grid), min = 50, max = 200)

# Step 3: 격자 데이터를 데이터 프레임으로 변환 (Convert the raster to a data frame for plotting)
middle_east_grid_df <- as.data.frame(middle_east_grid, xy = TRUE)

# Step 4: 중동 국가 경계 데이터 다운로드 (Download country boundaries for Middle East)
middle_east_countries <- ne_countries(scale = "medium", type = "countries", returnclass = "sf")

# Step 5: 격자 데이터를 지도에 시각화 (Plot lattice data on the map)
ggplot() +
  geom_tile(data = middle_east_grid_df, aes(x = x, y = y, fill = lyr.1), alpha = 0.8) +  # 격자 데이터 표시 (Displaying grid data)
  geom_sf(data = middle_east_countries, fill = NA, color = "black", size = 0.5) +  # 국가 경계 오버레이 (Overlay country boundaries)
  scale_fill_viridis_c(option = "inferno") +  # 색상 스케일 설정 (Set color scale)
  labs(title = "Middle East Air Quality (Example)", x = "Longitude", y = "Latitude", fill = "Air Quality") +  # 제목 설정 (Title and axis labels)
  theme_minimal() +
  coord_sf(xlim = c(25, 60), ylim = c(10, 40), expand = FALSE)

# 3. 점 데이터 사용 예시 (Point Data Example)
# 이 코드는 중동의 난민 캠프 위치를 시각화합니다.
# This code example maps the locations of refugee camps in the Middle East.

# Step 1: 중동 국가 경계 데이터 다운로드 (Download country boundaries for the Middle East)
middle_east_countries <- ne_countries(scale = "medium", type = "countries", returnclass = "sf")

# Step 2: 난민 캠프 위치 예시 데이터 생성 (Define example coordinates for refugee camps)
refugee_camps <- data.frame(
  longitude = c(36.6, 35.5, 39.8, 34.0, 37.9),
  latitude = c(32.0, 33.9, 36.2, 31.7, 36.7)
)

# Step 3: 난민 캠프 데이터를 sf 객체로 변환 (Convert refugee camps data to an sf object)
refugee_camps_sf <- st_as_sf(refugee_camps, coords = c("longitude", "latitude"), crs = 4326)

# Step 4: 난민 캠프 위치 지도 시각화 (Plot the refugee camp locations)
ggplot() +
  geom_sf(data = middle_east_countries, fill = NA, color = "black") +  # 국가 경계 표시 (Country borders)
  geom_sf(data = refugee_camps_sf, color = "red", size = 3, shape = 16) +  # 난민 캠프 위치 표시 (Refugee camp points)
  labs(title = "Refugee Camp Locations in the Middle East", x = "Longitude", y = "Latitude") +  # 제목 및 축 레이블 (Title and axis labels)
  theme_minimal() +
  coord_sf(xlim = c(25, 60), ylim = c(10, 40), expand = FALSE)  # 중동 지역 확대 설정 (Zoom into the Middle East region)

# 4. 기술 통계 및 중심 계산 (Descriptive Statistics and Center Calculations)
# 난민 캠프 좌표를 이용하여 중심 좌표 (평균 중심 및 중앙 중심)를 계산합니다.
# This section calculates the mean and median centers for refugee camps.

# Step 1: 난민 캠프 좌표 데이터 사용 (Use refugee camps coordinate data)
mean_center <- c(mean(refugee_camps$longitude), mean(refugee_camps$latitude))  # 평균 중심 (Mean center)
median_center <- c(median(refugee_camps$longitude), median(refugee_camps$latitude))  # 중앙 중심 (Median center)

# Step 2: 지도에 평균 및 중앙 중심 표시 (Plot the mean and median centers on the map)
ggplot() +
  geom_sf(data = middle_east_countries, fill = NA, color = "black") +  # 국가 경계 표시 (Country borders)
  geom_sf(data = refugee_camps_sf, color = "red", size = 3, shape = 16) +  # 난민 캠프 위치 표시 (Refugee camp points)
  geom_point(aes(x = mean_center[1], y = mean_center[2]), color = "blue", size = 4, shape = 4) +  # 평균 중심 표시 (Mean center)
  geom_point(aes(x = median_center[1], y = median_center[2]), color = "green", size = 4, shape = 8) +  # 중앙 중심 표시 (Median center)
  labs(title = "Refugee Camp Locations with Mean and Median Centers", x = "Longitude", y = "Latitude") +
  theme_minimal() +
  coord_sf(xlim = c(25, 60), ylim = c(10, 40), expand = FALSE)

# 5. 표준 거리 계산 (Standard Distance Calculation)
# 난민 캠프 좌표를 기준으로 표준 거리를 계산합니다.
# This function calculates the standard distance around the mean center.

# Step 1: 표준 거리 계산 함수 정의 (Define function to calculate standard distance)
standard_distance <- function(points, center) {
  sqrt(mean((points$longitude - center[1])^2 + (points$latitude - center[2])^2))
}

# Step 2: 표준 거리 계산 (Calculate standard distance)
std_distance <- standard_distance(refugee_camps, mean_center)
print(paste("Standard Distance from Mean Center:", round(std_distance, 2)))

# 6. 표준 거리 시각화 (Standard Distance Visualization)
# 난민 캠프 주변에 표준 거리 원을 그려 시각화합니다.
# Visualize the standard distance as a circle around the mean center.

# Step 1: 표준 거리 원 생성 함수 정의 (Define a function to create a circle representing standard distance)
create_circle <- function(center, radius, npoints = 100) {
  theta <- seq(0, 2 * pi, length.out = npoints)
  x <- center[1] + radius * cos(theta)
  y <- center[2] + radius * sin(theta)
  data.frame(x, y)
}

# Step 2: 표준 거리 원 데이터 생성 (Create circle data for plotting)
circle_data <- create_circle(mean_center, std_distance)

# Step 3: 난민 캠프 위치 및 표준 거리 원 시각화 (Plot refugee camps and the standard distance circle)
ggplot() +
  geom_point(data = refugee_camps, aes(x = longitude, y = latitude), color = "red", size = 3) +  # 난민 캠프 위치 (Refugee camp points)
  geom_point(aes(x = mean_center[1], y = mean_center[2]), color = "blue", size = 4, shape = 4) +  # 평균 중심 (Mean center)
  geom_path(data = circle_data, aes(x = x, y = y), color = "blue", linetype = "dashed") +  # 표준 거리 원 (Standard distance circle)
  labs(title = "Standard Distance Around Mean Center", x = "Longitude", y = "Latitude") +  # 제목 및 축 레이블 (Title and axis labels)
  theme_minimal()

# 7. 표준 편차 타원 시각화 (Standard Deviational Ellipse)
# 난민 캠프 위치의 표준 편차 타원을 계산하고 시각화합니다.
# This section calculates and visualizes the standard deviational ellipse.

# Step 1: 공분산 행렬 계산 (Calculate covariance matrix for the points)
cov_matrix <- cov(refugee_camps)

# Step 2: 고유값 및 고유벡터 계산 (Calculate eigenvalues and eigenvectors)
eigen_data <- eigen(cov_matrix)

# Step 3: 타원 데이터 생성 (Create ellipse data)
create_ellipse <- function(center, eigenvalues, eigenvectors, npoints = 100, scale = 2) {
  theta <- seq(0, 2 * pi, length.out = npoints)
  circle <- cbind(cos(theta), sin(theta))  # 단위 원 (Unit circle points)
  
  # 고유값 및 고유벡터를 사용해 타원 생성 (Create ellipse using eigenvalues and eigenvectors)
  ellipse <- t(eigenvectors %*% diag(eigenvalues * scale) %*% t(circle))
  
  # 중심 좌표에 맞게 이동 (Translate ellipse to center)
  ellipse <- sweep(ellipse, 2, center, "+")
  
  data.frame(x = ellipse[, 1], y = ellipse[, 2])
}

# Step 4: 타원 데이터 생성 (Generate ellipse data for plotting)
ellipse_points <- create_ellipse(mean_center, sqrt(eigen_data$values), eigen_data$vectors)

# Step 5: 난민 캠프 위치 및 표준 편차 타원 시각화 (Plot refugee camps and the standard deviational ellipse)
ggplot() +
  geom_point(data = refugee_camps, aes(x = longitude, y = latitude), color = "red", size = 3) +  # 난민 캠프 위치 (Refugee camp points)
  geom_point(aes(x = mean_center[1], y = mean_center[2]), color = "blue", size = 4, shape = 4) +  # 평균 중심 (Mean center)
  geom_path(data = ellipse_points, aes(x = x, y = y), color = "green", linetype = "dashed") +  # 표준 편차 타원 (Standard deviational ellipse)
  labs(title = "Standard Deviational Ellipse for Refugee Camps", x = "Longitude", y = "Latitude") +  # 제목 및 축 레이블 (Title and axis labels)
  theme_minimal()
