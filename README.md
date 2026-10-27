# Alpine qBittorrent — RISC-V

Image using Alpine edge and qBittorrent-nox for linux/riscv64.

GitHub Actions configures QEMU with docker/setup-qemu-action and builds with Docker Buildx. Pull requests test the build without publishing. Main pushes, version tags and manual runs publish ghcr.io/itamarjp/alpine-qbittorrent:latest.

Build success depends on Alpine edge providing qbittorrent-nox for riscv64. Check the GitHub Actions run before pulling.

## Orange Pi RV2 / Podman

Back up the existing configuration and stop any existing qBittorrent first.

```sh
podman pull ghcr.io/itamarjp/alpine-qbittorrent:latest
podman run -d --name qbittorrent --restart=always --network=host \
  -e TZ=America/Sao_Paulo \
  -v /4t/qBitTorrent/config:/config \
  -v /4t/qBitTorrent/downloads:/downloads \
  ghcr.io/itamarjp/alpine-qbittorrent:latest
podman logs -f qbittorrent
```

The old qBittorrent profile includes configuration under config/qBittorrent/config and torrent state under config/qBittorrent/data/BT_backup. Preserve all of it. Check the saved torrent paths and update them to /downloads when needed.

Web UI should normally be at http://ORANGEPI-IP:8080 (subject to existing settings). Do not expose it publicly without access controls. Verify write permissions on the mounted folders.

For reliable boot-time startup, configure a systemd Quadlet unit; the Podman restart policy alone may not cover host reboot.
