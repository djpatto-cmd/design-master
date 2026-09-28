#!/usr/bin/env bash
# matte-kie.sh — background removal through kie.ai (recraft/remove-background).
# Universal: needs only the .env key, no local installs. ~1 credit per image.
# The input must be an image URL (kie generation results are URLs already).
#
# usage: scripts/matte-kie.sh <image-url> <dest-file>
set -euo pipefail
url="${1:?usage: matte-kie.sh <image-url> <dest-file>}"
dest="${2:?usage: matte-kie.sh <image-url> <dest-file>}"
dir="$(cd "$(dirname "$0")" && pwd)"
tid="$("$dir/kie.sh" submit "{\"model\":\"recraft/remove-background\",\"input\":{\"image\":\"$url\"}}")"
echo "taskId $tid"
line="$("$dir/kie.sh" wait "$tid" | tail -1)"
state="$(echo "$line" | awk '{print $3}')"
out="$(echo "$line" | awk '{print $4}')"
[ "$state" = "success" ] || { echo "matte failed: $line" >&2; exit 1; }
"$dir/kie.sh" download "$out" "$dest"
