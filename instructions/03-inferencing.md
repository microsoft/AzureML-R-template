# Inferencing

## Preparing the real-time inferencing code

1. Adapt conda enviroment for inferencing
    * Copy your dependencies from [`aml_config/train-conda.yml`](../src/model1/aml_config/train-conda.yml) to [`aml_config/inference-conda.yml`](../src/model1/aml_config/inference-conda.yml)
    * If you have different dependencies for inferencing, you can adapt them in [`aml_config/inference-conda.yml`](../src/model1/aml_config/train-conda.yml)

1. Adapt existing `score.py`
    * Open [`score.py`](../src/model1/score.py) and start updating the `init()` and `run()` methods following the instructions given in the file
    * Updating `init()`:
        * The `init` method is executed once the real-time scoring service is starting up and is usually used to load the model
        * The model file(s) are automatically injected by AML and the location is available in the environment variable `AZUREML_MODEL_DIR`
        * For more details look at the existing [`score.py`](../src/model1/score.py)
    * Updating `run()`:
        * The `run` method is executed whenever a `HTTP POST` request is received by the service
        * The input to the method is usually JSON, which can be processed and then passed into your model
        * For more details look at the existing [`score.py`](../src/model1/score.py)
        * If you want to receive binary data, e.g., images, you can try use the following code (full example [here](https://github.com/csiebler/unet-pytorch-azureml/blob/master/model/score.py)):
        ```python
        from azureml.contrib.services.aml_request import AMLRequest, rawhttp
        from azureml.contrib.services.aml_response import AMLResponse
        ...
        @rawhttp
        def run(request):
            if request.method == 'POST':
                request_body = request.get_data(False)
                input_image = Image.open(io.BytesIO(request_body))

                # Do something with the input image
                response = 42 # create a more meaningful response

                headers = {
                    'Content-Type': 'image/png' # Set your Content-Type of the response
                }
                
                return AMLResponse(response, 200, headers)
            if request.method == 'GET':
                response_body = str.encode("GET is not supported")
                return AMLResponse(response_body, 405)
            return AMLResponse("Bad Request", 500)
        ```
    * You can test your `score.py` script locally using (make sure the file `outputs/model.pkl` exists):
    ```
    pytest tests/
    ```

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