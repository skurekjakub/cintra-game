---
section_id: side.travel_events
title: "Travel Events"
act: 1                                   # spans all acts; per-card `requires` gates act and stage
story_ref: "story.md §11 Daily Travel Table; gdd.md §6.3"
zones: [zone.arena_lowlands_1, zone.arena_lowlands_2, zone.arena_valley_1, zone.arena_valley_2, zone.arena_mountain_1, zone.arena_mountain_2]
available_when: "true"
escalation_stage_required: {min: 0, max: 4}
milestones_set: []
milestones_read: [ms.act1_complete, ms.act2_twist, ms.a2_wenna_line_resolved, ms.a2_tigg_resolved]
level_band: [1, 12]
---

# Travel Events

## 1. Scene summary
Every entry of the three terrain tables in story.md §11 and gdd.md §6.3, written as an `event_card`, plus the nine escalation-pool entries, the two forced hazard events on map edges, and the small arenas that travel fights load. A card is shown as a modal over the travel map (the game pauses, as in dialogue). An option that starts a fight loads the terrain's arena in real time. When the fight ends, the journey resumes and the party token arrives. Cards never cost time. They cost blood, crowns, reputation, or a consumable, and they pay out in clues, map pins, side-quest hooks, and small favours from the road.

## 2. Progress and escalation
- **Roll:** once per journey, on the chance in gdd §6.3. The d8 picks `table_slot` 1–7 on the route's majority terrain. A d8 of **8** draws from that terrain's escalation pool (`table_slot: esc`). The pool's first entry on each terrain is the story's slot 8.
- **Escalation rule:** at `stage() >= 2`, if the result is not already a pool entry, a d6 is rolled. On 1–2 the result is replaced by a random entry from the terrain's pool. Pool cards whose `requires` is false (for example `esc.m_stray_warden` below stage 4) are rerolled, as in gdd §6.3.
- **Rerolls:** a card whose `requires` is false, or the same card as the previous journey, is rerolled up to 3 times; then the road is quiet.
- **Stage flavour:** stage 3 adds one member to every Choir group (gdd §6.1, applied by the system, not by these cards). Stage 2 doubles the drowner weight on valley tables (system). Stage 4 uses mountain tables only (system). Cards below read `stage()` only where the text or options change.
- **Hooks:** L4 starts the Marnadal Watch hook, L5 the Brzezina hook, V7 the Rozrog hook, V4 can pin Rozrog or Vel Aram, V6 nudges the current Wenna objective, M5 and M7 give Act III verse-theory clues.
- **Recurring rival:** once `flag.drozd_rival` is set (side 04), lowlands slot 5 is taken by `event.l5_drozd_returns` instead of the tinker (see §12).
- No milestones are set here.

## 3. Location layout
Six small arenas, two per terrain, each about 40 × 40 m with cover on both flanks and a raised position. Every arena uses the same spawn ids so any travel encounter fits any arena of its terrain: `player` (default), `north_edge`, `south_edge`, `flank_left`, `flank_right`, `high_ground`. Arenas have no exits; when the encounter ends (won, yielded or fled), the journey resumes. Fleeing means walking off any edge of the arena outside combat range (8 m from the nearest enemy).

```yaml zone
id: zone.arena_lowlands_1
name: "King's Road, Sunken Lane"
kind: arena
map_node: null
time_of_day: dusk
cold_rate: 0
disguise_tag: null
music: road_skirmish
areas:
  - {id: lane, description: "A cart lane sunk shoulder-deep between hedgebanks; ruts full of brown water."}
  - {id: hedgebank_w, description: "Thorn hedge on a bank, waist-high cover, gaps every 6 m."}
  - {id: hedgebank_e, description: "The east bank, broken by a fallen ash that makes a ramp up."}
  - {id: milestone_rise, description: "A low rise by a lichened milestone reading 'CINTRA XII'. Clear sight down the lane."}
spawns:
  - {id: player, area: lane, default: true}
  - {id: north_edge, area: lane}
  - {id: south_edge, area: lane}
  - {id: flank_left, area: hedgebank_w}
  - {id: flank_right, area: hedgebank_e}
  - {id: high_ground, area: milestone_rise}
exits: []
interactables:
  - {id: abandoned_cart, area: lane, kind: container, label: "Search the overturned cart", condition: "true", check: null, once: true, effects: ["give_item(item.poultice, 1)"], fail_effects: []}
triggers: []
hazards:
  - {id: rut_mud, area: lane, kind: deep_mud, params: {speed_mult: 0.7}}
checkpoints:
  - {id: arena_start, area: lane}
beats: []
npcs: []
encounters: []
loot: []
variants:
  - {id: withered, when: "stage() >= 2", description: "The hedges are grey and leafless on the Amell side only.", npcs_absent: [], encounters_disabled: [], interactables_disabled: []}
```

```yaml zone
id: zone.arena_lowlands_2
name: "Mill Ford"
kind: arena
map_node: null
time_of_day: day
cold_rate: 0
disguise_tag: null
music: road_skirmish
areas:
  - {id: ford, description: "Knee-deep ford over gravel; the current pushes east."}
  - {id: mill_yard, description: "A burned watermill's yard: millstones and a collapsed wheel for cover."}
  - {id: reed_bank, description: "Reeds on the far side; poor footing, good concealment."}
  - {id: mill_loft, description: "The surviving loft floor, reached by a ladder. Overlooks the ford."}
spawns:
  - {id: player, area: mill_yard, default: true}
  - {id: north_edge, area: reed_bank}
  - {id: south_edge, area: mill_yard}
  - {id: flank_left, area: ford}
  - {id: flank_right, area: reed_bank}
  - {id: high_ground, area: mill_loft}
exits: []
interactables:
  - {id: mill_strongbox, area: mill_loft, kind: container, label: "Prise open the miller's box", condition: "true", check: {skill: investigate, dc: 4}, once: true, effects: ["add_crowns(12)"], fail_effects: []}
triggers: []
hazards:
  - {id: ford_current, area: ford, kind: deep_mud, params: {speed_mult: 0.6}}
checkpoints:
  - {id: arena_start, area: mill_yard}
beats: []
npcs: []
encounters: []
loot: []
variants: []
```

```yaml zone
id: zone.arena_valley_1
name: "Marnadal Shallows"
kind: arena
map_node: null
time_of_day: dusk
cold_rate: 0
disguise_tag: null
music: valley_skirmish
areas:
  - {id: shingle, description: "A shingle bar in the Marnadal, dry footing in a strip 6 m wide."}
  - {id: shallows, description: "Thigh-deep brown water on both sides of the bar. Drowners rise from here."}
  - {id: willow_bank, description: "Undercut bank with leaning willows; roots for cover."}
  - {id: boulder, description: "A flat boulder 2 m high in midstream, reachable by a jump from the shingle."}
spawns:
  - {id: player, area: shingle, default: true}
  - {id: north_edge, area: shallows}
  - {id: south_edge, area: shallows}
  - {id: flank_left, area: willow_bank}
  - {id: flank_right, area: shallows}
  - {id: high_ground, area: boulder}
exits: []
interactables:
  - {id: drowned_pack, area: willow_bank, kind: search, label: "Search the snagged pack", condition: "true", check: null, once: true, effects: ["give_item(item.crossbow_bolts, 6)"], fail_effects: []}
triggers: []
hazards:
  - {id: deep_water, area: shallows, kind: deep_mud, params: {speed_mult: 0.5}}
checkpoints:
  - {id: arena_start, area: shingle}
beats: []
npcs: []
encounters: []
loot: []
variants:
  - {id: dark_river, when: "stage() >= 2", description: "The water runs grey-black with silt; visibility into the shallows drops to nothing.", npcs_absent: [], encounters_disabled: [], interactables_disabled: []}
```

```yaml zone
id: zone.arena_valley_2
name: "Pinewood Clearing"
kind: arena
map_node: null
time_of_day: day
cold_rate: 0
disguise_tag: null
music: valley_skirmish
areas:
  - {id: clearing, description: "A trampled clearing around a charcoal clamp gone cold."}
  - {id: pine_ring, description: "Close-set pines around the clearing; trunks block crossbow lines."}
  - {id: deadfall, description: "A tangle of storm-felled pines; slow to cross, full cover."}
  - {id: rock_shelf, description: "A mossy shelf on the north side, 1.5 m up."}
spawns:
  - {id: player, area: clearing, default: true}
  - {id: north_edge, area: rock_shelf}
  - {id: south_edge, area: pine_ring}
  - {id: flank_left, area: deadfall}
  - {id: flank_right, area: pine_ring}
  - {id: high_ground, area: rock_shelf}
exits: []
interactables: []
triggers: []
hazards:
  - {id: clamp_embers, area: clearing, kind: fire, params: {damage_per_second: 3}}
checkpoints:
  - {id: arena_start, area: clearing}
beats: []
npcs: []
encounters: []
loot: []
variants: []
```

