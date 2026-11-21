# Content Format: Per-Section Authoring Template

Status: v1 (A02, 2026-11-21) plus Addendum 1 (A08, §J). Audience: content writers producing `docs/content/**.md`, and the converter that turns those files into `game/content/**/*.json` (`architecture.md` §8).

There is **no calendar**. Sections never declare time or day costs. They declare which **milestones they set** and which **escalation stage they require** (`gdd.md` §6.1). A zone may have a fixed `time_of_day` look (for example night at the Ring of Nine). That is a property of the scene, not a clock.

---

## A. File conventions

1. **One file per story section.** Paths and section ids follow `gdd.md` §7: `docs/content/act1/01-drowned-rat.md` (`a1.01`), `docs/content/act2/05-witchs-mere.md` (`a2.05`), `docs/content/side/barrows-old-kings.md` (`side.barrows`).
2. Each file has **YAML front matter**, then **fixed headings in a fixed order** (§B). Each heading holds prose for humans **and** fenced structured blocks for the converter.
3. **Structured blocks** are fenced code blocks whose info string is `yaml <block_type>`:
   ````
   ```yaml dialogue
   id: dlg.bertha_intro
   ...
   ```
   ````
   One entity per block. The converter reads only these blocks and the front matter. Prose is ignored by the build, but reviewers read it.
4. **YAML rules:** 2-space indentation. No anchors or aliases (`&`, `*`). No multi-document `---` inside blocks. Always double-quote **condition strings**, **effect strings**, and any text containing `:`, `#`, `"`, `{` or leading punctuation. Use `null` for none and `[]` for empty lists.
5. **Ids** follow `architecture.md` §8.2: `kind.snake_case`. Reuse ids that are already declared. Declare a new `flag.`, `var.` or `ms.` id in the `flags` block of the section that **first sets** it (§F.10).
6. **Text:** English. Dialogue lines are ≤ 250 characters each. Use `{player}` for the protagonist's name. No stage directions inside spoken text. Put them in `direction:`.
7. **Never invent mechanics in prose.** If a rule is missing from `gdd.md`, list it under **Open questions** at the bottom of the file.

---

## B. Section template (copy this)

````markdown
---
section_id: a1.01                     # aN.NN | side.<name>
title: "The Drowned Rat"
act: 1                                # 1 | 2 | 3
story_ref: "story.md §1 Hook, §5.1"
zones: [zone.drowned_rat, zone.cintra_mudflats, zone.cintra_docks]
available_when: "true"                # condition: when this section can start (§C)
escalation_stage_required: {min: 0, max: 0}   # inclusive. Use max: 4 for no upper limit
milestones_set: [ms.a1_rat_survived]
milestones_read: []                   # milestones this section's conditions test
level_band: [1, 1]                    # expected player level on entry and exit
---

# The Drowned Rat

## 1. Scene summary
Prose: 3–8 sentences. What happens, the dramatic question, how it ends.

## 2. Progress and escalation
Prose: which milestones are set and when. How the section looks at each allowed escalation
stage (variants are defined in the zone block).

## 3. Location layout
Prose: the areas, sight lines, and the route the player is meant to take.
```yaml zone
...                                    # §F.1, one block per zone
```

## 4. NPCs present
```yaml npc
...                                    # §F.2, one block per NPC (first appearance declares; later sections may only reference)
```

## 5. Dialogue trees
```yaml dialogue
...                                    # §F.3, one block per conversation
```

## 6. Encounters
```yaml encounter
...                                    # §F.4
```

## 7. Items and clues
```yaml item
...                                    # §F.5, new items only
```
```yaml clue
...                                    # §F.6
```
```yaml deduction
...                                    # §F.6, optional
```

## 8. Flags set and read
```yaml flags
...                                    # §F.10
```

## 9. Quest hooks
```yaml quest_stages
...                                    # §F.7: main-quest stages this section contributes
```
```yaml quest
...                                    # §F.7: full side quest (side files only)
```

## 10. Rumors and event cards (optional)
```yaml rumor
...                                    # §F.8
```
```yaml event_card
...                                    # §F.9
```

## 11. Failure states and branches
```yaml branches
...                                    # §F.11
```

## 12. Open questions
- Bullet list for the designer. Empty is fine.
````

---

## C. Condition language

Used in every field named `condition`, `available_when`, `when`, `if`, `closes_on`, or `available`.

**Grammar:**

```
expr    := or
or      := and ( "or" and )*
and     := unary ( "and" unary )*
unary   := "not" unary | atom
atom    := "(" expr ")" | "true" | "false" | bool_call | compare
compare := value OP value            OP ∈ == != < <= > >=
value   := INT | num_call | WORD     WORD = a bare enum word (e.g. friendly, reversed, stage ids)
```

**Boolean calls:**

| Call | True when |
|---|---|
| `flag(flag.x)` | The flag is set |
| `ms(ms.x)` | The milestone has been reached |
| `has_item(item.x)` | The player has ≥ 1 |
| `has_clue(clue.x)` / `ded(ded.x)` | The clue is found / the deduction is unlocked |
| `perk(perk.x)` | The perk is unlocked |
| `in_party(companion.x)` / `in_party(ally.x)` | The companion or ally is present and not retreated |
| `quest_active(quest.x)` / `quest_done(quest.x)` / `quest_failed(quest.x)` | Quest status |
| `visited(zone.x)` | The zone has been entered at least once |
| `rumor_heard(rumor.x)` | The rumor has been heard |
| `finale_seized()` | Endings only |

