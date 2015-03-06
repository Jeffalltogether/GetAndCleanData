## The data.table Package
## similar to data.frame, but faster at subsetting, grouping, and updating
## similar functions to data.frame, but some differing syntax
# melt and dcast functions are currently being developed for data.table
# https://r-forge.r-project.org/scm/viewvc.php/pkg/NEWS?view=markup&root=datatable
# http://stackoverflow.com/questions/13618488/what-you-can-do-with-data-frame-that-you-cant-in-data-table


library(data.table)
DF = data.frame(x=rnorm(9), y=rep(c("a","b","c"), each=3), z=rnorm(9))
head(DF,3)

DT = data.table(x=rnorm(9), y=rep(c("a","b","c"), each=3), z=rnorm(9))
head(DT,3)

tables() # see all the data tables in memory

## Use the fread() function to read a file into R memory as a data.table quickly!!
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = "./quiz1/IdahoHousing.csv")
list.files("./quiz1") # sort of like the ls() command, shows the files in the directory "./data"

DT <- fread("./quiz1/IdahoHousing.csv", sep = ",", header = TRUE)


## Subsetting Rows
DT[2,]

DT[DT$y=="a",]

# when subsetting with 1 index, it subsetts based on ROWs
DT[c(2,3)] # takes the second and third rows from the data.tabe

## Subsetting Columns
DT[,c(2,3)]

# applying a function to a column subsetted by another col variable
DT[,mean(pwgtp15),by=SEX]

# You can pass a list of functions to perform on columns!!!
# functions are applied to variables named by columns
DT[,list(mean(x), sum(z))]

DT[,table(y)]

## Adding new columns
DT[,w:=z^2]
DT

## Beware of copying data.tables both DT and DT2 are changed
# use copy() funciton instead
DT2 <- DT
DT[,y:=2]
DT
DT2

## Multiple Operations
# this creates a new column that is the result of step 1 (left of `;`) followed by step 2 (right of `;`)
DT[,m:={tmp <- (x+z); log2(tmp+5)}]
DT

## `plyr` like operations
DT[,a:=x>0]
DT

DT[,b:=mean(x+w),by=a] #takes the mean of x+w grouped by col `a` 
DT

## Special Variables
## `.N` an integer, length 1, containing the number of times a particular thing appears

set.seed(123)
DT <- data.table(x=sample(LETTERS[1:3], 1E5, TRUE))
DT[, .N, by=x] # counts the number of times things appeare grouped by the `x` variable

## Keys make subsetting and sorting easier
DT = data.table(x=rep(c("a","b","c"), each=100), y=rnorm(300))
setkey(DT,x)

# facilitating subsetting
DT['a'] # knows by the Key to quickly subset the data.table based on column x values equal to 'a'

# facilitating Joins
DT1 <- data.table(x=c('a', 'a', 'b', 'dt1'), y=1:4)
DT2 <- data.table(x=c('a', 'b', 'dt2'),z=5:7)
setkey(DT1,x); setkey(DT2, x)
merge(DT1, DT2)

## fread() function for reading in data.tables is faster than for data.frames
big_df <- data.frame(x=rnorm(1E6), y=rnorm(1E6))
file <- tempfile()
write.table(big_df, file=file, row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)
system.time(fread(file))
system.time(read.table(file, header=TRUE, sep="\t"))
