# AML Pipelines with R

ML Pipelines in AML allows you to group multiple parts of your Machine Learning process and group it into one pipeline. For example, a pipeline could consist of feature preprocessing, model training, model evaluation and finally model registration. A pipeline wraps these steps into one self-contained unit, that you can either run on-demand through AML or expose as a RESTful API. The latter will allow other users or application to trigger this pipeline and run it. By adding parameters, this pipeline can be made dynamic, e.g., allowing to feed in new data as it becomes available.

AML Pipelines cannot be authored directly from R code. In this repo, the pipeline will be authored using the AML Python SDK. Pipelines calling R code can also be authored using the Visual Designer but this approach will not be covered here as it offers less environment flexibility and may require more extensive code refactoring.

## Build and Publish the Training Pipeline

From within the directory of each pipeline, you can run it via:

```
python pipeline.py <arguments>
```

The `train` pipeline deployment script accepts the following command line arguments for publishing the training pipeline:

| Argument              | Description |
|:--------------------  | ------------|
| `--pipeline_name`     | Name of the pipeline that will be deployed |
| `--build_number`      | (Optional) The build number |
| `--datastore`           | References the datastore by name in the AML workspace where the training data is stored| 
| `--data_path`         | Path to the data within the datastore |
| `--runconfig`         | Path to the runconfig that configures the training |
| `--source_directory`  | Path to the source directory containing the training code | 


Example:
```
python pipeline.py --pipeline_name training_pipeline --datastore diabetes --data_path diabetes_data --runconfig pipeline.runconfig --source_directory ../../src/model1/
```
Optionally, edit `pipeline.py` and uncomment the last two lines to submit the pipeline as an experiment for testing.  
```
#pipeline_run = Experiment(ws, 'training-pipeline').submit(pipeline)
#pipeline_run.wait_for_completion()
```

The published pipeline can be called via its REST API, so it can be triggered on demand, when you wish to retrain. Furthermore, you can use an orchestrator of your choice to trigger them, e.g., you could directly trigger it from [Azure Data Factory](https://azure.microsoft.com/en-us/services/data-factory/) when new data got processed. You may follow [this tutorial](https://docs.microsoft.com/en-us/azure/data-factory/transform-data-machine-learning-service).
