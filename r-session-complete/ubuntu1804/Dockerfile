FROM rstudio/r-session-base:ubuntu1804-1.2.1320-1

# Install R and R packages -----------------------------------------------------

ARG R_VERSION=3.5.2
ARG DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update -y && apt-get install -y \
# wget gdebi rrdtool libuser libuser1-dev \
# libssl1.0.0 libssl-dev libcurl4-gnutls-dev libxml2-dev \
git subversion locales

# Install R dependencies
RUN set -x \
&& sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list \
&& apt-get update -y \
&& apt-get build-dep -y r-base

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
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
