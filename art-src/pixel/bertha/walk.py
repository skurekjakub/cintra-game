"""Bertha walk, front-facing toward the camera (A12). 8 frames at 10 fps; every move is a whole pixel.

Keys: CONTACT (one foot planted forward, the back heel up), DOWN (weight lands: the chest
compresses 1 and everything above it drops 1), PASSING (the free foot tucks under the hem, the body
is back up), UP (the free foot reaches forward, heel first). The bob is exactly 1 px. The skirt does not bob, so the feet stay
readable under the hem in every frame; it only sways. Then the same
four on the other side. "L" is the foot on screen left.
- Arms swing against the legs: the free (screen-left) hand rides up 1 when that side's foot leads
  and drops 1 when the other foot leads, in 1 px steps. The tankard hand never swings or tilts (an
  innkeeper who doesn't spill); it only rides the body's bob.
Critic round 1 (A12): the lifted foot never vanishes and travels inward; the free hand moves as a
1 px pendulum; one neck-shadow row in every frame; the tankard bobs with her.
- The hem sways 1 px toward the planted foot one frame after contact (it trails the legs).
- The head trails the body's bob by one frame (overlapping action), so the bun settles after landing.
"""
import rig

E = rig.OFFSET
BOB = [1, 1, 0, 0, 1, 1, 0, 0]            # 1 px bob: low through contact and down, high through passing and up
# Feet (dx, dy): the trailing foot lifts its heel (only the sole shows under the hem), slides 1 px
# inward as it passes under the body and lands as a full shoe at its contact. Never fully hidden.
FOOT_L = [(0, 0), (0, 0), (0, 0), (0, 0), (0, -1), (0, -1), (1, -1), (0, -1)]
FOOT_R = [(0, -1), (0, -1), (-1, -1), (0, -1), (0, 0), (0, 0), (0, 0), (0, 0)]
# Free hand, height on screen (absolute, 1 px steps): back (up) while the left foot leads, forward
# (down) while the right foot leads.
HAND_L = [-1, -1, 0, 1, 1, 1, 0, -1]
HEM = [0, -1, -1, 0, 0, 1, 1, 0]          # hem: toward the planted side, a frame after contact
SLOTS = {"legL": (9, 10), "legR": (19, 20)}  # the stocking gaps in the hem outline (still row 29)


def at(x: int, y: int, ch: str) -> tuple:
    return (x + E[0], y + E[1], ch)


def frame(i: int) -> list:
    b = BOB[i]
    head = BOB[i - 1]                     # the head trails the body by one frame
    off = {"armL": (0, b), "armR": (0, b), "handR": (0, b), "mug": (0, b), "head": (0, head)}
    off["hem"] = (HEM[i], 0)
    off["legL"] = FOOT_L[i]
    off["legR"] = FOOT_R[i]
    # torso: the neck band rides with the head (exactly one neck-shadow row, always), the bib and belly
    # with the body; the belt stays on the skirt, so a dropped body compresses the belly 1 row
    bands = {"torso": [(15, 15, head), (16, 21, b)]}
    stretch = {}
    if head < b:   # shoulders reach up to the head that has not dropped yet
        stretch = {"armL": (15, b - head), "armR": (15, b - head)}
    below = {"armL": (18, HAND_L[i] - b)} if HAND_L[i] != b else {}
    return rig.pose(off, stretch=stretch, below=below, bands=bands, patches=_slots(off))


def _slots(off: dict) -> list:
    """The hem's stocking gaps travel with the swaying hem and close up (outline); a planted leg's
    stockings then show under the hem edge wherever the leg actually is. A lifted leg is tucked up
    behind the skirt."""
    hx = off["hem"][0]
    out = []
    for xs in SLOTS.values():
        out += [at(x + hx, 29, 'O') for x in xs]
    for leg, xs in SLOTS.items():
        dx, dy = off[leg]
        if dy == 0:
            out += [at(x + dx, 29, 'q') for x in xs]
    return out


FRAMES = [frame(i) for i in range(8)]
LABELS = ["0 contact L", "1 down", "2 pass", "3 up", "4 contact R", "5 down", "6 pass", "7 up"]
FPS = 10.0
SEQUENCE = list(range(8))
