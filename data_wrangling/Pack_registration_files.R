library(readr)
library(tidyverse)
library(lubridate)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

d1 <- read_csv("2016reg2.csv", 
               col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess(), 
               REGISTRATION_DATE = col_guess(), VOTER_STATUS = col_guess(), 
               PARTY = col_guess(), GENDER = col_guess(), BIRTH_YEAR = col_guess()))
d1 <- mutate(d1, FILE_YEAR = 2016)

d1$REGISTRATION_DATE <- mdy(d1$REGISTRATION_DATE)

d2 <- read_csv("2015reg2.csv", 
               col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess(), 
               REGISTRATION_DATE = col_guess(), VOTER_STATUS = col_guess(), 
               GENDER = col_guess(), BIRTH_YEAR = col_guess()))
d2 <- mutate(d2, FILE_YEAR = 2015, PARTY = "NO_DATA")

d2 <- d2[, c(1, 2, 3, 4, 8, 5, 6, 7)]

d2$REGISTRATION_DATE <- mdy(d2$REGISTRATION_DATE)

d3 <- read_csv("2014reg2.csv", 
               col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess(), 
               REGISTRATION_DATE = col_guess(), VOTER_STATUS = col_guess(), 
               PARTY = col_guess(), GENDER = col_guess(), BIRTH_YEAR = col_guess()))
d3 <- mutate(d3, FILE_YEAR = 2014)

d3$REGISTRATION_DATE <- mdy(d3$REGISTRATION_DATE)

d4 <- read_csv("2013reg2.csv", 
               col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess(), 
               REGISTRATION_DATE = col_guess(), VOTER_STATUS = col_guess(), 
               PARTY = col_guess(), GENDER = col_guess(), BIRTH_YEAR = col_guess()))
d4 <- mutate(d4, FILE_YEAR = 2013)

d4$REGISTRATION_DATE <- mdy(d4$REGISTRATION_DATE)

d5 <- read_csv("2012reg2.csv", 
               col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess(), 
                                     REGISTRATION_DATE = col_guess(), VOTER_STATUS = col_guess(), 
                                     PARTY = col_guess(), GENDER = col_guess(), BIRTH_YEAR = col_guess()))
d5 <- mutate(d5, FILE_YEAR = 2012)

d5$REGISTRATION_DATE <- mdy(d5$REGISTRATION_DATE)

full_reg <- rbind(d1, d2, d3, d4, d5)

full_reg <- full_reg[!(is.na(full_reg$VOTER_ID)), ]

#I will now run some diagnostics and clean up the data

#COUNTY
summary(as.factor(full_reg$COUNTY))
#All good

#REGISTRATION_DATE
summary(as.factor(full_reg$REGISTRATION_DATE))
#All good

#VOTER_STATUS
summary(as.factor(full_reg$VOTER_STATUS))
#There is a bunch of noise, I will just recode this
full_reg$VOTER_STATUS <- fct_lump(full_reg$VOTER_STATUS, n = 2)

#PARTY
summary(as.factor(full_reg$PARTY))
#There is a bunch of noise, I will just recode this
full_reg$PARTY <- fct_lump(full_reg$PARTY, n = 4)

#GENDER
summary(as.factor(full_reg$GENDER))
#There is a bunch of noise, I will just recode this
full_reg$GENDER <- fct_lump(full_reg$GENDER, n = 2)

#BIRTH_YEAR
summary(as.factor(full_reg$BIRTH_YEAR))
#Again, need to remove NAs. By making this a numeric vector, 
#All non-year values will be coerced into NAs! Problem solved.
full_reg$BIRTH_YEAR <- as.numeric(full_reg$BIRTH_YEAR)

#FILE_YEAR
summary(as.factor(full_reg$FILE_YEAR))


remove(d1, d2, d3, d4, d5)

write.csv(full_reg, "packed_12_16_registration_file.csv")

