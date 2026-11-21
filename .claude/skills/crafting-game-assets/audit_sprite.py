"""Objective sprite audit: run it after every render; gates come from your spec.

Usage: python -I audit_sprite.py sprite_1x.png [--max-colours N] [--max-noise PCT] [--height MIN-MAX]
Prints the size, colour count, isolated-pixel % and height, and exits 1 if any gate fails.
An isolated pixel is an opaque pixel with no 4-neighbour of the same colour. Above about 8% it reads as noise.
"""
import argparse
import sys

from PIL import Image


def audit(path: str) -> dict:
    im = Image.open(path).convert("RGBA")
    w, h = im.size
    px = im.load()
    opaque = [(x, y) for y in range(h) for x in range(w) if px[x, y][3] > 0]
    if not opaque:
        return {"w": w, "h": h, "colours": 0, "noise_pct": 0.0, "fig_h": 0, "fig_w": 0}
    colours = {px[x, y] for x, y in opaque}
    iso = 0
    for x, y in opaque:
        c = px[x, y]
        same = any(
            0 <= x + dx < w and 0 <= y + dy < h and px[x + dx, y + dy] == c
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))
        )
        iso += 0 if same else 1
    ys = [y for _, y in opaque]
    xs = [x for x, _ in opaque]
    return {
        "w": w, "h": h, "colours": len(colours),
        "noise_pct": round(100.0 * iso / len(opaque), 1),
        "fig_h": max(ys) - min(ys) + 1, "fig_w": max(xs) - min(xs) + 1,
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("sprite")
    ap.add_argument("--max-colours", type=int, default=32)
    ap.add_argument("--max-noise", type=float, default=8.0)
    ap.add_argument("--height", default="")
    a = ap.parse_args()
    r = audit(a.sprite)
    fails = []
    if r["colours"] > a.max_colours:
        fails.append(f"colours {r['colours']} > {a.max_colours}")
    if r["noise_pct"] > a.max_noise:
        fails.append(f"isolated pixels {r['noise_pct']}% > {a.max_noise}%")
    if a.height:
        lo, hi = (int(v) for v in a.height.split("-"))
        if not lo <= r["fig_h"] <= hi:
            fails.append(f"figure height {r['fig_h']} outside {lo}-{hi}")
    print(r)
    print("PASS" if not fails else "FAIL: " + "; ".join(fails))
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
