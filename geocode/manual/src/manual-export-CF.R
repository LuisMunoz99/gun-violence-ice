# Authors:     LM
# Maintainers: LM
# Date: 19-Feb-24
# =========================================

# Exporting deaths of childrens due to firearm
# source = Death Registry database

# --- libs ---
if (!require(pacman)) install.packages("pacman")
p_load(dplyr,
       here,
       data.table,
       openxlsx,
       stringr)

args <- list(input = here("regdem/firearm-rip/output/"),
             output = here("geocode/manual/output/geocoding-CF-2018-2022.xlsx"))

# --- Import data ---

regdemCF <- list()
years <- c(2018:2022)

for (year in years) {
  file_path <- paste0(args$input, "regdem", year, "-CF.csv")
  regdemCF[[as.character(paste0("regdem", year))]] <- fread(file_path)
}

# --- Cleaning  ---

regdem_geocode <- lapply(regdemCF, function(df) {
  df <- df %>%
    mutate_all(~tolower(.)) %>%
    mutate_all(~str_squish(.)) %>%
    mutate(longitude = NA,
           latitude = NA)
})



# --- Export  ---
write.xlsx(list("2018" = regdem_geocode[[1]],
                "2019" = regdem_geocode[[2]],
                "2020" = regdem_geocode[[3]],
                "2021" = regdem_geocode[[4]],
                "2022" = regdem_geocode[[5]]),
           file = args$output,
           sheetNames = c("2018", "2019", "2020", "2021", "2022"))


## DONE  (reviewed 3 JULY 2024)
