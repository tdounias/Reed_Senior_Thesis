library(tidyverse)
library(lubridate)
library(knitr)
setwd("/Users/tdounias/Desktop/Reed_Senior_Thesis/Data_and_results/data")

reg16 <- read_csv("2016reg2.csv", 
                  col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess()))

county_reg_ref <- data.frame(reg16$VOTER_ID, reg16$COUNTY)

#Test for duplicate IDs
nrow(county_reg_ref) - length(unique(county_reg_ref$reg16.VOTER_ID))

#Rename
names(county_reg_ref) <- c("VOTER_ID", "COUNTY16")

#Next year
reg15 <- read_csv("2015reg2.csv", 
                  col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess()))

#How many IDs exist in the 2015 file that are not in the 2016 file?
sum(!(reg15$VOTER_ID %in% county_reg_ref$VOTER_ID))

#This means that after adding all necessary data from 2016, the length
#of the final df should be:
nrow(county_reg_ref) + 72400

#We add these, and also update counties
county_reg_ref <- left_join(county_reg_ref, reg15, by = "VOTER_ID")

names(county_reg_ref)[3] <- "COUNTY15"

#Now for those that dropped off after 2015
dropped15 <- data.frame(reg15[!(reg15$VOTER_ID %in% county_reg_ref$VOTER_ID),], NA)
dropped15 <- dropped15[,c(1, 3, 2)]
names(dropped15) <- c("VOTER_ID", "COUNTY16", "COUNTY15")

county_reg_ref <- rbind(county_reg_ref, dropped15)

#Note that the number of rows is actually correct!
nrow(county_reg_ref)

reg14 <- read_csv("2014reg2.csv", 
                  col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess()))

#How many IDs exist in the 2015 file that are not in the 2016 OR 2015 file?
sum(!(reg14$VOTER_ID %in% county_reg_ref$VOTER_ID))

#This means that after adding all necessary data from 2014, the length
#of the final df should be:
nrow(county_reg_ref) + 265085

#We add these, and also update counties
county_reg_ref <- left_join(county_reg_ref, reg14, by = "VOTER_ID")

names(county_reg_ref)[4] <- "COUNTY14"

#Now for those that dropped off after 2014
dropped14 <- data.frame(reg14[!(reg14$VOTER_ID %in% county_reg_ref$VOTER_ID),], NA, NA)
dropped14 <- dropped14[,c(1, 3, 4, 2)]
names(dropped14) <- c("VOTER_ID", "COUNTY16", "COUNTY15", "COUNTY14")

county_reg_ref <- rbind(county_reg_ref, dropped14)

#Note that the number of rows is actually correct again!
nrow(county_reg_ref)

#Next year
reg13 <- read_csv("2013reg2.csv", 
                  col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess()))

#How many IDs exist in the 2015 file that are not in the 2016 OR 2015 file?
sum(!(reg13$VOTER_ID %in% county_reg_ref$VOTER_ID))

#This means that after adding all necessary data from 2014, the length
#of the final df should be:
nrow(county_reg_ref) + 96779

#We add these, and also update counties
county_reg_ref <- left_join(county_reg_ref, reg13, by = "VOTER_ID")

names(county_reg_ref)[5] <- "COUNTY13"

#Now for those that dropped off after 2013
dropped13 <- data.frame(reg13[!(reg13$VOTER_ID %in% county_reg_ref$VOTER_ID),], NA, NA, NA)
dropped13 <- dropped13[,c(1, 3, 4, 5, 2)]
names(dropped13) <- c("VOTER_ID", "COUNTY16", "COUNTY15", "COUNTY14", "COUNTY13")

county_reg_ref <- rbind(county_reg_ref, dropped13)

#Note that the number of rows is actually correct again!
nrow(county_reg_ref)

#Last year!
reg12 <- read_csv("2012reg2.csv", 
                  col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess()))

#How many IDs exist in the 2015 file that are not in the 2016 OR 2015 file?
sum(!(reg12$VOTER_ID %in% county_reg_ref$VOTER_ID))

#This means that after adding all necessary data from 2014, the length
#of the final df should be:
nrow(county_reg_ref) + 176260

#We add these, and also update counties
county_reg_ref <- left_join(county_reg_ref, reg12, by = "VOTER_ID")

names(county_reg_ref)[6] <- "COUNTY12"

#Now for those that dropped off after 2012
dropped12 <- data.frame(reg12[!(reg12$VOTER_ID %in% county_reg_ref$VOTER_ID),], NA, NA, NA, NA)
dropped12 <- dropped12[,c(1, 3, 4, 5, 6, 2)]
names(dropped12) <- c("VOTER_ID", "COUNTY16", "COUNTY15", "COUNTY14", "COUNTY13", "COUNTY12")

county_reg_ref <- rbind(county_reg_ref, dropped12)