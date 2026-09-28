#!/usr/bin/env bash
# One-time setup for local background removal (free, offline).
# Creates a project-local Python venv with rembg. Needs Python 3.10+.
# After: .venv-matte/bin/python3 scripts/matte.py <in.png> <out.png>
set -euo pipefail
cd "$(dirname "$0")/.."
PY=""
for c in python3.12 python3.11 python3.10 python3; do
  if command -v "$c" >/dev/null 2>&1; then
    v=$("$c" -c 'import sys; print(sys.version_info[0]*100+sys.version_info[1])')
    [ "$v" -ge 310 ] && PY="$c" && break
  fi
done
[ -n "$PY" ] || { echo "ERROR: need Python 3.10+ (brew install python@3.12)"; exit 1; }
"$PY" -m venv .venv-matte
./.venv-matte/bin/pip install --quiet --upgrade pip
./.venv-matte/bin/pip install --quiet "rembg==2.0.57" onnxruntime pillow
echo "done — matte images with: .venv-matte/bin/python3 scripts/matte.py <in> <out>"