```yaml zone
id: zone.arena_mountain_1
name: "Switchback"
kind: arena
map_node: null
time_of_day: day
cold_rate: 1
disguise_tag: null
music: mountain_skirmish
areas:
  - {id: lower_bend, description: "The lower hairpin of a goat track, 5 m wide, sheer drop on the outer edge."}
  - {id: upper_bend, description: "The next hairpin up, 4 m above; sharpshooters' favourite perch."}
  - {id: scree_slope, description: "Loose scree joining the bends; climbable at half speed."}
  - {id: shepherd_hut, description: "A roofless stone hut on the lower bend; a fire pit (warmth)."}
spawns:
  - {id: player, area: lower_bend, default: true}
  - {id: north_edge, area: upper_bend}
  - {id: south_edge, area: lower_bend}
  - {id: flank_left, area: scree_slope}
  - {id: flank_right, area: shepherd_hut}
  - {id: high_ground, area: upper_bend}
exits: []
interactables: []
triggers: []
hazards:
  - {id: edge_drop, area: lower_bend, kind: trap, params: {fall: true}}
  - {id: loose_scree, area: scree_slope, kind: collapse, params: {damage: 15}}
  - {id: thin_air_cold, area: upper_bend, kind: cold, params: {chill_rate: 2}}
checkpoints:
  - {id: arena_start, area: lower_bend}
beats: []
npcs: []
encounters: []
loot: []
variants:
  - {id: snowed, when: "stage() >= 2", description: "Knee-deep snow on both bends; cold_rate doubles outside the hut.", npcs_absent: [], encounters_disabled: [], interactables_disabled: []}
```

```yaml zone
id: zone.arena_mountain_2
name: "Ice-Bridge Gorge"
kind: arena
map_node: null
time_of_day: dawn
cold_rate: 2
disguise_tag: null
music: mountain_skirmish
areas:
  - {id: near_lip, description: "The near lip of a gorge; boulders for cover."}
  - {id: ice_bridge, description: "A natural ice arch 3 m wide and 20 m long; slick, creaks under weight."}
  - {id: far_lip, description: "The far lip, an overhang with icicles."}
  - {id: under_arch, description: "A ledge under the bridge where trolls lie up. Reached by a crack in the near lip."}
spawns:
  - {id: player, area: near_lip, default: true}
  - {id: north_edge, area: far_lip}
  - {id: south_edge, area: near_lip}
  - {id: flank_left, area: under_arch}
  - {id: flank_right, area: ice_bridge}
  - {id: high_ground, area: far_lip}
exits: []
interactables:
  - {id: frozen_climber, area: under_arch, kind: search, label: "Search the frozen climber", condition: "true", check: null, once: true, effects: ["give_item(item.frost_tallow, 1)"], fail_effects: []}
triggers: []
hazards:
  - {id: slick_ice, area: ice_bridge, kind: trap, params: {slide: true}}
  - {id: falling_icicles, area: far_lip, kind: collapse, params: {damage: 20}}
checkpoints:
  - {id: arena_start, area: near_lip}
beats: []
npcs: []
encounters: []
loot: []
variants: []
```

## 4. NPCs present
Only two travel NPCs need blocks. Every other figure on a card is described in the card text.

**Voice notes.** Wat Mabry: a Cintran yeoman's flat vowels, sullen and quick to justify himself ("Pay stopped. You'd have walked too."). Ivena Drozd: see side 04; on the road she is amused and precise, and never raises her voice.

```yaml npc
id: npc.deserter_wat
name: "Wat Mabry"
faction: null
role: "Deserter from Marnadal Watch, selling garrison gear by the roadside"
motive: "Turn stolen kit into enough coin to get downriver and vanish."
secret: "He left the squire Tobin alone in the tower and is ashamed of it."
disposition: wary
essential: false
dialogue: null
barks: ["Good Crown steel. Barely bled on.", "Don't ask where it's from and I won't ask where you're going.", "Bolts, a buckler, a brigandine. Make an offer."]
combat: enemy.bandit
shop: {stock: [{item: item.crossbow_bolts, count: 20}, {item: item.poultice, count: 3}, {item: item.watch_brigandine, count: 1}], price_mod: 0.8}
```

```yaml item
id: item.watch_brigandine
name: "Marnadal Watch brigandine"
category: armor
description: "Riveted plates under faded Crown blue. The garrison number has been scratched off the collar."
price: 140
stack_max: 1
equip_slot: armor
weapon: null
armor: {armor: 22, resist: {cold: 0.9}}
consumable: null
readable_text: null
```

## 5. Dialogue trees
Travel cards carry their own options (§10). No dialogue trees here.

## 6. Encounters
All travel encounters use `zone: "arena:<terrain>"`; the system picks one of the terrain's two arenas. Travel XP is ×0.5 (system). Enemies flee when 70% of the group is down (system). `avoidable_by` lists the card that can skip the fight.

```yaml encounter
id: enc.travel_tax_bailiffs
zone: "arena:lowlands"
enemies:
  - {enemy: enemy.bandit, count: 3, spawn: north_edge, variant: crown_bailiff}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: arena_start
avoidable_by: ["event.l1_tax_collectors"]
on_won: ["add_rep(faction.crown, -5)"]
on_yielded: ["add_rep(faction.crown, -2)", "add_crowns(20)"]
on_player_fled: []
```

```yaml encounter
id: enc.travel_pilgrim_spy
zone: "arena:lowlands"
enemies:
  - {enemy: enemy.choir_cutthroat, count: 1, spawn: flank_left, variant: null}
  - {enemy: enemy.choir_thug, count: 2, spawn: south_edge, variant: pilgrim}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: arena_start
avoidable_by: ["event.l2_pilgrims_feather"]
on_won: ["give_item(item.pale_feather, 1)"]
on_yielded: ["give_item(item.pale_feather, 1)", "add_clue(clue.pilgrim_feather)"]
on_player_fled: []
```

```yaml encounter
id: enc.travel_lily_wagon
zone: "arena:lowlands"
enemies:
  - {enemy: enemy.bandit, count: 3, spawn: north_edge, variant: attre_smuggler}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: arena_start
avoidable_by: ["event.l3_lily_wagon"]
on_won: ["set_flag(flag.lily_wagon_searched)", "add_crowns(25)"]
on_yielded: ["set_flag(flag.lily_wagon_searched)"]
on_player_fled: []
```

```yaml encounter
id: enc.travel_highwaymen
zone: "arena:lowlands"
enemies:
  - {enemy: enemy.bandit, count: 1, spawn: high_ground, variant: disgraced_knight}
  - {enemy: enemy.bandit, count: 3, spawn: flank_left, variant: highwayman}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: arena_start
avoidable_by: ["event.l7_disgraced_knight"]
on_won: ["add_crowns(40)"]
on_yielded: ["add_crowns(40)", "add_rep(faction.crown, 2)"]
on_player_fled: []
```

```yaml encounter
id: enc.travel_knight_duel
zone: "arena:lowlands"
enemies:
  - {enemy: enemy.bandit, count: 1, spawn: north_edge, variant: disgraced_knight}
waves: []
attack_tokens: 1
allow_yield: true
allies: []
checkpoint: arena_start
avoidable_by: []
on_won: ["set_flag(flag.knight_duel_won)", "add_crowns(40)"]
on_yielded: ["set_flag(flag.knight_duel_won)", "add_crowns(40)", "add_rumor(rumor.r15_watch_deserted)"]
on_player_fled: []
```

```yaml encounter
id: enc.travel_ferry_toll
zone: "arena:valley"
enemies:
  - {enemy: enemy.bandit, count: 3, spawn: north_edge, variant: ferryman}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: arena_start
avoidable_by: ["event.v1_ferry_toll"]
on_won: ["add_rep(faction.ferrymen, -10)"]
on_yielded: ["add_rep(faction.ferrymen, -5)"]
on_player_fled: []
```

```yaml encounter
id: enc.travel_revenant_patrol
zone: "arena:valley"
enemies:
  - {enemy: enemy.revenant_footman, count: 3, spawn: north_edge, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: arena_start
avoidable_by: ["event.v2_revenant_patrol"]
on_won: []
on_yielded: []
on_player_fled: []
```

```yaml encounter
id: enc.travel_wolves
zone: "arena:valley"
enemies:
  - {enemy: enemy.wolf, count: 4, spawn: flank_left, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: arena_start
avoidable_by: ["event.v3_starving_wolves"]
on_won: []
on_yielded: []
on_player_fled: []
```

```yaml encounter
id: enc.travel_drowners
zone: "arena:valley"
enemies:
  - {enemy: enemy.drowner, count: 3, spawn: south_edge, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: arena_start
avoidable_by: ["event.v5_drowner_shallows"]
on_won: []
on_yielded: []
on_player_fled: []
```

