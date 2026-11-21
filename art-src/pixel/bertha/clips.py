"""Cut Bertha's review clips from a shot_runner --record capture (A12).

Usage:
  python clips.py scene  <rec_dir> <out_dir>   # bertha-scene.mp4 (full frame) + .gif (1:1 crop of her path)
                                               # + bertha-walk-closeup.* (crop that tracks her) + bertha-scene.png
  python clips.py idle   <rec_dir> <out_dir>   # bertha-idle-closeup.* (fixed crop, she idles in place)

The capture is 1920x1080 at a fixed 50 fps; <rec_dir>/track.csv holds, per frame, the card's snapped
top-left screen corner and the art frame shown. Close-ups are nearest-neighbour 6x of the capture.
"""
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

from PIL import Image

FFMPEG = (r"C:\Users\skure\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe"
          r"\ffmpeg-9.0.2-full_build\bin\ffmpeg.exe")
FPS = 50
CARD = 102          # 34 texels x 3 px
MARGIN = (24, 14)   # close-up margin around the card (capture px)
ZOOM = 6


def track(rec: Path) -> list:
    rows = []
    for line in (rec / "track.csv").read_text().split():
        i, x, y, f = (int(v) for v in line.split(","))
        rows.append((i, x, y, f))
    return rows


def frame(rec: Path, i: int) -> Image.Image:
    return Image.open(rec / f"frame_{i:05d}.png").convert("RGB")


def closeup(img: Image.Image, x: int, y: int) -> Image.Image:
    box = (x - MARGIN[0], y - MARGIN[1], x + CARD + MARGIN[0], y + CARD + MARGIN[1])
    c = img.crop(box)
    return c.resize((c.width * ZOOM, c.height * ZOOM), Image.NEAREST)


def encode(frames_dir: Path, out: Path, gif_fps: int, gif_dir: Path | None = None) -> None:
    """MP4 at the capture's 50 fps. GIF: frames dropped evenly to gif_fps (50 -> 25 keeps every second
    frame), or, with gif_dir, exactly the frames in gif_dir played at gif_fps; one global palette."""
    pat = str(frames_dir / "f_%05d.png")
    run = [FFMPEG, "-y", "-loglevel", "error", "-framerate", str(FPS), "-i", pat]
    subprocess.run(run + ["-c:v", "libx264", "-preset", "slow", "-crf", "16", "-pix_fmt", "yuv420p",
                          "-vf", "pad=ceil(iw/2)*2:ceil(ih/2)*2", str(out.with_suffix(".mp4"))], check=True)
    pal = "split[a][b];[a]palettegen=max_colors=256:stats_mode=full[p];[b][p]paletteuse=dither=none:diff_mode=rectangle"
    if gif_dir is None:
        gif = run + ["-vf", f"fps={gif_fps}," + pal]
    else:
        gif = [FFMPEG, "-y", "-loglevel", "error", "-framerate", str(gif_fps), "-i", str(gif_dir / "f_%05d.png"),
               "-vf", pal]
    subprocess.run(gif + ["-loop", "0", str(out.with_suffix(".gif"))], check=True)
    print(out.with_suffix(".mp4"), out.with_suffix(".mp4").stat().st_size // 1024, "KB;",
          out.with_suffix(".gif"), out.with_suffix(".gif").stat().st_size // 1024, "KB")


def write(frames: list, tmp: Path) -> Path:
    d = tempfile.mkdtemp(dir=tmp)
    for k, im in enumerate(frames):
        im.save(Path(d) / f"f_{k:05d}.png")
    return Path(d)


def scene(rec: Path, out: Path, tmp: Path) -> None:
    tr = track(rec)
    # full-frame MP4
    d = Path(tempfile.mkdtemp(dir=tmp))
    for i, *_ in tr:
        shutil.copy(rec / f"frame_{i:05d}.png", d / f"f_{i:05d}.png")
    subprocess.run([FFMPEG, "-y", "-loglevel", "error", "-framerate", str(FPS), "-i", str(d / "f_%05d.png"),
                    "-c:v", "libx264", "-preset", "slow", "-crf", "18", "-pix_fmt", "yuv420p",
                    str(out / "bertha-scene.mp4")], check=True)
    # GIF: a 1:1 crop that holds her whole path (the full frame cannot fit 8 MB and she would be 1 px/texel)
    xs = [x for _, x, _, _ in tr]
    ys = [y for _, _, y, _ in tr]
    cx, cy = (min(xs) + max(xs) + CARD) // 2, (min(ys) + max(ys) + CARD) // 2
    cx, cy = min(max(cx, 320), 1920 - 320), min(max(cy, 200), 1080 - 200)
    box = (cx - 320, cy - 200, cx + 320, cy + 200)
    gd = write([frame(rec, i).crop(box) for i, *_ in tr], tmp)
    vf = "fps=25,split[a][b];[a]palettegen=max_colors=256:stats_mode=full[p];[b][p]paletteuse=dither=bayer:bayer_scale=4:diff_mode=rectangle"
    subprocess.run([FFMPEG, "-y", "-loglevel", "error", "-framerate", str(FPS), "-i", str(gd / "f_%05d.png"),
                    "-vf", vf, "-loop", "0", str(out / "bertha-scene.gif")], check=True)
    print("scene gif", (out / "bertha-scene.gif").stat().st_size // 1024, "KB, crop", box)
    # walk close-up: from 0.3 s before she starts moving to 0.6 s after she stops
    moving = [k for k in range(1, len(tr)) if tr[k][1:3] != tr[k - 1][1:3]]
    a, b = max(0, moving[0] - 15), min(len(tr), moving[-1] + 30)
    walk = [closeup(frame(rec, tr[k][0]), tr[k][1], tr[k][2]) for k in range(a, b)]
    # the 50 fps close-up GIF would be ~19 MB: the GIF keeps one capture frame from the middle of each
    # 100 ms walk frame and plays at 10 fps, so the sprite's timing is exact (the background steps)
    first = moving[0] - 1                       # the capture frame where the walk strip starts
    picks = [walk[k - a] for k in range(a, b) if (k - first) % 5 == 2]
    encode(write(walk, tmp), out / "bertha-walk-closeup", 10, write(picks, tmp))
    print("walk close-up frames", a, b)


def idle(rec: Path, out: Path, tmp: Path, loops: int = 2) -> None:
    tr = track(rec)
    n = int(round(2.16 * FPS)) * loops          # the idle timing chart is 18 steps x 120 ms
    i0, x, y, _ = tr[0]
    frames = [closeup(frame(rec, tr[k][0]), x, y) for k in range(n)]
    assert all(t[1:3] == (x, y) for t in tr[:n]), "the card moved during an idle capture"
    encode(write(frames, tmp), out / "bertha-idle-closeup", 25)
    frame(rec, tr[0][0]).save(out / "bertha-scene.png")


def main() -> None:
    mode, rec, out = sys.argv[1], Path(sys.argv[2]), Path(sys.argv[3])
    tmp = Path(tempfile.mkdtemp())
    try:
        {"scene": scene, "idle": idle}[mode](rec, out, tmp)
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


if __name__ == "__main__":
    main()
