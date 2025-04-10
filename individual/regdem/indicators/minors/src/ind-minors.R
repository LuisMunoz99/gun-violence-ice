# Authors:     LM
# Maintainers: LM
# Date: 22-Aug-24

# --- libs ---
if (!require(pacman)) install.packages("pacman")
p_load(dplyr,
       here,
       data.table,
       openxlsx,
       stringr)


args <- list(input = here("individual/regdem/import/output/regdem2019-2022.csv"),
             output = here("individual/regdem/indicators/minors/output/minors.csv"))

# --- Import data -
minors <- fread(args$input) %>%
    filter(AgeUnit %in% c("Years", "1-135 AÑOS")) %>%
    filter(!is.na(Age) & Age != 0) %>%
    mutate(
           ind_minor = if_else(Age >= 1 & Age <= 19, TRUE, FALSE))  %>% 
    filter(ind_minor)  %>%
    distinct(ControlNumber, ind_minor = TRUE) 

# export 
fwrite(minors, args$output, row.names = FALSE)
