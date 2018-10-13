library(tidyverse)
library(lubridate)
library(knitr)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

#Load the data
load("all_turnouts.RData")

graph_data <- turnouts_county_data(turnout_list) %>%
  filter(county %in% c("Jefferson", "El Paso", "Denver", "Arapahoe", "Adams", "Larimer", "Boulder", "Douglas"))

ggplot(graph_data, aes(x = dates, y = turnout, shape = types, col = county)) +
  geom_vline(xintercept = 2013, col = "red", alpha = .3) +
  geom_hline(yintercept = 1) +
  geom_point() +
  scale_color_brewer(palette = "Reds") +
  labs(x = "Election Year", y = "Turnout as % of Registered Voters")
