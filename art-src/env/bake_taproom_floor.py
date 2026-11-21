"""Bake the Drowned Rat taproom floor as ONE unique texture set (A10).

Worn wide irregular planks running north-south (toward the camera), every board its own width,
length, grain offset, tint, cupping and tilt; staggered end joints, dirt-filled gaps, nail rows
on the joists, knots, two broken boards, two patches. On top: traffic wear (polished, lighter),
corner and wall dirt, hearth soot, ale spills, wax drips, straw, a blood pool, rain puddles and
wet streaks blowing in through the front door, and wet boot prints from the door to the hearth.

The texture covers the whole room rect, so nothing tiles:  x -8.1..8.1, z -5.65..5.65 (Godot),
at PX_PER_M texels per metre. Row 0 is the far (south) edge, column 0 the east (x = -8.1) edge.

Grain: CC0 Poly Haven `rough_wood` (2k). Usage:  python -I art-src/env/bake_taproom_floor.py
Output: game/spikes/hd2d/textures/baked/taproom_floor_{albedo,normal,rough,ao,height}.png
"""
import math
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage

ROOT = Path(__file__).resolve().parents[2]
PH = ROOT / "game/spikes/hd2d/textures/ph"
OUT = ROOT / "game/spikes/hd2d/textures/baked"
X0, Z0, XS, ZS = -8.1, -5.65, 16.2, 11.3
PX_PER_M = 144
NX, NZ = int(XS * PX_PER_M), int(ZS * PX_PER_M)
RNG = np.random.default_rng(31)

zz, xx = np.mgrid[0:NZ, 0:NX].astype(np.float32)
WX = X0 + (xx + 0.5) / PX_PER_M          # world x per texel
WZ = Z0 + (zz + 0.5) / PX_PER_M          # world z per texel


def smooth(a, b, x):
    t = np.clip((x - a) / (b - a), 0.0, 1.0)
    return t * t * (3 - 2 * t)


def noise(scale_m, seed, octaves=4):
    """Smooth fBm in 0..1 with features about scale_m metres (FFT low-pass of white noise)."""
    rng = np.random.default_rng(seed)
    acc = np.zeros((NZ, NX), np.float32)
    amp, tot, sc = 1.0, 0.0, scale_m
    fz = np.fft.fftfreq(NZ)[:, None]
    fx = np.fft.fftfreq(NX)[None, :]
    k2 = fz ** 2 + fx ** 2
    for _ in range(octaves):
        w = rng.standard_normal((NZ, NX)).astype(np.float32)
        s = sc * PX_PER_M
        spec = np.fft.fft2(w) * np.exp(-k2 * (s ** 2) * 2.0)
        n = np.real(np.fft.ifft2(spec)).astype(np.float32)
        n = (n - n.mean()) / (n.std() + 1e-9)
        acc += n * amp
        tot += amp
        amp *= 0.5
        sc *= 0.5
    acc /= tot
    return np.clip(acc * 0.5 * 0.5 + 0.5, 0.0, 1.0)


def blob_mask(cx, cz, rx, rz, seed, rough=0.35, scale=0.25):
    n = noise(scale, seed, 3)
    d = np.sqrt(((WX - cx) / rx) ** 2 + ((WZ - cz) / rz) ** 2)
    return np.clip(1.0 - d + (n - 0.5) * rough * 2.0, 0.0, 1.0)


# --------------------------------------------------------------------------------------------
# grain source
# --------------------------------------------------------------------------------------------
GRAIN_M = 1.6       # metres covered by the grain photo
gimg = Image.open(PH / "rough_wood/diff.jpg").convert("L")
gpx = int(GRAIN_M * PX_PER_M)
grain_src = np.asarray(gimg.resize((gpx, gpx), Image.LANCZOS)).astype(np.float32) / 255.0
grain_src = (grain_src - grain_src.mean()) / (grain_src.std() + 1e-6)

