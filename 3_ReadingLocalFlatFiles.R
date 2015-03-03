## Reading local 'flat' files
# Important Params: file, header, sep, row.names, nrows
read.table()
# related: read.csv() read.csv2()

cameraData <- read.table("./data/cameras.csv", sep = ",", header = TRUE)
head(cameraData)

# OR
# `read.csv` which automatically sets sep = ",' and header = TRUE
cameraData <- read.csv("./data/cameras.csv")

# some important parameters
        # quote - you can tell R whenther there are any quoted values; quote="" means no quote
        # na.strings - set the character that represent a missing value
        # nrows - how many rows of the file to read
        # skip - how many rows to skip before starting to read

# Biggest Trouble with reading flat files are quotation marks ` or " placed in
# data values, setting quote ="" often resolves these.