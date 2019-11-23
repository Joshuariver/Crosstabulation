# Manipulating Data Frames Using sqldf ??? A Brief Overview
# https://www.r-bloggers.com/manipulating-data-frames-using-sqldf-a-brief-overview/


rm(list=ls())
setwd("~/R/SQL/SQL practice")

crashes <- read.csv("crashes.csv")
roads <- read.csv("roads.csv")

head(crashes)
tail(crashes)
print(roads)

join_string <- "select
                crashes.*
              , roads.District
              , roads.Length
              from crashes
                left join roads
                on crashes.Road = roads.Road"

library(sqldf)

crashes_join_roads <- sqldf(join_string,stringsAsFactors = FALSE)

## Loading required package: tcltk

head(crashes_join_roads)
tail(crashes_join_roads)


join_string2 <- "select
                crashes.*
              , roads.District
              , roads.Length
              from crashes
                inner join roads
                on crashes.Road = roads.Road"

crashes_join_roads2 <- sqldf(join_string2,stringsAsFactors = FALSE)

head(crashes_join_roads2)
tail(crashes_join_roads2)

# The merge statement in base R can perform the equivalent of inner and left joins, 
# as well as right and full outer joins, which are unavailable in sqldf.

crashes_merge_roads <- merge(crashes, roads, by = c("Road"))
head(crashes_merge_roads)
tail(crashes_merge_roads)

crashes_merge_roads2 <- merge(crashes, roads, by = c("Road"), all.x = TRUE)
head(crashes_merge_roads2)
tail(crashes_merge_roads2)

crashes_merge_roads3 <- merge(crashes, roads, by = c("Road"), all.y = TRUE)
head(crashes_merge_roads3)
tail(crashes_merge_roads3)

crashes_merge_roads4 <- merge(crashes, roads, by = c("Road"), all.x = TRUE, 
                              all.y = TRUE)
head(crashes_merge_roads4)


join_string2 <- "select
                crashes.*
              , roads.District
              , roads.Length
                from crashes
                    inner join roads
                    on crashes.Road = roads.Road
                where crashes.Road = 'US-40'"                
crashes_join_roads4 <- sqldf(join_string2,stringsAsFactors = FALSE)
head(crashes_join_roads4)
tail(crashes_join_roads4)


# Aggregation Functions and Limitations of sqldf

group_string <- "select
                  crashes.Road
                 , avg(crashes.N_Crashes) as Mean_Crashes
                 from crashes
                    left join roads
                    on crashes.Road = roads.Road
                 group by 1"
sqldf(group_string)


library(plyr)

ddply(crashes_merge_roads,
      c("Road"),
      function(X) data.frame(Mean_Crashes = mean(X$N_Crashes),
                             Q1_Crashes = quantile(X$N_Crashes, 0.25),
                             Q3_Crashes = quantile(X$N_Crashes, 0.75),
                             Median_Crashes = quantile(X$N_Crashes, 0.50))
)

