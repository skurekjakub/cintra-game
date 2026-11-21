"""Sheet, normal map, contact sheet and onion-skin tools for Bertha's animation frames (A12)."""
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import pixelart  # noqa: E402

import rig  # noqa: E402

BG = (58, 54, 66, 255)
# Bertha's palette chars -> the pixelart char of the same material, so pixelart.normal_map gives
# her the same per-material roundness as the rest of the cast ('.' = outline, as the compiler makes it).
MATERIAL = {
    'O': '.',
    'W': 'A', 'C': 'A', 'a': 'a', 'q': 'a',          # kerchief, blouse, apron: cream
    'h': '3', 'H': '3', 'd': '2', 'D': '1',          # ginger hair
    's': 'S', 'S': 'S', 'k': 'z', 'b': 'p', 'm': 'x',  # skin + face accents
    'G': 'i', 'g': 'f', 'n': 'F', 'L': 'I',          # green shawl / skirt
    'T': 'L', 't': 'l', 'r': 'n',                    # wood: tankard, belt, shoes
}


def rgba(g: list) -> np.ndarray:
    return np.array(rig.to_image(g), dtype=np.uint8)


def normal(g: list) -> np.ndarray:
    chars = np.array([[MATERIAL.get(ch, '.') if ch != '.' else '.' for ch in row] for row in g], dtype="<U1")
    return pixelart.normal_map(chars, rgba(g))


def strip(arrays: list) -> Image.Image:
    return Image.fromarray(np.concatenate(arrays, axis=1), "RGBA")


def contact(frames: list, labels: list, scale: int = 8, pad: int = 8) -> Image.Image:
    f = rig.FRAME * scale
    sheet = Image.new("RGBA", (pad + len(frames) * (f + pad), f + 2 * pad + 14), BG)
    d = ImageDraw.Draw(sheet)
    for i, g in enumerate(frames):
        im = rig.to_image(g).resize((f, f), Image.NEAREST)
        x = pad + i * (f + pad)
        sheet.alpha_composite(im, (x, pad))
        d.text((x + 2, f + pad + 2), labels[i], fill=(230, 230, 230, 255))
    return sheet


def onion(frames: list, scale: int = 8, pad: int = 8) -> Image.Image:
    """Each frame drawn over the previous one (previous at 50%, tinted), so moved pixels show as fringes."""
    f = rig.FRAME * scale
    sheet = Image.new("RGBA", (pad + len(frames) * (f + pad), f + 2 * pad), BG)
    for i, g in enumerate(frames):
        prev = np.array(rig.to_image(frames[i - 1]), dtype=np.float32)
        cur = np.array(rig.to_image(g), dtype=np.float32)
        out = np.zeros_like(cur)
        out[...] = np.array(BG, dtype=np.float32)
        a_p = prev[..., 3:4] / 255.0
        tint = prev.copy()
        tint[..., :3] = tint[..., :3] * 0.5 + np.array([255, 60, 60]) * 0.5
        out = out * (1 - a_p * 0.5) + tint * a_p * 0.5
        a_c = cur[..., 3:4] / 255.0
        out = out * (1 - a_c * 0.5) + cur * a_c * 0.5
        out[..., 3] = 255
        im = Image.fromarray(out.astype(np.uint8), "RGBA").resize((f, f), Image.NEAREST)
        sheet.alpha_composite(im, (pad + i * (f + pad), pad))
    return sheet


def diff_count(a: list, b: list) -> int:
    return sum(ca != cb for ra, rb in zip(a, b) for ca, cb in zip(ra, rb))


def diffmap(frames: list, scale: int = 8, pad: int = 8) -> Image.Image:
    """Review aid: each frame greyed, with the pixels that changed since the previous frame marked
    (red = changed colour or appeared, blue = vanished)."""
    f = rig.FRAME * scale
    sheet = Image.new("RGBA", (pad + len(frames) * (f + pad), f + 2 * pad), BG)
    for i, g in enumerate(frames):
        prev = frames[i - 1]
        im = rig.to_image(g).convert("LA").convert("RGBA")
        px = im.load()
        for y in range(rig.FRAME):
            for x in range(rig.FRAME):
                a, b = prev[y][x], g[y][x]
                if a != b:
                    px[x, y] = (60, 120, 255, 255) if b == '.' else (255, 50, 50, 255)
                elif b != '.':
                    r, gg, bb, al = px[x, y]
                    px[x, y] = (r // 2 + 40, gg // 2 + 40, bb // 2 + 40, 255)
        sheet.alpha_composite(im.resize((f, f), Image.NEAREST), (pad + i * (f + pad), pad))
    return sheet
