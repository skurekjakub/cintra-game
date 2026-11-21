# Brief A01 — Art-direction options artifact

## Goal
Build and publish ONE HTML artifact (a claude.ai Artifact page) that presents **5 distinct art-direction options** for a real-time RPG called **The Lion's Shadow**, each with **visual mockups drawn in-page** (canvas / SVG / CSS — there is no image-generation tool; you must render the mockups procedurally). The user will pick one.

## Context
- Read `C:\Users\skure\repositories\cintra-game\story.md` for setting, tone, locations, characters. Tone: low-magic dark fantasy, muddy roads, dynastic crisis, cold dwarven engineering, human cruelty. Autumn → winter over 90 days.
- Ignore the tabletop framing: the game is a **real-time RPG** built in **Godot 4.7**.
- Assets will be made by AI agents: procedural geometry via Blender Python (Blender MCP), Godot shaders, and CC0 libraries (Poly Haven scans/HDRIs, Kenney, Quaternius low-poly). No hand-painted art and no image generation. Each option must carry an honest **production-feasibility** rating for that pipeline, with a one-line reason.
- Must be ORIGINAL. Do not imitate the look of any existing game (in particular not CD Projekt's Witcher games). You may describe broad lineage (e.g. "PS1-era lo-fi 3D", "Dürer-style woodcut") but not "looks like <game>".

## The 5 options (orchestrator's proposal — you may refine names/details, keep the spread)
1. **Low-poly diorama, 3/4 isometric camera** — flat-shaded faceted geometry, baked warm candle light against cold blue night, tilt-shift depth. Feasibility: high.
2. **Woodcut / engraving shader, 3D** — ink outlines + hatching shader, limited palette (bone, soot black, dried-blood red, one cold accent), looks like a printed chronicle come alive. Feasibility: high-medium (shader carries the look; simple geometry).
3. **Lo-fi late-90s 3D, over-the-shoulder** — low-res nearest-filtered textures, vertex snapping, ordered dithering, heavy distance fog, dread atmosphere. Feasibility: very high (low fidelity forgives crude assets).
4. **Grim naturalism, 3D third-person** — photo-scanned CC0 materials, desaturated mud/greys, volumetric fog, overcast light. Feasibility: medium (environments OK, characters/animation hard).
5. **Illuminated manuscript, 2D top-down** — flat gilded medieval-miniature figures, parchment ground, marginalia UI, map-as-page. Feasibility: medium-low (2D sprite animation without image gen is hard).

## Each option must show
- A **scene mockup** of the same moment for comparison: the *Drowned Rat* dockside tavern at night as Choir thugs kick in the door (player character, a few figures, a door, candles/hearth, a sign of the wet dockside). Draw it in that style with canvas/SVG — invest real effort; this is what the user judges.
- A small **HUD/UI sample** in that style (health/stamina, the 90-day countdown "Day 1 of 90 — Sept 21, 1268", a dialogue line).
- **Palette swatches** (5-6) and type suggestion.
- Camera/perspective, lighting, mood keywords, pros, cons, feasibility rating + reason.
- Optionally a second tiny vignette (e.g. Karak Ostrel frozen dwarven hall or Marnadal Stairs blizzard) if it helps differentiate.

## Page requirements
- Before writing, call the Artifact tool with `action: "quickstart"`, `intent: "other"`, `design_systems: false` and follow the page contract it returns (title, theme tokens, CDN allowlist, responsive, etc.). The page itself may commit to a single dark look if you choose, but set every color explicitly.
- Title suggestion: "Lion's Shadow Art Direction".
- Include a clear way for the user to compare (e.g. tabs or a stacked comparison) and a closing comparison table (feasibility, camera, mood, risk).
- No selection/voting mechanism needed; the user tells the orchestrator in chat.
- Write the page to `C:\Users\skure\repositories\cintra-game\docs\art-direction\art-options.html`. Publish it with the Artifact tool (`icon: "palette"`, one-sentence `description`). Take at most one preview/check, fix once, publish.

## Report
Write `C:\Users\skure\repositories\cintra-game\docs\orchestration\agents\A01-art-options\report.md` containing: artifact URL, file path, a 3-line summary per option (name, look, feasibility), and anything you changed from this brief and why. Keep your final chat reply to the orchestrator short: URL + "report written".
