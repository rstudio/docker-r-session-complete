FROM centos:7

LABEL maintainer="sol-eng@rstudio.com"

# Set versions and platforms
ARG RSP_PLATFORM=centos6
ARG RSP_VERSION=1.2.1578-2
ARG R_VERSION=3.6.1
ARG PYTHON_VERSION=3.6.8
ARG PYTHON_MAJOR_VERSION=3
ARG CONDA_VERSION=4.6.14

# Install RStudio Server Pro session components -------------------------------#

RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y \
    libcurl-devel \
    libuser-devel \
    openssl-devel \
    rrdtool \
    wget && \
    yum clean all

RUN curl -O https://s3.amazonaws.com/rstudio-ide-build/session/${RSP_PLATFORM}/rsp-session-${RSP_PLATFORM}-${RSP_VERSION}.tar.gz && \
    mkdir -p /usr/lib/rstudio-server && \
    tar -zxvf ./rsp-session-${RSP_PLATFORM}-${RSP_VERSION}.tar.gz -C /usr/lib/rstudio-server/ && \
    mv /usr/lib/rstudio-server/rsp-session*/* /usr/lib/rstudio-server/ && \
    rm -rf /usr/lib/rstudio-server/rsp-session* && \
    rm -f ./rsp-session-${RSP_PLATFORM}-${RSP_VERSION}.tar.gz

EXPOSE 8788/tcp

# Install additional system packages ------------------------------------------#

RUN yum update -y && \
    yum install -y \
    git \
    libxml2-devel \
    subversion \
    which && \
    yum clean all

# Install R -------------------------------------------------------------------#

RUN yum update -y && \
    yum install -y epel-release && \
    yum clean all

RUN yum update -y && \
    yum install -y \
    atlas-devel \
    blas-devel \
    bzip2-devel \
    gcc \
    gcc-gfortran \
    lapack-devel \
    libSM \
    libXmu \
    libXt \
    libcurl-devel \
    libicu-devel \
    libtiff \
    openssl-devel \
    pango \
    pcre-devel \
    pcre2-devel \
    perl-Digest-MD5 \
    tcl \
    tk \
    xz-devel \
    zlib-devel \
    @'Development Tools' && \
    yum clean all

RUN curl -O https://cdn.rstudio.com/r/centos-7/R-${R_VERSION}-centos-7.tar.gz && \
    mkdir -p /opt/R && \
    tar -xzC /opt/R -f ./R-${R_VERSION}-centos-7.tar.gz && \
    rm -rf R-${R_VERSION}-centos-7.tar.gz

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

RUN yum update -y && \
    yum install -y unixODBC unixODBC-devel && \
    yum clean all

RUN mkdir -p /opt/rstudio-drivers && \
    cd /opt/rstudio-drivers && \
    curl -O https://drivers.rstudio.org/7C152C12/odbc-install.sh && \
    bash odbc-install.sh --eula && \
    rm odbc-install.sh

RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("odbc", repos="http://cran.us.r-project.org")'

# Locale configuration --------------------------------------------------------#

RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
