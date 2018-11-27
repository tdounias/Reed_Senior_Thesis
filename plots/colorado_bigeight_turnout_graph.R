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

ggplot(graph_data, aes(x = dates, y = turnout, col = Type)) +
  geom_vline(xintercept = 2013, col = "grey", lty = 2) +
  geom_point() +
  annotate("text", x = 2013, y = .2, label = "2013 Reform", size = 3, col = "grey") +
  scale_color_manual(values = c("#00ccff", "#000066", "#0066ff", "#0033ff")) +
  theme_bw() +
  labs(x = "Election Year", y = "Turnout as % of Registered Voters") +
  ggsave("colorado_bigeight_turnout_graph.png", width = 5.00, height = 4.20)
