#' Get Counties for a State out of Clean Reg Files
#'
#' @param filesource Registration File location
#' @return A character vector of counties
#' @examples
#' counties(reg_colorado_16)

counties <- function(filesource){
  out <- read_csv(filesource, col_types = cols_only(COUNTY = col_guess()))
  unique(out)
}

#' Get total registrants per year per county
#'
#' 
#' @return A dataframe of registrants per year and county, 2012-2016
#' @examples
#' yearXcounty_reg()

yearXcounty_reg <- function(filesource){
  
  CO_county_names <- counties("2016reg2.csv") %>%
    rename(county = COUNTY)
  
  # read in each year's data and add year col
  d1 <- read_csv("2016reg2.csv", 
                 col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess()))
  d1 <- mutate(d1, year = 2016)
  
  d2 <- read_csv("2015reg2.csv", 
                 col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess()))
  d2 <- mutate(d2, year = 2015)
  
  d3 <- read_csv("2014reg2.csv", 
                 col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess()))
  d3 <- mutate(d3, year = 2014)
  
  d4 <- read_csv("2013reg2.csv", 
                 col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess()))
  d4 <- mutate(d4, year = 2013)
  
  #For 2012, I will extract data for 2011 and 2010 as well
  d5 <- read_csv("2012reg2.csv", 
                 col_types = cols_only(VOTER_ID = col_guess(), COUNTY = col_guess(), 
                                       REGISTRATION_DATE = col_guess()))
  
  d5$REGISTRATION_DATE <- year(mdy(d5$REGISTRATION_DATE))
  
  #Now to make datasets for 2010, 2011 from the 2012 file
  create_reg <- function(regdate) {
    out <- d5 %>%
      filter(REGISTRATION_DATE <= regdate) %>%
      mutate(count = 1) %>%
      group_by(COUNTY) %>%
      summarize(reg = n()) %>%
      rename(county = COUNTY)
    
    out
  }
  
  d6 <- create_reg(2010)
  d7 <- create_reg(2011)
  
  d5 <- mutate(d5, year = 2012) %>%
    select(-3)
  
  # join data sets
  reg_data <- rbind(d1, d2, d3, d4, d5)
  rm(d1, d2, d3, d4, d5)
  reg_data <- reg_data %>%
    rename(id = VOTER_ID, county = COUNTY)
  
  # form useful data format
  yearXcounty <- reg_data %>%
    group_by(year, county) %>%
    summarize(cnt = n())
  
  yearXcounty <- inner_join(yearXcounty, CO_county_names, by = "county")
  
  yearXcounty <- yearXcounty %>%
    spread(key = year, value = cnt)
  
  yearXcounty <- left_join(yearXcounty, d6, by = "county") %>%
    rename("2010" = reg)
  
  yearXcounty <- left_join(yearXcounty, d7, by = "county") %>%
    rename("2011" = reg)
  
  yearXcounty <- yearXcounty[, c(1, 7, 8, 2, 3, 4, 5, 6)]
  
  yearXcounty
}

#' Get total registrants per year per county MAY DATA
#'
#' 
#' @return A dataframe of registrants per year and county, 2010-2016 for the MAY DATA
#' @examples
#' yearXcounty_reg_SoS()

yearXcounty_reg_2017 <- function(){
  #Read in the data
  reg_per_year_sos <- read_csv("CO_2017_VRF_full.csv", 
                               col_types = cols_only(VOTER_ID = col_guess(), 
                                                     COUNTY = col_guess(),
                                                     REGISTRATION_DATE = col_guess()))
  
  #Make Date variable
  reg_per_year_sos$REGISTRATION_DATE <- year(mdy(reg_per_year_sos$REGISTRATION_DATE))
  
  #Make datasets
  create_sos_reg <- function(regdate) {
    out <- reg_per_year_sos %>%
      filter(REGISTRATION_DATE <= regdate) %>%
      mutate(count = 1) %>%
      group_by(COUNTY) %>%
      summarize(reg = n()) %>%
      mutate(year = regdate) %>%
      rename(county = COUNTY)
    
    out
  }
  
  #TODO Do this with an apply function :)
  sos16 <- create_sos_reg("2016")
  sos15 <- create_sos_reg("2015")
  sos14 <- create_sos_reg("2014")
  sos13 <- create_sos_reg("2013")
  sos12 <- create_sos_reg("2012")
  sos11 <- create_sos_reg("2011")
  sos10 <- create_sos_reg("2010")
  
  #Otputs the dataset
  sos_full <- rbind(sos16, sos15, sos14, sos13, sos12, sos11, sos10) %>%
    spread(key = year, value = reg)
  
  sos_full
}

#' From a registration file, get registrant totals for a given date
#'
#' 
#' @return A dataframe of registrants per year and county, 2010-2016 for the MAY DATA
#' @examples
#' yearXcounty_reg_SoS()
#' 

create_reg <- function(regdate, regfile) {
  out <- regfile %>%
    filter(REGISTRATION_DATE <= regdate) %>%
    group_by(COUNTY) %>%
    summarize(reg = n()) %>%
    rename(county = COUNTY)
  
  out
}


