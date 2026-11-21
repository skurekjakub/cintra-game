---
section_id: side.silver_mine
title: "The Knocking Below"
act: 2
story_ref: "story.md §10 Karak Ostrel Silver Mine; §1 Core Truth (pressure locks); gdd §7.3 Lower Halls breach, §7.4"
zones: [zone.silver_mine_camp, zone.silver_mine_shafts, zone.silver_mine_breach]
available_when: "ms(ms.act1_complete)"
escalation_stage_required: {min: 1, max: 4}
milestones_set: []
milestones_read: [ms.act1_complete, ms.act2_twist]
level_band: [7, 11]
---

# The Knocking Below

## 1. Scene summary
High in the Strept foothills, a clan silver mine has been dug for three generations on the shoulder of the Amell. For a season now, the miners have heard knocking under the deepest shafts: slow, rhythmic, iron on iron, like a great hammer that pauses to breathe. Half the crew has quit, sure it is the old dwarves come back for their silver, or something worse. Foreman Brannoc has to keep the mine working or his clan starves this winter, and he wants the knocking found and named. The player goes down past collapse-prone galleries and a flooded level where drowners have nested in the sump. At the bottom, the miners' tunnel has cut into worked dwarven stone. Behind it, Karak Ostrel's old pressure-hammers are labouring as the vault bolts loosen. The breach is a way into the Lower Halls of Karak Ostrel that does not need the Iron-Key. Late in the game, the Choir knows about it and wants it collapsed. The dramatic question: will a clan that owes Cintra nothing open its mine to a Cintran cause?

## 2. Progress and escalation
- **Availability:** Act II and Act III. Opens on `ms.act1_complete` (stage 1 or higher). Never closes. The breach is used as an entry to Karak Ostrel only in Act III.
- **Map node and zones:** `map.silver_mine`, reached from `map.dun_strept` (mountain edge, no condition). The route from Tigg runs `tigg — marnadal_watch — dun_strept — silver_mine` (all mountain after the Watch). At stage 2+ mountain edges without guides or Dravin force the "Snow-choked pass" hazard (gdd §6.3). Revealed by rumor r14 or by plain discovery from Dun Strept. Zones: `zone.silver_mine_camp`, `zone.silver_mine_shafts`, `zone.silver_mine_breach`.
- **Milestones:** none set. Reads `ms.act2_twist` only through `act() == 3` (the breach exit).
- **Payoff:** `flag.lower_breach_open` (gdd §7.3: the Lower Halls entry to Karak Ostrel, no Iron-Key needed; the inner bulkhead into the Forge of Echoes still needs Dravin or Maelis's rune reading, which is A06's to implement). `add_rep(faction.strept, 10)` on completion. `clue.vault_knocking` (theory.anselm_plan). `item.kettle_chart`.
- **Stage variants:**
  - **Stage 1:** sleet, mud at the pithead, half the crew gone.
  - **Stage 2 (Dark River):** heavy snow at the camp, and the pithead has a cold rate outside the forge hut. Meltwater raises the flooded level, and the knocking is faster.
  - **Stage 3 (Open Knives):** Choir sappers are in the breach, laying charges to collapse it (`enc.mine_choir_sappers`). Their charges must be cut (`flag.mine_charges_cut`) before the breach can be opened.
  - **Stage 4 (Act III):** the vault pressure is dropping. A dormant iron-warden has walked up the dwarven passage and stands at the breach. It wakes unless its rune plate is quieted (`enc.mine_stray_warden`). The breach exit to `zone.ko_lower_halls` is live.

## 3. Location layout
**The camp (pithead):** a shelf of spoil heaps on the mountain shoulder. The track comes up from Dun Strept on the south. There is a timber headframe over the main shaft with a winding drum and a man-cage, a forge hut (the only warm room), bunkhouses with half of their doors nailed shut, the clan's ore shed, and a rope bridge to an old adit across a gully. The adit was abandoned when the knocking began. Cover: ore carts, spoil heaps, the headframe legs.

**The shafts:** the man-cage drops to the **upper gallery**, a long timbered tunnel with side stopes. Several props are cracked, and the collapse hazard drops rock when the knocking peaks (a visible dust shiver gives warning). A ladderway leads down to the **pump chamber**, where three old hand-pumps feed a wooden launder up the shaft, all jammed. Beyond it the **flooded level** is a knee-to-chest-deep gallery that ends in the sump, where the drowners have nested in the dark water. They came up through flooded natural caves when the tremors broke the rock. At the far end of the flooded level, a **winze** (a sloping shaft) leads down.

**The breach:** the winze ends where a miner's pick broke through into **dwarven stonework**: dressed basalt blocks with no mortar seam, and a channel cut in the floor with old bronze fittings. The knocking is loud here. The player follows the passage to the **hammer gallery**, where a great iron hammer on a cam-shaft rises and falls against an anvil-block in a slot in the wall. It is a pressure-relief hammer, labouring. Past it is the **bulkhead stair**, a dwarven stair down to a rune-carved bulkhead door and the dark beyond: the way into the Lower Halls of Karak Ostrel. Rubble from the miners' break-in half chokes the stair and must be cleared (the "open the breach" step).

