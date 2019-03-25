# docker-r-session
Dockerfiles for R sessions and jobs to be used RStudio Server Pro, Launcher, and
Kubernetes.

## Release Process

All changes should be made in a PR and merged when the build passes.

When builds on master are passing and you are ready to release a new version of
the image on Docker Hub, you can tag a release on master using the following
steps:

1. Bump versions of base Docker images in Dockerfiles
2. Run the following commands, editing the version string as needed:

```
export VERSION=1.2.1330-2-r-3.5.3
git tag -a ${VERSION} -m "${VERSION}"
git commit -a "Bump version to ${VERSION}"
```

3. The new images will get built on Travis CI and get pushed to Docker Hub
