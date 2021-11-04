# Set up the Azure Machine Learning CLI and Workspace

This page describes the commands to prepare a CLI and workspace environment to run the examples in this repository. For further information, refer to the following documentation:

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

### Create an Azure resource group

```bash
az group create -n "azureml-r-examples-rg" -l "southcentralus"
```

### Configure the default resource group and select as Azure ML workspace name

```bash
az configure --defaults group="azureml-r-examples-rg" workspace="main"
``` 

### Create the named workspace

```bash
az ml workspace create
```

### Within the new workspace, create a compute cluster to run R jobs

```bash
az ml compute create -n cpu-cluster --type amlcompute --min-instances 0 --max-instances 2
```

Proceed to 01-job/ to run your first R job in Azure ML.