# --------------------------------------------------------------------------------------------
# board layout
# --------------------------------------------------------------------------------------------
col_edges = [X0 - 0.05]
while col_edges[-1] < X0 + XS:
    col_edges.append(col_edges[-1] + RNG.uniform(0.17, 0.31))
col_edges = np.array(col_edges)
col = np.clip(np.searchsorted(col_edges, WX, side="right") - 1, 0, len(col_edges) - 2)
bx0 = col_edges[col]
bx1 = col_edges[col + 1]

board_id = np.zeros((NZ, NX), np.int32)
seg_z0 = np.zeros((NZ, NX), np.float32)
seg_z1 = np.zeros((NZ, NX), np.float32)
boards = []
for c in range(len(col_edges) - 1):
    m = col == c
    edges = [Z0 - RNG.uniform(0.0, 2.5)]
    while edges[-1] < Z0 + ZS:
        edges.append(edges[-1] + RNG.uniform(1.1, 3.6))
    edges = np.array(edges)
    zc = WZ[m]
    s = np.clip(np.searchsorted(edges, zc, side="right") - 1, 0, len(edges) - 2)
    ids = len(boards) + s
    board_id[m] = ids
    seg_z0[m] = edges[s]
    seg_z1[m] = edges[s + 1]
    for k in range(len(edges) - 1):
        boards.append({
            "tint": RNG.uniform(0.62, 1.25),
            "hue": RNG.uniform(-0.05, 0.05),
            "gu": RNG.integers(0, gpx), "gv": RNG.integers(0, gpx),
            "cup": RNG.uniform(0.0006, 0.0022),
            "tilt": RNG.uniform(-0.002, 0.002),
            "lift": RNG.uniform(-0.0015, 0.0015),
            "flip": RNG.random() < 0.5,
        })
NB = len(boards)
tint = np.array([b["tint"] for b in boards], np.float32)[board_id]
hue = np.array([b["hue"] for b in boards], np.float32)[board_id]
cup = np.array([b["cup"] for b in boards], np.float32)[board_id]
tilt = np.array([b["tilt"] for b in boards], np.float32)[board_id]
lift = np.array([b["lift"] for b in boards], np.float32)[board_id]
gu = np.array([b["gu"] for b in boards])[board_id]
gv = np.array([b["gv"] for b in boards])[board_id]

# local coords in the board
u = (WX - bx0) / (bx1 - bx0)                     # 0..1 across
de_side = np.minimum(WX - bx0, bx1 - WX)          # m to the long edges
de_end = np.minimum(WZ - seg_z0, seg_z1 - WZ)     # m to the end joints
de = np.minimum(de_side, de_end)

# grain lookup (grain runs along z)
gi = ((xx.astype(np.int64) + gu) % gpx)
gj = ((zz.astype(np.int64) + gv) % gpx)
grain = grain_src[gj, gi]

# --------------------------------------------------------------------------------------------
# height (metres)
# --------------------------------------------------------------------------------------------
h = np.zeros((NZ, NX), np.float32)
h += lift + tilt * (u - 0.5) * 2.0
h -= cup * (2.0 * u - 1.0) ** 2
h += grain * 0.00045
gap = 0.0045 + 0.004 * noise(0.6, 5, 2)          # gap half width varies along the boards
edge_round = smooth(0.0, gap + 0.006, de)
h = h * edge_round + (-0.006) * (1.0 - smooth(gap * 0.5, gap, de))
h = np.minimum(h, -0.006 + edge_round * 0.02)

