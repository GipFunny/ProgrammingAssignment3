#########################################################################################
# Load and combine testing and training data.
# Final output should be a tidy data set of averages for each subject and activity.
#

#----------------------------------------------------------------------------------------
## Sample use

# tidyXYZ <- loadTidyXYZ()
# write.csv(tidyXYZ, "tidyXYZ.csv")

# summaryXYZ <- summarizeXYZ(tidyXYZ)
# write.csv(summaryXYZ, "summaryXYZ.csv")
#----------------------------------------------------------------------------------------

library(dplyr)
library(tidyr)
library(reshape2)
library(data.table)

#------------------------------------------
# Common data must be loaded first

# Var names
features        <- read.delim("assignment/data/features.txt", sep=' ', header=FALSE)
# Activity names
activity_labels   <- read.delim("assignment/data/activity_labels.txt", sep=' ', header=FALSE)
# Subjects
rawsubject_test <- read.fwf("assignment/data/test/subject_test.txt", widths=c(8))
rawsubject_train <- read.fwf("assignment/data/train/subject_train.txt", widths=c(8))


#########################################################################################
# Helper function to load data from three files
loadXY <- function(x_file, y_file, dfSubject){

    ## Raw Test data for X
    x_raw <- read.fwf(x_file, widths=c(17, rep(16,560)))
    
    ## Select the columns with mean or standard deviation variables
    x_data <- select(x_raw, grep("((mean|std)..-[X,Y,Z])$", features$V2))
    
    ## Set the names
    names(x_data) <- features[grepl("((mean|std)..-[X,Y,Z])$", features$V2),2]

    ## Raw Test Data for Y
    y_raw <- read.fwf(y_file, widths=c(1))
    
    ## Y now has the labels
    y_data <- merge(y_raw, activity_labels, by.x="V1", by.y="V1")
    names(y_data) <- c("activitycode", "activity")
    
    ## Add the subject to Y
    y_data <- cbind(dfSubject$V1, y_data)
    colnames(y_data)[names(y_data) == "dfSubject$V1"] <- "subject"

    ## Column bind the data
    cbind(y_data, x_data)
}

#########################################################################################
# Load the data into a tidy set
loadTidyXYZ <- function() {
    
    #------------------------------------------
    # Load the test and train data
    xy_data_test <- loadXY("assignment/data/test/X_test.txt", "assignment/data/test/Y_test.txt", rawsubject_test)
    
    xy_data_train <- loadXY("assignment/data/train/X_train.txt", "assignment/data/train/Y_train.txt", rawsubject_train)
    
    #------------------------------------------
    # Row bind into one set
    xy_data <- rbind(xy_data_test, xy_data_train) %>%
        # Rename and split columns
        gather(4:51, key="sensor", value="value", na.rm=TRUE) %>%
        # Return X Y Z to variables
        separate(sensor, into=c("sensor", "func", "axis"))
    
    # set to lowercase values (x, y, z)
    xy_data$axis <- tolower(xy_data$axis)
    
    #------------------------------------------
    # Change the data from wide to tall
    
    xyz_tall <- dcast(as.data.table(xy_data), ...~axis, value.var="value", fun.aggregate=mean)
    
    xyz_tall <- separate(xyz_tall, sensor, into=c("readtype", "sensor"), sep=1)
    xyz_tall <- separate(xyz_tall, sensor, into=c("sensor", "jerk"), sep="Jerk$", extra="merge", fill="right")
    
    # Jerk is a logical variable
    xyz_tall$jerk <- !is.na(xyz_tall$jerk)
    xyz_tall$jerk <- as.logical(xyz_tall$jerk)
    
    # Easier to split these values if we just rename them
    xyz_tall$sensor[xyz_tall$sensor == "BodyAcc"] <- "body_acc"
    xyz_tall$sensor[xyz_tall$sensor == "BodyGyro"] <- "body_gyro"
    xyz_tall$sensor[xyz_tall$sensor == "GravityGyro"] <- "gravity_gyro"
    xyz_tall$sensor[xyz_tall$sensor == "GravityAcc"] <- "gravity_acc"
    
    # Done
    xyz_tall <- xyz_tall %>%
        separate(sensor, into=c("motion", "sensor")) %>%
        select(-activitycode)
    
    # Disambiguate
    xyz_tall$readtype[xyz_tall$readtype == "f"] <- "frequency"
    xyz_tall$readtype[xyz_tall$readtype == "t"] <- "time"
    
    # Type is logical
    xyz_tall$activity <- tolower(xyz_tall$activity)
    
    invisible(xyz_tall)
}

#########################################################################################
# Create the summary
summarizeXYZ <- function(xyz) {
    # Create the summary and return    
    xyz %>% group_by(subject, activity, sensor, func) %>%
        summarize(x=mean(x), y=mean(y), z=mean(z)) %>%
        select(subject, activity, sensor, func, x, y, z) %>%
        arrange(subject, activity, sensor, func)
}


