# =================
# 资源下载
# =================
FROM alpine:3 AS downloader

RUN apk add --no-cache wget tar ca-certificates
RUN wget -qO /tmp/steamcmd.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && mkdir -p /out/steamcmd \
    && tar -xzf /tmp/steamcmd.tar.gz -C /out/steamcmd \
    && rm -f /tmp/steamcmd.tar.gz

# ===================
# 主镜像
# ===================
FROM debian:trixie-slim AS base

ENV TZ=Asia/Shanghai

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        libc6:i386 \
        libstdc++6:i386 \
        libgcc-s1:i386 \
        libcurl4:i386 \
        zlib1g:i386 \
        libncurses6:i386 \
        libtinfo6:i386 \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1000 gamesrv \
    && useradd -u 1000 -g gamesrv -m -s /bin/bash gamesrv
RUN mkdir -p /app /app-patch && chown -R 1000:1000 /app /app-patch

COPY --from=downloader --chown=1000:1000 ["/out/steamcmd", "/opt/steamcmd"]
COPY --chown=1000:1000 ["./init.sh", "/usr/local/bin/init.sh"]
COPY --chown=1000:1000 ["./patch/", "/app-patch"]

EXPOSE 16261/udp 16262/udp

VOLUME ["/app", "/data"]

WORKDIR /app
USER 1000:1000
ENTRYPOINT ["bash", "/usr/local/bin/init.sh"]
CMD ["bash", "/app/start-server.sh"]
