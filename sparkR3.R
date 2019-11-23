# Using Spark from R for performance with arbitrary code ??? Part 3 
# ??? Using R to construct SQL queries and let Spark execute them
# https://www.r-bloggers.com/using-spark-from-r-for-performance-with-arbitrary-code-part-3-using-r-to-construct-sql-queries-and-let-spark-execute-them/

# Load packages
suppressPackageStartupMessages({
  library(sparklyr)
  library(dplyr)
  library(nycflights13)
})

rm(list=ls())

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


# R functions as Spark SQL generators

normalize_sql <- function(df, colName, newColName) {
  paste0(
    "SELECT",
    "\n  ", df, ".*", ",",
    "\n  (", colName, " - (SELECT avg(", colName, ") FROM ", df, "))",
    " / ",
    "(SELECT stddev_samp(", colName,") FROM ", df, ") as ", newColName,
    "\n", "FROM ", df
  )
}

normalize_temp_query <- normalize_sql("weather", "temp", "normTemp")
cat(normalize_temp_query)


# Executing the generated queries via Spark
# Using DBI as the interface

res <- DBI::dbGetQuery(sc, statement = normalize_temp_query)
head(res)


# Invoking sql on a Spark session object

# Use the query "lazily" without execution:
normalized_lazy_ds <- sc %>%
  spark_session() %>%
  invoke("sql",  normalize_temp_query)
normalized_lazy_ds

# Collect when needed:
normalized_lazy_ds %>% collect()

# Using tbl with dbplyr???s sql

# Nothing is executed yet
normalized_lazy_tbl <- normalize_temp_query %>%
  dbplyr::sql() %>%
  tbl(sc, .)

# Print the first few rows
normalized_lazy_tbl




