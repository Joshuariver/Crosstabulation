rm(list=ls())

library(readxl)
library(dplyr)
library(pivottabler)

df <- read_xlsx("data/2020년도_학교기본정보.xlsx")

df$시도교육청 <- as.factor(df$시도교육청)
df$지역교육청 <- as.factor(df$지역교육청)
df$지역 <- as.factor(df$지역)
df$설립구분 <- as.factor(df$설립구분)
df$설립유형 <- as.factor(df$설립유형)
df$학교특성 <- as.factor(df$학교특성)
df$`남녀공학 구분` <- as.factor(df$`남녀공학 구분`)


# 교육청별 남녀공학의 수

pt1 <- PivotTable$new()
pt1$addData(df)
pt1$addColumnDataGroups("남녀공학 구분")
pt1$addRowDataGroups("시도교육청")
pt1$defineCalculation(calculationName="지역별_남녀공학", summariseExpression="n()")
pt1$renderPivot()
pt1 <- pt1$asMatrix()

# 설립구분별 학교 수

pt2 <- PivotTable$new()
pt2$addData(df)
pt2$addRowDataGroups("설립구분")
pt2$defineCalculation(calculationName="설립구분별", summariseExpression="n()")
pt2$renderPivot()
pt2 <- pt2$asMatrix()


# 시도교육청별 학교특성별 학교 수

pt3 <- PivotTable$new()
pt3$addData(df)
pt3$addColumnDataGroups("학교특성")
pt3$addRowDataGroups("시도교육청")
pt3$defineCalculation(calculationName="지역별_남녀공학", summariseExpression="n()")
pt3$renderPivot()
pt3 <- pt3$asMatrix()




# 출력된 도표를 엑셀로 저장하기

library(openxlsx)

wb <- createWorkbook()
addWorksheet(wb, "pt1")
addWorksheet(wb, "pt2")

writeData(wb, "pt1", pt1, startRow = 1, startCol = 1)
writeData(wb, "pt2", pt2, startRow = 1, startCol = 1)

saveWorkbook(wb, file = "excel_test.xlsx", overwrite = TRUE)
