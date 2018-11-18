library(tidyverse)
library(lubridate)
library(knitr)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

#Load the data
load("all_turnouts.RData")

graph_data <- turnouts_county_data(turnout_list) %>%
  filter(county %in% c("Jefferson", "El Paso", "Denver", "Arapahoe", "Adams", "Larimer", "Boulder", "Douglas")) %>%
  rename("County" = county, "Type" = types)

ggplot(graph_data, aes(x = dates, y = turnout, shape = Type, col = County)) +
  geom_vline(xintercept = 2013, col = "grey", lty = 2) +
  geom_point() +
  scale_color_brewer(palette = "Reds") +
  annotate("text", x = 2013, y = .2, label = "2013 Reform", size = 3, col = "grey") +
  theme_bw() +
  labs(x = "Election Year", y = "Turnout as % of Registered Voters")
