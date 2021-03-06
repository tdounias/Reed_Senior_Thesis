library(tidyverse)
library(lubridate)
library(knitr)
set.seed(14)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

model_sample <- read_csv("model_indiv_sample.csv")

#Models
library(lme4)
library(arm)

################################
##Models with only county data##
################################

model_dt_county <- model_dt %>%
  filter(ELECTION_TYPE == "General") %>%
  sample_n(50000)

demographics <- read_csv("colorado_demographic_stats_by_county.csv") %>%
  dplyr::select("COUNTY", "PCT_WHITE", "PCT_URBAN")

model_dt_county <- left_join(model_dt_county, demographics, by = "COUNTY")

model_dt_county$COUNTY <- as.factor(model_dt_county$COUNTY)

##Only COUNTY
md_county_1 <- glmer(data = model_sample, family = "binomial",
                     voted ~ (1|COUNTY))

arm::display(md_county_1)

fixef(md_county_1)

#COUNTY plus two demographics
md_county_2 <- glmer(data = model_sample, family = "binomial",
                     voted ~ (1|COUNTY) + PCT_WHITE + PCT_URBAN)

arm::display(md_county_2)

fixef(md_county_2)

#####################################
##Models with individual level data##
#####################################

#Re-select for more IDs
model_dt_ID <- model_dt %>%
  filter(ELECTION_TYPE == "General") %>%
  filter(VOTER_ID %in% sample(unique(model_dt$VOTER_ID), 50000)) %>%
  na.omit()

model_dt_ID$VOTER_ID <- as.factor(model_dt_ID$VOTER_ID)
model_dt_ID$GENDER <- as.factor(model_dt_ID$GENDER)

#Only INDIVIDUAL
md_ID_1 <- glmer(data = model_dt_ID, family = "binomial",
                     voted ~ (1|VOTER_ID))

display(md_ID_1)

coef(md_ID_1)

md_ID_2 <- glmer(data = model_dt_ID, family = "binomial",
                 voted ~ (1|VOTER_ID) + GENDER)

display(md_ID_2)

coef(md_ID_2)

###################################
##Model with election level data##
###################################

#For this section I make another dataset with data across elections
model_dt_election <- model_dt %>%
  sample_n(50000)

model_dt_election$ELECTION_TYPE <- as.factor(model_dt_election$ELECTION_TYPE)
model_dt_election$ELECTION_DATE <- as.factor(year(model_dt_election$ELECTION_DATE))

#Model with election data
md_elect_1 <- glm(data = model_dt_election, family = "binomial",
                    voted ~ ELECTION_TYPE + ELECTION_DATE)

summary(md_elect_1)

#ELECTION_DATE2015 is NA because of complete correlation, see:
alias(md_elect_1)

######################################
##Model with extra ballot-level data##
######################################

#Here I can just use the previous sample of the data
#to run the model as a test.

model_dt_ballot <- model_dt_election
model_dt_ballot <- left_join(model_dt_ballot, demographics, by = "COUNTY")

cols <- c("COUNTY", "PARTY", "GENDER")

model_dt_ballot[cols] <- lapply(model_dt_ballot[cols], factor)

md_ballot_1 <- glm(data = model_dt_ballot, family = "binomial",
                  voted ~ PARTY + GENDER + AGE + AGE^2 + MAIL_VOTE)

summary(md_ballot_1)

alias(md_ballot_1)

######################################
##Models with ballot plus other data##
######################################

#################
##FIRST ATTEMPT##
#################

#For this I will use a more complete dataset
model_full <- model_dt %>%
  filter(COUNTY %in% c("Yuma", "Bent", "Summit", "Washington"), 
         ELECTION_TYPE == "General")

cols <- c("COUNTY", "PARTY", "GENDER")

model_full <- left_join(model_full, demographics, by = "COUNTY")

model_full[cols] <- lapply(model_full[cols], factor)