# knots
knot_map = np.zeros((NZ, NX), np.float32)
for _ in range(int(XS * ZS * 1.1)):
    kx = RNG.uniform(X0, X0 + XS)
    kz = RNG.uniform(Z0, Z0 + ZS)
    rx = RNG.uniform(0.012, 0.03)
    rz = rx * RNG.uniform(1.6, 3.0)
    i0, i1 = int((kx - X0 - 0.15) * PX_PER_M), int((kx - X0 + 0.15) * PX_PER_M)
    j0, j1 = int((kz - Z0 - 0.25) * PX_PER_M), int((kz - Z0 + 0.25) * PX_PER_M)
    i0, j0 = max(i0, 0), max(j0, 0)
    sl = (slice(j0, max(j0, min(j1, NZ))), slice(i0, max(i0, min(i1, NX))))
    d = np.sqrt(((WX[sl] - kx) / rx) ** 2 + ((WZ[sl] - kz) / rz) ** 2)
    ring = np.exp(-((d - 1.0) ** 2) * 6.0) * 0.6 + np.exp(-(d ** 2) * 3.0)
    knot_map[sl] = np.maximum(knot_map[sl], ring * smooth(0.0, 0.01, de[sl]))

# nails on the joist lines (joists every 0.6 m)
nail = np.zeros((NZ, NX), np.float32)
for jz in np.arange(Z0 + 0.3, Z0 + ZS, 0.6):
    for c in range(len(col_edges) - 1):
        for t in (0.25, 0.75):
            nx_ = col_edges[c] + (col_edges[c + 1] - col_edges[c]) * t + RNG.uniform(-0.01, 0.01)
            nz_ = jz + RNG.uniform(-0.012, 0.012)
            i, j = int((nx_ - X0) * PX_PER_M), int((nz_ - Z0) * PX_PER_M)
            if 2 <= i < NX - 2 and 2 <= j < NZ - 2:
                nail[j - 2:j + 3, i - 2:i + 3] = np.maximum(nail[j - 2:j + 3, i - 2:i + 3],
                                                             np.array([[0, .4, .6, .4, 0], [.4, .9, 1, .9, .4], [.6, 1, 1, 1, .6],
                                                                       [.4, .9, 1, .9, .4], [0, .4, .6, .4, 0]]))
h -= nail * 0.0012

# broken board: a ragged hole with splintered rims and a joist showing below
broken = np.zeros((NZ, NX), np.float32)
splint = np.zeros((NZ, NX), np.float32)
for (cx, cz, ln) in ():  # (2.6, -1.0, 0.34) removed in r4: a black hole read as a hole in the render
    c = int(np.searchsorted(col_edges, cx) - 1)
    rag = noise(0.015, 11, 2)
    along = np.abs(WZ - cz) - ln * 0.5 - (rag - 0.5) * 0.18
    m = (col == c) & (along < 0) & (de_side > 0.012 + (rag - 0.5) * 0.03)
    broken[m] = 1.0
    ring = ndimage.binary_dilation(m, iterations=4) & ~m & (col == c)
    splint[ring] = 1.0
broken = ndimage.gaussian_filter(broken, 0.6)
splint = ndimage.gaussian_filter(splint, 0.5)
joist = broken * (np.abs(((WZ - Z0 - 0.3) % 0.6) - 0.3) > 0.22)
h = h * (1 - broken) + (-0.035) * broken + joist * 0.012
h += splint * 0.0015

# patches: newer boards nailed over the floor
patch = np.zeros((NZ, NX), np.float32)
patch_grain = np.zeros((NZ, NX), np.float32)
for (cx, cz, w, ln, rot) in ((-0.6, -0.9, 0.24, 0.62, 0.0), (4.4, -2.6, 0.3, 0.5, 0.0), (-3.5, 4.6, 0.26, 0.7, 0.0)):
    m = (np.abs(WX - cx) < w * 0.5) & (np.abs(WZ - cz) < ln * 0.5)
    e = np.minimum(w * 0.5 - np.abs(WX - cx), ln * 0.5 - np.abs(WZ - cz))
    p = m * smooth(0.0, 0.006, e)
    patch = np.maximum(patch, p)
    for (sx, sz) in ((-1, -1), (1, -1), (-1, 1), (1, 1)):
        i = int((cx + sx * (w * 0.5 - 0.035) - X0) * PX_PER_M)
        j = int((cz + sz * (ln * 0.5 - 0.035) - Z0) * PX_PER_M)
        nail[j - 2:j + 3, i - 2:i + 3] = 1.0
