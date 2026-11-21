"""Download the CC0 Poly Haven textures and models used by the Drowned Rat taproom set (A10).

Textures -> game/spikes/hd2d/textures/ph/<id>/{diff,nor,rough,ao}.jpg   (Godot imports these)
Models   -> game/spikes/hd2d/models/ph_src/<id>/<id>_1k.gltf + .bin + textures/
            (raw sources for art-src/env/build_taproom.py; the folder has a .gdignore so Godot
            does not import them twice: the Blender script bakes them into the set glTFs)

Usage:  python -I art-src/env/fetch_polyhaven.py
"""
import json
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TEX = ROOT / "game/spikes/hd2d/textures/ph"
MOD = ROOT / "game/spikes/hd2d/models/ph_src"
UA = {"User-Agent": "cintra-game-A10-env (CC0 asset fetch)"}

# id -> resolution (2k for the floor-bake grain sources)
TEXTURES = {
    "rough_wood": "2k",
    "weathered_planks": "2k",
    "clay_plaster": "1k",
    "worn_cracked_plaster": "1k",
    "rough_plaster_03": "1k",
    "wood_planks_dirt": "1k",
}

MODELS = [
    "wine_barrel_01", "wooden_crate_01", "wooden_crate_02", "wooden_stool_02", "folding_wooden_stool",
    "wooden_picnic_table", "wooden_bucket_01", "wooden_bucket_02", "wicker_basket_01",
    "wooden_bowl_01", "carved_wooden_plate", "wooden_cutting_board", "wooden_candlestick",
    "wooden_lantern_01", "wooden_broom", "treasure_chest", "street_rat", "hamburger_buns",
    "food_apple_01", "yellow_onion", "ceramic_pot", "brass_pot_01", "brass_pan_01",
    "dutch_ship_medium", "ship_pinnace", "modular_wooden_pier", "wooden_ladder", "wooden_axe",
]


def get(url):
    req = urllib.request.Request(url, headers=UA)
    with urllib.request.urlopen(req, timeout=120) as r:
        return r.read()


def fetch(url, dest: Path):
    if dest.exists() and dest.stat().st_size > 0:
        return
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_bytes(get(url))
    print("  ", dest.relative_to(ROOT))


def textures():
    for tid, res in TEXTURES.items():
        files = json.loads(get(f"https://api.polyhaven.com/files/{tid}"))
        maps = {"diff": "Diffuse", "nor": "nor_gl", "rough": "Rough", "ao": "AO"}
        for short, key in maps.items():
            if key not in files:
                continue
            fetch(files[key][res]["jpg"]["url"], TEX / tid / f"{short}.jpg")


def models():
    MOD.mkdir(parents=True, exist_ok=True)
    (MOD / ".gdignore").write_text("")
    for mid in MODELS:
        files = json.loads(get(f"https://api.polyhaven.com/files/{mid}"))
        g = files["gltf"]["1k"]["gltf"]
        fetch(g["url"], MOD / mid / Path(g["url"]).name)
        for rel, info in g["include"].items():
            fetch(info["url"], MOD / mid / rel)


def shrink_model_textures(size=512):
    """Props are 20-80 px tall on screen: 512 px maps are plenty and keep taproom_props.glb small."""
    from PIL import Image
    for f in MOD.glob("*/textures/*"):
        im = Image.open(f)
        if im.width > size:
            im = im.resize((size, size), Image.LANCZOS)
            if f.suffix.lower() == ".jpg":
                im.convert("RGB").save(f, quality=90)
            else:
                im.save(f)


if __name__ == "__main__":
    textures()
    models()
    shrink_model_textures()
    print("done")
