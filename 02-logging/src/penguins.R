# optparse for arguments passed by AzureML job
library(optparse)

# Packages to support logging to AzureML with MLflow
library(mlflow)
library(carrier)
library(azureml.mlflow)

#Packages required for EDA and training
library(tidyverse)
library(caret)
library(randomForest)

# Parse input arguments from AzureML job
options <- list(
  make_option(c("-d", "--data_folder"), default="./data")
)
opt_parser <- OptionParser(option_list = options)
opt <- parse_args(opt_parser)

# Enable mlflow logging to Azure by setting tracking uri to correct AzureML tracking uri
mlflow_set_tracking_uri(mlflow_get_azureml_tracking_uri())

# Get AZUREML_RUN_ID to set run id in mlflow calls
run_id <- Sys.getenv("AZUREML_RUN_ID")

# Set tags in the AzureML run with MLflow
mlflow_set_tag("language", "R", run_id = run_id)
mlflow_set_tag("dataset", "penguins", run_id = run_id)

# Single argument passed is the path to the mounted data folder. Read in the penguins dataset.
penguins <- read.csv(file.path(opt$data_folder, "penguins.csv"), stringsAsFactors = TRUE, header=TRUE)

# Sample factor features in the data
penguins %>%
  dplyr::select(where(is.factor)) %>%
  glimpse()

# Count penguins for each species / island
penguins %>%
  count(species, island, .drop = FALSE)

# Count penguins for each species / sex
penguins %>%
  count(species, sex, .drop = FALSE)

# Sample numeric features in the data
penguins %>%
  dplyr::select(body_mass_g, ends_with("_mm")) %>%
  glimpse()

# Train a random forest model to predict sex of the penguin by all other features
split <- createDataPartition(penguins$sex, p = 0.8, list = FALSE)

test <- penguins[-split,] # Save 20% of data for test validation here
train <- penguins[split,] # 80% of data 

# Set number of folds for cross validation
cv_folds <- 10

# Log parameters to the AzureML run using MLflow
mlflow_log_param("cv_folds", cv_folds, run_id=run_id)

# For training, use k-fold cross-validation maximizing accuracy
control <- trainControl(method="cv", number=cv_folds)
metric <- "Accuracy"

# Train model
set.seed(123)
fit.rf <- train(sex~., data=train, method="rf", metric=metric, trControl=control)

# Model output
print(fit.rf)

# Get predictions
predictions <- predict(fit.rf, test)

# Get confusion matrix
confMat <- confusionMatrix(predictions, test$sex)
print(confMat)

# Log accuracy metric to AzureML run using MLflow
accuracy <- confMat$overall[1]
mlflow_log_metric(key="Accuracy", value=accuracy, run_id=run_id)

# Create ./outputs directory and save any model artifacts to it.
# Anything in ./outputs will be uploaded to the AzureML experiment
output_dir = "outputs"
if (!dir.exists(output_dir)){
  dir.create(output_dir)
}
saveRDS(fit.rf, file = "./outputs/model.rds")
message("Model saved")