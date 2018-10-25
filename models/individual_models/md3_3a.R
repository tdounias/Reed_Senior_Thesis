library(tidyverse)
library(lubridate)
library(Matrix)
library(lme4)
library(gamm4)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

model_sample <- read_csv("model_indiv_sample.csv")
demographics <- read_csv("colorado_demographic_stats_by_county.csv")

model_sample$ELECTION_DATE <- year(model_sample$ELECTION_DATE)

md3 <- glmer(family = "binomial", data = model_sample, 
             voted ~ PCT_URBAN + PCT_WHITE + GENDER + (1|COUNTY) + (1|VOTER_ID))

md_3a <- glmer(family = "binomial", data = model_sample, 
              voted ~ PCT_URBAN + PCT_WHITE + GENDER + (1|COUNTY))

summary(md3)

summary(md_3a)
