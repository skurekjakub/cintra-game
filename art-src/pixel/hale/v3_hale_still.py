"""Hale v3: hood-up idle still, silhouette A. Spec: art-src/pixel/hale/spec.md.

Usage: python art-src/pixel/hale/hale_still.py
Writes art-src/pixel/hale/hale_1x.png, hale_8x.png and docs/art-direction/spike/hale-still-8x.png.
Rows are interior-only (x, string) segments, later ones overwrite; '.' is transparent.
`build()` adds Bertha's 1 px plum outline around the shape (4-connected), so the outline is not drawn.
"""
from pathlib import Path

from PIL import Image

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
PAL = {
    'O': '#321524',
    'R': '#d24a50', 'r': '#a22a40', 'q': '#641836', 'Q': '#3a0e28',
    'S': '#f4e2d0', 's': '#d4b2a6', 'k': '#946e7c',
    'Y': '#ffc23c', 'y': '#d4781c', 'h': '#262030',
    'B': '#86a2c4', 'b': '#55719c', 'v': '#33456c',
    'L': '#a86c3e', 'l': '#6c4028', 'n': '#3e2420',
    'M': '#eef2f8', 'm': '#a8b4c8', 'g': '#6a7088', 'G': '#3a3e54',
    't': '#2c2838',
}
W, H = 32, 34
R = {y: [] for y in range(H)}


def p(y: int, x: int, s: str) -> None:
    R[y].append((x, s))


# ---------- hilts (behind the hood): steel on his right (viewer's left), silver on his left ----------
p(4, 3, "mg"); p(5, 3, "gG")
p(6, 4, "Ll"); p(7, 4, "Ll")
for y in range(8, 12):
    p(y, 5, "Ll")
p(12, 2, "mgggG")
p(4, 27, "Mm"); p(5, 27, "mm")
p(6, 26, "vG"); p(7, 26, "vG")
for y in range(8, 12):
    p(y, 25, "vG")
p(12, 25, "MMmmm")
# ---------- hood: a soft ogive with a small tip, not a cone ----------
p(1, 15, "Rq")
p(2, 13, "RRrrqq")
p(3, 11, "RRRrrrrrqq")
p(4, 10, "RRrrrrrrrrqq")
p(5, 9, "RRrrrrrrrrrrqq")
p(6, 9, "RRrrrrrrrrrrqq")
p(7, 8, "RRrQQQQQQQQQQrqq")
p(8, 8, "RrQ" + "hhkkkkkkhh" + "Qqq")
p(9, 8, "RrQ" + "SOOOSSOOOs" + "Qqq")
p(10, 8, "RrQ" + "SYOySSYOys" + "Qqq")
p(11, 8, "RrQ" + "SSSSSSSssk" + "Qqq")
p(12, 8, "RrQ" + "sSSSkkSssk" + "Qqq")
p(13, 8, "RrQQQsSSsskQQQqq")
# ---------- body: broad mantle shoulders, the front parts downward over the coat ----------
p(14, 5, "RRRrrrQQkkkkkkQQrrqqqq")
p(15, 4, "RRrrrrQ" + "BBGbbbbGbv" + "QrqqqqQ")
p(16, 4, "RRrrrrQ" + "BBBGbbGbbv" + "QrqqqqQ")
p(17, 4, "RRrqrrQ" + "BBBbmGbbbv" + "QrqqqqQ")
p(18, 4, "RRrqrrQ" + "BBBbGGbbbv" + "QrqqqqQ")
p(19, 4, "RRrqrrQ" + "BBBbbbbbbv" + "QrqrqqQ")
p(20, 4, "RRrqRrQ" + "BBBbbbbbbv" + "QrqrqqQ")
p(21, 4, "RRrqRr" + "ln" + "LLlmmlll" + "ln" + "rqrqqQ")
p(22, 4, "RrqrRr" + "nn" + "BBbbbbbv" + "nn" + "rqrqqQ")
p(23, 4, "RrqrRQ" + "BBbbbvbbbbbv" + "QqrqqQ")
p(24, 4, "RrqrRQ" + "BBbbbvbbbbbv" + "QqrqqQ")
p(25, 3, "RRqrrR" + "Q" + "BBbbbvbbbbbv" + "Q" + "qrqqqQ")
p(26, 3, "RRqrrR" + "Q" + "Bbbbbvbbbbvv" + "Q" + "qrqqqQ")
p(27, 3, "Rq..rR" + "Q" + "vvvvvvvvvvvv" + "Q" + "qrq.QQ")
# ---------- legs and boots ----------
p(28, 11, "Gttt..Gttt")
p(29, 11, "Gttt..Gttt")
p(30, 10, "Lllln..Lllln")
p(31, 10, "nnnnn..nnnnn")


def rgb(hexs: str) -> tuple:
    c = hexs.lstrip('#')
    return tuple(int(c[j:j + 2], 16) for j in (0, 2, 4)) + (255,)


def build() -> Image.Image:
    im = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    px = im.load()
    for y in range(H):
        for x0, s in R[y]:
            for i, ch in enumerate(s):
                if ch != '.':
                    px[x0 + i, y] = rgb(PAL[ch])
    solid = {(x, y) for y in range(H) for x in range(W) if px[x, y][3]}
    for y in range(H):
        for x in range(W):
            if (x, y) not in solid and any((x + dx, y + dy) in solid for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
                px[x, y] = rgb(PAL['O'])
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