h = h * (1 - patch) + (0.012 + grain * 0.0004) * patch

# --------------------------------------------------------------------------------------------
# masks: traffic, dirt, soot, stains, straw, wet
# --------------------------------------------------------------------------------------------
def seg_dist(px, pz, ax, az, bx, bz):
    vx, vz = bx - ax, bz - az
    t = np.clip(((px - ax) * vx + (pz - az) * vz) / (vx * vx + vz * vz), 0, 1)
    return np.sqrt((px - ax - t * vx) ** 2 + (pz - az - t * vz) ** 2)


paths = [((1.2, -5.4), (0.2, 0.5)), ((0.2, 0.5), (-1.5, 3.0)), ((0.2, 0.5), (-5.6, 0.2)), ((0.2, 0.5), (4.0, 1.4)),
         ((-1.5, 3.0), (3.0, 3.0)), ((1.2, -5.4), (5.5, -3.0))]
traffic = np.zeros((NZ, NX), np.float32)
for (a, b) in paths:
    d = seg_dist(WX, WZ, a[0], a[1], b[0], b[1])
    traffic = np.maximum(traffic, np.exp(-(d / 1.0) ** 2))
traffic *= 0.6 + 0.4 * noise(0.5, 21, 3)

wall_d = np.minimum.reduce([WX - (-8.0), 8.0 - WX, WZ - (-5.5), 5.5 - WZ])
dirt = np.clip(np.exp(-wall_d / 0.35) * 1.1, 0, 1) * (0.6 + 0.4 * noise(0.3, 22, 3))
# under / around tables and the bar
for (cx, cz, r) in ((-4.0, 1.95, 0.9), (3.75, 2.35, 0.9), (-4.5, -3.0, 1.4), (5.1, 0.35, 1.3), (-1.9, -4.4, 1.1),
                    (6.25, -3.75, 1.2), (-0.8, 3.6, 2.5)):
    dirt = np.maximum(dirt, 0.45 * np.exp(-(((WX - cx) / r) ** 2 + ((WZ - cz) / (r * 0.7)) ** 2)) * noise(0.2, int(cx * 10 + 50), 2) * 1.6)
soot = np.exp(-(((WX + 7.0) / 1.6) ** 2 + (WZ / 2.6) ** 2)) * (0.7 + 0.3 * noise(0.2, 23, 3))

stain = np.zeros((NZ, NX), np.float32)
for k in range(26):
    cx, cz = RNG.uniform(-7.2, 7.2), RNG.uniform(-4.8, 4.8)
    r = RNG.uniform(0.08, 0.35)
    stain = np.maximum(stain, blob_mask(cx, cz, r, r * RNG.uniform(0.6, 1.4), 100 + k, 0.5, 0.06) * RNG.uniform(0.4, 1.0))
# ale spills near the round tables (fresh, still wet)
spill = np.zeros((NZ, NX), np.float32)
for (cx, cz, r) in ((-3.4, 2.5, 0.32), (4.3, 2.9, 0.25), (0.3, -2.4, 0.45), (-4.0, -2.2, 0.28)):
    spill = np.maximum(spill, blob_mask(cx, cz, r, r * 0.7, int(cx * 100) % 997, 0.45, 0.05))
spill = smooth(0.15, 0.4, spill)

# straw: thousands of short strands, denser near walls, stairs and under tables
straw = np.zeros((NZ, NX), np.float32)
dens = np.clip(dirt * 1.4 + 0.12, 0, 1)
n_str = 6000
n_cl = 900
clx = RNG.uniform(X0, X0 + XS, n_cl)
clz = RNG.uniform(Z0, Z0 + ZS, n_cl)
pick = RNG.integers(0, n_cl, n_str * 3)
cand_x = clx[pick] + RNG.normal(0, 0.09, n_str * 3)
cand_z = clz[pick] + RNG.normal(0, 0.09, n_str * 3)
ci = ((cand_x - X0) * PX_PER_M).astype(int).clip(0, NX - 1)
cj = ((cand_z - Z0) * PX_PER_M).astype(int).clip(0, NZ - 1)
keep = RNG.random(n_str * 3) < dens[cj, ci]
cand_x, cand_z = cand_x[keep][:n_str], cand_z[keep][:n_str]
img = Image.new("L", (NX, NZ), 0)
from PIL import ImageDraw  # noqa: E402

