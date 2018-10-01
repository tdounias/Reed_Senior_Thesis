library(tidyverse)
library(ggplot2)
library(riggd)

#Read in data using functions

single_year_data <- yearXcounty_reg()
five_year_data <- yearXcounty_reg_SoS()

single_year_data <- single_year_data %>%
  gather(2:8, key = year, value = regSoS)


five_year_data <- five_year_data %>%
  gather(2:8, key = year, value = regsept)


full_reg <- merge(single_year_data, five_year_data, by = c("county", "year"))

full_reg[,3:4] <- log(full_reg[,3:4])

ggplot(full_reg, aes(x = regsept, y = regSoS, col = year)) +
  geom_point(alpha = .5) +
  stat_function(fun = function(x) x, col = "black") +
  labs(x = "Registration from 2012-2016 Files", y = "Registration Only from 2017 File", 
       title = "Comparative Voter Registration Counts", 
       col = "Election Year") +
  geom_smooth(method="lm")
