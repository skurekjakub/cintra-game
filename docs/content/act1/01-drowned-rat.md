---
section_id: a1.01
title: "The Drowned Rat"
act: 1
story_ref: "story.md §1 The Hook, §5.1, §10 (The Drowned Rat); gdd.md §5, §6.19, §7.1 #1, §8.1 (vertical slice); story-witcher.md §5"
zones: [zone.drowned_rat, zone.cintra_mudflats, zone.cintra_docks]
available_when: "true"
escalation_stage_required: {min: 0, max: 0}
milestones_set: [ms.a1_rat_survived]
milestones_read: [ms.a1_rat_survived, ms.a1_audience_done]
level_band: [1, 2]
---

# The Drowned Rat

**This is the vertical slice.** Everything in this file is built first, end to end, and it must be completable both by fighting and by fleeing (gdd §8.1). It is also the reference implementation of the witcher stigma system (gdd §6.19, content-format §K). Each construct appears here at least once.

## 1. Scene summary

It is late September, a little before midnight. Hale, a witcher of the Matron, sits in the corner snug of the Drowned Rat, a dockside tavern on pilings at the end of Eel Row, with his hood up and three ales on a slate he cannot pay. The eel-men's guild hired him to clear drowners out of the pilots' channel, and then refused to pay a witcher. The Abbey bells across the river ring unbidden. His medallion trembles at something over the bar: another witcher's medallion, nailed above the bottles like a lucky charm. Then **Bertha Kell** comes to settle the slate, makes him look up, sees his eyes, and charges him double for the ales in a chipped clay cup that hangs on its own nail. The drinkers carry their mugs to the far tables.

A royal courier staggers in foaming grey-green, and the whole room backs away from him. Only the witcher kneels. The courier dies in his arms with a dwarf-sealed letter and one word, *"Ostrel"*, and the room decides on the spot that the witcher killed him. Gorm Tatch, the guild-master who kept his pay, sends his nephew running for the Chancellery watch. Hale can answer the room with the dead man's boots, with the poison's name (which makes things worse), with a threat, or with Bertha, if he has given her a reason to speak.

Then three hired Choir thugs kick in the door for the letter, and their leader turns the frightened room into a weapon: *"The witcher's done our cousin. Help us take the thing."* Hale can fight in the taproom, while some regulars join the thugs if the room is hot enough. He can shrink the fight with threats, with his eyes, with a sign, with the poison clue or with silver. Or he can run: Bertha opens the trapdoor and bolts the tide hatch behind him, because she will not watch Eel Row do it twice. The flight crosses the mudflats under the city wall, past the black stake where Eel Row drowned the last witcher seventeen years ago. On the docks, Sergeant Brask of the Marshal's patrol recognises him from the ditch at Marnadal. If the watch has come, she sends it away: "The Marshal wants a word. And put your hood up. You'll start a riot."

**The dramatic question:** *will you keep the letter, and your neck, in a room that has already decided what you are?* The section ends with the summons to the palace (the slice end card).

## 2. Progress and escalation

- **Escalation:** stage 0 only (Equinox). The Abbey bells ringing at midnight are the stage-0 world effect from gdd §6.1, staged here as the opening beat `bells_unbidden`.
- **The milestone** `ms.a1_rat_survived` is reached in exactly one of two places, whichever comes first:
  1. the `on_won` or `on_yielded` of the `enc.rat_thugs*` encounters (the fight path, including a fight that was talked down);
  2. the docks trigger `t_arrive_survived` on reaching the Fishmarket (the flee path). It is guarded by `not ms(...)`, so the reputation change below is applied only once.
- **Reputation:** with the milestone, `faction.choir` −30 (from −30 to −60, gdd §6.12). Choir reputation is always Hostile; this only weights later events.
- **Variant `after_rat`** (all three zones) applies once `ms.a1_rat_survived` is set: tables righted, sand thrown over the blood, the courier's body gone (once the letter is taken), and Bertha's later conversation.
- This section starts `quest.main_a1` (trigger `t_start`).

### Stigma in this section (gdd §6.19)

| Value | At start | What moves it here |
|---|---|---|
| `infamy()` | 30 (`shunned`) | `blame.courier_murder` +15. Fleeing +5. Glaring the room down +2. `[Hush]` +2. Executing a yielded thug +5. Sparing one −2. Gorm's debt: +1 if squeezed, −1 if forgiven. Regulars fleeing a mob +5. A killed townsman +10 (auto). Typical exit: 45–52 |
| `heat()` in `zone.drowned_rat` | 10 (the `shunned` floor, and the zone floor) | Eyes seen at the slate +15 (25: the drinkers move away). The courier dies in his arms +25 (50). Naming the poison +10. Cobb's frame +15. Any sign +25 (auto). The boots −15, calming the room −25, glaring −15, Bertha speaking −30, the foam argument −20, winning the fight −20 |
| Regard | Bertha `wary`, Gorm `bigot`, Murrow `bigot` (and `hushable`), Cobb `pragmatic`, Fenn `wary`, Wick `kindred`, Brask `pragmatic`, Voss `bigot` | Bertha becomes `kindred` if she speaks up for him (`dlg.rat_accused`) |
| Blame | none | `blame.courier_murder` is added when the courier dies, in his arms or alone. It is cleared later, in a1.08 or a1.03 (gdd §6.19.7) |

**Heat ≥ 75 when the fight starts** (and the room was neither calmed nor fled): Gorm and a drover join the thugs as `enemy.townsfolk` (encounter `variants`). They flee at 70% HP. Killing one is a civilian kill (+10 infamy, Crown −5, auto).

A default path, with the tab paid, no poison named and no calming, reaches 10 → 25 → 50 → 65 at the fight: no regulars join. Naming the poison (75) or one sign brings them in. Hiding in the snug with the hood up drains 2 heat per second.

### Tutorial beats woven into the fiction

| Tutorial | Where | Fiction |
|---|---|---|
| Medallion | `snug`, beat `tut_medallion` (trigger `t_medallion_bar`) | His medallion trembles at something over the bar: a dead witcher's medallion |
| Dialogue: choices, a check tag, stigma, a safe exit | `dlg.bertha_tab` | Bertha's slate. Persuade is hard and Intimidate easy, because she fears him. Paying the double price without a fight is the decent thing, and she notices |
| Hood (H / radial) | beat `tut_hood`, end of `dlg.bertha_tab` | "Hood up: strangers mutter less. Anyone who has seen your eyes is not fooled." |
| Move (WASD / left stick), camera | `snug`, beat `wake_in_snug` | After the slate, the room is watching him. Walk |
| Interact (E / A) | `taproom`, the collapsed courier | Kneel by the man nobody else will touch |
| Heat and accusation | `dlg.rat_accused` | The room turns. The Accusations tab opens with its first entry |
| Read a document, journal, clue board | `dlg.letter_read`, `clue.courier_foam` | Break the iron-wax. The door on the seal is the door on his medallion |
| Light / heavy attack | `enc.rat_thugs`, beat `tut_attack` | The first thug swings a cosh |
| Block / parry | beat `tut_block` | Cobb's two-hit combo has a loud wind-up |
| Dodge | beat `tut_dodge` | A thug kicks a bench at you |
| Kick | beat `tut_kick` | Murrow raises a barrel-lid shield and blocks |
| Sign (Knock) | beat `tut_sign` | A thug at half health: "Knock throws a man back. The hearth is behind them. The room will call it witchcraft." |
| Swap sword | beat `silver_bark` (played by the scene) | Drawing silver on men: "Silver's for monsters. These are only men." |
| Yield / spare | beat `tut_yield` | The first thug under 20% drops his cosh and begs |
| Quick item (poultice or Marrow elixir) | beat `tut_quick_item` | The first time HP < 50%: Bertha shouts "Drink something, you fool!" |
| Sprint, deep mud, mash to escape | `zone.cintra_mudflats`, beats `tut_sprint`, `tut_mud` | Fleeing under the pilings |
| Crossbow aim / fire | beat `tut_crossbow` | The lantern-man on the quay. Shoot back, or keep to cover |

The `tut_*` beats are UI prompts. The combat ones are fired by `"on": combat_event` triggers in `zone.drowned_rat` (content-format §J.3): the first enemy wind-up, the first enemy block, an enemy below 50% HP, the first yield, and the player below 50% HP. `tut_dodge` and `silver_bark` are played by the scene, when a thug first kicks a bench and when silver is first drawn on a human.

## 3. Location layout

### 3.1 The Drowned Rat (`zone.drowned_rat`)

A two-storey tarred timber tavern on oak pilings at the dead end of Eel Row. The south (street) half stands on the quay. The north half hangs over the mudflats, so the floor creaks and the cellar smells of the tide. The ground floor is about 18 m east–west by 12 m north–south. Low beams at 2.4 m (no jumping attacks; heavy swings can catch a beam, which is presentation only). It is lit by the hearth and tallow candles: dim, warm and smoky.

The tavern is named for Bertha's husband, Jan Kell, a river pilot everyone called the Rat, who drowned in the pilots' channel in 1251. She repainted the sign the day she buried him.

```
 N  (over the mudflats)
 +-----------+------------------------+---------+
 | SCULLERY  |   B A R  (counter)  [T]|  stairs |   [T] = cellar trapdoor behind the bar's west end
 | pantry    |====M===c===============|  to     |   M = Corrick's medallion on a nail, c = the witcher's cup on its nail
 +----+------+                        |  rooms  |
 |    |  (back_door to yard, NW)      +---------+
 |    |   o table      o table (Fenn) |  HEARTH |   o = round table, == = long trestle
 |SNUG|   == trestle   == trestle     |  (E)    |   P = oak support post (full cover)
 | *  |        P            P         |         |   * = player start
 |    |   == trestle (Gorm, the regulars) ==    |         |
 +----+-------------[FRONT DOOR]------+---------+
 S  (Eel Row quay -> zone.cintra_docks)
```

- **snug** (SW corner, 4 × 4 m): a high-backed settle and a scarred table. A shuttered window onto the quay (barred, not an exit). The player starts here, hood up, with two swords leaning on the settle: a tell for anyone who looks. Three empty mugs.
- **taproom** (centre, 10 × 8 m): two round tables and four long trestles. Benches are **low cover** (knee height). Two oak **support posts** are **full cover** and break line of sight. Eight regulars (generic onlookers) drink here, and Gorm Tatch holds the south trestle. Old Fenn sleeps face-down at the north round table. The courier collapses on the hearthstones at the east end.
- **hearth** (east wall, part of `taproom`): an open fire 2 m wide. The `hearth_fire` hazard reaches 1.5 m (Burning on contact). A thug knocked into it, by a Knock or a kick, takes fire damage. An iron poker leans on the jamb (a flavor pickup with no stats).
- **bar** (north side, a 9 m counter at waist height): **half cover**. Bertha's station. Shelves of bottles behind it, the source of her one thrown bottle. **Above the bottles, on a nail: a black-iron medallion** with a closed door and an open eye (Corrick's). The regulars think it keeps the rats off. Beside it, on its own nail, hangs **the witcher's cup**: a chipped clay cup. The **cellar trapdoor** is in the floor behind the counter's west end.
- **stairs** (NE): to the upper rooms. Blocked in the slice by a snoring drover on the landing. In the full game this is the stairs exit to `zone.drowned_rat_loft`, once `flag.bertha_safehouse` is set (side 01).
- **scullery** (NW, 4 × 4 m): a cramped kitchen and pantry shelf (loot). A small window, too narrow to climb. The **back door** to the yard (`zone.drowned_rat_yard`, side 01) is here, barred and unusable in this section (Bertha: "That's bolted, and it stays bolted.").
- **cellar** (under the bar, 12 × 6 m, ceiling 1.9 m, ankle-deep tide water): ale casks, a rack of smuggled brandy, rats. A wooden ladder down from the trapdoor. At the north end is the **tide hatch**, a heavy timber door in the outer wall that opens onto a ledge under the pilings, where Bertha rolls in casks off the flats at low water. It is the exit to the mudflats, and the hatch she watched from in 1251.

**Sight lines and intended route.** From the snug the player sees the whole taproom, the front door to the right and the bar ahead, with the medallion glinting over the bottles. Bertha comes to him for the slate. The courier enters by the front door and staggers diagonally to the hearth, drawing the player across a room that parts for him. After the thugs enter by the front door, the bar and the trapdoor are directly behind the player: fight forward or run back. Bertha opens the trapdoor the moment the fight starts, so the flee option is always visible.

**The crowd.** The taproom and the bar are onlooker areas (`crowd`). The regulars are generic: they stare, mutter, move tables at heat 25, throw a mug at heat 75, and run out of the door screaming "witchcraft" at 100 (`t_mob`).

### 3.2 The Mudflats (`zone.cintra_mudflats`)

The tidal flats of the Yaruga mouth below Cintra's dock wall, at night, in river fog, with the city lights smeared above. A linear escape route about 150 m long runs west to east along the foot of the quay wall, which stands 5 m above the mud. It has four segments separated by checkpoints. **Behind each checkpoint the tide floods the segment you left**, so there is no backtracking, and the water creeps after you.

```
 W                                                                                  E
 [hatch_landing]--A--(cp_mud_start)--B: PILINGS MAZE--(cp_pilings)--C: THE MARGERY--(cp_wreck)--D: EEL WEIRS (the stake)--(cp_weirs)--E: SLUICE STEPS -> docks
                                        ^ quay above: crossbowman with lantern walks east along the edge
```

