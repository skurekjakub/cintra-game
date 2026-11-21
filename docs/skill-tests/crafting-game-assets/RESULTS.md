# Skill test results: `crafting-game-assets`

## P0: baseline, no guidance (opus, 16 tool calls, 3.2 min)
Output: a 36×46 chibi Bertha (ginger bun, teal dress, apron, tankard). 5 renders.

**What it did on its own:**
- Read the reference and made a close-up crop of it.
- Looked at every render and fixed what it saw (the mouth, the apron folds).
- Built the sprite from a palette-indexed character map with an automatic outline.

**What it did not do:**
- Wrote no numeric spec: no target pixel height measured from the reference, no palette count, no light direction.
- Made no variants.

**Orchestrator's view:** clean and readable, much better than the spike's early sprites. It falls short of shippable for four reasons:
- **Outline:** uniformly black everywhere, with no selective or coloured outline.
- **Shading:** 2–3 flat value steps per material, with no hue-shift (the shadows are just darker versions of the same colour) and no rim light or key-light side.
- **Silhouette:** a rectangle-on-rectangle body and blob hands; the "heavy-set" build reads as boxy, not soft.
- **Polish:** no manual anti-aliasing on the curves (the bun and shoulders are stair-stepped).

The craft rules (M2) and a written critique against the reference (M3) are the levers to test.

## D0: baseline, no guidance (opus, 9 tool calls, 8.5 min)
Output: one script building 20 bulged staves, 2 heads, 6 hoops with rivets, a brass tap, a bung and a cradle, with generated textures; rendered in Cycles; GLB 6.6 MB.

**What it did on its own:**
- Built 3 renders and looked at each.
- Did not plan with real dimensions first. Did not build in stages; the whole thing came from one script.
- Did not re-import the GLB, and the exporter warned about a texture sampler.

**Orchestrator's view:** "Blender tutorial" quality, not shipped. What falls short:
- **Wood:** the oak reads as new pale pine, and the staves are uniform in colour with no individual variation.
- **Wear and detail:** almost no weathering, and the hoops have no edge wear.
- **Brass:** the tap is cartoon-gold and too clean.
- **Cradle:** sharp unbevelled pine boxes.
- **Floor:** a streaky stretched-noise texture.
- **Camera:** a grey studio render at a hero angle, never the in-game camera.

M7 should fix the plan, the stages, the wear and the camera-scale review.

## P1: M1 only (opus, 16 tool calls, 5 min)
Output: 27×26 px, 26 colours, 4 renders. It measured the reference with pixel-run analysis (the mage is 156 screen px ÷ 6 = 26 art px; the head is 54%) and wrote `spec.txt`.

**Effect of M1:**
- The proportions and scale now match the reference: about 40% smaller than P0, chibi head-heavy.
- The spec also copied the reference's *weaknesses*: a full near-black outline, no anti-aliasing, no rim light. M1 recorded them as the style.

**Orchestrator's view:**
- More faithful, but not better as art.
- At 26 px the face is crude: the green dot eyes read as sickly, and the mouth is a smear.
- The body is a wide rectangle.
- The tankard reads well, now that it sits outside the silhouette.

**Finding for the skill:** "the reference wins" lets the spec lock in the reference's flaws. The spec has to separate two things:
- **style choices to copy:** scale, proportions, palette mood, light direction;
- **craft quality to beat:** outline treatment, anti-aliasing, ramps.

That separation is M2's job. Keep it in mind when reading P2.

## P2: M1 + M2 (opus, 28 tool calls, 9 min)
Output: 29×28 px, 30 colours, 5 renders. It wrote a measured spec, then applied the craft rules.

**Effect of M2:**
- The ramps are now hue-shifted: the hair runs yellow-orange → maroon, and the apron shades to lilac-grey.
- The outline is tinted per material and lightened on the lit edges.
- The pose is asymmetric: one hand on the hip, the other holding the tankard out by its handle.
- It ran a solid-black silhouette check, which moved the tankard out past the body.
- It ran an orphan-pixel check, and the hair strands became clusters.

