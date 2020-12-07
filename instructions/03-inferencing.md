# Inferencing

Now that we've trained a model, in this step we'll walk through the process of deploying and serving the model for real-time inferencing using Azure Container Instances (ACI).

Ideally the deployment would be done using the AML CLI `az ml model deploy` command, however we're still troublehsooting this approach for deploying R models.

Therefore, for the time being we will acheive this by submitting an experiment using a run configuration that will execute on an AML Compute target (the same approach taken for model training in the previous step).

This short-term approach has the following short-comings:
* Utilization of many AML R SDK functions
* AML R SDK function `get_model` bug that throws a C Stack Usage error message similar to this [GitHub issue](https://github.com/Azure/azureml-sdk-for-r/issues/404)
* Due to the previous issue, we need to store the model in Azure Blob Storage or locally in the codebase and use the AML R SDK function `register_model` in order to get the model object for deployment

## Preparing the real-time inferencing code

1. Adapt conda enviroment for inferencing
    * Copy your dependencies from [`aml_config/train-conda.yml`](../src/model1/aml_config/train-conda.yml) to [`aml_config/inference-conda.yml`](../src/model1/aml_config/inference-conda.yml)
    * If you have different dependencies for inferencing, you can adapt them in [`aml_config/inference-conda.yml`](../src/model1/aml_config/train-conda.yml)

1. Adapt existing `score.R`
    * Open [`score.R`](../src/model1/score.R) and start updating the `init()` and `run()` as neccessary
    * Updating `init()`:
        * The `init` method is executed once the real-time scoring service is starting up and is usually used to load the model
        * The model file(s) are automatically injected by AML and the location is available in the environment variable `AZUREML_MODEL_DIR`
        * For more details look at the existing [`score.R`](../src/model1/score.R)
    * Updating `run()`:
        * The `run` method is executed whenever a `HTTP POST` request is received by the service
        * The input to the method is usually JSON, which can be processed and then passed into your model
        * For more details look at the existing [`score.R`](../src/model1/score.R)

## Running real-time inferecing on Azure

1. Deploy model to ACI (Azure Container Instances) for testing the model in Azure
    * Finally, you can test deploying the model to ACI:
    ```
    az ml model deploy -n test-deploy-aci -m demo-model:1 --ic aml_config/inference-config.yml --dc deployment/deployment-config-aci.yml --overwrite
    ```
    * Test using VSCode with `rest-client`
      * Install the [REST Client extension](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) for VSCode
      * In the AML Studio UI, goto `Endpoints -> test-deploy-aci -> Consume` and note the `REST endpoint` and `Primary key`
      * Open [`aci-endpoint.http`](../src/model1/tests/aci-endpoint.http) in VSCode, update your `URL` and `Authorization key`:
      ```
      POST http://<REST ENDPOINT HERE> HTTP/1.1
      Content-Type: application/json
      Authorization: Bearer <PRIMARY KEY HERE>
      ```
      * Test the request in VSCode by clicking `Send Request` or `Ctrl + Alt + R`
    * You can delete the deployment via:
    ```
    az ml service delete --name test-deploy-aci
    ```
    
Great, the model is running a service, let's move on the [next section](03-pipelines.md) and look how we can run ML Pipelines for automation on Azure.

### Batch Inferencing - TO-DO