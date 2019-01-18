##
## 
##

library(tidyverse)
library(lubridate)
library(knitr)
setwd('/Users/tdounias/Desktop/Reed_Senior_Thesis/Data_and_results/data')

#Read in the data
reg_per_year_sos <- read_csv("2017_CO/VRF_2017/CO_2017_VRF_full.csv", 
                             col_types = cols_only(VOTER_ID = col_guess(), 
                                                   COUNTY = col_guess(),
                                                   REGISTRATION_DATE = col_guess()))

#Make Date variable
reg_per_year_sos$REGISTRATION_DATE <- year(mdy(reg_per_year_sos$REGISTRATION_DATE))

#Make datasets
create_sos_reg <- function(regdate) {
  out <- reg_per_year_sos %>%
    filter(REGISTRATION_DATE <= regdate) %>%
    mutate(count = 1) %>%
    group_by(COUNTY) %>%
    summarize(reg = n()) %>%
    mutate(year = regdate) %>%
    rename(county = COUNTY)
  
  out
}

#TODO Do this with an apply function :)
sos16 <- create_sos_reg("2016")
sos15 <- create_sos_reg("2015")
sos14 <- create_sos_reg("2014")
sos13 <- create_sos_reg("2013")
sos12 <- create_sos_reg("2012")
sos11 <- create_sos_reg("2011")
sos10 <- create_sos_reg("2010")

#Otputs the dataset
sos_full <- rbind(sos16, sos15, sos14, sos13, sos12, sos11, sos10) %>%
  spread(key = year, value = reg)



