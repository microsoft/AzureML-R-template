# Conversion of working R pipeline notebook into .py.
# Will refactor into pipeline.py and pipeline.runconfig

# Azure Machine Learning and Pipeline SDK-specific Imports
import azureml.core
from azureml.core import Workspace, Experiment, Datastore
from azureml.core.compute import AmlCompute
from azureml.core.compute import ComputeTarget
from azureml.widgets import RunDetails

# Check core SDK version number
print("SDK version:", azureml.core.VERSION)

from azureml.data.data_reference import DataReference
from azureml.pipeline.core import Pipeline, PipelineData
from azureml.pipeline.steps import RScriptStep
print("Pipeline SDK-specific imports completed")

# Initialize Workspace
ws = Workspace.from_config()
print(ws.name, ws.resource_group, ws.location, ws.subscription_id, sep = '\n')

# Upload data to default datastore

# Default datastore (Azure blob storage)
# def_blob_store = ws.get_default_datastore()
def_blob_store = Datastore(ws, "workspaceblobstore")
print("Blobstore's name: {}".format(def_blob_store.name))

# get_default_datastore() gets the default Azure Blob Store associated with your workspace.
# Here we are reusing the def_blob_store object we obtained earlier
def_blob_store.upload("./03-pipelines/data", target_path="diabetes_data", overwrite=True)
print("Upload call completed")

# Source directory
source_directory = './03-pipelines/train'
print('Sample pipeline step scripts will be created in {} directory.'.format(source_directory))

# Attach AML Compute
from azureml.core.compute_target import ComputeTargetException

aml_compute_target = "cpu-cluster"
try:
    aml_compute = AmlCompute(ws, aml_compute_target)
    print("found existing compute target.")
except ComputeTargetException:
    print("creating new compute target")
    
    provisioning_config = AmlCompute.provisioning_configuration(vm_size = "STANDARD_D2_V2",
                                                                min_nodes = 1, 
                                                                max_nodes = 4)    
    aml_compute = ComputeTarget.create(ws, aml_compute_target, provisioning_config)
    aml_compute.wait_for_completion(show_output=True, min_node_count=None, timeout_in_minutes=20)
    
print("Aml Compute attached")

# Define Input and output data sources
blob_input_data = DataReference(
    datastore=def_blob_store,
    data_reference_name="diabetes_data",
    path_on_datastore="diabetes_data/")
print("DataReference object created")

processed_data1 = PipelineData("processed_data1",datastore=def_blob_store)
print("PipelineData object created")

## Define R RunConfiguration and Environment
from azureml.pipeline.steps import RScriptStep
from azureml.core.runconfig import RunConfiguration, DataReferenceConfiguration
from azureml.core.environment import Environment, RSection, RCranPackage, RGitHubPackage

# Create a new runconfig using the R framework
rc = RunConfiguration()
rc.framework = 'R'

# Create a new environment
renv = Environment(name="rpipeline-renv")
renv.docker.enabled = True

# Add an R section to the environment to set R env attributes
renv.r = RSection()
#renv.r.user_managed = True
#renv.r.version = '4.0.3' ## not working - conda-forge channel not being picked up?

# Add CRAN packages
cran_pkg = RCranPackage()
cran_pkg.name = 'tidyverse'

# Add github packages
# Investigate if these github packages are actually installed in image
#github_pkg = RGitHubPackage()
#github_pkg.repository = ['Azure/azureml-sdk-for-r', 'Azure/doAzureParallel']
renv.r.cran_packages = [cran_pkg]
#renv.r.github_packages = [github_pkg]

# Add new environment to runconfig
rc.environment = renv

# Defining the RScriptStep modifies the runconfiguration. Output before and after
# to understand what changes are needed.
#rc.save(name="pipelinerc-before.runconfig")

# Create single train step
trainStep = RScriptStep(
    script_name="train.R", 
    arguments=["--input_data", blob_input_data, "--output_train", processed_data1],
    inputs=[blob_input_data],
    outputs=[processed_data1],
    compute_target=aml_compute, 
    source_directory=source_directory,
    runconfig=rc
)
print("trainStep created")

#rc.save(name="pipelinerc-after.runconfig")

# Build and run pipeline
pipeline1 = Pipeline(workspace=ws, steps=[trainStep])
print ("Pipeline is built")
pipeline1.validate()

print('Publishing pipeline')
published_pipeline = pipeline1.publish('RPipeline-with-data-dependency')

# Output pipeline_id in specified format which will convert it to a variable in Azure DevOps
print(f'##vso[task.setvariable variable=pipeline_id]{published_pipeline.id}')

pipeline_run1 = Experiment(ws, 'RPipeline-with-data-dependency').submit(pipeline1)
print("Pipeline is submitted for execution")

pipeline_run1.wait_for_completion(show_output=True)

# See Output
# Get Steps
for step in pipeline_run1.get_steps():
    print("Outputs of step " + step.name)
    
    # Get a dictionary of StepRunOutputs with the output name as the key 
    output_dict = step.get_outputs()
    
    for name, output in output_dict.items():
        
        output_reference = output.get_port_data_reference() # Get output port data reference
        print("\tname: " + name)
        print("\tdatastore: " + output_reference.datastore_name)
        print("\tpath on datastore: " + output_reference.path_on_datastore)

# Download output
# Retrieve the step runs by name 'train.py'
train_step = pipeline_run1.find_step_run('train.py')

if train_step:
    train_step_obj = train_step[0] # since we have only one step by name 'train.py'
    train_step_obj.get_output_data('processed_data1').download("./outputs") # download the output to current directory