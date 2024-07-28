# Authors:     LM
# Maintainers: LM
# Date: 21-feb-24
# ===========================================

# Importing census data for income based indicators
# to analyze firearm deaths in minors 

# -- libs ---
if(!require(pacman))install.packages("pacman")
p_load(dplyr,
       here,
       tidycensus,
       sf,
       tidyr)

# args {{{
args <- list(output =
               here("concentration-ind/import/output/IncRaceBasedCensus.csv"))

# -- import ---
inc_race <- get_acs(
  geography = "tract",
  variables = c("B01003_001","B17001_002","B02001_002","B02001_003"), 
  state = "PR",
  year = 2022,
  survey = "acs5",
  geometry = TRUE,
  show_call = TRUE)


# Vars from Census 
# B01003_001 = Poblacion total
# B17001_002 = Personas bajo el nivel de pobreza
# B02001_002 = Personas blancas 
# B02001_003 = Personas negras alone 


inc_race_geometry <- inc_race %>% select(GEOID) %>% unique()

# remove geometry data so we can use pivot_wider
inc_race <- inc_race %>% st_drop_geometry()


inc_race <- inc_race %>% select(-moe) %>% 
    pivot_wider(names_from = variable, values_from = estimate) %>% 
    rename(total_pop = B01003_001,
           persons_below_povertyline = B17001_002,
           white = B02001_002,
           black = B02001_003) %>% 
    mutate(perct_below_povertyline = persons_below_povertyline/total_pop*100, 
           perct_whites = white/total_pop*100) 


# Remove all census tracts with low pop
inc_race <- inc_race %>% 
  filter(total_pop > 60)

# Returning geography data
out <- inc_race 


# -- Output ---

write.csv(out, args$output) 

#Done