"""Blender helpers for bespoke HD-2D environment geometry (A10).

All authoring happens in GODOT coordinates (x right, y up, z toward the camera) and is converted
to Blender (Z-up) on output, so the exported glTF lands exactly where the Godot scene expects it.

Geometry philosophy (art bible §6): chunky, bevelled, worn, never perfectly straight.
- `rbox`: a rounded box built from a non-uniform cube grid projected onto a rounded-box surface
  (real bevels with 15-degree arc steps).
- `timber`: rbox along a member axis + sag, twist, wobble, section swell, adze undulation and
  random edge chips; vertex colour carries edge wear and cavity darkening.
- `stone`: chunky rounded box with lumpy displacement.
- `Batch`: accumulates many pieces into one mesh object per group with per-face materials and a
  per-vertex colour attribute (R = cavity/AO multiplier, G = edge wear, B = grime/soot, A = wet).

Materials whose name starts with `TRI_` are re-mapped in Godot to world-space triplanar Poly Haven
sets (lib/taproom_set.gd); `FLOOR_` goes to the baked unique floor; anything else is a plain
PBR colour or the Poly Haven model's own textures.
"""
import math

import bmesh  # noqa: F401  (kept for callers)
import bpy
import numpy as np

# Godot (x, y, z) -> Blender (x, -z, y)
G2B = np.array([[1.0, 0.0, 0.0], [0.0, 0.0, -1.0], [0.0, 1.0, 0.0]])


def g2b(v):
    return np.asarray(v, float) @ G2B.T


# --------------------------------------------------------------------------------------------
# noise helpers (cheap, deterministic)
# --------------------------------------------------------------------------------------------

def noise1(x, rng, octaves=3, base=1.0):
    """Sum-of-sines 1D noise in about -1..1. x: array."""
    x = np.asarray(x, float)
    out = np.zeros_like(x)
    amp = 1.0
    tot = 0.0
    f = base
    for _ in range(octaves):
        out += amp * np.sin(x * f * (0.8 + 0.4 * rng.random()) + rng.random() * 6.283)
        tot += amp
        amp *= 0.5
        f *= 2.1
    return out / tot


def noise3(p, seed=0, scale=1.0):
    """Smooth 3D value-ish noise from summed sines, -1..1. p: (N,3)."""
    rng = np.random.default_rng(seed)
    p = np.asarray(p, float) * scale
    out = np.zeros(len(p))
    amp = 1.0
    tot = 0.0
    for o in range(4):
        d = rng.normal(size=3)
        d /= np.linalg.norm(d)
        d2 = rng.normal(size=3)
        d2 /= np.linalg.norm(d2)
        f = 2.0 ** o
        out += amp * np.sin(p @ d * f * 3.1 + rng.random() * 6.283) * np.cos(p @ d2 * f * 2.3 + rng.random() * 6.283)
        tot += amp
        amp *= 0.55
    return out / tot


def smoothstep(e0, e1, x):
    t = np.clip((np.asarray(x, float) - e0) / (e1 - e0), 0.0, 1.0)
    return t * t * (3.0 - 2.0 * t)


# --------------------------------------------------------------------------------------------
# rounded box
# --------------------------------------------------------------------------------------------

def _axis(h, r, step):
    """Grid coordinates on [-h, h]: arc samples near both ends + even interior.
    Small radii get fewer arc samples (a 1 cm bevel is about 1 px on screen)."""
    r = min(r, h * 0.95)
    inner = h - r
    if r < 0.016:
        k = [0.0, 1.0]
    elif r < 0.035:
        k = [0.0, 0.414, 1.0]
    else:
        k = [0.0, 0.268, 0.577, 1.0]
    ends = [inner + r * t for t in k]
    n = max(1, int(round(2.0 * inner / step)))
    mid = list(np.linspace(-inner, inner, n + 1))
    c = sorted(set([round(v, 6) for v in mid + ends + [-e for e in ends]]))
    return np.array(c)


