##
## Function that creates full individual dataset
##

library(readr)
library(tidyverse)
library(lubridate)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

indiv_model_data <- function(regfile, histfile, el_date, el_type){
  #Correct Date formating
  if(typeof(regfile$REGISTRATION_DATE) != "double") regfile$REGISTRATION_DATE <- mdy(regfile$REGISTRATION_DATE)
  
  if(typeof(histfile$ELECTION_DATE) != "double") histfile$ELECTION_DATE <- mdy(histfile$ELECTION_DATE)
  
  regfile_current <- regfile %>%
    filter(FILE_YEAR == year(el_date)) %>%
    filter(REGISTRATION_DATE <= el_date - 22)
  
  ballots <- histfile %>%
    filter(ELECTION_DATE == el_date) %>%
    mutate(voted = 1)
  
  indiv_file <- left_join(regfile_current, ballots, by = "VOTER_ID") %>%
    select(2:3, 5:8, 10, 11, 13, 16)
  
  #Fix NAs in type/date
  indiv_file$ELECTION_TYPE <- el_type
  indiv_file$ELECTION_DATE <- el_date
  
  #Find Age
  indiv_file$BIRTH_YEAR <- as.numeric(year(el_date)) - indiv_file$BIRTH_YEAR
  
  #Rename
  names(indiv_file)[3] <- "ACTIVE"
  names(indiv_file)[4] <- "PARTY"
  names(indiv_file)[5] <- "GENDER"
  names(indiv_file)[6] <- "AGE"
  
  #Make VBM variable
  mail_vote <- c("Absentee Carry", "Absentee Mail", "Mail Ballot", 
                 "Mail Ballot - DRE")
  
  indiv_file$VOTING_METHOD <- ifelse(indiv_file$VOTING_METHOD %in% mail_vote, 1, 0)
  
  names(indiv_file)[9] <- "MAIL_VOTE"
  
  #Make Voted variable
  indiv_file$voted <- ifelse(is.na(indiv_file$voted), 0, 1)

  indiv_file
}

tst <- indiv_model_data(reg_packed, vhist_full, as.Date("2014-11-04"), "Midterm")
