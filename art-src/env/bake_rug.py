"""Bake a worn woven rug texture for the Drowned Rat (A10): faded indigo field, brick-red and
ochre borders, three lozenge medallions, warp/weft weave, traffic wear and stains.
Usage: python art-src/env/bake_rug.py  ->  game/spikes/hd2d/textures/baked/taproom_rug_albedo.png
UV: u along the rug length (2.4 m), v across (1.5 m)."""
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "game/spikes/hd2d/textures/baked"
W, H = 768, 480
rng = np.random.default_rng(3)
yy, xx = np.mgrid[0:H, 0:W].astype(np.float32)
u = xx / W
v = yy / H


def lin(c):
    return np.array(c, np.float32)


field = lin([0.075, 0.085, 0.17])
red = lin([0.30, 0.065, 0.045])
ochre = lin([0.42, 0.28, 0.09])
cream = lin([0.48, 0.42, 0.30])
alb = np.tile(field, (H, W, 1))

# borders (distance to edge in metres-ish units)
du = np.minimum(u, 1 - u) * 2.4
dv = np.minimum(v, 1 - v) * 1.5
d = np.minimum(du, dv)
alb[d < 0.2] = red
alb[(d > 0.06) & (d < 0.085)] = ochre
alb[(d > 0.13) & (d < 0.15)] = cream
alb[(d > 0.2) & (d < 0.225)] = ochre
# little stepped teeth in the red border
teeth = (np.abs(((u * 2.4 / 0.12) % 1.0) - 0.5) < 0.18) & (d > 0.09) & (d < 0.125)
alb[teeth] = ochre
# lozenge medallions
for cu in (0.27, 0.5, 0.73):
    dx = np.abs(u - cu) * 2.4
    dy = np.abs(v - 0.5) * 1.5
    r = dx / 0.32 + dy / 0.42
    alb[(r > 0.86) & (r < 1.0)] = red
    alb[(r > 0.62) & (r < 0.7)] = ochre
    alb[r < 0.3] = red
    alb[(r > 0.12) & (r < 0.18)] = cream
# small hooked motifs scattered in the field
for _ in range(40):
    cu, cv = rng.uniform(0.12, 0.88), rng.uniform(0.2, 0.8)
    m = (np.abs(u - cu) * 2.4 < 0.03) & (np.abs(v - cv) * 1.5 < 0.03)
    alb[m] = ochre if rng.random() < 0.5 else cream
# weave: warp/weft ridges
weave = 0.82 + 0.18 * (np.sin(xx * np.pi / 2.0) * np.sin(yy * np.pi / 2.0) > 0)
alb *= weave[..., None]


def blur_noise(sigma, seed):
    r = np.random.default_rng(seed).standard_normal((H, W)).astype(np.float32)
    n = ndimage.gaussian_filter(r, sigma, mode="wrap")
    return (n - n.min()) / (n.max() - n.min())


# fading, traffic wear (lighter, greyer in the middle), dirt and stains
fade = blur_noise(30, 1)
alb = alb * (0.75 + 0.5 * fade[..., None])
# sun-faded and grimy overall: pull toward a dusty grey-brown
dust = np.array([0.11, 0.09, 0.075], np.float32)
alb = alb * 0.62 + dust * 0.38
wear = np.exp(-(((u - 0.55) / 0.35) ** 2 + ((v - 0.5) / 0.35) ** 2)) * (0.6 + 0.4 * blur_noise(8, 2))
grey = alb.mean(axis=2, keepdims=True)
alb = alb * (1 - 0.45 * wear[..., None]) + (grey * 0.9 + 0.04) * 0.45 * wear[..., None]
stain = (blur_noise(12, 3) > 0.72).astype(np.float32)
stain = ndimage.gaussian_filter(stain, 3)
alb *= (1 - 0.35 * stain)[..., None]
alb *= (0.9 + 0.1 * blur_noise(1.2, 4))[..., None]

OUT.mkdir(parents=True, exist_ok=True)
srgb = np.where(alb <= 0.0031308, alb * 12.92, 1.055 * np.power(np.clip(alb, 0, 1), 1 / 2.4) - 0.055)
Image.fromarray((srgb * 255).clip(0, 255).astype(np.uint8)).save(OUT / "taproom_rug_albedo.png")
print("rug baked")