```yaml encounter
id: enc.travel_strept_scouts
zone: "arena:mountain"
enemies:
  - {enemy: enemy.bandit, count: 3, spawn: high_ground, variant: strept_scout}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: arena_start
avoidable_by: ["event.m2_strept_scouts"]
on_won: ["add_rep(faction.strept, -20)"]
on_yielded: ["add_rep(faction.strept, -10)"]
on_player_fled: []
```

```yaml encounter
id: enc.travel_frost_troll
zone: "arena:mountain"
enemies:
  - {enemy: enemy.frost_troll, count: 1, spawn: flank_left, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: arena_start
avoidable_by: ["event.m3_frost_troll"]
on_won: []
on_yielded: []
on_player_fled: []
```

```yaml encounter
id: enc.travel_choir_rearguard
zone: "arena:mountain"
enemies:
  - {enemy: enemy.choir_zealot, count: 2, spawn: south_edge, variant: null}
  - {enemy: enemy.choir_sharpshooter, count: 1, spawn: high_ground, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: arena_start
avoidable_by: ["event.m6_choir_rearguard"]
on_won: ["give_item(item.pale_feather, 1)"]
on_yielded: ["give_item(item.pale_feather, 1)"]
on_player_fled: []
```

```yaml encounter
id: enc.travel_drozd_ambush
zone: "arena:lowlands"
enemies:
  - {enemy: enemy.bandit, count: 3, spawn: flank_left, variant: sodden_retainer}
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: high_ground, variant: sodden}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: arena_start
avoidable_by: ["event.l5_drozd_returns"]
on_won: ["add_crowns(30)"]
on_yielded: ["add_crowns(30)"]
on_player_fled: []
```

```yaml encounter
id: enc.esc_feather_proclaimers
zone: "arena:lowlands"
enemies:
  - {enemy: enemy.choir_zealot, count: 3, spawn: north_edge, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: arena_start
avoidable_by: ["esc.l_feather_proclamations"]
on_won: ["give_item(item.pale_feather, 1)", "add_rep(faction.crown, 3)"]
on_yielded: ["give_item(item.pale_feather, 1)", "add_rep(faction.crown, 3)"]
on_player_fled: []
```

```yaml encounter
id: enc.esc_drowner_swarm
zone: "arena:valley"
enemies:
  - {enemy: enemy.drowner, count: 3, spawn: south_edge, variant: null}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.drowner, count: 2, spawn: north_edge, variant: null}]}
attack_tokens: null
allow_yield: false
allies: []
checkpoint: arena_start
avoidable_by: ["esc.v_drowner_swarm"]
on_won: []
on_yielded: []
on_player_fled: []
```

```yaml encounter
id: enc.esc_blight_wagon
zone: "arena:valley"
enemies:
  - {enemy: enemy.choir_zealot, count: 2, spawn: north_edge, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: arena_start
avoidable_by: ["esc.v_blight_wagon"]
on_won: ["give_item(item.fire_oil, 2)"]
on_yielded: ["give_item(item.fire_oil, 2)"]
on_player_fled: []
```

```yaml encounter
id: enc.esc_stray_warden
zone: "arena:mountain"
enemies:
  - {enemy: enemy.iron_warden, count: 1, spawn: north_edge, variant: stray}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: arena_start
avoidable_by: ["esc.m_stray_warden"]
on_won: ["add_xp(75)"]
on_yielded: []
on_player_fled: []
```

Level-design note for `enc.esc_blight_wagon`: the wagon sits in the arena's centre, burning. It is a `fire` hazard (5 dmg/s within 3 m) for the whole fight, and the cask bursts after the second zealot falls, spreading the hazard to 5 m. The zealots' self-immolation at 0 HP (gdd §6.7) can chain into it.

## 7. Items and clues
`item.watch_brigandine` is declared in §4 (sold by Wat).

```yaml clue
id: clue.pilgrim_feather
theory: theory.choir
title: "A feather among the pilgrims"
text: "A 'pilgrim' bound for St. Corwen had a pale gull feather sewn inside his boot. The Choir walks the Abbey road in plain sight."
supports: [anselm]
refutes: []
```

```yaml clue
id: clue.cairn_marker
theory: theory.fourth_verse
title: "The dwarf's cairn"
text: "A dwarven ghost pointed me to a cairn cut with nineteen notches and a lion's paw. Under it: a cache, and a slate repeating the Pact's count of nineteen winters. The dwarves kept the cycle too."
supports: []
refutes: []
```

```yaml clue
id: clue.shrine_oath_line
theory: theory.fourth_verse
title: "Oath line on a mountain shrine"
text: "A crumbling shrine on the Amell road has a line of the Oath cut into its lintel: '...Till nineteen winters turn to light.' Old chisel work, older than any Abbey copy."
supports: []
refutes: []
```

## 8. Flags set and read
```yaml flags
declare:
  - {id: flag.marnadal_watch_hook, type: bool, desc: "Marnadal Watch side-quest hook started (deserter card L4 or rumor r15)."}
  - {id: flag.brzezina_hook, type: bool, desc: "Brzezina side-quest hook started (Sodden tinker card L5 or rumor r18)."}
  - {id: flag.rozrog_hook, type: bool, desc: "Rozrog side-quest hook started (woodwose totems V7, burners V4, or rumor r17)."}
  - {id: flag.lily_wagon_searched, type: bool, desc: "The Attre lily wagon (L3) has been dealt with; the card no longer appears."}
  - {id: flag.pilgrim_spy_exposed, type: bool, desc: "The Choir spy among the pilgrims (L2) was exposed."}
  - {id: flag.knight_duel_won, type: bool, desc: "Beat Ser Gaudric Vell in single combat (L7)."}
  - {id: flag.cairn_cache_taken, type: bool, desc: "The dwarven cairn cache (M5) was taken; the card no longer appears."}
  - {id: flag.shrine_oath_found, type: bool, desc: "The Oath shrine (M7) was read; the card no longer appears."}
  - {id: flag.blue_fires_active, type: bool, desc: "esc.m_blue_fires: warmth sources give no warmth in the arrival zone. The arrival zone clears it on exit (see §12)."}
  - {id: flag.drozd_road_met, type: bool, desc: "Drozd's road encounter (L5 rival variant) has happened."}
reads:
  - flag.wenna_bulbs_asked
  - var.bulbs_recovered
  - flag.strept_guides
  - flag.torc_rite_known
  - flag.roost_resolved
  - flag.drozd_rival
  - flag.woodwose_peace
  - flag.woodwose_dead
  - flag.jory_crossing_granted
  - flag.queen_reading_known
  - flag.choir_list_exposed
```

## 9. Quest hooks
No quest stages. Cards start side-quest hooks through `flag.marnadal_watch_hook`, `flag.brzezina_hook` and `flag.rozrog_hook`, and map pins. The side quests' `available` conditions read these flags.

## 10. Rumors and event cards

### 10.1 Lowlands & King's Roads

```yaml event_card
id: event.l1_tax_collectors
terrain: lowlands
table_slot: 1
requires: "true"
title: "Tax collectors at the ford"
text: "Two royal bailiffs and a clerk have a widow by the arm. Her goat is already tied to their cart. 'Crown levy, mistress. Hearth-tax and bridge-tax, and the Chancellor's new road-tax besides.'"
options:
  - {id: show_writ, text: "Show the Marshal's writ. 'The Lord Marshal wants this road quiet.' [Item: Marshal's writ]", tag: item, condition: "has_item(item.kosk_writ)", effects: ["add_xp(30)", "add_rep(faction.varn, -2)"], next: null}
  - {id: intervene, text: "Stand between them and the widow. [Intimidate 6]", tag: intimidate, check: {skill: intimidate, dc: 6, pass_effects: ["add_rep(faction.crown, -2)", "add_xp(30)"], fail_effects: ["start_encounter(enc.travel_tax_bailiffs)"]}, next: null}
  - {id: ledger, text: "'Road-tax? Show me the Chancellor's seal on that.' [Investigate 6]", tag: investigate, check: {skill: investigate, dc: 6, pass_effects: ["add_xp(30)", "add_rumor(rumor.r02_varn_ledgers)"], fail_effects: []}, next: null}
  - {id: pay, text: "Pay the widow's levy. [Bribe 15]", tag: bribe, bribe: 15, effects: ["add_xp(15)", "add_rep(faction.crown, 1)"], next: null}
  - {id: fight, text: "Draw steel.", effects: ["start_encounter(enc.travel_tax_bailiffs)"], next: null}
  - {id: ignore, text: "Ride on. It isn't your goat.", next: null}
combat: enc.travel_tax_bailiffs
```
*Investigate pass text:* the clerk stammers that the road-tax "goes to the Chancellor's own strongbox, not the treasury". The card adds rumor 2 (gdd §6.18: the late route to `clue.varn_ledgers`).

