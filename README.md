# docker-withings-sync

Docker image for [jaroslawhartman/withings-sync](https://github.com/jaroslawhartman/withings-sync).

## First Setup

```console
docker run -it -e GARMIN_USERNAME=<YOUR_GARMIN_USER> -e GARMIN_PASSWORD=<YOUR_GARMIN_PASSWORD> -v $HOME:/root ghcr.io/maruina/docker-withings-sync:latest /bin/bash

# From inside the container
withings-sync -f 2019-01-25 -v
```

For more information visit [https://github.com/jaroslawhartman/withings-sync#obtaining-withings-authorization-code](https://github.com/jaroslawhartman/withings-sync#obtaining-withings-authorization-code).

## Usage

```console
docker run -e GARMIN_USERNAME=<YOUR_GARMIN_USER> -e GARMIN_PASSWORD=<YOUR_GARMIN_PASSWORD> -v $HOME:/root ghcr.io/maruina/docker-withings-sync:latest
```

For more information visit [https://github.com/jaroslawhartman/withings-sync#usage](https://github.com/jaroslawhartman/withings-sync#usage).

## Configuration

There is cron config to run `withings-sync` every day at 10.
To change this time you need to edit https://github.com/maruina/docker-withings-sync/blob/main/entrypoint.sh#L28.
