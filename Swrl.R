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
#######################
cran <- tbl_df(mydf)
#######################
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


group_by()                              # to break up your dataset into groups of rows based on the values of one or more variables
by_package <- group_by(cran, package)   # Group cran by the package variable and store the result in a new variable called by_package
                                        # now any operation we apply to the grouped data will take place on a per package basis.
summarize(by_package, mean(size))       # Instead of returning a single value, summarize() now returns the mean size for EACH package in our dataset.

# Compute four values, in the following order, from
# the grouped data:
#
# 1. count = n()
# 2. unique = n_distinct(ip_id)
# 3. countries = n_distinct(country)
# 4. avg_bytes = mean(size)
#
# A few thing to be careful of:
#
# 1. Separate arguments by commas
# 2. Make sure you have a closing parenthesis
# 3. Check your spelling!
# 4. Store the result in pack_sum (for 'package summary')
#
# You should also take a look at ?n and ?n_distinct, so
# that you really understand what is going on.

pack_sum <- summarize(by_package,
                      count = n(),
                      unique = n_distinct(ip_id),
                      countries = n_distinct(country),
                      avg_bytes = mean(size))

quantile(pack_sum$count, probs = 0.99)          # the value of 'count' that splits the data into the top 1% and bottom 99%
top_counts <- filter(pack_sum, count > 679)     # use filter() to select all rows from pack_sum for which 'count' is strictly greater (>) than 679



View(top_counts)                        # Full table view of a varialbe

top_counts_sorted <- arrange(top_counts, desc(count))

## Chaining ##
# chaining allows you to string together multiple function calls in a way that is compact and readable
?chain
# Read the code below, but don't change anything. As
# you read it, you can pronounce the %>% operator as
# the word 'then'.
#
# Type submit() when you think you understand
# everything here.

result3 <-
        cran %>%
        group_by(package) %>%
        summarize(count = n(),
                  unique = n_distinct(ip_id),
                  countries = n_distinct(country),
                  avg_bytes = mean(size)
        ) %>%
        filter(countries > 60) %>%
        arrange(desc(countries), avg_bytes)

# Print result to console
print(result3)

####### STEP1 ####### 
# select() the following columns from cran. Keep in mind
# that when you're using the chaining operator, you don't
# need to specify the name of the data tbl in your call to
# select().
#
# 1. ip_id
# 2. country
# 3. package
# 4. size
#
# The call to print() at the end of the chain is optional,
# but necessary if you want your results printed to the
# console. Note that since there are no additional arguments
# to print(), you can leave off the parentheses after
# the function name. This is a convenient feature of the %>%
# operator.

cran %>%
        select(ip_id,
               country,
               package,
               size) %>%
        print

####### STEP2 ####### 
# Use mutate() to add a column called size_mb that contains
# the size of each download in megabytes (i.e. size / 2^20).
#
# If you want your results printed to the console, add
# print to the end of your chain.

cran %>%
        select(ip_id, country, package, size) %>%
        mutate(size_mb = size / 2^20) %>%
        print

####### STEP3 ####### 
# Use filter() to select all rows for which size_mb is
# less than or equal to (<=) 0.5.
#
# If you want your results printed to the console, add
# print to the end of your chain.

cran %>%
        select(ip_id, country, package, size) %>%
        mutate(size_mb = size / 2^20) %>%
        filter(size_mb <= 0.5) %>%
        print

####### STEP4 ####### 
# arrange() the result by size_mb, in descending order.
#
# If you want your results printed to the console, add
# print to the end of your chain.

cran %>%
        select(ip_id, country, package, size) %>%
        mutate(size_mb = size / 2^20) %>%
        filter(size_mb <= 0.5) %>%
        arrange(desc(size_mb)) %>%
        print


