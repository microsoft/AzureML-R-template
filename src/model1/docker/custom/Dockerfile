FROM mcr.microsoft.com/azureml/base:openmpi3.1.2-ubuntu18.04

## Use Debian unstable via pinning -- new style via APT::Default-Release
RUN echo "deb http://http.debian.net/debian sid main" > /etc/apt/sources.list.d/debian-unstable.list \
        && echo 'APT::Default-Release "testing";' > /etc/apt/apt.conf.d/default


ENV R_BASE_VERSION 4.0.3

# Install R
RUN apt-get update \
        && apt-get install -t unstable -y --no-install-recommends \
                gcc-9-base \
                libopenblas0-pthread \
	         	r-base=${R_BASE_VERSION}-* \
	        	r-base-dev=${R_BASE_VERSION}-* \
		        r-recommended=${R_BASE_VERSION}-* \
	    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
	    && rm -rf /var/lib/apt/lists/* && \
        rm -rf /var/lib/apt/lists/*

# Set up miniconda environment for reticulate configuration
# and install and configure R AzureML SDK
RUN ln -s /opt/miniconda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/miniconda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

ENV TAR="/bin/tar"
RUN R -e "install.packages(c('remotes', 'reticulate'), repos = 'https://cloud.r-project.org/')" && \
    R -e "remotes::install_github('https://github.com/Azure/azureml-sdk-for-r')" && \
    R -e "library(azuremlsdk); install_azureml()" && \
    echo "Sys.setenv(RETICULATE_PYTHON='/opt/miniconda/envs/r-reticulate/bin/python3')" >> ~/.Rprofile

## Install common Linux OS prerequisites for popular R packages
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libssl-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libpng-dev \
    libjpeg-dev \
    libz-dev \
    libpcre3-dev \
    liblzma-dev \
    libbz2-dev \
    zlib1g-dev

# Install additional R packages.
# Note that optparse should always be installed to support
# argument passing to your R code in AML.
RUN R -e "install.packages(c('optparse'), repos = 'https://cloud.r-project.org/')"
RUN R -e "install.packages(c('e1071'), repos = 'https://cloud.r-project.org/')"