###  Getting and Cleaning Data Course Project
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

setwd("C:/Users/jeffthatcher/Cloud Drive/RRepos/GetCleanData/UCI HAR Dataset")

library(XML)
library(data.table)
library(dplyr)
library(tidyr)

## read Data
features <- read.table("./features.txt", header=FALSE, sep=" ")                                 # the list of features will be the Column Names

trainLabel <- read.table ("./train/y_train.txt", header=FALSE, sep = " ")                       # this will create the list of the Subjects ID number that will eventuall become the subjects column in the data table
train <- read.table ("./train/X_train.txt", header=FALSE, sep = "", col.names = features$V2)    # read in the training data and label the coloumn according to the list of features
train <- mutate(train, subject = trainLabel$V1)                                                 # add the Subjects column 


testLabel <- read.table("./test/y_test.txt", header=FALSE, sep = " ")                           # this will create the list of the Subjects ID number that will eventuall become the subjects column in the data table
test <- read.table("./test/x_test.txt", header=FALSE, sep = "", col.names = features$V2)        # read in the training data and label the coloumn according to the list of features
test <- mutate(test, subject = testLabel$V1)                                                    # add the Subjects column 

# Merges the training and the test sets to create one data set.
data <- bind_rows(train, test)          # this step merges the test and trainnig data sets
data <- tbl_df(data)                    # convert 'data' into a data a dplyr 'data frame tbl'

rm(test, testLabel, train, trainLabel)  # remove large tables that are not needed for futher analysis

# Extract only the measurements on the mean and standard deviation for each measurement. 
meanCols <- which(grepl("mean", colnames(data)) == TRUE)        # identify the indices of the columnes that have the word "mean" somewhere in thier description
sdCols <- which(grepl("std", colnames(data)) == TRUE)           # identify the indices of the columnes that pertain to standard deviations and have "std" somewhere in thier description

data2 <- select(data, meanCols, sdCols, subject)                # subset of the original 'data' that only contains mean and standard deviation coloumns for each measurement

# From the data set in step 4, creates a second, independent
# tidy data set with the average of each variable for each activity and each subject.
data2 <- tbl_df(data2)                          # converts 'data2 into a data a dplyr 'data frame tbl'
data3 <-        
        data2 %>%                               
        group_by(subject) %>%                   
        summarise_each(funs(mean)) %>%          # calculate the mean of each column by subject
        print

View(data3)                                     #view the outcome dataset 

write.table(data3, file = "run_analysis_result.txt", row.name = FALSE)  #to submit to Coursera