def rbox(hx, hy, hz, r, step=0.06, step_x=None, step_y=None, step_z=None):
    """Rounded box centred at the origin. Returns verts (N,3), quads (M,4), normals (N,3)."""
    ax = _axis(hx, r, step_x or step)
    ay = _axis(hy, r, step_y or step)
    az = _axis(hz, r, step_z or step)
    verts = []
    quads = []

    def face(fixed_axis, sign, a_coords, b_coords, a_idx, b_idx):
        base = len(verts)
        na, nb = len(a_coords), len(b_coords)
        for i in range(na):
            for j in range(nb):
                p = [0.0, 0.0, 0.0]
                p[fixed_axis] = sign * [hx, hy, hz][fixed_axis]
                p[a_idx] = a_coords[i]
                p[b_idx] = b_coords[j]
                verts.append(p)
        for i in range(na - 1):
            for j in range(nb - 1):
                q = [base + i * nb + j, base + (i + 1) * nb + j, base + (i + 1) * nb + j + 1, base + i * nb + j + 1]
                quads.append(q if sign > 0 else q[::-1])

    face(0, 1, ay, az, 1, 2)
    face(0, -1, ay, az, 1, 2)
    face(1, 1, az, ax, 2, 0)
    face(1, -1, az, ax, 2, 0)
    face(2, 1, ax, ay, 0, 1)
    face(2, -1, ax, ay, 0, 1)
    v = np.array(verts)
    q = np.array(quads)
    key = np.round(v * 1e5).astype(np.int64)
    _, first, inv = np.unique(key, axis=0, return_index=True, return_inverse=True)
    inv = inv.reshape(-1)
    v = v[first]
    q = inv[q]
    h = np.array([hx, hy, hz])
    rr = np.minimum(r, h * 0.95)
    lim = h - rr
    qc = np.clip(v, -lim, lim)
    n = v - qc
    ln = np.linalg.norm(n, axis=1, keepdims=True)
    ln[ln < 1e-9] = 1.0
    nrm = n / ln
    v = qc + nrm * rr.min()
    return v, q, nrm


def frame(p0, p1, up=(0.0, 1.0, 0.0)):
    """Orthonormal frame with X along p0->p1. Returns origin(mid), X, Y, Z, length."""
    p0 = np.asarray(p0, float)
    p1 = np.asarray(p1, float)
    ax = p1 - p0
    L = np.linalg.norm(ax)
    X = ax / L
    upv = np.asarray(up, float)
    Z = upv - X * (upv @ X)
    if np.linalg.norm(Z) < 1e-4:
        upv = np.array([0.0, 0.0, 1.0]) if abs(X[2]) < 0.9 else np.array([1.0, 0.0, 0.0])
        Z = upv - X * (upv @ X)
    Z /= np.linalg.norm(Z)
    Y = np.cross(Z, X)
    return (p0 + p1) * 0.5, X, Y, Z, L


# --------------------------------------------------------------------------------------------
# batches
# --------------------------------------------------------------------------------------------

class Batch:
    """Accumulates pieces into one object. Colours: R cavity, G edge wear, B grime, A wet."""

    def __init__(self, name, shadows=True):
        self.name = name
        self.shadows = shadows
        self.v = []
        self.f = []
        self.fm = []
        self.fs = []
        self.c = []
        self.uv = []
        self.has_uv = False
        self.n = 0

    def add(self, verts, faces, mat, cols=None, smooth=True, uvs=None):
        verts = np.asarray(verts, float)
        k = len(verts)
        if cols is None:
            cols = np.tile([1.0, 0.0, 0.0, 0.0], (k, 1))
        if uvs is not None:
            self.has_uv = True
        self.uv.append(np.zeros((k, 2)) if uvs is None else np.asarray(uvs, float))
        self.v.append(verts)
        self.c.append(np.asarray(cols, float))
        for fc in faces:
            self.f.append([int(i) + self.n for i in fc])
        self.fm.extend([mat] * len(faces))
        self.fs.extend([smooth] * len(faces))
        self.n += k

    def build(self, collection, world_pass=None):
        if self.n == 0:
            return None
        v = np.concatenate(self.v)
        c = np.concatenate(self.c)
        if world_pass is not None:
            c = world_pass(v, c)
        vb = g2b(v)
        me = bpy.data.meshes.new(self.name)
        me.from_pydata(vb.tolist(), [], self.f)
        mats = []
        for m in self.fm:
            if m not in mats:
                mats.append(m)
        for m in mats:
            me.materials.append(material(m))
        idx = np.array([mats.index(m) for m in self.fm], dtype=np.int32)
        me.polygons.foreach_set("material_index", idx)
        me.polygons.foreach_set("use_smooth", np.array(self.fs, dtype=bool))
        attr = me.color_attributes.new("Color", "FLOAT_COLOR", "POINT")
        attr.data.foreach_set("color", np.clip(c, 0.0, 1.0).astype(np.float32).ravel())
        me.color_attributes.active_color = attr
        if self.has_uv:
            uv = np.concatenate(self.uv)
            lay = me.uv_layers.new(name="UVMap")
            vi = np.zeros(len(me.loops), dtype=np.int32)
            me.loops.foreach_get("vertex_index", vi)
            lay.data.foreach_set("uv", uv[vi].astype(np.float32).ravel())
        me.validate()
        me.update()
        ob = bpy.data.objects.new(self.name, me)
        collection.objects.link(ob)
        return ob


