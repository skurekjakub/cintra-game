"""Bertha cut-out rig (A12): splits the approved still into parts and re-poses them by whole pixels.

Every frame is the still's own pixels moved on the grid: no resampling, no rotation, no new colours.
A frame = per-part offsets (dx, dy) + optional per-part stretch + hand pixel patches.

Coordinates: still space is 30 x 32 (bertha_still.py); frames are FRAME x FRAME with the still placed
at OFFSET, so the feet sit on row FRAME-1 and there is headroom for the bob.
"""
from PIL import Image

import bertha_still as still

FRAME = 34
OFFSET = (2, 2)
PAL = {k: tuple(int(v.lstrip('#')[i:i + 2], 16) for i in (0, 2, 4)) for k, v in still.PAL.items()}


def still_grid() -> list:
    g = [['.'] * still.W for _ in range(still.H)]
    for y in range(still.H):
        for x0, s in still.R[y]:
            for i, ch in enumerate(s):
                if ch != '.':
                    g[y][x0 + i] = ch
    return g


STILL = still_grid()

# ---- parts: (x, y) sets in still space ------------------------------------------------------
def _box(x0, x1, y0, y1):
    return {(x, y) for y in range(y0, y1 + 1) for x in range(x0, x1 + 1) if STILL[y][x] != '.'}


HEAD = _box(0, 29, 0, 14)
MUG = _box(25, 29, 18, 23) | _box(24, 24, 19, 19) | _box(24, 24, 23, 23)
FOAM = {(x, 19) for x in range(25, 29)}
ARM_L = _box(0, 6, 15, 23) | _box(7, 7, 15, 19) | _box(8, 8, 15, 17)  # up to the shawl seam
HAND_R = _box(22, 24, 20, 23) - MUG
ARM_R = _box(20, 25, 15, 23) - MUG - HAND_R
# legs carry their stocking pixels and the hem outline beside them (hidden under the hem at rest)
LEG_L = _box(8, 11, 29, 29) | _box(7, 11, 30, 31)
LEG_R = _box(18, 21, 29, 29) | _box(19, 23, 30, 31)
TORSO = _box(7, 21, 15, 23) - ARM_L - ARM_R - HAND_R
HEM = _box(0, 29, 27, 29) - {(9, 29), (10, 29), (19, 29), (20, 29)}
SKIRT = _box(0, 29, 24, 26)
# Hidden under-layer: the hips and belt behind the hands, never seen in the still (the hands cover
# it), so a hand can move without leaving a hole. Moves with the body.
UNDER = {(5, y): 'O' for y in range(20, 24)} | {(6, y): 'G' for y in range(20, 23)} | {(6, 23): 't'}
UNDER |= {(x, y): 'g' for x in (22, 23) for y in range(20, 24)}
UNDER |= {(24, y): 'n' for y in range(20, 24)} | {(25, y): 'O' for y in range(20, 24)}
PARTS = {"under": set(UNDER), "legL": LEG_L, "legR": LEG_R, "hem": HEM, "skirt": SKIRT, "torso": TORSO, "armL": ARM_L,
         "armR": ARM_R, "handR": HAND_R, "mug": MUG, "head": HEAD}
# paint order: back to front
ORDER = ["under", "legL", "legR", "hem", "skirt", "torso", "armL", "armR", "head", "handR", "mug"]

_all = set().union(*(p for k, p in PARTS.items() if k != "under"))
assert sum(len(p) for k, p in PARTS.items() if k != "under") - len(_all) == 4, "parts overlap"  # hem outline by the legs
_opaque = {(x, y) for y in range(still.H) for x in range(still.W) if STILL[y][x] != '.'}
assert _all == _opaque, sorted(_opaque - _all)


def blank() -> list:
    return [['.'] * FRAME for _ in range(FRAME)]


def _stretch(pix: dict, row: int, n: int) -> dict:
    """Insert (n > 0) duplicates of `row` (pixels above move up), or delete it (n < 0, above moves down)."""
    out = {}
    for (x, y), ch in pix.items():
        if y < row:
            out[(x, y - n)] = ch
        elif y == row:
            out[(x, y)] = ch
            for k in range(1, n + 1):
                out[(x, y - k)] = ch
        else:
            out[(x, y)] = ch
    if n < 0:
        # rows strictly above `row` moved down by |n|: they overwrite `row`; keep their colours
        out = {}
        for (x, y), ch in pix.items():
            if y < row:
                out[(x, y - n)] = ch
            elif y > row:
                out[(x, y)] = ch
        for (x, y), ch in pix.items():
            if y == row and (x, y) not in out:
                out[(x, y)] = ch
    return out


