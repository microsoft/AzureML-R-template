# Creating R Environments for Azure Machine Learning

When using Python with Azure Machine Learning, your [AML Environments](https://docs.microsoft.com/en-us/azure/machine-learning/how-to-use-environments#create-an-environment) for training and deployment are typically defined and managed using the Python SDK and Conda and can be created dynamically at runtime. At runtime, AML will build and deploy a Docker image for the Environment you specified.

While this approach can be used to some extent for R environments, we recommend creating and publishing custom Docker images for R environments directly and ahead of the training phase. This allows for more flexibility and control over the R and package versions you need for your environment.

## Define Docker Image

A Docker image for use with AML should include the necessary AML Python environment to which we will add the necessary R and R package components. An example of a custom Docker image for running the template sample is included in [`src/model1/docker/custom`](../src/model1/docker/custom/).  This example follows  patterns for creating R Docker images used by the [The Rocker Project](https://www.rocker-project.org/) with modifications to support running R jobs in Azure Machine Learning.

In particular, the sample is built on one of the [AML Base Images](https://github.com/Azure/AzureML-Containers)

```dockerfile
FROM mcr.microsoft.com/azureml/base:openmpi3.1.2-ubuntu18.04
```

This ensures that the image has the required Python and dependencies environment for AML.

The sample Dockerfile also installs the AML R SDK to support optional run logging in AML from R code.

```dockerfile
# Set up miniconda environment for reticulate configuration
# and install and configure R AzureML SDK
RUN ln -s /opt/miniconda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/miniconda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

ENV TAR="/bin/tar"
RUN R -e "install.packages(c('remotes', 'reticulate'), repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_github('https://github.com/Azure/azureml-sdk-for-r')" && \
    R -e "library(azuremlsdk); install_azureml()" && \
    echo "Sys.setenv(RETICULATE_PYTHON='/opt/miniconda/envs/r-reticulate/bin/python3')" >> ~/.Rprofile

```

To customize your R environment for your code, you can edit the version of R you wish to install near the top of the Dockerfile.

```dockerfile
ENV R_BASE_VERSION 4.0.3
```

Then, at the end of the Dockerfile, add `RUN` instructions to install the R packages your code requires. Add any additional Dockerfile commands here to install other software that might be required by your training code (e.g. Java, MXNet, etc).

```dockerfile
RUN R -e "install.packages(c('e1071'), repos = 'https://cloud.r-project.org/')"
```

## Build and Publish Docker Image in Azure Container Registry

Now you are ready to build the Docker image and publish it to a registry for use by a AML run. For this template, we use the instance of Azure Container Registry you created in the Prerequisites step that is associated with your AML Workspace though the image can be used from another instance of ACR or Docker Hub.

Below are the steps to build and publish your image to ACR instance you created (example: `amldemoimages`) with your Workspace in the [Prerequisites](01-prerequisites) step. 


1. Open a terminal and navigate to the [`src/model1/docker/custom`](../src/model1/docker/base/) folder. 
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

You can now use your custom Docker image to run your training code and move to the [next section](02-training.md) to run your R code in AML.