# AML Pipelines with R

ML Pipelines in AML allows you to group multiple parts of your Machine Learning process and group it into one pipeline. For example, a pipeline could consist of feature preprocessing, model training, model evaluation and finally model registration. A pipeline wraps these steps into one self-contained unit, that you can either run on-demand through AML or expose as a RESTful API. The latter will allow other users or application to trigger this pipeline and run it. By adding parameters, this pipeline can be made dynamic, e.g., allowing to feed in new data as it becomes available.

AML Pipelines for R code can be authored in 2 ways:  

* Using the AML Python SDK (this example)
* Using the Visual Designer (not covered in this repo)

## Instructions

From within the directory of each pipeline, you can run it via:

```
python pipeline.py <arguments>
```

## `train` pipeline

The `train` pipeline deployment script accepts the following command line arguments for publishing the training pipeline:

| Argument              | Description |
|:--------------------  | ------------|
| `--pipeline_name`     | Name of the pipeline that will be deployed |
| `--build_number`      | (Optional) The build number |
| `--datastore`           | References the datastore by name in the AML workspace where the training data is stored| 
| `--data_path`         | Path to the data within the datastore |
| `--runconfig`         | Path to the runconfig that configures the training |
| `--source_directory`  | Path to the source directory containing the training code | 

### R Environment

If not already completed, edit, build, and push a Docker image for the R environment the pipeline will use for training. 

1. Open a terminal and navigate to the [`src/model1/docker/base`](../src/model1/docker/base/) folder. Edit `Dockerfile` to add commands to install any additional R packages or other software required by your training code.
2. Login to your Azure subscription:  
    `$ az login`
3. Query the container registry name for your AML Workspace:  
    `$ az ml workspace show -w <your workspace> -g <resourcegroup> --query containerRegistry`  
    The information returned will be similar to:  
    `/subscriptions/<subscription_id>/resourceGroups/<resource_group>/providers/Microsoft.ContainerRegistry/registries/<registry_name>`  
4. Authenticate to the Azure Container Registry using the registry name from the end of the previous result:  
    `$ az acr login --name <registry_name>`
5. Enter the following command to upload and build your image:  
    `az acr build --image <image_name>:<tag> --registry <registry_name> --file Dockerfile .`
6. When the build is completed, navigate back to the pipeline directory and edit `pipeline.runconfig` to use your published Docker image as the baseImage in the docker section:  
    `baseImage: <username>/<repository>:<tag>`

### Build and Publish the Pipeline

Example:
```
python pipeline.py --pipeline_name training_pipeline --datastore diabetes --data_path diabetes_data --runconfig pipeline.runconfig --source_directory ../../src/model1/
```
Optionally, edit [`src/model1/train.R`](../src/model1/train.R) and comment out the last two lines to submit the pipeline as an experiment for testing.

The published pipeline can be called via its REST API, so it can be triggered on demand, when you wish to retrain. Furthermore, you can use an orchestrator of your choice to trigger them, e.g., you could directly trigger it from [Azure Data Factory](https://azure.microsoft.com/en-us/services/data-factory/) when new data got processed. You may follow [this tutorial](https://docs.microsoft.com/en-us/azure/data-factory/transform-data-machine-learning-service).

## 
* Configure and build docker image if necessary
* Edit pipeline.runconfig to use docker image and reference train.R
* Run pipeline.py