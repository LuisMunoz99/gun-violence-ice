# Authors:     LM
# Maintainers: LM
# Date: 6-Feb-24
# =========================================

# Importing demographic registry databases
# source = Death Registry database
# Purpose = set variables types and create indicators of interest


# --- libs ---
if (!require(pacman)) install.packages("pacman")
p_load(dplyr,
       here,
       readxl,
       stringr,
       lubridate)


args <- list(input1 = here("regdem/import/input/regdem_2015-2020.xlsx"),
             input2 = here("regdem/import/input/regdem2020.xlsx"),
             input3 = here("regdem/import/input/regdem_2021_agosto2022.xlsx"),
             input4 = here("regdem/import/input/regdem_2022.xlsx"),
             output = here("regdem/import/output/"))

# --- Functions ---

## Verify NA
verify_NA <- function(data) {
  if_else(any(is.na(data$ControlNumber)),
          "Error: NA values",
          "GOOD")
}

## Verify duplicates
verify_duplicates <- function(data) {
  if_else(any(duplicated(data$ControlNumber)),
          "Error: Duplicates",
          "GOOD")
}


# Filtering and fixing bars
selected_data <- function(data) {
  selected <- data %>% select(
    DeathDate, ControlNumber,Name, LastName, SecondLastName,
    Age, AgeUnit, DeathNumber, InscriptionYear,
    ResidencePlaceAddress1, ResidencePlaceAddress2,
    ResidencePlaceAddress3, ResidencePlaceAddressZip,
    DeathCause_I_ID = "DeathCause_I (ID)",  # Renaming a variable
    DeathCause_I_Desc = "DeathCause_I (Desription)"
  )
  return(selected)
}

# --- Regdem 2015-2019 ---


##  Importing 2015-2019
reg15_20 <- read_excel(args$input1)

# Excluding 2020 because is not complete, another dataset will represent 2020
regdem15_19 <- reg15_20 %>%
  filter(InscriptionYear != 2020) %>%
  selected_data


for (i in unique(regdem15_19$InscriptionYear)) {
  single_year <- regdem15_19 %>% filter(InscriptionYear == i)
  # Assign the filtered data to a new data frame named regdem + year
  assign(paste0("regdem", i), single_year)
}



# --- Regdem 2020 ---

# Importing 2020
regdem2020 <- read_excel(args$input2)
regdem2020 <- regdem2020 %>%
  filter(InscriptionYear == 2020) %>%
  mutate(ControlNumber = "NULL") %>%
  selected_data

# --- Regdem 2021 ---

# Importing 2021
regdem2021 <- read_excel(args$input3)

regdem2021 <- regdem2021 %>%
  filter(InscriptionYear == 2021) %>%
  selected_data


verify_duplicates(regdem2021) # Duplicates detected
verify_NA(regdem2021)


# --- Regdem 2022 ---
# Importing 2022
regdem2022 <- read_excel(args$input4)

regdem2022 <- regdem2022 %>%
  filter(InscriptionYear == 2022) %>%
  selected_data


verify_duplicates(regdem2022)
verify_NA(regdem2022)




# --- Export ---

# Creating a list of all regdems for each year, based on InscriptionYear

regdem <- list()
for (i in 2015:2022) {
  regdem[[as.character(i)]] <- get(paste0("regdem", i))
}


# Writting CSV
for (i in seq_along(regdem)) {
  write.csv(regdem[[i]],
            file = paste0(args$output, "regdem", names(regdem)[i], ".csv"),
            row.names = FALSE)
}