```yaml zone
id: zone.silver_mine_camp
name: "Strept Silver Mine: the pithead"
kind: hub
map_node: map.silver_mine
time_of_day: day
cold_rate: 0
disguise_tag: null
music: mine_pithead_wind
areas:
  - {id: south_track, description: "Track up from Dun Strept between spoil heaps. Default arrival. A clan cairn with a wolf skull."}
  - {id: headframe, description: "Timber headframe over the main shaft, winding drum, a man-cage on a chain. A bell rope."}
  - {id: forge_hut, description: "The forge hut, the only warm room. Brannoc's table, ore samples, a map of the workings chalked on a slate. Kettle's stool by the fire."}
  - {id: bunkhouses, description: "Four bunkhouses, two with doors nailed shut. A child's carved wolf on a sill."}
  - {id: ore_shed, description: "Clan ore shed. Sacks of silver ore under guard of one bored boy with a spear."}
  - {id: gully_bridge, description: "Rope bridge over a gully to the old adit, abandoned and boarded up."}
spawns:
  - {id: track_arrival, area: south_track, default: true}
  - {id: cage_top, area: headframe, default: false}
exits:
  - id: ride_cage
    area: headframe
    to_zone: zone.silver_mine_shafts
    to_spawn: cage_bottom
    condition: "quest_active(quest.side_silver_mine) or quest_done(quest.side_silver_mine)"
    effects: []
  - {id: track_board, area: south_track, to_map: true, label: "Take the track down to Dun Strept", condition: "true", effects: []}
interactables:
  - id: workings_slate
    area: forge_hut
    kind: readable
    label: "Study the chalked map of the workings"
    condition: "true"
    check: null
    once: true
    effects: ["add_map_pin(map.silver_mine)"]
  - id: forge_rest
    area: forge_hut
    kind: rest
    label: "Rest by the forge"
    condition: "rep_tier(faction.strept) >= neutral or quest_active(quest.side_silver_mine)"
    check: null
    once: false
    effects: ["heal_player(full)"]
  - id: adit_boards
    area: gully_bridge
    kind: search
    label: "Pry at the boarded adit"
    condition: "true"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["add_crowns(20)", "give_item(item.poultice, 1)"]
    fail_effects: []
  - id: ore_sacks
    area: ore_shed
    kind: container
    label: "Search the ore sacks"
    condition: "true"
    check: null
    once: true
    effects: ["add_rep(faction.strept, -5)", "add_crowns(30)"]
triggers:
  - id: knock_heard
    area: headframe
    "on": enter
    source: null
    condition: "not visited(zone.silver_mine_shafts)"
    once: true
    effects: ["play_beat(knock_through_ground)"]
hazards:
  - {id: shaft_mouth, area: headframe, kind: collapse, params: {fall: lethal, railed: true}}
  - {id: gully_wind, area: gully_bridge, kind: cold, params: {cold_rate_when_stage_ge_2: 2}}
checkpoints:
  - {id: pithead_arrival, area: south_track}
beats:
  - {id: knock_through_ground, description: "Through the boots: a slow iron knock, then another, felt more than heard. The miners at the headframe stop talking until it passes."}
  - {id: miners_return, description: "Brannoc rings the headframe bell three times. Men come out of the bunkhouses with picks and props, not looking at the player."}
npcs:
  - {npc: npc.brannoc, area: forge_hut, condition: "true"}
  - {npc: npc.old_kettle, area: forge_hut, condition: "true"}
encounters: []
loot: []
variants:
  - id: snow
    when: "stage() >= 2"
    description: "Snow to the knee. Icicles on the headframe. The gully wind applies cold; the forge hut is warm. Two more bunkhouse doors nailed shut."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: choir_open
    when: "stage() >= 3"
    description: "A Strept boy found a pale feather by the adit. Brannoc keeps it on the table, nailed down with a knife."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: working_again
    when: "quest_done(quest.side_silver_mine)"
    description: "Smoke from every bunkhouse chimney. The drum turns. Someone is singing badly in the ore shed."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
```

