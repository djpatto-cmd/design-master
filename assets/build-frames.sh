#!/usr/bin/env bash
# build-frames.sh — slice a product clip -> matte (rembg) -> transparent WebP frame sequences.
#
# usage: assets/build-frames.sh <clip.mp4> <name> [desktop_fps] [mobile_fps]
#   writes assets/frames/<name>-desktop/ (1280w) and assets/frames/<name>-mobile/ (720w)
#   defaults: desktop 18fps, mobile 9fps (frame COUNT sets scrub smoothness)
#
# needs: ffmpeg, cwebp (brew install ffmpeg webp) and rembg on PATH
#   (pip install rembg, or run scripts/setup-matte.sh and put .venv-matte/bin on PATH)
set -euo pipefail
MP4="${1:?usage: build-frames.sh <clip.mp4> <name> [desktop_fps] [mobile_fps]}"
NAME="${2:?usage: build-frames.sh <clip.mp4> <name> [desktop_fps] [mobile_fps]}"
DFPS="${3:-18}"; MFPS="${4:-9}"
MP4="$(cd "$(dirname "$MP4")" && pwd)/$(basename "$MP4")"
cd "$(dirname "$0")"
FF="${FFMPEG:-ffmpeg}"
RAW=_raw; CUT=_cut
OUTD="frames/$NAME-desktop"; OUTM="frames/$NAME-mobile"
rm -rf "$RAW" "$CUT" "$OUTD" "$OUTM"
mkdir -p "$RAW/desktop" "$RAW/mobile" "$CUT/desktop" "$CUT/mobile" "$OUTD" "$OUTM"

echo "=== slice desktop (${DFPS}fps, 1280w) ==="
"$FF" -hide_banner -loglevel error -i "$MP4" -vf "fps=$DFPS,scale=1280:-1:flags=lanczos" "$RAW/desktop/frame_%04d.png"
echo "=== slice mobile (${MFPS}fps, 720w) ==="
"$FF" -hide_banner -loglevel error -i "$MP4" -vf "fps=$MFPS,scale=720:-1:flags=lanczos" "$RAW/mobile/frame_%04d.png"
echo "desktop raw: $(ls "$RAW/desktop" | wc -l)  mobile raw: $(ls "$RAW/mobile" | wc -l)"

echo "=== matte desktop (rembg isnet-general-use, keeps fine parts) ==="
rembg p -m isnet-general-use "$RAW/desktop" "$CUT/desktop"
echo "=== matte mobile ==="
rembg p -m isnet-general-use "$RAW/mobile" "$CUT/mobile"

echo "=== webp-alpha desktop ==="
for f in "$CUT/desktop"/*.png; do cwebp -quiet -q 86 -alpha_q 92 "$f" -o "$OUTD/$(basename "${f%.png}").webp"; done
echo "=== webp-alpha mobile ==="
for f in "$CUT/mobile"/*.png; do cwebp -quiet -q 86 -alpha_q 92 "$f" -o "$OUTM/$(basename "${f%.png}").webp"; done

echo "=== RESULT ==="
echo "desktop: $(ls "$OUTD" | wc -l) webp, $(du -sh "$OUTD" | cut -f1)  -> data-frames=\"../assets/$OUTD\" data-count=\"$(ls "$OUTD" | wc -l | tr -d ' ')\""
echo "mobile:  $(ls "$OUTM" | wc -l) webp, $(du -sh "$OUTM" | cut -f1)  -> data-frames-mobile=\"../assets/$OUTM\" data-count-mobile=\"$(ls "$OUTM" | wc -l | tr -d ' ')\""
rm -rf "$RAW" "$CUT"
echo "DONE"