- **A. hatch_landing** (8 m): a slimy timber ledge under the Rat's pilings and a short ladder down. Bertha slams and bolts the hatch behind him (beat `bertha_bolts_hatch` or `bertha_bolts_hatch_cold`), so the thugs must run round by the quay. Firm mud. Checkpoint `cp_mud_start`. Prompt `tut_sprint`.
- **B. pilings_maze** (40 m): a forest of tarred pilings under the Eel Row warehouses, 1–2 m apart. Every piling is **full cover** against the quay. Shallow mud (normal speed) with three marked **deep-mud pockets** (bubbling, darker; the `deep_mud` hazard) and one root pocket on the obvious straight line (prompt `tut_mud`). Above, on the quay edge, **the lantern-man** (`enemy.choir_crossbowman`) walks east, matching the player's pace and shooting through the gaps. His lantern is the tell: where the light points is where he aims. Broken crab pots and a fallen spar are low cover. The segment ends at an upturned skiff: checkpoint `cp_pilings`. Prompt `tut_crossbow` the first time he is in clear view.
- **C. the_margery** (30 m): the gutted hull of the fishing cog *Margery*, beached on her side long ago. The hull is a dark tunnel (full cover from the quay, no crossbow fire inside). Her bow points at the quay, where a **rope ladder** hangs from a mooring ring. As the player enters, the crossbowman shouts "Down the Margery's ladder, cut the cat-eye off!" (beat `thugs_on_ladder`), and the pursuing thugs climb down. The player has a few seconds to reach the foot of the ladder and **cut it** (interactable `rope_ladder`). Then the thugs drop 4 m into deep mud and are out of the chase (beat `thugs_stuck`). Otherwise they land and fight in the mouth of the hull. Checkpoint `cp_wreck` at the stern.
- **D. eel_weirs** (45 m): V-shaped wicker eel-fences across the flats, with **deep mud** between them and a knee-deep tide channel (the `tide` hazard is strongest here). The quickest line is through the mud. The safe line runs along the tops of the weir posts, which only a local knows. Wick, a mudlark girl sitting on a weir post with a sack of scavenged nails, will show it (`dlg.wick_weirs`). In the channel stands **the witcher's stake**: a black, notched post where Eel Row drowned Corrick of the Matron at low water in 1251 (interactable `witchers_stake`). The crossbowman's view is blocked by fog here; he only shouts. Checkpoint `cp_weirs`.
- **E. sluice_steps** (10 m): the stone stair and rusted grate of the Fishmarket sluice. The grate stands open (the fishwives prop it for the eel-men). Climb up to the docks: the exit to `zone.cintra_docks` at `sluice_top`.

### 3.3 The Docks (`zone.cintra_docks`)

Eel Row quay and the Fishmarket at night. A cobbled quay 12 m wide between the warehouses and the water, moored cogs creaking, a timber crane, stacked eel-barrels (cover), and a watch post with a brazier. The Drowned Rat's front door is at the west end of Eel Row. The Fishmarket sluice stair comes up at the east end. The **market gate** to the city streets is on the north side, beside the watch post. Sergeant Brask and two of Kosk's men wait under the crane with a lantern. If thugs or the crossbowman are still after the player, they see the Marshal's colors and scatter into the alleys (beat `thugs_scatter`). If Tam Tatch fetched the watch, Corporal Voss and two Chancellery watchmen come through the market gate as Brask starts talking. At night the quay has no crowd. By day (after the audience) it is packed, and it gets a `crowd`.

```yaml zone
id: zone.drowned_rat
name: "The Drowned Rat"
kind: interior
map_node: map.cintra
time_of_day: night
cold_rate: 0
disguise_tag: null
music: tavern_tense
crowd:
  heat_floor: 10
  onlookers: [taproom, bar]
  guards: null
  mob_encounter: null
areas:
  - {id: snug, description: "SW corner booth, 4 x 4 m. High-backed settle, scarred table, three empty mugs, two swords leaning on the settle. Barred shutter onto the quay. Player start."}
  - {id: taproom, description: "Centre, 10 x 8 m. Two round tables, four trestles (benches = low cover), two oak posts (full cover). Eight regulars; Gorm Tatch at the south trestle. Hearth on the east wall with an iron poker. Front door on the south wall."}
  - {id: bar, description: "North counter, 9 m, waist high (half cover). Bottle shelves behind; above them a black-iron medallion on a nail, and a chipped clay cup on its own nail. Cellar trapdoor in the floor at the counter's west end."}
  - {id: stairs, description: "NE staircase to the rooms. Blocked by a snoring drover in this section; safehouse loft later (side 01)."}
  - {id: scullery, description: "NW kitchen, 4 x 4 m. Pantry shelf. Narrow window. Barred back door to the yard."}
  - {id: cellar, description: "Under the bar, 12 x 6 m, ceiling 1.9 m, ankle-deep tide water. Casks, smuggled brandy, rats. Tide hatch in the north wall onto the mudflats."}
spawns:
  - {id: snug, area: snug, default: true}
  - {id: front_door, area: taproom, default: false}
  - {id: cellar, area: cellar, default: false}
  - {id: from_yard, area: scullery, default: false}
  - {id: from_loft, area: stairs, default: false}
  - {id: thug_door, area: taproom, default: false}
  - {id: regulars_table, area: taproom, default: false}
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
    label: "Open the dispatch case"
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
  - id: bar_medallion
    area: bar
    kind: readable
    label: "The charm over the bottles"
    condition: "not flag(flag.medallion_story)"
    check: null
    once: false
    magic: {range_m: 12}
    effects: ["set_flag(flag.medallion_noticed)", "play_beat(medallion_over_bar)"]
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
    effects: ["set_hood(up)", "start_quest(quest.main_a1)", "set_checkpoint(rat_start)", "play_beat(bells_unbidden)", "play_beat(bertha_at_snug)", "start_dialogue(dlg.bertha_tab)"]
  - id: t_medallion_bar
    area: snug
    "on": medallion
    source: bar_medallion
    condition: "not ms(ms.a1_rat_survived)"
    once: true
    effects: ["set_flag(flag.medallion_noticed)", "play_beat(tut_medallion)"]
  - id: t_medallion_seal
    area: taproom
    "on": medallion
    source: npc.courier
    condition: "true"
    once: true
    effects: ["play_beat(medallion_seal)"]
  - id: t_heat_mutters
    area: taproom
    "on": heat
    source: null
    threshold: 25
    condition: "not ms(ms.a1_rat_survived)"
    once: true
    effects: ["play_beat(drinkers_shift)"]
  - id: t_heat_stones
    area: taproom
    "on": heat
    source: null
    threshold: 75
    condition: "not ms(ms.a1_rat_survived)"
    once: true
    effects: ["play_beat(room_turns_ugly)"]
  - id: t_mob
    area: taproom
    "on": mob
    source: null
    condition: "not flag(flag.regulars_fled)"
    once: true
    effects: ["set_flag(flag.regulars_fled)", "play_beat(regulars_flee)", "add_infamy(5)", "set_heat(10)"]
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
    effects: ["set_flag(flag.courier_dead)", "play_beat(courier_dies_alone)", "add_blame(blame.courier_murder)", "add_heat(20)", "set_flag(flag.watch_fetched)"]
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
  - id: t_tut_sign
    area: taproom
    "on": combat_event
    source: enemy_hp_below
    threshold: 50
    condition: "true"
    once: true
    effects: ["play_beat(tut_sign)"]
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
  - {id: tut_medallion, description: "The medallion at Hale's throat trembles against his collarbone (HUD shiver icon, controller rumble). Prompt: 'Your medallion senses magic nearby: rune-iron, the dead, the Pact.' Camera drifts to the glint over the bottles."}
  - {id: bertha_at_snug, description: "Bertha comes out from behind the bar with the slate under her arm and a chipped clay cup hooked on one finger, and plants herself at the snug table. Ginger bun going grey, skewered with a notched tally stick; apron; forearms like a docker's."}
  - {id: tut_hood, description: "Prompt: 'H (or the radial): raise or lower your hood. Hooded, strangers mutter less and judge you less. Anyone who has seen your eyes is not fooled.' The heat meter appears on the HUD for the first time."}
  - {id: wake_in_snug, description: "Movement and camera prompt. Every face in the taproom is turned toward the snug, and turns away when he looks back."}
  - {id: drinkers_shift, description: "Heat 25 (Mutters). Two drinkers at the nearest trestle pick up their mugs and move to the far wall without a word. Barks: 'Don't let it look at you.' 'Burn that cup after.'"}
  - {id: room_turns_ugly, description: "Heat 75 (Stones). Somebody at the back throws a pewter mug; it bangs off the post beside Hale. Nobody admits to it."}
  - {id: regulars_flee, description: "Mob. The regulars break for the door all at once, Gorm shouting 'Witchcraft! Witchcraft at the Rat!' up Eel Row. Only Bertha and the sleeping Fenn stay."}
  - {id: courier_stumbles_in, description: "The front door bangs open. A man in the Crown's blue courier's coat, mud to the thighs, staggers in coughing grey-green froth and pitches onto the hearthstones. 'Plague!' The whole room backs to the walls. Bertha: 'Not on my floor!' Interact prompt over him."}
  - {id: medallion_seal, description: "As Hale kneels, the medallion trembles hard: the dispatch case's seal is dwarven rune-wax. Small HUD shiver; no prompt the second time."}
  - {id: courier_dies, description: "The courier presses the iron-waxed dispatch case into Hale's hands, grips his wrist, whispers 'Ostrel', and dies in his arms. His pupils are pinpricks. Hale is kneeling over a dead man with his hand at the man's throat, which is exactly what the room sees."}
  - {id: courier_dies_alone, description: "As Hale reaches for the door, the courier convulses behind him and goes still on the hearth. Gorm, pointing: 'It looked at him and he dropped! You all saw it look at him!' Tam Tatch slips out past Hale's elbow, running for the watch."}
  - {id: room_accuses, description: "Gorm Tatch on his feet at the south trestle, pointing. Chairs scrape back. The Accusations tab opens with its first entry: 'The royal courier's death.' Heat meter jumps."}
  - {id: bertha_speaks_up, description: "Bertha comes round the bar for the first time all night, wiping her hands, and stands between the witcher and the room. She does not look at him."}
  - {id: foam_closeup, description: "Camera on the courier's lips: grey-green froth, a sweet smell like crushed lilies. The clue pins to the board (first board tutorial)."}
  - {id: foam_shrug, description: "Hale sees froth and nothing more he can name. Bark: 'Sweet. Too sweet.' Bertha can still explain it."}
  - {id: medallion_over_bar, description: "Close-up: a black-iron disc on a nail above the bottles, a closed door with an open eye above it, the same as the one at Hale's throat. Mud still in the grooves of the eye."}
  - {id: letter_read, description: "Hale breaks the dark iron-wax. Full-screen document: Dravin's dispatch, sealed with a hammer over a closed door. On close, boots on the quay outside."}
  - {id: door_kicked, description: "The front door slams inward off one hinge. Three men in tar-stained coats with coshes and a short-sword: Cobb Rennet in front, Dace and Murrow behind. Old Fenn slides under his table."}
  - {id: cobb_turns_room, description: "Cobb turns his back on Hale to speak to the room, palms open, reasonable. A few regulars look at each other. Gorm's hand finds a bottle."}
  - {id: fight_begins, description: "Cobb: 'Have it your way.' Thugs fan out; Old Fenn crawls under a trestle. If regulars are joining, Gorm and a drover come off the south trestle with a bottle and a stool."}
  - {id: bertha_opens_trapdoor, description: "Bertha hauls up the cellar trapdoor behind the bar: 'Cellar's open, if you've the sense to run! Tide hatch at the far end!' The trapdoor gets an exit marker."}
  - {id: bertha_bottle, description: "Once per fight, the first time a thug is within 3 m of the bar or the player falls below 40% HP: Bertha breaks a bottle of rotgut over the nearest thug's head (35 poise damage, 6 blunt) and ducks. Bark: 'And stay down!' She never throws at a regular."}
  - {id: tut_attack, description: "Prompt: light attack, hold for heavy. Fired at fight start."}
  - {id: tut_block, description: "Prompt: block, tap at the last moment to parry. Fired on the first enemy wind-up within 3 m."}
  - {id: tut_dodge, description: "Prompt: dodge. Played by the scene when a thug first kicks a bench or charges."}
  - {id: tut_kick, description: "Prompt: kick breaks a block. Fired the first time an enemy blocks the player's attack."}
  - {id: tut_sign, description: "Prompt: R (or X) casts the selected sign. 'Knock throws a man back. The hearth is behind them.' Small print: 'Any sign in front of a crowd is witchcraft to them (heat +25).'"}
  - {id: silver_bark, description: "Played by the scene the first time silver is drawn on a human: Hale, under his breath, 'Silver's for monsters. These are only men.' Prompt: G (hold Y) swaps swords. Heat ticks up while silver is out."}
  - {id: tut_yield, description: "Prompt: a yielding enemy can be spared or finished. In front of a crowd, both are remembered. Fired the first time a thug yields."}
  - {id: tut_quick_item, description: "Prompt: quick slot item (a poultice, or the Marrow elixir: heals in combat, but your veins go black and people see it). Fired the first time player HP < 50%. Bertha: 'Drink something, you fool!'"}
  - {id: thugs_down, description: "The last thug drops. Silence; the hearth crackles. The regulars stare at the witcher standing in the wreck. Old Fenn: 'Is it over? Is there more ale?'"}
  - {id: read_notices, description: "Notices: 'MEN WANTED for the Marnadal Watch, pay in silver' (faded); 'LOST: one grey goose, answers to Agnes'; a fresh one from St. Corwen's almonry, 'PRAY FOR THE QUEEN. BEWARE THE MOUNTAIN'S BASTARDS.'"}
  - {id: read_tab, description: "Slate behind the bar. 'Witcher: 3 ales (double), 1 pie (cold).' Below, a column of sums with a J beside it, struck through again and again. In the corner, scratched out: 'Eel-men owe the witcher 40?'"}
npcs:
  - {npc: npc.bertha, area: bar, condition: "true"}
  - {npc: npc.gorm_tatch, area: taproom, condition: "not flag(flag.regulars_fled)"}
  - {npc: npc.courier, area: taproom, condition: "flag(flag.courier_entered) and not flag(flag.courier_dead)"}
  - {npc: npc.rat_thug_leader, area: taproom, condition: "flag(flag.thugs_arrived) and not ms(ms.a1_rat_survived)"}
  - {npc: npc.rat_thug_murrow, area: taproom, condition: "flag(flag.thugs_arrived) and not ms(ms.a1_rat_survived) and not flag(flag.rat_thug_scared)"}
  - {npc: npc.old_fenn, area: taproom, condition: "true"}
encounters: [enc.rat_thugs, enc.rat_thugs_two, enc.rat_thugs_one]
loot:
  - {container: pantry_shelf, items: [{item: item.poultice, count: 1}], condition: "true"}
  - {container: brandy_rack, items: [{item: item.poultice, count: 1}], condition: "true"}
variants:
  - id: after_rat
    when: "ms(ms.a1_rat_survived) and flag(flag.letter_taken)"
    description: "Tables overturned and righted, sand thrown over the blood, the courier's body taken away by the Marshal's men. Bertha behind the bar with a cudgel in reach. The front door hangs crooked on new hinges. The witcher's cup is back on its nail."
    npcs_absent: [npc.courier, npc.rat_thug_leader, npc.rat_thug_murrow]
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
  - {id: eel_weirs, description: "45 m. V-shaped wicker eel-fences, deep mud between, a knee-deep tide channel. Safe path along the weir-post tops. A black notched stake in the channel. Fog hides the quay."}
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
  - id: witchers_stake
    area: eel_weirs
    kind: readable
    label: "A black stake in the channel, notched"
    condition: "true"
    check: null
    once: false
    effects: ["play_beat(witchers_stake)"]
triggers:
  - id: t_hatch_bolted
    area: hatch_landing
    "on": enter
    source: null
    condition: "not ms(ms.a1_rat_survived)"
    once: true
    effects: ["set_flag(flag.rat_fled)", "set_checkpoint(cp_mud_start)", "play_beat(tut_sprint)", "add_infamy(5)"]
  - id: t_hatch_warm
    area: hatch_landing
    "on": enter
    source: null
    condition: "not ms(ms.a1_rat_survived) and (flag(flag.bertha_softened) or flag(flag.bertha_spoke_up))"
    once: true
    effects: ["play_beat(bertha_bolts_hatch)"]
  - id: t_hatch_cold
    area: hatch_landing
    "on": enter
    source: null
    condition: "not ms(ms.a1_rat_survived) and not flag(flag.bertha_softened) and not flag(flag.bertha_spoke_up)"
    once: true
    effects: ["play_beat(bertha_bolts_hatch_cold)"]
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
  - {id: bertha_bolts_hatch, description: "Behind Hale the tide hatch slams and the bolt shoots home. Bertha, muffled through the timber: 'Run, love. They'll go round by the quay. I'll not watch it twice.' Fists hammer on wood inside, then boots overhead."}
  - {id: bertha_bolts_hatch_cold, description: "Behind Hale the tide hatch slams and the bolt shoots home. Bertha, muffled through the timber: 'Run, witcher. They'll go round by the quay. I'll not watch it twice.' Fists hammer on wood inside, then boots overhead."}
  - {id: tut_sprint, description: "Prompt: sprint. Mud slows you, but this stretch is firm."}
  - {id: tut_mud, description: "Prompt: deep mud slows you; if you stick, mash Interact or Dodge to pull free. Weir tops are firm."}
  - {id: tut_crossbow, description: "Prompt: hold aim, fire. The lantern-man is 35 HP: two bolts. Or keep a piling between you."}
  - {id: lantern_man_spots, description: "A lantern swings over the quay edge. Voice: 'There! The witcher, under the pilings!' A bolt thunks into the wood beside Hale. The lantern's beam shows where he is aiming."}
  - {id: tide_floods_pilings, description: "Behind Hale, black water pours between the pilings with a hiss. No way back."}
  - {id: thugs_on_ladder, description: "The crossbowman shouts 'Down the Margery's ladder, cut the cat-eye off!' Boots on the rope ladder at the bow, about 4 seconds of climbing. The ladder's mooring rope glints: interact prompt 'Cut the ladder'."}
  - {id: thugs_stuck, description: "Hale slashes the rope. The ladder and the men on it drop 4 m into the mud; one howls about his leg, the other is stuck to the waist and cursing witchers. They are out of the chase."}
  - {id: tide_floods_wreck, description: "The tide pours through the Margery's broken ribs. The hull fills behind Hale."}
  - {id: witchers_stake, description: "A black oak post in the tide channel, iron staple at the top, the wood notched to waist height. Hale's medallion lies still: there is no magic here, only what men did. If Wick has spoken, he knows whose it was."}
  - {id: tide_floods_weirs, description: "The weirs go under. The black stake stands alone in the water. Wick's voice somewhere in the fog: 'Told you!'"}
  - {id: crossbowman_falls, description: "Struck, the lantern-man topples from the quay edge into the mud with his lantern; it hisses out. Darkness under the pilings, which a witcher's eyes do not mind."}
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
    description: "Low tide, no pursuers. The Margery's ladder hangs cut (or whole). Wick is mudlarking; her path stays open. The stake stands in the channel. A quiet way between the Rat and the Fishmarket."
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
crowd: null
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
  - {id: brask_arrives, description: "Sergeant Brask steps out from under the crane with two of Kosk's soldiers and a lantern. She looks at the blood on Hale, then at his hands, then at his eyes, and stays where she is."}
  - {id: voss_arrives, description: "Corporal Voss and two Chancellery watchmen come off the market gate at a jog, halberds up, with Tam Tatch trotting behind them and pointing. Shutters open along Eel Row to watch."}
  - {id: bertha_brings_letter, description: "Bertha comes up Eel Row in her shawl, a cudgel under one arm, and slaps the iron-waxed letter into Hale's palm in front of the whole quay: 'You left this. Don't.'"}
  - {id: slice_end_card, description: "Vertical slice only: end card. 'The Marshal wants a word.' The Accusations tab on screen behind the title, one entry long. 'Thank you for playing', return to menu. In the full game this beat is skipped and the player keeps control."}
npcs:
  - {npc: npc.sergeant_brask, area: crane_quay, condition: "not ms(ms.a1_audience_done)"}
  - {npc: npc.watch_corporal_voss, area: crane_quay, condition: "flag(flag.watch_fetched) and not flag(flag.voss_turned_away)"}
  - {npc: npc.bertha, area: eel_row, condition: "flag(flag.bertha_at_docks)"}
encounters: []
loot: []
variants:
  - id: after_audience
    when: "ms(ms.a1_audience_done)"
    description: "Day or night, the docks are working: fishwives, eel-men, a ballad-seller at the market gate who may be singing about the witcher. Brask's post is manned by an ordinary watchman."
    crowd: {heat_floor: 10, onlookers: [eel_row, crane_quay, fishmarket], guards: null, mob_encounter: null}
    npcs_absent: [npc.sergeant_brask, npc.watch_corporal_voss]
    encounters_disabled: []
    interactables_disabled: []
```

