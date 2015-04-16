# Soluton to a common issue I have had with data organization

# http://stackoverflow.com/questions/29523974/cleaning-data-when-variables-are-column-names/29526525?iemail=1&noredirect=1#29526525
#############################################################
# To install development version of data.table
# First you must install RTools at the following URL
# http://cran.r-project.org/bin/windows/Rtools/
library(devtools)
install_github("Rdatatable/data.table", build_vignettes = FALSE)
################################################################

setwd("C:/Users/jeffthatcher/Cloud Drive/RRepos/GetCleanData")

library(data.table)
library(dplyr)
library(tidyr)

df <- read.csv("./data/unCleanData.csv")

##################### Answer 1 #################################
library(reshape2)
melt(setDT(DT), id=1L, measure=lapply(c("^Group", "^Error"), grep, names(dt)), 
     variable.name="Group", value.name = c("Measure", "Error"))

##################### Answer 2.1 ##################################
library(dplyr)

df <- data.frame(Timepoint=c(0L, 7L, 14L, 21L, 28L), Group1=c(50L, 60L, 66L, 88L, 90L),
                 Error_Group1=c(3, 4, 6, 8, 2), Group2=c(30L, 60L, 90L, 120L, 150L),
                 Error_Group2=c(10L, 14L, 16L, 13L, 25L), Group3=c(44L, 78L, 64L, 88L, 91L),
                 Error_Group3=c(2L, 13L, 16L, 4L, 9L))

df <- lapply(1:3, function(x){
        temp <- df %>% select(Timepoint, ends_with(as.character(x))) %>% mutate(Group=x)
        names(temp) <- c("Timepoint", "Measure", "Error", "Group")
        temp <- temp %>% select(Timepoint, Group, Measure, Error)
})

df <- do.call(rbind, df)
df
##################### Answer 2.2 #################################
library(dplyr); library(tidyr)
df <- df %>% gather(temp, Timepoint) 
names(df) <- c("Timepoint", "temp", "values")

df <- df %>% mutate(Group = sub("\\D+", "", temp), temp=sub("\\d", "", temp)) %>% 
        spread(temp, values)

names(df) <- c("Timepoint", "Group", "Error", "Measure")
df

##################### Answer 3 #################################
df %>%
        # 1. Pivot the table
        gather (g, m, -Timepoint) %>%
        # 2. Get the final Group ID in mGroup
        separate (g, c("Measure", "mGroup"), -2) %>% 
        # 3. Spread the actual Error and Measure in two columns
        spread (Measure, m) %>% 
        # 4. Assign the correct names to final columns
        select (Timepoint, Group = mGroup, Measure = Group, Error = Error_Group) %>%
        # 5. Sort as requested
        arrange (Group, Timepoint) 

