# [🐋 Radarr-distroless](https://github.com/guillaumedsde/radarr-distroless)

[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/guillaumedsde/radarr-distroless)](https://hub.docker.com/r/guillaumedsde/radarr-distroless/tags)
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/guillaumedsde/radarr-distroless)](https://hub.docker.com/r/guillaumedsde/radarr-distroless)
[![Docker Pulls](https://img.shields.io/docker/pulls/guillaumedsde/radarr-distroless)](https://hub.docker.com/r/guillaumedsde/radarr-distroless)
[![GitHub stars](https://img.shields.io/github/stars/guillaumedsde/radarr-distroless?label=Github%20stars)](https://github.com/guillaumedsde/radarr-distroless)
[![GitHub watchers](https://img.shields.io/github/watchers/guillaumedsde/radarr-distroless?label=Github%20Watchers)](https://github.com/guillaumedsde/radarr-distroless)
[![Docker Stars](https://img.shields.io/docker/stars/guillaumedsde/radarr-distroless)](https://hub.docker.com/r/guillaumedsde/radarr-distroless)
[![GitHub](https://img.shields.io/github/license/guillaumedsde/radarr-distroless)](https://github.com/guillaumedsde/radarr-distroless/blob/master/LICENSE.md)

This repository contains the code to build a small and secure distroless **docker** image for **[Radarr](https://github.com/Radarr/Radarr)** running as an unprivileged user.
The final images are built and hosted on the [dockerhub](https://hub.docker.com/r/guillaumedsde/radarr-distroless).

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

- 💽 [Radarr](https://github.com/Radarr/Radarr) _the_ awesome software
- 🐋 The [Docker](https://github.com/docker) project (of course)
