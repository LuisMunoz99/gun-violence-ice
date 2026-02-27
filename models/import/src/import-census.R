# Script: import-census.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-07-24
# ---------------------------------------

# --- libs ---
if (!require(pacman)) install.packages("pacman")
pacman::p_load(
  tidycensus,  
  tidyverse,  
  here,      
  data.table
)

# --- args --- 
args <- list(
  output = here("./models/import/output/ct-data.csv"),
  notes   = here("models/import/notes/acs_vars.txt")
)

# These are the table cells we want from the 2022 ACS 5-year
# Source: https://api.census.gov/data/2022/acs/acs5/variables.html

acs_vars <- tibble::tribble(
  ~code,           ~short,              ~description,
  "B01003_001",    "pop_total",         "Total population",
  "B17001_001",    "poverty_den",       "Denominator for poverty rate",
  "B17001_002",    "poverty_cnt",       "Number of people below poverty line",
  "B19013_001",    "hhinc_median",        "Median household income",
)


# List all variables in the 2022 ACS 5-year
vars <- load_variables(year = 2022, dataset = "acs5", cache = TRUE)

# --- import census data ---
df <- get_acs(
  geography = "tract",
  state     = "72",         
  year      = 2022,
  survey    = "acs5",
  variables = acs_vars$code,
  geometry  = FALSE,         # No geometry in this step
  cache_table = TRUE
)

# --- transform --- 
out <- df %>%
  select(-moe) %>%                                # drop margins of error
  left_join(acs_vars, by = c("variable" = "code")) %>%
  select(GEOID, short, estimate) %>%
  pivot_wider(
    names_from  = short,
    values_from = estimate
  ) %>%
  mutate(
    poverty_pct = poverty_cnt / pop_total,
    population  = pop_total
  ) %>%
  select(
    GEOID, population, poverty_pct,
    hhinc_median, everything()
  )

 # -- Output ---
fwrite(out, args$output)
write.table(acs_vars, args$notes, sep = "\t", quote = FALSE)

# Done 
