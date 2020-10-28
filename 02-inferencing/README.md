### Real-time and Batch Inferencing
Navigate to src/model1 and execute az ml cli command below:
az ml model deploy -n test-deploy-aci -m diabetes_model:5 --ic aml_config/inference-config.yml --dc deployment/deployment-config-aci.yml --overwrite

### Current Error:
{'Azure-cli-ml Version': '1.16.0', 'Error': MlCliError({'Error': 'Invalid inference configuration.', 'Response Content': WebserviceException:
        Message: Error, unable to provide runtime, conda_file, extra_docker_file_steps, enable_gpu, cuda_version, or base_image along with an environment object.
        InnerException None
        ErrorResponse 
{
    "error": {
        "message": "Error, unable to provide runtime, conda_file, extra_docker_file_steps, enable_gpu, cuda_version, or base_image along with an environment object."
    }
}},)}