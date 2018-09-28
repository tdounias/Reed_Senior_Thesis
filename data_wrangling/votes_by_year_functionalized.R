library(readr)
library(tidyverse)
library(lubridate)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data/CO_12_to_16")

turnout_calc <- function(regfile, histfile, el_date, county){
  
  ##First the denominator
  
  #Filter for relevant year, registrants
  regfile_current <- regfile %>%
    filter(FILE_YEAR == year(el_date)) %>%
    filter(REGISTRATION_DATE <= el_date - 22)
  
  denoms <- create_reg(el_date, regfile_current)
  
  #Make sure no weird county values exist
  names(county) <- "county"
  
  denoms <- left_join(county, denoms, by = "county")
  
  ##Then the numerator
  
  #Take relevant votes
  nums <- vhist_full %>%
    filter(ELECTION_DATE == el_date)
  
  #Filter out those with no voter registration
  nums <- nums[(nums$VOTER_ID %in% regfile$VOTER_ID), ]
  
  nums <- nums %>%
    group_by(COUNTY_NAME) %>%
    summarise(votes = sum(n()))
  
  #Now for a final step, to calculate turnout
  turnouts <- merge(nums, denoms, by = county) %>%
    rename(county = COUNTY_NAME) %>%
    mutate(turnout = votes/reg)
}


