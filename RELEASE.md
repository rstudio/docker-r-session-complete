# Release Process for Docker Images

When builds on master are passing and you are ready to release a new version of
the image on Docker Hub, you can tag a release on master using the following
steps:

1. Update versions of RSP session components in Dockerfiles in a PR.
2. Update versions of R, Python, Pro Drivers, and other components as needed.
3. Merge PR when the build passes.
4. Run the following commands on the `master` branch, editing the version string
   as needed (where `1.3.XXXX-X` is the RSP version):

   ```
   export VERSION=1.3.XXXX-X
   git commit -am "Release for image version ${VERSION}" --allow-empty
   git tag -a ${VERSION} -m "${VERSION}"
   git push origin ${VERSION}
   git push
   ```

   Note: Add the `-preview` suffix to the version string for tagged images that
   correspond to preview release versions of RSP. Images related to preview
   builds are intended for testing purposes, subject to being removed, do not
   fall under our support agreement, and are not recommended for use in
   production.

5. The new images will get built on Travis CI and get pushed to the
   [rstudio/r-session-complete](https://hub.docker.com/r/rstudio/r-session-complete)
   repository on Docker Hub.
