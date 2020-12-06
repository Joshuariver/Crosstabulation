## Pivotter 패키지를 활용하여 Pivot을 자유롭게 해 보기.

# Chapter 2.  Data Group 다루기

# Source:  http://www.pivottabler.org.uk/articles/v02-datagroups.html
# Quick Example


rm(list=ls())

# Data Group 은 행과 열의 제목에 의해 표현될 수 있는 데이터의 집합

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addColumnDataGroups("PowerType")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# Pivot Table 에 Data Group 을 추가하는 방법

# 열이건 행이건 Data Group 을 추가하면 모집단에 존재하는 데이터 값들만 추가하게 된다.
# 예를 들어 위의 표를 보면 행에서 "Express Passenger"의 하부 행으로 DMU, EMU, HST 가 모두 존재하지만,
# "Ordinary Passenger" 의 하부 행에는 DMU 와 EMU 만 있다. 이것은 "Ordinary Passenger"행에는 HST 행에 해당하는 값이 존재하지
# 않기 때문이다.

# 만약 이를 무시하고, 값의 존재여부를 떠나서 표를 만들려고 하면 어떻게 해야 할까?
#  아래의 "onlyCombinationsThatExist=FALSE" 옵션을 원하는 값이 있는 행 정의문에 추가하면 된다.

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addColumnDataGroups("PowerType", onlyCombinationsThatExist=FALSE)
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# 추가할 데이터 그룹의 값을 지정할 수도 있다.
# 아래 PowerType 행을 추가하는 명령에 fromData=FALSE, explicitListOfValues=list("DMU", "EMU") 를 추가하는 방식으로
# 원하는 행만 추가할 수 있다.

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addColumnDataGroups("PowerType", fromData=FALSE, explicitListOfValues=list("DMU", "EMU"))
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# Visual Total 기능
# 위의 표를 보면 CrossCountry 의 DMU(22133) + EMU(0) 의 Total 이 22865 로 되어 있는데, 이는 합이 맞지 않다.
# 그 이유는 이 표에서 숨겨진 HST(732)의 값까지 포함한 Total 이기 때문이다.  이 경우 Total 값을 현재 화면에 보이는 값만을
# Total 한 값을 보여주기 원할 수 있는데, 이 경우에는 어떻게 해야 할까?

# 원하는 부분합을 넣을 행 선언문에 visualTotals=TRUE 을 추가하면 된다.

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addColumnDataGroups("PowerType", fromData=FALSE,
                       explicitListOfValues=list("DMU", "EMU"), visualTotals=TRUE)
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# 복수의의 데이터 그룹을 하나로 합쳐서 보여주기 (Adding data groups that combine values)

# 때로는 보여주고자 하는 핵심적인 내용이 "London Midland"  사와 "Cross Country" 사의 운행현황이고, "Arriva Trains" 사와
# "Wales Virgin Train" 사의 정보는 참조만 하는 내용이라 그냥 합쳐서 보여주고 싶을 경우가 있다. 이 경우에는 
# addRowDataGroups 명령으로 행을 추가 할 때, 행을 데이터에서 바로 가져오는 기본 옵션을 끄고 'fromData=FALSE,'
# 원하는 형태의 행을 list() 합수로 추가하여 보여줄 수 있다.

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addColumnDataGroups("PowerType")
pt$addRowDataGroups("TOC", fromData=FALSE, explicitListOfValues=list(
  "London Midland", "CrossCountry", c("Arriva Trains Wales", "Virgin Trains")))
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()

# list() 함수 대신 c() 합수를 써서 아래와 같이 "Other"라는 대표 행이름으로 보여주게 할 수도 있다.

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addColumnDataGroups("PowerType")
pt$addRowDataGroups("TOC", fromData=FALSE, explicitListOfValues=list(
  "London Midland", "CrossCountry", "Other"=c("Arriva Trains Wales", "Virgin Trains")))
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()



# 더욱 복잡한 데이터 행의 정의 방식

# 각 행의 명칭이 나타내는 값을 더욱 명확히 하기 위해서 행과 열이름에 추가적인 캡션을 넣고 싶을 경우가 있다.
# 예를 들어 TOC(Train Operating Company), TC(Train Category), PT(Power Type)등의 글을 제목 앞에 추가로 넣고싶은 경우
# 아래와 같이 caption() 합수를 사용하여 할 수 있다.

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory", caption="TC:  {value}")
pt$addColumnDataGroups("PowerType", caption="PT:  {value}")
pt$addRowDataGroups("TOC", caption="TOC:  {value}")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()



