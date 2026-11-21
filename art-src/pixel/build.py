"""Compile the hand-authored sprites to PNG + auto normal map for Godot (A09 spike).

Usage: python art-src/pixel/build.py
Output: game/spikes/hd2d/sprites/<name>.png and <name>_n.png, plus sprites.json (size, feet row).
"""
import json
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).parent))
import cast  # noqa: E402
import hale  # noqa: E402
import pixelart  # noqa: E402

OUT = Path(__file__).resolve().parents[2] / "game/spikes/hd2d/sprites"

SPRITES = {
    "hale_idle_s": hale.FRAMES["idle_s"],
    "thug_s": cast.FRAMES["thug_s"],
    "bertha_s": cast.FRAMES["bertha_s"],
    "courier_s": cast.FRAMES["courier_s"],
}


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    meta = {}
    for name, rows in SPRITES.items():
        rgba, chars = pixelart.compile_rgba(pixelart.parse(rows))
        nrm = pixelart.normal_map(chars, rgba)
        pixelart.save(rgba, OUT / f"{name}.png")
        pixelart.save(nrm, OUT / f"{name}_n.png")
        if name == "courier_s":
            lying = np.rot90(rgba, 1).copy()
            nl = np.rot90(nrm, 1).copy()
            pixelart.save(lying, OUT / "courier_lying.png")
            pixelart.save(nl, OUT / "courier_lying_n.png")
            meta["courier_lying"] = {"size": [lying.shape[1], lying.shape[0]]}
        ys = np.nonzero(rgba[..., 3])[0]
        meta[name] = {"size": [rgba.shape[1], rgba.shape[0]], "feet_row": int(ys.max())}
    (OUT / "sprites.json").write_text(json.dumps(meta, indent=1))
    print(meta)


main()
