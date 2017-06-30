library(reshape2)
library(dplyr)
library(ggplot2)
library(lubridate)

## Read the data
setwd('~/Desktop/NedDocs/R/exdata_plotting1_data')
eda <- read.csv('household_power_consumption.txt', sep = ';')

## Filter for the right dates
eda[,1] <- as.character(eda[,1])
eda[,1] <- dmy(eda[,1])
eda_sub <- filter(eda, Date >= "2007-02-01", Date <= "2007-02-02")

## Convert to character columns
eda_sub[,3:9] <- lapply(eda_sub[,3:9], function(x) as.numeric(as.character(x)))

## Combine date and time into one column
eda_sub$new_time <- ymd_hms(paste(eda_sub$Date, eda_sub$Time))
eda_sub$weekday <- weekdays(eda_sub$new_time)

## Create the second figure
ggplot(eda_sub, aes(new_time, Global_active_power)) + 
        geom_line() + ylab("Global Active Power (kilowatts)") + xlab("")

dev.copy(png,'plot2.png', width=480, height=480)
dev.off()