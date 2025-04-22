# Script: adjust-hhincome.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-04-06
# ---------------------------------------

# -- libs ---
if(!require(pacman))install.packages("pacman")
p_load(dplyr,
       data.table,
       here)

# args {{{
args <- list(input = here("./individual/census/import/output/race-census.csv"),
             output = here("./individual/census/adjust-pop/output/race-census-final.csv"))

# -- Import ---
race <- fread(args$input)

race_adjusted <- race %>%
    filter(pop_total  >= 60)  %>%
  mutate(
    POC = pop_total - white)   # POC = people of color 

fwrite(race_adjusted, args$output)