**Numeric or enum calls** (use with a comparison):

| Call | Returns |
|---|---|
| `var(var.x)` | int |
| `items(item.x)` | count |
| `stat(might\|agility\|grit\|wits\|presence)` | attribute |
| `skill(persuade\|intimidate\|investigate\|lore)` | check total including bonuses (`gdd.md` §6.10) |
| `rep(faction.x)` | −100..100 |
| `rep_tier(faction.x)` | `hostile < wary < neutral < friendly < allied` (ordered, comparable) |
| `stage()` | escalation stage 0–4 |
| `act()` | 1–3 |
| `level()` | 1–12 |
| `crowns()` | int |
| `count_ms(ms.a, ms.b, ...)` | how many of the listed milestones are reached |
| `quest_stage(quest.x)` | the current stage id (compare with a WORD) |
| `queen()` | Queen condition 0–3 |
| `finale_oath()` / `finale_anselm()` | `true\|reversed\|none` / `alive\|dead\|fled` (endings only) |

**Examples:**

```
"has_clue(clue.chalice_pollen) and skill(persuade) >= 4"
"rep_tier(faction.strept) >= friendly or has_item(item.marnadal_torc)"
"stage() >= 2 and not flag(flag.strept_guides)"
"count_ms(ms.a1_sickroom_done, ms.a1_abbey_done, ms.a1_ring_done) >= 2"
"quest_stage(quest.main_a1) == audience"
```

---

## D. Dialogue model (summary)

- `start` names the first node. Node ids are local `snake_case`.
- **Node types:** `line`, `choice`, `check`, `branch`, `effect`, `end`.
- **Option visibility:** if `condition` is false, the option is hidden, unless `show_locked: true`, in which case it is shown greyed out with its requirement.
- **Checks** are deterministic: `skill(...) + reputation modifier >= dc`. A failed check locks the option for this conversation. With `once: true` it stays locked permanently.
- **Bribe:** `bribe: <crowns>`. The option is shown only if the player can pay (after Haggler). Choosing it always pays and succeeds.
- Effects on an option apply when it is chosen (before `next`). Effects on a node apply when it is entered.
- Every path must reach an `end` node. Every `choice` node must have at least one option with no condition (a safe exit). Both are tested.

---

## E. Effects

Effects are strings in lists named `effects`, `on_complete`, `on_won`, `on_yielded`, `on_player_fled`, `on_enter`, `fail_effects` or `on_hear`. They are applied in list order.

| Effect | Arguments | Notes |
|---|---|---|
| `set_flag(flag.x)` / `clear_flag(flag.x)` | flag id | |
| `set_var(var.x, N)` / `add_var(var.x, N)` | var id, int | `add_var` clamps to the declared `min`/`max` |
| `reach_milestone(ms.x)` | milestone id | Write-once. Drives escalation |
| `set_act(N)` | 1–3 | Only in act transition sections |
| `give_item(item.x, N)` / `take_item(item.x, N)` | item id, count (default 1) | `take_item` on key items is allowed only here |
| `add_crowns(N)` | int (may be negative) | A negative value fails the whole effect list if the player cannot pay. Guard it with `crowns() >= N` |
| `add_rep(faction.x, N)` | faction id, int | |
| `add_xp(N)` | int | Only for one-off rewards. Quest, clue and check XP are automatic |
| `add_clue(clue.x)` | clue id | |
| `start_quest(quest.x)` / `fail_quest(quest.x)` | quest id | |
| `complete_objective(quest.x, objective_id)` | quest id, local id | Use when no condition expresses the objective |
| `start_dialogue(dlg.x)` | dialogue id | Chains into a new conversation after the current one ends |
| `start_encounter(enc.x)` | encounter id | |
| `goto_zone(zone.x, spawn_id)` | zone id, local spawn id | |
| `unlock_map_node(map.x)` / `add_map_pin(map.x)` | map node id | |
| `recruit(companion.x)` / `dismiss(companion.x)` | companion id | |
| `add_ally(ally.x)` / `remove_ally(ally.x)` | ally id | Scripted allies |
| `add_rumor(rumor.x)` | rumor id | Marks the rumor heard without drawing it |
| `verify_rumor(rumor.x)` | rumor id | |
| `heal_player(N)` / `heal_player(full)` / `damage_player(N)` | int or `full` | |
| `apply_status(poison\|burning\|bleed\|chill, N)` | status, stacks | |
| `play_beat(beat_id)` | local beat id | A scripted scene moment (camera, animation, bark) that the zone scene must implement. It must be listed in the zone block's `beats` |
| `set_checkpoint(checkpoint_id)` | local id | Autosave point |
| `open_shop(npc.x)` | npc id with a `shop` | |
| `administer_antidote(queen\|maelis)` | target | Consumes `item.wenna_antidote` |
| `send_antidote_rider()` | — | `gdd.md` §6.2 |
| `game_over(reason_id)` | local id | Escort death, etc. Reloads the last checkpoint |

Unknown ops, wrong argument kinds, or ids that are not declared fail the content tests.

---

## F. Block schemas

Fields marked **(req)** are required. Everything else is optional with the default shown.

