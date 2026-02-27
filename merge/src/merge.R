# Script: merge.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-04-29
# ---------------------------------------

if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(
               here,
               data.table,
               dplyr,
               ggplot2,
               tidyr)

# args {{{
args <- list(firearm_minors = here("./firearm-minors/export/output/firearm-minors-final.csv"), 
             hhincome = here("./ICE/export/output/ice-hhincome.csv"),
             combined = here("./ICE/export/output/ice-combine.csv"),
             minors_pop = here("./individual/census/export/output/pop-1-19-census-final.csv"),
             output = here("./merge/output/ice-analysis-final.csv"))


# import 
firearm_minors <- fread(args$firearm_minors)
hhincome <- fread(args$hhincome)
combined <- fread(args$combined)
minors_pop <- fread(args$minors_pop) 


# --- Merge ---


out <- minors_pop %>%
  left_join(firearm_minors, by = "GEOID") %>%
  mutate(
    ind_firearm = coalesce(ind_firearm, FALSE), # NAs from unmatched tracts set to FALSE
    ind_minor   = coalesce(ind_minor, FALSE)    # NAs from unmatched tracts set to FALSE
  ) %>%
  mutate(firearm_minor = ind_firearm & ind_minor) %>%
  { if (any(is.na(.$firearm_minor))) stop("INTEGRITY ERROR: NA in firearm_minor after coalesce — check source data"); . } %>%
  group_by(GEOID, pop_1_19) %>%
  summarize(
    firearm_minor = sum(firearm_minor, na.rm = TRUE),
    ControlNumber = paste(unique(ControlNumber), collapse = "|"),
    name = paste(unique(Name), collapse = "|"),
    .groups = "drop")  %>%
  left_join(hhincome, by = "GEOID")  %>%
  left_join(combined, by = "GEOID")

fwrite(out, args$output) 
