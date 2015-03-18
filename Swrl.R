### Swirl Assignments from Getting and Cleaning Data
# Installation...
# library(swirl)
# install_from_swirl("Getting and Cleaning Data")

library(swirl)
swirl()

## Manipulating Data with dplyr
library(dplyr)
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


filter(cran, package == "swirl")                        # to select all rows for which the package variable is equal to "swirl"
filter(cran, r_version == "3.1.1", country == "US")     # you can specify as many conditions as you want, separated by commas
filter(cran, country == "US" | country == "IN")         # request rows for which EITHER one condition OR another condition are TRUE
filter(cran, !is.na(r_version))                         # return all rows of cran for which r_version is NOT NA

arrange()                                                # order the rows of a dataset according to the values of a particular variable
arrange(cran2, ip_id)                                    # to order the ROWS of cran2 so that ip_id is in ascending order (from small to large)
arrange(cran2, desc(ip_id))                              # in descending order
arrange(cran2, package, ip_id)                           # arrange the data according to the values of multiple variables
arrange(cran2, country, desc(r_version), ip_id)          # arrange works on columns in the order they are given

mutate()                                                        # to create a new variable based on the value of one or more variables already in a dataset
mutate(cran3, size_mb = size / 2^20)                            # to add a column called size_mb that contains the download size in megabytes
mutate(cran3, size_mb = size / 2^20, size_gb = size_mb / 2^10)  # mutate will handle operations on newly created columns in the same line of code.


summarize()                             # collapses the dataset to a single row
summarize(cran, avg_bytes = mean(size)) # the average download size