## 4. NPCs present

**Voice notes.**
- **Bertha Kell** (54): broad, red-armed, a ginger bun going grey and skewered with a notched tally stick, because she keeps accounts of everything: ale, debts and sins. Cintran dock vowels. Short sentences. She swears by the river, not the gods. She calls everyone "love", whether she likes them or not. **She does not call the witcher "love".** She calls him "witcher" or "you". The scene is built so the player notices the gap, and notices the moment she closes it. Practical first, kind second, scared underneath, and ashamed of one thing for seventeen years.
- **The courier (Tomas Wyle)**: a young man trying to be brave. He can barely speak, and every line is broken by the poison. He does not know what the letter says. To a delirious man, cat's eyes are an answer, not a threat.
- **Gorm Tatch**: master of the Eel Row eel-men's guild and a net-mender. Loud, red-faced, and never wrong in his own taproom. The voice of the town. He kept the witcher's pay and has been loud all night about it.
- **Cobb Rennet**: a docks bruiser with a pleasant, reasonable voice that makes him worse. He talks like a man doing a job, and he calls people "friend". He is the only man in the room who doesn't care what a witcher is, and the first to use what everyone else thinks.
- **Murrow**: a squat, superstitious thug with a barrel-lid shield. He makes the sign of the lion when he is frightened.
- **Old Fenn**: an ancient eel-man, drunk. Comic relief with one true line.
- **Wick**: a mudlark girl of ten, quick and sly, who says "you" like an accusation and calls him "goat-eyes". She knows every inch of the flats and is afraid of nobody.
- **Sergeant Oda Brask**: in her forties, Kosk's veteran, with a flat voice. She never wastes a word and notices everything. A Marnadal veteran (she limps) who held the ditch line the week the witcher walked it.
- **Corporal Anders Voss**: Chancellery watch. A thin man who wants to be thanked by the Chancellor.

```yaml npc
id: npc.bertha
name: "Bertha Kell"
faction: null
role: "Innkeeper of the Drowned Rat, widow of the river pilot it is named for"
motive: "Keep the Rat standing, keep Jory's collector paid, and keep Eel Row from doing on her floor what it did on the flats seventeen years ago."
secret: "In 1251 she paid a witcher, Corrick of the Matron, to bring her drowned husband up from the drowners. Eel Row said he had fed Jan to them and drowned him at the stake on the flats, and she watched from the tide hatch and said nothing. His medallion hangs over her bottles and his cup on its own nail. She also owes Jory's collectors (the J on her slate) and lands smuggled brandy through the tide hatch."
disposition: neutral
regard: wary
essential: true
dialogue: dlg.bertha
barks: ["Mind the blood on my floor.", "Drink or leave, love.", "Not the good bottles!", "Bolt's on. Breathe.", "Cup's on its nail. Where it lives.", "I keep accounts. All of them."]
combat: null
shop: null
```

```yaml npc
id: npc.gorm_tatch
name: "Gorm Tatch"
faction: null
role: "Master of the Eel Row eel-men's guild; net-mender; the loudest man in the Drowned Rat"
motive: "Keep the forty crowns the guild owes the witcher, and stay the loudest man in any room."
secret: "The guild voted to pay the witcher. Gorm kept the purse. His nephew Tam has no winter coat because Gorm drinks the guild's money."
disposition: hostile
regard: bigot
hushable: false
essential: true
dialogue: dlg.gorm_tatch
barks: ["Burn that cup after.", "Don't let it look at you.", "My gran said they drink babies' breath.", "We never signed with a witcher."]
barks_by_stigma: {shunned: ["Don't let it look at you."], loathed: ["Somebody fetch the watch. Somebody fetch a rope."], hunted: ["There's a price on that! There's a price on it!"]}
combat: enemy.townsfolk
shop: null
```

```yaml npc
id: npc.courier
name: "Tomas Wyle, royal courier"
faction: faction.crown
role: "A royal courier of the Crown's southern post, poisoned on the road"
motive: "Deliver the dispatch to the Lord Marshal. Failing that, to anyone who isn't the men behind him, or afraid of him."
secret: "He shared a cup at a pilgrims' hostel on the King's Road with a kindly monk. He never saw the monk's face again."
disposition: friendly
regard: pragmatic
magic: {range_m: 2}
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
motive: "Get the letter, get paid the second half, and leave no one who can describe him."
secret: "Paid in fresh-clipped silver wrapped in a strip of vellum; told to bring the letter to a man in grey at the Fishmarket steps. Does not know what the Choir is. Does not care what a witcher is, and knows exactly what one is worth to a frightened room."
disposition: hostile
regard: pragmatic
essential: false
dialogue: dlg.rat_thugs_standoff
barks: ["Easy, friend. Nobody has to bleed.", "Take the witcher, I'll take the letter.", "Pin it by the hearth!", "That's coming out of your share, Dace."]
combat: enemy.choir_thug
shop: null
```

```yaml npc
id: npc.rat_thug_murrow
name: "Murrow"
faction: faction.choir
role: "Superstitious docks thug in Cobb's crew, with a barrel-lid shield"
motive: "Six silver for an easy night. Nobody said anything about a witcher."
secret: "His gran swore a cat-eye's look will stop your heart. He half believes it."
disposition: hostile
regard: bigot
hushable: true
essential: false
dialogue: null
barks: ["Don't look at me. Don't look at me!", "Lion keep me.", "Nobody said witcher, Cobb!"]
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
regard: wary
essential: true
dialogue: dlg.old_fenn
barks: ["Bells at midnight. Bad luck, that.", "Is there more ale?", "I'm not here. I'm a table.", "Don't look at it, it'll curdle your ale."]
combat: null
shop: null
```

```yaml npc
id: npc.mudlark_wick
name: "Wick"
faction: null
role: "Mudlark girl who scavenges the flats"
motive: "Nails, coins, and not being caught by anyone holding a lantern."
secret: "Her brother was taken by the press-gangs for the Marnadal Watch; she hates anyone in a uniform except the ones who pay. She has never been told to be afraid of witchers, and would not listen if she were."
disposition: wary
regard: kindred
essential: true
dialogue: dlg.wick_weirs
barks: ["Mud's hungry tonight.", "Not that way. You'll go in to your neck.", "Lantern men. Ugh.", "Keep up, goat-eyes."]
combat: null
shop: null
```