```yaml event_card
id: event.l2_pilgrims_feather
terrain: lowlands
table_slot: 2
requires: "not flag(flag.pilgrim_spy_exposed)"
title: "Pilgrims bound for St. Corwen"
text: "A dozen pilgrims trudge toward the Abbey, singing the Lion's hymn off-key. One of them, a broad man with soldier's hands, does not sing. He watches you instead."
options:
  - {id: watch, text: "Walk alongside and watch the quiet one. [Investigate 5]", tag: investigate, check: {skill: investigate, dc: 5, pass_effects: ["set_flag(flag.pilgrim_spy_exposed)", "add_clue(clue.pilgrim_feather)", "give_item(item.pale_feather, 1)"], fail_effects: []}, next: null}
  - {id: accuse, text: "'You. Show me your boots.' Force the issue.", effects: ["set_flag(flag.pilgrim_spy_exposed)", "start_encounter(enc.travel_pilgrim_spy)"], next: null}
  - {id: bread, text: "Share bread and walk with them a while.", effects: ["add_rep(faction.abbey, 2)", "add_rumor(rumor.r04_living_saint)"], next: null}
  - {id: pass, text: "Let them pass.", next: null}
combat: enc.travel_pilgrim_spy
```
*Investigate pass text:* when he stoops to fix a boot-lace you see it: a pale gull feather stitched into the lining. He sees you see it, and he runs into the hedges, dropping the feather.

```yaml event_card
id: event.l3_lily_wagon
terrain: lowlands
table_slot: 3
requires: "ms(ms.a1_audience_done) and not flag(flag.lily_wagon_searched)"
title: "An Attre wagon, riding heavy"
text: "A wagon with Attre's gull-and-anchor on the tailboard is stuck to the axles. Three drivers too well armed for wool. The load smells of damp earth and something sweet underneath."
options:
  - {id: bulbs_for_wenna, text: "Help dig it out, and look under the sacking for Wenna's bulbs. [Investigate 5]", tag: investigate, condition: "flag(flag.wenna_bulbs_asked) and not ms(ms.a2_wenna_line_resolved)", check: {skill: investigate, dc: 5, pass_effects: ["set_flag(flag.lily_wagon_searched)", "add_var(var.bulbs_recovered, 1)", "give_item(item.grey_lily_bulbs, 1)", "add_xp(45)"], fail_effects: ["start_encounter(enc.travel_lily_wagon)"]}, next: null}
  - {id: search, text: "'Crown inspection.' Lift the sacking. [Intimidate 6]", tag: intimidate, check: {skill: intimidate, dc: 6, pass_effects: ["set_flag(flag.lily_wagon_searched)", "add_xp(30)", "add_rep(faction.attre, -3)"], fail_effects: ["start_encounter(enc.travel_lily_wagon)"]}, next: null}
  - {id: pay_look, text: "Pay them to let you look. [Bribe 30]", tag: bribe, bribe: 30, effects: ["set_flag(flag.lily_wagon_searched)", "add_xp(20)"], next: null}
  - {id: fight, text: "Take the wagon.", effects: ["start_encounter(enc.travel_lily_wagon)"], next: null}
  - {id: leave, text: "Leave them to their mud.", next: null}
combat: enc.travel_lily_wagon
```
*Pass text (search or bribe without the Wenna line):* pale bulbs packed in wet moss, a dozen sacks of them, stamped for "the Peixe house". You have seen what grey lily does. *With the Wenna line active:* one sack is tied with a witch's knot of red thread: Wenna's own harvest. You take it.
If the encounter starts from the Wenna option's failure, the bulb sack can be taken from the wagon after the fight: `enc.travel_lily_wagon.on_won` does not add the bulb, so a dedicated `pickup` is placed on the arena's cart when `flag(flag.wenna_bulbs_asked)`; see §12.

```yaml event_card
id: event.l4_watch_deserter
terrain: lowlands
table_slot: 4
requires: "true"
title: "A deserter selling Crown steel"
text: "A man in a Crown-blue brigandine with the badge cut off has laid out bolts and a buckler on a cloak. 'Marnadal Watch kit. Good steel. Pay stopped, so I stopped.'"
options:
  - {id: shop, text: "Look over his wares.", effects: ["open_shop(npc.deserter_wat)"], next: null}
  - {id: ask, text: "'Who's holding the Watch now?'", effects: ["set_flag(flag.marnadal_watch_hook)", "add_map_pin(map.marnadal_watch)", "add_rumor(rumor.r15_watch_deserted)"], next: null}
  - {id: shame, text: "'You left a boy up there alone.' [Persuade 6]", tag: persuade, check: {skill: persuade, dc: 6, pass_effects: ["set_flag(flag.marnadal_watch_hook)", "add_map_pin(map.marnadal_watch)", "give_item(item.crossbow_bolts, 10)", "add_xp(30)"], fail_effects: ["set_flag(flag.marnadal_watch_hook)"]}, next: null}
  - {id: seize, text: "'That's Crown property. Hand it over.' [Intimidate 6]", tag: intimidate, check: {skill: intimidate, dc: 6, pass_effects: ["give_item(item.watch_brigandine, 1)", "set_flag(flag.marnadal_watch_hook)", "add_rep(faction.crown, 2)"], fail_effects: []}, next: null}
  - {id: leave, text: "Ride on.", next: null}
combat: null
```
*Persuade pass text:* "Tobin. Squire Tobin Ashe. Fourteen and too stupid to run." He shoves his bolts at you. "Give him those. Tell him... don't tell him anything."

```yaml event_card
id: event.l5_sodden_tinker
terrain: lowlands
table_slot: 5
requires: "not flag(flag.drozd_rival)"
title: "A tinker with fen-mud on his boots"
text: "A tinker mends pots at a crossroads shrine. His tools are Cintran. His boots are caked in black fen-mud, and he counts the soldiers on the road under his breath."
options:
  - {id: read, text: "Watch his hands and his eyes. [Investigate 6]", tag: investigate, check: {skill: investigate, dc: 6, pass_effects: ["set_flag(flag.brzezina_hook)", "add_map_pin(map.brzezina_woods)", "add_rumor(rumor.r18_brzezina_lodge)", "add_xp(40)"], fail_effects: []}, next: null}
  - {id: chat, text: "Ask him where he's bound.", effects: ["add_rumor(rumor.r10_sodden_spears)"], next: null}
  - {id: buy, text: "Buy a mended flask off him. [Bribe 10]", tag: bribe, bribe: 10, effects: ["give_item(item.poultice, 1)"], next: null}
  - {id: leave, text: "Leave him to his pots.", next: null}
combat: null
```
*Investigate pass text:* tucked in his tool-roll is a birch-bark tally with Sodden numerals and a sketch of a hunting lodge. "Brzezina," he says when you hold it up, too fast. "I mend pots there. For the Baron."

```yaml event_card
id: event.l5_drozd_returns
terrain: lowlands
table_slot: 5
requires: "flag(flag.drozd_rival) and not flag(flag.drozd_road_met)"
title: "A lady's carriage, waiting"
text: "A black carriage stands across the road, horses steaming. Ivena Drozd leans out of the window. 'There you are. You cost me a baron. I've come to see what you cost.' Men step out of the birches."
options:
  - {id: talk, text: "'You came all this way to talk?' [Persuade 6]", tag: persuade, check: {skill: persuade, dc: 6, pass_effects: ["set_flag(flag.drozd_road_met)", "add_rumor(rumor.r10_sodden_spears)", "add_xp(60)"], fail_effects: ["set_flag(flag.drozd_road_met)", "start_encounter(enc.travel_drozd_ambush)"]}, next: null}
  - {id: threaten, text: "'Call them off or I start with the coachman.' [Intimidate 8]", tag: intimidate, check: {skill: intimidate, dc: 8, pass_effects: ["set_flag(flag.drozd_road_met)", "add_xp(60)"], fail_effects: ["set_flag(flag.drozd_road_met)", "start_encounter(enc.travel_drozd_ambush)"]}, next: null}
  - {id: fight, text: "Draw on the nearest man.", effects: ["set_flag(flag.drozd_road_met)", "start_encounter(enc.travel_drozd_ambush)"], next: null}
combat: enc.travel_drozd_ambush
```
*Persuade pass text:* she laughs. "I wanted to know if you were bought. You aren't. How rare, and how expensive for you." She tells you, as a gift, that Sodden has only scouts on the border, because Sodden is waiting to see who wins. The carriage leaves. Every option here ends the card; the fight option has no condition and no check, so it is the card's safe exit. Drozd herself never fights: she drives off when the fight begins.