**How it settled the conflicts with the reference:** sensibly, and on its own. It kept the reference's near-black outline *value* but tinted it per material. It added only a small bounce light, and anti-aliased only the jaw.

**Orchestrator's view:** the best arm so far, clearly above P1 and more charming than P0. The palette has life, and the face reads (teal eyes, blush, open smile). What still falls short:
- the tankard reads as a box or frame;
- the top of the hair is a flat cap;
- the torso is still a wide block;
- the bottom of the skirt is a straight edge.

**Contamination:** the finished skill was visible in the subagent's skill list partway through the run. The agent did not invoke it. Every later arm is told not to.

## P3: M1 + M2 + M3 (opus, 33 tool calls, 12 min)
Output: 32×32 canvas, 28 px tall, 25 colours. 6 written critique rounds, each with a side-by-side image of the reference crop, the 8× sprite, the silhouette and the 1× sprite.

**Effect of M3:** real, specific critiques: 5, 6, 3, 3, 1 and 1 gaps per round. Fixes they produced:
- a rounded head instead of a helmet;
- a bell skirt and sloped shoulders;
- a 2 px mouth, matching the reference;
- a notch so the mug separates in silhouette;
- the apron darkened so the face is the brightest area, matching the reference's focal hierarchy;
- anti-aliasing at the crown.

**Stopping:** it stopped when the remaining gaps were minor. That is weaker than the skill's "stop only when you cannot name a gap" rule: it named a gap and stopped anyway.

**Orchestrator's view:**
- The form is the best so far: a soft heavy-set body, a bell skirt, a convincing hand on the hip, a wooden tankard with a brass band.
- The outline went back to uniform near-black, because the agent chose the reference over M2 for the outside line. So M1's "reference wins" still overrides M2 on the outline.
- Overall about the same as or slightly above P2. The blind judge decides.

**Skill fixes indicated so far:**
- M1 must split *style to copy* from *craft to beat*.
- M3's stop rule needs teeth: name the next gap, or justify in one line why it is invisible at game scale.

## P4: M1–M4 (opus, 34 tool calls, 12 min)
Output: 29×27 px, 29 colours. 4 variants, then 4 critique rounds.

**Effect of M4:** weak.
- The 4 variants share the same head, face and proportions; only the arms and the dress colour change. That is not real divergence in silhouette or proportion.
- The choice was well argued: D was the only variant whose tankard survives in silhouette. The agent then grafted A's hip arm onto it.

**Craft:**
- The face follows the reference: no mouth, a peach nose patch.
- The belly is shaded as a sphere.
- The tankard has staves and bands.
- The belt breaks up the stripe.

**Stopping:** it stopped once the only gap it could still name was the colour count. That is the "name the next gap" rule obeyed in letter only.

**Orchestrator's view:**
- About level with P3. Cleaner face, comparable body. The outline is still uniform near-black.
- M4 as written does not buy much, because the variants are too similar. To be worth its cost, the variants must differ in **silhouette and proportion**, e.g. a heavy pear shape, a stocky square, a tall broad build; each one is judged in solid black.

## Skill refactor after P0–P4 (before P5)
1. **M1** splits the spec into *style to copy* (scale, proportions, palette mood, light direction, face language) and *craft floor to beat* (outline treatment, ramps, anti-aliasing, rim). The craft floor never drops below M2, even when the reference does.
2. **M3 stop rule:** stop only after a round where you cannot name a gap visible **at 1× game scale against the target backdrop**. Wins at 8× only don't count. You must also render on the real backdrop: a warm wood floor and a cold blue pool.
3. **M4:** the variants must differ in silhouette and proportion (judged in solid black), not in palette or arm pose alone.

## D1: full skill incl. M7 (opus, 67 tool calls, 51 min, about 6× D0's time)
Output: an upright barrel. 18 jittered staves, 4 hoops with riveted laps, 3-board heads, a tarnished brass spigot. A **baked** GLB: 19.2k tris, 1 material, 4.6 MB. The final render comes from the *re-imported* GLB.

