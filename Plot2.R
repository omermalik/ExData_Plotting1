file.name <- "./household_power_consumption.txt"
url       <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zip.file  <- "./data.zip"

# Check if the data is downloaded and download when applicable
if (!file.exists("./household_power_consumption.txt")) {
    download.file(url, destfile = zip.file)
    unzip(zip.file)
    file.remove(zip.file)
}

# Reading the file
library(data.table)
DT <- fread(file.name,
            sep = ";",
            header = TRUE,
            colClasses = rep("character",9))

# Convert "?" in NAs
DT[DT == "?"] <- NA

# Selecting adequate lines
DT$Date <- as.Date(DT$Date, format = "%d/%m/%Y")
DT <- DT[DT$Date >= as.Date("2007-02-01") & DT$Date <= as.Date("2007-02-02"),]

# Joining day and time to create a new posix date
DT$posix <- as.POSIXct(strptime(paste(DT$Date, DT$Time, sep = " "),
                                format = "%Y-%m-%d %H:%M:%S"))

# Convert column that we will use to correct class
DT$Global_active_power <- as.numeric(DT$Global_active_power)

# Do the graph
png(file = "plot2.png", width = 480, height = 480, units = "px")
with(DT,
     plot(posix,
          Global_active_power,
          type = "l",
          xlab = "",
          ylab = "Global Active Power (kilowatts)"))
dev.off() # Close the png file device