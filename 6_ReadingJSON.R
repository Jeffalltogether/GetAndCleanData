## Reading JSON
# look up wiki for JSON

library(jsonlite)
jsonData <- fromJSON("https://api.github.com/users/jtleek/repos") # returns a structured data.frame
names(jsonData)
names(jsonData$owner)
jsonData$owner$login

## take data.frame in R and export to JSON
myjson <- toJSON(iris, pretty=TRUE) #converts iris data set to JSON
cat(myjson)

iris2 <- fromJSON(myjson) #convert the JSON we just made of the iris dataset back to data.frame
head(iris2)

