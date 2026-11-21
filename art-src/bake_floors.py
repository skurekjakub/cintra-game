"""Bake carved ornamental stone floor panels for the HD-2D spike (A09).

Builds a height field procedurally (large tiles, worn bevels, chips, Voronoi cracks, chiselled
ornament grooves), then bakes albedo, OpenGL normal, roughness, AO and height PNGs. Photo detail
comes from the CC0 Poly Haven set `quarry_wall` (2k). Every field is periodic, so panels tile.

Usage:  python -I art-src/bake_floors.py
Output: game/spikes/hd2d/textures/baked/<panel>_{albedo,normal,rough,ao,height}.png
"""
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage
from scipy.spatial import cKDTree

ROOT = Path(__file__).resolve().parents[1]
PH = ROOT / "game/spikes/hd2d/textures/ph"
OUT = ROOT / "game/spikes/hd2d/textures/baked"
N = 1024
RNG = np.random.default_rng(7)


def periodic_noise(n, scale_px, rng):
    """Smooth periodic noise in 0..1 with features about scale_px wide (FFT low-pass)."""
    white = rng.standard_normal((n, n))
    f = np.fft.fftfreq(n)
    fx, fy = np.meshgrid(f, f)
    k = np.sqrt(fx ** 2 + fy ** 2) * scale_px
    spec = np.fft.fft2(white) * np.exp(-(k ** 2) * 4.0)
    out = np.real(np.fft.ifft2(spec))
    out -= out.min()
    return out / max(out.max(), 1e-9)


def fbm(n, base_px, rng, octaves=4):
    acc = np.zeros((n, n))
    amp = 1.0
    tot = 0.0
    for i in range(octaves):
        acc += periodic_noise(n, base_px / (2 ** i), rng) * amp
        tot += amp
        amp *= 0.5
    return acc / tot


