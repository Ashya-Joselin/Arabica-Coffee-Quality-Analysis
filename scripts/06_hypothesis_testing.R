# Hypothesis Testing - Processing Method vs Quality

library(readr)
library(janitor)
library(forcats)
library(dplyr)

coffee <- read_csv("data/arabica_data_cleaned.csv", show_col_types = FALSE) %>%
  clean_names() %>%
  drop_na(total_cup_points, processing_method)

coffee <- coffee %>%
  mutate(processing_method = fct_lump_n(as.factor(processing_method), n = 3))

# One-way ANOVA: does processing method affect total cup points?
fit <- aov(total_cup_points ~ processing_method, data = coffee)

summary(fit)

# Post-hoc pairwise comparison
TukeyHSD(fit)
