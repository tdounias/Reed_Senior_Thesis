Huber County Level Presidential Elections Models
================
Theodore Dounias
3/18/2018

In the first model my results directly mirror those of the study.

``` r
#Create dataset for presidential elections

d_Pres <- data %>%
  filter(Year == 1996| Year == 2000| Year == 2004| Year == 2008)

d_Pres$Year <- as.factor(d_Pres$Year)

#Replication of first model for presidential elections

lm.1 <- lm(data = d_Pres, TurnoutPct ~ County + Year + VBMOnly)

summary(lm.1)
```

    ## 
    ## Call:
    ## lm(formula = TurnoutPct ~ County + Year + VBMOnly, data = d_Pres)
    ## 
    ## Residuals:
    ##       Min        1Q    Median        3Q       Max 
    ## -0.059548 -0.013577 -0.002013  0.013526  0.112281 
    ## 
    ## Coefficients:
    ##                      Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)         7.201e-01  1.478e-02  48.734  < 2e-16 ***
    ## CountyAsotin       -7.285e-02  2.014e-02  -3.618 0.000445 ***
    ## CountyBenton       -5.025e-03  2.014e-02  -0.250 0.803377    
    ## CountyChelan        1.112e-02  2.014e-02   0.553 0.581684    
    ## CountyClallam       3.069e-02  2.041e-02   1.504 0.135351    
    ## CountyClark         1.073e-02  2.014e-02   0.533 0.595319    
    ## CountyColumbia      4.122e-02  2.014e-02   2.047 0.042935 *  
    ## CountyCowlitz      -8.150e-03  2.014e-02  -0.405 0.686414    
    ## CountyDouglas      -2.475e-02  2.014e-02  -1.229 0.221550    
    ## CountyFerry         7.615e-05  2.246e-02   0.003 0.997300    
    ## CountyFranklin      1.140e-02  2.014e-02   0.566 0.572396    
    ## CountyGarfield      5.620e-02  2.014e-02   2.791 0.006168 ** 
    ## CountyGrant         1.572e-02  2.014e-02   0.781 0.436449    
    ## CountyGrays Harbor -1.798e-02  2.014e-02  -0.893 0.373903    
    ## CountyIsland        6.355e-02  2.014e-02   3.156 0.002049 ** 
    ## CountyJefferson     8.030e-02  2.014e-02   3.988 0.000119 ***
    ## CountyKing          2.393e-02  2.041e-02   1.173 0.243324    
    ## CountyKitsap        3.868e-02  2.014e-02   1.921 0.057279 .  
    ## CountyKittitas      9.925e-03  2.014e-02   0.493 0.623024    
    ## CountyKlickitat    -2.722e-02  2.014e-02  -1.352 0.179036    
    ## CountyLewis         1.020e-02  2.014e-02   0.507 0.613437    
    ## CountyLincoln       6.452e-02  2.014e-02   3.205 0.001758 ** 
    ## CountyMason         4.890e-02  2.014e-02   2.429 0.016734 *  
    ## CountyOkanogan      1.554e-02  2.041e-02   0.762 0.447858    
    ## CountyPacific       1.558e-02  2.014e-02   0.774 0.440825    
    ## CountyPend Oreille  1.397e-02  2.041e-02   0.684 0.495085    
    ## CountyPierce        5.458e-03  2.041e-02   0.267 0.789595    
    ## CountySan Juan      1.049e-01  2.014e-02   5.210 8.59e-07 ***
    ## CountySkagit        3.545e-02  2.014e-02   1.761 0.081009 .  
    ## CountySkamania     -1.533e-02  2.041e-02  -0.751 0.453975    
    ## CountySnohomish     2.770e-02  2.014e-02   1.376 0.171632    
    ## CountySpokane       7.275e-03  2.014e-02   0.361 0.718542    
    ## CountyStevens      -3.795e-02  2.014e-02  -1.885 0.062029 .  
    ## CountyThurston      1.925e-02  2.014e-02   0.956 0.341090    
    ## CountyWahkiakum     4.548e-02  2.014e-02   2.259 0.025834 *  
    ## CountyWalla Walla  -2.778e-02  2.014e-02  -1.379 0.170484    
    ## CountyWhatcom       1.823e-02  2.014e-02   0.905 0.367317    
    ## CountyWhitman      -8.525e-02  2.014e-02  -4.234 4.70e-05 ***
    ## CountyYakima       -1.495e-02  2.014e-02  -0.742 0.459333    
    ## Year2000            2.964e-02  6.448e-03   4.597 1.12e-05 ***
    ## Year2004            8.252e-02  6.590e-03  12.523  < 2e-16 ***
    ## Year2008            9.518e-02  1.383e-02   6.882 3.47e-10 ***
    ## VBMOnly             2.553e-02  1.325e-02   1.926 0.056582 .  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.02848 on 113 degrees of freedom
    ## Multiple R-squared:  0.8574, Adjusted R-squared:  0.8044 
    ## F-statistic: 16.18 on 42 and 113 DF,  p-value: < 2.2e-16

