library(tidyverse)
library(lubridate)
library(knitr)
setwd('/Users/tdounias/Desktop/Reed_Senior_Thesis/Data_and_results/data')

#Data from 12-16 coded as "sept == september" data
#Previous data coded as "sos == secretary of state" data

#Read in the data
reg_per_year_sept <- read_csv("CO_12_to_16/County_Reg_Per_Year.csv")

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
    group_by(COUNTY) %>%
    mutate(count = 1) %>%
    summarize(sum(count))
  
  out
}



sos16 <- create_sos_reg("2016")
sos15 <- create_sos_reg("2015")
sos14 <- create_sos_reg("2014")
sos13 <- create_sos_reg("2013")
sos12 <- create_sos_reg("2012")
sos11 <- create_sos_reg("2011")
sos10 <- create_sos_reg("2010")

sos_full <- merge(sos16, sos15, sos14, sos13, sos12, sos11, sos10, by = COUNTY)


##Need to make ~BIG FILE~ with all of these in it for ggplot to work. 
##Read up on purrr and then do so!