#' Get turnout, registered voters, and total votes per vounty
#'
#' @param regfile total registration file, with extra variable for year collected named FILE_YEAR
#' @param histfile complete history file across all reg file years
#' @param el_dat the election date, in the Date format
#' @param county a vector of all counties in the state
#' @return A dataframe with turnout, registered voters, and turnout per county
#' @examples
#' turnout_calc(MAINE_12_to_17_REG_FILE, VHIST_MAINE, as.Date("2016-11-08), MAINE_COUNTIES)
#' 
turnout_calc <- function(regfile, histfile, el_date, county){
  
  ##First the denominator
  
  if(typeof(regfile$REGISTRATION_DATE) != "double") regfile$REGISTRATION_DATE <- mdy(regfile$REGISTRATION_DATE)
  
  if(typeof(histfile$ELECTION_DATE) != "double") histfile$ELECTION_DATE <- mdy(histfile$ELECTION_DATE)
  
  #Filter for relevant year, registrants
  regfile_current <- regfile %>%
    filter(FILE_YEAR == year(el_date)) %>%
    filter(REGISTRATION_DATE <= el_date - 22)
  
  denoms <- create_reg(el_date, regfile_current)
  
  #Make sure no weird county values exist
  names(county) <- "county"
  
  denoms <- left_join(county, denoms, by = "county")
  
  ##Then the numerator
  
  #Take relevant votes
  nums <- histfile %>%
    filter(ELECTION_DATE == el_date)
  
  #Filter out those with no voter registration
  nums <- nums[(nums$VOTER_ID %in% regfile$VOTER_ID), ]
  
  mail_vote <- c("Absentee Carry", "Absentee Mail", "Mail Ballot", 
                 "Mail Ballot - DRE")
  
  nums <- nums %>%
    group_by(COUNTY_NAME) %>%
    summarise(votes = sum(n()), 
              mail_votes = sum(VOTING_METHOD %in% mail_vote))
  
  names(nums)[1] <- "county"
  
  #Now for a final step, to calculate turnout
  turnouts <- merge(nums, denoms, by = "county") %>%
    mutate(turnout = votes/reg, 
           pct_vbm = mail_votes/votes)
  
  turnouts
}

#' Get variable location data
#'
#' @param regfile total registration file, with extra variable for year collected named FILE_YEAR
#' @param var_location Numerical location of the variable of interest
#' @param var_name The name that is desired of the final variable
#' @return A dataframe with the variable of interest for each county, each year
#' @examples
#' var_table(MAINE_12_to_17_REG_FILE, 3, COUNTY)
#' 

var_table <- function(regfile, var_location, var_name) {
  
  #Select relevant information from voter reg files
  registrants <- regfile %>%
    select("VOTER_ID", var_location, "FILE_YEAR")
  
  #Rename variable of importance
  names(registrants)[2] <- "IMP_DATA"
  
  #Replace NA values with "NO_DATA", so it's clearly discernible
  #When the individual was not registered
  registrants[is.na(registrants[,2]),2] <- "NO_DATA"
  
  #Initialize with 2016 data
  var_table_out <- registrants %>%
    filter(FILE_YEAR == "2016") %>%
    rename(dt2016 = IMP_DATA) %>%
    select(1:2)
  
  #Add 2015 data
  file15 <- registrants %>%
    filter(FILE_YEAR == "2015") %>%
    select(-FILE_YEAR)
  
  var_table_out <- left_join(var_table_out, file15, by = "VOTER_ID")
  
  dropped15 <- data.frame(file15[!(file15$VOTER_ID %in% var_table_out$VOTER_ID),], NA)
  dropped15 <- dropped15[,c(1, 3, 2)]
  names(dropped15)[2] <- "dt2016"
  var_table_out <- rbind(var_table_out, dropped15)
  names(var_table_out)[3] <- "dt2015"
  
  #Add 2014 data
  file14 <- registrants %>%
    filter(FILE_YEAR == "2014") %>%
    select(-FILE_YEAR)
  
  var_table_out <- left_join(var_table_out, file14, by = "VOTER_ID")
  
  dropped14 <- data.frame(file14[!(file14$VOTER_ID %in% var_table_out$VOTER_ID),], NA, NA)
  dropped14 <- dropped14[,c(1, 3, 4, 2)]
  names(dropped14)[2:3] <- c("dt2016", "dt2015")
  var_table_out <- rbind(var_table_out, dropped14)
  names(var_table_out)[4] <- "dt2014"
  
  #Add 2013 data 
  file13 <- registrants %>%
    filter(FILE_YEAR == "2013") %>%
    select(-FILE_YEAR)
  
  var_table_out <- left_join(var_table_out, file13, by = "VOTER_ID")
  
  dropped13 <- data.frame(file13[!(file13$VOTER_ID %in% var_table_out$VOTER_ID),], NA, NA, NA)
  dropped13 <- dropped13[,c(1, 3, 4, 5, 2)]
  names(dropped13)[2:4] <- c("dt2016", "dt2015", "dt2014")
  var_table_out <- rbind(var_table_out, dropped13)
  names(var_table_out)[5] <- "dt2013"
  
  #Add 2012 data
  file12 <- registrants %>%
    filter(FILE_YEAR == "2012") %>%
    select(-FILE_YEAR)
  
  var_table_out <- left_join(var_table_out, file12, by = "VOTER_ID")
  
  dropped12 <- data.frame(file12[!(file12$VOTER_ID %in% var_table_out$VOTER_ID),], NA, NA, NA, NA)
  dropped12 <- dropped12[,c(1, 3, 4, 5, 6, 2)]
  names(dropped12)[2:5] <- c("dt2016", "dt2015", "dt2014", "dt2013")
  var_table_out <- rbind(var_table_out, dropped12)
  names(var_table_out)[6] <- "dt2012"
  
  names(var_table_out)[2:6] <- paste(var_name, 16:12, sep = "")
  
  var_table_out
}