The second model also directly mirrors Huber's results.

``` r
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
```

    ## 
    ## Call:
    ## lm(formula = TurnoutPct ~ County + Year + VBMOnly + VBMOnly:PriorAbsenteePct, 
    ##     data = d_Pres)
    ## 
    ## Residuals:
    ##       Min        1Q    Median        3Q       Max 
    ## -0.056024 -0.014414  0.000126  0.014326  0.093507 
    ## 
    ## Coefficients:
    ##                            Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)               0.7244852  0.0144030  50.301  < 2e-16 ***
    ## CountyAsotin             -0.0827219  0.0198142  -4.175 5.92e-05 ***
    ## CountyBenton             -0.0099532  0.0195903  -0.508 0.612404    
    ## CountyChelan              0.0130450  0.0195267   0.668 0.505472    
    ## CountyClallam             0.0282617  0.0197959   1.428 0.156173    
    ## CountyClark               0.0091003  0.0195235   0.466 0.642034    
    ## CountyColumbia            0.0367378  0.0195775   1.877 0.063185 .  
    ## CountyCowlitz            -0.0087844  0.0195166  -0.450 0.653509    
    ## CountyDouglas            -0.0247693  0.0195154  -1.269 0.206993    
    ## CountyFerry               0.0441819  0.0266145   1.660 0.099699 .  
    ## CountyFranklin            0.0006384  0.0198700   0.032 0.974427    
    ## CountyGarfield            0.0522556  0.0195634   2.671 0.008687 ** 
    ## CountyGrant               0.0112520  0.0195771   0.575 0.566612    
    ## CountyGrays Harbor       -0.0224248  0.0195764  -1.146 0.254444    
    ## CountyIsland              0.0615333  0.0195279   3.151 0.002087 ** 
    ## CountyJefferson           0.0785167  0.0195252   4.021 0.000105 ***
    ## CountyKing                0.0189258  0.0198542   0.953 0.342520    
    ## CountyKitsap              0.0392295  0.0195163   2.010 0.046826 *  
    ## CountyKittitas            0.0025920  0.0196808   0.132 0.895457    
    ## CountyKlickitat          -0.0370621  0.0198122  -1.871 0.064001 .  
    ## CountyLewis               0.0124372  0.0195308   0.637 0.525556    
    ## CountyLincoln             0.0528144  0.0199347   2.649 0.009230 ** 
    ## CountyMason               0.0450485  0.0195611   2.303 0.023128 *  
    ## CountyOkanogan            0.0013521  0.0203826   0.066 0.947230    
    ## CountyPacific             0.0092955  0.0196368   0.473 0.636872    
    ## CountyPend Oreille       -0.0008754  0.0204386  -0.043 0.965913    
    ## CountyPierce              0.0004508  0.0198542   0.023 0.981924    
    ## CountySan Juan            0.1018556  0.0195440   5.212 8.63e-07 ***
    ## CountySkagit              0.0309770  0.0195771   1.582 0.116399    
    ## CountySkamania           -0.0155790  0.0197780  -0.788 0.432541    
    ## CountySnohomish           0.0243978  0.0195490   1.248 0.214623    
    ## CountySpokane             0.0010728  0.0196339   0.055 0.956521    
    ## CountyStevens            -0.0453913  0.0196857  -2.306 0.022963 *  
    ## CountyThurston            0.0193222  0.0195154   0.990 0.324258    
    ## CountyWahkiakum           0.0450753  0.0195158   2.310 0.022739 *  
    ## CountyWalla Walla        -0.0317813  0.0195649  -1.624 0.107101    
    ## CountyWhatcom             0.0164391  0.0195252   0.842 0.401613    
    ## CountyWhitman            -0.0957395  0.0198525  -4.823 4.50e-06 ***
    ## CountyYakima             -0.0166675  0.0195245  -0.854 0.395108    
    ## Year2000                  0.0296436  0.0062499   4.743 6.25e-06 ***
    ## Year2004                  0.0819259  0.0063907  12.820  < 2e-16 ***
    ## Year2008                  0.0980863  0.0134424   7.297 4.53e-11 ***
    ## VBMOnly                   0.0795736  0.0227447   3.499 0.000672 ***
    ## VBMOnly:PriorAbsenteePct -0.1031547  0.0358267  -2.879 0.004776 ** 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.0276 on 112 degrees of freedom
    ## Multiple R-squared:  0.8672, Adjusted R-squared:  0.8162 
    ## F-statistic: 17.01 on 43 and 112 DF,  p-value: < 2.2e-16

