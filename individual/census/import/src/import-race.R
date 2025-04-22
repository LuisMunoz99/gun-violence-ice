# Script: import-race.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-04-21
# ---------------------------------------


# --- libs ---
if(!require(pacman))install.packages("pacman")
p_load(dplyr,
       sf,
       here,
       data.table,
       tidyr,
       tidycensus)

args <- list(output = here("./individual/census/import/output/race-census.csv"),
             notes = here("./individual/census/import/notes/IceRaceVarsDic.txt"))


# Variables corresponding to ICE measure
race_data_vars <-
  tibble::tribble(
    ~name,          ~shortname,      ~desc,
    "B01003_001", 'pop_total',   "Total population",
    "B02001_002", 'white',     "White alone",
    "B02001_003", 'black',     "Black alone")


# -- import ---
race_data <- get_acs(
  geography = "tract",
  variables = race_data_vars$name,
  state = "PR",
  year = 2022,
  survey = "acs5",
  show_call = TRUE)


# remove geometry data so we can use pivot_wider
race <- race_data %>% st_drop_geometry() %>%
  left_join(race_data_vars, by = c("variable" = "name")) %>% 
  select(-moe, -variable, -desc) %>% 
  pivot_wider(names_from = shortname, values_from = estimate)


# Output
fwrite(race, args$output)
write.table(race_data_vars, args$notes, sep = "\t", quote = FALSE)



#Done
