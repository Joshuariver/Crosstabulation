## Pivotter 패키지를 활용하여 Pivot을 자유롭게 해 보기.

# Chapter 3.  계산 다루기

# Source:  http://www.pivottabler.org.uk/articles/v03-calculations.html
# Quick Example


rm(list=ls())


# 계산(Calculation)이란 숫자를 어떤 방식으로 분류하여 종합하는 것을 의미한다. 계산에는 사칙연산 이외에도 행렬 값을 사용하여 
# 합하거나, 평균을 구하거나, 중간값을 구하거나 하는 것을 모두 포함한다.
# Pivotter 에서 다루는 계산은 그러나 항상 Grouping한 변수를 어떻게 계산하는 가에 관련된 것이다.

# Pivotter 에서 다루는 계산의 유형은 아래와 같다.

# 
# 합산: Summarise values (dplyr summarise or data.table calculate expression)
# 다른 합산된 값에서 값을 추출함. Deriving values from other summarised values
# 자체 제작한 계산 공식 Custom calculation functions
# 계산 없이 값을 보여주기 Show a value (no calculation)

# 1. 기본적인 합산하기

# 이제까기 다룬 기본 표에는 단순한 데이터 관측값의 갯수 값을 합하였다.

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# Pivotter 패키지에서는 계산에 있어서 기본적으로 dplyr 의 summarise() 함수를 사용한다.

library(pivottabler)
library(dplyr)
library(lubridate)

# derive some additional data
trains <- mutate(bhmtrains,
                 ArrivalDelta=difftime(ActualArrival, GbttArrival, units="mins"),
                 ArrivalDelay=ifelse(ArrivalDelta<0, 0, ArrivalDelta))

# create the pivot table
pt <- PivotTable$new()
pt$addData(trains)
pt$addRowDataGroups("TOC", totalCaption="All TOCs")
pt$defineCalculation(calculationName="TotalTrains", caption="Total Trains",
                     summariseExpression="n()")
pt$defineCalculation(calculationName="MinArrivalDelay", caption="Min Arr. Delay",
                     summariseExpression="min(ArrivalDelay, na.rm=TRUE)")
pt$defineCalculation(calculationName="MaxArrivalDelay", caption="Max Arr. Delay",
                     summariseExpression="max(ArrivalDelay, na.rm=TRUE)")
pt$defineCalculation(calculationName="MeanArrivalDelay", caption="Mean Arr. Delay",
                     summariseExpression="mean(ArrivalDelay, na.rm=TRUE)", format="%.1f")
pt$defineCalculation(calculationName="MedianArrivalDelay", caption="Median Arr. Delay",
                     summariseExpression="median(ArrivalDelay, na.rm=TRUE)")
pt$defineCalculation(calculationName="IQRArrivalDelay", caption="Delay IQR",
                     summariseExpression="IQR(ArrivalDelay, na.rm=TRUE)")
pt$defineCalculation(calculationName="SDArrivalDelay", caption="Delay Std. Dev.",
                     summariseExpression="sd(ArrivalDelay, na.rm=TRUE)", format="%.1f")
pt$renderPivot()




# 2 다른 수치를 가져와서 계산에 포함시키기.

#  이미 계산이 되어 있는 다른 값을 활용하여 새로운 계산 값을 생성하여 표시하기는 다음 세 단계를 거쳐서 만들 수 있다.

# Specifying type="calculation",
# Specifying the names of the calculations which this calculation is based on in the basedOn argument.
# Specifying an expression for this calculation in the calculationExpression argument. 
# The values of the base calculations are accessed as elements of the values list.

# 예를 들어 전체 운행 기차 수 중 5분 연착한 기차의 비율을 표시하려면 아래와 같이 할 수 있다.



library(pivottabler)
library(dplyr)
library(lubridate)

# derive some additional data
trains <- mutate(bhmtrains,
                 ArrivalDelta=difftime(ActualArrival, GbttArrival, units="mins"),
                 ArrivalDelay=ifelse(ArrivalDelta<0, 0, ArrivalDelta),
                 DelayedByMoreThan5Minutes=ifelse(ArrivalDelay>5,1,0))

