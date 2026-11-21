# A01 report: art-direction options artifact

(Saved by the orchestrator from the agent's hand-back; subagents cannot write report files.)

- Artifact: https://claude.ai/artifact/NAEiH8W5Fuz9ihX3chUVze
- File: `docs/art-direction/art-options.html`
- Layout: contact sheet of all 5 scenes, a tab per option (`#opt-1`…`#opt-5`), and a comparison table. Each option has the Drowned Rat scene with HUD, palette, type pair, camera/lighting/mood, pros/cons, feasibility, and a second vignette. All drawing is canvas code; no images.

## Options
1. **Lantern Diorama**: low-poly isometric cutaway, faceted geometry, warm baked hearth light vs cold blue night, tilt-shift and bloom. Vignette: Forge of Echoes. Feasibility: High (Blender Python + Quaternius/Kenney).
2. **Woodcut Chronicle**: 3D engraving shader, ink hatching, bare-paper light, red only for fire and blood, printed caption-band dialogue. Vignette: Marnadal Stairs blizzard. Feasibility: High–medium (shader tuning, shimmer in motion).
3. **Lo-Fi Dread**: late-90s 3D over the shoulder, 320×200, vertex snapping, teal-black fog, Bayer dither. Vignette: iron-warden in fog. Feasibility: Very high.
4. **Grim Naturalism**: photo-scanned realism, third-person, desaturated mud, film grain. Vignette: Stairs fog ridges. Feasibility: Medium (characters and animation are the weak point).
5. **Illuminated Manuscript**: 2D top-down, painted figures on vellum, gilded frame, margin UI. Vignette: realm map folio. Feasibility: Medium–low (every figure is a code-built puppet).

## Deviations
- No day countdown (user D4). The HUD shows the objective "Keep Dravin's letter" / "Escape the Drowned Rat".
- Option names refined; every option got a second vignette; a single neutral dark page theme.
- Checked once with a headless Edge screenshot; the manuscript renderer crash and composition issues were fixed in one pass. The fixes were checked by a runtime error check, not a second screenshot. JS syntax OK.
