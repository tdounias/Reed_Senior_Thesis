library(readr)
library(tidyverse)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data/CO_12_to_16")

d1 <- read_csv("2016reg2.csv", 
               col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess(), 
               REGISTRATION_DATE = col_guess()))
d1 <- mutate(d1, FILE_YEAR = 2016)

d1$REGISTRATION_DATE <- mdy(d1$REGISTRATION_DATE)

d2 <- read_csv("2015reg2.csv", 
               col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess(), 
               REGISTRATION_DATE = col_guess()))
d2 <- mutate(d2, FILE_YEAR = 2015)

d2$REGISTRATION_DATE <- mdy(d2$REGISTRATION_DATE)

d3 <- read_csv("2014reg2.csv", 
               col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess(), 
               REGISTRATION_DATE = col_guess()))
d3 <- mutate(d3, FILE_YEAR = 2014)

d3$REGISTRATION_DATE <- mdy(d3$REGISTRATION_DATE)

d4 <- read_csv("2013reg2.csv", 
               col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess(), 
               REGISTRATION_DATE = col_guess()))
d4 <- mutate(d4, FILE_YEAR = 2013)

d4$REGISTRATION_DATE <- mdy(d4$REGISTRATION_DATE)

d5 <- read_csv("2012reg2.csv", 
               col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess(), 
                                     REGISTRATION_DATE = col_guess()))
d5 <- mutate(d5, FILE_YEAR = 2012)

full_reg <- rbind(d1, d2, d3, d4, d5)

remove(d1, d2, d3, d4, d5)

full_reg <- full_reg[!(is.na(full_reg$VOTER_ID)), ]

write.csv(full_reg, "packed_12_16_registration_file.csv")

