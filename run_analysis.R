## load relevant libraries

library(dplyr)

## go to the correct directory

setwd("C:/Users/Chris/Documents/MyData/Education/Online/R/coursera/Data science/Getting and Cleaning Data/Week4")

## download the zipped data and unpack the files

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, dest="source.zip", mode="wb") 
unzip ("source.zip")

## read in the names of the activities and the columns

data_names <- read.table("UCI HAR Dataset/features.txt", sep = "")
data_names <- data_names$V2

activities <- read.table("UCI HAR Dataset/activity_labels.txt", sep = "")
activities <- as.character(activities$V2)

## read in and process the training data set

X_train <- read.table("UCI HAR Dataset/train/X_train.txt", sep = "")
names(X_train) <- data_names

Y_train <- read.table("UCI HAR Dataset/train/y_train.txt", sep = "")
names(Y_train) <- "Activities"
Y_train$Activities <- as.factor(Y_train$Activities)
levels(Y_train$Activities) <- activities

S_train <- read.table("UCI HAR Dataset/train/subject_train.txt", sep = "")
names(S_train) <- "Subjects"
S_train$Subjects <- as.factor(S_train$Subjects)

length_to_use <- length(S_train)
T_train <- replicate(length_to_use, "Training data")
T_train <- as.data.frame(T_train)
names(T_train) <- "datatype"

All_train <- cbind(S_train, Y_train, T_train, X_train)
write.csv(All_train, "train.csv")

## read in and process the test data set

X_test <- read.table("UCI HAR Dataset/test/X_test.txt", sep = "")
names(X_test) <- data_names

Y_test <- read.table("UCI HAR Dataset/test/y_test.txt", sep = "")
names(Y_test) <- "Activities"
Y_test$Activities <- as.factor(Y_test$Activities)
levels(Y_test$Activities) <- activities

S_test <- read.table("UCI HAR Dataset/test/subject_test.txt", sep = "")
names(S_test) <- "Subjects"
S_test$Subjects <- as.factor(S_test$Subjects)

length_to_use <- length(S_test)
T_test <- replicate(length_to_use, "Test data")
T_test <- as.data.frame(T_test)
names(T_test) <- "datatype"

All_test <- cbind(S_test, Y_test, T_test, X_test)

## combine the training and test data sets

Full <- rbind(All_train, All_test)
write.csv(Full, "full.csv")

## select only the columns relating to means and standard deviations
## assumption is that means contain the string "mean" and standard deviations the string "std"
## we also want to keep the columns that contain the Subjects and Activities data

list_of_names <- names(Full)
list_of_names <- as.character(list_of_names)
selected <- grep("mean|std|Subjects|Activities|datatype", list_of_names)

## select from the full data set, the relevant columns we want to keep

adjusted <- Full[,selected]

## rename the columns so they are easy to understand

list_of_names <- names(adjusted)
write.csv(list_of_names, "names_before.csv")
list_of_names <- gsub("Acc", "Acceleration", list_of_names)
list_of_names <- gsub("Mag", "Magnitude", list_of_names)
list_of_names <- gsub("^t", "time", list_of_names)
list_of_names <- gsub("^f", "freq", list_of_names)
names(adjusted) <- list_of_names
write.csv(list_of_names, "names_after.csv")
write.csv(adjusted, "adjusted.csv")

## create a new dataset which has the averages of each variable for each activity and each subject

dim_adjusted <- dim(adjusted)
upper <- dim_adjusted[2]
new <- aggregate(adjusted[, 4:upper], list(adjusted$Subjects, adjusted$Activities), mean)
list_of_names <- names(new)
list_of_names[1] <- "Subjects"
list_of_names[2] <- "Activities"
names(new) <- list_of_names
write.csv(new, "new.csv")
write.table(new, "new", row.name=FALSE)