### F.1 `zone`

```yaml zone
id: zone.drowned_rat                       # (req)
name: "The Drowned Rat"                    # (req)
kind: interior                             # (req) interior | exterior | dungeon | arena | hub
map_node: map.cintra                       # the travel-map node this zone belongs to, or null
time_of_day: night                         # dawn | day | dusk | night (a fixed look, not a clock)
cold_rate: 0                               # Chill per second outside warmth (gdd §6.4)
disguise_tag: null                         # masquerade | choir | null (gdd §6.5)
music: tavern_tense
areas:                                     # (req) named regions for placement
  - {id: taproom, description: "Low beams, six tables, a hearth on the east wall."}
  - {id: cellar, description: "Barrels, a hatch to the mudflats."}
spawns:                                    # (req) at least one with default: true
  - {id: front_door, area: taproom, default: true}
exits:
  - id: cellar_hatch
    area: cellar
    to_zone: zone.cintra_mudflats
    to_spawn: hatch_landing
    condition: "true"
    effects: []
interactables:
  - id: courier_body
    area: taproom
    kind: search                           # search | container | door | readable | lever | rest | shop | pickup (map_board is retired: leave to the map with an exit, §J.5)
    label: "Search the courier"
    condition: "flag(flag.courier_dead)"
    check: null                            # or {skill: investigate, dc: 4}
    once: true
    effects: ["give_item(item.dravin_letter, 1)"]
    fail_effects: []                       # only if check is set
triggers:
  - id: thugs_arrive
    area: taproom
    "on": interact                         # enter | interact | exit_attempt | beat_done | encounter_done (more in §J.3). Always quote the key (§J.8)
    source: courier_body                   # the interactable, exit, beat or encounter id the trigger watches (for non-enter triggers)
    condition: "not flag(flag.thugs_arrived)"
    once: true
    effects: ["set_flag(flag.thugs_arrived)", "play_beat(door_kicked)", "start_encounter(enc.rat_thugs)"]
hazards:
  - {id: hearth_fire, area: taproom, kind: fire, params: {damage_per_second: 5}}   # fire | deep_mud | tide | cold | trap | collapse | steam
checkpoints:
  - {id: before_thugs, area: taproom}
beats:                                     # scripted moments referenced by play_beat
  - {id: courier_dies, description: "Courier convulses, whispers 'Ostrel', dies."}
  - {id: door_kicked, description: "Three thugs kick in the front door."}
npcs:
  - {npc: npc.bertha, area: taproom, condition: "true"}
encounters: [enc.rat_thugs]
loot:
  - {container: cellar_shelf, items: [{item: item.poultice, count: 1}], condition: "true"}
variants:                                  # changes at escalation stages or after milestones
  - id: after_slice
    when: "ms(ms.a1_rat_survived)"
    description: "Tables overturned, courier's body removed."
    npcs_absent: []
    encounters_disabled: [enc.rat_thugs]
    interactables_disabled: [courier_body]
```

### F.2 `npc`

```yaml npc
id: npc.bertha                             # (req)
name: "Bertha"                             # (req)
faction: null                              # faction id or null
role: "Innkeeper of the Drowned Rat"       # (req)
motive: "Keep her tavern; pay off Jory."   # (req) what they want now
secret: "Owes Jory 200 crowns."            # or null
disposition: friendly                      # hostile | wary | neutral | friendly (starting attitude)
essential: true                            # cannot be killed
dialogue: dlg.bertha_intro                 # default conversation on interact, or null
barks: ["Mind the blood on my floor.", "Drink or leave."]
combat: null                               # enemy id if this NPC can fight
shop: null                                 # or {stock: [{item: item.poultice, count: 5}], price_mod: 1.0}
```

### F.3 `dialogue`

```yaml dialogue
id: dlg.bertha_intro                       # (req)
participants: [npc.bertha]                 # (req)
start: greet                               # (req)
nodes:                                     # (req)
  greet:
    type: line
    speaker: npc.bertha                    # npc id, or "player"
    text: "He came in coughing froth. Now he's dead on my floor, and you're standing over him."
    direction: "Wiping her hands on her apron."
    effects: []
    next: hub
  hub:
    type: choice
    options:
      - id: who
        text: "Who was he?"
        next: who_answer
      - id: foam
        text: "That froth isn't drink. [Investigate]"
        tag: investigate
        check: {skill: investigate, dc: 4, pass: foam_pass, fail: foam_fail}
        once: true
      - id: leave
        text: "Keep your door barred."
        next: bye
  foam_pass:
    type: effect
    effects: ["add_clue(clue.courier_foam)"]
    next: hub
  foam_fail:
    type: line
    speaker: npc.bertha
    text: "Looks like death to me, love."
    next: hub
  who_answer:
    type: branch
    cases:
      - {if: "flag(flag.letter_taken)", next: who_letter}
    else: who_plain
  who_letter:
    type: line
    speaker: npc.bertha
    text: "Royal courier, by the boots. Whatever's in that letter, they'll come for it."
    next: hub
  who_plain:
    type: line
    speaker: npc.bertha
    text: "Royal courier, by the boots."
    next: hub
  bye:
    type: end
```

Option fields: `id` (req), `text` (req), `next` (req unless `check` is set), `condition` ("true"), `show_locked` (false), `once` (false), `tag` (null: persuade | intimidate | investigate | lore | bribe | item | clue | sway), `check` ({skill, dc, pass, fail}), `bribe` (int), `effects` ([]).