```yaml npc
id: npc.sergeant_brask
name: "Sergeant Oda Brask"
faction: faction.crown
role: "Lord Marshal Kosk's sergeant; runs his private patrol on the docks"
motive: "Find out what happened to the Marshal's courier before the Chancellery's men do."
secret: "Kosk has her watch the docks because he trusts none of the palace guard, half of whom draw extra pay from Chancellor Varn. She held the ditch line at Marnadal the week the witcher walked it, and heard him say the clan words over the dead."
disposition: neutral
regard: pragmatic
essential: true
dialogue: dlg.brask_docks
barks: ["Keep walking.", "Marshal's business.", "You've blood on your boots, witcher.", "Hood up."]
combat: null
shop: null
```

```yaml npc
id: npc.watch_corporal_voss
name: "Corporal Anders Voss"
faction: faction.varn
role: "Corporal of the Chancellery watch on Eel Row"
motive: "Hang a witcher for the Chancellor and be thanked for it."
secret: "Draws a second wage from the Chancellery for reporting on the Marshal's patrol."
disposition: hostile
regard: bigot
essential: true
dialogue: dlg.brask_docks
barks: ["Chancellery business.", "Stand aside for the watch.", "It hangs. Tonight."]
combat: null
shop: null
```

## 5. Dialogue trees

### 5.1 Bertha's slate (the opening)

This plays once, on the new game. It teaches dialogue and the stigma system in its first minute (gdd §6.19.4 has the worked example). Persuade against a `wary` woman at `shunned` is −1. Intimidate is +1. **Paying the double price without a fight** sets `flag.bertha_softened`. It is the only way to earn her in this scene, and she pays it back later.

Crowns: 30 at start. Paying 7 leaves 23, and the courier's purse adds 8, so the thug bribe (30) stays affordable on every path.

```yaml dialogue
id: dlg.bertha_tab
participants: [npc.bertha, npc.gorm_tatch]
start: open
nodes:
  open:
    type: line
    speaker: npc.bertha
    text: "Last bell. Three ales and a cold pie on your slate, and I want it settled before the eel-men start singing."
    direction: "At the snug table, slate under one arm, a chipped clay cup hooked on one finger. She hasn't looked under the hood."
    next: look
  look:
    type: line
    speaker: npc.bertha
    text: "And look at me when I'm talking to you. I like to see the face that owes me."
    direction: "Hale lifts his head. The hood slides back. Bertha sees the eyes, and her chalk stops halfway down the slate."
    effects: ["set_hood(down)", "show_eyes(npc.bertha)", "show_eyes(npc.gorm_tatch)", "add_heat(15)"]
    next: price
  price:
    type: line
    speaker: npc.bertha
    text: "...Seven crowns."
    direction: "Flat. She sets the clay cup down at his elbow, well apart from the clean mugs, and wipes her fingers on her apron."
    next: gorm
  gorm:
    type: line
    speaker: npc.gorm_tatch
    text: "Make it ten, Bertha. You'll have to burn the cup after."
    direction: "From the south trestle, loud enough for the room. Somebody laughs."
    next: hub
  hub:
    type: choice
    options:
      - id: pay
        text: "Seven, then. [Pay 7]"
        condition: "crowns() >= 7 and not flag(flag.tab_paid)"
        effects: ["add_crowns(-7)", "set_flag(flag.tab_paid)", "set_flag(flag.bertha_softened)"]
        next: paid
      - id: argue
        text: "Three ales is three crowns. Same as his. [Persuade 5]"
        tag: persuade
        vs: npc.bertha
        condition: "not flag(flag.tab_paid)"
        check: {skill: persuade, dc: 5, pass: argue_pass, fail: argue_fail}
        once: true
      - id: lean
        text: "You'll take three. And you'll smile. [Intimidate 4]"
        tag: intimidate
        vs: npc.bertha
        condition: "not flag(flag.tab_paid)"
        check: {skill: intimidate, dc: 4, pass: lean_pass, fail: lean_fail}
        once: true
      - id: cup
        text: "Why the cup?"
        once: true
        next: cup
      - id: charm
        text: "That charm over your bottles is a Matron's medallion. [Witcher]"
        tag: witcher
        once: true
        effects: ["set_flag(flag.medallion_noticed)"]
        next: charm
      - id: channel
        text: "The eel-men owe me forty for clearing your pilots' channel. Take it out of that."
        once: true
        next: channel
      - id: ale
        text: "And another ale."
        once: true
        next: ale
      - id: bells
        text: "Who rings bells at midnight?"
        once: true
        next: bells
      - id: done
        text: "Leave the slate. I'm not going anywhere."
        next: done_branch
  paid:
    type: line
    speaker: npc.bertha
    text: "...You're not going to argue?"
    direction: "She waits for it. It doesn't come."
    next: paid_b
  paid_b:
    type: line
    speaker: player
    text: "Everywhere charges double. You're the first who's said it to my face."
    next: paid_c
  paid_c:
    type: line
    speaker: npc.bertha
    text: "Hm."
    direction: "She takes the coins. Her fingers brush his palm, and she doesn't pull them back as fast as she meant to."
    next: hub
  argue_pass:
    type: line
    speaker: npc.bertha
    text: "Three. Don't make a habit of being right in my tavern."
    effects: ["add_crowns(-3)", "set_flag(flag.tab_paid)"]
    next: hub
  argue_fail:
    type: line
    speaker: npc.bertha
    text: "Seven, or the gutter. The gutter's free, and it's where your sort usually sleeps."
    next: hub
  lean_pass:
    type: line
    speaker: npc.bertha
    text: "Three it is."
    direction: "She sweeps the coins off the table without touching his hand, and doesn't look at his face again."
    effects: ["add_crowns(-3)", "set_flag(flag.tab_paid)", "set_flag(flag.bertha_cowed)", "add_heat(10)"]
    next: hub
  lean_fail:
    type: line
    speaker: npc.bertha
    text: "I've had dockers twice your width try that face on me, witcher. Seven."
    next: hub
  cup:
    type: line
    speaker: npc.bertha
    text: "Because it's the witcher's cup. It hangs on its own nail, so nobody drinks after you. It's hung there seventeen years."
    next: cup_b
  cup_b:
    type: line
    speaker: player
    text: "Seventeen years. Who drank from it before me?"
    next: cup_c
  cup_c:
    type: line
    speaker: npc.bertha
    text: "Somebody who didn't argue about the price, either. Settle up."
    direction: "She looks at the cup, not at him."
    next: hub
  charm:
    type: line
    speaker: npc.bertha
    text: "It's a charm. Keeps the rats off."
    direction: "Too quickly. She doesn't turn round to look at it."
    next: charm_b
  charm_b:
    type: line
    speaker: player
    text: "It's a Matron's. The door and the eye. Witchers don't give those away."
    next: charm_c
  charm_c:
    type: line
    speaker: npc.bertha
    text: "Then he must have dropped it. Seven crowns."
    direction: "He. She hears herself say it."
    next: hub
  channel:
    type: line
    speaker: npc.bertha
    text: "Gorm?"
    direction: "Over her shoulder, to the south trestle."
    next: channel_b
  channel_b:
    type: line
    speaker: npc.gorm_tatch
    text: "We never signed with a witcher. Nobody signs with a witcher."
    next: channel_c
  channel_c:
    type: line
    speaker: npc.bertha
    text: "There. I can't eat the guild's debts, witcher. Nobody on Eel Row can."
    next: hub
  ale:
    type: line
    speaker: npc.bertha
    text: "No. Three is what I pour your kind in one night, and that's three more than the Gull and Anchor would."
    next: hub
  bells:
    type: line
    speaker: npc.bertha
    text: "St. Corwen's, over the river. Nobody rang them. Third time since spring. Fenn says it means a royal death."
    next: hub
  done_branch:
    type: branch
    cases:
      - {if: "flag(flag.tab_paid)", next: done_paid}
    else: done_unpaid
  done_paid:
    type: line
    speaker: npc.bertha
    text: "Mind yourself, then. And keep your eyes to yourself."
    next: finish
  done_unpaid:
    type: line
    speaker: npc.bertha
    text: "You'll pay before you leave, or you'll leave through the river."
    next: finish
  finish:
    type: effect
    effects: ["play_beat(tut_hood)", "play_beat(wake_in_snug)"]
    next: bye
  bye:
    type: end
```

### 5.2 The dying courier

The room has backed to the walls. The witcher is the only one who kneels. The `[Witcher]` option names the poison quietly, to the dying man alone, and costs nothing. Saying it to the room is a different choice (5.3).

```yaml dialogue
id: dlg.courier_dying
participants: [npc.courier, npc.bertha]
start: open
nodes:
  open:
    type: line
    speaker: npc.courier
    text: "Marshal's... man? No. No, your eyes..."
    direction: "On his back on the hearthstones, froth at his lips, clutching a dispatch case. The whole room has backed to the walls. Only Hale kneels and gets an arm under his head."
    next: eyes
  eyes:
    type: line
    speaker: npc.courier
    text: "Cat's eyes. You're one of the mountain's. Good. Something's waking. That's your trade, isn't it?"
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
      - id: smell
        text: "That's grey lily on your breath. [Witcher]"
        tag: witcher
        effects: ["add_clue(clue.courier_grey_lily)"]
        next: smell
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
  smell:
    type: line
    speaker: npc.courier
    text: "Is that its name? Pretty. Pretty name for it."
    direction: "Hale says it under his breath. Nobody else hears."
    next: give
  water:
    type: line
    speaker: npc.bertha
    text: "Water won't help him. Look at his mouth."
    direction: "From behind the bar. She doesn't come round it."
    next: give
  give:
    type: line
    speaker: npc.courier
    text: "Take it. Don't let them... Ostrel."
    direction: "He presses the dispatch case into Hale's hands, grips his wrist hard, and dies in his arms with his eyes open."
    next: dies
  dies:
    type: effect
    effects: ["set_flag(flag.courier_dead)", "play_beat(courier_dies)", "set_checkpoint(before_thugs)", "add_blame(blame.courier_murder)", "start_dialogue(dlg.rat_accused)"]
    next: bye
  bye:
    type: end
```

### 5.3 The room decides

This chains straight from the courier's death. Every option is honest, and most of them make it worse. **Investigate** is the clean argument. **`[Witcher]`** is the true argument, and it sounds like a confession. **Persuade** against the crowd is hard (`wary`, `shunned`: −1). **Intimidate** works, and the room remembers that it worked. **Bertha** speaks only if he gave her a reason (`flag.bertha_softened`), and when she does, she turns (`set_regard(npc.bertha, kindred)`).

```yaml dialogue
id: dlg.rat_accused
participants: [npc.gorm_tatch, npc.bertha, npc.old_fenn]
start: accuse
nodes:
  accuse:
    type: line
    speaker: npc.gorm_tatch
    text: "It touched him and he died. You all saw it. It put its hands on the Queen's man, and he died."
    direction: "Gorm Tatch is on his feet at the south trestle, pointing. The drinkers press back against the walls."
    effects: ["play_beat(room_accuses)", "add_heat(25)"]
    next: send
  send:
    type: line
    speaker: npc.gorm_tatch
    text: "Tam! Run for the watch. Tell them the witcher's killed a royal rider at the Rat."
    direction: "A gangly lad in a torn smock bolts out of the front door into the night."
    effects: ["set_flag(flag.watch_fetched)"]
    next: hub
  hub:
    type: choice
    options:
      - id: boots
        text: "Look at his boots. Mud to the thigh. He walked in off the south road, and he was dying when he did. [Investigate 4]"
        tag: investigate
        check: {skill: investigate, dc: 4, pass: boots_pass, fail: boots_fail}
        once: true
      - id: lily
        text: "Grey lily. A mountain poison. It takes hours, not a touch. [Witcher]"
        tag: witcher
        condition: "not flag(flag.named_grey_lily)"
        effects: ["set_flag(flag.named_grey_lily)", "add_clue(clue.courier_grey_lily)", "add_heat(10)"]
        next: lily_line
      - id: calm
        text: "Sit down, all of you. If I'd wanted him dead, I'd not have held him. [Persuade 5]"
        tag: persuade
        vs: crowd
        condition: "not flag(flag.rat_crowd_calmed)"
        check: {skill: persuade, dc: 5, pass: calm_pass, fail: calm_fail}
        once: true
      - id: glare
        text: "Sit. Down. [Intimidate 4]"
        tag: intimidate
        vs: crowd
        condition: "not flag(flag.rat_crowd_calmed)"
        check: {skill: intimidate, dc: 4, pass: glare_pass, fail: glare_fail}
        once: true
      - id: ask_bertha
        text: "Bertha. You saw him come through your door."
        condition: "not flag(flag.rat_crowd_calmed)"
        once: true
        next: bertha_branch
      - id: stare
        text: "Let them stare."
        next: bye
  boots_pass:
    type: line
    speaker: npc.old_fenn
    text: "He's right, Gorm. Lad came in coughing. I saw him through the window, staggering like a drunk."
    direction: "Fenn, from under his table, where he seems to have been awake all along."
    effects: ["add_clue(clue.courier_foam)", "add_heat(-15)"]
    next: hub
  boots_fail:
    type: line
    speaker: npc.gorm_tatch
    text: "Mud? Everybody's muddy on Eel Row. Not everybody's got eyes like that."
    effects: ["add_heat(5)"]
    next: hub
  lily_line:
    type: line
    speaker: npc.gorm_tatch
    text: "Hear that? It knows the poison's name. Who knows a poison's name but the one that used it?"
    next: lily_b
  lily_b:
    type: line
    speaker: npc.bertha
    text: "He's not wrong, witcher. That's how it sounds from here."
    next: hub
  calm_pass:
    type: line
    speaker: npc.old_fenn
    text: "...Aye. Sit down, Gorm. Your ale's getting warm."
    direction: "Benches scrape. One by one they sit. They do not stop watching."
    effects: ["set_flag(flag.rat_crowd_calmed)", "add_heat(-25)"]
    next: hub
  calm_fail:
    type: line
    speaker: npc.gorm_tatch
    text: "Held him? You held him down! I saw your hand on his throat!"
    effects: ["add_heat(5)"]
    next: hub
  glare_pass:
    type: line
    speaker: npc.gorm_tatch
    text: "...Don't you look at me with those."
    direction: "Benches scrape. They sit, because it told them to. Every one of them will remember that it told them to."
    effects: ["add_heat(-15)", "add_infamy(2)"]
    next: hub
  glare_fail:
    type: line
    speaker: npc.gorm_tatch
    text: "Look at it! It thinks it can stare us down in our own tavern!"
    effects: ["add_heat(5)"]
    next: hub
  bertha_branch:
    type: branch
    cases:
      - {if: "flag(flag.bertha_softened) and not flag(flag.bertha_cowed)", next: bertha_speaks}
    else: bertha_aside
  bertha_speaks:
    type: line
    speaker: npc.bertha
    text: "I did. He came through my door coughing froth, and this one hadn't left his corner all night. Sit down, Gorm. That lad was dead when he walked in."
    direction: "She comes round the bar for the first time all night and stands between the witcher and the room."
    effects: ["set_flag(flag.bertha_spoke_up)", "set_flag(flag.rat_crowd_calmed)", "set_regard(npc.bertha, kindred)", "add_heat(-30)", "play_beat(bertha_speaks_up)"]
    next: bertha_speaks_b
  bertha_speaks_b:
    type: line
    speaker: npc.gorm_tatch
    text: "You're standing up for it, Bertha? After what it is?"
    next: bertha_speaks_c
  bertha_speaks_c:
    type: line
    speaker: npc.bertha
    text: "I'm standing up for my floor. Drink your ale or get off it."
    next: hub
  bertha_aside:
    type: line
    speaker: npc.bertha
    text: "I saw him come in. I saw you kneel. That's all I saw, and I'm keeping out of it."
    direction: "She doesn't come round the bar. She doesn't look at Gorm, either."
    next: hub
  bye:
    type: end
```

