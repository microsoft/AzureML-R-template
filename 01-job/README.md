[![cli-job-r-penguins](https://github.com/microsoft/AzureML-R-template/actions/workflows/cli-job-r-penguins.yml/badge.svg)](https://github.com/microsoft/AzureML-R-template/actions/workflows/cli-job-r-penguins.yml)
# Run an R job in Azure Machine Learning Compute

### Contents

The file structure for the example job is as follows:

| File/folder       | Description                                |
|-------------------|--------------------------------------------|
| `data/penguins.csv` | The sample [Palmer Penguins](https://allisonhorst.github.io/palmerpenguins/) dataset for training the model. |
| `src/penguins.R` | R code train a random forest model on the penguins dataset. |
| `environment/Dockerfile` | A Docker file based on a [rocker/tidyverse](https://hub.docker.com/r/rocker/tidyverse) image that will be used to create an R execution environment for Azure ML |
| `job.yml` | The Azure ML CLI job definition |

### Dockerfile

The Dockerfile defines the execution environment for the job in AmlCompute. It includes the installation of python and python packages required for Azure ML job execution, the R `optparse` package for parsing arguments passed by the job to the script, and any additional R packages required to execute the training script.

### Adapting R code to run as an AzureML job

Typically, few changes are required to existing R code to take advantage of execution in Azure ML. Generally, two sections should be added:
#### Add optparse code to handle arguments passed by the job definition. 

For example, a reference to the training data:

```r
library(optparse)

# Parse input arguments from AzureML job
options <- list(
  make_option(c("-d", "--data_folder"), default="./data")
)
opt_parser <- OptionParser(option_list = options)
opt <- parse_args(opt_parser)

penguins <- read.csv(file.path(opt$data_folder, "penguins.csv"), stringsAsFactors = TRUE, header=TRUE)
```
#### Create an `./outputs` directory to save any script run artifacts

Any files saved to `./outputs` will be automatically uploaded to the experiment at the end of the run. For example:

```r
output_dir = "outputs"
if (!dir.exists(output_dir)){
  dir.create(output_dir)
}
saveRDS(fit.rf, file = "./outputs/model.rds")
message("Model saved")
```

### Job definition

The `job.yml` file defines the job to run in Azure ML - what, how, and where to run it. Key elements of the example `job.yml` are:

| Section       | Description                                |
|-------------------|--------------------------------------------|  
| command | Call Rscript to execute the training script. |
| code | Where to find the training script(s). |
| inputs | Define references to data or other inputs to the script. |
| environment | Run environment for the job. In this example, the Dockerfile. |
| compute | Where to run the job. In this example, the compute cluster created during setup. |

For information on the definition of the Azure ML CLI job, see [Introducing Jobs](https://docs.microsoft.com/en-us/azure/machine-learning/how-to-train-cli#introducing-jobs) in the product documentation.

### Submit the R Job

From the `01-job/` directory, run the command:

```bash
az ml job create -f job.yml --web
```
This will submit the job to the Azure ML workspace and compute cluster created in the setup step.

To adapt your own code to run as an Azure ML job:
* Modify the Dockerfile to include R packages needed by your script
* Modify the R script to support any parameters passed by the job definition
* Create a job definition `.yml` to define how and where to run the job.

Proceed to the `02-logging/` directory to see how to add Azure ML logging to your job using MLflow.
