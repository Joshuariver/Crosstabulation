# Using Spark from R for performance with arbitrary code ??? Part 2 
# ??? Constructing functions by piping dplyr verbs
# https://www.r-bloggers.com/using-spark-from-r-for-performance-with-arbitrary-code-part-2-constructing-functions-by-piping-dplyr-verbs/

# Load packages

rm(list=ls())

suppressPackageStartupMessages({
  library(sparklyr)
  library(dplyr)
  library(nycflights13)
})

# Prepare the data
weather <- nycflights13::weather %>%
  mutate(id = 1L:nrow(nycflights13::weather)) %>% 
  select(id, everything())

# Connect
sc <- sparklyr::spark_connect(master = "local")

# Copy the weather dataset to the instance
tbl_weather <- dplyr::copy_to(
  dest = sc, 
  df = weather,
  name = "weather",
  overwrite = TRUE
)

# Copy the flights dataset to the instance
tbl_flights <- dplyr::copy_to(
  dest = sc, 
  df = nycflights13::flights,
  name = "flights",
  overwrite = TRUE
)

normalize_dplyr_scale <- function(df, col, newColName) {
  df %>% mutate(!!newColName := scale({{col}}))
}

weather %>%
  normalize_dplyr_scale(temp, "normTemp") %>%
  select(id, temp, normTemp)

tbl_weather %>%
  normalize_dplyr_scale(temp, "normTemp") %>%
  select(id, temp, normTemp)


normalize_dplyr <- function(df, col, newColName) {
  df %>% mutate(
    !!newColName := ({{col}} - mean({{col}}, na.rm = TRUE)) /
      sd({{col}}, na.rm = TRUE)
  )
}


# Local data frame
weather %>%
  normalize_dplyr(temp, "normTemp") %>%
  select(id, temp, normTemp)

# Spark DataFrame
tbl_weather %>%
  normalize_dplyr(temp, "normTemp") %>%
  select(id, temp, normTemp) %>% 
  collect()

tbl_weather %>%
  normalize_dplyr(temp, "normTemp") %>%
  dplyr::explain()

tbl_weather %>%
  normalize_dplyr(temp, "normTemp") %>%
  dbplyr::sql_render() %>%
  unclass()

# A more complex use case ??? Joins, group bys, and aggregations

joingrpagg_dplyr <- function(
  df1, df2, 
  joinColNames = intersect(colnames(df1), colnames(df2)),
  col, groupCol
) {
  df1 %>%
    right_join(df2, by = joinColNames) %>%
    group_by({{groupCol}}) %>%
    summarise(mean({{col}})) %>% 
    arrange({{groupCol}})
}


delay_by_visib <- joingrpagg_dplyr(
  tbl_flights, tbl_weather,
  col = arr_delay, groupCol = visib
)
delay_by_visib %>% collect()

delay_by_visib %>% dplyr::explain()


# Using the functions with local versus remote datasets

bycols <-  c("year", "month", "day", "origin", "hour", "time_hour")

# Look at count of rows of Inner join of the Spark data frames 
tbl_flights %>% inner_join(tbl_weather, by = bycols) %>% count()

# Look at count of rows of Inner join of the local data frames 
flights %>% inner_join(weather, by = bycols) %>% count()


# Create (lazy) left joins
joined_spark <- tbl_flights %>% left_join(tbl_weather, by = bycols) %>% collect()
joined_local <- flights %>% left_join(weather, by = bycols)

# Look at counts of NA values
joined_local %>% filter(is.na(temp)) %>% count()


joined_spark %>% filter(is.na(temp)) %>% count()

# Look at counts of NaN values
joined_local %>% filter(is.nan(temp)) %>% count()

joined_spark %>% filter(is.nan(temp)) %>% count()

# Note the time_hour values are different
weather %>% select(id, time_hour)

tbl_weather %>% select(id, time_hour)

