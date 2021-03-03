FROM centos:7

LABEL maintainer="RStudio Docker <docker@rstudio.com>"

# Set versions and platforms
ARG RSP_PLATFORM=centos7
ARG RSP_VERSION=1.4.1106-5
ARG R_VERSION=4.0.2
ARG MINICONDA_VERSION=py37_4.8.3
ARG PYTHON_VERSION=3.7.7
ARG DRIVERS_VERSION=1.6.1-1
ARG CODE_SERVER_VERSION=3.8.1

# Install RStudio Server Pro session components -------------------------------#

RUN yum update -y && \
    yum install -y \
    libcurl-devel \
    libuser-devel \
    openssl-devel \
    postgresql-libs \
    rrdtool && \
    yum clean all

RUN curl -O https://s3.amazonaws.com/rstudio-ide-build/session/${RSP_PLATFORM}/rsp-session-${RSP_PLATFORM}-${RSP_VERSION}.tar.gz && \
    mkdir -p /usr/lib/rstudio-server && \
    tar -zxvf ./rsp-session-${RSP_PLATFORM}-${RSP_VERSION}.tar.gz -C /usr/lib/rstudio-server/ && \
    mv /usr/lib/rstudio-server/rsp-session*/* /usr/lib/rstudio-server/ && \
    rm -rf /usr/lib/rstudio-server/rsp-session* && \
    rm -f ./rsp-session-${RSP_PLATFORM}-${RSP_VERSION}.tar.gz && \
    # write session version to a file
    echo "${RSP_VERSION}" > /usr/lib/rstudio-server/SESSION_VERSION

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

RUN curl -O https://cdn.rstudio.com/r/centos-7/pkgs/R-${R_VERSION}-1-1.x86_64.rpm && \
    yum install -y R-${R_VERSION}-1-1.x86_64.rpm && \
    yum clean all && \
    rm -rf R-${R_VERSION}-1-1.x86_64.rpm

RUN ln -s /opt/R/${R_VERSION}/bin/R /usr/local/bin/R && \
    ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/local/bin/Rscript

# Install R packages ----------------------------------------------------------#

RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("devtools", repos="https://packagemanager.rstudio.com/cran/__linux__/centos7/latest")' && \
    /opt/R/${R_VERSION}/bin/R -e 'install.packages("tidyverse", repos="https://packagemanager.rstudio.com/cran/__linux__/centos7/latest")' && \
    /opt/R/${R_VERSION}/bin/R -e 'install.packages("shiny", repos="https://packagemanager.rstudio.com/cran/__linux__/centos7/latest")' && \
    /opt/R/${R_VERSION}/bin/R -e 'install.packages("rmarkdown", repos="https://packagemanager.rstudio.com/cran/__linux__/centos7/latest")' && \
    /opt/R/${R_VERSION}/bin/R -e 'install.packages("plumber", repos="https://packagemanager.rstudio.com/cran/__linux__/centos7/latest")'

# Install Python --------------------------------------------------------------#

RUN yum update -y && \
    yum install -y bzip2 && \
    yum clean all

RUN curl -O https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -bp /opt/python/${PYTHON_VERSION} && \
    /opt/python/${PYTHON_VERSION}/bin/pip install virtualenv && \
    rm -rf Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh

ENV PATH="/opt/python/${PYTHON_VERSION}/bin:${PATH}"

# Install Python packages -----------------------------------------------------#

RUN /opt/python/${PYTHON_VERSION}/bin/pip install \
    altair \
    beautifulsoup4 \
    bokeh \
    cloudpickle \
    cython \
    dash \
    dask \
    flask \
    gensim \
    keras \
    matplotlib \
    nltk \
    numpy \
    pandas \
    pillow \
    plotly \
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
    streamlit \
    tensorflow \
    xgboost

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

# Install VSCode code-server --------------------------------------------------#

RUN curl -o code-server.tar.gz -L https://github.com/cdr/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server-${CODE_SERVER_VERSION}-linux-amd64.tar.gz && \
    mkdir -p /opt/code-server && \
    tar -zxvf ./code-server.tar.gz -C /opt/code-server/ --strip-components 1 && \
    rm -f ./code-server.tar.gz

# Install RStudio Professional Drivers ----------------------------------------#

RUN yum update -y && \
    yum install -y unixODBC unixODBC-devel && \
    yum clean all

RUN curl -O https://drivers.rstudio.org/7C152C12/installer/rstudio-drivers-${DRIVERS_VERSION}.el7.x86_64.rpm && \
    yum install -y rstudio-drivers-${DRIVERS_VERSION}.el7.x86_64.rpm && \
    yum clean all && \
    cp /opt/rstudio-drivers/odbcinst.ini.sample /etc/odbcinst.ini

RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("odbc", repos="https://packagemanager.rstudio.com/cran/__linux__/centos7/latest")'

# Locale configuration --------------------------------------------------------#

RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
