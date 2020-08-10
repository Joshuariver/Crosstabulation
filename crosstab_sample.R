# Cross Tabulation Analysis in R sample code

rm(list=ls())

ID <- seq(1:177)
Age <- sample(c("0-15", "16-29", "30-44", "45-64", "65+"), 177, replace = TRUE)
Sex <- sample(c("Male", "Female"), 177, replace = TRUE)
Country <- sample(c("England", "Wales", "Scotland", "N. Ireland"), 177, replace = TRUE)
Health <- sample(c("Poor", "Average", "Good"), 177, replace = TRUE)
Survey <- data.frame(Age, Sex, Country, Health)
head(Survey)

# Load function
source("http://pcwww.liv.ac.uk/~william/R/crosstab.r")

# Frequency count
crosstab(Survey, row.vars = "Age", col.vars = "Sex", type = "f")

# Row percentages
crosstab(Survey, row.vars = "Age", col.vars = "Sex", type = "r")

# Column percentages
crosstab(Survey, row.vars = "Age", col.vars = "Sex", type = "c")

# Joint percentages (sums to 100 within final two table dimensions)
crosstab(Survey, row.vars = c("Age", "Sex"), col.vars = "Health", type = "j")

# Total percentages (sums to 100 across entire table)
crosstab(Survey, row.vars = c("Age", "Sex"), col.vars = "Health", type = "t")

# All margins...
crosstab(Survey, row.vars = c("Age", "Sex"), col.vars = "Health", type = "f")  #By default addmargins=TRUE

# No margins...
crosstab(Survey, row.vars = c("Age", "Sex"), col.vars = "Health", type = "f", 
         addmargins = FALSE)

# Grand margins only...
crosstab(Survey, row.vars = c("Age", "Sex"), col.vars = "Health", type = "f", 
         subtotals = FALSE)

# Calculate proportions rather than percentages...
crosstab(Survey, row.vars = "Age", col.vars = "Sex", type = "t", percentages = FALSE)

# Round output to 1 decimal place...
crosstab(Survey, row.vars = "Age", col.vars = "Sex", type = "t", percentages = FALSE, 
         dec.places = 1)

# Create a table with two row and two column variables
crosstab(Survey, row.vars = c("Age", "Sex"), col.vars = c("Health", "Country"), 
         type = "f", addmargins = FALSE)

# Create a table with three row and one column variable
crosstab(Survey, row.vars = c("Age", "Sex", "Health"), col.vars = c("Country"), 
         type = "f", addmargins = FALSE)

crosstab(Survey, row.vars = c("Age", "Sex"), col.vars = c("Health", "Country"), 
         type = "f", subtotals = FALSE)
