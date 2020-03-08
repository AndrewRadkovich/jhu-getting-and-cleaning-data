---
title: "Getting and Cleaning Data Course Project"
output: html_document
---


### main()

This function is the entry point of the whole script;
You need to call this one to start the script.

### downloadDataIfNotExist()

If data was not downloaded before the script will do this;

### runAnalisys()

This functions performs data loading, merging, labeling, measurements extraction and summarization;

### loadSet(paths)

loads train or test set depending on passed parameter `paths`. `paths` parameters should contain 3 attributes: subjectPath, xPath, yPath.
In the script you can refer to a variable `dataPaths` to see all values.

### merge(train, test)

Merges two data sets

### labelActivities(dataset, activitiesPath)

Transforms numeric activity values with appropriate string representation:

- 1   into             WALKING
- 2   into    WALKING_UPSTAIRS
- 3   into  WALKING_DOWNSTAIRS
- 4   into             SITTING
- 5   into            STANDING
- 6   into              LAYING

### extract_measurements(dataset, measurement_patterns)

input:
 - `dataset` - is combined train and test sets
 - `measurement_patterns` - is a list of patterns by which we want to filter features

output:
 - dataset with subset of features
 
### averageBy(measurements)

performs average operation for each activity and subject from given measurements
