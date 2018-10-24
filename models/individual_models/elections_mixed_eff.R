library(tidyverse)
library(lubridate)
library(Matrix)
library(lme4)
library(gam)
library(mgcv)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

model_sample <- read_csv("model_indiv_sample.csv")
demographics <- read_csv("colorado_demographic_stats_by_county.csv")

model_sample$ELECTION_DATE <- year(model_sample$ELECTION_DATE)

md_4 <- gam(family = "binomial", data = model_sample, 
            voted ~ ns(ELECTION_DATE) + ELECTION_TYPE)

summary.gam(md_4)