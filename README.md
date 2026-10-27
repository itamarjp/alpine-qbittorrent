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

## Optional strace diagnostics

`strace` is included for troubleshooting unexpected process exits, but is **not enabled by default**. Normal startup and the default command are unchanged.

Stop any existing qBittorrent instance that uses the same configuration before starting a diagnostic container. Use an **absolute path** for `./debug` if required by your Podman setup.

```sh
mkdir -p ./debug/strace
podman run -d --name qbittorrent-debug --restart=no \
  --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
  -p 8080:8080 -p 6881:6881/tcp -p 6881:6881/udp \
  -v ./config:/config -v ./downloads:/downloads -v ./debug:/debug \
  --entrypoint /bin/sh \
  ghcr.io/itamarjp/alpine-qbittorrent:latest \
  -c 'echo "START $(date -Iseconds)" >> /debug/lifecycle.log; strace -ff -ttt -T -s 256 -o /debug/strace/qbittorrent -e trace=process,signal,network,desc qbittorrent-nox --profile=/config --webui-port=8080 --confirm-legal-notice >> /debug/console.log 2>&1; rc=$?; echo "EXIT $(date -Iseconds) CODE=$rc" >> /debug/lifecycle.log; exit "$rc"'
```

After an unexpected exit, inspect `./debug/lifecycle.log`, `./debug/console.log`, and the trace files in `./debug/strace/`. For example:

```sh
grep -hE 'SIGTERM|SIGINT|SIGKILL|SIGSEGV|exit_group|exited with|killed by' ./debug/strace/qbittorrent.* | tail -80
```

The tracing privileges and relaxed seccomp policy are **for diagnostics only**. Traces can grow quickly, affect performance, and contain sensitive data. Do not publish raw traces without reviewing them. Remove the diagnostic container when finished.
