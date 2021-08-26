# Prometheus | Ubuntu

Current Prometheus Docker Image from Ubuntu. Receives security updates and rolls to newer Prometheus or Ubuntu LTS. This repository is exempted from per-user rate limits. For [LTS Docker Image](https://ubuntu.com/security/docker-images) versions of this image, see `lts/prometheus`. 


## About Prometheus

Prometheus is a systems and service monitoring system. It collects metrics from configured targets at given intervals, evaluates rule expressions, displays the results, and can trigger alerts if some condition is observed to be true. Read more on the [Prometheus website](https://prometheus.io/).


## Tags and Architectures
![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17)
Up to 5 years free security maintenance `from lts/prometheus`.

![ESM](https://assets.ubuntu.com/v1/572f3fbd-ESM%402x.png?h=17)
Up to 10 years customer security maintenance `from store/canonical/prometheus`.

_Tags in italics are not available in ubuntu/prometheus but are shown here for completeness._

| Channel Tag | | | Currently | Architectures |
|---|---|---|---|---|
| **`2.28-21.10_beta`** &nbsp;&nbsp; | | | Prometheus 2.28.1 on Ubuntu 21.10 | `amd64`, `arm64`, `ppc64el`, `s390x` |
| _`track_risk`_ |

Channel tag shows the most stable channel for that track ordered `stable`, `candidate`, `beta`, `edge`. More risky channels are always implicitly available. So if `beta` is listed, you can also pull `edge`. If `candidate` is listed, you can pull `beta` and `edge`. When `stable` is listed, all four are available. Images are guaranteed to progress through the sequence `edge`, `beta`, `candidate` before `stable`.


## Usage

Launch this image locally:

```sh
docker run -d --name prometheus-container -e TZ=UTC -p 30090:9090 ubuntu/prometheus:2.28-21.10_beta
```
Access your Prometheus server at `localhost:30090`.

#### Parameters

| Parameter | Description |
|---|---|
| `-e TZ=UTC` | Timezone. |
| `-p 30090:9090` | Expose Prometheus server on `localhost:30090`. |
| `-v /path/to/prometheus.yml:/etc/prometheus/prometheus.yml` | Local [configuration file](https://prometheus.io/docs/prometheus/2.25/configuration/configuration/) `prometheus.yml` (try [this example](https://git.launchpad.net/~canonical-server/ubuntu-docker-images/+git/prometheus/plain/examples/config/prometheus.yml?h=2.25-21.04)). |
| `-v /path/to/alerts.yml:/etc/prometheus/alerts.yml` | Local [alert configuration file](https://prometheus.io/docs/prometheus/2.25/configuration/configuration/) `alerts.yml` (try [this example](https://git.launchpad.net/~canonical-server/ubuntu-docker-images/+git/prometheus/plain/examples/config/alerts.yml?h=2.25-21.04)). |


#### Testing/Debugging

To debug the container:

```sh
docker logs -f prometheus-container
```

To get an interactive shell:

```sh
docker exec -it prometheus-container /bin/bash
```


## Deploy with Kubernetes

Works with any Kubernetes; if you don't have one, we recommend you [install MicroK8s](https://microk8s.io/) and `microk8s.enable dns storage` then `snap alias microk8s.kubectl kubectl`.

Download
[prometheus.yml](https://git.launchpad.net/~canonical-server/ubuntu-docker-images/+git/prometheus/plain/examples/config/prometheus.yml?h=2.25-21.04), [alerts.yml](https://git.launchpad.net/~canonical-server/ubuntu-docker-images/+git/prometheus/plain/examples/config/alerts.yml?h=2.25-21.04) and
[prometheus-deployment.yml](https://git.launchpad.net/~canonical-server/ubuntu-docker-images/+git/prometheus/plain/examples/prometheus-deployment.yml?h=2.25-21.04) and set `containers.prometheus.image` in `prometheus-deployment.yml` to your chosen channel tag (e.g. `ubuntu/prometheus:2.28-21.10_beta`), then:

```sh
kubectl create configmap prometheus-config --from-file=prometheus=prometheus.yml --from-file=prometheus-alerts=alerts.yml
kubectl apply -f prometheus-deployment.yml
```

You will now be able to connect to the Prometheus on `http://localhost:30090`.

## Bugs and feature requests

If you find a bug in our image or want to request a specific feature, please file a bug here:

[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)

Please title the bug "`prometheus: <issue summary>`". Make sure to include the digest of the image you are using, from:

```sh
docker images --no-trunc --quiet ubuntu/prometheus:<tag>
```


