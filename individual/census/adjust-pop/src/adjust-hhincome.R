# Script: adjust-hhincome.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-04-06
# ---------------------------------------

# Adjusting census household income 
# based on quintiles measured in PUMS  

# -- libs ---
if(!require(pacman))install.packages("pacman")
p_load(dplyr,
       data.table,
       here)

# args {{{
args <- list(input = here("./individual/census/import/output/hhincome-census.csv"),
             quintiles = here("./individual/PUMS/hhinc-quintiles/output/hhinc-quintiles.csv"),
             output = here("./individual/census/adjust-pop/output/hhincome-census-final.csv"))

# -- Import ---
income_census <- fread(args$input)
quintiles_PUMS <- fread(args$quintiles)

# These thresholds split the Puerto Rico income distribution into quintiles (20% each)
# They allow us to estimate the extremes of income from grouped ACS categories
q1_limit <- quintiles_PUMS$upper.limits[1]  # Threshold for bottom 20% (< $7,808)
q5_limit <- quintiles_PUMS$upper.limits[4]  # Lower bound of top 20% (> $49,300)

# The ACS groups household income into brackets (e.g. $0–10k, $10–15k, etc.)
# Since quintile thresholds do not align perfectly with PR hhincome quintiles,
# we estimate the portion of households in the target quintile using proportional allocation,
# assuming uniform distribution within each income bracket.

income_adjusted <- income_census %>%
  mutate(
    # Estimate households with income < $7,808 within <$10,000 category
    hhinc_7808 = (q1_limit / 10000) * hhinc1,

    # Estimate households with income > $49,300 within the $45k–$49,999 category
    hhinc_49300 = ((49999 - q5_limit) / 5000) * hhinc9,

    # Q1: Population in the most economically deprived stratum
    q1 = hhinc_7808,

    # Q5: Population in the most economically privileged stratum
    q5 = hhinc_49300 + hhinc10 + hhinc11 + hhinc12 + hhinc13 + hhinc14 + hhinc15 + hhinc16
  )

fwrite(income_adjusted, args$output)
