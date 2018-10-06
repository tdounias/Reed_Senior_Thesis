library(tidyverse)
library(lubridate)
library(Matrix)
library(lme4)
library(arm)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

#Load the data
load("indiv_model_list.RData")

model8_dt <- extract_indiv_model_data(indiv_voter_list)

model8_dt$PARTY <- as.factor(model8_dt$PARTY)
model8_dt$GENDER <- as.factor(model8_dt$GENDER)
model8_dt$ELECTION_TYPE <- as.factor(model8_dt$ELECTION_TYPE)
model8_dt$ELECTION_DATE <- as.factor(year(model8_dt$ELECTION_DATE))


model8 <- glm(data = model8_dt, voted ~ MAIL_VOTE + ELECTION_DATE + ELECTION_TYPE +
             PARTY + GENDER + AGE ,family = "binomial", na.action = na.exclude)
