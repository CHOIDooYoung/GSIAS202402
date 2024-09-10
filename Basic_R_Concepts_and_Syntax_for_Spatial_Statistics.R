#Basic R Concepts and Syntax

# Variables and Assignment (변수와 할당)
# In R, variables are used to store data. You can assign values to variables 
# using the assignment operator <- or =. 
# This is a key concept because variables hold the data that you will work with.

# 변수에 값을 할당할 때는 <- 또는 = 를 사용합니다. 
# (To assign values to variables, we use <- or =)

x <- 10  # x라는 변수에 숫자 10을 저장합니다. (Store the number 10 in the variable 'x')
y <- 5   # y라는 변수에 숫자 5를 저장합니다. (Store the number 5 in the variable 'y')

# 변수의 값을 확인하려면 변수명을 입력하고 실행합니다.
# (To check the value of a variable, type its name and run the code.)

x  # x의 값 출력 (Print the value of x)
y  # y의 값 출력 (Print the value of y)

# x와 y의 합을 계산할 수도 있습니다.
# (We can also calculate the sum of x and y.)

z <- x + y  # x와 y의 합을 z에 저장합니다. (Store the sum of x and y in the variable 'z')
z  # z의 값 출력 (Print the value of z)


# Explanation (설명):
  
# Variables (변수): 변수를 사용하여 데이터를 저장합니다. 변수에 값을 할당하고, 이를 다양한 수학 연산에서 사용할 수 있습니다.
# Variables: You use variables to store data. Once data is stored, it can be used for various calculations.
# Assignment (할당): <-는 값을 변수에 할당하는 연산자입니다.
# Assignment: The <- symbol is used to assign values to variables.

# Basic Math Operations (기초 수학 연산)
# R can handle all basic arithmetic operations like addition, subtraction, 
# multiplication, and division.

# 기초적인 수학 연산을 R에서 할 수 있습니다.
# (Basic arithmetic operations can be performed in R.)

a <- 20  # 변수 a에 20 할당 (Assign 20 to variable a)
b <- 4   # 변수 b에 4 할당 (Assign 4 to variable b)

# 사칙연산 (Basic arithmetic)
sum <- a + b  # 덧셈 (Addition)
difference <- a - b  # 뺄셈 (Subtraction)
product <- a * b  # 곱셈 (Multiplication)
quotient <- a / b  # 나눗셈 (Division)

# 결과 출력 (Print the results)
sum  # 24
difference  # 16
product  # 80
quotient  # 5

# Explanation (설명):
  
# Arithmetic Operators (사칙연산자): +, -, *, /는 각각 덧셈, 뺄셈, 곱셈, 나눗셈 연산을 수행합니다.
# Operators: + for addition, - for subtraction, * for multiplication, and / for division.


# Data Types (데이터 타입)
# R supports various data types such as numbers, characters (text), and 
# logical (TRUE/FALSE) values. 
# It’s important to understand different data types since they determine 
# how data is stored and manipulated.

# R에서 사용할 수 있는 주요 데이터 타입은 숫자, 문자, 논리 값입니다.
# (The main data types in R are numbers, characters, and logical values.)

num_var <- 100  # 숫자형 데이터 (Numeric data)
char_var <- "Hello, R!"  # 문자형 데이터 (Character data)
logical_var <- TRUE  # 논리형 데이터 (Logical data)

# 데이터 타입 확인하기 (Check the data types)
class(num_var)  # "numeric"
class(char_var)  # "character"
class(logical_var)  # "logical"

# Explanation (설명):

# Numeric (숫자형): 숫자 데이터를 나타냅니다. 계산에 사용할 수 있습니다.
# Numeric: Represents numbers, which can be used in calculations.
# Character (문자형): 텍스트 데이터를 나타냅니다. 텍스트를 저장하거나 출력할 때 사용됩니다.
# Character: Represents text data, useful for storing or displaying text.
# Logical (논리형): TRUE 또는 FALSE 값을 가집니다. 논리 연산에서 사용됩니다.
# Logical: Represents TRUE or FALSE values, often used in logical comparisons.


# Vectors (벡터)
# A vector is a sequence of data elements of the same type. 
# It’s one of the most common data structures in R. 
# You can create vectors using the c() function.

