# Migrating your R code to Azure Machine Learning

This tutorial will show an easy and proven way to get your existing R code running in Azure Machine Learning. Furthermore, it shows how to automate it using ML pipelines and GitHub Actions for MLOps.

## Guided Approach

We recommend you to follow the proven step-by-step guidelines, which will cover everything from setup, training at scale, and automation:

1. [Prerequisites](00-prerequisites.md) - Setup of initial environment
1. [Creating R environments for Azure Machine Learning](01-Renvironment.md) - Build and publish Docker images to support R training and inferencing
1. [Moving training to Azure Machine Learning](02-training.md) - Moving your training code to AML
1. (**In progress**) [Moving inferencing to Azure Machine Learning](03-inferencing.md) - Moving your prediction code to AML
1. [Automating training and scoring using ML Pipelines](04-pipelines.md) - Running training and prediction code as a ML Pipeline
1. [MLOps using GitHub Actions](05-automation.md) - Automated training and deployment using CI/CD