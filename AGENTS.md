# Release flow

This repository releases two artifacts: the Docker image and the Helm chart. Do not recreate release-drafter: it resolves the next version from the full GitHub releases stream, which the chart workflow also publishes into, so the draft version drifts onto the chart version line (see PR #90). Do not publish a chart that references an image tag that does not exist yet.

## 1. Release the image

Create the release manually. This creates the `v*` tag that triggers `.github/workflows/build.yaml` to build, smoke test, and push `ghcr.io/maruina/docker-withings-sync:<version>`:

```console
gh release create vX.Y.Z --target main --generate-notes --notes-start-tag v<PREVIOUS>
```

`<PREVIOUS>` is the last published image release, so the notes cover everything since then and the chart releases do not shorten them. Confirm the image is on ghcr.io before you move on:

```console
docker manifest inspect ghcr.io/maruina/docker-withings-sync:X.Y.Z
```

## 2. Release the chart

After the image exists, open a separate PR that bumps `charts/docker-withings-sync/Chart.yaml`:

1. `version`: the next chart version.
2. `appVersion`: `"X.Y.Z"`, set to the image just published.

Merging triggers `.github/workflows/chart-release.yaml`, which packages and publishes `docker-withings-sync-<version>` through chart-releaser and updates the gh-pages index. The chart-test workflow must pass on the PR: the install job pulls the `appVersion` image, so a chart referencing an unpublished image fails there.

## Verify

```console
gh release list
gh run list --limit 5
```

See `README.md` for the full flow.
