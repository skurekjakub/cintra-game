"""Hale v5: hood-up ready stance, silhouette A, critic round 2 rulings R4-R7. Spec: art-src/pixel/hale/spec.md.

Usage: python art-src/pixel/hale/hale_still.py
Writes art-src/pixel/hale/hale_1x.png, hale_8x.png and docs/art-direction/spike/hale-still-8x.png.
Rows are interior-only (x, string) segments, later ones overwrite; '.' is transparent.
`build()` adds Bertha's 1 px plum outline (4-connected) around the shape, and a lighter crimson
outline on the lit top/left edges of the hood and shoulders (spec ruling R2).
"""
from pathlib import Path

from PIL import Image

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
PAL = {
    'O': '#321524', 'P': '#7c2a42',
    'R': '#f4566a', 'r': '#dc3a56', 'q': '#a6284a', 'Q': '#5e1232',
    'S': '#fbecdc', 's': '#dcbcae', 'k': '#9c7682',
    'Y': '#ffc83c', 'y': '#e0801c', 'h': '#262030',
    'B': '#8aa4c6', 'b': '#6682ae', 'v': '#43567e',
    'L': '#be8048', 'l': '#865232', 'n': '#583228',
    'M': '#f4f8fc', 'm': '#b0bccf', 'g': '#78809a', 'G': '#40465e',
    't': '#464058',
}
LIT_OUTLINE_ROWS = range(0, 34)
W, H = 32, 34
R = {y: [] for y in range(H)}


def p(y: int, x: int, s: str) -> None:
    R[y].append((x, s))


# ---------- hilts (behind): they rise from behind the shoulders, guards on the shoulder edge ----------
def hilt(pommel: str, grip: str, guard: str, mirror: bool) -> None:
    """A 45-degree hilt: 2x2 pommel (y7-8), a 3-row 2 px grip, a skewed 2-row guard (y11-12)."""
    pix = [(2, 7, pommel[0]), (3, 7, pommel[1]), (2, 8, pommel[2]), (3, 8, pommel[3]),
           (3, 9, grip[0]), (4, 9, grip[0]), (4, 10, grip[1]), (5, 10, grip[1]), (5, 11, grip[0]), (6, 11, grip[0]),
           (7, 11, guard[0]), (8, 11, guard[0]), (6, 12, guard[1]), (7, 12, guard[1])]
    for x, y, ch in pix:
        p(y, W - 1 - x if mirror else x, ch)


hilt("gggg", "Ll", "gg", mirror=False)
hilt("Mmmm", "Gn", "mm", mirror=True)
# ---------- hood: crown lit, dark interior framing a shadowed, scowling face ----------
p(1, 15, "RR")
p(2, 13, "RRRRrr")
p(3, 11, "RRRRRrrrrq")
p(4, 10, "RRRRrrrrrrqq")
p(5, 9, "RRRrrrrrrrrrqq")
p(6, 9, "Rrrrrrrrrrrrqq")
p(7, 9, "rQ" + "hhhhsshhhh" + "Qq")
p(8, 9, "rQ" + "sshhsshhsk" + "Qq")
p(9, 9, "rQ" + "sYhYssYhYk" + "Qq")
p(10, 9, "rQ" + "SSsssssssk" + "Qq")
p(11, 9, "rQ" + "Sssskksssk" + "Qq")
p(12, 9, "rQ" + "QssssssskQ" + "Qq")
# ---------- cowl: collar shadow line, lit left shoulder, medallion pendant ----------
p(13, 6, "RRRq" + "Q" + "qqqqqqqqqq" + "Q" + "qrrq")
p(14, 5, "RRrrrrrrrrrrrrrrrrqqqq")
p(15, 5, "Rrrrrrrrrr" + "mG" + "rrrrrqqqqq")
# ---------- mantle swept back on the left (behind the sword arm), hanging in front on the right ----------
LEFT = {16: (4, "rqq"), 17: (4, "rqq"), 18: (4, "rq"), 19: (4, "rq"), 20: (3, "rq"), 21: (3, "rq"), 22: (3, "rq"),
        23: (3, "Rrqrrrq"), 24: (2, "Rrrqrrrq"), 25: (2, "Rrrqrrrq"), 26: (2, "Rrrqrrrq"), 27: (2, "Rrrqrrrq")}
