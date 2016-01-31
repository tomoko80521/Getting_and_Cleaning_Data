library(dplyr)

original_working_dir <- getwd()

R_dir <- "/Users/tomoko/RWorkspace/Cousera/Getting_Cleaning_Data/"
setwd(R_dir)

# Part 1
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="../data/GCD_hw_data.zip", method="curl")
unzip(zipfile="GCD_hw_data.zip", exdir="./")
file.rename("UCI HAR Dataset", "UCI_HAR_Dataset")
file.remove("../data/GCD_hw_data.zip")

files_train <- dir(path = "../data/UCI_HAR_Dataset/train", pattern = "txt", full.names = TRUE)
files_test <- dir(path = "../data/UCI_HAR_Dataset/test", pattern = "txt", full.names = TRUE)

files_train
files_test

dataSubjectTrain <- read.table(files_train[1], header = FALSE)
dataSubjectTest  <- read.table(files_test[1], header = FALSE)

dataXTrain <- read.table(files_train[2], header = FALSE)
dataXTest  <- read.table(files_test[2], header = FALSE)

dataYTrain <- read.table(files_train[3], header = FALSE)
dataYTest  <- read.table(files_test[3], header = FALSE)

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
names(dataSubject) <- c("subject")

dataY <- rbind(dataYTrain, dataYTest)
names(dataY) <- c("activity")

dataX <- rbind(dataXTrain, dataXTest)
listFeatures <- read.table("../data/UCI_HAR_Dataset/features.txt", header = FALSE)
names(dataX) <- listFeatures[[2]]

temp <- cbind(dataSubject, dataY)
data <- cbind(temp, dataX)

# Part 2
tmp <- grep("mean\\(\\)|std\\(\\)", listFeatures[[2]])
targetFeatures <- listFeatures[[2]][tmp]
targetNames <- c(as.character(targetFeatures), "subject", "activity" )
targetData <- subset(data, select=targetNames)

# Part 3
activityLabels <- read.table("../data/UCI_HAR_Dataset/activity_labels.txt", header = FALSE)

# Part 4
names(targetData) <- gsub("^t", "Time", names(targetData))
names(targetData) <- gsub("^f", "Frequency", names(targetData))
names(targetData) <- gsub("Acc", "Accelerometer", names(targetData))
names(targetData) <- gsub("Gyro", "Gyroscope", names(targetData))
names(targetData) <- gsub("Mag", "Magnitude", names(targetData))
names(targetData) <- gsub("BodyBody", "Body", names(targetData))
names(targetData) <- gsub("mean", "Mean", names(targetData))
names(targetData) <- gsub("std", "Std", names(targetData))
names(targetData) <- gsub('[-()]', '', names(targetData))

# Part 5
tidyData <- targetData %>% 
    group_by(subject, activity) %>%
    summarise_each(funs(mean))

write.table(tidyData, file = "tidydata.txt",row.name=FALSE)

setwd(original_working_dir)
