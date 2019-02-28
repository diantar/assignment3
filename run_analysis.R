library(data.table)
library(dplyr)

## fastest file reading. Reading test and train data + subjects + activity = 6 files in total
train <- fread("X_train.txt")
trainsubj <-fread("subject_train.txt")
trainact <-fread("y_train.txt")

test <- fread("X_test.txt")
testsubj <-fread("subject_test.txt")
testact <-fread("y_test.txt")

## merging data sets
mdata <- bind_rows(train,test)
msubj <- bind_rows(trainsubj,testsubj)
mact <- bind_rows(trainact,testact)

## reading colnames for main merged data set
## for some reason description of features names are duplicated therefore concatenation is required
cn <- fread("features.txt")
cn <- cn %>% mutate(cc = paste(V1,"@",V2))

## assigning features name as column names
colnames(mdata) <- cn$cc

## reading activities description
actl <- fread("activity_labels.txt")
names(actl)<- c("activities","actitivities_description")

## now, once we labeled columns, we can add columns with subjects and activities to mdata
## selecting only stdev and mean for each measurement + subjects and activities
## joining activities description
mdata <- mdata %>% 
    mutate (subjects = msubj$V1, activities = mact$V1)%>% 
    select(names(mdata)[grepl("std", names(mdata))],names(mdata)[grepl("mean", names(mdata))], subjects, activities) %>%
    inner_join(actl)

## cleaning up non-used variables except main one
rm(list=setdiff(ls(), "mdata"))

## now, let's tidy column names a little
names(mdata) <- gsub("-","_",names(mdata))
names(mdata) <- gsub("\\()","",names(mdata))
## here we remove an extra concatenated column number descriptions, because they are not relevent anymore
names(mdata) <- gsub("^.*@ ","",names(mdata))

## kill column with activities, we will further use description only
mdata <- mdata %>% select(-activities)

## creating a tidy data set with summary means
tidydata <- mdata %>% group_by(actitivities_description,subjects) %>% summarise_all(mean)

## exporting tidy data set to csv
write.table(tidydata, "tidydata.txt", row.names=FALSE)
