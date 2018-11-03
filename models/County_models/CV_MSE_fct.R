library(tidyverse)
library(lubridate)
library(Matrix)
library(lme4)
library(gamm4)

#Get folds from data
set.seed(1)
folds <- split(sample(nrow(model_dt), nrow(model_dt),replace=FALSE), as.factor(1:5))

#Model 2
mse <- rep(0,5)

for(i in 1:5){
  md_2.fit <- lmer(data = model_dt, subset = -folds[[i]], turnout ~ pct_white + pct_urban + (1|county))
  
  mse[i] <- mean((model_dt$turnout - predict(md_2.fit, model_dt))[-folds[[i]]]^2)
}

mean(mse)

#Model 3
mse <- rep(0,5)

for(i in 1:5){
  md_3.fit <- lmer(data = model_dt, subset = -folds[[i]], turnout ~ 1 + types + pct_vbm +
                 pct_urban + pct_white + pct_vbm*types + (1|county))
  
  mse[i] <- mean((model_dt$turnout - predict(md_3.fit, model_dt))[-folds[[i]]]^2)
}

mean(mse)

#Model 4
mse <- rep(0,5)

model_dt$dates <-  as.integer(model_dt$dates)

for(i in 1:5){
  md_4.fit <- gamm4(turnout ~ 1 + types + types +
                  pct_urban + pct_white + pct_vbm*types + s(dates, k = 7), 
                random =~ (1|county), 
                data = model_dt, subset = -folds[[i]])
  
  mse[i] <- mean((model_dt$turnout - predict(md_4.fit$gam, model_dt))[-folds[[i]]]^2)
}

mean(mse)
