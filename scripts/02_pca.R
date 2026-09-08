# Principal Component Analysis (PCA)

library(readr)
library(janitor)
library(factoextra)
library(dplyr)

coffee <- read_csv("data/arabica_data_cleaned.csv", show_col_types = FALSE) %>% clean_names()

X <- scale(na.omit(coffee[, c("aroma", "flavor", "aftertaste", "acidity", "body", "balance")]))

pca <- prcomp(X, center = TRUE, scale. = TRUE)

summary(pca)

# Scree plot - variance explained per component
fviz_eig(pca, addlabels = TRUE)

# Biplot of variable loadings
fviz_pca_biplot(pca, repel = TRUE, col.var = "black")
