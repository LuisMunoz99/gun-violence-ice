# Script: merge.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-04-29
# ---------------------------------------

if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(
               here,
               data.table,
               dplyr,
               ggplot2,
               tidyr)

# args {{{
args <- list(firearm_minors = here("./firearm-minors/export/output/firearm-minors-final.csv"), 
             hhincome = here("./ICE/export/output/ice-hhincome.csv"),
             combined = here("./ICE/export/output/ice-combine.csv"),
             minors_pop = here("./individual/census/export/output/pop-1-19-census-final.csv"),
             output = here("./merge/output/ice-analysis-final.csv"))


# import 
firearm_minors <- fread(args$firearm_minors)
hhincome <- fread(args$hhincome)
combined <- fread(args$combined)
minors_pop <- fread(args$minors_pop) 


# Merge firearm que tiene coords
# merge ct data (buscar cual es la version master??? o solo tener los geoid y entonces anadirle los ICE values y deprived and shit 
# los ice values anadirlos tambien los de cada metrica en el mismo df? 
# merge un paquete para que write lo use entero.
# anadirle las poblaciones de menores 


out <- minors_pop %>%
  left_join(firearm_minors, by = "GEOID") %>%
   mutate(firearm_minor = ind_firearm & ind_minor)  %>%
  group_by(GEOID, pop_1_19) %>%
  summarize(
    firearm_minor = sum(firearm_minor, na.rm = TRUE),
    ControlNumber = paste(unique(ControlNumber), collapse = "|"),
    name = paste(unique(Name), collapse = "|"),
    .groups = "drop")  %>%
  left_join(hhincome, by = "GEOID")  %>%
  left_join(combined, by = "GEOID")

fwrite(out, args$output) 

