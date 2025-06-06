# Script: merge.indicators.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-05-30
# ---------------------------------------

if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(dplyr, here, data.table, purrr)

args <- list(
  input   = here("individual/regdem/import/output/regdem2019-2022.csv"),
  firearm = here("individual/regdem/indicators/firearm/output/firearm.csv"),
  minor   = here("individual/regdem/indicators/minor/output/minor.csv"),
  output  = here("individual/regdem/indicators/export/output/indicators.csv")
)

# --- Import
firearm <- fread(args$firearm)
minor   <- fread(args$minor)

# --- Merge
indicators <- list(firearm, minor) %>%
  reduce(full_join, by = "ControlNumber")

# --- Export
fwrite(indicators, args$output)

