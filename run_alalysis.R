library(dplyr)

main <- function() {
  downloadDataIfNotExist()
  runAnalisys()
}

downloadDataIfNotExist <- function() {
  if (!dir.exists("UCI HAR Dataset")) {
    message("No data at the moment")
    destfile <- "dataset.zip"
    url <-
      "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url = url,
                  destfile = destfile,
                  quiet = FALSE)
    unzip(destfile)
    message("Data was downloaded")
  } else {
    message("Data has been downloaded already")
  }
}

dataPaths <- list(
  featuresPath = "./UCI HAR Dataset/features.txt",
  activitiesPath = "./UCI HAR Dataset/activity_labels.txt",
  train = list(
    subjectPath = "./UCI HAR Dataset/train/subject_train.txt",
    xPath = "./UCI HAR Dataset/train/X_train.txt",
    yPath = "./UCI HAR Dataset/train/y_train.txt"
  ),
  test = list(
    subjectPath = "./UCI HAR Dataset/test/subject_test.txt",
    xPath = "./UCI HAR Dataset/test/X_test.txt",
    yPath = "./UCI HAR Dataset/test/y_test.txt"
  )
)

runAnalisys <- function() {
  train <- loadSet(dataPaths$train)
  test <- loadSet(dataPaths$test)
  mergedData <- merge(train, test)
  message("data was merged")
  
  labeledMergedData <- labelActivities(mergedData, dataPaths$activitiesPath)
  message(dim(labeledMergedData))
  message("activities were labeled")
  
  measurements <- extract_measurements(labeledMergedData, c("mean", "std"))
  message("measurements were extracted")
  avg_measurements <- averageBy(measurements)
  write(avg_measurements)
}

loadSet <- function(paths) {
  subject <- read.table(paths$subjectPath)
  x <- read.table(paths$xPath)
  y <- read.table(paths$yPath)
  return(cbind(subject, x, y))
}

merge <- function(trainData, testData) {
  features <- read.table("./UCI HAR Dataset/features.txt")
  variable_names <- c("subject", as.character(features[, 2]), "activity")
  mergedData <- rbind(trainData, testData)
  names(mergedData) <- variable_names
  return(mergedData)
}

labelActivities <- function(dataset, activitiesPath) {
  activities <- read.table(activitiesPath)
  activities[, 2] <- as.character(activities[, 2])
  for (i in 1:6) {
    dataset$activity <- gsub(i, activities[i, 2], dataset$activity)
  }
  return(dataset)
}

extract_measurements <- function(dataset, measurement_patterns) {
  pattern <- paste(measurement_patterns, collapse = "|")
  column_indexes <- grep(pattern, names(dataset))
  return(dataset[, c(1, column_indexes, 563)])
}

averageBy <- function(measurements) {
  summarized <- measurements %>%
    group_by(activity, subject) %>%
    summarise_all(mean)
  return(summarized)
}

write <- function(data) {
  write.table(data, './tidy_dataset.txt', row.names=FALSE)
}
