# Script: ind-firearm.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-04-21
# ---------------------------------------

# --- Load Required Libraries ---
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(dplyr, here, data.table, stringr, tidyr)

# --- Define File Paths Using args$input ---
args <- list(
  input = here("individual/regdem/import/output/regdem2019-2022.csv"),
  output = here("individual/regdem/indicators/firearm/output/firearm.csv")
)

clean_icd10 <- function(codes) {
  codes_clean <- toupper(trimws(codes))                     # Mayúsculas y trim
  codes_clean <- gsub("[^A-Z0-9]", "", codes_clean)         # Elimina todo excepto letras y números
  codes_clean <- ifelse(codes_clean == "", NA, codes_clean) # Vacíos a NA
  return(codes_clean)
}

input <- fread(args$input)  %>% 
    mutate(
           DeathCause_I_ID   = clean_icd10(DeathCause_I_ID),
           DeathCause_I_Desc = tolower(trimws(DeathCause_I_Desc)))

out <-  input %>%
  mutate(
    ind_firearm = case_when(
                            str_detect(DeathCause_I_ID, "(W32|W33|W34|X72|X73|X74|X93|X94|X95|Y22|Y23|Y24)") ~ TRUE,
                            str_detect(DeathCause_I_Desc, "\\b(firearm|gun|pistol|rifle|shotgun)\\b") ~ TRUE,
      TRUE ~ FALSE
    )
  ) %>%
  filter(ind_firearm) %>%
  distinct(ControlNumber, ind_firearm = TRUE)


# output 
fwrite(out, args$output, row.names = FALSE) 
