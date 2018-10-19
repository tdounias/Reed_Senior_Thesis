library(tidyverse)
library(lubridate)
library(Matrix)
library(lme4)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

#Load the data
load("all_turnouts.RData")
demographics <- read_csv("colorado_demographic_stats_by_county.csv")
names(demographics) <- tolower(names(demographics))

model_dt <- turnouts_county_data(turnout_list)

model_dt$dates <- as.factor(model_dt$dates)
model_dt$types <- as.factor(model_dt$types)

model_dt <- filter(model_dt, !is.na(model_dt$reg))

model_dt <- left_join(model_dt, demographics, by = "county")

model_dt$county <- as.factor(model_dt$county)

#######################
##Mixed Effects Model##
#######################

md_1 <- lmer(data = model_dt, turnout ~ 1 + dates + types + pct_vbm +
       pct_urban + pct_white + pct_vbm*types + (1 | county))

arm::display(md_1)

#Check for linear dependence
md_1_check <-  lm(data = model_dt, turnout ~ 1 + dates + types + pct_vbm +
                      pct_urban + pct_white + pct_vbm*types + county)

summary(md_1_check)
alias(md_1_check)
#It's typesPrimary!

#Check normal diagnostic plots
plot(md_1,type=c("p","smooth")) ## fitted vs residual
plot(md_1,sqrt(abs(resid(.)))~fitted(.) , type=c("p","smooth"))
lattice::qqmath(md_1,id=0.05) ## quantile-quantile

#All these seem fine as well...

#ANOVA 
anova(md_1)

#This shows that the types variable explains a massive amount ofnvariance 
#in comparison to other metrics. Both VBM effects are rather small...

#Let's make a model without vbm as a predictor and compare 
#using a simple chi-square test:

md_2 <- lmer(data = model_dt, turnout ~ 1 + dates + types +
               pct_urban + pct_white + (1 | county))

#Compare
anova(md_1, md_2)

#There is a significant difference between the models. 

#How much do county-level predictors explain?

md_3 <- lmer(data = model_dt, turnout ~ 1 + dates + types + pct_vbm +
            pct_vbm*types + (1 | county))

anova(md_1, md_3)

###########################
##Mixed Effects GAM Model##
###########################

library(gamm4)

model_dt$dates <-  as.integer(model_dt$dates)

md_gam <- gamm4(turnout ~ 1 + types + pct_vbm +
                 pct_urban + pct_white + pct_vbm*types + ns(dates), 
               random =~ (1|county), 
               data = model_dt)

summary(md_gam$mer)

#This runs, but I don't know how to 
#diagnose the model


md_test <- lmer(data = model_dt, turnout ~ pct_urban + pct_white + (1|county) + types  + pct_vbm*types)

arm::display(md_test)

fixef(md_test)
