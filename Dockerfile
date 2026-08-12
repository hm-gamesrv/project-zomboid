# =================
# 资源下载
# =================
FROM cm2network/steamcmd AS downloader

RUN /home/steam/steamcmd/steamcmd.sh +quit
RUN /home/steam/steamcmd/steamcmd.sh \
    +@sSteamCmdForcePlatformType linux \
    +login anonymous \
    +app_update 380870 validate \
    +quit

# ===================
# 基座镜像
# ===================
FROM eclipse-temurin:25-jre

EXPOSE 16261/udp 16262/udp

VOLUME ["/data"]

ENV TZ=Asia/Shanghai

RUN mkdir -p /data && chown 1000:1000 /data

USER 1000:1000

COPY --from=downloader --chown=1000:1000 ["/home/steam/Steam/steamapps/common/Project Zomboid Dedicated Server", "/app"]
COPY --chown=1000:1000 ["./patch/", "/app"]

WORKDIR /app

CMD ["bash", "/app/start-server.sh"]