# 벡터는 동일한 데이터 타입의 여러 값을 저장하는 데 사용됩니다.
# (Vectors are used to store multiple values of the same data type.)

num_vector <- c(10, 20, 30, 40)  # 숫자형 벡터 생성 (Create a numeric vector)
char_vector <- c("apple", "banana", "cherry")  # 문자형 벡터 생성 (Create a character vector)

# 벡터의 길이 확인 (Check the length of the vector)
length(num_vector)  # 4
length(char_vector)  # 3

# 벡터의 특정 요소에 접근 (Access elements in a vector)
num_vector[2]  # 두 번째 요소를 출력 (Print the second element, 20)
char_vector[1]  # 첫 번째 요소를 출력 (Print the first element, "apple")

# Explanation (설명):

# Vectors (벡터): 벡터는 동일한 타입의 여러 값을 저장하는 일련의 데이터입니다. 벡터는 c() 함수를 사용해 생성됩니다.
# Vectors: A vector stores a sequence of data elements of the same type. You can create them using the c() function.
# Indexing (인덱스 접근): 벡터의 특정 요소에 접근하려면 대괄호 []를 사용합니다.
# Indexing: To access a specific element in a vector, use square brackets [].

# Functions (함수)
# A function in R performs specific tasks. R has many built-in functions, 
# and you can also define your own.

# sum() 함수는 주어진 숫자들의 합을 계산합니다.
# (The sum() function calculates the sum of given numbers.)

result <- sum(c(5, 10, 15))  # 5 + 10 + 15 = 30
result  # 30

# 사용자 정의 함수 만들기 (Create a custom function)
add_numbers <- function(x, y) {
  return(x + y)  # x와 y의 합을 반환합니다. (Return the sum of x and y.)
}

# 사용자 정의 함수 호출하기 (Call the custom function)
add_numbers(8, 12)  # 20 출력 (Print 20)

# Data Frames (데이터 프레임)
# A data frame is a table-like data structure where each column contains values 
# of one variable, and each row contains one set of values from each column.

# 데이터 프레임은 R에서 가장 많이 사용되는 데이터 구조 중 하나입니다.
# (A data frame is one of the most commonly used data structures in R.)

# data.frame() 함수를 사용해 데이터 프레임을 생성합니다.
# (Create a data frame using the data.frame() function.)

students <- data.frame(
  name = c("Alice", "Bob", "Charlie"),  # 학생 이름 (Student names)
  age = c(23, 22, 24),  # 나이 (Ages)
  grade = c("A", "B", "A")  # 학점 (Grades)
)

# 데이터 프레임 출력 (Print the data frame)
print(students)

# 특정 열에 접근 (Accessing specific columns)
students$name  # 학생 이름 열 출력 (Print the "name" column)

# 특정 행에 접근 (Accessing specific rows)
students[1, ]  # 첫 번째 학생의 정보 출력 (Print information about the first student)

# Explanation (설명):

# Data Frame (데이터 프레임): 여러 변수(열)을 포함한 테이블 형식의 데이터 구조입니다. 각 열은 동일한 데이터 유형을 포함하고, 각 행은 특정 관측치를 나타냅니다.
# Data Frame: A table-like data structure that contains multiple variables (columns), with each column containing data of the same type and each row representing an observation.
# Accessing Columns and Rows (열과 행에 접근): 열은 $를 사용해 접근하고, 행은 대괄호 []를 사용해 접근할 수 있습니다.
# Accessing Columns and Rows: Use $ to access a column and [] to access rows.




# -------------------------
# Step 1: Load Required Libraries (필요한 패키지를 불러오기)
# -------------------------

# R에서 특정 기능을 사용하려면 그 기능을 제공하는 패키지를 먼저 불러와야 합니다.
# (To use specific functions in R, you need to load the package that provides those functions.)

# 설치되지 않은 패키지는 install.packages() 명령어를 통해 설치할 수 있습니다.
# (If the package is not installed, you can install it using install.packages())

# 예를 들어, ggplot2를 설치하려면: 
# (For example, to install ggplot2:)
# install.packages("ggplot2")

