## Deploy

### Pre-requisites

You'll need:

- A fly.io account (with billing activated)
- The `fly` CLI [already installed](https://fly.io/docs/getting-started/installing-flyctl/) and authenticated on your machine

## Create a persistent config volume

```bash
VOLUME_NAME="syncthing_config" # Must match fly.toml.
SIZE_IN_GB=1

fly volumes create "${VOLUME_NAME}" \
  --size "${SIZE_IN_GB}"
```

## Deploy

Finally, it's time to deploy your app.

```bash
fly deploy
```
