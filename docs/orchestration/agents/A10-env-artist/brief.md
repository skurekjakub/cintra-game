# Brief A10 — Environment artist: the Drowned Rat taproom set

## The bar
The user will accept only a prototype that looks like a **shipped, production-quality HD-2D game**. References (local only, never commit or publish them) are in `docs/art-direction/reference/`: `ref-02` and `ref-03..07` are The Adventures of Elliot (Square Enix), the primary target; `ref-aldermere-*` are a secondary one. Study them with Read before starting, and again every round.

## Where things stand
Read `docs/design/art-bible.md` (v1.1, especially §11 "gaps"). The spike lives in `game/spikes/hd2d/`; the current shot is `docs/art-direction/spike/drowned-rat.png`. Look at it next to `ref-02`.
- **Works, keep it:** world bend (`shaders/bend.gdshaderinc` + `Kit.apply_bend`/`bend_point`), normal-mapped pixel sprites with real shadows (`lib/pixel_card.gd`), HUD, DOF/grade (`post_grade.gdshader`), VFX lights, fog/SSR/SSAO.
- **Not good enough, your job:** the environment reads as "a clean tiled box with toy props".
  - KayKit props look like toys.
  - The floor is a uniform tile grid with dark grout.
  - Far walls are too dark.
  - Windows have no openings, so there are no light shafts.
  - No foreground depth layers.
  - The overall grade is oversaturated red/magenta.

## Your scope: environment only (characters, HUD and post code stay as they are)
Rebuild the Drowned Rat taproom set so the environment alone is shipped HD-2D quality. Use the layout in `docs/content/act1/01-drowned-rat.md` (taproom zone: bar, hearth, tables, cellar trapdoor, front door to the docks, stairs to the loft). The fiction: a low-ceilinged dockside tavern at night, rain outside, timber and stone, salt and smoke.

1. **Architecture, bespoke Blender geometry** (Blender CLI: `"C:\Program Files\Blender Foundation\Blender 5.3\blender.exe" --background --python art-src/env/<script>.py`; export GLB; scripts in `art-src/env/`):
   - timber-framed walls with plaster infill;
   - chunky exposed beams, posts, rafters and braces with bevels and wear;
   - real window openings with mullions and wavy glass;
   - a doorway to the rain-wet dock;
   - a stone hearth with a chimney breast and a mantel;
   - a bar counter with back shelves;
   - a staircase;
   - a cellar trapdoor.
   Bevel every edge and add chips, sag and irregularity. Nothing perfectly straight.
2. **Floor:** worn wide irregular planks (varying widths, end joints, knots, a few broken or patched boards), plus a flagstone apron around the hearth. Bake in Blender or numpy with real relief: normal + AO + roughness + height. Puddles and wet streaks near the door (SSR).
3. **Props and set dressing, density like Elliot:** use Poly Haven CC0 models (barrels, crates, lanterns, chairs, tables, bottles, ropes; download via `https://api.polyhaven.com`, glTF) where they fit, and model the rest.
   - Hanging lanterns and an iron candle wheel with real candle geometry.
   - Clutter: tankards, plates, bread, bottles on shelves, nets, coiled rope, an anchor or oar, sacks, straw on the floor.
   - Decals: spills, soot above the hearth, dirt in the corners, wet footprints from the door.
4. **Depth layers:**
   - Foreground occluders near the camera (a beam or post edge, a hanging net, a barrel top), blurred by the DOF.
   - The background beyond the bent far wall: open windows showing the rainy dock, moored boat silhouettes, distant lights.
5. **Lighting, environment side:**
   - Warm hearth and lantern pools.
   - Cold blue moonlight through the windows and the door, with **visible volumetric shafts**.
   - The walls and the far side readable in mid-tones; deep shadows hold colour, never black.
   - Pull the grade back from magenta toward natural warm amber against cold blue-violet.
   - Lightmap or SDFGI only if the GPU survives (see below). Otherwise fake bounce with fill lights.
6. **Keep the sprites readable:** after your changes, the characters and VFX must still pop against the set. Check every round.

## Process
- Iterate in rounds. Each round:
  - render the shot: `shot_runner.tscn -- --shot=drowned_rat --out=...`, with MSAA 2×;
  - save `docs/art-direction/spike/env-rN.png`;
  - build a local side-by-side `compare-env-rN.png` against `ref-02` (gitignored);
  - Read both;
  - write a 5-line honest critique into `docs/art-direction/spike/env-log.md`, then fix.
- At least 6 rounds. Stop only when the frame genuinely belongs next to Elliot, or when a blocker needs a decision.
- **GPU:** this Snapdragon X2 Adreno loses the Vulkan device on heavy per-pixel shaders (MSAA 4×, per-pixel Voronoi). Bake anything heavy into textures. If a device loss happens, back off and note it in `env-log.md`.
- Other Godot processes may be running for other agents. Never kill them.
- **Licences:** add every new asset to `game/assets/LICENSES.md` (CC0 only, plus your own work).
- Update `docs/design/art-bible.md` with the environment kit and recipes that worked (replace the §11 items you closed).
- Touch only `game/spikes/hd2d/**`, `art-src/env/**`, `docs/art-direction/spike/env-*`, `docs/design/art-bible.md`, `game/assets/LICENSES.md`. Do not commit.

## Final message (your report; you cannot write report files)
Under 30 lines:
- the rounds done and the final file;
- what changed;
- an honest verdict against `ref-02`, with what still falls short;
- the techniques and recipes for the next specialists (lighting/post TD, sprite animator).
