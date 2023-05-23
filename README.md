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

## Create a persistent config volume

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

Open fly console:

```bash
fly ssh console
```

Use socat to proxy IPv4 to IPv6:

```bash
apk add socat && \
  socat TCP6-LISTEN:8386,fork,su=nobody TCP4:localhost:8384
```

Open a fly proxy to 8386:

```bash
fly proxy 8384:8386
```

Open web UI:

<http://localhost:8384>
