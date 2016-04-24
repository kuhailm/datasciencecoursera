run_analysis<- function() {

  
  # Read columnn names (features)
  
  columnNames <- read.table("C:\\Users\\MohammadA\\Documents\\R\\Coursera\\UCI HAR Dataset\\features.txt")
  
  
  
  
  # read train subject IDs
  
  trainSubjectID <- read.table("C:\\Users\\MohammadA\\Documents\\R\\Coursera\\UCI HAR Dataset\\train\\subject_train.txt")
 
  
  ### read train values
  
  train_y <- read.table("C:\\Users\\MohammadA\\Documents\\R\\Coursera\\UCI HAR Dataset\\train\\y_train.txt")
 
  
  ## read train set
  
  trainSet <- read.table("C:\\Users\\MohammadA\\Documents\\R\\Coursera\\UCI HAR Dataset\\train\\x_train.txt")
  #View(trainSet)
  
  # add columns from train_y and trainSubjectID to trainSet
  
  trainSet <- data.frame(trainSubjectID, train_y, trainSet)
  

  
  # read subject test IDs
  
  testID <- read.table("C:\\Users\\MohammadA\\Documents\\R\\Coursera\\UCI HAR Dataset\\test\\subject_test.txt")
  
  
  # read test y
  
  y_test <- read.table("C:\\Users\\MohammadA\\Documents\\R\\Coursera\\UCI HAR Dataset\\test\\y_test.txt")
  
  # read x_test
  
  testSet <- read.table("C:\\Users\\MohammadA\\Documents\\R\\Coursera\\UCI HAR Dataset\\test\\x_test.txt")
  
  # add columns from y_test and testID to testSet
  
  testSet <- data.frame(testID, y_test, testSet)

  
  # union test set and train set
  
  set <- rbind(testSet, trainSet)

  
  # change coumn names to subject ID, activity, and the other column variables
  
  colnames(set) <- c("subjectID", "activity", as.character(columnNames$V2))
  
  
  # get only the columns that have mean and std in their names
  
  subset <- set[,c(1:2, grep("mean|std", colnames(set)))]
  
  
  # change the activity values from 1-6 to meaningful values
  
  subset$activity <- factor(subset$activity,
                            labels=c("walking", "walkingUpstairs",
                                    "walkingDownstairs", "sitting", "standing", "laying"))
  
  
  
  # Reshape data frame to form a new data frame with the average of each variable for each activity and each subject. 
  
  library(reshape2)
  
  # create a melted set with subjectID and activity as ID
  
  mSet <- melt(subset, id.vars=c("subjectID", "activity"))
  View(mSet)
  
  # cast the data set to produce the final three dimensional array
  
  final_set <- dcast(mSet, subjectID + variable ~ activity, mean, margins=FALSE)
  
  
  
  #Write the final, tidy dataset to a text file
  
  write.table(final_set, "final_set.txt")
  View(final_set)

}
