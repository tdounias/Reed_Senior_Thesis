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
pct_white <- read_csv("data/Pct_White.csv")

pct_white <- pct_white %>%
  mutate(PCT_WHITE = WHITE/TOTAL_POP) %>%
  slice(-1)

pct_white$COUNTY <- tolower(pct_white$COUNTY)

col_pct_white <- merge(col, pct_white, by.x = "subregion", by.y = "COUNTY")

ggplot(col_pct_white, mapping = aes(long, lat, group = group, fill = PCT_WHITE)) +
  scale_fill_gradient(low = "dark green", high = "white") +
  geom_polygon(color = "black") +
  theme(legend.title = element_text(),
        legend.key.width = unit(.5, "in")) +
  labs(fill = "% White") + 
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
  ggsave("pct_white_county_map.png", width = 5.00, height = 4.20) 
