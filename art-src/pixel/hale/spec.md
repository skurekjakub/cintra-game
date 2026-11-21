# Hale still sprite: spec (A14)

Hale of the Matron, the player witcher (gdd §5.1). Hood-up idle still, facing the camera.

## Scale and budget (from the game, not the reference)
- **Figure height: 33 px** including the outline (gate 30–34). Bertha is 32, so the hero stands one
  pixel taller (the hood peak); his head mass matches hers.
- **Canvas 32 × 34**, feet on the bottom row of the figure, transparent around.
- **Colour budget: ≤ 28** (v3 uses 22). Bertha uses 21.
- **Noise: ≤ 8 %** isolated pixels.
- Seen in the scene at 3× (as Bertha is in `bertha-scene.png`).

## Style to copy (Bertha v7 and ref-aldermere-4)
- **Proportions:** chibi, the head (here the hood) is about 45 % of the height: hood and face rows 0–13,
  body 14–32. Shoulders wider than the hood, so the hood reads as a head and not as a tent.
- **Outline:** a 1 px dark plum `#321524` (Bertha's `O`), 4-connected, added by the compiler. Where
  the outline sits on a lit top or left mantle edge it is a lighter crimson `P` `#7c2a42` (ruling R2).
- **Light:** from the top-left. Left planes one step lighter; right planes one step darker.
- **Face language (v5, R5):** Bertha's: small, flat, a 2 px mouth, no nose line. The face is 10 px
  wide (x11–20) inside the hood's dark `Q` interior (x10, x21). Row 7 is the black fringe with a
  2 px parting in the middle; row 8 is a shadowed forehead with the inner brow pixels dropped below
  the fringe (a V scowl); row 9 has the eyes, `Y h Y` each; mostly `s` skin, `S` on the lit left cheek.
- **Palette mood:** warm, saturated, slightly hue-shifted ramps; shadows lean plum.

## Read order (focal hierarchy)
1. **Face + amber eyes:** brightest, highest contrast, framed by the hood's dark interior.
2. **Crimson mantle:** the player's colour (art bible §3.2); one value below the face.
3. **Two hilts** rising at 45° over both shoulders (the swords cross on his back): a 2 × 2 pommel,
   a 3-row grip and a skewed 2-row guard square to the grip; pommels at y7–8, guards resting on the
   shoulder edge at y11–12 (R6). Steel (his right, viewer's left): all-`g` pommel and guard, brown grip. Silver (viewer's right): mid-silver with the sprite's one
   silver glint on the pommel, dark grip.
4. The bare sword arm and gloved fist on the viewer's left (R4), the steel-blue coat, the 2 × 2
   black-iron medallion pendant at the cowl hem, belt, boots in a wide stance.

## Silhouette pick
Variant **A** (see `docs/art-direction/spike/hale-silhouettes.png`): peaked hood, hilts in a V over
both shoulders, knee-length mantle with a slight flare and a worn, notched hem. In pixels the peak is
softened to an ogive with a 2 px tip (v2): the straight cone read as Little Red Riding Hood.

## Palette (v5: 22 colours)
| key | hex | use |
|---|---|---|
| O P | #321524 #7c2a42 | outline; lit-edge outline on the mantle (R2) |
| R r q Q | #f4566a #dc3a56 #a6284a #5e1232 | crimson ramp; R only on the hood crown, lit shoulder and lit hem edge (31 px); Q = hood interior, right lining |
| S s k | #fbecdc #dcbcae #9c7682 | skin: S only on the lit left cheek, s for the rest, k shade and mouth |
| Y y | #ffc83c #e0801c | amber eyes (`Y h Y`); y spare |
| h | #262030 | black hair, brows, slits |
| B b v | #8aa4c6 #6682ae #43567e | steel-blue coat (one step darker than v4) |
| L l n | #be8048 #865232 #583228 | leather: grips, belt, gloves, boots |
| M m g G | #f4f8fc #b0bccf #78809a #40465e | silver glint (one pixel), mid-silver, steel, dark iron |
| t | #464058 | trousers |

Value check: `python art-src/pixel/hale/lum.py art-src/pixel/hale/hale_1x.png` prints the mean
luminance and its standard deviation over opaque pixels, and the plum-outline share.
v3 77 / 20.9 %; v4 99.9 / 14.9 %; v5 95.6, std 46.3 / 16.1 %.
Bertha (`game/spikes/hd2d/sprites/bertha_idle.png`, frame 0): 113.9, std 63.5 / 18.9 %.

## Not shown at this size (decided)
- The notched left ear is under the hood in the hood-up still. It belongs to the hood-down variant
  and the portrait.

## Rulings log
- A14 self-check, v1 → v3 (before any critic): cone hood → ogive; bright red → deeper crimson
  (`#d24a50` light); open amber eyes → brow bar + narrowed slit eyes; vertical fold lines on the mantle.
- **R1, value (orchestrator, critic round 1):** the hero wins on value, not only on hue: mean luminance
  ≈ 100 or more over opaque pixels, a low outline share, the face and eyes the brightest and
  highest-contrast area, silver gets exactly one glint.
- **R2, outline (orchestrator):** the plum outline stays as the base; a selective lighter outline on
  lit top/left edges (hood crown, shoulder) is allowed if it passes the gates. Compare against the
  current Bertha, `game/spikes/hd2d/sprites/bertha_idle.png` frame 0, not the old `bertha_s.png`.
- **R3, height (orchestrator):** keep 33 px.
- Critic round 1 → v4: face 12 px wide with 1 px hood walls and a fringe row; mid-silver everywhere
  but one pommel glint; Q only in the right third; gloves and cuffs break the lining columns; short
  45° hilts with square guards, no outline shelves; cast shadow under the hood hem and a lit shoulder
  plane; folds as 2 px planes fanning out (x7→x5, x23→x25); hem flares 2 px and ends in 2 px tatters.
  v3 is kept as `v3_*` in this folder.
- **Critic round 2 (v4 read as "monk / Red Riding Hood in a white mask, two sticks"). Rulings R4–R7
  override the earlier frontal, arms-hidden constraint:**
- **R4, stance:** still camera-facing (down direction) but asymmetric and ready: the mantle swept back
  on the viewer's left showing a gloved sword arm (≈ y17–22, x5–10); feet set wider, one hip shifted;
  the mantle sides taper toward the waist (≈ y20) before the hem flares (a man in a cloak, not a bell).
- **R5, face:** the hood's dark interior frames the face (`Q` at x10 and x21, y8–12) with a q/Q collar
  line across y13–14 (≈ x6–25); the forehead under a raised hood is in shadow; brows slant into a
  scowl (outer brow pixels merge into the fringe row); eyes `Y h Y`; the face mostly `s`, `S` only on
  the lit left cheek. Hard and wary, not sleepy.
- **R6, hilts:** about 4 rows lower, guards on the mantle's shoulder edge (y12–14), visibly coming from
  behind the shoulders; no transparent gap at (7,10); the steel pommel fully `g`.
- **R7, colour:** true crimson, not salmon; `R` only on the hood crown and lit shoulder (≈ 35 px);
  fold planes converge toward the shoulder; hem tatters are crimson tips, not outline stubs; the coat
  one step darker so the mantle and face lead; the medallion a 2×2 pendant. Gates: 30–34 px,
  ≤ 28 colours, ≤ 8 % noise, mean luminance ≈ 95 or more.
- v5 (round-2 fixes) is in `hale_still.py`; v4 is kept as `v4_*`.
- (The orchestrator adds further critic rulings here.)
