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

### Tidying Data with tidyr
library(tidyr)
# http://vita.had.co.nz/papers/tidy-data.pdf

# tidy data satisfies three conditions:
         
        # 1) Each variable forms a column

        # 2) Each observation forms a row

        # 3) Each type of observational unit forms a table

### 1. The first problem is when you have column headers that are values, not variable names.
gather()
gather(students, sex, count, -grade)    # we need to have one column for each of these three variables
                                        # The data argument, students, gives the name of
                                        # the original dataset. The key and value arguments -- sex and count, respectively -- give the column names for our
                                        # tidy dataset. The final argument, -grade, says that we want to gather all columns EXCEPT the grade column (since
                                        # grade is already a proper column variable.)

### 2. The second messy data case we'll look at is when multiple variables are stored in one column.
# students2 suffers from the same messy data problem of having column headers that are values (male_1, female_1, etc.)
res <- gather(students2, sex_class, count, -grade)      # That got us half way to tidy data, but we still have two different variables, sex and class, stored together in the sex_class column
separate()
separate(res, sex_class, into = c("sex", "class"))      # Conveniently, separate() was able to figure out on its own how to separate the sex_class column. 
                                                        # Unless you request otherwise with the 'sep' argument, it
                                                        # splits on non-alphanumeric values. In other words, it assumes that the values are separated by 
                                                        # something other than a letter or number (in this case, an underscore.)

### just like with dplyr, you can use the %>% operator to chain multiple function calls together.
# Repeat your calls to gather() and separate(), but this time
# use the %>% operator to chain the commands together without
# storing an intermediate result.
#
# If this is your first time seeing the %>% operator, check
# out ?chain, which will bring up the relevant documentation.
# You can also look at the Examples section at the bottom
# of ?gather and ?separate.
#
# The main idea is that the result to the left of %>%
# takes the place of the first argument of the function to
# the right. Therefore, you OMIT THE FIRST ARGUMENT to each
# function.
#
students2 %>%
        gather(sex_class, count, -grade) %>%
        separate(sex_class, c("sex", "class")) %>%
        print

### 3. A third symptom of messy data is when variables are stored in both rows and columns
# Call gather() to gather the columns class1 through
# through class5 into a new variable called class.
# The 'key' should be class, and the 'value'
# should be grade.
#
# tidyr makes it easy to reference multiple adjacent
# columns with class1:class5, just like with sequences
# of numbers.
#
# Since each student is only enrolled in two of
# the five possible classes, there are lots of missing
# values (i.e. NAs). Use the argument na.rm = TRUE
# to omit these values from the final result.
#
# Remember that when you're using the %>% operator,
# the value to the left of it gets inserted as the
# first argument to the function on the right.
#
# Consult ?gather and/or ?chain if you get stuck.
#
students3 %>%
        gather(class, grade, class1:class5 ,na.rm = TRUE) %>%
        print
# This script builds on the previous one by appending
# a call to spread(), which will allow us to turn the
# values of the test column, midterm and final, into
# column headers (i.e. variables).
#
# You only need to specify two arguments to spread().
# Can you figure out what they are? (Hint: You don't
# have to specify the data argument since we're using
# the %>% operator.
#
students3 %>%
        gather(class, grade, class1:class5, na.rm = TRUE) %>%
        spread(test, grade) %>%
        print

                                # Lastly, we want the values in the class column to simply be 1, 2, ..., 5 and not class1, class2, ...,
extract_numeric("class5")       # class5. We can use the extract_numeric() function from tidyr to accomplish this. To see how it works, try
# We want the values in the class columns to be
# 1, 2, ..., 5 and not class1, class2, ..., class5.
#
# Use the mutate() function from dplyr along with
# extract_numeric(). Hint: You can "overwrite" a column
# with mutate() by assigning a new value to the existing
# column instead of creating a new column.
#
# Check out ?mutate and/or ?extract_numeric if you need
# a refresher.
#
students3 %>%
        gather(class, grade, class1:class5, na.rm = TRUE) %>%
        spread(test, grade) %>%
        mutate(class = extract_numeric(class)) %>% ### Call to mutate() goes here %>%
        print

### 4. The fourth messy data problem we'll look at occurs when multiple observational units are stored in the same table.
# notice that each id, name, and sex is repeated twice, which seems quite redundant
# Our solution will be to break students4 into two separate tables -- one containing basic student
# information (id, name, and sex) and the other containing grades (id, class, midterm, final).
# Complete the chained command below so that we are
# selecting the id, name, and sex column from students4
# and storing the result in student_info.
#
student_info <- students4 %>%
        select(id, name, sex) %>%
        print
