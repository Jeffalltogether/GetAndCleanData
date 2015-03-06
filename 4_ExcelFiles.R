## Excel Files

setwd("C:/Users/jeffthatcher/Cloud Drive/RRepos/GetCleanData")
if(!file.exists("data")) {dir.create("data")}
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "./data/cameras.xlsx", mode="wb") # Mode ="wb" to download in binary and fix error with unreadable content
dateDownloaded <- date()

# {xlsx package}
# read.xlsx();  read.xlsx2();

library(xlsx)
cameraData <- read.xlsx("./data/cameras.xlsx", sheetIndex=1, header=TRUE)
head(cameraData)
