# Read Training Data and check dimensions
trainingdata <- read.table("X_train.txt")
ytrain <- read.table("Y_train.txt")
subjectTrain <- read.table("subject_train.txt")
dim(trainingdata)
dim(ytrain)
dim(subjectTrain)
#
# Read Test Data and check dimensions
testdata <- read.table("X_test.txt")
ytest <- read.table("Y_test.txt")
subjecttest <- read.table("subject_test.txt")
dim(testdata)
dim(ytest)
dim(subjecttest)
#
# Read column names from features.txt and activity labels from activity_label.txt
colnames <- read.table("features.txt")
activity <- read.table("activity_labels.txt")
#
# Name the columns for all data tables
names(subjecttest) <- "subject"
names(subjectTrain) <- "subject"
names(ytest) <- "activityid"
names(ytrain) <- "activityid"
names(trainingdata) <- colnames$V2
names(testdata) <- colnames$V2
names(activity) <- c("activity_id", "activity")
#
#Step 1 : Merges the training and the test sets to create one data set
trainingdata <- cbind(subjectTrain, ytrain, trainingdata)
dim(trainingdata)
testdata <- cbind(subjecttest, ytest, testdata)
dim(testdata)
completedata <- rbind(trainingdata, testdata)
dim(completedata)
#
# Step 3: Uses descriptive activity names to name the activities in the data set
library(plyr)
library(dplyr)
completewithactivity <- merge(completedata, activity, by.x = "activityid", by.y = "activity_id", all = TRUE)
#
# Step 2 : Extracts only the measurements on the mean and standard deviation for each measurement
alldatawithmean <- completewithactivity[grep("mean", names(completewithactivity))]
alldatawithstd <- completewithactivity[grep("std", names(completewithactivity))]
subject <- completewithactivity[grep("subject", names(completewithactivity))]
activitylist <- completewithactivity[grep("activity", names(completewithactivity))]
intermeddata <- cbind(subject, activitylist, alldatawithmean, alldatawithstd)
intermeddata <- select(intermeddata, -activityid)
#
# step 4: label the data set with descriptive variable names without -, () and all lower case 
varnames <- gsub("-","", names(intermeddata),)
varnames <- gsub("\\()","", varnames,)
varnames <- tolower(varnames)
names(intermeddata) <- varnames
#
# step 5: From the data set in step 4, creates a second, independent tidy data set with  
# the average of each variable for each activity and each subject.
prefinaldata <- arrange(intermeddata, subject, activity)
tidydata <- ddply(prefinaldata, c("subject", "activity"), numcolwise(mean))
#
#Write the tidydata as a text file
write.table(tidydata, file = "tidydata.txt", row.names = FALSE)
