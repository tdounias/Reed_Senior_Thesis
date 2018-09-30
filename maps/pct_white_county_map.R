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

#Read in map data
col <- map_data("county") %>%
  filter(region == 'colorado')

#Read in and process racial demographi data
pct_urban <- read_csv("data/Pop_Rurban.csv")

pct_urban <- pct_urban %>%
  mutate(PCT_URBAN = URBAN/TOTAL) %>%
  slice(-1)

pct_white$COUNTY <- tolower(pct_white$COUNTY)

col_pct_white <- merge(col, pct_white, by.x = "subregion", by.y = "COUNTY")

ggplot(col_pct_white, mapping = aes(long, lat, group = group, fill = PCT_WHITE)) +
  scale_fill_gradient(low = "dark green", high = "white") +
  geom_polygon(color = "black") +
  theme(legend.title = element_text(),
        legend.key.width = unit(.5, "in")) +
  labs(fill = "Percentage White", title = "Percentage of White Residents") + 
  theme(panel.grid = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks.y = element_blank())
