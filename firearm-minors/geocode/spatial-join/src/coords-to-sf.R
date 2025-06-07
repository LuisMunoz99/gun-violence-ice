# Script: coords-to-sf.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-04-12
# ---------------------------------------

# transforming coordinates to sf objects for census

# libs
if (!require(pacman)) install.packages("pacman")
pacman::p_load(data.table,
       here,
       sf,
       tidycensus,
       dplyr,
       tidyr)

# args {{{
args <- list(input = here("./firearm-minors/geocode/coords/output/coordinates.csv"), 
             output =  here("./firearm-minors/geocode/spatial-join/output/firearm-minors-sf.csv"))

# }}}

# -- Import --
coords <- fread(args$input)  %>%
    filter(!is.na(latitude)|!is.na(longitude))  

PR_tract <- get_acs(
  geography = "tract",
  variables = c("B01003_001"), # dummy var to get geometry
  state = "PR",
  year = 2022,
  geometry = TRUE 
) %>%
  st_transform(6440)


# Converting into simple features
coords_to_sf <- coords %>%
  st_as_sf(coords = c("latitude", "longitude"), crs = 4326) %>%
  st_transform(6440)  %>%
  st_join(PR_tract)  %>%
  st_drop_geometry()  %>%
  distinct(ControlNumber, GEOID)

# -- Output ---
fwrite(coords_to_sf, args$output) 
