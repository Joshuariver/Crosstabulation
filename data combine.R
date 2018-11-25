rm(list=ls())
setwd("~/R/Crosstabulation")

# a <- read.csv("SAP 2017 R test3.csv")


# install.packages ("googledrive")
# 파일 구글 드라이브에서 불러와서 합치기

library (googledrive)

k <- tempfile(fileext = ".csv")
drive_download(as_id("1NViPZQ7DCpKdGa03D3UWH-ZZW-v9eZOr"), path = k, overwrite = TRUE)
a<- read.csv (k, sep = ",")

k <- tempfile(fileext = ".csv")
drive_download(as_id("1ncBaCrJwcoten8h60oCeWHGzARruFCIh"), path = k, overwrite = TRUE)
b<- read.csv (k, sep = ",")

# 확인 - 변수 이름

names (a)
names (b)

# 확인 - 케이스 갯수

nrow (a)
nrow (b)


# 두개의 파일을 'ID' 기준으로 변수를 통합하라.

x <- merge (a, b, by = "ID", all = TRUE)


library (gmodels)

#확인 : x 라는 이름의 데이터 객체에서 변수와 케이스가 통합된 것을 확인한다.

names (x)
nrow (x)


# 두개의 파일을 순서대로 통합하라.
# 결과 : 이 명령어는 두개의 파일을 순서대로 통합한 것이다. 변수명이 중복되는 ID는 두번째에 ID.1로 변수명이 바뀐 것을 알 수 있다.

c <-data.frame (a, b)
head (c)


# 케이스 값 - 단순 변경


head (a)
library (car)


a$Gender <- recode (a$Gender, "1='boy'")

a$Gender <- recode (a$Gender, "1='boy'; 2='girl'")


# 케이스 값 - 조건 변경
# 해석: a 라는 이름의 데이터 객체의 BMI_zs 라는 변수 중($) -1.63에서 가장 낮은 값(lo)까지(:)를 
# underweight로 바꾸라 (recode). 이후 이를 a 라는 이름의 데이터 객체의 BMI_zs 라는 변수에 저장하라(<-).

a$BMI_zs <- recode(a$BMI_zs, "lo:-1.63='underweight'")

# 케이스 값 - 복잡한 조건 변경

a$BMI_zs <- recode(a$BMI_zs,
                   + "lo:-1.63='underweight';
                   + -1.63:1.03='healthy';
                   + 1.03:1.63='overweigt';
                   + 1.63:hi='obesity';
                   + else='NA'")


a$BMI_zs <- recode(a$BMI_zs, "lo:-1.63='underweight'; -1.63:1.03='healthy'; 1.03:1.63='overweigt'; 1.63:hi='obesity'; else='NA'")





