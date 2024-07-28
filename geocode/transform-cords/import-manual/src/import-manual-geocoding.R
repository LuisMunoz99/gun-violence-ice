# Authors:     LM
# Maintainers: LM
# Date: 7-Mar-24
# =========================================

# Importing manual geocoding of deaths of minors with firearm

# --- libs ---
if (!require(pacman)) install.packages("pacman")
p_load(dplyr,
       here,
       data.table,
       readxl)

args <- list(input = here("geocode/transform-cords/import-manual/input/geocoding-CF-2018-2022-done.xlsx"),
             output = here("geocode/transform-cords/import-manual/output/geocoding-CF-2018-2022-done.csv"))

# --- Import data ---
child_firearm <- list()

all_sheets <- excel_sheets(args$input)

for (ind in all_sheets) {
  child_firearm[[as.character(paste0("regedem",ind))]] <- read_excel(args$input, sheet = ind)
}

# --- Cleaning  ---
out <- bind_rows(child_firearm)

# --- Output ---
fwrite(out, args$out)

## DONE (reviewed 3 July 2024)