Here my results are the same, assuming that they rounded to the third decimal.

``` r
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
```

    ## 
    ## Call:
    ## lm(formula = TurnoutPct ~ County + Year + VBMOnly:PriorAbsenteePct_Tercile, 
    ##     data = d_Pres)
    ## 
    ## Residuals:
    ##       Min        1Q    Median        3Q       Max 
    ## -0.055607 -0.014798 -0.000646  0.014212  0.095614 
    ## 
    ## Coefficients:
    ##                                          Estimate Std. Error t value
    ## (Intercept)                             7.245e-01  1.438e-02  50.389
    ## CountyAsotin                           -8.274e-02  1.966e-02  -4.209
    ## CountyBenton                           -1.491e-02  1.966e-02  -0.759
    ## CountyChelan                            1.112e-02  1.939e-02   0.574
    ## CountyClallam                           3.111e-02  2.020e-02   1.540
    ## CountyClark                             1.073e-02  1.939e-02   0.553
    ## CountyColumbia                          3.134e-02  1.966e-02   1.594
    ## CountyCowlitz                          -8.150e-03  1.939e-02  -0.420
    ## CountyDouglas                          -2.475e-02  1.939e-02  -1.276
    ## CountyFerry                             1.489e-02  2.269e-02   0.656
    ## CountyFranklin                          1.512e-03  1.966e-02   0.077
    ## CountyGarfield                          5.394e-02  1.967e-02   2.743
    ## CountyGrant                             1.346e-02  1.967e-02   0.685
    ## CountyGrays Harbor                     -2.024e-02  1.967e-02  -1.029
    ## CountyIsland                            6.129e-02  1.967e-02   3.116
    ## CountyJefferson                         8.030e-02  1.939e-02   4.141
    ## CountyKing                              1.900e-02  1.979e-02   0.960
    ## CountyKitsap                            3.868e-02  1.939e-02   1.994
    ## CountyKittitas                          3.735e-05  1.966e-02   0.002
    ## CountyKlickitat                        -3.711e-02  1.966e-02  -1.888
    ## CountyLewis                             1.020e-02  1.939e-02   0.526
    ## CountyLincoln                           5.464e-02  1.966e-02   2.780
    ## CountyMason                             4.664e-02  1.967e-02   2.372
    ## CountyOkanogan                          7.032e-04  2.017e-02   0.035
    ## CountyPacific                           5.687e-03  1.966e-02   0.289
    ## CountyPend Oreille                     -8.718e-04  2.017e-02  -0.043
    ## CountyPierce                            5.215e-04  1.979e-02   0.026
    ## CountySan Juan                          1.026e-01  1.967e-02   5.219
    ## CountySkagit                            3.319e-02  1.967e-02   1.688
    ## CountySkamania                         -1.492e-02  2.020e-02  -0.738
    ## CountySnohomish                         2.544e-02  1.967e-02   1.294
    ## CountySpokane                          -2.613e-03  1.966e-02  -0.133
    ## CountyStevens                          -4.784e-02  1.966e-02  -2.434
    ## CountyThurston                          1.925e-02  1.939e-02   0.993
    ## CountyWahkiakum                         4.548e-02  1.939e-02   2.345
    ## CountyWalla Walla                      -3.004e-02  1.967e-02  -1.527
    ## CountyWhatcom                           1.596e-02  1.967e-02   0.812
    ## CountyWhitman                          -9.514e-02  1.966e-02  -4.840
    ## CountyYakima                           -1.495e-02  1.939e-02  -0.771
    ## Year2000                                2.964e-02  6.210e-03   4.773
    ## Year2004                                8.206e-02  6.351e-03  12.921
    ## Year2008                                9.745e-02  1.337e-02   7.290
    ## VBMOnly:PriorAbsenteePct_TercileLower   4.534e-02  1.429e-02   3.172
    ## VBMOnly:PriorAbsenteePct_TercileMiddle  1.483e-02  1.443e-02   1.027
    ## VBMOnly:PriorAbsenteePct_TercileUpper   5.786e-03  1.572e-02   0.368
    ##                                        Pr(>|t|)    
    ## (Intercept)                             < 2e-16 ***
    ## CountyAsotin                           5.23e-05 ***
    ## CountyBenton                            0.44968    
    ## CountyChelan                            0.56732    
    ## CountyClallam                           0.12645    
    ## CountyClark                             0.58132    
    ## CountyColumbia                          0.11373    
    ## CountyCowlitz                           0.67508    
    ## CountyDouglas                           0.20449    
    ## CountyFerry                             0.51322    
    ## CountyFranklin                          0.93881    
    ## CountyGarfield                          0.00711 ** 
    ## CountyGrant                             0.49500    
    ## CountyGrays Harbor                      0.30576    
    ## CountyIsland                            0.00233 ** 
    ## CountyJefferson                        6.77e-05 ***
    ## CountyKing                              0.33908    
    ## CountyKitsap                            0.04855 *  
    ## CountyKittitas                          0.99849    
    ## CountyKlickitat                         0.06164 .  
    ## CountyLewis                             0.59993    
    ## CountyLincoln                           0.00640 ** 
    ## CountyMason                             0.01944 *  
    ## CountyOkanogan                          0.97225    
    ## CountyPacific                           0.77287    
    ## CountyPend Oreille                      0.96561    
    ## CountyPierce                            0.97902    
    ## CountySan Juan                         8.46e-07 ***
    ## CountySkagit                            0.09429 .  
    ## CountySkamania                          0.46184    
    ## CountySnohomish                         0.19851    
    ## CountySpokane                           0.89450    
    ## CountyStevens                           0.01654 *  
    ## CountyThurston                          0.32301    
    ## CountyWahkiakum                         0.02080 *  
    ## CountyWalla Walla                       0.12955    
    ## CountyWhatcom                           0.41867    
    ## CountyWhitman                          4.23e-06 ***
    ## CountyYakima                            0.44236    
    ## Year2000                               5.56e-06 ***
    ## Year2004                                < 2e-16 ***
    ## Year2008                               4.86e-11 ***
    ## VBMOnly:PriorAbsenteePct_TercileLower   0.00196 ** 
    ## VBMOnly:PriorAbsenteePct_TercileMiddle  0.30644    
    ## VBMOnly:PriorAbsenteePct_TercileUpper   0.71350    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.02742 on 111 degrees of freedom
    ## Multiple R-squared:  0.8701, Adjusted R-squared:  0.8186 
    ## F-statistic: 16.89 on 44 and 111 DF,  p-value: < 2.2e-16

