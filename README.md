# tidydata
##Course Project - Getting and Cleaning Data

### Read Training Data and check dimensions
<br />Read.table function is used to read 3 text files pertaining to training data - viz. X_train.txt, Y_train.txt and subject_train.txt
<br />Dimensions of each of the dataframes provides an idea of how to combine them to create tidydata
<br />X_train gives observations, subject_train gives volunteer ID and Y_train gives activity ID
<br />trainingdata <- read.table("X_train.txt")
<br />ytrain <- read.table("Y_train.txt")
<br />subjectTrain <- read.table("subject_train.txt")
<br />dim(trainingdata)
<br />dim(ytrain)
<br />dim(subjectTrain)

### Read Test Data and check dimensions
<br />Read.table function is used to read 3 text files pertaining to test data - viz. X_test.txt, Y_test.txt and subject_test.txt
<br />Dimensions of each of the dataframes provides an idea of how to combine them to create tidydata
<br />X_test gives observations, subject_test gives volunteer ID and Y_test gives activity ID
<br />testdata <- read.table("X_test.txt")
<br />ytest <- read.table("Y_test.txt")
<br />subjecttest <- read.table("subject_test.txt")
<br />dim(testdata)
<br />dim(ytest)
<br />dim(subjecttest)

### Read column names from features.txt and activity labels from activity_label.txt
<br />colnames <- read.table("features.txt")
<br />activity <- read.table("activity_labels.txt")

### Name the columns for all data frames
<br />Using names() function, rename the columns for dataframes to have meaningful column names. 
<br />trainingdata and testdata are renamed using the colnames (created from features.txt)
<br />names(subjecttest) <- "subject"
<br />names(subjectTrain) <- "subject"
<br />names(ytest) <- "activityid"
<br />names(ytrain) <- "activityid"
<br />names(trainingdata) <- colnames$V2
<br />names(testdata) <- colnames$V2
<br />names(activity) <- c("activity_id", "activity")

### Step 1 : Merging the training and the test sets to create one data set
<br />Use cbind() to add subject and activityid to trainingdata dataframe
<br />trainingdata <- cbind(subjectTrain, ytrain, trainingdata)
<br />dim(trainingdata)

<br />Use cbind() to add subject and activityid to testdata dataframe
<br />testdata <- cbind(subjecttest, ytest, testdata)
<br />dim(testdata)

<br />Use rbind() to combine the training and test dataframes
<br />completedata <- rbind(trainingdata, testdata)
<br />dim(completedata)

### Step 3: Uses descriptive activity names to name the activities in the data set
<br />While this is actually step 3, I completed this first to get a complete data set with all columns and rows before tidying up the dataset
<br />load the plyr and dplyr libraries
<br />library(plyr)
<br />library(dplyr)
<br /> Use the merge() function to match the activityid in completedata with activity_id of activity dataframe to create a complete data set including the descriptive activity labels
<br />completewithactivity <- merge(completedata, activity, by.x = "activityid", by.y = "activity_id", all = TRUE)

### Step 2 : Extracts only the measurements on the mean and standard deviation for each measurement
<br />create a subset with all columns having mean data. In doing this, I have also considered the meanfreq data 
<br />alldatawithmean <- completewithactivity[grep("mean", names(completewithactivity))]

<br />create a subset with all columns having standard deviation (std) in column name
<br />alldatawithstd <- completewithactivity[grep("std", names(completewithactivity))]

<br />create a subset of the subject column
<br />subject <- completewithactivity[grep("subject", names(completewithactivity))]

<br />create a subset of the activity column
<br />activitylist <- completewithactivity[grep("activity", names(completewithactivity))]

<br /> create a data frame called intermeddata by combining the four subsets above using cbind()
<br />intermeddata <- cbind(subject, activitylist, alldatawithmean, alldatawithstd)

<br /> using the select() function from dplyr remove the unwanted activityid column
<br />intermeddata <- select(intermeddata, -activityid)

### step 4: label the data set with descriptive variable names without -, () and all lower case 
<br />Using the gsub() function, remove all hyphens from the column names in intermeddata dataframe
<br />varnames <- gsub("-","", names(intermeddata),)
<br />further, remove the parantheses from varnames 
<br />varnames <- gsub("\\()","", varnames,)
<br />transform all varnames to lower case
<br />varnames <- tolower(varnames)
<br />rename the columns of intermeddata dataframe with the values of varnames
<br />names(intermeddata) <- varnames

### step 5: From the data set in step 4, creates a second, independent tidy data set with  the average of each variable for each activity and each subject.
<br />sort the intermeddata dataframe by subject and activity and store in prefinaldata dataframe
<br />prefinaldata <- arrange(intermeddata, subject, activity)
<br /> using the ddply() function, with subject and activity as IDs, create mean of each column
<br />tidydata <- ddply(prefinaldata, c("subject", "activity"), numcolwise(mean))

### Write the tidydata as a text file
<br />Using write.table function, create text file tidydata.txt as required
<br />write.table(tidydata, file = "tidydata.txt", row.names = FALSE)