# --------------------------------------------------------------------------------------------
# materials
# --------------------------------------------------------------------------------------------

PALETTE = {
    # name: (base colour (linear), roughness, metallic)
    "COL_pewter": ((0.30, 0.30, 0.31), 0.58, 0.55),
    "COL_iron": ((0.09, 0.085, 0.085), 0.6, 0.7),
    "COL_brass": ((0.55, 0.36, 0.12), 0.35, 0.9),
    "COL_glass_green": ((0.03, 0.12, 0.05), 0.08, 0.0),
    "COL_glass_brown": ((0.12, 0.05, 0.015), 0.08, 0.0),
    "COL_glass_clear": ((0.32, 0.38, 0.36), 0.06, 0.0),
    "COL_wax": ((0.82, 0.72, 0.52), 0.55, 0.0),
    "COL_rope": ((0.36, 0.27, 0.15), 0.9, 0.0),
    "COL_burlap": ((0.34, 0.25, 0.14), 0.95, 0.0),
    "COL_cloth_red": ((0.32, 0.05, 0.04), 0.9, 0.0),
    "COL_cloth_blue": ((0.06, 0.09, 0.18), 0.9, 0.0),
    "COL_cloth_cream": ((0.55, 0.48, 0.36), 0.9, 0.0),
    "COL_ale": ((0.32, 0.16, 0.03), 0.1, 0.0),
    "COL_foam": ((0.8, 0.72, 0.55), 0.6, 0.0),
    "COL_bread": ((0.48, 0.25, 0.08), 0.75, 0.0),
    "COL_cheese": ((0.7, 0.48, 0.12), 0.5, 0.0),
    "COL_meat": ((0.35, 0.1, 0.05), 0.5, 0.0),
    "COL_straw": ((0.55, 0.42, 0.18), 0.9, 0.0),
    "COL_soot": ((0.02, 0.018, 0.016), 0.95, 0.0),
    "COL_ember": ((0.9, 0.25, 0.04), 0.9, 0.0),
    "COL_ash": ((0.16, 0.15, 0.14), 0.95, 0.0),
    "COL_coal_hole": ((0.01, 0.008, 0.008), 1.0, 0.0),
    "COL_water": ((0.02, 0.03, 0.05), 0.04, 0.0),
    "COL_sky": ((0.03, 0.04, 0.09), 1.0, 0.0),
    "COL_fish": ((0.35, 0.38, 0.40), 0.35, 0.3),
    "COL_blood": ((0.05, 0.004, 0.006), 0.08, 0.0),
    "COL_onion": ((0.45, 0.25, 0.08), 0.6, 0.0),
    "COL_rope_fg": ((0.05, 0.04, 0.03), 0.95, 0.0),
    "COL_herb_fg": ((0.03, 0.045, 0.015), 0.95, 0.0),
    "COL_herb": ((0.10, 0.13, 0.04), 0.9, 0.0),
    "COL_far_house": ((0.012, 0.014, 0.025), 1.0, 0.0),
    "EMIT_lamp": ((1.0, 0.62, 0.3), 0.5, 0.0),
    "EMIT_cellar": ((1.0, 0.6, 0.3), 0.6, 0.0),
    "EMIT_far_window": ((1.0, 0.6, 0.28), 0.5, 0.0),
    "GLASS": ((0.2, 0.26, 0.3), 0.05, 0.0),
}


