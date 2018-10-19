library(tidyverse)
library(lubridate)
setwd("/Users/tdounias/Desktop/Reed_Senior_Thesis/Data_and_results")

#Read in data
colorado_pop_stats <- read_csv("data/colorado_demographic_stats_by_county.csv")

#Create dataset for table
pop_table <- colorado_pop_stats %>%
  select(2, 6, 9, 14:16) 

#Create vector with largest counties
big_eight <- c("Jefferson", "El Paso", "Denver", "Arapahoe", "Adams", 
               "Larimer", "Boulder", "Douglas")

#Create vector of all other counties together and merge
other <- data.frame("Other", sum(pop_table$TOTAL_POP[!(pop_table$COUNTY %in% big_eight)]), 
                    sum(pop_table$TOTAL_REGISTERED[!(pop_table$COUNTY %in% big_eight)]), 
                    "---", 
                    sum(pop_table$PCT_OF_STATE_POP[!(pop_table$COUNTY %in% big_eight)]),
                    sum(pop_table$PCT_OF_STATE_REG[!(pop_table$COUNTY %in% big_eight)]))

names(other) <- names(pop_table)

pop_table <- rbind(pop_table, other) %>%
  filter(COUNTY %in% c(big_eight, "Other"))

#Create statewide row
Colorado <- data.frame("Colorado", sum(pop_table$TOTAL_POP), 
                       sum(pop_table$TOTAL_REGISTERED), mean(as.numeric(pop_table$PCT_REGISTERED)), 100, 100)

names(Colorado) <- names(pop_table)

pop_table <- rbind(pop_table, Colorado)

#Largest Metro Areas
pop_table <- data.frame(pop_table, c("Denver-Aurora-Lakewood Metro Area", 
                                     "Denver-Aurora-Lakewood Metro Area", 
                                     "Boulder", "Denver", 
                                     "Denver-Aurora-Lakewood Metro Area", 
                                     "Colorado Springs", 
                                     "Denver-Aurora-Lakewood Metro Area", 
                                     "Fort COllins", "", ""))

#Set final readable names
names(pop_table) <- c("County", "Total Population", "Total Registered Voters", 
                      "County Voter Registration Rate", 
                      "CO Population %", "% of Statewide Registrants", 
                      "Largest Metro Area")

#First table, of statewide population
pandoc.table(select(pop_table, 1, 2, 5, 7))

#Second Table, of Voter registration
kable(select(pop_table, 1, 3, 4, 6))
