# Setup data file path 
cZipDataURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
cZipDataFileName <- "exdata_data_household_power_consumption.zip"
CDataFileName <- "household_power_consumption.txt"

# Download the data file from the given URL
if (!file.exists(cZipDataFileName)){
  download.file(cZipDataURL, cZipDataFileName, method="curl")
}  

# Checking if folder exists
if (!file.exists(CDataFileName)) { 
  unzip(cZipDataFileName)
}

if (!(file.exists(CDataFileName))) {
  print("Required data file is not ready. Please check the downloaded file.")
  return
}

# Read file into dataframe dfDataSet
dfDataSet <- read.csv(CDataFileName, header=TRUE, sep=";")

# Filter the data by date = '2007-2-1' or '2007-2-2'
dfDataSet <- subset(dfDataSet, Date == "1/2/2007" | Date == "2/2/2007")

# Replace "?" value into NA
dfDataSet[dfDataSet == "?"] <- NA

# Transform the measures into numeric
dfDataSet[,3:9] <- lapply(dfDataSet[3:9], as.numeric)

# Add column DataTime
DateTime = strptime(paste(dfDataSet$Date, dfDataSet$Time), "%d/%m/%Y %H:%M:%S")
dfDataSet <- cbind(dfDataSet, DateTime)

# Plot 3
plot(dfDataSet$DateTime, dfDataSet$Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
lines(dfDataSet$DateTime, dfDataSet$Sub_metering_2, col='Red')
lines(dfDataSet$DateTime, dfDataSet$Sub_metering_3, col='Blue')
legend("topright", col=c("black", "red", "blue"), lty=1, lwd=1, legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Output the plot to PNG
dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()
