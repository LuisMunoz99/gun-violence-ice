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
args <- list(input = here("./individual/census/export/output/hhincome-census-final.csv"),
             output = here("./ICE/hhincome/output/ice-hhincome.csv"))

# Import ICE data (new task to merge)
ct <- fread(args$input)  %>%
    mutate(   
           # Q1: Population in the most economically deprived stratus
           q1_pop = hhinc_7808,

           # Q5: Population in the most economically privileged stratus
           q5_pop = hhinc_49300 + hhinc10 + hhinc11 + hhinc12 + hhinc13 + hhinc14 + hhinc15 + hhinc16,

           total_pop = hhinc_7808 + hhinc2 + hhinc3 + hhinc4 + hhinc5 + hhinc6 + hhinc7 + hhinc8 +
      hhinc_49300 + hhinc10 + hhinc11 + hhinc12 + hhinc13 + hhinc14 + hhinc15 + hhinc16
    )

# 1. Calculate ICE income
ct <- ct %>%
  mutate(
    people_deprived  = q1_pop,

    people_afluent = q5_pop,

    ICE_hhinc =
      (people_afluent - people_deprived) / 
      total_pop)


# 2. Divide ICE measures into Quintiles 
out <- ct %>%
  arrange(ICE_hhinc) %>%
  mutate(ICE_hhinc_quintile = ntile(ICE_hhinc, 5))  %>%
  distinct(GEOID, ICE_hhinc, ICE_hhinc_quintile)

# output
fwrite(out, args$output)
