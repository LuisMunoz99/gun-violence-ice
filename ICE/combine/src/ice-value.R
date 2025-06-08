# Script: ice-value.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-04-13
# ---------------------------------------

# measure ice values per ct and group in quintiles 

# -- libs ---
if(!require(pacman))install.packages("pacman")
p_load(dplyr,
       data.table,
       here,
       tidycensus,
       tidyr)

# args {{{
args <- list(input = here("./individual/census/export/output/combine-census-final.csv"),
             output = here("./ICE/combine/output/ice-combine.csv"))

# Import ICE data (new task to merge)fre
ct <- fread(args$input) %>%
    mutate(
           # Q1: Population in the most economically deprived stratum
        q1_pop = hhinc_7808_black,
        # Q5: Population in the most economically privileged stratum
        q5_pop = hhinc_49300_white +
             hhinc_white_10 + hhinc_white_11 + hhinc_white_12 +
             hhinc_white_13 + hhinc_white_14 + hhinc_white_15 +
             hhinc_white_16,
       
         total_pop = hhinc_total
         ) 
    

ct <- ct %>%
  mutate(
    people_deprived  = q1_pop,
    people_afluent = q5_pop,

    ICE_combined =
      (people_afluent - people_deprived) /
      total_pop)


# 2. Divide ICE measures into Quintiles
out <- ct %>%
  arrange(ICE_combined) %>%
  mutate(ICE_combined_quintile = ntile(ICE_combined, 5))  %>%
  distinct(GEOID, ICE_combined, ICE_combined_quintile)

# output
fwrite(out, args$output)
