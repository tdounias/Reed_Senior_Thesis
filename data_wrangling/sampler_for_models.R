##
## Stratified sampler for individual-level model data.
##

library(tidyverse)
library(lubridate)
library(knitr)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

#Load the data
load("indiv_model_list.RData")

#Make df from list
model_dt <- extract_indiv_model_data(indiv_voter_list)

set.seed(14)
dt_frac <- model_dt %>%
  group_by(COUNTY, MAIL_VOTE, voted) %>%
  summarise(n()/nrow(model_dt))

model_sample <- model_dt %>%
  group_by(MAIL_VOTE, voted, COUNTY) %>%
  mutate(num_rows=n()) %>%
  sample_frac(0.01, weight=num_rows) %>%
  ungroup

#Check fraction of difference
dt_frac_after <- model_sample %>%
  group_by(COUNTY, MAIL_VOTE, voted) %>%
  summarise(n()/nrow(model_sample))

diffs <- (dt_frac[,4] - dt_frac_after[,4])

#The absolute value of differences has a mean of about .1%
mean(abs(diffs[,1]))

#And a standard deviation of .3%
sd(abs(diffs[,1]))

#Check all variables
##Voter ID
length(unique(model_sample$VOTER_ID))

sum(is.na(model_sample$VOTER_ID))


##County
length(unique(model_sample$COUNTY))

sum(is.na(model_sample$COUNTY))


##Party
unique(model_sample$PARTY)

sum(is.na(model_sample$PARTY))


##Gender
unique(model_sample$GENDER)

sum(is.na(model_sample$GENDER))

summary(as.factor(model_sample$GENDER))


##Age
unique(model_sample$AGE)

sum(is.na(model_sample$AGE))


##Election Type
unique(model_sample$ELECTION_TYPE)

sum(is.na(model_sample$ELECTION_TYPE))


##Election Date
unique(model_sample$ELECTION_DATE)

sum(is.na(model_sample$ELECTION_DATE))

summary(as.factor(model_sample$ELECTION_DATE))


##Mail Vote
unique(model_sample$MAIL_VOTE)

sum(is.na(model_sample$MAIL_VOTE))

summary(as.factor(model_sample$MAIL_VOTE))


##Voted and Mail Vote
sum(model_sample$voted == model_sample$MAIL_VOTE)/nrow(model_sample)

model_sample <- na.omit(model_sample)

write.csv(model_sample, "model_indiv_sample.csv")
