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
| `/data`  | 存档数据目录 |

## 3. 构建与运行

### 3.1. 构建并运行（Docker）

```bash
docker build -t project-zomboid:temp . && \
    docker run --rm -it \
        -p 16261:16261/udp \
        -p 16262:16262/udp \
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
    -v ./data:/data \
    "$IMAGE"
```
