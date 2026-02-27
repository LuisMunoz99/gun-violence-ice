# Script: eda.R
# Author: LMN
# Maintainer: LMN
# Date: 2025-07-24
# ---------------------------------------

# --- libs ---
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(
  here,       
  data.table,  
  dplyr,       
  tidyr,       
  ggplot2,    
  corrplot,   
  glue       
)

# --- args ---
args <- list(
  input = here("./models/merge/output/deaths-ct.csv"),  # Merged dataset
  figs   = here("figs")                              # Folder for saving figures
)

# --- import ---
df <- fread(args$input) 
print(summary(select(df, population, poverty_pct, hhinc_median, deaths)))

# --- 2. Distribution of Deaths ------------------------------------------------
mean_deaths <- mean(df$deaths)
var_deaths  <- var(df$deaths)
message(glue("Mean deaths = {mean_deaths}, Variance = {var_deaths}"))

p1 <- ggplot(df, aes(x = deaths)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "white") +
  labs(title = "Distribution of Firearm Death Counts by Tract",
       x = "Deaths", y = "Frequency")
print(p1)


df_long <- df %>%
  select(deaths, poverty_pct, hhinc_median) %>%
  pivot_longer(
    cols      = c(poverty_pct, hhinc_median),
    names_to  = "predictor",
    values_to = "value"
  )

g <- ggplot(df_long, aes(x = value, y = deaths)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "loess", se = FALSE, color = "red") +
  facet_wrap(~ predictor, scales = "free_x", nrow = 1) +
  labs(
    title = "Firearm Deaths vs Structural Predictors",
    x     = "Predictor value",
    y     = "Number of Deaths"
  ) +
  theme_minimal()

print(g)


df_corr <- df %>% select(poverty_pct, hhinc_median)
corr_mat <- cor(df_corr, use = "complete.obs")
print(corr_mat)
corrplot(corr_mat, method = "number", title = "Predictor Correlations")

df_summary <- df %>%
  summarise(
    mean_deaths = mean(deaths),
    var_deaths  = var(deaths),
    mean_poverty = mean(poverty_pct, na.rm = TRUE),
    mean_income  = mean(hhinc_median, na.rm = TRUE),
  )

df_summary
# Done 
