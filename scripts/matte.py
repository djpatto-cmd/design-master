#!/usr/bin/env python3
"""matte.py — background removal for the scroll-hero pipeline.

Set up once with scripts/setup-matte.sh, then:
  .venv-matte/bin/python3 scripts/matte.py <in> <out> [more pairs...]
Or a directory pair:
  .venv-matte/bin/python3 scripts/matte.py rawdir/ cutdir/

Uses rembg's isnet-general-use model (keeps fine parts the default model drops)
with alpha matting for clean edges on colored backgrounds.
"""
import sys, os
from rembg import remove, new_session

def matte(session, src, dst):
    with open(src, "rb") as f:
        out = remove(
            f.read(), session=session,
            alpha_matting=True,
            alpha_matting_foreground_threshold=240,
            alpha_matting_background_threshold=15,
            alpha_matting_erode_size=8,
        )
    os.makedirs(os.path.dirname(dst) or ".", exist_ok=True)
    with open(dst, "wb") as f:
        f.write(out)
    print("matted", dst)

def main():
    args = sys.argv[1:]
    if len(args) < 2 or len(args) % 2:
        sys.exit("usage: matte.py <in> <out> [<in> <out> ...]  (files or dir pairs)")
    session = new_session("isnet-general-use")
    for src, dst in zip(args[::2], args[1::2]):
        if os.path.isdir(src):
            for name in sorted(os.listdir(src)):
                if name.lower().endswith((".png", ".jpg", ".jpeg", ".webp")):
                    matte(session, os.path.join(src, name),
                          os.path.join(dst, os.path.splitext(name)[0] + ".png"))
        else:
            matte(session, src, dst)

if __name__ == "__main__":
    main()