**Effect of M7:** every process step now happened:
- **Plan first:** real dimensions in metres, and a game camera defined (ortho, 40° down, about 66 px tall).
- **4 stages**, each rendered as a hero view next to the in-game view at 1× and 6×.
- **Specific critiques:** the grain went from "flame" to "camouflage" to long streaks; the rust from "tortoiseshell" to granular; it debug-rendered a spill mask that was 1 cm wide.
- **Engine budget:** the bake took the mesh from 38.7k to 19.2k tris and the file from 24.7 MB to 4.6 MB. It parsed the GLB JSON and re-imported it to check.

**Orchestrator's view:**
- A real, engine-ready game asset, where D0 was a scene file with a studio render.
- Lit for the tavern (warm key, cold moon rim). It reads at 66 px.
- Visually it is stylized-clean rather than "weathered": the wood is a little smooth and uniform up close.
- As a *pipeline* result it is far ahead of D0; as a hero image it is comparable.

**Lessons for the later 3D pipeline (D7):**
- The in-game-scale check is the decisive habit.
- Baking plus GLB re-import verification belongs in every asset's definition of done.
- Weathering needs its own explicit pass: edge wear, grime, stains, all scaled to be visible at game size.

## P5: full skill after the refactor (opus, 45 tool calls, 14 min)
Output: a 27×32 figure, 50 colours. 5 variants, 6 critique rounds, and 1× checks on wood and moonlight crops taken from env-r6.

**Effect of the refactor:**
- **M1:** both lists were written. The craft floor was applied above the reference: tinted outlines lightened on the lit edges, a cool 1 px moon rim, hue-shifted ramps.
- **M4:** the variants differed in silhouette (pear, stocky square, apple, tall-broad, chibi-round), judged in solid black next to the reference's silhouette. This time the choice was real.
- **M3:** it checked against the backdrop. It removed bodice lacing because the lacing merged with the foam at 1×, and it stopped under the stop rule (no gap visible at 1× on either backdrop).
- **Initiative:** it took Bertha's mob cap and green bodice from the HUD portrait in env-r6, so the sprite stays consistent with existing art.

**Orchestrator's view:**
- The most *designed* sprite: it has a costume, a character and the right game palette.
- But it is busier: the white cap and white sleeves form one mass, the tankard is a grey block, and 50 colours is a lot for this scale.

The blind judge decides.

## Blind judge, round 1 (opus; names shuffled, key in scratchpad `judge_key.json`)

| Rank | Sprite | Arm | Total /50 | Size (fig h) | Colours | Isolated px |
|---|---|---|---|---|---|---|
| 1 | N | **P0** (no guidance) | 32 | 43 | 28 | 7.7% |
| 2 | L | P4 (M1–M4) | 31 | 27 | 29 | 11.5% |
| 3 | M | P3 (M1–M3) | 31 | 28 | 25 | 11.6% |
| 4 | R | P2 (M1+M2) | 25 | 28 | 30 | 8.8% |
| 5 | K | P1 (M1) | 22 | 26 | 26 | 6.7% |
| 6 | Q | **P5** (full skill) | 21 | 32 | 50 | 20.8% |

### Verdict: the skill as written FAILED its test
No arm beat the baseline. The full skill came last.

