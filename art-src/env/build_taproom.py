"""Build the Drowned Rat taproom set (A10) in Blender and export it for the Godot HD-2D spike.

Usage:
  "C:\\Program Files\\Blender Foundation\\Blender 5.3\\blender.exe" --background --python art-src/env/build_taproom.py
  (set TAPROOM_SKIP_PROPS=1 to skip the Poly Haven props while iterating on the architecture)

Outputs (game/spikes/hd2d/models/env/):
  taproom_arch.glb   bespoke geometry (walls, hearth, bar, stairs, trapdoor, beams, clutter,
                     the dock outside), vertex colours = cavity / edge wear / grime / wet
  taproom_props.glb  Poly Haven CC0 models (decimated, linked duplicates, own textures)
  taproom_anchors.json  light / flame / shaft anchors for the Godot scene (Godot coordinates)

Coordinates: everything is authored in Godot space (x right/west, y up, z toward the camera =
north). The camera looks south. Room: x -8..8, z -5.5..5.5. Front door in the far (south) wall
at x 0.4..2.0; hearth on the east wall (x = -8); bar along the north side; stairs NE; snug SW.
"""
import json
import math
import os
import sys
from pathlib import Path

import bpy
import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
import envlib as E  # noqa: E402

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "game/spikes/hd2d/models/env"
PH = ROOT / "game/spikes/hd2d/models/ph_src"
SKIP_PROPS = os.environ.get("TAPROOM_SKIP_PROPS", "") == "1"

W, D, H = 8.0, 5.5, 3.2
WALL_T = 0.26           # timber section depth
PLINTH = 0.40           # stone footing height
SOLE = (0.40, 0.62)     # sole plate y range
MID = (1.95, 2.15)      # mid rail / window head y range
TOP = (2.90, 3.20)

anchors = {"hearth": [], "candles": [], "lanterns": [], "windows": [], "door": [], "trapdoor": [],
           "dock": [], "embers": [], "far_lights": [], "wall_lamps": []}

E.material("TRI_timber")  # ensure exists early


def reset():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    s = bpy.data.collections.new("SET")
    bpy.context.scene.collection.children.link(s)
    hold = bpy.data.collections.new("HOLD")
    bpy.context.scene.collection.children.link(hold)
    p = bpy.data.collections.new("PROPS")
    bpy.context.scene.collection.children.link(p)
    return s, hold, p


SET, HOLD, PROPS = reset()
B = {}


def batch(name, shadows=True):
    if name not in B:
        B[name] = E.Batch(name, shadows)
    return B[name]


rng = np.random.default_rng(1234)


def seed():
    return int(rng.integers(0, 1_000_000))


# ============================================================================================
# walls
# ============================================================================================

def plinth_run(b, a, c, inward, z_line, courses=((0.0, 0.22), (0.2, 0.42)), depth=0.40, along="x"):
    """Stone footing from a to c along x or z. inward: +1/-1 unit direction of the room side."""
    for (y0, y1) in courses:
        pos = a + rng.uniform(-0.2, 0.0)
        while pos < c - 0.05:
            ln = rng.uniform(0.32, 0.62)
            end = min(pos + ln, c)
            if end - pos < 0.14:
                break
            mid = (pos + end) * 0.5
            hgt = (y1 - y0) * rng.uniform(0.92, 1.05)
            dep = depth * rng.uniform(0.9, 1.05)
            off = z_line + inward * (dep * 0.5 - 0.12 + rng.uniform(-0.015, 0.02))
            if along == "x":
                ctr = (mid, y0 + hgt * 0.5, off)
                size = (end - pos - 0.03, hgt, dep)
            else:
                ctr = (off, y0 + hgt * 0.5, mid)
                size = (dep, hgt, end - pos - 0.03)
            E.stone(b, ctr, size, yaw=rng.uniform(-2, 2), seed=seed(), lump=0.01, r=0.045)
            pos = end + 0.02


def far_wall():
    """South wall, z = -D. Inner timber faces at z ~= -D."""
    b = batch("wall_south")
    zc = -D - WALL_T * 0.5
    zf = zc + WALL_T * 0.5          # inner face of the timbers
    posts = [-7.9, -6.3, -4.2, -2.9, -0.9, 0.27, 2.13, 3.5, 5.6, 7.9]
    bays = ["brace_r", "window", "plain", "window", "brace_l", "door", "brace_r", "window_barred", "brace_l"]
    # plinth (gap at the door)
    plinth_run(b, -8.1, 0.14, 1.0, zc, along="x")
    plinth_run(b, 2.26, 8.1, 1.0, zc, along="x")
    # threshold stone
    E.stone(b, (1.2, 0.03, zc + 0.05), (1.9, 0.1, 0.5), seed=seed(), r=0.03, lump=0.006)
    # sole plates
    E.timber(b, (-8.05, 0.51, zc), (0.27, 0.51, zc), 0.3, 0.22, seed=seed(), sag=0.004)
    E.timber(b, (2.13, 0.51, zc), (8.05, 0.51, zc), 0.3, 0.22, seed=seed(), sag=0.004)
    # top plate (mostly off-screen but closes the shadow volume)
    E.timber(b, (-8.1, 3.05, zc), (8.1, 3.05, zc), 0.32, 0.3, seed=seed(), sag=0.03)
    for i, x in enumerate(posts):
        y0 = 0.0 if x in (0.27, 2.13) else SOLE[1]
        E.timber(b, (x, y0, zc), (x, TOP[0], zc), 0.27, WALL_T, up=(0, 0, 1), seed=seed(), wobble=0.008)
    for i, kind in enumerate(bays):
        x0, x1 = posts[i] + 0.135, posts[i + 1] - 0.135
        wdt = x1 - x0
        if kind == "door":
            # lintel + plaster over the door
            E.timber(b, (x0 - 0.2, 2.36, zc), (x1 + 0.2, 2.36, zc), WALL_T + 0.04, 0.26, seed=seed(), sag=0.012, chips=1.6)
            E.panel(b, (x0, 2.49, zf - 0.05), (1, 0, 0), (0, 1, 0), (0, 0, 1), wdt, TOP[0] - 2.49, seed=seed())
            anchors["door"].append({"x0": x0, "x1": x1, "y1": 2.23, "z": zf})
            continue
        # mid rail / window head
        E.timber(b, (x0 - 0.02, (MID[0] + MID[1]) * 0.5, zc), (x1 + 0.02, (MID[0] + MID[1]) * 0.5, zc), 0.22, WALL_T - 0.02,
                 seed=seed(), sag=0.01)
        # upper panel
        E.panel(b, (x0, MID[1], zf - 0.05), (1, 0, 0), (0, 1, 0), (0, 0, 1), wdt, TOP[0] - MID[1], seed=seed())
        # upper short stud in wide bays
        if wdt > 1.5:
            xm = (x0 + x1) * 0.5
            E.timber(b, (xm, MID[1], zc), (xm, TOP[0], zc), 0.18, WALL_T - 0.03, up=(0, 0, 1), seed=seed())
        if kind.startswith("window"):
            window(b, x0, x1, zc, zf, barred=(kind == "window_barred"))
        else:
            E.panel(b, (x0, SOLE[1], zf - 0.05), (1, 0, 0), (0, 1, 0), (0, 0, 1), wdt, MID[0] - SOLE[1], seed=seed())
            if kind.startswith("brace"):
                if kind == "brace_r":
                    p0, p1 = (x0 + 0.05, SOLE[1] + 0.05, zc + 0.02), (x1 - 0.05, MID[0] - 0.05, zc + 0.02)
                else:
                    p0, p1 = (x1 - 0.05, SOLE[1] + 0.05, zc + 0.02), (x0 + 0.05, MID[0] - 0.05, zc + 0.02)
                E.timber(b, p0, p1, 0.17, WALL_T - 0.05, up=(0, 0, 1), seed=seed(), chips=0.8)
    # far-wall dressing: a hanging lantern bracket on two posts
    for x in (-4.2, 3.5):
        wall_lamp(b, (x, 1.72, zf + 0.02), facing=(0, 0, 1))


def window(b, x0, x1, zc, zf, barred=False):
    sill_y = (0.80, 0.96)
    head_y = MID[0]
    E.timber(b, (x0 - 0.04, (sill_y[0] + sill_y[1]) * 0.5, zc + 0.02), (x1 + 0.04, (sill_y[0] + sill_y[1]) * 0.5, zc + 0.02),
             0.16, WALL_T + 0.06, seed=seed(), chips=1.4)
    E.panel(b, (x0, SOLE[1], zf - 0.05), (1, 0, 0), (0, 1, 0), (0, 0, 1), x1 - x0, sill_y[0] - SOLE[1], seed=seed())
    wdt = x1 - x0
    # two mullions + a transom: three tall lights
    for k in (1, 2):
        xm = x0 + wdt * k / 3.0
        E.timber(b, (xm, sill_y[1], zc), (xm, head_y, zc), 0.085, 0.12, up=(0, 0, 1), seed=seed(), r=0.015, chips=0.4,
                 step=0.03, step_x=0.08)
    ty = sill_y[1] + (head_y - sill_y[1]) * 0.68
    E.timber(b, (x0, ty, zc), (x1, ty, zc), 0.075, 0.11, seed=seed(), r=0.015, chips=0.3, step=0.03, step_x=0.08)
    g = batch("glass", shadows=False)
    lights = []
    for k in range(3):
        lx0 = x0 + wdt * k / 3.0 + 0.045
        lx1 = x0 + wdt * (k + 1) / 3.0 - 0.045
        lights.append((lx0, lx1))
    for k, (lx0, lx1) in enumerate(lights):
        open_light = (k == 1 and not barred)
        for (ly0, ly1) in ((sill_y[1], ty - 0.04), (ty + 0.04, head_y)):
            if open_light and ly0 < ty:
                # casement leaf swung into the room on its left hinge
                leaf(b, g, lx0, lx1, ly0, ly1, zf, 68.0)
                continue
            glass_pane(g, lx0, lx1, ly0, ly1, zc + 0.01)
    if barred:
        bi = batch("iron")
        for k in range(7):
            xb = x0 + 0.1 + (wdt - 0.2) * k / 6.0
            E.timber(bi, (xb, sill_y[1], zf + 0.05), (xb, head_y, zf + 0.05), 0.035, 0.035, up=(0, 0, 1), seed=seed(),
                     r=0.012, chips=0.0, mat="TRI_iron", step=0.015, step_x=0.1, twist=0, swell=0)
        # half-closed inner shutter on the right light
        sh = batch("wall_south")
        for j in range(4):
            sx = lights[2][0] - 0.02 + j * (lights[2][1] - lights[2][0] + 0.04) / 4.0 + 0.04
            E.board(sh, (sx, sill_y[1] + 0.02, zf + 0.12), (sx, head_y - 0.03, zf + 0.12), 0.11, 0.035, up=(0, 0, 1),
                    seed=seed())
    anchors["windows"].append({"x0": x0, "x1": x1, "y0": sill_y[1], "y1": head_y, "z": zf, "barred": barred,
                               "normal": [0, 0, 1]})


def glass_pane(g, x0, x1, y0, y1, z, axis="z"):
    nx, ny = 4, 5
    verts = []
    for i in range(nx + 1):
        for j in range(ny + 1):
            u = x0 + (x1 - x0) * i / nx
            v = y0 + (y1 - y0) * j / ny
            wob = 0.006 * math.sin(u * 37.0 + v * 23.0) + 0.004 * math.sin(v * 51.0)
            verts.append((u, v, z + wob) if axis == "z" else (z + wob, v, u))
    faces = []
    for i in range(nx):
        for j in range(ny):
            a = i * (ny + 1) + j
            faces.append([a, a + ny + 1, a + ny + 2, a + 1] if axis == "z" else [a, a + 1, a + ny + 2, a + ny + 1])
    g.add(np.array(verts), faces, "GLASS", np.tile([1, 0, 0, 0], (len(verts), 1)))


