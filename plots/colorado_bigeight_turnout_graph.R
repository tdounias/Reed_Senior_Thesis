library(tidyverse)
library(lubridate)
library(knitr)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

#Load the data
load("all_turnouts.RData")

graph_data <- turnouts_county_graph(turnout_list) %>%
  filter(county %in% c("Jefferson", "El Paso", "Denver", "Arapahoe", "Adams", "Larimer", "Boulder", "Douglas"))

ggplot(graph_data, aes(x = ELECTION_YEAR, y = turnout, col = county)) +
  facet_wrap(facets = "ELECTION_TYPE") +
  geom_vline(xintercept = 2013, col = "red") +
  geom_hline(yintercept = 1) +
  geom_point(size = .2) +
  geom_line(alpha = .8) +
  labs(title = "Turnout in Colorado Elections for the Largest 8 Counties, 2012-2016", 
       x = "Election Year", y = "Turnout as % of Registered Voters")
