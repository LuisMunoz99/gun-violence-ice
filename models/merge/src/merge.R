# Script: merge.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-07-24
# ---------------------------------------

# --- libs --- 
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(
  here,
  data.table,
  dplyr,
  tidyr
)

# --- args ---
args <- list(
  ct = here("./models/import/output/ct-data.csv"),  # ACS structural indicators
  deaths   = here("./firearm-minors/export/output/firearm-minors-final.csv"),    # Firearm death counts by tract
  output   = here("./models/merge/output/deaths-ct.csv")    # Output merged dataset
)

# --- import ---
ct <- fread(args$ct)
deaths   <- fread(args$deaths)

death2ct <- deaths %>%
  group_by(GEOID) %>%
  summarise(
    deaths = sum(ind_minor, na.rm = TRUE)
  ) 


# -- merge -- 
out <- ct %>%
  left_join(death2ct, by = "GEOID") %>%
   mutate(
    deaths = coalesce(deaths, 0)  # Si deaths es NA, toma 0
  )


# --- output --- 
fwrite(
  out,
  args$output
)

# End of script