# 지금까지는 표제어는 모두 요인(Factor)인 Character들이었는데, 경우에 따라서는 Number 나 Date 같은 Character 이외의
# 데이터를 표제어로 포함시켜야 할 때도 있다.  이 경우에는 사전에 표제어로 사용할 데이터를 정리해야 한다.
# 아래는 날짜를 표제어로 사용한 사례이다.

# derive the date of each train (from the arrival/dep times),
# then the month of each train from the date of each train
library(dplyr)
library(lubridate)
library(pivottabler)
trains <- mutate(bhmtrains,
                 GbttDate=if_else(is.na(GbttArrival), GbttDeparture, GbttArrival),
                 GbttMonth=make_date(year=year(GbttDate), month=month(GbttDate), day=1))

pt <- PivotTable$new()
pt$addData(trains)
pt$addColumnDataGroups("GbttMonth")
pt$addColumnDataGroups("PowerType")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# 위의 사례에서는 월을 기준으로 포멧이 만들어지만 날짜까지 기재되었다.
# 월을 중심으로 정리하면 아래와 같이 된다  addColumnDataGroups() 함수에 .dataFormat 옵션 사용하였다.


# derive the date of each train (from the arrival/dep times),
# then the month of each train from the date of each train
library(dplyr)
library(lubridate)
library(pivottabler)
trains <- mutate(bhmtrains,
                 GbttDate=if_else(is.na(GbttArrival), GbttDeparture, GbttArrival),
                 GbttMonth=make_date(year=year(GbttDate), month=month(GbttDate), day=1))

pt <- PivotTable$new()
pt$addData(trains)
pt$addColumnDataGroups("GbttMonth", dataFormat=list(format="%B %Y"))
pt$addColumnDataGroups("PowerType")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()



# 숫자를 표시하는 데 있어서 또 다른 접근방식도 가능하다.


# If the dataFormat is a text value, then pivottabler invokes base::sprintf() with the specified format.
# If the dataFormat is a list, then pivottabler invokes base::format(), where the elements in the list 
# become arguments in the function call.
# The example above is equivalent to: base::format(value, format="%B %Y")
# If the dataFormat is an R function, then this is invoked for each value.
# If dataFormat is not specified, then base::as.character() is invoked to provide a default formatted value.



# derive the date of each train (from the arrival/dep times), then derive
# the month of each train from the date of each train
library(dplyr)
library(lubridate)
library(pivottabler)
trains <- mutate(bhmtrains,
                 GbttDate=if_else(is.na(GbttArrival), GbttDeparture, GbttArrival),
                 GbttMonth=make_date(year=year(GbttDate), month=month(GbttDate), day=1))

# define a custom formatting function
formatDate <- function(x) {
  base::format(x, format="%B %Y")
}

pt <- PivotTable$new()
pt$addData(trains)
pt$addColumnDataGroups("GbttMonth", dataFormat=formatDate)
pt$addColumnDataGroups("PowerType")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# dataFmtFuncArgs 옵션을 사용한 커스텀 포멧도 가능하다.

# derive the date of each train (from the arrival/dep times), then derive
# the month of each train from the date of each train
library(dplyr)
library(lubridate)
library(pivottabler)
trains <- mutate(bhmtrains,
                 GbttDate=if_else(is.na(GbttArrival), GbttDeparture, GbttArrival),
                 GbttMonth=make_date(year=year(GbttDate), month=month(GbttDate), day=1))

# define a custom formatting function
formatDate <- function(x, formatCode) {
  base::format(x, format=formatCode)
}

pt <- PivotTable$new()
pt$addData(trains)
pt$addColumnDataGroups("GbttMonth",
                       dataFormat=formatDate, dataFmtFuncArgs=list(formatCode="%B %Y"))
pt$addColumnDataGroups("PowerType")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# 데이터 그룹 정렬 (Sorting) 하기.
# 데이터의 정렬은 기본적으로 오름차순으로 정렬된다.  아래 사례를 보자.
# Arriva Trains Wales 가 A로 시작하므로 먼저 나왔고, Virgin Trains 가 V로 시작하므로 알파벳 순서에 따라 정렬되었다.


library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addColumnDataGroups("PowerType")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()

