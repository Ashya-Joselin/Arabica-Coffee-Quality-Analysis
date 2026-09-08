# Arabica Coffee Quality Analysis and Predictive Modeling

Academic team project analyzing 1,311 Arabica coffee samples from the Coffee Quality Institute (CQI) database, using statistical analysis and machine learning to identify what drives coffee cupping scores - and to predict them.

**Team:** Santhosh Kumar Senthil Kumar, Saffanah S, Ashya J, Tejas Kumar
**Guidance:** G. K. Revathi, School of Computer Science and Engineering (SCOPE), VIT Chennai

## Summary

Flavor and aftertaste emerged as the strongest predictors of total cup score. Ridge regression and random forest were the best-performing models (R² ≈ 0.99, RMSE < 0.30), and washed processing consistently outperformed natural processing (though it accounts for only a small share of overall quality variance).

## Methodology

1. **Exploratory Data Analysis** - distributions, correlation heatmaps, pair plots
2. **Principal Component Analysis** - dimensionality reduction on sensory attributes
3. **Regression modeling** - Linear (OLS), Ridge, and Lasso, with 5-fold CV
4. **Random Forest** - ensemble learning with hyperparameter tuning
5. **Clustering** - K-means and hierarchical clustering to find natural quality tiers
6. **Hypothesis testing** - ANOVA on processing method vs. quality score
7. **Optimization** - solving for the sensory profile that maximizes predicted score

## Key results

| Model | RMSE | MAE | R² |
|---|---|---|---|
| Random Forest | 0.185 | 0.135 | 0.992 |
| Lasso Regression | 0.202 | 0.134 | 0.991 |
| Linear Regression | 0.203 | 0.135 | 0.991 |
| Ridge Regression | 0.216 | 0.148 | 0.990 |

## Repo structure

```
scripts/
  01_eda.R                  - distributions, correlations, pair plots
  02_pca.R                  - PCA on sensory attributes
  03_linear_regression.R    - OLS, ridge, lasso comparison
  04_random_forest.R        - random forest with cross-validation
  05_clustering.R           - k-means + hierarchical clustering
  06_hypothesis_testing.R   - ANOVA on processing method
  07_optimization.R         - optimal sensory profile search
data/
  README.md                 - dataset source + setup instructions
report/
  Arabica_Coffee_Quality_Report.pdf
```

## Running the scripts

1. Download the dataset (see `data/README.md`) and place `arabica_data_cleaned.csv` in `data/`.
2. Install required R packages:
   ```r
   install.packages(c("readr", "janitor", "ggplot2", "factoextra", "caret",
                       "glmnet", "Metrics", "randomForest", "forcats", "dplyr", "tidyr"))
   ```
3. Run scripts in order (01 → 07) from the project root in R or RStudio.

## Data source

[Coffee Quality Database from CQI (Kaggle)](https://www.kaggle.com/datasets/volpatto/coffee-quality-database-from-cqi)