```yaml zone
id: zone.silver_mine_shafts
name: "Strept Silver Mine: the galleries"
kind: dungeon
map_node: map.silver_mine
time_of_day: night
cold_rate: 0
disguise_tag: null
music: mine_deep_drip
areas:
  - {id: cage_bottom, description: "Shaft bottom. The man-cage, a lamp niche, the bell wire up."}
  - {id: upper_gallery, description: "Long timbered tunnel with side stopes. Cracked props marked with chalk crosses. Abandoned carts."}
  - {id: side_stopes, description: "Three worked-out stopes off the gallery. Old tools, a miner's lunch tin, a shrine to the clan's luck-wolf."}
  - {id: pump_chamber, description: "Ladderway down to a chamber with three jammed hand-pumps feeding a wooden launder up the shaft. Dwarf-marks scratched beside them by Kettle years ago."}
  - {id: flooded_level, description: "Gallery flooded knee- to chest-deep. Floating timber. The sump at the far end: black water, drowner nest."}
  - {id: winze_head, description: "Top of a sloping winze at the far end of the flooded level, leading down."}
spawns:
  - {id: cage_bottom, area: cage_bottom, default: true}
  - {id: winze_top, area: winze_head, default: false}
  - {id: sump, area: flooded_level, default: false}
exits:
  - id: ride_up
    area: cage_bottom
    to_zone: zone.silver_mine_camp
    to_spawn: cage_top
    condition: "true"
    effects: []
  - id: down_winze
    area: winze_head
    to_zone: zone.silver_mine_breach
    to_spawn: winze_bottom
    condition: "true"
    effects: []
interactables:
  - id: pump_one
    area: pump_chamber
    kind: lever
    label: "Work the first pump"
    condition: "flag(flag.mine_pumps_cleared) and not flag(flag.mine_gallery_drained)"
    check: null
    once: true
    effects: ["set_flag(flag.mine_pump_1)"]
  - id: pump_two
    area: pump_chamber
    kind: lever
    label: "Work the second pump"
    condition: "flag(flag.mine_pump_1) and not flag(flag.mine_gallery_drained)"
    check: null
    once: true
    effects: ["set_flag(flag.mine_pump_2)"]
  - id: pump_three
    area: pump_chamber
    kind: lever
    label: "Work the third pump"
    condition: "flag(flag.mine_pump_2) and not flag(flag.mine_gallery_drained)"
    check: null
    once: true
    effects: ["set_flag(flag.mine_gallery_drained)", "play_beat(water_drops)"]
  - id: pump_marks
    area: pump_chamber
    kind: readable
    label: "Read the scratched marks by the pumps"
    condition: "true"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["set_flag(flag.mine_pump_order_known)"]
    fail_effects: []
  - id: pump_jam
    area: pump_chamber
    kind: search
    label: "Clear the jammed valves"
    condition: "not flag(flag.mine_pumps_cleared)"
    check: null
    once: true
    effects: ["set_flag(flag.mine_pumps_cleared)"]
  - id: luck_shrine
    area: side_stopes
    kind: search
    label: "Leave a coin at the luck-wolf shrine"
    condition: "crowns() >= 1"
    check: null
    once: true
    effects: ["add_crowns(-1)", "add_rep(faction.strept, 2)"]
  - id: lunch_tin
    area: side_stopes
    kind: container
    label: "Open the miner's lunch tin"
    condition: "true"
    check: null
    once: true
    effects: []
triggers:
  - id: rockfall_warning
    area: upper_gallery
    "on": enter
    source: null
    condition: "true"
    once: true
    effects: ["play_beat(dust_shiver)"]
  - id: drowners_wake
    area: flooded_level
    "on": enter
    source: null
    condition: "not flag(flag.mine_gallery_drained) and not flag(flag.mine_drowners_dealt)"
    once: false
    effects: ["start_encounter(enc.mine_drowners)"]
hazards:
  - {id: rockfall, area: upper_gallery, kind: collapse, params: {damage: 30, tell: "dust shiver 1.5 s before; on each knock peak", cover: "stand under sound props (no chalk cross)"}}
  - {id: flood_water, area: flooded_level, kind: deep_mud, active_when: "not flag(flag.mine_gallery_drained)", params: {speed_mult: 0.5}}
  - {id: sump_drop, area: flooded_level, kind: tide, params: {pull_back_damage: 15}}
checkpoints:
  - {id: shaft_bottom, area: cage_bottom}
  - {id: before_flood, area: pump_chamber}
beats:
  - {id: dust_shiver, description: "The knock comes, closer. Dust sifts from the props marked with chalk crosses. A fist of rock drops where the player was about to step."}
  - {id: water_drops, description: "The launder gurgles and runs. The flooded level drops to ankle depth. Pale shapes thrash in the shrinking sump, then slither away down a crack into the dark."}
npcs: []
encounters: [enc.mine_drowners]
loot:
  - {container: lunch_tin, items: [{item: item.poultice, count: 1}], condition: "true"}
variants:
  - id: meltwater
    when: "stage() >= 2"
    description: "Meltwater runs down the ladderway. The flooded level is deeper, and the knocking is faster."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: drained
    when: "flag(flag.mine_gallery_drained)"
    description: "Ankle-deep mud where the flood was. Bones of goats in the empty sump."
    npcs_absent: []
    encounters_disabled: [enc.mine_drowners]
    interactables_disabled: []
```

Pump puzzle: the pumps must be worked in order (one, two, three) after the jammed valves are cleared. The `condition` chain makes the order deterministic, so the puzzle is about knowing it. `flag.mine_pump_order_known` (Investigate 6 on Kettle's marks, or Kettle's own hint in `dlg.kettle_main`, or Dravin in the party) lights the right pump in the scene. Without the knowledge, the player can still find the order by trying (wrong pumps do nothing, because the conditions hide them). No check is required. Draining the level makes the drowners flee: the non-combat route. Walking into the flood first wakes them: the combat route.

