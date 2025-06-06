# Script: adjust-hhincome-race.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-04-13
# ---------------------------------------

# Adjusting census household income 
# based on quintiles measured in PUMS  

# -- libs ---
if(!require(pacman)) install.packages("pacman")
pacman::p_load(dplyr, tidycensus, data.table, here, tidyr)

# --- Args ---
args <- list(
  input     = here("individual/census/import/output/hhincome-race-census.csv"),
  quintiles = here("individual/PUMS/export/output/hhinc-quintiles.csv"),
  output    = here("individual/census/adjust-pop/output/hhincome-race-census-final.csv")
)

# --- Import data ---
hhinc_race <- fread(args$input)
quintiles  <- fread(args$quintiles)

# --- Pull race estimates for Puerto Rico ---
race_vars <- c(
  total = "B02001_001",
  white = "B02001_002",
  black = "B02001_003"
)

race_pr <- get_acs(
  geography = "state",
  state = "PR",
  variables = race_vars,
  survey = "acs5",
  year = 2022,
  geometry = FALSE
)

# --- Compute race proportions ---
race_props <- race_pr %>%
  select(variable, estimate) %>%
  pivot_wider(names_from = variable, values_from = estimate) %>%
  transmute(
    prop_white = white / total,
    prop_black = black / total
  )

# Extract proportions
prop_white <- race_props$prop_white
prop_black <- race_props$prop_black

# --- Get quintile thresholds from PUMS ---
q1_limit <- quintiles$upper.limits[1]  # Bottom 20%
q5_limit <- quintiles$upper.limits[4]  # Lower bound of top 20%

# --- Adjust income distributions ---
out <- hhinc_race %>%
  filter(pop_total >= 60) %>%
  mutate(
    # Total population estimates
    hhinc_7808   = (q1_limit / 10000) * hhinc1,
    hhinc_49300  = ((49999 - q5_limit) / 5000) * hhinc9,

    # Race-specific estimates (no additional race weighting needed)
    hhinc_7808_white  = (q1_limit / 10000) * hhinc_white_1,
    hhinc_49300_white = ((49999 - q5_limit) / 5000) * hhinc_white_9,

    hhinc_7808_black  = (q1_limit / 10000) * hhinc_black_1,
    hhinc_49300_black = ((49999 - q5_limit) / 5000) * hhinc_black_9
  )

# --- Save output ---
fwrite(out, args$output)

