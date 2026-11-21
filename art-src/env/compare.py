"""Side-by-side of a render and a reference frame (local critique aid, output is gitignored).
Usage: python art-src/env/compare.py <render.png> <reference.png> <out.png>"""
import sys

from PIL import Image

a = Image.open(sys.argv[1]).convert("RGB")
b = Image.open(sys.argv[2]).convert("RGB")
h = 1080
a = a.resize((int(a.width * h / a.height), h))
b = b.resize((int(b.width * h / b.height), h))
out = Image.new("RGB", (a.width + b.width + 16, h), (0, 0, 0))
out.paste(a, (0, 0))
out.paste(b, (a.width + 16, 0))
out = out.resize((out.width // 2, out.height // 2), Image.LANCZOS)
out.save(sys.argv[3])
print("compare", sys.argv[3])