```yaml zone
id: zone.silver_mine_breach
name: "The Breach"
kind: dungeon
map_node: map.silver_mine
time_of_day: night
cold_rate: 1
disguise_tag: null
music: breach_hammer_pulse
areas:
  - {id: winze_bottom, description: "Bottom of the winze. Raw rock gives way to a ragged hole in dressed basalt: the miners' break-in."}
  - {id: dwarven_passage, description: "Mortarless basalt passage, a floor channel with bronze fittings green with age. Faint warm air moving outward. Chiselled runes at shoulder height."}
  - {id: hammer_gallery, description: "A great iron hammer on a cam-shaft rises and falls against an anvil-block in a slot in the wall. Each blow shakes grit from the ceiling. Bronze gauges, one needle trembling in the red."}
  - {id: sapper_ledge, description: "Side ledge above the passage, where Choir sappers lay powder kegs and fuse-cord along the ceiling (stage 3+)."}
  - {id: bulkhead_stair, description: "Dwarven stair down, half-choked with rubble from the break-in. At the foot: a rune-carved bulkhead and the dark beyond."}
  - {id: rune_plate, description: "A brass plate set in the stair wall, runes worn by hands. Beside it, at stage 4, a dormant iron-warden stands like a statue."}
spawns:
  - {id: winze_bottom, area: winze_bottom, default: true}
  - {id: ledge, area: sapper_ledge, default: false}
  - {id: from_ostrel, area: bulkhead_stair}
  - {id: plate, area: rune_plate, default: false}
exits:
  - id: up_winze
    area: winze_bottom
    to_zone: zone.silver_mine_shafts
    to_spawn: winze_top
    condition: "true"
    effects: []
  - id: lower_halls
    area: bulkhead_stair
    to_zone: zone.ko_lower_halls
    to_spawn: mine_breach
    condition: "flag(flag.lower_breach_open) and act() == 3"
    effects: []
interactables:
  - id: hammer_housing
    area: hammer_gallery
    kind: search
    label: "Examine the hammer and its gauges"
    condition: "true"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["add_clue(clue.vault_knocking)"]
    fail_effects: []
  - id: rune_rubbing
    area: dwarven_passage
    kind: pickup
    label: "Take a charcoal rubbing of the runes"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.rune_rubbing, 1)"]
  - id: fuse_one
    area: sapper_ledge
    kind: search
    label: "Cut the first fuse-cord"
    condition: "stage() >= 3 and not flag(flag.mine_charges_cut)"
    check: null
    once: true
    effects: ["set_flag(flag.mine_fuse_1)"]
  - id: fuse_two
    area: sapper_ledge
    kind: search
    label: "Cut the second fuse-cord"
    condition: "stage() >= 3 and not flag(flag.mine_charges_cut)"
    check: null
    once: true
    effects: ["set_flag(flag.mine_fuse_2)"]
  - id: fuse_three
    area: bulkhead_stair
    kind: search
    label: "Cut the fuse-cord at the stair"
    condition: "stage() >= 3 and flag(flag.mine_fuse_1) and flag(flag.mine_fuse_2) and not flag(flag.mine_charges_cut)"
    check: null
    once: true
    effects: ["set_flag(flag.mine_charges_cut)", "complete_objective(quest.side_silver_mine, cut_charges)"]
  - id: quiet_warden_companion
    area: rune_plate
    kind: search
    label: "Have your companion read the rune plate"
    condition: "stage() >= 4 and not flag(flag.mine_warden_dealt) and (in_party(companion.maelis) or in_party(companion.dravin))"
    check: null
    once: true
    effects: ["set_flag(flag.mine_warden_dealt)", "play_beat(warden_sleeps)"]
  - id: quiet_warden_lore
    area: rune_plate
    kind: search
    label: "Press the runes in the order the wear shows"
    condition: "stage() >= 4 and not flag(flag.mine_warden_dealt)"
    check: {skill: lore, dc: 8}
    once: true
    effects: ["set_flag(flag.mine_warden_dealt)", "play_beat(warden_sleeps)"]
    fail_effects: ["play_beat(warden_wakes)", "start_encounter(enc.mine_stray_warden)"]
  - id: clear_rubble
    area: bulkhead_stair
    kind: search
    label: "Clear the rubble from the dwarven stair"
    condition: "not flag(flag.lower_breach_open) and (stage() < 3 or flag(flag.mine_charges_cut)) and (stage() < 4 or flag(flag.mine_warden_dealt))"
    check: null
    once: true
    effects: ["set_flag(flag.lower_breach_open)", "play_beat(stair_cleared)", "complete_objective(quest.side_silver_mine, open_breach)"]
  - id: sapper_pack
    area: sapper_ledge
    kind: container
    label: "Search the sappers' pack"
    condition: "true"
    check: null
    once: true
    effects: []
    fail_effects: []
triggers:
  - id: hammer_reveal
    area: hammer_gallery
    "on": enter
    source: null
    condition: "true"
    once: true
    effects: ["play_beat(hammer_seen)", "complete_objective(quest.side_silver_mine, find_source)"]
  - id: sappers_spot
    area: dwarven_passage
    "on": enter
    source: null
    condition: "stage() >= 3 and not flag(flag.mine_sappers_dealt)"
    once: false
    effects: ["play_beat(sappers_seen)"]
  - id: sappers_fight
    area: sapper_ledge
    "on": enter
    source: null
    condition: "stage() >= 3 and not flag(flag.mine_sappers_dealt) and not flag(flag.mine_charges_cut)"
    once: false
    effects: ["start_encounter(enc.mine_choir_sappers)"]
  - id: warden_approach
    area: bulkhead_stair
    "on": enter
    source: null
    condition: "stage() >= 4 and not flag(flag.mine_warden_dealt)"
    once: true
    effects: ["play_beat(warden_wakes)", "start_encounter(enc.mine_stray_warden)"]
hazards:
  - {id: hammer_shock, area: hammer_gallery, kind: collapse, params: {damage: 25, tell: "grit falls on each upswing", cover: "the slot alcoves"}}
  - {id: warm_vent, area: dwarven_passage, kind: steam, active_when: "stage() >= 3", params: {damage_per_second: 4}}
  - {id: stair_rubble, area: bulkhead_stair, kind: trap, params: {loose_footing: true}}
checkpoints:
  - {id: breach_entry, area: winze_bottom}
  - {id: before_sappers, area: dwarven_passage}
  - {id: before_warden, area: rune_plate}
beats:
  - {id: hammer_seen, description: "The knocking made visible: an iron hammer taller than a man rising on its cam and falling on the anvil-block. A gauge needle trembles in the red. Somewhere far below, something answers."}
  - {id: sappers_seen, description: "Lantern light on the side ledge. Two hooded men pack powder kegs against the ceiling. A third pays out fuse-cord down the passage toward the stair."}
  - {id: warden_wakes, description: "The statue by the plate lifts its head. Rune-light runs along its seams. Its shield comes up with a sound like a portcullis."}
  - {id: warden_sleeps, description: "The runes take the touch. The warden's seams go dark one by one. It lowers its shield and stands still."}
  - {id: stair_cleared, description: "The last block rolls aside. Cold dwarven air comes up the stair from the dark. The knocking is very loud now."}
npcs: []
encounters: [enc.mine_choir_sappers, enc.mine_stray_warden]
loot:
  - {container: sapper_pack, items: [{item: item.pale_feather, count: 1}, {item: item.poultice, count: 2}], condition: "flag(flag.mine_sappers_dealt)"}
variants:
  - id: choir_sappers
    when: "stage() >= 3 and not flag(flag.mine_charges_cut)"
    description: "Powder kegs packed along the ceiling, fuse-cord running down the passage. The vent breathes hot."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: warden_present
    when: "stage() >= 4 and not flag(flag.mine_warden_dealt)"
    description: "An iron-warden stands by the rune plate, dormant, rune seams faintly lit."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: breach_open
    when: "flag(flag.lower_breach_open)"
    description: "The stair is clear to the bulkhead. Strept props brace the break-in. A clan wolf-sign chalked on the basalt."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: [clear_rubble]
```

