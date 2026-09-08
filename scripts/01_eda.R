# Exploratory Data Analysis (EDA)

library(readr)
library(janitor)
library(ggplot2)

coffee <- read_csv("data/arabica_data_cleaned.csv")
coffee <- janitor::clean_names(coffee)

main_scores <- coffee[, c("aroma", "flavor", "aftertaste", "acidity", "body", "balance", "total_cup_points")]
main_scores <- na.omit(main_scores)

# Pairwise scatterplots of sensory attributes
pairs(main_scores)

# Correlation matrix + heatmap
corr_mat <- cor(main_scores, use = "pairwise.complete.obs")
heatmap(corr_mat, symm = TRUE)