def material(name):
    m = bpy.data.materials.get(name)
    if m is not None:
        return m
    m = bpy.data.materials.new(name)
    m.use_nodes = True
    bsdf = m.node_tree.nodes.get("Principled BSDF")
    col, rough, metal = PALETTE.get(name, ((0.5, 0.5, 0.5), 0.8, 0.0))
    if bsdf is not None:
        bsdf.inputs["Base Color"].default_value = (col[0], col[1], col[2], 1.0)
        bsdf.inputs["Roughness"].default_value = rough
        bsdf.inputs["Metallic"].default_value = metal
    m.diffuse_color = (col[0], col[1], col[2], 1.0)
    return m


# --------------------------------------------------------------------------------------------
# pieces
# --------------------------------------------------------------------------------------------

def _place(v, origin, X, Y, Z):
    return origin + v[:, 0:1] * X + v[:, 1:2] * Y + v[:, 2:3] * Z


def timber(batch, p0, p1, w, h, up=(0.0, 1.0, 0.0), seed=0, r=0.028, chips=1.0, sag=0.0,
           wobble=0.006, twist=1.5, swell=0.03, mat="TRI_timber", step=0.09, step_x=0.2,
           end_rough=0.012):
    """Hewn timber member from p0 to p1 (Godot coords), section w (Y) x h (Z)."""
    rng = np.random.default_rng(seed)
    origin, X, Y, Z, L = frame(p0, p1, up)
    v, q, nrm = rbox(L * 0.5, w * 0.5, h * 0.5, r, step, step_x)
    x = v[:, 0]
    t = x / L + 0.5
    hy, hz = w * 0.5, h * 0.5
    ay = np.abs(v[:, 1])
    az = np.abs(v[:, 2])
    ey = smoothstep(hy - 2.6 * r, hy - 0.2 * r, ay)
    ez = smoothstep(hz - 2.6 * r, hz - 0.2 * r, az)
    edge = ey * ez
    cav = np.zeros(len(v))
    # edge chips: notches along the 4 long edges
    for sy in (-1.0, 1.0):
        for sz in (-1.0, 1.0):
            sel = (np.sign(v[:, 1]) == sy) & (np.sign(v[:, 2]) == sz)
            n_chips = rng.poisson(max(0.0, L * 1.6 * chips))
            for _ in range(n_chips):
                uc = rng.uniform(-L * 0.5, L * 0.5)
                hl = rng.uniform(0.025, 0.11)
                depth = rng.uniform(0.008, 0.03) * chips
                prof = smoothstep(1.0, 0.55, np.abs(x - uc) / hl)
                reach = rng.uniform(1.8, 3.2) * r + depth
                cy = smoothstep(hy - reach, hy, ay)
                cz = smoothstep(hz - reach, hz, az)
                d = depth * prof * cy * cz * sel
                v[:, 1] -= sy * d * 0.75
                v[:, 2] -= sz * d * 0.75
                cav = np.maximum(cav, d / 0.03)
    # end damage
    for se in (-1.0, 1.0):
        near = smoothstep(0.06, 0.0, L * 0.5 - se * x)
        v[:, 0] += -se * near * end_rough * (0.5 + 0.5 * noise1(v[:, 1] * 40 + v[:, 2] * 31, rng))
    # adze undulation along the faces
    und = 0.0035 * noise1(x * 7.0 + 3.0 * np.sign(v[:, 1]) + 5.0 * np.sign(v[:, 2]), rng, 3)
    v += nrm * und[:, None]
    # swell, twist, sag, wobble
    s = 1.0 + swell * noise1(x * 1.3, rng, 2)
    v[:, 1] *= s
    v[:, 2] *= s
    a = math.radians(twist) * (2.0 * t - 1.0) * rng.uniform(-1, 1)
    cy_, sy_ = np.cos(a), np.sin(a)
    y2 = v[:, 1] * cy_ - v[:, 2] * sy_
    z2 = v[:, 1] * sy_ + v[:, 2] * cy_
    v[:, 1], v[:, 2] = y2, z2
    v[:, 2] -= sag * np.sin(np.pi * t)
    v[:, 1] += wobble * noise1(x * 0.9, rng, 2)
    v[:, 2] += wobble * 0.6 * noise1(x * 0.8 + 11.0, rng, 2)
    wv = _place(v, origin, X, Y, Z)
    wear = np.clip(edge * (0.55 + 0.45 * noise1(x * 9.0 + v[:, 1] * 13.0, rng, 2)) - cav * 0.6, 0.0, 1.0)
    shade = 1.0 - 0.35 * np.clip(cav, 0, 1) - 0.12 * np.clip(-nrm[:, 2], 0.0, 1.0)
    cols = np.stack([shade, wear, np.zeros(len(v)), np.zeros(len(v))], axis=1)
    batch.add(wv, q.tolist(), mat, cols)
    return wv


