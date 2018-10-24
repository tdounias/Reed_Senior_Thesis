library(tidyverse)
library(lubridate)
library(Matrix)
library(lme4)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

model_sample <- read_csv("model_indiv_sample.csv")
demographics <- read_csv("colorado_demographic_stats_by_county.csv")

#Run the model
md_1 <- glmer(family = "binomial", data = model_sample, 
              voted ~ (1|COUNTY) + PCT_URBAN + PCT_WHITE)

#Display results
arm::display(md_1)

#Fixed effects
fixef(md_1)

#########################
##Diagnostics and Plots##
#########################

##12.6 Graphs
county_coefs <- coef(md_1)[[1]][,1]

plot_data <- data.frame(cbind(county_coefs, demographics$PCT_URBAN, demographics$PCT_WHITE), ranef(md_1)[[1]][,1])

names(plot_data) <- c("estimated_coefs", "urban", "white", "coef_se")

##Urban pop graph (12.6)
ggplot(plot_data, aes(x = urban, y = estimated_coefs)) +
  geom_pointrange(aes(ymin= estimated_coefs-coef_se, ymax=estimated_coefs+coef_se), size = .1) +
  geom_abline(slope = fixef(md_1)[2], intercept = fixef(md_1)[1])

##White pop graph (12.6)
ggplot(plot_data, aes(x = white, y = estimated_coefs)) +
  geom_pointrange(aes(ymin= estimated_coefs-coef_se, ymax=estimated_coefs+coef_se), size = .1) +
  geom_abline(slope = fixef(md_1)[3], intercept = fixef(md_1)[1])


##12.5 Graphs
#Put counties into plot_data
# county <- demographics[,2]
# plot_data <- cbind(plot_data, county)
# 
# plot_data2 <- plot_data %>%
#   filter(COUNTY %in% c("Arapahoe", "Denver", "Summit", "Yuma", "Weld", 
#                        "Boulder", "Bent", "Custer")) %>%
  


  