dr = ImageDraw.Draw(img)
for sx, sz in zip(cand_x, cand_z):
    a = RNG.uniform(0, math.pi)
    ln = RNG.uniform(0.04, 0.13) * PX_PER_M
    x0 = (sx - X0) * PX_PER_M
    z0 = (sz - Z0) * PX_PER_M
    bend = RNG.uniform(-0.25, 0.25)
    pts = [(x0 + math.cos(a + bend * t) * ln * t, z0 + math.sin(a + bend * t) * ln * t) for t in np.linspace(0, 1, 4)]
    dr.line(pts, fill=int(RNG.uniform(90, 200)), width=1)
straw = np.asarray(img).astype(np.float32) / 255.0
straw *= (1.0 - broken) * (1.0 - smooth(0.3, 0.7, traffic) * 0.7)
h = np.maximum(h, h * (1 - straw) + (0.0025 + h) * straw)

# rain blown in at the door: puddles + streaks, and wet boot prints toward the hearth
door = blob_mask(1.2, -5.4, 1.4, 1.1, 301, 0.6, 0.18)
streak = np.exp(-(seg_dist(WX, WZ, 1.2, -5.5, 0.6, -2.5) / 0.55) ** 2) * noise(0.12, 302, 3)
wet = np.clip(door * 1.4 + streak * 0.9, 0, 1)
wet = np.maximum(wet, np.exp(-(seg_dist(WX, WZ, 1.2, -5.6, -0.4, -4.4) / 0.35) ** 2) * noise(0.1, 303, 2) * 1.2)
puddle = smooth(0.45, 0.62, np.clip(door * 1.3 + 0.35 * noise(0.15, 304, 3) - 0.2, 0, 1))
puddle = np.maximum(puddle, smooth(0.55, 0.7, np.clip(streak * 1.2 + 0.25 * noise(0.1, 305, 2), 0, 1)) * 0.9)
prints = np.zeros((NZ, NX), np.float32)


def bootprint(cx, cz, ang, left, strength):
    ca, sa = math.cos(ang), math.sin(ang)
    lx = (WX - cx) * ca + (WZ - cz) * sa
    lz = -(WX - cx) * sa + (WZ - cz) * ca
    sole = ((lx / 0.05) ** 2 + ((lz - 0.04) / 0.085) ** 2) < 1.0
    heel = ((lx / 0.045) ** 2 + ((lz + 0.09) / 0.045) ** 2) < 1.0
    m = (sole | heel).astype(np.float32)
    return m * strength


def walk(ax, az, bx, bz, step, strength0, seed_):
    r = np.random.default_rng(seed_)
    L = math.hypot(bx - ax, bz - az)
    ang = math.atan2(bz - az, bx - ax) - math.pi / 2
    n = int(L / step)
    out = np.zeros((NZ, NX), np.float32)
    for k in range(n):
        t = k / max(n - 1, 1)
        side = 1 if k % 2 else -1
        cx = ax + (bx - ax) * t + math.cos(ang) * 0.09 * side + r.uniform(-0.02, 0.02)
        cz = az + (bz - az) * t + math.sin(ang) * 0.09 * side + r.uniform(-0.02, 0.02)
        s = strength0 * (1.0 - t) ** 1.3 * r.uniform(0.6, 1.0)
        out = np.maximum(out, bootprint(cx, cz, ang + r.uniform(-0.15, 0.15), side < 0, s))
    return out


