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
