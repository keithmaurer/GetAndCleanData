##Course project for Coursera "Getting and cleaning data." Writen around Feburary 16, 2015.
##Data available from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
##Description is availible: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

##INSTRUCTIONS
##You should create one R script called run_analysis.R that does the following:

##1.Merges the training and the test sets to create one data set.
##2.Extracts only the measurements on the mean and standard deviation for each measurement. 
##3.Uses descriptive activity names to name the activities in the data set
##4.Appropriately labels the data set with descriptive variable names.
##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##First thing, open and extract data into R.
##Program must be run in same location as files.
##Set R dir to locate files. 
	setwd("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")

##Open and store necessary files. 
	acttyp<-read.table("activity_labels.txt")
	features<-read.table("features.txt")	

##Go into the "test" sub folder and pull X, Y, and subject data, then go back.
setwd("test")
	X_test<-read.table("X_test.txt")
	Y_test<-read.table("y_test.txt")
	SubTest<-read.table("subject_test.txt")
setwd("../")

##Go into the "train" sub folder and pull X, Y, and subject data, then go back.
setwd("train")
	X_train<-read.table("X_train.txt")
	Y_train<-read.table("y_train.txt")
	SubTrain<-read.table("subject_train.txt")
setwd("../")

##Go back to home directory so code can be repeated if necessary.
setwd("../../")


##PART 1 Merge all data
##"test" & "train" each have 561 columns (features) each. 
##Since they have no duplicate data, we can simply stack them together.
##"alldata1" is data from part 1.
alldata1<-rbind(X_test,X_train)

##Add column names from "features" file, column 2.
colnames(alldata1)<-features$V2

##Add activity codes to new column in dataset. Column name will be made also. 
##Be sure they are in the right place & order to march up.
alldata1[, "ActivityCode"] <- rbind(Y_test,Y_train)

##Add Subject Data in the same as above.
alldata1[, "Subject"]<-rbind(SubTest, SubTrain)

##The resulting dataframe has all information for the project.

##PART 2 Pull mean and standard deviation columns.
##Search for the word "mean" and "std" in the column names, return column index. 
means<-grep("mean()",names(alldata1))
stdev<-grep("std()",names(alldata1))

##Combine to one string and sort so they appear in nice order
##Bring in Activity and SubjectCodes for next parts of the project.
colpull<-sort(c(means,stdev,562,563))

##Pull these columns from the main data, and bind them to new data frame.
alldata2<-alldata1[,colpull]
##"alldata2" is data from part 2.

##PART 3 Add activity names
##"alldata3" is data from part 3.
alldata3<-alldata2

##Find rows "which" have spcific numbers. Replace "ActivityCode" column with  text.
##Repeat, and replace each activity number with text.
alldata3[which(alldata3$ActivityCode==1),"ActivityCode"]<-"WALKING"
alldata3[which(alldata3$ActivityCode==2),"ActivityCode"]<-"WALKING_UPSTAIRS"
alldata3[which(alldata3$ActivityCode==3),"ActivityCode"]<-"WALKING_DOWNSTAIRS"
alldata3[which(alldata3$ActivityCode==4),"ActivityCode"]<-"SITTING"
alldata3[which(alldata3$ActivityCode==5),"ActivityCode"]<-"STANDING"
alldata3[which(alldata3$ActivityCode==6),"ActivityCode"]<-"LAYING"


##PART 4 Rename Columns with readable names
##There too many columns in the data set. 
##Lets reduce this to just the most important.
alldata4<-alldata3[,c(31,32,37,38,80,81)]

##Rename Columns with sensical names.
colnames(alldata4)<-c("Avg_Body_Acc","STD_Body_Acc",
"Avg_Body_Gyro","STD_Body_Gyro","Activity","Subject")

##PART 5 Make Table with Avg Values by Activity 
##Requires "reshape2" package.
library("reshape2")

##alldata5 is for part 5 DF
alldata5<-alldata4

##Sort rows for nice readable outcome, searchable by non-computers.
alldata5<-alldata5[order(alldata5$Subject,alldata5$Activity),]

##Melt Data into long form, using Activity and Subject as id values.
alldata5melt<-melt(alldata5,
id=c("Subject","Activity"),
measure.vars=c("Avg_Body_Acc","STD_Body_Acc","Avg_Body_Gyro","STD_Body_Gyro")
)

##This part "recasts" the means of data. 
##It groups variables (i.e. measurements) by Subject then Activity (vertical), for every type of measurement(horizontal).
result<-dcast(alldata5melt,Subject+Activity~variable,mean)

##This last line of code exports the last table to a text file "Part5Result.txt".
write.table(result, file = "Part5Result.txt",row.name=FALSE,sep = " ",col.names=TRUE)

