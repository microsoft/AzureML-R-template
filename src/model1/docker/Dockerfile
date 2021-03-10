FROM rocker/tidyverse:4.0.0-ubuntu18.04
 
# Install python
RUN apt-get update -qq && \
 apt-get install -y python3
 
# Create link for python
RUN ln -f /usr/bin/python3 /usr/bin/python

# Install optparse package to support argument passing
RUN R -e "install.packages(c('optparse'), repos = 'https://cloud.r-project.org/')"

# Install additional R packages needed for training code
RUN R -e "install.packages(c('caret', 'e1071'), repos = 'https://cloud.r-project.org/')"