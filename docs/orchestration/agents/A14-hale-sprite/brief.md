# Brief A14: Hale, the player witcher, as a still sprite

## Who he is
Read `docs/design/gdd.md` §5 and `docs/design/story-witcher.md`. He is **Hale of the Matron**, an original witcher: not Geralt, and no CD Projekt designs.
- pale skin, **amber slit-pupil eyes**, black cropped hair, a notched ear;
- a **crimson hooded mantle**. The hood is a game mechanic, so the hood-up state is the default sprite;
- **two swords on his back**: steel and silver, both visibly readable;
- a medallion on his chest.

He is the player character: he must read instantly at 1× in the scene, and he must look like the hero (the most striking silhouette in the room), yet hunted and worn.

## Scale and style
- **Same scale and craft as the new Bertha:** a figure about 32 px tall, chibi proportions like `docs/art-direction/reference/ref-aldermere-4.png`. The reference is local only; never commit it.
- Look at `docs/art-direction/spike/bertha-frames.png` and `bertha-scene.png`: Hale must belong to the same cast.
- **The game scene:** `docs/art-direction/spike/env-r6.png`. The current placeholder hero is the orange-haired figure in the middle.

## Process (binding): `.claude/skills/crafting-game-assets/SKILL.md`, sections 1–6
1. Write the spec (height, colour budget ≤ 28, style to copy) to `art-src/pixel/hale/spec.md`.
2. Make **5 silhouette variants** in solid black: hood shapes, how the two sword hilts break the silhouette above the shoulders, how the mantle hangs. Pick one in one line.
3. Build the still in code: `art-src/pixel/hale/hale_still.py`, outputting `hale_1x.png` plus an 8× preview. Run `audit_sprite.py` after every render: height 30–34, ≤ 28 colours, ≤ 8% noise.
4. Build a backdrop check: 3× on env-r6's wood and moon pool, next to Bertha.
5. You cannot dispatch agents, so stop after the audit passes and hand back. The orchestrator runs two independent critic rounds and relays them to you.

## Rules
- Touch only `art-src/pixel/hale/**` and `docs/art-direction/spike/hale-*`.
- Do not modify the spike scene yet. Do not commit.

## Final message (under 12 lines)
- the paths;
- the spec;
- the variants and your pick;
- the audit line;
- the 2 things you are least sure about.
