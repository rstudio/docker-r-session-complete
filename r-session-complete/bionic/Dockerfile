FROM ubuntu:bionic

LABEL maintainer="sol-eng@rstudio.com"

# Set versions and platforms
ARG RSP_PLATFORM=trusty
ARG RSP_VERSION=1.2.1511-1
ARG R_VERSION=3.6.0
ARG PYTHON_VERSION=3.6.8
ARG PYTHON_MAJOR_VERSION=3
ARG PRO_DRIVERS_VERSION=7C152C12

# Install RStudio Server Pro session components -------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    gdebi \
    libcurl4-gnutls-dev \
    libssl1.0.0 \
    libssl-dev \
    libuser \
    libuser1-dev \
    rrdtool \
    wget

RUN wget https://s3.amazonaws.com/rstudio-ide-build/session/${RSP_PLATFORM}/rsp-session-${RSP_PLATFORM}-${RSP_VERSION}.tar.gz && \
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

RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list && \
    apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get build-dep -y r-base

RUN mkdir -p /opt/R && \
    cd /opt/R && \
    wget https://cran.rstudio.com/src/base/R-3/R-${R_VERSION}.tar.gz && \
    tar zxvf R-${R_VERSION}.tar.gz && \
    cd R-${R_VERSION}  && \
    ./configure --prefix=/opt/R/${R_VERSION} --enable-memory-profiling --enable-R-shlib --with-blas --with-lapack && \
    make && \
    make install && \
    rm -rf /opt/R/R-${R_VERSION}.tar.gz && \
    rm -rf /opt/R/R-${R_VERSION}

ENV PATH="/opt/R/${R_VERSION}/bin:${PATH}"

# Install R packages ----------------------------------------------------------#

RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("devtools", repos="https://cran.rstudio.com")' && \
    /opt/R/${R_VERSION}/bin/R -e 'install.packages("tidyverse", repos="https://cran.rstudio.com")' && \
    /opt/R/${R_VERSION}/bin/R -e 'install.packages("shiny", repos="https://cran.rstudio.com")' && \
    /opt/R/${R_VERSION}/bin/R -e 'install.packages("rmarkdown", repos="https://cran.rstudio.com")'

# Install Python --------------------------------------------------------------#

RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list && \
    apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get build-dep -y python

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libffi-dev \
    libgdbm-dev \
    libsqlite3-dev \
    libssl-dev \
    zlib1g-dev

RUN mkdir -p /opt/Python && \
    cd /opt/Python && \
    wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar -xzvf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --prefix=/opt/Python/${PYTHON_VERSION} --enable-shared --enable-ipv6 LDFLAGS=-Wl,-rpath=/opt/Python/${PYTHON_VERSION}/lib,--disable-new-dtags && \
    make && \
    make install && \
    wget https://bootstrap.pypa.io/get-pip.py && \
    /opt/Python/${PYTHON_VERSION}/bin/python${PYTHON_MAJOR_VERSION} get-pip.py && \
    /opt/Python/${PYTHON_VERSION}/bin/pip install virtualenv && \
    rm -rf /opt/Python/Python-${PYTHON_VERSION}.tar.gz && \
    rm -rf /opt/Python/Python-${PYTHON_VERSION}

ENV PATH="/opt/Python/${PYTHON_VERSION}/bin:${PATH}"

# Install Jupyter Notebook and RSP/RSC Notebook Extensions --------------------#

RUN /opt/Python/${PYTHON_VERSION}/bin/pip install \
    jupyter \
    jupyterlab \
    rsp_jupyter \
    rsconnect_jupyter

RUN /opt/Python/${PYTHON_VERSION}/bin/jupyter-nbextension install --sys-prefix --py rsp_jupyter && \
    /opt/Python/${PYTHON_VERSION}/bin/jupyter-nbextension enable --sys-prefix --py rsp_jupyter && \
    /opt/Python/${PYTHON_VERSION}/bin/jupyter-nbextension install --sys-prefix --py rsconnect_jupyter && \
    /opt/Python/${PYTHON_VERSION}/bin/jupyter-nbextension enable --sys-prefix --py rsconnect_jupyter && \
    /opt/Python/${PYTHON_VERSION}/bin/jupyter-serverextension enable --sys-prefix --py rsconnect_jupyter

# Install Python packages -----------------------------------------------------#

RUN /opt/Python/${PYTHON_VERSION}/bin/pip install \
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
    pyspark \
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
    torch \
    torchvision \
    xgboost

# Install RStudio Professional Drivers ----------------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y unixodbc unixodbc-dev

RUN mkdir -p /opt/rstudio-drivers && \
    cd /opt/rstudio-drivers && \
    wget https://drivers.rstudio.org/${PRO_DRIVERS_VERSION}/odbc-install.sh && \
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
