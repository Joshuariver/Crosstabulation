# Using Spark from R for performance with arbitrary code ??? Part 4 ??? 
# Using the lower-level invoke API to manipulate Spark???s Java objects from R
# https://www.r-bloggers.com/using-spark-from-r-for-performance-with-arbitrary-code-part-4-using-the-lower-level-invoke-api-to-manipulate-sparks-java-objects-from-r/

# 

# Load packages
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

# The invoke() API of sparklyr

# Get the count of rows
tbl_flights %>% spark_dataframe() %>%
  invoke("count")

tbl_flights_summary <- tbl_flights %>% spark_dataframe() %>%
  invoke("describe", as.list(colnames(tbl_flights))) %>%
  sdf_register()
tbl_flights_summary

sparklyr::sdf_describe

tbl_flights %>% spark_dataframe() %>%
  invoke("select", "origin", list()) %>%
  collect()

tbl_flights %>% spark_dataframe() %>%
  invoke("schema")

sc %>% spark_context() %>%
  invoke("uiWebUrl") %>%
  invoke("toString")

tbl_flights %>%
  group_by(origin) %>%
  summarise(avg(dep_delay))

# flights.
# groupBy("origin").
# agg(avg("dep_delay"))

tbl_flights %>%
  spark_dataframe() %>%
  invoke("groupBy", "origin", list()) %>%
  invoke("agg", invoke_static(sc, "org.apache.spark.sql.functions", "expr", "avg(dep_delay)"), list()) %>%
  sdf_register()

# Wrapping the invocations into R functions

agg_expr <- function(tbl, exprs) {
  sparklyr::invoke_static(
    tbl[["src"]][["con"]],
    "org.apache.spark.sql.functions",
    "expr",
    exprs
  )
}


grpagg_invoke <- function(tbl, colName, groupColName, aggOperation) {
  avgColumn <- tbl %>% agg_expr(paste0(aggOperation, "(", colName, ")"))
  tbl %>%  spark_dataframe() %>% 
    invoke("groupBy", groupColName, list()) %>%
    invoke("agg", avgColumn, list()) %>% 
    sdf_register()
}


tbl_flights %>% 
  grpagg_invoke("arr_delay", groupColName = "origin", aggOperation = "avg")


# Reconstructing variable normalization

normalize_invoke <- function(tbl, colName) {
  sdf <- tbl %>% spark_dataframe()
  stdCol <- agg_expr(tbl, paste0("stddev_samp(", colName, ")"))
  avgCol <- agg_expr(tbl, paste0("avg(", colName, ")"))
  avgTemp <- sdf %>% invoke("agg", avgCol, list()) %>% invoke("first")
  stdTemp <- sdf %>% invoke("agg", stdCol, list()) %>% invoke("first")
  newCol <- sdf %>%
    invoke("col", colName) %>%
    invoke("minus", as.numeric(avgTemp)) %>%
    invoke("divide", as.numeric(stdTemp))
  sdf %>%
    invoke("withColumn", colName, newCol) %>%
    sdf_register()
}

tbl_weather %>% normalize_invoke("temp")


# Where invoke can be better than dplyr translation or SQL