### 5.4 Reading the letter

Opening the dispatch case hands over the letter and opens this short prompt. Reading it is what the Choir men outside are waiting for (the noise of the seal breaking, Cobb's lookout at the shutter), so reading starts the ambush. Pocketing it unread delays the ambush until Hale tries to leave.

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
    next: door
  door:
    type: line
    speaker: player
    text: "A hammer over a closed door. It's the same door that's on my medallion."
    direction: "The medallion at his throat is still trembling against the rune-wax."
    next: bertha_react
  bertha_react:
    type: line
    speaker: npc.bertha
    text: "Dwarf-wax. Haven't seen that since my granddad's day. Whatever it says, it'll get you hanged faster than it gets you paid."
    next: fire
  fire:
    type: effect
    effects: ["play_beat(letter_read)"]
    next: bye
  pocket_line:
    type: line
    speaker: npc.bertha
    text: "Smart. Now take it, and yourself, out of my tavern."
    next: bye
  bye:
    type: end
```

### 5.5 Bertha (router and topics)

`dlg.bertha` is Bertha's default conversation (side 01 reads it). It routes by state: before the courier, after his death, during the fight, after the fight, and later visits. Whether she calls him "love" follows her regard and `flag.bertha_softened`. The Corrick story is told only to a witcher she has decided to trust. It ends the conversation, because there is nothing to say after it.

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
    type: branch
    cases:
      - {if: "flag(flag.tab_paid)", next: early_paid}
    else: early_unpaid
  early_paid:
    type: line
    speaker: npc.bertha
    text: "Paid's paid. Drink from your cup and keep your eyes to yourself."
    next: bye
  early_unpaid:
    type: line
    speaker: npc.bertha
    text: "Seven crowns. It hasn't got any cheaper while you sat there."
    next: early_hub
  early_hub:
    type: choice
    options:
      - id: pay
        text: "Seven. [Pay 7]"
        condition: "crowns() >= 7 and not flag(flag.tab_paid)"
        effects: ["add_crowns(-7)", "set_flag(flag.tab_paid)", "set_flag(flag.bertha_softened)"]
        next: early_paid_line
      - id: later
        text: "In a moment."
        next: bye
  early_paid_line:
    type: line
    speaker: npc.bertha
    text: "...Hm. You didn't argue."
    next: bye
  dead_greet:
    type: line
    speaker: npc.bertha
    text: "He came in breathing and he died in your hands. Whatever's true, that's what Eel Row'll be saying by morning."
    direction: "Wiping her hands on her apron."
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
      - id: think
        text: "Do you think I killed him?"
        once: true
        next: think_branch
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
    text: "Royal courier, by the coat. He's got a case under him. I'm not touching it, and I'd think twice before you do."
    next: dead_hub
  poison_answer:
    type: line
    speaker: npc.bertha
    text: "Poison. My cousin's lad frothed like that after the wrong mushroom, but he went in a day. This one's been dying for hours. And he smells sweet. Like lilies."
    effects: ["add_clue(clue.courier_foam)"]
    next: dead_hub
  ostrel_answer:
    type: line
    speaker: npc.bertha
    text: "Dwarf name. Old money, old songs. My granddad said they locked themselves under a mountain and threw away the key. Your sort come down from those mountains, don't you?"
    next: dead_hub
  lore_pass:
    type: line
    speaker: player
    text: "Karak Ostrel. The dwarf-hold that helped Corvan win his crown. Sealed a hundred years. My school stands on the next peak over. Nobody writes letters from Ostrel."
    next: lore_pass_b
  lore_pass_b:
    type: line
    speaker: npc.bertha
    text: "Well, somebody did. And somebody killed for it. You've a head on you, witcher. Try to keep it on."
    next: dead_hub
  lore_fail:
    type: line
    speaker: player
    text: "Ostrel. It's in one of the school's songs. I can't place it."
    next: dead_hub
  think_branch:
    type: branch
    cases:
      - {if: "flag(flag.bertha_softened) and not flag(flag.bertha_cowed)", next: think_no}
    else: think_shrug
  think_no:
    type: line
    speaker: npc.bertha
    text: "No. I've seen poison. It doesn't work that fast, and you're not that stupid. Doesn't matter what I think, though, does it?"
    next: dead_hub
  think_shrug:
    type: line
    speaker: npc.bertha
    text: "I think it doesn't matter what I think. Take that case and get out of my tavern before somebody comes for it."
    next: dead_hub
  help_answer:
    type: line
    speaker: npc.bertha
    text: "He wanted the Marshal. Lord Kosk. His patrol walks the Fishmarket most nights, under the crane. They're the only soldiers on Eel Row who won't hang you first and ask after."
    next: dead_hub
  busy:
    type: branch
    cases:
      - {if: "flag(flag.bertha_softened) or flag(flag.bertha_spoke_up)", next: busy_warm}
    else: busy_cold
  busy_warm:
    type: line
    speaker: npc.bertha
    text: "Not now, love! Hit them or run!"
    next: bye
  busy_cold:
    type: line
    speaker: npc.bertha
    text: "Not now, witcher! Hit them or run!"
    next: bye
  after_fight:
    type: branch
    cases:
      - {if: "flag(flag.bertha_softened) or flag(flag.bertha_spoke_up)", next: after_warm}
    else: after_cold
  after_warm:
    type: line
    speaker: npc.bertha
    text: "Three of them. In my tavern. You broke two benches and saved my neck, love, and I can't decide which I'm angrier about."
    effects: ["set_flag(flag.bertha_thanked)"]
    next: after_hub
  after_cold:
    type: line
    speaker: npc.bertha
    text: "Three of them, in my tavern. ...Thank you. There. I've said it to a witcher. Don't you tell anyone."
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
      - id: medallion
        text: "The medallion over your bottles. Where did you get it?"
        condition: "flag(flag.medallion_noticed) and not flag(flag.medallion_story)"
        next: med_branch
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
    text: "Sit. Hold still. This is river-spirit, it'll sting like a wasp's wedding. Do your kind even feel it? Don't answer."
    direction: "She splashes brandy on the cuts and binds them with a bar rag, and doesn't flinch at the touch."
    next: after_hub
  fenn_hint:
    type: line
    speaker: npc.bertha
    text: "Ask Fenn. He sits by the window to watch the eel boats. Sees more than he lets on, when he's not snoring."
    next: after_hub
  body_line:
    type: line
    speaker: npc.bertha
    text: "The Marshal's men'll want him. If not, the river takes what nobody claims. That's how it goes on Eel Row. For his sort and for yours."
    next: after_hub
  help_answer_after:
    type: line
    speaker: npc.bertha
    text: "Lord Kosk's patrol. Fishmarket, under the crane. Go now, before the Chancellery's watch comes asking who broke my door, and who to hang for it."
    next: after_hub
  go_line:
    type: line
    speaker: npc.bertha
    text: "Take this. Poultice. My mother made them. She'd have hated you, gods rest her. I'm not sure I do."
    effects: ["give_item(item.poultice, 1)"]
    next: bye
  med_branch:
    type: branch
    cases:
      - {if: "(flag(flag.bertha_softened) or flag(flag.bertha_spoke_up)) and not flag(flag.bertha_cowed)", next: med_1}
    else: med_refuse
  med_refuse:
    type: line
    speaker: npc.bertha
    text: "Found it. In the mud. Leave it be, witcher."
    next: bye
  med_1:
    type: line
    speaker: npc.bertha
    text: "My Jan piloted the channel. Drowned in it, spring of fifty-one, and the drowners had him. Nobody would go down for him. Then a witcher came through. Corrick, he said his name was."
    direction: "She doesn't look at the medallion. She looks at the slate."
    next: med_2
  med_2:
    type: line
    speaker: npc.bertha
    text: "He brought my Jan up for ten crowns, which was fair. And Eel Row said a witcher who can pull a man out of the drowners must have put him there to begin with."
    next: med_3
  med_3:
    type: line
    speaker: npc.bertha
    text: "They took him out to the stake on the flats at low water and held him till the tide did the rest. I watched from my hatch. I didn't say a word. I fished that out of the mud next morning."
    next: med_4
  med_4:
    type: line
    speaker: player
    text: "Corrick went down to the coast the year I took the Trial, and never came back. The masters never said why."
    next: med_5
  med_5:
    type: line
    speaker: npc.bertha
    text: "Now you know. Take it. It was never mine. Neither's the cup."
    direction: "She unhooks the medallion from its nail, puts it in his hand, and closes his fingers over it with both of hers."
    effects: ["give_item(item.corrick_medallion, 1)", "set_flag(flag.medallion_story)"]
    next: bye
  regular:
    type: branch
    cases:
      - {if: "regard(npc.bertha) == kindred", next: regular_warm}
    else: regular_cold
  regular_warm:
    type: line
    speaker: npc.bertha
    text: "There he is. Your cup's on its nail, love. Single price, now. Don't tell the regulars."
    next: regular_hub
  regular_cold:
    type: line
    speaker: npc.bertha
    text: "Your cup's on its nail. Double, same as ever. I've regulars to think of."
    next: regular_hub
  regular_hub:
    type: choice
    options:
      - id: troubles
        text: "That J on your slate. Who is he?"
        condition: "ms(ms.a1_audience_done)"
        next: troubles
      - id: medallion
        text: "The medallion over your bottles. Where did you get it?"
        condition: "flag(flag.medallion_noticed) and not flag(flag.medallion_story)"
        next: med_branch
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
    text: "Plenty. Half of them about you. Pull up a stool."
    effects: ["draw_rumor(npc.bertha)"]
    next: bye
  bye:
    type: end
```

### 5.6 The thugs at the door

Cobb does the talking, to the room more than to Hale. The fight can be **shrunk** (gdd §8.1). Murrow can be driven off by **Intimidate 6** (he is `bigot`, so +2 at `shunned`), by **`[Hood]`** and then the threat, by **`[Hush]`** (no check, +25 heat, and Gorm screams witchcraft), or by the **poison argument** to the room (Persuade 4 against the crowd, which also calms it). Dace walks for **Bribe 30**. Doing both leaves Cobb alone. Cobb himself never backs down by talk: he has been paid half up front, and he is the only man in the room who isn't afraid of the witcher.

```yaml dialogue
id: dlg.rat_thugs_standoff
participants: [npc.rat_thug_leader, npc.bertha, npc.rat_thug_murrow, npc.gorm_tatch]
start: demand
nodes:
  demand:
    type: line
    speaker: npc.rat_thug_leader
    text: "Evening, friends. Evening, witcher. Our cousin there came in with something that belongs to us."
    direction: "Cobb steps over the broken threshold, cosh loose in one hand, and takes in the room: the dead man, the witcher, the drinkers against the walls. Dace and Murrow behind him."
    next: frame
  frame:
    type: line
    speaker: npc.rat_thug_leader
    text: "Would you look at that. The witcher's done our cousin. You all saw it. Help us take the thing, and the Marshal's reward is yours."
    direction: "He says it to the room, palms open, not to Hale."
    effects: ["play_beat(cobb_turns_room)", "add_heat(15)"]
    next: frame_branch
  frame_branch:
    type: branch
    cases:
      - {if: "flag(flag.bertha_spoke_up)", next: bertha_answers}
      - {if: "flag(flag.rat_crowd_calmed)", next: room_holds}
    else: room_stirs
  bertha_answers:
    type: line
    speaker: npc.bertha
    text: "There's no reward, Cobb Rennet, and I knew your mother. Nobody in my tavern is helping you."
    effects: ["add_heat(-15)"]
    next: demand_branch
  room_holds:
    type: line
    speaker: npc.gorm_tatch
    text: "...Reward or no reward, I'm not touching it."
    direction: "The room stays sitting. Nobody looks at Cobb."
    next: demand_branch
  room_stirs:
    type: line
    speaker: npc.gorm_tatch
    text: "You heard him. There's a reward!"
    direction: "Gorm takes a bottle by the neck. Somebody behind him picks up a stool."
    next: demand_branch
  demand_branch:
    type: branch
    cases:
      - {if: "not flag(flag.letter_taken)", next: demand_body}
    else: hub
  demand_body:
    type: line
    speaker: npc.rat_thug_leader
    text: "Oh, it's still on him. Even better. Step away from the hearth, witcher, and nobody needs to work tonight."
    next: hub
  hub:
    type: choice
    options:
      - id: why
        text: "Who's paying you to lie?"
        once: true
        next: why_answer
      - id: scare
        text: "Murrow, is it? Ask your gran what a witcher does to men who corner him. [Intimidate 6]"
        tag: intimidate
        vs: npc.rat_thug_murrow
        condition: "not flag(flag.rat_thug_scared)"
        check: {skill: intimidate, dc: 6, pass: scare_pass, fail: scare_fail}
        once: true
      - id: hood
        text: "Lower the hood. Let Murrow see what he's come for. [Hood]"
        tag: hood
        condition: "hooded() and not flag(flag.rat_thug_scared)"
        once: true
        effects: ["set_hood(down)", "show_eyes(npc.rat_thug_murrow)", "add_heat(10)"]
        next: hood_line
      - id: hush
        text: "Make the squat one forget why he came. [Hush]"
        tag: sign
        sign: hush
        vs: npc.rat_thug_murrow
        condition: "not flag(flag.rat_thug_scared)"
        once: true
        effects: ["set_flag(flag.rat_thug_scared)", "add_var(var.rat_thugs_left, -1)", "add_infamy(2)"]
        next: hush_line
      - id: bribe
        text: "Thirty crowns says one of you never found anyone here. [Bribe 30]"
        tag: bribe
        bribe: 30
        condition: "not flag(flag.rat_thug_bribed)"
        effects: ["set_flag(flag.rat_thug_bribed)", "add_var(var.rat_thugs_left, -1)"]
        next: bribe_pass
      - id: foam
        text: "He was dying when he came in. You all saw him cough. They'll poison you too, when you've done their job. [Clue: Froth at the courier's mouth]"
        tag: clue
        vs: crowd
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
        next: run_branch
  why_answer:
    type: line
    speaker: npc.rat_thug_leader
    text: "Lie? I don't care what you are, friend. I'm the only man in here who doesn't. But they do, and that's worth more to me than a cosh."
    next: hub
  scare_pass:
    type: line
    speaker: npc.rat_thug_murrow
    text: "I'm not fighting a witcher for six silver! Not for sixty!"
    direction: "Murrow backs into the doorframe, makes the sign of the lion, and runs up Eel Row."
    effects: ["set_flag(flag.rat_thug_scared)", "add_var(var.rat_thugs_left, -1)"]
    next: hub
  scare_fail:
    type: line
    speaker: npc.rat_thug_leader
    text: "Murrow's not scared of nursery stories. Are you, Murrow?"
    next: scare_fail_b
  scare_fail_b:
    type: line
    speaker: npc.rat_thug_murrow
    text: "...No, Cobb."
    direction: "He is. He stays anyway."
    next: hub
  hood_line:
    type: line
    speaker: npc.rat_thug_murrow
    text: "Lion keep me. Cobb, look at its eyes. Look at its eyes."
    direction: "Murrow takes a step back, and doesn't take it again."
    next: hub
  hush_line:
    type: line
    speaker: npc.gorm_tatch
    text: "Witchcraft! You saw it, all of you, it witched him!"
    direction: "Hale's fingers move. Murrow's face goes slack; he turns round and wanders out into the dark like a man looking for his bed."
    next: hub
  bribe_pass:
    type: line
    speaker: npc.rat_thug_leader
    text: "Dace. Dace, you whoreson, put that purse down. Dace!"
    direction: "The lanky one catches the purse, shrugs at Cobb, and strolls out whistling."
    next: hub
  foam_pass:
    type: line
    speaker: npc.rat_thug_murrow
    text: "Cobb... he did come in coughing. I saw him on the quay."
    direction: "Murrow looks at the dead man's lips, goes white, and backs out of the door. Around the room, people sit down."
    effects: ["set_flag(flag.rat_thug_scared)", "add_var(var.rat_thugs_left, -1)", "set_flag(flag.rat_crowd_calmed)", "add_heat(-20)"]
    next: hub
  foam_fail:
    type: line
    speaker: npc.rat_thug_leader
    text: "Lots of men die of drink on Eel Row, friend. Lots."
    next: hub
  fight_line:
    type: line
    speaker: npc.rat_thug_leader
    text: "Have it your way. Nothing personal, witcher. It never is."
    next: fight_go
  run_branch:
    type: branch
    cases:
      - {if: "flag(flag.bertha_softened) or flag(flag.bertha_spoke_up)", next: run_warm}
    else: run_cold
  run_warm:
    type: line
    speaker: npc.bertha
    text: "Trapdoor's behind the bar, love! Go! I'll not watch it twice!"
    next: fight_go
  run_cold:
    type: line
    speaker: npc.bertha
    text: "Trapdoor's behind the bar! Go, witcher, go! I'll not watch it twice!"
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

### 5.7 A thug yields

In front of the room, both choices are remembered (gdd §6.19.8). Execution is authored here, because this dialogue is not a combat execution.

```yaml dialogue
id: dlg.rat_thug_yield
participants: [npc.rat_thug_leader, npc.bertha]
start: beg
nodes:
  beg:
    type: line
    speaker: npc.rat_thug_leader
    text: "Enough! Enough, friend. I've a mother. Probably. Let me crawl out of here and you'll never see my face again."
    direction: "Whoever yielded last, on his knees by the hearth, not looking at the witcher's eyes. Spoken in the leader's voice set if Cobb is alive, else the generic thug voice."
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
        effects: ["set_flag(flag.rat_thug_spared)", "add_infamy(-2)"]
        next: spare_line
      - id: kill
        text: "No."
        effects: ["set_flag(flag.rat_thug_executed)", "add_infamy(5)", "add_heat(15)"]
        next: kill_line
  who_pass:
    type: line
    speaker: npc.rat_thug_leader
    text: "Man in grey! Hood up, soft voice, soft hands. Pays half up front, half at the Fishmarket steps. Silver, new-clipped. Said if there was a witcher about, so much the better. That's all, I swear it."
    effects: ["add_clue(clue.thug_silver)"]
    next: hub
  who_fail:
    type: line
    speaker: npc.rat_thug_leader
    text: "Nobody! A man. A face. I don't look at faces, friend, it's bad for business. Least of all yours."
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
    direction: "The thug scrambles out of the door on hands and knees. Somebody at the back says, quietly, 'It let him go.'"
    next: bye
  kill_line:
    type: line
    speaker: npc.bertha
    text: "Gods. On my floor. In front of all of them."
    direction: "Hale finishes it. The room makes a sound like a held breath. Bertha turns away and starts pouring sand."
    next: bye
  bye:
    type: end
```

### 5.8 Old Fenn

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
    text: "Don't look at me, I'll curdle. Bells at midnight. Bells at midnight, and now you. Somebody royal's going in the ground before the snow, you mark me."
    next: bye
  after:
    type: line
    speaker: npc.old_fenn
    text: "Is it over? You didn't eat anybody. Huh. My gran lied to me, then. Is there more ale? No? Then let an old man tell you something for free."
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
    text: "Man in grey on the quay, hood up. Stood under the lamp like he was waiting for a ferry. When the bells rang, he bowed his head, like at prayers. Then the blue lad came stumbling, and grey man walked off."
    effects: ["add_clue(clue.thug_silver)"]
    next: bye
  bye:
    type: end
```

### 5.9 Gorm Tatch

Gorm is the town in one man: loud, bigoted, and owing the witcher money. After the fight there is one small piece of justice to take, or to give away. Intimidate is easy against him (`bigot`: +2 at `shunned`).

```yaml dialogue
id: dlg.gorm_tatch
participants: [npc.gorm_tatch]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "ms(ms.a1_rat_survived)", next: after}
      - {if: "flag(flag.courier_dead)", next: during}
    else: before
  before:
    type: line
    speaker: npc.gorm_tatch
    text: "Don't you sit near me. And don't you look at my nephew."
    next: bye
  during:
    type: line
    speaker: npc.gorm_tatch
    text: "Stay back! The watch is coming. They'll hang you off the crane by your own swords."
    next: bye
  after:
    type: line
    speaker: npc.gorm_tatch
    text: "What? What do you want? I didn't touch you. Nobody touched you."
    direction: "At the south trestle, nursing his ale, or a split lip if he joined the fight."
    next: after_hub
  after_hub:
    type: choice
    options:
      - id: debt
        text: "The guild owes me forty crowns for the channel. [Intimidate 5]"
        tag: intimidate
        vs: npc.gorm_tatch
        condition: "not flag(flag.gorm_debt_settled)"
        check: {skill: intimidate, dc: 5, pass: debt_pass, fail: debt_fail}
        once: true
      - id: forgive
        text: "Keep the forty. Buy your nephew a coat."
        condition: "not flag(flag.gorm_debt_settled)"
        once: true
        effects: ["set_flag(flag.gorm_debt_settled)", "add_infamy(-1)"]
        next: forgive_line
      - id: leave
        text: "Nothing."
        next: bye
  debt_pass:
    type: line
    speaker: npc.gorm_tatch
    text: "Twenty. It's all there is. The guild voted to pay you, all right? I kept it. Take it and don't look at me."
    direction: "He counts it onto the table so he won't have to touch the witcher's hand."
    effects: ["add_crowns(20)", "set_flag(flag.gorm_debt_settled)", "add_infamy(1)"]
    next: bye
  debt_fail:
    type: line
    speaker: npc.gorm_tatch
    text: "Hit me, then. Go on. Hit me in front of them. That's all your kind knows."
    next: after_hub
  forgive_line:
    type: line
    speaker: npc.gorm_tatch
    text: "...What's your game?"
    direction: "He stares. For once he has nothing to shout."
    next: bye
  bye:
    type: end
```

### 5.10 Wick at the eel-weirs

Wick is `kindred`. Nobody told her to be afraid of witchers, and she would not have listened. Persuade against her gets +1.

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
    text: "You're running from the lantern men. Everyone runs from the lantern men. Most of them drown in the weirs."
    direction: "Perched on a weir post, a sack of bent nails on her lap."
    next: eyes
  eyes:
    type: line
    speaker: npc.mudlark_wick
    text: "Show us your eyes, then. ...Huh. They're yellow. Like a goat's, but the wrong way round."
    direction: "She leans right off her post to look. Not afraid at all."
    effects: ["show_eyes(npc.mudlark_wick)"]
    next: hub
  hub:
    type: choice
    options:
      - id: pay
        text: "Show me the way through and these are yours. [Bribe 5]"
        tag: bribe
        bribe: 5
        next: path
      - id: owe
        text: "Help me through and I'll owe you one. [Persuade 4]"
        tag: persuade
        vs: npc.mudlark_wick
        check: {skill: persuade, dc: 4, pass: owe_pass, fail: owe_fail}
        once: true
      - id: dark
        text: "I can see in the dark. I can't see which posts are rotten. [Witcher]"
        tag: witcher
        once: true
        next: dark_line
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
    effects: ["set_flag(flag.wick_helped)", "play_beat(wick_path)"]
    next: stake
  stake:
    type: line
    speaker: npc.mudlark_wick
    text: "And mind the black stake by the channel. That's the witcher post. They drowned one on it before I was born. Tide does it for you, if you hold still."
    next: bye
  owe_pass:
    type: line
    speaker: npc.mudlark_wick
    text: "A witcher owing me. Ha! Mam'd die. Fine. Fine. Keep up."
    next: path
  owe_fail:
    type: line
    speaker: npc.mudlark_wick
    text: "Owing's not paying."
    next: hub
  dark_line:
    type: line
    speaker: npc.mudlark_wick
    text: "Ha! Nobody can, except me. Come on, then, goat-eyes."
    next: path
  scared:
    type: line
    speaker: npc.mudlark_wick
    text: "Throw me in? I live in it. Enjoy the green posts, goat-eyes."
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
    text: "You didn't drown. Most of your sort do, round here. Bring me nails and I'll tell you who's been walking my flats at night."
    next: bye
  bye:
    type: end
```

### 5.11 Sergeant Brask at the docks

Brask knows him from the Marnadal ditch. If Tam fetched the watch, Corporal Voss arrives to hang the witcher, and Brask sends him away in the Marshal's name. That sets up Varn's grudge in a1.02 (`flag.voss_turned_away`). Her last line is the slice's last line before the end card.

```yaml dialogue
id: dlg.brask_docks
participants: [npc.sergeant_brask, npc.bertha, npc.watch_corporal_voss]
start: open
nodes:
  open:
    type: line
    speaker: npc.sergeant_brask
    text: "Stop there. You've blood on you and mud to the knees, and a royal courier went into the Drowned Rat an hour ago and didn't come out. Talk."
    direction: "Lantern raised. Her two soldiers spread to either side."
    next: know
  know:
    type: line
    speaker: npc.sergeant_brask
    text: "...I know those eyes. Marnadal. The ditch. You were the one the Marshal paid to walk it."
    direction: "She lowers the lantern a hand's width. Not more."
    next: voss_check
  voss_check:
    type: branch
    cases:
      - {if: "flag(flag.watch_fetched)", next: voss}
    else: letter_check
  voss:
    type: line
    speaker: npc.watch_corporal_voss
    text: "That's it, Sergeant. That's the witcher that killed the Queen's rider. Chancellery orders: it hangs tonight."
    direction: "Corporal Voss and two watchmen come off the market gate at a jog, Tam Tatch behind them, pointing."
    effects: ["play_beat(voss_arrives)"]
    next: voss_b
  voss_b:
    type: line
    speaker: npc.sergeant_brask
    text: "Chancellery orders don't run on the Marshal's docks, Corporal. This one's the Marshal's until the Marshal says otherwise."
    next: voss_c
  voss_c:
    type: line
    speaker: npc.watch_corporal_voss
    text: "The Chancellor will hear of this."
    next: voss_d
  voss_d:
    type: line
    speaker: npc.sergeant_brask
    text: "I'm counting on it. Off you go."
    direction: "Voss goes. He looks back twice. Shutters close along Eel Row."
    effects: ["set_flag(flag.voss_turned_away)"]
    next: letter_check
  letter_check:
    type: branch
    cases:
      - {if: "not has_item(item.dravin_letter)", next: no_letter}
    else: hub
  no_letter:
    type: line
    speaker: npc.bertha
    text: "Wait! Wait, you daft... You left this on him!"
    direction: "Bertha comes puffing up Eel Row with the iron-waxed dispatch, in front of every open shutter on the quay."
    effects: ["set_flag(flag.bertha_at_docks)", "play_beat(bertha_brings_letter)", "give_item(item.dravin_letter, 1)", "set_flag(flag.letter_taken)"]
    next: no_letter_b
  no_letter_b:
    type: line
    speaker: npc.bertha
    text: "And he died of poison, not of him, before anyone asks. Frothing like a lily-pond. I'm going home. To bed. Forever."
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
    text: "In your arms. Gods. You know what Eel Row makes of that."
    direction: "She takes the case, turns the iron-wax to the lantern, and gives it back."
    next: truth_b
  truth_b:
    type: line
    speaker: npc.sergeant_brask
    text: "Dwarf iron-wax. He said that name, did he? Ostrel? ...Don't answer that out here."
    next: summons
  seal:
    type: line
    speaker: npc.sergeant_brask
    text: "Tomas. He was green, but he was ours. Most on Eel Row would have sold that seal. Most on Eel Row would have sold you with it."
    next: truth
  coy:
    type: line
    speaker: npc.sergeant_brask
    text: "Your life, maybe. Men who carry that letter don't live long, and men with your eyes live less. The Marshal can keep you breathing. Show me."
    next: truth
  walk:
    type: line
    speaker: npc.sergeant_brask
    text: "Then don't talk. Walk. With me, to the palace, or alone, to wherever the Chancellery catches you. Your choice."
    next: truth
  summons:
    type: line
    speaker: npc.sergeant_brask
    text: "The Marshal wants a word. He sits with the Queen's council at first light. He doesn't trust the palace guard, so he'll trust a witcher who bled for his courier. Market gate, then the Lion Steps."
    effects: ["set_flag(flag.brask_met)", "set_flag(flag.summoned_by_kosk)", "add_xp(25)"]
    next: hood
  hood:
    type: line
    speaker: npc.sergeant_brask
    text: "And put your hood up. You'll start a riot."
    direction: "She's already walking."
    next: end_card
  end_card:
    type: effect
    effects: ["play_beat(slice_end_card)"]
    next: bye
  bye:
    type: end
```

## 6. Encounters

All the thug encounters in the tavern share the checkpoint `before_thugs` and Bertha as a scripted ally (one bottle throw, beat `bertha_bottle`). Fighting is optional; fleeing through the trapdoor at any time leaves the encounter by an exit (`on_player_fled`).

| Encounter | Enemies | When |
|---|---|---|
| `enc.rat_thugs` | Cobb + 2 thugs | No talk reduction |
| `enc.rat_thugs_two` | Cobb + 1 thug | One of: Intimidate 6, `[Hush]`, the poison argument, Bribe 30 |
| `enc.rat_thugs_one` | Cobb alone | A Murrow option and the bribe |
| any of the three, variant | + Gorm and a drover (`enemy.townsfolk`) | Heat ≥ 75 at the start, and the room neither calmed nor fled |
| `enc.mudflats_crossbow` | 1 crossbowman on the quay | Always on the flee path. He cannot be reached, only shot (2 bolts) or avoided |
| `enc.mudflats_thugs` / `enc.mudflats_thug` | the thugs left in the tavern (at most 2) | They land at the Margery unless the ladder is cut |

The townsfolk flee at 70% HP (gdd §6.7). One hit usually does it. They count as defeated, so they never block the win. A heavy hit can kill one outright, and that is a civilian kill (+10 infamy, Crown −5, automatic, gdd §6.19.8). Using steel on a frightened drunk is the player's choice. A kick or a Knock moves them without killing them.

```yaml encounter
id: enc.rat_thugs
zone: zone.drowned_rat
enemies:
  - {enemy: enemy.choir_thug, count: 1, spawn: thug_door, variant: leader}
  - {enemy: enemy.choir_thug, count: 2, spawn: thug_door, variant: null}
variants:
  - when: "heat() >= 75 and not flag(flag.regulars_fled) and not flag(flag.rat_crowd_calmed)"
    add_enemies:
      - {enemy: enemy.townsfolk, count: 1, spawn: regulars_table, variant: gorm}
      - {enemy: enemy.townsfolk, count: 1, spawn: regulars_table, variant: drover}
waves: []
attack_tokens: null
allow_yield: true
allies: [npc.bertha]
checkpoint: before_thugs
avoidable_by: ["dlg.rat_thugs_standoff"]
on_won: ["reach_milestone(ms.a1_rat_survived)", "add_rep(faction.choir, -30)", "set_flag(flag.rat_fought)", "add_heat(-20)", "play_beat(thugs_down)"]
on_yielded: ["reach_milestone(ms.a1_rat_survived)", "add_rep(faction.choir, -30)", "set_flag(flag.rat_fought)", "add_heat(-20)", "start_dialogue(dlg.rat_thug_yield)"]
on_player_fled: ["set_flag(flag.rat_fled)"]
```

```yaml encounter
id: enc.rat_thugs_two
zone: zone.drowned_rat
enemies:
  - {enemy: enemy.choir_thug, count: 1, spawn: thug_door, variant: leader}
  - {enemy: enemy.choir_thug, count: 1, spawn: thug_door, variant: null}
variants:
  - when: "heat() >= 75 and not flag(flag.regulars_fled) and not flag(flag.rat_crowd_calmed)"
    add_enemies:
      - {enemy: enemy.townsfolk, count: 1, spawn: regulars_table, variant: gorm}
      - {enemy: enemy.townsfolk, count: 1, spawn: regulars_table, variant: drover}
waves: []
attack_tokens: null
allow_yield: true
allies: [npc.bertha]
checkpoint: before_thugs
avoidable_by: ["dlg.rat_thugs_standoff"]
on_won: ["reach_milestone(ms.a1_rat_survived)", "add_rep(faction.choir, -30)", "set_flag(flag.rat_fought)", "add_heat(-20)", "play_beat(thugs_down)"]
on_yielded: ["reach_milestone(ms.a1_rat_survived)", "add_rep(faction.choir, -30)", "set_flag(flag.rat_fought)", "add_heat(-20)", "start_dialogue(dlg.rat_thug_yield)"]
on_player_fled: ["set_flag(flag.rat_fled)"]
```

```yaml encounter
id: enc.rat_thugs_one
zone: zone.drowned_rat
enemies:
  - {enemy: enemy.choir_thug, count: 1, spawn: thug_door, variant: leader}
variants:
  - when: "heat() >= 75 and not flag(flag.regulars_fled) and not flag(flag.rat_crowd_calmed)"
    add_enemies:
      - {enemy: enemy.townsfolk, count: 1, spawn: regulars_table, variant: gorm}
      - {enemy: enemy.townsfolk, count: 1, spawn: regulars_table, variant: drover}
waves: []
attack_tokens: null
allow_yield: true
allies: [npc.bertha]
checkpoint: before_thugs
avoidable_by: ["dlg.rat_thugs_standoff"]
on_won: ["reach_milestone(ms.a1_rat_survived)", "add_rep(faction.choir, -30)", "set_flag(flag.rat_fought)", "add_heat(-20)", "play_beat(thugs_down)"]
on_yielded: ["reach_milestone(ms.a1_rat_survived)", "add_rep(faction.choir, -30)", "set_flag(flag.rat_fought)", "add_heat(-20)", "start_dialogue(dlg.rat_thug_yield)"]
on_player_fled: ["set_flag(flag.rat_fled)"]
```

The `leader` variant of `enemy.choir_thug` is Cobb: the same stat block, a voice set, and the scripted barks above. If Cobb yields, the yield dialogue uses his voice. Of the two other thugs, the shield-bearer is Murrow (`npc.rat_thug_murrow`, the one the talk options remove) and the swordsman is Dace (the one the bribe removes). The `gorm` and `drover` variants of `enemy.townsfolk` are a bottle and a stool. Gorm keeps his voice set (`npc.gorm_tatch`).

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

The `quay_walker` variant: the crossbowman's movement is confined to the quay-edge path above the pilings maze and the Margery. He matches the player's x-position with a 2 s lag, fires at most once every 3 s, and only with a clear line of sight. He stops at the weirs (fog). He cannot be reached in melee.

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

The thugs in the mud are slowed like the player (−40% in deep mud). Fighting in the mouth of the hull is a deliberate lesson in fighting on bad footing. Outrunning them to the sluice is allowed.

## 7. Items and clues

Starting gear (gdd §6.9) is declared here because the new game spawns into this section: `item.arming_sword` (steel, `main_hand`), `item.silver_sword` (`silver`), `item.gambeson` (the school jack), `item.matron_medallion`, `item.crossbow`, 8 × `item.crossbow_bolt`, 2 × `item.poultice`, 1 × `item.elixir_marrow`, and 30 crowns.

```yaml item
id: item.dravin_letter
name: "Dravin's iron-wax dispatch"
category: key
description: "A folded sheet of heavy rag paper sealed with dark dwarven iron-wax, the seal stamped with a hammer over a closed door. Addressed to the Lord Marshal. The rune-wax sets a witcher's medallion trembling."
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
name: "Matron steel"
category: weapon
description: "A witcher's steel sword, forged in the Matron's pattern: plain, long in the grip, nicked and oiled. For men and ordinary beasts. It barely marks a monster."
price: 40
stack_max: 1
equip_slot: main_hand
weapon: {base: 12, type: slash, block_pct: 0.7, armor_pen: 0, bonus_vs: {monster: 0.6, undead: 0.6, construct: 0.8}, moveset: sword}
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.silver_sword
name: "Matron silver"
category: weapon
description: "A silver-edged blade over a steel core, the Matron's door-and-eye on the ricasso. For monsters and the dead. Soft on men, useless on dwarven iron, and in town it draws more eyes than blood."
price: 0
stack_max: 1
equip_slot: silver
weapon: {base: 11, type: slash, block_pct: 0.6, armor_pen: 0, bonus_vs: {monster: 1.6, undead: 1.6, beast: 0.8, human: 0.6, construct: 0.5}, moveset: sword}
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.gambeson
name: "School jack"
category: armor
description: "Quilted linen under cut leather, the Matron's pattern, patched by a dozen hands since. Stained at the sword-side. Better than skin."
price: 30
stack_max: 1
equip_slot: armor
weapon: null
armor: {armor: 10, resist: {}}
consumable: null
readable_text: null
```

```yaml item
id: item.matron_medallion
name: "Matron medallion"
category: key
description: "A black dwarven-iron disc on a thong: a closed door, an open eye above it. 'We watch the door.' It trembles near magic: the dead, rune-iron, the Pact's stones."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.corrick_medallion
name: "Corrick's medallion"
category: key
description: "A Matron medallion like Hale's, its door and eye still crusted with seventeen-year-old Eel Row mud. It hung over Bertha Kell's bottles until she gave it back."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Scratched on the back, small, in a boy's hand: CORRICK. And under it, older: WE WATCH THE DOOR."
```

```yaml item
id: item.elixir_marrow
name: "Marrow"
category: consumable
description: "A witcher's elixir, black as tar. Knits flesh while you fight. Your veins go dark and your eyes go black, and anyone watching will remember it. It would kill an ordinary man."
price: 40
stack_max: 3
equip_slot: null
weapon: null
armor: null
consumable: {effects: ["heal_over_time(4, 15)"], use_time: 1.0, elixir: {tell_s: 30}}
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
text: "Grey-green froth, pinpoint pupils, a sweet smell like crushed lilies, and mud to the thigh. Not drink, and not a touch: a slow poison that took hours, swallowed on the road. The courier shared a cup with a 'kind monk' on the way."
supports: []
refutes: []
```

```yaml clue
id: clue.courier_grey_lily
theory: theory.poisoner
title: "Grey lily"
text: "Hale knew it by the smell: grey lily, a flower of the high Amell, a nerve-poison that takes hours to kill. The Matron fed it to its boys until it stopped killing them. Anyone who knows it that well is either a witcher or a poisoner, and Eel Row has already decided which."
supports: []
refutes: []
```

```yaml clue
id: clue.thug_silver
theory: theory.choir
title: "Paid in new silver and vellum"
text: "The Drowned Rat thugs were paid in new-clipped silver wrapped in strips of vellum by a soft-handed man in a grey hood, who waited on the quay, bowed his head when the Abbey bells rang, and said a witcher in the room would be 'so much the better'."
supports: []
refutes: []
```

```yaml clue
id: clue.ostrel_bolts
theory: theory.anselm_plan
title: "The lower bolts are grinding loose"
text: "Dravin Ostrel, a dwarf at Assengard, warned the Lord Marshal that the bolts under Karak Ostrel are failing and 'something old is waking'. Someone killed to stop that letter arriving. The seal's closed door is the door on a Matron medallion."
supports: []
refutes: []
```

```yaml blame
id: blame.courier_murder
title: "The royal courier's death"
text: "A royal courier died in the Drowned Rat with a witcher's hands on him. Eel Row says the witcher poisoned him. By morning the ballad-sellers will be singing it."
weight: 15
cleared_text: "The Lord Marshal's proclamation names the poison, the road it was swallowed on, and the silver that paid the men at the door."
clear_hint: "Prove the courier was poisoned before he reached the Rat, to someone the city listens to (gdd §6.19.7: a1.08 or a1.03)."
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: flag.bertha_bottle_thrown, type: bool, desc: "Bertha has thrown her one bottle in the taproom fight (beat bertha_bottle)."}
  - {id: flag.courier_entered, type: bool, desc: "The courier has stumbled into the Drowned Rat (beat courier_stumbles_in)."}
  - {id: flag.courier_dead, type: bool, desc: "The courier has died (beat courier_dies or courier_dies_alone)."}
  - {id: flag.letter_taken, type: bool, desc: "The player holds Dravin's letter (from the dispatch case or from Bertha)."}
  - {id: flag.letter_read, type: bool, desc: "The player broke the iron-wax and read the letter in the tavern."}
  - {id: flag.thugs_arrived, type: bool, desc: "The Choir thugs kicked in the Drowned Rat's door."}
  - {id: var.rat_thugs_left, type: int, min: 0, max: 3, desc: "Thugs still in the fight after talk (3, 2 or 1). Read by the mudflats pursuit."}
  - {id: flag.rat_thug_scared, type: bool, desc: "Murrow left: frightened (Intimidate, the hood), hushed, or convinced by the poison argument."}
  - {id: flag.rat_thug_bribed, type: bool, desc: "Dace took 30 crowns and walked."}
  - {id: flag.rat_fought, type: bool, desc: "The player won the tavern fight (or ended it by a yield)."}
  - {id: flag.rat_fled, type: bool, desc: "The player fled through the cellar onto the mudflats."}
  - {id: flag.rat_thug_spared, type: bool, desc: "The player spared a yielding thug in front of the room."}
  - {id: flag.rat_thug_executed, type: bool, desc: "The player killed a yielding thug in front of Bertha and the room."}
  - {id: flag.bertha_thanked, type: bool, desc: "Bertha's after-fight conversation has played."}
  - {id: flag.bertha_tended, type: bool, desc: "Bertha patched the player up (full heal, once)."}
  - {id: flag.tab_paid, type: bool, desc: "The witcher settled Bertha's slate (at 7, or at 3 after an argument or a threat). Side 01 may read it."}
  - {id: flag.bertha_softened, type: bool, desc: "He paid Bertha's doubled slate without a fight. The only way to earn her in a1.01; she can then speak up for him."}
  - {id: flag.bertha_cowed, type: bool, desc: "He frightened Bertha into taking three crowns. She will not stand up for him in this section."}
  - {id: flag.bertha_spoke_up, type: bool, desc: "Bertha defended the witcher in front of her regulars (dlg.rat_accused). Her regard becomes kindred."}
  - {id: flag.medallion_noticed, type: bool, desc: "The witcher noticed Corrick's medallion over Bertha's bottles (medallion trigger, the readable, or the [Witcher] option)."}
  - {id: flag.medallion_story, type: bool, desc: "Bertha told the Corrick story and gave back his medallion (item.corrick_medallion)."}
  - {id: flag.named_grey_lily, type: bool, desc: "The witcher named the poison aloud to the room (heat +10)."}
  - {id: flag.rat_crowd_calmed, type: bool, desc: "The taproom was talked or argued down (Persuade, the poison argument, or Bertha). No regulars join the thugs."}
  - {id: flag.watch_fetched, type: bool, desc: "Gorm sent his nephew Tam for the Chancellery watch. Corporal Voss comes to the docks."}
  - {id: flag.regulars_fled, type: bool, desc: "Heat reached 100 in the Rat: the regulars ran out screaming witchcraft (t_mob)."}
  - {id: flag.gorm_debt_settled, type: bool, desc: "The eel-men's debt to the witcher is settled: squeezed out of Gorm (+20 crowns) or forgiven."}
  - {id: flag.voss_turned_away, type: bool, desc: "Brask sent the Chancellery watch away from the docks in the Marshal's name. Varn hears of it (a1.02)."}
  - {id: flag.thugs_on_ladder, type: bool, desc: "Pursuing thugs are climbing down the Margery's ladder."}
  - {id: flag.ladder_cut, type: bool, desc: "The player cut the Margery's ladder; the pursuers are stuck in the mud."}
  - {id: flag.thugs_landed, type: bool, desc: "Pursuing thugs reached the mud and engaged."}
  - {id: flag.wick_helped, type: bool, desc: "Wick showed the safe path along the weir tops (and told him about the stake)."}
  - {id: flag.bertha_at_docks, type: bool, desc: "Bertha brought the forgotten letter to the docks, in front of the whole quay."}
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
    journal: "A royal courier died in my arms at the Drowned Rat, poisoned, with a dwarf-sealed letter from one Dravin Ostrel. His last word was 'Ostrel'. The whole room thinks I killed him. Someone sent men to take that letter back."
    objectives:
      - {id: get_letter, text: "Keep the courier's letter", condition: "has_item(item.dravin_letter)", optional: false}
      - {id: survive, text: "Survive the men at the door", condition: "ms(ms.a1_rat_survived)", optional: false}
      - {id: meet_brask, text: "Find the Lord Marshal's patrol on the docks", condition: "flag(flag.brask_met)", optional: false}
      - {id: learn_poison, text: "Learn what killed the courier", condition: "has_clue(clue.courier_foam) or has_clue(clue.courier_grey_lily)", optional: true, xp: 20}
      - {id: one_believer, text: "Make one person on Eel Row believe you", condition: "flag(flag.bertha_spoke_up) or flag(flag.rat_crowd_calmed)", optional: true, xp: 30}
    on_complete: []
    next: []