def board(batch, p0, p1, w, t, up=(0.0, 1.0, 0.0), seed=0, mat="TRI_planks", chips=0.5, sag=0.0, r=0.012, step=0.09,
          step_x=0.2):
    """A sawn board (thinner, crisper)."""
    return timber(batch, p0, p1, w, t, up, seed, r=r, chips=chips, sag=sag, wobble=0.003, twist=1.0,
                  swell=0.01, mat=mat, step=step, step_x=step_x, end_rough=0.006)


def stone(batch, center, size, yaw=0.0, seed=0, r=None, lump=0.012, mat="TRI_stone", tilt=(0.0, 0.0)):
    """Chunky stone block: rounded box + lumpy displacement. size = full (x, y, z)."""
    rng = np.random.default_rng(seed)
    sx, sy, sz = size
    rr = r if r is not None else min(size) * 0.22
    st = [float(np.clip(d * 0.3, 0.05, 0.14)) for d in size]
    v, q, nrm = rbox(sx * 0.5, sy * 0.5, sz * 0.5, rr, step=st[1], step_x=st[0], step_y=st[1], step_z=st[2])
    n = noise3(v + rng.normal(size=3) * 5.0, seed=seed, scale=4.0)
    v += nrm * (n * lump)[:, None]
    # random facet flattening
    v *= 1.0 + 0.04 * noise3(v, seed + 1, 2.0)[:, None]
    a = math.radians(yaw)
    rot = np.array([[math.cos(a), 0, math.sin(a)], [0, 1, 0], [-math.sin(a), 0, math.cos(a)]])
    tx, tz = math.radians(tilt[0]), math.radians(tilt[1])
    rx = np.array([[1, 0, 0], [0, math.cos(tx), -math.sin(tx)], [0, math.sin(tx), math.cos(tx)]])
    rz = np.array([[math.cos(tz), -math.sin(tz), 0], [math.sin(tz), math.cos(tz), 0], [0, 0, 1]])
    v = v @ (rot @ rx @ rz).T + np.asarray(center, float)
    edge = np.clip(1.0 - np.abs(nrm).max(axis=1) * 1.0 + 0.3, 0, 1)
    shade = 0.82 + 0.18 * (0.5 + 0.5 * n)
    cols = np.stack([shade, edge * 0.6, np.zeros(len(v)), np.zeros(len(v))], axis=1)
    batch.add(v, q.tolist(), mat, cols)
    return v


