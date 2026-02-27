# Authors:     LM
# Maintainers: LM
# Date: 7-Mar-24
# =========================================

# Importing manual geocoding of deaths of minors with firearm

# --- libs ---
if (!require(pacman)) install.packages("pacman")
p_load(dplyr,
       here,
       readxl, 
       data.table)

args <- list(
  input  = here("firearm-minors/geocode/coords/hand/export-manual-done.xlsx"),
  output = here("firearm-minors/geocode/coords/output/coordinates.csv")
)

coords <- read_xlsx(args$input)  %>%
  mutate(across(where(is.character), ~ trimws(.)))

out <- coords %>%
  mutate(
         latitude  = as.numeric(latitude),
         longitude = as.numeric(longitude)
  ) %>%
  distinct(ControlNumber, latitude, longitude) 


# --- Output ---
fwrite(out, args$output)

## DONE (reviewed 3 July 2024)
