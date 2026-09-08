# Random Forest Modeling

library(readr)
library(janitor)
library(caret)
library(randomForest)
library(Metrics)
library(dplyr)
library(tidyr)

coffee <- read_csv("data/arabica_data_cleaned.csv", show_col_types = FALSE) %>%
  janitor::clean_names() %>%
  drop_na(total_cup_points)

form <- total_cup_points ~ aroma + flavor + aftertaste + acidity + body + balance + uniformity +
  clean_cup + sweetness + moisture + category_one_defects + category_two_defects + quakers + altitude_mean_meters

set.seed(42)
idx <- createDataPartition(coffee$total_cup_points, p = 0.8, list = FALSE)
train <- coffee[idx, ] %>% drop_na(all_of(all.vars(form)))
test <- coffee[-idx, ] %>% drop_na(all_of(all.vars(form)))

x_train <- model.matrix(form, data = train)[, -1]
y_train <- train$total_cup_points
x_test <- model.matrix(form, data = test)[, -1]

ctrl <- trainControl(method = "cv", number = 5)

rf_model <- train(form, data = train, method = "rf", trControl = ctrl)

pred_rf <- predict(rf_model, newdata = test)

calc_rsq <- function(actual, predicted) {
  rss <- sum((actual - predicted)^2)
  tss <- sum((actual - mean(actual))^2)
  1 - rss / tss
}

results_rf <- data.frame(
  Model = "Random Forest",
  RMSE = rmse(test$total_cup_points, pred_rf),
  MAE = mae(test$total_cup_points, pred_rf),
  R_squared = calc_rsq(test$total_cup_points, pred_rf)
)

print(results_rf)
