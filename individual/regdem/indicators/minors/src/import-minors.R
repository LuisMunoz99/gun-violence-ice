# Authors:     LM
# Maintainers: LM
# Date: 22-Aug-24

# --- libs ---
if (!require(pacman)) install.packages("pacman")
p_load(dplyr,
       here,
       readr,
       openxlsx,
       stringr)


args <- list(input = here("individual/regdem/import/output/regdem2019-2022.csv"),
             output = here("individual/regdem/indicators/minors/output/minors-2019-2022.csv"))

# --- Import data -
minors <- read.csv(args$input) %>%
    filter(AgeUnit %in% c("Years", "1-135 AÑOS")) %>%
    filter(!is.na(Age) & Age != 0) %>%
    mutate(
            minors = if_else(Age >= 1 & Age <= 19, TRUE, FALSE)
    )  %>% 
    filter(minors) 



# separating each year into a different csv file
write.csv(minors, args$output)


# Done 
