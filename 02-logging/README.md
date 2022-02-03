[![cli-job-r-penguins-mlflow](https://github.com/microsoft/AzureML-R-template/actions/workflows/cli-job-r-penguins-mlflow.yml/badge.svg)](https://github.com/microsoft/AzureML-R-template/actions/workflows/cli-job-r-penguins-mlflow.yml)

# Add Azure ML Logging to an R job with MLflow

This examples demonstrates how to log metrics, parameters, tags, and models to an Azure ML experiment for R by using MLflow in the place of the now-deprecated R SDK for Azure ML.

To enable this, the following changes to the 01-job example are made:
#### Dockerfile Changes
```dockerfile
# Install azureml-mlflow
RUN pip install azureml-mlflow

# Create link for python
RUN ln -f /usr/bin/python3 /usr/bin/python

# Install additional R packages for MLflow suport
RUN R -e "install.packages(c('mlflow'), repos = 'https://cloud.r-project.org/')"
RUN R -e "install.packages(c('carrier'), repos = 'https://cloud.r-project.org/')"
RUN R -e "install.packages(c('tcltk2'), repos = 'https://cloud.r-project.org/')"
```

Along with azureml-core, azureml-mlflow is also installed. This installs mlflow/AzureML support for Python but also installs a base mlflow installation that the R support will use.

The R `mlflow` and `carrier` packages are installed for support of mlflow APIs and serialization of R models to register via MLflow.

Azure ML/MLflow integration is managed by functions in the `azureml_utils.R` file. This file should be be placed in the snapshot directory your R source code is and sourced in your R code to enable using MLflow for logging. Functions in this file set the correct MLflow tracking URL to use Azure ML as a backend as well as manage the Azure ML token refresh for long-running jobs.

After sourcing `azureml_utils.R`, your R code should set the `MLFLOW_PYTHON_BIN` and `MLFLOW_BIN` environment variables to point to the azureml.mlflow instance of mlflow to avoid duplicate installations of mlflow. This also removes the necessity to run `mlflow::install_mlflow()` from R.

### R Script Changes

With the run environment modified to support MLflow, the following changes to the script are needed:

#### Load required packages

```r
# Packages to support logging to AzureML with MLflow
library(mlflow)
library(carrier)
```

#### Source azureml_utils.R

```r
# Load aml_utils.R. This is needed to use AML as MLflow backend tracking store.
source('azureml_utils.R')
```

#### Set MLflow environment variables

```r
# Set MLflow related env vars
# https://www.mlflow.org/docs/latest/R-api.html#details
Sys.setenv(MLFLOW_BIN=system("which mlflow", intern=TRUE))
Sys.setenv(MLFLOW_PYTHON_BIN=system("which python", intern=TRUE))
```

You can then add logging of MLflow tags, parameters, metrics, artifacts, and models to your R code.

For example:

```r
mlflow_set_tag("R.version", R.version$version.string)

mlflow_log_param("cv_folds", cv_folds)

mlflow_log_metric(key="Accuracy", value=accuracy)

mlflow_log_artifact("confusion_matrix.png", artifact_path = "plots")
```
See `src/penguins.R` for more detail.

### Submit the R Job with Logging

From the `02-job/` directory, run the command:

```bash
az ml job create -f job.yml --web
```