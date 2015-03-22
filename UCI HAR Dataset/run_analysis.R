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
features <- read.table("./features.txt", header=FALSE, sep=" ")

trainLabel <- read.table ("./train/y_train.txt", header=FALSE, sep = " ")
train <- read.table ("./train/X_train.txt", header=FALSE, sep = "", col.names = features$V2)
train <- mutate(train, subject = trainLabel$V1)


testLabel <- read.table("./test/y_test.txt", header=FALSE, sep = " ")
test <- read.table("./test/x_test.txt", header=FALSE, sep = "", col.names = features$V2)
test <- mutate(test, subject = testLabel$V1)

# Merges the training and the test sets to create one data set.
data <- bind_rows(train, test)
data <- tbl_df(data)

rm(test, testLabel, train, trainLabel)

# Extract only the measurements on the mean and standard deviation for each measurement. 
meanCols <- which(grepl("mean", colnames(data)) == TRUE)
sdCols <- which(grepl("std", colnames(data)) == TRUE)

data2 <- select(data, meanCols, sdCols, subject)    

# From the data set in step 4, creates a second, independent
# tidy data set with the average of each variable for each activity and each subject.
data2 <- tbl_df(data2)
data3 <- 
        data2 %>%
        group_by(subject) %>% 
        summarise_each(funs(mean)) %>%
        print
        

