# Running the examples

## docker-compose

Install `docker-compose` from the Ubuntu archive:

```
$ sudo apt install -y docker-compose
```

Call `docker-compose` from the examples directory:

```
$ docker-compose up -d
```

Access `http://localhost:9090` and Prometheus will be running in the background. To stop it run:

```
$ docker-compose down
```

# Microk8s

With microk8s running, enable the `dns` and `storage` add-ons:

```
$ microk8s enable dns storage
```

Create a configmap for the configuration files:

```
$ microk8s kubectl create configmap prometheus-config \
		--from-file=prometheus=config/prometheus.yml \
		--from-file=prometheus-alerts=config/alerts.yml
```

Apply the `microk8s-deployments.yml`:

```
$ microk8s kubectl apply -f microk8s-deployments.yml
```

Access `http://localhost:30090` and Prometheus will be running.