# create the pivot table
pt <- PivotTable$new()
pt$addData(trains)
pt$addRowDataGroups("TOC", totalCaption="All TOCs")
pt$defineCalculation(calculationName="DelayedTrains", caption="Trains Arr. 5+ Mins Late",
                     summariseExpression="sum(DelayedByMoreThan5Minutes, na.rm=TRUE)")
pt$defineCalculation(calculationName="TotalTrains", caption="Total Trains",
                     summariseExpression="n()")
pt$defineCalculation(calculationName="DelayedPercent", caption="% Trains Arr. 5+ Mins Late",
                     type="calculation", basedOn=c("DelayedTrains", "TotalTrains"),
                     format="%.1f %%",
                     calculationExpression="values$DelayedTrains/values$TotalTrains*100")
pt$renderPivot()


# 월별로 연착된 기차의 비율이 얼마나 되는가에 대한 값은 위의 표에서는 표현되지 않았다.  이를 표현하려면 아래와 같이
# 코드를 구성할 수 있다.

library(pivottabler)
library(dplyr)
library(lubridate)

# derive some additional data
trains <- mutate(bhmtrains,
                 GbttDateTime=if_else(is.na(GbttArrival), GbttDeparture, GbttArrival),
                 GbttMonth=make_date(year=year(GbttDateTime), month=month(GbttDateTime), day=1),
                 ArrivalDelta=difftime(ActualArrival, GbttArrival, units="mins"),
                 ArrivalDelay=ifelse(ArrivalDelta<0, 0, ArrivalDelta),
                 DelayedByMoreThan5Minutes=ifelse(ArrivalDelay>5,1,0))

# create the pivot table
pt <- PivotTable$new()
pt$addData(trains)
pt$addColumnDataGroups("GbttMonth", dataFormat=list(format="%B %Y"))
pt$addRowDataGroups("TOC", totalCaption="All TOCs")
pt$defineCalculation(calculationName="DelayedTrains", visible=FALSE,
                     summariseExpression="sum(DelayedByMoreThan5Minutes, na.rm=TRUE)")
pt$defineCalculation(calculationName="TotalTrains", visible=FALSE,
                     summariseExpression="n()")
pt$defineCalculation(calculationName="DelayedPercent", caption="% Trains Arr. 5+ Mins Late",
                     type="calculation", basedOn=c("DelayedTrains", "TotalTrains"),
                     format="%.1f %%",
                     calculationExpression="values$DelayedTrains/values$TotalTrains*100")
pt$renderPivot()



# 피벗 테이블 내에서 계산된 값의 위치를 옮기는 방법은 아래와 같다.

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="NumberOfTrains", caption="Number of Trains",
                     summariseExpression="n()")
pt$defineCalculation(calculationName="MaximumSpeedMPH", caption="Maximum Speed (MPH)",
                     summariseExpression="max(SchedSpeedMPH, na.rm=TRUE)")
pt$renderPivot()


# 계산된 값을 행으로 보여주기
# addRowCalculationGroups() 함수를 사용하면 행으로 보여주게 할 수 있다.

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="NumberOfTrains", caption="Number of Trains",
                     summariseExpression="n()")
pt$defineCalculation(calculationName="MaximumSpeedMPH", caption="Maximum Speed (MPH)",
                     summariseExpression="max(SchedSpeedMPH, na.rm=TRUE)")
pt$addRowCalculationGroups()
pt$renderPivot()


# 그룹 명 목록 상위에 계산 식을 구분하여 표시하고 싶다면 아래와 같이 할 수 있다.


library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$defineCalculation(calculationName="NumberOfTrains", caption="Number of Trains",
                     summariseExpression="n()")
pt$defineCalculation(calculationName="MaximumSpeedMPH", caption="Maximum Speed (MPH)",
                     summariseExpression="max(SchedSpeedMPH, na.rm=TRUE)")
pt$addColumnCalculationGroups()
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC")
pt$renderPivot()

# 유사하게 행으로 저장하는 방법을 쓸수 있다.

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$defineCalculation(calculationName="NumberOfTrains", caption="Number of Trains",
                     summariseExpression="n()")
pt$defineCalculation(calculationName="MaximumSpeedMPH", caption="Maximum Speed (MPH)",
                     summariseExpression="max(SchedSpeedMPH, na.rm=TRUE)")
