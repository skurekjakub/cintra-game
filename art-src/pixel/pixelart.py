"""Hand-authored pixel art compiler (A09 HD-2D spike).

Sprites are palette-indexed maps: one character per pixel, '.' = transparent. Maps contain only
the interior; the compiler adds a *selective outline*: every transparent pixel touching the
sprite becomes a dark, hue-coloured outline taken from the neighbouring material's deepest tone,
lighter on the lit (top-left) side. Ramps are hue-shifted: shadows lean purple, lights lean warm.

Also derives a normal map from the art (auto-bevel of the alpha shape + per-material roundness),
so the sprite can be lit by the 3D scene's lights in Godot.
"""
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage

OUTLINE = (34, 18, 34)

# Ramps darkest -> lightest. Each pixel char belongs to one ramp.
RAMPS = {
    "skin": [("Z", (110, 50, 74)), ("z", (176, 92, 98)), ("s", (232, 152, 116)), ("S", (255, 210, 162))],
    "hair": [("J", (48, 22, 40)), ("j", (88, 40, 44)), ("h", (134, 66, 42)), ("H", (204, 120, 62))],
    "red": [("Q", (64, 16, 48)), ("q", (126, 24, 58)), ("r", (194, 44, 54)), ("R", (244, 108, 82))],
    "blue": [("V", (32, 34, 80)), ("v", (50, 68, 126)), ("b", (76, 110, 176)), ("B", (134, 178, 224))],
    "leather": [("N", (50, 28, 40)), ("n", (90, 52, 50)), ("l", (138, 86, 56)), ("L", (188, 134, 84))],
    "steel": [("G", (58, 60, 92)), ("g", (110, 118, 156)), ("m", (176, 186, 212)), ("M", (240, 244, 252))],
    "gold": [("u", (140, 84, 40)), ("y", (222, 168, 62)), ("Y", (255, 234, 146))],
    "bone": [("K", (84, 74, 96)), ("k", (150, 140, 152)), ("c", (212, 204, 196)), ("C", (250, 246, 232))],
    "plum": [("P", (40, 20, 50)), ("t", (72, 36, 78)), ("T", (112, 62, 112)), ("U", (160, 104, 150))],
    "green": [("F", (24, 44, 46)), ("f", (36, 84, 64)), ("i", (60, 132, 82)), ("I", (130, 186, 104))],
    "cream": [("a", (150, 130, 120)), ("A", (230, 220, 196))],
    "ginger": [("1", (86, 28, 40)), ("2", (168, 58, 40)), ("3", (226, 108, 50)), ("4", (252, 172, 92))],
    "face": [("e", (40, 22, 46)), ("w", (255, 255, 255)), ("x", (150, 58, 72)), ("p", (240, 126, 118))],
}
# How round each material is for the auto normal map (0 = flat, 1 = very domed).
ROUNDNESS = {"skin": 0.8, "hair": 1.0, "red": 0.6, "blue": 0.7, "leather": 0.7, "steel": 0.5,
             "gold": 0.4, "bone": 0.7, "plum": 0.7, "green": 0.7, "cream": 0.6, "face": 0.8, "ginger": 1.0}

COLOR = {}
RAMP_OF = {}
for _name, _ramp in RAMPS.items():
    for _i, (_ch, _rgb) in enumerate(_ramp):
        assert _ch not in COLOR, _ch
        COLOR[_ch] = _rgb
        RAMP_OF[_ch] = _name


def parse(rows, width=None):
    width = width or max(len(r) for r in rows)
    out = []
    for y, r in enumerate(rows):
        assert len(r) <= width, f"row {y} too long ({len(r)} > {width}): {r!r}"
        r = r.ljust(width, ".")
        for x, ch in enumerate(r):
            assert ch == "." or ch in COLOR, f"unknown char {ch!r} at {x},{y}"
        out.append(r)
    return out


def _mix(a, b, t):
    return tuple(int(round(a[i] * (1 - t) + b[i] * t)) for i in range(3))


def compile_rgba(rows, pad=1):
    """Map rows -> RGBA array with selective outline, padded by `pad` transparent pixels."""
    h = len(rows)
    w = len(rows[0])
    img = np.zeros((h + 2 * pad, w + 2 * pad, 4), np.uint8)
    chars = np.full((h + 2 * pad, w + 2 * pad), ".", dtype="<U1")
    for y, r in enumerate(rows):
        for x, ch in enumerate(r):
            if ch != ".":
                chars[y + pad, x + pad] = ch
                img[y + pad, x + pad] = COLOR[ch] + (255,)
    H, W = chars.shape
    for y in range(H):
        for x in range(W):
            if chars[y, x] != ".":
                continue
            neigh = []
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nx, ny = x + dx, y + dy
                if 0 <= nx < W and 0 <= ny < H and chars[ny, nx] != ".":
                    neigh.append((dx, dy, chars[ny, nx]))
            if not neigh:
                continue
            # The lit side is top-left: an outline pixel whose sprite neighbour is below/right of it.
            lit = any((dx, dy) in ((1, 0), (0, 1)) for dx, dy, _ in neigh) and not any(
                (dx, dy) in ((-1, 0), (0, -1)) for dx, dy, _ in neigh)
            ramp = RAMPS[RAMP_OF[neigh[0][2]]]
            deep = ramp[0][1]
            col = _mix(OUTLINE, deep, 0.55 if lit else 0.3)
            img[y, x] = col + (255,)
    return img, chars


def normal_map(chars, rgba):
    """Auto-bevel normals: distance-to-edge dome per material region plus the luminance of the art."""
    alpha = rgba[..., 3] > 0
    dist = ndimage.distance_transform_edt(alpha)
    rough = np.zeros(alpha.shape, np.float32)
    for y in range(chars.shape[0]):
        for x in range(chars.shape[1]):
            ch = chars[y, x]
            rough[y, x] = ROUNDNESS.get(RAMP_OF.get(ch, "face"), 0.6) if ch != "." else 0.7
    height = np.sqrt(np.clip(dist, 0, 6) / 6.0) * (0.5 + rough)
    lum = rgba[..., :3].mean(axis=2) / 255.0
    height = height + lum * 0.35
    height = ndimage.gaussian_filter(height, 0.7)
    gy, gx = np.gradient(height)
    nx, ny, nz = -gx * 2.2, gy * 2.2, np.ones_like(height)
    ln = np.sqrt(nx * nx + ny * ny + nz * nz)
    n = np.stack([nx / ln, ny / ln, nz / ln], axis=2) * 0.5 + 0.5
    out = np.zeros_like(rgba)
    out[..., :3] = (n * 255).astype(np.uint8)
    out[..., 3] = rgba[..., 3]
    return out


def save(arr, path):
    Path(path).parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(arr, "RGBA").save(path)
