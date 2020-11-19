### Creating R Environments for Azure Machine Learning

### To-Do

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
    `baseImage: <registry_name>.azurecr.io/<repository>:<tag>`

