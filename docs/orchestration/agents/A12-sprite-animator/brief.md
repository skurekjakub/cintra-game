# Brief A12: Sprite animator. Bertha, lit and animated in the Drowned Rat

## Goal
The user wants to judge the new Bertha sprite **animated**. The animation itself comes first; the lit scene is the context it is judged in.

Deliver:
- **the animations as close-up clips** (the primary deliverable);
- the same animations playing in the Drowned Rat under the scene's real lights.

Animation quality is the bar: appealing, alive, readable, with no jitter.

## Inputs
- **The approved still** (critic round 2): `C:\Users\skure\AppData\Local\Temp\claude\f82cef077b1ec211\fe7622d7-f626-4cfc-b340-9272070adc79\scratchpad\skilltest\P6\bertha_1x.png`. 30×32 px, 21 colours. Its generator is `bertha_final.py` in the same folder.
  - Copy the generator into `art-src/pixel/bertha/`, which is the repo's home for sprite sources, and build from there.
- **The skill:** `.claude/skills/crafting-game-assets/SKILL.md`. Follow sections 1, 4 and 6, and use `audit_sprite.py` on every frame.
- **The spike:** `game/spikes/hd2d/`.
  - `lib/pixel_card.gd` is the normal-mapped pixel card; the existing `sprites/bertha_s.png` and `bertha_s_n.png` are the old Bertha and her normal map.
  - The shot is `shots/drowned_rat.gd`, and `shot_runner.gd` renders it.
  - Read `docs/design/art-bible.md` v1.2 (characters and §6 environment kit) and A10's notes in `docs/orchestration/agents/A10-env-artist/report.md`: keep about 0.45 m clear around fighters and keep the sprite rim and self-light.

## Work
1. **Idle animation, 6–8 frames at about 8 fps**, built in code from the still. Animation craft:
   - **Breathing:** the chest and belly rise 1 px, and the shoulders follow 1 frame later.
   - **Settle:** a 1 px weight shift.
   - **A blink:** 1–2 frames, once per loop.
   - **The tankard:** a small foam or tilt movement.

   Rules:
   - Do the key poses first, then the in-betweens (skill §6).
   - Keep every pixel on the grid: no sub-pixel smear, no rotation resampling. Move clusters by whole pixels.
   - Volume is conserved: what rises on one part settles on another.
   - Every frame passes the audit with the same gates as the still: height 30–34, at most 28 colours, at most 8% noise.
   - Output a horizontal sheet `bertha_idle.png` plus its normal map `bertha_idle_n.png`.
1b. **Walk cycle (front-facing, toward the camera), 6–8 frames, about 10 fps.** Animation craft:
   - The contact, down, passing and up poses are the keys.
   - A 1 px body bob, with arms swinging opposite to the legs.
   - The skirt hem sways a frame behind the legs.
   - The tankard stays level, as an innkeeper who doesn't spill.

   Output `bertha_walk.png` and `bertha_walk_n.png`. The same gates apply to every frame.

1c. **Self-review before the render.** Make a contact sheet of all frames at 8× and an onion-skin overlay (each frame over the previous one, at 50%). Check for:
   - pixels that pop in and out;
   - mass changing between frames;
   - jitter in parts that should be still, such as the feet in idle.

   Fix what you find.

2. **Normal map** for every frame, in the same style the spike's existing `*_n.png` maps use; read how they were made (grep `art-src/` and the `lib/`). The scene's lights should model her form: a warm key from the hearth side, the cold moon rim.
3. **Put her in the shot.** Replace the old Bertha in `drowned_rat.gd` with the animated card, using whatever minimal animation support `pixel_card.gd` needs (frame index over time). The other characters stay as they are.
   - Place her where the player would meet her: near the bar, in a lantern pool, clearly visible and not under the HUD.
4. **Record a clip.** Extend `shot_runner.gd` minimally with a `--record=<seconds>` mode (Godot Movie Maker `--write-movie` with a PNG sequence, or frame grabs at a fixed timestep), at 1920×1080 with MSAA 2×.
   - Make a 5–8 second loop.
   - Encode to MP4 (H.264, `-pix_fmt yuv420p`) and a ≤ 8 MB GIF, using ffmpeg at `C:\Users\skure\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-9.0.2-full_build\bin\ffmpeg.exe`.
   - **Primary output:** close-up clips of her alone at 6× nearest-neighbour, rendered from the actual in-scene capture (so they are lit): `docs/art-direction/spike/bertha-idle-closeup.gif` and `bertha-walk-closeup.gif`, plus `.mp4` versions.
   - **In-scene output:** `bertha-scene.mp4` and `.gif`. She idles for about 3 s, then walks a short path across a lantern pool and through the moonlight shaft, so the lighting change across her form is visible.
   - Also save a still, `bertha-scene.png`, and a contact sheet `bertha-frames.png` (all frames at 8×).
5. **Check honestly**, and report on each:
   - Does she read on the scene's lighting?
   - Does the animation pop or jitter?
   - Do the normal map's lighting and the moon rim look right?
   - Is the frame rate stable?

## Rules
- **GPU:** this Snapdragon Adreno loses the Vulkan device on MSAA 4× and on heavy per-pixel shaders. Use MSAA 2×.
- **Godot:** use the 4.7.2 console binary (see CLAUDE.md), never the `godot` on PATH. Other Godot processes may belong to other agents; never kill them.
- **Scope:** touch only:
  - `game/spikes/hd2d/**`
  - `art-src/pixel/bertha/**`
  - `docs/art-direction/spike/bertha-idle-*`
  - `game/assets/LICENSES.md` (if needed)

  Do not commit.

## Final message (your report; you cannot write report files)
Under 25 lines:
- the output paths;
- the frame count and timing;
- the audit lines;
- what you changed in the spike;
- an honest verdict on the four checks in step 5;
- the 3 biggest things still wrong.
