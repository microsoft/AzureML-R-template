import os
import argparse
import azureml.core
from azureml.core import Workspace, Experiment, Datastore, RunConfiguration
from azureml.core.compute import AmlCompute, ComputeTarget
from azureml.pipeline.core import Pipeline, PipelineData, PipelineParameter
from azureml.pipeline.steps import RScriptStep
from azureml.data.data_reference import DataReference

print("Azure ML SDK version:", azureml.core.VERSION)

parser = argparse.ArgumentParser("deploy_training_pipeline")
parser.add_argument("--pipeline_name", type=str, help="Name of the pipeline that will be deployed", dest="pipeline_name", required=True)
parser.add_argument("--build_number", type=str, help="Build number", dest="build_number", required=False)
parser.add_argument("--datastore", type=str, help="Default datastore, referenced by name", dest="datastore", required=True)
parser.add_argument("--data_path", type=str, help="Path to data directory in datastore", dest="data_path", required=True)
parser.add_argument("--runconfig", type=str, help="Path to runconfig for pipeline", dest="runconfig", required=True)
parser.add_argument("--source_directory", type=str, help="Path to model training code", dest="source_directory", required=True)
args = parser.parse_args()
print(f'Arguments: {args}')

print('Connecting to workspace')
ws = Workspace.from_config()
print(f'WS name: {ws.name}\nRegion: {ws.location}\nSubscription id: {ws.subscription_id}\nResource group: {ws.resource_group}')

print('Loading runconfig for pipeline')
runconfig = RunConfiguration.load(args.runconfig)

print('Creating reference to training data for input to pipeline')  
blob_datastore = Datastore.get(ws, args.datastore)

blob_input_data = DataReference(
    data_reference_name="input_data_reference",
    datastore=blob_datastore,
    path_on_datastore=args.data_path)
print("DataReference object created")

# Create single train step
train_step = RScriptStep(name="train-step",
                    runconfig=runconfig,
                    source_directory=args.source_directory,
                    script_name=runconfig.script,
                    arguments=["--input_data", blob_input_data],
                    inputs=[blob_input_data],
                    allow_reuse=False)

steps = [train_step]

print('Creating and validating pipeline')
pipeline = Pipeline(workspace=ws, steps=steps)
pipeline.validate()

print('Publishing pipeline')
published_pipeline = pipeline.publish(args.pipeline_name)

# Output pipeline_id in specified format which will convert it to a variable in Azure DevOps
print(f'##vso[task.setvariable variable=pipeline_id]{published_pipeline.id}')

#pipeline_run = Experiment(ws, 'training-pipeline').submit(pipeline)
#pipeline_run.wait_for_completion()