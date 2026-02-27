# Script: manual-geo.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-04-07
# ---------------------------------------
# --- libs ---
if (!require(pacman)) install.packages("pacman")
p_load(dplyr,
       here,
       data.table,
       writexl,
       stringr)

args <- list(input = here("./firearm-minors/import/output/firearm-minors-2019-2022.csv"),
             output = here("./firearm-minors/geocode/coords/output/export-manual.xlsx"))

# --- Import data ---
df <- fread(args$input)

out <- df %>%
    mutate(across(starts_with("Residence"), ~ tolower(.)))  %>%
    mutate(across(where(is.character), ~ str_squish(.))) %>%
    mutate(longitude = NA_character_,
           latitude = NA_character_)  %>%
 select(DeathDate, 
       ControlNumber, 
       starts_with("Residence"), 
       DeathCause_I_Desc,
       longitude,
        latitude)

# --- Export  ---
write_xlsx(out, args$output)
