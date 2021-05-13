#!/usr/bin/env bash

set -e
set -x

cd r-session-complete/${DISTRO}
docker build . -t r-session-complete
docker images
