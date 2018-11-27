library(tidyverse)
library(ggplot2)
library(knitr)
library(lubridate)
library(stringr)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

load("all_turnouts.RData")

numextract <- function(string){ 
  str_extract(string, "\\-*\\d+\\.*\\d*")
} 

reported <- read_csv("2014GeneralPrecinctTurnout.csv")
calc <- turnout_list[[8]][,c(1,5)]

calc <- mutate(calc, Type = "Calculated")

reported <- reported %>%
  select(4, 10) %>%
  mutate(Type = "Reported")

names(reported)[1:2] <- c("county", "turnout")
reported$turnout <- as.numeric(numextract(reported$turnout))/100

reported <- reported %>%
  group_by(county) %>%
  summarise(turnout = mean(turnout), Type = "Reported")

reported$county <- tolower(reported$county)
calc$county <- tolower(calc$county)

graph_data <- rbind(reported, calc)  


ggplot(graph_data, aes(x = county, y = turnout, col = Type)) +
  geom_point() + 
  theme_bw() +
  ylim(c(0,1)) +
  scale_color_manual(values = c("blue", "red"), name = "Turnout Types") +
  theme(axis.text.x = element_blank()) +
  xlab("County") + 
  ylab("Turnout") +
  ggsave("Calc_vs_rep_turnout.png", width = 5.00, height = 4.20)