pt$addRowCalculationGroups()
pt$addColumnDataGroups("PowerType")
pt$addRowDataGroups("TOC")
pt$renderPivot()


# 동일한 방식이지만 이번에는 출력 레이아웃을 활용하여 해 보면


library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$defineCalculation(calculationName="NumberOfTrains", caption="Number of Trains",
                     summariseExpression="n()")
pt$defineCalculation(calculationName="MaximumSpeedMPH", caption="Maximum Speed (MPH)",
                     summariseExpression="max(SchedSpeedMPH, na.rm=TRUE)")
pt$addRowCalculationGroups(outlineBefore=TRUE)
pt$addColumnDataGroups("PowerType")
pt$addRowDataGroups("TOC")
pt$renderPivot()



# 3. 데이터를 부분적으로 필터링해서 보여주기

# PivotFilters() 함수로 먼저 필터를 지정해 두고, 이것을 defineCalculation() 함수에서 filters 옵션에 지정하는 방법을 사용함.

library(dplyr)
library(lubridate)
library(pivottabler)

# get the date of each train and whether that date is a weekday or weekend
trains <- bhmtrains %>%
  mutate(GbttDateTime=if_else(is.na(GbttArrival), GbttDeparture, GbttArrival),
         DayNumber=wday(GbttDateTime),
         WeekdayOrWeekend=ifelse(DayNumber %in% c(1,7), "Weekend", "Weekday"))

# render the pivot table
pt <- PivotTable$new()
pt$addData(trains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC")
weekendFilter <- PivotFilters$new(pt, variableName="WeekdayOrWeekend", values="Weekend")
pt$defineCalculation(calculationName="WeekendTrains", summariseExpression="n()",
                     filters=weekendFilter, visible=FALSE)
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()", visible=FALSE)
pt$defineCalculation(calculationName="WeekendTrainsPercentage",
                     type="calculation", basedOn=c("WeekendTrains", "TotalTrains"),
                     format="%.1f %%",
                     calculationExpression="values$WeekendTrains/values$TotalTrains*100")
pt$renderPivot()



# % of Totals, Cumulative Sums, Running Differences, Rolling Averages, Ratios/Multiples 등을 계산식에 포함해보자자

# 예를 들어 가로행의 %와 그 합이다.

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="CountTrains", summariseExpression="n()",
                     caption="Count", visible=FALSE)
filterOverrides <- PivotFilterOverrides$new(pt, keepOnlyFiltersFor="TOC")
pt$defineCalculation(calculationName="TOCTotalTrains", filters=filterOverrides,
                     summariseExpression="n()", caption="TOC Total", visible=FALSE)
pt$defineCalculation(calculationName="PercentageOfTOCTrains", type="calculation",
                     basedOn=c("CountTrains", "TOCTotalTrains"),
                     calculationExpression="values$CountTrains/values$TOCTotalTrains*100",
                     format="%.1f %%", caption="% of TOC")
pt$renderPivot()




# 4. 계산 값을 포메팅 하여 보여주기.

# pivotter 에서 보여주는 값은 두 가지가 있다.  먼저 rawValue 는 계산된 결과인 원래 값으로서 numeric 속성을 가지고 있다.
# 그리고 외형적으로 보여주는 값으로서 formattedValue 가 있다.

# 이하에서는 formattedValue 옵션을 이용하여 보여주는 값을 변경하는 방법을 소개한다.

# rawValue 데이터의 종류에 따라 다른 방식으로 포멧을 조정할 수 있다.

# A number of different approaches to formatting are supported:
  
# If format is a text value, then pivottabler invokes base::sprintf() with the specified format.
# If format is a list, then pivottabler invokes base::format(), where the elements in the list become arguments in the function call.
# If format is an R function, then this is invoked for each value.
# If format is not specified, then base::as.character() is invoked to provide a default formatted value.

# base::sprintf() and base::format() 을 사용한 사례이다.

library(pivottabler)
library(dplyr)
library(lubridate)

# derive some additional data
trains <- mutate(bhmtrains,
                 ArrivalDelta=difftime(ActualArrival, GbttArrival, units="mins"),
                 ArrivalDelay=ifelse(ArrivalDelta<0, 0, ArrivalDelta))

