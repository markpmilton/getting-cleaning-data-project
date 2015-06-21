# first we read the data into R I have already downloaded it and un zipped it the script for that will be
# on git hub but as the people at jhu did not ask for it you ain't getting it here

path_rf <- file.path("./data" , "UCI HAR Dataset")

dataActTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

dataSubTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

dataFeaTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

# we will now get the stick the data together

dataSubject <- rbind(dataSubTrain, dataSubTest)
dataActivity<- rbind(dataActTrain, dataActTest)
dataFeatures<- rbind(dataFeaTrain, dataFeaTest)


names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

# I now need the standard deviation and means of all the measurements

subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

# lets give the actvities nice names which are descriptive

activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
names(activityLabels) = c("activity","ActivityName")
tidyData    = merge(Data,activityLabels,by='activity',all.x=TRUE)


# now for a nice tidy data set

library(plyr);
Data2<-aggregate(. ~subject + activity, tidyData, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)






