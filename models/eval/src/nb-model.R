# Script: model_baseline.R
# Author:     LMN
# Maintainer: LMN
# Date:       2025-07-24
# ------------------------------------------------------------------------------

# --- libs --- 
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(
  here, data.table, dplyr, MASS, performance, DHARMa, performance
)



args <- list(
  input      = here("./models/merge/output/deaths-ct.csv"),
  model_rds   = here("./models/output/nb_model.rds"),
  coeffs_csv  = here("./models/output/nb_model_coeffs.csv")
)

# --- inputs --- 
df <- fread(args$input)   %>%
    filter(population > 0 | !is.na(poverty_pct)) 


# --- models --- 
# poisson
poisson_model <- glm(
  deaths ~ poverty_pct + offset(log(population)),
  family = poisson(),
  data = df
)

# overdispersion test
od <- check_overdispersion(poisson_model)
print(od)

# The Poisson regression assumes that the mean and variance are equal.
# However, the test results indicate overdispersion:
#   - Dispersion ratio = 1.667
#   - p-value < 0.001
#
# This means the observed variability in the data is significantly
# higher than what the Poisson model expects, making it unreliable.
#
# As a result, we switch to a Negative Binomial regression

# negative binomial 
nb_model <- glm.nb(
  deaths ~ poverty_pct + offset(log(population)),
  data = df
)

print(summary(nb_model))


## --- Diagnostics --- 
###  Model Comparison using AIC:
#
# AIC (Akaike Information Criterion) evaluates model fit while penalizing 
# complexity. Lower AIC indicates a better balance between goodness
# of fit and simplicity.
AIC(poisson_model, nb_model)


# Simulate standardized residuals using DHARMa
# This creates simulated residuals under the fitted model to test for
# model violations such as non-normality, overdispersion, zero-inflation,
# heteroscedasticity, and outliers in a robust and interpretable way.

sim_res <- simulateResiduals(fittedModel = nb_model)


# overall 
# --- Global Residual Diagnostics: testResiduals() ---
#
# This function runs a comprehensive battery of tests on the simulated residuals
# to assess overall model adequacy. It includes:
#
# 1. **Uniformity Test (Kolmogorov–Smirnov)**  
#    → Checks if residuals follow a uniform distribution as expected under a well-fitting model.  
#    → p > 0.05 suggests residuals are well-behaved (good fit).
#
# 2. **Dispersion Test**  
#    → Compares variance of residuals to the expectation under the model.  
#    → Detects overdispersion (variance > mean) or underdispersion.  
#    → p > 0.05 means acceptable dispersion.
#
# 3. **Zero-Inflation Test**  
#    → Compares number of predicted vs. observed zero outcomes.  
#    → Helps detect if a zero-inflated model is needed.  
#    → p > 0.05 means no evidence of zero-inflation.
#
# 4. **Outlier Test**  
#    → Checks for more extreme residuals than expected.  
#    → p > 0.05 suggests the number of outliers is within expected bounds.
#
# Interpretation:
# - If all p-values > 0.05 → the model passes these basic diagnostic tests.
# - If any p-value < 0.05 → investigate the specific assumption violated.
#   This may indicate a need for model refinement (e.g., different predictors,
#   alternative family, zero-inflation handling, etc.).
#
# Note: Always combine statistical tests with visual diagnostics (e.g., QQ plots, residual plots).

testResiduals(sim_res)






### Plot of Simulated Residuals vs Predicted Values (DHARMa)
#
# This diagnostic checks for patterns in the residuals relative to the
# model's fitted values. A good model will show randomly scattered points.
# Visible trends or shapes may indicate non-linearity, heteroscedasticity,
# or other model misspecifications.

# Checks for patterns in residuals relative to fitted values.
# A well-specified model should show a flat, random scatter of points.
# Result: No significant patterns or heteroscedasticity detected.
# The residuals appear independent and uniformly distributed.
plotResiduals(sim_res)


plotResiduals(sim_res, form = ~ poverty_pct)


# Uniformity Test of Simulated Residuals 
#
# This test (Kolmogorov–Smirnov) checks whether the simulated residuals 
# follow a uniform distribution between 0 and 1, as expected under a well-specified model.
# If the p-value is > 0.05, we do not reject the null hypothesis of uniformity,
# suggesting that the model fits the data well in terms of residual distribution.
# If p < 0.05, this indicates a potential misspecification in the model.
#
# Use together with plotQQunif() for visual inspection. 
# QQ Plot of Simulated Residuals 
#
# This plot checks whether the residuals from the model follow a uniform
# distribution, as expected under a correctly specified model.
# Points should lie close to the diagonal. Deviations suggest
# misspecification, such as incorrect distributional assumptions.

testUniformity(sim_res)
plotQQunif(sim_res)


### Dispersion Test (DHARMa)
#
# This test checks whether the observed variance in residuals matches
# the variance expected under the model. It detects overdispersion or
# underdispersion that may indicate model misspecification.
#
# Result interpretation:
# - p > 0.05 → Dispersion is acceptable (model fits well)
# - p < 0.05 → Over/underdispersion detected (model may need revision)

testDispersion(sim_res)

### Zero-Inflation Test (DHARMa)
#
# This test checks whether the model predicts the correct number of zeros.
# It compares the observed vs expected frequency of zero outcomes.
#
# Result interpretation:
# - p > 0.05 → No zero-inflation detected (model appropriate)
# - p < 0.05 → Zero-inflation detected (consider zero-inflated model)

testZeroInflation(sim_res)

### Outlier Test (DHARMa)
#
# This test identifies observations that deviate strongly from what the
# model expects, based on simulated prediction intervals.
#
# Result interpretation:
# - p > 0.05 → Number of extreme values is within expectations
# - p < 0.05 → Too many outliers detected; model may not fit all points well
#
testOutliers(sim_res)

### Pseudo R² (McFadden)
#
# Indicates the proportion of variance explained by the model,
# analogous to R² in linear regression. Useful for model interpretability.
# Higher values indicate better explanatory power.
r2(nb_model)

# Note: Always combine statistical tests with visual diagnostics (e.g., QQ plots, residual plots).








# --- export --- 
saveRDS(nb_model, args$model_rds)

# Save coefficient estimates
summary(nb_model)$coefficients %>%
  as.data.frame() %>%
  tibble::rownames_to_column(var = "term") %>%
  mutate(rate_ratio = exp(Estimate)) %>%
  fwrite(args$coeffs_csv)
