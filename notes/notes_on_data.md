##Notes on the data

###Manson CO Data 2013

###Choate CO Data 2017

####Voter Registration Files

I used file 26 as a sample.

The first issue that is apparent is that variable names towards the tail of the columns are full sentences in ``. Should pay attention when trying to call. 

####Voter History Files

I used dataset number 10 as a sample.

*PARTY*  

Factorization revealed 14 different entries for PARTY in the VHF. There are several entries that have "NO DATA" in them.

*COUNTY*

All entries have data in them. All 64 counties are represented in the sample dataset I used. 
  
*ELECTION TYPE*  

There are 9 different election types listed in the sample dataset--Coordinated, General, Municipal, Municipal Run-off, Primary, Recall, School, Special, and "Special District"--, but I think that the two last ones may be the same thing.  

*VOTER ID*

Approx 67k entries in the sample file.
  
*ELECTION DATE/DESCRIPTION*

There are 189 election dates listed, with around 2k different election descriptions.

*VOTING METHODS*

The methods are split into DRE (I assume Direct Recording Electroni machines?) and non DRE. They include absentee carry, absentee mail, EV, in person, mail ballot, polling place, and vote center.

Is in person, vote center, polling place, and absentee carry similar?


CO_2017_VHist_full <- rbind(CO_2017_VHist_p1, CO_2017_VHist_p2, CO_2017_VHist_p3, CO_2017_VHist_p4,
                          CO_2017_VHist_p5, CO_2017_VHist_p6, CO_2017_VHist_p7, CO_2017_VHist_p8,
                          CO_2017_VHist_p9, CO_2017_VHist_p10, CO_2017_VHist_p11, CO_2017_VHist_p12,
                          CO_2017_VHist_p13, CO_2017_VHist_p14, CO_2017_VHist_p15, CO_2017_VHist_p16,
                          CO_2017_VHist_p17, CO_2017_VHist_p18, CO_2017_VHist_p19, CO_2017_VHist_p20,
                          CO_2017_VHist_p21, CO_2017_VHist_p22, CO_2017_VHist_p23, CO_2017_VHist_p24,
                          CO_2017_VHist_p25, CO_2017_VHist_p26, CO_2017_VHist_p27, CO_2017_VHist_p28, 
                          CO_2017_VHist_p29, CO_2017_VHist_p30, CO_2017_VHist_p31, CO_2017_VHist_p32,
                          CO_2017_VHist_p33, CO_2017_VHist_p34)




write.csv(CO_2017_VHist_full, file = "CO_2017_VHist_full")

