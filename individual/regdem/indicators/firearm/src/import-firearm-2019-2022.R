## Authors: LM
# Maintainers: LM
# Date: 19-Feb-24
# =========================================
# Purpose: Extract firearm-related deaths among minors (1-19 years old)
# Data Source: Death Registry database (2019-2022)

# --- Load Required Libraries ---
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(dplyr, here, data.table, stringr, tidyr)

# --- Define File Paths Using args$input ---
args <- list(
  input = here("individual/regdem/import/output/regdem2019-2022.csv"),
  output = here("individual/regdem/indicators/firearm/output/firearm-2019-2022.csv")
)

# --- Define ICD-10 Firearm-Related Codes ---
firearm_codes <- c(
  "W32", "W33", "W34",  # Accidental firearm discharge
  "X72", "X73", "X74",  # Intentional self-harm by firearm (suicide)
  "X93", "X94", "X95",  # Assault by firearm (homicide)
  "Y22", "Y23", "Y24",  # Firearm discharge of undetermined intent
  "Y350",               # Legal intervention with firearm
  # Subcategories:
  "W32.0", "W32.1", "W32.2", "W32.3",
  "X72.0", "X72.1", "X72.8", "X72.9",
  "X93.0", "X93.1", "X93.8", "X93.9",
  "Y22.0", "Y22.1", "Y22.8", "Y22.9"
)

firearm <- read.csv(args$input) %>%
  mutate(
    DeathCause_I_ID   = toupper(trimws(DeathCause_I_ID)),
    DeathCause_I_Desc = tolower(trimws(DeathCause_I_Desc)),
    firearm = case_when(
      DeathCause_I_ID %in% firearm_codes ~ TRUE,
      str_detect(DeathCause_I_Desc, "\\b(firearm|gun|pistol|rifle|shotgun)\\b") ~ TRUE,
      TRUE ~ NA
    )
  ) %>%
  filter(firearm)

# output 
write.csv(firearm, args$output) 