# create the pivot table
pt <- PivotTable$new()
pt$addData(trains)
pt$addRowDataGroups("TOC", totalCaption="All TOCs")
pt$defineCalculation(calculationName="TotalTrains", caption="Total Trains",
                     summariseExpression="n()")
pt$defineCalculation(calculationName="MeanArrivalDelay1", caption="Mean Arr. Delay 1",
                     summariseExpression="mean(ArrivalDelay, na.rm=TRUE)",
                     format="%.2f")
pt$defineCalculation(calculationName="MeanArrivalDelay2", caption="Mean Arr. Delay 2",
                     summariseExpression="mean(ArrivalDelay, na.rm=TRUE)",
                     format=list(digits=2, nsmall=2))
pt$renderPivot()


# 어떤 나라에서는 천단위 구분자가 . 인 경우도 있고 , 인 경우도 있다.  이것은 pivotter 에서 표현할 수 있다.

library(pivottabler)

pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory", totalCaption="All Categories")
pt$addRowDataGroups("TOC", totalCaption="All TOCs")
pt$defineCalculation(calculationName="Value1", caption="Value 1",
                     summariseExpression="mean(SchedSpeedMPH, na.rm=TRUE)*33.33333",
                     format=list(digits=1, nsmall=0, big.mark=",", decimal.mark="."))
pt$defineCalculation(calculationName="Value2", caption="Value 2",
                     summariseExpression="sd(SchedSpeedMPH,na.rm=TRUE)*333.33333",
                     format=list(digits=1, nsmall=1, big.mark=",", decimal.mark="."))
pt$renderPivot()


# 또한 포멧은 R 내장 함수를 사용하여 사용자의 편의에 따라 조작하여 정할 수도 있다.


library(pivottabler)
library(dplyr)
library(lubridate)

# derive some additional data
trains <- mutate(bhmtrains,
                 ArrivalDelta=difftime(ActualArrival, GbttArrival, units="mins"),
                 ArrivalDelay=ifelse(ArrivalDelta<0, 0, ArrivalDelta))

# custom format function
fmtAddComment <- function(x) {
  formattedNumber <- sprintf("%.1f", x)
  comment <- "-"
  if (x < 2.95) comment <- "Below 3:  "
  else if ((2.95 <= x) && (x < 3.05)) comment <- "Equals 3:  "
  else if (x >= 3.05) comment <- "Over 3:  "
  return(paste0(comment, " ", formattedNumber))
}

# create the pivot table
pt <- PivotTable$new()
pt$addData(trains)
pt$addRowDataGroups("TOC", totalCaption="All TOCs")
pt$defineCalculation(calculationName="TotalTrains", caption="Total Trains",
                     summariseExpression="n()")
pt$defineCalculation(calculationName="MeanArrivalDelay1",
                     caption="Mean Arr. Delay 1",
                     summariseExpression="mean(ArrivalDelay, na.rm=TRUE)",
                     format="%.1f")
pt$defineCalculation(calculationName="MeanArrivalDelay2",
                     caption="Mean Arr. Delay 2",
                     summariseExpression="mean(ArrivalDelay, na.rm=TRUE)",
                     format=fmtAddComment)
pt$renderPivot()

# fmtFuncArgs명령을 사용함에 있어서 명령을 추가하여 새로운 포멧 기능을 만들 수 있다.
# 아래 예에서는 R base 를 활용하여 셀 값에 x 로 설정한 값을 보내준다.
# 아래 예에서는 소숫점 숫자를 fmtFuncaArgs 함수를 사용하여 지정하였다.


# Using the fmtFuncArgs argument it is also possible to pass additional arguments to a custom R function used for formatting. 
# When passing multiple arguments to the custom R function, the cell value is always passed to the custom function as x. 
# In the example below, the number of decimal places is specified using the fmtFuncArgs argument:


library(pivottabler)
library(dplyr)
library(lubridate)

# derive some additional data
trains <- mutate(bhmtrains,
                 ArrivalDelta=difftime(ActualArrival, GbttArrival, units="mins"),
                 ArrivalDelay=ifelse(ArrivalDelta<0, 0, ArrivalDelta))

