FROM docker.io/debian:bullseye-slim as build

ARG VERSION=2.0.0.5344
ARG APP=radarr
ARG BRANCH=master

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
    && wget -qO- "https://${APP}.servarr.com/v1/update/${BRANCH}/updatefile?version=${VERSION}&os=linux&runtime=netcore&arch=${ARCH}" \
    | tar xvz --strip-components=1 --directory=app \
    && mv app/*arr app/Executable \
    && mv app /rootfs/ \
    && cp /usr/lib/*-linux-gnu/libsqlite3.so.0 /rootfs/usr/lib/libsqlite3.so.0

WORKDIR /rootfs

COPY --chmod=755 --chown=0:0 --from=busybox:1.36.0-musl /bin/wget /bin/uname /rootfs/usr/bin/

FROM mcr.microsoft.com/dotnet/runtime-deps:7.0.5-cbl-mariner2.0-distroless

ARG PORT=7878
USER 1000

COPY --from=build --chown=1000:1000 /rootfs /

EXPOSE ${PORT}

# NOTE: enabling running containers with read only filesystem
#       https://github.com/dotnet/docs/issues/10217
ENV XDG_CONFIG_HOME=/config \
    DOTNET_SYSTEM_GLOBALIZATION_PREDEFINED_CULTURES_ONLY=false \
    COMPlus_EnableDiagnostics=0 \
    PORT=${PORT}

HEALTHCHECK  --start-period=15s --interval=30s --timeout=5s --retries=5 \
    CMD "/usr/bin/wget --quiet --tries=1 --spider http://localhost:${PORT}"

ENTRYPOINT [ "/app/Executable" ]
CMD [ "-nobrowser" ]