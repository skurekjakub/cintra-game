"""Palette-swap KayKit character atlases per role (A09 HD-2D spike).

KayKit atlases are 1024x1024: 8 columns x 4 rows of 128x256 gradient swatches. Each role maps
swatch (col, row) -> target sRGB colour; the swatch's own luminance gradient is kept, so the
toon shading still steps. Cells were found with game/spikes/hd2d/tools/uvcells.gd.

Usage:  python art-src/recolor_kaykit.py
"""
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[1] / "game/spikes/hd2d/kaykit"
SRC = {
    "barbarian": ROOT / "adventurers/Barbarian_barbarian_texture.png",
    "rogue": ROOT / "adventurers/Rogue_rogue_texture.png",
    "knight": ROOT / "adventurers/Knight_knight_texture.png",
    "mage": ROOT / "adventurers/Mage_mage_texture.png",
}

ROLES = {
    # Hale: crimson hat and cloak, steel-blue coat.
    "hale": ("barbarian", {(7, 0): (0.78, 0.1, 0.09), (0, 1): (0.22, 0.36, 0.62)}),
    # Pale Choir thugs: bone-white hood, plum coat, blood-red sash.
    "choir": ("rogue", {(1, 1): (0.9, 0.87, 0.8), (0, 1): (0.36, 0.2, 0.38), (5, 0): (0.7, 0.08, 0.12), (0, 0): (0.86, 0.84, 0.8)}),
    # Bertha: bottle-green dress, cream trim.
    "bertha": ("rogue", {(0, 1): (0.18, 0.42, 0.26), (5, 0): (0.9, 0.85, 0.72)}),
    # The royal courier: Cintran red-and-gold tabard over grey.
    "courier": ("knight", {(0, 1): (0.7, 0.1, 0.1), (3, 0): (0.45, 0.47, 0.55), (7, 0): (0.85, 0.65, 0.25)}),
    # Sister Maelis: navy habit, white trim.
    "maelis": ("mage", {(0, 1): (0.14, 0.18, 0.42), (5, 0): (0.93, 0.91, 0.86), (2, 1): (0.93, 0.91, 0.86), (4, 0): (0.2, 0.24, 0.5)}),
    # Dwarven iron-warden: blued iron plate, brass trim, dark joints.
    "warden": ("knight", {(3, 0): (0.5, 0.54, 0.64), (7, 0): (0.85, 0.62, 0.28), (6, 0): (0.2, 0.22, 0.28), (7, 1): (0.18, 0.2, 0.26), (2, 1): (0.3, 0.85, 1.0)}),
}


def recolor(src, swaps):
    a = np.asarray(Image.open(src).convert("RGB")).astype(np.float32) / 255.0
    for (col, row), rgb in swaps.items():
        cell = a[row * 256:(row + 1) * 256, col * 128:(col + 1) * 128]
        lum = cell.mean(axis=2, keepdims=True)
        k = lum / max(float(lum.mean()), 1e-3)
        a[row * 256:(row + 1) * 256, col * 128:(col + 1) * 128] = np.clip(np.array(rgb) * k, 0, 1)
    return Image.fromarray((a * 255 + 0.5).astype(np.uint8))


if __name__ == "__main__":
    out = ROOT / "recolor"
    out.mkdir(exist_ok=True)
    for role, (base, swaps) in ROLES.items():
        recolor(SRC[base], swaps).save(out / f"{role}.png")
        print("wrote", role)
