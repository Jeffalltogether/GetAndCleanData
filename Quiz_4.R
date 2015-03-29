### Quiz 3
setwd("C:/Users/jeffthatcher/Cloud Drive/RRepos/GetCleanData")
library(data.table)
library(dplyr)
library(tidyr)

## Question 1

if(!file.exists("q3data")) {
        dir.create("q3data")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./q3data/idaho.csv") #curl is necessary for MAC users getting data from https
list.files("./q3data") # sort of like the ls() command, shows the files in the directory "./data"

idaho <- read.csv("./q3data/idaho.csv")
idaho <-(idaho)

# Apply strsplit() to split all the names of the data frame on the 
# characters "wgtp". What is the value of the 123 element of the resulting list?
strsplit(names(idaho), "wgtp")

## Question 2
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv "
download.file(fileUrl, destfile = "./q3data/gdp.csv") #curl is necessary for MAC users getting data from https
list.files("./q3data") # so
gdp <- read.csv("./q3data/gdp.csv", skip = 4, nrows = 190, col.names = c("CountryCode","c2","c3","countryNames","c5","c6","c7","c8","c9","c10"))

y <- as.numeric(gsub(",","", gdp$c5))
y <- y[!is.na(y)]
ave <- mean(y)
gdp <- colnames(gdp, y)

## Question 3
a <- grep("*United",gdp$countryNames)
b <- grep("^United",gdp$countryNames)
c <- grep("United$",gdp$countryNames)
d <- grep("^United",gdp$countryNames)
summary(d)

## Question 4
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl, destfile = "./q3data/edu.csv") #curl is necessary for MAC users getting data from https
list.files("./q3data") # so
edu <- read.csv("./q3data/edu.csv", skip = 0)
head(edu)
str(edu)

g <- merge(gdp, edu, all = TRUE, by = c("CountryCode"))
FYearEnd <- grepl("fiscal year end", tolower(g$Special.Notes))
June <- grepl("june", tolower(g$Special.Notes))
table(FYearEnd, June)


## Question 5
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn) 
addmargins(table(year(sampleTimes), weekdays(sampleTimes)))
