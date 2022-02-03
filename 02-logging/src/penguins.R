# optparse for arguments passed by AzureML job
library(optparse)

# Packages to support logging to AzureML with MLflow
library(mlflow)
library(carrier)

#Packages required for model training
library(caret)
library(randomForest)

# Load aml_utils.R. This is needed to use AML as MLflow backend tracking store.
source('azureml_utils.R')

# Set MLflow related env vars
# https://www.mlflow.org/docs/latest/R-api.html#details
Sys.setenv(MLFLOW_BIN=system("which mlflow", intern=TRUE))
Sys.setenv(MLFLOW_PYTHON_BIN=system("which python", intern=TRUE))

# Parse input arguments from AzureML job
options <- list(
  make_option(c("-d", "--data_folder"), default="./data")
)
opt_parser <- OptionParser(option_list = options)
opt <- parse_args(opt_parser)

# Single argument passed is the path to the mounted data folder. Read in the penguins dataset.
penguins <- read.csv(file.path(opt$data_folder, "penguins.csv"), stringsAsFactors = TRUE, header=TRUE)

with(run <- mlflow_start_run(), {
  
  # Set tags in the AzureML run with MLflow
  mlflow_set_tag("Language", "R")
  mlflow_set_tag("R.version", R.version$version.string)
  mlflow_set_tag("Dataset", "penguins")


  # Set number of folds for cross validation and log as a parameter
  # to the AzureML run using MLflow
  cv_folds <- 10
  mlflow_log_param("cv_folds", cv_folds)

  
  # Train a random forest model to predict sex of the penguin by all other features
  set.seed(123)
  split <- createDataPartition(penguins$sex, p = 0.8, list = FALSE)
  test <- penguins[-split,] # Save 20% of data for test 
  train <- penguins[split,] # 80% of data for training
  
  # Train the model
  control <- trainControl(method="cv", number=cv_folds)
  metric <- "Accuracy"
  fit.rf <- train(sex~., data=train, method="rf", metric=metric, trControl=control)

  # print model output to stdout in the AzureML run log
  print(fit.rf)
  

  # Create a predictor function for the model using crate.
  # This is the expected model representation to log the model with MLflow
  predictor <- crate(function(x) {
    stats::predict(model,x)
  }, model = fit.rf)
  
  print("Call crated model to get predictions")
  predictions <- predictor(test)

  
  # Log accuracy metric to AzureML run using MLflow
  accuracy <- (sum(predictions == test$sex) / nrow(test))
  mlflow_log_metric(key="Accuracy", value=accuracy)
  
  
  # Plot and log a confusion matrix to the AzureML run using MLflow
  library(yardstick)
  library(ggplot2)
  
  cm <- conf_mat(data.frame(sex=test$sex, predictions), sex, predictions)
  autoplot(cm, type = "heatmap") + scale_fill_gradient(low="#D6EAF8",high = "#2E86C1")
  
  ggsave("confusion_matrix.png")
  mlflow_log_artifact("confusion_matrix.png", artifact_path = "plots")


  # Log the model to the experiment using MLflow.
  mlflow_log_model(predictor, "rf_model")
})