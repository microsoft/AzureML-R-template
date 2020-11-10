# Import SDK and print version numbers
library(azuremlsdk)

# Authenticate to AML workspace
ws <- load_workspace_from_config()

# Get the registered model
model <- get_model(workspace = ws,
                   name = 'diabetes_model')

# Define inference environment
r_env <- r_environment(name = "basic_env")

# Define inference config
inference_config <- inference_config(
  entry_script = "score.R",
  source_directory = ".",
  environment = r_env)

# Define ACI config
aci_config <- aci_webservice_deployment_config(cpu_cores = 1, memory_gb = 2)
print(aci_config)



# Deploy to ACI
aci_service <- deploy_model(ws,
                            'diabetes-pred',
                            list(model),
                            inference_config,
                            aci_config)

wait_for_deployment(aci_service, show_output = TRUE)