## 4. NPCs present
**Voice notes.**
- **Brannoc:** forty, broad, with a burn-scarred forearm and a slow, deliberate Strept burr. He measures every word as if it costs him. He hates Cintra with an old, tired hate (he lost a brother at Marnadal), but he hates hunger more. He never shouts. When he is angry he goes quiet and starts counting things. If the player wears Kosk's badge (`equipped(item.kosk_badge)`), his first line is a refusal to speak to "a Marshal's dog", and every Strept check in this file takes the badge's −2 (gdd §6.10).
- **Old Kettle:** seventy, toothless, half-blind, and happy. He worked the mine before Brannoc was born, and as a boy he once traded with a dwarf at the Ostrel gate. He reads dwarf-marks the way other old men read weather. He talks to the knocking like a neighbour ("there he goes again"). He gives answers sideways, as stories, and is always right.

```yaml npc
id: npc.brannoc
name: "Brannoc"
faction: faction.strept
role: "Foreman of the Strept silver mine"
motive: "Keep the mine working through the winter so his clan doesn't starve, and know what is knocking under it."
secret: "He sold a season's ore to an Attre buyer behind Hesk's back to feed the crew. If Hesk found out, he'd lose the mine."
disposition: wary
essential: true
dialogue: dlg.brannoc_main
barks: ["Mind the props with the chalk crosses.", "There it goes again. Count it.", "No Cintran ever came up here to give us anything.", "Half my men gone. The other half thinking about it."]
combat: null
shop: {stock: [{item: item.poultice, count: 4}], price_mod: 1.2}
```

