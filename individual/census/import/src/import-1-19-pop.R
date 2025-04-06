# Script: import-minors-pop.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-04-06
# ---------------------------------------
if (!require(pacman)) install.packages("pacman")
p_load(dplyr,
       here,
       data.table,
       tidyr,
       tidycensus)

args <- list(output1 = here("individual/census/import/output/pop-1-19-census.csv"),
             output2 = here("individual/census/import/notes/pop-vars.txt"))

pop_vars <- tibble::tribble(
  ~name,           ~shortname,      ~desc,
  "B01001_001",    "pop_total",     "hombres y mujeres (all)",
  "B01001_003",    "men_under5",     "Hombres <5",
  "B01001_004",    "men_5_9",        "Hombres 5–9",
  "B01001_005",    "men_10_14",      "Hombres 10–14",
  "B01001_006",    "men_15_17",      "Hombres 15–17",
  "B01001_007",    "men_18_19",      "Hombres 18–19",
  "B01001_027",    "women_under5",   "Mujeres <5",
  "B01001_028",    "women_5_9",      "Mujeres 5–9",
  "B01001_029",    "women_10_14",    "Mujeres 10–14",
  "B01001_030",    "women_15_17",    "Mujeres 15–17",
  "B01001_031",    "women_18_19",    "Mujeres 18–19"
)

# --- Descargar datos del ACS 5-Year para PR ---
pop <- get_acs(
  geography = "tract",
  variables = pop_vars$name,
  state = "PR",
  year = 2022,
  survey = "acs5",
  geometry = FALSE,
  show_call = TRUE
)

# --- Limpieza y formateo (wide) ---

pop <- pop %>%
  left_join(pop_vars, by = c("variable" = "name")) %>%
  select(-moe, -variable, -desc) %>%
  pivot_wider(names_from = shortname, values_from = estimate) 

# -- Output ---
fwrite(pop, args$output1)
write.table(pop_vars, args$output2, sep = "\t", quote = FALSE)
