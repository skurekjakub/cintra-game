---
section_id: a2.07
title: "Ruins of Vel Aram"
act: 2
story_ref: "story.md §3 The Pale Choir (muster), §6 Ruins of Vel Aram, §8 The Lion's Oath, §7.5 Wyvern's Roost (eggs)"
zones: [zone.vel_aram_outer, zone.vel_aram_sanctum, zone.vel_aram_vault]
available_when: "ms(ms.act1_complete) and not ms(ms.act2_twist) and ded(ded.choir_muster_vel_aram)"
escalation_stage_required: {min: 1, max: 3}
milestones_set: [ms.a2_vel_aram_cleared]
milestones_read: [ms.a2_vel_aram_cleared, ms.act1_complete, ms.act2_twist]
level_band: [7, 8]
---

# Ruins of Vel Aram

## 1. Scene summary
Vel Aram was a border fortress before there was a Cintra. It was built by wardens who watched the Amell long before Corvan made his Pact. Now it is the Pale Choir's sanctum and muster: thirty-odd sworn brothers drill in the outer ward, Prior Ulric preaches the fall of the old order in the roofless nave, and the Abbey's cellarer keeps two stolen wyvern eggs warm for his alchemy. In the undercroft, a dwarven war-construct hauled out of Ostrel's outer tunnels, the **soot-hound**, strains on a chain at the edge of a drained cistern. Behind it, in a sealed reliquary, lies the page Anselm cut from the *Book of the Lion*: the **authentic fourth verse**. In the Abbot's private cell is his **journal**, which lays out the whole design: the poisoned chalice, the stolen verse, the boy who will be crowned and then taken, and the Pact spoken backward at Karak Ostrel's control throne to unseal the vaults. The player can storm the fortress, walk it in a stolen robe, or find the drowned postern the old wardens left under the well. The dramatic question: once the player reads the Abbot's own words, can they still get home in time to matter? The section ends with the page in the player's hands (`ms.a2_vel_aram_cleared`).

