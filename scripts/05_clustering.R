# Clustering (K-means + Hierarchical)

library(readr)
library(janitor)
library(dplyr)

coffee <- read_csv("data/arabica_data_cleaned.csv", show_col_types = FALSE) %>%
  janitor::clean_names()

X <- scale(na.omit(coffee[, c("aroma", "flavor", "aftertaste", "acidity", "body", "balance")]))

set.seed(42)

# Elbow method to choose k
wcss <- sapply(1:8, function(k) kmeans(X, centers = k, nstart = 20)$tot.withinss)
plot(1:8, wcss, type = "b", xlab = "Number of clusters (k)", ylab = "Within-cluster SS")

# K-means with k = 3
km <- kmeans(X, centers = 3, nstart = 30)

plot(X[, 1], X[, 2], col = km$cluster, pch = 19,
     xlab = "Feature 1", ylab = "Feature 2", main = "K-means Clustering")

# Hierarchical clustering (Ward's method)
d <- dist(X)
hc <- hclust(d, method = "ward.D2")
plot(hc, main = "Hierarchical Clustering Dendrogram")
rect.hclust(hc, k = 3, border = "red")
