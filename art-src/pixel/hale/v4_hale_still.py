"""Hale v4: hood-up idle still, silhouette A, critic round 1 fixes. Spec: art-src/pixel/hale/spec.md.

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
    'R': '#ee5660', 'r': '#c43a4e', 'q': '#8e2444', 'Q': '#561634',
    'S': '#fbecdc', 's': '#dcbcae', 'k': '#9c7682',
    'Y': '#ffc83c', 'y': '#e0801c', 'h': '#262030',
    'B': '#9ab4d2', 'b': '#7090ba', 'v': '#4a5e88',
    'L': '#b87a46', 'l': '#7a4a2e', 'n': '#4a2a22',
    'M': '#f4f8fc', 'm': '#b0bccf', 'g': '#78809a', 'G': '#40465e',
    't': '#3a3448',
}
LIT_OUTLINE_ROWS = range(0, 34)
W, H = 32, 34
R = {y: [] for y in range(H)}


def p(y: int, x: int, s: str) -> None:
    R[y].append((x, s))


def hilt(pommel: str, grip: str, guard: str, mirror: bool) -> None:
    """A 45-degree hilt rising up and out from behind the shoulder: 2x2 pommel, 3-row 2 px grip,
    and a 3 px guard perpendicular to the grip. `mirror` flips it to the right shoulder."""
    pix = [(2, 3, pommel[0]), (3, 3, pommel[1]), (2, 4, pommel[2]), (3, 4, pommel[3]),
           (3, 5, grip[0]), (4, 5, grip[0]), (4, 6, grip[1]), (5, 6, grip[1]), (5, 7, grip[0]), (6, 7, grip[0]),
           (7, 7, guard[0]), (8, 7, guard[0]), (7, 8, guard[1]), (6, 9, guard[2])]
    for x, y, ch in pix:
        if mirror:
            x = W - 1 - x
        p(y, x, ch)


# ---------- hilts: steel on his right (viewer's left), silver on his left; one silver glint ----------
hilt("ggGG", "Ll", "ggG", mirror=False)
hilt("mMmm", "Gn", "mmg", mirror=True)
# ---------- hood: ogive with a small tip, 1 px walls at the face ----------
p(1, 15, "Rr")
p(2, 13, "RRRrrq")
p(3, 11, "RRRRrrrrqq")
p(4, 10, "RRRRrrrrrrqq")
p(5, 9, "RRRrrrrrrrrrqq")
p(6, 9, "RRrrrrrrrrrrqq")
p(7, 9, "RQ" + "hhhhhhhhhh" + "Qq")
p(8, 9, "R" + "hSSSSSSSSSsh" + "q")
p(9, 9, "R" + "SShhhSShhhSs" + "q")
p(10, 9, "R" + "SSYhySSYhySs" + "q")
p(11, 9, "R" + "SSsssSSsssss" + "q")
p(12, 9, "R" + "sSSSSkkSSSsk" + "q")
p(13, 8, "RrQQsSSSSSskQQqq")
# ---------- shoulders: lit plane left, cast shadow under the hood hem ----------
p(14, 5, "RRqqq" + "qqkkkkkkkkQQ" + "QQQrr")
p(15, 4, "RRRrqq" + "q" + "BBGbbbbGbv" + "Q" + "QQqrrQ")


def left_panel(f: int) -> str:
    """x4..9: lit outer plane, a 2 px fold at x=f, lit front plane."""
    return "".join("r" if x in (f, f + 1) else "R" for x in range(4, 10))


def right_panel(g: int) -> str:
    """x22..27: lit front plane, a 2 px fold at x=g, the darkest value only at the outer edge."""
    return "".join("q" if x in (g, g + 1) or x > g + 1 else "r" for x in range(22, 28))


COAT = {16: "BBBGbbGbbv", 17: "BBBbmGbbbv", 18: "BBBbGGbbbv", 19: "BBBbbbbbbv", 20: "BBBbbbbbbv",
        21: "LLLLmmLlll", 22: "BBbbbvbbbv", 23: "BBbbbvbbbv", 24: "BBbbbvbbbv", 25: "BBbbbvbbbv",
        26: "Bbbbbvbbvv", 27: "vvvvvvvvvv"}
for y in range(16, 28):
    f = 7 if y < 20 else (6 if y < 24 else 5)
    g = 23 if y < 20 else (24 if y < 24 else 25)
    p(y, 4, left_panel(f) + "q" + COAT[y] + "Q" + right_panel(g))
# hem: 1 px flare at y25-26, 2 px at y27, then 2 px tatters
p(25, 3, "R"); p(26, 3, "R"); p(25, 28, "Q"); p(26, 28, "Q")
p(27, 2, "RR"); p(27, 28, "QQ")
p(28, 2, "Rr"); p(28, 6, "rR"); p(28, 24, "rq"); p(28, 28, "qQ")
# ---------- arms: a sleeve cuff and a leather glove breaking each lining column ----------
p(19, 9, "bb"); p(19, 21, "bv")
p(20, 9, "LL"); p(20, 21, "Ll")
p(21, 9, "ll"); p(21, 21, "ln")
# ---------- legs and boots ----------
p(28, 11, "Gttt..Gttt")
p(29, 11, "Gttt..Gttt")
p(30, 10, "LLlln..LLlln")
p(31, 10, "nnnnn..nnnnn")


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
