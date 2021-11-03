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

This repo features an Azure Machine Learning (AML)  template which enables you to quickly onboard your existing R code to AML.

While there is an [Azure Machine Learning SDK for R](https://azure.github.io/azureml-sdk-for-r/), this SDK will be deprecated in the near future. This goal of this repository is to provide a project template and examples for running R in Azure Machine Learning without a dependency on an R SDK by using supported AzureML CLI and YAML interfaces where possible and following patterns for the [Azure ML CLI v1](https://docs.microsoft.com/en-us/azure/machine-learning/reference-azure-machine-learning-cli) consistent with the [Azure ML CLI v2](https://docs.microsoft.com/en-us/cli/azure/ml?view=azure-cli-latest) currently in preview to minimize future migration effort.

The template is based heavily on the [AML Acceleration Template](https://github.com/microsoft/aml-acceleration-template) adapted to enable smooth migration of your local R code into the Azure Cloud. 

If you want to follow a guided approach to use this repo, start with [migrating your first workload to AML](instructions/README.md) and walk through the individual sections.

## Getting Started

We recommend you to start with [migrating your first workload to AML](instructions/README.md) as it covers all prerequisites and outlines a simple and proven step-by-step approach.

## Contents

This repo follows a pre-defined structure for storing your model code, pipelines, etc.

| File/folder       | Description                                |
|-------------------|--------------------------------------------|
| `.cloud/.azure` | Configuration files for the Azure Machine Learning GitHub Actions used for MLOps |
| `.github/workflows`| Folder for GitHub workflows used for MLOps |
| `instructions/`| A step-by-step guide on how to onboard your first workload to AML |
| `sample-data/` | Some small sample data used for the template example |
| `src/` | Model(s) code and other required code assets |
| `src/model1` | An example showing docker environment, remote training, and automation for R code in AML |


## Authors

* Scott Donohoo, Data & AI Technical Specialist, Americas GBB
* Anthony Martin, Data & AI Cloud Solution Architect

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