# 정렬순서를 역으로 하려면 어떻게 해야 하는가?  dataSortOrder 옵션의 변수를 내림차순으로 지정해 주면 된다. (desc 사용)

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addColumnDataGroups("PowerType")
pt$addRowDataGroups("TOC", dataSortOrder="desc")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# 정렬순서는 또한 dataSortOrder 와 customSortOrder옵션을 사용하여 조정할 수 있다.

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addColumnDataGroups("PowerType")
pt$addRowDataGroups("TOC", dataSortOrder="custom",
                    customSortOrder=c("London Midland", "Arriva Trains Wales",
                                      "Virgin Trains", "CrossCountry"))
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# 정렬순서를 최종 합산된 값을 기준으로 오름차순 혹은 내림차순으로 정리해야 할 경우도 있다.
# 이 때는 어느 행으로 기준으로 정렬해야 하는가에 따라서 sortColumnDataGroups 혹은 sortRowDataGroups 함수를 사용하여 할 수 있다.

# By the data group value - using orderBy="value",
# By the data group caption (e.g. if formatting has been applied) - using orderBy="caption",
# By the result of a calculation - the default, or set explicitly using orderBy="calculation",
# By the data group value with a custom sort order - using orderBy="customByValue" and specifying customOrder,
# By the data group caption with a custom sort order - using orderBy="customByCaption" and specifying customOrder.



library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addColumnDataGroups("PowerType")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$sortRowDataGroups(levelNumber=1, orderBy="calculation", sortOrder="desc")
pt$renderPivot()


# 가로행의 데이터를 기준으로 정렬하는 예를 들어보자.
# 한가지 행 기준으로만 정렬을 하려면 위와 같이 하면 되지만, 한 가지 이상의 기준으로 정렬을 하기위해서는 
# levelNumber 옵션을 추가하여 조정할 수 있다.

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addColumnDataGroups("PowerType")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$sortColumnDataGroups(levelNumber=2, orderBy="calculation", sortOrder="desc")
pt$renderPivot()


# 이러한 방법으로 Pivot 테이블을 완전히 다시 설계할 필요 없이 함수를 추가하여 간단하게 정렬을 변경할 수 있다.
# customOrder 옵션을 사용해서 완전히 원하는 방식으로 정렬을 하게 할 수도 있다.

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$sortRowDataGroups(levelNumber=1, orderBy="customByValue", sortOrder="asc",
                     customOrder=c("Arriva Trains Wales", "London Midland",
                                   "CrossCountry", "Virgin Trains"))
pt$renderPivot()


# header 옵션을 사용해서 더욱 표준적인 도표처럼 만들 수도 있다.


library(dplyr)
library(lubridate)
library(pivottabler)
trains <- mutate(bhmtrains,
                 GbttDate=if_else(is.na(GbttArrival), GbttDeparture, GbttArrival),
                 GbttMonth=make_date(year=year(GbttDate), month=month(GbttDate), day=1))
trains <- filter(trains, GbttMonth>=make_date(year=2017, month=1, day=1))

pt <- PivotTable$new()
pt$addData(trains)
pt$addColumnDataGroups("GbttMonth", dataFormat=list(format="%B %Y"))
pt$addColumnDataGroups("PowerType")
pt$addRowDataGroups("TOC", header="Train Company")
pt$addRowDataGroups("TrainCategory", header="Train Category")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot(showRowGroupHeaders=TRUE)


# 또한 표제열 내 중간 합도 addTotal 옵션을 FALSE 시켜서 보이지 않게 할 수 있다.


# derive the date of each train (from the arrival/dep times),
# then the month of each train from the date of each train
library(dplyr)
library(lubridate)
library(pivottabler)
trains <- mutate(bhmtrains,
                 GbttDate=if_else(is.na(GbttArrival), GbttDeparture, GbttArrival),
                 GbttMonth=make_date(year=year(GbttDate), month=month(GbttDate), day=1))
trains <- filter(trains, GbttMonth>=make_date(year=2017, month=1, day=1))

pt <- PivotTable$new()
pt$addData(trains)
pt$addColumnDataGroups("GbttMonth", dataFormat=list(format="%B %Y"))
pt$addColumnDataGroups("PowerType")
pt$addRowDataGroups("TOC", header="Train Company", addTotal=FALSE)
pt$addRowDataGroups("TrainCategory", header="Train Category", addTotal=FALSE)
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$theme <- getStandardTableTheme(pt)
pt$renderPivot(showRowGroupHeaders=TRUE)