# custom format function
fmtNumDP <- function(x, numDP) {
  formatCode <- paste0("%.", numDP, "f")
  formattedNumber <- sprintf(formatCode, x)
  return(formattedNumber)
}

# create the pivot table
pt <- PivotTable$new()
pt$addData(trains)
pt$addRowDataGroups("TOC", totalCaption="All TOCs")
pt$defineCalculation(calculationName="TotalTrains", caption="Total Trains",
                     summariseExpression="n()")

# define calculations
# note the use of the same custom format function (fmtNumDP) 
# but specifying different decimal places
pt$defineCalculation(calculationName="MeanArrivalDelay1", caption="Mean Arr. Delay 1",
                     summariseExpression="mean(ArrivalDelay, na.rm=TRUE)",
                     format=fmtNumDP, fmtFuncArgs=list(numDP=1))
pt$defineCalculation(calculationName="MeanArrivalDelay2", caption="Mean Arr. Delay 2",
                     summariseExpression="mean(ArrivalDelay, na.rm=TRUE)",
                     format=fmtNumDP, fmtFuncArgs=list(numDP=2))
pt$renderPivot()



# 5. 빈 셀 다루기

# 기본적으로 pivotter 는 빈 셀의 데이터는 어떤 값을 부여하지 않고, 공란으로 처리한다.
# 그러나 꼭 빈 공란에 0 값을 넣어야 할 경우에는 defineCalculation()함수 내에 noDataValue=0 으로 두면 된다.


library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()", noDataValue=0)
pt$renderPivot()




# 하나의 피벗 테일블 내에 복수 개의 데이터 포멧을 사용하는 사례이다.



library(pivottabler)
library(dplyr)

# derive some additional data
trains <- mutate(bhmtrains,
                 ArrivalDelta=difftime(ActualArrival, GbttArrival, units="mins"),
                 ArrivalDelay=ifelse(ArrivalDelta<0, 0, ArrivalDelta),
                 DelayedByMoreThan5Minutes=ifelse(ArrivalDelay>5,1,0)) %>%
  select(TrainCategory, TOC, DelayedByMoreThan5Minutes)
# in this example, bhmtraindisruption is joined to bhmtrains
# so that the TrainCategory and TOC columns are present in both
# data frames added to the pivot table
cancellations <- bhmtraindisruption %>%
  inner_join(bhmtrains, by="ServiceId") %>%
  mutate(CancelledInBirmingham=ifelse(LastCancellationLocation=="BHM",1,0)) %>%
  select(TrainCategory, TOC, CancelledInBirmingham)

# create the pivot table
pt <- PivotTable$new()
pt$addData(trains, "trains")
pt$addData(cancellations, "cancellations")
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="DelayedTrains", dataName="trains",
                     caption="Delayed",
                     summariseExpression="sum(DelayedByMoreThan5Minutes, na.rm=TRUE)")
pt$defineCalculation(calculationName="CancelledTrains", dataName="cancellations",
                     caption="Cancelled",
                     summariseExpression="sum(CancelledInBirmingham, na.rm=TRUE)")
pt$renderPivot()



# 6. 커스텀 계산 기능 함수들

#  커스텀 계산 기능 함수를 사용하면 더욱 다양한 계산 값을 보여줄 수 있다.
# 커스텀 계산 함수에는 다음과 같은 것들이 있는데,
# pivotCalculator is a helper object that offers various methods to assist in performing calculations,
# netFilters contains the definitions of the filter criteria coming from the row and column headers in the pivot table,
# calcFuncArgs is a list that specifies any additional arguments that need to be passed to the custom calculation function,
# format provides the formatting definition - this is the same value specified in the defineCalculation() call,
# fmtFuncArgs is a list that specifies any additional arguments that need to be passed to a custom format function (if used),
# baseValues provides access to the results of other calculations in the calculation group,
# cell provides access to more details about the individual cell that is being calculated.
# 

# 예를 들어 가장 성적이 나빴던 날의 데이터를 보여주고자 할 때에는 

# 1. For each date, calculate the percentage of trains more than five minutes late,
# 2. Sort this list (of dates and percentages) into descending order (by percentage of trains more than five minutes late),
# 3. Display the top percentage value from this list

