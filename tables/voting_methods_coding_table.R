library(pander)

voting_methods <- data.frame(c("Absentee Carry", "Absentee Mail", 
                               "Early Voting", "In Person", 
                               "Mail Ballot", "Polling Place", 
                               "Vote Center"), 
                             as.character(c("Voters who carried an absentee ballot with them 
                                            from an early voting location or county office", 
                                            "Voters who were sent an absentee ballot, and mailed it in", 
                                            "Voters who physically went to an Early Voting location and voted",
                                            "Voters who physically went to a polling place and voted on paper", 
                                            "Vote By Mail", "Traditional polling place voting, discontinued in 2013", 
                                            "Voters who cast their ballots at Vote Centers")), 
                             c("VBM", "VBM", "In Person", "In Person", "VBM", "In Person", 
                               "In Person"))

names(voting_methods) <- c("Voting Method", "Description of Method", "Designation")
