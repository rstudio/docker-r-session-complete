#!/usr/bin/env bash

set -e
set -x
docker tag r-session-complete rstudio/r-session-complete:${DISTRO}-${TRAVIS_TAG}
echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
docker push rstudio/r-session-complete:${DISTRO}-${TRAVIS_TAG}
