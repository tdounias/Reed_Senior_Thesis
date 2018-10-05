library(tidyverse)
library(lubridate)
library(gam)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

#Load the data
load("all_turnouts.RData")

model1_dt <- turnouts_county_data(turnout_list)

model1_dt$county <- as.factor(model1_dt$county)
model1_dt$dates <- as.factor(model1_dt$dates)
model1_dt$types <- as.factor(model1_dt$types)

model1_dt <- filter(model1_dt, !is.na(model1_dt$reg))

model1_lm <- lm(data = model1_dt, turnout ~ dates + types + pct_vbm + county)

summary(model1_lm)

plot(model1_lm)

model1_gam <- gam(data = model1_dt, turnout ~ ns(dates) + types + pct_vbm + county)

summary(model1_gam)

coef(model1_gam)

