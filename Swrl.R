### Swirl Assignments from Getting and Cleaning Data
# Installation...
# library(swirl)
# install_from_swirl("Getting and Cleaning Data")

library(swirl)
swirl()

## Manipulating Data with dplyr
library(dplry)
mydf <- read.csv(path2csv, stringsAsFactors = FALSE)
dim() # to view data fram dimensions
packageVersion("dplyr")
x <- tbl_df()    # to load the data into what the package authors call a 'data frame tbl' or 'tbl_df'
rm() # removed the old data frama

### dplyr supplies five 'verbs' that cover most fundamental data
### manipulation tasks: select(), filter(), arrange(), mutate(), and summarize()
select(cran, ip_id, package, country)   # we don't have to type cran$ip_id, cran$package, and cran$country, as we
                                        # normally would when referring to columns of a data frame
select(cran, r_arch:country)            # specify a sequence of columns using the `:` operator, just like 5:20
select(cran, country:r_arch)            # can be done in reverse order