rm(list=ls())
setwd("~/R/Crosstabulation")

a <- read.csv("SAP 2017 R test3.csv")

# 데이터를 보고 편집할 수 있는 view
fix (a)

# 

head (a)



head (a, n=10)



tail (a, n=3)

# 변수의 명을 보여달라.

ls (a)


names (a)

# 전반적인 파일의 특성을 보기.

ls.str (a)


str (a)


# 케이스 갯수


dim (a)


nrow (a)
ncol (a)

# 데이터 성격, 변수 성격.

class (a)

sapply (a, class)

# 변수 항목에 따른 케이스 갯수

table(a$성별)


# 비타민 변수의 실측값을 제외한 변수

NROW(na.omit(a$비타민))

# 만일 논리적인 변수, TRUE/FALSE 값을 가진다면 아래와 같은 명령어를 입력한다.

sum(complete.cases(a$비타민))



# 산술평균 값. (나이)


mean(a$나이, na.rm = TRUE)

# 백분위수(percentile)

quantile(a$신장, c(0.2, 0.4, 0.6, 0.8), na.rm = TRUE) 

# 백분위수와 95백분위수, 10단위 백분위수 값 구하기

quantile(a$신장, c(0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.95), na.rm = TRUE)

# 요약값 보기

summary(a$신장)

# 합계
sum(a$신장, na.rm=TRUE)

# 표준편차
sd(a$신장, na.rm=TRUE)

# 분산
var (a$신장, na.rm=TRUE)



