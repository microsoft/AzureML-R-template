[![cli-job-r-penguins-mlflow](https://github.com/microsoft/AzureML-R-template/actions/workflows/cli-job-r-penguins-mlflow.yml/badge.svg)](https://github.com/microsoft/AzureML-R-template/actions/workflows/cli-job-r-penguins-mlflow.yml)

# Add Azure ML Logging to an R job with MLflow

This examples demonstrates how to log metrics to an Azure ML experiment for R by using MLflow in the place of the now-deprecated R SDK for Azure ML.

 **This capability is still under development.** At this time, the following MLflow logging APIs for R are functional with Azure ML:

```r
mlflow_set_tag()
mlflow_log_param()
mlflow_log_metric()
```
To enable this, the following changes to the 01-job example are made:
#### Dockerfile Changes
```dockerfile
RUN pip install azureml-dataprep azureml-core azureml-mlflow

# Setup MLflow support for R
RUN R -e "install.packages(c('mlflow', 'carrier'), repos = 'https://cloud.r-project.org/')"
RUN R -e "remotes::install_github('sdonohoo/azureml.mlflow', ref='main')"
ENV MLFLOW_PYTHON_BIN=/usr/bin/python
ENV MLFLOW_BIN=/usr/local/bin/mlflow
```

Along with azureml-core, azureml-mlflow is also installed. This installs mlflow/AzureML support for Python but also installs a base mlflow installation that the R support will use.

The R `mlflow` and `carrier` packages are installed for support of mlflow APIs and serialization of R models to register via MLflow.

The  `azureml.mlflow`  package defines a helper function to reformat the Azure ML tracking URI into a compatible format for R MLflow. 

The `MLFLOW_PYTHON_BIN` and `MLFLOW_BIN` environment variables are set to point to the azureml.mlflow instance of mlflow to avoid duplicate installations of mlflow. This also removes the necessity to run `mlflow::install_mlflow()` from R.

### R Script Changes

With the run environment modified to support MLflow, the following changes to the script are needed:

#### Load required packages

```r
# Packages to support logging to AzureML with MLflow
library(mlflow)
library(carrier)
library(azureml.mlflow)
```
#### Set MLflow to use the correct Azure ML tracking URI

```r
# Enable mlflow logging to Azure by setting tracking uri to correct AzureML tracking uri
mlflow_set_tracking_uri(mlflow_get_azureml_tracking_uri())

# Get AZUREML_RUN_ID to set run id in mlflow calls
run_id <- Sys.getenv("AZUREML_RUN_ID")
```

At this point, you can add logging of tags, parameters, and metrics to your R code. For example:

```r
mlflow_set_tag("language", "R", run_id = run_id)

mlflow_log_param("cv_folds", cv_folds, run_id=run_id)

mlflow_log_metric(key="Accuracy", value=accuracy, run_id=run_id)
```
See `src/penguins.R` for more detail.

### Submit the R Job with Logging

From the `02-job/` directory, run the command:

```bash
az ml job create -f job.yml --web
```