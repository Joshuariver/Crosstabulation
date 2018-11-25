rm(list=ls())
setwd("~/R/Crosstabulation")


# pearson 교차분석

CrossTable (c$Gender, c$평생천식여부, chisq=TRUE, format=c("SPSS"))


# 코딩 확장

CrossTable (c$Gender, c$평생천식여부, chisq=TRUE, expected= TRUE, fisher=TRUE, format=c("SPSS"))