#First model run
md_ballot_2 <- glmer(data = model_full, family = "binomial",
                   voted ~ PARTY + GENDER + AGE + AGE^2 + MAIL_VOTE + 
                     (1|COUNTY) + PCT_WHITE + PCT_URBAN)

#This asks for re-scalling variables. Let's do that for age:
model_full$AGE <- scale(model_full$AGE)
                            
#Call model again (without square for age)
md_ballot_2 <- glmer(data = model_full, family = "binomial",
                     voted ~ PARTY + GENDER + AGE + AGE^2 + MAIL_VOTE + 
                       (1|COUNTY) + PCT_WHITE + PCT_URBAN)
#This does not eliminate scale warnings...

#Check for singularity
tt <- getME(md_ballot_2,"theta")
ll <- getME(md_ballot_2,"lower")
min(tt[ll==0])
#Is this good?...I don't actually know

#Check gradient calculations
derivs1 <- md_ballot_2@optinfo$derivs
md_grad1 <- with(derivs1,solve(Hessian,gradient))
max(abs(md_grad1))

max(pmin(abs(md_grad1),abs(derivs1$gradient)))
#Based on what I read online, this is within tolerance

#Restart from previous fit to converge
ss <- getME(md_ballot_2,c("theta","fixef"))
m2 <- update(md_ballot_2,start=ss,control=glmerControl(optCtrl=list(maxfun=2e4)))
#Nope

#Issue wit singularity maybe comes from MAIL_VOTE?
#If almost all votes are by mail, then it is basically the response
#Let's try a call without it

md_ballot_3 <- glmer(data = model_full, family = "binomial",
                     voted ~ PARTY + GENDER + AGE + AGE^2 + 
                       (1|COUNTY) + PCT_WHITE + PCT_URBAN)

#How many ballot level observations have the same response and MAIL_VOTE?
sum(model_dt$MAIL_VOTE == model_dt$voted)

#Yup, this is the problem. The data I have are almost all mail votes. 
#This means that MAIL_VOTE CANNOT BE USED TO MODEL INDIVIDUAL TURNOUT


################
##ALTERNATIVES##
################

## Assessing policy change temporaly; before/after 2013 variable + splines

#Build dtst for this model
model_alts <- model_dt %>%
  filter(COUNTY %in% c("Washington", "Yuma", "Summit"))

cols <- c("COUNTY", "PARTY", "GENDER", "VOTER_ID")

model_alts <- left_join(model_alts, demographics, by = "COUNTY")

model_alts[cols] <- lapply(model_alts[cols], factor)

model_alts$ELECTION_TYPE <- as.factor(model_alts$ELECTION_TYPE)
model_alts$ELECTION_DATE <- as.factor(year(model_alts$ELECTION_DATE))
model_alts$AGE <- scale(model_alts$AGE)

library(gamm4)
# 
# md_alt_1 <- gamm4(voted ~ PARTY + GENDER + AGE + AGE^2 + 
#                   PCT_WHITE + PCT_URBAN + ELECTION_TYPE + s(ELECTION_DATE, k = 7),
#                   random =~ (1|COUNTY),
#                   data = model_alts, family = binomial)
#This doesn't actually work...

md_alt_1 <- glmer(data = model_alts, family = "binomial",
                 voted ~ PARTY + GENDER + AGE + AGE^2 + (1|COUNTY) +
                   ELECTION_TYPE + ELECTION_DATE)

arm::display(md_alt_1)

#Check the previous model for linear dependency by running the fixed effects version

md_alt_1_check <- glm(data = model_alts, family = "binomial",
                  voted ~ PARTY + GENDER + AGE + AGE^2 + COUNTY +
                    PCT_WHITE + PCT_URBAN + ELECTION_TYPE + ELECTION_DATE)

alias(md_alt_1_check)

#Conclusion is that county-level predictors are actually incorporated in the coefficients
#For those particular counties in the glm. Also, I don't think there's a way around dropping some 
#Values in the election type/date, other than coding dates as year/month. I'm not sure how to do that though...
