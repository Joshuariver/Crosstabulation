# https://www.r-bloggers.com/pivot-tables-and-medians-in-r/
# Pivot Tables and Medians in R

rm(list=ls())
setwd("~/R/Crosstabulation")



datafile = read.table(file.choose(), header= TRUE)

median_output <- tapply(as.numeric(datafile$score),  list(datafile$participant,  datafile$condition), median)

write.table(median_output, file.choose())