# 패키지를 설치한 후, 다음과 같이 불러옵니다. (After installation, load the package as follows:)
library(ggplot2)      # 그래프와 지도 그리기를 위한 패키지 (For creating plots and maps)
library(dplyr)        # 데이터 처리 및 변형을 위한 패키지 (For data manipulation and transformation)
library(sf)           # 공간 데이터(지리적 정보) 처리를 위한 패키지 (For handling spatial (geographic) data)
library(rnaturalearth)# 세계 경계 데이터를 다운로드하기 위한 패키지 (For downloading world boundary data)

# Explanation (설명):
# library()는 이미 설치된 패키지를 불러옵니다. 
# install.packages()는 아직 설치되지 않은 패키지를 설치할 때 사용됩니다.
# `library()` loads an already installed package.
# `install.packages()` installs a package that is not yet installed.

# -------------------------
# Step 2: Load and Explore a Simple Dataset (데이터셋 불러오기 및 탐색)
# -------------------------

# 국가 경계 데이터를 불러옵니다. 이 데이터는 세계의 국가 경계선을 포함하고 있습니다.
# (Download the world country boundary data. This data contains the country borders of the world.)

world_data <- ne_countries(scale = "medium", returnclass = "sf")
# 'sf' 객체는 공간 데이터를 처리할 수 있게 해주는 특수한 데이터 형식입니다.
# ('sf' objects are special data formats that allow for handling spatial data.)

# head() 함수는 데이터 프레임의 상위 몇 개 행을 보여줍니다.
# (The head() function displays the first few rows of the data frame.)

head(world_data)  # 데이터의 첫 6개의 행을 확인합니다. (View the first 6 rows of the data.)

# Explanation (설명):
# ne_countries() 함수는 세계의 국가 경계 데이터를 다운로드합니다.
# `ne_countries()` downloads the world’s country boundary data.
# sf 객체는 공간 데이터를 처리할 수 있는 특수한 형식으로, 지도 시각화에 자주 사용됩니다.
# The sf object is a special format for handling spatial information.
# head()는 데이터의 처음 몇 개 행을 확인하는 함수입니다.
# `head()` lets you inspect the first few rows of the dataset.

# -------------------------
# Step 3: Filter Countries by Continent (대륙별 국가 필터링)
# -------------------------

# filter() 함수는 특정 조건에 따라 데이터를 필터링하는 데 사용됩니다.
# (The filter() function is used to filter data based on specific conditions.)

# 여기서는 continent 열에서 값이 "Asia"인 국가만 필터링합니다.
# (Here, we filter countries where the continent column equals "Asia".)

asia_data <- world_data %>%
  filter(continent == "Asia")  # 대륙이 아시아인 국가만 선택합니다. (Select only countries on the continent of Asia.)

# head()로 필터링된 데이터를 확인합니다.
# (Check the filtered data using head().)
head(asia_data)

# Explanation (설명):
# filter()는 특정 조건을 만족하는 데이터만 남깁니다.
# `filter()` keeps only the data that meets specific conditions.
# %>% (파이프 연산자)는 데이터를 다음 함수로 전달하는 데 사용됩니다.
# The pipe operator %>% passes data from one function to another.

# -------------------------
# Practice 1: Filter and Explore Different Continent (연습 1: 다른 대륙 탐색하기)
# -------------------------

# 연습문제:
# 같은 방법으로 Africa 대륙을 필터링하고 그 결과를 head() 함수로 출력해 보세요.
# (Use the same method to filter Africa and print the result using the head() function.)

africa_data <- world_data %>%
  filter(continent == "Africa")

# 필터링된 아프리카 데이터를 확인합니다.
# (Check the filtered Africa data.)
head(africa_data)

# -------------------------
# Step 4: Create a Simple Plot (기본 지도 시각화)
# -------------------------

# ggplot() 함수는 시각화를 만들 때 기본으로 사용됩니다.
# (The ggplot() function is the core function used to create visualizations.)

# geom_sf() 함수는 공간 데이터를 시각화하는 데 사용됩니다.
# (The geom_sf() function is used to plot spatial data.)