def panel(batch, origin, U, V, N, w, h, depth=0.08, seed=0, mat="TRI_plaster", bulge=0.012, step=0.07,
          border_dark=0.35):
    """Plaster infill: front face displaced (bulge + lumps), flat back, closed edges.
    origin = lower-left corner of the FRONT face; U, V in-plane axes; N outward (toward viewer)."""
    rng = np.random.default_rng(seed)
    U = np.asarray(U, float)
    V = np.asarray(V, float)
    N = np.asarray(N, float)
    origin = np.asarray(origin, float)
    nu = max(2, int(round(w / step)))
    nv = max(2, int(round(h / step)))
    us = np.linspace(0, w, nu + 1)
    vs = np.linspace(0, h, nv + 1)
    uu, vv = np.meshgrid(us, vs, indexing="ij")
    uu = uu.ravel()
    vv = vv.ravel()
    b = np.minimum(np.minimum(uu, w - uu), np.minimum(vv, h - vv))
    ph = rng.random(4) * 6.283
    disp = bulge * np.sin(np.pi * uu / w) * np.sin(np.pi * vv / h)
    disp += 0.004 * np.sin(uu * 9.1 + ph[0]) * np.sin(vv * 7.3 + ph[1])
    disp += 0.0025 * np.sin(uu * 23.0 + vv * 5.0 + ph[2])
    disp *= smoothstep(0.0, 0.05, b)
    front = origin + uu[:, None] * U + vv[:, None] * V + disp[:, None] * N
    quads = []
    for i in range(nu):
        for j in range(nv):
            a = i * (nv + 1) + j
            quads.append([a, a + nv + 1, a + nv + 2, a + 1])
    # orientation: U x V should equal N
    if np.dot(np.cross(U, V), N) < 0:
        quads = [qq[::-1] for qq in quads]
    shade = 1.0 - border_dark * np.exp(-b / 0.07) - 0.08 * (0.5 + 0.5 * np.sin(uu * 3.0 + vv * 2.0 + ph[3]))
    cols = np.stack([shade, np.zeros_like(shade), np.zeros_like(shade), np.zeros_like(shade)], axis=1)
    batch.add(front, quads, mat, cols)
    # back slab (flat, closed) so it casts shadows from outside
    bo = origin - N * depth
    corners = [bo, bo + U * w, bo + U * w + V * h, bo + V * h]
    fo = [origin, origin + U * w, origin + U * w + V * h, origin + V * h]
    vb = np.array(corners + fo)
    faces = [[3, 2, 1, 0], [0, 1, 5, 4], [1, 2, 6, 5], [2, 3, 7, 6], [3, 0, 4, 7]]
    if np.dot(np.cross(U, V), N) < 0:
        faces = [ff[::-1] for ff in faces]
    batch.add(vb, faces, mat, np.tile([0.6, 0, 0, 0], (8, 1)), smooth=False)


def tube(batch, pts, radius, sides=6, mat="COL_rope", closed=False, twist_bumps=0.0, seed=0, cols=None):
    """Swept tube along a polyline (Godot coords)."""
    pts = np.asarray(pts, float)
    n = len(pts)
    rad = np.broadcast_to(np.asarray(radius, float), (n,)).copy()
    tang = np.gradient(pts, axis=0)
    tang /= np.linalg.norm(tang, axis=1, keepdims=True) + 1e-9
    ref = np.array([0.0, 1.0, 0.0]) if abs(tang[0][1]) < 0.9 else np.array([1.0, 0.0, 0.0])
    nrm = np.cross(tang[0], ref)
    nrm /= np.linalg.norm(nrm)
    verts = []
    for i in range(n):
        tng = tang[i]
        nrm = nrm - tng * (nrm @ tng)
        nrm /= np.linalg.norm(nrm) + 1e-9
        bin_ = np.cross(tng, nrm)
        for s in range(sides):
            a = 2 * math.pi * s / sides
            rr = rad[i] * (1.0 + twist_bumps * math.sin(a * 3 + i * 1.7))
            verts.append(pts[i] + (math.cos(a) * nrm + math.sin(a) * bin_) * rr)
    faces = []
    for i in range(n - 1 if not closed else n):
        i2 = (i + 1) % n
        for s in range(sides):
            s2 = (s + 1) % sides
            faces.append([i * sides + s, i * sides + s2, i2 * sides + s2, i2 * sides + s])
    if not closed:
        faces.append(list(range(sides))[::-1])
        faces.append([(n - 1) * sides + s for s in range(sides)])
    vv = np.array(verts)
    if cols is None:
        cols = np.tile([1.0, 0.2, 0.0, 0.0], (len(vv), 1))
    batch.add(vv, faces, mat, cols)
    return vv


