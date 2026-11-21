---
name: crafting-game-assets
description: Use when producing game art in code or in Blender (pixel sprites, sprite sheets, textures, tiles, 3D props or sets), especially against a reference image or a "production quality" bar, or when earlier assets were judged amateur, flat, toy-like or generic.
---

# Crafting game assets

## Overview
A first pass that "looks fine" is roughly where a capable model's art defaults land. Production quality comes from measuring the reference, applying named craft rules, and making several rounds where you look at the output against the reference and write specific critiques. Taste is the bar; process is how you reach it.

## M1. Turn the reference into a numeric spec before you draw
Open the reference, crop the part that matches your asset, and write these down as numbers:
- **Size:** the character's height in art pixels (count it on the crop: height ÷ pixel size), and the head-to-body ratio.
- **Palette:** how many ramps, steps per ramp, and how many colours in total.
- **Light:** the key-light direction (e.g. top-left), and whether there is a rim or bounce light.
- **Outline:** colour, whether it is selective (dropped or lightened on lit edges), and whether interior lines are used.
- **Shading:** how many values per material, whether dithering is used, and whether anti-aliasing is applied by hand.

Split the spec into two lists, and write both down:
- **Style to copy:** scale, proportions, palette mood, light direction, face language (how eyes, mouth and nose are drawn). When you would have chosen differently, the reference wins.
- **Craft floor to beat:** outline treatment, ramps, anti-aliasing, rim or bounce light. The M2 rules are the minimum here, even when the reference does less. A reference with a flat black outline still gets a material-tinted outline from you.

## M2. Craft rules (pixel art)
- **Hue-shifted ramps:** shadows shift toward cool or purple and drop saturation a little; highlights shift toward warm or yellow. Never just darken the same hue.
- **Selective outline:** the outer outline uses a dark, saturated version of the neighbouring colour, not pure black. Break or lighten it where the light hits. Interior lines are lighter than the outer ones.
- **Volume:** 3–4 values per material. Light from one consistent side. Use a 1-px rim or bounce light on the shadow side to separate the shape from dark backgrounds.
- **Manual anti-aliasing:** curves get intermediate-colour pixels at their stair steps, with no jaggies on the outer silhouette. Never anti-alias against transparency.
- **Clusters, not noise:** no single stray pixels. Every colour patch is a deliberate shape. Dither only where materials meet, if at all.
- **Silhouette first:** fill the sprite solid black. You should still be able to tell who it is and what they are holding. Soft shapes (heavy-set, cloth) need curves and overlap, not stacked rectangles.
- **Hands and props:** the hands read as hands (a 2–3 px mass with a lighter knuckle line), and props overlap the body.

## M3. Render, look, critique, fix: at least 3 rounds
Each round:
1. Render the asset at game scale and at 8× next to the reference crop, in **one** image.
2. Look at it.
3. Write a numbered critique that compares it to the reference: "the shadow ramp is grey where the reference is purple", not "make it better". Then fix only those points.

Every round also renders the asset at 1× on its **real in-game backdrop** (e.g. a warm wood floor and a cold blue light pool), because a sprite that reads on flat grey can vanish in the game.

**Stop rule:** stop only after a round in which you cannot name a gap that is visible **at 1× on the real backdrop**. Accepting a gap you can still name is not stopping, it is quitting. Bookkeeping gaps (colour count, a pixel of height) do not count as reaching the bar.

## M4. Diverge, then converge
Before refining, make **3–5 quick variants that differ in silhouette and proportion**, e.g. a pear shape, a stocky square, a tall broad build, a different head-to-body ratio. Variants that differ only in palette or arm pose do not count.

Render them all in **solid black** on one sheet next to the reference's silhouette. Choose the one whose silhouette alone says who this is, and give the reason in one line. Then refine only that one.

## M5. One thing at a time
- Do one asset, frame or stage at a time, and check it before moving on.
- For animation: get the key pose right first, then the in-betweens.
- Change one aspect per iteration (silhouette → ramps → outline → details) so you can see what each change did.

## M6. Anti-defaults: avoid these generic choices
- pure-black outlines everywhere;
- straight value-darkening shadows;
- a symmetric front pose with arms hanging straight down;
- rectangle torsos;
- saturated "primary" palettes;
- a 2-tone flat fill;
- a centred, perfectly symmetric face;
- 3D props with perfect cylinders and boxes, uniform materials and no wear;
- a default grey studio render.

## M7. 3D in Blender (CLI or MCP)
- **Plan first.** Write the part list with real-world dimensions in metres (e.g. a barrel is 0.9 m tall, 0.6 m across the bilge), the materials, and the camera. State the Blender version (5.x API).
- **Build in stages**, and render and inspect after each one:
  1. blockout proportions vs the reference;
  2. form (bevels, bulge, sag, irregularity: nothing perfectly straight);
  3. surface (bespoke materials: wood grain, metal pitting, edge wear from curvature or AO, dirt in the crevices);
  4. lighting and the final render.
- **Bevel every edge.** Add per-instance variation: noise-offset vertices and rotate staves, planks and stones individually.
- **Bake** heavy procedural nodes to image textures (base colour, normal, roughness, AO) before export. glTF keeps only image textures, so check that the exported GLB actually carries them.
- **Look at your renders as a critic** (M3), from the in-game camera angle and at the in-game scale, not only from a hero angle.
