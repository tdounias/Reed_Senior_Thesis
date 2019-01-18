##
##Creates a dataframe with urban population, population, and white population for Colorado by County##
##


library(tidyverse)
library(lubridate)
setwd("/Users/tdounias/Desktop/Reed_Senior_Thesis/Data_and_results")


#Read in the data
vrf <- read_csv("data/CO_2017_VRF_full.csv", 
                col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess(), 
                                      VOTER_STATUS = col_guess(), 
                                      PARTY = col_guess(), 
                                      REGISTRATION_DATE = col_guess()))

#Create dataframe for total registrants, party
registrants_analysis <- vrf %>%
  mutate(PARTY = ifelse(!(PARTY %in% c("DEM", "REP", "UAF")), "OTHER", PARTY), count = 1) %>%
  group_by(COUNTY) %>%
  summarize(TOTAL_REGISTERED = sum(count), REP = sum(PARTY == "REP"), DEM = sum(PARTY =="DEM"), 
            OTHER = sum(PARTY == "OTHER"), UAF = sum(PARTY == "UAF"))

#Read in stats for white population
pct_white <- read_csv("data/Pct_White.csv")

pct_white <- pct_white %>%
  mutate(PCT_WHITE = WHITE/TOTAL_POP) %>%
  slice(-1)

#Read in stats for urban population
pct_urban <- read_csv("data/Pop_Rurban.csv")

pct_urban <- pct_urban %>%
  mutate(PCT_URBAN = URBAN/TOTAL) %>%
  slice(-1)

#Create single dataset for use in the following tables and maps

colorado_pop_stats <- merge(pct_urban, pct_white, by = "COUNTY")
colorado_pop_stats <- merge(colorado_pop_stats, registrants_analysis, by = "COUNTY")

colorado_pop_stats <- colorado_pop_stats %>%
  select(-2) %>%
  mutate(PCT_REGISTERED = TOTAL_REGISTERED/TOTAL_POP, 
         PCT_OF_STATE_POP = TOTAL_POP/sum(TOTAL_POP), 
         PCT_OF_STATE_REG = TOTAL_REGISTERED/sum(TOTAL_REGISTERED))

write.csv(colorado_pop_stats, "colorado_demographic_stats_by_county.csv")
