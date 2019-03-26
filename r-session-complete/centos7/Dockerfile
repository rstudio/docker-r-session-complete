FROM rstudio/r-session-base:centos7-1.2.1320-1

ARG R_VERSION=3.5.3
ARG OS_IDENTIFIER=centos-7
ARG PRO_DRIVERS_VERSION=7C152C12

# Install system dependencies
RUN yum update -y && \
    yum -y install epel-release && \
    yum -y groupinstall "Development tools" && \
    yum install -y \
    gcc \
    libcurl-devel \
    libicu \
    make \
    pcre2 \
    perl-Digest-MD5 \
    sudo \
    tcl \
    tk \
    tre \
    vim \
    wget && \
    yum clean all

# Install additional dependencies
RUN yum update -y && \
    yum install -y \
    git \
    libxml2-devel \
    openssl-devel \
    pandoc \
    subversion \
    which && \
    yum clean all

# Install R
RUN mkdir -p /opt/R && cd /opt/R && \
    wget https://cdn.rstudio.com/r/${OS_IDENTIFIER}/R-${R_VERSION}-${OS_IDENTIFIER}.tar.gz && \
    mkdir -p /opt/R && \
    tar zx -C /opt/R -f ./R-${R_VERSION}-${OS_IDENTIFIER}.tar.gz && \
    rm R-${R_VERSION}-${OS_IDENTIFIER}.tar.gz

# Install R packages
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("devtools", repos="http://cran.us.r-project.org")' && \
    /opt/R/${R_VERSION}/bin/R -e 'install.packages("tidyverse", repos="http://cran.us.r-project.org")' && \
    /opt/R/${R_VERSION}/bin/R -e 'install.packages("shiny", repos="http://cran.us.r-project.org")' && \
    /opt/R/${R_VERSION}/bin/R -e 'install.packages("rmarkdown", repos="http://cran.us.r-project.org")'

# Include R in PATH
ENV PATH="/opt/R/${R_VERSION}/bin:${PATH}"

# Install RStudio Professional Drivers
RUN yum update -y && yum install -y unixODBC unixODBC-devel && yum clean all
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("odbc", repos="http://cran.us.r-project.org")'
RUN mkdir -p /opt/rstudio-drivers && \
    cd /opt/rstudio-drivers && \
    wget https://drivers.rstudio.org/${PRO_DRIVERS_VERSION}/odbc-install.sh && \
    chmod +x odbc-install.sh && \
    ./odbc-install.sh --eula

# Set the locale
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
