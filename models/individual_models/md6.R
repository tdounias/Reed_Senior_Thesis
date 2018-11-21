library(tidyverse)
library(lubridate)
library(Matrix)
library(lme4)
library(gamm4)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

model_sample <- read_csv("model_indiv_sample.csv")

model_sample$ELECTION_DATE <- (year(model_sample$ELECTION_DATE))
model_sample$AGE <- scale(model_sample$AGE)

md_6 <- glmer(data = model_sample, family= "binomial", 
              voted ~ AGE + PARTY + MAIL_VOTE + (1|COUNTY) +
                PCT_WHITE + PCT_URBAN + GENDER + (1|VOTER_ID))
