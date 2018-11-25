library(tidyverse)
library(lubridate)
library(readr)
setwd("/Users/tdounias/Desktop/Reed_Senior_Thesis/Data_and_results/data")

vhist_sample <- read_csv("2016hist.csv")
vrf_sample <- read_csv("2016reg2.csv")

#Sample voter histories
vhist_sample <- vhist_sample %>%
  sample_n(10)

vhist_sample$VOTER_ID <- as.integer(rnorm(10, 1000000, 354345))
vhist_sample$PARTY <- c("REP", "DEM", "UAF", "CDP", "REP", "REP", "REP", 
                        "DEM", "UAF", "DEM")

#Sample voter registration files
vrf_sample <- vrf_sample %>%
  sample_n(10)

vrf_sample$VOTER_ID <- vhist_sample$VOTER_ID
vrf_sample$LAST_NAME <- c("Jefferies", "Simmons", "Jenkins", "Giroux", 
                          "Provorov", "Hoskins", "Nola", "Arrieta", "Butler", "Clement")

vrf_sample <- vrf_sample %>%
  select(1:4, 15, 20:23)

table_sample <- list(vrf_sample, vhist_sample)

save(file = "table_sample.RData", table_sample)