### F.4 `encounter`

```yaml encounter
id: enc.rat_thugs                          # (req)
zone: zone.drowned_rat                     # (req) or "arena:<terrain>" for travel encounters
enemies:                                   # (req)
  - {enemy: enemy.choir_thug, count: 3, spawn: front_door, variant: null}
waves: []                                  # optional: [{after: wave_cleared|reversed_verse_2|..., enemies: [...]}]
attack_tokens: null                        # null = difficulty default
allow_yield: true
allies: [npc.bertha]                       # scripted helpers (no full AI party)
checkpoint: before_thugs                   # autosave before start
avoidable_by: ["dlg.thug_leader"]          # dialogue ids that can shrink or skip the fight (documentation; the logic lives in the dialogue effects)
on_won: ["reach_milestone(ms.a1_rat_survived)"]
on_yielded: ["add_clue(clue.thug_paid_in_abbey_silver)"]
on_player_fled: []                         # if the player leaves through an exit mid-fight
```

### F.5 `item` (new items only)

```yaml item
id: item.dravin_letter                     # (req)
name: "Dravin's iron-wax dispatch"         # (req)
category: key                              # (req) weapon | armor | trinket | consumable | ammo | key | document
description: "Sealed in dwarven iron-wax. 'The lower bolts in Ostrel are grinding loose...'"
price: 0
stack_max: 1
equip_slot: null                           # main_hand | ranged | armor | trinket
weapon: null                               # {base: 12, type: slash, block_pct: 0.7, armor_pen: 0, bonus_vs: {construct: 2.0}, moveset: sword}
armor: null                                # {armor: 10, resist: {cold: 0.8}}
consumable: null                           # {effects: ["heal_player(40)"], use_time: 1.0}
readable_text: null                        # full text for documents
```

### F.6 `clue` and `deduction`

```yaml clue
id: clue.courier_foam                      # (req)
theory: theory.poisoner                    # (req) theory.poisoner | theory.fourth_verse | theory.choir | theory.anselm_plan
title: "Froth at the courier's mouth"      # (req)
text: "Grey-green froth and pinpoint pupils: not drink, but poison."   # (req) journal text
supports: []                               # suspect ids: varn | pell | anselm | raimund | vandals
refutes: []
```

```yaml deduction
id: ded.varn_thief_not_poisoner            # (req)
theory: theory.poisoner                    # (req)
condition: "has_clue(clue.varn_ledgers)"   # (req)
title: "Varn is a thief, not a poisoner"
text: "The ledgers he burns hide toll embezzlement. He has no reason to want the Queen dead."
```

### F.7 `quest_stages` (main quests) and `quest` (side quests)

Main quests span many files. Each section contributes stages. The converter merges them by `order`, with the lowest order first.

```yaml quest_stages
quest: quest.main_a1                       # (req)
order: 10                                  # (req) unique within the quest; sections use multiples of 10
stages:
  - id: survive_the_rat                    # (req) unique within the quest
    journal: "A courier died at the Drowned Rat with a letter from one Dravin Ostrel. Someone wants it back."
    objectives:
      - {id: get_letter, text: "Take the courier's letter", condition: "has_item(item.dravin_letter)", optional: false}
      - {id: survive, text: "Survive the Choir thugs", condition: "ms(ms.a1_rat_survived)", optional: false}
      - {id: learn_poison, text: "Learn what killed the courier", condition: "has_clue(clue.courier_foam)", optional: true, xp: 20}
    on_complete: []
    next: []                               # [] = continue to the next stage by order. Or [{if: "...", stage: id}, {stage: id}]
```

A side quest is a full `quest` block. Its header fields are `id`, `kind: side`, `title`, `giver`, `available` (condition), `closes_on` (condition or null), `xp` (on completion), `stages` (same shape as above), and `outcome_effects: {completed: [], failed: []}`.

### F.8 `rumor`

```yaml rumor
id: rumor.r01_poisoned_cup
text: "The Queen's not dying of fever. Someone's poisoning her cup. Ask the marsh-witch."
truth: true                                # true | false | half | cover
sources: [npc.bertha]                      # taverns/NPCs that can tell it
available: "true"
on_hear: ["add_map_pin(map.witchs_mere)"]
verified_by: "has_clue(clue.chalice_pollen)"
```

### F.9 `event_card` (travel encounters and modal choices)

```yaml event_card
id: event.l1_tax_collectors
terrain: lowlands                          # lowlands | valley | mountain | none (scripted)
table_slot: 1                              # 1–8 on the terrain table, or "esc" for the escalation pool, or null
requires: "true"
title: "Tax collectors at the ford"
text: "Two royal tax men are taking a widow's last goat."
options:                                   # same option schema as dialogue choices (F.3), but next: null ends the card
  - {id: intervene, text: "Stand between them. [Intimidate 5]", tag: intimidate, check: {skill: intimidate, dc: 5, pass_effects: ["add_rep(faction.crown, -2)", "add_xp(30)"], fail_effects: ["start_encounter(enc.tax_guards)"]}, next: null}
  - {id: pay, text: "Pay the levy. [Bribe 15]", bribe: 15, effects: ["add_xp(15)"], next: null}
  - {id: ignore, text: "Ride on.", next: null}
combat: null                               # encounter id if a choice leads to a fight (via start_encounter)
```

