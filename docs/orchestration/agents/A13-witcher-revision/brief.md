# Brief A13: Narrative revision. The protagonist is a witcher, and the story is about the prejudice he faces

## The user's direction (decision D8, verbatim)
> "the main character shud be a witcher obviously, and the entire story should be him getting shit on for being a witcher, duh"

## What exists
- **`story.md`** (repo root): the user's own outline. Treat it as the source and **do not edit it**.
- **`docs/design/gdd.md`:** the game rules. §5 has the protagonist "Hale, a hired sword between contracts", whom the player creates and names. §6 has the systems: reputation, checks, factions, the Queen and escalation.
- **`docs/content/`:** 40 fleshed-out sections (act1, act2, act3, side, world) in the format of `docs/design/content-format.md`, including Addendum §J. The registry is `docs/content/_registry.md`.
  - The vertical slice is **`docs/content/act1/01-drowned-rat.md`**: the opening in the dockside tavern, with innkeeper Bertha, the dying courier and the Choir thugs.
- **Content-writer conventions:** `docs/orchestration/agents/_content-writer-common.md`. Read it; its format rules bind you.

## IP rule (binding)
The setting already borrows Cintra. The witcher is an **original character**: not Geralt, and none of CD Projekt's named characters, schools, quests or game text. Use the general witcher concept:
- a mutated monster-hunter for hire;
- slit-pupil cat eyes and pale skin;
- two swords, steel for men and silver for monsters;
- a medallion that trembles near magic;
- simple signs;
- mutagenic elixirs;
- feared and despised by ordinary folk.

Give him an original name. Keep **Hale** as the default if it suits; it's your call, so justify it. Do not reuse CDPR's school names. If you want a school, invent one that fits this world: Góry Amell, Karak Ostrel, the dwarves.

## Your job
1. **Design: `docs/design/gdd.md`.**
   - **Rewrite §5, the protagonist.** He is a witcher, not a blank hired sword. Cover his identity, what he can do, and how the witcher shapes his kit: silver vs steel, the medallion, a few signs at most (the world is low-magic, so keep them modest), and elixirs as consumables.
   - **Add a new system section, "Witcher stigma"**, as a real mechanic, not flavour. Cover:
     - how NPCs and factions react to a witcher;
     - refusal of service, price markups, guards hassling him, a mob or crowd suspicion meter in towns;
     - being blamed for the Choir's crimes (the Choir frames him as the poisoner or monster);
     - how the hood or disguise (`disguised()` already exists in §J.1), reputation and deeds shift attitudes;
     - dialogue checks where stigma hurts or helps. Intimidate is easier, Persuade is harder.

     Write it so it can be built on the existing rules: conditions and effects in content-format §C/§E/§J, factions and reputation §6.9/§6.10, checks §6.10. Add the condition calls or effect ops it needs, as a **content-format addendum §K**, in the same style as §J.
   - Keep balance numbers concrete, in the same style as the rest of the gdd.
2. **Story spine: a new file `docs/design/story-witcher.md`.**
   - How the whole story is reframed around a despised witcher. Why he gets the courier's letter. How the court, Kosk, the Abbey, the dwarves and the common folk treat him. How the Choir uses anti-witcher hatred as cover for the regicide plot.
   - What the ending means for him. Saving a kingdom that spits on him is the emotional core.
   - **Section by section:** a table listing every one of the 40 content sections with the concrete changes each needs (dialogue, new beats, new stigma checks, changed outcomes).
3. **Rewrite the vertical slice in full: `docs/content/act1/01-drowned-rat.md`.**
   - Bertha refuses to serve him, or serves him in a chipped cup at double price. The drinkers mutter and move away from him.
   - When the courier dies in his arms, the room assumes the witcher did it.
   - The thugs use the crowd's hatred.
   - The tutorial beats still work.

   Keep every id, zone, encounter and the block structure valid against content-format.md, including §J and your new §K, and update `_registry.md` for any new ids. Make **Bertha** a memorable, specific person. The user has no idea who she is, so the slice must make her vivid in one scene.
4. **Do not rewrite the other 39 sections now.** The table in item 2 is their work order; they will be rewritten in a later wave.

## Rules
- Only touch:
  - `docs/design/gdd.md`, `docs/design/content-format.md` (§K only), `docs/design/story-witcher.md`;
  - `docs/content/act1/01-drowned-rat.md`, `docs/content/_registry.md`.
- Do not commit.
- **Validation:** the content validator from the reconciliation (A08's `val.py`) lived in a scratchpad and may be gone. Check by hand, by careful reading, that every id you use is declared and that every condition and effect matches the grammar.

## Final message (your report; you cannot write report files)
Under 30 lines:
- the protagonist summary (name, look, kit);
- the stigma system in 6 lines;
- the new §K calls and ops;
- how the slice now plays, beat by beat in 8 lines;
- who Bertha is now, in 2 lines;
- open questions or calls you made.
