#!/bin/bash
set -euo pipefail

# 首次启动：下载游戏本体
if [ ! -f /app/.INSTALLED ]; then
    echo "[init] /app 未安装，开始通过 steamcmd 下载 Project Zomboid 服务端..."

    /opt/steamcmd/steamcmd.sh \
        +@sSteamCmdForcePlatformType linux \
        +force_install_dir /app \
        +login anonymous \
        +app_update 380870 validate \
        +quit

    # 下载成功后再标记，避免半截安装被当成已完成
    if [ ! -x /app/ProjectZomboid64 ]; then
        echo "[init] 错误：steamcmd 执行结束但 /app/ProjectZomboid64 不存在，下载可能失败" >&2
        exit 1
    fi

    touch /app/.INSTALLED
fi

# 应用补丁
if [ ! -f /app/.PATCHED ]; then
    echo "[init] 应用补丁 /app-patch -> /app"
    cp -rf /app-patch/. /app/
    touch /app/.PATCHED
fi

exec "$@"
