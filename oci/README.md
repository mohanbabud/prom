# Ubuntu Prometheus OCI image

This OCI image was built based on the upstream one (prom/prometheus). Prometheus in Ubuntu is supported as a snap package, so both are built from the same source. The Ubuntu Dockerfile differs a bit from upstream, instead of relying on the upstream Makefile to do the build and copy the binaries and needed file into the image, we do the build and test of the code during OCI build time.

As an initial attempt to not require Internet access to build the image the following was changed:

* Add the promu (tool used to build prometheus) binaries for the supported architectures to this repo to avoid downloading them from Github. Build promu from source was also considerd but it depends on itself (older version) to build, for now the binaries built from upstream are used.

There is no change that should impact users.

## Versions supported

* `edge` = `2.20.1`

## Architectures supported

* amd64
* arm64
* ppc64el
* s390x

## Usage

To get this image run:

```
$ docker pull squeakywheel/prometheus:edge
```

Prometheus command line can be called like this:

```
$ docker run squeakywheel/prometheus:edge -h
```

The command above will display the output of the `prometheus -h`.

Since containers are ephemeral you might be interested in persist data and not initialize a new TSDB database every time you launch a new container. To do that you can use docker volumes:

```
$ docker run --name prometheus \
             --volume /path/to/persisted/data:/prometheus \
             squeakywheel/prometheus:edge
```

Important note: the directory you will be using to persist the data needs to belong to `nogroup:nobody`. You can run `chown nogroup:nobody <path_to_persist_data>` before launching your container.

You can also pass your own configuration files to the container doing the following:

```
$ docker run --name prometheus \
             --volume /path/to/prometheus/config/file/prometheus.yml:/etc/prometheus/prometheus.yml
             --volume /path/to/prometheus/config/file/alerts.yml:/etc/prometheus/alerts.yml
             squeakywheel/prometheus:edge
```

In case you need to debug what it is happening with the container you can run `docker logs <name_of_the_container>`. But if you want to get access to an interactive shell run:

```
$ docker exec -it <name_of_the_container> /bin/bash
```

To see how to use the Prometheus OCI image with `docker-compose` and `microk8s` check the `examples/README.md` file.

## Bugs and Features request

If you find a bug in our image or want to request a specific feature file a bug here:

https://bugs.launchpad.net/ubuntu-server-oci/+filebug

In the title of the bug add `prometheus: <reason>`.

Make sure to include:

* The tag of the image you are using
* Reproduction steps for the deployment
* If it is a feature request, please provide as much detail as possible