```yaml npc
id: npc.old_kettle
name: "Old Kettle"
faction: faction.strept
role: "Oldest miner of the Strept mine; reads dwarf-marks"
motive: "See one more dwarf door before he dies."
secret: "The pump marks are his own, copied from a dwarf's slate he stole as a boy and never returned."
disposition: friendly
essential: true
dialogue: dlg.kettle_main
barks: ["There he goes. Regular as a heart.", "Dwarves never dug a thing without a reason.", "Wet feet, wet head, dead.", "My eyes are bad. My ears aren't."]
combat: null
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.brannoc_main
participants: [npc.brannoc, npc.old_kettle]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "quest_done(quest.side_silver_mine)", next: done_hub}
      - {if: "flag(flag.lower_breach_open)", next: report}
      - {if: "quest_active(quest.side_silver_mine)", next: hub}
    else: first
  first:
    type: line
    speaker: npc.brannoc
    text: "You're not clan and you're not ore-buyer. So you're lost, or you've come about the knocking. Most who come about the knocking are priests. I've no use for priests."
    direction: "At the forge hut table, sorting ore by lamplight. He does not stand."
    next: first_choice
  first_choice:
    type: choice
    options:
      - id: knocking
        text: "Tell me about the knocking."
        next: knocking
      - id: dravin_letter
        text: "A smith of Ostrel's gate-line wrote that the lower bolts are grinding loose. Read it. [Item: Dravin's dispatch]"
        tag: item
        condition: "has_item(item.dravin_letter)"
        show_locked: true
        next: letter
      - id: leave
        text: "Just passing."
        next: bye
  knocking:
    type: line
    speaker: npc.brannoc
    text: "Started at the end of summer. Under the deep level. Iron on iron, slow, like a smith who's tired. Props crack on the big ones. Half my crew's walked. I need it found, and named, so the rest go back down."
    next: offer
  letter:
    type: line
    speaker: npc.brannoc
    direction: "Reads it slowly, lips moving. Hands it back carefully, as if it might burn."
    text: "Dwarven iron-wax. Ostrel. So it's them, and it's not good. All right. Then you're the one to go down and look."
    effects: ["add_rep(faction.strept, 3)"]
    next: offer
  offer:
    type: line
    speaker: npc.brannoc
    text: "The cage is yours. Kettle knows the old marks; talk to him before you go below the pumps. Find what knocks. If it's a thing that dies, kill it. If it's a thing that doesn't, tell me what it is."
    effects: ["start_quest(quest.side_silver_mine)"]
    next: hub
  hub:
    type: choice
    options:
      - id: crew
        text: "Why did your men really quit?"
        next: crew
      - id: cintra
        text: "You don't like Cintrans much."
        next: cintra
      - id: shop
        text: "What can you spare?"
        effects: ["open_shop(npc.brannoc)"]
        next: bye
      - id: bye_opt
        text: "I'll go down."
        next: bye
  crew:
    type: line
    speaker: npc.brannoc
    text: "The knocking, and the drowners in the flooded level. Took Dafydd's leg off at the knee. Pale things that came up out of the sump when the tremors cracked it. Never had them up here before."
    next: hub
  cintra:
    type: line
    speaker: npc.brannoc
    text: "My brother burned in Dun Edra hall in '63. Your Marshal's torches. I like silver. Silver doesn't care where you're from."
    next: hub
  report:
    type: line
    speaker: npc.brannoc
    text: "You're back, and still in one piece. So. What knocks under my mine?"
    next: report_choice
  report_choice:
    type: choice
    options:
      - id: hammer
        text: "A dwarven hammer, venting pressure from Karak Ostrel's vaults. It's not coming for you. But it's straining. [Clue: Vault knocking]"
        tag: clue
        condition: "has_clue(clue.vault_knocking)"
        show_locked: true
        next: report_true
      - id: plain
        text: "Old dwarf-work, deep down. Your tunnel broke into it. It's machinery, not a monster."
        next: report_plain
  report_true:
    type: line
    speaker: npc.brannoc
    text: "A hammer. A hammer that's been knocking for four hundred years, and now it's tired. That's worse than a monster. Monsters you can kill."
    next: reward
  report_plain:
    type: line
    speaker: npc.brannoc
    text: "Machinery. Hm. Kettle will want to hear it from you. So will I, once I've thought about it."
    next: reward
  reward:
    type: line
    speaker: npc.brannoc
    text: "My men will go back down if I tell them it's a hammer. And that hole into the dwarf stair stays open and braced. If Cintra needs a way under the mountain, it's there. Not for Cintra. For whoever stops the knocking."
    effects: ["play_beat(miners_return)", "complete_objective(quest.side_silver_mine, report)"]
    next: reward_chart
  reward_chart:
    type: line
    speaker: npc.old_kettle
    text: "Here. I drew the way, from the winze to the bulkhead, and what the runes on the stair say, near enough. Take it to whoever goes in."
    effects: ["give_item(item.kettle_chart, 1)"]
    next: bye
  done_hub:
    type: choice
    options:
      - id: thanks
        text: "How is the mine?"
        next: done_line
      - id: shop2
        text: "What can you spare?"
        effects: ["open_shop(npc.brannoc)"]
        next: bye
      - id: bye2
        text: "Keep your props sound."
        next: bye
  done_line:
    type: line
    speaker: npc.brannoc
    text: "Working. The men count the knocks now, for luck. If it ever stops, I'll know you did something. Or it did."
    next: bye
  bye:
    type: end
```

Kettle speaks the `reward_chart` line. The Strept reward is in the quest's `outcome_effects`.

```yaml dialogue
id: dlg.kettle_main
participants: [npc.old_kettle]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "has_item(item.rune_rubbing) and not flag(flag.kettle_read_rubbing)", next: rubbing}
    else: open
  open:
    type: line
    speaker: npc.old_kettle
    text: "There he goes. Hear him? Regular as a heart. I've been listening to him all season. He's not angry. He's working."
    direction: "Rocking on his stool by the forge, eyes closed."
    next: hub
  hub:
    type: choice
    options:
      - id: pumps
        text: "Brannoc says you know the old marks by the pumps."
        next: pumps
      - id: dwarves
        text: "You've met a dwarf?"
        next: dwarves
      - id: drowners
        text: "What about the things in the flooded level?"
        next: drowners
      - id: bye_opt
        text: "Thank you, Kettle."
        next: bye
  pumps:
    type: line
    speaker: npc.old_kettle
    text: "One, then two, then three, like you'd count your fingers. Clear the valves first, they'll be choked with silt. I scratched the dwarf marks there myself, years back, so I'd never forget."
    effects: ["set_flag(flag.mine_pump_order_known)"]
    next: hub
  dwarves:
    type: line
    speaker: npc.old_kettle
    text: "One. I was eight. At the big gate before it shut for good. He traded me a slate of his marks for a hare. Grumpy as Brannoc. Said the mountain breathes, and the dwarves keep its breath for it."
    next: hub
  drowners:
    type: line
    speaker: npc.old_kettle
    text: "Wet feet, wet head, dead. Don't wade. Drain it. Pale things hate an empty sump more than a sword. They'll go down the crack they came up."
    next: hub
  rubbing:
    type: line
    speaker: npc.old_kettle
    direction: "Runs his fingers over the charcoal rubbing like a blind man reading a face."
    text: "Pressure. Relief. The second mark is 'breath', the third is 'hold'. It's a hammer that lets the mountain breathe out. And this one says 'nineteen'. Nineteen what, I couldn't tell you."
    effects: ["set_flag(flag.kettle_read_rubbing)", "add_clue(clue.vault_knocking)"]
    next: hub
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.mine_drowners
zone: zone.silver_mine_shafts
enemies:
  - {enemy: enemy.drowner, count: 3, spawn: sump, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: before_flood
avoidable_by: []
on_won: ["set_flag(flag.mine_drowners_dealt)"]
on_yielded: []
on_player_fled: []
```
Three drowners rise from the sump as the player wades into the flooded level. The deep water slows the player (deep mud hazard ×0.5), and the drowners' drag-grab pulls toward the sump drop. They are fought waist-deep in the dark, with floating timber as obstacles. **Non-combat alternative:** drain the level with the pumps first. The drowners flee and the encounter is disabled by the `drained` variant.

