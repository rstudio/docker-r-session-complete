FROM rstudio/r-session-base:bionic-1.2.1320-1

ARG R_VERSION=3.5.3
ARG PRO_DRIVERS_VERSION=7C152C12

# Install build dependencies
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list && \
    apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get build-dep -y r-base

# Install additional dependencies
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git \
    libssl1.0.0 \
    libuser \
    libxml2-dev \
    locales \
    subversion

# Install R from source
RUN mkdir -p /opt/R && \
    cd R && \
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

# Include R in PATH
ENV PATH="/opt/R/${R_VERSION}/bin:${PATH}"

# Install RStudio Professional Drivers
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y unixodbc unixodbc-dev
RUN mkdir -p /opt/rstudio-drivers && \
    cd /opt/rstudio-drivers && \
    wget https://drivers.rstudio.org/${PRO_DRIVERS_VERSION}/odbc-install.sh && \
    bash odbc-install.sh --eula
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("odbc", repos="http://cran.us.r-project.org")'

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
