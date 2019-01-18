##
## For each election by election date, outputs turnout rates per county.
##

library(readr)
library(tidyverse)
library(lubridate)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data/CO_12_to_16")

turnout_calc <- function(regfile, histfile, el_date, county){
  
  ##First the denominator
  
  if(typeof(regfile$REGISTRATION_DATE) != "double") regfile$REGISTRATION_DATE <- mdy(regfile$REGISTRATION_DATE)
  
  if(typeof(histfile$ELECTION_DATE) != "double") histfile$ELECTION_DATE <- mdy(histfile$ELECTION_DATE)
  
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
  nums <- histfile %>%
    filter(ELECTION_DATE == el_date)
  
  #Filter out those with no voter registration
  nums <- nums[(nums$VOTER_ID %in% regfile$VOTER_ID), ]
  
  mail_vote <- c("Absentee Carry", "Absentee Mail", "Mail Ballot", 
                 "Mail Ballot - DRE")
  
  nums <- nums %>%
    group_by(COUNTY_NAME) %>%
    summarise(votes = sum(n()), 
              mail_votes = sum(VOTING_METHOD %in% mail_vote))
  
  names(nums)[1] <- "county"
  
  #Now for a final step, to calculate turnout
  turnouts <- merge(nums, denoms, by = "county") %>%
    mutate(turnout = votes/reg, 
           pct_vbm = mail_votes/votes)
  
  turnouts
}

