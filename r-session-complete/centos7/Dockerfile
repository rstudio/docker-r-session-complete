FROM rstudio/r-session-base:centos7-1.2.1320-1

# Install R and R packages -----------------------------------------------------

ARG R_VERSION=3.5.3

# Install required packages
RUN yum update -y && yum install -y \
git subversion which libxml2-devel

# Install build dependencies
RUN set -x && yum install -y epel-release make gcc gcc-c++

# Install R dependencies
RUN set -x \
&& yum update -y \
&& yum install -y yum-utils \
&& yum-builddep -y R

# Install R from source
RUN cd /opt && mkdir R && cd R \
&& wget https://cran.r-project.org/src/base/R-3/R-$R_VERSION.tar.gz \
&& tar zxvf R-$R_VERSION.tar.gz \
&& cd R-$R_VERSION  \
&& ./configure --prefix=/opt/R/$R_VERSION --enable-memory-profiling \
--enable-R-shlib --with-blas --with-lapack \
&& make \
&& make install \
&& rm -rf /opt/R/R-${R_VERSION}.tar.gz \
&& rm -rf /opt/R/R-${R_VERSION}

# Install R packages
RUN /opt/R/$R_VERSION/bin/R -e 'install.packages("devtools", repos="http://cran.us.r-project.org")' \
&& /opt/R/$R_VERSION/bin/R -e 'install.packages("tidyverse", repos="http://cran.us.r-project.org")' \
&& /opt/R/$R_VERSION/bin/R -e 'install.packages("shiny", repos="http://cran.us.r-project.org")' \
&& /opt/R/$R_VERSION/bin/R -e 'install.packages("rmarkdown", repos="http://cran.us.r-project.org")'

# Include R in PATH
ENV PATH="/opt/R/$R_VERSION/bin:${PATH}"

# Set the locale
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