Cards have no nodes, so a check option on a card uses `{skill, dc, pass_effects: [], fail_effects: []}` instead of `pass`/`fail` node ids. Every card needs at least one option with no condition and no check.

### F.10 `flags`

Declare every new `flag.`, `var.` and `ms.` id exactly once across all content, in the section that first sets it.

```yaml flags
declare:
  - {id: flag.courier_dead, type: bool, desc: "Courier has died (beat courier_dies)."}
  - {id: flag.thugs_arrived, type: bool, desc: "Thug encounter triggered."}
  - {id: flag.letter_taken, type: bool, desc: "Player took the letter."}
  - {id: ms.a1_rat_survived, type: milestone, desc: "Player survived the Drowned Rat (fight, talk, or flight)."}
  - {id: var.bulbs_recovered, type: int, min: 0, max: 6, desc: "Wenna's bulbs returned."}
reads:                                     # documentation only: ids declared elsewhere that this section tests
  - flag.chalice_secured
```

### F.11 `branches` (failure states and branches)

```yaml branches
paths:
  - id: fight
    when: "Player fights all three thugs in the taproom."
    outcome: "ms.a1_rat_survived; Bertha friendly; exit by front door to docks."
    sets: ["reach_milestone(ms.a1_rat_survived)"]
  - id: flee
    when: "Player takes the cellar hatch after the thugs arrive."
    outcome: "Mudflats chase; reach docks; ms.a1_rat_survived."
    sets: ["reach_milestone(ms.a1_rat_survived)"]
failures:
  - id: player_dies
    result: reload_checkpoint              # reload_checkpoint | game_over | soft_fail
    recover: "Reload before_thugs."
  - id: letter_left_behind
    result: soft_fail
    recover: "Bertha keeps the letter; she hands it over at the docks (dlg.bertha_docks)."
guarantees:                                # how this section's required milestones can always be reached (content test input)
  - "ms.a1_rat_survived reachable without any check (fight or flee)."
```

---

## G. Ids used across sections

Before inventing an id, check `gdd.md` (items §6.9, enemies §6.7, clues §6.11, factions §6.12, companions §6.13, quests §7, map §7.5) and the files that already exist. Reuse exactly. When `gdd.md` names an id, that id is binding.

## H. Conversion rules (for the converter tool)

| Block | Output file | Notes |
|---|---|---|
| front matter | `game/content/sections/<section_id>.json` | Kept for traceability and the content tests (escalation range, milestones) |
| `zone` | `game/content/zones/<suffix>.json` | |
| `npc` | `game/content/npcs/<suffix>.json` | |
| `dialogue` | `game/content/dialogues/<suffix>.json` | |
| `encounter` | `game/content/encounters/<suffix>.json` | |
| `item` | `game/content/items/<suffix>.json` | |
| `clue` / `deduction` | `game/content/clues/…` / `game/content/deductions/…` | |
| `quest_stages` | merged into `game/content/quests/<quest suffix>.json` | Sorted by `order`. Duplicate `order` or stage ids are errors |
| `quest` | `game/content/quests/<suffix>.json` | A side quest must not also receive `quest_stages` |
| `rumor` / `event_card` | `game/content/rumors/…` / `game/content/event_cards/…` | |
| `flags` | `game/content/flags/<section_id>.json` | Declarations. An id declared twice anywhere is an error |
| `branches` | `game/content/sections/<section_id>.json` (embedded) | Read by the act-gate and completability tests |
| `epilogue` | `game/content/epilogues/<suffix>.json` | Addendum 1 (§J.7) |
| `map_node` / `map_edge` | `game/content/map/nodes/<suffix>.json` / `game/content/map/edges/<suffix>.json` | Addendum 1 (§J.9) |
| `encounter_table` | `game/content/encounter_tables/<terrain>.json` | Addendum 1 (§J.9) |

The converter:
1. Fails on unknown block types, YAML errors, missing required fields, or duplicate ids (it reports file and line).
2. Does not interpret conditions or effects. It copies them verbatim. Parsing and checking happen in the Godot content tests (`architecture.md` §9.4).
3. Writes JSON with sorted keys and 2-space indentation, so it diffs cleanly.
4. Is idempotent: running it twice gives byte-identical output.

## I. Writer checklist (before handing back)

- [ ] The front matter is complete. `milestones_set` matches the `reach_milestone` effects in the file.
- [ ] Every zone has a default spawn. Every exit names an existing zone and spawn.
- [ ] Every `play_beat` id is listed in its zone's `beats`.
- [ ] Every dialogue path ends at an `end` node. Every choice node has an unconditional option.
- [ ] Every check has both `pass` and `fail`. Every DC is an integer from 4 to 10. The anchors are 4 easy, 6 medium, 8 hard and 10 legendary, and the values in between (5, 7, 9) are allowed, for example where `gdd.md` names them.
- [ ] Every required milestone has a path that needs no check and cannot be failed (`branches.guarantees`).
- [ ] Every new flag, var and milestone is declared in `flags`.
- [ ] Every condition and effect string is quoted and uses only §C, §E and §J.
- [ ] Every `on` key is written `"on":`, and every option id that reads as a YAML 1.1 boolean (`"yes"`, `"no"`, `"on"`, `"off"`) is quoted (§J.8).
- [ ] Enemy ids come from `gdd.md` §6.7. Item, clue and quest ids follow `gdd.md` where it names them.
- [ ] No time, day, or deadline language in mechanics (prose atmosphere such as "at midnight" is fine when it matches `time_of_day`).

