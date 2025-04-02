# Authors:     LM
# Maintainers: LM
# Date: 24-feb-24
# ===========================================

# Importing PUMS data for income household
# Selecting only variables of interest

# -- libs ---
if (!require(pacman)) install.packages("pacman")
p_load(dplyr,
       data.table,
       here,
       tidycensus,
       tidyr)

# args {{{
args <- list(input = here("individual/PUMS/import/input/psam_h72.csv"),
             output = here("individual/PUMS/import/output/pumsHIncome.csv"))

data(pums_variables)

pums_variables %>%
  filter(year == 2019, survey == "acs1") %>%
  distinct(var_code, var_label, data_type, level)

# -- import ---

## PUMS_inc <- get_pums(
##  variables = "HINCP", 
## state = "PR",
## year = 2022,
## survey = "acs5")

# https://github.com/walkerke/tidycensus/issues/425
# This is an issue

# Vars from Census
# HINCP = Income Household

pums_inc <- fread(args$input) %>%
  select(RT:ACCESSINET, HINCP) %>%
  filter(HINCP >= 0)

summary(pums_inc)

## Keeping only positive values.


# Export the table of quintiles to a text file
write.csv(pums_inc, args$output)




# DONE
