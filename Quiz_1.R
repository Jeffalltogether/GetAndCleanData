## Quiz 1 Getting and Cleaning Data

setwd("C:/Users/jeffthatcher/Cloud Drive/RRepos/GetCleanData")
library(data.table)

## Question 1
if(!file.exists("quiz1")) {dir.create("quiz1")}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./quiz1/IdahoHousing.csv")
list.files("./quiz1") # sort of like the ls() command, shows the files in the directory "./data"

IH <- read.table("./quiz1/IdahoHousing.csv", sep = ",", header = TRUE)
head(IH$VAL)
a <- IH$VAL[!is.na(IH$VAL)] == 24 #return T/F vector of col VAL equal to 24 ($1,000,000 + )
sum(a) # sum of all the TURE values in `a`

## Question 3
library(xlsx)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileUrl, destfile = "./quiz1/natgas.xlsx", mode="wb")
list.files("./quiz1") # sort of like the ls() command, shows the files in the directory "./data"

dat <- read.xlsx("./quiz1/natgas.xlsx", sheetIndex=1, 
                 startRow=18, endRow=23, colIndex=c(7:15), 
                 header=TRUE)

sum(dat$Zip*dat$Ext,na.rm=T) 

## Question 4
library(XML)
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlTreeParse(fileUrl, useInternal=TRUE) # loads the document into R memory for parsing 
rootNode <- xmlRoot(doc) # weapper element for entire XML document
xmlName(rootNode) # returns the name of the XML

zip <- xpathSApply(rootNode, "//zipcode", xmlValue)
x <- zip == 21231
sum(x)

## Question 5
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = "./quiz1/IdahoHousing.csv")
list.files("./quiz1") # sort of like the ls() command, shows the files in the directory "./data"

DT <- fread("./quiz1/IdahoHousing.csv", sep = ",", header = TRUE)

# calculates the mean of a column (pwgtp15) subsetted by the levels of a second column (SEX)
DT[,mean(pwgtp15),by=SEX]
