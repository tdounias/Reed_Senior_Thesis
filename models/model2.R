library(tidyverse)
library(lubridate)
library(gam)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

#Load the data
load("all_turnouts.RData")
demographics <- read_csv("colorado_demographic_stats_by_county.csv")
names(demographics) <- tolower(names(demographics))

#Wrangle/create full dataset
model2_dt <- turnouts_county_data(turnout_list)

model2_dt$dates <- as.factor(model2_dt$dates)
model2_dt$types <- as.factor(model2_dt$types)

model2_dt <- filter(model2_dt, !is.na(model2_dt$reg))

model2_dt <- left_join(model2_dt, demographics, by = "county")

model2_dt$county <- as.factor(model2_dt$county)

#Call lm
model2_lm <- lm(data = model2_dt, turnout ~ dates + types + pct_vbm + county + 
                  pct_urban + pct_white)

summary(model2_lm)

#Don't know why this is happening

plot(model2_lm)

model2_gam <- gam(data = model2_dt, turnout ~ ns(dates) + types + pct_vbm + county + 
                    pct_urban + pct_white)

summary(model2_gam)

coef(model_gam)
