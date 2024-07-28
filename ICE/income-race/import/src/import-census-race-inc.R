
# Authors:     LM
# Maintainers: LM
# Date: 25-Feb-24

# Importing census data for ICE income indicators
# to analyze firearm deaths in minors 

# --- libs --- 
if(!require(pacman))install.packages("pacman")
p_load(dplyr, 
       here,
       data.table,
       sf,
       tidyr,
       tidycensus)

args <- list(
  output1 = here("ICE/income-race/import/output/IceIncWhiteCensus.csv"),
  output2 = here("ICE/income-race/import/notes/IceIncWhiteVarsDic.txt"))


# --- import --- 
var_dic <- load_variables(2021, "acs5") # Importing all variables in census

# Variables corresponding to ICE measure
income_data_vars <-
  tibble::tribble(
    ~name,          ~shortname,      ~desc,
    
    # All race income households 
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
    "B01003_001", 'pop_total',    "total population",
    
    # White alone income households
    "B19001A_001", 'hhinc_white_total', "white alone total household income estimates",
    "B19001A_002", 'hhinc_white_1',   "white alone household income <$10k",
    "B19001A_003", 'hhinc_white_2',     "white alone household income $10k-14,999",
    "B19001A_004", 'hhinc_white_3',     "white alone household income $15k-19,999",
    "B19001A_005", 'hhinc_white_4',     "white alone household income $20k-24,999",
    "B19001A_006", 'hhinc_white_5',     "white alone household income $25k-29,999",
    "B19001A_007", 'hhinc_white_6',     "white alone household income $30k-34,999",
    "B19001A_008", 'hhinc_white_7',     "white alone household income $35k-39,999",
    "B19001A_009", 'hhinc_white_8',     "white alone household income $40k-44,999",
    "B19001A_010", 'hhinc_white_9',     "white alone household income $45k-49,999",
    "B19001A_011", 'hhinc_white_10',    "white alone household income $50k-59,999",
    "B19001A_012", 'hhinc_white_11',    "white alone household income $60k-74,999",
    "B19001A_013", 'hhinc_white_12',    "white alone household income $75k-99,999",
    "B19001A_014", 'hhinc_white_13',    "white alone household income $100k-124,999",
    "B19001A_015", 'hhinc_white_14',    "white alone household income $125k-149,999",
    "B19001A_016", 'hhinc_white_15',    "white alone household income $150k-199,999",
    "B19001A_017", 'hhinc_white_16',    "white alone household income $200k or more")


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
out <- income_data %>% st_drop_geometry() %>% 
  left_join(income_data_vars, by = c("variable" = "name")) %>% 
  select(-moe, -variable, -desc) %>% 
  pivot_wider(names_from = shortname, values_from = estimate) %>% 
  filter(pop_total > 60)



# Create a new data frame 'out_final' and initialize it with the same data as the original data frame 'out'
out_final <- out

# measuring non white populations by extracting total people with income from white alone

# Start a loop that will iterate 17 times, with 'i' taking values from 1 to 17 in each iteration
for (i in 1:16) {
  out_final <- out_final %>%
    mutate(!!paste0("hhinc_no_white_", i) := 
             !!sym(paste0("hhinc", i)) - !!sym(paste0("hhinc_white_", i)))
}

# -- Output ---
write.table(income_data_vars, args$output2, sep = "\t", quote = FALSE)
fwrite(out_final, args$output1) 



#Done (verified in 03-Jul-24)
