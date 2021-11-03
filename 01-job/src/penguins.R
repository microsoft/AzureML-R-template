# optparse for arguments passed by AzureML job
library(optparse)

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

# Fro training, use 10-fold cross-validation maximizing accuracy
control <- trainControl(method="cv", number=10)
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

# Create ./outputs directory and save any model artifacts to it.
# Anything in ./outputs will be uploaded to the AzureML experiment
output_dir = "outputs"
if (!dir.exists(output_dir)){
  dir.create(output_dir)
}
saveRDS(fit.rf, file = "./outputs/model.rds")
message("Model saved")