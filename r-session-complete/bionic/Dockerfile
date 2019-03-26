FROM rstudio/r-session-base:bionic-1.2.1320-1

ARG R_VERSION=3.5.3
ARG OS_IDENTIFIER=ubuntu-1804
ARG PRO_DRIVERS_VERSION=7C152C12
ARG DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update -y && \
    apt-get install -y \
    git \
    make \
    libcurl4-openssl-dev \
    libssl-dev \
    libssl1.0.0 \
    libuser \
    libxml2-dev \
    locales \
    pandoc \
    subversion

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
RUN apt-get update -y && apt-get install -y unixodbc unixodbc-dev
RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("odbc", repos="http://cran.us.r-project.org")'
RUN mkdir -p /opt/rstudio-drivers && \
    cd /opt/rstudio-drivers && \
    wget https://drivers.rstudio.org/${PRO_DRIVERS_VERSION}/odbc-install.sh && \
    chmod +x odbc-install.sh && \
    ./odbc-install.sh --eula

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
