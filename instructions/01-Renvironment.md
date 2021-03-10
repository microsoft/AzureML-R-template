# Creating R Environments for Azure Machine Learning

When using Python with Azure Machine Learning, your [AML Environments](https://docs.microsoft.com/en-us/azure/machine-learning/how-to-use-environments#create-an-environment) for training and deployment are typically defined and managed using the Python SDK and Conda and can be created dynamically at runtime. At runtime, AML will build and deploy a Docker image for the Environment you specified.

While this approach can be used to some extent for R environments, we recommend creating and publishing custom Docker images for R environments directly and ahead of the training phase. This allows for more flexibility and control over the R and package versions you need for your environment.

## Define Docker Image

A Docker image for use with AML should include the necessary AML Python environment to which we will add the necessary R and R package components. An example of a custom Docker image for running the template sample is included in [`src/model1/docker/`](../src/model1/docker/).  This example uses a Docker base image from the [The Rocker Project](https://www.rocker-project.org/) with the addition of python to support running jobs in Azure Machine Learning.

The sample Docker image is below and is based on the rocker base image with R 4.0 and the tidyverse collection of packages preinstalled.:

```dockerfile
FROM rocker/tidyverse:4.0.0-ubuntu18.04
 
# Install python
RUN apt-get update -qq && \
 apt-get install -y python3
 
# Create link for python
RUN ln -f /usr/bin/python3 /usr/bin/python

# Install optparse package to support argument passing
RUN R -e "install.packages(c('optparse'), repos = 'https://cloud.r-project.org/')"

# Install additional R packages needed for training code
RUN R -e "install.packages(c('caret', 'e1071'), repos = 'https://cloud.r-project.org/')"
```


To customize the R environment for your code, you may install additional R packages or other software needed by your training. For the sample code run in this template, caret and e1071 packages are installed.



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