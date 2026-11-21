# Skill test plan: `crafting-game-assets`

The skill is tested the TDD way (superpowers:writing-skills): baseline first, then add methods one at a time and measure each one's contribution.

## Methods under test (from the research, 2026-11-21)
| Id | Method | Source |
|---|---|---|
| M1 | Turn references into a numeric spec before drawing (px size, proportions, palette count, light direction, outline rule) | Anthropic aesthetics guidance; Codixel |
| M2 | Craft rules stated explicitly (hue-shifted ramps, selective coloured outline, dither only at transitions, manual AA, readable silhouette) | Codixel; pixel-art practice |
| M3 | Closed render → look → critique-against-reference → fix loop, N rounds, written critique first | Sprite Fusion; Anthropic screenshot iteration |
| M4 | Diverge then converge: 5 rough variants, pick one, refine | Sprite Fusion |
| M5 | One asset / frame / step at a time, verified before moving on; specific critique, never "make it better" | Codixel; Sprite Fusion |
| M6 | Anti-defaults: name the generic choices to avoid | Anthropic frontend-aesthetics cookbook |
| M7 | 3D (Blender): staged build, real units, Blender version, plan first, inspect after each stage, bake heavy work | Blender MCP guides |

## Scenario P (pixel character): cumulative ablation
Task given to every arm (identical wording; only the guidance differs):
> Make a pixel-art sprite of **Bertha**, the ginger-haired, heavy-set innkeeper of a dockside tavern, idle, facing the camera, for an HD-2D action RPG. Style reference: `docs/art-direction/reference/ref-aldermere-4.png`. Produce a PNG at 1:1 and an 8× nearest-neighbour preview side by side at `<arm dir>/bertha.png`. Use code only (Python with PIL is available; run it with `python -I`).

| Arm | Guidance given |
|---|---|
| P0 | none (baseline) |
| P1 | M1 |
| P2 | M1 + M2 |
| P3 | M1 + M2 + M3 |
| P4 | M1 + M2 + M3 + M4 |
| P5 | the full skill (M1–M6) |

## Scenario D (3D prop in Blender)
> Model a **weathered oak ale barrel with iron hoops and a brass tap** for a dockside tavern in an HD-2D game (fully 3D environment, high detail). Use the Blender CLI (`"C:\Program Files\Blender Foundation\Blender 5.3\blender.exe" --background --python <script>`). Render a 1024×1024 three-quarter view to `<arm dir>/barrel.png` and export `<arm dir>/barrel.glb`.

| Arm | Guidance |
|---|---|
| D0 | none (baseline) |
| D1 | the full skill (with M7) |

## Measurement
- **Blind judging:** a judge subagent receives the outputs renamed at random and scores each 1–10 on
  - reference fidelity,
  - craft (palette, outline, AA, shading / topology, materials),
  - readability at game scale,
  - "would this ship in an HD-2D game".

  The judge also ranks them.
- The orchestrator also looks at every output.
- For each arm, record the behaviour seen: did it extract a spec, iterate, render and look, make variants? Note the verbatim shortcuts and rationalizations.
- Outputs go in the scratchpad `skilltest/<arm>/`; only results are committed here (`RESULTS.md`).