# Add a call to unique() below, which will remove
# duplicate rows from student_info.
#
# Like with the call to the print() function below,
# you can omit the parentheses after the function name.
# This is a nice feature of %>% that applies when
# there are no additional arguments to specify.
#
student_info <- students4 %>%
        select(id, name, sex) %>%
        unique %>% 
        print
# select() the id, class, midterm, and final columns
# (in that order) and store the result in gradebook.
#
gradebook <- students4 %>%
        select(id, class, midterm, final) %>%
        print

### 5. when a single observational unit is stored in multiple tables. It's the opposite of the fourth problem.
# The name of each dataset actually represents the value of a new variable that we will call 'status'. Before
# joining the two tables together, we'll add a new column to each containing this information so that its not
# lost when we put everything together.
passed <- mutate(passed, status = "passed")
failed <- mutate(failed, status = "failed")
bind_rows()

### 6. Practice with a real dataset
# http://research.collegeboard.org/programs/sat/data/cb-seniors-2013
# sat' in your workspace, which contains data on all college-bound seniors who took the SAT exam in 2013.
# Accomplish the following three goals:
#
# 1. select() all columns that do NOT contain the word "total",
# since if we have the male and female data, we can always
# recreate the total count in a separate column, if we want it.
# Hint: Use the contains() function, which you'll
# find detailed in 'Selection' section of ?select.
#
# 2. gather() all columns EXCEPT score_range, using
# key = part_sex and value = count.
#
# 3. separate() part_sex into two separate variables (columns),
# called "part" and "sex", respectively. You may need to check
# the 'Examples' section of ?separate to remember how the 'into'
# argument should be phrased.
#
sat %>%
        select(-contains("total")) %>%
        gather(part_sex, count, -score_range) %>%
        separate(part_sex, c("part", "sex")) %>%
        print
# Append two more function calls to accomplish the following:
#
# 1. Use group_by() (from dplyr) to group the data by part and
# sex, in that order.
#
# 2. Use mutate to add two new columns, whose values will be
# automatically computed group-by-group:
#
#   * total = sum(count)
#   * prop = count / total
#
sat %>%
        select(-contains("total")) %>%
        gather(part_sex, count, -score_range) %>%
        separate(part_sex, c("part", "sex")) %>%
        group_by(part, sex) %>%
        mutate(total = sum(count),
               prop = count / total
        ) %>% print

###### Dates and Times with lubridate
library(lubridate)
today()
this_day <- today()     # There are three components to this date. In order, they are year, month, and day.
                        # We can extract any of these components using the year(), month(), or day() function, respectively

wday()                  # get the day of the week from this_day
wday(this_day, label = TRUE)

now()                   # returns the date-time representing this exact moment in time
this_moment <- now()
minute(this_moment)     # we can also use hour(),minute(), and second() to extract specific time information
# lubridate offers a variety of functions for parsing date-times
# ymd(), dmy(), hms(), ymd_hms(), etc., where each letter in the name of the function stands for the
# location of years (y), months (m), days (d), hours (h), minutes (m), and/or seconds (s) in the date-time
# being read in.
my_date <- ymd("1989-05-17")
class(my_date)          # POSIXct is, but just know that it is one way that R stores date-time information internally.
ymd("1989 May 17")      # to parse "1989 May 17"
mdy("March 12, 1975")   # to parse "1989 May 17", etc... 
ymd("1920/1/2")
ymd_hms(dt1)
hms("03:22:14")
ymd(dt2)        # works on vectors

update()                # allows us to update one or more components of a date-time
update(this_moment, hours = 8, minutes = 34, seconds = 55) #It's important to recognize that the previous command does not alter this_moment unless we reassign theresult to this_moment


nyc <- now(tzone = "America/New_York")   # To find the current date in New York, we'll use the now() function again
### For a complete list of valid time zones for use with lubridate, check out the following Wikipedia page:
#      http://en.wikipedia.org/wiki/List_of_tz_database_time_zones
depart <-  nyc + days(2)
depart <- update(depart, hours = 17, minutes = 34)
arrive <- depart + hours(15) + minutes(50)

with_tz()       # returns a date-time as it would appear in another time zone
arrive <- with_tz(arrive, "Asia/Hong_Kong")

## add/subtract dates
new_interval()
as.period()

last_time <- mdy("June 17, 2008", tz = "Singapore") 
how_long <- new_interval(last_time, arrive)
as.period(how_long)

stopwatch()  #  to see how long you've been working!

# 2011 Journal of Statistical Software paper titled 'Dates and Times Made Easy with lubridate'


