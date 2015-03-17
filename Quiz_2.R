### Quiz 2 
setwd("C:/Users/jeffthatcher/Cloud Drive/RRepos/GetCleanData")
## Question 1
library(httr)
require(httpuv)
require(jsonlite)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. Register an application at https://github.com/settings/applications
#    Insert your values below - if secret is omitted, it will look it up in
#    the GITHUB_CONSUMER_SECRET environmental variable.
#
#    Use http://localhost:1410 as the callback url
myapp <- oauth_app("quiz2", "663754c307533a825c19", secret="8795f9a4fe93b512520f407a027b1fc1c66e96bf")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
req <- GET("https://api.github.com/users/jtleek/repos", config(token = github_token))
stop_for_status(req)
output <- content(req)
list(output[[4]]$name, output[[4]]$created_at)


## Question 2
setwd("C:/Users/jeffthatcher/Cloud Drive/RRepos/GetCleanData")

if(!file.exists("quizData")) {
        dir.create("quizData")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = "./quizData/acs.csv") #curl is necessary for MAC users getting data from https
list.files("./data") # sort of like the ls() command, shows the files in the directory "./data"
dateDownloaded <- date()
dateDownloaded

options(sqldf.driver = "SQLite") # as per FAQ #7 force SQLite
options(gsubfn.engine = "R") # as per FAQ #5 use R code rather than tcltk

library(RMySQL)
library(sqldf)

acs <- data.table(read.csv("./quizData/acs.csv"))
query1 <- sqldf("select pwgtp1 from acs where AGEP < 50")

## Question 3
DTq <- unique(acs$AGEP)
sqlq <- sqldf("select distinct AGEP from acs")
x <- DTq == sqlq
sum(x)

## Question 4
library(XML)
connection <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(connection)
close(connection)
c(nchar(htmlCode[10]), nchar(htmlCode[20]), nchar(htmlCode[30]), nchar(htmlCode[100]))


## Question 5
library(XML)
connection <- url("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for")
htmlCode2 <- readLines(connection)
close(connection)
DT <- data.table(htmlCode2)


url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
lines <- readLines(url, n=10)
w <- c(1, 9, 5, 4, 1, 3, 5, 4, 1, 3, 5, 4, 1, 3, 5, 4, 1, 3)
colNames <- c("filler", "week", "filler", "sstNino12", "filler", "sstaNino12", "filler", "sstNino3", "filler", "sstaNino3", "filler", "sstNino34", "filler", "sstaNino34", "filler", "sstNino4", "filler", "sstaNino4")
d <- read.fwf(url, w, header=FALSE, skip=4, col.names=colNames)
d <- d[, grep("^[^filler]", names(d))]
sum(d[, 4])