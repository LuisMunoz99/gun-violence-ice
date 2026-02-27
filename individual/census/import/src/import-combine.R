# Script: import-combine.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-04-13
# ---------------------------------------

# --- libs --- 
if(!require(pacman))install.packages("pacman")
p_load(dplyr, 
       here,
       data.table,
       sf,
       tidyr,
       tidycensus)

args <- list(
  output = here("./individual/census/import/output/combine-census.csv"),
  notes = here("./individual/census/import/notes/hhincome-race-vars.txt"))

# --- import --- 
# importing total housegold income for all races 

combined_vars <- tibble::tribble(
    ~name,          ~shortname,          ~desc,
    # Importing total household income for all races
    "B19001_001",   "hhinc_total",       "Total household income estimates",
    "B01003_001", 'pop_total',    "total population",

    # White alone income households
    "B19001A_001",  "hhinc_white_total", "White alone total household income estimates",
    "B19001A_002",  "hhinc_white_1",     "White alone household income <$10k",
    "B19001A_003",  "hhinc_white_2",     "White alone household income $10k-14,999",
    "B19001A_004",  "hhinc_white_3",     "White alone household income $15k-19,999",
    "B19001A_005",  "hhinc_white_4",     "White alone household income $20k-24,999",
    "B19001A_006",  "hhinc_white_5",     "White alone household income $25k-29,999",
    "B19001A_007",  "hhinc_white_6",     "White alone household income $30k-34,999",
    "B19001A_008",  "hhinc_white_7",     "White alone household income $35k-39,999",
    "B19001A_009",  "hhinc_white_8",     "White alone household income $40k-44,999",
    "B19001A_010",  "hhinc_white_9",     "White alone household income $45k-49,999",
    "B19001A_011",  "hhinc_white_10",    "White alone household income $50k-59,999",
    "B19001A_012",  "hhinc_white_11",    "White alone household income $60k-74,999",
    "B19001A_013",  "hhinc_white_12",    "White alone household income $75k-99,999",
    "B19001A_014",  "hhinc_white_13",    "White alone household income $100k-124,999",
    "B19001A_015",  "hhinc_white_14",    "White alone household income $125k-149,999",
    "B19001A_016",  "hhinc_white_15",    "White alone household income $150k-199,999",
    "B19001A_017",  "hhinc_white_16",    "White alone household income $200k or more",
    
    # Black alone income households
    "B19001B_001",  "hhinc_black_total", "Black alone total household income estimates",
    "B19001B_002",  "hhinc_black_1",     "Black alone household income <$10k",
    "B19001B_003",  "hhinc_black_2",     "Black alone household income $10k-14,999",
    "B19001B_004",  "hhinc_black_3",     "Black alone household income $15k-19,999",
    "B19001B_005",  "hhinc_black_4",     "Black alone household income $20k-24,999",
    "B19001B_006",  "hhinc_black_5",     "Black alone household income $25k-29,999",
    "B19001B_007",  "hhinc_black_6",     "Black alone household income $30k-34,999",
    "B19001B_008",  "hhinc_black_7",     "Black alone household income $35k-39,999",
    "B19001B_009",  "hhinc_black_8",     "Black alone household income $40k-44,999",
    "B19001B_010",  "hhinc_black_9",     "Black alone household income $45k-49,999",
    "B19001B_011",  "hhinc_black_10",    "Black alone household income $50k-59,999",
    "B19001B_012",  "hhinc_black_11",    "Black alone household income $60k-74,999",
    "B19001B_013",  "hhinc_black_12",    "Black alone household income $75k-99,999",
    "B19001B_014",  "hhinc_black_13",    "Black alone household income $100k-124,999",
    "B19001B_015",  "hhinc_black_14",    "Black alone household income $125k-149,999",
    "B19001B_016",  "hhinc_black_15",    "Black alone household income $150k-199,999",
    "B19001B_017",  "hhinc_black_16",    "Black alone household income $200k or more")



df <- get_acs(
  geography = "tract",
  variables = combined_vars$name,
  state = "PR",
  year = 2022,
  survey = "acs5",
  geometry = TRUE,
  show_call = TRUE)


out <- df %>% st_drop_geometry() %>% 
  left_join(combined_vars, by = c("variable" = "name")) %>% 
  select(-moe, -variable, -desc) %>% 
  pivot_wider(names_from = shortname, values_from = estimate)

# -- Output ---
fwrite(out, args$output) 
write.table(combined_vars, args$notes, sep = "\t", quote = FALSE)
