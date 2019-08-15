FROM ubuntu:bionic

LABEL maintainer="sol-eng@rstudio.com"

# Set versions and platforms
ARG RSP_PLATFORM=trusty
ARG RSP_VERSION=1.2.1568-3
ARG R_VERSION=3.6.1
ARG PYTHON_VERSION=3.6.8
ARG PYTHON_MAJOR_VERSION=3
ARG CONDA_VERSION=4.6.14

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
    rrdtool \
    wget

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

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-transport-https \
    build-essential \
    curl \
    gfortran \
    libbz2-dev \
    libcairo2 \
    libcurl4-openssl-dev \
    libicu-dev \
    liblzma-dev \
    libopenblas-dev \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libpcre3-dev \
    libtcl8.6 \
    libtiff5 \
    libtk8.6 \
    libx11-6 \
    libxt6 \
    locales \
    tzdata \
    wget \
    zlib1g-dev

RUN curl -O https://cdn.rstudio.com/r/ubuntu-1804/R-${R_VERSION}-ubuntu-1804.tar.gz && \
    mkdir -p /opt/R && \
    tar -xzC /opt/R -f ./R-${R_VERSION}-ubuntu-1804.tar.gz &&\
    rm -rf R-${R_VERSION}-ubuntu-1804.tar.gz

ENV PATH="/opt/R/${R_VERSION}/bin:${PATH}"

# Install R packages ----------------------------------------------------------#

RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("devtools", repos="https://cran.rstudio.com")' && \
    /opt/R/${R_VERSION}/bin/R -e 'install.packages("tidyverse", repos="https://cran.rstudio.com")' && \
    /opt/R/${R_VERSION}/bin/R -e 'install.packages("shiny", repos="https://cran.rstudio.com")' && \
    /opt/R/${R_VERSION}/bin/R -e 'install.packages("rmarkdown", repos="https://cran.rstudio.com")'

# Install Python --------------------------------------------------------------#

RUN mkdir -p /opt/python && \
    cd /opt/python && \
    curl -O https://repo.anaconda.com/miniconda/Miniconda${PYTHON_MAJOR_VERSION}-${CONDA_VERSION}-Linux-x86_64.sh && \
    bash Miniconda${PYTHON_MAJOR_VERSION}-${CONDA_VERSION}-Linux-x86_64.sh -bp /opt/python/${PYTHON_VERSION} && \
    /opt/python/${PYTHON_VERSION}/bin/pip install virtualenv && \
    rm -rf Miniconda${PYTHON_MAJOR_VERSION}-${CONDA_VERSION}-Linux-x86_64.sh

ENV PATH="/opt/python/${PYTHON_VERSION}/bin:${PATH}"

# Install Jupyter Notebook and RSP/RSC Notebook Extensions --------------------#

RUN /opt/python/${PYTHON_VERSION}/bin/pip install \
    jupyter \
    jupyterlab \
    rsp_jupyter \
    rsconnect_jupyter

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
    DEBIAN_FRONTEND=noninteractive apt-get install -y unixodbc unixodbc-dev

RUN mkdir -p /opt/rstudio-drivers && \
    cd /opt/rstudio-drivers && \
    curl -O https://drivers.rstudio.org/7C152C12/odbc-install.sh && \
    bash odbc-install.sh --eula && \
    rm odbc-install.sh

RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("odbc", repos="http://cran.us.r-project.org")'

# Locale configuration --------------------------------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
