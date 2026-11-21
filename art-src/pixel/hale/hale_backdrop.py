"""Backdrop check: Hale and Bertha pasted at 3x (their in-scene scale) on env-r6's wood and moon pool.

Usage: python art-src/pixel/hale/hale_backdrop.py
Writes docs/art-direction/spike/hale-backdrop.png. Panels, left to right: the warm wood floor beside
the placeholder hero, then the cold moonlight pool by the window. Straight paste, no scene lighting.
"""
import sys
from pathlib import Path

from PIL import Image

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE.parent / "bertha"))
import bertha_still  # noqa: E402
import hale_still  # noqa: E402

SCALE = 3
# (left, top) of each 330 x 250 crop of env-r6, and where the feet stand inside it.
PANELS = [((1020, 560), 190), ((1560, 290), 210)]
CROP_W, CROP_H = 330, 250


def feet_paste(panel: Image.Image, sprite: Image.Image, cx: int, feet_y: int) -> None:
    box = sprite.getbbox()
    s = sprite.crop(box)
    s = s.resize((s.width * SCALE, s.height * SCALE), Image.NEAREST)
    panel.alpha_composite(s, (cx - s.width // 2, feet_y - s.height))


def main() -> None:
    env = Image.open(ROOT / "docs/art-direction/spike/env-r6.png").convert("RGBA")
    hale = hale_still.build()
    bertha = bertha_still.build()
    out = Image.new("RGBA", (CROP_W * len(PANELS), CROP_H), (0, 0, 0, 255))
    for i, ((x, y), feet) in enumerate(PANELS):
        panel = env.crop((x, y, x + CROP_W, y + CROP_H))
        feet_paste(panel, hale, 110, feet)
        feet_paste(panel, bertha, 230, feet)
        out.alpha_composite(panel, (i * CROP_W, 0))
    out.save(ROOT / "docs/art-direction/spike/hale-backdrop.png")


if __name__ == "__main__":
    main()
