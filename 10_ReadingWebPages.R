## Reading data from the web
# beware of 'terms of service'

## Getting data off webpages
con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con)
htmlCode

## Parsing with XML
library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes=T)

xpathSApply(html, "//title", xmlValue)

xpathSApply(html, "//td[@id='col-Cited by']", xmlValue)


## GET from the httr package
library(httr); html2 = GET(url)
content2 = content(html2, as="text")
parsedHtml = htmlParse(content2,asText=TRUE)
xpathSApply(parsedHtml, "//title", xmlValue)

# Authenticate yourself to login with user-name and PW
pg2 = GET("http://httpbin.org/basic-auth/user/passwd",
          authenticate("user","passwd"))  #this is a test website and the username is "user"; the PW is "passwd"
pg2

names(pg2)

## Using handles, authentication is stored as a cookie to speed things up
google = handle("http://google.com")
pg1 = GET(handle=google,path="/")
pg2 = GET(handle=google,path="search")
