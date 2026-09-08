# Linear / Ridge / Lasso Regression

library(readr)
library(janitor)
library(caret)
library(glmnet)
library(Metrics)
library(dplyr)
library(tidyr)

coffee <- read_csv("data/arabica_data_cleaned.csv", show_col_types = FALSE) %>%
  janitor::clean_names() %>%
  drop_na(total_cup_points)

names(coffee)

form <- total_cup_points ~ aroma + flavor + aftertaste + acidity + body + balance +
  uniformity + clean_cup + sweetness + moisture + category_one_defects +
  category_two_defects + quakers + altitude_mean_meters

set.seed(42)
idx <- createDataPartition(coffee$total_cup_points, p = 0.8, list = FALSE)

train <- coffee[idx, ] %>%
  drop_na(all_of(c("aroma", "flavor", "aftertaste", "acidity", "body", "balance",
                    "uniformity", "clean_cup", "sweetness", "moisture",
                    "category_one_defects", "category_two_defects", "quakers",
                    "altitude_mean_meters", "total_cup_points")))

x <- model.matrix(form, data = train)[, -1]
y <- train$total_cup_points

test <- coffee[-idx, ] %>%
  drop_na(all_of(c("aroma", "flavor", "aftertaste", "acidity", "body", "balance",
                    "uniformity", "clean_cup", "sweetness", "moisture",
                    "category_one_defects", "category_two_defects", "quakers",
                    "altitude_mean_meters", "total_cup_points")))

# Baseline OLS
lm_fit <- lm(form, data = train)

ctrl <- trainControl(method = "cv", number = 5)

# Ridge (L2)
ridge <- train(x, y, method = "glmnet", trControl = ctrl,
               tuneGrid = expand.grid(alpha = 0, lambda = 10^seq(-3, 2, length.out = 30)))

# Lasso (L1)
lasso <- train(x, y, method = "glmnet", trControl = ctrl,
               tuneGrid = expand.grid(alpha = 1, lambda = 10^seq(-3, 2, length.out = 30)))

pred_lm <- predict(lm_fit, newdata = test)
pred_ridge <- predict(ridge, newdata = model.matrix(form, data = test)[, -1])
pred_lasso <- predict(lasso, newdata = model.matrix(form, data = test)[, -1])

calc_rsq <- function(actual, predicted) {
  rss <- sum((actual - predicted)^2)
  tss <- sum((actual - mean(actual))^2)
  1 - rss / tss
}

results <- data.frame(
  Model = c("LM", "Ridge", "Lasso"),
  RMSE = c(rmse(test$total_cup_points, pred_lm),
           rmse(test$total_cup_points, pred_ridge),
           rmse(test$total_cup_points, pred_lasso)),
  MAE = c(mae(test$total_cup_points, pred_lm),
          mae(test$total_cup_points, pred_ridge),
          mae(test$total_cup_points, pred_lasso)),
  R_squared = c(calc_rsq(test$total_cup_points, pred_lm),
                calc_rsq(test$total_cup_points, pred_ridge),
                calc_rsq(test$total_cup_points, pred_lasso))
)

results %>% arrange(RMSE)