## 2. Progress and escalation
- `ms.a2_vel_aram_cleared` is set when the player takes the true fourth verse from the reliquary. After that the muster breaks: the remaining brothers march for the Marnadal Stairs (variant `muster_gone`), and only a rear guard is left. Anselm's cell, the reagent store and the armory stay lootable, so nothing is lost by taking the page first.
- Outputs: `item.true_fourth_verse` and `clue.reversed_oath` (reliquary); `item.anselm_journal`, `clue.anselm_journal` and `clue.reversed_oath` (Anselm's cell); `item.wyvern_eggs` (reagent store); `item.choir_robe` (armory). `ded.anselm_treason_proven` and `ded.reversed_oath_plan` are declared here.
- Reactivity: `flag.forged_dispatch_planted` (a2.02) removes patrols A and B (ten brothers went north). `flag.oswy_returned` or `flag.oak_courier_escaped` hangs Oswy on the gate gibbet. `flag.yorek_freed` gives the naming rite (read by a2.04) and Strept +10.
- **Stage 1–2:** as written. At stage 2, black silt water rises in the cistern (the postern is deeper; `enc.va_cistern_drowners` gains one drowner through the stage rule on valley water, authored as a wave here). **Stage 3:** the muster is at full strength and openly armed. The system adds +1 to Choir groups, and the bell reinforcements come faster (presentation).

## 3. Location layout

### 3.1 Outer works (`zone.vel_aram_outer`, dusk, about 140 × 110 m)
1. **Ravine road** (south): a 6 m-wide road cut between rock walls, climbing 200 m to the gate. It is the player's entry. An old gibbet stands at the top. If Oswy returned or escaped, he hangs here with a placard: *"He lost the wheel."*
2. **Collapsed barbican:** two gate-tower stumps and a rubble ramp where the gate was. A **trip-line** of bells is strung across the ramp at shin height (a `trap` hazard that plays `alarm` if walked through upright; crouch to step over, or cut it with Investigate 4 to spot it first). Sentry **S1**, a crossbowman, stands on the east tower stump (4 m up, a sight line down the whole ravine road).
3. **Outer ward:** a 50 × 40 m bailey. Muster tents in three rows (soft cover), a cookfire, straw-man training posts, two supply carts (full cover). **Patrol A** (2 zealots) walks the ward perimeter clockwise, about 70 s a loop. The muster (`enc.va_muster`) is camped here and engages only on alarm.
4. **Wall walk:** rotten timber hoarding along the west curtain wall, 5 m up, reached by a stair at the south end. Sentry **S2**, a crossbowman, walks it north to south (25 s each way). The middle 8 m of hoarding is rotten: sprinting, rolling or fighting on it drops the player into the ward (`collapse`, 30 damage, knockdown, in full view of the muster).
5. **Stable ruin** (east): a lean-to over old horse stalls. A **cage** holds Yorek, a Strept scout. The cage pin can be worked loose (Investigate 4) or the bar levered (loud: plays `alarm`).
6. **Well house** (north-west corner): a roofed well with a rope ladder down 8 m to a cistern ledge. An old warden's mark is cut in the well head (a ring with a mountain inside). The **loose capstone** at the bottom, the secret, is found with Investigate 6, or Novice Liss tells the player about it. It opens the **sunken postern** into the vault (`zone.vel_aram_vault`, spawn `postern_cistern`).
7. **Inner gatehouse** (north): the keep door into the sanctum, flanked by two braziers. It is permitted to Choir-disguised players and watched by Patrol A at each pass.

### 3.2 The sanctum (`zone.vel_aram_sanctum`, dungeon, about 60 × 45 m, `disguise_tag: choir`)
1. **Nave:** 30 × 12 m, roofless, broken pews (low cover), the altar wall nailed with pale feathers in the shape of a swan. Prior Ulric preaches here at the **muster beat** (the first time the player enters the nave). **Patrol B** (2 zealots) loops nave → north transept → nave, about 50 s.
2. **South aisle:** cracked vaulting propped with timbers. Two heavy impacts (kicks, a zealot's death burst, an explosion) bring the vault down (`collapse`, 50 damage, blocks the aisle afterwards). The player can use this deliberately to crush enemies.
3. **Dormitory** (west): twenty cots, novices asleep or praying. Novice Liss is here. Permitted.
4. **Refectory** (west, beyond the dormitory): long tables, spilled lamp oil puddles under the benches (a `fire` hazard if anything burns nearby).
5. **Cellarer's store** (south-west): Jory's crates, a dwarven chain spool, and **six powder kegs** (blasting powder for the Stairs). Fire or a crossbow bolt into a keg explodes it (`fire`, 80 damage, 4 m radius, and it collapses the store's doorway). Permitted.
6. **Armory** (south): racks of Choir robes, spears, bolts. Permitted.
7. **Reagent store** (east, restricted): an alchemist's bench, glass alembics, a warm-sand box under a brazier holding **two wyvern eggs**. Brother Cellarer Aumery works here.
8. **Chapter house** (north-east, restricted): Prior Ulric's room. The muster roll, orders, the **cell key** on a hook.
9. **Anselm's cell** (north, restricted, locked): a plain room with a narrow bed, a 1263 chaplain's stole on a nail, a lectern with a **locked box** (a needle trap: Investigate 6 to disarm, or smash it open and take a poison dose), and a charcoal sketch of a round chamber with a throne and mirror-shafts pinned above the desk.
10. **Bell tower:** a stair in the north transept to the bell. On a sanctum alarm a brother runs to ring it, which brings `enc.va_bell_reinforcements` from the outer ward. **Cutting the bell rope** (a lever, no check) beforehand cancels that wave.
11. **Undercroft stair** (behind the altar, restricted): down to the vault.

### 3.3 The vault (`zone.vel_aram_vault`, dungeon, about 50 × 40 m)
1. **Undercroft landing:** the bottom of the stair. Soot on every surface, a constant low hum.
2. **Engine gallery** (west): a dwarven soot-furnace feeding iron pipes into the pit wall, coal heaps, a **damper lever**, and the **reliquary lock lever**. Houndwright Edrin tends it. Steam vents along the pipe run (`steam` hazard when the hound is awake).
3. **Hound pit** (centre): a drained cistern 25 m across and 3 m deep. The **soot-hound** is chained to a central anchor with 10 m of chain. A 2 m **ledge** runs round the rim to the reliquary door on the east side; the north stretch of the ledge passes within the chain's reach. The hound sleeps when fed and wakes on the vault alarm, on anyone stepping into the pit, or on anyone crossing the north ledge while it is not dormant.
4. **Reliquary** (east): a dwarven-sealed door (opened by the lock lever in the engine gallery, or by a hidden catch from the postern side). Inside: a lead reliquary holding **the cut page** (the true fourth verse), Anselm's annotated chant sheet, and a dwarven rune-tablet.
5. **Sunken postern** (the secret, north-east): a flooded passage from the outer well's cistern. It is waist-deep at stage 1 and chest-deep at stage 2+ (`deep_mud` water). Halfway along is the **warden's tomb**, a niche with a pre-Cintran captain's bones and his **maul**. Two drowners have nested in the cistern. The passage ends at the reliquary's back wall (hidden catch).
6. **Collapse tunnel** (south-east): a one-way crawl from the reliquary up into the ravine below the barbican, an escape route. If the hound is awake when it is used, the tunnel mouth collapses behind the player (`collapse`, cosmetic; the route can't be reused).

```yaml zone
id: zone.vel_aram_outer
name: "Vel Aram: Outer Works"
kind: exterior
map_node: map.vel_aram
time_of_day: dusk
cold_rate: 0
disguise_tag: choir
music: vel_aram_drums
areas:
  - {id: ravine_road, description: "6 m road between rock walls, 200 m to the gate. Gibbet at the top. Player entry."}
  - {id: barbican, description: "Two gate-tower stumps and a rubble ramp. Trip-line of bells at shin height. S1 crossbowman on the east stump (4 m)."}
  - {id: outer_ward, description: "50 x 40 m bailey: three rows of muster tents (soft cover), cookfire, training posts, two carts (full cover). Patrol A clockwise, ~70 s loop."}
  - {id: wall_walk, description: "Rotten timber hoarding 5 m up the west curtain. S2 walks it N-S, 25 s each way. Middle 8 m rotten."}
  - {id: stable_ruin, description: "East lean-to over old stalls. Yorek's cage."}
  - {id: well_house, description: "North-west roofed well, rope ladder 8 m down to a cistern ledge. Warden's mark on the well head. Loose capstone below."}
  - {id: inner_gatehouse, description: "North keep door into the sanctum, two braziers."}
spawns:
  - {id: ravine_road, area: ravine_road, default: true}
  - {id: tunnel_exit, area: ravine_road}
  - {id: well_ledge, area: well_house}
  - {id: keep_door, area: inner_gatehouse}
  - {id: tower_stump, area: barbican}
  - {id: wall_south, area: wall_walk}
  - {id: tents, area: outer_ward}
exits:
  - id: to_sanctum
    area: inner_gatehouse
    to_zone: zone.vel_aram_sanctum
    to_spawn: nave_door
    condition: "true"
    effects: []
  - id: to_postern
    area: well_house
    to_zone: zone.vel_aram_vault
    to_spawn: postern_cistern
    condition: "flag(flag.postern_found)"
    effects: []
interactables:
  - id: travel_marker
    area: ravine_road
    kind: map_board
    label: "Leave Vel Aram (travel)"
    condition: "true"
    check: null
    once: false
    effects: []
  - id: gibbet_body
    area: ravine_road
    kind: search
    label: "Search the hanged novice"
    condition: "flag(flag.oswy_returned) or flag(flag.oak_courier_escaped)"
    check: null
    once: true
    effects: ["give_item(item.pale_feather, 1)"]
  - id: trip_line
    area: barbican
    kind: lever
    label: "Cut the bell trip-line"
    condition: "not flag(flag.trip_line_cut)"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["set_flag(flag.trip_line_cut)"]
    fail_effects: ["play_beat(alarm)"]
  - id: cage_pin
    area: stable_ruin
    kind: lever
    label: "Work the cage pin loose"
    condition: "not flag(flag.yorek_freed)"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["set_flag(flag.yorek_freed)", "start_dialogue(dlg.yorek)"]
    fail_effects: []
  - id: cage_bar
    area: stable_ruin
    kind: lever
    label: "Lever the cage bar off (loud)"
    condition: "not flag(flag.yorek_freed)"
    check: null
    once: true
    effects: ["set_flag(flag.yorek_freed)", "play_beat(alarm)", "start_dialogue(dlg.yorek)"]
  - id: warden_mark
    area: well_house
    kind: readable
    label: "Study the mark on the well head"
    condition: "not flag(flag.postern_found)"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["set_flag(flag.postern_found)", "play_beat(capstone_found)"]
    fail_effects: []
  - id: well_cistern_rest
    area: well_house
    kind: rest
    label: "Catch your breath in the well house (rest, unseen)"
    condition: "flag(flag.postern_found)"
    check: null
    once: false
    effects: ["heal_player(full)", "set_checkpoint(well_cp)"]
triggers:
  - id: outer_alarm
    area: outer_ward
    on: beat_done
    source: alarm
    condition: "not flag(flag.va_outer_alarm)"
    once: true
    effects: ["set_flag(flag.va_outer_alarm)", "start_encounter(enc.va_muster)"]
  - id: tunnel_arrival
    area: ravine_road
    on: enter
    source: null
    condition: "ms(ms.a2_vel_aram_cleared) and not flag(flag.va_left_after_clear)"
    once: true
    effects: ["set_flag(flag.va_left_after_clear)", "play_beat(muster_marches)"]
hazards:
  - {id: bell_line, area: barbican, kind: trap, params: {trigger: walk_upright, on_trigger_beat: alarm, disabled_by_flag: flag.trip_line_cut}}
  - {id: rotten_hoarding, area: wall_walk, kind: collapse, params: {trigger: sprint_roll_or_combat, segment_m: 8, damage: 30, knockdown: true}}
checkpoints:
  - {id: va_arrival, area: ravine_road}
  - {id: well_cp, area: well_house}
  - {id: keep_cp, area: inner_gatehouse}
beats:
  - {id: alarm, description: "Outer-works alarm: a sentry shouts, the trip-bells jangle, the muster pours out of the tents."}
  - {id: capstone_found, description: "Fingers find the ring-and-mountain mark repeated on a capstone at the bottom; it grinds aside onto black water."}
  - {id: muster_marches, description: "From the ravine, a column of grey robes and carts winds north out of the ward toward the mountains. Torches until the bend, then nothing."}
npcs:
  - {npc: npc.yorek, area: stable_ruin, condition: "not flag(flag.yorek_freed)"}
encounters: [enc.va_sentries, enc.va_patrol_a, enc.va_muster]
loot:
  - {container: gibbet_body, items: [], condition: "true"}
variants:
  - id: oswy_hanged
    when: "flag(flag.oswy_returned) or flag(flag.oak_courier_escaped)"
    description: "Brother Oswy hangs from the gibbet at the top of the ravine road, a placard on his chest: 'He lost the wheel.'"
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: thinned
    when: "flag(flag.forged_dispatch_planted) and not ms(ms.a2_vel_aram_cleared)"
    description: "Ten bedrolls empty in the tents. Patrol A is missing; the forged order sent them north to the Oak."
    npcs_absent: []
    encounters_disabled: [enc.va_patrol_a]
    interactables_disabled: []
  - id: muster_gone
    when: "ms(ms.a2_vel_aram_cleared)"
    description: "The tents are struck. A rear guard of two sentries remains."
    npcs_absent: []
    encounters_disabled: [enc.va_patrol_a, enc.va_muster]
    interactables_disabled: []
```

```yaml zone
id: zone.vel_aram_sanctum
name: "Vel Aram: The Sanctum"
kind: dungeon
map_node: map.vel_aram
time_of_day: night
cold_rate: 0
disguise_tag: choir
music: vel_aram_hymn
areas:
  - {id: nave, description: "30 x 12 m roofless nave, broken pews (low cover), altar wall nailed with pale feathers in a swan. Patrol B loops nave - north transept, ~50 s."}
  - {id: south_aisle, description: "Cracked vaulting propped with timbers. Collapses after two heavy impacts."}
  - {id: dormitory, description: "Twenty cots, novices. Novice Liss. Permitted."}
  - {id: refectory, description: "Long tables, lamp-oil puddles under the benches."}
  - {id: cellarers_store, description: "Jory's crates, a dwarven chain spool, six powder kegs. Permitted."}
  - {id: armory, description: "Racks of Choir robes, spears, bolts. Permitted."}
  - {id: reagent_store, description: "Alchemist's bench, alembics, a warm-sand box under a brazier with two wyvern eggs. Restricted."}
  - {id: chapter_house, description: "Prior Ulric's room: muster roll, orders, the cell key on a hook. Restricted."}
  - {id: anselm_cell, description: "Narrow bed, a 1263 chaplain's stole, a lectern with a trapped box, a charcoal sketch of a throne chamber. Restricted, locked."}
  - {id: bell_tower, description: "Stair in the north transept up to the alarm bell and its rope."}
  - {id: undercroft_stair, description: "Behind the altar, down to the vault. Restricted."}
spawns:
  - {id: nave_door, area: nave, default: true}
  - {id: transept, area: nave}
  - {id: chapter, area: chapter_house}
  - {id: reagent, area: reagent_store}
  - {id: stair_top, area: undercroft_stair}
  - {id: from_vault, area: undercroft_stair}
exits:
  - id: to_outer
    area: nave
    to_zone: zone.vel_aram_outer
    to_spawn: keep_door
    condition: "true"
    effects: []
  - id: to_vault
    area: undercroft_stair
    to_zone: zone.vel_aram_vault
    to_spawn: landing
    condition: "true"
    effects: []
interactables:
  - id: armory_robes
    area: armory
    kind: pickup
    label: "Take a Choir robe"
    condition: "not has_item(item.choir_robe)"
    check: null
    once: true
    effects: ["give_item(item.choir_robe, 1)", "give_item(item.pale_feather, 1)"]
  - id: armory_bolts
    area: armory
    kind: container
    label: "Take bolts from the rack"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.crossbow_bolt, 10)"]
  - id: bell_rope
    area: bell_tower
    kind: lever
    label: "Cut the bell rope"
    condition: "not flag(flag.bell_rope_cut)"
    check: null
    once: true
    effects: ["set_flag(flag.bell_rope_cut)"]
  - id: muster_roll
    area: chapter_house
    kind: readable
    label: "Read the muster roll"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.va_muster_roll, 1)", "add_clue(clue.choir_at_vel_aram)"]
  - id: cell_key_hook
    area: chapter_house
    kind: pickup
    label: "Take the key from the hook"
    condition: "not has_item(item.cell_key)"
    check: null
    once: true
    effects: ["give_item(item.cell_key, 1)"]
  - id: cell_door
    area: anselm_cell
    kind: door
    label: "Unlock the Abbot's cell"
    condition: "(has_item(item.cell_key) or ms(ms.a2_vel_aram_cleared)) and not flag(flag.cell_open)"
    check: null
    once: true
    effects: ["set_flag(flag.cell_open)"]
  - id: cell_door_pick
    area: anselm_cell
    kind: door
    label: "Work the cell lock"
    condition: "not has_item(item.cell_key) and not ms(ms.a2_vel_aram_cleared) and not flag(flag.cell_open)"
    check: {skill: investigate, dc: 8}
    once: true
    effects: ["set_flag(flag.cell_open)"]
    fail_effects: []
  - id: journal_box_disarm
    area: anselm_cell
    kind: container
    label: "Disarm the needle in the lectern box"
    condition: "flag(flag.cell_open) and not has_item(item.anselm_journal)"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["give_item(item.anselm_journal, 1)", "add_clue(clue.anselm_journal)", "add_clue(clue.reversed_oath)"]
    fail_effects: ["apply_status(poison, 2)"]
  - id: journal_box_smash
    area: anselm_cell
    kind: container
    label: "Smash the lectern box open"
    condition: "flag(flag.cell_open) and not has_item(item.anselm_journal)"
    check: null
    once: true
    effects: ["apply_status(poison, 3)", "give_item(item.anselm_journal, 1)", "add_clue(clue.anselm_journal)", "add_clue(clue.reversed_oath)"]
  - id: chaplain_stole
    area: anselm_cell
    kind: search
    label: "Examine the chaplain's stole"
    condition: "flag(flag.cell_open)"
    check: null
    once: true
    effects: ["add_clue(clue.marnadal_chaplain)"]
  - id: throne_sketch
    area: anselm_cell
    kind: readable
    label: "Look at the charcoal sketch"
    condition: "flag(flag.cell_open)"
    check: {skill: lore, dc: 6}
    once: true
    effects: ["add_clue(clue.throne_sketch)"]
    fail_effects: []
  - id: egg_box
    area: reagent_store
    kind: pickup
    label: "Lift the wyvern eggs from the warm sand"
    condition: "not has_item(item.wyvern_eggs) and not flag(flag.eggs_lost)"
    check: null
    once: true
    effects: ["give_item(item.wyvern_eggs, 1)", "add_clue(clue.wyvern_eggs_stolen)"]
  - id: powder_kegs
    area: cellarers_store
    kind: lever
    label: "Set a slow match in the powder kegs"
    condition: "not flag(flag.powder_blown)"
    check: null
    once: true
    effects: ["set_flag(flag.powder_blown)", "play_beat(powder_blast)", "play_beat(alarm)"]
triggers:
  - id: muster_sermon
    area: nave
    on: enter
    source: null
    condition: "not flag(flag.va_sermon_seen) and not ms(ms.a2_vel_aram_cleared) and not flag(flag.va_sanctum_alarm)"
    once: true
    effects: ["set_flag(flag.va_sermon_seen)", "play_beat(muster_sermon)", "start_dialogue(dlg.prior_ulric)"]
  - id: cellarer_cracks
    area: reagent_store
    on: enter
    source: null
    condition: "not has_item(item.wyvern_eggs) and not flag(flag.eggs_lost) and not flag(flag.cellarer_dealt)"
    once: true
    effects: ["start_dialogue(dlg.aumery)"]
  - id: sanctum_alarm
    area: nave
    on: beat_done
    source: alarm
    condition: "not flag(flag.va_sanctum_alarm)"
    once: true
    effects: ["set_flag(flag.va_sanctum_alarm)", "play_beat(bell_rings)"]
  - id: bell_brings_muster
    area: nave
    on: beat_done
    source: bell_rings
    condition: "not flag(flag.bell_rope_cut) and not ms(ms.a2_vel_aram_cleared)"
    once: true
    effects: ["start_encounter(enc.va_bell_reinforcements)"]
hazards:
  - {id: aisle_vault, area: south_aisle, kind: collapse, params: {trigger: heavy_impacts, impacts: 2, damage: 50, blocks_area_after: true}}
  - {id: refectory_oil, area: refectory, kind: fire, params: {ignites_on: fire, damage_per_second: 6}}
  - {id: powder, area: cellarers_store, kind: fire, params: {ignites_on: fire_or_bolt, burst_damage: 80, radius_m: 4, collapses_doorway: true}}
checkpoints:
  - {id: nave_cp, area: nave}
  - {id: stair_cp, area: undercroft_stair}
beats:
  - {id: muster_sermon, description: "Prior Ulric on the altar step, a congregation of novices and brothers answering him (the novices scatter if steel is drawn): 'The crown is rotten. The mountain remembers. At the turning, the dark wakes and the old order burns.'"}
  - {id: alarm, description: "Sanctum alarm: a novice screams, boots on stone, someone runs for the bell tower."}
  - {id: bell_rings, description: "The great bell booms over the ward (or, if the rope is cut, a brother hauls on a dangling end and nothing happens)."}
  - {id: powder_blast, description: "The cellarer's store goes up in a roar of flame and stone; the doorway falls in."}
  - {id: egg_cracked, description: "Aumery's mallet comes down; one egg splits and spills on the sand. The other rolls into the brazier coals."}
npcs:
  - {npc: npc.prior_ulric, area: nave, condition: "not flag(flag.prior_ulric_dead) and not ms(ms.a2_vel_aram_cleared)"}
  - {npc: npc.novice_liss, area: dormitory, condition: "not flag(flag.liss_left)"}
  - {npc: npc.brother_aumery, area: reagent_store, condition: "not flag(flag.cellarer_dealt)"}
encounters: [enc.va_patrol_b, enc.va_prior, enc.va_bell_reinforcements, enc.va_reagent]
loot:
  - {container: armory_bolts, items: [{item: item.smoke_pot, count: 1}], condition: "true"}
  - {container: journal_box_smash, items: [], condition: "true"}
variants:
  - id: thinned
    when: "flag(flag.forged_dispatch_planted) and not ms(ms.a2_vel_aram_cleared)"
    description: "Half the dormitory cots stripped; Patrol B gone north."
    npcs_absent: []
    encounters_disabled: [enc.va_patrol_b]
    interactables_disabled: []
  - id: muster_gone
    when: "ms(ms.a2_vel_aram_cleared)"
    description: "Feathers torn from the altar, cots stripped, a cold hearth. Only Liss (if still here) and the dead remain."
    npcs_absent: [npc.prior_ulric]
    encounters_disabled: [enc.va_patrol_b, enc.va_prior, enc.va_bell_reinforcements]
    interactables_disabled: [cell_door_pick]
  - id: store_blown
    when: "flag(flag.powder_blown)"
    description: "The cellarer's store is a smoking crater; its doorway is rubble."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: [powder_kegs]
```

```yaml zone
id: zone.vel_aram_vault
name: "Vel Aram: The Undercroft"
kind: dungeon
map_node: map.vel_aram
time_of_day: night
cold_rate: 0
disguise_tag: null
music: soot_hum
areas:
  - {id: landing, description: "Bottom of the undercroft stair. Soot on every surface, a low hum."}
  - {id: engine_gallery, description: "Dwarven soot-furnace, iron pipes into the pit wall, coal heaps, the damper lever and the reliquary lock lever. Houndwright Edrin."}
  - {id: hound_pit, description: "Drained cistern 25 m across, 3 m deep. Soot-hound on a 10 m chain from a central anchor. A 2 m ledge round the rim; the north stretch is within chain reach."}
  - {id: reliquary, description: "Dwarven-sealed chamber: lead reliquary with the cut page, Anselm's chant sheet, a rune-tablet. Hidden catch on the back wall."}
  - {id: sunken_postern, description: "Flooded passage from the outer well's cistern to the reliquary's back wall. Warden's tomb niche halfway. Drowner nest."}
  - {id: collapse_tunnel, description: "One-way crawl from the reliquary up to the ravine road."}
spawns:
  - {id: landing, area: landing, default: true}
  - {id: postern_cistern, area: sunken_postern}
  - {id: pit_anchor, area: hound_pit}
  - {id: postern_deep, area: sunken_postern}
exits:
  - id: to_sanctum
    area: landing
    to_zone: zone.vel_aram_sanctum
    to_spawn: from_vault
    condition: "true"
    effects: []
  - id: postern_out
    area: sunken_postern
    to_zone: zone.vel_aram_outer
    to_spawn: well_ledge
    condition: "true"
    effects: []
  - id: tunnel_out
    area: collapse_tunnel
    to_zone: zone.vel_aram_outer
    to_spawn: tunnel_exit
    condition: "not flag(flag.tunnel_collapsed)"
    effects: ["play_beat(tunnel_falls)"]
interactables:
  - id: houndwright_talk
    area: engine_gallery
    kind: lever
    label: "Approach the Houndwright"
    condition: "not flag(flag.edrin_dealt) and not flag(flag.hound_awake)"
    check: null
    once: false
    effects: ["start_dialogue(dlg.houndwright)"]
  - id: damper
    area: engine_gallery
    kind: lever
    label: "Close the furnace damper"
    condition: "flag(flag.edrin_dealt) and not flag(flag.hound_awake) and not flag(flag.soot_hound_dormant)"
    check: null
    once: true
    effects: ["set_flag(flag.soot_hound_dormant)", "play_beat(hound_banks)"]
  - id: lock_lever
    area: engine_gallery
    kind: lever
    label: "Throw the reliquary lock lever"
    condition: "not flag(flag.reliquary_open)"
    check: null
    once: true
    effects: ["set_flag(flag.reliquary_open)", "play_beat(reliquary_unseals)"]
  - id: furnace_papers
    area: engine_gallery
    kind: readable
    label: "Read the Houndwright's notes"
    condition: "true"
    check: null
    once: true
    effects: ["add_clue(clue.soot_hound_origin)"]
  - id: hidden_catch
    area: sunken_postern
    kind: door
    label: "Press the warden's mark on the back wall"
    condition: "not flag(flag.reliquary_open)"
    check: null
    once: true
    effects: ["set_flag(flag.reliquary_open)", "set_flag(flag.reliquary_by_postern)"]
  - id: warden_tomb
    area: sunken_postern
    kind: container
    label: "Search the warden's tomb"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.warden_maul, 1)", "give_item(item.warden_tablet, 1)"]
  - id: true_page
    area: reliquary
    kind: pickup
    label: "Take the cut page from the reliquary"
    condition: "flag(flag.reliquary_open) and not has_item(item.true_fourth_verse)"
    check: null
    once: true
    effects: ["give_item(item.true_fourth_verse, 1)", "add_clue(clue.reversed_oath)", "play_beat(page_taken)", "reach_milestone(ms.a2_vel_aram_cleared)"]
  - id: rune_tablet
    area: reliquary
    kind: readable
    label: "Read the dwarven rune-tablet"
    condition: "flag(flag.reliquary_open)"
    check: {skill: lore, dc: 6}
    once: true
    effects: ["add_clue(clue.soot_hound_origin)"]
    fail_effects: []
triggers:
  - id: hound_wakes_ledge
    area: hound_pit
    on: enter
    source: null
    condition: "not flag(flag.soot_hound_dormant) and not flag(flag.soot_hound_slain) and not flag(flag.hound_awake)"
    once: true
    effects: ["set_flag(flag.hound_awake)", "set_checkpoint(pit_cp)", "play_beat(hound_wakes)", "start_encounter(enc.va_soot_hound)"]
  - id: hound_wakes_alarm
    area: engine_gallery
    on: beat_done
    source: alarm
    condition: "not flag(flag.soot_hound_dormant) and not flag(flag.soot_hound_slain) and not flag(flag.hound_awake)"
    once: true
    effects: ["set_flag(flag.hound_awake)", "set_checkpoint(pit_cp)", "play_beat(hound_wakes)", "start_encounter(enc.va_soot_hound)"]
  - id: postern_water
    area: sunken_postern
    on: enter
    source: null
    condition: "not flag(flag.cistern_cleared)"
    once: true
    effects: ["start_encounter(enc.va_cistern_drowners)"]
hazards:
  - {id: steam_vents, area: engine_gallery, kind: steam, params: {active_when_beat: hound_wakes, damage_per_second: 8, cycle_s: 4}}
  - {id: pit_soot, area: hound_pit, kind: trap, params: {status: soot, source: enemy_cloud}}
  - {id: postern_water, area: sunken_postern, kind: deep_mud, params: {speed_mult: 0.6}}
checkpoints:
  - {id: vault_landing, area: landing}
  - {id: pit_cp, area: engine_gallery}
  - {id: postern_cp, area: sunken_postern}
beats:
  - {id: alarm, description: "Vault alarm: the Houndwright shouts, or a fight starts near the pit."}
  - {id: hound_wakes, description: "Furnace glow in a mouth of riveted iron; the soot-hound unfolds, chain shrieking on the anchor, and lunges at the end of its reach."}
  - {id: hound_banks, description: "The furnace roar drops to a mutter. The hound's vents dim; it settles on the pit floor like a cooling kiln."}
  - {id: reliquary_unseals, description: "A dwarven pressure-seal sighs; the reliquary door swings in on a breath of cold, clean air."}
  - {id: page_taken, description: "A single vellum leaf, one edge knife-straight where it was cut from a book. Gilt initials. Four lines, the fourth in red."}
  - {id: tunnel_falls, description: "Behind the player the crawl's mouth gives way in a slide of stone and soot."}
npcs:
  - {npc: npc.houndwright_edrin, area: engine_gallery, condition: "not flag(flag.edrin_dealt) and not flag(flag.hound_awake)"}
encounters: [enc.va_soot_hound, enc.va_cistern_drowners]
loot:
  - {container: warden_tomb, items: [{item: item.field_draught, count: 1}], condition: "true"}
variants:
  - id: hound_dead
    when: "flag(flag.soot_hound_slain)"
    description: "The soot-hound lies on its side in the pit, vents cold, chain slack."
    npcs_absent: []
    encounters_disabled: [enc.va_soot_hound]
    interactables_disabled: [damper]
  - id: hound_banked
    when: "flag(flag.soot_hound_dormant)"
    description: "The hound sleeps in the pit, glowing faintly. It does not stir for footsteps on the ledge."
    npcs_absent: []
    encounters_disabled: [enc.va_soot_hound]
    interactables_disabled: []
  - id: tunnel_gone
    when: "flag(flag.tunnel_collapsed)"
    description: "The crawl is choked with rubble."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
```

## 4. NPCs present
**Voice notes.** Prior Ulric: a former sergeant turned preacher, a parade-ground voice, scripture as drill commands. Novice Liss: sixteen, a miller's daughter from near Tigg, whispers, asks questions she has been told not to ask. Yorek: a Strept scout, laconic, contemptuous of Cintrans, honours debts. Houndwright Edrin: a disgraced Cintran siege engineer who learned dwarven pipework from books; he talks to the hound as "she" and to people as obstacles. Brother Cellarer Aumery: precise, cold, an alchemist who sees eggs as reagents and people as vessels.

```yaml npc
id: npc.prior_ulric
name: "Prior Ulric"
faction: faction.choir
role: "Prior of the Vel Aram muster"
motive: "Hold the muster until the Abbot's word, then march the iron up the Stairs."
secret: "He was a sergeant at Marnadal who carried a torch to the clan halls. He believes only fire can wash that off the realm."
disposition: hostile
essential: false
dialogue: dlg.prior_ulric
barks: ["Ranks! The mountain remembers!", "The crown is rotten to the root.", "Burn the proud."]
combat: enemy.choir_zealot
shop: null
```

```yaml npc
id: npc.novice_liss
name: "Novice Liss"
faction: faction.choir
role: "Doubting novice who cleans the Abbot's cell"
motive: "Find out whether what she was promised is true, and get out if it isn't."
secret: "She has read a page of the Abbot's journal while dusting and has not slept since. She knows about the capstone under the well; the old brothers use it to hide wine."
disposition: wary
essential: false
dialogue: dlg.liss
barks: ["The swan sings...", "Please don't tell the Prior I was up.", "Is it true? Any of it?"]
combat: null
shop: null
```

```yaml npc
id: npc.yorek
name: "Yorek"
faction: faction.strept
role: "Strept clan scout, prisoner in the stable cage"
motive: "Get home to Dun Strept and tell Hesk what the Choir is doing in the mountains."
secret: "He was caught watching Choir carts go up the Marnadal Stairs. He knows the naming rite for the Marnadal dead."
disposition: wary
essential: false
dialogue: dlg.yorek
barks: ["Cintran.", "Open it or walk on.", "Water. If you've got it."]
combat: null
shop: null
```

```yaml npc
id: npc.houndwright_edrin
name: "Houndwright Edrin"
faction: faction.choir
role: "Engineer who keeps the soot-hound"
motive: "Keep 'her' fed and working. Be proved right about dwarven engines."
secret: "He hauled the hound out of Ostrel's outer tunnels himself. Its brothers are still down there, and some are not dead."
disposition: neutral
essential: false
dialogue: dlg.houndwright
barks: ["Easy, girl. Easy.", "Don't touch the pipes.", "Coal. More coal."]
combat: enemy.choir_thug
shop: null
```

```yaml npc
id: npc.brother_aumery
name: "Brother Cellarer Aumery"
faction: faction.choir
role: "Former cellarer of St. Corwen, Vel Aram's quartermaster and alchemist"
motive: "Render the wyvern eggs into a blight reagent for the Stairs."
secret: "He prepared the grey lily tinctures for the Queen's communion wine at the Abbey before he came south."
disposition: hostile
essential: false
dialogue: dlg.aumery
barks: ["Reagents do not have mothers.", "Close the door, you're letting the heat out.", "Precision is a kind of prayer."]
combat: enemy.choir_thug
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.prior_ulric
participants: [npc.prior_ulric]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "has_item(item.choir_robe) and has_item(item.pale_feather)", next: disguised}
    else: intruder
  intruder:
    type: line
    speaker: npc.prior_ulric
    text: "A stranger in the house of the swan. Brothers. Here is the old order come to see us. Show it how we answer."
    direction: "On the altar step, a congregation of grey hoods turning in the torchlight."
    effects: ["play_beat(alarm)"]
    next: fight
  disguised:
    type: line
    speaker: npc.prior_ulric
    text: "You. Brother at the back. I don't know your face. Sing me the second line, brother. The swan sings..."
    direction: "Mid-sermon. Every hood turns."
    next: test
  test:
    type: choice
    options:
      - id: lore
        text: "[Lore 6] '...and the old song ends.'"
        tag: lore
        check: {skill: lore, dc: 6, pass: passed, fail: exposed}
      - id: oak
        text: "[Clue: Anselm's cipher] (Recite a verse from the cipher's key-sheet.) 'Read inner to outer, brother. Burn the sheet if taken.'"
        tag: clue
        condition: "has_clue(clue.anselm_cipher)"
        next: passed
      - id: bluff
        text: "[Persuade 8] I'm the Abbot's runner from the Oak, Prior. I sing for him, not for you."
        tag: persuade
        check: {skill: persuade, dc: 8, pass: passed, fail: exposed}
      - id: drop
        text: "(Draw steel.)"
        next: exposed
  passed:
    type: line
    speaker: npc.prior_ulric
    text: "Good. Stand in the rank, brother, and keep your hood up. The Abbot's word comes soon. Then the mountain."
    next: bye
  exposed:
    type: line
    speaker: npc.prior_ulric
    text: "No brother of mine. Take him!"
    effects: ["play_beat(alarm)"]
    next: fight
  fight:
    type: effect
    effects: ["set_checkpoint(nave_cp)", "start_encounter(enc.va_prior)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.liss
participants: [npc.novice_liss]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.novice_liss
    text: "Oh! Brother... no. You're not. Are you here to kill us? Please don't shout. Please."
    direction: "Sitting up on a cot, a candle cupped in her hands."
    next: hub
  hub:
    type: choice
    options:
      - id: who
        text: "Who are you?"
        next: who
      - id: truth
        text: "[Persuade 4] Your Abbot is poisoning the Queen and means to unseal the dwarven vaults. You've read something. I can see it."
        tag: persuade
        check: {skill: persuade, dc: 4, pass: turned, fail: scared}
      - id: clue
        text: "[Clue: Chalice pollen] Grey lily in the Queen's own cup. Your cellarer brews it."
        tag: clue
        condition: "has_clue(clue.chalice_pollen) or has_clue(clue.wenna_sold_priest)"
        next: turned
      - id: threaten
        text: "[Intimidate 6] Talk, or I wake the Prior myself and tell him you helped me."
        tag: intimidate
        check: {skill: intimidate, dc: 6, pass: turned_scared, fail: scared}
      - id: leave
        text: "Go back to sleep."
        next: bye
  who:
    type: line
    speaker: npc.novice_liss
    text: "Liss. From the mill at Coombe, near Tigg. They said the Choir fed the poor and the poor would inherit. I clean the Abbot's cell when he comes. He's not here now."
    next: hub
  scared:
    type: line
    speaker: npc.novice_liss
    text: "I don't know anything. I don't. Please."
    next: hub
  turned:
    type: line
    speaker: npc.novice_liss
    text: "I read a page while I was dusting. About the Queen. About the boy. I haven't slept. The key to his cell is on a hook in the Prior's room. And... the well. There's a stone under the well."
    effects: ["set_flag(flag.postern_found)", "set_flag(flag.liss_turned)"]
    next: escape
  turned_scared:
    type: line
    speaker: npc.novice_liss
    text: "All right! The Abbot's key is on the Prior's hook. The old brothers hide wine under a stone at the bottom of the well. It goes somewhere. That's all. That's all I know."
    effects: ["set_flag(flag.postern_found)"]
    next: escape
  escape:
    type: choice
    options:
      - id: go
        text: "Leave tonight. Go home to the mill, or to Sister Maelis at St. Corwen. Tell her what you read."
        next: go
      - id: stay
        text: "Stay quiet and stay here."
        next: bye
  go:
    type: line
    speaker: npc.novice_liss
    text: "Maelis. The archivist. She was kind to me. All right. All right. Saint keep you, whoever you are."
    effects: ["set_flag(flag.liss_left)", "add_rep(faction.abbey, 5)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.yorek
participants: [npc.yorek]
start: free
nodes:
  free:
    type: line
    speaker: npc.yorek
    text: "A Cintran letting a Strept out of a cage. Now I've seen it. Yorek, of Hesk's people. I owe you."
    direction: "Stretching cramped legs, rubbing rope-burned wrists."
    effects: ["add_rep(faction.strept, 10)"]
    next: hub
  hub:
    type: choice
    options:
      - id: why
        text: "Why did they cage you?"
        next: why
      - id: rite
        text: "Marnadal Field. The dead walk there. Do your people have a way to lay them down?"
        condition: "not flag(flag.torc_rite_known)"
        next: rite
      - id: go
        text: "Go home. Tell Hesk."
        next: go
  why:
    type: line
    speaker: npc.yorek
    text: "Watched their carts go up the Marnadal Stairs. Iron, powder, monks. Into the high passes in autumn. Nobody goes up there in autumn who wants to come down."
    next: hub
  rite:
    type: line
    speaker: npc.yorek
    text: "The naming. Stand at the clan stones, say each clan and its dead, a stone on the wall for each, and end it: 'Home from the mud. Home from the iron. The hill holds you now.' Do it right and they'll go."
    effects: ["set_flag(flag.torc_rite_known)"]
    next: hub
  go:
    type: line
    speaker: npc.yorek
    text: "I'll tell him a Cintran opened the cage. He won't believe me. Come to Dun Strept and make me honest."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.houndwright
participants: [npc.houndwright_edrin]
start: greet
nodes:
  greet:
    type: branch
    cases:
      - {if: "has_item(item.choir_robe) and has_item(item.pale_feather)", next: greet_brother}
    else: greet_stranger
  greet_brother:
    type: line
    speaker: npc.houndwright_edrin
    text: "Mind the pipes, brother. She's touchy tonight. What does the Prior want now?"
    direction: "Shovelling coal into the furnace, back to the player."
    next: hub
  greet_stranger:
    type: line
    speaker: npc.houndwright_edrin
    text: "You're not a brother. Don't move. One shout and she wakes, and then you're soot. Who are you?"
    direction: "A hand on the alarm chain over the furnace."
    next: hub
  hub:
    type: choice
    options:
      - id: what
        text: "What is that thing?"
        next: what
      - id: prior
        text: "[Persuade 6] The Prior wants her banked for the night. Close the damper."
        tag: persuade
        condition: "has_item(item.choir_robe)"
        check: {skill: persuade, dc: 6, pass: banked, fail: suspicious}
      - id: threat
        text: "[Intimidate 6] Let go of the chain, close the damper, and walk up those stairs. Or I put you in the pit with her."
        tag: intimidate
        check: {skill: intimidate, dc: 6, pass: banked_scared, fail: suspicious}
      - id: pride
        text: "[Lore 6] Dwarven pressure-boilers. You're running her too hot; the rivets on the third collar are weeping. She'll burst."
        tag: lore
        check: {skill: lore, dc: 6, pass: banked_pride, fail: suspicious}
      - id: grab
        text: "(Rush him before he pulls the chain.)"
        next: grabbed
      - id: leave
        text: "(Back away.)"
        next: bye
  what:
    type: line
    speaker: npc.houndwright_edrin
    text: "A gate-hound of Karak Ostrel. Pressure-iron, a coal heart, soot for breath. I dragged her out of the outer tunnels on rollers. Her brothers are still down there. Some of them twitch."
    effects: ["add_clue(clue.soot_hound_origin)"]
    next: hub
  banked:
    type: line
    speaker: npc.houndwright_edrin
    text: "Banked? Now? He's never... fine. Fine. She'll sleep like a stone. Don't blame me if she's slow to wake for the Abbot."
    effects: ["set_flag(flag.edrin_dealt)"]
    next: bye
  banked_scared:
    type: line
    speaker: npc.houndwright_edrin
    text: "All right. All right! Damper's the long lever. I'm going. I'm going."
    direction: "He goes up the stair at a run. He does not raise the alarm; he does not stop running."
    effects: ["set_flag(flag.edrin_dealt)"]
    next: bye
  banked_pride:
    type: line
    speaker: npc.houndwright_edrin
    text: "The third collar? ...God's bones, you're right. Bank her, bank her, the long lever, quick, before she cracks. You know engines? Who are you?"
    effects: ["set_flag(flag.edrin_dealt)"]
    next: bye
  suspicious:
    type: line
    speaker: npc.houndwright_edrin
    text: "Wake up, girl!"
    direction: "He hauls on the alarm chain."
    effects: ["play_beat(alarm)"]
    next: bye
  grabbed:
    type: line
    speaker: npc.houndwright_edrin
    text: "No, no, no..."
    direction: "The player pins him before his hand closes on the chain."
    effects: ["set_flag(flag.edrin_dealt)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.aumery
participants: [npc.brother_aumery]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.brother_aumery
    text: "Close the door, you're letting the heat out. Who sent you? No matter. Stand there and be quiet, I'm about to open the first one."
    direction: "At the bench, a mallet and chisel poised over a speckled egg the size of a helmet."
    next: hub
  hub:
    type: choice
    options:
      - id: stop
        text: "[Intimidate 4] Put the mallet down. Now."
        tag: intimidate
        check: {skill: intimidate, dc: 4, pass: stopped, fail: cracks}
      - id: prior
        text: "[Persuade 6] The Prior wants them whole. The Abbot means them as a gift for the mountain."
        tag: persuade
        condition: "has_item(item.choir_robe)"
        check: {skill: persuade, dc: 6, pass: stopped_fooled, fail: cracks}
      - id: lily
        text: "You brewed the Queen's lily, didn't you, Cellarer?"
        next: lily
      - id: attack
        text: "(Attack him.)"
        next: fight
      - id: watch
        text: "(Watch.)"
        next: cracks
  lily:
    type: line
    speaker: npc.brother_aumery
    text: "Measured to the grain, in the Abbey kitchen, for her communion. Precision is a kind of prayer. Why? Will you weep for a queen? She would not weep for you."
    effects: ["add_clue(clue.cellarer_brewed_lily)"]
    next: hub
  stopped:
    type: line
    speaker: npc.brother_aumery
    text: "Barbarian. Very well. Take them, then, and carry them in your shirt like a hen. The mother will smell you from the mountain."
    effects: ["set_flag(flag.cellarer_dealt)"]
    next: bye
  stopped_fooled:
    type: line
    speaker: npc.brother_aumery
    text: "A gift. For the mountain. How poetic of him. Take them, then. Keep them warm or they're worthless."
    effects: ["set_flag(flag.cellarer_dealt)"]
    next: bye
  cracks:
    type: line
    speaker: npc.brother_aumery
    text: "Watch carefully. This is how the world ends: with a chisel."
    effects: ["set_flag(flag.cellarer_dealt)", "set_flag(flag.eggs_lost)", "play_beat(egg_cracked)", "start_encounter(enc.va_reagent)"]
    next: bye
  fight:
    type: effect
    effects: ["set_flag(flag.cellarer_dealt)", "play_beat(alarm)", "start_encounter(enc.va_reagent)"]
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.va_sentries
zone: zone.vel_aram_outer
enemies:
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: tower_stump, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: wall_south, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: va_arrival
avoidable_by: []
on_won: []
on_yielded: []
on_player_fled: []
```
Design: S1 (tower stump, sentry posture, faces down the ravine; turns to face the ward every 20 s) and S2 (wall walk, patrol posture). Both engage on alarm and keep to range (gdd §6.7). With the trip-line cut, S1 can be passed crouched along the ravine's west wall while he faces the ward.

```yaml encounter
id: enc.va_patrol_a
zone: zone.vel_aram_outer
enemies:
  - {enemy: enemy.choir_zealot, count: 2, spawn: tents, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: va_arrival
avoidable_by: ["dlg.yorek"]
on_won: []
on_yielded: []
on_player_fled: []
```
Design: patrol posture, clockwise round the ward perimeter: barbican → stable → well house → gatehouse → wall stair (about 70 s). They pass the well house 20 s after the gatehouse, which is the window to descend unseen. Removed by the forged dispatch.

```yaml encounter
id: enc.va_muster
zone: zone.vel_aram_outer
enemies:
  - {enemy: enemy.choir_zealot, count: 3, spawn: tents, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 2, spawn: tents, variant: null}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.choir_zealot, count: 2, spawn: keep_door, variant: null}]}
attack_tokens: null
allow_yield: true
allies: []
checkpoint: va_arrival
avoidable_by: []
on_won: ["add_rep(faction.crown, 5)"]
on_yielded: ["add_clue(clue.choir_at_vel_aram)"]
on_player_fled: []
```
Design: dormant in the tents (not placed as patrols); spawns on the outer alarm. This is the "storm the gate" fight. Zealots self-immolate at 0 HP; the tents burn. The guaranteed path is to fight it at the barbican choke, then go in by the gatehouse.

```yaml encounter
id: enc.va_patrol_b
zone: zone.vel_aram_sanctum
enemies:
  - {enemy: enemy.choir_zealot, count: 2, spawn: transept, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: nave_cp
avoidable_by: []
on_won: []
on_yielded: []
on_player_fled: []
```
Design: patrol posture, nave → north transept → nave (about 50 s), pausing 5 s at the undercroft stair. The bell-tower stair is in the transept, so the rope is best cut on their far leg. Removed by the forged dispatch.

```yaml encounter
id: enc.va_prior
zone: zone.vel_aram_sanctum
enemies:
  - {enemy: enemy.choir_zealot, count: 1, spawn: nave_door, variant: prior}
  - {enemy: enemy.choir_zealot, count: 2, spawn: transept, variant: null}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.choir_crossbowman, count: 2, spawn: chapter, variant: null}]}
attack_tokens: null
allow_yield: true
allies: []
checkpoint: nave_cp
avoidable_by: ["dlg.prior_ulric"]
on_won: ["set_flag(flag.prior_ulric_dead)", "give_item(item.cell_key, 1)"]
on_yielded: ["set_flag(flag.prior_ulric_dead)", "give_item(item.cell_key, 1)"]
on_player_fled: []
```
Design: the Prior's variant has elite stats (about 140 HP, the fervour buff from the start). Kicking the pew-stacks into the aisle triggers the vault collapse onto the second wave. The Prior never yields; "yielded" here covers his last zealots surrendering after his death.

```yaml encounter
id: enc.va_bell_reinforcements
zone: zone.vel_aram_sanctum
enemies:
  - {enemy: enemy.choir_zealot, count: 2, spawn: nave_door, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: nave_door, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: nave_cp
avoidable_by: []
on_won: []
on_yielded: []
on_player_fled: []
```
Design: arrives from the outer ward when the bell rings. Cancelled by cutting the bell rope.

```yaml encounter
id: enc.va_reagent
zone: zone.vel_aram_sanctum
enemies:
  - {enemy: enemy.choir_thug, count: 1, spawn: reagent, variant: alchemist}
  - {enemy: enemy.choir_zealot, count: 1, spawn: reagent, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: nave_cp
avoidable_by: ["dlg.aumery"]
on_won: ["add_clue(clue.cellarer_brewed_lily)"]
on_yielded: ["add_clue(clue.cellarer_brewed_lily)"]
on_player_fled: []
```
Design: Aumery (alchemist variant: throws glass flasks that burst into a poison cloud) and his zealot assistant. The alembics shatter and spread a poison patch. If the eggs were cracked, the second egg is lost in the brazier.

```yaml encounter
id: enc.va_soot_hound
zone: zone.vel_aram_vault
enemies:
  - {enemy: enemy.soot_hound, count: 1, spawn: pit_anchor, variant: null}
waves: []
attack_tokens: 1
allow_yield: false
allies: []
checkpoint: pit_cp
avoidable_by: ["dlg.houndwright"]
on_won: ["set_flag(flag.soot_hound_slain)", "add_rep(faction.crown, 5)"]
on_yielded: []
on_player_fled: []
```
Design (boss, gdd §6.7): the hound is chained, so its reach is a 10 m circle from the anchor plus the chain-lunge (a 2 m surge at the chain's end, telegraphed by the chain going taut with a shriek). Phase 1: chain-lunges and soot clouds (Soot status, darkened vision) that pool in the pit. The ledge outside the circle is safe for crossbow fire, but the soot rises. After a stagger, the back vent opens (weak point ×2; Mane-Cleaver ×2 vs construct). At 50% the furnace overpressures: the steam vents in the engine gallery fire on a 4 s cycle and the hound tears the chain anchor half-loose, extending its reach to 14 m. Closing the damper mid-fight is not possible (the lever jams when it is awake); that is the whole point of doing it beforehand. Poison is useless (immune), and fire is resisted; blunt weapons such as the warden's maul hit hard.

```yaml encounter
id: enc.va_cistern_drowners
zone: zone.vel_aram_vault
enemies:
  - {enemy: enemy.drowner, count: 2, spawn: postern_deep, variant: null}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.drowner, count: 1, spawn: postern_cistern, variant: null}]}
attack_tokens: null
allow_yield: false
allies: []
checkpoint: postern_cp
avoidable_by: []
on_won: ["set_flag(flag.cistern_cleared)"]
on_yielded: []
on_player_fled: []
```
Design: two drowners in waist-deep black water, a third from behind once they are dead. The tomb niche is dry ground for fighting.

## 7. Items and clues

```yaml item
id: item.anselm_journal
name: "Anselm's private journal"
category: document
description: "A worn octavo in a scholar's cramped hand, the covers stained with candle-smoke and wine. The Abbot's own words."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Marnadal, 1263. I blessed the charge and then I watched them burn the halls with the children in them, and the Marshal had his indemnity counted by noon. There is no reforming this. There is only fire. -- The Queen trusts me with her soul and her cup. A grain of the witch's lily each communion. She will fade like a saint and no physician will name it. -- The smith at Assengard has written to her. His courier will not arrive. -- I have cut the fourth verse from the Book and given the Marshal's hireling a pretty false one, 'from memory'. The girl Maelis noticed the cut. Watch her. -- The Pact, read straight, locks the vaults for nineteen winters: By iron forged in mountain deep, / By lion's blood the watch we keep. / Let bolt and bar hold fast the night, / Till nineteen winters turn to light. -- Read backward by royal blood at the throne in the control chamber, it is a key: From light to dark the winters turn, / Let bar and bolt to ashes burn. / By lion's blood the gates unbind, / Wake what the mountain left behind. -- Royal blood is not enough; the lock knows the Crown. So she must live long enough to crown the boy. Then he comes to me. The boy listens. He already says the old words in his sleep. -- The merchant duke is a lever. When the dark wakes, his ports burn first. -- At the turning of the year, the old order ends. God forgive me. No. God will understand."
```

```yaml item
id: item.true_fourth_verse
name: "The authentic fourth verse"
category: key
description: "A single vellum leaf cut from the Book of the Lion, one edge knife-straight. Gilt initials, four lines of the Pact, the fourth in red. Anselm's note in the margin."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "The Pact of the Lion and the Mountain, to be spoken at the Ring by the crowned sovereign, and at the Throne beneath Ostrel when the lock calls. By iron forged in mountain deep, / By lion's blood the watch we keep. / Let bolt and bar hold fast the night, / (in red) Till nineteen winters turn to light. -- (margin, Anselm's hand) Reversed: From light to dark the winters turn, / Let bar and bolt to ashes burn. / By lion's blood the gates unbind, / Wake what the mountain left behind."
```

```yaml item
id: item.wyvern_eggs
name: "Two wyvern eggs"
category: key
description: "Speckled bronze-green eggs the size of helmets, still warm, wrapped in sacking. Something inside one of them knocks."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.cell_key
name: "The Abbot's cell key"
category: key
description: "A plain iron key from the Prior's hook."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.va_muster_roll
name: "Vel Aram muster roll"
category: document
description: "The Prior's roll of sworn brothers, by name and by trade."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Sworn at Vel Aram: thirty-one. Of St. Corwen: twelve. Hired blades: nine. Of the palace: (names withheld, kept by the Abbot). Ordered: hold until word. Then the Stairs, the powder, the iron. The hound goes up last, with the Houndwright."
```

```yaml item
id: item.warden_maul
name: "Warden's maul"
category: weapon
description: "A long-hafted iron maul from a pre-Cintran captain's tomb, its head cut with a ring-and-mountain mark. Made for breaking things that do not bleed."
price: 220
stack_max: 1
equip_slot: main_hand
weapon: {base: 17, type: blunt, block_pct: 0.65, armor_pen: 15, bonus_vs: {construct: 1.25, undead: 1.25}, moveset: mace}
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.warden_tablet
name: "Warden's slate"
category: document
description: "A slate tablet from the warden's tomb, scratched in an older script that Lore can half-read."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "We watched the mountain before the Lion. When the dwarves shut their doors, we watched the doors. When the Lion made his Pact, we kept a copy of the words in stone at the clans' hearth, against the day a king forgot them."
```

```yaml clue
id: clue.anselm_journal
theory: theory.anselm_plan
title: "The Abbot's own hand"
text: "Anselm's journal confesses it all: grey lily in the Queen's communion cup, Dravin's courier silenced, the fourth verse cut out and a false one given to Maelis, and a plan to let the Queen crown Aldric and then take the boy to the throne beneath Ostrel."
supports: [anselm]
refutes: [varn, raimund]
```

```yaml clue
id: clue.reversed_oath
theory: theory.anselm_plan
title: "The Pact spoken backward"
text: "Spoken backward by royal blood at the control throne in Karak Ostrel, the Pact unlocks the vaults instead of sealing them: 'From light to dark the winters turn, / Let bar and bolt to ashes burn. / By lion's blood the gates unbind, / Wake what the mountain left behind.'"
supports: [anselm]
refutes: []
```

```yaml clue
id: clue.soot_hound_origin
theory: theory.anselm_plan
title: "A gate-hound out of Ostrel"
text: "The soot-hound is a dwarven gate-guard dragged out of Karak Ostrel's outer tunnels on rollers. The Choir already has a way into the outer works, and the things left down there are beginning to stir."
supports: []
refutes: []
```

```yaml clue
id: clue.cellarer_brewed_lily
theory: theory.poisoner
title: "The cellarer's tincture"
text: "Brother Cellarer Aumery measured grey lily 'to the grain' for the Queen's communion wine in the Abbey kitchen before he came south to Vel Aram."
supports: [anselm]
refutes: [varn]
```

```yaml clue
id: clue.throne_sketch
theory: theory.anselm_plan
title: "The chamber with the mirror-shafts"
text: "A charcoal sketch in Anselm's cell: a round vault, a black throne at its heart, four shafts angled to catch a low sun. A note: 'first light on the throne at the solstice'."
supports: [anselm]
refutes: []
```

```yaml deduction
id: ded.anselm_treason_proven
theory: theory.anselm_plan
condition: "has_clue(clue.anselm_journal) or (has_clue(clue.anselm_cipher) and has_clue(clue.raimund_ledger_silver))"
title: "Abbot Anselm is the traitor"
text: "Anselm's own hand, or his cipher's orders plus Abbey silver in the Duke's ledger: the Queen's confessor poisoned her, leads the Pale Choir, and paid for the lily. This is proof enough for Kosk to hang him."
```

```yaml deduction
id: ded.reversed_oath_plan
theory: theory.anselm_plan
condition: "has_clue(clue.reversed_oath)"
title: "The lock is a key"
text: "Anselm does not need to break Ostrel's vaults. He needs a crowned child of the Lion to speak the Pact backward at the control throne. That is why the Queen must live long enough to crown Aldric."
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.a2_vel_aram_cleared, type: milestone, desc: "The player took the true fourth verse from Vel Aram's reliquary; the muster marches."}
  - {id: flag.trip_line_cut, type: bool, desc: "The barbican bell-line is cut."}
  - {id: flag.yorek_freed, type: bool, desc: "Yorek the Strept scout was freed (Strept +10; naming rite). Read by a2.04 and act3 Dun Strept."}
  - {id: flag.postern_found, type: bool, desc: "The player found the capstone under the well (the sunken postern)."}
  - {id: flag.va_outer_alarm, type: bool, desc: "The outer works raised the alarm; the muster engaged."}
  - {id: flag.va_left_after_clear, type: bool, desc: "Internal: the muster-marches beat has played."}
  - {id: flag.va_sermon_seen, type: bool, desc: "Prior Ulric's sermon played."}
  - {id: flag.va_sanctum_alarm, type: bool, desc: "The sanctum raised the alarm."}
  - {id: flag.bell_rope_cut, type: bool, desc: "The bell rope was cut; no reinforcements from the ward."}
  - {id: flag.powder_blown, type: bool, desc: "The cellarer's powder kegs exploded."}
  - {id: flag.prior_ulric_dead, type: bool, desc: "Prior Ulric fell."}
  - {id: flag.liss_turned, type: bool, desc: "Novice Liss was persuaded of the truth."}
  - {id: flag.liss_left, type: bool, desc: "Liss left for the mill or for Maelis. Read by act3 or side (Maelis knows more)."}
  - {id: flag.cellarer_dealt, type: bool, desc: "Aumery was stopped, fooled or fought."}
  - {id: flag.eggs_lost, type: bool, desc: "Aumery cracked the eggs; the wyvern cannot be placated in Act III. Read by act3 Wyvern's Roost."}
  - {id: flag.edrin_dealt, type: bool, desc: "The Houndwright was talked down, frightened off or seized."}
  - {id: flag.hound_awake, type: bool, desc: "The soot-hound woke."}
  - {id: flag.soot_hound_dormant, type: bool, desc: "The furnace damper was closed; the hound sleeps."}
  - {id: flag.soot_hound_slain, type: bool, desc: "The soot-hound was destroyed."}
  - {id: flag.cell_open, type: bool, desc: "Anselm's cell door is open (key, lock check, or after the milestone)."}
  - {id: flag.reliquary_open, type: bool, desc: "The reliquary door is open."}
  - {id: flag.reliquary_by_postern, type: bool, desc: "The reliquary was opened from the secret postern."}
  - {id: flag.cistern_cleared, type: bool, desc: "The cistern drowners are dead."}
  - {id: flag.tunnel_collapsed, type: bool, desc: "The escape crawl collapsed behind the player."}
reads:
  - flag.forged_dispatch_planted
  - flag.oswy_returned
  - flag.oak_courier_escaped
  - flag.torc_rite_known
  - clue.chalice_pollen
  - clue.wenna_sold_priest
  - clue.anselm_cipher
  - clue.raimund_ledger_silver
  - clue.marnadal_chaplain
```

## 9. Quest hooks
Contributes the required objectives `true_verse` and `proof` (through `ded.anselm_treason_proven`, declared here) and the optional `lead_vel_aram` of `quest.main_a2/the_marnadal_road` (declared in `a2.01`).

Act III hooks: `item.wyvern_eggs` (Wyvern's Roost), `flag.eggs_lost` (the eggs cannot be returned), `flag.yorek_freed` (a friendly voice at Dun Strept), `clue.soot_hound_origin` (Ostrel's outer works are open), `item.warden_tablet` (foreshadows the standing stone at Dun Strept), `item.warden_maul` (a blunt weapon against iron-wardens, which are weak to blunt).

## 10. Rumors and event cards (optional)
The valley card "Charcoal burners saw hooded monks" (gdd §6.3, slot 4) pins this node. Owned by the side slice.

## 11. Failure states and branches

```yaml branches
paths:
  - id: storm
    when: "Player goes in through the barbican and fights the muster, the Prior and the hound."
    outcome: "Every room open by force; the page; ms.a2_vel_aram_cleared."
    sets: ["reach_milestone(ms.a2_vel_aram_cleared)"]
  - id: disguise
    when: "Player wears a Choir robe and a pale feather (from the Oak or the armory) and passes the Prior's test (Lore 6, the cipher clue, or Persuade 8)."
    outcome: "Walk the sanctum as a brother; restricted rooms still need stealth."
    sets: []
  - id: postern
    when: "Player finds the capstone (Investigate 6 at the well, or from Liss), wades the sunken postern, and presses the hidden catch."
    outcome: "Reliquary from behind with no hound fight; the warden's maul; the page."
    sets: ["reach_milestone(ms.a2_vel_aram_cleared)"]
  - id: hound_banked
    when: "Player deals with Edrin (Persuade 6 disguised, Intimidate 6, Lore 6, or rushing him) and closes the damper."
    outcome: "The hound sleeps; the north ledge is safe."
    sets: ["set_flag(flag.soot_hound_dormant)"]
  - id: eggs_saved
    when: "Player stops Aumery (Intimidate 4, or Persuade 6 disguised), or enters the reagent store and lifts the eggs before talking."
    outcome: "item.wyvern_eggs for Act III."
    sets: []
  - id: eggs_lost
    when: "Player watches, fails the check, or attacks Aumery before he is stopped."
    outcome: "flag.eggs_lost; Act III Roost must be fought or climbed."
    sets: ["set_flag(flag.eggs_lost)"]
failures:
  - id: player_dies
    result: reload_checkpoint
    recover: "Reload va_arrival, well_cp, nave_cp, pit_cp or postern_cp."
  - id: cell_locked
    result: soft_fail
    recover: "No key and a failed lock check: smash the cell door after the Prior dies (he drops the key), or return after the milestone (the cell stands open)."
  - id: journal_trap
    result: soft_fail
    recover: "A failed disarm poisons; the 'smash' option always yields the journal."
guarantees:
  - "ms.a2_vel_aram_cleared is reachable with no check: fight in through the gatehouse, down the undercroft stair, throw the lock lever, defeat the soot-hound, take the page."
  - "item.anselm_journal is reachable with no check: the Prior drops the cell key (enc.va_prior), and journal_box_smash needs none."
  - "The Vel Aram node itself is always reachable: ded.choir_muster_vel_aram unlocks from clue.jory_iron_crates, which a2.03 guarantees without a check."
```

## 12. Open questions
- **Prior Ulric's variant** (`enemy.choir_zealot`, `variant: prior`) and **Aumery's** (`enemy.choir_thug`, `variant: alchemist`) need variant rows in enemy data. Neither is a new archetype.
- **Patrol schema:** patrol routes and loop times are given in prose and area descriptions. The `encounter` block has no `posture` or route field (see also a2.02). Proposed: `posture: patrol|sentry|dormant` and `route: [area ids]`.
- **Hazard parameters** (`bell_line`, `powder`, `steam_vents`) use free-form `params`. The zone runtime needs to agree on the keys `on_trigger_beat`, `ignites_on`, `active_when_beat` and `disabled_by_flag`.
- **Item scope:** `item.warden_maul`'s `bonus_vs: {undead: 1.25}` uses a tag (`undead`) that exists on revenants (gdd §6.7). It does not invent a new mechanic, but tuning should confirm it.
- The journal says Anselm gave the false verse to "the Marshal's hireling" (the player) "from memory", matching story.md §5.4. If act1 delivers it differently, adjust that one line.
