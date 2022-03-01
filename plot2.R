####################
# Setting Language #
####################

# Set locale
Sys.setlocale("LC_TIME", "English")

#############################
# Setting Working Directory #
#############################

# Import library rstudioapi
library(rstudioapi)

# Set working directory to source file location
setwd(dirname(getActiveDocumentContext()$path))

# Check updated working directory
getwd()

####################
# Downloading Data #
####################

# Import library data.table
library(data.table)

# Download Dataset
file_url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if (!file.exists("exdata_data_household_power_consumption.zip")){
    download.file(file_url,"exdata_data_household_power_consumption.zip", mode = "wb")
    unzip("exdata_data_household_power_consumption.zip", exdir = getwd())
}

###############################
# Reading and Converting Data #
###############################

# Reading list of all features
features <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", na.strings="?")

# Formatting date to Type Date
features$Date <- as.Date(features$Date, "%d/%m/%Y")

# Filtering data set from February 1, 2007 to February 2, 2007
features <- subset(features,Date >= as.Date("2007-2-1") & Date <= as.Date("2007-2-2"))

# Removing incomplete observation
features <- features[complete.cases(features),]

# Combining Date and Time columns
dateTime <- paste(features$Date, features$Time)

# Naming the vector
dateTime <- setNames(dateTime, "DateTime")

# Removing Date and Time column
features <- features[ ,!(names(features) %in% c("Date","Time"))]

# Adding DateTime column
features <- cbind(dateTime, features)

# Formatting dateTime Column
features$dateTime <- as.POSIXct(dateTime)

############
# Plotting #
############

# Graphical device PNG
png(filename='plot2.png', width=480, height=480, units='px')

# Plotting line chart
plot(features$dateTime, features$Global_active_power, type="l", ylab="Global Active Power (kilowatts)", col="black", xlab="")

# Closing device
dev.off()
