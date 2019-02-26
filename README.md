# This files explain how script is working.

There is a single script called run_analysis.R
Script uses data.table and dplyr packages. Both are very fast, and convenient.

Data used for script is from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## There are several main data files, which are used by script:
* X_test.txt - main test data
* X_train.txt - main train data
* y_test.txt - test activities index 
* y_train.txt - train activities index 
* subject_test.txt - test subjects index
* subject_train.txt - train subjects index
* features.txt - headers for all variables in main test and train data
* activity_labels.txt - labels for activities index

Detailed description of script's work can be found in comments in script itself.

## In general script:
- combines test and train data
- adds activities and subjects index
- joins activities description by activities index
- populates meaningful headers for variables
- tidy column headers in merged data set
- produces separate tidy data set with means of main variables grouped by activities and subjects
- writes tidy data set to csv files
