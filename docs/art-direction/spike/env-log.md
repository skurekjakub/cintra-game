# Drowned Rat environment log (A10)

Each round: `art-src/env/render_round.ps1 -Round N` renders `env-rN.png` (MSAA 2x) and a local
`compare-env-rN.png` next to ref-02 (gitignored). Five honest lines per round, then the fix.

Baseline (A09 `drowned-rat.png`): clean tiled box, toy KayKit props, uniform ornamental tiles with dark
grout, black far walls, no window openings, magenta grade.

## r1 — first Blender set + unique plank floor
1. The floor finally reads as a worn plank floor (unique bake, no tiling, straw, nails, patches); the hearth
   flagstones and candle wheel read as real objects. That part is a clear step up.
2. Broken: the moonlight spots sit 4 m outside the wall, the world bend swings them to floor level, and
   they flood the fog right in front of the camera: three white blow-outs with black mullion-shadow bars.
3. The two N–S summer beams become huge blurred dark bands over the play area. Ceiling members over
   the room do not work with this camera; only cut posts and the near (foreground) beam can stay.
4. Whole frame is hazy orange; the fog is too dense and every omni injects into it. Walls and the far
   side cannot be judged under the glare.
5. Fix: spots 1.6 m outside each opening with short range and lower fog energy, kill the summer beams,
   per-light fog energies, fog density down.

## r2 — NaN fix, cold fill, warm pools
1. The white blow-outs in r1 were NaNs, not fog: the shaft shader did `pow(1 - uv.y)` with uv.y a hair
   above 1, and bloom + DOF smeared the NaN over a third of the frame. Clamped; shafts are clean now.
2. Lighting reads for the first time: a cold moon-bounce base with local fire/candle pools; the west window
   throws a proper blue shaft and pool across the floor; characters pop again (courier no longer blown out).
3. The hearth fire sits under the HUD weapon slots (x ~150 px); the chimney breast must come forward.
4. The two broken boards read as black rectangles stamped on the floor; the bottom band is only the blurred
   bar, there is no foreground occluder you can actually see, and the picnic tables read almost black.
5. Fix: breast 1.35 m deep with the firebox moved forward, ragged broken board with splinters and a joist,
   a net and a herb rope hung in front of the lens at the frame edges plus a near lantern (bokeh), more stock
   along the walls, blood as a glossy decal on the hearthstones.

## r3 — hearth forward, foreground layer, rug, moon pools
1. The fire is finally visible left of the courier, the moonlight now lands as blue pools in front of the far
   wall and the door, and the west-window shaft + pool is the best thing in the frame (reads like Elliot).
2. A woven rug (baked texture, wrinkled mesh, fringes) breaks the plank field and adds the colour the
   frame lacked; a hanging lantern near the lens gives real bokeh top-left.
3. The foreground net at frame right reads as a bright, regular white grid (moonlit) instead of a dark soft
   occluder; the herb rope top-left is barely there.
4. Pewter tankards and the bowls read as glass balls (too metallic/glossy); the rug is too new and saturated;
   the round table tops look like red plastic.
5. Still too orange overall and the far wall is a warm smudge: plaster/timber contrast does not survive the
   far blur. Next: darker FG materials, matte pewter, faded rug, lighter lime-wash plaster, cooler wood.

## r4 — grade pulled back to natural amber vs blue
1. Measured against ref-02 (480x270 luminance): r3-era frames had mean 0.19 with 31% of pixels near black
   and a red/magenta channel balance; ref-02 has mean 0.28, 5% near black, neutral-cool balance.
2. Ambient up to 1.15 (cool), exposure 1.18, post lift 2.0, vignette 0.32, fire and candle colours moved to
   amber, wood albedo cooled: now mean 0.26 and 16% near black; the far wall reads as lime-wash plaster
   between dark posts and braces with blue windows, which is the timber-frame read we wanted.
3. Removed the broken board (it read as a black stamp at this scale); pewter is matte, the rug faded.
4. Still warm-heavy (R 0.33 vs G 0.23): candle groups and the slash light tint the middle; the trapdoor (the
   flee route!) is only a faint smudge at the bottom right; the FG net is now a dark soft shape (good).
5. Next: greener amber, a lit cellar under the trapdoor so the hole reads as a warm rectangle, and a full
   craft pass on close crops (bar top, hearth, far wall).

## r5 — props stop looking wet, the trapdoor reads
1. Found why the Poly Haven props looked black and glassy: meshes without a colour attribute read
   COLOR = (1,1,1,1) in Godot, which my set shader takes as "fully wet + grimy". The loader now zeroes the
   vertex-colour terms for such surfaces; picnic tables, stools, crates and tableware read as wood again.
2. The trapdoor lid was hinged on the camera side and hid the hole; it now hinges on the far side, leans
   away, shows its battens and a propping stick, and the lit cellar floor + lantern below make the flee
   route a warm rectangle at the bottom right.
3. Next to ref-02 the frame now has the right ingredients (bent diorama, warm pools vs blue moon shafts,
   blurred far wall with readable timber frame, foreground bokeh, rich edges).
4. Still short: the central plank field is clean and empty compared with Elliot's ground, which is
   littered with small 3D detail even inside the play space; the bar band at the bottom is a dark blur.
5. Next: small debris in the play space (straw tufts, coins, cards, shards, splinters, a dropped cosh),
   kept low and sparse so the combat read survives; check frame time.

## r6 — floor litter, frame time, asset weight (final: `env-r6.png`)
1. Sparse 3D litter in the play space (straw tufts, coins and a purse, playing cards, splinters around the
   overturned trestle, a dropped cosh, a cap, a toppled candle) gives the ground Elliot-like life without
   touching the combat read; all four fighters and the courier still pop.
2. Frame time on the Adreno X2 (1080p, MSAA 2x): 29 fps at r5 → 35 fps. SSIL was ~4 ms for a near-invisible
   gain (bounce is faked with fill lights), the extra lantern lights were duplicates, only the hearth and one
   lantern now cast omni shadows; arch triangles 833k → 647k with coarser bevel grids. No device loss in
   any round (no per-pixel noise anywhere: every texture is baked).
3. Poly Haven sources shrunk to 512 px maps on disk (props GLB 63 MB → 9 MB). Blender `Image.scale()` +
   glTF export wrote broken JPEGs (white props in Godot); resizing the files with PIL before import is the fix.
4. Honest gap vs ref-02: the far wall is a soft timber-frame impression (intended DOF, but there is no
   readable detail up there), the bar band at the bottom is a dark blur with bokeh rather than a designed
   foreground, Elliot's micro-density (every square metre has a small 3D thing) is only reached at the edges.
5. Still 35 fps, not 60: Forward+ with ~30 omnis, 6 shadowed lights, SSR, SSAO, volumetric fog and DOF on
   this GPU. The lighting/post TD should own the next cut (light merging, SSR only on the wet zone).
