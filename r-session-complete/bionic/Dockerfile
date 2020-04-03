FROM ubuntu:bionic

LABEL maintainer="sol-eng@rstudio.com"

# Set versions and platforms
ARG RSP_PLATFORM=xenial
ARG RSP_VERSION=1.3.842-1
ARG R_VERSION=3.6.2
ARG MINICONDA_VERSION=4.5.4
ARG PYTHON_VERSION=3.6.5
ARG DRIVERS_VERSION=1.6.1

# Install RStudio Server Pro session components -------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    gdebi \
    libcurl4-gnutls-dev \
    libssl1.0.0 \
    libssl-dev \
    libuser \
    libuser1-dev \
    rrdtool

RUN curl -O https://s3.amazonaws.com/rstudio-ide-build/session/${RSP_PLATFORM}/rsp-session-${RSP_PLATFORM}-${RSP_VERSION}.tar.gz && \
    mkdir -p /usr/lib/rstudio-server && \
    tar -zxvf ./rsp-session-${RSP_PLATFORM}-${RSP_VERSION}.tar.gz -C /usr/lib/rstudio-server/ && \
    mv /usr/lib/rstudio-server/rsp-session*/* /usr/lib/rstudio-server/ && \
    rm -rf /usr/lib/rstudio-server/rsp-session* && \
    rm -f ./rsp-session-${RSP_PLATFORM}-${RSP_VERSION}.tar.gz

EXPOSE 8788/tcp

# Install additional system packages ------------------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git \
    libssl1.0.0 \
    libuser \
    libxml2-dev \
    subversion

# Install R -------------------------------------------------------------------#

RUN curl -O https://cdn.rstudio.com/r/ubuntu-1804/pkgs/r-${R_VERSION}_1_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive gdebi --non-interactive r-${R_VERSION}_1_amd64.deb && \
    rm -rf r-${R_VERSION}_1_amd64.deb

RUN ln -s /opt/R/${R_VERSION}/bin/R /usr/local/bin/R && \
    ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/local/bin/Rscript

# Install R packages ----------------------------------------------------------#

RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("devtools", repos="https://demo.rstudiopm.com/cran/__linux__/bionic/latest")' && \
    /opt/R/${R_VERSION}/bin/R -e 'install.packages("tidyverse", repos="https://demo.rstudiopm.com/cran/__linux__/bionic/latest")' && \
    /opt/R/${R_VERSION}/bin/R -e 'install.packages("shiny", repos="https://demo.rstudiopm.com/cran/__linux__/bionic/latest")' && \
    /opt/R/${R_VERSION}/bin/R -e 'install.packages("rmarkdown", repos="https://demo.rstudiopm.com/cran/__linux__/bionic/latest")'

# Install Python --------------------------------------------------------------#

RUN curl -O https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -bp /opt/python/${PYTHON_VERSION} && \
    /opt/python/${PYTHON_VERSION}/bin/pip install virtualenv && \
    rm -rf Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh

ENV PATH="/opt/python/${PYTHON_VERSION}/bin:${PATH}"

# Install Jupyter Notebook and RSP/RSC Notebook Extensions and Packages -------#

RUN /opt/python/${PYTHON_VERSION}/bin/pip install \
    jupyter \
    jupyterlab \
    rsp_jupyter \
    rsconnect_jupyter \
    rsconnect_python

RUN /opt/python/${PYTHON_VERSION}/bin/jupyter-nbextension install --sys-prefix --py rsp_jupyter && \
    /opt/python/${PYTHON_VERSION}/bin/jupyter-nbextension enable --sys-prefix --py rsp_jupyter && \
    /opt/python/${PYTHON_VERSION}/bin/jupyter-nbextension install --sys-prefix --py rsconnect_jupyter && \
    /opt/python/${PYTHON_VERSION}/bin/jupyter-nbextension enable --sys-prefix --py rsconnect_jupyter && \
    /opt/python/${PYTHON_VERSION}/bin/jupyter-serverextension enable --sys-prefix --py rsconnect_jupyter

# Install Python packages -----------------------------------------------------#

RUN /opt/python/${PYTHON_VERSION}/bin/pip install \
    altair \
    beautifulsoup4 \
    cloudpickle \
    cython \
    dask \
    gensim \
    keras \
    matplotlib \
    nltk \
    numpy \
    pandas \
    pillow \
    pyarrow \
    requests \
    scipy \
    scikit-image \
    scikit-learn \
    scrapy \
    seaborn \
    spacy \
    sqlalchemy \
    statsmodels \
    tensorflow \
    xgboost

# Install RStudio Professional Drivers ----------------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y unixodbc unixodbc-dev gdebi

RUN curl -O https://drivers.rstudio.org/7C152C12/installer/rstudio-drivers_${DRIVERS_VERSION}_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive gdebi --non-interactive rstudio-drivers_${DRIVERS_VERSION}_amd64.deb

RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("odbc", repos="https://demo.rstudiopm.com/cran/__linux__/bionic/latest")'

# Locale configuration --------------------------------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
