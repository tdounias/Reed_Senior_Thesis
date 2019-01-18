##
## Applies individual mode data function to each date. Creates a list with data for each election.
##

library(readr)
library(tidyverse)
library(lubridate)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

vhist_full <- read_csv("full_voter_history.csv")
vrf_packed <- read_csv("packed_12_16_registration_file.csv")
county <- counties("2016reg2.csv")

#Add 2011, 2010 files for refference
add <- vrf_packed %>%
  filter(FILE_YEAR == "2012")

d1 <- add
d1$FILE_YEAR <- "2011"

d2 <- add
d2$FILE_YEAR <- "2010"

vrf_packed <- rbind(d1, d2, vrf_packed)

dates <- as.Date(c("2010-08-10", "2010-11-02", "2011-11-01", "2012-06-26",
                   "2012-11-06", "2013-11-05", "2014-06-24", "2014-11-04", 
                   "2015-11-03", "2016-06-28", "2016-11-08"))

types <- c("Primary", "Midterm", "Coordinated", "Primary", "General", "Coordinated", 
           "Primary", "Midterm", "Coordinated", "Primary", "General")

indiv_voter_list <- purrr::map2(dates, types, ~ indiv_model_data(vrf_packed, vhist_full, .x, .y))

save(indiv_voter_list, file = "indiv_model_list.RData")
