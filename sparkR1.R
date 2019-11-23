# Using Spark from R for performance with arbitrary code - Part 1 - Spark SQL translation, 
# custom functions, and Arrow
#
# https://jozef.io/r201-spark-r-1/#setting-up-spark-with-r-and-sparklyr

rm(list=ls())

# install.packages("sparklyr")
# install.packages("nycflights13")
# sparklyr::spark_install(version = "2.4.3")


# Load packages
library(sparklyr)
library(dplyr)
library(nycflights13)

# Connect
sc <- sparklyr::spark_connect(master = "local")

# Copy the weather dataset to the instance
tbl_weather <- dplyr::copy_to(
  dest = sc, 
  df = nycflights13::weather,
  name = "weather",
  overwrite = TRUE
)

# Collect it back
tbl_weather %>% collect()


# An R function translated to Spark SQL
fun_implemented <- function(df, col) {
  df %>% mutate({{col}} := tolower({{col}}))
}

fun_implemented(nycflights13::weather, origin)
fun_implemented(tbl_weather, origin)


dbplyr::sql_render(
  fun_implemented(tbl_weather, origin)
)

# An R function not translated to Spark SQL
fun_r_only <- function(df, col) {
  df %>% mutate({{col}} := casefold({{col}}, upper = FALSE))
}

fun_r_only(nycflights13::weather, origin)
fun_r_only(tbl_weather, origin)


# A Hive built-in function not existing in R
fun_hive_builtin <- function(df, col) {
  df %>% mutate({{col}} := lower({{col}}))
}

fun_hive_builtin(tbl_weather, origin)

# fun_hive_builtin(nycflights13::weather, origin)
dbplyr::sql_render(fun_hive_builtin(tbl_weather, origin))

fun_r_custom <- function(tbl, colName) {
  tbl[[colName]] <- casefold(tbl[[colName]], upper = FALSE)
  tbl
}

spark_apply(tbl_weather, fun_r_custom, context = {colName <- "origin"})


mb = microbenchmark::microbenchmark(
  times = 10,
  hive_builtin = fun_hive_builtin(tbl_weather, origin) %>% collect(),
  translated_dplyr = fun_implemented(tbl_weather, origin) %>% collect(),
  spark_apply = spark_apply(tbl_weather, fun_r_custom, context = {colName <- "origin"}) %>% collect()
)

mb = microbenchmark::microbenchmark(
  times = 10, 
  setup = library(arrow),
  hive_builtin = fun_hive_builtin(tbl_weather, origin) %>% collect(),
  translated_dplyr = fun_implemented(tbl_weather, origin) %>% collect(),
  spark_apply_arrow = spark_apply(tbl_weather, fun_r_custom, context = {colName <- "origin"}) %>% collect()
)