# right panel: base r, one fold at x23 from the shoulder, a second opening at x26 toward the hem
RIGHT = {16: "Qrqrrq", 17: "Qrqrrq", 18: "Qrqrq", 19: "Qrqrq", 20: "Qrqq", 21: "Qrqq", 22: "Qrqrq",
         23: "Qrqrrq", 24: "Qrqrrqq", 25: "Qrqrrqrq", 26: "Qrqrrqrq", 27: "Qrqrrqrq"}
for y, (x, s) in LEFT.items():
    p(y, x, s)
for y, s in RIGHT.items():
    p(y, 21, s)
p(28, 2, "Rr"); p(28, 6, "rr"); p(28, 22, "rr"); p(28, 26, "rq")
# ---------- coat (one step darker), belt ----------
COAT = {16: "BBBbGGbbbv", 17: "BBBbbbbbbv", 18: "BBBbbbbbbv", 19: "BBBbbbbbbv", 20: "BBbbbbbbbv",
        21: "LLLLmlllll", 22: "BBbbbvbbbv", 23: "BBbbbvbbbbv", 24: "BBbbbvbbbbv", 25: "bbbbbvbbbvv"}
for y, s in COAT.items():
    p(y, 11 if y < 23 else 10, s)
# ---------- sword arm (his right, viewer's left): sleeve angled out, gloved fist ----------
p(16, 7, "BBb"); p(17, 7, "BBb")
p(18, 6, "BBb"); p(19, 6, "Bbv")
p(20, 5, "LLll"); p(21, 5, "Llln"); p(22, 5, "llnn")
# ---------- legs: wide stance, the right leg set out ----------
p(26, 10, "Gtt"); p(27, 10, "Gtt"); p(28, 10, "Gtt")
p(26, 18, "Gtt"); p(27, 19, "Gtt"); p(28, 20, "Gtt")
p(29, 9, "LLlln"); p(30, 9, "Llnnn"); p(31, 9, "nnnnn")
p(29, 20, "LLlln"); p(30, 20, "Llnnn"); p(31, 20, "nnnnn")


def rgb(hexs: str) -> tuple:
    c = hexs.lstrip('#')
    return tuple(int(c[j:j + 2], 16) for j in (0, 2, 4)) + (255,)


def chars() -> dict:
    g = {}
    for y in range(H):
        for x0, s in R[y]:
            for i, ch in enumerate(s):
                if ch != '.':
                    g[(x0 + i, y)] = ch
    return g


def outline_char(g: dict, x: int, y: int) -> str:
    """'P' on the lit top/left edge of the mantle in the upper rows, else the plum 'O'."""
    below_or_right = [g.get((x + 1, y)), g.get((x, y + 1))]
    above_or_left = [g.get((x - 1, y)), g.get((x, y - 1))]
    lit = any(c in ('R', 'r') for c in below_or_right) and not any(above_or_left)
    return 'P' if lit and y in LIT_OUTLINE_ROWS else 'O'


def build() -> Image.Image:
    g = chars()
    im = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    px = im.load()
    for (x, y), ch in g.items():
        px[x, y] = rgb(PAL[ch])
    for y in range(H):
        for x in range(W):
            if (x, y) not in g and any((x + dx, y + dy) in g for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
                px[x, y] = rgb(PAL[outline_char(g, x, y)])
    return im


def main() -> None:
    im = build()
    im.save(HERE / "hale_1x.png")
    big = im.resize((W * 8, H * 8), Image.NEAREST)
    bg = Image.new("RGBA", big.size, (58, 54, 66, 255))
    bg.alpha_composite(big)
    bg.save(HERE / "hale_8x.png")
    bg.save(ROOT / "docs/art-direction/spike/hale-still-8x.png")


if __name__ == "__main__":
    main()
