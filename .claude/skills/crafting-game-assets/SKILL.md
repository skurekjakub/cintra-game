---
name: crafting-game-assets
description: Use when producing game art in code or in Blender (pixel sprites, sprite sheets, textures, tiles, 3D props or sets), especially against a reference image or a "production quality" bar, or when earlier assets were judged amateur, flat, noisy, toy-like or generic.
---

# Crafting game assets

## Overview
Blind-judged tests (`docs/skill-tests/crafting-game-assets/RESULTS.md`) showed two things. The model's *unguided* first sprite is clean and appealing, and *more craft rules made sprites worse*: each added rim, hue-shift or detail became noise at small scale. Artists also graded their own work as finished while a blind judge found 4–6 flaws. So this skill relies on **objective gates and an independent critic**, not on piling up techniques.

## 1. Fix scale and budget from the GAME, then copy style from the reference
- **Target figure height:** measure the sprites already in the game scene, or the art bible. Do not take it from the reference's resolution. Fewer pixels than the design needs produces mush.
- **Colour budget:** at most the reference's count; about 24–32 for a 32 px figure.
- **Style to copy from the reference:** proportions (the head-to-body ratio), palette mood, light direction, face language, and how the outline is drawn.
- Write these as a short spec before drawing.

## 2. Draw for clarity first
- **Silhouette:** make 3–5 solid-black variants that differ in silhouette and proportion. Pick the one that says who this is from the black shape alone.
- **Big clusters:** 3–4 values per material, light from one side, no single stray pixels.
- **A focal hierarchy:** the face is the brightest, highest-contrast area. Large areas (apron, cloak) sit a value below it.
- **Props are readable:** the key prop sits outside the body silhouette.
- **Appeal:** a clear expression beats anatomical detail; a closed-eye smile reads at 1×.

## 3. Add a refinement only if it survives the gates
Hue-shifted ramps, tinted outlines, a 1 px rim, manual anti-aliasing: each is optional. Add one at a time, re-run the audit, and keep it only if the sprite still passes **and** it reads better at 1× on the real backdrop. When in doubt, leave it out.

## 4. Gate every render objectively
Run `python -I <this skill dir>/audit_sprite.py sprite_1x.png --max-colours N --max-noise 8 --height LO-HI` after every render.
- A failing gate is a gap, whatever your eye says.
- An isolated-pixel rate above 8% is noise, every time.

## 5. Use a critic who did not draw it
- **Your own critique is not a stopping condition.**
- **If you can dispatch agents:** give a fresh agent the 1× sprite pasted on the real in-game backdrop, the 8× view and the reference, and ask for the 5 worst flaws. Fix them and repeat until the critic's worst flaw is minor at 1×. Every hero asset gets at least 2 rounds. In the blind test, one critic round added +6/50 and was the single largest gain; the gates alone gave a clean but lifeless sprite.
- **If you cannot dispatch agents:** finish, run the audit, and hand back with the render paths. The orchestrator runs the critic.
- Give every critic the written spec (section 1), and add each ruling to it. Fresh critics without a shared spec can reverse each other: in the test, one said "widen the body" and the next "the body is too wide". The person running the loop rules on conflicts with a number.
- Every critique names a specific gap ("the white cap and sleeves form one mass"), never "make it better".

## 6. One step at a time
- One asset, frame or stage at a time.
- For animation: key poses first, then in-betweens.
- Change one aspect per iteration, so the audit and the critic can tell what helped.

## 7. 3D in Blender (CLI or MCP)
- **Plan first:** a part list in real metres, the materials, and the **in-game camera and on-screen pixel size**. State the Blender version.
- **Stages, each rendered from the hero view and the in-game camera at 1×:**
  1. blockout;
  2. form (bevels, sag, nothing perfectly straight);
  3. surface;
  4. a **weathering pass** scaled to show at game size (edge wear, grime, stains);
  5. bake.
- **Bake** procedural materials to image textures. Export the GLB, **re-import it and render from the import**, and check the triangle and texture budget.
- The independent critic (5) applies here too.
