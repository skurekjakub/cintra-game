# Brief A09 — Art direction: HD-2D render spike + art bible

## Why
The user rejected all five canvas mockups ("all of those look like crap") and supplied a reference screenshot of the look they want: `C:\Users\skure\repositories\cintra-game\image.png`. Look at it with your Read tool before anything else. It is a frame from a commercial game. It is a **style reference only**: never copy its characters, UI art, or assets, and never commit or publish it (it is gitignored). Our content is original.

This time the proof must be a **real Godot render**, not a drawing. Quality bar: a screenshot from our engine that holds up next to the reference.

## The look (what to extract from the reference)
- **Camera:** high three-quarter top-down, roughly 50–60° pitch, perspective with a fairly narrow FOV so the floor reads almost like a board. The player sits small in frame. A slight tilt-shift depth of field softens the top and bottom edges.
- **Environment:** full-resolution 3D with crisp detailed stone. Large tiles with carved ornamental patterns, worn edges, cracks, damp stains, chunky ornate railings and pillars, and deep shadow outside the lit play area.
- **Lighting:** dark scene with a cool purple/magenta ambient grade; warm point lights (torches, braziers, candles) with falloff pools; small cold accents (a blue wisp). Strong bloom on lights and VFX, ambient occlusion, a vignette.
- **Characters:** **pixel-art sprites** standing in the 3D world (billboards), crisp with no smoothing, warm rim-lit, with soft blob shadows on the floor. Characters are small (about 48–64 px tall at 1080p for the player; bosses bigger).
- **VFX:** bright saturated additive effects: a big red crescent sword-slash arc, a yellow-white hit spark burst, glow.
- **HUD (ornate, gothic filigree, thin gold-white frames):** a row of blood-drop health pips top-left; boss name with a long bar inside an ornate frame top-centre; circular weapon and item slots on the left with an ammo count; a round companion portrait medallion bottom-left; a circular minimap bottom-right. Make our own original designs in this register, adapted to our game: no time counter; there is an objective line.

## Production approach (no image generation available)
1. **Characters, preferred route:** model simple low-poly characters (Blender via the `blender` CLI with `--background --python`, or Godot primitives) and render them through a **low-resolution SubViewport** with nearest filtering, toon or stepped lighting, a 1-px dark outline and a limited palette. Show the result as a billboard `Sprite3D` with a `ViewportTexture`. This gives real pixel-art characters that animate from 3D rigs. **Fallback:** pre-render 8-direction sprite sheets from Blender at low resolution. Pick whichever looks better in the spike, and say why.
2. **Environment:** CC0 materials (Poly Haven textures via direct download: record the license and URL in `game/assets/LICENSES.md`) or procedural textures (Blender bake, or a Godot shader) for the ornamental floor tiles; modular blocks for walls, railings and pillars.
3. **Post:** Godot `WorldEnvironment` with glow, SSAO, tonemap and colour grading (adjustment or LUT); a DOF camera attribute; a vignette shader.
- The Blender MCP needs the user to click "Start MCP Server" in a running Blender, so **use the `blender` CLI directly** (`"C:\Program Files\Blender Foundation\Blender 5.3\blender.exe" --background --python <script>`). Keep generator scripts in `art-src/`.

## Scene to build
The **Drowned Rat** tavern interior at night (story Act I, scene 1). Pull the layout from `docs/content/act1/01-drowned-rat.md` if it exists; otherwise improvise: a timber-and-stone dockside tavern, hearth, tables, candles, a bar, a door with rain beyond. Include the player, the dying courier on the floor, and 3 Choir thugs bursting in through the door. Show one mid-combat moment: a slash arc, a hit spark, an enemy health bar. Include the full HUD. Then make a **second shot** in a cold, stony location (a corridor of Karak Ostrel with a dwarven iron-warden and blue light) to prove the look holds across the game.

## Where things go
- The spike is throwaway: put it in `game/spikes/hd2d/`. It does not need to follow architecture.md layering, and the architecture test only scans `res://src`. Keep it tidy anyway, because the techniques will be ported.
- Screenshots: capture from a windowed run. Write a tiny capture script that waits ~60 frames, saves `get_viewport().get_texture().get_image()` as PNG, then quits. Headless can't render. Save to `docs/art-direction/spike/drowned-rat.png` and `docs/art-direction/spike/karak-ostrel.png`, at 1920×1080.
- **Iterate:** look at your own screenshots with the Read tool, compare them honestly against the reference, and improve. Do at least 3 rounds per shot. Keep the round-1 shot as `*-r1.png` to show progress.
- Art bible: `docs/design/art-bible.md`. Cover camera numbers, pixel scale, palette and grade, lighting recipe, the character pipeline (exact viewport resolution, outline, shading steps), the environment kit list, the VFX recipes, HUD components, a performance budget, and the asset licensing rules. Future agents will build all content from it.
- Use the 4.7.2 Godot exe (`$env:LOCALAPPDATA\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7.2-stable_windows_arm64.exe` for windowed runs; `..._console.exe` for logs). Never use `godot` from PATH (it is 4.7.0).

## Rules
- Do not touch `game/src`, `game/tests`, `docs/content`, or `docs/superpowers/plans` (other agents are working there). `tools/test.ps1` must still pass when you finish.
- Do not commit. Put your report in your **final message** (subagents cannot write report files): screenshots made, the character route chosen and why, an honest self-assessment against the reference (what matches, what doesn't yet), and the art bible path.
