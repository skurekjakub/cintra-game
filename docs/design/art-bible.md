# Art Bible: The Lion's Shadow (HD-2D)

Status: v1.1 (A09, 2026-11-21). **Work in progress: the spike does not yet meet the bar (see section 11).** Source of truth for every visual asset. The reference implementation is the throwaway spike in `game/spikes/hd2d/` (screenshots in `docs/art-direction/spike/`). When this file and the spike disagree, this file wins and the spike is wrong.

**The look in one line:** a dark, full-3D diorama of crisp, worn stone and timber, seen from high above through a narrow lens, lit by warm fire pools against a cool violet night, with small crisp pixel-art people standing in it and loud additive VFX on top.

(Style reference: a commercial HD-2D action game frame the user supplied. It is local-only and gitignored. Never copy its characters, UI art or assets.)

---

## 1. Camera

| Parameter | Value | Notes |
|---|---|---|
| Projection | Perspective | Never orthographic for gameplay. |
| Vertical FOV | **27°** | Narrow lens: the floor reads almost like a board, low perspective distortion. |
| Pitch | **52°** below horizontal | 50–60° allowed per zone. |
| Yaw | Fixed per zone (default 0°, looking toward −Z) | No player-rotated camera. Rooms are authored for one view. |
| Distance to target | **21 m** | About 18 m of floor across the frame at 1080p (≈100 px per metre at the focus plane); a 16 × 11 m room fills the frame. |
| World bend ("rolling cylinder") | radius **13 m**, pivot = player, far side only | `shaders/bend.gdshaderinc`: geometry beyond the pivot (along the camera's horizontal forward) wraps onto a cylinder, so the far floor drops away and far walls lean back to face the camera. Every environment material includes it (`Kit.pbr`, `Kit.uv_mat`, `Kit.floor_material`); sprites, lights, particles and billboards are moved with `Kit.bend_point` / `Kit.apply_bend`. |
| Target | Player position, damped (0.15 s), clamped to room bounds | |
| Depth of field | `CameraAttributesPractical`: far blur from focus + 5 m (transition 7 m), near blur from focus − 4.5 m (transition 3 m), amount 0.045 | Real depth blur. |
| Tilt-shift | Post shader: focus band centred at 54% of screen height, half-height 18%, 12-tap blur up to 8 px at the edges | Softens top and bottom edges like a miniature. |

Rooms should be built so the play area fills the middle 60% of the frame and the walls and drop-offs at the edges fall into darkness.

## 2. Pixel scale and characters on screen

- **One sprite texel = 3 screen pixels at 1080p** (`pixel_scale = 3`; 4 at 1440p). The card is sized from the camera distance, so the scale holds across the frame.
- Humans: **32–34 texels tall in a 34 × 34 frame** (≈ 75–100 px on screen). Large enemies 48–64 texels, bosses up to 96.
- Characters are chibi: about 1.0 m tall in world units at a 1.0 model scale, head about 0.34 m across (a third of the height).
- Sprites never rotate with the camera and never scale with depth beyond what the camera gives them.

## 3. Palette and grade

### 3.1 World grade (per zone, in `WorldEnvironment` + the post pass)

| Element | Tavern / city interior (warm) | Dungeon / Karak Ostrel (cold) |
|---|---|---|
| Background | `#030104` | `#030104` |
| Ambient colour × energy | `(0.50, 0.36, 0.66)` × 1.4 | `(0.36, 0.40, 0.68)` × 1.4 |
| Key fire light | `(1.0, 0.52, 0.25)` | rune blue `(0.35, 0.75, 1.0)` |
| Play-area wash (overhead omni) | `(1.0, 0.78, 0.8)` energy 3, range 12 | `(0.75, 0.8, 1.0)` energy 2, range 13 |
| Accent | cold door light `(0.45, 0.58, 1.0)` | one warm brazier `(1.0, 0.55, 0.25)` near the player |
| Post shadow tint | `(0.75, 0.62, 1.0)` violet | `(0.62, 0.68, 1.0)` blue |
| Post highlight tint | `(1.08, 0.98, 0.86)` amber | `(1.02, 1.0, 0.95)` |

Rule: **shadows are violet, light is warm**. Every zone keeps at least one warm source and one cold source so the split-tone reads.

Tonemap ACES, exposure 1.15, white 6. Adjustments: contrast 1.12–1.15, saturation 1.08–1.12. Glow: levels 2–5 weighted (0.6, 1, 1, 0.8, 0.5, 0.3), intensity 0.5, strength 1.1, HDR threshold 1.2, blend Screen. SSAO radius 1.2, intensity 2.5, power 1.6. SSIL radius 4, intensity 0.8. Volumetric fog density 0.003–0.006 (just enough to catch light). Vignette 0.62 (oval). Film grain 0.025.

### 3.2 Character palette rules

- 3–4 large colour blocks per character plus one accent. Clothing values sit between 0.3 and 0.75 (linear) so the toon bands survive the tonemapper; never pure black clothing.
- Skin `(0.95, 0.74, 0.60)` base; sickly `(0.78, 0.82, 0.70)`.
- Hale: steel-blue coat `(0.2, 0.3, 0.5)`, crimson cloak `(0.72, 0.12, 0.10)`, brass guard. The cloak is the player's identifying colour: no other friendly wears saturated red.
- Pale Choir: bone-white mask `(0.93, 0.90, 0.82)` with a red slash mark, hood, red sash `(0.62, 0.08, 0.10)`. The mask is the faction read.
- Dwarven constructs: iron `(0.42, 0.44, 0.50)`, brass bands `(0.78, 0.60, 0.30)`, rune glow `(0.45, 0.85, 1.0)` (emissive).
- Outline: `(0.07, 0.03, 0.08)`, a near-black violet. Never pure black.

## 4. Lighting recipe

1. **Ambient** (colour source, values above) keeps unlit stone readable as violet-grey, never black, inside the play area.
2. **Play-area wash**: one overhead `OmniLight3D` (6.5 m up, range 12–13 m, shadows on) creates the lit "stage" that falls off to darkness at the room edges.
3. **Fire pools**: hearth, braziers, candles, lanterns as `OmniLight3D`, attenuation 1.3. Hearth energy 2.6 range 9 with shadows; braziers 2.5–3.5 range 7–8 with shadows; candles 0.7 range 3.2 without shadows; lanterns 1.2 range 4.5.
4. **Cold accent**: a `SpotLight3D` through a door or window (energy 5, range 10, 28°, shadows), or rune strips (emissive + small omni).
5. **Every visible flame** = flame billboard + additive glow disc + omni light. A light with no visible source is allowed only for the play-area wash.
6. Max **8 shadowed lights** visible per room. Shadow atlas 4096.
7. Volumetric fog energy per light: omni 0.25, spot 0.6.

## 5. Character pipeline

**Primary route: hand-authored pixel art in code** (`art-src/pixel/`).
- `pixelart.py` holds the master palette as hue-shifted ramps (shadows lean purple, lights lean warm): skin, hair, red, blue, leather, steel, gold, bone, plum, green, cream, ginger, face accents. One character per pixel in the maps; `.` is transparent.
- Maps contain only the interior. The compiler adds a **selective outline**: each transparent pixel touching the sprite takes the deepest tone of the neighbouring material mixed with `#221222`, lighter on the lit (top-left) side.
- Craft rules: chibi head ≈ 42–45% of the height, 2-px eyes, a skin shadow under the hair, light from the top-left with a highlight band on hair, shadow lower right, one saturated accent per character, distinct silhouettes (Hale: crimson mantle and sword; Pale Choir: bone hood and singing mask; Bertha: ginger bun and apron; courier: red-and-gold tabard).
- `pixelart.normal_map` derives a normal map from the art (distance-to-edge dome per material roundness + luminance), so the sprite is lit by real lights from the correct side.
- `build.py` writes `game/spikes/hd2d/sprites/<name>.png`, `<name>_n.png` and `sprites.json`; `preview.py` makes the 1:1 / 8× critique sheet.
- In Godot, `lib/pixel_card.gd` + `shaders/pixel_lit.gdshader`: nearest sampling, alpha scissor (casts a real silhouette shadow onto the floor), 2-band diffuse from the scene lights via the normal map, rim from lights behind, self-light 0.42 so the art never sinks into the dark, `hit_flash`, horizontal flip, and "upright depth" (vertices slide along their view ray to stand above the feet). Plus a soft blob contact shadow.
- Animation plan (not yet authored): idle 2–4 frames (1-px bob), walk 4–6 frames × 4 directions (mirror east/west), attack 4 frames with a smear frame, hurt 1–2.

**Fallback route: 3D rig → pixels.** Either live (`lib/pixel_sprite.gd`: a KayKit rig in a tiny own-world SubViewport, ortho camera at the gameplay yaw and 24–30° pitch, unshaded 3-band toon + rim from the nearest lights, 1-texel outline in `pixel_sprite.gdshader`) or offline (`art-src/render_sprites.py`, Blender CLI, EEVEE 1 sample, filter 0, emission toon material, normal/depth pass for inner lines). Role recolours: `art-src/recolor_kaykit.py` swaps KayKit palette swatches. This route is used for the iron-warden and Maelis until their pixel art exists.

## 6. Environment kit

All geometry is full-resolution 3D with PBR materials. Chunky beats thin: at 75 px/m anything under 4 cm wide disappears.

**Floors** are baked carved-stone panels (`art-src/bake_floors.py`: height field with 1 m tiles, worn bevels, chips, Voronoi cracks, chiselled ornament grooves → albedo, OpenGL normal, roughness, AO, height PNGs at 1024 px per panel; photo grain from Poly Haven `quarry_wall`). `floor_baked.gdshader` world-maps them with offset-mapped relief. Panels: `karak_floor` (3 m: octagon frames, interlace lattice, rosette, corner quarter-rounds) and `tavern_floor` (2 m: diamond tile, rosette tile, two plain tiles with an inset line). Real-time Voronoi in a floor shader crashed the Adreno driver (Vulkan device loss): always bake.

**Props**: KayKit Dungeon Remastered (CC0) at 0.45 × 1.35 scale with `env_uv.gdshader` (palette atlas × triplanar Poly Haven grain).

**Materials** (CC0 Poly Haven 1k sets, `env_triplanar.gdshader`, see `game/assets/LICENSES.md`):
- Floors: `stone_floor.gdshader` = photo albedo/normal/roughness/AO + procedural height field (large tiles with worn bevels, carved ornament panels, Voronoi cracks, damp stains that darken albedo and drop roughness to 0.18 so they catch the lights), normal from finite differences.
  - Tavern flagstones: `monastery_stone_floor`, tex scale 5 m, tint `(0.82, 0.74, 0.8)`, cracks 0.7, damp 0.7.
  - Hearthstones: `monastery_stone_floor`, scale 3.
  - Dwarven halls: `granite_tile` as micro detail, `use_grid` with 1.0 m tiles, ornament panels every 3×3 tiles (double octagon frame, diagonal interlace lattice, central rosette, corner quarter-rounds), groove dirt `(0.18, 0.2, 0.3)`.
- Walls: `rough_block_wall` footings (1.1 m), `old_planks_02` timber upper, `dark_wooden_planks` posts and beams (Drowned Rat); `large_sandstone_blocks` tinted `(0.42, 0.45, 0.55)` for dwarven stone; `rusty_metal_02` darkened for iron.
- Furniture tops: `wood_table_worn`.

**Modules** (`game/spikes/hd2d/lib/props.gd` holds the reference builders):
- Timber wall run (footing, upper, sill beam, top beam, posts every 3 m), 3.1 m tall.
- Hearth (two cheeks, mantel beam, chimney breast, firebox, 3–5 flame cards, logs, ember particles).
- Round table with 4 stools, trestle table with 2 benches, bar counter 1.05 m with bottle row, barrels (standing, lying), crates.
- Support post with plinth, wall lantern (emissive box + omni), shuttered window with emissive cold slits.
- Chunky iron railing: top rail 0.12 × 0.22 m, dense diagonal balusters every 0.18 m, posts every 2 m with brass ball and spike finials, brass kerb.
- Dwarven pillar: plinth, two bands, capital; rune strip (emissive) on the inner face.
- Rune bulkhead door with emissive glyph bars, steps.
- Rubble chunks, fallen armour plates, blood pools (flat, roughness 0.15).

Deep shadow outside the play area is mandatory: drop-offs, unlit back rooms or an abyss floor 9 m below lit at 10%.

## 7. VFX recipes

All VFX are additive, unshaded, HDR (values above 1) so the glow pass blooms them. None are pixelated: VFX are high-resolution on purpose, in contrast with the sprites.

| Effect | Recipe |
|---|---|
| Sword slash | Ring-sector mesh (64 segments) around the attacker at chest height, radius 1.45–1.5 m, width 0.75–0.8 m, 165° sweep ending at the target, tilted 12–14° toward the camera. `vfx_slash.gdshader`: crescent width profile (thin tail, fat body at 86%, tapered tip), red edge `(1, 0.04, 0.12)`, white-pink hot outer rim, intensity 2.5. Lives 0.12–0.18 s, fades tail-first. |
| Hit spark | Camera-facing quad 1.0–1.3 m, `vfx_spark.gdshader`: 11 hashed rays of random length, tapering, plus a white core and a soft halo, yellow `(1, 0.8, 0.3)` × 3. A second smaller orange spark offset by 0.2 m. A 1.2-energy omni for 2 frames. |
| Fire | Upright billboard, `vfx_flame.gdshader` (4-octave noise flame, 3 tongues), white-yellow core to red edge, intensity 4–5.5. Blue variant for rune braziers: hot `(0.8, 0.95, 1)`, mid `(0.25, 0.6, 1)`, cool `(0.05, 0.15, 0.6)`. |
| Glow / wisp | `vfx_glow.gdshader` disc, 0.45–0.5 m, intensity 6 for wisps, 1.2 for candle halos, plus a small omni (1.5, range 2.5). |
| Embers / motes | GPU particles, 0.035 m quads, additive ×4, rising 0.35–0.8 m/s with turbulence. |
| Rain | GPU particles, 0.015 × 0.45 m streaks, Y-billboard, additive blue-white at 35% alpha, 700 per doorway, only visible outside openings. |

## 8. HUD

Register: gothic filigree, thin gold-white strokes (gold `#EDD49E`, white `#FFF7E6`, dim gold `#9E8057`), dark violet translucent fills (`#0F0512` at 75–90%), serif type (spike: system Palatino Linotype; production: an OFL serif such as Cinzel or IM Fell, recorded in LICENSES). All drawn as vector lines with antialiasing; never pixelated. Reference layout at 1920×1080:

| Component | Position | Spec |
|---|---|---|
| Health | top-left, first drop at (64, 54) | 10 blood-drop pips 38 px tall, 34 px pitch; full = dark-red body, bright-red inner, pink highlight, cream outline; empty = dark outline only. Filigree rule underneath with end spirals and a centre diamond. |
| Objective line | (62, 119) | Diamond bullet + one line, 21 px serif, warm white with a 5 px dark outline. No timer anywhere (gdd: no time mechanic). |
| Boss / encounter bar | top centre, 760 × 14 px at y 66 | Name 30 px bold above. Gold fill, red "recent damage" chunk, dark track; double gold frame, spear-tip finials at both ends, diamonds above and below the centre, side spirals. |
| Enemy bars | above each engaged enemy (head + 0.25 m) | 64 × 7 px gold fill, dark border, thin gold frame. |
| Weapon and item slots | left edge, centres x 96, y 330 / 448 / 566 | 40 px radius circles, dark fill, gold ring + outer dim ring, star stud on top, icon in the middle, count under it (crossbow bolts, poultices). |
| Companion medallion | bottom-left, centre (178, 900), radius 116 | Pixel-art portrait (§5) clipped to a circle on a violet disc; white inner ring, gold outer ring, four sparkle stars, a top star; ability-ready arc in amber; name plate below; vine flourish to the screen edge; optional key badge. |
| Minimap | bottom-right, centre (1752, 918), radius 112 | Dark disc, room outlines, red enemy dots, door squares, red player arrow; gold ring + outer dim ring, four compass stars (north larger), "N". |
| Edge flourishes | left and right edges | Faint gold vines at 30–35% alpha. |

The HUD draws on a canvas layer above the post pass so it is never blurred or graded.

## 9. Performance budget (1080p, mid-range PC; spike measured on a Snapdragon X2 Adreno)

| Item | Budget |
|---|---|
| Frame | 16.6 ms at 1080p with MSAA 2×. **MSAA 4× at 1080p crashed the Adreno driver (Vulkan submit failure) in the spike; ship 2× or FXAA.** |
| Draw calls | ≤ 1500 per frame (merge static props into MultiMesh or combined meshes per room in production; the spike uses one node per box). |
| Shadowed lights | ≤ 8 visible, atlas 4096. Candles never cast shadows. |
| Unshadowed omni lights | ≤ 32 visible. |
| Character viewports | ≤ 12 active, each ≤ 112×112, no AA, own world. Off-screen characters pause their viewport (`UPDATE_DISABLED`). |
| Floor shader | One finite-difference height field (3 evaluations, 2 Voronoi passes each). Bake the height to a normal map per tile set if the GPU cost exceeds 2 ms. |
| Particles | ≤ 2000 live. |
| Textures | 1k PBR sets for walls and props, 2k only for floors that fill the screen. Mipmaps on, anisotropic. |

## 10. Asset licensing rules

- Allowed: **procedural** (made in this repo: shaders, code-built meshes, Blender scripts in `art-src/`) and **CC0** (Poly Haven, Kenney, Quaternius, ambientCG). Fonts: OFL is acceptable for fonts only.
- Every imported file or pack gets a row in `game/assets/LICENSES.md`: path, source URL, author, license, notes.
- Download Poly Haven assets through the public API (`https://api.polyhaven.com/files/<id>`, send a User-Agent) at 1k unless a floor needs 2k. Keep the Poly Haven id as the folder name.
- Never ship, commit or trace reference screenshots from other games (`/image.png` and `docs/art-direction/reference/` are gitignored).
- No AI-generated images in shipped assets.
- Generator scripts live in `art-src/`; generated outputs live in `game/assets/`.

## 11. Status of the spike (read before building on it)

The spike proves the pipeline pieces (bend, baked carved floors, lit pixel cards with real shadows, HUD, post stack, KayKit props) but **does not yet hold up next to the Elliot and Aldermere references**. Known gaps, in priority order:
1. Environment density: the room reads as a clean tiled box with toy props. It needs bespoke Blender-modelled hero pieces (bevelled beams, hearth, bar, rope, railings), Poly Haven models (barrels, crates, bottles, chairs), clutter and decals, and layered depth (foreground occluders, back rooms).
2. The tavern floor ornament is too regular and the grout too dark; vary tiles, add rugs, straw and spill decals, and reduce the grid read.
3. Walls and the bent background are too dark; light them and add detail (shelves, banners, windows with real openings so the volumetric shafts show).
4. Hale has no attack pose; animations are not authored; the warden and Maelis still use the 3D-render fallback.
5. Volumetric light shafts are not visible yet; SDFGI/LightmapGI not tried (the Adreno X2 GPU is fragile: MSAA 4× at 1080p and heavy per-pixel noise both caused device loss).