def leaf(b, g, x0, x1, y0, y1, zf, angle):
    """Open casement: frame + glass, hinged at x0, swung `angle` deg into the room."""
    wdt = x1 - x0
    a = math.radians(angle)
    dirv = np.array([math.cos(a), 0, math.sin(a)])
    hinge = np.array([x0, 0, zf + 0.03])

    def P(u, y):
        p = hinge + dirv * u
        return (p[0], y, p[2])

    E.board(b, P(0.0, y0), P(0.0, y1), 0.05, 0.04, up=(dirv[2], 0, -dirv[0]), seed=seed(), mat="TRI_timber_dark")
    E.board(b, P(wdt, y0), P(wdt, y1), 0.05, 0.04, up=(dirv[2], 0, -dirv[0]), seed=seed(), mat="TRI_timber_dark")
    E.board(b, P(0.0, y0), P(wdt, y0), 0.05, 0.04, seed=seed(), mat="TRI_timber_dark")
    E.board(b, P(0.0, y1), P(wdt, y1), 0.05, 0.04, seed=seed(), mat="TRI_timber_dark")
    E.board(b, P(0.0, (y0 + y1) * 0.5), P(wdt, (y0 + y1) * 0.5), 0.03, 0.03, seed=seed(), mat="TRI_timber_dark")
    verts = [P(0.02, y0 + 0.02), P(wdt - 0.02, y0 + 0.02), P(wdt - 0.02, y1 - 0.02), P(0.02, y1 - 0.02)]
    g.add(np.array(verts), [[0, 1, 2, 3]], "GLASS", np.tile([1, 0, 0, 0], (4, 1)))


def wall_lamp(b, pos, facing):
    """Iron bracket + hanging lantern (light anchor)."""
    bi = batch("iron")
    p = np.array(pos)
    f = np.array(facing, float)
    E.timber(bi, p, p + f * 0.32, 0.03, 0.03, seed=seed(), r=0.01, mat="TRI_iron", chips=0, step=0.012, step_x=0.05)
    E.timber(bi, p - np.array([0, 0.18, 0]), p + f * 0.26, 0.025, 0.025, seed=seed(), r=0.008, mat="TRI_iron", chips=0,
             step=0.01, step_x=0.05)
    lp = p + f * 0.3 - np.array([0, 0.22, 0])
    lantern_geo(lp, register=False)
    anchors["wall_lamps"].append({"pos": [float(v) for v in lp]})


def lantern_geo(center, scale=1.0, register=True):
    """Bespoke iron lantern: cage, glass, cap, ring; flame anchor at centre."""
    bi = batch("iron")
    c = np.array(center, float)
    s = scale
    E.lathe(bi, [(0.0, 0.17 * s), (0.04 * s, 0.17 * s), (0.11 * s, 0.11 * s), (0.11 * s, 0.09 * s)], c, sides=4, mat="COL_iron",
            yaw=45)
    E.lathe(bi, [(0.09 * s, -0.12 * s), (0.09 * s, -0.10 * s), (0.05 * s, -0.10 * s)], c, sides=4, mat="COL_iron", yaw=45)
    for k in range(4):
        a = math.radians(45 + 90 * k)
        q = c + np.array([math.cos(a) * 0.085 * s, 0, math.sin(a) * 0.085 * s])
        E.tube(bi, [q + np.array([0, -0.11 * s, 0]), q + np.array([0, 0.1 * s, 0])], 0.01 * s, sides=4, mat="COL_iron")
    E.tube(bi, [c + np.array([0, 0.17 * s, 0]) + np.array([math.cos(t) * 0.035 * s, 0.035 * s + math.sin(t) * 0.035 * s, 0])
                for t in np.linspace(0, 2 * math.pi, 10)], 0.007 * s, sides=4, mat="COL_iron")
    g = batch("lamp_glass", shadows=False)
    E.lathe(g, [(0.075 * s, -0.1 * s), (0.08 * s, 0.0), (0.075 * s, 0.09 * s)], c, sides=4, mat="EMIT_lamp", yaw=45,
            cap_top=False, cap_bottom=False)
    if register:
        anchors["lanterns"].append({"pos": [float(v) for v in c], "scale": s})


def side_wall(x_line, inward, features):
    """East (x=-8, inward=+1) or west (x=+8, inward=-1) wall along z."""
    name = "wall_east" if inward > 0 else "wall_west"
    b = batch(name)
    xc = x_line - inward * WALL_T * 0.5
    xf = xc + inward * WALL_T * 0.5
    posts = features["posts"]
    bays = features["bays"]
    gaps = features.get("plinth_gaps", [])
    zs = [-D - 0.1] + sorted([g for pair in gaps for g in pair]) + [D + 0.1]
    for k in range(0, len(zs), 2):
        plinth_run(b, zs[k], zs[k + 1], inward, xc, along="z")
    E.timber(b, (xc, 0.51, -D - 0.1), (xc, 0.51, D + 0.1), 0.3, 0.22, up=(0, 1, 0), seed=seed(), sag=0.004)
    E.timber(b, (xc, 3.05, -D - 0.1), (xc, 3.05, D + 0.1), 0.32, 0.3, seed=seed(), sag=0.03)
    for z in posts:
        E.timber(b, (xc, SOLE[1], z), (xc, TOP[0], z), 0.27, WALL_T, up=(1, 0, 0), seed=seed(), wobble=0.008)
    nrm = (inward, 0, 0)
    for i, kind in enumerate(bays):
        z0, z1 = posts[i] + 0.135, posts[i + 1] - 0.135
        if kind == "skip":
            continue
        wdt = z1 - z0
        # panel origin lower-left as seen from the room; U along +z for the east wall (facing +x),
        # along -z for the west wall
        if inward > 0:
            o_low = (xf - 0.05, SOLE[1], z1)
            U = (0, 0, -1)
        else:
            o_low = (xf + 0.05, SOLE[1], z0)
            U = (0, 0, 1)
        E.timber(b, (xc, (MID[0] + MID[1]) * 0.5, z0 - 0.02), (xc, (MID[0] + MID[1]) * 0.5, z1 + 0.02), 0.22, WALL_T - 0.02,
                 up=(0, 1, 0), seed=seed(), sag=0.01)
        o_up = (o_low[0], MID[1], o_low[2])
        E.panel(b, o_up, U, (0, 1, 0), nrm, wdt, TOP[0] - MID[1], seed=seed())
        if kind == "window":
            sill = (0.80, 0.96)
            E.timber(b, (xc + inward * 0.02, 0.88, z0 - 0.04), (xc + inward * 0.02, 0.88, z1 + 0.04), 0.16, WALL_T + 0.06,
                     up=(0, 1, 0), seed=seed())
            E.panel(b, o_low, U, (0, 1, 0), nrm, wdt, sill[0] - SOLE[1], seed=seed())
            g = batch("glass", shadows=False)
            zm = (z0 + z1) * 0.5
            E.timber(b, (xc, sill[1], zm), (xc, MID[0], zm), 0.085, 0.12, up=(1, 0, 0), seed=seed(), r=0.015, chips=0.4,
                     step=0.03, step_x=0.08)
            glass_pane(g, z0 + 0.04, zm - 0.05, sill[1], MID[0], xc, axis="x")
            glass_pane(g, zm + 0.05, z1 - 0.04, sill[1], MID[0], xc, axis="x")
            anchors["windows"].append({"x0": z0, "x1": z1, "y0": sill[1], "y1": MID[0], "x": xf, "axis": "x",
                                       "normal": [inward, 0, 0]})
        else:
            E.panel(b, o_low, U, (0, 1, 0), nrm, wdt, MID[0] - SOLE[1], seed=seed())
            if kind.startswith("brace"):
                a_, c_ = (z0 + 0.05, z1 - 0.05) if kind == "brace_r" else (z1 - 0.05, z0 + 0.05)
                E.timber(b, (xc + inward * 0.02, SOLE[1] + 0.05, a_), (xc + inward * 0.02, MID[0] - 0.05, c_), 0.17,
                         WALL_T - 0.05, up=(1, 0, 0), seed=seed(), chips=0.8)


# ============================================================================================
# hearth (east wall, centred z = 0)
# ============================================================================================