def _stretch_below(pix: dict, row: int, n: int) -> dict:
    """Pixels below `row` move down n (n > 0: `row` is duplicated into the gap; n < 0: they move up over it)."""
    out = {}
    for (x, y), ch in pix.items():
        if y < row or (y == row and n > 0):
            out[(x, y)] = ch
    for (x, y), ch in pix.items():
        if y > row:
            out[(x, y + n)] = ch
    if n > 0:
        for (x, y), ch in pix.items():
            if y == row:
                for k in range(1, n + 1):
                    out.setdefault((x, y + k), ch)
    return out


def _bands(pix: dict, bands: list) -> dict:
    """Move horizontal bands of rows by dy each: bands = [(top, bottom, dy), ...]; other rows stay.
    Moved rows win overlaps over still ones, then lower rows; a row a band leaves empty is filled from
    the pixel below it (stretch)."""
    def dy(y: int) -> int:
        for top, bottom, d in bands:
            if top <= y <= bottom:
                return d
        return 0
    out = {}
    for (x, y), ch in sorted(pix.items(), key=lambda kv: (dy(kv[0][1]) != 0, kv[0][1])):
        out[(x, y + dy(y))] = ch
    cols = {}
    for (x, y) in out:
        cols.setdefault(x, []).append(y)
    for x, ys in cols.items():
        for y in range(max(ys) - 1, min(ys), -1):
            if (x, y) not in out and (x, y + 1) in out:
                out[(x, y)] = out[(x, y + 1)]
    return out


def pose(offsets: dict, stretch: dict | None = None, patches: list | None = None, below: dict | None = None,
         bands: dict | None = None) -> list:
    """offsets: part -> (dx, dy). stretch: part -> (row, n) applied before the offset.
    patches: [(x, y, ch)] in FRAME space, painted last ('.' erases). below: part -> (row, n), see
    _stretch_below (a hanging hand moving while its shoulder stays)."""
    g = blank()
    stretch = stretch or {}
    for name in ORDER:
        pix = dict(UNDER) if name == "under" else {(x, y): STILL[y][x] for (x, y) in PARTS[name]}
        st = stretch.get(name, [])
        for row, n in ([st] if isinstance(st, tuple) else st):
            pix = _stretch(pix, row, n)
        if name in (bands or {}):
            pix = _bands(pix, bands[name])
        if name in (below or {}):
            pix = _stretch_below(pix, *below[name])
        dx, dy = offsets.get(name, (0, 0))
        for (x, y), ch in pix.items():
            fx, fy = x + dx + OFFSET[0], y + dy + OFFSET[1]
            if 0 <= fx < FRAME and 0 <= fy < FRAME:
                g[fy][fx] = ch
    _fill_holes(g)
    for x, y, ch in patches or []:
        g[y][x] = ch
    return g


def _holes_of_still() -> set:
    g = blank()
    for (x, y) in _opaque:
        g[y + OFFSET[1]][x + OFFSET[0]] = STILL[y][x]
    out = set()
    for y in range(1, FRAME - 1):
        for x in range(1, FRAME - 1):
            nb = [g[y + 1][x], g[y - 1][x], g[y][x - 1], g[y][x + 1]]
            if g[y][x] == '.' and sum(c != '.' for c in nb) >= 3:
                out.add((x, y))
    return out


STILL_HOLES: set = set()


def _fill_holes(g: list) -> None:
    """A part that moved can uncover a pixel nobody owns. Fill any transparent pixel enclosed on 3+
    sides with its neighbours' majority colour (outline excluded; ties go to the pixel below)."""
    for y in range(1, FRAME - 1):
        for x in range(1, FRAME - 1):
            if g[y][x] != '.' or (x, y) in STILL_HOLES:
                continue
            nb = [g[y + 1][x], g[y - 1][x], g[y][x - 1], g[y][x + 1]]
            filled = sum(c != '.' for c in nb)
            if filled < 3 or (filled == 3 and 'O' in nb):  # a notch in the outline is a real notch
                continue
            cols = [c for c in nb if c not in '.O'] or ['O']
            g[y][x] = max(cols, key=lambda c: (cols.count(c), c == nb[0]))


def to_image(g: list) -> Image.Image:
    im = Image.new("RGBA", (FRAME, FRAME), (0, 0, 0, 0))
    px = im.load()
    for y, row in enumerate(g):
        for x, ch in enumerate(row):
            if ch != '.':
                px[x, y] = PAL[ch] + (255,)
    return im


def mass(g: list) -> int:
    return sum(ch != '.' for row in g for ch in row)


STILL_HOLES = _holes_of_still()
