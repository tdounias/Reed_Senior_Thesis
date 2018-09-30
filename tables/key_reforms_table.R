library(lubridate)
library(knitr)

reform_summary <- data.frame(c("1992", "2008", "2013"), 
                             c("No Excuse Absentee Statewide Implementation", 
                               "Permanent No-Excuse VBM Lists,
                               Option of Full-VBM Elections for Coordinated County Elections", 
                               "Automatic Mail Ballot System Implemented Statewide, 
                               Established Vote Centers"))

names(reform_summary) <- c("Year", "Key Changes")

kable(reform_summary)