def hearth():
    b = batch("hearth")
    x_wall = -W
    depth = 1.35                      # chimney breast projection into the room
    xf = x_wall + depth               # front face
    fb = x_wall + 0.4                 # firebox reference (internals shifted forward)
    z0, z1 = -1.55, 1.55
    fb_z0, fb_z1 = -0.85, 0.85        # firebox opening
    fb_top = 1.12
    # coursed stones on the breast front
    y = 0.0
    course = 0
    while y < 3.1:
        ch = rng.uniform(0.2, 0.3)
        z = z0 - rng.uniform(0.0, 0.15) * (course % 2)
        while z < z1 - 0.05:
            ln = rng.uniform(0.3, 0.55)
            e = min(z + ln, z1)
            if e - z < 0.12:
                break
            zm = (z + e) * 0.5
            in_box = (fb_z0 - 0.02 < zm < fb_z1 + 0.02) and y < fb_top - 0.05
            if not in_box:
                # arch stones above the opening are bigger and protrude
                prot = 0.03 if (fb_z0 - 0.3 < zm < fb_z1 + 0.3 and fb_top - 0.05 < y < fb_top + 0.35) else 0.0
                E.stone(b, (xf - 0.15 + prot + rng.uniform(-0.01, 0.015), y + ch * 0.5, zm),
                        (0.34, ch - 0.025, e - z - 0.025), yaw=rng.uniform(-2, 2), seed=seed(), lump=0.012, r=0.05)
            z = e + 0.015
        y += ch
        course += 1
    # sides of the breast
    for zs in (z0 - 0.17, z1 + 0.17):
        y = 0.0
        while y < 3.1:
            ch = rng.uniform(0.2, 0.3)
            E.stone(b, (x_wall + depth * 0.5, y + ch * 0.5, zs), (depth - 0.02, ch - 0.02, 0.3), seed=seed(), lump=0.012,
                    r=0.05)
            y += ch
    # firebox: back, sides, floor (soot), hearth slab
    bs = batch("hearth_inner")
    E.stone(bs, (fb + 0.05, 0.6, 0.0), (0.5, 1.2, 1.9), seed=seed(), mat="COL_soot", lump=0.02)
    for zz in (fb_z0 - 0.08, fb_z1 + 0.08):
        E.stone(bs, (fb + 0.5, 0.56, zz), (0.92, 1.12, 0.16), seed=seed(), mat="TRI_stone_dark", lump=0.012)
    E.stone(bs, (fb + 0.45, 1.2, 0.0), (1.0, 0.12, 1.9), seed=seed(), mat="COL_soot", lump=0.01)
    # ash bed + embers
    E.stone(bs, (fb + 0.5, 0.02, 0.0), (0.7, 0.05, 1.5), seed=seed(), mat="COL_ash", lump=0.01, r=0.02)
    for k in range(26):
        E.stone(bs, (fb + rng.uniform(0.3, 0.75), 0.05, rng.uniform(-0.6, 0.6)),
                (rng.uniform(0.04, 0.09), 0.035, rng.uniform(0.04, 0.09)), seed=seed(), mat="COL_ember", lump=0.005)
    # fire dogs + logs
    bi = batch("iron")
    for zz in (-0.45, 0.45):
        E.timber(bi, (fb + 0.25, 0.14, zz), (fb + 0.85, 0.14, zz), 0.05, 0.05, seed=seed(), r=0.015, mat="TRI_iron",
                 chips=0, step=0.02)
        E.timber(bi, (fb + 0.82, 0.0, zz), (fb + 0.82, 0.32, zz), 0.05, 0.05, up=(1, 0, 0), seed=seed(), r=0.015,
                 mat="TRI_iron", chips=0, step=0.02)
    bl = batch("logs")
    for k, (zz, yy, rot) in enumerate([(-0.15, 0.2, -6), (0.2, 0.19, 8), (0.02, 0.33, -2)]):
        a = math.radians(rot)
        p0 = np.array([fb + 0.55 - math.sin(a) * 0.1, yy, zz - math.cos(a) * 0.55])
        p1 = np.array([fb + 0.55 + math.sin(a) * 0.1, yy, zz + math.cos(a) * 0.55])
        E.timber(bl, p0, p1, 0.15, 0.14, seed=seed(), r=0.06, mat="TRI_bark", chips=1.5)
    anchors["hearth"].append({"pos": [fb + 0.55, 0.25, 0.0], "width": 1.5, "front": [xf, 0.6, 0.0]})
    anchors["embers"].append({"pos": [fb + 0.6, 0.9, 0.0], "ext": [0.25, 0.3, 0.7]})
    # mantel beam (big, sagging, charred underside) + corbels
    E.timber(b, (xf + 0.02, fb_top + 0.17, z0 - 0.35), (xf + 0.02, fb_top + 0.17, z1 + 0.35), 0.34, 0.3, up=(0, 1, 0),
             seed=seed(), sag=0.025, chips=2.0, mat="TRI_timber_dark")
    for zz in (z0 - 0.22, z1 + 0.22):
        E.stone(b, (xf + 0.05, fb_top - 0.06, zz), (0.24, 0.18, 0.22), seed=seed(), lump=0.008, r=0.03)
    # mantel shelf board
    E.board(b, (xf + 0.12, fb_top + 0.36, z0 - 0.4), (xf + 0.12, fb_top + 0.36, z1 + 0.4), 0.42, 0.06, seed=seed(),
            mat="TRI_timber")
    mt = fb_top + 0.39
    dress = batch("clutter")
    candle(dress, (xf + 0.12, mt, z0 - 0.15), 0.22, stick=True)
    candle(dress, (xf + 0.12, mt, z1 + 0.15), 0.16, stick=True)
    for k, zz in enumerate([-1.0, -0.62, 0.55, 0.9]):
        bottle(dress, (xf + 0.12 + rng.uniform(-0.05, 0.05), mt, zz), kind=k % 3)
    jug(dress, (xf + 0.1, mt, -0.2))
    tankard(dress, (xf + 0.14, mt, 0.18), yaw=40)
    # pot crane + hanging kettle
    E.timber(bi, (fb + 0.25, 0.4, -0.75), (fb + 0.25, 1.05, -0.75), 0.04, 0.04, up=(1, 0, 0), seed=seed(), r=0.012,
             mat="TRI_iron", chips=0, step=0.015)
    E.timber(bi, (fb + 0.25, 1.0, -0.75), (fb + 0.62, 1.0, -0.1), 0.035, 0.035, seed=seed(), r=0.01, mat="TRI_iron",
             chips=0, step=0.015)
    E.tube(bi, [(fb + 0.6, 1.0, -0.12), (fb + 0.6, 0.72, -0.12)], 0.012, sides=4, mat="COL_iron")
    E.lathe(bi, [(0.0, 0.0), (0.12, 0.02), (0.17, 0.1), (0.18, 0.2), (0.15, 0.3), (0.13, 0.3), (0.13, 0.32)],
            (fb + 0.6, 0.42, -0.12), sides=14, mat="COL_iron")
    # poker leaning on the jamb
    E.tube(bi, [(xf + 0.12, 0.02, fb_z1 + 0.35), (xf + 0.05, 1.0, fb_z1 + 0.2)], 0.016, sides=5, mat="COL_iron")
    E.tube(bi, [(xf + 0.12, 0.02, fb_z1 + 0.35), (xf + 0.2, 0.05, fb_z1 + 0.32)], 0.014, sides=5, mat="COL_iron")
    # hearthstone apron (raised flagstones, irregular)
    bf = batch("flagstones")
    zz = -2.25
    while zz < 2.25:
        rw = rng.uniform(0.45, 0.75)
        xx = xf
        while xx < xf + 1.9:
            ln = rng.uniform(0.45, 0.8)
            e = min(xx + ln, xf + 1.9 + rng.uniform(-0.25, 0.1))
            if e - xx < 0.2:
                break
            E.stone(bf, ((xx + e) * 0.5, 0.012 + rng.uniform(-0.006, 0.008), zz + rw * 0.5),
                    (e - xx - 0.035, 0.05, rw - 0.035), yaw=rng.uniform(-3, 3), seed=seed(), lump=0.006, r=0.018,
                    mat="TRI_flag", tilt=(rng.uniform(-1.2, 1.2), rng.uniform(-1.2, 1.2)))
            xx = e
        zz += rw
    # inside-firebox hearth slab
    E.stone(bf, (fb + 0.55, -0.01, 0.0), (0.85, 0.05, 1.75), seed=seed(), lump=0.004, r=0.02, mat="TRI_stone_dark")
    # stacked firewood beside the hearth
    for k in range(9):
        row = k // 3
        zz = 1.95 + (k % 3) * 0.17 + (row % 2) * 0.08
        yy = 0.09 + row * 0.15
        E.timber(bl, (xf - 0.1, yy, zz), (xf + 0.55, yy, zz + rng.uniform(-0.03, 0.03)), 0.15, 0.14, seed=seed(), r=0.06,
                 mat="TRI_bark", chips=1.0)


# ============================================================================================
# small dressing primitives
# ============================================================================================

def candle(b, base, h=0.16, stick=False, drip=True):
    x, y, z = base
    if stick:
        bi = batch("iron")
        E.lathe(bi, [(0.0, 0.0), (0.07, 0.0), (0.07, 0.015), (0.025, 0.03), (0.018, 0.08), (0.04, 0.1), (0.04, 0.115)],
                (x, y, z), sides=8, mat="COL_brass")
        y += 0.115
    prof = [(0.032, 0.0), (0.033, h * 0.5), (0.03, h * 0.95), (0.022, h)]
    E.lathe(b, prof, (x, y, z), sides=8, mat="COL_wax")
    if drip:
        for k in range(3):
            a = rng.uniform(0, 6.28)
            E.tube(b, [(x + math.cos(a) * 0.033, y + h * rng.uniform(0.6, 0.95), z + math.sin(a) * 0.033),
                       (x + math.cos(a) * 0.036, y + h * rng.uniform(0.15, 0.5), z + math.sin(a) * 0.036)],
                   0.008, sides=4, mat="COL_wax")
    anchors["candles"].append({"pos": [x, y + h + 0.01, z]})


def tankard(b, base, yaw=0.0, wood=False, ale=True):
    x, y, z = base
    s = 1.35
    mat = "TRI_timber" if wood else "COL_pewter"
    E.lathe(b, [(0.0, 0.0), (0.05 * s, 0.0), (0.052 * s, 0.01 * s), (0.046 * s, 0.11 * s), (0.049 * s, 0.12 * s),
                (0.043 * s, 0.12 * s), (0.041 * s, 0.03 * s)], (x, y, z), sides=12, mat=mat, cap_top=False)
    if ale:
        E.lathe(b, [(0.0, 0.1 * s), (0.043 * s, 0.1 * s)], (x, y, z), sides=12, mat="COL_foam", cap_top=False,
                cap_bottom=True)
    a = math.radians(yaw)
    d = np.array([math.cos(a), 0, math.sin(a)])
    pts = [np.array(base) + d * (0.048 * s + 0.035 * s * math.sin(t)) + np.array([0, (0.06 + 0.035 * math.cos(t)) * s, 0])
           for t in np.linspace(0, math.pi, 7)]
    E.tube(b, pts, 0.008 * s, sides=5, mat=mat)


def bottle(b, base, kind=0, s=1.45):
    x, y, z = base
    mats = ["COL_glass_green", "COL_glass_brown", "COL_glass_clear"]
    if kind == 0:
        prof = [(0.0, 0.0), (0.036, 0.0), (0.038, 0.01), (0.037, 0.13), (0.03, 0.16), (0.013, 0.19), (0.012, 0.25),
                (0.015, 0.255), (0.0, 0.26)]
    elif kind == 1:   # squat onion bottle
        prof = [(0.0, 0.0), (0.05, 0.0), (0.06, 0.04), (0.056, 0.08), (0.035, 0.12), (0.014, 0.15), (0.012, 0.2),
                (0.015, 0.205), (0.0, 0.21)]
    else:
        prof = [(0.0, 0.0), (0.03, 0.0), (0.032, 0.1), (0.024, 0.14), (0.011, 0.165), (0.011, 0.22), (0.0, 0.225)]
    prof = [(r * s, h * s) for r, h in prof]
    E.lathe(b, prof, (x, y, z), sides=10, mat=mats[kind % 3], cap_top=False)
    # cork
    E.lathe(b, [(0.009 * s, prof[-2][1]), (0.01 * s, prof[-2][1] + 0.02), (0.0, prof[-2][1] + 0.02)], (x, y, z), sides=6,
            mat="COL_bread", cap_bottom=False)


def jug(b, base, s=1.4):
    x, y, z = base
    prof = [(0.0, 0.0), (0.055, 0.0), (0.075, 0.05), (0.08, 0.1), (0.06, 0.16), (0.035, 0.19), (0.04, 0.21), (0.0, 0.21)]
    E.lathe(b, [(r * s, hh * s) for r, hh in prof], (x, y, z), sides=12, mat="TRI_crock")
    pts = [np.array(base) + np.array([0.07 * s + 0.05 * s * math.sin(t), (0.12 + 0.05 * math.cos(t)) * s, 0])
           for t in np.linspace(0, math.pi, 7)]
    E.tube(b, pts, 0.012 * s, sides=5, mat="TRI_crock")


def plate(b, base, r=0.13, mat="COL_pewter"):
    E.lathe(b, [(0.0, 0.0), (r * 0.7, 0.0), (r, 0.02), (r * 0.95, 0.025), (r * 0.68, 0.008), (0.0, 0.008)], base, sides=16,
            mat=mat, cap_top=True, cap_bottom=True)


def loaf(b, base, yaw=0.0, s=1.0):
    v, q, nrm = E.rbox(0.13 * s, 0.06 * s, 0.075 * s, 0.055 * s, step=0.03)
    v[:, 1] += 0.02 * s * (1 - (v[:, 0] / (0.13 * s)) ** 2)
    v[:, 1] *= np.where(v[:, 1] > 0, 1.2, 1.0)
    v = v @ E.rot_y(yaw).T + np.array(base) + np.array([0, 0.06 * s, 0])
    cols = np.tile([1.0, 0.0, 0.0, 0.0], (len(v), 1))
    cols[:, 0] = np.where(nrm[:, 1] > 0.5, 1.0, 0.7)
    b.add(v, q.tolist(), "COL_bread", cols)


def sack(b, base, yaw=0.0, s=1.0, lean=0.0):
    v, q, nrm = E.rbox(0.2 * s, 0.3 * s, 0.15 * s, 0.13 * s, step=0.04)
    t = (v[:, 1] / (0.3 * s) + 1) * 0.5
    pinch = 1.0 - 0.55 * E.smoothstep(0.7, 1.0, t)
    v[:, 0] *= pinch * (1 + 0.15 * np.sin(t * 3.0))
    v[:, 2] *= pinch * (1 + 0.25 * (1 - t))
    v += nrm * (0.012 * E.noise3(v, seed(), 9.0))[:, None]
    v[:, 1] += 0.3 * s
    v[:, 0] += lean * v[:, 1]
    v = v @ E.rot_y(yaw).T + np.array(base)
    cols = np.tile([1.0, 0.0, 0.2, 0.0], (len(v), 1))
    b.add(v, q.tolist(), "COL_burlap", cols)
    # tie
    top = np.array(base) + E.rot_y(yaw) @ np.array([lean * 0.52 * s, 0.52 * s, 0])
    E.lathe(b, [(0.045 * s, -0.02), (0.05 * s, 0.0), (0.04 * s, 0.03), (0.06 * s, 0.08), (0.0, 0.09)], top, sides=7,
            mat="COL_burlap")


