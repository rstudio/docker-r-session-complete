FROM ubuntu:18.04

# Install and configure RStudio Server Pro session components ------------------

ARG RSP_VERSION=1.2.1320-1
ARG RSP_PLATFORM=trusty

# Install required packages
RUN apt-get update -y && apt-get install -y \
wget gdebi rrdtool libuser libuser1-dev locales \
libssl1.0.0 libssl-dev libcurl4-gnutls-dev libxml2-dev \
git subversion

# Install RStudio Server Pro session components
ARG RSTUDIO_DOWNLOAD_URL=https://s3.amazonaws.com/rstudio-ide-build
RUN wget ${RSTUDIO_DOWNLOAD_URL}/session/${RSP_PLATFORM}/rsp-session-${RSP_PLATFORM}-${RSP_VERSION}.tar.gz \
&& mkdir -p /usr/lib/rstudio-server \
&& tar zxvf ./rsp-session-${RSP_PLATFORM}-${RSP_VERSION}.tar.gz -C /usr/lib/rstudio-server/ \
&& mv /usr/lib/rstudio-server/rsp-session*/* /usr/lib/rstudio-server/ \
&& rm -rf /usr/lib/rstudio-server/rsp-session* \
&& rm -f ./rsp-session-${RSP_PLATFORM}-${RSP_VERSION}.tar.gz

# Expose port for RStudio Server Pro session
EXPOSE 8788/tcp

# Prepare access for the NFS mount
RUN chmod 777 /home
