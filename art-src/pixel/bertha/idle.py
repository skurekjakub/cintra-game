"""Bertha idle (A12). Key poses first, then the in-betweens; every move is a whole pixel.

Keys: REST (the approved still), INHALE (chest, head, arms and tankard up 1), SETTLE (head and
shoulders sink 1, the skirt flares 1 at the hem: what sinks spreads, so the mass holds).
In-betweens: CHEST (the chest leads the breath, carrying the head: it rises before the arms) and LAG
(the chest is back down, the arms and tankard follow one frame later). BLINK frames sit on REST.
Critic round 1 (A12): one neck-shadow row in every frame; settle shown for one step only; the foam
crown holds after the settle; the blink is half, shut, open.
The tankard foam lags the hand: it dips when the mug rises and crowns over the rim when it falls.
"""
import rig

E = rig.OFFSET  # still -> frame offset
# Shoulders up: the head and the tankard arm lift 1; the free left arm hangs (its shoulder rises,
# the sleeve lengthens 1 px, the hand stays put).
UP_ALL = {"head": (0, -1), "armR": (0, -1), "handR": (0, -1), "mug": (0, -1)}
DOWN_ALL = {"head": (0, 1), "armR": (0, 1), "handR": (0, 1), "mug": (0, 1)}


def at(x: int, y: int, ch: str, dy: int = 0) -> tuple:
    """A patch given in still coordinates (dy = the owning part's vertical offset)."""
    return (x + E[0], y + E[1] + dy, ch)


def foam_dip(dy: int) -> list:
    # the foam lags the rising mug: its highlight sinks to the back half of the cup
    return [at(25, 19, 'a', dy), at(26, 19, 'C', dy), at(27, 19, 'C', dy), at(28, 19, 'a', dy)]


def foam_crown(dy: int) -> list:
    # the foam keeps rising as the mug drops: a 2 px crown over the rim
    return [at(26, 18, 'W', dy), at(27, 18, 'C', dy), at(26, 17, 'O', dy), at(27, 17, 'O', dy),
            at(25, 18, 'O', dy), at(28, 18, 'O', dy)]


def eyes(top: str, bottom: str) -> list:
    return [at(12, 10, top), at(17, 10, top), at(12, 11, bottom), at(17, 11, bottom)]


def skirt_flare() -> list:
    # hem spreads 1 px each side on the two lowest skirt rows (outline moves out, cloth fills in)
    return [at(3, 27, 'O'), at(4, 27, 'G'), at(3, 28, 'O'), at(4, 28, 'g'),
            at(27, 27, 'O'), at(26, 27, 'n'), at(27, 28, 'O'), at(26, 28, 'n'),
            at(3, 29, 'O'), at(27, 29, 'O')]


REST = rig.pose({})
# the chest carries the head (the neck shadow stays exactly one row) and the shoulder tops; the arms
# and the tankard follow one frame later and drop one frame later
CHEST = rig.pose({"head": (0, -1)}, stretch={"torso": (22, 1), "armL": (15, 1), "armR": (15, 1)})
INHALE = rig.pose(UP_ALL, stretch={"torso": (22, 1), "armL": (17, 1)}, patches=foam_dip(-1))
LAG = rig.pose({"armR": (0, -1), "handR": (0, -1), "mug": (0, -1)}, stretch={"armL": (17, 1)})
SETTLE = rig.pose(DOWN_ALL, stretch={"torso": (22, -1), "armL": (17, -1)}, patches=skirt_flare() + foam_crown(1))
RISE = rig.pose({}, patches=foam_crown(0))
HALF = rig.pose({}, patches=eyes('k', 'O'))
# shut: the lid line is 2 px wide, so the closed eye reads at 1x instead of vanishing into the skin
SHUT = rig.pose({}, patches=eyes('S', 'D') + [at(11, 11, 'D'), at(18, 11, 'D')])

FRAMES = [REST, CHEST, INHALE, LAG, RISE, SETTLE, HALF, SHUT]
LABELS = ["0 rest", "1 chest", "2 inhale", "3 arms lag", "4 foam crown", "5 settle", "6 half", "7 shut"]
# Timing chart at FPS: one breath with a hold at the top and a sink at the bottom, then a blink.
FPS = 25.0 / 3.0
SEQUENCE = [0, 0, 1, 2, 2, 2, 3, 4, 4, 5, 4, 0, 0, 0, 6, 7, 0, 0]
