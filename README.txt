##Introduction
This code was written in February, 2015, as part of Coursera's “Getting and Cleaning Data” course, part of the “Data Science” specialization.

The “run_analysis” script, written in R, was specifically designed to filter down and summarize movement data provided by Smartlab (www.smartlab.ws). The movement data was captured via motion detectors on a “Samsung Galaxy S II” cell phone. Linear and rotational forces were recorded, among others. 

The phones were worn on the waist of 30 participants whom each performed six activities. Data was recorded on a time scale at a 50hz rate. This generated quite a large amount of data (5.9 million data points) that needs to be filtered and summarized to more meaningful results. The simplified data will lend itself to further analysis. Here are links to the data and data description:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 


##Explanation
The “run_analysis” code must be run from the same location as the downloaded data. The script will then:

*Open the “X_Test.txt” and “X_Train.txt” raw data sets, and combine them into one data frame, combining the number of rows. This may take a few minutes.

*Add data from the “features.txt” file, which become column names.

*Create a new, single column for “Activity Code,” which describes the activity performed for each measurement. Import data from “Y_test.txt” and “Y_train.txt” data files.

*Make a new, single column contain information on the subject (participant) who generated the data. Add “Subject_test.txt” and “Subject_train.txt” data. 

This represents all of the data used. The resulting dataframe will be 10299 rows, and 563 columns, including the two new columns. All data is imported in 'test' then 'train' order to maintain row alignment.

*Next, the columns are filtered by a text search. Columns names containing “mean()” or “std()” are pulled out, reducing the number of columns from 563 to 79. “Subject” and “Activity” columns are maintained for 81 total columns.

*To make the data easier to read, digits in the “Activity Code” column are replaced with suitable text descriptors. 1 becomes WALKING, 2 becomes WALKING_UPSTAIRS, 3 becomes WALKING_DOWNSTAIRS, 4 becomes SITTING, 5 becomes STANDING, 6 becomes LAYING. This will make the resulting output easier to read and understand to the human eye.

*There are still 79 columns of motion data. Next we subset the information even further. Most of the data columns are for the X, Y, and Z directions (linear and rotational). The directional data is irrelevant as the subject changes directions and body orientation (turning, sitting, and lying down). Data frequency information was eliminated, along with gravitational forces. “Jerk” data that recorded sudden movements was removed to help simplify the data. The four remaining columns are the average and standard deviation of linear and rotational forces. This is defined in detail in the “results” section. 

*Lastly the rows are summered. The 10299 original data rows are combined to 180 data rows, one row for each participant and activity (30 participants x 6 activities = 180 rows). Data from each participant, performing each activity is averaged to a single value that is placed in the final table. This repeated for each of the four columns, providing an average value for each measurement, for each participant performing for each activity.

The resulting table is written to “Part5Result.txt” in the same directory. This function filtered and summarized the most important data, reducing 5.9 million data points (the input data), down to a more manageable 720. 

Please the notated script for more details.

##Results
The output table “Part5Result.txt” is space separated data table that has six columns and 180 rows. 
Columns:
1) “Subject” identifies the participant who generated the data. The identity of the subjects are not known, so they receive a unique number 1 to 30.
2) “Activity” describes what each subject was doing when the data was generated.
3) "Avg_Body_Acc" which is the average (mean) of all linear motion data. 
4) "STD_Body_Acc" which measures the standard deviation of all linear motion data.
5) "Avg_Body_Gyro", which measures the average (mean) of all rotation forces. 
6) "STD_Body_Gyro" which measures standard deviation of rotational forces. 

 

