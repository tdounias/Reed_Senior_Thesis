library(tidyverse)
library(lubridate)
library(knitr)
library(plotly)
library(maps)
library(knitr)
library(xtable)
library(mapproj)
library(RColorBrewer)
setwd("/Users/tdounias/Desktop/Reed_Senior_Thesis/Data_and_results")

#Map Data
col <- map_data("county") %>%
  filter(region == 'colorado')

#Read in data
colorado_pop_stats <- read_csv("data/colorado_demographic_stats_by_county.csv")

colorado_pop_stats$COUNTY <- tolower(colorado_pop_stats$COUNTY)

colorado_pop_stats$PCT_REGISTERED[colorado_pop_stats$PCT_REGISTERED >= 1] <- 1

pct_reg_map <- merge(col, colorado_pop_stats, by.x = "subregion", by.y = "COUNTY")

ggplot(pct_reg_map, mapping = aes(long, lat, group = group, fill = PCT_REGISTERED)) +
  scale_fill_gradient(low = "light blue", high = "navy blue") +
  geom_polygon(color = "black") +
  theme(legend.title = element_text(),
        legend.key.width = unit(.5, "in")) +
  labs(fill = "% Registered") + 
  theme(axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        plot.background=element_blank()) +
  ggsave("pct_registered_county_map.png", width = 5.00, height = 4.20) 

