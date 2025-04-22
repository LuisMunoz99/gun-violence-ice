# Script: merge.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-04-21
# ---------------------------------------

# --- libs ---
if (!require(pacman)) install.packages("pacman")
p_load(dplyr,
       here,
       data.table,
       stringr)


args <- list(input = here("individual/regdem/import/output/regdem2019-2022.csv"),
             minors = here("individual/regdem/indicators/minor/output/minor.csv"),
             firearm = here("individual/regdem/indicators/firearm/output/firearm.csv"),
             output = here("individual/regdem/export/output/regdem2019-2022-final.csv"))


minor <- fread(args$minors)
firearm <- fread(args$firearm)
regdem <- fread(args$input)  %>%
    left_join(minor, by = "ControlNumber")  %>%
    left_join(firearm, by = "ControlNumber")

# output
fwrite(regdem, args$output)
