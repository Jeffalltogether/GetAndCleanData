## Reading from MySQL
# www.mysql.com
# Best to practice on local version of MySQL database

library(RMySQL)

## Also see package sqlfd
library(sqldf)

## Open connection to online SQL database
ucscDb <- dbConnect(MySQL(), user="genome",
                    host="genome-mysql.cse.ucsc.edu")
# open query to database through dbGetQuery an then disconnect!
result <- dbGetQuery(ucscDb, "show databases;"); dbDisconnect(ucscDb); # dbGetQuery has SQL arguments
result

## focus on "hg19" genome build
hg19 <- dbConnect(MySQL(), user="genome", db="hg19",
                    host="genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)  # each table is a data.table
allTables[1:5]

dbListFields(hg19, "affyU133Plus2")  # what are all the column fields in "affyU133Plus2"?
dbGetQuery(hg19, "select count(*) from affyU133Plus2") # how many different rows are in "affyU133Plus2"?  Use a special MySQL command in ""

## Pulling data from database
affyData <- dbReadTable(hg19, "affyU133Plus2") #extract the data as a data.table
head(affyData)

## Subsetting
query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3") # subset the data where values in mismatch column are between 1 and 3
affyMis <- fetch(query); quantile(affyMis$misMatches)

affyMisSmall <- fetch(query, n=10); dbClearResult(query); # must clear the query from the remote servery when done

dim(affyMisSmall)

## Remember to close the connection!!
dbDisconnect(hg19)
