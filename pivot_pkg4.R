## Pivotter 패키지를 활용하여 Pivot을 자유롭게 해 보기.

# Chapter 4.  일반적인 출력 (Regular Output)

# Source:  http://www.pivottabler.org.uk/articles/v04-regularlayout.html
# Quick Example


rm(list=ls())


# 이 장에서는 pivotter 가 지원하는 표준적인 두 가지 형태의 산출물을 보여줌.

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addColumnDataGroups("PowerType")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# 테뷸러(Tabluar) 형태의 Output

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC")
pt$addRowDataGroups("PowerType")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# 외곽선(Outline) 형태의 Output

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC", outlineBefore=TRUE)    # Change
pt$addRowDataGroups("PowerType")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# 외곽선 형태의 Output 은 옵션을 변경시킴에 따라 여러가지 형태로 출력할 수 있다.

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC", outlineBefore=TRUE, outlineAfter=TRUE)
pt$addRowDataGroups("PowerType")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()



# mergeSpace 옵션을 사용하여 칸을 합치거나 분리하기

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC", outlineBefore=list(mergeSpace="doNotMerge"))
pt$addRowDataGroups("PowerType")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()



# dataGroup 만 칸을 합치기

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC", outlineBefore=list(mergeSpace="dataGroupsOnly"))
pt$addRowDataGroups("PowerType")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# Cell 만 칸을 합치기

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC", outlineBefore=list(mergeSpace="cellsOnly"))
pt$addRowDataGroups("PowerType")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# dataGroupsAndCellsAs2  데이터그룹과 셀을 둘로 칸을 분리하기
# This specifies that the row headings should be merged into one combined row heading and that 
# the cells should be merged into one cell. This is the default used when outlineBefore=TRUE is specified.


library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC", outlineBefore=list(mergeSpace="dataGroupsAndCellsAs2"))
pt$addRowDataGroups("PowerType")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# dataGroupsAndCellsAs1   데이터그룹과 셀을 하나로 합치기
# 

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC", outlineBefore=list(mergeSpace="dataGroupsAndCellsAs1"))
pt$addRowDataGroups("PowerType")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()



# The isEmpty Setting  
# 보통 열행의 큰제목 우측 칸은 위 표에서 본 것과 같이 공란으로 남는다. 그것은 숨겨진 isEmpty 의 기본 값이 TRUE이기 때문인데,
# 이 옵션을 변경함으로서  소계를 보여주도록 세팅을 하는 것이 가능하다.

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC",
                    outlineBefore=list(isEmpty=FALSE, mergeSpace="dataGroupsOnly"))
pt$addRowDataGroups("PowerType", addTotal=FALSE)
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()

# outlineTotal 옵션은 맨 아래 최종 Total 값은 bold 체로 바꿔주도록 하는 옵션이다.


library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC",
                    outlineBefore=list(isEmpty=FALSE, mergeSpace="dataGroupsOnly"),
                    outlineTotal=TRUE)
pt$addRowDataGroups("PowerType", addTotal=FALSE)
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# The caption Setting
# 캡션 세팅 옵션은 행의 큰제목에 기재될 내용을 조정할 수 있는 옵션이다.
# 위의 예에서 큰 제목은 원래 단순히 철도회사의 이름만 나오는 것이지만, outlineBefore=list(caption= 에서 보여줄 값을 
# 설정함으로서 최종 표에서 보여주는 큰제목의 내용을 변경할 수 있다.


library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC",
                    outlineBefore=list(caption="TOC:  {value}"))
pt$addRowDataGroups("PowerType")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# The groupStyleName and groupStyleDeclarations Settings
# groupStyleName 과 groupStyleDeclarations 옵션을 변경하여 표제어의 색상이나 스타일을 변경할 수 있다.


library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC",
                    outlineBefore=list(groupStyleDeclarations=list(color="blue")))
pt$addRowDataGroups("PowerType")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# The cellStyleName and cellStyleDeclarations Settings
# cellStyleName 과 cellStyleDeclarations 옵션을 변경하여 셀의 색상을 변경할 수 있다.

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC",
                    outlineBefore=list(mergeSpace="doNotMerge",
                                       cellStyleDeclarations=list("background-color"="lightskyblue")))
pt$addRowDataGroups("PowerType")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()



# 표제어 아웃라인을 복합적으로 구성하기


library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC",
                    outlineBefore=list(groupStyleDeclarations=list(color="blue")),
                    outlineAfter=list(isEmpty=FALSE,
                                      mergeSpace="dataGroupsOnly",
                                      caption="Total ({value})",
                                      groupStyleDeclarations=list("font-style"="italic")),
                    outlineTotal=list(groupStyleDeclarations=list(color="blue"),
                                      cellStyleDeclarations=list("color"="blue")))
pt$addRowDataGroups("PowerType", addTotal=FALSE)
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# 다계층형 피벗 테이블의 표제어를 모두 달리 구성하기

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC",
                    outlineBefore=list(isEmpty=FALSE,
                                       mergeSpace="dataGroupsOnly",
                                       groupStyleDeclarations=list(color="blue"),
                                       cellStyleDeclarations=list(color="blue")),
                    outlineTotal=list(groupStyleDeclarations=list(color="blue"),
                                      cellStyleDeclarations=list(color="blue")))
pt$addRowDataGroups("PowerType",
                    addTotal=FALSE,
                    outlineBefore=list(isEmpty=FALSE, mergeSpace="dataGroupsOnly"))
pt$addRowDataGroups("Status", addTotal=FALSE)
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()



# 일부 변경된 포멧으로 보여주기기

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC",
                    outlineBefore=list(isEmpty=FALSE,
                                       mergeSpace="dataGroupsOnly",
                                       groupStyleDeclarations=list(color="blue")),
                    outlineTotal=list(groupStyleDeclarations=list(color="blue")))
