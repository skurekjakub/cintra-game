"""Preview sheet for a sprite: 1:1, 8x nearest, and the Aldermere character crop for comparison.

Usage: python art-src/pixel/preview.py <module> <frame> <out.png>
The reference crop is local-only (docs/art-direction/reference is gitignored); the output named
char-*.png contains it, so it must stay local too.
"""
import importlib
import sys
from pathlib import Path

from PIL import Image

sys.path.insert(0, str(Path(__file__).parent))
import pixelart  # noqa: E402

ROOT = Path(__file__).resolve().parents[2]
REF = ROOT / "docs/art-direction/reference/ref-aldermere-4.png"


def main():
    mod = importlib.import_module(sys.argv[1])
    frame = sys.argv[2]
    rgba, _ = pixelart.compile_rgba(pixelart.parse(mod.FRAMES[frame]))
    im = Image.fromarray(rgba, "RGBA")
    big = im.resize((im.width * 8, im.height * 8), Image.NEAREST)
    bg = (58, 54, 66, 255)
    ref = Image.open(REF).convert("RGBA").crop((935, 225, 1060, 395))
    ref_big = ref.resize((ref.width * 3, ref.height * 3), Image.NEAREST)
    W = 40 + im.width + 40 + big.width + 40 + ref_big.width + 40
    H = max(big.height, ref_big.height) + 80
    sheet = Image.new("RGBA", (W, H), bg)
    x = 40
    sheet.paste(im, (x, 40), im)
    x += im.width + 40
    sheet.paste(big, (x, 40), big)
    x += big.width + 40
    sheet.paste(ref_big, (x, 40))
    sheet.save(sys.argv[3])
    print("wrote", sys.argv[3], im.size)


main()
