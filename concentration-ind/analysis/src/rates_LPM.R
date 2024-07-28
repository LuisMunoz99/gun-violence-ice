
# --- libs --- 
if(!require(pacman))install.packages("pacman")
p_load(dplyr, 
       here,
       tidycensus,
       data.table,
       tidyr,
       stringr)


args <- list(input = here("concentration-ind/merge/output/fatal-victims-final.csv"))

# Import

df <- fread(args$input) 

## Census

inc_race <- get_acs(
  geography = "state",
  variables = c("B01003_001","B17001_002","B02001_002","B02001_003"), 
  state = "PR",
  year = 2022,
  survey = "acs5",
  geometry = TRUE,
  show_call = TRUE)

inc_race <- inc_race %>% select(-moe) %>% 
  pivot_wider(names_from = variable, values_from = estimate) %>% 
  rename(total_pop = B01003_001,
         persons_below_povertyline = B17001_002,
         white = B02001_002,
         black = B02001_003) %>% 
  mutate(perct_below_povertyline = persons_below_povertyline/total_pop*100, 
         perct_whites = white/total_pop*100) 

# Indicators
df <- df %>% 
  mutate(
    poverty_status = ifelse(perct_below_povertyline < 41.8,
                            "not poor neighborhood",
                            "poor neighborhood"),
    racial_composition = ifelse(perct_whites >= 43.5,
                                "predominantly white neighborhood", 
                                "racially diverse neighborhood"))

# Rates by poverty and race classification 
# Estos no tienen imputacion ni ajustes para las muertes que no tenemos infromacion

df %>% 
  group_by(poverty_status) %>% 
  summarise(
    rip = sum(Count),
    num = sum(Count, na.rm = TRUE)/9, # Imputation = Missing cases = 8
    denom = sum(total_pop, na.rm = TRUE),
    rate = num/denom*1000000) %>% kableExtra::kable() %>% 
  kableExtra::kable_styling()

# Rates by race

df %>% 
  group_by(racial_composition) %>% 
  summarise(
    rip = sum(Count),
    num = sum(Count, na.rm = TRUE)/9, 
    denom = sum(total_pop, na.rm = TRUE),
    rate = num/denom*1000000) %>% kableExtra::kable() %>% 
  kableExtra::kable_styling()

# Rates combined race and class

df %>% 
  group_by(racial_composition, poverty_status) %>% 
  summarise(
    rip = sum(Count),
    num = sum(Count, na.rm = TRUE)/9, # Imputation = Missing cases = 8
    denom = sum(total_pop, na.rm = TRUE),
    rate = num/denom*1000000) %>% 
  kableExtra::kable() %>% 
  kableExtra::kable_styling()
