# [🐋 arr-distroless](https://github.com/guillaumedsde/radarr-distroless)

This repository contains the code to build a small and secure distroless **docker** image for most ARR applications running as an unprivileged user.
The final images are built and hosted on the [dockerhub]:

- [`radarr-distroless`](https://hub.docker.com/r/guillaumedsde/radarr-distroless).
- [`lidarr-distroless`](https://hub.docker.com/r/guillaumedsde/lidarr-distroless).
- [`readarr-distroless`](https://hub.docker.com/r/guillaumedsde/readarr-distroless).
- [`prowlarr-distroless`](https://hub.docker.com/r/guillaumedsde/prowlarr-distroless).

## ✔️ Features summary

- 🥑 distroless minimal image
- 🤏 As few Docker layers as possible
- 🛡️ only basic runtime dependencies
- 🛡️ Runs as unprivileged user with minimal permissions

## 🏁 How to Run

### `docker run`

```bash
$ docker run  --volume "/your/config/path:/config" \
              --publish "7878:7878" \
              --user "1000:1000" \
              --read-only=true \
              guillaumedsde/radarr-distroless:latest
```

### `docker-compose.yml`

```yaml
version: '3.9'
services:
  radarr-distroless:
    volumes:
      - '/your/config/path:/config'
    ports:
      - '7878:7878'
    user: '1000:1000'
    read_only: true
    image: 'guillaumedsde/radarr-distroless:latest'
```

## 🖥️ Supported platforms

Currently this container supports only one (but widely used) platform:

- linux/amd64
- linux/arm64

## 🙏 Credits

A couple of projects really helped me out while developing this container:

- 💽 [Arr software](https://wiki.servarr.com/) _the_ awesome suite of software
- 🐋 The [Docker](https://github.com/docker) project (of course)
