# Script: recode.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-05-13
# ---------------------------------------


# --- libs ---
if (!require(pacman)) install.packages("pacman")
p_load(dplyr,
       here,
       data.table,
       stringr)


args <- list(input = here("./individual/regdem/import/output/regdem2019-2022.csv"),
             output = here("./individual/regdem/recode-ICD10/output/cause-category.csv")) 

df <- fread(args$input)

library(dplyr)
library(stringr)
library(data.table)

out <- df %>%
  mutate(
    cause_category = case_when(
      # Firearms
      str_detect(DeathCause_I_ID, "^(W3[2-4]|X7[2-4]|X9[3-5]|Y2[2-4]|Y350)$") ~ "Firearms",

      # Motor vehicles: V00–V89
      str_detect(DeathCause_I_ID, "^V[0-8][0-9]") ~ "Motor vehicles",

      # Other injuries: W00–W31, W35–W99, X00–X41, X43–X46, X48–X59, X70, X80
      str_detect(DeathCause_I_ID,
                 "^(W0[0-9]|W[1-2][0-9]|W3[0-1]|W[3-9][5-9]|W[4-9][0-9]|X0[0-9]|X[1-3][0-9]|X4[0-1]|X4[3-6]|X4[8-9]|X5[0-9]|X70|X80)$") ~ "Other injuries",

      # Congenital conditions: Q00–Q99, R00–R99
      str_detect(DeathCause_I_ID, "^[QR][0-9]{2}") ~ "Congenital conditions",

      # Cancer: C00–D49
      str_detect(DeathCause_I_ID, "^C[0-9]{2}") |
        str_detect(DeathCause_I_ID, "^D[0-4][0-9]") ~ "Cancer",

      # Substance use: F10–F19, X42, X47, X64
      str_detect(DeathCause_I_ID, "^F1[0-9]$|^X42$|^X47$|^X64$") ~ "Substance use",

      # Cardiovascular diseases: I00–I78
      str_detect(DeathCause_I_ID, "^I[0-7][0-9]") ~ "Cardiovascular diseases",

      # Missing / Unknown
      is.na(DeathCause_I_ID) | DeathCause_I_ID == "" ~ "Missing/Unknown",

      # Fallback
      TRUE ~ "Other/Unclassified"
    )
  ) %>%
  distinct(ControlNumber, cause_category)


# output
fwrite(out, args$output) 