#' From the list output of multiple turnout_calc()s, get county level data for graphing/modeling
#'
#' @param regfile total registration file, with extra variable for year collected named FILE_YEAR
#' @param turnouts_list a list created using the turnout_calc() function described previously
#' @examples
#' turnouts_county_graph(list_of_Maine_turnouts)
#' 

turnouts_county_data <- function(turnout_list){
  turnouts_graph <- turnout_list[[1]] %>%
    dplyr::select(1, 4:8) %>%
    mutate(dates = year(dates)) 
  
  for(i in 2:11){
    temp <- turnout_list[[i]] %>%
      dplyr::select(1, 4:8) %>%
      mutate(dates = year(dates)) 
    
    turnouts_graph <- rbind(temp, turnouts_graph)
  }
  
  turnouts_graph
}

#' Get data for individuals per election
#'
#' @param regfile total registration file, with extra variable for year collected named FILE_YEAR
#' @param histfile complete history file across all reg file years
#' @param el_dat the election date, in the Date format
#' @param el_type the type of election
#' @return A dataframe with individual data per election
#' @examples
#' turnout_calc(MAINE_12_to_17_REG_FILE, VHIST_MAINE, as.Date("2016-11-08), "General")
#' 

indiv_model_data <- function(regfile, histfile, el_date, el_type){
  #Correct Date formating
  if(typeof(regfile$REGISTRATION_DATE) != "double") regfile$REGISTRATION_DATE <- mdy(regfile$REGISTRATION_DATE)
  
  if(typeof(histfile$ELECTION_DATE) != "double") histfile$ELECTION_DATE <- mdy(histfile$ELECTION_DATE)
  
  regfile_current <- regfile %>%
    filter(FILE_YEAR == year(el_date)) %>%
    filter(REGISTRATION_DATE <= el_date - 22)
  
  ballots <- histfile %>%
    filter(ELECTION_DATE == el_date) %>%
    mutate(voted = 1)
  
  indiv_file <- left_join(regfile_current, ballots, by = "VOTER_ID") %>%
    select(2:3, 5:8, 10, 11, 13, 16)
  
  #Fix NAs in type/date
  indiv_file$ELECTION_TYPE <- el_type
  indiv_file$ELECTION_DATE <- el_date
  
  #Find Age
  indiv_file$BIRTH_YEAR <- as.numeric(year(el_date)) - indiv_file$BIRTH_YEAR
  
  #Rename
  names(indiv_file)[3] <- "ACTIVE"
  names(indiv_file)[4] <- "PARTY"
  names(indiv_file)[5] <- "GENDER"
  names(indiv_file)[6] <- "AGE"
  
  #Make VBM variable
  mail_vote <- c("Absentee Carry", "Absentee Mail", "Mail Ballot", 
                 "Mail Ballot - DRE")
  
  indiv_file$VOTING_METHOD <- ifelse(indiv_file$VOTING_METHOD %in% mail_vote, 1, 0)
  
  names(indiv_file)[9] <- "MAIL_VOTE"
  
  #Make Voted variable
  indiv_file$voted <- ifelse(is.na(indiv_file$voted), 0, 1)
  
  indiv_file
}

#' From the list output of multiple indiv_model_data()s, get individual level data for graphing/modeling
#'
#' @param indiv_voter_list a list created using the indiv_model_data() function described previously
#' @examples
#' extract_indiv_model_data(list_of_Maine_individual_registrants_and_voters)
#' 

extract_indiv_model_data <- function(indiv_voter_list){
  indiv_data <- indiv_voter_list[[1]]
  
  for(i in 2:11){
    indiv_data <- rbind(indiv_data, indiv_voter_list[[i]])
  }
  
  indiv_data
}

#' Divide an age variable into three
#'
#' @param age  An age vector
#' @return Values from 1 to 3 based on age groups
#' 

age_group <- function(age){
  vec <- rep(0, length(age))
  for(i in 1:length(age)){
    out <- 0
    if(age[i] <= 35) out <- 1
    if(age[i] %in% c(36:60)) out <- 2
    if(age[i] > 60) out <- 3
    vec[i] <- out
  }
  vec
}
