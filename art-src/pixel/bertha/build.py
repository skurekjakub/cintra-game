"""Build Bertha's animation sheets (A12): horizontal strips of 34x34 frames + matching normal maps,
a per-frame audit with the still's gates, and the review sheets.

Usage: python art-src/pixel/bertha/build.py [review_dir]
Writes game/spikes/hd2d/sprites/bertha_{idle,walk}.png and *_n.png, bertha_anim.json (frame size,
feet row, fps, play sequence) and docs/art-direction/spike/bertha-frames.png (every frame at 8x).
review_dir (optional) receives contact / onion-skin / diff sheets and the 1x frames that were audited.
"""
import json
import subprocess
import sys
from pathlib import Path

from PIL import Image

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import idle  # noqa: E402
import rig  # noqa: E402
import sheets  # noqa: E402
import walk  # noqa: E402

ROOT = HERE.parents[2]
OUT = ROOT / "game/spikes/hd2d/sprites"
DOCS = ROOT / "docs/art-direction/spike"
AUDIT = ROOT / ".claude/skills/crafting-game-assets/audit_sprite.py"
GATES = ["--max-colours", "28", "--max-noise", "8", "--height", "30-34"]
ANIMS = {"bertha_idle": idle, "bertha_walk": walk}


def audit(frames: list, name: str, tmp: Path) -> bool:
    ok = True
    for i, g in enumerate(frames):
        p = tmp / f"{name}_{i}.png"
        rig.to_image(g).save(p)
        r = subprocess.run([sys.executable, "-I", str(AUDIT), str(p), *GATES], capture_output=True, text=True)
        print(f"{name}[{i}] " + r.stdout.strip().replace("\n", "  "))
        ok = ok and r.returncode == 0
    return ok


def main() -> int:
    review = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "reports/bertha_review"
    review.mkdir(parents=True, exist_ok=True)
    meta = {}
    ok = True
    for name, mod in ANIMS.items():
        frames = mod.FRAMES
        ok = audit(frames, name, review) and ok
        sheets.strip([sheets.rgba(g) for g in frames]).save(OUT / f"{name}.png")
        sheets.strip([sheets.normal(g) for g in frames]).save(OUT / f"{name}_n.png")
        meta[name] = {"frame": [rig.FRAME, rig.FRAME], "frames": len(frames), "feet_row": rig.FRAME - 1,
                      "fps": mod.FPS, "sequence": mod.SEQUENCE}
        sheets.contact(frames, mod.LABELS, 8).save(review / f"{name}_contact.png")
        sheets.onion(frames, 8).save(review / f"{name}_onion.png")
        sheets.diffmap(frames, 8).save(review / f"{name}_diff.png")
        print(name, "mass per frame:", [rig.mass(g) for g in frames])
    (OUT / "bertha_anim.json").write_text(json.dumps(meta, indent=1))
    rows = [sheets.contact(m.FRAMES, m.LABELS, 8) for m in ANIMS.values()]
    w = max(r.width for r in rows)
    sheet = Image.new("RGBA", (w, sum(r.height for r in rows)), sheets.BG)
    y = 0
    for r in rows:
        sheet.alpha_composite(r, (0, y))
        y += r.height
    sheet.save(DOCS / "bertha-frames.png")
    print("all frames pass the audit" if ok else "AUDIT FAILURES")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
