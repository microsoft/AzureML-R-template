# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license.

library(azuremlsdk)
library(optparse)
library(caret)

print("In train.R")

options <- list(
  make_option(c("--input_data")),
  make_option(c("--output_train"))
)

opt_parser <- OptionParser(option_list = options)
opt <- parse_args(opt_parser)

paste(opt$input_data)
paste(opt$output_train)

print("Listing input data files...")
list.files(opt$input_data)

# Read data files and drop PatientID column
data_files <- list(file.path(opt$input_data, "diabetes.csv"),
                   file.path(opt$input_data, "diabetes2.csv")
                   )

data <- subset(
  do.call(rbind, lapply(data_files, read.csv)),
  select = -c(PatientID)
)

data$Diabetic <- factor(data$Diabetic)

# Train test split
set.seed(123)
idx <- createDataPartition(data$Diabetic, p = 0.75, list = FALSE)
train <- data[idx, ]
test <- data[-idx, ]

# Train model
mod <- train(
  form = Diabetic ~ .,
  data = train,
  trControl = trainControl(method = "cv", number = 5),
  method = "glm",
  family = "binomial"
)
mod

# Calculate accuracy
calc_acc <- function(actual, predicted) {
  mean(actual == predicted)
}

accuracy <- calc_acc(actual = test$Diabetic,
                     predicted = predict(mod, newdata = test))

# Log accuracy metric to run
log_metric_to_run("Accuracy", accuracy)

output_dir <- "outputs"
if (!dir.exists(output_dir)){
  dir.create(output_dir)
}

saveRDS(mod, file = "./outputs/model.rds")
message("Model saved")