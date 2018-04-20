library(tidyverse)

WA.County.VotesCast <- read.csv("~/Thesis/thesis_2018/data/WA-County-VotesCast.csv")

data <- WA.County.VotesCast

#Create dataset for presidential elections

d_Pres <- data %>%
  filter(Year == 1996| Year == 2000| Year == 2004| Year == 2008)

d_Pres$Year <- as.factor(d_Pres$Year)

#Replication of first model for presidential elections

lm.1 <- lm(data = d_Pres, TurnoutPct ~ County + Year + VBMOnly)

summary(lm.1)

#Replication of second model for presidential elections

first_year <- rep(0, length(d_Pres$County))
col <- rep(0, length(d_Pres$County))
d_Pres <- arrange(d_Pres, County, Year)
for(i in 1:length(d_Pres$County)){
  if(d_Pres$VBMOnly[i] == 1 && d_Pres$VBMOnly[i-1] == 0) first_year[i] <- 1
  if(d_Pres$VBMOnly[i] == 1){
    if(first_year[i] == 1){
      ifelse(d_Pres$Year[i] == 2000, col[i] <- d_Pres$AbsenteePct[i-1],
             col[i] <-  (d_Pres$AbsenteePct[i-1] +  d_Pres$AbsenteePct[i-2])/2)
    }
    if(first_year[i] == 0) col[i] <- col[i-1]
  }
  if(d_Pres$County[i] == "Ferry") col[i] <- 1
}

d_Pres <- cbind(d_Pres, col)  
names(d_Pres)[10] <- "PriorAbsenteePct"

lm.2 <- lm(data = d_Pres, TurnoutPct ~ County + Year + VBMOnly + VBMOnly:PriorAbsenteePct)

summary(lm.2)

#Replication of Third Model for presidential elections

terc_dist <- d_Pres$PriorAbsenteePct[d_Pres$PriorAbsenteePct != 0]

terc <-quantile(terc_dist, c(1/3, 2/3))

col3 <- rep(0, length(d_Pres$County))
for(i in 1:length(d_Pres$County)){
  if(col[i] <= terc[1]) col3[i] <- "Lower"
  if(terc[1] < col[i] && col[i] <= terc[2]) col3[i] <- "Middle"
  if(col[i] > terc[2]) col3[i] <- "Upper"
}

d_Pres <- cbind(d_Pres, as.factor(col3))  
names(d_Pres)[11] <- "PriorAbsenteePct_Tercile"

lm.3 <- lm(data = d_Pres, TurnoutPct ~ County + Year + VBMOnly:PriorAbsenteePct_Tercile)

summary(lm.3)

#Replication of Fourth Model for Presidential elections

first_year[first_year == 1] <- "First"
first_year[first_year == 0] <- "Second"
first_year[d_Pres$VBMOnly == 0] <- "NotMail"

first_year <- factor(first_year, levels = c("NotMail", "First", "Second"))

d_Pres <- cbind(d_Pres, first_year)  
names(d_Pres)[12] <- "Novelty"

lm.3 <- lm(data = d_Pres, TurnoutPct ~ County + Year + Novelty)

summary(lm.3)


#Replication of Fifth Model for Presidential Elections
  
rural <- DEC_00_SF1_P002 %>%
  select(3, 4, 5, 7) %>%
  slice(2953:2991) %>%
  mutate("PctRural" = Rural/Total.) %>%
  select(1, 5)

rural$Geography <- as.character(rural$Geography)
rural$Geography <- substr(rural$Geography,1,nchar(rural$Geography)-7) 

names(rural)[1] <- "County"

d_Pres <- merge(d_Pres, rural, by = "County")

lm.5 <- lm(data = d_Pres, TurnoutPct ~ County + Year + VBMOnly + VBMOnly:PctRural)

summary(lm.5)