library(pivottabler)
library(dplyr)
library(lubridate)

# derive some additional data
trains <- mutate(bhmtrains,
                 GbttDateTime=if_else(is.na(GbttArrival), GbttDeparture, GbttArrival),
                 GbttDate=make_date(year=year(GbttDateTime), month=month(GbttDateTime), day=day(GbttDateTime)),
                 GbttMonth=make_date(year=year(GbttDateTime), month=month(GbttDateTime), day=1),
                 ArrivalDelta=difftime(ActualArrival, GbttArrival, units="mins"),
                 ArrivalDelay=ifelse(ArrivalDelta<0, 0, ArrivalDelta),
                 DelayedByMoreThan5Minutes=ifelse(ArrivalDelay>5,1,0))

# custom calculation function
getWorstSingleDayPerformance <- function(pivotCalculator, netFilters, calcFuncArgs,
                                         format, fmtFuncArgs, baseValues, cell) {
  # get the data frame
  trains <- pivotCalculator$getDataFrame("trains")
  # apply the TOC and month filters coming from the headers in the pivot table
  filteredTrains <- pivotCalculator$getFilteredDataFrame(trains, netFilters)
  # calculate the percentage of trains more than five minutes late by date
  dateSummary <- filteredTrains %>%
    group_by(GbttDate) %>%
    summarise(DelayedPercent = sum(DelayedByMoreThan5Minutes, na.rm=TRUE) / n() * 100) %>%
    arrange(desc(DelayedPercent))
  # top value
  tv <- dateSummary$DelayedPercent[1]
  # build the return value
  value <- list()
  value$rawValue <- tv
  value$formattedValue <- pivotCalculator$formatValue(tv, format=format)
  return(value)
}

# create the pivot table
pt <- PivotTable$new()
pt$addData(trains, "trains")
pt$addColumnDataGroups("GbttMonth", dataFormat=list(format="%B %Y"))
pt$addRowDataGroups("TOC", totalCaption="All TOCs")
pt$defineCalculation(calculationName="WorstSingleDayDelay", format="%.1f %%",
                     type="function", calculationFunction=getWorstSingleDayPerformance)
pt$renderPivot()


# 커스텀 함수 기능으로 보다 더 많은 정보를 보여주게 할 수도 있다.
# 이 경우에는 월별로 가장 연착이 심했던 날이 며칠이었는지도 보여줄 수 있다.



library(pivottabler)
library(dplyr)
library(lubridate)

# derive some additional data
trains <- mutate(bhmtrains,
                 GbttDateTime=if_else(is.na(GbttArrival), GbttDeparture, GbttArrival),
                 GbttDate=make_date(year=year(GbttDateTime), month=month(GbttDateTime),
                                    day=day(GbttDateTime)),
                 GbttMonth=make_date(year=year(GbttDateTime), month=month(GbttDateTime), day=1),
                 ArrivalDelta=difftime(ActualArrival, GbttArrival, units="mins"),
                 ArrivalDelay=ifelse(ArrivalDelta<0, 0, ArrivalDelta),
                 DelayedByMoreThan5Minutes=ifelse(ArrivalDelay>5,1,0))

# custom calculation function
getWorstSingleDayPerformance <- function(pivotCalculator, netFilters, calcFuncArgs,
                                         format, fmtFuncArgs, baseValues, cell) {
  # get the data frame
  trains <- pivotCalculator$getDataFrame("trains")
  # apply the TOC and month filters coming from the headers in the pivot table
  filteredTrains <- pivotCalculator$getFilteredDataFrame(trains, netFilters)
  # calculate the percentage of trains more than five minutes late by date
  dateSummary <- filteredTrains %>%
    group_by(GbttDate) %>%
    summarise(DelayedPercent = sum(DelayedByMoreThan5Minutes, na.rm=TRUE) / n() * 100) %>%
    arrange(desc(DelayedPercent))
  # top value
  tv <- dateSummary$DelayedPercent[1]
  date <- dateSummary$GbttDate[1]             #     <<  CODE CHANGE  <<
  # build the return value
  value <- list()
  value$rawValue <- tv
  value$formattedValue <- paste0(format(      #     <<  CODE CHANGE (AND BELOW)  <<
    date, format="%a %d"), ":  ", pivotCalculator$formatValue(tv, format=format))
  return(value)
}