---

## J. Addendum 1 (A08, 2026-11-21)

Addendum 1 adds the constructs that the four content slices needed. It is part of the format: §C, §E and §F are read together with it, and the content tests and the converter apply it. Anything that is not listed here or in §C–§F is still invalid.

### J.1 Condition calls

| Call | True when / returns |
|---|---|
| `equipped(item.x)` | The item is in one of the player's equipment slots (§F.5 `equip_slot`). Example: `equipped(item.kosk_badge)` |
| `disguised()` | The player is "permitted" in the current zone (`gdd.md` §6.5): the zone has a `disguise_tag`, and the player wears or carries the matching disguise (`choir`: `item.choir_robe` equipped and `item.pale_feather` held; `masquerade`: `item.masquerade_invitation` held). Outside such a zone, test `equipped(item.choir_robe) and has_item(item.pale_feather)` |
| `heard_from(rumor.x, npc.x)` | The rumor was heard from that source |
| `map_unlocked(map.x)` / `map_pinned(map.x)` | The travel-map node is unlocked / has a map pin (`add_map_pin`) |

**Attribute checks.** A check's `skill` (dialogue options, interactables, event cards) may also be an attribute: `might | agility | grit | wits | presence`. The total is the attribute plus perk and item bonuses (§J.6 `mods`). Reputation never modifies an attribute check. Example: `check: {skill: agility, dc: 5, pass_effects: [], fail_effects: []}`. In a condition, `stat(agility)` remains the raw attribute.

**DCs.** Any integer from 4 to 10 is valid (see §I).

### J.2 Effect ops

| Effect | Arguments | Notes |
|---|---|---|
| `start_encounter(enc.x, opening)` | encounter id, optional `player_first \| enemy_first \| normal` | The second argument overrides the encounter's `opening` (§J.4) for this start |
| `end_encounter(enc.x, outcome)` | encounter id, `won \| yielded \| fled` | Ends the running encounter and applies the matching `on_won` / `on_yielded` / `on_player_fled` list |
| `force_flee(enc.x)` | encounter id | Every enemy still standing (bosses included) disengages and leaves. The encounter then ends as `won` |
| `damage_player_pct(N)` | percent of max HP | Never drops HP below 1. Use for `gdd.md` "costs 25% HP" rules |
| `take_random_consumable(N)` | count (default 1) | Removes N random consumables (seeded RNG). A no-op when the player has none |
| `set_flag_until(flag.x, scope)` | flag id, `zone_exit \| journey_end` | Sets the flag; the game clears it when the player next leaves a zone (`zone_exit`; set during travel, that is the arrival zone) or when the current journey ends (`journey_end`). This is the one-journey modifier and the "clear on zone exit" flag |
| `draw_rumor(npc.x)` | optional source npc | Draws one unheard, available rumor whose `sources` include that npc (any rumor if omitted), marks it heard from that npc and runs its `on_hear`. A no-op when none is left |
| `cancel_journey()` | — | Event cards only. The party token returns to the start node and no encounter is rolled. The safe exit of a forced hazard card |
| `raise_alarm()` | — | Raises the current zone's stealth alarm (fires `"on": alarm` triggers, §J.3) |
| `finale_event(event)` | `start \| gear_brake \| free_aldric \| command \| pursue \| shield` | Lock Chamber only. Calls the finale use case: start the ritual meter, apply Dravin's gear-brake (×1.25 `T_rev`), free Aldric, Command the Vault (coerced when `flag.aldric_coerced` is set), or the aftermath choice. It replaces the beat → use-case table |
| `cure_status(status)` | `poison \| burning \| bleed \| chill \| soot` | |
| `status_immunity(status, S)` | status, seconds | |
| `imbue_weapon(type, S)` | damage type, seconds | The main-hand weapon deals that damage type |
| `chill_rate_mod(P)` | percent | Changes the Chill rate by P% (−50 halves it) until the player leaves the current zone |
| `break_enemy_sight(S)` | seconds | Enemies near the player lose sight of them and their suspicion stops filling |

`goto_zone` into the current zone (a scene cut to another spawn) and a second `give_item` of a held `stack_max: 1` key item (a no-op) are valid as written. `take_item` of an item the player does not hold is a no-op.

### J.3 Triggers and hazard activation

New trigger kinds (`"on":`):

| `"on"` | `source` | Fires when |
|---|---|---|
| `combat_event` | one of the events below | A combat event happens in this zone. Optional fields: `encounter: enc.x` (only during that encounter), `threshold: N` (percent or count, see below), `ally: ally.x` |
| `alarm` | `null` or an encounter id | The zone's stealth alarm is raised: a guard's suspicion reaches 100 (`gdd.md` §6.5), or an effect runs `raise_alarm()`. With an encounter id, only guards of that encounter count |
| `checkpoint` | a checkpoint id of this zone | The player reaches the checkpoint |

