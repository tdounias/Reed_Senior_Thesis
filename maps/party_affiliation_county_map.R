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

#Read in data
colorado_pop_stats <- read_csv("data/colorado_demographic_stats_by_county.csv")

party_map <- colorado_pop_stats %>%
  select(2, 9:13) %>%
  mutate(PARTY_LEAN <- (REP - DEM)/TOTAL_REGISTERED, PARTY_MAJ <- (REP - DEM),
         PCT_UAF_OTHER <- (OTHER + UAF)/TOTAL_REGISTERED)

names(party_map)[7:9] <- c("PARTY_LEAN", "PARTY_MAJ", "PCT_UAF_OTHER")

party_map$COUNTY <- tolower(party_map$COUNTY)

party_map <- merge(col, party_map, by.x = "subregion", by.y = "COUNTY")

#Plot of party lean normalized over registered voters
ggplot(party_map, mapping = aes(long, lat, group = group, fill = PARTY_LEAN)) +
  scale_fill_gradient(low = "blue", high = "red") +
  geom_polygon(color = "black") +
  theme(legend.title = element_text(),
        legend.key.width = unit(.5, "in")) +
  labs(fill = "Party Lean (DEM to REP)", "Party Affiliation Lean", 
       title = 
         "Colorado Party Affiliation Map") + 
  theme(panel.grid = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks.y = element_blank())
