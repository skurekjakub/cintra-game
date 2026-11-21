# A12 report: Bertha animated in the Drowned Rat (saved by the orchestrator from the agent's hand-back)

**Outputs** (`docs/art-direction/spike/`):
- `bertha-idle-closeup.gif/.mp4`, `bertha-walk-closeup.gif/.mp4`: 6× close-ups of the lit 1080p capture.
- `bertha-scene.mp4` (8 s, 1080p, 50 fps) and `bertha-scene.gif`.
- `bertha-scene.png`, `bertha-frames.png` (all 16 frames at 8×).

**Animation:**
- **Idle:** 8 frames at 8.33 fps. One 2.16 s loop plays 18 steps: a breath (the arms and tankard lag a frame), the foam crowns, a settle, and a half/shut/open blink.
- **Walk (front-facing):** 8 frames at 10 fps. A 1 px bob, the head trailing it by a frame, the hem swaying a frame behind the legs, and the tankard always level.
- **Audit:** all 16 frames pass (21 colours, 6.1–7.2% noise, height 31–33).

**Spike changes:**
- `pixel_card.gd`: strip frames, `play()` with a timing chart, `move_to()`, and pixel-snapping of the card each frame.
- `pixel_lit.gdshader`: frame uniforms and `light_cap`.
- `lib/stage_walk.gd`: drives idle → walk → idle on a fixed timestep.
- `shot_runner.gd`: `--record=<s>` writes a PNG sequence.
- `drowned_rat.gd`: Bertha under the bar-end lantern, plus `--bertha=walk` for the review walk.

Sources are in `art-src/pixel/bertha/`.

**Critic:** one independent critic round on the animation flagged popping feet, a pulsing chin shadow, a twitching hand, a long settle and a drowsy blink. All five were fixed.

**Still wrong, per the agent:**
1. The front walk has no foreshortening: the feet are on the bottom row and only the soles lift, so it can read as marching.
2. Bloom and glow soften her edges in the hot pools, and the lantern washes out her face.
3. No second critic round yet. The moon rim is faint, and the light cap is a per-card workaround, not a scene fix.

The scene runs at 34–36 fps in real time.
