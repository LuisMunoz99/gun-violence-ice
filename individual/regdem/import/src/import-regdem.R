## Death Registry Cleaner: Exportar datos 2019–2022 (individual y combinado)
# Author: LM | Date: 1-Apr-2025

# Cargar y, si es necesario, instalar el paquete pacman
if (!require(pacman)) install.packages("pacman")
pacman::p_load(dplyr, here, readxl, lubridate, purrr, stringr)

# --- Definición de rutas de entrada y salida ---
# Se definen los archivos de entrada por año.
args <- list(
  "2015-2020" = here("individual/regdem/import/input/regdem_2015-2020.xlsx"),  # Archivo con datos de varios años; se filtrará 2019
  "2020" = here("individual/regdem/import/input/regdem2020.xlsx"),
  "2021" = here("individual/regdem/import/input/regdem_2021_agosto2022.xlsx"),
  "2022" = here("individual/regdem/import/input/regdem_2022.xlsx"),
  output_dir = here("individual/regdem/import/output/"))

# --- Función para limpiar y estandarizar los datos ---
 clean <- function(df) {
  df %>%
    select(
      DeathDate, ControlNumber, Name, LastName, SecondLastName, Age, AgeUnit,
      Gender, DeathNumber, TypeOfDeath, InscriptionYear,
      ResidencePlaceAddress1, ResidencePlaceAddress2, ResidencePlaceAddress3,
      ResidencePlaceAddressZip,
      DeathCause_I_ID = `DeathCause_I (ID)`,
      DeathCause_I_Desc = `DeathCause_I (Desription)`
    ) %>%
    mutate(across(starts_with("residence"), as.character))  %>%
    mutate(
      parsed_date = parse_date_time(DeathDate, orders = c("ymd", "mdy", "dmy")),
      DeathDate = format(parsed_date, "%Y-%m-%d"),
      DeathDate_Year = format(parsed_date, "%Y"),
      ControlNumber = toupper(str_trim(ControlNumber)),
      Age = as.integer(suppressWarnings(Age)),
      Age = ifelse(Age < 0 | Age > 120, NA, Age),
      Gender = str_trim(tolower(Gender)),
      Gender = case_when(
        Gender %in% c("m", "male", "masculino") ~ "Male",
        Gender %in% c("f", "female", "femenino") ~ "Female",
        TRUE ~ NA_character_),
      DeathNumber = str_trim(DeathNumber)) %>% 
    distinct(ControlNumber, .keep_all = TRUE)
}

regdem <- list() 

# using onlye 2019 freom 2015-2020 
regdem[["2019"]]<- read_xlsx(args$`2015-2020`) %>%
    clean() %>% 
    filter(DeathDate_Year == "2019")

# 2020 
regdem[["2020"]]<- read_xlsx(args$`2020`) %>%
    clean() %>% 
    filter(DeathDate_Year == "2020")


# 2021
regdem[["2021"]]<- read_xlsx(args$`2021`) %>%
    clean() %>% 
    filter(DeathDate_Year == "2021")

# 2022
regdem[["2022"]]<- read_xlsx(args$`2022`) %>%
    clean() %>% 
    filter(DeathDate_Year == "2022")


# export
for (i in seq_along(regdem)) {
  year <- names(regdem)[i]
  output_file <- paste0(args$output_dir,"regdem",year,".csv")
    write.csv(regdem[[year]], output_file, row.names = FALSE)
}

merge <- bind_rows(regdem)  

write.csv(merge, paste0(args$output_dir,"regdem2019-2022.csv"))
