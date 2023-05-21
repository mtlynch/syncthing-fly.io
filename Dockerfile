FROM golang:1.19 AS builder

WORKDIR /src

ARG SYNCTHING_VERSION="1.23.4"
RUN curl --location \
  https://github.com/syncthing/syncthing/archive/refs/tags/v${SYNCTHING_VERSION}.tar.gz | \
  tar -xzv
RUN cd syncthing-${SYNCTHING_VERSION} && \
  CGO_ENABLED=0 \
  BUILD_USER=docker \
    go run build.go -no-upgrade build syncthing

FROM alpine:3.15

COPY --from=builder /src/syncthing /bin/syncthing
COPY --from=builder /src/script/docker-entrypoint.sh /bin/entrypoint.sh

RUN chmod 755 /bin/entrypoint.sh

EXPOSE 8384 22000/tcp 22000/udp 21027/udp

ENTRYPOINT ["/bin/entrypoint.sh", "/bin/syncthing", "-home", "/var/syncthing/config"]
