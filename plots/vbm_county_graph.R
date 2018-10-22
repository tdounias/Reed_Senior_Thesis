library(tidyverse)
library(lubridate)
library(knitr)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

#Load the data
load("all_turnouts.RData")

graph_data <- turnouts_county_data(turnout_list) %>%
  group_by(dates) %>%
  summarise(state_wide = sum(reg*turnout*pct_vbm)/sum(reg*turnout))

names(graph_data) <- c("year", "pct_vbm")

ggplot(graph_data, aes(x = year, y = pct_vbm)) +
  geom_vline(xintercept = 2013, col = "red") +
  geom_hline(yintercept = 1) +
  geom_point(size = .2) +
  geom_line(alpha = .7, col = "dark blue") +
  labs(x = "Election Year", y = "% of Mail Ballots Over Total Ballots") +
  guides(col=FALSE)