```yaml encounter
id: enc.mine_choir_sappers
zone: zone.silver_mine_breach
enemies:
  - {enemy: enemy.choir_zealot, count: 2, spawn: ledge, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: ledge, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: before_sappers
avoidable_by: []
on_won: ["set_flag(flag.mine_sappers_dealt)"]
on_yielded: ["set_flag(flag.mine_sappers_dealt)"]
on_player_fled: []
```
Stage 3 and above, on the sapper ledge. A zealot self-immolates at 0 HP (2 m fire burst). Near the packed powder kegs this is dangerous: if a zealot dies within 2 m of the kegs, the kegs on that ledge burn harmlessly (the fuses are what set the charges, not fire), but the fire burst still hurts the player. The stage 3 rule adds +1 Choir member. **Non-combat alternative:** sneak along the passage crouched (stealth, gdd §6.5: the passage is dark, so cones are 6 m) and cut the three fuse-cords without entering the ledge. Cutting all three sets `flag.mine_charges_cut` and the breach can be opened with the sappers still on their ledge. They notice when the stair rubble moves and come down to fight (the trigger re-checks `mine_sappers_dealt`), but the collapse threat is gone.

```yaml encounter
id: enc.mine_stray_warden
zone: zone.silver_mine_breach
enemies:
  - {enemy: enemy.iron_warden, count: 1, spawn: plate, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: before_warden
avoidable_by: []
on_won: ["set_flag(flag.mine_warden_dealt)"]
on_yielded: []
on_player_fled: []
```
Stage 4 (Act III) only. One dormant iron-warden by the rune plate. It has shield bash and rune overload, and its rune core is exposed 3 s after a stagger. `item.mane_cleaver` deals ×2. Blunt is effective. **Non-combat alternative:** quiet it with the rune plate: Maelis or Dravin in the party (no check), or Lore 8.

## 7. Items and clues

```yaml item
id: item.kettle_chart
name: "Kettle's chart of the breach"
category: document
description: "A miner's chart on scraped hide: the winze, the dwarven passage, the hammer gallery and the stair to the bulkhead, with Kettle's reading of the stair runes."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Cage to deep level. Pumps one-two-three, clear valves first. Winze at the flood's end, mind the sump. Dwarf hole at the bottom. Follow the channel. Big hammer: stay in the slots when it lifts. Stair down to the iron door. Runes on the door: 'breath', 'hold', 'lion', and one I don't know. Door won't open for a pick. Wants a key or a dwarf. Or someone who reads them better than me. K."
```

```yaml item
id: item.rune_rubbing
name: "Rune rubbing"
category: document
description: "A charcoal rubbing of the dwarven runes in the breach passage."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml clue
id: clue.vault_knocking
theory: theory.anselm_plan
title: "The knocking under the Strept mine"
text: "A dwarven pressure-hammer under the Amell, venting the deep vaults of Karak Ostrel. Its gauges sit in the red. The runes say 'breath', 'hold', and 'nineteen'. The locks are straining toward the end of their cycle."
supports: []
refutes: []
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: flag.lower_breach_open, type: bool, desc: "The Lower Halls breach into Karak Ostrel is open (Act III alternate entry, gdd §7.3)."}
  - {id: flag.mine_charges_cut, type: bool, desc: "All three Choir fuse-cords in the breach are cut."}
  - {id: flag.mine_gallery_drained, type: bool, desc: "The flooded level is pumped dry."}
  - {id: flag.mine_pump_1, type: bool, desc: "First pump worked."}
  - {id: flag.mine_pump_2, type: bool, desc: "Second pump worked."}
  - {id: flag.mine_pumps_cleared, type: bool, desc: "The pump valves were cleared of silt."}
  - {id: flag.mine_pump_order_known, type: bool, desc: "The player knows the pump order (Investigate 6 or Kettle)."}
  - {id: flag.mine_drowners_dealt, type: bool, desc: "The flooded-level drowners were killed."}
  - {id: flag.mine_sappers_dealt, type: bool, desc: "The Choir sappers were beaten or yielded."}
  - {id: flag.mine_fuse_1, type: bool, desc: "First fuse-cord cut."}
  - {id: flag.mine_fuse_2, type: bool, desc: "Second fuse-cord cut."}
  - {id: flag.mine_warden_dealt, type: bool, desc: "The stray iron-warden was quieted or destroyed."}
  - {id: flag.kettle_read_rubbing, type: bool, desc: "Kettle has read the rune rubbing."}
reads:
  - ms.act1_complete
  - item.dravin_letter
  - companion.maelis
  - companion.dravin
```


## 9. Quest hooks

