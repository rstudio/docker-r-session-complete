# docker-r-session-complete

Dockerfiles for R and Python sessions and jobs to be used RStudio Server Pro,
Launcher, and Kubernetes.

## How to Use These Docker Images

The Docker images built from these Dockerfiles are intended to be used for R and
Jupyter sessions and jobs with RStudio Server Pro (RSP), Launcher, and
Kubernetes.

Note: These Docker images are not equipped or intended to be used to run RStudio
Server Pro within a Docker container. Visit the
[rstudio/rstudio-docker-products](https://github.com/rstudio/rstudio-docker-products)
repository for images built for that purpose.

For more information about RStudio Server Pro and Launcher, refer to the
[Launcher Overview](https://solutions.rstudio.com/launcher/overview/) on the
RStudio Solutions website.

For more information about how to use these images with RStudio Server Pro and
Launcher, refer to the RStudio support article on [Using Docker images with
RStudio Server Pro, Launcher, and
Kubernetes](https://support.rstudio.com/hc/en-us/articles/360019253393-Using-Docker-images-with-RStudio-Server-Pro-Launcher-and-Kubernetes).

## Docker Images on Docker Hub

Built images are available from the
[rstudio/r-session-complete](https://hub.docker.com/r/rstudio/r-session-complete)
repository on Docker Hub.

## Docker Image Layers

These images include the following layers:

* Base OS
* RSP session components
* System packages required for R, R packages, and RStudio Professional Drivers
* One version of R
* R packages (devtools, tidyverse, shiny, and rmarkdown)
* One version of Python
* Jupyter Notebooks, JupyterLab, and RSP/RSC notebook extensions
* Python packages
* RStudio Professional Drivers
