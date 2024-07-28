# Authors:     LM
# Maintainers: LM
# Date: 25-Feb-24

# Importing data from census

# Importing census data for ICE income indicators
# to analyze firearm deaths in minors

### Things to do here, we have just to import all variables involving income
## After that we will downstream the imputations for quintiles



# --- libs ---
if (!require(pacman)) install.packages("pacman")
p_load(dplyr,
       here,
       data.table,
       sf,
       tidyr,
       tidycensus)

args <- list(output1 = here("ICE/income/import/output/IceCensus.csv"),
             output2 = here("ICE/income/import/notes/IceIncVarsDic.txt"))



# --- import ---

# Variables corresponding to ICE measure
income_data_vars <-
  tibble::tribble(
    ~name,          ~shortname,      ~desc,
    "B19001_001", 'hhinc_total',   "total household income estimates",
    "B19001_002", 'hhinc1',     "household income <$10k",
    "B19001_003", 'hhinc2',     "household income $10k-14,999",
    "B19001_004", 'hhinc3',     "household income $15k-19,999",
    "B19001_005", 'hhinc4',     "household income $20k-24,999",
    "B19001_006", 'hhinc5',     "household income $25k-29,999",
    "B19001_007", 'hhinc6',     "household income $30k-34,999",
    "B19001_008", 'hhinc7',     "household income $35k-39,999",
    "B19001_009", 'hhinc8',     "household income $40k-44,999",
    "B19001_010", 'hhinc9',     "household income $45k-49,999",
    "B19001_011", 'hhinc10',    "household income $50k-59,999",
    "B19001_012", 'hhinc11',    "household income $60k-74,999",
    "B19001_013", 'hhinc12',    "household income $75k-99,999",
    "B19001_014", 'hhinc13',    "household income $100k-124,999",
    "B19001_015", 'hhinc14',    "household income $125k-149,999",
    "B19001_016", 'hhinc15',    "household income $150k-199,999",
    "B19001_017", 'hhinc16',    "household income $200k or more",
    "B01003_001", 'pop_total',    "total population")

# -- import ---
income_data <- get_acs(
    geography = "tract",
    variables = income_data_vars$name,
    state = "PR",
    year = 2022,
    survey = "acs5",
    geometry = TRUE,
    show_call = TRUE)



income_data_geom <- income_data %>% select(GEOID) %>% unique()

# remove geometry data so we can use pivot_wider
out <- income_data %>%
  st_drop_geometry() %>%

  # Left join to tibble
  left_join(income_data_vars, by = c("variable" = "name")) %>%

  # Dropping extra vars
  select(-moe, -variable, -desc) %>%

  # Pivoting
  pivot_wider(names_from = shortname, values_from = estimate) %>%

  # Removing small pops
  filter(pop_total > 60)


# -- Output ---
fwrite(out, args$output1)
write.table(income_data_vars, args$output2, sep = "\t", quote = FALSE)

#Done
