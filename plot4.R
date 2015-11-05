rm(list=ls())

Sys.setlocale("LC_TIME", locale="USA")

installPackages <- function(x)
{
  new.packages <- x[!(x %in% installed.packages()[,"Package"])]
  if(length(new.packages)){
    install.packages(new.packages)
  } 
  
}

loadLibraries <- function(x){
  lapply(x, library ,character.only = TRUE)
}


getRootDir <- function(){
  OS <- Sys.info()['sysname']
  
  if (grepl(OS, "Windows")){
    return('F:')
  }else if (grepl(OS, "Linux")){ # linux osx must have curl installed
    return('/media/thekeisoes/STORE N GO2')
  }else{
    return('/Volumes/STORE N GO')
  }  
}

getWorkingDirectoryPath <- function(directory){
  OS <- Sys.info()['sysname']
  if (grepl(OS, "Windows")){
    return(file.path(getRootDir(),  gsub('/','\\\\',directory)))
  }else{
    return(file.path(getRootDir(), gsub('\\\\','/',directory)))
  }
}


installPackages(c('sqldf'))
loadLibraries(c('sqldf'))

OS <- Sys.info()['sysname']
workingDirectory <- getWorkingDirectoryPath('Coursera\\Exploratory Data Analysis\\Project1')
setwd(workingDirectory)
url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
# windows environment
 if (grepl(OS, "Windows")){
   download.file(url, file.path(workingDirectory, 'household_power_consumption.zip'))
 }else{ # linux osx must have curl installed
   download.file(url, file.path(workingDirectory, 'household_power_consumption.zip'), method = 'curl') 
 }


#unzip(file.path(workingDirectory, 'household_power_consumption.zip'))
# retrieve data


#dataset<-read.csv('household_power_consumption.txt', sep=';' ,na.strings="NA", stringsAsFactors=FALSE)
dataset <- read.csv.sql('household_power_consumption.txt', 
          sql='select * from file where Date=="2/2/2007" OR Date=="1/2/2007"',
          sep=';' , stringsAsFactors=FALSE)
dataset <- na.omit(dataset)
Date <- as.Date(strptime(dataset$Date, '%d/%m/%Y'))
Time <- as.Date(strptime(dataset$Time, '%X'))

DateTime <- strptime(paste(dataset$Date, dataset$Time, sep = " "), '%d/%m/%Y %H:%M:%S')
DateTime[1]
dataset$Date=Date
dataset$Time=Time
dataset$DateTime=DateTime
str(dataset)




png(filename = "plot4.png", 
    width = 700, height = 700,
    units = "px")

par(mfrow=c(2,2))


plot(dataset$DateTime, 
     as.numeric(dataset$Global_active_power), 
     type="l",
     xlab="",
     ylab = 'Global Active Power (kilowatts)')

plot(dataset$DateTime, 
     as.numeric(dataset$Voltage), 
     type="l",
     xlab="",
     ylab = 'Voltage')


plot(dataset$DateTime, 
     as.numeric(dataset$Sub_metering_1), 
     type="l",
     xlab="",
     ylab = 'Energy sub metering')
lines(dataset$DateTime, as.numeric(dataset$Sub_metering_2), type = 'l', col='red')
lines(dataset$DateTime, as.numeric(dataset$Sub_metering_3), type = 'l', col='blue')
legend("topright",
       bty = "n",
       col = c("black", "red", "blue"),
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lwd = 1)

plot(dataset$DateTime, 
     as.numeric(dataset$Global_reactive_power), 
     type="l",
     xlab="datetime",
     ylab = 'Global_Active_Power')



dev.off()