```yaml event_card
id: event.l6_harvest_supper
terrain: lowlands
table_slot: 6
requires: "true"
title: "A harvest supper"
text: "A village has trestles out on the green: pease pudding, cider, a pig on a spit. 'Sit, stranger. There's beds in the tithe barn, and nobody's asking your business.'"
options:
  - {id: stay_a1, text: "Eat, drink, and listen.", condition: "act() == 1", effects: ["heal_player(full)", "add_rumor(rumor.r05_dwarves_inside)"], next: null}
  - {id: stay_a2, text: "Eat, drink, and listen.", condition: "act() >= 2 and stage() < 3", effects: ["heal_player(full)", "add_rumor(rumor.r08_new_moon_dead)"], next: null}
  - {id: stay_a3, text: "Eat what they can spare, and listen.", condition: "stage() >= 3", effects: ["heal_player(full)", "add_rumor(rumor.r09_aldric_dwarven)"], next: null}
  - {id: give, text: "Leave coin for the widows' table. [Bribe 10]", tag: bribe, bribe: 10, effects: ["heal_player(full)", "add_rep(faction.crown, 2)"], next: null}
  - {id: decline, text: "Thank them and push on.", next: null}
combat: null
```
At stage 3 the text changes in presentation only: half the trestles are empty, "the young men went to Attre's walls or Sodden's border, and the rest went to the Abbey."

```yaml event_card
id: event.l7_disgraced_knight
terrain: lowlands
table_slot: 7
requires: "true"
title: "Highwaymen and a knight without a lord"
text: "A felled tree across the road; four men with spears behind it. Their leader wears good mail with the heraldry burned off. 'Ser Gaudric Vell, late of the Marshal's horse. The road toll is everything you carry.'"
options:
  - {id: duel, text: "'You were a knight. Fight me like one, alone.' [Persuade 7]", tag: persuade, check: {skill: persuade, dc: 7, pass_effects: ["start_encounter(enc.travel_knight_duel)"], fail_effects: ["start_encounter(enc.travel_highwaymen)"]}, next: null}
  - {id: marnadal, text: "'Late of the Marshal's horse. Were you at Marnadal?' [Lore 6]", tag: lore, check: {skill: lore, dc: 6, pass_effects: ["add_xp(60)", "add_rumor(rumor.r08_new_moon_dead)"], fail_effects: ["start_encounter(enc.travel_highwaymen)"]}, next: null}
  - {id: pay, text: "Pay the toll. [Bribe 40]", tag: bribe, bribe: 40, effects: [], next: null}
  - {id: fight, text: "Go over the tree at them.", effects: ["start_encounter(enc.travel_highwaymen)"], next: null}
combat: enc.travel_highwaymen
```
*Lore pass text:* his face changes. "I was. I refused the torches at the third hall. Kosk broke my spurs for it." He lowers his sword. "Go. Tell nobody you met a coward of Marnadal." The duel option uses Presence 7 as gdd §6.3 states (see §12 on the DC scale).

### 10.2 Marnadal Valley & Woods

```yaml event_card
id: event.v1_ferry_toll
terrain: valley
table_slot: 1
requires: "true"
title: "Triple toll at the crossing"
text: "A barge is chained across the Marnadal. Three of Jory's men lounge on it with loaded crossbows. 'Toll's tripled. River's dangerous these days. Thirty crowns, or swim.'"
options:
  - {id: friend, text: "'Jory's friends ride free.' [Ferrymen: Friendly]", tag: sway, condition: "rep_tier(faction.ferrymen) >= friendly", effects: ["add_xp(20)"], next: null}
  - {id: pay, text: "Pay the triple toll. [Bribe 30]", tag: bribe, bribe: 30, effects: ["add_rep(faction.ferrymen, 2)"], next: null}
  - {id: haggle, text: "'Thirty? Jory charges ten. Does he know you charge thirty?' [Persuade 6]", tag: persuade, check: {skill: persuade, dc: 6, pass_effects: ["add_crowns(-10)", "add_xp(30)"], fail_effects: []}, condition: "crowns() >= 10", next: null}
  - {id: threaten, text: "'Lower the chain or lose the hand.' [Intimidate 6]", tag: intimidate, check: {skill: intimidate, dc: 6, pass_effects: ["add_rep(faction.ferrymen, -5)", "add_xp(30)"], fail_effects: ["start_encounter(enc.travel_ferry_toll)"]}, next: null}
  - {id: fight, text: "Board the barge.", effects: ["start_encounter(enc.travel_ferry_toll)"], next: null}
  - {id: around, text: "Turn back and take the long way round the bend.", next: null}
combat: enc.travel_ferry_toll
```

```yaml event_card
id: event.v2_revenant_patrol
terrain: valley
table_slot: 2
requires: "true"
title: "The dead on patrol"
text: "Mist off the river, and in it the clink of harness. Six figures in rotted Cintran blue march in step along the far bank, toward Dun Strept. Three of them turn their empty helms toward you."
options:
  - {id: rite, text: "Speak the champion's words for the fallen. [Marnadal rite known]", tag: lore, condition: "flag(flag.torc_rite_known)", effects: ["add_xp(50)"], next: null}
  - {id: salute, text: "Stand aside and salute as they pass. [Lore 6]", tag: lore, check: {skill: lore, dc: 6, pass_effects: ["add_xp(45)"], fail_effects: ["start_encounter(enc.travel_revenant_patrol)"]}, next: null}
  - {id: hide, text: "Drop into the reeds and wait. [Investigate 6]", tag: investigate, check: {skill: investigate, dc: 6, pass_effects: ["add_xp(30)"], fail_effects: ["start_encounter(enc.travel_revenant_patrol)"]}, next: null}
  - {id: fight, text: "Meet them with steel. Blunt steel, if you're wise.", effects: ["start_encounter(enc.travel_revenant_patrol)"], next: null}
combat: enc.travel_revenant_patrol
```
Fighting here is the safe exit: it has no condition and no check. Revenants rise again unless the last hit was blunt or fire, or `flag.torc_rite_known` (gdd §6.7). At stage 2 the text reads "the river beside them runs black".

```yaml event_card
id: event.v3_starving_wolves
terrain: valley
table_slot: 3
requires: "true"
title: "Wolves down from the snow"
text: "Ribs like barrel staves. Four wolves come out of the pines, heads low, too hungry to be afraid. The snow line must be low this year to bring them so far down."
options:
  - {id: fire, text: "Light a brand and hold your ground. [Lore 4]", tag: lore, check: {skill: lore, dc: 4, pass_effects: ["add_xp(30)"], fail_effects: ["start_encounter(enc.travel_wolves)"]}, next: null}
  - {id: stare, text: "Make yourself big and loud. [Intimidate 6]", tag: intimidate, check: {skill: intimidate, dc: 6, pass_effects: ["add_xp(30)"], fail_effects: ["start_encounter(enc.travel_wolves)"]}, next: null}
  - {id: fight, text: "Fight.", effects: ["start_encounter(enc.travel_wolves)"], next: null}
combat: enc.travel_wolves
```

```yaml event_card
id: event.v4_charcoal_burners
terrain: valley
table_slot: 4
requires: "true"
title: "Charcoal burners on the road"
text: "Soot-black men leading a mule train of charcoal sacks. They stop when they see you. 'You're not monks? Thank the Lion. They came by our clamps by night, hooded, a whole column, dragging something on runners.'"
options:
  - {id: monks, text: "'Which way did the monks go?'", effects: ["add_map_pin(map.vel_aram)", "add_xp(20)"], next: null}
  - {id: wood, text: "'Where do you cut your wood?'", effects: ["add_map_pin(map.rozrog_forest)", "set_flag(flag.rozrog_hook)", "add_rumor(rumor.r17_rozrog_woodwose)"], next: null}
  - {id: buy, text: "Buy them a meal at the next inn. [Bribe 5]", tag: bribe, bribe: 5, effects: ["add_map_pin(map.vel_aram)", "add_map_pin(map.rozrog_forest)", "set_flag(flag.rozrog_hook)"], next: null}
  - {id: leave, text: "Wish them a safe road.", next: null}
combat: null
```
*Wood answer:* "Rozrog. Used to be deadfall only, but the monks pay silver by the cartload now, so Wencel has us at the old oaks. And something in Rozrog doesn't like it."

```yaml event_card
id: event.v5_drowner_shallows
terrain: valley
table_slot: 5
requires: "true"
title: "Flooded shallows"
text: "The road dips under brown floodwater for fifty paces. A cart lies on its side in the middle, the horse still in harness, half eaten. The water is very still."
options:
  - {id: spot, text: "Read the water before you step in. [Investigate 6]", tag: investigate, check: {skill: investigate, dc: 6, pass_effects: ["add_xp(30)"], fail_effects: ["start_encounter(enc.travel_drowners)"]}, next: null}
  - {id: oil, text: "Pour fire oil on the water and light it. [Item: fire oil]", tag: item, condition: "has_item(item.fire_oil)", effects: ["take_item(item.fire_oil, 1)", "add_xp(30)"], next: null}
  - {id: wade, text: "Wade through, blade drawn.", effects: ["start_encounter(enc.travel_drowners)"], next: null}
combat: enc.travel_drowners
```
*Investigate pass text:* bubbles rising in a line, then another, toward the cart. You take the high field-edge round, ankle-deep, and three grey heads surface behind you, too late.

