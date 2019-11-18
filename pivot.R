# Using R: From gather to pivot
# https://www.r-bloggers.com/using-r-from-gather-to-pivot/

rm(list=ls())
setwd("~/R/Crosstabulation")

library(reshape2)
fake_data <- data.frame(id = 1:20,
                        variable1 = runif(20, 0, 1),
                        variable2 = rnorm(20))
melted <- melt(fake_data, id.vars = "id")

library(tidyr)
melted <- gather(fake_data, variable, value, 2:3)

## Column names instead of indices
melted <- gather(fake_data, variable, value, variable1, variable2)

## Excluding instead of including
melted <- gather(fake_data, variable, value, -1)

## Excluding using column name
melted <- gather(fake_data, variable, value, -id)

long <- pivot_longer(fake_data, 2:3,
                     names_to = "variable",
                     values_to = "value")

wide <- pivot_wider(long,
                    names_from = "variable",
                    values_from = "value")

plot(wide)
