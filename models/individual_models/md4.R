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

md_4 <- gam(family = "binomial", data = model_sample, 
            voted ~ ns(ELECTION_DATE) + ELECTION_TYPE)

#Bootstrapped SDs

bs_coefs <- data.frame(0, 0, 0, 0)

for(i in 1:500){
  bs_sample <- model_sample[sample(1:nrow(model_sample), nrow(model_sample), replace = TRUE),]
  md_4.temp <- gam(family = "binomial", data = bs_sample, 
                   voted ~ ns(ELECTION_DATE) + ELECTION_TYPE)
  bs_coefs[i,] <- c(coef(md_4.temp)[1], coef(md_4.temp)[3:5])
}

names(bs_coefs) <- c("(Intercept)", "General", "Midterm", "Primary")

#Standard errors
summarize_all(bs_coefs, sd)

summary(md_4)

coef(md_4)[1]
