# Script: merge.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-04-13
# ---------------------------------------

# merge regdem data with census tract data 

# --- libs
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(
here, dplyr, data.table, stringr
)

# --- files
args <- list(
  firearm_minors = here("./firearm-minors/import/output/firearm-minors-2019-2022.csv"),
  coords = here("./firearm-minors/geocode/export/output/firearm-minors-sf.csv"),
  output = here("./firearm-minors/export/output/firearm-minors-final.csv")
)

df <- fread(args$firearm_minors) 
coords <- fread(args$coords)


out <- df %>%
  left_join(coords, by = "ControlNumber") %>%
  select(-AgeUnit, -starts_with("Residence"))

ifelse(nrow(filter(out, is.na(GEOID))) > 1, 
       stop("Join failed: more than 1 unmatched ControlNumber"),
       TRUE)

fwrite(out, args$output) 
