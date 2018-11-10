library(tidyverse)
library(lubridate)
library(Matrix)
library(lme4)
library(gamm4)
library(lmerTest)
library(boot)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

#DATA
load("all_turnouts.RData")
demographics <- read_csv("colorado_demographic_stats_by_county.csv")
names(demographics) <- tolower(names(demographics))

model_dt <- turnouts_county_data(turnout_list)

model_dt$dates <- as.factor(model_dt$dates)
model_dt$types <- as.factor(model_dt$types)

model_dt <- filter(model_dt, !is.na(model_dt$reg))

model_dt <- left_join(model_dt, demographics, by = "county")

model_dt$county <- as.factor(model_dt$county)

#MODELS

##MODEL 1

md_1 <- glm(data = model_dt, turnout ~ pct_white + pct_urban + county)

summary(md_1)

alias(md_1)

plot(md_1)

md_1_cv <- cv.glm(model_dt, md_1, K=5)

md_1_cv$delta

##MODEL 2

md_2 <- lmer(data = model_dt, turnout ~ pct_white + pct_urban + (1|county))

arm::display(md_2)

summary(md_2)

ranef(md_2)

fixef(md_2)

plot(md_2)

qqnorm(residuals(md_2))

##MODEL 3

md_3 <- lmer(data = model_dt, turnout ~ 1 + types + pct_vbm +
               pct_urban + pct_white + pct_vbm*types + (1|county))

arm::display(md_3)

summary(md_3)

ranef(md_3)

fixef(md_3)

plot(md_3)

qqnorm(residuals(md_3))

#Significant difference by adding extra variables
anova(md_2, md_3)

##MODEL 4

model_dt$dates <-  as.integer(model_dt$dates)

md_4 <- gamm4(turnout ~ 1 + types + types +
               pct_urban + pct_white + pct_vbm*types + s(dates, k = 7, bs = "cr"), 
             random =~ (1|county), 
             data = model_dt)

summary(md_4$mer)

plot(fitted(md_4$mer), residuals(md_4$mer))

qqnorm(residuals(md_4$mer))
