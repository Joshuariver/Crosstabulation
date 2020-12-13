# Pivotter 패키지를 활용하여 LATEX 포멧으로 출력하기

# http://www.pivottabler.org.uk/articles/v06-latexoutput.html


# 시범용 Pivot Table

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$renderPivot()



# LATEX 포멧으로 출력하기

library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
cat(pt$getLatex())

