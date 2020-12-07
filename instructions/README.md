# Migrating your R code to Azure Machine Learning

This tutorial will show an easy and proven way to get your existing R code running in Azure Machine Learning. Furthermore, it shows how to automate it using ML pipelines and GitHub Actions for MLOps.

## Guided Approach

We recommend you to follow the proven step-by-step guidelines, which will cover everything from setup, running at scale, and automation:

1. [Prerequisites](00-prerequisites.md) - Setup of initial environemnt
1. [Creating R environments for Azure Machine Learning](01-Renvironment.md) - Build R environments for training and inferencing
1. [Moving training to Azure Machine Learning](02-training.md) - Moving your training code to AML
1. <mark>In progress</mark> [Moving inferencing to Azure Machine Learning](03-inferencing.md) - Moving your prediction code to AML
1. [Automating training and scoring using ML Pipelines](04-pipelines.md) - Running training and prediction code as a ML Pipeline
1. [Automating ML Pipeline deployment](05-automation.md) - Deploying and testing ML Pipelines automatically using CI/CD