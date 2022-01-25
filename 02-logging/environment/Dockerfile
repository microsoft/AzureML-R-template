FROM rocker/tidyverse:latest

# Install python
RUN apt-get update -qq && \
 apt-get install -y python3-pip tcl tk libz-dev libpng-dev

RUN ln -f /usr/bin/python3 /usr/bin/python
RUN ln -f /usr/bin/pip3 /usr/bin/pip
RUN pip install -U pip

# Install azureml-mlflow
RUN pip install azureml-mlflow

# Create link for python
RUN ln -f /usr/bin/python3 /usr/bin/python

# Install additional R packages for MLflow suport
RUN R -e "install.packages(c('mlflow'), repos = 'https://cloud.r-project.org/')"
RUN R -e "install.packages(c('carrier'), repos = 'https://cloud.r-project.org/')"
RUN R -e "install.packages(c('tcltk2'), repos = 'https://cloud.r-project.org/')"

# Install optparse R package for argument passing from the AzureML job
RUN R -e "install.packages(c('optparse'), repos = 'https://cloud.r-project.org/')"

# Install any additional R packages needed for your R script
RUN R -e "install.packages(c('caret', 'randomForest','yardstick'), repos = 'https://cloud.r-project.org/')"
