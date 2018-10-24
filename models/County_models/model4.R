library(tidyverse)
library(lubridate)
library(Matrix)
library(lme4)
library(arm)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

#Load the data
load("all_turnouts.RData")
demographics <- read_csv("colorado_demographic_stats_by_county.csv")
names(demographics) <- tolower(names(demographics))

#Wrangle/create full dataset
model4_dt <- turnouts_county_data(turnout_list)

model4_dt$dates <- as.factor(model4_dt$dates)
model4_dt$types <- as.factor(model4_dt$types)

model4_dt <- filter(model4_dt, !is.na(model4_dt$reg))

model4_dt <- left_join(model4_dt, demographics, by = "county")

model4_dt$county <- as.factor(model4_dt$county)

model4 <- lmer(data = model4_dt, turnout ~ 1 + dates + types + pct_vbm +
                 pct_urban + pct_white + (1 | county))

display(model4)

coef(model4)
