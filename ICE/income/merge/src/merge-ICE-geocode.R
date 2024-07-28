# Authors:     LM
# Maintainers: LM
# Date: 26-feb-23

## Merging census data with SF points
## After this task is done the result database would be the final
## Requires output from adjust-income/export/output

## Also it requries output in transform-cords/export/output
# ===========================================


# -- libs ---
if (!require(pacman)) install.packages("pacman")
p_load(data.table,
       here,
       dplyr,
       sf)

# args {{{
args <- list(input1 = here("ICE/income/adjust-income/export/output/ICE-adjustedInc.csv"),  # Ice import
             input2 = here("geocode/transform-cords/export/output/geocoded-coords.csv"),  # SF import 
             output = here("ICE/income/merge/output/iceInc-geo-final.csv")) # Output ICE with SF 
# }}}



# -- Import ---
ice_data <- fread(args$input1)
sf_child_firearm <- fread(args$input2)


# -- Export ---
out <- ice_data %>%
  left_join(sf_child_firearm, by = "GEOID") %>%
  mutate(RIP = ifelse(is.na(RIP), 0, RIP)) %>%
  select(-geometry)


# Export to CSV
write.csv(out, file = args$output, row.names = FALSE)
