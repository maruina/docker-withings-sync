# docker-withings-sync

Docker image for [jaroslawhartman/withings-sync](https://github.com/jaroslawhartman/withings-sync).

## First Setup

```console
docker run -it -e GARMIN_USERNAME=<YOUR_GARMIN_USER> -e GARMIN_PASSWORD=<YOUR_GARMIN_PASSWORD> -v $HOME:/data ghcr.io/maruina/docker-withings-sync:latest /bin/bash

# From inside the container
withings-sync -f 2019-01-25 -v
```

For more information visit [https://github.com/jaroslawhartman/withings-sync#obtaining-withings-authorization-code](https://github.com/jaroslawhartman/withings-sync#obtaining-withings-authorization-code).

## Usage

```console
docker run -e GARMIN_USERNAME=<YOUR_GARMIN_USER> -e GARMIN_PASSWORD=<YOUR_GARMIN_PASSWORD> -v $HOME:/data ghcr.io/maruina/docker-withings-sync:latest
```

For more information visit [https://github.com/jaroslawhartman/withings-sync#usage](https://github.com/jaroslawhartman/withings-sync#usage).

## Configuration

| Environment Variable | Default | Description |
|---|---|---|
| `GARMIN_USERNAME` | (required) | Garmin account username |
| `GARMIN_PASSWORD` | (required) | Garmin account password |
| `SYNC_INTERVAL` | `21600` | Sync interval in seconds (default: 6 hours) |
| `DATA_DIR` | `/data` | Directory for persistent data (OAuth tokens) |

## Kubernetes (Helm)

A Helm chart is available in [`charts/docker-withings-sync`](charts/docker-withings-sync).

### Install

```console
helm install withings-sync charts/docker-withings-sync \
  --set garmin.username=<YOUR_GARMIN_USER> \
  --set garmin.password=<YOUR_GARMIN_PASSWORD>
```

Or use an existing secret:

```console
kubectl create secret generic withings-garmin \
  --from-literal=GARMIN_USERNAME=<YOUR_GARMIN_USER> \
  --from-literal=GARMIN_PASSWORD=<YOUR_GARMIN_PASSWORD>

helm install withings-sync charts/docker-withings-sync \
  --set garmin.existingSecret=withings-garmin
```

### First Setup on Kubernetes

Before the first automated run, obtain a Withings authorization code interactively. The Helm install notes will print the exact `kubectl run` command to use.

### Persistence

The chart creates a PersistentVolumeClaim by default to store the Withings OAuth tokens. To use an existing PVC:

```console
helm install withings-sync charts/docker-withings-sync \
  --set persistence.existingClaim=my-existing-pvc \
  --set garmin.existingSecret=withings-garmin
```

See [`charts/docker-withings-sync/values.yaml`](charts/docker-withings-sync/values.yaml) for all available options.
