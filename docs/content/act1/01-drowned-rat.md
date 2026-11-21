---
section_id: a1.01
title: "The Drowned Rat"
act: 1
story_ref: "story.md §1 The Hook, §5.1, §10 (The Drowned Rat); gdd.md §7.1 #1, §8.1 (vertical slice)"
zones: [zone.drowned_rat, zone.cintra_mudflats, zone.cintra_docks]
available_when: "true"
escalation_stage_required: {min: 0, max: 0}
milestones_set: [ms.a1_rat_survived]
milestones_read: [ms.a1_rat_survived, ms.a1_audience_done]
level_band: [1, 2]
---

# The Drowned Rat

**This is the vertical slice.** Everything in this file is built first, end to end, and must be completable both by fighting and by fleeing (gdd §8.1).

## 1. Scene summary

Late September, a little before midnight. Hale, a hired sword between contracts, is nursing the last of a cheap ale in the corner snug of the Drowned Rat, a dockside tavern on pilings at the end of Eel Row. The Abbey bells across the river ring unbidden, three slow strokes, and while the room is still muttering about it a royal courier staggers through the door foaming grey-green at the mouth. He dies on the hearthstones with a dispatch sealed in dwarven iron-wax pressed into Hale's hands, and one word: *"Ostrel."* Innkeeper Bertha wants the body out and the trouble with it. Whether Hale reads the letter or simply tries to leave, three hired Choir thugs kick in the front door to take it back. Hale can fight in the taproom (the combat tutorial, with Bertha throwing one bottle), talk the fight down to two or one, or run through Bertha's cellar and across the tidal mudflats under the city wall while the tide comes in behind and a crossbowman shoots from the quay. Either way Hale reaches the docks, where Lord Marshal Kosk's sergeant is waiting: "The Marshal wants a word." The dramatic question: *will you keep the letter and live?* The section ends with the summons to the palace (the slice end card).

## 2. Progress and escalation

- Stage 0 only (Equinox). The Abbey bells ringing at midnight is the stage-0 world effect from gdd §6.1, staged here as the opening beat `bells_unbidden`.
- `ms.a1_rat_survived` is reached in exactly one of two places, whichever comes first:
  1. `enc.rat_thugs*` `on_won` or `on_yielded` (the fight path, including a talked-down fight),
  2. the docks trigger `t_arrive_survived` on reaching the Fishmarket (the flee path). It is guarded by `not ms(...)`, so the reputation change below is applied once.
- With the milestone: `faction.choir` −30 (−30 → −60, gdd §6.12). Choir reputation is always Hostile; this only weights later events.
- Variant `after_rat` (all three zones) applies once `ms.a1_rat_survived` is set: tables overturned, blood sanded over, courier's body gone (once the letter is taken), Bertha's later conversation.
- This section starts `quest.main_a1` (trigger `t_start`).

### Tutorial beats woven into the fiction

| Tutorial | Where | Fiction |
|---|---|---|
| Move (WASD / left stick), camera | `snug`, beat `wake_in_snug` | Bertha calls last bell; the Abbey bells ring; Hale stands to look at the window |
| Interact (E / A) | `taproom`, the collapsed courier | Kneel by the man who fell through the door |
| Dialogue (choices, a check tag, a safe exit) | `dlg.courier_dying`, `dlg.bertha` | The dying man, then Bertha's questions. Bertha's options teach that a failed check is not a dead end (she tells you anyway) |
| Read a document, journal, clue board | `dlg.letter_read`, `clue.courier_foam` | Break the iron-wax; the clue pins to "Who is poisoning the Queen?" |
| Light / heavy attack | `enc.rat_thugs`, beat `tut_attack` | First thug swings a cosh |
| Block / parry | beat `tut_block` | Leader Cobb's two-hit combo has a loud wind-up |
| Dodge | beat `tut_dodge` | A thug kicks a bench at you |
| Kick | beat `tut_kick` | A thug raises a barrel-lid shield and blocks |
| Yield / spare | beat `tut_yield` | The first thug under 20% drops his cosh and begs |
| Quick item | beat `tut_quick_item` | First time HP < 50%: Bertha shouts "Drink that poultice, you fool!" |
| Sprint, deep mud, mash to escape | `zone.cintra_mudflats`, beats `tut_sprint`, `tut_mud` | Fleeing under the pilings |
| Crossbow aim / fire | beat `tut_crossbow` | The lantern-man on the quay. Shoot back or keep to cover |

The `tut_*` beats are UI prompts. The combat ones are fired by `"on": combat_event` triggers in `zone.drowned_rat` (content-format §J.3): first enemy wind-up, first enemy block, first yield, HP below 50%. `tut_dodge` is played by the scene when a thug first kicks a bench.

## 3. Location layout

### 3.1 The Drowned Rat (`zone.drowned_rat`)

A two-storey tarred timber tavern on oak pilings at the dead end of Eel Row. The south (street) half stands on the quay. The north half hangs over the mudflats, so the floor creaks and the cellar smells of the tide. Ground floor about 18 m (east–west) by 12 m (north–south). Low beams at 2.4 m (no jumping attacks, heavy swings can catch a beam: presentation only). Lit by the hearth and tallow candles; dim, warm, smoky.

```
 N  (over the mudflats)
 +-----------+------------------------+---------+
 | SCULLERY  |   B A R  (counter)  [T]|  stairs |   [T] = cellar trapdoor behind the bar's west end
 | pantry    |========================|  to     |
 +----+------+                        |  rooms  |
 |    |  (back_door to yard, NW)      +---------+
 |    |   o table      o table        |  HEARTH |   o = round table, == = long trestle
 |SNUG|   == trestle   == trestle     |  (E)    |   P = oak support post (full cover)
 | *  |        P            P         |         |   * = player start
 |    |   == trestle   == trestle     |         |
 +----+-------------[FRONT DOOR]------+---------+
 S  (Eel Row quay -> zone.cintra_docks)
```