# create the pivot table
pt <- PivotTable$new()
pt$addData(trains, "trains")
pt$addColumnDataGroups("GbttMonth", dataFormat=list(format="%B %Y"))
pt$addRowDataGroups("TOC", totalCaption="All TOCs")
pt$defineCalculation(calculationName="WorstSingleDayDelay", format="%.1f %%",
                     type="function", calculationFunction=getWorstSingleDayPerformance)
pt$renderPivot()



# 같은 칸에 두 가지 정보를 동시에 넣는 것은 가독력이 부정적인 영향을 줄 수 있다.
# 커스텀 함수를 사용하여 추가 정보를 아래와 같이 단순화 하여 보여주게 할 수 있다.
# 

# It is possible to pass additional arguments as a list to a custom calculation function, as illustrated in the trivial example below.

library(pivottabler)

# custom calculation function
calcFunction <- function(pivotCalculator, netFilters, calcFuncArgs,
                         format, fmtFuncArgs, baseValues, cell) {
  
  # build the return value
  value <- list()
  value$rawValue <- calcFuncArgs$result
  value$formattedValue <- pivotCalculator$formatValue(calcFuncArgs$result, format=format)
  return(value)
}

# create the pivot table
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("PowerType")
pt$addRowDataGroups("TOC", totalCaption="All TOCs")
pt$defineCalculation(calculationName="calcA", caption="A", type="function",
                     calculationFunction=calcFunction, calcFuncArgs=list(result=1))
pt$defineCalculation(calculationName="calcB", caption="B", type="function",
                     calculationFunction=calcFunction, calcFuncArgs=list(result=2))
pt$renderPivot()


# 때로는 새로운 값을 추가하기 위해 새로 함수를 작성하는 것보다, 기존에 있는 함수를 재사용하여 값을 추가하는 것이 효율적일 수 있다.

library(pivottabler)
library(dplyr)
library(lubridate)

# derive some additional data
trains <- mutate(bhmtrains,
                 GbttDateTime=if_else(is.na(GbttArrival), GbttDeparture, GbttArrival),
                 GbttDate=make_date(year=year(GbttDateTime), month=month(GbttDateTime), day=day(GbttDateTime)),
                 GbttMonth=make_date(year=year(GbttDateTime), month=month(GbttDateTime), day=1),
                 ArrivalDelta=difftime(ActualArrival, GbttArrival, units="mins"),
                 ArrivalDelay=ifelse(ArrivalDelta<0, 0, ArrivalDelta),
                 DelayedByMoreThan5Minutes=ifelse(ArrivalDelay>5,1,0))

# custom calculation function
getWorstSingleDayPerformance <- function(pivotCalculator, netFilters, calcFuncArgs,
                                         format, fmtFuncArgs, baseValues, cell) {
  # get the data frame
  trains <- pivotCalculator$getDataFrame("trains")
  # apply the TOC and month filters coming from the headers in the pivot table
  filteredTrains <- pivotCalculator$getFilteredDataFrame(trains, netFilters)
  # calculate the percentage of trains more than five minutes late by date
  dateSummary <- filteredTrains %>%
    group_by(GbttDate) %>%
    summarise(DelayedPercent = sum(DelayedByMoreThan5Minutes, na.rm=TRUE) / n() * 100) %>%
    arrange(desc(DelayedPercent))
  # top value
  tv <- dateSummary$DelayedPercent[1]
  date <- dateSummary$GbttDate[1]
  if(calcFuncArgs$output=="day") {  #     <<  CODE CHANGES HERE  << 
    # build the return value
    value <- list()
    value$rawValue <- date
    value$formattedValue <- format(date, format="%a %d")
  }
  else if(calcFuncArgs$output=="performance") {  #     <<  CODE CHANGES HERE  << 
    # build the return value
    value <- list()
    value$rawValue <- tv
    value$formattedValue <- pivotCalculator$formatValue(tv, format=format)
  }
  return(value)
}

