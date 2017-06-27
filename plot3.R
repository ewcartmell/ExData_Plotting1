Source('~/Desktop/NedDocs/R/useful_functions/multiplot.R')

library(reshape2)
library(dplyr)
library(ggplot2)
library(lubridate)

## Read the data
eda <- read.csv('household_power_consumption.txt', sep = ';')

## Filter for the right dates
eda_sub <- filter(eda, Date >= "2007-02-01", Date <= "2007-02-02")

## Convert to character columns
eda_sub[,3:9] <- lapply(eda_sub[,3:9], function(x) as.numeric(as.character(x)))

## Combine date and time into one column
eda_sub$new_time <- ymd_hms(paste(eda_sub$Date, eda_sub$Time))

## Create the third figure
ggplot(eda_sub, aes(new_time)) + geom_line(aes(y = Sub_metering_1), 
        color = 'gray') + geom_line(aes(y = Sub_metering_2), color = 'red') + 
        geom_line(aes(y = Sub_metering_3), color = 'blue')