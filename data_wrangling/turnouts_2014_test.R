##
## Test for turnout calculations for 2014
##

library(readr)
library(tidyverse)
library(lubridate)
setwd("~/Desktop/Reed_Senior_Thesis/Data_and_results/data/CO_12_to_16")

#Read in data
county_reg_ref <- read_csv("County_Reg_Per_Year.csv")

reg14 <- read_csv("2014reg2.csv", 
                  col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess(), 
                                        VOTER_STATUS = col_guess(), 
                                        REGISTRATION_DATE = col_guess()))

reg14$REGISTRATION_DATE <- mdy(reg14$REGISTRATION_DATE)

vhist_full <- read_csv("full_voter_history.csv")
vhist_full$ELECTION_DATE <- mdy(vhist_full$ELECTION_DATE)

#Make base denominators
denoms_14 <- county_reg_ref %>%
  select(2, 5)

#Check for NAs, remove if necessary
if(sum(is.na(denoms_14$COUNTY14)) != 0) 
  denoms_14 <- denoms_14[!(is.na(denoms_14$COUNTY14)), ]

#Matching IDs
denoms_14 <- left_join(denoms_14, reg14, by = "VOTER_ID")

#Filtering dates
denoms_14 <- denoms_14 %>%
  filter(REGISTRATION_DATE <= as.Date("2014-11-04") - 22) %>%
  group_by(COUNTY14) %>%
  summarize(reg = sum(n()))

#I have turnout statistics from the SoS as percentage of
#Registered Voters, so no need for further filtering!

#Make file with votes
nums_14 <- vhist_full %>%
  filter(ELECTION_DATE == as.Date("2014-11-04"))

#Is any of them not in the reg file?
sum(!(nums_14$VOTER_ID %in% reg14$VOTER_ID))

#Investigate!
missing_voters <- nums_14[!(nums_14$VOTER_ID %in% reg14$VOTER_ID),]

#Similarities in PARTY registration...
summary(as.factor(missing_voters$PARTY))
#None appear to have data on their party registration!

#Do they exist in the cumulative county reg file?
sum(!(missing_voters$VOTER_ID %in% county_reg_ref$VOTER_ID))
#All of them do!

head(missing_voters)

###HOWEVER
#Proceeding for now with their inclusion...
nums_14 <- nums_14 %>%
  group_by(COUNTY_NAME) %>%
  summarise(votes = sum(n()))

#Now for a final step, to calculate turnout
turnouts <- merge(nums_14, denoms_14, by.x = "COUNTY_NAME", by.y = "COUNTY14") %>%
  rename(county = COUNTY_NAME) %>%
  mutate(turnout = votes/reg)

ggplot(turnouts, aes(y = votes/reg, x = county)) +
  geom_bar(stat = "identity")

#Now let's compare to reported turnout

#These data taken from Colorado Secretary of State
reported_stats <- read_csv("2014GeneralPrecinctTurnout.csv")

reported_stats <- reported_stats %>%
  group_by(County) %>%
  rename(votes = "Ballots Cast", reg = "Total Voters", 
         county = County) %>%
  summarize(votes_rep = sum(votes), reg_rep = sum(reg), 
            turnout_rep = votes_rep/reg_rep)

reported_stats$county <- tolower(reported_stats$county)

#Merging
turnouts$county <- tolower(turnouts$county)

turnouts <- merge(turnouts, reported_stats, by = "county")

#Some diagnostics
mean(turnouts$turnout - turnouts$turnout_rep)

turnouts <- gather(turnouts, c(4, 7), key= reported, value = turnout)


ggplot(turnouts, aes(x = county, y = turnout, col = reported)) +
  geom_point() +
  ylim(0, 1) +
  theme(axis.text.x=element_blank()) +
  scale_color_manual(labels = c("Calculated", "Reported"), values = c("blue", "red")) +
  labs(x = "Counties", y = "Turnout", color = "Turnout Type")