# create the pivot table
pt <- PivotTable$new()
pt$addData(trains, "trains")
pt$addColumnDataGroups("GbttMonth", dataFormat=list(format="%B %Y"))
pt$addRowDataGroups("TOC", totalCaption="All TOCs")
pt$defineCalculation(calculationName="WorstSingleDay", caption="Day",
                     format="%.1f %%", type="function",
                     calculationFunction=getWorstSingleDayPerformance,
                     calcFuncArgs=list(output="day"))
pt$defineCalculation(calculationName="WorstSingleDayPerf", caption="Perf",
                     format="%.1f %%", type="function",
                     calculationFunction=getWorstSingleDayPerformance,
                     calcFuncArgs=list(output="performance"))
pt$renderPivot()



# 계산 없이 값을 보여주기

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()

# 위와 같이 테이블 형태로 값을 보여주는 대신, R base 와 dplyr 의 기능만 사용하여 값을 나열하여 보여주게 할 수 있다.

library(pivottabler)

# perform the aggregation in R code explicitly
trains <- bhmtrains %>%
  group_by(TrainCategory, TOC) %>%
  summarise(NumberOfTrains=n()) %>%
  ungroup()

# a sample of the aggregated data
head(trains)

# 선행해서 trains 테이블 내에 미리 계산된 값을 보여주기만 하는 경우는 아래와 같다.

# display this pre-calculated data
pt <- PivotTable$new()
pt$addData(trains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", type="value", valueName="NumberOfTrains")
pt$renderPivot()


# trains 데이터에는 합산 값이 포함되어 있지 않으므로, 표시되지 않아 이 경우에는 공란으로 남는다.
# 보기 좋지 않기 때문에 합산 결과(Total) 값을 숨길 수 있다.


library(pivottabler)

# perform the aggregation in R code explicitly
trains <- bhmtrains %>%
  group_by(TrainCategory, TOC) %>%
  summarise(NumberOfTrains=n()) %>%
  ungroup()

# display this pre-calculated data
pt <- PivotTable$new()
pt$addData(trains)
pt$addColumnDataGroups("TrainCategory", addTotal=FALSE)   #  <<  *** CODE CHANGE ***  <<
pt$addRowDataGroups("TOC", addTotal=FALSE)                #  <<  *** CODE CHANGE ***  <<
pt$defineCalculation(calculationName="TotalTrains", type="value", valueName="NumberOfTrains")
pt$renderPivot()



# total 값을 추가하고 싶은데, 테이블에는 그 정보가 없기 대문에 테이블 외에 다른 곳에서 값을 읽어와서 보여줄 때


library(dplyr)
library(pivottabler)

# perform the aggregation in R code explicitly
trains <- bhmtrains %>%
  group_by(TrainCategory, TOC) %>%
  summarise(NumberOfTrains=n()) %>%
  ungroup()

# calculate the totals/aggregate values
trainsTrainCat <- bhmtrains %>%
  group_by(TrainCategory) %>%
  summarise(NumberOfTrains=n()) %>%
  ungroup()

trainsTOC <- bhmtrains %>%
  group_by(TOC) %>%
  summarise(NumberOfTrains=n()) %>%
  ungroup()

trainsTotal <- bhmtrains %>%
  summarise(NumberOfTrains=n())

# display this pre-calculated data
pt <- PivotTable$new()
pt$addData(trains)
pt$addTotalData(trainsTrainCat, variableNames="TrainCategory")
pt$addTotalData(trainsTOC, variableNames="TOC")
pt$addTotalData(trainsTotal, variableNames=NULL)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", type="value", valueName="NumberOfTrains")
pt$renderPivot()



# 혹은 Pivot 내부적으로 값을 계산하여 보여주게 할 때

library(pivottabler)

# perform the aggregation in R code explicitly
trains <- bhmtrains %>%
  group_by(TrainCategory, TOC) %>%
  summarise(NumberOfTrains=n()) %>%
  ungroup()

# display this pre-calculated data
pt <- PivotTable$new()
pt$addData(trains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains",  # <<  *** CODE CHANGE (AND BELOW) *** <<
                     type="value", valueName="NumberOfTrains",
                     summariseExpression="sum(NumberOfTrains)")
pt$renderPivot()



# 끝.




