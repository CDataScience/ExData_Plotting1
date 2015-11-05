rm(list=ls())



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
# if (grepl(OS, "Windows")){
#   download.file(url, file.path(workingDirectory, 'household_power_consumption.zip'))
# }else{ # linux osx must have curl installed
#   download.file(url, file.path(workingDirectory, 'household_power_consumption.zip'), method = 'curl') 
# }


#unzip(file.path(workingDirectory, 'household_power_consumption.zip'))
# retrieve data


#dataset<-read.csv('household_power_consumption.txt', sep=';' ,na.strings="NA", stringsAsFactors=FALSE)
dataset <- read.csv.sql('household_power_consumption.txt', 
          sql='select * from file where Date=="2/2/2007" OR Date=="1/2/2007"',
          sep=';' , stringsAsFactors=FALSE)
dataset <- na.omit(dataset)
dataset$Date <- as.Date(dataset$Date)





str(dataset)

png('plot1.png' ,   width = 500, height = 500,
    units = "px")
hist(as.numeric(dataset$Global_active_power), 
     main="Global Active Power", 
     xlab='Global Active Power (kilowatts)',
     col = 'red')
dev.off()

