library(tidyverse)
library(lubridate)
library(purrr)
library(reprex)

vhist_full <- read_csv("full_voter_history.csv")
vrf_packed <- read_csv("packed_12_16_registration_file.csv")
county <- counties("2016reg2.csv")

tst <- turnout_calc(vrf_packed, vhist_full, as.Date("2014-11-04"), county)

dates <- as.Date(c("2014-11-04", "2016-11-08"))

txt <- purrr::map(dates, ~ turnout_calc(vrf_packed, vhist_full, .x, county))
