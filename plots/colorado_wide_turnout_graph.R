library(tidyverse)
library(lubridate)
library(knitr)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

#Load the data
load("all_turnouts.RData")

graph_data <- turnouts_county_data(turnout_list) %>%
  group_by(dates, types) %>%
  summarize(turnout = mean(turnout))

#Graph
ggplot(graph_data, aes(x = dates, y = turnout, col = types)) +
  scale_color_manual(values = c("#2F9395", "Dark Orange", "dark blue", "dark green", "red")) +
  geom_vline(xintercept = 2013, col = "red") +
  geom_hline(yintercept = 1) +
  geom_line() +
  geom_point(size = .9) +
  labs(x = "Election Year", y = "Turnout as % of Registared Voters", col = "Election Type") +
  theme_minimal()
