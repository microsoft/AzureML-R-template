# Azure Machine Learning R Acceleration Template

<!-- 
Guidelines on README format: https://review.docs.microsoft.com/help/onboard/admin/samples/concepts/readme-template?branch=master

Guidance on onboarding samples to docs.microsoft.com/samples: https://review.docs.microsoft.com/help/onboard/admin/samples/process/onboarding?branch=master

Taxonomies for products and languages: https://review.docs.microsoft.com/new-hope/information-architecture/metadata/taxonomies?branch=master
-->

This repo features an Azure Machine Learning (AML) Acceleration template which enables you to quickly onboard your existing R code to AML. The template enables a smooth ML development process between your local machine and the Azure Cloud. Furthermore, it includes simple examples for running your model's training and batch inferencing as [Machine Learning Pipelines](https://docs.microsoft.com/en-us/azure/machine-learning/concept-ml-pipelines) for automation.

## Getting Started

We recommend you to follow the step-by-step path below, starting with Prerequisites and environment setup then progress through local/AmlCompute trainin, and automation:

1. [Prerequisites](00-getting-started/README.md) - Setup of initial development environment and R compute environment.
2. [Moving training to Azure Machine Learning](01-training/README.md) - Moving your training code to AML
3. [Moving inferencing to Azure Machine Learning](02-inferencing/README.md) - Moving your prediction code to AML
4. [Automating training and scoring using ML Pipelines](03-pipelines/README.md) - Running training and prediction code as a ML Pipeline
5. [Automating ML Pipeline deployment](04-automation/README.md) - Deploying and testing ML Pipelines automatically using CI/CD


## Authors

* Scott Donohoo, AI Technical Specialist, Americas GBB
* Anthony Martin, AI Cloud Solution Architect

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