My results are almost the same here as well.

``` r
#Replication of Fourth Model for Presidential elections

first_year[first_year == 1] <- "First"
first_year[first_year == 0] <- "Second"
first_year[d_Pres$VBMOnly == 0] <- "NotMail"

first_year <- factor(first_year, levels = c("NotMail", "First", "Second"))

d_Pres <- cbind(d_Pres, first_year)  
names(d_Pres)[12] <- "Novelty"

lm.4 <- lm(data = d_Pres, TurnoutPct ~ County + Year + Novelty)

summary(lm.4)
```

    ## 
    ## Call:
    ## lm(formula = TurnoutPct ~ County + Year + Novelty, data = d_Pres)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.05925 -0.01414 -0.00189  0.01416  0.11156 
    ## 
    ## Coefficients:
    ##                     Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)         0.719758   0.014822  48.559  < 2e-16 ***
    ## CountyAsotin       -0.072850   0.020189  -3.608 0.000462 ***
    ## CountyBenton       -0.005025   0.020189  -0.249 0.803896    
    ## CountyChelan        0.011125   0.020189   0.551 0.582703    
    ## CountyClallam       0.033882   0.021079   1.607 0.110792    
    ## CountyClark         0.010725   0.020189   0.531 0.596313    
    ## CountyColumbia      0.041225   0.020189   2.042 0.043506 *  
    ## CountyCowlitz      -0.008150   0.020189  -0.404 0.687215    
    ## CountyDouglas      -0.024750   0.020189  -1.226 0.222803    
    ## CountyFerry         0.012434   0.029878   0.416 0.678089    
    ## CountyFranklin      0.011400   0.020189   0.565 0.573433    
    ## CountyGarfield      0.056200   0.020189   2.784 0.006311 ** 
    ## CountyGrant         0.015725   0.020189   0.779 0.437689    
    ## CountyGrays Harbor -0.017975   0.020189  -0.890 0.375195    
    ## CountyIsland        0.063550   0.020189   3.148 0.002109 ** 
    ## CountyJefferson     0.080300   0.020189   3.977 0.000124 ***
    ## CountyKing          0.023530   0.020471   1.149 0.252812    
    ## CountyKitsap        0.038675   0.020189   1.916 0.057960 .  
    ## CountyKittitas      0.009925   0.020189   0.492 0.623962    
    ## CountyKlickitat    -0.027225   0.020189  -1.349 0.180217    
    ## CountyLewis         0.010200   0.020189   0.505 0.614394    
    ## CountyLincoln       0.064525   0.020189   3.196 0.001811 ** 
    ## CountyMason         0.048900   0.020189   2.422 0.017035 *  
    ## CountyOkanogan      0.018732   0.021079   0.889 0.376097    
    ## CountyPacific       0.015575   0.020189   0.771 0.442061    
    ## CountyPend Oreille  0.017157   0.021079   0.814 0.417412    
    ## CountyPierce        0.005055   0.020471   0.247 0.805396    
    ## CountySan Juan      0.104900   0.020189   5.196 9.24e-07 ***
    ## CountySkagit        0.035450   0.020189   1.756 0.081839 .  
    ## CountySkamania     -0.012143   0.021079  -0.576 0.565737    
    ## CountySnohomish     0.027700   0.020189   1.372 0.172796    
    ## CountySpokane       0.007275   0.020189   0.360 0.719269    
    ## CountyStevens      -0.037950   0.020189  -1.880 0.062743 .  
    ## CountyThurston      0.019250   0.020189   0.953 0.342397    
    ## CountyWahkiakum     0.045475   0.020189   2.252 0.026242 *  
    ## CountyWalla Walla  -0.027775   0.020189  -1.376 0.171646    
    ## CountyWhatcom       0.018225   0.020189   0.903 0.368614    
    ## CountyWhitman      -0.085250   0.020189  -4.223 4.94e-05 ***
    ## CountyYakima       -0.014950   0.020189  -0.740 0.460546    
    ## Year2000            0.029644   0.006466   4.585 1.19e-05 ***
    ## Year2004            0.082690   0.006613  12.504  < 2e-16 ***
    ## Year2008            0.097814   0.014484   6.753 6.74e-10 ***
    ## NoveltyFirst        0.023921   0.013534   1.767 0.079876 .  
    ## NoveltySecond       0.012771   0.024247   0.527 0.599431    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.02855 on 112 degrees of freedom
    ## Multiple R-squared:  0.8579, Adjusted R-squared:  0.8033 
    ## F-statistic: 15.72 on 43 and 112 DF,  p-value: < 2.2e-16

