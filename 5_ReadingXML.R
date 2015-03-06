## Reading XML
# Futher Reading:
# http://www.omegahat.org/RSXML/shortIntro.pdf
# http://www.omegahat.org/RSXML/Tour.pdf
# http://www.stat.berkeley.edu/~statcur/Workshop2/Presentations/XML.pdf

library(XML)
fileUrl <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileUrl, useInternal=TRUE) # loads the document into R memory for parsing 
rootNode <- xmlRoot(doc) # wrapper element for entire XML document
xmlName(rootNode) # returns the name of the XML

names(rootNode) # root node wraps the entire document, this command shows the names of these root nodes

rootNode[[1]] # accesses the first element in the list of rootNodes

rootNode[[1]][[1]] # first element of first subcomponent of the rootNode

xmlSApply(rootNode, xmlValue) # loops through all of the elements in the rootNode and applys the xmlValue function to these elements

##XPath language is valuable, see lecture notes
## Get all the items on the menue and their prices
xpathSApply(rootNode, "//name", xmlValue)
xpathSApply(rootNode, "//price", xmlValue)

## Website Scraping!!
## ESPN Ravens website source-code example
fileUrl <- "http://espn.go.com/nfl/team/schedule/_/name/bal/year/2014"
doc <- htmlTreeParse(fileUrl, useInternal=TRUE)  # need to use html rather than xml for website source-code
scores <- xpathSApply(doc, "//li[@class='score']", xmlValue)
teams <- xpathSApply(doc, "//li[@class='team-name']", xmlValue)
scores
teams
