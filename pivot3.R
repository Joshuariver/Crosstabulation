# Good riddance to Excel pivot tables
# https://www.r-bloggers.com/good-riddance-to-excel-pivot-tables/

rm(list=ls())
setwd("~/R/Crosstabulation")



################ Good riddance to pivot tables ############
library(reshape2)
library(reshape)
library(plyr)
library(ggplot2)

dataset <- data.frame(var1 = rep(c("a","b","c","d","e","f"), each = 4), 
                      var2 = rep(c("level1","level1","level2","level2"), 6), 
                      var3 = rep(c("h","m"), 12), meas = rep(1:12))

# simply pivot table
cast(dataset, var1 ~ var2 + var3)

# mean by var1 and var2
cast(dataset, var1 ~ var2, mean)

# mean by var1 and var3
cast(dataset, var1 ~ var3, mean)

# mean by var1, var2 and var3 (version 1)
cast(dataset, var1 ~ var2 + var3, mean)

# mean by var1, var2 and var3 (version 2)
cast(dataset, var1 + var2 ~ var3, mean)

# use package plyr to create flexible data frames...
dataset_plyr <- ddply(dataset, .(var1, var2), summarise, 
                      mean = mean(meas), 
                      se = sd(meas),
                      CV = sd(meas)/mean(meas)
) 

# ...to use for plotting
qplot(var1, mean, colour = var2, size = CV, data = dataset_plyr, geom = "point")                      

