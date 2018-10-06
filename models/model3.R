library(tidyverse)
library(lubridate)
library(Matrix)
library(lme4)
library(arm)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

#Load the data
load("all_turnouts.RData")

model3_dt <- turnouts_county_data(turnout_list)

model3_dt$county <- as.factor(model3_dt$county)
model3_dt$dates <- as.factor(model3_dt$dates)
model3_dt$types <- as.factor(model3_dt$types)

model3 <- lmer(data = model3_dt, turnout ~ 1 + dates + types + pct_vbm + (1 | county))

display(model3)

coef(model3)