```

## 10. Rumors and event cards (optional)

None are defined here. Bertha's `rumors` option runs `draw_rumor(npc.bertha)` (content-format §J.2) on the pool in `docs/content/side/14-rumors.md`. Bertha is a rumor source for the Cintra pool. The rewrite wave adds the frame rumor "A witcher poisoned the Queen's rider" to that pool (`story-witcher.md` §11, side 14).

## 11. Failure states and branches

```yaml branches
paths:
  - id: fight
    when: "Player chooses 'Come and take it' (or fails every talk option) and wins the taproom fight."
    outcome: "ms.a1_rat_survived via on_won; heat -20; Bertha's after-fight talk (warm or cold), the Corrick story if she trusts him; Gorm's debt; front door to the docks; Brask's summons."
    sets: ["reach_milestone(ms.a1_rat_survived)", "set_flag(flag.rat_fought)"]
  - id: fight_with_regulars
    when: "Heat is 75 or more when the fight starts and the room was neither calmed nor fled (typically: the poison named aloud, or a sign used)."
    outcome: "Gorm and a drover join as enemy.townsfolk and flee at 70% HP. Killing one is a civilian kill (+10 infamy, Crown -5). Same milestone."
    sets: ["reach_milestone(ms.a1_rat_survived)"]
  - id: talk_down_then_fight
    when: "Player removes Murrow (Intimidate 6, [Hood] then Intimidate, [Hush], or the poison argument at Persuade 4) and/or pays Bribe 30 for Dace, then fights Cobb with one or no helper."
    outcome: "Smaller fight (enc.rat_thugs_two or enc.rat_thugs_one). Same outcome as fight. [Hush] costs +25 heat and +2 infamy."
    sets: ["reach_milestone(ms.a1_rat_survived)"]
  - id: bertha_turns
    when: "Player paid the doubled slate without a fight, then asked Bertha to speak to the room."
    outcome: "Bertha defends him to her regulars; regard kindred; the crowd is calmed; she calls him 'love' from then on, tells the Corrick story and gives back the medallion."
    sets: ["set_flag(flag.bertha_spoke_up)", "set_flag(flag.rat_crowd_calmed)"]
  - id: yield
    when: "The last thug standing yields at 20% HP."
    outcome: "Yield dialogue: question him (clue.thug_silver), take his purse, spare him (-2 infamy) or execute him (+5 infamy, +15 heat). Milestone via on_yielded."
    sets: ["reach_milestone(ms.a1_rat_survived)"]
  - id: flee
    when: "Player takes the cellar trapdoor and the tide hatch at any point after the thugs arrive."
    outcome: "+5 infamy (ran like the guilty). Bertha bolts the hatch ('love' or 'witcher'). Mudflats chase: crossbowman on the quay, the Margery ladder (cut it or fight the remaining thugs in the mud), Wick's safe path and the witcher's stake, sluice steps. Milestone on arrival at the Fishmarket."
    sets: ["set_flag(flag.rat_fled)", "reach_milestone(ms.a1_rat_survived)"]
  - id: mob
    when: "Heat reaches 100 in the Rat (several signs, or a sign on top of a hot room)."
    outcome: "The regulars flee screaming witchcraft (+5 infamy); heat set to 10; no townsfolk can join the fight; Gorm is gone for the rest of the section."
    sets: ["set_flag(flag.regulars_fled)"]
  - id: watch_at_docks
    when: "Gorm sent Tam for the watch (any courier death)."
    outcome: "Corporal Voss tries to arrest the witcher on the docks; Brask turns him away in the Marshal's name (flag.voss_turned_away, read by a1.02). No check, no fight."
    sets: ["set_flag(flag.voss_turned_away)"]
  - id: letter_unread
    when: "Player pockets the letter unread."
    outcome: "No ambush until the player touches the front door. Same branches afterwards. The letter can be read later from the inventory (no clue.ostrel_bolts until read in the tavern; Brask's line covers the content)."
    sets: []
