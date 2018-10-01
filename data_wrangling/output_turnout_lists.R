library(tidyverse)
library(lubridate)
library(purrr)
library(reprex)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

vhist_full <- read_csv("full_voter_history.csv")
vrf_packed <- read_csv("packed_12_16_registration_file.csv")
county <- counties("2016reg2.csv")

#Add 2011, 2010 files for refference
d1 <- read_csv("2012reg2.csv", 
               col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess(), 
                                     REGISTRATION_DATE = col_guess()))
d1 <- mutate(d1, FILE_YEAR = 2011)

d1 <- data.frame(1, d1)

d2 <- read_csv("2012reg2.csv", 
               col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess(), 
                                     REGISTRATION_DATE = col_guess()))
d2 <- mutate(d2, FILE_YEAR = 2010)

d2 <- data.frame(1, d2)

vrf_packed <- rbind(d1, d2, vrf_packed)

dates <- as.Date(c("2010-08-10", "2010-11-02", "2011-11-01", "2012-06-26",
                   "2012-11-06", "2013-11-05", "2014-06-24", "2014-11-04", 
                   "2015-11-03", "2016-06-28", "2016-11-08"))

turnout_list <- purrr::map(dates, ~ turnout_calc(vrf_packed, vhist_full, .x, county))

save(turnout_list, file ="all_turnouts.RData")
