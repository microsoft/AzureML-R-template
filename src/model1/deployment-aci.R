# Import SDK
library(azuremlsdk)

# Authenticate to AML workspace
# ws <- load_workspace_from_config()
run <- get_current_run()
exp <- run$experiment
ws <- exp$workspace

# Create and register environment from custom Docker image
r_env <- r_environment("R-env",
                       #custom_docker_image = "<repository_name>.azurecr.io/<image_name>:<tag>")
                       custom_docker_image = "azuremlb384076d.azurecr.io/azureml/r-image:latest")

# model <- get_model(workspace = ws,
#                    name = 'demo-model')

model <- register_model(ws, 
                        model_path = "./model.rds", 
                        model_name = "demo-model")                              

# Define inference config
inference_config <- inference_config(
  entry_script = "score.R",
  source_directory = ".",
  environment = r_env)

# Define ACI config
aci_config <- aci_webservice_deployment_config(cpu_cores = 1, memory_gb = 2, auth_enabled = TRUE)

print("Begin deploy to ACI")       

# Deploy to ACI
aci_service <- deploy_model(ws,
                            'diabetes-pred2',
                            list(model),
                            inference_config,
                            aci_config)

wait_for_deployment(aci_service, show_output = TRUE)


