library(readr)
library(tidyverse)
library(lubridate)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

var_table <- function(regfile, var_location, var_name) {
  
  #Select relevant information from voter reg files
  registrants <- regfile %>%
    select("VOTER_ID", var_location, "FILE_YEAR")
  
  #Rename variable of importance
  names(registrants)[2] <- "IMP_DATA"
  
  #Replace NA values with "NO_DATA", so it's clearly discernible
  #When the individual was not registered
  registrants[is.na(registrants[,2]),2] <- "NO_DATA"
  
  #Initialize with 2016 data
  var_table_out <- registrants %>%
    filter(FILE_YEAR == "2016") %>%
    rename(dt2016 = IMP_DATA) %>%
    select(1:2)
  
  #Add 2015 data
  file15 <- registrants %>%
    filter(FILE_YEAR == "2015") %>%
    select(-FILE_YEAR)
  
  var_table_out <- left_join(var_table_out, file15, by = "VOTER_ID")
  
  dropped15 <- data.frame(file15[!(file15$VOTER_ID %in% var_table_out$VOTER_ID),], NA)
  dropped15 <- dropped15[,c(1, 3, 2)]
  names(dropped15)[2] <- "dt2016"
  var_table_out <- rbind(var_table_out, dropped15)
  names(var_table_out)[3] <- "dt2015"
  
  #Add 2014 data
  file14 <- registrants %>%
    filter(FILE_YEAR == "2014") %>%
    select(-FILE_YEAR)
  
  var_table_out <- left_join(var_table_out, file14, by = "VOTER_ID")
  
  dropped14 <- data.frame(file14[!(file14$VOTER_ID %in% var_table_out$VOTER_ID),], NA, NA)
  dropped14 <- dropped14[,c(1, 3, 4, 2)]
  names(dropped14)[2:3] <- c("dt2016", "dt2015")
  var_table_out <- rbind(var_table_out, dropped14)
  names(var_table_out)[4] <- "dt2014"
 
  #Add 2013 data 
  file13 <- registrants %>%
    filter(FILE_YEAR == "2013") %>%
    select(-FILE_YEAR)
  
  var_table_out <- left_join(var_table_out, file13, by = "VOTER_ID")
  
  dropped13 <- data.frame(file13[!(file13$VOTER_ID %in% var_table_out$VOTER_ID),], NA, NA, NA)
  dropped13 <- dropped13[,c(1, 3, 4, 5, 2)]
  names(dropped13)[2:4] <- c("dt2016", "dt2015", "dt2014")
  var_table_out <- rbind(var_table_out, dropped13)
  names(var_table_out)[5] <- "dt2013"
  
  #Add 2012 data
  file12 <- registrants %>%
    filter(FILE_YEAR == "2012") %>%
    select(-FILE_YEAR)
  
  var_table_out <- left_join(var_table_out, file12, by = "VOTER_ID")
  
  dropped12 <- data.frame(file12[!(file12$VOTER_ID %in% var_table_out$VOTER_ID),], NA, NA, NA, NA)
  dropped12 <- dropped12[,c(1, 3, 4, 5, 6, 2)]
  names(dropped12)[2:5] <- c("dt2016", "dt2015", "dt2014", "dt2013")
  var_table_out <- rbind(var_table_out, dropped12)
  names(var_table_out)[6] <- "dt2012"
  
  names(var_table_out)[2:6] <- paste(var_name, 16:12, sep = "")
  
  var_table_out
}

