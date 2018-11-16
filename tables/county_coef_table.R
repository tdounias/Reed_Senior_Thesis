suppressMessages(library(tidyverse))
library(lubridate)
library(Matrix)
library(lme4)
library(gamm4)
library(pander)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

#DATA
load("all_turnouts.RData")
demographics <- suppressMessages(suppressWarnings(read_csv("colorado_demographic_stats_by_county.csv")))
names(demographics) <- tolower(names(demographics))

model_dt <- turnouts_county_data(turnout_list)

model_dt$dates <- as.factor(model_dt$dates)
model_dt$types <- as.factor(model_dt$types)

model_dt <- filter(model_dt, !is.na(model_dt$reg))

model_dt <- left_join(model_dt, demographics, by = "county")

model_dt$county <- as.factor(model_dt$county)

md_1 <- lm(data = model_dt, turnout ~ county)

md_2 <- lmer(data = model_dt, turnout ~ pct_white + pct_urban + (1|county),
             REML = F)

md_3 <- lmer(data = model_dt, turnout ~ 1 + types +
               pct_urban + pct_white + pct_vbm:types + (1|county), 
             REML = F)

model_dt$dates <-  as.integer(model_dt$dates)

md_4 <- gamm4(turnout ~ 1 + types +
                pct_urban + pct_white + pct_vbm:types + s(dates, k = 7), 
              random =~ (1|county), 
              data = model_dt)

varnames <- c("(Intercept)", "", "Pct_white", "", "Pct_urban", "", "typeGeneral", "", "typeMidterm", "", "typePrimary",
              "", "typeCoordinated*VBM", "", "typeGeneral*VBM", "", "typeMidterm*VBM", "", "typePrimary*VBM", "", 
              "CV MSE", "", "Obs", "", "Groups", "")

md1coef <- c("0.369", "(0.60)", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 
             "0.041", "", "704", "", "64", "")

md2coef <- c("0.492", "(0.045)**", "0.034", "(0.053)", "-0.118", "(0.022)**",  
             "", "", "", "", "", "", "", "", "", "", "", "", "", "", 
             "0.040", "", "704", "", "64", "")

md3coef <- c("0.455", "(0.078)**", "0.033", "(0.050)", "-0.117", "(0.021)**", "0.190", "(0.070)**", "0.252", "(0.068)**", 
             "-0.071", "(0.069)", "-0.001", "(0.067)", "0.151", "(0.073)*", "-0.058", "(0.026)", "-0.089", "(0.028)", 
             "0.004", "", "704", "", "64", "")

md4coef <- c("0.470", "(0.072)**", "0.031", "(0.050)", "-0.119", "(0.021)**", "0.254", "(0.065)**", "0.070", "(0.063)", 
             "-0.170", "(0.062)**", "0.002", "(0.058)", "0.087", "(0.037)", "0.109", "(0.030)*", "-0.003", "(0.027)", 
             "0.006", "", "704", "", "64", "")

table_data <- data.frame(varnames, md1coef, md2coef, md3coef, md4coef)

names(table_data) <- c("Variables", "Model 1", "Model 2", "Model 3", "Model 4")
