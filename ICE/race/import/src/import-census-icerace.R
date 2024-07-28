# Authors:     LM
# Maintainers: LM
# Date: 25-Feb-24

# Importing data from census 
# =========================================

# Importing census data for ICE income indicators
# to analyze firearm deaths in minors

### Things to do here, we have just to import all variables involving income
## After that we will downstream the imputations for quintiles


# --- libs ---
if(!require(pacman))install.packages("pacman")
p_load(dplyr,
       sf,
       here,
       data.table,
       tidyr,
       tidycensus)

args <- list(output1 = here("ICE/race/import/output/IceCensusRace.csv"),
             output2 = here("ICE/race/import/notes/IceRaceVarsDic.txt"))



# --- import ---
# var_dic <- load_variables(2021, "acs5") # Importing all variables in census

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
  geometry = TRUE,
  show_call = TRUE)



race_data_geom <- race_data %>% select(GEOID) %>% unique()

# remove geometry data so we can use pivot_wider
census_race <- race_data %>% st_drop_geometry() %>%
  
  # Left join to tibble
  left_join(race_data_vars, by = c("variable" = "name")) %>% 
  
  # Dropping extra vars
  select(-moe, -variable, -desc) %>% 
  
  # Pivoting 
  pivot_wider(names_from = shortname, values_from = estimate) %>% 
  
  # Removing small pops 
  filter(pop_total > 60)


# POP
out <- census_race %>% 
  mutate(POC = pop_total - white)



# -- Output ---
# Variable desc
write.table(race_data_vars, args$output2, sep = "\t", quote = FALSE)

# Output
fwrite(out, args$output1)



#Done
