library(tidyverse)
library(lubridate)
library(knitr)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

#Load the data
load("all_turnouts.RData")

graph_data <- turnouts_county_graph(turnout_list)

ggplot(graph_data, aes(x = ELECTION_YEAR, y = turnout, col = county)) +
  facet_wrap(facets = "ELECTION_TYPE") +
  geom_vline(xintercept = 2013, col = "red") +
  geom_hline(yintercept = 1) +
  geom_point(size = .2) +
  geom_line(alpha = .3) +
  labs(title = "Turnout in Colorado Elections by County, 2010-2016", x = "Election Year", y = "Turnout as % of Registered Voters") +
  guides(col=FALSE)
