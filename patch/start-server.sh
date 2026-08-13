#!/bin/bash
set -euo pipefail

cd /app

export PATH="/app/jre64/bin:$PATH"
export LD_LIBRARY_PATH="/app/linux64:/app:/app/jre64/lib/amd64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export LD_PRELOAD="libjsig.so${LD_PRELOAD:+:$LD_PRELOAD}"

exec ./ProjectZomboid64 -nosteam -cachedir=/data -servername pz-server "$@"
