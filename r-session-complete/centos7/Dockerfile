FROM rstudio/r-session-base:centos7-1.2.1330-2

ARG R_VERSION=3.5.3
ARG PRO_DRIVERS_VERSION=7C152C12

# Install build dependencies
RUN yum update -y && \
    yum install -y epel-release make gcc gcc-c++ && \
    yum install -y yum-utils && \
    yum-builddep -y R && \
    yum clean all

# Install additional dependencies
RUN yum update -y && \
    yum install -y \
    git \
    libxml2-devel \
    subversion \
    which && \
    yum clean all

# Install R from source
RUN mkdir -p /opt/R && \
    cd /opt/R && \
    wget https://cran.r-project.org/src/base/R-3/R-${R_VERSION}.tar.gz && \
    tar zxvf R-${R_VERSION}.tar.gz && \
    cd R-${R_VERSION}  && \
    ./configure --prefix=/opt/R/${R_VERSION} --enable-memory-profiling --enable-R-shlib --with-blas --with-lapack && \
    make && \
    make install && \
    rm -rf /opt/R/R-${R_VERSION}.tar.gz && \
    rm -rf /opt/R/R-${R_VERSION}

# Install R packages
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("devtools", repos="http://cran.us.r-project.org")' && \
    /opt/R/${R_VERSION}/bin/R -e 'install.packages("tidyverse", repos="http://cran.us.r-project.org")' && \
    /opt/R/${R_VERSION}/bin/R -e 'install.packages("shiny", repos="http://cran.us.r-project.org")' && \
    /opt/R/${R_VERSION}/bin/R -e 'install.packages("rmarkdown", repos="http://cran.us.r-project.org")'

# Install RStudio Professional Drivers
RUN yum update -y && \
    yum install -y unixODBC unixODBC-devel && \
    yum clean all
RUN mkdir -p /opt/rstudio-drivers && \
    cd /opt/rstudio-drivers && \
    wget https://drivers.rstudio.org/${PRO_DRIVERS_VERSION}/odbc-install.sh && \
    bash odbc-install.sh --eula && \
    rm odbc-install.sh
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("odbc", repos="http://cran.us.r-project.org")'

# Include R in PATH
ENV PATH="/opt/R/${R_VERSION}/bin:${PATH}"

# Set the locale
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