pt$addRowDataGroups("PowerType", addTotal=FALSE)
pt$addRowDataGroups("Status")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()


# 가로행 합산을 보여주기

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


# 표제어 디자인 변경하기

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$defineCalculation(calculationName="NumberOfTrains", caption="Number of Trains",
                     summariseExpression="n()")
pt$defineCalculation(calculationName="MaximumSpeedMPH", caption="Maximum Speed (MPH)",
                     summariseExpression="max(SchedSpeedMPH, na.rm=TRUE)")
pt$addColumnDataGroups("PowerType")
pt$addRowCalculationGroups(outlineBefore=list(isEmpty=FALSE, mergeSpace="dataGroupsOnly",
                                              groupStyleDeclarations=list(color="blue"),
                                              cellStyleDeclarations=list(color="blue")))
pt$addRowDataGroups("TOC", addTotal=FALSE)
pt$renderPivot()


# 복잡하고 심도깊은 피벗테이블 포멧 구성하기

df <- data.frame(
  Level1 = rep("Net entrepreneurial income", times=12),
  Level2 = c(rep("Net operating surplus", 9), rep("Interests and rents", 3)),
  Level3 = c(rep("Factor income", 8),"Compensation of employees","Paid rent",
             "Paid interest","Received interest"),
  Level4 = c(rep("Net value added", 6), rep("Taxes and subsidies", 2), rep(NA, 4)),
  Level5 = c(rep("Gross value added", 5),"Depreciation","Other taxes on production",
             "Other subsidies (non-product specific)", rep(NA, 4)),
  Level6 = c(rep("Production of the agricultural industry", 4),
             "Intermediate services", rep(NA, 7)),
  Level7 = c("Crop production","Livestock production",
             "Production of agricultural services","Other production", rep(NA, 8)),
  MaxGroupLevel = c(7,7,7,7,6,5,5,5,3,3,3,3),
  Budget2019 = c(4150.39,4739.2,625.6,325.8,-6427,-2049.3,
                 -145.4,2847.3,-1149,-221.2,-307.6,12.8),
  Actual2019 = c(3978.8,4341.1,603.7,343,-6063.9,-2079.6,
                 -136.8,2578.6,-1092.9,-203.3,-327.6,14.1),
  Budget2020 = c(4210.9,4857.7,676.6,405.8,-6299,-2086.7,
                 -145.4,2920.6,-1245,-236.5,-244.7,10.1),
  Actual2020 = c(4373.7,5307.6,693.9,408.2,-7065.3,-1985,
                 -154.2,3063,-1229.3,-268.2,-250.3,11.1)
)

# settings related to outline groups
ob <- list(isEmpty=FALSE, nocgApplyOutlineStyling=FALSE,
           nocgGroupStyleDeclarations=list("font-weight"="normal"))

library(pivottabler)
pt <- PivotTable$new()
pt$setDefault(addTotal=FALSE, outlineBefore=ob)
pt$addData(df)
pt$addRowDataGroups("Level1", outlineBefore=TRUE,
                    onlyAddOutlineChildGroupIf="MaxGroupLevel>1")
pt$addRowDataGroups("Level2", outlineBefore=TRUE,
                    onlyAddOutlineChildGroupIf="MaxGroupLevel>2",
                    dataSortOrder="custom",
                    customSortOrder=c("Net operating surplus", "Interests and rents"))
pt$addRowDataGroups("Level3", outlineBefore=TRUE,
                    onlyAddOutlineChildGroupIf="MaxGroupLevel>3",
                    dataSortOrder="custom",
                    customSortOrder=c("Factor income", "Compensation of employees",
                                      "Paid rent", "Paid interest", "Received interest"))
pt$addRowDataGroups("Level4", outlineBefore=TRUE,
                    onlyAddOutlineChildGroupIf="MaxGroupLevel>4")
pt$addRowDataGroups("Level5", outlineBefore=TRUE,
                    onlyAddOutlineChildGroupIf="MaxGroupLevel>5",
                    dataSortOrder="custom",
                    customSortOrder=c("Gross value added", "Depreciation",
                                      "Other taxes on production",
                                      "Other subsidies (non-product specific)"))
pt$addRowDataGroups("Level6", outlineBefore=TRUE,
                    onlyAddOutlineChildGroupIf="MaxGroupLevel>6",
                    dataSortOrder="custom",
                    customSortOrder=c("Production of the agricultural industry",
                                      "Intermediate Services"))
pt$addRowDataGroups("Level7", dataSortOrder="custom",
                    customSortOrder=c("Crop production", "Livestock production",
                                      "Production of agricultural services", "Other production"),
                    styleDeclarations=list("font-weight"="normal"))
pt$defineCalculation(calculationName="Budget",
                     summariseExpression="sum(Budget2020)")
pt$defineCalculation(calculationName="Actual",
                     summariseExpression="sum(Actual2020)")
pt$defineCalculation(calculationName="Variance",
                     summariseExpression="sum(Actual2020)-sum(Budget2020)",
                     format="%.1f")
pt$evaluatePivot()

# apply the red style for negative variance
cells <- pt$findCells(calculationNames="Variance",
                      minValue=-1000, maxValue=0,
                      includeNull=FALSE, includeNA=FALSE)
pt$setStyling(cells=cells, declarations=list("color"="#9C0006"))
# apply the green style for positive variance
cells <- pt$findCells(calculationNames="Variance",
                      minValue=0, maxValue=10000,
                      includeNull=FALSE, includeNA=FALSE)
pt$setStyling(cells=cells, declarations=list("color"="#006100"))

# draw the pivot table
pt$renderPivot()
