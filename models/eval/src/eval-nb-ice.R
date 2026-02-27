# Script: model_evaluation.R
# Author:     LMN
# Maintainer: LMN
# Date:       2025-07-26
# ------------------------------------------------------------------------------

# --- libs ---
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(
  here, data.table, dplyr, MASS, performance, DHARMa, tibble
)

# --- inputs ---
# Define file paths for input and output
args <- list(
  input      = here("./merge/output/ice-analysis-final.csv"),
  model_rds  = here("./models/eval/output/nb_model_quintile.rds"),
  coeffs_csv = here("./models/eval/output/nb_model_quintile_coeffs.csv")
)

# Read the input data file
df <- fread(args$input)

# --- data prep ---
# Ensure the quintile variable is treated as a factor for the model
df$ICE_hhinc_quintile <- as.factor(df$ICE_hhinc_quintile)

# --- models ---
# Poisson Regression: The baseline model for count data.
poisson_model <- glm(
  firearm_minor ~ ICE_hhinc + offset(log(pop_1_19)),
  family = poisson(),
  data = df
)

# Overdispersion Test: Checks if the Poisson assumption is violated.
od <- check_overdispersion(poisson_model)
print(od)

# Negative Binomial Regression with ICE_hhinc (continuous)
nb_model <- glm.nb(
  firearm_minor ~ ICE_hhinc + offset(log(pop_1_19)),
  data = df
)

# Negative Binomial Regression with ICE_hhinc (quintiles)
# This is the final model as it does not assume a linear relationship.
nb_model_quintile <- glm.nb(
  firearm_minor ~ ICE_hhinc_quintile + offset(log(pop_1_19)),
  data = df
)

print(summary(nb_model_quintile))

# --- metrics and diagnostics ---
## Model Comparison using AIC
# A lower AIC indicates a better balance between fit and complexity.
AIC(poisson_model, nb_model, nb_model_quintile)

## DHARMa Diagnostics
# Simulate standardized residuals for the final model (nb_model_quintile)
sim_quintiles <- simulateResiduals(fittedModel = nb_model_quintile)

# Global Residual Diagnostics: testResiduals()
# This checks for uniformity, dispersion, and zero-inflation.
# All p-values > 0.05 are desired.
testResiduals(sim_quintiles)

# Plot of Simulated Residuals vs. Fitted Values
# A well-specified model shows a flat, random scatter of points.
plot(sim_quintiles)

# QQ Plot of Simulated Residuals
# Checks if residuals follow a uniform distribution. Points should be on the diagonal line.
plotQQunif(sim_quintiles)

## Pseudo R² (Nagelkerke)
# Indicates the proportion of variance explained by the model.
r2(nb_model_quintile)

# --- export ---
# Save the best-performing model (based on AIC and diagnostics)
saveRDS(nb_model_quintile, args$model_rds)

# Save the coefficient estimates for the final model
summary(nb_model_quintile)$coefficients %>%
  as.data.frame() %>%
  tibble::rownames_to_column(var = "term") %>%
  mutate(rate_ratio = exp(Estimate)) %>%
  fwrite(args$coeffs_csv)
