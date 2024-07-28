# Authors:     LM
# Maintainers: LM
# Date: 19-Feb-24
# =========================================

# Creating indicators for specific table of cases of interest from regdem task
# source = Death Registry database


# --- libs ---
if (!require(pacman)) install.packages("pacman")
p_load(dplyr,
       here,
       data.table,
       openxlsx,
       stringr)


args <- list(input = here("regdem/import/output/"),
             output = here("regdem/firearm-rip/output/"))


# --- Import data ---

regdem <- list()
years <- c(2018:2022)

for (year in years) {
  file_path <- paste0(args$input, "regdem", year, ".csv")
  regdem[[as.character(paste0("regdem", year))]] <- fread(file_path)
}


ICD_firearm <- c("w32", "w33", "w34", "x72", "x73", "x74",
                 "x93", "x94", "x95", "y22", "y23", "y24", "y350")

regdem_done <- lapply(regdem, function(df) {
  df <- df %>%
    filter(AgeUnit %in% c("Years", "1-135 AÑOS")) %>%
    filter(Age != 0) %>%
    mutate_all(tolower)
  # Indicators
  df <- df %>%
    mutate(
      minors = ifelse(Age >= 1 & Age <= 19, 1, 0),
      firearm = case_when(
        DeathCause_I_ID %in% ICD_firearm ~ 1,
        TRUE ~ 0)
    )

  return(df)
})




# --- Output ---

out <- lapply(regdem_done, function(df) {
  df <- filter(df, minors == 1 & firearm == 1)
  return(df)
})

# separating each year into a different csv file
for (i in seq_along(out)) {
  write.csv(out[[i]],
            file = paste0(args$output, names(regdem)[i], "-CF.csv"),
            row.names = FALSE)
}



# Done (reviewed in 3 Jul 2024)
