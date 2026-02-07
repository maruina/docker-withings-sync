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

## Release Flow

The Docker image and Helm chart are released independently.

### Docker Image

1. Merge dependency updates (Renovate PRs) or bump `WITHINGS_SYNC_COMMIT` in the `Dockerfile`.
2. [release-drafter](https://github.com/release-drafter/release-drafter) automatically maintains a draft GitHub release on every push to `main`.
3. Review and publish the draft release. This creates a `v*` tag, which triggers the `build.yaml` workflow to build and push `ghcr.io/maruina/docker-withings-sync:<version>`.

### Helm Chart

The chart defaults to the Docker image tag matching `appVersion` in `Chart.yaml` (see `image.tag` in `values.yaml`). After publishing a new Docker image release, open a separate PR to:

1. Update `appVersion` in [`charts/docker-withings-sync/Chart.yaml`](charts/docker-withings-sync/Chart.yaml) to the new image version.
2. Bump `version` in `Chart.yaml` (the chart version itself).

When this PR merges, the `chart-release.yaml` workflow packages and publishes the chart via [chart-releaser](https://github.com/helm/chart-releaser-action).