**Why P0 won:** the cleanest clusters, a consistent outline and the most appeal (closed-eye smile). It was drawn on a **bigger canvas** (43 px tall), and the extra pixels make clean craft easier. It is the wrong scale for the game (1.35× the scene's sprites), but it still won on craft, readability and appeal.

**Why the guided arms lost:**
1. **M1 shrank the sprite** to the reference's 26–28 px, and every guided arm then had too few pixels for the detail it tried to add.
2. **M2 and M6 added *things*:** rim light, tinted and lightened outlines, hue shifts, props, lacing. At 27–32 px, each addition became noise. P5 ended with 50 colours and 21% isolated pixels.
3. **M3 self-critique is unreliable.** Every agent "could not name a gap" or accepted one and stopped, while a blind judge named 4–6 obvious flaws in each sprite. An artist cannot see its own noise.
4. **The noise measure tracks the judge's craft scores better than any method does.** P0 and P1 were the only arms under 8%.

### Caveats
- n = 1 per arm. The spread between the 2nd and 4th places is within run-to-run variance.
- The test gave the reference's scale, not the game's. The scene's sprites are about 32 px tall.

### Changes for round 2 (the skill refactor)
- **Objective gates replace self-assessment:** `audit_sprite.py` checks colour count, isolated-pixel % (≤ 8%) and figure height after every render. It agrees with the judge's own measurements.
- **Independent critic:** the critique comes from a fresh agent that did not draw the sprite, so the artist never grades its own work. In this repo, the orchestrator runs the artist → critic → artist loop.
- **Restraint rule:** at ≤ 32 px every added colour and detail must pass the noise gate. Prefer fewer, larger clusters. The colour budget is ≤ the reference's count.
- **Scale comes from the game,** not the reference: the target figure height is set by the scene the sprite stands in.
- **Variance:** run the baseline twice (P0b) to see run-to-run spread before crediting any method.

## Round 2: rewritten skill (gates + independent critic), with a baseline rerun for variance

| Arm | What it was | Fig h | Colours | Isolated px | Audit |
|---|---|---|---|---|---|
| P0 | baseline, run 1 | 43 | 28 | 7.7% | height fail |
| P0b | baseline, run 2 | 31 | 33 | 11.3% | FAIL (colours, noise) |
| P6pre | rewritten skill, before the critic | 32 | 20 | 3.6% | PASS |
| P6 | rewritten skill, after 1 independent-critic round | 32 | 21 | 6.9% | PASS |

**Baseline variance is large.** The same prompt produced a 43 px slim barmaid and a 31 px chibi. Round 1's "P0 wins" was partly the luck of one sample.

**The critic step (P6pre → P6):** one fresh critic gave 5 specific, pixel-located flaws, led by "head as wide as body, reads as a toddler or jar". The artist fixed them in one pass and the sprite still passed the gates.

### Blind judge, round 2 (opus; key: W=P0, X=P6, Y=P0b, Z=P6pre)

| Rank | Arm | Fidelity | Craft | Readability | Character | Ship | **Total** |
|---|---|---|---|---|---|---|---|
| 1 | **P6** (skill + critic) | 7 | 6 | 7 | 8 | 6 | **34** |
| 2 | P0b (baseline) | 6 | 5 | 6 | 7 | 5 | 29 |
| 3 | P6pre (skill, no critic) | 6 | 6 | 7 | 5 | 4 | 28 |
| 4 | P0 (baseline) | 3 | 7 | 6 | 4 | 3 | 23 |

### Verdict: the rewritten skill PASSES, and the critic is the main lever
- **The skill with the critic won.** It was the only sprite judged on-model (it matches the HUD portrait), at scene scale and unmistakably heavy-set.
- **The gates alone were not enough.** They make a sprite *clean* (P6pre had the best clusters) but not *good*: the judge called P6pre "a peg doll or toy with no appeal". The critic round added +6 points, almost all of it character, fidelity and ship-readiness.
- **The baseline still has the most raw polish when it hits:** P0 scored 7 on craft. Its failures are scale and brief, the things the skill's game-scale spec fixes.
- **Remaining flaw of the winner:** the torso is a green sack; the left arm and sleeve merge into the body; the mug arm is a stiff horizontal bar.

The next lever is a **second critic round**. Within the skill, use it on every hero asset.

### What goes into the pipeline (for A12, the sprite animator, and the later asset pipeline)
1. A spec from the game: target height and the palette taken from existing on-model art (the HUD portrait).
2. Silhouette variants in solid black.
3. Objective gates after every render.
4. **2 independent-critic rounds**, run by the orchestrator, each critic a fresh agent.
5. A final blind check against the scene.