failures:
  - id: player_dies_tavern
    result: reload_checkpoint
    recover: "Reload before_thugs (set when the courier dies): the accusation's result, the case and the standoff replay from there."
  - id: player_dies_mudflats
    result: reload_checkpoint
    recover: "Reload the last mudflats checkpoint (cp_mud_start, cp_pilings, cp_wreck, cp_weirs). The tide resets with the checkpoint."
  - id: caught_by_tide
    result: reload_checkpoint
    recover: "Tide damage kills like any other damage; reload the last checkpoint."
  - id: letter_left_behind
    result: soft_fail
    recover: "Player left without opening the dispatch case (door touched first, or fled). Bertha brings the letter to the docks in dlg.brask_docks (node no_letter), in front of the whole quay, and tells the poison clue."
  - id: no_money_for_bribe
    result: soft_fail
    recover: "Bribe options are hidden without the crowns (impossible on a normal path: 30 - 7 + 8 = 31). Intimidate, [Hood], [Hush], the clue, the fight and the flight remain."
  - id: bertha_not_earned
    result: soft_fail
    recover: "Player argued or threatened over the slate. Bertha stays out of the accusation and calls him 'witcher'; she still opens the trapdoor and bolts the hatch. The Corrick story waits for side 01."
guarantees:
  - "ms.a1_rat_survived is reachable without any check: choose 'Come and take it' and win, or choose 'Bertha, the cellar!' and run the mudflats to the sluice (no check on that route). Heat and infamy never gate either path."
  - "item.dravin_letter always reaches the player before the section ends: the dispatch case (no check) or Bertha at the docks (no check)."
  - "flag.summoned_by_kosk is always set by dlg.brask_docks, which has no checks on its main path and fires on entering the crane quay or Eel Row. The Voss branch has no checks and always ends with him sent away."
  - "blame.courier_murder has check-free clears later in Act I (gdd §6.19.7: Kosk's proclamation in a1.08 with clue.courier_foam, which this section always grants via Bertha or the docks, and clue.thug_silver)."
