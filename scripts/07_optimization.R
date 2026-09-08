# Optimization - Ideal Sensory Profile for Maximum Score

library(readr)
library(janitor)
library(dplyr)

coffee <- read_csv("data/arabica_data_cleaned.csv", show_col_types = FALSE) %>%
  clean_names() %>%
  drop_na(total_cup_points, aroma, flavor, aftertaste, acidity, body, balance)

form <- total_cup_points ~ aroma + flavor + aftertaste + acidity + body + balance

fit <- lm(form, data = coffee)

beta <- coef(fit)

pred <- function(x) {
  beta[1] + sum(beta[-1] * x)
}

# Use the 5th-95th percentile range of each attribute as realistic bounds
bounds <- summarise(coffee,
                     aroma_lo = quantile(aroma, 0.05),
                     aroma_hi = quantile(aroma, 0.95),
                     flavor_lo = quantile(flavor, 0.05),
                     flavor_hi = quantile(flavor, 0.95),
                     aftertaste_lo = quantile(aftertaste, 0.05),
                     aftertaste_hi = quantile(aftertaste, 0.95),
                     acidity_lo = quantile(acidity, 0.05),
                     acidity_hi = quantile(acidity, 0.95),
                     body_lo = quantile(body, 0.05),
                     body_hi = quantile(body, 0.95),
                     balance_lo = quantile(balance, 0.05),
                     balance_hi = quantile(balance, 0.95))

lo <- as.numeric(bounds[1, seq(1, 11, by = 2)])
hi <- as.numeric(bounds[1, seq(2, 12, by = 2)])

start <- (lo + hi) / 2

res <- optim(par = start,
             fn = function(x) -pred(x),
             method = "L-BFGS-B",
             lower = lo, upper = hi)

list(optimal_profile = setNames(res$par, names(coffee)[3:8]),
     predicted_total_cup_points = -res$value)
