# Script: adjust-minors-pop.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-04-06
# ---------------------------------------
if (!require(pacman)) install.packages("pacman")
p_load(dplyr,
       here,
       data.table)


args <- list(input = here("individual/census/import/output/pop-1-19-census.csv"),
             output = here("individual/census/adjust-pop/output/pop-1-19-census-final.csv"))

pop <- fread(args$input)

# --- Population Adjustment ---
# Method: Uniform proportional adjustment
# Assumption: The population aged 0 to 4 is evenly distributed.
# Therefore, we estimate the population aged 1–4 as 4/5 of the total under 5,
# and add it to the exact age groups available (5–9, 10–14, etc.)

pop_1_19 <- pop %>%
  mutate(
    men_1_4   = (4 / 5) * men_under5,
    women_1_4 = (4 / 5) * women_under5,
    pop_1_19 = men_1_4 + men_5_9 + men_10_14 + men_15_17 + men_18_19 +
               women_1_4 + women_5_9 + women_10_14 + women_15_17 + women_18_19
           )  %>%
  filter(pop_total >= 60) # identify a better criteria to exclude 

fwrite(pop_1_19, args$output)
