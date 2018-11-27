library(tidyverse)
library(lubridate)
library(knitr)
source("~/Desktop/Reed_Senior_Thesis/riggd/R/utils.R")
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data")

#Load the data
load("all_turnouts.RData")

graph_data <- turnouts_county_data(turnout_list) %>%
  group_by(dates) %>%
  summarise(state_wide = sum(reg*turnout*pct_vbm)/sum(reg*turnout))

names(graph_data) <- c("year", "pct_vbm")

before_2010 <- read_csv("2012hist.csv")

before_2010$ELECTION_DATE <- year(mdy(before_2010$ELECTION_DATE))

mail_vote <- c("Absentee Carry", "Absentee Mail", "Mail Ballot", 
               "Mail Ballot - DRE")

before_2010 <- before_2010 %>%
  filter(ELECTION_DATE %in% c(2002:2009)) %>%
  filter(ELECTION_TYPE %in% c("Primary", "General", "Coordinated")) %>%
  mutate(vbm = (VOTING_METHOD %in% mail_vote)) %>%
  group_by(ELECTION_DATE) %>%
  summarise(pct_vbm = sum(vbm)/n())

names(before_2010)[1] <- "year"

graph_data <- rbind(graph_data, before_2010)

ggplot(graph_data, aes(x = year, y = pct_vbm)) +
  geom_vline(xintercept = 2013, col = "grey", lty = 2) +
  geom_vline(xintercept = 2008, col = "grey", lty = 2) +
  geom_point(size = .2) +
  theme_bw() +
  geom_line(alpha = .7, col = "dark blue") +
  labs(x = "Election Year", y = "% of Mail Ballots Over Total Ballots") +
  guides(col=FALSE) +
  ylim(c(0, 1)) +
  geom_rect(xmin =2010,xmax = 2016, ymin = .75, ymax =1, fill = 10, alpha = .01) +
  annotate("text", x = 2013, y = .70, label = "Range of Trustworthy Data") +
  annotate("text", x = 2008, y = .1, col = "dark grey", label = "2008 Reform") +
  annotate("text", x = 2013, y = .1, col = "dark grey", label = "2013 Reform") +
  ggsave("vbm_county_graph.png", width = 5.00, height = 4.20)