def photo(set_name, kind, repeats):
    im = Image.open(PH / set_name / f"{kind}.jpg").convert("RGB")
    size = -(-N // repeats)
    im = im.resize((size, size), Image.LANCZOS)
    a = np.asarray(im).astype(np.float32) / 255.0
    return np.tile(a, (repeats, repeats, 1))[:N, :N]


def groove(d, w):
    """Chiselled V-groove profile: 1 at the centre line, 0 at distance w."""
    x = np.clip(1.0 - np.abs(d) / w, 0.0, 1.0)
    return x ** 0.8


def voronoi_edges(n, cells, rng):
    pts = rng.random((cells, 2)) * n
    tiled = np.concatenate([pts + np.array([dx, dy]) * n for dx in (-1, 0, 1) for dy in (-1, 0, 1)])
    tree = cKDTree(tiled)
    yy, xx = np.mgrid[0:n, 0:n]
    q = np.stack([xx.ravel(), yy.ravel()], axis=1).astype(np.float64)
    d, _ = tree.query(q, k=2)
    return (d[:, 1] - d[:, 0]).reshape(n, n)


def tile_field(panel_m, tile_m):
    px_per_m = N / panel_m
    t = tile_m * px_per_m
    yy, xx = np.mgrid[0:N, 0:N].astype(np.float32)
    u = np.mod(xx, t)
    v = np.mod(yy, t)
    edge = np.minimum(np.minimum(u, t - u), np.minimum(v, t - v)) / px_per_m
    tid = (np.floor(xx / t) + 17 * np.floor(yy / t)).astype(np.int32)
    return edge, tid, (u / t - 0.5) * tile_m, (v / t - 0.5) * tile_m


def karak_carving(panel_m):
    """Metres-based ornament on a 3x3 tile panel: octagon frames, interlace lattice, rosette."""
    yy, xx = np.mgrid[0:N, 0:N].astype(np.float32)
    x = (xx / N - 0.5) * panel_m
    y = (yy / N - 0.5) * panel_m
    ax, ay = np.abs(x), np.abs(y)
    h = panel_m * 0.5
    octa = np.maximum(np.maximum(ax, ay), (ax + ay) * 0.7071)
    c = np.zeros_like(x)
    c = np.maximum(c, groove(octa - h * 0.82, 0.05))
    c = np.maximum(c, groove(octa - h * 0.72, 0.03))
    u = (x + y) * 0.7071
    v = (x - y) * 0.7071
    cell = h * 0.32
    for band in (u, v):
        lu = (np.mod(band, cell) - cell * 0.5)
        c = np.maximum(c, groove(np.abs(lu) - 0.055, 0.025) * (octa < h * 0.64))
    r = np.sqrt(x * x + y * y)
    th = np.arctan2(y, x)
    c = np.maximum(c, groove(r - h * 0.22, 0.03))
    c = np.maximum(c, groove(r - h * 0.14 * (1 + 0.35 * np.cos(8 * th)), 0.025))
    cx = h - ax
    cy = h - ay
    cr = np.sqrt(cx * cx + cy * cy)
    c = np.maximum(c, groove(cr - h * 0.34, 0.035))
    c = np.maximum(c, groove(cr - h * 0.24, 0.025))
    diamond = np.abs(cx) + np.abs(cy)
    raised = (diamond < h * 0.1).astype(np.float32)
    return c, raised


def tavern_carving(panel_m, tile_m):
    """2x2 tile panel: diamond-in-square tile, rosette tile, two plain tiles with an inset line."""
    edge, tid, lx, ly = tile_field(panel_m, tile_m)
    yy, xx = np.mgrid[0:N, 0:N].astype(np.float32)
    ix = np.floor(xx / (N / 2)).astype(int)
    iy = np.floor(yy / (N / 2)).astype(int)
    c = groove(edge - 0.09, 0.025)
    ax, ay = np.abs(lx), np.abs(ly)
    a_tile = (ix == 0) & (iy == 0)
    d_tile = (ix == 1) & (iy == 1)
    dia = ax + ay
    ca = np.maximum(groove(dia - 0.38, 0.035), groove(dia - 0.3, 0.025))
    ca = np.maximum(ca, groove(np.sqrt(lx * lx + ly * ly) - 0.12, 0.03))
    for sx in (-1, 1):
        for sy in (-1, 1):
            ca = np.maximum(ca, groove(np.sqrt((lx - sx * 0.41) ** 2 + (ly - sy * 0.41) ** 2) - 0.05, 0.02))
    r = np.sqrt(lx * lx + ly * ly)
    th = np.arctan2(ly, lx)
    cd = np.maximum(groove(r - 0.36, 0.035), groove(r - 0.22 * (1 + 0.3 * np.cos(4 * th)), 0.03))
    cd = np.maximum(cd, groove(r - 0.07, 0.02))
    cd = np.maximum(cd, groove(np.minimum(np.abs(lx), np.abs(ly)) - 0.0, 0.018) * ((r > 0.36) & (r < 0.43)))
    c = np.where(a_tile, np.maximum(c, ca), c)
    c = np.where(d_tile, np.maximum(c, cd), c)
    return c, np.zeros_like(c)


def bake(name, panel_m, tile_m, carving, tint, photo_repeats, crack_cells, damp, out_dir):
    rng = np.random.default_rng(abs(hash(name)) % (2 ** 32))
    px_m = N / panel_m
    edge, tid, _, _ = tile_field(panel_m, tile_m)
    wear = fbm(N, 40, rng) - 0.5
    chips = fbm(N, 14, rng)
    e = edge + wear * 0.03 - np.clip(chips - 0.72, 0, 1) * 0.25
    bevel = np.clip((e - 0.006) / 0.035, 0, 1)
    bevel = bevel * bevel * (3 - 2 * bevel)
    jitter = np.vectorize(lambda i: np.random.default_rng(int(i) + 99).random(), otypes=[np.float32])(tid)
    tilt_x = np.vectorize(lambda i: np.random.default_rng(int(i) + 7).random() - 0.5, otypes=[np.float32])(tid)
    yy, xx = np.mgrid[0:N, 0:N].astype(np.float32)
    lx = (np.mod(xx, tile_m * px_m) / (tile_m * px_m) - 0.5)
    height = bevel * (0.8 + jitter * 0.12 + tilt_x * lx * 0.08)
    carve, raised = carving
    carve = carve * bevel
    height -= carve * 0.32
    height += raised * bevel * 0.05
    alb = photo("quarry_wall", "diff", photo_repeats)
    rough = photo("quarry_wall", "rough", photo_repeats)[..., 0]
    lum = alb.mean(axis=2)
    height += (lum - ndimage.uniform_filter(lum, 25, mode="wrap")) * 0.12 * bevel
    vor = voronoi_edges(N, crack_cells, rng)
    crack_mask = np.clip((fbm(N, 120, rng) - 0.55) * 5, 0, 1)
    crack = np.clip(1 - vor / 2.2, 0, 1) * crack_mask * bevel
    height -= crack * 0.25

    gy, gx = np.gradient(height)
    strength = 14.0
    nx, ny, nz = -gx * strength, gy * strength, np.ones_like(height)
    ln = np.sqrt(nx * nx + ny * ny + nz * nz)
    normal = np.stack([nx / ln, ny / ln, nz / ln], axis=2) * 0.5 + 0.5

    occl = np.zeros_like(height)
    for rad, w in ((2, 1.0), (6, 0.8), (18, 0.6)):
        blur = ndimage.gaussian_filter(height, rad, mode="wrap")
        occl += np.clip(blur - height, 0, None) * w
    ao = np.clip(1 - occl * 4.5, 0.25, 1)

    tint = np.array(tint, dtype=np.float32)
    mottle = (fbm(N, 90, rng) - 0.5)[..., None] * np.array([0.22, 0.2, 0.26])
    lum_n = (lum / max(lum.mean(), 1e-3))[..., None]
    base = tint * (1.0 + (lum_n - 1.0) * 0.55 + mottle)
    var = (jitter - 0.5)[..., None] * np.array([0.10, 0.09, 0.12])
    base = base * (1 + var)
    grime = np.clip(1 - carve * 0.55 - crack * 0.6, 0.2, 1)[..., None]
    base = base * grime * (0.45 + 0.55 * bevel[..., None])
    slope = np.sqrt(gx * gx + gy * gy) * px_m
    worn = np.clip(slope * 0.02, 0, 1) * (carve < 0.2) * (bevel > 0.2)
    base = base + worn[..., None] * 0.12
    wet = np.clip((fbm(N, 220, rng) - 0.5) * 4, 0, 1) * damp
    base = base * (1 - wet[..., None] * 0.4)
    base = base * (ao ** 0.8)[..., None]
    rough = np.clip(rough * 0.85 + carve * 0.1 - wet * 0.55, 0.12, 1)

    out_dir.mkdir(parents=True, exist_ok=True)

    def save(arr, suffix, mode="RGB"):
        a = np.clip(arr * 255 + 0.5, 0, 255).astype(np.uint8)
        Image.fromarray(a, mode=None).save(out_dir / f"{name}_{suffix}.png")

    save(np.clip(base, 0, 1), "albedo")
    save(normal, "normal")
    save(rough, "rough")
    save(ao, "ao")
    save((height - height.min()) / max(np.ptp(height), 1e-6), "height")
    print("baked", name)


if __name__ == "__main__":
    bake("karak_floor", 3.0, 1.0, karak_carving(3.0), (0.58, 0.6, 0.7), 3, 60, 0.7, OUT)
    bake("tavern_floor", 2.0, 1.0, tavern_carving(2.0, 1.0), (0.78, 0.7, 0.74), 2, 30, 0.8, OUT)
