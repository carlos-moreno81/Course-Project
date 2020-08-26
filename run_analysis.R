library(dplyr)
filename <- "Assignment_CleaningData.zip"


if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  


if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

feature <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = feature$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = feature$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

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

ResultData <- TData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(ResultData, "ResultData.txt", row.name=FALSE)

names(ResultData)
