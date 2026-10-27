FROM alpine:edge
RUN apk upgrade --no-cache && \
    apk add --no-cache qbittorrent-nox ca-certificates tzdata && \
    mkdir -p /config /downloads
ENV HOME=/config
EXPOSE 8080/tcp 6881/tcp 6881/udp
CMD ["qbittorrent-nox", "--profile=/config", "--webui-port=8080"]
