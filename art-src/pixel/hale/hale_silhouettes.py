"""Hale: five solid-black silhouette variants (crafting-game-assets section 2), next to Bertha for scale.

Usage: python art-src/pixel/hale/hale_silhouettes.py
Writes docs/art-direction/spike/hale-silhouettes.png (8x) and art-src/pixel/hale/silhouettes_1x.png.
Each variant differs in hood shape, how the two hilts break the line above the shoulders, and how
the mantle hangs. Drawn with polygons at 1x so they stay true to the 32 px grid.
"""
import sys
from pathlib import Path

from PIL import Image, ImageDraw

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
sys.path.insert(0, str(HERE.parent / "bertha"))
import bertha_still  # noqa: E402

W, H = 32, 34
INK = (20, 14, 22, 255)


def hilt(d, top, guard, width=2):
    """A sword hilt from pommel `top` to the guard centre `guard`, with a 5 px crossguard."""
    d.line([top, guard], fill=INK, width=width)
    gx, gy = guard
    d.rectangle([gx - 2, gy, gx + 2, gy + 1], fill=INK)
    tx, ty = top
    d.rectangle([tx - 1, ty - 1, tx, ty], fill=INK)


def legs(d, top=27, bottom=32):
    d.rectangle([11, top, 14, bottom], fill=INK)
    d.rectangle([17, top, 20, bottom], fill=INK)


def body(d, hem=28, flare=2, ragged=True):
    """Shoulders wider than the hood (x5..26), mantle to `hem` flaring by `flare` px, a ragged hem."""
    d.polygon([(5, 14), (26, 14), (26 + flare, hem), (5 - flare, hem)], fill=INK)
    if ragged:
        for x in (8, 15, 22):
            d.rectangle([x, hem - 1, x + 1, hem], fill=(0, 0, 0, 0))


def peaked(d):
    d.polygon([(15, 0), (16, 0), (23, 7), (23, 14), (8, 14), (8, 7)], fill=INK)


def var_a(d):
    """A: peaked hood, hilts in a V over both shoulders, knee mantle with a ragged hem."""
    hilt(d, (3, 5), (6, 12)); hilt(d, (28, 5), (25, 12))
    peaked(d)
    body(d)
    legs(d, 28)


def var_b(d):
    """B: rounded cowl, both hilts together over the right shoulder, ankle-length A-line mantle."""
    hilt(d, (3, 4), (6, 12)); hilt(d, (6, 3), (9, 11))
    d.ellipse([8, 1, 23, 16], fill=INK)
    body(d, 31, 3, False)
    d.rectangle([10, 31, 21, 32], fill=INK)


def var_c(d):
    """C: peak drooping back to one side, near-vertical hilts, ragged hip cape, long lean legs."""
    hilt(d, (5, 3), (6, 12)); hilt(d, (26, 3), (25, 12))
    d.polygon([(10, 2), (20, 2), (23, 8), (23, 14), (8, 14), (8, 6)], fill=INK)
    d.polygon([(19, 1), (23, 0), (26, 4), (23, 7)], fill=INK)
    d.polygon([(5, 14), (26, 14), (26, 23), (24, 25), (22, 23), (19, 25), (15, 23), (12, 25), (9, 23), (7, 25), (5, 23)], fill=INK)
    d.rectangle([9, 14, 22, 26], fill=INK)
    legs(d, 26, 32)


def var_d(d):
    """D: peaked hood, V hilts, mantle thrown back on his left: long cloak one side, bare arm the other."""
    hilt(d, (3, 5), (6, 12)); hilt(d, (28, 5), (25, 12))
    peaked(d)
    d.polygon([(5, 14), (16, 14), (16, 28), (2, 29)], fill=INK)
    d.rectangle([10, 14, 22, 28], fill=INK)
    d.polygon([(21, 14), (26, 14), (29, 30), (23, 29)], fill=INK)
    d.rectangle([22, 15, 25, 24], fill=INK)
    legs(d, 28)


def var_e(d):
    """E: rounded hood, hilts crossed low (guards beside the neck, pommels at ear height), shoulder cape, long coat."""
    hilt(d, (5, 6), (7, 12)); hilt(d, (26, 6), (24, 12))
    d.ellipse([8, 1, 23, 16], fill=INK)
    d.polygon([(4, 14), (27, 14), (28, 20), (3, 20)], fill=INK)
    d.polygon([(8, 20), (23, 20), (25, 28), (6, 28)], fill=INK)
    d.rectangle([6, 19, 8, 24], fill=INK); d.rectangle([23, 19, 25, 24], fill=INK)
    legs(d, 28)


VARIANTS = [("A", var_a), ("B", var_b), ("C", var_c), ("D", var_d), ("E", var_e)]


def bertha_black() -> Image.Image:
    im = bertha_still.build()
    px = im.load()
    for y in range(im.height):
        for x in range(im.width):
            if px[x, y][3]:
                px[x, y] = INK
    return im


def main() -> None:
    tiles = []
    for _, fn in VARIANTS:
        im = Image.new("RGBA", (W, H), (0, 0, 0, 0))
        fn(ImageDraw.Draw(im))
        tiles.append(im)
    b = bertha_black()
    tile_b = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    tile_b.alpha_composite(b, ((W - b.width) // 2, H - b.height - 1))
    tiles.append(tile_b)
    row = Image.new("RGBA", (len(tiles) * (W + 4), H), (0, 0, 0, 0))
    for i, t in enumerate(tiles):
        row.alpha_composite(t, (i * (W + 4), 0))
    row.save(HERE / "silhouettes_1x.png")
    big = Image.new("RGBA", (row.width * 8 + 16, H * 8 + 40), (226, 220, 206, 255))
    big.alpha_composite(row.resize((row.width * 8, H * 8), Image.NEAREST), (8, 8))
    d = ImageDraw.Draw(big)
    for i, name in enumerate([v[0] for v in VARIANTS] + ["Bertha"]):
        d.text((8 + i * (W + 4) * 8 + 4, H * 8 + 16), name, fill=(40, 30, 40, 255))
    big.save(ROOT / "docs/art-direction/spike/hale-silhouettes.png")


if __name__ == "__main__":
    main()