prints = np.maximum(prints, walk(1.2, -5.0, -5.2, 0.3, 0.34, 1.0, 7))       # the courier's stagger to the hearth
prints = np.maximum(prints, walk(1.0, -4.6, -0.6, 0.4, 0.3, 0.9, 8))        # thugs
prints = np.maximum(prints, walk(1.6, -4.8, 2.3, -1.4, 0.3, 0.85, 9))
prints = ndimage.gaussian_filter(prints, 0.7) * (1.0 - straw * 0.5)
wet = np.clip(np.maximum(wet, prints * 0.9), 0, 1)

# blood pool where the courier fell (on the floor just off the flagstones)
blood = smooth(0.35, 0.55, blob_mask(-4.45, 0.85, 0.22, 0.16, 401, 0.4, 0.05))
blood_drip = np.zeros((NZ, NX), np.float32)
for k in range(14):
    t = k / 13.0
    cx = 1.0 + (-4.5 - 1.0) * t + RNG.uniform(-0.15, 0.15)
    cz = -4.8 + (0.6 + 4.8) * t + RNG.uniform(-0.15, 0.15)
    blood_drip = np.maximum(blood_drip, smooth(0.5, 0.7, blob_mask(cx, cz, 0.035, 0.03, 410 + k, 0.5, 0.02)))
blood = np.maximum(blood, blood_drip * 0.8)

# hearth zone (real 3D flagstones sit on top of this area) and the hole under the bar end
hearth_zone = (WX < -4.7) & (np.abs(WZ) < 2.3)

# --------------------------------------------------------------------------------------------
# albedo
# --------------------------------------------------------------------------------------------
g01 = np.clip(grain * 0.18 + 0.5, 0, 1)
dark = np.array([0.085, 0.056, 0.038], np.float32)
light = np.array([0.33, 0.235, 0.155], np.float32)
alb = dark[None, None, :] + (light - dark)[None, None, :] * g01[..., None]
alb *= tint[..., None]
alb[..., 0] *= 1.0 + hue
alb[..., 2] *= 1.0 - hue
# low-frequency variation across the room
alb *= (0.85 + 0.3 * noise(1.2, 41, 3))[..., None]
# traffic: rubbed lighter and a little greyer
grey = alb.mean(axis=2, keepdims=True)
alb = alb * (1 + 0.28 * traffic[..., None]) * (1 - 0.15 * traffic[..., None]) + grey * 0.15 * traffic[..., None]
# knots
alb *= (1.0 - 0.55 * knot_map)[..., None]
# gaps: dark dirt
gapmask = 1.0 - smooth(gap * 0.3, gap + 0.004, de)
alb = alb * (1 - gapmask[..., None] * 0.8) + np.array([0.03, 0.022, 0.016]) * gapmask[..., None] * 0.8
# dirt / soot / stains
grime = np.array([0.07, 0.055, 0.045], np.float32)
dmix = np.clip(dirt * 0.75 + soot * 0.85, 0, 0.92)
alb = alb * (1 - dmix[..., None]) + grime * dmix[..., None]
alb *= (1.0 - 0.35 * stain)[..., None]
alb = alb * (1 - spill[..., None] * 0.5) + np.array([0.08, 0.04, 0.012]) * spill[..., None] * 0.5
# patches: newer, warmer, lighter wood
pgrain = np.clip(grain * 0.2 + 0.55, 0, 1)
pcol = np.array([0.30, 0.19, 0.11])[None, None, :] * (0.8 + 0.5 * pgrain[..., None])
alb = alb * (1 - patch[..., None]) + pcol * patch[..., None]
# broken holes: black void with splinter rims
alb = alb * (1 - broken[..., None]) + np.array([0.012, 0.009, 0.007]) * broken[..., None]
alb = alb * (1 - joist[..., None]) + np.array([0.05, 0.035, 0.022]) * joist[..., None]
alb = alb * (1 - splint[..., None] * 0.7) + np.array([0.42, 0.29, 0.16]) * splint[..., None] * 0.7
# nails
alb = alb * (1 - nail[..., None] * 0.85) + np.array([0.05, 0.045, 0.042]) * nail[..., None] * 0.85
# straw
scol = np.array([0.34, 0.24, 0.10])[None, None, :] * (0.75 + 0.5 * noise(0.05, 51, 1)[..., None])
alb = alb * (1 - straw[..., None]) + scol * straw[..., None]
# blood (dark, almost black-red)
alb = alb * (1 - blood[..., None]) + np.array([0.045, 0.004, 0.005]) * blood[..., None]
# wet: darker and more saturated
alb *= (1.0 - 0.45 * wet - 0.2 * puddle)[..., None]
alb[hearth_zone] *= 0.4

