*turnout_calc*: 
      
      file with calculations that output turnout.

*vhist_full_and_county_reg_creation*: 
      
      outputs two files, based on the following adviser directions:

      Getting the files tidied needs to be done carefully because you are juggling a lot of 3 GB files.
  
      I think what you initially will want to do is to create a file of voter registration IDs from the latest         (2016) voter registration file.

      Save county of registration and label is “county2016”. Have only the IDs and county2016 in memory.

      Then load the 2015 voter reg file. For any IDs that match, add a county2015 value. For any IDs in that           file that were not in the 2016 file, add these IDs and the county2015 value.

      And so on sequentially.  So your output file will consist of all registrants who have been on the files for       some of the 2012 - 2016 period.

      OK. Now go through the same exercise for voter histories.

      For any record with a valid value for county2016, grab the vote histories.

      For records with county2015 but not county2016, grab histories from the 2015 history file.

      … and so on. Each step should get faster because the vast majority of records will have been in the same         county and have a registration record from 2012 - 2016, but as you go backwards, you’ll grab the vote            histories of those who moved out of state or fell off the rolls.
      
*Diagnostics*:

      Diagnostics for vhist and vrf for 2012-2016