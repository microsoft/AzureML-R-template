library(jsonlite)

init <- function()
{
  
  # Update to your model's filename
  model_filename <- "model.rds"
  
  # AZUREML_MODEL_DIR is injected by AML
  model_dir <- Sys.getenv("AZUREML_MODEL_DIR")
  
  paste("Model dir:", model_dir)
  paste("Model filename:", model_filename)

  model <- readRDS(file.path(model_dir, model_filename))
  message("logistic regression model loaded")
  
  function(data)
  {
    vars <- as.data.frame(fromJSON(data))
    prediction <- as.numeric(predict(model, vars, type="prob"))
    toJSON(prediction)
  }
}