# Script: adjust-hhincome-race.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-04-13
# ---------------------------------------

# Adjusting census household income 
# based on quintiles measured in PUMS  

# -- libs ---
if(!require(pacman))install.packages("pacman")
p_load(dplyr,
       data.table,
       here)

# args {{{
args <- list(input = here("./individual/census/import/output/hhincome-race-census.csv"),
             quintiles = here("./individual/PUMS/output/hhinc-quintiles.csv"),
             output = here("./individual/census/adjust-pop/output/hhincome-race-census-final.csv"))

# -- Import ---
hhinc_race <- fread(args$input)
quintiles <- fread(args$quintiles)

# These wrere obtained from census quickfacts (we should improve) 
proportion_white_alone <- .43
proportion_black_alone  <- .088

q1_limit <- quintiles$upper.limits[1]  # Threshold for bottom 20% (< $7,808)
q5_limit <- quintiles$upper.limits[4]  # Lower bound of top 20% (> $49,300)



out <- hhinc_race %>%
    filter(pop_total >= 60)  %>% 
  mutate(
    # low income quintile
    hhinc_7808 = (q1_limit - 0) / 10000 * hhinc1,
    
    # High income start
         hhinc_49300 = (49999 - q5_limit / 5000) * hhinc9,
    
    # Low income whites quintile
         hhinc_7808_white = (proportion_white_alone * (q1_limit - 0) / 10000) * hhinc_white_1,

    # High income whites start
         hhinc_49300_white = (proportion_white_alone * (49999 - q5_limit) / 5000) * hhinc_white_9,
    
    # Low income non whites quintile
         hhinc_7808_black = (proportion_black_alone * (q5_limit - 0) / 10000) * hhinc_black_1,
    
         hhinc_49300_black = (proportion_black_alone * (49999 - q5_limit) / 5000) * hhinc_black_9)

fwrite(out, args$output)
