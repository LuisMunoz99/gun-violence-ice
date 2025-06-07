# Script: assemble-firearm-minors.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-04-10
# ---------------------------------------

# includes specific group for analysis (minors + firearms from 2019-2022) 

if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(
here, dplyr, data.table
)

# --- files
args <- list(
  input  = here("./individual/regdem/export/output/regdem2019-2022-final.csv"),
  output = here("./firearm-minors/import/output/firearm-minors-2019-2022.csv"))

df <- fread(args$input)  %>%
    filter(ind_minor, ind_firearm)  %>%
    distinct(ControlNumber, ind_minor, ind_firearm, .keep_all = TRUE)

fwrite(df, args$output)
