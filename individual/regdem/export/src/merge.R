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
             indicators = here("individual/regdem/indicators/export/output/indicators.csv"),
             output = here("individual/regdem/export/output/regdem2019-2022-final.csv"))

indicators <- fread(args$indicators)

regdem <- fread(args$input)  

out <- regdem  %>%
    left_join(indicators, by = "ControlNumber")  %>%
      mutate(across(starts_with("ind_"), ~ coalesce(.x, FALSE))) 
      



# output
fwrite(out, args$output)
