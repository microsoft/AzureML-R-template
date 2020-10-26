FROM mcr.microsoft.com/azureml/base:openmpi3.1.2-ubuntu18.04

RUN conda install -c r -y pip=20.1.1 openssl=1.1.1c r-base r-essentials rpy2 && \
  conda install -c conda-forge -y mscorefonts && \
    conda clean -ay && \
    pip install --no-cache-dir azureml-defaults
    
ENV TAR="/bin/tar"
RUN R -e "install.packages(c('remotes', 'reticulate', 'optparse'), repos = 'https://cloud.r-project.org/')"
RUN R -e "remotes::install_github('https://github.com/Azure/azureml-sdk-for-r')" 
RUN R -e "install.packages(c('e1071'), repos = 'https://cloud.r-project.org/')"