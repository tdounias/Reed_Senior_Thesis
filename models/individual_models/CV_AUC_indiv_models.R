library(tidyverse)
library(lubridate)
library(Matrix)
library(lme4)
library(pROC)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

#Data 
model_sample <- read_csv("model_indiv_sample.csv")

model_sample$ELECTION_DATE <- (year(model_sample$ELECTION_DATE))
model_sample$AGE <- scale(model_sample$AGE)

#Get folds from data
set.seed(1)
folds <- split(sample(nrow(model_sample), nrow(model_sample),replace=FALSE), as.factor(1:5))

get_true <- function(probs){
  a <- rep(0, length(probs))
  a <- data.frame(ifelse(probs >= .5, 1, 0))
  names(a) <- "probs"
  a
}

#Model 1
auc_1 <- rep(0,5)

for(i in 1:5){
  md_1.fit <- glmer(family = "binomial", data = model_sample, 
                voted ~ (1|COUNTY), subset = -folds[[i]])

  prob <- predict(md_1.fit, model_sample, type = "response")[folds[[i]]]
  
  temp_data <- data.frame(prob, model_sample$voted[folds[[i]]])
  names(temp_data) <- c("prob", "voted")

  g <- roc(voted ~ prob, data = temp_data)
  plot(g)   
  auc_1[i] <- auc(g)
}

mean(auc_1)

#Model 2
auc_2 <- rep(0,5)

for(i in 1:5){
  md_2.fit <- glmer(family = "binomial", data = model_sample, 
                    voted ~ (1|COUNTY) + PCT_WHITE + PCT_URBAN, 
                    subset = -folds[[i]])
  
  prob <- predict(md_2.fit, model_sample, type = "response")[folds[[i]]]
  
  temp_data <- data.frame(prob, model_sample$voted[folds[[i]]])
  names(temp_data) <- c("prob", "voted")
  
  g <- roc(voted ~ prob, data = temp_data)
  plot(g)   
  auc_2[i] <- auc(g)
}

mean(auc_2)

#Model 3
# auc_3 <- rep(0,5)
# 
# for(i in 1:5){
#   md_3.fit <- glmer(family = "binomial", data = model_sample, 
#                voted ~ PCT_URBAN + PCT_WHITE + GENDER + (1|COUNTY) + (1|VOTER_ID),
#                subset = -folds[[i]])
#   
#   prob <- predict(md_3.fit, model_sample, type = "response")[folds[[i]]]
#   
#   temp_data <- data.frame(prob, model_sample$voted[folds[[i]]])
#   names(temp_data) <- c("prob", "voted")
#   
#   g <- roc(voted ~ prob, data = temp_data)
#   plot(g)   
#   auc_3[i] <- auc(g)
#}

#Model 3a
auc_3a <- rep(0,5)

for(i in 1:5){
  md_3a.fit <- glmer(family = "binomial", data = model_sample, 
                 voted ~ PCT_URBAN + PCT_WHITE + GENDER + (1|COUNTY),
                 subset = -folds[[i]])
  
  prob <- predict(md_3a.fit, model_sample, type = "response")[folds[[i]]]
  
  temp_data <- data.frame(prob, model_sample$voted[folds[[i]]])
  names(temp_data) <- c("prob", "voted")
  
  g <- roc(voted ~ prob, data = temp_data)
  plot(g)   
  auc_3a[i] <- auc(g)
}

mean(auc_3a)

#Model 4
auc_4 <- rep(0,5)

for(i in 1:5){
  md_4.fit <- gam(family = "binomial", data = model_sample, 
              voted ~ ns(ELECTION_DATE) + ELECTION_TYPE, 
              subset = -folds[[i]])
  
  prob <- predict(md_4.fit, model_sample, type = "response")[folds[[i]]]
  
  temp_data <- data.frame(prob, model_sample$voted[folds[[i]]])
  names(temp_data) <- c("prob", "voted")
  
  g <- roc(voted ~ prob, data = temp_data)
  plot(g)   
  auc_4[i] <- auc(g)
}

mean(auc_4)

#Model 5
auc_5 <- rep(0,5)

for(i in 1:5){
  md_5.fit <- glm(data = model_sample, family= "binomial", 
             voted ~ AGE + PARTY + MAIL_VOTE, subset = -folds[[i]])

  prob <- predict(md_5.fit, model_sample, type = "response")[folds[[i]]]
  
  temp_data <- data.frame(prob, model_sample$voted[folds[[i]]])
  names(temp_data) <- c("prob", "voted")
  
  g <- roc(voted ~ prob, data = temp_data)
  plot(g)   
  auc_5[i] <- auc(g)
}

mean(auc_5)

#Model 5a
auc_5a <- rep(0,5)

for(i in 1:5){
  md_5a.fit <- glmer(data = model_sample, family= "binomial", 
                voted ~ AGE + PARTY + MAIL_VOTE + (1|COUNTY) +
                  PCT_WHITE + PCT_URBAN + GENDER, subset = -folds[[i]])
  
  prob <- predict(md_5a.fit, model_sample, type = "response")[folds[[i]]]
  
  temp_data <- data.frame(prob, model_sample$voted[folds[[i]]])
  names(temp_data) <- c("prob", "voted")
  
  g <- roc(voted ~ prob, data = temp_data)
  plot(g)   
  auc_5a[i] <- auc(g)
}

mean(auc_5a)