```yaml event_card
id: event.v6_wenna_crow
terrain: valley
table_slot: 6
requires: "true"
title: "A one-eyed crow"
text: "A crow with one milky eye sits on a dead branch over the road and does not fly when you pass. It turns its head to keep the good eye on you, then looks pointedly south."
options:
  - {id: find_mere, text: "Follow where it looks.", condition: "not visited(zone.witchs_mere)", effects: ["add_map_pin(map.witchs_mere)", "add_xp(20)"], next: null}
  - {id: bulbs, text: "'Your mistress wants her bulbs. Where?'", condition: "flag(flag.wenna_bulbs_asked) and not ms(ms.a2_wenna_line_resolved)", effects: ["add_map_pin(map.attre)", "add_map_pin(map.gull_tower)"], next: null}
  - {id: hair, text: "'She wants the Queen's hair. I know.'", condition: "quest_active(quest.side_wenna_hair) and not has_item(item.ysolde_hair)", effects: ["add_map_pin(map.cintra)"], next: null}
  - {id: scrap, text: "Toss it a strip of dried meat.", effects: ["add_rep(faction.wenna, 2)"], next: null}
  - {id: stone, text: "Throw a stone at it.", effects: ["add_rep(faction.wenna, -5)"], next: null}
  - {id: ignore, text: "Ignore the bird.", next: null}
combat: null
```
*Bulbs answer:* the crow drops a scrap of sacking stamped with Attre's gull-and-anchor, then flies toward the coast. *Hair answer:* it caws once, harshly, and flies north toward Cintra. Wenna hears about the stone. She always does.

```yaml event_card
id: event.v7_woodwose_totems
terrain: valley
table_slot: 7
requires: "not flag(flag.woodwose_peace) and not flag(flag.woodwose_dead)"
title: "Carved warning totems"
text: "Every pine trunk for a hundred paces has a face cut into it at head height, crude and furious, each one with an axe-head driven into its mouth. Under one lies a charcoal burner's cap, and nothing else of him."
options:
  - {id: follow, text: "Follow the totems toward the old oaks.", effects: ["set_flag(flag.rozrog_hook)", "add_map_pin(map.rozrog_forest)", "add_xp(20)"], next: null}
  - {id: read, text: "Study the carvings. [Lore 6]", tag: lore, check: {skill: lore, dc: 6, pass_effects: ["set_flag(flag.rozrog_hook)", "add_map_pin(map.rozrog_forest)", "add_xp(45)"], fail_effects: ["set_flag(flag.rozrog_hook)"]}, next: null}
  - {id: leave, text: "Keep to the road and walk faster.", next: null}
combat: null
```
*Lore pass text:* not a curse, a boundary. Every face looks outward from one place. Something is guarding a grove, and it has given fair warning.

### 10.3 Góry Amell & Strept

Hazard checks use attributes, as gdd §6.3 states ("Agility 6", "Grit 7"). They are written `check: {skill: agility, ...}`; see §12.

```yaml event_card
id: event.m1_rockslide
terrain: mountain
table_slot: 1
requires: "true"
title: "Rockslide"
text: "A crack like a siege-stone loosing, high above. The slope starts to move: scree first, then boulders the size of carts, then snow behind them."
options:
  - {id: dash, text: "Sprint for the overhang ahead. [Agility 6]", check: {skill: agility, dc: 6, pass_effects: ["add_xp(40)"], fail_effects: ["damage_player(35)"]}, next: null}
  - {id: back, text: "Fall back and climb around the slide.", effects: ["apply_status(chill, 1)"], next: null}
combat: null
```

```yaml event_card
id: event.m2_strept_scouts
terrain: mountain
table_slot: 2
requires: "true"
title: "Clan scouts shadowing you"
text: "Twice you've seen a figure on the ridgeline in a grey plaid, and twice it was gone before you looked again. Now there are three, and one has a bow strung."
options:
  - {id: friends, text: "Raise an open hand. They know you. [Strept: Friendly]", tag: sway, condition: "rep_tier(faction.strept) >= friendly", effects: ["add_xp(30)", "add_rumor(rumor.r14_mine_knocking)"], next: null}
  - {id: hail, text: "Call out in the clan greeting. [Persuade 6]", tag: persuade, check: {skill: persuade, dc: 6, pass_effects: ["add_rep(faction.strept, 3)", "add_xp(45)"], fail_effects: ["add_rep(faction.strept, -2)"]}, next: null}
  - {id: shoot, text: "Put a bolt near the archer's feet.", effects: ["start_encounter(enc.travel_strept_scouts)"], next: null}
  - {id: ignore, text: "Keep walking. Let them watch.", next: null}
combat: enc.travel_strept_scouts
```
*Friendly text:* the scouts come down and walk the next stretch with you, pointing out where the snow is rotten. One of them mentions the miners' knocking. Persuade checks against Strept take −2 when the Marshal's writ is worn as a badge (gdd §6.9, applied by the system). The gdd's "guides for this journey" effect has no effect op; see §12.

```yaml event_card
id: event.m3_frost_troll
terrain: mountain
table_slot: 3
requires: "true"
title: "Under the ice bridge"
text: "The only way across the gorge is a natural arch of blue ice. Beneath it, on a ledge, something the colour of dirty snow is breathing, slow and enormous. Bones on the ledge. Goat, mostly."
options:
  - {id: fire, text: "Throw burning oil down on the ledge first. [Item: fire oil]", tag: item, condition: "has_item(item.fire_oil)", effects: ["take_item(item.fire_oil, 1)", "add_xp(60)"], next: null}
  - {id: sneak, text: "Cross on your toes. [Agility 6]", check: {skill: agility, dc: 6, pass_effects: ["add_xp(60)"], fail_effects: ["start_encounter(enc.travel_frost_troll)"]}, next: null}
  - {id: lore, text: "Trolls lie up through the cold hours. Wait for it to sleep deep. [Lore 6]", tag: lore, check: {skill: lore, dc: 6, pass_effects: ["apply_status(chill, 1)", "add_xp(45)"], fail_effects: ["start_encounter(enc.travel_frost_troll)"]}, next: null}
  - {id: fight, text: "Go down and kill it on its ledge.", effects: ["start_encounter(enc.travel_frost_troll)"], next: null}
combat: enc.travel_frost_troll
```

```yaml event_card
id: event.m4_wyvern_circling
terrain: mountain
table_slot: 4
requires: "not flag(flag.roost_resolved)"
title: "Wyvern overhead"
text: "A shadow crosses the snow. Then the shriek, thin and furious, from very high. The wyvern circles the crags with something clutched in her claws, and she does not stop searching."
options:
  - {id: watch, text: "Lie flat and watch where she goes. [Investigate 6]", tag: investigate, check: {skill: investigate, dc: 6, pass_effects: ["add_xp(45)"], fail_effects: ["damage_player(20)"]}, next: null}
  - {id: hide, text: "Get under the rocks and wait for her to pass.", next: null}
combat: null
```
*Investigate pass text:* she isn't hunting. She is quartering the slopes the way a ewe searches for a lost lamb, and she always turns back to the same ridge below the Old Grey Matron. *Fail text:* she sees you, stoops, and rakes the rocks with her tail as she passes; then she is gone, still searching.

```yaml event_card
id: event.m5_dwarven_ghost
terrain: mountain
table_slot: 5
requires: "not flag(flag.cairn_cache_taken)"
title: "A dwarf in the snow"
text: "A dwarf stands in the snow ahead, beard braided with iron rings. You can see the rocks through him. He lifts one arm and points, unmoving, at a cairn you'd have walked past."
options:
  - {id: dig, text: "Go to the cairn and dig.", effects: ["set_flag(flag.cairn_cache_taken)", "add_clue(clue.cairn_marker)", "give_item(item.field_draught, 2)", "give_item(item.frost_tallow, 1)", "give_item(item.crossbow_bolts, 10)"], next: null}
  - {id: bow, text: "Bow to him first, as the dwarves bow. [Lore 6]", tag: lore, check: {skill: lore, dc: 6, pass_effects: ["set_flag(flag.cairn_cache_taken)", "add_clue(clue.cairn_marker)", "give_item(item.field_draught, 2)", "give_item(item.frost_tallow, 1)", "give_item(item.crossbow_bolts, 10)", "give_item(item.antitoxin, 2)"], fail_effects: ["set_flag(flag.cairn_cache_taken)", "add_clue(clue.cairn_marker)", "give_item(item.field_draught, 2)"]}, next: null}
  - {id: leave, text: "Leave the dead to themselves.", next: null}
combat: null
```
*Lore pass text:* he bows back, a gate-warden's bow, fist to the breastbone. When you look up he is gone, and the cache under the cairn is wrapped in oilcloth as if someone expected you.