def rope_coil(b, base, r=0.28, turns=4, thick=0.035):
    pts = []
    n = turns * 24
    for i in range(n):
        t = i / 24.0
        rr = r - (t / turns) * r * 0.45
        a = t * 2 * math.pi
        pts.append((base[0] + math.cos(a) * rr, base[1] + thick + 0.012 * math.sin(a * 3) + thick * 1.3 * (i // 24 % 2) * 0.4,
                    base[2] + math.sin(a) * rr))
    E.tube(b, pts, thick, sides=6, mat="COL_rope", twist_bumps=0.18)
    # loose tail
    a = turns * 2 * math.pi
    p = np.array(pts[-1])
    tail = [p + np.array([0.08 * k, 0, 0.05 * k * math.sin(k)]) for k in range(6)]
    E.tube(b, tail, thick, sides=6, mat="COL_rope", twist_bumps=0.18)


def net(b, origin, U, V, w, h, cell=0.11, sag=0.18, seed_=0, cord=0.009, mat="COL_rope", torn=0.0):
    """Draped fishing net: a grid of cords hung from the U edge, sagging between hang points."""
    U = np.array(U, float)
    V = np.array(V, float)
    o = np.array(origin, float)
    r = np.random.default_rng(seed_)
    nu = int(w / cell)
    nv = int(h / cell)
    N = np.cross(U, V)

    def P(i, j):
        u = i / nu
        v = j / nv
        drape = sag * math.sin(math.pi * ((u * 3.0) % 1.0)) * v
        bulge = 0.08 * math.sin(math.pi * u) * math.sin(math.pi * v) + 0.02 * math.sin(i * 1.3 + j * 0.7)
        return o + U * (u * w) - V * (v * h) + V * (drape * 0.6) + N * bulge

    for i in range(nu + 1):
        js = [j for j in range(nv + 1) if not (torn and r.random() < torn and j > 2)]
        run = []
        for j in range(nv + 1):
            if j in js:
                run.append(P(i, j))
            elif len(run) > 1:
                E.tube(b, run, cord, sides=3, mat=mat)
                run = []
            else:
                run = []
        if len(run) > 1:
            E.tube(b, run, cord, sides=3, mat=mat)
    for j in range(nv + 1):
        E.tube(b, [P(i, j) for i in range(nu + 1)], cord, sides=3, mat=mat)
    # floats
    for i in range(0, nu + 1, 3):
        p = P(i, 0)
        E.stone(b, tuple(p), (0.07, 0.05, 0.05), seed=seed(), mat="TRI_crock", lump=0.004, r=0.02)


def anchor_geo(b, base, yaw=0.0, lean=12.0, s=1.0):
    R = E.rot_y(yaw) @ E.rot_x(-lean)
    o = np.array(base)

    def T(p):
        return o + R @ (np.array(p) * s)

    E.tube(b, [T((0, 0.15, 0)), T((0, 1.25, 0))], 0.035 * s, sides=6, mat="COL_iron")
    E.tube(b, [T((-0.28, 1.1, 0)), T((0.28, 1.1, 0))], 0.03 * s, sides=6, mat="COL_iron")
    arc = [T((math.sin(t) * 0.42, 0.42 - math.cos(t) * 0.36, 0)) for t in np.linspace(-1.35, 1.35, 13)]
    E.tube(b, arc, 0.04 * s, sides=6, mat="COL_iron")
    for sgn in (-1, 1):
        tip = T((sgn * 0.42 * math.sin(1.35) + sgn * 0.06, 0.42 - 0.36 * math.cos(1.35) + 0.12, 0))
        E.tube(b, [arc[0 if sgn < 0 else -1], tip], 0.03 * s, sides=4, mat="COL_iron")
    ring = [T((math.sin(t) * 0.09, 1.36 + math.cos(t) * 0.09, 0)) for t in np.linspace(0, 2 * math.pi, 12)]
    E.tube(b, ring, 0.016 * s, sides=5, mat="COL_iron")


def oar(b, p0, p1, blade=0.5):
    p0 = np.array(p0, float)
    p1 = np.array(p1, float)
    E.timber(b, p0, p1, 0.05, 0.05, seed=seed(), r=0.022, mat="TRI_planks", chips=0.2, step=0.02, step_x=0.1)
    d = (p1 - p0) / np.linalg.norm(p1 - p0)
    E.timber(b, p1 - d * blade, p1 + d * 0.04, 0.16, 0.03, seed=seed(), r=0.012, mat="TRI_planks", chips=0.6, step=0.02)


def candle_wheel(center, radius=0.55, n=8, hang_to=3.2):
    bi = batch("iron")
    c = np.array(center, float)
    ring = [c + np.array([math.cos(t) * radius, 0, math.sin(t) * radius]) for t in np.linspace(0, 2 * math.pi, 33)]
    E.tube(bi, ring, 0.028, sides=6, mat="COL_iron")
    ring2 = [c + np.array([math.cos(t) * radius * 0.92, -0.06, math.sin(t) * radius * 0.92]) for t in np.linspace(0, 2 * math.pi, 33)]
    E.tube(bi, ring2, 0.016, sides=5, mat="COL_iron")
    for k in range(4):
        a = k * math.pi / 2 + 0.3
        E.tube(bi, [c + np.array([math.cos(a) * radius, 0, math.sin(a) * radius]), c + np.array([0, 0.0, 0])], 0.018, sides=4,
               mat="COL_iron")
    for k in range(3):
        a = k * 2 * math.pi / 3 + 0.3
        chain(bi, c + np.array([math.cos(a) * radius, 0.02, math.sin(a) * radius]), c + np.array([0, 0.75, 0]))
    chain(bi, c + np.array([0, 0.75, 0]), c + np.array([0, hang_to - c[1], 0]))
    dress = batch("clutter")
    for k in range(n):
        a = k * 2 * math.pi / n
        p = c + np.array([math.cos(a) * radius, 0.03, math.sin(a) * radius])
        E.lathe(bi, [(0.0, 0.0), (0.045, 0.0), (0.045, 0.025), (0.03, 0.03)], p - np.array([0, 0.0, 0]), sides=6,
                mat="COL_iron")
        candle(dress, (p[0], p[1] + 0.03, p[2]), rng.uniform(0.1, 0.2))


def chain(b, a, c, link=0.05):
    a = np.array(a, float)
    c = np.array(c, float)
    ln = np.linalg.norm(c - a)
    n = max(2, int(ln / link))
    pts = [a + (c - a) * (k / n) for k in range(n + 1)]
    E.tube(b, pts, 0.012, sides=4, mat="COL_iron", twist_bumps=0.35)


def hang_lantern(top, length):
    c = np.array(top, float) - np.array([0, length, 0])
    chain(batch("iron"), top, c + np.array([0, 0.2, 0]))
    lantern_geo(c, 1.25)


# ============================================================================================
# furniture
# ============================================================================================

def round_table(center, r=0.62, top_h=0.62, yaw=0.0):
    b = batch("furniture")
    x, _, z = center
    # top: thick slab of 4 boards clipped to a circle approximated by a 14-gon lathe
    E.lathe(b, [(0.0, top_h - 0.06), (r - 0.02, top_h - 0.06), (r, top_h - 0.035), (r, top_h - 0.01), (r - 0.015, top_h),
                (0.0, top_h)], (x, 0, z), sides=18, mat="TRI_tabletop", yaw=yaw,
            cols_fn=lambda vv: np.c_[np.ones(len(vv)), np.full(len(vv), 0.5), np.zeros(len(vv)), np.zeros(len(vv))])
    E.timber(b, (x, 0.08, z), (x, top_h - 0.06, z), 0.14, 0.14, up=(1, 0, 0), seed=seed(), r=0.04, mat="TRI_timber")
    for k in range(3):
        a = math.radians(yaw + k * 120)
        E.timber(b, (x, 0.07, z), (x + math.cos(a) * 0.42, 0.04, z + math.sin(a) * 0.42), 0.09, 0.1, seed=seed(), r=0.03,
                 mat="TRI_timber")


def trestle_bespoke(center, length=2.4, yaw=0.0, overturned=False):
    """A trestle table (used for the overturned one the thugs kicked over)."""
    b = batch("furniture")
    c = np.array(center, float)
    R = E.rot_y(yaw)
    if overturned:
        R = R @ E.rot_x(-88)

    def T(p):
        return c + R @ np.array(p)

    top_h = 0.62
    for k in range(4):
        zz = -0.33 + k * 0.22
        E.board(b, T((-length / 2, top_h - 0.03, zz)), T((length / 2 - (0.25 if k == 2 and overturned else 0.0), top_h - 0.03, zz)),
                0.205, 0.055, up=tuple(R @ np.array([0, 1, 0])), seed=seed(), mat="TRI_tabletop", chips=1.2)
    for sx in (-1, 1):
        x = sx * (length / 2 - 0.3)
        E.timber(b, T((x, top_h - 0.1, -0.38)), T((x, top_h - 0.1, 0.38)), 0.08, 0.08, up=tuple(R @ np.array([0, 1, 0])),
                 seed=seed(), r=0.02)
        E.timber(b, T((x, top_h - 0.1, 0.0)), T((x, 0.05, -0.3)), 0.09, 0.09, seed=seed(), r=0.025)
        E.timber(b, T((x, top_h - 0.1, 0.0)), T((x, 0.05, 0.3)), 0.09, 0.09, seed=seed(), r=0.025)
    E.timber(b, T((-length / 2 + 0.3, 0.28, 0.0)), T((length / 2 - 0.3, 0.28, 0.0)), 0.08, 0.06, seed=seed(), r=0.02)


def bench(center, length=2.2, yaw=0.0, h=0.36, tilt=0.0):
    b = batch("furniture")
    c = np.array(center, float)
    R = E.rot_y(yaw) @ E.rot_z(tilt)

    def T(p):
        return c + R @ np.array(p)

    E.board(b, T((-length / 2, h, 0)), T((length / 2, h, 0)), 0.3, 0.06, up=tuple(R @ np.array([0, 1, 0])), seed=seed(),
            mat="TRI_tabletop", chips=1.0)
    for sx in (-1, 1):
        x = sx * (length / 2 - 0.2)
        E.board(b, T((x, h - 0.03, 0)), T((x, 0.0, 0)), 0.26, 0.06, up=tuple(R @ np.array([1, 0, 0])), seed=seed(),
                mat="TRI_timber")


def settle(center, length, yaw=0.0):
    """High-backed settle (snug)."""
    b = batch("furniture")
    c = np.array(center, float)
    R = E.rot_y(yaw)

    def T(p):
        return c + R @ np.array(p)

    E.board(b, T((-length / 2, 0.42, 0.05)), T((length / 2, 0.42, 0.05)), 0.42, 0.06, seed=seed(), mat="TRI_tabletop")
    for k in range(int(length / 0.2)):
        x = -length / 2 + 0.1 + k * 0.2
        E.board(b, T((x, 0.0, -0.17)), T((x, 1.45, -0.17)), 0.195, 0.04, up=tuple(R @ np.array([0, 0, 1])), seed=seed(),
                mat="TRI_planks")
    for sx in (-1, 1):
        E.board(b, T((sx * length / 2, 0.0, 0.0)), T((sx * length / 2, 1.5, -0.1)), 0.46, 0.07, up=tuple(R @ np.array([1, 0, 0])),
                seed=seed(), mat="TRI_timber")
    E.timber(b, T((-length / 2 - 0.05, 1.5, -0.17)), T((length / 2 + 0.05, 1.5, -0.17)), 0.1, 0.09, seed=seed(), r=0.03)


def stool(center, h=0.42):
    b = batch("furniture")
    x, _, z = center
    E.lathe(b, [(0.0, h - 0.05), (0.19, h - 0.05), (0.2, h - 0.02), (0.18, h), (0.0, h)], (x, 0, z), sides=12,
            mat="TRI_tabletop")
    for k in range(3):
        a = k * 2.094 + rng.uniform(0, 1)
        E.timber(b, (x + math.cos(a) * 0.08, h - 0.05, z + math.sin(a) * 0.08), (x + math.cos(a) * 0.17, 0.0, z + math.sin(a) * 0.17),
                 0.045, 0.045, seed=seed(), r=0.018)


# ============================================================================================
# bar, shelves, stairs, trapdoor, posts
# ============================================================================================

def bar():
    b = batch("bar")
    x0, x1 = -4.6, 2.9
    zf = 3.25                          # room-side face
    zb = 3.95                          # Bertha's side
    top_y = 1.0
    # top slab: three heavy boards
    for k in range(3):
        zz = zf + 0.06 + k * 0.24
        E.board(b, (x0 - 0.08, top_y, zz), (x1 + 0.08, top_y, zz), 0.235, 0.075, seed=seed(), mat="TRI_tabletop", chips=1.5,
                sag=0.006)
    # front: vertical boards behind framed panels
    for k in range(int((x1 - x0) / 0.16)):
        xx = x0 + 0.08 + k * 0.16
        E.board(b, (xx, 0.06, zf + 0.04), (xx, top_y - 0.05, zf + 0.04), 0.155, 0.04, up=(0, 0, 1), seed=seed(), mat="TRI_planks")
    for xx in np.linspace(x0, x1, 7):
        E.timber(b, (xx, 0.0, zf + 0.06), (xx, top_y - 0.04, zf + 0.06), 0.14, 0.12, up=(0, 0, 1), seed=seed(), r=0.025)
    E.timber(b, (x0, 0.1, zf + 0.02), (x1, 0.1, zf + 0.02), 0.12, 0.2, seed=seed(), r=0.03)
    E.timber(b, (x0, top_y - 0.1, zf + 0.02), (x1, top_y - 0.1, zf + 0.02), 0.1, 0.13, seed=seed(), r=0.02)
    # back side: open shelving under the counter
    for xx in np.linspace(x0, x1, 7):
        E.timber(b, (xx, 0.0, zb - 0.05), (xx, top_y - 0.04, zb - 0.05), 0.1, 0.1, up=(0, 0, 1), seed=seed(), r=0.02)
    for yy in (0.08, 0.5):
        for k in range(2):
            E.board(b, (x0, yy, zf + 0.25 + k * 0.28), (x1, yy, zf + 0.25 + k * 0.28), 0.27, 0.04, seed=seed(), mat="TRI_planks")
    # brass foot rail on the room side
    bi = batch("iron")
    E.tube(bi, [(x0, 0.2, zf - 0.17), (x1, 0.2, zf - 0.17)], 0.025, sides=8, mat="COL_brass")
    for xx in np.linspace(x0 + 0.3, x1 - 0.3, 5):
        E.tube(bi, [(xx, 0.2, zf - 0.17), (xx, 0.25, zf - 0.02)], 0.015, sides=5, mat="COL_brass")
    dress = batch("clutter")
    # under-counter stock (visible from the camera side)
    xx = x0 + 0.15
    while xx < x1 - 0.15:
        kind = rng.integers(0, 4)
        if kind == 0:
            for j in range(3):
                bottle(dress, (xx + j * 0.09, 0.53, zf + rng.uniform(0.3, 0.6)), kind=int(rng.integers(0, 3)), s=1.25)
            xx += 0.3
        elif kind == 1:
            tankard(dress, (xx, 0.53, zf + 0.5), yaw=rng.uniform(0, 360), ale=False)
            tankard(dress, (xx + 0.15, 0.53, zf + 0.45), yaw=rng.uniform(0, 360), ale=False)
            xx += 0.32
        elif kind == 2:
            jug(dress, (xx + 0.06, 0.11, zf + 0.5))
            xx += 0.26
        else:
            for j in range(4):
                plate(dress, (xx + 0.1, 0.53 + j * 0.03, zf + 0.5), r=0.12)
            xx += 0.3
        xx += rng.uniform(0.05, 0.2)
    # counter top dressing
    tankard(dress, (-3.9, top_y + 0.04, zf + 0.35), 30)
    tankard(dress, (-3.6, top_y + 0.04, zf + 0.25), 200)
    tankard(dress, (-0.3, top_y + 0.04, zf + 0.3), 120, wood=True)
    tankard(dress, (1.7, top_y + 0.04, zf + 0.3), -40)
    bottle(dress, (-2.6, top_y + 0.04, zf + 0.4), 0)
    bottle(dress, (-2.45, top_y + 0.04, zf + 0.3), 1)
    bottle(dress, (0.6, top_y + 0.04, zf + 0.45), 2)
    jug(dress, (2.3, top_y + 0.04, zf + 0.35))
    plate(dress, (-1.3, top_y + 0.04, zf + 0.35), r=0.14, mat="TRI_tabletop")
    loaf(dress, (-1.3, top_y + 0.06, zf + 0.35), 30, 1.1)
    candle(dress, (-2.0, top_y + 0.04, zf + 0.5), 0.18, stick=True)
    candle(dress, (1.2, top_y + 0.04, zf + 0.55), 0.12, stick=True)
    # rag
    E.stone(dress, (0.15, top_y + 0.045, zf + 0.35), (0.28, 0.015, 0.2), yaw=20, seed=seed(), mat="COL_cloth_cream", lump=0.008)
    anchors["bar"] = {"x0": x0, "x1": x1, "z": (zf + zb) * 0.5, "y": top_y}


def keg_rack(x, z):
    """Small kegs lying on a cradle at the bar's east end (PH barrels placed later)."""
    b = batch("bar")
    for zz in (z - 0.25, z + 0.25):
        E.timber(b, (x - 0.5, 1.07, zz), (x + 0.5, 1.07, zz), 0.08, 0.1, seed=seed(), r=0.02)


def back_shelves(x0, x1, z, y0=0.0, levels=(0.5, 1.0, 1.5, 2.0), depth=0.32, facing=-1):
    """Wall shelves loaded with bottles/jugs/plates. facing: -1 = items face -z (room side)."""
    b = batch("shelves")
    for yy in levels:
        E.board(b, (x0, yy, z + facing * depth * 0.5), (x1, yy, z + facing * depth * 0.5), depth, 0.045, seed=seed(), mat="TRI_planks",
                chips=1.0, sag=0.01)
    for xx in (x0 + 0.05, x1 - 0.05):
        E.board(b, (xx, 0.0, z + facing * depth * 0.5), (xx, levels[-1] + 0.25, z + facing * depth * 0.5), depth, 0.05,
                up=(1, 0, 0), seed=seed(), mat="TRI_timber")
    dress = batch("clutter")
    for yy in levels:
        xx = x0 + 0.12
        while xx < x1 - 0.12:
            k = rng.integers(0, 6)
            zz = z + facing * depth * rng.uniform(0.35, 0.6)
            if k <= 2:
                bottle(dress, (xx, yy + 0.023, zz), kind=int(k), s=1.3)
                xx += 0.1
            elif k == 3:
                jug(dress, (xx + 0.05, yy + 0.023, zz))
                xx += 0.22
            elif k == 4:
                tankard(dress, (xx, yy + 0.023, zz), yaw=rng.uniform(0, 360), ale=False)
                xx += 0.17
            else:
                plate(dress, (xx + 0.12, yy + 0.023, zz), r=0.12)
                xx += 0.26
            xx += rng.uniform(0.0, 0.06)


def support_post(x, z, top=2.95, beam_dir=None):
    b = batch("posts")
    E.stone(b, (x, 0.08, z), (0.5, 0.16, 0.5), seed=seed(), r=0.05, lump=0.01)
    E.timber(b, (x, 0.14, z), (x, top, z), 0.34, 0.34, up=(0, 0, 1), seed=seed(), r=0.045, chips=2.2, wobble=0.01)
    # iron hooks / a notice nailed on
    bi = batch("iron")
    for yy in (1.55, 1.75):
        E.tube(bi, [(x + 0.17, yy, z + 0.05), (x + 0.26, yy, z + 0.05), (x + 0.28, yy + 0.05, z + 0.05)], 0.012, sides=4,
               mat="COL_iron")
    # bolster cap + knee braces carrying a cut summer-beam stub
    E.timber(b, (x, top + 0.08, z - 0.55), (x, top + 0.08, z + 0.55), 0.38, 0.16, seed=seed(), r=0.035)
    for s in (-1, 1):
        E.timber(b, (x, top - 0.55, z), (x, top + 0.02, z + s * 0.55), 0.14, 0.14, up=(1, 0, 0), seed=seed(), r=0.03)


def summer_beam(x, z0, z1, y=3.29):
    b = batch("ceiling")
    E.timber(b, (x, y, z0), (x, y, z1), 0.36, 0.36, up=(0, 1, 0), seed=seed(), r=0.05, chips=2.5, sag=0.05, wobble=0.015)


def stairs():
    """NE corner: rising south along the east wall from z = 5.4 (bottom) to a landing at y = 2.42."""
    b = batch("stairs")
    x0, x1 = -W + 0.02, -W + 1.12
    n = 11
    rise = 2.42 / n
    run = 0.26
    zb = 5.35
    for k in range(n):
        y = (k + 1) * rise
        z = zb - k * run
        E.board(b, (x0, y - 0.03, z - run * 0.5 - 0.02), (x1, y - 0.03, z - run * 0.5 - 0.02), run + 0.06, 0.055, seed=seed(),
                mat="TRI_planks", chips=1.4)
        E.board(b, (x0, y - rise * 0.5 - 0.03, z + 0.0), (x1, y - rise * 0.5 - 0.03, z + 0.0), rise - 0.04, 0.035,
                up=(0, 0, 1), seed=seed(), mat="TRI_planks", chips=0.6)
    # stringer on the room side + handrail with balusters
    E.timber(b, (x1 + 0.05, 0.05, zb + 0.15), (x1 + 0.05, 2.42, zb - n * run), 0.08, 0.3, up=(0, 1, 0), seed=seed())
    for k in range(0, n + 1, 1):
        y = k * rise + 0.08
        z = zb - k * run + 0.05
        E.timber(b, (x1 + 0.05, y, z), (x1 + 0.05, y + 0.85, z), 0.055, 0.055, up=(0, 0, 1), seed=seed(), r=0.015, chips=0.4,
                 step=0.025)
    E.timber(b, (x1 + 0.05, 0.95, zb + 0.15), (x1 + 0.05, 0.85 + 2.42 + 0.1, zb - n * run), 0.09, 0.09, seed=seed(), r=0.03)
    E.timber(b, (x1 + 0.05, 0.0, zb + 0.15), (x1 + 0.05, 1.15, zb + 0.15), 0.14, 0.14, up=(0, 0, 1), seed=seed(), r=0.035)
    # landing
    zl = zb - n * run
    for k in range(6):
        E.board(b, (x0, 2.4, zl - k * 0.2), (x1 + 0.1, 2.4, zl - k * 0.2), 0.19, 0.06, seed=seed(), mat="TRI_planks")
    E.timber(b, (x1 + 0.12, 0.0, zl - 1.05), (x1 + 0.12, 2.42, zl - 1.05), 0.2, 0.2, up=(0, 0, 1), seed=seed())
    # under-stair storage: sacks + a coil of rope
    dress = batch("clutter")
    sack(dress, (x0 + 0.4, 0.0, zb - 2.3), yaw=20, s=1.0)
    sack(dress, (x0 + 0.45, 0.0, zb - 2.8), yaw=-30, s=0.9, lean=0.15)
    rope_coil(dress, (x0 + 0.55, 0.0, zb - 1.7), r=0.26)


def trapdoor(x0, z0, x1, z1):
    """Open cellar trapdoor: hole frame, lid propped open, ladder rails, warm glow from below."""
    b = batch("trapdoor")
    for (p, q) in (((x0, 0.0, z0), (x1, 0.0, z0)), ((x0, 0.0, z1), (x1, 0.0, z1))):
        E.timber(b, (p[0] - 0.08, -0.04, p[2]), (q[0] + 0.08, -0.04, q[2]), 0.12, 0.1, seed=seed(), r=0.02)
    for xx in (x0, x1):
        E.timber(b, (xx, -0.04, z0), (xx, -0.04, z1), 0.12, 0.1, seed=seed(), r=0.02)
    # shaft walls (stone) down to the cellar
    for (cx, cz, sx, sz) in ((x0 - 0.12, (z0 + z1) / 2, 0.2, z1 - z0 + 0.3), (x1 + 0.12, (z0 + z1) / 2, 0.2, z1 - z0 + 0.3),
                             ((x0 + x1) / 2, z0 - 0.12, x1 - x0 + 0.3, 0.2), ((x0 + x1) / 2, z1 + 0.12, x1 - x0 + 0.3, 0.2)):
        E.stone(b, (cx, -1.0, cz), (sx, 1.9, sz), seed=seed(), mat="TRI_stone_dark", lump=0.02, r=0.04)
    E.stone(b, ((x0 + x1) / 2, -1.95, (z0 + z1) / 2), (x1 - x0 + 0.3, 0.1, z1 - z0 + 0.3), seed=seed(), mat="TRI_stone_dark")
    # lantern-lit cellar floor seen through the hole (reads as a warm rectangle: the flee route)
    E.quad_poly(b, [(x0 - 0.05, -1.88, z1 + 0.05), (x1 + 0.05, -1.88, z1 + 0.05), (x1 + 0.05, -1.88, z0 - 0.05), (x0 - 0.05, -1.88, z0 - 0.05)],
                "EMIT_cellar")
    lantern_geo(((x0 + x1) / 2 + 0.25, -1.7, (z0 + z1) / 2 + 0.2), 1.2, register=False)
    # ladder
    xm = (x0 + x1) / 2
    for sx in (-0.22, 0.22):
        E.timber(b, (xm + sx, -1.9, z0 + 0.25), (xm + sx, 0.35, z0 + 0.12), 0.06, 0.06, seed=seed(), r=0.02)
    for k in range(6):
        y = -1.7 + k * 0.33
        E.timber(b, (xm - 0.24, y, z0 + 0.25 - (y + 1.9) * 0.05), (xm + 0.24, y, z0 + 0.25 - (y + 1.9) * 0.05), 0.04, 0.04,
                 seed=seed(), r=0.015)
    # lid: planks + battens, hinged on the SOUTH edge and propped open past vertical, leaning away from
    # the camera, so the lit hole stays in view and the battened underside faces the lens
    ang = math.radians(104)
    along = np.array([0, math.sin(ang), math.cos(ang)])          # from the hinge up the lid
    under = np.array([0, -math.cos(ang), math.sin(ang)])         # underside normal (toward the camera)
    lid_len = z1 - z0
    for k in range(5):
        xx = x0 + 0.1 + k * (x1 - x0 - 0.2) / 4
        p0 = np.array([xx, 0.04, z0 - 0.02])
        E.board(b, p0, p0 + along * lid_len, 0.2, 0.05, up=tuple(under), seed=seed(), mat="TRI_planks")
    for t in (0.15, 0.82):
        p0 = np.array([x0, 0.04, z0 - 0.02]) + along * (lid_len * t) + under * 0.045
        E.board(b, p0, p0 + np.array([x1 - x0, 0, 0]), 0.1, 0.04, up=tuple(under), seed=seed(), mat="TRI_timber")
    bi = batch("iron")
    ring_c = np.array([xm, 0.04, z0 - 0.02]) + along * (lid_len * 0.6) + under * 0.07
    E.tube(bi, [ring_c + np.array([math.cos(t) * 0.07, 0, 0]) + along * (math.sin(t) * 0.07) for t in np.linspace(0, 2 * math.pi, 10)],
           0.012, sides=4, mat="COL_iron")
    # a stick propping the lid
    E.tube(b, [(x1 - 0.15, 0.0, z0 + 0.15), tuple(np.array([x1 - 0.15, 0.04, z0 - 0.02]) + along * lid_len * 0.7)], 0.025, sides=5,
           mat="TRI_planks")
    anchors["trapdoor"].append({"pos": [xm, -1.2, (z0 + z1) / 2], "x0": x0, "x1": x1, "z0": z0, "z1": z1})


# ============================================================================================
# floor mesh, outside, foreground
# ============================================================================================

def floor_mesh(hole):
    b = batch("floor")
    xs = np.arange(-8.1, 8.1001, 0.25)
    zs = np.arange(-5.65, 5.6501, 0.25)
    hx0, hz0, hx1, hz1 = hole
    xs = np.unique(np.concatenate([xs, [hx0, hx1]]))
    zs = np.unique(np.concatenate([zs, [hz0, hz1]]))
    verts = []
    idx = {}
    for i, x in enumerate(xs):
        for j, z in enumerate(zs):
            idx[(i, j)] = len(verts)
            verts.append((x, 0.0, z))
    faces = []
    for i in range(len(xs) - 1):
        for j in range(len(zs) - 1):
            cx = (xs[i] + xs[i + 1]) / 2
            cz = (zs[j] + zs[j + 1]) / 2
            if hx0 < cx < hx1 and hz0 < cz < hz1:
                continue
            faces.append([idx[(i, j)], idx[(i, j + 1)], idx[(i + 1, j + 1)], idx[(i + 1, j)]])
    b.add(np.array(verts), faces, "FLOOR_room", np.tile([1, 0, 0, 0], (len(verts), 1)), smooth=True)


def outside():
    """The rain-wet quay beyond the far wall: deck planks, kerb, bollards, water, a moored boat,
    and distant warehouse / mast silhouettes with lit windows (all bent by the Godot world bend)."""
    b = batch("outside")
    # deck planks running away from the door (z), small gaps between
    x = -8.4
    while x < 8.4:
        w = rng.uniform(0.2, 0.3)
        z = -D - 0.3
        while z > -8.6:
            ln = rng.uniform(1.2, 2.6)
            e = max(z - ln, -8.6)
            E.board(b, (x + w / 2, -0.18 + rng.uniform(-0.01, 0.008), z), (x + w / 2, -0.18 + rng.uniform(-0.01, 0.008), e), w - 0.022,
                    0.08, seed=seed(), mat="TRI_quay", chips=1.2, step=0.15, step_x=0.25)
            z = e - 0.015
        x += w
    # joists under the deck (seen through gaps)
    for xx in np.arange(-8.0, 8.1, 1.4):
        E.timber(b, (xx, -0.36, -D - 0.2), (xx, -0.36, -8.7), 0.16, 0.2, seed=seed(), mat="TRI_quay")
    # kerb + bollards on the quay edge
    E.timber(b, (-8.5, -0.06, -8.55), (8.5, -0.06, -8.55), 0.28, 0.22, seed=seed(), mat="TRI_timber_dark", chips=2.0, sag=0.02)
    for xx in (-5.6, -1.4, 3.4, 7.0):
        E.lathe(b, [(0.0, -0.2), (0.17, -0.2), (0.15, 0.25), (0.12, 0.3), (0.2, 0.38), (0.2, 0.44), (0.0, 0.46)], (xx, 0, -8.35),
                sides=10, mat="COL_iron")
    dress = batch("outside_dress")
    rope_coil(dress, (2.6, -0.14, -7.4), r=0.3)
    rope_coil(dress, (-3.6, -0.14, -7.9), r=0.24, turns=3)
    tube_pts = [(3.4, 0.32, -8.35), (3.0, 0.1, -8.0), (2.8, -0.12, -7.7)]
    E.tube(dress, tube_pts, 0.03, sides=5, mat="COL_rope")
    # piles at the quay edge
    for xx in np.arange(-8.0, 8.1, 2.0):
        E.timber(b, (xx, -2.5, -8.75), (xx, 0.35, -8.75), 0.3, 0.3, up=(0, 0, 1), seed=seed(), mat="TRI_timber_dark", r=0.12,
                 chips=1.5)
    # dock lamp post
    E.timber(b, (-1.9, -0.18, -7.7), (-1.9, 2.4, -7.7), 0.16, 0.16, up=(0, 0, 1), seed=seed())
    E.timber(b, (-1.9, 2.3, -7.7), (-1.9, 2.3, -7.2), 0.08, 0.1, seed=seed())
    lantern_geo((-1.9, 2.02, -7.25), 1.2, register=False)
    anchors["dock"].append({"pos": [-1.9, 2.02, -7.25]})
    # water
    w = batch("water", shadows=False)
    verts = []
    faces = []
    xs = np.linspace(-14, 14, 29)
    zs = np.linspace(-8.6, -16.0, 16)
    for i, xx in enumerate(xs):
        for j, zz in enumerate(zs):
            verts.append((xx, -0.85, zz))
    for i in range(len(xs) - 1):
        for j in range(len(zs) - 1):
            a = i * len(zs) + j
            faces.append([a, a + 1, a + len(zs) + 1, a + len(zs)])
    w.add(np.array(verts), faces, "COL_water", np.tile([1, 0, 0, 1], (len(verts), 1)))
    # distant harbour: warehouse blocks with lit windows + masts against a sky card
    far = batch("far", shadows=False)
    xx = -16.0
    while xx < 16.0:
        wdt = rng.uniform(2.2, 4.0)
        hgt = rng.uniform(3.0, 6.0)
        zz = -15.5 + rng.uniform(-0.6, 0.6)
        verts = [(xx, -1.0, zz), (xx + wdt, -1.0, zz), (xx + wdt, hgt, zz), (xx + wdt * 0.5, hgt + rng.uniform(0.8, 1.6), zz),
                 (xx, hgt, zz)]
        far.add(np.array(verts), [[0, 1, 2, 3, 4]], "COL_far_house", np.tile([1, 0, 0, 0], (5, 1)))
        for k in range(int(rng.integers(0, 3))):
            wx = xx + rng.uniform(0.4, wdt - 0.6)
            wy = rng.uniform(0.5, hgt - 1.0)
            E.quad_poly(far, [(wx, wy, zz + 0.05), (wx + 0.35, wy, zz + 0.05), (wx + 0.35, wy + 0.5, zz + 0.05), (wx, wy + 0.5, zz + 0.05)],
                        "EMIT_far_window")
            anchors["far_lights"].append({"pos": [wx + 0.17, wy + 0.25, zz + 0.1]})
        xx += wdt + rng.uniform(0.0, 0.6)
    E.quad_poly(far, [(-30, -2, -18.5), (30, -2, -18.5), (30, 14, -18.5), (-30, 14, -18.5)], "COL_sky")
    # masts and spars of moored boats
    for (mx, mz, mh) in ((-6.5, -11.0, 7.0), (-5.2, -11.6, 5.5), (4.6, -10.6, 8.0), (6.8, -12.0, 6.0), (0.8, -12.8, 6.5)):
        E.timber(far, (mx, -0.8, mz), (mx, mh, mz), 0.12, 0.12, up=(0, 0, 1), seed=seed(), mat="COL_far_house", r=0.04, chips=0)
        E.timber(far, (mx - 1.4, mh * 0.62, mz), (mx + 1.4, mh * 0.62 + 0.2, mz), 0.06, 0.06, seed=seed(), mat="COL_far_house",
                 r=0.02, chips=0)
        E.tube(far, [(mx, mh, mz), (mx + 2.5, -0.5, mz + 0.4)], 0.012, sides=3, mat="COL_far_house")
        anchors["far_lights"].append({"pos": [mx + 0.15, mh * 0.35, mz + 0.2], "boat": True})


def foreground():
    """Near-camera occluders (DOF-blurred): a cut tie beam and hanging nets/lantern/herbs."""
    b = batch("FG_beams", shadows=False)
    E.timber(b, (-8.4, 3.05, 5.75), (8.4, 3.05, 5.75), 0.4, 0.36, seed=seed(), r=0.06, chips=2.5, sag=0.06, wobble=0.02)
    for xx in (-5.9, 6.1):
        E.timber(b, (xx, 0.0, 5.8), (xx, 3.0, 5.8), 0.34, 0.34, up=(0, 0, 1), seed=seed(), r=0.05, chips=2.0)
    f = batch("FG_hang", shadows=False)
    # a fishing net slung from the (cut-away) rafters right in front of the lens, frame right
    net(f, (4.95, 6.7, 3.55), (1, 0, 0), (0, 1, 0), 1.8, 2.6, cell=0.16, sag=0.5, seed_=seed(), cord=0.018, mat="COL_rope_fg",
        torn=0.08)
    E.tube(f, [(4.9, 6.75, 3.5), (5.8, 6.55, 3.55), (6.8, 6.8, 3.5)], 0.035, sides=5, mat="COL_rope_fg")
    # a rope of drying herbs and onions across the upper-left corner
    rope = [np.array([-6.6 + 3.2 * t, 8.0 - 0.6 * math.sin(math.pi * t) - 0.3 * t, 2.1 + 0.8 * t]) for t in np.linspace(0, 1, 12)]
    E.tube(f, rope, 0.035, sides=5, mat="COL_rope_fg")
    for k in range(1, 11):
        top = rope[k]
        ln = rng.uniform(0.35, 0.6)
        E.tube(f, [top, top - np.array([0, 0.1, 0])], 0.015, sides=3, mat="COL_rope_fg")
        if k % 3 == 0:
            E.stone(f, tuple(top - np.array([0, 0.18, 0])), (0.12, 0.14, 0.12), seed=seed(), mat="COL_onion", lump=0.01, r=0.05)
            continue
        for j in range(10):
            a = j * 0.65
            E.tube(f, [top - np.array([0, 0.08, 0]), top - np.array([math.cos(a) * 0.14, ln * 1.5 + rng.uniform(0, 0.15), math.sin(a) * 0.1])],
                   0.045, sides=3, mat="COL_herb_fg")
    hang_lantern((-1.0, 3.0, 5.6), 0.75)
    anchors["lanterns"][-1]["fg"] = True
    hang_lantern((4.35, 9.0, 4.4), 4.4)
    anchors["lanterns"][-1]["fg"] = True
    hang_lantern((-3.6, 10.5, 2.8), 2.9)
    anchors["lanterns"][-1]["fg"] = True


# ============================================================================================
# room dressing (bespoke)
# ============================================================================================

def rug(center, length, width, yaw, seed_=0):
    """Woven rug: wrinkled grid with UVs (texture from bake_rug.py) + frayed fringes."""
    b = batch("rug", shadows=False)
    r_ = np.random.default_rng(seed_)
    nu, nv = 48, 30
    R = E.rot_y(yaw)
    c = np.array(center, float)
    verts, uvs = [], []
    ph = r_.random(4) * 6.28
    for i in range(nu + 1):
        for j in range(nv + 1):
            uu, vv = i / nu, j / nv
            x = (uu - 0.5) * length
            z = (vv - 0.5) * width
            y = 0.008 + 0.012 * max(0.0, math.sin(uu * 7.0 + ph[0]) * math.sin(vv * 3.0 + ph[1])) ** 3                 + 0.02 * math.exp(-((uu - 0.86) / 0.05) ** 2) * (0.5 + 0.5 * math.sin(vv * 9 + ph[2]))
            verts.append(c + R @ np.array([x, y, z]))
            uvs.append((uu, 1.0 - vv))
    faces = []
    for i in range(nu):
        for j in range(nv):
            a = i * (nv + 1) + j
            faces.append([a, a + 1, a + nv + 2, a + nv + 1])
    b.add(np.array(verts), faces, "RUG", np.tile([1, 0, 0.15, 0], (len(verts), 1)), uvs=np.array(uvs))
    for side in (-1, 1):
        for k in range(26):
            z = (k / 25 - 0.5) * width * 0.96
            p0 = c + R @ np.array([side * length * 0.5, 0.008, z])
            p1 = c + R @ np.array([side * (length * 0.5 + r_.uniform(0.04, 0.08)), 0.004, z + r_.uniform(-0.01, 0.01)])
            E.tube(b, [p0, p1], 0.006, sides=3, mat="COL_cloth_cream")


def tabletop_spread(center, radius, items, top_h=0.62):
    dress = batch("clutter")
    c = np.array(center, float)
    for k, it in enumerate(items):
        a = rng.uniform(0, 2 * math.pi)
        rr = rng.uniform(0.1, radius)
        p = (c[0] + math.cos(a) * rr, top_h, c[2] + math.sin(a) * rr)
        if it == "tankard":
            tankard(dress, p, rng.uniform(0, 360), wood=bool(rng.random() < 0.3), ale=bool(rng.random() < 0.7))
        elif it == "plate":
            plate(dress, p, r=0.13, mat="COL_pewter" if rng.random() < 0.5 else "TRI_tabletop")
        elif it == "loaf":
            plate(dress, p, r=0.15, mat="TRI_tabletop")
            loaf(dress, (p[0], p[1] + 0.01, p[2]), rng.uniform(0, 180), 1.0)
        elif it == "bottle":
            bottle(dress, p, int(rng.integers(0, 3)))
        elif it == "candle":
            candle(dress, p, rng.uniform(0.1, 0.18), stick=True)
        elif it == "jug":
            jug(dress, p)
        elif it == "spill":
            E.quad_poly(dress, [(p[0] - 0.12, p[1] + 0.003, p[2] - 0.08), (p[0] + 0.14, p[1] + 0.003, p[2] - 0.05),
                                (p[0] + 0.1, p[1] + 0.003, p[2] + 0.09), (p[0] - 0.1, p[1] + 0.003, p[2] + 0.07)], "COL_ale")
        elif it == "dice":
            for j in range(2):
                E.stone(dress, (p[0] + j * 0.05, p[1] + 0.018, p[2]), (0.035, 0.035, 0.035), yaw=rng.uniform(0, 90), seed=seed(),
                        mat="COL_cloth_cream", r=0.006, lump=0.001)


def dressing():
    dress = batch("clutter")
    # sacks + crates corner NW (bottom right)
    for (p, yaw, s) in (((7.3, 0.0, 3.4), 10, 1.1), ((6.75, 0.0, 3.75), -25, 1.0), ((7.45, 0.0, 3.95), 40, 0.95)):
        sack(dress, p, yaw, s)
    rope_coil(dress, (6.2, 0.0, 2.9), r=0.32)
    # anchor and oars leaning on the west wall
    anchor_geo(dress, (7.55, 0.0, -0.9), yaw=90, lean=14, s=1.1)
    oar(dress, (7.6, 0.0, 0.6), (7.75, 2.4, 1.05))
    oar(dress, (7.55, 0.0, 0.95), (7.78, 2.35, 1.6))
    # net draped over the west wall rail
    net(dress, (7.72, 2.0, 4.4), (0, 0, -1), (0, 1, 0), 1.6, 1.3, cell=0.12, sag=0.2, seed_=seed())
    # a coil and floats near the far wall
    rope_coil(dress, (-5.9, 0.0, -4.35), r=0.27)
    # straw clumps along the walls
    for k in range(70):
        side = rng.integers(0, 4)
        if side == 0:
            p = (rng.uniform(-7.6, 7.6), 0.0, -D + rng.uniform(0.05, 0.35))
        elif side == 1:
            p = (-W + 1.0 + rng.uniform(0.0, 0.35), 0.0, rng.uniform(-5.2, -1.8))
        elif side == 2:
            p = (W - rng.uniform(0.05, 0.35), 0.0, rng.uniform(-5.2, 5.2))
        else:
            p = (rng.uniform(-6.5, 6.5), 0.0, rng.uniform(-4.5, 4.5))
        for j in range(int(rng.integers(3, 9))):
            a = rng.uniform(0, math.pi)
            ln = rng.uniform(0.08, 0.2)
            o = np.array(p) + np.array([rng.uniform(-0.12, 0.12), 0.006 + j * 0.002, rng.uniform(-0.12, 0.12)])
            E.tube(dress, [o, o + np.array([math.cos(a) * ln, 0.004, math.sin(a) * ln])], 0.005, sides=3, mat="COL_straw")
    # the courier's blood on the hearthstones (glossy, irregular)
    bl = batch("decals", shadows=False)
    r_ = np.random.default_rng(5)
    for (cx, cz, rr, n_) in ((-5.55, 0.62, 0.38, 22), (-5.1, 0.95, 0.12, 10), (-4.95, 0.35, 0.07, 8)):
        pts = []
        for k in range(n_):
            a = 2 * math.pi * k / n_
            rad = rr * (0.75 + 0.35 * r_.random())
            pts.append((cx + math.cos(a) * rad, 0.062, cz + math.sin(a) * rad * 0.8))
        E.quad_poly(bl, pts[::-1], "COL_blood")
    # broken crockery near the overturned table
    for k in range(7):
        E.stone(dress, (0.4 + rng.uniform(-0.6, 0.8), 0.012, -2.4 + rng.uniform(-0.5, 0.5)),
                (rng.uniform(0.04, 0.09), 0.012, rng.uniform(0.03, 0.07)), yaw=rng.uniform(0, 180), seed=seed(), mat="TRI_crock",
                lump=0.004, r=0.006)
    tankard(dress, (-0.4, 0.0, -2.2), 70, ale=False)
    floor_debris(dress)


def floor_debris(dress):
    """Elliot-style ground litter inside the play space: low, sparse, readable at 100 px/m."""
    r_ = np.random.default_rng(77)
    keep_clear = [(0.5, -0.3, 0.55), (-0.9, 0.2, 0.45), (1.9, -1.7, 0.45), (1.2, -4.3, 0.45), (-6.0, 0.4, 0.6)]

    def clear(x, z):
        return all((x - cx) ** 2 + (z - cz) ** 2 > rr ** 2 for cx, cz, rr in keep_clear)

    # straw tufts standing up a little (3D, so they catch light and cast tiny shadows)
    for _ in range(60):
        x, z = r_.uniform(-6.2, 7.2), r_.uniform(-4.9, 3.0)
        if not clear(x, z):
            continue
        for j in range(int(r_.integers(4, 9))):
            a = r_.uniform(0, 2 * math.pi)
            ln = r_.uniform(0.08, 0.2)
            o = np.array([x + r_.uniform(-0.06, 0.06), 0.004, z + r_.uniform(-0.06, 0.06)])
            E.tube(dress, [o, o + np.array([math.cos(a) * ln, r_.uniform(0.0, 0.05), math.sin(a) * ln])], 0.006, sides=3,
                   mat="COL_straw")
    # coins spilled from a purse near the overturned table, playing cards near the first trestle
    for _ in range(14):
        x, z = 0.0 + r_.uniform(-0.7, 0.9), -2.6 + r_.uniform(-0.5, 0.6)
        if clear(x, z):
            E.lathe(dress, [(0.0, 0.0), (0.022, 0.0), (0.022, 0.006), (0.0, 0.006)], (x, 0.002, z), sides=8, mat="COL_brass")
    sack(dress, (0.95, 0.0, -2.35), yaw=40, s=0.28)
    for _ in range(6):
        x, z = -3.2 + r_.uniform(-0.6, 0.6), -1.9 + r_.uniform(-0.4, 0.4)
        yaw = r_.uniform(0, 180)
        R = E.rot_y(yaw)
        c = np.array([x, 0.004, z])
        pts = [c + R @ np.array(p) for p in ((-0.045, 0, -0.065), (0.045, 0, -0.065), (0.045, 0, 0.065), (-0.045, 0, 0.065))]
        E.quad_poly(dress, pts[::-1], "COL_cloth_cream")
    # splinters around the overturned table
    for _ in range(18):
        x, z = 0.6 + r_.uniform(-1.2, 1.2), -3.0 + r_.uniform(-0.7, 0.9)
        if not clear(x, z):
            continue
        a = r_.uniform(0, math.pi)
        ln = r_.uniform(0.06, 0.25)
        p0 = np.array([x, 0.012, z])
        E.board(dress, p0, p0 + np.array([math.cos(a) * ln, 0.0, math.sin(a) * ln]), r_.uniform(0.015, 0.04), 0.015,
                seed=int(r_.integers(0, 99999)), mat="TRI_planks", chips=2.0, step=0.03, step_x=0.05)
    # a dropped cosh and a thug's cap
    E.timber(dress, (2.45, 0.03, -1.15), (2.95, 0.05, -0.75), 0.05, 0.05, seed=4, r=0.02, mat="TRI_timber_dark", step=0.02)
    E.lathe(dress, [(0.0, 0.0), (0.13, 0.0), (0.12, 0.05), (0.08, 0.09), (0.0, 0.1)], (-1.75, 0.0, -0.95), sides=10,
            mat="COL_cloth_blue")
    # a rolled-away apple and onion, a toppled candle with a wax smear
    E.stone(dress, (1.65, 0.035, 0.55), (0.07, 0.07, 0.07), seed=9, mat="COL_meat", r=0.03, lump=0.003)
    E.timber(dress, (-2.1, 0.03, -2.65), (-1.95, 0.03, -2.5), 0.05, 0.05, seed=5, r=0.02, mat="COL_wax", step=0.02)


# ============================================================================================
# Poly Haven props
# ============================================================================================

PH_BUDGET = {
    "wine_barrel_01": 2500, "wooden_crate_01": 1500, "wooden_crate_02": 1500, "wooden_stool_02": 1200,
    "folding_wooden_stool": 1500, "wooden_picnic_table": 3500, "wooden_bucket_01": 1200, "wooden_bucket_02": 1500,
    "wicker_basket_01": 2500, "wooden_bowl_01": 800, "carved_wooden_plate": 600, "wooden_cutting_board": 500,
    "wooden_candlestick": 600, "wooden_lantern_01": 2000, "wooden_broom": 1500, "treasure_chest": 4000, "street_rat": 1500,
    "hamburger_buns": 800, "food_apple_01": 300, "yellow_onion": 300, "ceramic_pot": 1200, "brass_pot_01": 1200,
    "brass_pan_01": 800, "dutch_ship_medium": 9000, "ship_pinnace": 9000, "modular_wooden_pier": 6000, "wooden_ladder": 1500,
    "wooden_axe": 600,
}


def ph(name):
    import glob
    g = glob.glob(str(PH / name / "*.gltf"))[0]
    return E.ph_model(g, name, PH_BUDGET.get(name, 2000), HOLD)


def place(name, pos, yaw=0.0, s=1.0, tilt=(0.0, 0.0)):
    return E.ph_place(ph(name), PROPS, pos, yaw, s, tilt)


def props():
    # barrels: stacks by the far wall, by the bar, in the NW corner, on the quay
    for (p, yaw, s) in (((-7.1, 0, -4.75), 10, 1.0), ((-6.3, 0, -4.95), 70, 0.95), ((6.95, 0, 4.6), 30, 1.0),
                        ((6.2, 0, 4.85), 120, 0.9), ((-6.3, 0, 5.0), 15, 0.95), ((5.0, -0.18, -7.3), 40, 1.0),
                        ((5.8, -0.18, -7.0), 0, 0.9), ((-6.3, -0.18, -7.5), 20, 1.0)):
        place("wine_barrel_01", p, yaw, s)
    place("wine_barrel_01", (-6.7, 0.78, -4.85), 50, 0.85)           # stacked on top
    place("wine_barrel_01", (-3.0, 1.04, 3.75), 0, 0.55, tilt=(90, 0))   # kegs lying on the bar cradle
    place("wine_barrel_01", (-2.4, 1.04, 3.75), 0, 0.55, tilt=(90, 0))
    # crates
    for (p, yaw, s) in (((7.2, 0, 2.2), 85, 1.0), ((7.2, 0.35, 2.15), 95, 0.95), ((-5.2, 0, -5.05), 5, 1.0),
                        ((4.2, -0.18, -7.6), 30, 1.0)):
        place("wooden_crate_01", p, yaw, s)
    place("wooden_crate_02", (7.15, 0, 1.15), 0, 1.0)
    place("treasure_chest", (5.0, 0, 4.85), 180, 0.9)
    # trestles (picnic tables), chibi scale 0.82
    place("wooden_picnic_table", (-4.5, 0, -3.0), 90, 0.82)
    place("wooden_picnic_table", (-1.9, 0, -4.4), 90, 0.72)
    place("wooden_picnic_table", (5.1, 0, 0.35), 0, 0.8)
    # stools
    for (p, yaw) in (((-4.9, 0, 1.15), 10), ((-3.1, 0, 2.6), 70), ((-3.4, 0, 1.2), 200), ((3.9, 0, 1.6), 30), ((5.4, 0, 2.6), 120),
                     ((4.1, 0, 3.0), 300)):
        place("folding_wooden_stool", p, yaw, 0.95)
    place("folding_wooden_stool", (-1.6, 0.2, -2.6), 40, 0.95, tilt=(0, 80))   # knocked over
    place("wooden_stool_02", (-6.3, 0, 2.9), 10, 2.0)
    # buckets, broom, baskets
    place("wooden_bucket_01", (-6.7, 0, -2.4), 30, 1.1)
    place("wooden_bucket_02", (2.9, -0.18, -6.6), 0, 0.9)
    place("wooden_broom", (-7.55, 0.0, -3.25), 90, 1.25, tilt=(0, -12))
    place("wicker_basket_01", (5.9, 0, 3.9), 20, 1.4)
    place("ceramic_pot", (-6.9, 0, 3.4), 60, 0.8)
    place("brass_pot_01", (4.4, 0.0, -5.15), 0, 1.3)
    place("wooden_axe", (-6.2, 0.03, 2.3), 80, 1.6, tilt=(0, 85))
    # hanging pan on the chimney breast side
    place("brass_pan_01", (-7.03, 1.3, -1.78), 90, 1.4, tilt=(-90, 0))
    # tableware from Poly Haven on the round tables + snug
    place("carved_wooden_plate", (-4.05, 0.62, 2.1), 0, 1.3)
    place("wooden_bowl_01", (3.7, 0.62, 2.5), 0, 1.0)
    place("wooden_cutting_board", (6.2, 0.62, -3.8), 30, 1.2)
    place("hamburger_buns", (6.2, 0.64, -3.8), 30, 1.3)
    place("food_apple_01", (4.0, 0.62, 2.7), 0, 1.6)
    place("food_apple_01", (4.15, 0.62, 2.55), 90, 1.6)
    place("yellow_onion", (-4.3, 0.62, 1.8), 0, 1.6)
    place("wooden_candlestick", (5.0, 0.6, 0.6), 0, 1.4)
    anchors["candles"].append({"pos": [5.0, 0.93, 0.6]})
    place("street_rat", (6.6, 0.0, 3.05), 200, 2.6)
    place("street_rat", (-6.2, 0.0, -4.5), 120, 2.6)
    # more stock along the walls (Elliot-level density at the edges, the fighting floor stays clear)
    place("wooden_crate_01", (-3.45, 0, -5.15), 2, 0.95)
    place("wooden_crate_02", (-3.4, 0.36, -5.15), 88, 0.8)
    place("wine_barrel_01", (2.75, 0, -5.05), 15, 0.85)
    place("wooden_bucket_02", (3.2, 0, -4.75), 0, 0.75)
    place("wine_barrel_01", (7.35, 0, -1.9), 60, 0.9)
    place("wooden_crate_01", (7.35, 0, 0.0), 90, 0.9)
    place("wicker_basket_01", (-6.9, 0, -3.9), 70, 1.5)
    place("ceramic_pot", (-6.1, 0, -5.1), 10, 0.7)
    place("wooden_bucket_01", (-0.45, 0, -5.1), 120, 1.0)
    # moored boats on the water (background silhouettes)
    place("ship_pinnace", (2.0, -1.3, -12.8), 90, 0.22)
    place("dutch_ship_medium", (-8.5, -1.0, -13.5), 85, 0.3)


# ============================================================================================
# world colour pass + export
# ============================================================================================

def world_pass(v, c):
    x, y, z = v[:, 0], v[:, 1], v[:, 2]
    n = E.noise3(v, 77, 1.3)
    floor_grime = 0.45 * E.smoothstep(0.35, 0.0, y) * (0.7 + 0.3 * n)
    soot = np.exp(-((x + 7.6) / 1.5) ** 2 - (z / 2.4) ** 2) * E.smoothstep(1.0, 2.4, y) * 0.95
    smoke = 0.3 * E.smoothstep(2.0, 3.2, y)
    corner = 0.25 * E.smoothstep(7.2, 8.0, np.abs(x)) * E.smoothstep(0.8, 0.0, y)
    grime = np.clip(np.maximum.reduce([floor_grime, soot, smoke, corner]) + 0.08 * n, 0.0, 1.0)
    wet = np.exp(-((x - 1.2) / 1.6) ** 2 - ((z + D) / 1.4) ** 2) * E.smoothstep(0.5, 0.0, y)
    wet = np.maximum(wet, E.smoothstep(-D - 0.2, -D - 0.6, z) * E.smoothstep(0.3, -0.1, y))
    c = c.copy()
    c[:, 2] = np.maximum(c[:, 2], grime)
    c[:, 3] = np.maximum(c[:, 3], np.clip(wet, 0, 1))
    return c


def export():
    OUT.mkdir(parents=True, exist_ok=True)
    meta = {}
    for name, b in B.items():
        ob = b.build(SET, world_pass)
        if ob is not None:
            meta[name] = {"shadows": b.shadows}
    bpy.ops.object.select_all(action="DESELECT")
    for o in SET.objects:
        o.select_set(True)
    bpy.ops.export_scene.gltf(filepath=str(OUT / "taproom_arch.glb"), export_format="GLB", use_selection=True,
                              export_vertex_color="ACTIVE", export_normals=True, export_yup=True, export_apply=True,
                              export_materials="EXPORT")
    if not SKIP_PROPS:
        bpy.ops.object.select_all(action="DESELECT")
        for o in PROPS.objects:
            o.select_set(True)
        bpy.ops.export_scene.gltf(filepath=str(OUT / "taproom_props.glb"), export_format="GLB", use_selection=True,
                                  export_vertex_color="NONE", export_normals=True, export_yup=True, export_apply=True,
                                  export_image_format="JPEG", export_jpeg_quality=88)
    anchors["batches"] = meta
    (OUT / "taproom_anchors.json").write_text(json.dumps(anchors, indent=1))
    for o in SET.objects:
        print("BATCH", o.name, sum(len(p.vertices) - 2 for p in o.data.polygons))
    tris = sum(sum(len(p.vertices) - 2 for p in o.data.polygons) for o in SET.objects)
    print(f"TAPROOM arch objects={len(SET.objects)} tris={tris} props={len(PROPS.objects)}")


def main():
    far_wall()
    side_wall(-W, 1.0, {"posts": [-5.6, -4.1, -2.05, 2.05, 3.2, 5.6],
                        "bays": ["brace_l", "plain", "skip", "plain", "plain"],
                        "plinth_gaps": [(-1.75, 1.75)]})
    side_wall(W, -1.0, {"posts": [-5.6, -4.3, -2.6, -0.6, 1.4, 3.3, 5.6],
                        "bays": ["brace_r", "plain", "window", "brace_l", "plain", "brace_r"]})
    hearth()
    support_post(-3.0, -0.6)
    support_post(3.3, 0.6)
    bar()
    keg_rack(-2.7, 3.75)
    back_shelves(-4.6, 2.9, 5.45, levels=(0.45, 0.95, 1.45), facing=-1)
    back_shelves(5.75, 7.7, -5.36, levels=(1.65, 2.1), depth=0.28, facing=1)
    stairs()
    trap = (3.25, 3.35, 4.25, 4.3)
    trapdoor(*trap)
    floor_mesh(trap)
    settle((6.3, 0.0, -4.95), 2.4, 0.0)
    settle((7.55, 0.0, -3.4), 1.6, -90.0)
    stool((5.2, 0, -3.5))
    rug((-2.9, 0.0, 0.8), 2.4, 1.5, 6.0, 11)
    round_table((-4.0, 0, 1.95), yaw=10)
    round_table((3.75, 0, 2.35), yaw=40)
    trestle_bespoke((6.25, 0, -3.75), 2.0, 0.0)
    trestle_bespoke((0.6, 0.37, -3.0), 2.4, 70.0, overturned=True)
    bench((0.15, 0, -2.15), 2.0, 160.0, tilt=0.0)
    tabletop_spread((-4.0, 0, 1.95), 0.45, ["tankard", "tankard", "candle", "plate", "spill", "dice"])
    tabletop_spread((3.75, 0, 2.35), 0.45, ["tankard", "candle", "loaf", "jug", "tankard"])
    tabletop_spread((6.25, 0, -3.75), 0.5, ["tankard", "candle", "bottle", "plate"])
    tabletop_spread((-4.5, 0, -3.0), 0.75, ["tankard", "tankard", "plate", "candle", "bottle", "loaf"], top_h=0.615)
    tabletop_spread((5.1, 0, 0.35), 0.7, ["tankard", "plate", "candle", "jug", "spill"], top_h=0.6)
    tabletop_spread((-1.9, 0, -4.4), 0.5, ["tankard", "bottle", "candle"], top_h=0.54)
    candle_wheel((-3.0, 2.25, 1.35), hang_to=9.0)
    candle_wheel((3.3, 2.3, -2.4), radius=0.5, n=7, hang_to=7.0)
    hang_lantern((-3.0, 7.0, -3.3), 4.85)
    hang_lantern((3.3, 9.0, 2.0), 6.85)
    dressing()
    outside()
    foreground()
    if not SKIP_PROPS:
        props()
    export()


main()
