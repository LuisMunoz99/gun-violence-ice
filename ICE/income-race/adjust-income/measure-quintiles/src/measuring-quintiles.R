# Authors:     LM
# Maintainers: LM
# Date: 24-feb-24
# ===========================================

# Calculating quintiles for Puerto Rico
# Based on previous PUMS import

# -- libs ---
if (!require(pacman)) install.packages("pacman")
p_load(dplyr,
       here,
       tidycensus,
       data.table,
       tidyr,
       knitr)

# args {{{
args <- list(input = here("ICE/income-race/adjust-income/import/output/pumsHIncome.csv"),
             output = here("ICE/income-race/adjust-income/measure-quintiles/output/HI-quintiles.csv"))
# -- import ---

pums_inc <- fread(args$input)


# -- Quintiles ---
# Method one: Quintiles() package
pums_inc <- pums_inc %>% mutate(HINCP = sort(HINCP))

quintiles <- quantile(pums_inc$HINCP, probs = seq(0, 1, 1 / 5))
print(quintiles)

# Method two: ntile package and then average
## https://ui.josiahparry.com/creating-new-measures

## Esto es consistente con el Center for a new economy
max(pums_inc$HINCP)


ntile_test <- pums_inc %>%
  mutate(inc_quintile = ntile(HINCP, 5))

pums_inc %>%
  mutate(inc_quintile = ntile(HINCP, 5)) %>%
  group_by(inc_quintile) %>%
  summarise(mean = mean(HINCP))


# -- Export ---
quintiles_df <- data.frame(
  Quintile = c("1st Quintile (0% - 20%)",
               "2nd Quintile (20% - 40%)",
               "3rd Quintile (40% - 60%)",
               "4th Quintile (60% - 80%)",
               "5th Quintile (80% - 100%)"),
  `upper limits` = quintiles[-1]  # Exclude the first value
)

fwrite(quintiles_df, args$output)

#DONE reviewed  3 Jul 2024
