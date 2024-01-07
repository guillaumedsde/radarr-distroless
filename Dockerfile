ARG VERSION=4.3.2.6857

FROM docker.io/debian:bullseye-slim as build

ARG VERSION

WORKDIR /workdir


SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# hadolint ignore=DL3008
RUN --mount=type=cache,target=/var/cache/apt \
    case "$(uname -m)" in \
    x86_64)  ARCH="x64" ;; \
    aarch64*)  ARCH="arm64" ;; \
    armv8?)  ARCH="arm64" ;; \
    arm64)  ARCH="arm64" ;; \
    armv[67]?)  ARCH="arm" ;; \
    *) exit 1 ;; \
    esac \
    && apt-get update \
    && apt-get install --yes --no-install-recommends ca-certificates wget libsqlite3-0 \
    && mkdir -p app /rootfs/usr/lib/ \
    && wget -qO- "https://radarr.servarr.com/v1/update/master/updatefile?version=${VERSION}&os=linux&runtime=netcore&arch=${ARCH}" | \
    tar xvz --strip-components=1 --directory=app \
    && mv app /rootfs/ \
    && cp /usr/lib/*-linux-gnu/libsqlite3.so.0 /rootfs/usr/lib/libsqlite3.so.0

WORKDIR /rootfs

COPY --chmod=755 --chown=0:0 --from=busybox:1.36.1-musl /bin/wget /rootfs/wget

FROM mcr.microsoft.com/dotnet/runtime-deps:7.0.14-cbl-mariner2.0-distroless

USER 1000

COPY --from=build --chown=1000:1000 /rootfs /

EXPOSE 7878

# NOTE: enabling running containers with read only filesystem
#       https://github.com/dotnet/docs/issues/10217
ENV XDG_CONFIG_HOME=/config \
    DOTNET_SYSTEM_GLOBALIZATION_PREDEFINED_CULTURES_ONLY=false \
    COMPlus_EnableDiagnostics=0

HEALTHCHECK  --start-period=15s --interval=30s --timeout=5s --retries=5 \
    CMD [ "/wget", "--quiet", "--tries=1", "--spider", "http://localhost:7878/"]

ENTRYPOINT [ "/app/Radarr" ]
CMD [ "-nobrowser" ]