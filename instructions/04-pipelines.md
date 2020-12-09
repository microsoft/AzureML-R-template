# ML Pipelines

ML Pipelines in AML allows you to group multiple parts of your Machine Learning process and group it into one pipeline. For example, a pipeline could consist of feature preprocessing, model training, model evaluation and finally model registration. A pipeline wraps these steps into one self-contained unit, that you can either run on-demand through AML or expose as a RESTful API. The latter will allow other users or application to trigger this pipeline and run it. By adding parameters, this pipeline can be made dynamic, e.g., allowing to feed in new data as it becomes available.

AML offers 3 different ways of creating pipelines, using the [AML CLI and YAML](https://docs.microsoft.com/en-us/azure/machine-learning/reference-azure-machine-learning-cli#ml-pipeline-management), the [Python SDK](https://docs.microsoft.com/en-us/azure/machine-learning/concept-ml-pipelines#building-pipelines-with-the-python-sdk), or the [Visual Designer](https://docs.microsoft.com/en-us/azure/machine-learning/concept-designer). This repo will show how to create a simple pipeline for R using CLI/YAML and a small Python front-end to execute the R code.
## Execute training in a ML Pipeline

* Open the terminal and navigate to the [`src/model1/aml_config`](../src/model1/aml_config/) folder
* Open `pipeline.yml` in your editor and adapt the necessary fields, which are most likely:
    * `default_compute` - point to the AML Compute cluster created earlier
    * `dataset_name` - point to your dataset registered earlier
    * `arguments` - adapt to have Rscript run your top-level R script and data path argument. Add any further arguments (similar to the training stage) as needed.
    * Note that `script_name` should point to the python stub file `src/model1/r_pipeline.py`. Editing this is unnecessary.
* Open `pipeline-runconfig.yml` and adapt to use your target compute cluster and custom Docker image.
* Navigate to [`src/model1`](../src/model1/) 
* From the command line, you can now run the training in a pipeline (asynchronously):
    ```
    az ml run submit-pipeline -n training-pipeline-exp -y aml_config/pipeline.yml
    ```
    * For more details on how to publish the pipeline, check the [README.md](../pipelines-yaml/README.md)

## Publishing the Pipeline

When the training pipeline runs successfully and is ready to publish as an endpoint, we can publish the pipeline as a pipeline draft:
```
az ml pipeline create-draft -e training-pipeline-draft -n training-pipeline -y aml_config/pipeline.yml
```

And then submit that draft as an experiment for testing:
```
az ml pipeline submit-draft -i <pipeline_draft_id>
```
Once you confirmed that the pipeline draft works fine, you can fully publish the pipeline as an endpoint so that other processes like Azure Data Factory or Azure DevOps can use it:
```
az ml pipeline publish-draft -i <pipeline_draft_id>
```

The pipeline will then show up under `Endpoints --> Pipeline endpoints` in the Azure Machine Learning studio.

Great, we got our training running in an ML pipeline. Let's move on to the [next section](05-automation.md) for using GitHub Actions for MLOps.