Ditto

``` r
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
```

    ## 
    ## Call:
    ## lm(formula = TurnoutPct ~ County + Year + VBMOnly + VBMOnly:PctRural, 
    ##     data = d_Pres)
    ## 
    ## Residuals:
    ##       Min        1Q    Median        3Q       Max 
    ## -0.055770 -0.014501 -0.001729  0.015470  0.108331 
    ## 
    ## Coefficients:
    ##                     Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)         0.720110   0.014629  49.223  < 2e-16 ***
    ## CountyAsotin       -0.076684   0.020049  -3.825 0.000216 ***
    ## CountyBenton       -0.008338   0.020020  -0.416 0.677851    
    ## CountyChelan        0.009955   0.019947   0.499 0.618688    
    ## CountyClallam       0.029299   0.020219   1.449 0.150115    
    ## CountyClark         0.007864   0.019999   0.393 0.694888    
    ## CountyColumbia      0.039566   0.019957   1.983 0.049869 *  
    ## CountyCowlitz      -0.009762   0.019956  -0.489 0.625671    
    ## CountyDouglas      -0.026530   0.019961  -1.329 0.186515    
    ## CountyFerry         0.013950   0.023522   0.593 0.554328    
    ## CountyFranklin      0.008745   0.019990   0.437 0.662611    
    ## CountyGarfield      0.060154   0.020056   2.999 0.003335 ** 
    ## CountyGrant         0.015324   0.019938   0.769 0.443757    
    ## CountyGrays Harbor -0.019023   0.019945  -0.954 0.342251    
    ## CountyIsland        0.063204   0.019937   3.170 0.001965 ** 
    ## CountyJefferson     0.080565   0.019937   4.041 9.79e-05 ***
    ## CountyKing          0.024580   0.020208   1.216 0.226400    
    ## CountyKitsap        0.036001   0.019991   1.801 0.074419 .  
    ## CountyKittitas      0.008988   0.019943   0.451 0.653098    
    ## CountyKlickitat    -0.026696   0.019938  -1.339 0.183307    
    ## CountyLewis         0.011207   0.019944   0.562 0.575277    
    ## CountyLincoln       0.068479   0.020056   3.414 0.000891 ***
    ## CountyMason         0.050763   0.019963   2.543 0.012359 *  
    ## CountyOkanogan      0.019267   0.020309   0.949 0.344828    
    ## CountyPacific       0.015489   0.019936   0.777 0.438844    
    ## CountyPend Oreille  0.021228   0.020600   1.030 0.305013    
    ## CountyPierce        0.006105   0.020208   0.302 0.763126    
    ## CountySan Juan      0.108854   0.020056   5.427 3.35e-07 ***
    ## CountySkagit        0.033856   0.019956   1.697 0.092556 .  
    ## CountySkamania     -0.008072   0.020600  -0.392 0.695911    
    ## CountySnohomish     0.024302   0.020025   1.214 0.227458    
    ## CountySpokane       0.004138   0.020012   0.207 0.836568    
    ## CountyStevens      -0.035725   0.019974  -1.789 0.076389 .  
    ## CountyThurston      0.016993   0.019975   0.851 0.396756    
    ## CountyWahkiakum     0.049429   0.020056   2.465 0.015238 *  
    ## CountyWalla Walla  -0.030520   0.019994  -1.526 0.129712    
    ## CountyWhatcom       0.016586   0.019957   0.831 0.407682    
    ## CountyWhitman      -0.086867   0.019956  -4.353 2.98e-05 ***
    ## CountyYakima       -0.016885   0.019965  -0.846 0.399519    
    ## Year2000            0.029644   0.006385   4.643 9.41e-06 ***
    ## Year2004            0.083256   0.006538  12.735  < 2e-16 ***
    ## Year2008            0.091638   0.013834   6.624 1.26e-09 ***
    ## VBMOnly             0.045352   0.017105   2.651 0.009177 ** 
    ## VBMOnly:PctRural   -0.033047   0.018291  -1.807 0.073483 .  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.02819 on 112 degrees of freedom
    ## Multiple R-squared:  0.8614, Adjusted R-squared:  0.8082 
    ## F-statistic: 16.19 on 43 and 112 DF,  p-value: < 2.2e-16
