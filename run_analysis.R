original_working_dir <- getwd()

R_dir <- "/Users/tomoko/RWorkspace/data/"
setwd(R_dir)

# Part 1
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./GCD_hw_data.zip", method="curl")
unzip(zipfile="GCD_hw_data.zip", exdir="./")
file.rename("UCI HAR Dataset", "UCI_HAR_Dataset")

files_train <- dir(path = "./UCI_HAR_Dataset/train", pattern = "txt", full.names = TRUE)
files_test <- dir(path = "./UCI_HAR_Dataset/test", pattern = "txt", full.names = TRUE)

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
listFeatures <- read.table("./UCI_HAR_Dataset/features.txt", header = FALSE)
names(dataX) <- listFeatures[[2]]

temp <- cbind(dataSubject, dataY)
data <- cbind(temp, dataX)

# Part 2
tmp <- grep("mean\\(\\)|std\\(\\)", listFeatures[[2]])
targetFeatures <- listFeatures[[2]][tmp]
targetNames <- c(as.character(subdataFeaturesNames), "subject", "activity" )
targetData <- subset(data, select=targetNames)

# Part 3
activityLabels <- read.table("./UCI_HAR_Dataset/activity_labels.txt", header = FALSE)

# Part 4
names(targetData) <- gsub("^t", "time", names(targetData))
names(targetData) <- gsub("^f", "frequency", names(targetData))
names(targetData) <- gsub("Acc", "Accelerometer", names(targetData))
names(targetData) <- gsub("Gyro", "Gyroscope", names(targetData))
names(targetData) <- gsub("Mag", "Magnitude", names(targetData))
names(targetData) <- gsub("BodyBody", "Body", names(targetData))

# Part 5
library(dplyr)
byKind <- targetData %>% group_by(subject, activity) 
tidyData <- byKind %>% summarise_each(funs(mean))
write.table(Data2, file = "tidydata.txt",row.name=FALSE)


setwd(original_working_dir)
