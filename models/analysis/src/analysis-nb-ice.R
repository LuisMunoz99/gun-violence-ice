# Script: analysis.R
# Author:     LMN
# Maintainer: LMN
# Date:       2025-07-26
# ------------------------------------------------------------------------------

# --- libs ---
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(
  here, data.table, dplyr, MASS
)

# --- inputs ---
# Define file paths for input data and the saved model
args <- list(
  input      = here("./merge/output/ice-analysis-final.csv"),
  model_rds  = here("./models/eval/output/nb_model_quintile.rds"),
  output_csv = here("./models/analysis/output/excess-mortality-results.csv")
)

# Read the input data file
df <- fread(args$input)  %>%
    mutate(ICE_hhinc_quintile = as.factor(ICE_hhinc_quintile))

# Load the final model object from the evaluation step
nb_model_quintile <- readRDS(args$model_rds)

# --- analysis ---
# Method 1: Calculate disparity relative to an "equitable" baseline
# This model represents the expected deaths if the rate were uniform.
baseline_model <- glm.nb(
  firearm_minor ~ 1 + offset(log(pop_1_19)),
  data = df
)

# Predict the expected deaths from the baseline model
df$baseline_expected <- predict(baseline_model, newdata = df, type = "response")

# Aggregate the disparity by quintile
disparity_by_quintile <- df %>%
  group_by(ICE_hhinc_quintile) %>%
  summarise(
    observed_deaths = sum(firearm_minor, na.rm = TRUE),
    baseline_expected_deaths = sum(baseline_expected, na.rm = TRUE)
  ) %>%
  mutate(
    disparity = observed_deaths - baseline_expected_deaths,
    percent_disparity = (disparity / baseline_expected_deaths) * 100
  ) %>%
  filter(!is.na(ICE_hhinc_quintile))

print(disparity_by_quintile)

# Method 2: Calculate excess deaths relative to the most advantaged quintile (quintile 5)
# This is a "best-case scenario" baseline.

# Predict expected deaths using the loaded quintile model
df$predicted_deaths <- predict(nb_model_quintile, newdata = df, type = "response")

# Get the model's expected death rate for the most advantaged quintile
quintile5_rate <- df %>%
  dplyr::filter(ICE_hhinc_quintile == 5) %>%
  dplyr::summarise(
    total_deaths = sum(predicted_deaths, na.rm = TRUE),
    total_pop = sum(pop_1_19, na.rm = TRUE)
  ) %>%
  dplyr::mutate(rate = total_deaths / total_pop) %>%
  pull(rate)

# Calculate the "standardized" expected deaths and excess deaths for all quintiles
mortality_by_quintile <- df %>%
  filter(!is.na(ICE_hhinc_quintile)) %>%
  dplyr::mutate(standardized_expected = quintile5_rate * pop_1_19) %>%
  dplyr::group_by(ICE_hhinc_quintile) %>%
  dplyr::summarise(
    observed_deaths = sum(firearm_minor, na.rm = TRUE),
    standardized_expected = sum(standardized_expected, na.rm = TRUE)
  ) %>%
  dplyr::mutate(
    excess_deaths = observed_deaths - standardized_expected,
    percent_excess = (excess_deaths / standardized_expected) * 100
  ) %>%
  dplyr::arrange(ICE_hhinc_quintile)

print(mortality_by_quintile)

# --- export ---
# Save the final results table to a CSV file
fwrite(mortality_by_quintile, args$output_csv)