```yaml quest
id: quest.side_silver_mine
kind: side
title: "The Knocking Below"
giver: npc.brannoc
available: "ms(ms.act1_complete)"
closes_on: null
xp: 550
stages:
  - id: go_down
    journal: "At the Strept silver mine above Dun Strept, the miners hear iron knocking under the deepest shafts. Foreman Brannoc wants it found and named."
    objectives:
      - {id: reach_breach, text: "Get past the flooded level", condition: "visited(zone.silver_mine_breach)", optional: false}
      - {id: drain, text: "Drain the flooded level", condition: "flag(flag.mine_gallery_drained)", optional: true, xp: 80}
    on_complete: []
    next: []
  - id: the_source
    journal: "The miners' tunnel has broken into dwarven stonework. The knocking is very close."
    objectives:
      - {id: find_source, text: "Find what is knocking", condition: "visited(zone.silver_mine_breach)", optional: false}
      - {id: understand, text: "Understand what the knocking means", condition: "has_clue(clue.vault_knocking)", optional: true, xp: 90}
      - {id: cut_charges, text: "Cut the Choir's fuse-cords", condition: "flag(flag.mine_charges_cut) or stage() < 3", optional: false}
      - {id: open_breach, text: "Clear the dwarven stair", condition: "flag(flag.lower_breach_open)", optional: false}
    on_complete: []
    next: []
  - id: tell_brannoc
    journal: "The stair to a dwarven bulkhead is clear. Brannoc is waiting to hear what knocks under his mine."
    objectives:
      - {id: report, text: "Report to Brannoc", condition: "flag(flag.lower_breach_open)", optional: false}
    on_complete: []
    next: []
outcome_effects:
  completed: ["add_rep(faction.strept, 10)"]
  failed: []
```

Note on `tell_brannoc/report`: its condition is the same as `open_breach`, so the stage completes at once and the quest completes the moment the breach is open. The Brannoc dialogue (`complete_objective(..., report)`) is then flavor plus the chart. Choice: the payoff must not depend on walking back up. The chart is a nice-to-have (it duplicates the rune reading for A06's bulkhead).

## 10. Rumors and event cards (optional)
Rumor r14 in `14-rumors.md` ("Strept miners hear iron hammering under the mountain") pins `map.silver_mine`. Rumor r05 ("the dwarves locked themselves inside") is thematically confirmed by Kettle's dwarf story.

## 11. Failure states and branches

```yaml branches
paths:
  - id: drain_then_go
    when: "Player clears the valves and works the pumps in order before wading."
    outcome: "Drowners flee; no fight; reach the breach."
    sets: ["set_flag(flag.mine_gallery_drained)"]
  - id: wade_and_fight
    when: "Player wades into the flooded level."
    outcome: "enc.mine_drowners; reach the breach."
    sets: ["set_flag(flag.mine_drowners_dealt)"]
  - id: stage3_fight_sappers
    when: "Stage 3+: player fights the sappers, then cuts the fuses."
    outcome: "flag.mine_charges_cut; breach can be cleared."
    sets: ["set_flag(flag.mine_sappers_dealt)", "set_flag(flag.mine_charges_cut)"]
  - id: stage3_sneak_fuses
    when: "Stage 3+: player sneaks the passage and cuts the three fuse-cords."
    outcome: "flag.mine_charges_cut without the ledge fight."
    sets: ["set_flag(flag.mine_charges_cut)"]
  - id: stage4_quiet_warden
    when: "Stage 4: Maelis or Dravin read the rune plate, or Lore 8."
    outcome: "Warden sleeps; breach can be cleared."
    sets: ["set_flag(flag.mine_warden_dealt)"]
  - id: stage4_fight_warden
    when: "Stage 4: the warden wakes (approach or failed Lore 8)."
    outcome: "enc.mine_stray_warden; breach can be cleared after."
    sets: ["set_flag(flag.mine_warden_dealt)"]
  - id: open
    when: "Player clears the stair rubble."
    outcome: "flag.lower_breach_open; quest complete; Strept +10; in Act III the bulkhead exit leads to zone.ko_lower_halls."
    sets: ["set_flag(flag.lower_breach_open)"]
failures:
  - id: player_dies
    result: reload_checkpoint
    recover: "Reload shaft_bottom, before_flood, breach_entry, before_sappers or before_warden."
  - id: rune_check_failed
    result: soft_fail
    recover: "Failed Lore 8 wakes the warden; defeating it gives the same result."
  - id: robbed_ore
    result: soft_fail
    recover: "Taking ore costs Strept -5. The quest is unaffected."
  - id: kosk_badge
    result: soft_fail
    recover: "Wearing Kosk's badge gives -2 to Strept checks. No check in this quest is required."
guarantees:
  - "Breach reachable without a check: drain by trying the pumps in order (no check), or wade and fight."
  - "flag.mine_charges_cut reachable without a check (cut the fuses; the sappers are a fight, not a check)."
  - "flag.mine_warden_dealt reachable without a check (fight the warden)."
  - "flag.lower_breach_open reachable without a check (clear_rubble)."
  - "clue.vault_knocking reachable without a check (take the rubbing to Kettle)."
```

## 12. Open questions
- The inner bulkhead from `zone.ko_lower_halls` into the Forge of Echoes needs Dravin or Maelis's rune reading (gdd §7.3). That is A06's zone. `item.kettle_chart` names the runes but does not open the door. A06 may choose to let the chart count as a third option. Not assumed here.
- The quest is available in Act II but the breach is only usable in Act III (`act() == 3` on the exit). In Act II the player sees the bulkhead and is told it won't open for picks. Confirm this is the intended reading of gdd §7.4 "Act II – III".
- Kettle's rune "nineteen" foreshadows the 19-year cycle. Lore only.
