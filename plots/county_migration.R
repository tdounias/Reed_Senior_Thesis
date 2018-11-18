library(tidyverse)
library(ggplot2)
library(knitr)
library(lubridate)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

#Read in data using functions

five_year_data <- yearXcounty_reg()
single_year_data <- yearXcounty_reg_2017()

single_year_data <- single_year_data %>%
  gather(2:8, key = year, value = regSoS)


five_year_data <- five_year_data %>%
  gather(2:8, key = year, value = regsept)


full_reg <- merge(single_year_data, five_year_data, by = c("county", "year"))

full_reg[,3:4] <- log(full_reg[,3:4])

#First Graph
ggplot(full_reg, aes(x = regsept, y = regSoS)) +
  geom_point(alpha = .5, aes(col = year)) +
  geom_smooth(method = "lm", aes(x = regsept, y = regSoS), col = "red") +
  stat_function(fun = function(x) x, col = "black") +
  coord_cartesian(xlim = c(6, 13.5), ylim = c(6, 13.5)) +
  scale_color_brewer(palette = "Blues") +
  theme_bw() + 
  annotate("text", x = 12, y = 10, label = "Data Estimate", col = "red") + 
  annotate("text", x = 8, y = 10, label = "No Difference", col = "black") + 
  labs(x = "Registration from 2012-2016 Files", y = "Registration Only from 2017 File", 
       col = "Election Year") 

#Further Illustration
second_graph <- filter(full_reg, regsept > 11) %>%
  filter(county %in% c("Adams", "Arapahoe", "Boulder", "Denver", 
                       "Douglas", "El Paso")) %>%
  rename("County" = county)

ggplot(second_graph, aes(x = regsept, y = regSoS)) +
  geom_point(alpha = 1, aes(col = year, shape = County)) +
  stat_function(fun = function(x) x, col = "black") +
  scale_color_brewer(palette = "Blues") + 
  theme_bw() +
  coord_cartesian(xlim = c(12, 13.2), ylim = c(12, 13.2)) +
  labs(x = "Registration from 2012-2016 Files", y = "Registration Only from 2017 File", 
       col = "Election Year") 
