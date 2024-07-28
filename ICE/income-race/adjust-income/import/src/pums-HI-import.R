# Authors:     LM
# Maintainers: LM
# Date: 24-feb-24
# ===========================================

# Importing PUMS data for income household
# Selecting only variables of interest

## WE HAVE TO CLARIFY IF ITS CORRECT TO EXCLUDE LESS THAN 0
## following conversations with Ricardo,
## he finds it appropiate to exclude negative income values

# -- libs ---
if (!require(pacman)) install.packages("pacman")
p_load(dplyr,
       data.table,
       here,
       tidycensus,
       tidyr)

# args {{{
args <- list(input = here("ICE/income-race/adjust-income/import/input/psam_h72.csv"),
             output = here("ICE/income-race/adjust-income/import/output/pumsHIncome.csv"))


pums_variables %>%
  filter(year == 2019, survey == "acs1") %>%
  distinct(var_code, var_label, data_type, level)

# -- import ---
pums_inc <- fread(args$input) %>%
  select(RT:ACCESSINET, HINCP) %>%
  filter(HINCP >= 0)

summary(pums_inc)

## Keeping only positive values.


# Export the table of quintiles to a text file
write.csv(pums_inc, args$output)




# DONE (reviewed Jul 3 2024)