```

## 12. Open questions

1. **Tutorial prompt triggers (resolved by A08).** `"on": combat_event` triggers in `zone.drowned_rat` play the `tut_*` beats (content-format §J.3). `t_tut_sign` uses `enemy_hp_below` 50.
2. **`bertha_bottle` (resolved by A08).** Two `combat_event` triggers (`enemy_enters_area` at the bar, `player_hp_below` 40) play it once, guarded by `flag.bertha_bottle_thrown`.
3. **Hazard parameters (resolved by A08).** Each tide hazard turns on at its checkpoint (`enabled_by: {"on": checkpoint, ...}`, §J.3). The remaining `params` are physical tuning for the zone-scene implementer.
4. **Milestone XP (resolved by A08).** Main-milestone XP sits on the milestone declaration (`xp`, §J.7).
5. **`on_yielded` semantics.** I assume it fires once, when the encounter ends with at least one enemy having yielded and the rest down or fled. If yield can happen mid-fight while others still fight, the yield dialogue should wait until the encounter ends.
6. **Bertha's debt hook (resolved by A08).** `troubles` chains into side 01's `dlg.bertha_debt_plea`.
7. **Rumor source (resolved by A08).** `draw_rumor(npc.bertha)`.
8. **Triggers firing during dialogue (A13).** `add_heat` inside dialogue can cross a threshold (`t_heat_mutters`, `t_heat_stones`, `t_mob`). I assume heat triggers fire when the dialogue ends, in the order they were crossed, and that an encounter `variants.when` is evaluated when `start_encounter` runs, after the dialogue's effects. If the mob trigger fires mid-standoff, the regulars leave before the fight, which is the intended result.
9. **The medallion at spawn (A13).** `t_medallion_bar` has a 12 m range from the snug, so it fires within the first second, alongside the bells. Presentation should queue `tut_medallion` after `bells_unbidden` and before Bertha arrives.
10. **The Chancellery watch is not hostile here (A13).** Voss only talks. A real arrest fight belongs to later sections (a2.08), as gdd §6.19.6 says.