ggplot(data = asia_data) +  # 데이터를 ggplot으로 전달합니다. (Pass the data to ggplot.)
  geom_sf(fill = "lightblue", color = "black") +  # 국경을 검은색으로 그리고 내부를 파란색으로 채웁니다. (Draw borders in black and fill the map with light blue.)
  labs(title = "Map of Asia") +  # 지도에 제목을 추가합니다. (Add a title to the map.)
  theme_minimal()  # 간단한 테마 적용 (Apply a minimal theme.)

# Explanation (설명):
# ggplot()는 R에서 시각화를 만드는 기본 함수입니다.
# `ggplot()` is the core function for creating visualizations.
# geom_sf()는 공간 데이터를 시각화하는 함수입니다.
# `geom_sf()` is used to visualize spatial data.

# -------------------------
# Practice 2: Plot Africa (연습 2: 아프리카 지도 그리기)
# -------------------------

# 연습문제:
# 방금 필터링한 아프리카 데이터를 이용해 아프리카 대륙의 지도를 그려보세요.
# (Use the filtered Africa data to plot the map of the African continent.)

ggplot(data = africa_data) + 
  geom_sf(fill = "lightgreen", color = "black") +  # 지도의 색상과 경계선을 설정합니다. (Set the map’s fill color and borders.)
  labs(title = "Map of Africa") +  # 제목 추가 (Add a title.)
  theme_minimal()  # 미니멀 테마 적용 (Apply a minimal theme.)

# -------------------------
# Step 5: Basic Data Manipulation (기초 데이터 처리)
# -------------------------

# data.frame() 함수로 새로운 데이터 프레임을 생성합니다.
# (Use data.frame() to create a new data frame.)

population_data <- data.frame(
  country = c("China", "India", "Japan", "South Korea", "Indonesia"),  # 국가명 (Country names)
  population_millions = c(1440, 1380, 126, 52, 273)  # 인구 데이터 (Population data in millions)
)

# left_join() 함수로 국가 데이터와 인구 데이터를 결합합니다.
# (Merge the country data with the population data using left_join().)

asia_population <- asia_data %>%
  left_join(population_data, by = c("name" = "country"))
# 'name' 열과 'country' 열을 기준으로 데이터를 병합합니다.
# (Merge the datasets based on the 'name' column in Asia data and the 'country' column in the population data.)

# 결합된 데이터를 확인합니다. (Check the merged data.)
head(asia_population)

# Explanation (설명):
# data.frame()은 데이터를 표 형태로 저장합니다.
# `data.frame()` stores data in a table format.
# left_join()는 두 데이터 프레임을 결합하는 함수입니다.
# `left_join()` merges two data frames based on specified columns.

# -------------------------
# Step 6: Plot Data with Color Based on Population (인구에 기반한 색상 지도 시각화)
# -------------------------

# 인구에 따라 지도 색상을 채우는 시각화를 생성합니다.
# (Create a plot where the color is filled based on population data.)

ggplot(data = asia_population) +
  geom_sf(aes(fill = population_millions), color = "black") +  # 인구 수에 따라 색상 채우기 (Fill based on population.)
  scale_fill_viridis_c(option = "plasma", na.value = "grey") +  # 색상 스케일 적용 (Apply a color scale.)
  labs(title = "Population in Asia", fill = "Population (millions)") +  # 제목과 범례 추가 (Add title and legend.)
  theme_minimal()  # 미니멀 테마 적용 (Apply a minimal theme.)

# Explanation (설명):
# aes()는 시각적 요소에 변수를 연결할 때 사용됩니다.
# `aes()` maps variables to visual elements in the plot.
# scale_fill_viridis_c()는 연속적인 값에 따른 색상을 설정하는 함수입니다.
# `scale_fill_viridis_c()` sets colors based on continuous values.

# -------------------------
# Extended Practice for Newcomers and Advanced Students (추가 연습)
# -------------------------

# Practice 3:
# Filter South American countries and plot the map, adding an imaginary dataset (e.g., GDP).
# 연습 3: 남미 국가를 필터링하고 GDP 같은 가상의 데이터를 추가하여 지도를 그려보세요.

# Practice 4:
# Explore the dataset further by plotting countries and changing the color scheme, adding different map themes.
# 연습 4: 다양한 색상과 테마를 사용하여 지도를 더욱 다채롭게 표현해보세요.
