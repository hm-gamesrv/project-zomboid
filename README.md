# Project Zomboid Server

## 1. 简述

僵尸毁灭工程原版服务器

**可用版本：**

| 游戏模式   | 镜像 tag |
| ---------- | -------- |
| 最新正式版 | `latest` |

## 2. 资源占用信息

### 2.1. 端口

| 端口号 | 协议 | 说明                                 |
| ------ | ---- | ------------------------------------ |
| 16261  | UDP  | 游戏联机端口                         |
| 16262  | UDP  | Direct Connection Port，直连相关端口 |

### 2.2. 持久卷

| 容器路径 | 说明         |
| -------- | ------------ |
| `/app`   | 游戏本体目录 |
| `/data`  | 存档数据目录 |

## 3. 构建与运行

### 3.1. 构建并运行（Docker）

```bash
docker build -t project-zomboid:temp . && \
    docker run --rm -it \
        -p 16261:16261/udp \
        -p 16262:16262/udp \
        -v ./app:/app \
        -v ./data:/data \
        project-zomboid:temp
```

### 3.2. 运行服务器（Podman）

```bash
IMAGE=ghcr.io/hm-gamesrv/project-zomboid:latest

if ! podman pull "$IMAGE"; then
    exit 1
fi

podman run --rm -it \
    --name project-zomboid \
    --userns keep-id \
    --network pasta \
    -p 16261:16261/udp \
    -p 16262:16262/udp \
    -v ./app:/app \
    -v ./data:/data \
    "$IMAGE"
```

## 4. 首次启动与维护

- 首次启动会下载数 GB 的游戏本体，完成后写入 `/app/.INSTALLED` 标记，后续启动直接跳过下载
- 补丁（插件、配置）在首次启动时应用一次，完成后写入 `/app/.PATCHED` 标记，后续启动跳过应用补丁
- 强制更新游戏：删除 `/app/.INSTALLED` 后重启容器，会重新执行 `validate` 校验并更新。建议同时删除 `/app/.PATCHED` 文件以确保补丁再次应用