- **snug** (SW corner, 4 × 4 m): a high-backed settle and a scarred table. Shuttered window onto the quay (barred, not an exit). Player start. Half a mug of ale, a guttering candle.
- **taproom** (centre, 10 × 8 m): two round tables and four long trestles. Benches are **low cover** (knee height). Two oak **support posts** are **full cover** and break line of sight. The courier collapses on the hearthstones at the east end. Old Fenn, a regular, sleeps face-down at the north round table.
- **hearth** (east wall, part of `taproom`): an open fire 2 m wide. `hearth_fire` hazard within 1.5 m (Burning on contact). A thug knocked into it takes fire damage. An iron poker leans on the jamb (flavor pickup, no stats).
- **bar** (north side, 9 m counter, waist height): **half cover**. Bertha's station. Shelves of bottles behind it (her one thrown bottle). The **cellar trapdoor** is in the floor behind the counter's west end.
- **stairs** (NE): to the upper rooms. Blocked in the slice by a snoring drover on the landing. In the full game this is the stairs exit to `zone.drowned_rat_loft` once `flag.bertha_safehouse` is set (A07).
- **scullery** (NW, 4 × 4 m): a cramped kitchen and pantry shelf (loot). A small window, too narrow to climb. The **back door** to the yard (A07's `zone.drowned_rat_yard`) is here: barred and unusable in this section (Bertha: "That's bolted, and it stays bolted.").
- **cellar** (under the bar, 12 × 6 m, ceiling 1.9 m, ankle-deep tide water): ale casks, a rack of smuggled brandy, rats. A wooden ladder down from the trapdoor. At the north end, the **tide hatch**: a heavy timber door in the outer wall that opens onto a ledge under the pilings, where Bertha rolls in casks off the flats at low water. Exit to the mudflats.

**Sight lines and intended route.** From the snug the player sees the whole taproom, the front door to the right, the bar ahead. The courier enters by the front door and staggers diagonally to the hearth, drawing the player across the room. After the thugs enter (front door), the bar and the trapdoor are directly behind the player: fight forward or run back. Bertha opens the trapdoor the moment the fight starts, so the flee option is always visible.

### 3.2 The Mudflats (`zone.cintra_mudflats`)

Tidal flats of the Yaruga mouth below Cintra's dock wall. Night, river fog, the city lights smeared above. A linear escape route about 150 m long, running west to east along the foot of the quay wall (the quay is 5 m above the mud). Four segments, separated by checkpoints. **Behind each checkpoint the tide floods the segment you left**: no backtracking, and the water creeps after you.

```
 W                                                                                  E
 [hatch_landing]--A--(cp_mud_start)--B: PILINGS MAZE--(cp_pilings)--C: THE MARGERY--(cp_wreck)--D: EEL WEIRS--(cp_weirs)--E: SLUICE STEPS -> docks
                                        ^ quay above: crossbowman with lantern walks east along the edge
```

- **A. hatch_landing** (8 m): a slimy timber ledge under the Rat's pilings and a short ladder down. Bertha slams and bolts the hatch behind you (beat `bertha_bolts_hatch`); the thugs must run round by the quay. Firm mud. Checkpoint `cp_mud_start`. Prompt `tut_sprint`.
- **B. pilings_maze** (40 m): a forest of tarred pilings under the Eel Row warehouses, 1–2 m apart. Every piling is **full cover** against the quay. Shallow mud (normal speed) with three marked **deep-mud pockets** (bubbling, darker; `deep_mud` hazard) and one root pocket on the obvious straight line (prompt `tut_mud`). Above, on the quay edge, **the lantern-man** (`enemy.choir_crossbowman`) walks east, matching the player's pace, shooting through the gaps. His lantern is the tell: where the light points is where he aims. Broken crab pots and a fallen spar are low cover. Ends at an upturned skiff: checkpoint `cp_pilings`. Prompt `tut_crossbow` the first time he is in clear view.
- **C. the_margery** (30 m): the gutted hull of the fishing cog *Margery*, beached on her side long ago. The hull is a dark tunnel (full cover from the quay, no crossbow fire inside). Her bow points at the quay, where a **rope ladder** hangs from a mooring ring. As the player enters, the crossbowman shouts "Down the Margery's ladder, cut him off!" (beat `thugs_on_ladder`): the pursuing thugs climb down. The player has a few seconds to reach the ladder's foot and **cut it** (interactable `rope_ladder`); the thugs drop 4 m into deep mud and are out of the chase (beat `thugs_stuck`). Otherwise they land and fight in the hull's mouth. Checkpoint `cp_wreck` at the stern.
- **D. eel_weirs** (45 m): V-shaped wicker eel-fences across the flats, with **deep mud** between them and a knee-deep tide channel (`tide` hazard is strongest here). The quickest line is through the mud. The safe line is along the top of the weir posts, which only a local knows: Wick, a mudlark girl sitting on a weir post with a sack of scavenged nails, will show it (`dlg.wick_weirs`). The crossbowman's view is blocked by fog here; he only shouts. Checkpoint `cp_weirs`.
- **E. sluice_steps** (10 m): the stone stair and rusted grate of the Fishmarket sluice. The grate stands open (the fishwives prop it for the eel-men). Climb up to the docks: exit to `zone.cintra_docks` at `sluice_top`.

### 3.3 The Docks (`zone.cintra_docks`)

Eel Row quay and the Fishmarket, night. A cobbled quay 12 m wide between the warehouses and the water, moored cogs creaking, a timber crane, stacked eel-barrels (cover), a watch post with a brazier. The Drowned Rat's front door is at the west end of Eel Row; the Fishmarket sluice stair comes up at the east end; the **market gate** to the city streets is north, beside the watch post. Sergeant Brask and two of Kosk's men wait under the crane with a lantern. If thugs or the crossbowman are still after the player, they see the Marshal's colors and scatter into the alleys (beat `thugs_scatter`).

```yaml zone
id: zone.drowned_rat
name: "The Drowned Rat"
kind: interior
map_node: map.cintra
time_of_day: night
cold_rate: 0
disguise_tag: null
music: tavern_tense
areas:
  - {id: snug, description: "SW corner booth, 4 x 4 m. High-backed settle, scarred table, half a mug of ale. Barred shutter onto the quay. Player start."}
  - {id: taproom, description: "Centre, 10 x 8 m. Two round tables, four trestles (benches = low cover), two oak posts (full cover). Hearth on the east wall with an iron poker. Front door on the south wall."}
  - {id: bar, description: "North counter, 9 m, waist high (half cover). Bottle shelves behind. Cellar trapdoor in the floor at the counter's west end."}
  - {id: stairs, description: "NE staircase to the rooms. Blocked by a snoring drover in this section; safehouse loft later (A07)."}
  - {id: scullery, description: "NW kitchen, 4 x 4 m. Pantry shelf. Narrow window. Barred back door to the yard."}
  - {id: cellar, description: "Under the bar, 12 x 6 m, ceiling 1.9 m, ankle-deep tide water. Casks, smuggled brandy, rats. Tide hatch in the north wall onto the mudflats."}
spawns:
  - {id: snug, area: snug, default: true}
  - {id: front_door, area: taproom, default: false}
  - {id: cellar, area: cellar, default: false}
  - {id: from_yard, area: scullery, default: false}
  - {id: from_loft, area: stairs, default: false}
  - {id: thug_door, area: taproom, default: false}
exits:
  - id: front_door
    area: taproom
    to_zone: zone.cintra_docks
    to_spawn: rat_door
    condition: "ms(ms.a1_rat_survived)"
    effects: []
  - id: tide_hatch
    area: cellar
    to_zone: zone.cintra_mudflats
    to_spawn: hatch_landing
    condition: "flag(flag.thugs_arrived)"
    effects: []
  - id: back_door
    area: scullery
    to_zone: zone.drowned_rat_yard
    to_spawn: from_rat
    condition: "ms(ms.a1_audience_done)"
    effects: []
  - id: loft_stairs
    area: stairs
    to_zone: zone.drowned_rat_loft
    to_spawn: from_taproom
    condition: "flag(flag.bertha_safehouse)"
    effects: []
interactables:
  - id: front_door_handle
    area: taproom
    kind: door
    label: "Leave"
    condition: "not flag(flag.thugs_arrived)"
    check: null
    once: true
    effects: []
  - id: courier_body
    area: taproom
    kind: search
    label: "Search the courier"
    condition: "flag(flag.courier_dead) and not flag(flag.letter_taken)"
    check: null
    once: true
    effects: ["give_item(item.dravin_letter, 1)", "give_item(item.courier_seal, 1)", "add_crowns(8)", "set_flag(flag.letter_taken)", "start_dialogue(dlg.letter_read)"]
  - id: courier_mouth
    area: taproom
    kind: search
    label: "Look closer at the froth on his lips"
    condition: "flag(flag.courier_dead) and not has_clue(clue.courier_foam)"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["add_clue(clue.courier_foam)", "play_beat(foam_closeup)"]
    fail_effects: ["play_beat(foam_shrug)"]
  - id: trapdoor
    area: bar
    kind: door
    label: "Cellar trapdoor"
    condition: "flag(flag.thugs_arrived)"
    check: null
    once: false
    effects: []
  - id: pantry_shelf
    area: scullery
    kind: container
    label: "Pantry shelf"
    condition: "true"
    check: null
    once: true
    effects: []
  - id: brandy_rack
    area: cellar
    kind: container
    label: "Rack of smuggled brandy"
    condition: "true"
    check: null
    once: true
    effects: []
  - id: notice_nail
    area: taproom
    kind: readable
    label: "Notices nailed by the door"
    condition: "true"
    check: null
    once: false
    effects: ["play_beat(read_notices)"]
  - id: tab_slate
    area: bar
    kind: readable
    label: "Bertha's tab slate"
    condition: "true"
    check: null
    once: false
    effects: ["play_beat(read_tab)"]
triggers:
  - id: t_start
    area: snug
    "on": enter
    source: null
    condition: "not quest_active(quest.main_a1) and not ms(ms.a1_rat_survived)"
    once: true
    effects: ["start_quest(quest.main_a1)", "set_checkpoint(rat_start)", "play_beat(bells_unbidden)", "play_beat(wake_in_snug)"]
  - id: t_courier_enters
    area: taproom
    "on": enter
    source: null
    condition: "not flag(flag.courier_entered)"
    once: true
    effects: ["set_flag(flag.courier_entered)", "play_beat(courier_stumbles_in)"]
  - id: t_courier_dies_alone
    area: taproom
    "on": interact
    source: front_door_handle
    condition: "not flag(flag.courier_dead)"
    once: true
    effects: ["set_flag(flag.courier_dead)", "play_beat(courier_dies_alone)"]
  - id: t_thugs_door
    area: taproom
    "on": interact
    source: front_door_handle
    condition: "not flag(flag.thugs_arrived)"
    once: true
    effects: ["set_flag(flag.thugs_arrived)", "set_var(var.rat_thugs_left, 3)", "play_beat(door_kicked)", "start_dialogue(dlg.rat_thugs_standoff)"]
  - id: t_thugs_letter
    area: taproom
    "on": beat_done
    source: letter_read
    condition: "not flag(flag.thugs_arrived)"
    once: true
    effects: ["set_flag(flag.thugs_arrived)", "set_var(var.rat_thugs_left, 3)", "play_beat(door_kicked)", "start_dialogue(dlg.rat_thugs_standoff)"]
  - id: t_fight_begins
    area: taproom
    "on": beat_done
    source: fight_begins
    condition: "true"
    once: true
    effects: ["play_beat(bertha_opens_trapdoor)", "play_beat(tut_attack)"]
  - id: t_tut_block
    area: taproom
    "on": combat_event
    source: first_windup
    condition: "true"
    once: true
    effects: ["play_beat(tut_block)"]
  - id: t_tut_kick
    area: taproom
    "on": combat_event
    source: first_block
    condition: "true"
    once: true
    effects: ["play_beat(tut_kick)"]
  - id: t_tut_yield
    area: taproom
    "on": combat_event
    source: first_yield
    condition: "true"
    once: true
    effects: ["play_beat(tut_yield)"]
  - id: t_tut_quick_item
    area: taproom
    "on": combat_event
    source: player_hp_below
    threshold: 50
    condition: "true"
    once: true
    effects: ["play_beat(tut_quick_item)"]
  - id: t_bertha_bottle_bar
    area: bar
    "on": combat_event
    source: enemy_enters_area
    condition: "not flag(flag.bertha_bottle_thrown)"
    once: true
    effects: ["set_flag(flag.bertha_bottle_thrown)", "play_beat(bertha_bottle)"]
  - id: t_bertha_bottle_hp
    area: taproom
    "on": combat_event
    source: player_hp_below
    threshold: 40
    condition: "not flag(flag.bertha_bottle_thrown)"
    once: true
    effects: ["set_flag(flag.bertha_bottle_thrown)", "play_beat(bertha_bottle)"]
hazards:
  - {id: hearth_fire, area: taproom, kind: fire, params: {damage_per_second: 5, radius_m: 1.5, applies_status: burning}}
checkpoints:
  - {id: rat_start, area: snug}
  - {id: before_thugs, area: taproom}
beats:
  - {id: bells_unbidden, description: "Across the river the Abbey of St. Corwen rings three slow strokes at midnight. Nobody rang for a service. The room goes quiet; Old Fenn makes the sign of the lion. Ambient for escalation stage 0."}
  - {id: wake_in_snug, description: "Bertha (from the bar): 'Last bell, sellsword. Settle up or sleep in the gutter.' Movement and camera prompt appears."}
  - {id: courier_stumbles_in, description: "The front door bangs open. A man in the Crown's blue courier's coat, mud to the thighs, staggers in, coughing grey-green froth, and pitches onto the hearthstones. Bertha: 'Not on my floor!' Interact prompt over him."}
  - {id: courier_dies, description: "The courier presses the iron-waxed dispatch into Hale's hand, grips the wrist hard, whispers 'Ostrel', and stops breathing. His pupils are pinpricks."}
  - {id: courier_dies_alone, description: "As Hale reaches for the door, the courier convulses behind them and goes still on the hearth. Bertha swears softly."}
  - {id: foam_closeup, description: "Camera on the courier's lips: grey-green froth, a sweet smell like crushed lilies. The clue pins to the board (first board tutorial)."}
  - {id: foam_shrug, description: "Hale sees froth and nothing more. Bark: 'Bad drink? No. Can't tell.' Bertha can still explain it."}
  - {id: letter_read, description: "Hale breaks the dark iron-wax. Full-screen document: Dravin's dispatch. On close, boots on the quay outside."}
  - {id: door_kicked, description: "The front door slams inward off one hinge. Three men in tar-stained coats with coshes and a short-sword: Cobb Rennet in front. Old Fenn slides under his table."}
  - {id: fight_begins, description: "Cobb: 'Have it your way.' Thugs fan out; Old Fenn crawls under a trestle."}
  - {id: bertha_opens_trapdoor, description: "Bertha hauls up the cellar trapdoor behind the bar: 'Cellar's open, if you've the sense to run! Tide hatch at the far end!' The trapdoor gets an exit marker."}
  - {id: bertha_bottle, description: "Once per fight, the first time a thug is within 3 m of the bar or the player falls below 40% HP: Bertha breaks a bottle of rotgut over the nearest thug's head (35 poise damage, 6 blunt) and ducks. Bark: 'And stay down!'"}
  - {id: tut_attack, description: "Prompt: light attack, hold for heavy. Fired at fight start."}
  - {id: tut_block, description: "Prompt: block, tap at the last moment to parry. Fired on the first enemy wind-up within 3 m."}
  - {id: tut_dodge, description: "Prompt: dodge. Fired when a thug first kicks a bench or charges."}
  - {id: tut_kick, description: "Prompt: kick breaks a block. Fired the first time an enemy blocks the player's attack."}
  - {id: tut_yield, description: "Prompt: a yielding enemy can be spared or finished. Fired the first time a thug yields."}
  - {id: tut_quick_item, description: "Prompt: quick slot item. Fired the first time player HP < 50%. Bertha: 'Drink that poultice, you fool!'"}
  - {id: thugs_down, description: "The last thug drops. Silence; the hearth crackles. Old Fenn: 'Is it over? Is there more ale?'"}
  - {id: read_notices, description: "Notices: 'MEN WANTED for the Marnadal Watch, pay in silver' (faded); 'LOST: one grey goose, answers to Agnes'; a crude charcoal lion with its tail cut off."}
  - {id: read_tab, description: "Slate behind the bar. 'Sellsword: 3 ales, 1 pie (cold).' Below, in a harder hand, a column of sums with a J beside it, struck through again and again."}
npcs:
  - {npc: npc.bertha, area: bar, condition: "true"}
  - {npc: npc.courier, area: taproom, condition: "flag(flag.courier_entered) and not flag(flag.courier_dead)"}
  - {npc: npc.rat_thug_leader, area: taproom, condition: "flag(flag.thugs_arrived) and not ms(ms.a1_rat_survived)"}
  - {npc: npc.old_fenn, area: taproom, condition: "true"}
encounters: [enc.rat_thugs, enc.rat_thugs_two, enc.rat_thugs_one]
loot:
  - {container: pantry_shelf, items: [{item: item.poultice, count: 1}], condition: "true"}
  - {container: brandy_rack, items: [{item: item.poultice, count: 1}], condition: "true"}
variants:
  - id: after_rat
    when: "ms(ms.a1_rat_survived) and flag(flag.letter_taken)"
    description: "Tables overturned and righted, sand thrown over the blood, the courier's body taken away by the Marshal's men. Bertha behind the bar with a cudgel in reach. The front door hangs crooked on new hinges."
    npcs_absent: [npc.courier, npc.rat_thug_leader]
    encounters_disabled: [enc.rat_thugs, enc.rat_thugs_two, enc.rat_thugs_one]
    interactables_disabled: [courier_body, courier_mouth, front_door_handle]
```

```yaml zone
id: zone.cintra_mudflats
name: "The Mudflats under Eel Row"
kind: exterior
map_node: map.cintra
time_of_day: night
cold_rate: 0
disguise_tag: null
music: chase_mud
areas:
  - {id: hatch_landing, description: "8 m slimy timber ledge under the Rat's pilings, short ladder down to firm mud. Hatch bolted behind."}
  - {id: pilings_maze, description: "40 m forest of tarred pilings 1-2 m apart (full cover vs the quay). Shallow mud, three deep-mud pockets, one root pocket on the straight line. Crab pots and a fallen spar (low cover). Quay 5 m above with the lantern-man."}
  - {id: the_margery, description: "30 m. The beached cog Margery on her side: a dark hull tunnel, full cover from the quay. Rope ladder from a mooring ring at her bow. Deep mud at the ladder's foot."}
  - {id: eel_weirs, description: "45 m. V-shaped wicker eel-fences, deep mud between, a knee-deep tide channel. Safe path along the weir-post tops. Fog hides the quay."}
  - {id: sluice_steps, description: "10 m. Stone stair and propped-open rusted grate of the Fishmarket sluice, up to the docks."}
spawns:
  - {id: hatch_landing, area: hatch_landing, default: true}
  - {id: sluice_bottom, area: sluice_steps, default: false}
  - {id: quay_lantern, area: pilings_maze, default: false}
  - {id: ladder_foot, area: the_margery, default: false}
  - {id: weir_mouth, area: eel_weirs, default: false}
exits:
  - id: sluice_up
    area: sluice_steps
    to_zone: zone.cintra_docks
    to_spawn: sluice_top
    condition: "true"
    effects: []
  - id: hatch_back
    area: hatch_landing
    to_zone: zone.drowned_rat
    to_spawn: cellar
    condition: "ms(ms.a1_rat_survived)"
    effects: []
interactables:
  - id: rope_ladder
    area: the_margery
    kind: lever
    label: "Cut the ladder"
    condition: "flag(flag.thugs_on_ladder) and not flag(flag.thugs_landed)"
    check: null
    once: true
    effects: ["set_flag(flag.ladder_cut)", "play_beat(thugs_stuck)"]
  - id: drowned_satchel
    area: pilings_maze
    kind: container
    label: "A drowned man's satchel, caught on a piling"
    condition: "true"
    check: null
    once: true
    effects: []
  - id: margery_locker
    area: the_margery
    kind: container
    label: "The Margery's rotten sea-chest"
    condition: "true"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["add_crowns(6)"]
    fail_effects: []
triggers:
  - id: t_hatch_bolted
    area: hatch_landing
    "on": enter
    source: null
    condition: "not ms(ms.a1_rat_survived)"
    once: true
    effects: ["set_flag(flag.rat_fled)", "play_beat(bertha_bolts_hatch)", "set_checkpoint(cp_mud_start)", "play_beat(tut_sprint)"]
  - id: t_lantern_man
    area: pilings_maze
    "on": enter
    source: null
    condition: "not ms(ms.a1_rat_survived)"
    once: true
    effects: ["play_beat(lantern_man_spots)", "start_encounter(enc.mudflats_crossbow)"]
  - id: t_cp_pilings
    area: the_margery
    "on": enter
    source: null
    condition: "true"
    once: true
    effects: ["set_checkpoint(cp_pilings)", "play_beat(tide_floods_pilings)"]
  - id: t_thugs_ladder
    area: the_margery
    "on": enter
    source: null
    condition: "not ms(ms.a1_rat_survived) and var(var.rat_thugs_left) >= 1"
    once: true
    effects: ["set_flag(flag.thugs_on_ladder)", "play_beat(thugs_on_ladder)"]
  - id: t_thugs_land_two
    area: the_margery
    "on": beat_done
    source: thugs_on_ladder
    condition: "not flag(flag.ladder_cut) and var(var.rat_thugs_left) >= 2"
    once: true
    effects: ["set_flag(flag.thugs_landed)", "start_encounter(enc.mudflats_thugs)"]
  - id: t_thugs_land_one
    area: the_margery
    "on": beat_done
    source: thugs_on_ladder
    condition: "not flag(flag.ladder_cut) and var(var.rat_thugs_left) == 1"
    once: true
    effects: ["set_flag(flag.thugs_landed)", "start_encounter(enc.mudflats_thug)"]
  - id: t_cp_wreck
    area: eel_weirs
    "on": enter
    source: null
    condition: "true"
    once: true
    effects: ["set_checkpoint(cp_wreck)", "play_beat(tide_floods_wreck)", "play_beat(tut_mud)"]
  - id: t_cp_weirs
    area: sluice_steps
    "on": enter
    source: null
    condition: "true"
    once: true
    effects: ["set_checkpoint(cp_weirs)", "play_beat(tide_floods_weirs)"]
hazards:
  - {id: maze_pockets, area: pilings_maze, kind: deep_mud, params: {speed_mult: 0.6, root_pockets: 1, mash_presses_to_free: 6}}
  - {id: ladder_mud, area: the_margery, kind: deep_mud, params: {speed_mult: 0.6, root_pockets: 0}}
  - {id: weir_mud, area: eel_weirs, kind: deep_mud, params: {speed_mult: 0.6, root_pockets: 3, mash_presses_to_free: 6, safe_path: weir_tops}}
  - {id: tide_pilings, area: pilings_maze, kind: tide, enabled_by: {"on": checkpoint, source: cp_pilings}, params: {creep_mps: 0.8, damage_per_second: 6, speed_mult_in_water: 0.5}}
  - {id: tide_wreck, area: the_margery, kind: tide, enabled_by: {"on": checkpoint, source: cp_wreck}, params: {creep_mps: 0.9, damage_per_second: 6, speed_mult_in_water: 0.5}}
  - {id: tide_weirs, area: eel_weirs, kind: tide, enabled_by: {"on": checkpoint, source: cp_weirs}, params: {creep_mps: 1.0, damage_per_second: 8, speed_mult_in_water: 0.5, channel_always_wet: true}}
checkpoints:
  - {id: cp_mud_start, area: hatch_landing}
  - {id: cp_pilings, area: the_margery}
  - {id: cp_wreck, area: eel_weirs}
  - {id: cp_weirs, area: sluice_steps}
beats:
  - {id: bertha_bolts_hatch, description: "Behind Hale the tide hatch slams and the bolt shoots home. Bertha, muffled: 'Run, love. They'll go round by the quay.' Fists hammer on wood inside, then boots overhead."}
  - {id: tut_sprint, description: "Prompt: sprint. Mud slows you, but this stretch is firm."}
  - {id: tut_mud, description: "Prompt: deep mud slows you; if you stick, mash Interact or Dodge to pull free. Weir tops are firm."}
  - {id: tut_crossbow, description: "Prompt: hold aim, fire. The lantern-man is 35 HP: two bolts. Or keep a piling between you."}
  - {id: lantern_man_spots, description: "A lantern swings over the quay edge. Voice: 'There! Under the pilings!' A bolt thunks into the wood beside Hale. The lantern's beam shows where he is aiming."}
  - {id: tide_floods_pilings, description: "Behind Hale, black water pours between the pilings with a hiss. No way back."}
  - {id: thugs_on_ladder, description: "The crossbowman shouts 'Down the Margery's ladder, cut him off!' Boots on the rope ladder at the bow, about 4 seconds of climbing. The ladder's mooring rope glints: interact prompt 'Cut the ladder'."}
  - {id: thugs_stuck, description: "Hale slashes the rope. The ladder and the men on it drop 4 m into the mud; one howls about his leg, the other is stuck to the waist and cursing. They are out of the chase."}
  - {id: tide_floods_wreck, description: "The tide pours through the Margery's broken ribs. The hull fills behind Hale."}
  - {id: tide_floods_weirs, description: "The weirs go under. Wick's voice somewhere in the fog: 'Told you!'"}
  - {id: crossbowman_falls, description: "Struck, the lantern-man topples from the quay edge into the mud with his lantern; it hisses out. Darkness under the pilings."}
  - {id: wick_path, description: "Wick drops bent nails along the tarred weir tops: a glinting safe path that skips the deep mud and the root pockets."}
npcs:
  - {npc: npc.mudlark_wick, area: eel_weirs, condition: "true"}
encounters: [enc.mudflats_crossbow, enc.mudflats_thugs, enc.mudflats_thug]
loot:
  - {container: drowned_satchel, items: [{item: item.crossbow_bolt, count: 4}], condition: "true"}
  - {container: margery_locker, items: [{item: item.poultice, count: 1}], condition: "true"}
variants:
  - id: after_rat
    when: "ms(ms.a1_rat_survived)"
    description: "Low tide, no pursuers. The Margery's ladder hangs cut (or whole). Wick is mudlarking; her path stays open. A quiet way between the Rat and the Fishmarket."
    npcs_absent: []
    encounters_disabled: [enc.mudflats_crossbow, enc.mudflats_thugs, enc.mudflats_thug]
    interactables_disabled: [rope_ladder]
```

```yaml zone
id: zone.cintra_docks
name: "Eel Row and the Fishmarket"
kind: exterior
map_node: map.cintra
time_of_day: night
cold_rate: 0
disguise_tag: null
music: docks_night
areas:
  - {id: eel_row, description: "West end of the quay. The Drowned Rat's front door. Stacked eel-barrels (low cover), a net-mending bench."}
  - {id: crane_quay, description: "Centre. Timber crane, moored cogs, a lantern on a post. Brask waits here."}
  - {id: fishmarket, description: "East end. Shuttered fish stalls, gutting tables, the sluice stair coming up from the flats."}
  - {id: watch_post, description: "North side by the market gate. A brazier and a bench. The gate leads into the city streets."}
spawns:
  - {id: rat_door, area: eel_row, default: true}
  - {id: sluice_top, area: fishmarket, default: false}
  - {id: gutter_lane, area: eel_row}
  - {id: market_gate, area: watch_post, default: false}
exits:
  - id: rat_door
    area: eel_row
    to_zone: zone.drowned_rat
    to_spawn: front_door
    condition: "ms(ms.a1_rat_survived)"
    effects: []
  - id: sluice_down
    area: fishmarket
    to_zone: zone.cintra_mudflats
    to_spawn: sluice_bottom
    condition: "ms(ms.a1_rat_survived)"
    effects: []
  - id: market_gate
    area: watch_post
    to_zone: zone.cintra_streets
    to_spawn: docks_gate
    condition: "flag(flag.brask_met)"
    effects: []
interactables:
  - id: watch_brazier
    area: watch_post
    kind: rest
    label: "Warm your hands at the watch brazier"
    condition: "flag(flag.brask_met)"
    check: null
    once: false
    effects: []
  - id: gutting_table
    area: fishmarket
    kind: search
    label: "Search under the gutting table"
    condition: "true"
    check: null
    once: true
    effects: ["add_crowns(2)"]
triggers:
  - id: t_arrive_survived
    area: fishmarket
    "on": enter
    source: null
    condition: "not ms(ms.a1_rat_survived)"
    once: true
    effects: ["reach_milestone(ms.a1_rat_survived)", "add_rep(faction.choir, -30)", "play_beat(thugs_scatter)"]
  - id: t_brask
    area: crane_quay
    "on": enter
    source: null
    condition: "not flag(flag.brask_met)"
    once: true
    effects: ["play_beat(brask_arrives)", "start_dialogue(dlg.brask_docks)"]
  - id: t_brask_from_rat
    area: eel_row
    "on": enter
    source: null
    condition: "not flag(flag.brask_met)"
    once: true
    effects: ["play_beat(brask_arrives)", "start_dialogue(dlg.brask_docks)"]
hazards: []
checkpoints:
  - {id: docks_arrival, area: crane_quay}
beats:
  - {id: thugs_scatter, description: "If anyone was still after Hale: at the top of the steps a lantern swings toward the crane, picks out the Marshal's red-and-iron surcoats, and the pursuers vanish into the alleys."}
  - {id: brask_arrives, description: "Sergeant Brask steps out from under the crane with two of Kosk's soldiers and a lantern. She looks at the blood on Hale, then at Hale's hands."}
  - {id: bertha_brings_letter, description: "Bertha comes up Eel Row in her shawl, a cudgel under one arm, and slaps the iron-waxed letter into Hale's palm: 'You left this. Don't.'"}
  - {id: slice_end_card, description: "Vertical slice only: end card. 'The Marshal wants a word.' Title, 'Thank you for playing', return to menu. In the full game this beat is skipped and the player keeps control."}
npcs:
  - {npc: npc.sergeant_brask, area: crane_quay, condition: "not ms(ms.a1_audience_done)"}
  - {npc: npc.bertha, area: eel_row, condition: "flag(flag.bertha_at_docks)"}
encounters: []
loot: []
variants:
  - id: after_audience
    when: "ms(ms.a1_audience_done)"
    description: "Day or night, the docks are working: fishwives, eel-men, a ballad-seller at the market gate. Brask's post is manned by an ordinary watchman."
    npcs_absent: [npc.sergeant_brask]
    encounters_disabled: []
    interactables_disabled: []
```

## 4. NPCs present

**Voice notes.**
- **Bertha**: fifties, broad, Cintran dock vowels, calls everyone "love" whether she likes them or not. Short sentences. Practical first, kind second, scared underneath. Swears by the river, not the gods.
- **The courier (Tomas Wyle)**: a young man trying to be brave. Can barely speak; every line is broken by the poison. He does not know what the letter says.
- **Cobb Rennet**: a docks bruiser with a pleasant, reasonable voice that makes him worse. Talks like a man doing a job. Uses "friend".
- **Old Fenn**: an ancient eel-man, drunk, comic relief with one true line.
- **Wick**: a mudlark girl of ten, quick and sly, says "you" like an accusation. Knows every inch of the flats.
- **Sergeant Oda Brask**: forties, Kosk's veteran, flat voice, never wastes a word, notices everything. Marnadal veteran (a limp).

```yaml npc
id: npc.bertha
name: "Bertha"
faction: null
role: "Innkeeper of the Drowned Rat"
motive: "Keep her tavern standing, her neck unstretched, and the blood off her floor."
secret: "Owes crippling protection money to Ninefingers Jory's collectors; the J on her slate is his. She also lands smuggled brandy through the tide hatch."
disposition: neutral
essential: true
dialogue: dlg.bertha
barks: ["Mind the blood on my floor.", "Drink or leave, love.", "Not the good bottles!", "Bolt's on. Breathe.", "I've seen worse. Not much worse."]
combat: null
shop: null
```

```yaml npc
id: npc.courier
name: "Tomas Wyle, royal courier"
faction: faction.crown
role: "A royal courier of the Crown's southern post, poisoned on the road"
motive: "Deliver the dispatch to the Lord Marshal. Failing that, to anyone who isn't the men behind him."
secret: "He shared a cup at a pilgrims' hostel on the King's Road with a kindly monk. He never saw the monk's face again."
disposition: friendly
essential: true
dialogue: dlg.courier_dying
barks: ["Can't... breathe right.", "Marshal... Kosk..."]
combat: null
shop: null
```

```yaml npc
id: npc.rat_thug_leader
name: "Cobb Rennet"
faction: faction.choir
role: "Docks bruiser hired by the Pale Choir to recover the courier's letter"
motive: "Get the letter, get paid the second half, leave no one who can describe him."
secret: "Paid in fresh-clipped silver wrapped in a strip of vellum; told to bring the letter to a man in grey at the Fishmarket steps. Does not know what the Choir is."
disposition: hostile
essential: false
dialogue: dlg.rat_thugs_standoff
barks: ["Easy, friend. Nobody has to bleed.", "Take the sellsword, I'll take the letter.", "Pin him by the hearth!", "That's coming out of your share, Dace."]
combat: enemy.choir_thug
shop: null
```

```yaml npc
id: npc.old_fenn
name: "Old Fenn"
faction: null
role: "An eel-man and the Rat's oldest regular"
motive: "Stay drunk and out of the way."
secret: "He saw a grey-hooded man waiting on the quay before the courier came in. He'll only say so if asked after the fight."
disposition: friendly
essential: true
dialogue: dlg.old_fenn
barks: ["Bells at midnight. Bad luck, that.", "Is there more ale?", "I'm not here. I'm a table."]
combat: null
shop: null
```

```yaml npc
id: npc.mudlark_wick
name: "Wick"
faction: null
role: "Mudlark girl who scavenges the flats"
motive: "Nails, coins, and not being caught by anyone holding a lantern."
secret: "Her brother was taken by the press-gangs for the Marnadal Watch; she hates anyone in a uniform except the ones who pay."
disposition: wary
essential: true
dialogue: dlg.wick_weirs
barks: ["Mud's hungry tonight.", "Not that way. You'll go in to your neck.", "Lantern men. Ugh."]
combat: null
shop: null
```

```yaml npc
id: npc.sergeant_brask
name: "Sergeant Oda Brask"
faction: faction.crown
role: "Lord Marshal Kosk's sergeant; runs his private patrol on the docks"
motive: "Find out what happened to the Marshal's courier before the Chancellery's men do."
secret: "Kosk has her watch the docks because he trusts none of the palace guard, half of whom draw extra pay from Chancellor Varn."
disposition: neutral
essential: true
dialogue: dlg.brask_docks
barks: ["Keep walking.", "Marshal's business.", "You've blood on your boots, friend."]
combat: null
shop: null
```

## 5. Dialogue trees

### 5.1 The dying courier

```yaml dialogue
id: dlg.courier_dying
participants: [npc.courier]
start: open
nodes:
  open:
    type: line
    speaker: npc.courier
    text: "Marshal's... man? You're not... the Marshal's man."
    direction: "On his back on the hearthstones, froth at his lips, clutching a leather dispatch case to his chest."
    next: hub
  hub:
    type: choice
    options:
      - id: easy
        text: "Easy. Lie still. Who did this to you?"
        next: who
      - id: what
        text: "What are you carrying?"
        next: what
      - id: bertha
        text: "Bertha! Water!"
        next: water
  who:
    type: line
    speaker: npc.courier
    text: "A monk. On the road. Shared his cup. He was... kind."
    next: give
  what:
    type: line
    speaker: npc.courier
    text: "For Kosk. Only Kosk. They're coming for it. I heard them on the quay."
    next: give
  water:
    type: line
    speaker: npc.bertha
    text: "Water won't help him, love. Look at his mouth."
    direction: "From behind the bar, not moving."
    next: give
  give:
    type: line
    speaker: npc.courier
    text: "Take it. Don't let them... Ostrel."
    direction: "He presses the dispatch case into Hale's hands and grips Hale's wrist hard."
    next: dies
  dies:
    type: effect
    effects: ["set_flag(flag.courier_dead)", "play_beat(courier_dies)", "set_checkpoint(before_thugs)"]
    next: bye
  bye:
    type: end
```

### 5.2 Reading the letter

The body search hands over the dispatch and opens this short prompt. Reading it is what the Choir men outside are waiting for (the noise of the seal breaking, Cobb's lookout at the shutter), so reading starts the ambush. Pocketing it unread delays the ambush until Hale tries to leave.

```yaml dialogue
id: dlg.letter_read
participants: [npc.bertha]
start: prompt
nodes:
  prompt:
    type: choice
    options:
      - id: read
        text: "Break the iron-wax and read it."
        effects: ["set_flag(flag.letter_read)"]
        next: text
      - id: pocket
        text: "Pocket it. It isn't addressed to me."
        next: pocket_line
  text:
    type: line
    speaker: player
    text: "'The lower bolts in Ostrel are grinding loose. Something old is waking in the dark. Come before the winter lock fails.' Signed in runes. Dravin Ostrel."
    direction: "Read aloud, slowly. The document view opens over the line."
    effects: ["add_clue(clue.ostrel_bolts)"]
    next: bertha_react
  bertha_react:
    type: line
    speaker: npc.bertha
    text: "Dwarf-wax. Haven't seen that since my granddad's day. Whatever it says, it's not for the likes of us."
    next: fire
  fire:
    type: effect
    effects: ["play_beat(letter_read)"]
    next: bye
  pocket_line:
    type: line
    speaker: npc.bertha
    text: "Smart. Now take it and him out of my tavern."
    next: bye
  bye:
    type: end
```

### 5.3 Bertha (router and topics)

`dlg.bertha` is Bertha's default conversation. It routes by state: before the thugs, after the fight, and later visits.

```yaml dialogue
id: dlg.bertha
participants: [npc.bertha]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "ms(ms.a1_rat_survived) and flag(flag.rat_fought) and not flag(flag.bertha_thanked)", next: after_fight}
      - {if: "ms(ms.a1_rat_survived)", next: regular}
      - {if: "flag(flag.thugs_arrived)", next: busy}
      - {if: "flag(flag.courier_dead)", next: dead_greet}
    else: early
  early:
    type: line
    speaker: npc.bertha
    text: "Three ales and a cold pie. Settle up or sleep in the gutter, sellsword. I'm not running a charity for heroes."
    next: early_hub
  early_hub:
    type: choice
    options:
      - id: pay
        text: "Here. Three ales, one pie. [Pay 3]"
        condition: "crowns() >= 3"
        effects: ["add_crowns(-3)", "set_flag(flag.tab_paid)"]
        next: paid
      - id: bells
        text: "Who rings bells at midnight?"
        next: bells
      - id: later
        text: "I'll settle up in a moment."
        next: bye
  paid:
    type: line
    speaker: npc.bertha
    text: "Honest. That's rarer than ale round here. Mind yourself going out."
    next: bye
  bells:
    type: line
    speaker: npc.bertha
    text: "St. Corwen's, over the river. Nobody, is who. Third time since spring. Fenn says it means a royal death."
    next: early_hub
  dead_greet:
    type: line
    speaker: npc.bertha
    text: "He came in coughing froth. Now he's dead on my floor, and you're standing over him with his letter. Wonderful."
    direction: "Wiping her hands on her apron, not coming round the bar."
    next: dead_hub
  dead_hub:
    type: choice
    options:
      - id: who
        text: "Who was he?"
        next: who_answer
      - id: poison
        text: "That froth isn't drink. What killed him?"
        condition: "not has_clue(clue.courier_foam)"
        next: poison_answer
      - id: ostrel
        text: "He said 'Ostrel'. Mean anything to you?"
        next: ostrel_answer
      - id: lore_ostrel
        text: "Ostrel. Karak Ostrel, under the Amell. [Lore 4]"
        tag: lore
        check: {skill: lore, dc: 4, pass: lore_pass, fail: lore_fail}
        once: true
      - id: help
        text: "Where do I take this?"
        next: help_answer
      - id: leave
        text: "I'll be going."
        next: bye
  who_answer:
    type: branch
    cases:
      - {if: "flag(flag.letter_taken)", next: who_letter}
    else: who_plain
  who_letter:
    type: line
    speaker: npc.bertha
    text: "Royal courier, by the blue coat and the boots. Whatever's in that letter, someone'll come for it, and I'd rather they came for it somewhere else."
    next: dead_hub
  who_plain:
    type: line
    speaker: npc.bertha
    text: "Royal courier, by the coat. He's got a case under him. I'm not touching it."
    next: dead_hub
  poison_answer:
    type: line
    speaker: npc.bertha
    text: "Poison. My cousin's lad frothed like that after the wrong mushroom, except he went in a day. This one's been dying for hours. And he smells sweet. Like a lily."
    effects: ["add_clue(clue.courier_foam)"]
    next: dead_hub
  ostrel_answer:
    type: line
    speaker: npc.bertha
    text: "Dwarf name. Old money, old songs. My granddad said they locked themselves under a mountain and threw away the key. That's all I know, and more than I want."
    next: dead_hub
  lore_pass:
    type: line
    speaker: player
    text: "Karak Ostrel. The dwarf-hold that helped Corvan the Lion win his crown. Sealed for a century. Nobody writes letters from there."
    next: lore_pass_b
  lore_pass_b:
    type: line
    speaker: npc.bertha
    text: "Well, somebody did. And somebody killed for it. You've a head on you, sellsword. Try to keep it."
    next: dead_hub
  lore_fail:
    type: line
    speaker: player
    text: "Ostrel. I've heard it in a song somewhere. Can't place it."
    next: dead_hub
  help_answer:
    type: line
    speaker: npc.bertha
    text: "He wanted the Marshal. Lord Kosk. His patrol walks the Fishmarket most nights, under the crane. They pay for news, I hear. Out the front, turn right."
    next: dead_hub
  busy:
    type: line
    speaker: npc.bertha
    text: "Not now, love! Hit them or run!"
    next: bye
  after_fight:
    type: line
    speaker: npc.bertha
    text: "Three of them. In my tavern. You've broken two of my benches and saved my neck, and I can't decide which I'm angrier about."
    effects: ["set_flag(flag.bertha_thanked)"]
    next: after_hub
  after_hub:
    type: choice
    options:
      - id: patch
        text: "I'm bleeding on your floor."
        condition: "not flag(flag.bertha_tended)"
        effects: ["set_flag(flag.bertha_tended)", "heal_player(full)"]
        next: patch_line
      - id: fenn
        text: "Did anyone see these men before they came in?"
        next: fenn_hint
      - id: body
        text: "What happens to him? The courier."
        next: body_line
      - id: where
        text: "Where do I take the letter?"
        next: help_answer_after
      - id: go
        text: "I'm going."
        next: go_line
  patch_line:
    type: line
    speaker: npc.bertha
    text: "Sit. Hold still. This is river-spirit, it'll sting like a wasp's wedding."
    direction: "She splashes brandy on the cuts and binds them with a bar rag."
    next: after_hub
  fenn_hint:
    type: line
    speaker: npc.bertha
    text: "Ask Fenn. He sits by the window to watch the eel boats. Sees more than he lets on, when he's not snoring."
    next: after_hub
  body_line:
    type: line
    speaker: npc.bertha
    text: "The Marshal's men'll want him. If not, the river takes what nobody claims. That's how it goes on Eel Row."
    next: after_hub
  help_answer_after:
    type: line
    speaker: npc.bertha
    text: "Lord Kosk's patrol. Fishmarket, under the crane. Go now, before the Chancellery's guards come asking who broke my door."
    next: after_hub
  go_line:
    type: line
    speaker: npc.bertha
    text: "Take this. Poultice. My mother made them. She'd have liked you, gods help her."
    effects: ["give_item(item.poultice, 1)"]
    next: bye
  regular:
    type: line
    speaker: npc.bertha
    text: "The hero of Eel Row. Your ale's on the house, once. After that you pay like everybody else."
    next: regular_hub
  regular_hub:
    type: choice
    options:
      - id: troubles
        text: "That J on your slate. Who is he?"
        condition: "ms(ms.a1_audience_done)"
        next: troubles
      - id: rumors
        text: "Heard anything worth hearing?"
        next: rumors
      - id: bye_reg
        text: "Just passing through."
        next: bye
  troubles:
    type: line
    speaker: npc.bertha
    text: "Nobody you want to meet. Nobody I want to talk about in my own taproom. Come round the back if you're serious."
    effects: ["start_dialogue(dlg.bertha_debt_plea)"]
    next: bye
  rumors:
    type: line
    speaker: npc.bertha
    text: "Plenty. None of it good. Pull up a stool."
    effects: ["draw_rumor(npc.bertha)"]
    next: bye
  bye:
    type: end
```

### 5.4 The thugs at the door

Cobb does the talking. The fight can be **shrunk** (gdd §8.1): Intimidate 6 makes one thug flee, Bribe 30 makes one thug walk. Both can be used, which leaves Cobb alone. Cobb himself never backs down by talk: he has been paid half up front. Starting crowns are 30 plus the courier's 8; paying is a real cost.

```yaml dialogue
id: dlg.rat_thugs_standoff
participants: [npc.rat_thug_leader, npc.bertha]
start: demand
nodes:
  demand:
    type: line
    speaker: npc.rat_thug_leader
    text: "Evening, friend. Our cousin there came in with something that's ours. Hand it over and we'll all forget tonight. My word on it."
    direction: "Cobb steps over the threshold, cosh loose in one hand. Two men behind him: a lanky one with a short-sword (Dace) and a squat one with a barrel-lid shield (Murrow)."
    next: demand_branch
  demand_branch:
    type: branch
    cases:
      - {if: "not flag(flag.letter_taken)", next: demand_body}
    else: hub
  demand_body:
    type: line
    speaker: npc.rat_thug_leader
    text: "Oh, he's still got it on him. Even better. Step away from the hearth and nobody needs to work tonight."
    next: hub
  hub:
    type: choice
    options:
      - id: why
        text: "Your cousin's dead. Poisoned. Who's paying you?"
        once: true
        next: why_answer
      - id: scare
        text: "First one through gets the poker in his teeth. Who wants to be first? [Intimidate 6]"
        tag: intimidate
        condition: "not flag(flag.rat_thug_scared)"
        check: {skill: intimidate, dc: 6, pass: scare_pass, fail: scare_fail}
        once: true
      - id: bribe
        text: "Thirty crowns says one of you never found anyone here. [Bribe 30]"
        tag: bribe
        bribe: 30
        condition: "not flag(flag.rat_thug_bribed)"
        effects: ["set_flag(flag.rat_thug_bribed)", "add_var(var.rat_thugs_left, -1)"]
        next: bribe_pass
      - id: foam
        text: "He was poisoned before he got here. They'll poison you too, when you've done your job. [Clue: Froth at the courier's mouth]"
        tag: clue
        condition: "has_clue(clue.courier_foam) and not flag(flag.rat_thug_scared)"
        show_locked: true
        check: {skill: persuade, dc: 4, pass: foam_pass, fail: foam_fail}
        once: true
      - id: fight
        text: "Come and take it."
        effects: ["set_flag(flag.rat_fought)"]
        next: fight_line
      - id: run
        text: "Bertha, the cellar!"
        next: run_line
  why_answer:
    type: line
    speaker: npc.rat_thug_leader
    text: "Paying? Somebody with clean hands and full pockets, friend, same as always. Last chance."
    next: hub
  scare_pass:
    type: line
    speaker: npc.rat_thug_leader
    text: "Murrow? Murrow! Get back here, you yellow sack of..."
    direction: "The squat one with the barrel-lid looks at the hearth, at Hale, and bolts up Eel Row."
    effects: ["set_flag(flag.rat_thug_scared)", "add_var(var.rat_thugs_left, -1)"]
    next: hub
  scare_fail:
    type: line
    speaker: npc.rat_thug_leader
    text: "Ooh. A poker. We're all trembling, friend."
    direction: "The thugs laugh. That option is gone."
    next: hub
  foam_pass:
    type: line
    speaker: npc.rat_thug_leader
    text: "Shut your mouth. Murrow, don't listen to... Murrow!"
    direction: "Murrow looks at the dead man's lips, goes white, and backs out of the door."
    effects: ["set_flag(flag.rat_thug_scared)", "add_var(var.rat_thugs_left, -1)"]
    next: hub
  foam_fail:
    type: line
    speaker: npc.rat_thug_leader
    text: "Lots of men die of drink on Eel Row, friend. Lots."
    next: hub
  bribe_pass:
    type: line
    speaker: npc.rat_thug_leader
    text: "Dace. Dace, you whoreson, you put that purse down. Dace!"
    direction: "The lanky one catches the purse, shrugs at Cobb, and strolls out whistling."
    next: hub
  fight_line:
    type: line
    speaker: npc.rat_thug_leader
    text: "Have it your way. Nothing personal, friend."
    next: fight_go
  run_line:
    type: line
    speaker: npc.bertha
    text: "Trapdoor's behind the bar! Go, go!"
    next: fight_go
  fight_go:
    type: effect
    effects: ["play_beat(fight_begins)"]
    next: pick_encounter
  pick_encounter:
    type: branch
    cases:
      - {if: "var(var.rat_thugs_left) >= 3", next: enc_three}
      - {if: "var(var.rat_thugs_left) == 2", next: enc_two}
    else: enc_one
  enc_three:
    type: effect
    effects: ["start_encounter(enc.rat_thugs)"]
    next: bye
  enc_two:
    type: effect
    effects: ["start_encounter(enc.rat_thugs_two)"]
    next: bye
  enc_one:
    type: effect
    effects: ["start_encounter(enc.rat_thugs_one)"]
    next: bye
  bye:
    type: end
```

### 5.5 A thug yields

```yaml dialogue
id: dlg.rat_thug_yield
participants: [npc.rat_thug_leader]
start: beg
nodes:
  beg:
    type: line
    speaker: npc.rat_thug_leader
    text: "Enough! Enough, friend. I've a mother. Probably. Let me crawl out of here and you'll never see my face again."
    direction: "Whoever yielded last, on his knees by the hearth. Spoken by the leader's voice set if Cobb is alive, else the generic thug voice."
    next: hub
  hub:
    type: choice
    options:
      - id: who
        text: "Who paid you? [Intimidate 4]"
        tag: intimidate
        check: {skill: intimidate, dc: 4, pass: who_pass, fail: who_fail}
        once: true
      - id: purse
        text: "Turn out your purse."
        once: true
        next: purse
      - id: spare
        text: "Crawl, then. Tell your paymaster the letter's gone where he can't reach it."
        effects: ["set_flag(flag.rat_thug_spared)"]
        next: spare_line
      - id: kill
        text: "No."
        effects: ["set_flag(flag.rat_thug_executed)"]
        next: kill_line
  who_pass:
    type: line
    speaker: npc.rat_thug_leader
    text: "Man in grey! Hood up, soft voice, soft hands. Pays half up front, half at the Fishmarket steps. Silver, new-clipped. That's all, I swear it."
    effects: ["add_clue(clue.thug_silver)"]
    next: hub
  who_fail:
    type: line
    speaker: npc.rat_thug_leader
    text: "Nobody! A man. A face. I don't look at faces, friend, it's bad for business."
    next: hub
  purse:
    type: line
    speaker: player
    text: "New silver pennies, clipped clean. Wrapped in a strip of vellum. Who pays thugs in vellum?"
    effects: ["add_crowns(12)", "add_clue(clue.thug_silver)"]
    next: hub
  spare_line:
    type: line
    speaker: npc.bertha
    text: "Out. And if I see you on Eel Row again I'll gut you myself."
    direction: "The thug scrambles out of the door on hands and knees."
    next: bye
  kill_line:
    type: line
    speaker: npc.bertha
    text: "Gods, love. On my floor."
    direction: "Hale finishes it. Bertha turns away and starts pouring sand."
    next: bye
  bye:
    type: end
```

### 5.6 Old Fenn

```yaml dialogue
id: dlg.old_fenn
participants: [npc.old_fenn]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "ms(ms.a1_rat_survived)", next: after}
    else: before
  before:
    type: line
    speaker: npc.old_fenn
    text: "Bells at midnight. Bells at midnight, and a dead man in blue. You mark me. Somebody royal's going in the ground before the snow."
    next: bye
  after:
    type: line
    speaker: npc.old_fenn
    text: "Is it over? Is there more ale? No? Then let an old man tell you something for free."
    next: after_hub
  after_hub:
    type: choice
    options:
      - id: saw
        text: "You sit by the window. What did you see before he came in?"
        once: true
        next: saw
      - id: sleep
        text: "Go back to sleep, Fenn."
        next: bye
  saw:
    type: line
    speaker: npc.old_fenn
    text: "Man in grey on the quay, hood up. Stood there under the lamp like he was waiting for a ferry. When the bells rang, he bowed his head. Like at prayers. Then the blue lad came stumbling, and grey man walked off."
    effects: ["add_clue(clue.thug_silver)"]
    next: bye
  bye:
    type: end
```

### 5.7 Wick at the eel-weirs

```yaml dialogue
id: dlg.wick_weirs
participants: [npc.mudlark_wick]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "ms(ms.a1_rat_survived)", next: later}
    else: greet
  greet:
    type: line
    speaker: npc.mudlark_wick
    text: "You're running from the lantern men. Everyone runs from the lantern men. Most of them drown in the weirs. You want to drown?"
    direction: "Perched on a weir post, a sack of bent nails on her lap."
    next: hub
  hub:
    type: choice
    options:
      - id: pay
        text: "Show me the way through and these are yours. [Bribe 5]"
        tag: bribe
        bribe: 5
        effects: ["set_flag(flag.wick_helped)"]
        next: path
      - id: kind
        text: "I'm trying not to. Your brother ever run from them? [Persuade 4]"
        tag: persuade
        check: {skill: persuade, dc: 4, pass: kind_pass, fail: kind_fail}
        once: true
      - id: scare
        text: "Move, or I'll throw you in."
        tag: intimidate
        next: scared
      - id: alone
        text: "I'll find my own way."
        next: alone
  path:
    type: line
    speaker: npc.mudlark_wick
    text: "Posts, not mud. Left foot on the tarred ones, never the green ones. Follow my nails."
    direction: "She drops bent nails on the weir tops ahead, a glinting trail along the safe path."
    effects: ["play_beat(wick_path)"]
    next: bye
  kind_pass:
    type: line
    speaker: npc.mudlark_wick
    text: "They took him for the Watch. In a uniform like yours. ...Fine. Fine. Posts, not mud. Keep up."
    effects: ["set_flag(flag.wick_helped)"]
    next: path
  kind_fail:
    type: line
    speaker: npc.mudlark_wick
    text: "Don't you talk about my brother."
    next: hub
  scared:
    type: line
    speaker: npc.mudlark_wick
    text: "Throw me in? I live in it. Enjoy the green posts."
    direction: "She vanishes into the fog. No path."
    next: bye
  alone:
    type: line
    speaker: npc.mudlark_wick
    text: "Suit yourself. I'll look for your boots tomorrow."
    next: bye
  later:
    type: line
    speaker: npc.mudlark_wick
    text: "You didn't drown. Good. Bring me nails and I'll tell you who's been walking on my flats at night."
    next: bye
  bye:
    type: end
```

### 5.8 Sergeant Brask at the docks

```yaml dialogue
id: dlg.brask_docks
participants: [npc.sergeant_brask, npc.bertha]
start: open
nodes:
  open:
    type: line
    speaker: npc.sergeant_brask
    text: "Stop there. You've blood on you and mud to the knees, and a royal courier went into the Drowned Rat an hour ago and didn't come out. Talk."
    direction: "Lantern raised. Her two soldiers spread to either side."
    next: letter_check
  letter_check:
    type: branch
    cases:
      - {if: "not has_item(item.dravin_letter)", next: no_letter}
    else: hub
  no_letter:
    type: line
    speaker: npc.bertha
    text: "Wait! Wait, you daft sod! You left this on him!"
    direction: "Bertha comes puffing up Eel Row with the iron-waxed dispatch."
    effects: ["set_flag(flag.bertha_at_docks)", "play_beat(bertha_brings_letter)", "give_item(item.dravin_letter, 1)", "set_flag(flag.letter_taken)"]
    next: no_letter_b
  no_letter_b:
    type: line
    speaker: npc.bertha
    text: "And he died of poison, not drink, before you ask. Frothing like a lily-pond. I'm going home. To bed. Forever."
    effects: ["add_clue(clue.courier_foam)"]
    next: hub
  hub:
    type: choice
    options:
      - id: truth
        text: "He died in my arms. He gave me this for the Marshal."
        next: truth
      - id: seal
        text: "He wore the Crown's courier seal. Here. [Item: Courier's seal]"
        tag: item
        condition: "has_item(item.courier_seal)"
        next: seal
      - id: coy
        text: "What's it worth to the Marshal?"
        next: coy
      - id: walk
        text: "I don't talk to soldiers."
        next: walk
  truth:
    type: line
    speaker: npc.sergeant_brask
    text: "Dwarf iron-wax. Gods. He said that name, did he? Ostrel? ...Don't answer that out here."
    next: summons
  seal:
    type: line
    speaker: npc.sergeant_brask
    text: "Tomas. He was green, but he was ours. Thank you for bringing that. Most on Eel Row would have sold it."
    next: truth
  coy:
    type: line
    speaker: npc.sergeant_brask
    text: "Your life, maybe. Men who carry that letter don't live long, as you've seen. The Marshal can keep you breathing. Show me."
    next: truth
  walk:
    type: line
    speaker: npc.sergeant_brask
    text: "Then don't talk. Walk. With me, to the palace, or alone, to wherever those men catch you. Your choice."
    next: truth
  summons:
    type: line
    speaker: npc.sergeant_brask
    text: "The Marshal wants a word. He sits with the Queen's council at first light. He doesn't trust the palace guard or the Chancellery, so he'll trust a sellsword who bled for his courier. Market gate, then the Lion Steps."
    effects: ["set_flag(flag.brask_met)", "set_flag(flag.summoned_by_kosk)", "add_xp(25)"]
    next: end_card
  end_card:
    type: effect
    effects: ["play_beat(slice_end_card)"]
    next: bye
  bye:
    type: end
```

## 6. Encounters

All thug encounters in the tavern share the checkpoint `before_thugs` and Bertha as a scripted ally (one bottle throw, beat `bertha_bottle`). Fighting is optional; fleeing at any time through the trapdoor leaves the encounter by an exit (`on_player_fled`).

| Encounter | Enemies | When |
|---|---|---|
| `enc.rat_thugs` | Cobb + 2 thugs | No talk reduction |
| `enc.rat_thugs_two` | Cobb + 1 thug | One of Intimidate 6 / clue-persuade / Bribe 30 |
| `enc.rat_thugs_one` | Cobb alone | Both a scare and the bribe |
| `enc.mudflats_crossbow` | 1 crossbowman on the quay | Always on the flee path; cannot be reached, only shot (2 bolts) or avoided |
| `enc.mudflats_thugs` / `enc.mudflats_thug` | the thugs left in the tavern (max 2) | Land at the Margery unless the ladder is cut |

```yaml encounter
id: enc.rat_thugs
zone: zone.drowned_rat
enemies:
  - {enemy: enemy.choir_thug, count: 1, spawn: thug_door, variant: leader}
  - {enemy: enemy.choir_thug, count: 2, spawn: thug_door, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: [npc.bertha]
checkpoint: before_thugs
avoidable_by: ["dlg.rat_thugs_standoff"]
on_won: ["reach_milestone(ms.a1_rat_survived)", "add_rep(faction.choir, -30)", "set_flag(flag.rat_fought)", "play_beat(thugs_down)"]
on_yielded: ["reach_milestone(ms.a1_rat_survived)", "add_rep(faction.choir, -30)", "set_flag(flag.rat_fought)", "start_dialogue(dlg.rat_thug_yield)"]
on_player_fled: ["set_flag(flag.rat_fled)"]
```

```yaml encounter
id: enc.rat_thugs_two
zone: zone.drowned_rat
enemies:
  - {enemy: enemy.choir_thug, count: 1, spawn: thug_door, variant: leader}
  - {enemy: enemy.choir_thug, count: 1, spawn: thug_door, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: [npc.bertha]
checkpoint: before_thugs
avoidable_by: ["dlg.rat_thugs_standoff"]
on_won: ["reach_milestone(ms.a1_rat_survived)", "add_rep(faction.choir, -30)", "set_flag(flag.rat_fought)", "play_beat(thugs_down)"]
on_yielded: ["reach_milestone(ms.a1_rat_survived)", "add_rep(faction.choir, -30)", "set_flag(flag.rat_fought)", "start_dialogue(dlg.rat_thug_yield)"]
on_player_fled: ["set_flag(flag.rat_fled)"]
```

```yaml encounter
id: enc.rat_thugs_one
zone: zone.drowned_rat
enemies:
  - {enemy: enemy.choir_thug, count: 1, spawn: thug_door, variant: leader}
waves: []
attack_tokens: null
allow_yield: true
allies: [npc.bertha]
checkpoint: before_thugs
avoidable_by: ["dlg.rat_thugs_standoff"]
on_won: ["reach_milestone(ms.a1_rat_survived)", "add_rep(faction.choir, -30)", "set_flag(flag.rat_fought)", "play_beat(thugs_down)"]
on_yielded: ["reach_milestone(ms.a1_rat_survived)", "add_rep(faction.choir, -30)", "set_flag(flag.rat_fought)", "start_dialogue(dlg.rat_thug_yield)"]
on_player_fled: ["set_flag(flag.rat_fled)"]
```

The `leader` variant of `enemy.choir_thug` is Cobb: same stat block, a voice set, and the scripted barks above. If Cobb yields, the yield dialogue uses his voice.

```yaml encounter
id: enc.mudflats_crossbow
zone: zone.cintra_mudflats
enemies:
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: quay_lantern, variant: quay_walker}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: cp_mud_start
avoidable_by: []
on_won: ["play_beat(crossbowman_falls)"]
on_yielded: []
on_player_fled: []
```

`quay_walker` variant: the crossbowman's movement is confined to the quay edge path above the pilings maze and the Margery; he matches the player's x-position with a lag of 2 s, fires at most once per 3 s, and only with clear line of sight. He stops at the weirs (fog). He cannot be reached in melee.

```yaml encounter
id: enc.mudflats_thugs
zone: zone.cintra_mudflats
enemies:
  - {enemy: enemy.choir_thug, count: 2, spawn: ladder_foot, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: cp_pilings
avoidable_by: []
on_won: []
on_yielded: ["add_clue(clue.thug_silver)"]
on_player_fled: []
```

```yaml encounter
id: enc.mudflats_thug
zone: zone.cintra_mudflats
enemies:
  - {enemy: enemy.choir_thug, count: 1, spawn: ladder_foot, variant: leader}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: cp_pilings
avoidable_by: []
on_won: []
on_yielded: ["add_clue(clue.thug_silver)"]
on_player_fled: []
```

The thugs in the mud are slowed like the player (−40% in deep mud). Fighting in the hull mouth is a deliberate "fight in bad footing" lesson. Outrunning them to the sluice is allowed.

## 7. Items and clues

Starting gear (gdd §6.9) is declared here because the new game spawns into this section: `item.arming_sword`, `item.gambeson`, `item.crossbow`, 8 × `item.crossbow_bolt`, 2 × `item.poultice`, 30 crowns.

```yaml item
id: item.dravin_letter
name: "Dravin's iron-wax dispatch"
category: key
description: "A folded sheet of heavy rag paper sealed with dark dwarven iron-wax, the seal stamped with a hammer over a closed door. Addressed to the Lord Marshal."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "To the Lord Marshal of Cintra, by the Queen's road. The lower bolts in Ostrel are grinding loose. Something old is waking in the dark. Come before the winter lock fails. - Dravin Ostrel, at Assengard, last of the gate-wardens."
```

```yaml item
id: item.courier_seal
name: "Royal courier's seal"
category: document
description: "A brass disc on a cord, struck with the lion and a running horse. Proof that its bearer rode the Crown's post."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Southern Post. Rider T. Wyle. By the Queen's leave, let him pass."
```

```yaml item
id: item.arming_sword
name: "Arming sword"
category: weapon
description: "A plain, honest sellsword's blade. Nicked, oiled, paid for."
price: 40
stack_max: 1
equip_slot: main_hand
weapon: {base: 12, type: slash, block_pct: 0.7, armor_pen: 0, bonus_vs: {}, moveset: sword}
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.gambeson
name: "Quilted gambeson"
category: armor
description: "Padded linen, stained at the armpits and sword-side. Better than skin."
price: 30
stack_max: 1
equip_slot: armor
weapon: null
armor: {armor: 10, resist: {}}
consumable: null
readable_text: null
```

```yaml item
id: item.crossbow
name: "Hunting crossbow"
category: weapon
description: "A light goat's-foot crossbow. One bolt at a time, and make it count."
price: 50
stack_max: 1
equip_slot: ranged
weapon: {base: 22, type: pierce, block_pct: 0.0, armor_pen: 0, bonus_vs: {}, moveset: crossbow}
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.crossbow_bolt
name: "Crossbow bolt"
category: ammo
description: "Iron-headed bolt with goose fletching."
price: 1
stack_max: 20
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.poultice
name: "Poultice"
category: consumable
description: "Yarrow, honey and moss in a linen wrap. Press it to the wound and grit your teeth."
price: 8
stack_max: 10
equip_slot: null
weapon: null
armor: null
consumable: {effects: ["heal_player(40)"], use_time: 1.0}
readable_text: null
```

```yaml clue
id: clue.courier_foam
theory: theory.poisoner
title: "Froth at the courier's mouth"
text: "Grey-green froth, pinpoint pupils, a sweet smell like crushed lilies. Not drink: a slow poison that took hours. The courier shared a cup with a 'kind monk' on the road."
supports: []
refutes: []
```

```yaml clue
id: clue.thug_silver
theory: theory.choir
title: "Paid in new silver and vellum"
text: "The Drowned Rat thugs were paid in new-clipped silver wrapped in strips of vellum by a soft-handed man in a grey hood, who waited on the quay and bowed his head when the Abbey bells rang."
supports: []
refutes: []
```

```yaml clue
id: clue.ostrel_bolts
theory: theory.anselm_plan
title: "The lower bolts are grinding loose"
text: "Dravin Ostrel, a dwarf at Assengard, warned the Lord Marshal that the bolts under Karak Ostrel are failing and 'something old is waking'. Someone killed to stop that letter arriving."
supports: []
refutes: []
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: flag.bertha_bottle_thrown, type: bool, desc: "Bertha has thrown her one bottle in the taproom fight (beat bertha_bottle)."}
  - {id: flag.courier_entered, type: bool, desc: "The courier has stumbled into the Drowned Rat (beat courier_stumbles_in)."}
  - {id: flag.courier_dead, type: bool, desc: "The courier has died (beat courier_dies or courier_dies_alone)."}
  - {id: flag.letter_taken, type: bool, desc: "The player holds Dravin's letter (from the body or from Bertha)."}
  - {id: flag.letter_read, type: bool, desc: "The player broke the iron-wax and read the letter in the tavern."}
  - {id: flag.thugs_arrived, type: bool, desc: "The Choir thugs kicked in the Drowned Rat's door."}
  - {id: var.rat_thugs_left, type: int, min: 0, max: 3, desc: "Thugs still in the fight after talk (3, 2 or 1). Read by the mudflats pursuit."}
  - {id: flag.rat_thug_scared, type: bool, desc: "One thug fled from Intimidate or the poison argument."}
  - {id: flag.rat_thug_bribed, type: bool, desc: "One thug took 30 crowns and walked."}
  - {id: flag.rat_fought, type: bool, desc: "The player won the tavern fight (or ended it by a yield)."}
  - {id: flag.rat_fled, type: bool, desc: "The player fled through the cellar onto the mudflats."}
  - {id: flag.rat_thug_spared, type: bool, desc: "The player spared a yielding thug."}
  - {id: flag.rat_thug_executed, type: bool, desc: "The player killed a yielding thug in front of Bertha."}
  - {id: flag.bertha_thanked, type: bool, desc: "Bertha's after-fight conversation has played."}
  - {id: flag.bertha_tended, type: bool, desc: "Bertha patched the player up (full heal, once)."}
  - {id: flag.tab_paid, type: bool, desc: "The player paid Bertha's 3-crown tab before the trouble (flavor; A07 may read it)."}
  - {id: flag.thugs_on_ladder, type: bool, desc: "Pursuing thugs are climbing down the Margery's ladder."}
  - {id: flag.ladder_cut, type: bool, desc: "The player cut the Margery's ladder; the pursuers are stuck in the mud."}
  - {id: flag.thugs_landed, type: bool, desc: "Pursuing thugs reached the mud and engaged."}
  - {id: flag.wick_helped, type: bool, desc: "Wick showed the safe path along the weir tops."}
  - {id: flag.bertha_at_docks, type: bool, desc: "Bertha brought the forgotten letter to the docks."}
  - {id: flag.brask_met, type: bool, desc: "Sergeant Brask has met the player on the docks."}
  - {id: flag.summoned_by_kosk, type: bool, desc: "Brask summoned the player to the palace; opens the palace gate in zone.cintra_streets."}
  - {id: ms.a1_rat_survived, type: milestone, xp: 150, desc: "The player survived the Drowned Rat (fight, talk-down, or flight)."}
reads:
  - flag.bertha_safehouse
  - ms.a1_audience_done
```

## 9. Quest hooks

```yaml quest_stages
quest: quest.main_a1
order: 10
stages:
  - id: survive_the_rat
    journal: "A royal courier died in my arms at the Drowned Rat, poisoned, with a dwarf-sealed letter from one Dravin Ostrel. His last word was 'Ostrel'. Someone sent men to take that letter back."
    objectives:
      - {id: get_letter, text: "Keep the courier's letter", condition: "has_item(item.dravin_letter)", optional: false}
      - {id: survive, text: "Survive the men at the door", condition: "ms(ms.a1_rat_survived)", optional: false}
      - {id: meet_brask, text: "Find the Lord Marshal's patrol on the docks", condition: "flag(flag.brask_met)", optional: false}
      - {id: learn_poison, text: "Learn what killed the courier", condition: "has_clue(clue.courier_foam)", optional: true, xp: 20}
    on_complete: []
    next: []
```

## 10. Rumors and event cards (optional)

None defined here. Bertha's `rumors` option runs `draw_rumor(npc.bertha)` (content-format §J.2) on the pool authored by A07 (`docs/content/side/14-rumors.md`). Bertha is a rumor source for the Cintra pool.

## 11. Failure states and branches

```yaml branches
paths:
  - id: fight
    when: "Player chooses 'Come and take it' (or fails every talk option) and wins the taproom fight."
    outcome: "ms.a1_rat_survived via on_won; Bertha's after-fight talk (heal, poultice); front door to the docks; Brask's summons."
    sets: ["reach_milestone(ms.a1_rat_survived)", "set_flag(flag.rat_fought)"]
  - id: talk_down_then_fight
    when: "Player passes Intimidate 6 (or the poison clue Persuade 4) and/or pays Bribe 30, then fights Cobb with one or no helper."
    outcome: "Smaller fight (enc.rat_thugs_two or enc.rat_thugs_one). Same outcome as fight."
    sets: ["reach_milestone(ms.a1_rat_survived)"]
  - id: yield
    when: "The last thug standing yields at 20% HP."
    outcome: "Yield dialogue: question him (clue.thug_silver), take his purse, spare him or execute him. Milestone via on_yielded."
    sets: ["reach_milestone(ms.a1_rat_survived)"]
  - id: flee
    when: "Player takes the cellar trapdoor and the tide hatch at any point after the thugs arrive."
    outcome: "Mudflats chase: crossbowman on the quay, the Margery ladder (cut it or fight the remaining thugs in the mud), Wick's safe path, sluice steps. Milestone on arrival at the Fishmarket."
    sets: ["set_flag(flag.rat_fled)", "reach_milestone(ms.a1_rat_survived)"]
  - id: letter_unread
    when: "Player pockets the letter unread."
    outcome: "No ambush until the player touches the front door. Same branches afterwards. The letter can be read later from the inventory (no clue.ostrel_bolts until read in the tavern; Brask's line covers the content)."
    sets: []
failures:
  - id: player_dies_tavern
    result: reload_checkpoint
    recover: "Reload before_thugs (set when the courier dies): the body search and the standoff replay."
  - id: player_dies_mudflats
    result: reload_checkpoint
    recover: "Reload the last mudflats checkpoint (cp_mud_start, cp_pilings, cp_wreck, cp_weirs). The tide resets with the checkpoint."
  - id: caught_by_tide
    result: reload_checkpoint
    recover: "Tide damage kills like any other damage; reload the last checkpoint."
  - id: letter_left_behind
    result: soft_fail
    recover: "Player left without searching the body (door touched first, or fled). Bertha brings the letter to the docks in dlg.brask_docks (node no_letter) and tells the poison clue."
  - id: no_money_for_bribe
    result: soft_fail
    recover: "Bribe options are hidden without the crowns. Intimidate, the clue, the fight and the flight remain."
guarantees:
  - "ms.a1_rat_survived is reachable without any check: choose 'Come and take it' and win, or choose 'Bertha, the cellar!' and run the mudflats to the sluice (no check on that route)."
  - "item.dravin_letter always reaches the player before the section ends: the body search (no check) or Bertha at the docks (no check)."
  - "flag.summoned_by_kosk is always set by dlg.brask_docks, which has no checks on its main path and fires on entering the crane quay or Eel Row."
```

## 12. Open questions

1. **Tutorial prompt triggers (resolved by A08).** `"on": combat_event` triggers in `zone.drowned_rat` play the `tut_*` beats (content-format §J.3).
2. **`bertha_bottle` (resolved by A08).** Two `combat_event` triggers (`enemy_enters_area` at the bar, `player_hp_below` 40) play it once, guarded by `flag.bertha_bottle_thrown`.
3. **Hazard parameters (resolved by A08).** Each tide hazard turns on at its checkpoint (`enabled_by: {"on": checkpoint, ...}`, §J.3). The remaining `params` are physical tuning for the zone-scene implementer.
4. **Milestone XP (resolved by A08).** Main-milestone XP now sits on the milestone declaration (`xp`, §J.7).
5. **`on_yielded` semantics.** I assume it fires once, when the encounter ends with at least one enemy having yielded (and the rest down). If yield can happen mid-fight while others still fight, the yield dialogue should wait until the encounter ends.
6. **Bertha's debt hook (resolved by A08).** `troubles` chains into A07's `dlg.bertha_debt_plea`.
7. **Rumor source (resolved by A08).** `draw_rumor(npc.bertha)`.
