## Getting data from the internet
# need url, destfile, method
# right-click to cpoy link address
# download.file()

setwd("C:/Users/jeffthatcher/Cloud Drive/RRepos/GetCleanData")

if(!file.exists("data")) {
        dir.create("data")
}

fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "./data/cameras.csv") #curl is necessary for MAC users getting data from https
list.files("./data") # sort of like the ls() command, shows the files in the directory "./data"
dateDownloaded <- date()
dateDownloaded

