source('~/Desktop/NedDocs/R/useful_functions/multiplot.R')

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

## Create the fourth figure
p1 <- ggplot(eda_sub, aes(new_time, Global_active_power)) + 
        geom_line() + ylab("Global Active Power (kilowatts)") + xlab("")
p2 <- ggplot(eda_sub, aes(new_time, Voltage)) + geom_line() + xlab("Datetime") + ylab("Voltage")
p3 <- ggplot(eda_sub, aes(new_time)) + 
        geom_line(aes(y = Sub_metering_1, color = 'Sub_metering_1')) + 
        geom_line(aes(y = Sub_metering_2, color = 'Sub_metering_2')) + 
        geom_line(aes(y = Sub_metering_3, color = 'Sub_metering_3')) + 
        xlab("") + ylab("Energy sub metering") +
        scale_fill_manual(name = "Legend",
                values=c(Sub_metering_1 = "Red", Sub_metering_2 = "Green", Sub_metering_3 = "Blue")) +
        theme(legend.justification=c(1,1), legend.position=c(1,1), legend.title = element_text(size=6), 
              legend.text = element_text(size = 4))
p4 <- ggplot(eda_sub, aes(new_time, Global_reactive_power)) + geom_line() + 
        xlab("Datetime") + ylab("Globa_reactive_power")

## Make the plots
multiplot(p1, p3, p2, p4, cols=2)

dev.copy(png,'plot4.png', width=480, height=480)
dev.off()