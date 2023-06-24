# PostgreSQL container images extender

This repository contains the dockerfiles and scripts as well as the github actions
to extend the postgresql container images from [ghcr.io/cloudnative-pg/postgresql](https://github.com/cloudnative-pg/postgres-containers/).

## Building locally

To build an image locally using docker, check out the repository and run the following command:

```shell
git clone
```

Then you can build the image using the following command:

```shell
docker build -t postgresql .
```

By default the image extends version 15.3 of the cloudnative-pg operand image.
You can change this by providing a different version as build argument:

```shell
docker build -t postgresql --build-arg POSTGRESQL_VERSION=15.2 .
```

By default this image extends the base image with the timescaledb and cron extensions.
To change this, you can provide a different list of extensions as build argument:

```shell
docker build -t postgresql --build-arg EXTENSIONS="timescaledb cron" .
```

The supported extensions are found in the official debian apt repositories
under the package names `postgresql-<pg_major>-<extension>`. Timescaledb is 
handled separately as it is not available in the official debian apt repositories.

For the Timescaledb version you can also provide a different version as build argument:

```shell
docker build -t postgresql --build-arg TIMESCALEDB_VERSION=2.11.0 .
```

# Building with GitHub Actions

This repository contains a GitHub Actions workflow that builds the image and pushes it to the
`ghcr.io/<repository_owner>/postgresql` repository. You can clone this repository
to generate your own custom images directly in GitHub. The workflow is triggered
manually and accepts the same build arguments as the local build.

The tags for the images are generated from the postgresql version and the extension list.
The timescaledb extension is versioned. For example, the image for postgresql 15.3 with
timescaledb 2.11.0 and cron extension would be tagged as `15.3-cron-timescaledb-2.11.0`.
