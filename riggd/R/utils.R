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
  reg_per_year_sos <- read_csv("2017_CO/VRF_2017/CO_2017_VRF_full.csv", 
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
  
  nums <- nums %>%
    group_by(COUNTY_NAME) %>%
    summarise(votes = sum(n()))
  
  names(nums)[1] <- "county"
  
  #Now for a final step, to calculate turnout
  turnouts <- merge(nums, denoms, by = "county") %>%
    mutate(turnout = votes/reg)
}

