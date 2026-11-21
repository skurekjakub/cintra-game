"""Mean luminance (Rec. 601) over opaque pixels and the standard deviation (value contrast) and the plum-outline share (spec rulings R1, R4-R7).

Usage: python lum.py sprite.png [frame_width]   (frame_width crops frame 0 of a strip)
"""
import sys

import numpy as np
from PIL import Image

im = Image.open(sys.argv[1]).convert("RGBA")
if len(sys.argv) > 2:
    im = im.crop((0, 0, int(sys.argv[2]), im.height))
a = np.array(im).reshape(-1, 4)
a = a[a[:, 3] > 0].astype(float)
lum = 0.299 * a[:, 0] + 0.587 * a[:, 1] + 0.114 * a[:, 2]
plum = np.all(a[:, :3] == (0x32, 0x15, 0x24), axis=1)
print(f"mean_lum {lum.mean():.1f}  std {lum.std():.1f}  outline_share {100 * plum.mean():.1f}%  opaque {len(a)}")
