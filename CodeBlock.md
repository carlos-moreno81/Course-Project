---
title: "CodeBook"
author: "Carlos Moreno"
date: "25/8/2020"
output: html_document
---


## Code Book
1. The run_analysis.R script performs the data preparation,Download the dataset and extracted under the folder called UCI HAR Dataset
```{r}
library(dplyr)
filename <- "Assignment_CleaningData.zip"

if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")}  

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename)}
```
 2. Assign each data to variables:
  
features <- The features selected for this database come from the accelerometer and gyroscope. 
  
activities <- List of activities performed when the corresponding measurements.
  
subject_test <- contains test data of  volunteer test subjects being observed.
  
x_test <-contains recorded features test data.
  
y_test <- contains test data of activities’code labels.
  
subject_train <- contains train data of volunteer subjects being observed.
  
x_train <-contains recorded features train data.
  
y_train <-contains train data of activities’code labels.


```{r}
feature <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = feature$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = feature$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
```
3. Merges the training and the test sets.

-X is created by merging x_train and x_test.
  
-Y is created by merging y_train and y_test.

- Subject is created by merging subject_train and subject_test.

-Merged_Data is created by merging Subject, Y and X.

```{r}
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)
```

4. Extractsthe mean and standard deviation and Uses descriptive activity names;Appropriately labels the data set .

```{r}
TData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

TData$code <- activities[TData$code, 2]

names(TData)[2] = "activity"
names(TData)<-gsub("Acc", "Accelerometer", names(TData))
names(TData)<-gsub("Gyro", "Gyroscope", names(TData))
names(TData)<-gsub("BodyBody", "Body", names(TData))
names(TData)<-gsub("Mag", "Magnitude", names(TData))
names(TData)<-gsub("^t", "Time", names(TData))
names(TData)<-gsub("^f", "Frequency", names(TData))
names(TData)<-gsub("tBody", "TimeBody", names(TData))
names(TData)<-gsub("-mean()", "Mean", names(TData), ignore.case = TRUE)
names(TData)<-gsub("-std()", "STD", names(TData), ignore.case = TRUE)
names(TData)<-gsub("-freq()", "Frequency", names(TData), ignore.case = TRUE)
names(TData)<-gsub("angle", "Angle", names(TData))
names(TData)<-gsub("gravity", "Gravity", names(TData))
```

5.Create file "ResultData.txt".

```{r}
ResultData <- TData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(ResultData, "ResultData.txt", row.name=FALSE)
```