# --------------------------------------------------------------------------------------------
# roughness, height finish, AO, normal
# --------------------------------------------------------------------------------------------
rough = 0.78 + 0.08 * (g01 - 0.5) - 0.28 * traffic + 0.15 * dirt + 0.1 * straw
rough = np.where(nail > 0.5, 0.35, rough)
rough = rough * (1 - spill) + 0.12 * spill
rough = rough * (1 - wet) + 0.22 * wet
rough = rough * (1 - puddle) + 0.03 * puddle
rough = rough * (1 - blood) + 0.12 * blood
rough = np.clip(rough, 0.03, 1.0)

water_level = np.float32(0.0002)
h = np.where(puddle > 0.01, h * (1 - puddle) + np.maximum(h, water_level) * puddle, h)
h = h * (1 - blood * 0.7) + np.maximum(h, 0.0004) * blood * 0.7

hb = ndimage.gaussian_filter(h, 3.0)
cav = np.clip((hb - h) / 0.004, 0, 1)
hb2 = ndimage.gaussian_filter(h, 12.0)
cav2 = np.clip((hb2 - h) / 0.008, 0, 1)
ao = np.clip(1.0 - 0.55 * cav - 0.3 * cav2 - 0.25 * dirt, 0.15, 1.0)
alb *= (0.75 + 0.25 * ao)[..., None]

px_m = 1.0 / PX_PER_M
dhx = (np.roll(h, -1, axis=1) - np.roll(h, 1, axis=1)) / (2 * px_m)
dhz = (np.roll(h, -1, axis=0) - np.roll(h, 1, axis=0)) / (2 * px_m)
strength = 1.0
flat = 1.0 - puddle * 0.95
nx_ = -dhx * strength * flat
nz_ = -dhz * strength * flat
nrm = np.stack([nx_, np.ones_like(nx_), nz_], axis=-1)
nrm /= np.linalg.norm(nrm, axis=-1, keepdims=True)
# OpenGL tangent-space: R = +x (u), G = +v up. Texture v grows with z (rows), so G = -z.
tn = np.stack([nrm[..., 0], -nrm[..., 2], nrm[..., 1]], axis=-1)
tn_img = ((tn * 0.5 + 0.5) * 255).clip(0, 255).astype(np.uint8)

h01 = np.clip((h + 0.04) / 0.06, 0, 1)

OUT.mkdir(parents=True, exist_ok=True)
srgb = np.where(alb <= 0.0031308, alb * 12.92, 1.055 * np.power(np.clip(alb, 0, 1), 1 / 2.4) - 0.055)
Image.fromarray((srgb * 255).clip(0, 255).astype(np.uint8)).save(OUT / "taproom_floor_albedo.png")
Image.fromarray(tn_img).save(OUT / "taproom_floor_normal.png")
Image.fromarray((rough * 255).astype(np.uint8)).save(OUT / "taproom_floor_rough.png")
Image.fromarray((ao * 255).astype(np.uint8)).save(OUT / "taproom_floor_ao.png")
Image.fromarray((h01 * 255).astype(np.uint8)).save(OUT / "taproom_floor_height.png")
print("baked", NX, NZ, "boards", NB)
