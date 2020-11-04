# Import SDK and print version numbers
library(azuremlsdk)

# Authenticate to AML workspace
ws <- load_workspace_from_config()


# Create and register environment from custom Docker image
env <- r_environment("R-env",
                     ##custom_docker_image = "<repository_name>.azurecr.io/<image_name>:<tag>")
                     custom_docker_image = "azuremlb384076d.azurecr.io/azureml/r-image:latest")

register_environment(env, ws)