```yaml event_card
id: event.m6_choir_rearguard
terrain: mountain
table_slot: 6
requires: "ms(ms.act1_complete)"
title: "Ambush on the switchback"
text: "Fresh boot-prints in the snow, many of them, and then none: someone swept the track. Above, on the next bend, a glint that could be ice. Or a lens."
options:
  - {id: disguise, text: "Pull up the Choir hood and walk on, feather showing. [Item: Choir robe]", tag: item, condition: "has_item(item.choir_robe) and has_item(item.pale_feather)", effects: ["add_xp(60)"], next: null}
  - {id: spot, text: "Read the slope for the shooter's nest. [Investigate 6]", tag: investigate, check: {skill: investigate, dc: 6, pass_effects: ["add_xp(45)", "start_encounter(enc.travel_choir_rearguard)"], fail_effects: ["damage_player(28)", "start_encounter(enc.travel_choir_rearguard)"]}, next: null}
  - {id: charge, text: "Charge the bend before they're ready.", effects: ["start_encounter(enc.travel_choir_rearguard)"], next: null}
combat: enc.travel_choir_rearguard
```
*Investigate pass:* you see the sharpshooter before he sees you, and the fight starts on your terms (no opening shot). *Fail:* the first bolt hits before you see anyone. At stage 3 the group has +1 member (system).

```yaml event_card
id: event.m7_oath_shrine
terrain: mountain
table_slot: 7
requires: "not flag(flag.shrine_oath_found)"
title: "A roadside shrine"
text: "A shrine no taller than a man, roof fallen in, a lion's head worn to a lump. Words are cut into the lintel, mostly weathered away."
options:
  - {id: read, text: "Brush the snow off and read it.", effects: ["set_flag(flag.shrine_oath_found)", "add_clue(clue.shrine_oath_line)"], next: null}
  - {id: rubbing, text: "Take a rubbing with charcoal and cloth to compare later. [Investigate 4]", tag: investigate, check: {skill: investigate, dc: 4, pass_effects: ["set_flag(flag.shrine_oath_found)", "add_clue(clue.shrine_oath_line)", "add_xp(40)"], fail_effects: ["set_flag(flag.shrine_oath_found)", "add_clue(clue.shrine_oath_line)"]}, next: null}
  - {id: pray, text: "Leave a crown in the niche and move on.", effects: ["add_crowns(-1)"], condition: "crowns() >= 1", next: null}
  - {id: leave, text: "Move on.", next: null}
combat: null
```
The legible fragment is the Oath's last line, verbatim: *"...Till nineteen winters turn to light."*

### 10.4 Escalation pools

`table_slot: esc`. A d8 of 8 draws from the terrain's pool; at stage ≥ 2 a d6 of 1–2 also swaps any other result for a pool card.

```yaml event_card
id: esc.l_withered_line
terrain: lowlands
table_slot: esc
requires: "true"
title: "The withered line"
text: "Through the stubble of a barley field runs a line of dead crops, a pace wide and dead straight, as if a scythe of frost had passed. It runs from the horizon behind you to the horizon ahead, toward Amell."
options:
  - {id: study, text: "Kneel and dig into the dead soil. [Lore 6]", tag: lore, check: {skill: lore, dc: 6, pass_effects: ["add_xp(60)"], fail_effects: []}, next: null}
  - {id: farmer, text: "Ask the farmer at the field's edge.", effects: ["add_rumor(rumor.r05_dwarves_inside)"], next: null}
  - {id: on, text: "Walk on along the line.", next: null}
combat: null
```
*Lore pass text:* the soil smells of struck flint and old pennies. Under the plough-depth there is a thin black crust, the same tar that wept from the Ring of Nine. Something underground is venting along an old seam, all the way from the mountains.

```yaml event_card
id: esc.l_feather_proclamations
terrain: lowlands
table_slot: esc
requires: "stage() >= 2"
title: "Proclamations on the church door"
text: "Three men in grey are nailing sheets to a village church door. Pale feathers pinned to their collars, openly now. 'The Lion is rotten. The nobles ate Marnadal. Winter will burn them clean.' The villagers watch and say nothing."
options:
  - {id: fight, text: "Tear the sheets down in front of them.", effects: ["start_encounter(enc.esc_feather_proclaimers)"], next: null}
  - {id: preach, text: "Answer them for the crowd. [Persuade 8]", tag: persuade, check: {skill: persuade, dc: 8, pass_effects: ["add_rep(faction.crown, 5)", "add_xp(90)"], fail_effects: ["start_encounter(enc.esc_feather_proclaimers)"]}, next: null}
  - {id: wait, text: "Wait until they leave, then tear the sheets down.", effects: ["add_rep(faction.crown, 1)"], next: null}
combat: enc.esc_feather_proclaimers
```

```yaml event_card
id: esc.l_refugee_column
terrain: lowlands
table_slot: esc
requires: "stage() >= 2"
title: "A refugee column"
text: "A column of carts and walkers coming down from the Marnadal country, a mile long. Children on the carts, old men walking. 'River's gone black. Wells too. The Watch is gone and nobody comes.'"
options:
  - {id: share, text: "Hand out what medicine you have. [Give a poultice]", condition: "has_item(item.poultice)", effects: ["take_item(item.poultice, 1)", "add_rep(faction.crown, 5)", "add_xp(45)"], next: null}
  - {id: coin, text: "Give coin to the column's elder. [Bribe 20]", tag: bribe, bribe: 20, effects: ["add_rep(faction.crown, 5)", "add_xp(45)"], next: null}
  - {id: ask, text: "Ask what they saw on the road.", effects: ["add_rumor(rumor.r15_watch_deserted)", "add_map_pin(map.marnadal_watch)", "set_flag(flag.marnadal_watch_hook)"], next: null}
  - {id: pass, text: "Pass them by.", next: null}
combat: null
```

```yaml event_card
id: esc.v_black_river
terrain: valley
table_slot: esc
requires: "true"
title: "The river runs black"
text: "For an hour the Marnadal runs thick and black, like ink from a cracked well. Dead fish turn belly-up in rafts. The ford you need is in the middle of it, and the water is cold as a cellar floor."
options:
  - {id: wade, text: "Wade through it.", effects: ["apply_status(chill, 2)"], next: null}
  - {id: sample, text: "Fill a flask to show someone who knows. [Lore 6]", tag: lore, check: {skill: lore, dc: 6, pass_effects: ["apply_status(chill, 1)", "add_xp(60)"], fail_effects: ["apply_status(chill, 2)"]}, next: null}
  - {id: wait, text: "Wait upstream until it clears.", effects: ["apply_status(chill, 1)"], next: null}
combat: null
```
Every option chills: the "Chill" in gdd §6.3. *Lore pass text:* not soot. Mineral silt and something oily, ground fine, the way a mill grinds. Something is grinding under the mountain.

```yaml event_card
id: esc.v_drowner_swarm
terrain: valley
table_slot: esc
requires: "stage() >= 2"
title: "Drowners in the black water"
text: "The black silt has driven them out of the deep pools. Drowners, five at least, clotted in the shallows over a dead cow, and the road runs right past."
options:
  - {id: sneak, text: "Skirt the bank downwind. [Investigate 8]", tag: investigate, check: {skill: investigate, dc: 8, pass_effects: ["add_xp(60)"], fail_effects: ["start_encounter(enc.esc_drowner_swarm)"]}, next: null}
  - {id: oil, text: "Set the shallows alight. [Item: fire oil]", tag: item, condition: "has_item(item.fire_oil)", effects: ["take_item(item.fire_oil, 1)", "add_xp(60)"], next: null}
  - {id: fight, text: "Fight.", effects: ["start_encounter(enc.esc_drowner_swarm)"], next: null}
combat: enc.esc_drowner_swarm
```

```yaml event_card
id: esc.v_blight_wagon
terrain: valley
table_slot: esc
requires: "stage() >= 2"
title: "The burning wagon"
text: "A wagon on fire in a ditch, and two Choir zealots standing guard over it as it burns. The cask on its bed is iron-hooped and stamped with a dwarven rune. The smoke turns the grass black where it settles."
options:
  - {id: fight, text: "Kill the guards before the cask goes.", effects: ["start_encounter(enc.esc_blight_wagon)"], next: null}
  - {id: shoot, text: "Put a bolt through the cask from range. [Agility 6]", check: {skill: agility, dc: 6, pass_effects: ["add_xp(60)"], fail_effects: ["apply_status(burning, 1)", "start_encounter(enc.esc_blight_wagon)"]}, next: null}
  - {id: avoid, text: "Go wide through the fields, holding your breath.", effects: ["apply_status(poison, 1)"], next: null}
combat: enc.esc_blight_wagon
```
*Agility pass text:* the cask splits and burns out in a roar, taking both zealots' nerve with it; they run. A blight-cask, one of Corvan's, out of Ostrel's outer tunnels. Someone is testing them.

