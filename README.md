# docker-r-session
Dockerfiles for R sessions and jobs to be used RStudio Server Pro, Launcher, and
Kubernetes.

## Docker Images on Docker Hub

Built images are available at
https://hub.docker.com/r/rstudio/r-session-complete.

## Docker Image Layers

These images includes the following layers:

* Base image from `rstudio/r-session-base` that includes OS and R session
  components
* Some system packages required for R, R packages, and RStudio Professional
  Drivers
* A recent version of R
* R packages (devtools, tidyverse, shiny, and rmarkdown)
* RStudio Professional Drivers

## Release Process for Docker Images

All changes should be made in a PR and merged when the build passes.

When builds on master are passing and you are ready to release a new version of
the image on Docker Hub, you can tag a release on master using the following
steps:

1. Bump versions of base Docker images in Dockerfiles
2. Run the following commands on the `master` branch, editing the version string
   as needed:

```
export VERSION=1.2.1330-2-r-3.5.3
git commit --allow-empty -m "Release for image version ${VERSION}"
git tag -a ${VERSION} -m "${VERSION}"
git push --follow-tags
```

3. The new images will get built on Travis CI and get pushed to Docker Hub
