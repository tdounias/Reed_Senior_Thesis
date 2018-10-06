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
model7_dt <- turnouts_county_data(turnout_list)

model7_dt$dates <- as.factor(model7_dt$dates)
model7_dt$types <- as.factor(model7_dt$types)

model7_dt <- filter(model7_dt, !is.na(model7_dt$reg))

model7_dt <- left_join(model7_dt, demographics, by = "county")

model7_dt$county <- as.factor(model7_dt$county)

model7 <- lmer(data = model7_dt, pct_vbm ~ 1 + dates + types +
                 pct_urban + pct_white + (1 | county))

display(model7)

coef(model7)
