FROM rocker/tidyverse:latest
 
# Install python (this is still required by AzureML, but this requirement will soon be removed )
RUN apt-get update -qq && \
 apt-get install -y python3-pip
RUN ln -f /usr/bin/python3 /usr/bin/python
RUN ln -f /usr/bin/pip3 /usr/bin/pip
RUN pip install -U pip

# install azureml-base and libfuse (this is required for data access in local execution -- this requirement will also be removed soon)
RUN sudo apt-get install -y libfuse-dev
RUN pip install azureml-dataprep azureml-core
RUN apt-get update && apt-get install -y fuse

# Install optparse R package for argument passing from the AzureML job
RUN R -e "install.packages(c('optparse'), repos = 'https://cloud.r-project.org/')"

# Install any additional R packages needed for the R script
RUN R -e "install.packages(c('caret', 'randomForest'), repos = 'https://cloud.r-project.org/')"