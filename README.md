# Azure Machine Learning R Template

<!-- 
Guidelines on README format: https://review.docs.microsoft.com/help/onboard/admin/samples/concepts/readme-template?branch=master

Guidance on onboarding samples to docs.microsoft.com/samples: https://review.docs.microsoft.com/help/onboard/admin/samples/process/onboarding?branch=master

Taxonomies for products and languages: https://review.docs.microsoft.com/new-hope/information-architecture/metadata/taxonomies?branch=master
-->

<p align="center">
  <img src="doc/media/aml_logo.png" width="150px" />
  <img src="https://i.ya-webdesign.com/images/a-plus-png-2.png" alt="plus" height="75"/>
  <img src="https://www.r-project.org/logo/Rlogo.png" alt="R-Project" width="180px"/>
</p>

This repo provides examples for using R with Azure Machine Learning. While an [Azure Machine Learning SDK for R](https://azure.github.io/azureml-sdk-for-r/) exists, this SDK will be deprecated in the near future. This goal of this repository is to provide examples for running R in Azure Machine Learning without a dependency on an R SDK by using supported AzureML CLI and YAML interfaces where possible.

Current examples for running R using the AML CLI include:
* Creating R environments for using AmlCompute
* Onboarding existing R code to migrate to Azure ML

**[Note: the examples in the main branch are based on the [AzureML CLI v2](https://docs.microsoft.com/en-us/azure/machine-learning/how-to-train-cli), currently in preview. This offers a simpler and more reliable approach to running R in AzureML but updates may introduce breaking changes. For a supported approach, refer to the azureml-cli-v1 branch of this repo. When CLI v2 is released, the v1 branch will be deleted. ]**
## Getting Started

To begin, start in 00-setup/.

## Contents

This repo structure is as follows:

| File/folder       | Description                                |
|-------------------|--------------------------------------------|
| `.github/workflows`| Folder for GitHub workflows used for MLOps |
| `00-setup/` | Quick steps to configure an Azure ML environment for running the samples |
| `01-job/` | Simple AzureML job example to train a model on the penguins dataset |
| `02-logging/` | Simple AzureML job example to train a model on the penguins dataset with logging to experiment using MLflow |
| `utils` | Environment setup script run by GitHub workflows |

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
