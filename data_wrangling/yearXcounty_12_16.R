library(readr)
library(tidyverse)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data/CO_12_to_16")
# 
# files <- list.files()
# reg_idx <- grep("reg", files)
# 
# for(i in reg_idx) {
#   read_csv(files[i])
# }

CO_county_names <- counties("2016reg2.csv") %>%
  rename(county = COUNTY)

# read in each year's data and add year col
d1 <- read_csv("2016reg2.csv", 
         col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess()))
d1 <- mutate(d1, year = 2016)

d2 <- read_csv("2015reg2.csv", 
               col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess()))
d2 <- mutate(d2, year = 2015)

d3 <- read_csv("2014reg2.csv", 
               col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess()))
d3 <- mutate(d3, year = 2014)

d4 <- read_csv("2013reg2.csv", 
               col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess()))
d4 <- mutate(d4, year = 2013)

#For 2012, I will extract data for 2011 and 2010 as well
d5 <- read_csv("2012reg2.csv", 
               col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess(), 
                                     REGISTRATION_DATE = col_guess()))

d5$REGISTRATION_DATE <- year(mdy(d5$REGISTRATION_DATE))

#Now to make datasets for 2010, 2011 from the 2012 file
create_reg <- function(regdate) {
  out <- d5 %>%
    filter(REGISTRATION_DATE <= regdate) %>%
    mutate(count = 1) %>%
    group_by(COUNTY) %>%
    summarize(reg = n()) %>%
    rename(county = COUNTY)
  
  out
}

d6 <- create_reg(2010)
d7 <- create_reg(2011)

d5 <- mutate(d5, year = 2012) %>%
  select(-3)

# join data sets
reg_data <- rbind(d1, d2, d3, d4, d5)
rm(d1, d2, d3, d4, d5)
reg_data <- reg_data %>%
  rename(id = VOTER_ID, county = COUNTY)

# form useful data format
yearXcounty <- reg_data %>%
  group_by(year, county) %>%
  summarize(cnt = n())

yearXcounty <- inner_join(yearXcounty, CO_county_names, by = "county")

yearXcounty <- yearXcounty %>%
  spread(key = year, value = cnt)

yearXcounty <- left_join(yearXcounty, d6, by = "county") %>%
  rename("2010" = reg)

yearXcounty <- left_join(yearXcounty, d7, by = "county") %>%
  rename("2011" = reg)

yearXcounty <- yearXcounty[, c(1, 7, 8, 2, 3, 4, 5, 6)]

#There is also a function now that does this!
#It is named yearXcounty_reg
#Read documentation! Make sure to set correct directory
#Before actually using!