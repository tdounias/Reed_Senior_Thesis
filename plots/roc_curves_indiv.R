library(tidyverse)
library(lubridate)
library(Matrix)
library(lme4)
library(pROC)
library(purrr)
library(gamm4)
library(gam)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

load("indiv_model_list.RData")

model_sample <- read_csv("model_indiv_sample.csv")

model_sample$AGE <- scale(model_sample$AGE)

rocs <- map(model_list, ~get_rocs(.x, model_sample))

models <- c("1", "2", "3a", "4", "5", "5a")

graph_data <- data.frame(1 - rocs[[1]]$sensitivities, rocs[[1]]$specificities, models[1])

names(graph_data) <- c("Sensitivity", "Specificity", "Model")

for(i in 2:6){
  temp <- data.frame(1 - rocs[[i]]$sensitivities, rocs[[i]]$specificities, models[i])
  
  names(temp) <- c("Sensitivity", "Specificity", "Model")
  
  graph_data <- rbind(graph_data, temp)
}

ggplot(graph_data, aes(x = Sensitivity, y = Specificity, col = Model)) +
  geom_line() +
  geom_abline(intercept = 0, slope = 1, alpha = .4, linetype = "twodash") +
  xlab("1 - Sensitivity") +
  scale_color_brewer(palette = 1) +
  theme_bw() +
  annotate("text", x = .65, y = .75, label = "1, 2, 3a") +
  annotate("text", x = .35, y = .75, label = "4") +
  annotate("text", x = .07, y = .75, label = "5, 5a")
 