```yaml event_card
id: esc.m_blue_fires
terrain: mountain
table_slot: esc
requires: "true"
title: "Cold blue fire"
text: "When you strike a light, the flame comes up blue and gives no heat. The lantern too. Every fire on the mountain burns cold tonight, as if something under the rock is drinking the warmth."
options:
  - {id: endure, text: "Push on without warmth.", effects: ["set_flag(flag.blue_fires_active)"], next: null}
  - {id: tallow, text: "Grease yourself with frost-tallow. [Item: frost-tallow]", tag: item, condition: "has_item(item.frost_tallow)", effects: ["take_item(item.frost_tallow, 1)", "set_flag(flag.blue_fires_active)", "add_xp(30)"], next: null}
combat: null
```
Per gdd §6.3, campfires give no warmth in the journey's arrival zone. Frost-tallow halves the Chill rate for that zone visit (gdd §6.9); the card only lets the player apply it in advance.

```yaml event_card
id: esc.m_tremor
terrain: mountain
table_slot: esc
requires: "true"
title: "The mountain shudders"
text: "A deep shudder through the rock, felt in the teeth more than heard. Snow cornices let go all along the ridge. Then, from very deep, a sound like a great bolt dragged an inch through iron."
options:
  - {id: brace, text: "Brace against the rock and ride it out. [Grit 7]", check: {skill: grit, dc: 7, pass_effects: ["add_xp(60)"], fail_effects: ["damage_player(30)", "apply_status(chill, 1)"]}, next: null}
  - {id: run, text: "Run for the open slope.", effects: ["damage_player(15)"], next: null}
combat: null
```

```yaml event_card
id: esc.m_stray_warden
terrain: mountain
table_slot: esc
requires: "stage() >= 4"
title: "An iron-warden, wandering"
text: "It stands in the middle of the track like a statue, eight feet of riveted iron with a rune-core glowing dull red in its chest. Snow has drifted against its legs. Then its head turns, grinding, toward you."
options:
  - {id: runes, text: "Read the rune on its brow and speak the gate-warden's stand-down word. [Lore 8]", tag: lore, check: {skill: lore, dc: 8, pass_effects: ["add_xp(120)"], fail_effects: ["start_encounter(enc.esc_stray_warden)"]}, next: null}
  - {id: dravin, text: "Let Dravin speak to it.", tag: sway, condition: "in_party(companion.dravin)", effects: ["add_xp(90)"], next: null}
  - {id: fight, text: "Fight it. Aim for the core when it staggers.", effects: ["start_encounter(enc.esc_stray_warden)"], next: null}
combat: enc.esc_stray_warden
```
Mane-Cleaver deals ×2.0 against it (gdd §6.4). It is the only warden met outside Karak Ostrel.

### 10.5 Forced hazard events (map edges, gdd §6.3)

`terrain: none`, `table_slot: null`. The travel system shows these when the route uses the edge, before the encounter roll.

```yaml event_card
id: event.ford_marnadal
terrain: none
table_slot: null
requires: "not flag(flag.jory_crossing_granted)"
title: "Ford the Marnadal"
text: "No barge for you without Jory's leave. The ford is chest-deep and fast, brown water piling against the marker stakes."
options:
  - {id: ford, text: "Ford it. [Agility 5]", check: {skill: agility, dc: 5, pass_effects: ["add_xp(30)"], fail_effects: ["damage_player(25)", "take_item(item.poultice, 1)"]}, next: null}
  - {id: turn_back, text: "Turn back. Find Jory, or another road.", effects: ["cancel_journey()"], next: null}
combat: null
```
Fail costs 25% HP and one random consumable in gdd §6.3. Content has no "percent" or "random item" op; see §12. `take_item` on a missing poultice is a no-op the engine must allow (§12).

```yaml event_card
id: event.snow_choked_pass
terrain: none
table_slot: null
requires: "stage() >= 2 and not flag(flag.strept_guides) and not in_party(companion.dravin)"
title: "Snow-choked pass"
text: "The pass is drifted to the waist and the wind has teeth. No guide to show you where the snow is rotten over the drops."
options:
  - {id: push, text: "Push through. [Grit 6]", check: {skill: grit, dc: 6, pass_effects: ["add_xp(40)"], fail_effects: ["apply_status(chill, 2)", "damage_player(30)"]}, next: null}
  - {id: turn_back, text: "Turn back and come again with a guide.", effects: ["cancel_journey()"], next: null}
combat: null
```
The edge stays passable either way (gdd §6.3).

## 11. Failure states and branches
```yaml branches
paths:
  - id: talk_past
    when: "Player passes a check or uses an item/rep option on a card."
    outcome: "Card ends without a fight; XP, clues or pins as listed."
    sets: []
  - id: fight
    when: "Player picks a fight option or fails a check that starts an encounter."
    outcome: "Arena loads; when the encounter ends (won, yielded, fled), the journey resumes."
    sets: []
  - id: decline
    when: "Player picks the no-check exit option."
    outcome: "Journey resumes. Combat cards whose only safe exit is the fight option are marked as such in §10."
    sets: []
failures:
  - id: player_dies_in_arena
    result: reload_checkpoint
    recover: "Reload arena_start (autosaved when the arena loads)."
  - id: hook_card_missed
    result: soft_fail
    recover: "Every hook started by a card is also started by a rumor (r15, r17, r18) or a map pin from Bertha's gossip; no side quest depends on a card."
guarantees:
  - "No card sets a required milestone. Every card has at least one option with no condition and no check."
  - "Clues given only here (clue.cairn_marker, clue.shrine_oath_line, clue.pilgrim_feather) are never required by an act gate."
```

## 12. Open questions
- **Hazard checks on attributes.** gdd §6.3 writes hazards as "Agility 6", "Grit 6", "Grit 7", but content-format §C's `skill()` lists only persuade/intimidate/investigate/lore. I wrote `check: {skill: agility|grit, dc: N}` and assume the check resolver accepts attribute names (the stat value plus bonuses). Alternatively add `stat` checks to the format.
- **Off-scale DCs.** gdd §6.3 uses Wits 5, Presence 7, Agility 5, Grit 7; content-format §I wants 4/6/8/10. I kept the gdd values where the gdd names them (L2 5, L7 7, ford 5, tremor 7) and used the scale elsewhere.
- **Percent damage and random consumables.** gdd's "25% HP" and "one random consumable" have no effect op. I used `damage_player(25)` and `take_item(item.poultice, 1)` as stand-ins. Proposal: `damage_player_pct(N)` and `take_random_consumable()`. `take_item` on an item the player lacks should be a no-op, not a failure.
- **Turning back from a forced hazard.** Every card needs an option with no condition and no check, but the two forced hazards (`event.ford_marnadal`, `event.snow_choked_pass`) are checks by nature. I added a "Turn back" option using a proposed new effect `cancel_journey()` (the token returns to the start node, no encounter roll). It is **not** in content-format §E yet and will fail the content tests until added. Alternative: drop the rule for `terrain: none` cards.
- **"Guides for this journey" (M2).** No effect expresses a journey-scoped modifier. The Friendly option gives XP and a rumor only. Proposal: `journey_modifier(guides)`.
- **"+1 rumor" (L6).** No `draw_rumor()` effect exists, so the supper gives a fixed rumor per act. Proposal: `draw_rumor(source)`.
- **`flag.blue_fires_active`.** The flag needs clearing when the player leaves the arrival zone. No zone owns that. Proposal: the travel application clears it on the next `JourneyStarted`, or add a journey-scoped status op.
- **Two cards on one slot (L5).** `event.l5_sodden_tinker` and `event.l5_drozd_returns` share slot 5 with mutually exclusive `requires`. I assume the table resolves a slot to the first card in file order whose `requires` is true. If a slot holds exactly one entry, move the Drozd card to the lowlands escalation pool instead.
- **Escalation-pool ids.** gdd names the pool entries `esc.*`, so the pool cards use `esc.*` as their `event_card` id (stored under `event_cards/`). Rename to `event.esc_*` if the converter requires the `event.` prefix.
- **L3 bulb after a fight.** If the Wenna option's check fails and the fight is won, the player should still get the bulb. Encounters cannot read conditions in `on_won`, so I propose `enc.travel_lily_wagon` gets a variant `enc.travel_lily_wagon_wenna` or the arena gets a conditional pickup. Left for the reconciliation pass.
- **Consumable ids** (`item.poultice`, `item.field_draught`, `item.frost_tallow`, `item.fire_oil`, `item.antitoxin`, `item.crossbow_bolts`) are named from gdd §6.9 but not declared there. I expect A04 (first shops) to declare them.
- `flag.roost_resolved` (M4) is expected from A06's Wyvern's Roost.
- **M6 first strike.** The Investigate pass should start the fight without the sharpshooter's opening shot. Encounters have no "ambush / ambushed" field; I propose an optional `opening: player_first | enemy_first` on `encounter`, or an encounter variant. Until then both outcomes load the same fight and only the fail applies `damage_player(28)`.
