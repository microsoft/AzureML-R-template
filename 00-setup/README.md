# Set up the Azure Machine Learning CLI and Workspace

This page describes the commands to prepare a CLI and workspace environment for running the examples in this repository. For further in-depth information, refer to the following documentation:

*  [Install and set up the CLI (v2)](https://docs.microsoft.com/en-us/azure/machine-learning/how-to-configure-cli)
* [Train models (create jobs) with the CLI (v2)](https://docs.microsoft.com/en-us/azure/machine-learning/how-to-train-cli)

Prerequisites:
* An Azure subscription
* Install the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)


### Install the Azure CLI ml 2.0 extension

```bash
az extension add -n ml -y
```

### Login to your Azure account

```bash
az login
```

### If you have multiple Azure subscriptions, set the active subscription

```bash
az account set -s "<YOUR_SUBSCRIPTION_NAME_OR_ID>"
```

### Set environment variables for use in subsequent commands

Choose the Azure region you will run your Azure ML jobs in and select resource group name and a workspace name and set variables for each. For example:

```bash
GROUP="azureml-examples"
LOCATION="eastus"
WORKSPACE="main"
```

### Create an Azure resource group

```bash
az group create -n $GROUP -l $LOCATION"
```
### Create the the Azure ML workspace

```bash
az ml workspace create -n $WORKSPACE -g $GROUP -l $LOCATION
```
### Configure the default resource group and Azure ML workspace

```bash
az configure --defaults group=$GROUP workspace=$WORKSPACE location=$LOCATION
``` 

### Within the default workspace, create a compute cluster to run R jobs

```bash
az ml compute create -n cpu-cluster --type amlcompute --min-instances 0 --max-instances 2
```

Change directory  to 01-job/ to run your first R job in Azure ML.