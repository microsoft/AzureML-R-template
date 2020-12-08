# ML Ops with GitHub Actions and AML

<p align="center">
  <img src="media/aml.png" height="80"/>
  <img src="https://i.ya-webdesign.com/images/a-plus-png-2.png" alt="plus" height="40"/>
  <img src="media/actions.png" alt="Azure Machine Learning + Actions" height="80"/>
</p>

This example shows how to perform DevOps for Machine learning applications using [Azure Machine Learning](https://docs.microsoft.com/en-us/azure/machine-learning/) powered [GitHub Actions](). The example is based off of the [mlops-enterprise-template repo](https://github.com/Azure-Samples/mlops-enterprise-template).  Using this example template you will be able to setup your train and deployment infra, and train and register the model and in an automated manner. 

# Getting started

### 1. Prerequisites

The following prerequisites are required to make this repository work:
- Azure subscription
- Contributor access to the Azure subscription
- Access to [GitHub Actions](https://github.com/features/actions)

If you don’t have an Azure subscription, create a free account before you begin. Try the [free or paid version of Azure Machine Learning](https://aka.ms/AMLFree) today.

### 2. Setting up the required secrets

#### To allow GitHub Actions to access Azure
An [Azure service principal](https://docs.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals) needs to be generated. Just go to the Azure Portal to find the details of your resource group. Then start the Cloud CLI or install the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) on your computer and execute the following command to generate the required credentials:

```sh
# Replace {service-principal-name}, {subscription-id} and {resource-group} with your 
# Azure subscription id and resource group name and any name for your service principle
az ad sp create-for-rbac --name {service-principal-name} \
                         --role contributor \
                         --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group} \
                         --sdk-auth
```

This will generate the following JSON output:

```sh
{
  "clientId": "<GUID>",
  "clientSecret": "<GUID>",
  "subscriptionId": "<GUID>",
  "tenantId": "<GUID>",
  (...)
}
```

Add this JSON output as [a secret](https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets#creating-encrypted-secrets) with the name `AZURE_CREDENTIALS` in your GitHub repository:

<p align="center">
  <img src="media/secrets.png" alt="GitHub Template repository" width="700"/>
</p>

To do so, click on the Settings tab in your repository, then click on Secrets and finally add the new secret with the name `AZURE_CREDENTIALS` to your repository.

Please follow [this link](https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets#creating-encrypted-secrets) for more details. 

### 3. Setup and Define Triggers

#### Events that trigger workflow
Github workflows are triggered based on events specified inside workflows. These events can be from inside the github repo like a push commit or can be from outside like a webhook ([repository-dispatch](https://docs.github.com/en/developers/webhooks-and-events/webhook-events-and-payloads#repository_dispatch)).
Refer [link](https://docs.github.com/en/actions/reference/events-that-trigger-workflows) for more details on configuring your workflows to run on specific events.

#### Define Trigger
We have created a sample workflow file [train_register](/.github/workflows/train_register.yml) that trains a model on a remote AML Compute Cluster and registers the model in the AML Workspace upon training completion. 

#### Workflow Definition

- Check Out Repository
  - Checks out your repository so your job can access it
- Connect Azure Machine Learning Workspace
  - Connects to AML workspace as defined in [workspace.json](/.cloud/.azure/workspace.json)
- Create Azure Machine Learning Compute Target
  - Creates AML Compute Cluster if not already created based on definition of [compute.json](/.cloud/.azure/compute.json)
- Submit Training Run
  - Submits AML experiment to train a model based on definition of [run.json](/.cloud/.azure/run.json)
- Register Model
  - Registers model from training run based on definition of [model.json](/.cloud/.azure/registermodel.json)

### 4. Testing the trigger

You need to update this workflow file [train_register.yml](/.github/workflows/train_register.yml) by doing a commit to this file.

# Documentation

## Code structure

| File/folder                   | Description                                |
| ----------------------------- | ------------------------------------------ |
| `src/model1`                  | Sample data science source code that will be submitted to Azure Machine Learning to train and deploy machine learning models. |
| `src/model1/train.R`          | Training script that gets executed on a cluster on Azure Machine Learning. |
| `src/model1/aml_config/train_conda.yml`  | Conda environment specification, which describes the dependencies of `train.R`. These packages will be installed inside a Docker image on the Azure Machine Learning compute cluster. |
| `src/model1/aml_config/train-amlcompute.runconfig`   | YAML file, which describes the execution of your training run on Azure Machine Learning. |
| `.cloud/.azure`               | Configuration files for the Azure Machine Learning GitHub Actions. Please visit the repositories of the respective actions and read the documentation for more details. |
| `.github/workflows`           | Folder for GitHub workflows. The `train_register.yml` sample workflow shows you how your can use the Azure Machine Learning GitHub Actions to automate the machine learning process. |
| `CODE_OF_CONDUCT.md`          | Microsoft Open Source Code of Conduct.     |
| `LICENSE`                     | The license for the sample.                |
| `README.md`                   | This README file.                          |
| `SECURITY.md`                 | Microsoft Security README.                 |


## Documentation of Azure Machine Learning GitHub Actions

The template uses the open source Azure certified Actions listed below. Click on the links and read the README files for more details.
- [aml-workspace](https://github.com/Azure/aml-workspace) - Connects to or creates a new workspace
- [aml-compute](https://github.com/Azure/aml-compute) - Connects to or creates a new compute target in Azure Machine Learning
- [aml-run](https://github.com/Azure/aml-run) - Submits a ScriptRun, an Estimator or a Pipeline to Azure Machine Learning
- [aml-registermodel](https://github.com/Azure/aml-registermodel) - Registers a model to Azure Machine Learning
- [aml-deploy](https://github.com/Azure/aml-deploy) - Deploys a model and creates an endpoint for the model