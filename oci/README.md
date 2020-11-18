# Prometheus | Ubuntu

## About Prometheus

Prometheus is a systems and service monitoring system. It collects metrics from configured targets at given intervals, evaluates rule expressions, displays the results, and can trigger alerts if some condition is observed to be true. Read more on the [Prometheus website](https://prometheus.io/).

## Tags

* `2.20.1-focal`, `2.20.1`, `2.20-focal`, `2.20`, `2-focal`, `2`, `focal`, `beta` - **/!\ this is a beta release**

## Architectures supported

* `amd64`, `arm64`, `ppc64el`, `s390x`

## Usage

### Docker CLI

```sh
$ docker run -d --name prometheus -p 30090:9090 -e TZ=Europe/London squeakywheel/prometheus:edge
```

Access your Prometheus instance at [`localhost:30090`](http://localhost:30090/).

#### Parameters

| Parameter | Description |
|---|---|
| `-e TZ=UTC` | Timezone. |
| `-p 30090:9090` | Expose MySQL server on `localhost:30090`. |
| `-v /path/to/persisted/data:/prometheus` | Persist data instead of initializing a new database for each newly launched container. **Important note**: the directory you will be using to persist the data needs to belong to `nogroup:nobody`. You can run `chown nogroup:nobody <path_to_persist_data>` before launching your container. |
| `-v /path/to/prometheus.yml:/etc/prometheus/prometheus.yml` | Pass a custom config file (download this [example file](https://git.launchpad.net/~canonical-server/ubuntu-server-oci/+git/prometheus/plain/oci/examples/config/prometheus.yml)). |
| `-v /path/to/alerts.yml:/etc/prometheus/alerts.yml` | Pass a custom alerts config file (download this [example file](https://git.launchpad.net/~canonical-server/ubuntu-server-oci/+git/prometheus/plain/oci/examples/config/alerts.yml)). |


#### Testing/Debugging

In case you need to debug what it is happening with the container you can run `docker logs <name_of_the_container>`. To get access to an interactive shell run:

```
$ docker exec -it <name_of_the_container> /bin/bash
```

### Deploy with Kubernetes

You can use your favorite Kubernetes distribution; if you don't have one, consider [installing MicroK8s](https://microk8s.io/).

With microk8s running, enable the `dns` and `storage` add-ons:
```sh
$ microk8s enable dns storage
 ```

Create a configmap for the configuration files (check the upstream documentation [here](https://prometheus.io/docs/prometheus/2.20/getting_started/)):

```sh
$ microk8s kubectl create configmap prometheus-config --from-file=prometheus=config/prometheus.yml --from-file=prometheus-alerts=config/alerts.yml
```

Use the sample deployment yaml provided [here](https://git.launchpad.net/~canonical-server/ubuntu-server-oci/+git/prometheus/plain/examples/prometheus-deployment.yml).

<details>
  <summary>Apply the `prometheus-deployment.yml` (click to expand)</summary>

```yaml
# prometheus-deployment.yml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: prometheus-volume-claim
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: microk8s-hostpath
  resources:
    requests:
      storage: 500M
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      containers:
      - name: prometheus
        image: squeakywheel/prometheus:edge
        volumeMounts:
        - name: prometheus-config-volume
          mountPath: /etc/prometheus/prometheus.yml
          subPath: prometheus.yml
        - name: prometheus-config-volume
          mountPath: /etc/prometheus/alerts.yml
          subPath: alerts.yml
        - name: prometheus-data
          mountPath: /prometheus
        ports:
        - containerPort: 9090
          name: prometheus
          protocol: TCP
      volumes:
        - name: prometheus-config-volume
          configMap:
            name: prometheus-config
            items:
            - key: prometheus
              path: prometheus.yml
            - key: prometheus-alerts
              path: alerts.yml
        - name: prometheus-data
          persistentVolumeClaim:
            claimName: prometheus-volume-claim
---
apiVersion: v1
kind: Service
metadata:
  name: prometheus-service
spec:
  type: NodePort
  selector:
    app: prometheus
  ports:
  - protocol: TCP
    port: 9090
    targetPort: 9090
    nodePort: 30090
    name: prometheus
```

</details>

```sh
$ microk8s kubectl apply -f prometheus-deployment.yml
```

You will now be able to connect to the Prometheus on [`http://localhost:30090`](http://localhost:30090).

## Bugs and Features request

If you find a bug in our image or want to request a specific feature file a bug here:

https://bugs.launchpad.net/ubuntu-server-oci/+filebug

In the title of the bug add `prometheus: <reason>`.

Make sure to include:

* The digest of the image you are using, you can find it using this command replacing `<tag>` with the one you used to run the image:
```sh
$ docker images --no-trunc --quiet squeakywheel/prometheus:<tag>
```
* Reproduction steps for the deployment
* If it is a feature request, please provide as much detail as possible
