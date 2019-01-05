# Turnout and Mail Voting in Colorado or; How I learned to Stop Worrying and Love VOter Registration Files
### December 2018

This repository contains my senior thesis, completed across the Spring/Fall semesters of my last year at Reed College. This thesis is an ad-hoc interdisciplinary project, between the departments of Mathematics and Political Science. [Andrew Bray](http://andrewpbray.github.io/) and [Paul Gronke](https://blogs.reed.edu/paul-gronke/) advised this thesis.

Mail voting in the United States was conceived and first implemented to serve
absentee voters during the Civil War (Fortier, 2006) and has persisted until the present
day, becoming one of the key reforms associated with “convenience voting” and the
expansion of the democratic franchise (Gronke, Galanes-Rosenbaum, Miller, & Toffey,
2008). In 2013, Colorado implemented the latest in a series of in-state election reforms
and became the third state in the nation with universal mail voting for all elections,
after Oregon and Washington. 

![](maps/us_vbm_status.png)

Despite claims by policymakers that mail voting should
have a strong, positive effect on voter turnout, a recent series of studies on Oregon,
Washington, parts of California, and Colorado have failed to show consistent results,
disagreeing both on the scale and the direction (positive or negative) that this effect
has. This thesis aims at following this series of studies by examining Colorado voter
registration files for recent elections (2010-2016). These files consist of a registration
file with voter information and a history file with voter participation data in Colorado
elections, and provide all information necessary for a comprehensive study of turnout.
By describing, fitting, and interpreting multilevel general additive regression models of
voter turnout based on these data, I show that there is a small positive effect of mail
voting on turnout in national elections at the county level. This thesis also contributes
to the literature by presenting a description of modeling and data wrangling difficulties
associated with voter registration files, and giving a series of potential solutions, as
well as an extensive coding library to aid future research on the subject.


## Turnout and Voting Methods in Colorado Elections

#### data_wrangling

Contains R scripts related to wrangling the voter history and voter registration files

#### plots

Contains R scripts and pngs of all plots used in this thesis

#### maps

Contains R scripts and pngs of all maps used in this thesis

#### thesis folder

This is were all of the files related to your final thesis should live. I recommend that you start by adding a template to this directory - either the Markdown thesis template or the LaTeX thesis template.

#### Data_and_results

Currently contains rmds with initial data wrangling and diagnostics, as well as any data used in this thesis. Will be eventually changed to exclusivelly "data"

#### thesis_output_folder

Contains thsis template that actually builds full text

#### riggd

R package with full documentation, used in creating this thesis
#### README.md

