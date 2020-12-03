library(jsonlite)

init <- function()
{
  # AZUREML_MODEL_DIR is injected by AML
  model_dir <- Sys.getenv("AZUREML_MODEL_DIR")

  model <- readRDS(file.path(model_dir, "model.rds"))
  message("logistic regression model loaded")
  
  function(data)
  {
    vars <- as.data.frame(fromJSON(data))
    prediction <- as.numeric(predict(model, vars, type="prob"))
    toJSON(prediction)
  }
}