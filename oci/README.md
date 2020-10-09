# Ubuntu Prometheus OCI image

This OCI image was built based on the upstream one (prom/prometheus). Prometheus in Ubuntu is supported as a snap package, so both are built from the same source. The Ubuntu Dockerfile differs a bit from upstream, instead of relying on the upstream Makefile to do the build and copy the binaries and needed file into the image, we do the build and test of the code during OCI build time.

As an initial attempt to not require Internet access to build the image the following was changed:

* Add the promu (tool used to build prometheus) binaries for the supported architectures to this repo to avoid downloading them from Github. Build promu from source was also considerd but it depends on itself (older version) to build, for now the binaries built from upstream are used.

There is no change that should impact users.
