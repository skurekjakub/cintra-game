# A10 report: Drowned Rat environment (saved by the orchestrator from the agent's hand-back)

6 rounds. Final frame: `docs/art-direction/spike/env-r6.png`; the per-round critiques are in `env-log.md`.

## What changed
- **Architecture:** bespoke Blender geometry (`art-src/env/build_taproom.py`, `envlib.py`), exported to `taproom_arch.glb`, `taproom_props.glb` and `taproom_anchors.json`.
  - Timber-framed walls with plaster panels.
  - Real windows (mullions, wavy glass) and a kicked-in door onto a rain-wet quay with ships.
  - A hearth with a chimney breast, the bar, back shelves, stairs and the cellar trapdoor.
  - Dense dressing, plus 28 Poly Haven CC0 models.
- **Floor:** one unique baked texture (390 boards, worn paths, puddles, wet boot prints) and a baked rug.
- **Lighting:** a cool moon-bounce base with warm hearth, candle and lantern pools; moon spots plus hand-made light-shaft meshes; a foreground layer with a net, herbs and bokeh lanterns.
- **Grade:** amber against blue, no longer magenta. Mean luminance went from 0.15 to 0.26 (ref-02 is 0.28).
- **Docs:** art bible v1.2 (§3.1, §4 moon-shaft recipe, §6 environment kit, §9 costs, §11 gaps); LICENSES.md updated.

## The agent's own verdict
It reads as a real HD-2D diorama, but is not yet at Elliot level:
- The far wall is only an impression.
- The bottom foreground is a dark blur, not a designed foreground.
- The play area is much sparser than Elliot's ground.
- The snug and the stairs sit under the HUD.
- **35 fps** on the Adreno at 1080p with MSAA 2× (the budget is 60), after SSIL was turned off. No device loss.

## Recipes and gotchas
- **Moon spots:** create them after `apply_bend`, 1.6 m outside the opening, with both ends placed through `Kit.bend_point`.
- **Shaders:** clamp every `pow()` in additive shaders. A NaN gets smeared across the frame by bloom and DOF.
- **Fog:** only the fire and the moon inject into the fog; every other light uses 0.04.
- **Toggles:** `A10_DEBUG=noshaft|nofog|moononly|nossr|nossil|noprops|nospot`.
- **Vertex colours:** a glTF without vertex colours reads COLOR as 1. `lib/taproom.gd` handles this.
- **Textures:** shrink Poly Haven textures with PIL, not Blender's `Image.scale()`, which writes corrupt JPEGs on export.
- **Sprites:** keep about 0.45 m clear around each fighter, and keep the sprite rim and self-light so the characters read against warm wood and the blue pools.
- **Next frame-time cuts:** merge lights, restrict SSR to the wet zone, use MultiMesh for repeated props.
