# Skill test results: `crafting-game-assets`

## P0: baseline, no guidance (opus, 16 tool calls, 3.2 min)
Output: a 36×46 chibi Bertha (ginger bun, teal dress, apron, tankard). 5 renders.

**What it did on its own:**
- Read the reference and made a close-up crop of it.
- Looked at every render and fixed what it saw (the mouth, the apron folds).
- Built the sprite from a palette-indexed character map with an automatic outline.

**What it did not do:**
- Wrote no numeric spec: no target pixel height measured from the reference, no palette count, no light direction.
- Made no variants.

**Orchestrator's view:** clean and readable, much better than the spike's early sprites. It falls short of shippable for four reasons:
- **Outline:** uniformly black everywhere, with no selective or coloured outline.
- **Shading:** 2–3 flat value steps per material, with no hue-shift (the shadows are just darker versions of the same colour) and no rim light or key-light side.
- **Silhouette:** a rectangle-on-rectangle body and blob hands; the "heavy-set" build reads as boxy, not soft.
- **Polish:** no manual anti-aliasing on the curves (the bun and shoulders are stair-stepped).

The craft rules (M2) and a written critique against the reference (M3) are the levers to test.

## D0: baseline, no guidance
(pending)
