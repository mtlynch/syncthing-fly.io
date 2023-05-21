FROM golang:1.19 AS builder

WORKDIR /tmp

ARG SYNCTHING_VERSION="1.23.4"
RUN curl --location \
  https://github.com/syncthing/syncthing/archive/refs/tags/v${SYNCTHING_VERSION}.tar.gz | \
  tar -xzv && \
  mv syncthing-${SYNCTHING_VERSION} /src

WORKDIR /src
RUN CGO_ENABLED=0 BUILD_USER=docker \
      go run build.go -no-upgrade build syncthing

FROM alpine:3.15 AS deploy

RUN apk add --no-cache ca-certificates libcap su-exec tzdata

COPY --from=builder /src/syncthing /bin/syncthing
COPY --from=builder /src/script/docker-entrypoint.sh /bin/entrypoint.sh

RUN chmod 755 /bin/entrypoint.sh

EXPOSE 8384 22000/tcp 22000/udp 21027/udp

ENV HOME=/var/syncthing
ENTRYPOINT ["/bin/entrypoint.sh", "/bin/syncthing", "-home", "/var/syncthing/config"]