def lathe(batch, profile, center, sides=16, mat="COL_pewter", yaw=0.0, tilt=None, cap_top=True, cap_bottom=True,
          cols_fn=None):
    """Surface of revolution. profile: list of (radius, height) bottom->top (Godot y up)."""
    prof = np.asarray(profile, float)
    verts = []
    for (r, y) in prof:
        for s in range(sides):
            a = 2 * math.pi * s / sides + math.radians(yaw)
            verts.append([math.cos(a) * r, y, math.sin(a) * r])
    faces = []
    m = len(prof)
    for i in range(m - 1):
        for s in range(sides):
            s2 = (s + 1) % sides
            faces.append([i * sides + s, (i + 1) * sides + s, (i + 1) * sides + s2, i * sides + s2])
    vv = np.array(verts)
    if cap_bottom:
        faces.append([s for s in range(sides)])
    if cap_top:
        faces.append([(m - 1) * sides + s for s in range(sides)][::-1])
    if tilt is not None:
        vv = vv @ np.asarray(tilt, float).T
    vv = vv + np.asarray(center, float)
    cols = np.tile([1.0, 0.3, 0.0, 0.0], (len(vv), 1)) if cols_fn is None else cols_fn(vv)
    batch.add(vv, faces, mat, cols)
    return vv


def quad_poly(batch, pts, mat, col=(1.0, 0.0, 0.0, 0.0), smooth=False):
    pts = np.asarray(pts, float)
    batch.add(pts, [list(range(len(pts)))], mat, np.tile(col, (len(pts), 1)), smooth=smooth)


def rot_y(deg):
    a = math.radians(deg)
    return np.array([[math.cos(a), 0, math.sin(a)], [0, 1, 0], [-math.sin(a), 0, math.cos(a)]])


def rot_x(deg):
    a = math.radians(deg)
    return np.array([[1, 0, 0], [0, math.cos(a), -math.sin(a)], [0, math.sin(a), math.cos(a)]])


def rot_z(deg):
    a = math.radians(deg)
    return np.array([[math.cos(a), -math.sin(a), 0], [math.sin(a), math.cos(a), 0], [0, 0, 1]])


# --------------------------------------------------------------------------------------------
# Poly Haven models
# --------------------------------------------------------------------------------------------

_PH_CACHE = {}


def ph_model(path_gltf, name, target_tris, holding):
    """Import a Poly Haven glTF once, join it into one object, decimate, keep it unlinked in
    `holding` collection (excluded from export). Returns the source object."""
    if name in _PH_CACHE:
        return _PH_CACHE[name]
    before = set(bpy.data.objects)
    bpy.ops.import_scene.gltf(filepath=str(path_gltf))
    new = [o for o in bpy.data.objects if o not in before]
    meshes = [o for o in new if o.type == "MESH"]
    others = [o for o in new if o.type != "MESH"]
    for o in new:
        if o.type != "MESH":
            continue
    bpy.ops.object.select_all(action="DESELECT")
    for o in meshes:
        o.select_set(True)
    bpy.context.view_layer.objects.active = meshes[0]
    # apply parent transforms
    for o in meshes:
        mw = o.matrix_world.copy()
        o.parent = None
        o.matrix_world = mw
    bpy.ops.object.transform_apply(location=True, rotation=True, scale=True)
    if len(meshes) > 1:
        bpy.ops.object.join()
    ob = bpy.context.view_layer.objects.active
    ob.name = "PH_" + name
    ob.data.name = "PH_" + name
    for o in others:
        bpy.data.objects.remove(o, do_unlink=True)
    tris = sum(len(p.vertices) - 2 for p in ob.data.polygons)
    if tris > target_tris:
        mod = ob.modifiers.new("dec", "DECIMATE")
        mod.ratio = max(0.01, target_tris / tris)
        bpy.ops.object.modifier_apply(modifier="dec")
    for c in list(ob.users_collection):
        c.objects.unlink(ob)
    holding.objects.link(ob)
    _PH_CACHE[name] = ob
    return ob


def ph_place(src, collection, pos, yaw=0.0, scale=1.0, tilt=(0.0, 0.0), name=None):
    """Linked duplicate of a PH source object at a Godot position / yaw (degrees)."""
    o = src.copy()
    o.data = src.data
    o.name = name or src.name
    o.location = tuple(g2b(pos))
    # Godot yaw about +Y == Blender rotation about +Z; tilt = (x, z) in Godot -> Blender (x, -y)
    o.rotation_mode = "XYZ"
    o.rotation_euler = (math.radians(tilt[0]), math.radians(-tilt[1]), math.radians(yaw))
    s = scale if isinstance(scale, (tuple, list)) else (scale, scale, scale)
    o.scale = s
    collection.objects.link(o)
    return o