Combat events: `first_windup` (first enemy attack wind-up), `first_block` (an enemy first blocks the player's attack), `first_parry` (the player's first parry), `first_yield`, `player_hp_below` (`threshold` = percent of max HP), `enemy_hp_below` (`threshold` = percent), `enemy_enters_area` (an enemy enters the trigger's `area`), `enemy_downed`, `ally_downed` (`ally`), `wave_cleared`, `reversed_verse` (Lock Chamber; `threshold` = verse number 1–4).

**Hazards** gain four optional fields. A hazard is active when `enabled_by` (if set) has happened, `disabled_by` (if set) has not, and `active_when` holds.

```yaml
hazards:
  - id: tide_pilings
    area: pilings_maze
    kind: tide                                   # adds tar (a flammable deep_mud) to the §F.1 kinds
    enabled_by: {"on": checkpoint, source: cp_pilings}   # starts inactive; turns on at the event
    disabled_by: null                            # {"on": <event>, source: <id>}: turns off for good at the event
    active_when: "true"                          # condition, checked continuously
    on_tripped: []                               # effects when the player trips it (traps and collapses)
    params: {creep_mps: 0.8, damage_per_second: 6}
```

`enabled_by` and `disabled_by` take the trigger vocabulary: `beat_done`, `checkpoint`, `interact`, `encounter_done`, `alarm`, `combat_event` (with `threshold`). Physical tuning stays free-form in `params`. Use `tripped_by` (not `trigger` or `on`) for what sets a trap or collapse off, for example `tripped_by: sprint`.

**Interactables** gain `activate_by: interact | shot` (default `interact`). `shot` means a crossbow hit activates it, for example a rope.

### J.4 Encounter fields

```yaml encounter
id: enc.fair_assassins
zone: zone.chociebuz_fair
opening: normal                    # normal | player_first (the player strikes first) | enemy_first (ambushed)
posture: hostile                   # hostile | patrol | sentry | dormant. Non-hostile enemies use stealth AI
                                   # (gdd §6.5) until the alarm, a takedown attempt, or start_encounter
enemies:
  - enemy: enemy.choir_assassin
    count: 1
    spawn: stall_roof
    variant: wren
    condition: "true"              # this entry spawns only if the condition holds
    posture: patrol                # overrides the encounter posture for this entry
    route: [oil_row, harvest_green]   # patrol route: area ids walked in a loop
    loop_s: 40
    downed_at_zero: true           # at 0 HP the enemy is downed, not dead; it counts as defeated
    flees_at_hp_pct: null          # leaves the fight at this HP percent (a scripted escape); counts as defeated
allies:                            # bare ids (npc.*, ally.*) or entries with a condition
  - {ally: ally.strept_warband, condition: "in_party(ally.strept_warband)"}
escorts:                           # an escort's death ends the game (gdd §6.18)
  - {ally: ally.aldric, game_over: escort_aldric}
target_priority: [ally.aldric]     # enemies prefer these targets, in order, over the player
variants:                          # chosen when the encounter starts; add_enemies joins the first group, waves replaces the wave list
  - {when: "stage() >= 2", add_enemies: [{enemy: enemy.drowner, count: 1, spawn: reed_edge, variant: null}]}
on_executed: []                    # applied each time the player executes a yielded enemy
```

`waves[].after` accepts `wave_cleared`, `reversed_verse_1` … `reversed_verse_4`, and `beat:<beat_id>`. `participants: []` is valid in a dialogue whose only speaker is the player or a non-speaking actor.

### J.5 Zone fields

```yaml zone
exits:
  - {id: road_out, area: gate, to_map: true, label: "Take the road", condition: "true", effects: []}   # leave to the travel map at the zone's map_node; to_zone and to_spawn are omitted
npcs:
  - {npc: npc.ysolde, area: bed, condition: "true", dialogue: dlg.queen_sickroom}   # overrides the npc's default dialogue here
underwater:                        # the whole zone is underwater
  breath_s: 60                     # breath meter; refilled in air pockets
  damage_per_second_when_empty: 6
  air_pockets: [hull_bubble]       # area ids
  ranged_allowed: false
chases:
  - id: varn_chase
    quarry: npc.varn
    start_on: {"on": beat_done, source: varn_flees}
    route: [the_leads, toll_house_roof, tanners_drop]   # the quarry's fixed route
    lose_distance_m: 25            # lost when the quarry stays this far ahead...
    lose_after_s: 5                # ...for this long, or reaches the end of the route
    catch_distance_m: 2
    cornered_when: "flag(flag.carriage_gone)"   # the chase cannot be lost; reaching the end corners the quarry
    on_caught: []
    on_escaped: []
    on_cornered: []
variants:
  - {id: dark_river, when: "stage() >= 2", cold_rate: 4, exits_disabled: [], hazards_disabled: []}
```

Exits may carry a `label` (the prompt text). An `exit_attempt` trigger may watch a `to_map` exit. Variants may also set `cold_rate`, `exits_disabled` and `hazards_disabled`.

### J.6 Items

```yaml item
id: item.kosk_badge
category: trinket
equip_slot: trinket
trinket:
  mods:
    - {mod: check_all, value: 2, vs_faction: faction.crown}
    - {mod: check_all, value: -2, vs_faction: faction.strept}
consumable: null
```

`mods` is a list of `{mod, value, vs_faction}` (`vs_faction` optional) and may appear under `trinket` and `armor`. Mods: `check_persuade`, `check_intimidate`, `check_investigate`, `check_lore`, `check_all` (dialogue and attribute checks against speakers of `vs_faction`, or all checks), `bleed_buildup_pct`, `chill_rate_pct`, `armor`, `max_hp`, `stamina_regen_pct`. A trinket with no mechanical effect has `mods: []`. A consumable used only through an interactable has `consumable: {effects: [], use_time: 0, quick_slot: false}`.

Consumable effects use §J.2: antitoxin `["cure_status(poison)", "status_immunity(poison, 30)"]`, fire oil `["imbue_weapon(fire, 60)"]`, smoke pot `["break_enemy_sight(6)"]`, frost-tallow `["chill_rate_mod(-50)"]`.

### J.7 Other additions

- **XP on milestones.** A milestone declaration may carry `xp` (`gdd.md` §6.8 "per data"), awarded once when it is reached: `- {id: ms.a1_rat_survived, type: milestone, xp: 150, desc: "..."}`. Objective `xp` is for optional objectives.
- **Suspects** (§F.6) add `vandals`.
- **Rumors** (§F.8) may carry `credibility_when` (a condition): the credibility mark shows when it holds, as with `perk.read_the_room`. Example: `"flag(flag.bertha_safehouse) and heard_from(rumor.r02_varn_ledgers, npc.bertha)"`.
- **Id kinds.** `epilogue` is a new kind. `edge` (map edges) and `esc` (escalation-pool entries) are the `architecture.md` §8.2 kinds. Escalation event cards are ordinary `event.esc_*` cards; the pool entries in the encounter tables (§J.9) carry the `esc.*` ids that `gdd.md` §6.3 names.
- **Act transitions.** The section that ends an act owns `set_act(N+1)` and `start_quest(quest.main_aN+1)`: `a1.08` for Act II, `a2.08` for Act III.

**`epilogue` block** (`act3/08-endings.md`; converter output `epilogues/<suffix>.json`):

```yaml epilogue
id: epilogue.lion_holds_10_the_lock_holds   # (req) epilogue.<ending>_<order>_<slug> or epilogue.v<order>_<slug>
ending: ending.lion_holds                   # (req) ending id, or null for a shared variant
order: 10                                   # (req) 10–30 core, 100–899 variants, 900 close
condition: "true"                           # (req) §C, endings calls allowed
title: "The lock holds"                     # (req)
text: "The bolts drove home one after another..."   # (req) narration
```

The slide's **[ART]** note stays in the prose above the block.

### J.8 For the converter (YAML pitfalls)

- PyYAML implements YAML 1.1, where the plain scalars `on`, `off`, `yes`, `no` (any case) are booleans. A trigger's `on:` key would become `True`, and an option `id: no` would become `False`.
- **The converter must load content with YAML 1.2 core-schema semantics**: only `true` and `false` (and their `True`/`TRUE`/`False`/`FALSE` spellings) are booleans. A date-like scalar stays a string. `truth: true` stays boolean.
- Content quotes these anyway, so it parses the same under both: `"on": interact`, `id: "no"`. The A08 validator fails any block that loads differently under 1.1 and 1.2.

### J.9 World blocks (`docs/content/world/`)

World files use the section template's front matter with `section_id: world.<name>`, `act: 0` (not bound to an act) and empty milestone lists. They hold three new block types.

```yaml map_node
id: map.tigg                       # (req)
name: "Tigg Crossroads"            # (req)
terrain: valley                    # (req) lowlands | valley | mountain
unlock: "ms(ms.act1_complete)"     # (req) condition; the node unlocks once it holds. Effects may also unlock it
```

```yaml map_edge
id: edge.ferrymen_camp_marnadal_field   # (req) edge.<a>_<b>
a: map.ferrymen_camp                    # (req)
b: map.marnadal_field                   # (req)
terrain: valley                         # (req)
kind: road                              # (req) road | sea | barge
condition: "true"                       # (req) passable when true
hazard: {event: event.ford_marnadal, condition: "not flag(flag.jory_crossing_granted)"}   # (req) forced hazard card, or null
```

```yaml encounter_table
terrain: valley                         # (req) one table per terrain
entries:                                # (req) exactly 8, slots 1–8
  - {slot: 5, kind: combat, ref: enc.travel_drowner_ambush, requires: "true", alt: null}
  - slot: 4
    kind: discovery
    ref: event.v4_charcoal_burners
    requires: "true"
    alt: {when: "stage() >= 2", kind: combat, ref: enc.travel_drowner_ambush}   # replaces the entry while `when` holds
escalation_pool:                        # (req) at least 3
  - {id: esc.v_black_river, kind: event_card, ref: event.esc_v_black_river, requires: "true"}
```

`kind` is `combat | event_card | discovery | hazard`. `ref` is the encounter or event card that runs (`null` for a quiet discovery). `alt` is how a table changes with the escalation stage (for example the stage 2 "drowner ×2 weight" rule: a second slot rolls the drowner ambush). An entry whose `requires` is false is rerolled (`gdd.md` §6.3).

Converter output (§H): `map_node` → `map/nodes/<suffix>.json`, `map_edge` → `map/edges/<suffix>.json`, `encounter_table` → `encounter_tables/<terrain>.json`, `epilogue` → `epilogues/<suffix>.json`. Required fields are the ones marked (req) above.
