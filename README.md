# syncthing-fly.io

[![CircleCI](https://circleci.com/gh/mtlynch/syncthing-fly.io.svg?style=svg)](https://circleci.com/gh/mtlynch/syncthing-fly.io)
[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](LICENSE)

## Overview

Syncthing configuration for fly.io.

## Deploy

### Pre-requisites

You'll need:

- A fly.io account (with billing activated)
- The `fly` CLI [already installed](https://fly.io/docs/getting-started/installing-flyctl/) and authenticated on your machine

## Create your app

```bash
# You can change this to any region from https://fly.io/docs/reference/regions/
REGION="ewr"

RANDOM_SUFFIX="$(head /dev/urandom | tr -dc 'a-z0-9' | head -c 6 ; echo '')"
APP_NAME="syncthing-${RANDOM_SUFFIX}"

fly apps create --name "${APP_NAME}"
```

## Create a persistent volume

```bash
VOLUME_NAME="syncthing" # Must match fly.toml.
SIZE_IN_GB=3

fly volumes create "${VOLUME_NAME}" \
  --region "${REGION}" \
  --size "${SIZE_IN_GB}" \
  --yes
```

## Deploy

Finally, it's time to deploy your app.

```bash
fly deploy
```

## Access web UI


Open a fly proxy to 8386:

```bash
fly proxy 8388:8384
```

Open web UI:

<http://localhost:8388>
