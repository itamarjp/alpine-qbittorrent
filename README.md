# Alpine qBittorrent (RISC-V)

Container image for qBittorrent-nox based on Alpine Linux, targeting `linux/riscv64`.

## Build

GitHub Actions uses Docker Buildx with QEMU to build the image. Pull requests validate builds; pushes to `main` publish to GHCR.

## Usage

```sh
podman run -d --name qbittorrent --restart=always \
  -p 8080:8080 -p 6881:6881/tcp -p 6881:6881/udp \
  -v ./config:/config -v ./downloads:/downloads \
  ghcr.io/itamarjp/alpine-qbittorrent:latest
```

Ensure appropriate volume permissions and configure the Web UI credentials before exposing the service.
