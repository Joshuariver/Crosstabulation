#
#

rm(list=ls())
setwd("~/R/Crosstabulation")

library(knitr)

head(airquality)

knitr::kable(head(airquality), caption = "New York Air Quality Measurements.")

#knitr::kable(head(airquality), caption = "New York Air Quality Measurements.")
print(head(airquality))

kable_if <- function(x, ...) if (interactive()) print(x, ...) else knitr::kable(x, ...)

kable_if(head(airquality), caption = "New York Air Quality Measurements.")

