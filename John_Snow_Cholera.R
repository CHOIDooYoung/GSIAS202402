# 필요한 패키지 불러오기
# Load necessary packages
library(cholera)
library(leaflet)

# 1. 콜레라 사례 및 펌프 데이터 로드
# Load cholera cases and pump data
fatalities <- cholera::fatalities
pumps <- cholera::pumps

# 2. 사례 데이터에 위도와 경도 추가
# Adding longitude and latitude columns to fatalities and pumps
fatalities$long <- fatalities$lon
fatalities$lat <- fatalities$lat
pumps$long <- pumps$lon
pumps$lat <- pumps$lat

# 3. Leaflet을 사용하여 콜레라 사례와 펌프 위치 시각화
# Visualizing cholera cases and pump locations using Leaflet
leaflet() %>%
  addTiles() %>%
  # 콜레라 사례 위치 (빨간색으로 표시)
  # Adding cholera cases (marked in red)
  addCircleMarkers(data = fatalities, 
                   ~long, ~lat, 
                   color = 'red', 
                   popup = ~as.character(case), 
                   radius = 5,
                   group = "Fatalities") %>%
  # 펌프 위치 (파란색으로 표시)
  # Adding pump locations (marked in blue)
  addCircleMarkers(data = pumps, 
                   ~long, ~lat, 
                   color = 'blue', 
                   popup = ~as.character(id), 
                   radius = 8,
                   group = "Pumps") %>%
  # 레이어 컨트롤 추가 (Fatalities 및 Pumps 그룹)
  # Adding layer control (groups: Fatalities and Pumps)
  addLayersControl(overlayGroups = c("Fatalities", "Pumps"),
                   options = layersControlOptions(collapsed = FALSE))
