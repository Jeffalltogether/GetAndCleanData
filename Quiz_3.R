### Quiz 3

library(data.table)
library(dplyr)
library(tidyr)


setwd("C:/Users/jeffthatcher/Cloud Drive/RRepos/GetCleanData")


## Question 1

if(!file.exists("data")) {
        dir.create("data")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./data/idaho.csv") #curl is necessary for MAC users getting data from https
list.files("./data") # sort of like the ls() command, shows the files in the directory "./data"

idaho <- read.csv("./data/idaho.csv")
idaho <-(idaho)
idaho[id := 1:length(idaho)]
# Create a logical vector that identifies the households on greater than 10 acres 
# who sold more than $10,000 worth of agriculture products. Assign that logical 
# vector to the variable agricultureLogical. Apply the which() function 
# like this to identify the rows of the data frame where the logical vector is TRUE. 
# which(agricultureLogical) What are the first 3 values that result?


agricultureLogical <- 
        idaho %>%
        mutate(id = 1:nrow(idaho)) %>%
        select(id, ACR, AGS) %>%
        filter(ACR >= 3& AGS >= 6) %>%
        print


## Question 2
# Using the jpeg package read in the following picture of your instructor into R 

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(fileUrl, destfile = "./data/pic.jpg") #curl is necessary for MAC users getting data from https
list.files("./data") # sort of like the ls() command, shows the files in the directory "./data"

# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data?

library(jpeg)
library(reshape2)
jpeg <- readJPEG("./data/pic.jpg", native=TRUE)

parta <- quantile(jpeg, probs = 0.30)
partb <- quantile(jpeg, probs = 0.80)

## Question 3
fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
fileUrl2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl1, destfile = "./data/fgdp.csv") #curl is necessary for MAC users getting data from https
download.file(fileUrl2, destfile = "./data/fedstats.csv") #curl is necessary for MAC users getting data from https
list.files("./data") # sort of like the ls() command, shows the files in the directory "./data"

names <- c("CountryCode", "GDP_Ranking", "X3", "Country", "$M", "X6", "X7", "X8", "X9", "X10")
fgdp <- read.csv("./data/fgdp.csv", skip = 4, nrows = 194-4, col.names = names)
fedstats <- read.csv("./data/fedstats.csv")
x <- merge(fgdp, fedstats, by.x = "CountryCode", by.y ="CountryCode")
y <- join(fgdp, fedstats, by = "CountryCode")

arrange(y, CountryCode)
tail(y$CountryCode[!is.na(y$CountryCode)], 13)
# Match the data based on the country shortcode. How many of the IDs match? 
# Sort the data frame in descending order by GDP rank (so United States is last). 
# What is the 13th country in the resulting data frame? 

## Question 4
# What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?

nonOECD <- filter(y, Income.Group == "High income: nonOECD")
nonRank <- mean(nonOECD$GDP_Ranking)
OECD <- filter(y, Income.Group == "High income: OECD")
Rank <- mean(OECD$GDP_Ranking)


## Question 5
# Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. 
# How many countries are Lower middle income but among the 38 nations with highest GDP?

quantiles <- quantile(y$GDP_Ranking, probs = seq(0.2, 1.0, 0.2) )
DT <- 
        y %>%
        select(Short.Name, Income.Group, GDP_Ranking) %>%
        arrange(GDP_Ranking) %>%
        print

DT2 <- DT[1:38,]
count <- sum(DT2$Income.Group == "Lower middle income")


1 - 125, 238,262
2 - XXX -16776430 -15390165 XXX
3 - 189 matches, 13th country is St. Kitts and Nevis
4 - 32.96667, 91.91304
5 - 5