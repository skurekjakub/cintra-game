---
section_id: a2.06
title: "Attre: The Masquerade and the Warehouse"
act: 2
story_ref: "story.md §2 Duchy of Attre, §3 Duke Raimund, §6 Attre (Masquerade & Warehouse Raid), §10 Morrow Gull / Skerra (hooks); gdd §6.1 stage 3, §6.2 sell to Raimund, §6.5 stealth"
zones: [zone.attre_harbor, zone.attre_masquerade, zone.attre_warehouse]
available_when: "ms(ms.act1_complete) and not ms(ms.act2_twist)"
escalation_stage_required: {min: 1, max: 3}
milestones_set: [ms.a2_attre_ledger]
milestones_read: [ms.act1_complete, ms.act2_twist]
level_band: [6, 8]
---

# Attre: The Masquerade and the Warehouse

## 1. Scene summary
Attre is a free port of white walls and black water, and Duke Raimund means to make it a kingdom the day Ysolde dies. His smugglers raided Wenna's mere for the Choir and dried the grey lily in **Warehouse Nine**. Some bulbs went north through Gull Tower; the last four sit in two crates in the drying loft, waiting for the Abbey's man to pay the balance. Raimund's private shipping ledger, locked in his study at the **Anchor House**, proves that Abbey silver paid for it all. The Duke's autumn masquerade fills the Anchor House whenever the player climbs the palazzo steps (a fixed night look, not a schedule). The player can get in with an invitation (forged, bought or begged), by the servants' gate, or up the sea stair. Inside they can overhear the Duke selling to a Choir buyer, steal the ledger, and discover that the Duke's own nine-year-old son is coughing himself to death from the lily dust he breathed playing in the drying loft. Then the player decides what Raimund is: a mark to blackmail, an ally to buy, or a father to sell a cure to. The warehouse raid is either quiet (both crates saved), loud (the foreman torches whatever is still in the loft), or unnecessary (Raimund signs the crates over). The dramatic question: will the player use a grieving man's weakness, and what will they trade for it? The section ends when the ledger is in the player's hands (`ms.a2_attre_ledger`). The bulbs and the alliance are separate outcomes.

## 2. Progress and escalation
- `ms.a2_attre_ledger` is set when `item.raimund_ledger` is obtained: stolen from the study strongbox (stealth, a check, a key, or by force), or handed over by Raimund once allied.
- **Bulbs:** two crates of 2 bulbs each in the warehouse loft (`crate_east`, `crate_west`). Each crate looted gives `give_item(item.grey_lily_bulbs, 2)` and `add_var(var.bulbs_recovered, 2)`. If the warehouse **alarm** fires while foreman Gaspard is still free and no release writ was shown, Gaspard torches every crate not yet looted (`flag.crate_east_burned`, `flag.crate_west_burned`) and Attre reputation drops 30 (loud raid).
- **Raimund outcomes:** blackmail (`flag.raimund_blackmailed`, Attre −10, crates released); alliance (`flag.raimund_allied`, Attre +50, crates released, ledger handed over, no stage-3 fortification); antidote sold (`flag.antidote_sold_raimund`, Attre +50, +300 crowns, Crown −10).
- **Stage 1–2:** as written. **Stage 3:** the land gate is fortified (gdd §6.1). Arriving by road without `item.masquerade_invitation`, without the Skerra cutter, and with Attre below Allied triggers the checkpoint (`dlg.attre_checkpoint`: bribe, persuade, or fight). Choir buyers no longer hide their feathers at the ball.

## 3. Location layout

**Attre harbour** (day, hub, about 180 × 120 m). The **land gate** (road arrivals; the stage-3 checkpoint has a barricade of wine casks, three ducal guards and a sergeant) opens onto the **fish market** (stalls, the chandler's shop, gulls). The **quay** runs along the water (sea arrivals: the Skerra cutter, Jory's barge, hired boats to the Morrow Gull wreck). **Forger's lane** is a stepped alley off the market where Velia keeps a "bookbinder's" shop. **The Gilded Gull** tavern is on the quay (rest, rumors). At the north end, the **palazzo steps** climb to the Anchor House gate (exit to the masquerade). At the south end, **warehouse row** is a line of tall tarred warehouses on piles (exit to Warehouse Nine). Below the palazzo, **the rocks** (reached from the quay's end at low water) lead to the foot of the **sea stair**.

**The Anchor House masquerade** (night, interior and terraces, about 70 × 60 m on two floors, `disguise_tag: masquerade`).
- *Ground floor:* **front court** (gate, two guards checking invitations; permitted with the invitation), **ballroom** (40 × 20 m, masked dancers, musicians' gallery, pillars as cover; permitted), **orangery** (glass house, lemon trees in tubs, a stone bench where Raimund meets the Choir buyer; a hiding spot behind the trees; permitted), **kitchens** and the **servants' passage** (restricted for guests, permitted for nobody: crouch and shadow), **wine cellar** (restricted; a barred door to the sea stair tunnel).
- *Upper floor:* **gallery** (restricted, long corridor of portraits, one guard patrolling end to end), **study** (restricted; desk with a false drawer, iron strongbox, sea window), **heir's chamber** (restricted; Aimeric's sickbed, his nurse; Raimund lets the player in if invited).
- **Terrace:** a balcony over the sea at the ballroom's end (permitted), where private talks happen. The **sea stair** comes up from the rocks to a gate under the terrace (restricted until the player reaches the terrace itself).

Patrol layout: **G1** walks the gallery end to end (12 s each way, 3 s pause at each end, facing the window at the study end). **G2** stands at the servants' passage door and turns every 8 s. **G3/G4** stand at the front court gate. **Lucan** the steward circulates ballroom → orangery → kitchens on a 60 s loop.

**Warehouse Nine** (night, interior, about 60 × 40 m plus the yard).
- **Yard gate** (land entrance from warehouse row, the night watchman's booth; Old Pieter).
- **Bonded yard** (20 × 25 m: stacked casks, a crane, lanterns on poles; patrol **Y1/Y2** walk a figure-eight round the cask stacks).
- **Counting house** (a lit office by the gate: clerk's desk, manifest book, the strongroom key on a nail).
- **Strongroom** (locked; Abbey-stamped silver ingots in a chest).
- **Main hall** (bales, hanging ropes, a rope-hoist to the loft; patrol **H1** walks the length of the hall).
- **Drying loft** (upper floor over the hall: racks of grey lily hung to dry, the dust hangs in the lantern light (`trap` hazard: poison while fighting in the dust); **crate_east** and **crate_west** at either end; foreman Gaspard at his table between them with a lit lamp and a can of lamp oil).
- **Sea gate** (water entrance under the hall; a skiff tied inside; reached by swimming from the quay).
- **Roof** (skylight into the loft, reached from the neighbouring warehouse's roof by a plank).

```yaml zone
id: zone.attre_harbor
name: "Attre Harbour"
kind: hub
map_node: map.attre
time_of_day: day
cold_rate: 0
disguise_tag: null
music: attre_harbour
areas:
  - {id: land_gate, description: "Road arrivals. At stage 3 a barricade of wine casks, three ducal guards and a sergeant."}
  - {id: fish_market, description: "Stalls, gulls, the chandler's shop."}
  - {id: quay, description: "Waterfront: sea arrivals, Jory's barge mooring, boats for hire."}
  - {id: forgers_lane, description: "Stepped alley off the market. Velia's 'bookbinder' shop."}
  - {id: gilded_gull, description: "Quay tavern: rest, rumors."}
  - {id: palazzo_steps, description: "Steps up to the Anchor House gate (masquerade)."}
  - {id: warehouse_row, description: "Tall tarred warehouses on piles. Warehouse Nine at the end."}
  - {id: rocks, description: "Below the palazzo cliff, reached from the quay's end. Foot of the sea stair."}
spawns:
  - {id: land_gate, area: land_gate, default: true}
  - {id: quay, area: quay}
  - {id: palazzo_steps, area: palazzo_steps}
  - {id: warehouse_row, area: warehouse_row}
  - {id: rocks, area: rocks}
exits:
  - id: to_masquerade_front
    area: palazzo_steps
    to_zone: zone.attre_masquerade
    to_spawn: front_gate
    condition: "true"
    effects: []
  - id: to_masquerade_servants
    area: palazzo_steps
    to_zone: zone.attre_masquerade
    to_spawn: servants_gate
    condition: "flag(flag.servants_gate_open)"
    effects: []
  - id: to_sea_stair
    area: rocks
    to_zone: zone.attre_masquerade
    to_spawn: sea_stair
    condition: "true"
    effects: []
  - id: to_warehouse_gate
    area: warehouse_row
    to_zone: zone.attre_warehouse
    to_spawn: yard_gate
    condition: "true"
    effects: []
  - id: to_warehouse_roof
    area: warehouse_row
    to_zone: zone.attre_warehouse
    to_spawn: roof
    condition: "true"
    effects: []
  - id: to_warehouse_sea
    area: quay
    to_zone: zone.attre_warehouse
    to_spawn: sea_gate
    condition: "true"
    effects: []
  - {id: quay_board, area: quay, to_map: true, label: "Harbour master's board (travel by land or sea)", condition: "true", effects: []}
interactables:
  - id: gull_bed
    area: gilded_gull
    kind: rest
    label: "Take a room at the Gilded Gull (rest)"
    condition: "true"
    check: null
    once: false
    effects: ["heal_player(full)", "set_checkpoint(harbour_rest)"]
  - id: servants_porter
    area: palazzo_steps
    kind: lever
    label: "Talk to the kitchen porter at the side door"
    condition: "not flag(flag.servants_gate_open)"
    check: null
    once: false
    effects: ["start_dialogue(dlg.attre_porter)"]
triggers:
  - id: checkpoint
    area: land_gate
    "on": enter
    source: null
    condition: "stage() >= 3 and rep_tier(faction.attre) < allied and not flag(flag.raimund_allied) and not has_item(item.masquerade_invitation) and not flag(flag.skerra_cutter) and not flag(flag.attre_checkpoint_passed)"
    once: false
    effects: ["set_checkpoint(harbour_gate)", "start_dialogue(dlg.attre_checkpoint)"]
hazards: []
checkpoints:
  - {id: harbour_gate, area: land_gate}
  - {id: harbour_rest, area: gilded_gull}
beats: []
npcs:
  - {npc: npc.velia, area: forgers_lane, condition: "true"}
  - {npc: npc.dame_fenna, area: fish_market, condition: "true"}
  - {npc: npc.attre_tapster, area: gilded_gull, condition: "true"}
  - {npc: npc.sergeant_arnaut, area: land_gate, condition: "stage() >= 3"}
encounters: [enc.attre_checkpoint]
loot: []
variants:
  - id: fortified
    when: "stage() >= 3 and rep_tier(faction.attre) < allied and not flag(flag.raimund_allied)"
    description: "Cask barricade at the land gate, ducal pennants on every mast, a chain across the harbour mouth at night."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: allied_port
    when: "flag(flag.raimund_allied)"
    description: "Choir notices torn down on the quay; a ducal crier reads a ban on 'grey-robed brethren'."
    npcs_absent: []
    encounters_disabled: [enc.attre_checkpoint]
    interactables_disabled: []
```

```yaml zone
id: zone.attre_masquerade
name: "The Anchor House"
kind: interior
map_node: map.attre
time_of_day: night
cold_rate: 0
disguise_tag: masquerade
music: masquerade_waltz
areas:
  - {id: front_court, description: "Gate and lantern court. Two guards check invitations. Permitted with the invitation."}
  - {id: ballroom, description: "40 x 20 m, masked dancers, musicians' gallery, pillars as cover. Permitted."}
  - {id: orangery, description: "Glass house, lemon trees in tubs, a stone bench. A hiding spot behind the trees. Permitted."}
  - {id: kitchens, description: "Ovens, servants, the servants' passage door (G2). Restricted."}
  - {id: wine_cellar, description: "Barrel vaults; a barred door to the sea-stair tunnel. Restricted."}
  - {id: gallery, description: "Upper corridor of portraits, 30 m. G1 patrols end to end. Restricted."}
  - {id: study, description: "Raimund's study: desk with a false drawer, iron strongbox, sea window. Restricted."}
  - {id: heirs_chamber, description: "Aimeric's sickbed, a nurse, shuttered windows, a smell of camphor. Restricted unless invited."}
  - {id: terrace, description: "Balcony over the sea at the ballroom's end. Permitted. The sea-stair gate is below it."}
spawns:
  - {id: front_gate, area: front_court, default: true}
  - {id: servants_gate, area: kitchens}
  - {id: sea_stair, area: wine_cellar}
  - {id: gallery_end, area: gallery}
  - {id: ballroom_doors, area: ballroom}
exits:
  - id: leave_front
    area: front_court
    to_zone: zone.attre_harbor
    to_spawn: palazzo_steps
    condition: "true"
    effects: []
  - id: leave_sea_stair
    area: wine_cellar
    to_zone: zone.attre_harbor
    to_spawn: rocks
    condition: "true"
    effects: []
interactables:
  - id: front_gate_check
    area: front_court
    kind: door
    label: "Show your invitation at the gate"
    condition: "has_item(item.masquerade_invitation)"
    check: null
    once: true
    effects: ["set_flag(flag.masquerade_entered)"]
  - id: orangery_listen
    area: orangery
    kind: search
    label: "Listen from behind the lemon trees"
    condition: "flag(flag.raimund_meeting) and not flag(flag.raimund_meeting_overheard)"
    check: null
    once: true
    effects: ["set_flag(flag.raimund_meeting_overheard)", "add_clue(clue.raimund_choir_buyer)", "play_beat(meeting_overheard)"]
  - id: false_drawer
    area: study
    kind: search
    label: "Search the desk"
    condition: "not has_item(item.study_key)"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["give_item(item.study_key, 1)"]
    fail_effects: []
  - id: strongbox_key
    area: study
    kind: container
    label: "Open the strongbox with the key"
    condition: "has_item(item.study_key) and not has_item(item.raimund_ledger)"
    check: null
    once: true
    effects: ["give_item(item.raimund_ledger, 1)", "add_clue(clue.raimund_ledger_silver)", "add_crowns(120)", "reach_milestone(ms.a2_attre_ledger)"]
  - id: strongbox_force
    area: study
    kind: container
    label: "Lever the strongbox open (loud)"
    condition: "not has_item(item.study_key) and not has_item(item.raimund_ledger)"
    check: null
    once: true
    effects: ["give_item(item.raimund_ledger, 1)", "add_clue(clue.raimund_ledger_silver)", "add_crowns(120)", "reach_milestone(ms.a2_attre_ledger)", "raise_alarm()"]
  - id: aimeric_bed
    area: heirs_chamber
    kind: search
    label: "Look closely at the sick boy"
    condition: "true"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["add_clue(clue.aimeric_lily_sick)", "set_flag(flag.aimeric_diagnosed)"]
    fail_effects: []
  - id: aimeric_bed_known
    area: heirs_chamber
    kind: search
    label: "[Clue] Grey-green spittle, pinpoint pupils: you've seen this"
    condition: "(has_clue(clue.courier_foam) or has_clue(clue.chalice_pollen)) and not flag(flag.aimeric_diagnosed)"
    check: null
    once: true
    effects: ["add_clue(clue.aimeric_lily_sick)", "set_flag(flag.aimeric_diagnosed)"]
  - id: cellar_bar
    area: wine_cellar
    kind: door
    label: "Lift the bar on the sea-stair door"
    condition: "true"
    check: null
    once: true
    effects: []
triggers:
  - id: raimund_greets
    area: ballroom
    "on": enter
    source: null
    condition: "flag(flag.masquerade_entered) and not flag(flag.raimund_greeted) and not flag(flag.masquerade_alarm)"
    once: true
    effects: ["set_flag(flag.raimund_greeted)", "start_dialogue(dlg.raimund_ball)"]
  - id: meeting_starts
    area: ballroom
    "on": enter
    source: null
    condition: "not flag(flag.raimund_meeting) and not flag(flag.masquerade_alarm)"
    once: true
    effects: ["set_flag(flag.raimund_meeting)", "play_beat(raimund_to_orangery)"]
  - id: masquerade_alarm
    area: gallery
    "on": alarm
    source: null
    condition: "not flag(flag.masquerade_alarm)"
    once: true
    effects: ["play_beat(alarm)", "set_flag(flag.masquerade_alarm)", "add_rep(faction.attre, -20)", "start_encounter(enc.masquerade_alarm)"]
hazards: []
checkpoints:
  - {id: masquerade_entry, area: front_court}
  - {id: gallery_cp, area: gallery}
beats:
  - {id: raimund_to_orangery, description: "Raimund excuses himself and walks to the orangery with a guest in a gull mask; a pale feather is tied in the mask's ribbon."}
  - {id: meeting_overheard, description: "Behind the lemon trees: Raimund names Warehouse Nine and two crates; the gull mask promises 'the usual bars'."}
  - {id: alarm, description: "Stealth alarm: a guard shouts, the musicians stop, guests scream and crowd the doors. Played by the stealth system or by loud actions."}
  - {id: corbin_vanishes, description: "Corbin smashes a smoke pot and is gone through the orangery glass."}
npcs:
  - {npc: npc.raimund, area: ballroom, condition: "not flag(flag.masquerade_alarm)"}
  - {npc: npc.steward_lucan, area: ballroom, condition: "not flag(flag.masquerade_alarm)"}
  - {npc: npc.master_corbin, area: orangery, condition: "not flag(flag.corbin_exposed) and not flag(flag.masquerade_alarm)"}
  - {npc: npc.aimeric, area: heirs_chamber, condition: "true"}
encounters: [enc.masquerade_alarm, enc.corbin_unmasked]
loot:
  - {container: strongbox_key, items: [{item: item.field_draught, count: 1}], condition: "true"}
variants:
  - id: alarm_raised
    when: "flag(flag.masquerade_alarm)"
    description: "Guests gone, candles knocked over, ducal guards in every doorway. The study is still reachable through the fight."
    npcs_absent: [npc.raimund, npc.steward_lucan, npc.master_corbin]
    encounters_disabled: []
    interactables_disabled: [orangery_listen]
  - id: open_feathers
    when: "stage() >= 3"
    description: "Two guests wear pale feathers openly in their masks. Nobody says anything."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
```

```yaml zone
id: zone.attre_warehouse
name: "Warehouse Nine"
kind: interior
map_node: map.attre
time_of_day: night
cold_rate: 0
disguise_tag: null
music: warehouse_creep
areas:
  - {id: yard_gate, description: "Land entrance from warehouse row; watchman's booth (Old Pieter)."}
  - {id: bonded_yard, description: "20 x 25 m: cask stacks (full cover), a crane, lanterns on poles. Y1/Y2 walk a figure-eight round the stacks."}
  - {id: counting_house, description: "Lit office by the gate: clerk's desk, manifest book, strongroom key on a nail."}
  - {id: strongroom, description: "Locked brick room: a chest of Abbey-stamped silver ingots."}
  - {id: main_hall, description: "Bales, hanging ropes, a rope-hoist to the loft. H1 walks the hall's length."}
  - {id: drying_loft, description: "Grey lily hung to dry on racks, dust in the lantern light. crate_east and crate_west at either end; Gaspard's table between with a lamp and a can of lamp oil."}
  - {id: sea_gate, description: "Water entrance under the hall, a skiff tied inside, a ladder up to the hall."}
  - {id: roof, description: "Skylight into the loft, reached by a plank from the next warehouse."}
spawns:
  - {id: yard_gate, area: yard_gate, default: true}
  - {id: sea_gate, area: sea_gate}
  - {id: roof, area: roof}
  - {id: yard_stacks, area: bonded_yard}
  - {id: hall_far, area: main_hall}
  - {id: loft_table, area: drying_loft}
exits:
  - id: leave_gate
    area: yard_gate
    to_zone: zone.attre_harbor
    to_spawn: warehouse_row
    condition: "true"
    effects: []
  - id: leave_sea
    area: sea_gate
    to_zone: zone.attre_harbor
    to_spawn: quay
    condition: "true"
    effects: []
  - id: leave_roof
    area: roof
    to_zone: zone.attre_harbor
    to_spawn: warehouse_row
    condition: "true"
    effects: []
interactables:
  - id: pieter_booth
    area: yard_gate
    kind: lever
    label: "Talk to the night watchman"
    condition: "not flag(flag.pieter_bribed) and not flag(flag.warehouse_alarm)"
    check: null
    once: false
    effects: ["start_dialogue(dlg.pieter)"]
  - id: manifest_book
    area: counting_house
    kind: readable
    label: "Read the manifest book"
    condition: "true"
    check: null
    once: true
    effects: ["add_clue(clue.bulbs_to_attre)"]
  - id: strongroom_key
    area: counting_house
    kind: pickup
    label: "Take the key from the nail"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.strongroom_key, 1)"]
  - id: strongroom_door
    area: strongroom
    kind: door
    label: "Unlock the strongroom"
    condition: "has_item(item.strongroom_key)"
    check: null
    once: true
    effects: ["add_clue(clue.abbey_silver_ingots)", "add_crowns(200)"]
  - id: crate_east
    area: drying_loft
    kind: container
    label: "Take the bulbs from the east crate"
    condition: "not flag(flag.crate_east_taken) and not flag(flag.crate_east_burned)"
    check: null
    once: true
    effects: ["set_flag(flag.crate_east_taken)", "give_item(item.grey_lily_bulbs, 2)", "add_var(var.bulbs_recovered, 2)"]
  - id: crate_west
    area: drying_loft
    kind: container
    label: "Take the bulbs from the west crate"
    condition: "not flag(flag.crate_west_taken) and not flag(flag.crate_west_burned)"
    check: null
    once: true
    effects: ["set_flag(flag.crate_west_taken)", "give_item(item.grey_lily_bulbs, 2)", "add_var(var.bulbs_recovered, 2)"]
  - id: seize_gaspard
    area: drying_loft
    kind: lever
    label: "Seize the foreman from behind"
    condition: "not flag(flag.gaspard_down) and not flag(flag.warehouse_alarm) and not flag(flag.warehouse_release)"
    check: null
    once: true
    effects: ["set_flag(flag.gaspard_down)", "play_beat(gaspard_seized)", "start_dialogue(dlg.gaspard_seized)"]
  - id: show_release
    area: drying_loft
    kind: lever
    label: "Hand Gaspard the Duke's release"
    condition: "has_item(item.raimund_release) and not flag(flag.warehouse_alarm)"
    check: null
    once: true
    effects: ["set_flag(flag.warehouse_release)", "start_dialogue(dlg.gaspard_release)"]
triggers:
  - id: alarm_raised
    area: drying_loft
    "on": alarm
    source: null
    condition: "not flag(flag.warehouse_alarm)"
    once: true
    effects: ["play_beat(alarm)", "set_flag(flag.warehouse_alarm)", "set_flag(flag.attre_loud_raid)", "add_rep(faction.attre, -30)", "start_encounter(enc.warehouse_alarm)"]
  - id: gaspard_torches
    area: drying_loft
    "on": alarm
    source: null
    condition: "not flag(flag.gaspard_down) and not flag(flag.warehouse_release) and (not flag(flag.crate_east_taken) or not flag(flag.crate_west_taken))"
    once: true
    effects: ["play_beat(alarm)", "play_beat(crates_torched)"]
  - id: burn_east
    area: drying_loft
    "on": alarm
    source: null
    condition: "not flag(flag.gaspard_down) and not flag(flag.warehouse_release) and not flag(flag.crate_east_taken)"
    once: true
    effects: ["play_beat(alarm)", "set_flag(flag.crate_east_burned)"]
  - id: burn_west
    area: drying_loft
    "on": alarm
    source: null
    condition: "not flag(flag.gaspard_down) and not flag(flag.warehouse_release) and not flag(flag.crate_west_taken)"
    once: true
    effects: ["play_beat(alarm)", "set_flag(flag.crate_west_burned)"]
hazards:
  - {id: lily_dust, area: drying_loft, kind: trap, params: {status: poison, stacks_per_second_in_combat: 0.25}}
  - {id: loft_fire, area: drying_loft, kind: fire, enabled_by: {"on": beat_done, source: crates_torched}, params: {damage_per_second: 6}}
checkpoints:
  - {id: warehouse_entry, area: yard_gate}
  - {id: loft_cp, area: main_hall}
beats:
  - {id: alarm, description: "Stealth alarm: a guard rings the yard bell. Played by the stealth system on suspicion 100."}
  - {id: crates_torched, description: "Gaspard upends the oil can over every crate still in the loft and throws the lamp. The racks go up; the dust flashes."}
  - {id: gaspard_seized, description: "The player pins Gaspard to his own table before he can reach the lamp."}
npcs:
  - {npc: npc.pieter, area: yard_gate, condition: "not flag(flag.warehouse_alarm)"}
  - {npc: npc.gaspard, area: drying_loft, condition: "not flag(flag.gaspard_down)"}
encounters: [enc.warehouse_yard, enc.warehouse_hall, enc.warehouse_alarm]
loot:
  - {container: strongroom_door, items: [{item: item.smoke_pot, count: 2}], condition: "true"}
variants:
  - id: pieter_looks_away
    when: "flag(flag.pieter_bribed)"
    description: "Pieter has called the yard patrol into his booth for dice."
    npcs_absent: []
    encounters_disabled: [enc.warehouse_yard]
    interactables_disabled: []
  - id: released
    when: "flag(flag.warehouse_release)"
    description: "Lanterns up, guards stood down by the Duke's order. Gaspard waits by the crates with his cap in his hands."
    npcs_absent: []
    encounters_disabled: [enc.warehouse_yard, enc.warehouse_hall, enc.warehouse_alarm]
    interactables_disabled: [seize_gaspard]
  - id: burned
    when: "flag(flag.crate_east_burned) or flag(flag.crate_west_burned)"
    description: "The loft is a black shell, roof open to the stars, racks fallen. The smell of burnt lily hangs over the harbour."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
```

## 4. NPCs present
**Voice notes.** Raimund: warm, witty, unhurried. He talks about trade as if it were love and about love as if it were trade. When his son is mentioned his voice goes flat. Lucan: a fussy steward who hates disorder more than he loves his master. Corbin: a lean Choir buyer, a scholar's diction, contemptuous of merchants. Velia: a forger with ink-black fingers, wry, professional, proud of her work. Gaspard: a frightened foreman who follows orders exactly. Pieter: an old watchman who hates the night shift. Arnaut: a decent sergeant with orders he dislikes. Aimeric: nine, feverish, polite, asks if the player has seen ships.

```yaml npc
id: npc.raimund
name: "Duke Raimund of Attre"
faction: faction.attre
role: "Merchant-prince of the Free Port"
motive: "Free Attre from Cintran tariffs and keep the ports profitable, whoever wears the crown."
secret: "He sold grey lily to Choir agents for heavy silver without asking what for. His son Aimeric is dying of the lily dust from his own warehouse, and he half suspects it."
disposition: neutral
essential: true
dialogue: dlg.raimund_ball
barks: ["Everything in Attre is for sale. Except the view.", "Drink, friend. The green wine is my joke.", "Trade is only war with better manners."]
combat: null
shop: null
```

```yaml npc
id: npc.aimeric
name: "Aimeric"
faction: faction.attre
role: "Raimund's son and heir, nine years old"
motive: "To get well enough to see the ships again."
secret: "He played hide-and-seek in Warehouse Nine's drying loft in the summer."
disposition: friendly
essential: true
dialogue: dlg.aimeric
barks: ["Have you seen the ships?", "Papa says I'll be better by spring.", "It's only a cough."]
combat: null
shop: null
```

```yaml npc
id: npc.steward_lucan
name: "Steward Lucan"
faction: faction.attre
role: "Steward of the Anchor House"
motive: "A perfect evening with no broken glass."
secret: "He carries the study key on his chain and hates the Choir buyer for treading mud on the ballroom floor."
disposition: neutral
essential: false
dialogue: dlg.lucan
barks: ["Mind the candles.", "Your mask is crooked, my lord.", "The Duke will see you when the Duke sees you."]
combat: null
shop: null
```

```yaml npc
id: npc.master_corbin
name: "Master Corbin"
faction: faction.choir
role: "The Abbey's buyer, Choir agent at the masquerade"
motive: "Pay the balance on the last two crates and take them north."
secret: "He is the 'Br. Corbin' named in Raimund's ledger, and he carries orders to burn Attre's warehouses once the vaults are open."
disposition: hostile
essential: false
dialogue: dlg.corbin
barks: ["Merchants. Always the price.", "The swan sings.", "Out of my light."]
combat: enemy.choir_assassin
shop: null
```

```yaml npc
id: npc.velia
name: "Velia"
faction: null
role: "Forger posing as a bookbinder"
motive: "Good money for good work, no questions."
secret: "She forged the Gull Tower keeper's dismissal papers for Raimund's smugglers last spring."
disposition: neutral
essential: false
dialogue: dlg.velia
barks: ["Bindings, repairs, nothing else.", "Ink is cheaper than blood.", "Don't touch the wet ones."]
combat: null
shop: null
```

```yaml npc
id: npc.dame_fenna
name: "Dame Fenna"
faction: null
role: "Harbour chandler"
motive: "Sell rope and salve to anyone with coin."
secret: null
disposition: neutral
essential: false
dialogue: null
barks: ["Rope, oil, salve, bolts. Haggle and I'll raise it.", "Ships in, ships out. Coin stays."]
combat: null
shop: {stock: [{item: item.poultice, count: 8}, {item: item.field_draught, count: 4}, {item: item.antitoxin, count: 4}, {item: item.crossbow_bolt, count: 20}, {item: item.smoke_pot, count: 3}, {item: item.fire_oil, count: 3}], price_mod: 1.1}
```

```yaml npc
id: npc.attre_tapster
name: "Coll the tapster"
faction: null
role: "Tapster at the Gilded Gull, rumor source"
motive: "Sell beer, hear everything, repeat half of it."
secret: null
disposition: neutral
essential: false
dialogue: null
barks: ["Gull ale or Peixe red?", "Everybody's talking about the Duke's boy. Nobody's saying it loud.", "Ships in, rumors out."]
combat: null
shop: null
```

```yaml npc
id: npc.gaspard
name: "Gaspard"
faction: faction.attre
role: "Foreman of Warehouse Nine"
motive: "Obey the Duke's standing order: if anyone comes for the lily, burn it."
secret: "He knows the Duke's boy played in the loft. He has told no one."
disposition: wary
essential: false
dialogue: null
barks: ["Nobody in the loft.", "Lamp stays lit.", "Orders are orders."]
combat: enemy.bandit
shop: null
```

```yaml npc
id: npc.pieter
name: "Old Pieter"
faction: faction.attre
role: "Night watchman at Warehouse Nine"
motive: "Get through the night with his feet up."
secret: null
disposition: neutral
essential: false
dialogue: dlg.pieter
barks: ["Closed. Come back at dawn.", "My knees, my knees.", "I didn't see anything. I never see anything."]
combat: null
shop: null
```

```yaml npc
id: npc.sergeant_arnaut
name: "Sergeant Arnaut"
faction: faction.attre
role: "Commander of the land-gate checkpoint (stage 3)"
motive: "Keep the gate shut without killing anyone he'd have to bury."
secret: null
disposition: wary
essential: false
dialogue: dlg.attre_checkpoint
barks: ["Gate's closed by the Duke's order.", "Papers or turn round."]
combat: enemy.bandit
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.attre_checkpoint
participants: [npc.sergeant_arnaut]
start: halt
nodes:
  halt:
    type: line
    speaker: npc.sergeant_arnaut
    text: "Halt. Attre's closed to the Cintra road by the Duke's order. No invitation, no seal, no entry. Turn round, friend."
    direction: "Behind a barricade of wine casks, three guards with spears."
    next: hub
  hub:
    type: choice
    options:
      - id: bribe
        text: "[Bribe 80] Perhaps the Duke's order has a price."
        tag: bribe
        bribe: 80
        next: pass
      - id: persuade
        text: "[Persuade 8] I'm here to buy, not to fight. Your Duke loses money every day this gate is shut."
        tag: persuade
        check: {skill: persuade, dc: 8, pass: pass, fail: refuse}
      - id: writ
        text: "[Item: Marshal's writ] Royal business."
        tag: item
        condition: "has_item(item.kosk_writ)"
        next: writ
      - id: fight
        text: "Then I'll go through."
        next: fight
      - id: leave
        text: "(Turn back.)"
        next: bye
  writ:
    type: line
    speaker: npc.sergeant_arnaut
    text: "A Cintran writ. That's exactly what I'm here to keep out. Wrong paper, friend."
    next: hub
  refuse:
    type: line
    speaker: npc.sergeant_arnaut
    text: "Very persuasive. Still no."
    next: hub
  pass:
    type: line
    speaker: npc.sergeant_arnaut
    text: "Go on, then. Quickly. You came by sea, if anyone asks."
    effects: ["set_flag(flag.attre_checkpoint_passed)"]
    next: bye
  fight:
    type: effect
    effects: ["start_encounter(enc.attre_checkpoint)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.velia
participants: [npc.velia]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.velia
    text: "Bindings, repairs, gilt edges. Nothing else. Unless you're the sort who needs something else."
    direction: "Ink to the wrists, a drying invitation on a line behind her."
    next: hub
  hub:
    type: choice
    options:
      - id: invite
        text: "I need an invitation to the Duke's masquerade."
        condition: "not has_item(item.masquerade_invitation)"
        next: invite
      - id: gull
        text: "[Investigate 6] That hand. You forged papers for Gull Tower, didn't you?"
        tag: investigate
        condition: "visited(zone.gull_tower)"
        check: {skill: investigate, dc: 6, pass: gull, fail: gull_fail}
        once: true
      - id: leave
        text: "Just browsing."
        next: bye
  invite:
    type: line
    speaker: npc.velia
    text: "Eighty crowns. Real paper, the Duke's own printer's stock, a seal you could kiss. Ready by the time you've had a drink."
    next: invite_choice
  invite_choice:
    type: choice
    options:
      - id: pay
        text: "[Bribe 80] Done."
        tag: bribe
        bribe: 80
        next: sold
      - id: haggle
        text: "[Persuade 6] Forty, and I don't mention your bindings to the harbour watch."
        tag: persuade
        check: {skill: persuade, dc: 6, pass: haggle_pass, fail: haggle_fail}
      - id: "no"
        text: "Too dear."
        next: hub
  haggle_pass:
    type: choice
    options:
      - id: pay40
        text: "[Bribe 40] Forty, then."
        tag: bribe
        bribe: 40
        next: sold
      - id: "no"
        text: "On second thought, no."
        next: hub
  haggle_fail:
    type: line
    speaker: npc.velia
    text: "Mention what you like. The watch buys their wedding contracts from me."
    next: invite_choice
  sold:
    type: line
    speaker: npc.velia
    text: "Here. Wear a mask that covers your eyes. People look at eyes."
    effects: ["give_item(item.masquerade_invitation, 1)"]
    next: hub
  gull:
    type: line
    speaker: npc.velia
    text: "The keeper's dismissal. The Duke's man paid for it. I didn't know they'd kill him for it, if that helps. It doesn't help me."
    effects: ["add_clue(clue.bulbs_to_attre)"]
    next: hub
  gull_fail:
    type: line
    speaker: npc.velia
    text: "Every clerk in Attre writes like that. We all learned from the same beatings."
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.attre_porter
participants: []
start: porter
nodes:
  porter:
    type: line
    speaker: player
    text: "(A kitchen porter is smoking by the side door, watching crates of oysters come in.)"
    next: hub
  hub:
    type: choice
    options:
      - id: bribe
        text: "[Bribe 30] I'm the extra hand they sent for. Here's for your trouble."
        tag: bribe
        bribe: 30
        next: open
      - id: persuade
        text: "[Persuade 6] Lucan sent me. Something about the oysters being late. You want to tell him they're late?"
        tag: persuade
        check: {skill: persuade, dc: 6, pass: open, fail: shut}
      - id: leave
        text: "(Walk on.)"
        next: bye
  open:
    type: line
    speaker: player
    text: "(The porter shrugs, flicks his pipe, and props the side door open.)"
    effects: ["set_flag(flag.servants_gate_open)"]
    next: bye
  shut:
    type: line
    speaker: player
    text: "(The porter laughs and shuts the door in your face.)"
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.raimund_ball
participants: [npc.raimund]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.raimund
    text: "A new mask. I collect them. You walk like a soldier and look at the doors like a thief. Which are you, and who paid for your invitation?"
    direction: "A silver lion-mask pushed up on his forehead, a glass of green wine in each hand. He offers one."
    next: hub
  hub:
    type: choice
    options:
      - id: trade
        text: "Neither. I'm here to talk trade."
        next: trade
      - id: lily
        text: "[Clue: The bulbs went to Attre] Grey lily. Your warehouse. Your smugglers dug up a witch's garden."
        tag: clue
        condition: "has_clue(clue.bulbs_to_attre) or has_clue(clue.raimund_choir_buyer)"
        next: lily
      - id: son
        text: "I hear your son is ill."
        next: son
      - id: terrace
        text: "Somewhere quieter, your Grace. You'll want this conversation private."
        condition: "has_item(item.raimund_ledger) or flag(flag.aimeric_diagnosed) or has_item(item.wenna_antidote) or has_item(item.anselm_journal)"
        next: to_terrace
      - id: leave
        text: "Enjoy your party."
        next: bye
  trade:
    type: line
    speaker: npc.raimund
    text: "Trade! A guest after my heart. Attre sells everything, my friend, except the view, and Cintra wants to tax even that. When the Queen goes, so do the tariffs. Drink to her health while it lasts."
    next: hub
  lily:
    type: line
    speaker: npc.raimund
    text: "I own a great many warehouses and know very little about gardens. Careful. That's the kind of sentence that gets thrown off a terrace. Bring me something firmer than a witch's word."
    direction: "The smile stays. The eyes don't."
    next: hub
  son:
    type: line
    speaker: npc.raimund
    text: "A summer cough. He'll be well by spring. Physicians say so, and I pay them handsomely to be right."
    direction: "Flat, for a moment. Then the smile is back."
    next: hub
  to_terrace:
    type: effect
    effects: ["start_dialogue(dlg.raimund_terrace)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.raimund_terrace
participants: [npc.raimund]
start: open
nodes:
  open:
    type: line
    speaker: npc.raimund
    text: "Private enough? The sea is a good listener. It never repeats anything. Speak."
    direction: "On the terrace, the lion-mask in his hand, the ball muffled behind the glass."
    next: hub
  hub:
    type: choice
    options:
      - id: ledger
        text: "[Item: Raimund's ledger] Your own hand. The mere job, Gull Tower, warehouse nine, all paid in Abbey silver."
        tag: item
        condition: "has_item(item.raimund_ledger) and not flag(flag.raimund_blackmailed) and not flag(flag.raimund_allied)"
        next: ledger
      - id: son_truth
        text: "[Clue: Aimeric's sickness] Your son isn't coughing from a summer chill. He breathed the lily you sold. In your own drying loft."
        tag: clue
        condition: "has_clue(clue.aimeric_lily_sick) and not flag(flag.raimund_allied)"
        next: son_truth
      - id: journal
        text: "[Item: Anselm's journal] Read what the Abbot writes about you. 'The merchant duke is a lever. When the dark wakes, his ports burn first.'"
        tag: item
        condition: "has_item(item.anselm_journal) and not flag(flag.raimund_allied)"
        next: alliance_offer
      - id: evidence
        text: "[Persuade 8] The Choir will burn Attre with everything else. Give me the crates and stay out of their way."
        tag: persuade
        condition: "has_clue(clue.raimund_choir_buyer) and not flag(flag.raimund_blackmailed) and not flag(flag.raimund_allied) and not flag(flag.warehouse_release)"
        check: {skill: persuade, dc: 8, pass: release_only, fail: deny}
      - id: sell
        text: "[Item: Counter-dose] I have a cure for grey lily. One dose."
        tag: item
        condition: "has_item(item.wenna_antidote)"
        next: sell
      - id: leave
        text: "Enjoy the view, your Grace."
        next: bye
  deny:
    type: line
    speaker: npc.raimund
    text: "The Choir? Monks who pay on time. You're a very loud guest. Go and dance."
    next: hub
  ledger:
    type: line
    speaker: npc.raimund
    text: "So you're a thief after all. A good one. What do you want? Name a price; everything has one."
    next: ledger_choice
  ledger_choice:
    type: choice
    options:
      - id: blackmail
        text: "Wenna's bulbs, released to me tonight. And no more Choir silver through your ports. Or this goes to the Lord Marshal."
        next: blackmail
      - id: ally
        text: "[Persuade 6] I don't want to ruin you. I want Attre standing with the Crown when the Choir comes. You want stability for trade. So do we."
        tag: persuade
        check: {skill: persuade, dc: 6, pass: alliance_offer, fail: blackmail}
      - id: sway
        text: "[Sway] Hang for the lily, or be the duke who saved the realm and kept his ports. I know which one your heirs will thank you for."
        tag: sway
        condition: "perk(perk.kingmaker)"
        next: alliance_offer
  blackmail:
    type: line
    speaker: npc.raimund
    text: "Released. Banned. Very well. You'll have my seal for Gaspard. And I'll remember your face, thief. Attre has a long memory and short piers."
    effects: ["set_flag(flag.raimund_blackmailed)", "add_rep(faction.attre, -10)", "give_item(item.raimund_release, 1)"]
    next: hub
  release_only:
    type: line
    speaker: npc.raimund
    text: "You argue like a merchant. Fine. Two crates of weeds are not worth my port. Take my seal to Gaspard. The ledger stays where it is, of course."
    effects: ["give_item(item.raimund_release, 1)"]
    next: hub
  son_truth:
    type: line
    speaker: npc.raimund
    text: "No. He played... in the summer he played everywhere, he... the loft. Gaspard found him asleep in the racks once. God. God, I sold it by the pound."
    direction: "He sits down on the balustrade."
    next: alliance_offer
  alliance_offer:
    type: line
    speaker: npc.raimund
    text: "Then let us be honest, for once. I wanted Attre free. I did not want the world on fire. What does the Crown need from me?"
    next: alliance_choice
  alliance_choice:
    type: choice
    options:
      - id: ally
        text: "Close your ports to the Choir. Release the crates. Give me the ledger for the Marshal. And stand with Cintra this winter."
        next: allied
      - id: just_crates
        text: "Just the crates. The rest is your conscience."
        condition: "not has_item(item.raimund_release) and not flag(flag.warehouse_release)"
        next: release_only
      - id: back
        text: "I'll think about it."
        next: hub
  allied:
    type: line
    speaker: npc.raimund
    text: "Done. The grey robes leave my ports by dawn. Here is my seal for Gaspard, and here is the ledger, if you haven't stolen it already. I'd rather hang for lily than burn for a priest."
    effects: ["set_flag(flag.raimund_allied)", "add_rep(faction.attre, 50)", "start_dialogue(dlg.raimund_ally_gifts)"]
    next: bye
  sell:
    type: line
    speaker: npc.raimund
    text: "A cure. For the lily. You have it here? Name your price. No. I'll name it. Three hundred crowns and anything Attre can give. Please. He's nine."
    next: sell_choice
  sell_choice:
    type: choice
    options:
      - id: sell_yes
        text: "(Give the dose for Aimeric. 300 crowns. The Queen may die without it.)"
        next: sold
      - id: sell_no
        text: "It's promised to someone else."
        next: sell_refused
  sold:
    type: line
    speaker: npc.raimund
    text: "Lucan! The physician, now! ...Whatever you need, whenever you need it. Attre owes you a son."
    effects: ["take_item(item.wenna_antidote, 1)", "add_crowns(300)", "add_rep(faction.attre, 50)", "add_rep(faction.crown, -10)", "set_flag(flag.antidote_sold_raimund)", "set_flag(flag.aimeric_saved)"]
    next: hub
  sell_refused:
    type: line
    speaker: npc.raimund
    text: "Promised. To the Queen, of course. Then I hope she's worth two of him."
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.raimund_ally_gifts
participants: [npc.raimund]
start: gifts
nodes:
  gifts:
    type: branch
    cases:
      - {if: "has_item(item.raimund_ledger)", next: seal_only}
    else: seal_and_ledger
  seal_only:
    type: line
    speaker: npc.raimund
    text: "You have the ledger already. Of course you do. My seal, then."
    effects: ["give_item(item.raimund_release, 1)"]
    next: bye
  seal_and_ledger:
    type: line
    speaker: npc.raimund
    text: "The ledger. My seal. And my word, which is worth more than either in this city."
    effects: ["give_item(item.raimund_release, 1)", "give_item(item.raimund_ledger, 1)", "add_clue(clue.raimund_ledger_silver)", "reach_milestone(ms.a2_attre_ledger)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.lucan
participants: [npc.steward_lucan]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.steward_lucan
    text: "My lord, my lady, whichever. The Duke receives in the ballroom. The upper floor is private. The buffet is not."
    next: hub
  hub:
    type: choice
    options:
      - id: key_bribe
        text: "[Bribe 60] A quiet room upstairs for a delicate matter. The study, perhaps."
        tag: bribe
        condition: "not has_item(item.study_key)"
        bribe: 60
        next: key
      - id: key_corbin
        text: "[Persuade 6] The gull-mask guest has been tracking mud across your floor all night. I can make him leave, if I can reach the Duke's papers first."
        tag: persuade
        condition: "not has_item(item.study_key) and flag(flag.raimund_meeting)"
        check: {skill: persuade, dc: 6, pass: key, fail: no_key}
      - id: key_threat
        text: "[Intimidate 6] Give me the key on your chain, and nobody spills anything on anything tonight."
        tag: intimidate
        condition: "not has_item(item.study_key)"
        check: {skill: intimidate, dc: 6, pass: key_alarm_risk, fail: no_key}
      - id: leave
        text: "Thank you, steward."
        next: bye
  key:
    type: line
    speaker: npc.steward_lucan
    text: "The study is locked, naturally. And this key fell off my chain, naturally. Do not touch the ink."
    effects: ["give_item(item.study_key, 1)"]
    next: bye
  key_alarm_risk:
    type: line
    speaker: npc.steward_lucan
    text: "Take it. Take it! I'll say I lost it. Please don't touch the candelabra."
    effects: ["give_item(item.study_key, 1)", "add_rep(faction.attre, -5)"]
    next: bye
  no_key:
    type: line
    speaker: npc.steward_lucan
    text: "No."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.corbin
participants: [npc.master_corbin]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.master_corbin
    text: "Out of my light. I'm not here to dance."
    direction: "A lean man in a gull mask, a pale feather in the ribbon, alone on the orangery bench."
    next: hub
  hub:
    type: choice
    options:
      - id: swan
        text: "The swan sings, brother."
        next: swan
      - id: expose
        text: "[Item: Pale feather] (Hold up a pale feather.) I know what you are, Corbin."
        tag: item
        condition: "has_item(item.pale_feather)"
        next: exposed
      - id: leave
        text: "(Leave him.)"
        next: bye
  swan:
    type: line
    speaker: npc.master_corbin
    text: "And the old song ends. Then you know better than to speak to me here. Go."
    next: bye
  exposed:
    type: line
    speaker: npc.master_corbin
    text: "Do you. Then you know what we do to people who know things."
    effects: ["set_flag(flag.corbin_exposed)", "start_encounter(enc.corbin_unmasked)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.aimeric
participants: [npc.aimeric]
start: greet
nodes:
  greet:
    type: branch
    cases:
      - {if: "flag(flag.aimeric_saved)", next: saved}
    else: sick
  sick:
    type: line
    speaker: npc.aimeric
    text: "Hello. Are you a guest? Have you seen the ships? I can't see them from here, Papa keeps the shutters closed. It's only a cough."
    direction: "Propped on pillows, grey-lipped, a green-stained cloth in his fist."
    next: bye
  saved:
    type: line
    speaker: npc.aimeric
    text: "The shutters are open! I saw a cog come in with red sails. Papa says you're a hero. Are you?"
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.pieter
participants: [npc.pieter]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.pieter
    text: "Closed. Come back at dawn, or never. My knees prefer never."
    direction: "Feet up on a brazier in his booth, a dice cup beside him."
    next: hub
  hub:
    type: choice
    options:
      - id: bribe
        text: "[Bribe 50] Call the yard lads in for a game. Lose slowly."
        tag: bribe
        bribe: 50
        next: bribed
      - id: release
        text: "[Item: Duke's release] Duke's seal. Open up."
        tag: item
        condition: "has_item(item.raimund_release)"
        next: release
      - id: leave
        text: "Sorry to wake you."
        next: bye
  bribed:
    type: line
    speaker: npc.pieter
    text: "Lads! Dice! ...I didn't see anything. I never see anything. Mind Gaspard up top, he's got a lamp and orders."
    effects: ["set_flag(flag.pieter_bribed)"]
    next: bye
  release:
    type: line
    speaker: npc.pieter
    text: "The anchor seal. Well, well. Go on up. Tell Gaspard not to burn anything, he's been itching to all week."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.gaspard_seized
participants: [npc.gaspard]
start: pinned
nodes:
  pinned:
    type: line
    speaker: npc.gaspard
    text: "Don't! I won't, I won't light it, I swear. Duke's orders, burn it if anyone comes. I've got children."
    direction: "Pinned over his own table, the lamp knocked out of reach."
    next: hub
  hub:
    type: choice
    options:
      - id: tie
        text: "Then you'll sit tied in the corner and live to tell him you couldn't."
        next: tied
      - id: boy
        text: "The Duke's boy played up here, didn't he?"
        next: boy
  boy:
    type: line
    speaker: npc.gaspard
    text: "All summer. Hiding in the racks. I told him to go home. I never told the Duke. What was I to say? Your weed is killing your son?"
    effects: ["add_clue(clue.aimeric_lily_sick)"]
    next: hub
  tied:
    type: line
    speaker: npc.gaspard
    text: "Yes. Yes. Tie it tight, so he believes me."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.gaspard_release
participants: [npc.gaspard]
start: read
nodes:
  read:
    type: line
    speaker: npc.gaspard
    text: "The anchor seal. 'Release to bearer.' Thank God. Take them. Take them and get that dust out of my loft."
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.attre_checkpoint
zone: zone.attre_harbor
enemies:
  - {enemy: enemy.bandit, count: 2, spawn: land_gate, variant: shield}
  - {enemy: enemy.bandit, count: 2, spawn: land_gate, variant: spear}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: harbour_gate
avoidable_by: ["dlg.attre_checkpoint"]
on_won: ["set_flag(flag.attre_checkpoint_passed)", "add_rep(faction.attre, -15)"]
on_yielded: ["set_flag(flag.attre_checkpoint_passed)", "add_rep(faction.attre, -10)"]
on_player_fled: []
```
Design: ducal guards use the `enemy.bandit` archetype (shield and spear variants), since gdd §6.7 has no guard archetype. The cask barricade is full cover; kicking a cask rolls it into the guards (knockdown).

```yaml encounter
id: enc.masquerade_alarm
zone: zone.attre_masquerade
enemies:
  - {enemy: enemy.bandit, count: 2, spawn: gallery_end, variant: sword}
  - {enemy: enemy.bandit, count: 1, spawn: gallery_end, variant: shield}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.bandit, count: 2, spawn: ballroom_doors, variant: spear}]}
attack_tokens: null
allow_yield: true
allies: []
checkpoint: gallery_cp
avoidable_by: []
on_won: []
on_yielded: []
on_player_fled: []
```
Design: once the alarm fires, guards converge on the gallery. The study stays open; the fight is the guaranteed route to the ledger. Leaving by the sea stair ends the fight.

```yaml encounter
id: enc.corbin_unmasked
zone: zone.attre_masquerade
enemies:
  - {enemy: enemy.choir_assassin, count: 1, spawn: ballroom_doors, variant: null}
  - {enemy: enemy.choir_cutthroat, count: 2, spawn: ballroom_doors, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: masquerade_entry
avoidable_by: []
on_won: ["give_item(item.corbin_orders, 1)", "add_clue(clue.raimund_choir_buyer)", "add_rep(faction.attre, 10)"]
on_yielded: ["give_item(item.corbin_orders, 1)", "add_clue(clue.raimund_choir_buyer)", "add_rep(faction.attre, 10)"]
on_player_fled: []
```
Design: Corbin (assassin) and two Choir cutthroats posing as guests. Guests scatter. Raimund's guards do not join in; they watch, and Raimund is grateful afterwards (+10). If Corbin's smoke vanish takes him out of the zone, he drops his orders (beat `corbin_vanishes`).

```yaml encounter
id: enc.warehouse_yard
zone: zone.attre_warehouse
posture: patrol
enemies:
  - {enemy: enemy.bandit, count: 2, spawn: yard_stacks, variant: spear, route: [bonded_yard], loop_s: 40}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: warehouse_entry
avoidable_by: ["dlg.pieter"]
on_won: []
on_yielded: []
on_player_fled: []
```
Design: Y1/Y2 in patrol posture, a figure-eight round the cask stacks (about 40 s per loop, they cross at the crane). They engage on alarm.

```yaml encounter
id: enc.warehouse_hall
zone: zone.attre_warehouse
enemies:
  - {enemy: enemy.bandit, count: 1, spawn: hall_far, variant: sword}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: loft_cp
avoidable_by: []
on_won: []
on_yielded: []
on_player_fled: []
```
Design: H1 walks the hall's length (30 s each way) under the loft. The rope-hoist and the sea-gate ladder both come up behind his turn.

```yaml encounter
id: enc.warehouse_alarm
zone: zone.attre_warehouse
enemies:
  - {enemy: enemy.bandit, count: 2, spawn: hall_far, variant: sword}
  - {enemy: enemy.bandit, count: 1, spawn: loft_table, variant: shield}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.bandit, count: 2, spawn: yard_stacks, variant: spear}]}
attack_tokens: null
allow_yield: true
allies: []
checkpoint: loft_cp
avoidable_by: []
on_won: []
on_yielded: []
on_player_fled: []
```
Design: the loud raid. The loft fire spreads along the racks; the dust is a poison trap while fighting in it.

## 7. Items and clues

```yaml item
id: item.raimund_ledger
name: "Raimund's private shipping ledger"
category: document
description: "A calf-bound ledger in the Duke's own hand, kept in his study strongbox. Not the harbour books. The real ones."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Midsummer. The mere job, for the Abbey's man (Br. Corbin): half in advance, 200 in bars, Abbey stamp. Bed dug, bulbs salted. To Gull Tower for the Cintra drop: 2, keeper to be dismissed (V. to paper it). Held at No. 9 pending balance: 4, two crates. Balance due 400, Abbey account, the Abbot's own surety. Previous: grey lily, two winters running, small lots, same account. Do not ask. R."
```

```yaml item
id: item.masquerade_invitation
name: "Masquerade invitation"
category: key
description: "Heavy card with the Anchor House seal: the bearer and one mask are welcome at the Duke's autumn masquerade. Worn as a disguise in masquerade zones."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Raimund, by grace Duke of Attre, bids the bearer welcome. Masks to be worn. Blades to be left at the door. Green wine to be avoided."
```

```yaml item
id: item.study_key
name: "Study key"
category: key
description: "A small brass key on a broken chain link: Raimund's study strongbox."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.strongroom_key
name: "Warehouse Nine strongroom key"
category: key
description: "A heavy iron key from the counting-house nail."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.raimund_release
name: "The Duke's release"
category: document
description: "A slip under the anchor seal ordering Gaspard to release two crates to the bearer."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Gaspard. Release the two crates in the loft to the bearer. Burn nothing. R."
```

```yaml item
id: item.corbin_orders
name: "Corbin's orders"
category: document
description: "Choir orders in a fair copy, taken from the Abbey's buyer."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Pay the merchant his balance and bring the last lily north. When the vaults wake, the merchant's warehouses burn first; a free port is a door the old order will run through. Leave him nothing. - by the Abbot's word."
```

```yaml clue
id: clue.raimund_ledger_silver
theory: theory.poisoner
title: "Abbey silver paid for the lily"
text: "Raimund's private ledger: the raid on Wenna's mere and the grey lily lots shipped to Gull Tower and held at Warehouse Nine were paid in Abbey-stamped silver through 'the Abbey's man, Br. Corbin', on the Abbot's own surety."
supports: [raimund, anselm]
refutes: []
```

```yaml clue
id: clue.raimund_choir_buyer
theory: theory.poisoner
title: "The Duke and the gull mask"
text: "At the masquerade, Raimund sold the last two crates in Warehouse Nine to a Choir buyer in a gull mask with a pale feather, payment in 'the usual bars'."
supports: [raimund]
refutes: []
```

```yaml clue
id: clue.abbey_silver_ingots
theory: theory.choir
title: "Abbey bars in a smuggler's strongroom"
text: "Warehouse Nine's strongroom holds small silver bars stamped with the Abbey of St. Corwen's lion, the Choir's coin, piled beside the Duke's own."
supports: [anselm, raimund]
refutes: []
```

```yaml clue
id: clue.aimeric_lily_sick
theory: theory.poisoner
title: "The Duke's son is dying of the lily"
text: "Aimeric, Raimund's nine-year-old heir, coughs grey-green and has pinpoint pupils. He played in Warehouse Nine's drying loft all summer. The lily his father sold is killing him."
supports: []
refutes: []
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.a2_attre_ledger, type: milestone, xp: 400, desc: "The player holds Raimund's private ledger (stolen or handed over)."}
  - {id: flag.raimund_allied, type: bool, desc: "Raimund made common cause with the Crown. Read by epilogues and act3."}
  - {id: flag.raimund_blackmailed, type: bool, desc: "The player blackmailed Raimund with his ledger."}
  - {id: flag.antidote_sold_raimund, type: bool, desc: "A dose went to Aimeric. Read by a2.08 and the endings."}
  - {id: flag.aimeric_saved, type: bool, desc: "Aimeric received the counter-dose."}
  - {id: flag.aimeric_diagnosed, type: bool, desc: "The player recognised grey lily in Aimeric."}
  - {id: flag.attre_checkpoint_passed, type: bool, desc: "The player got past the stage-3 land-gate checkpoint."}
  - {id: flag.servants_gate_open, type: bool, desc: "The kitchen porter let the player in by the side door."}
  - {id: flag.masquerade_entered, type: bool, desc: "The player entered the masquerade as a guest."}
  - {id: flag.raimund_greeted, type: bool, desc: "Raimund has greeted the player at the ball."}
  - {id: flag.raimund_meeting, type: bool, desc: "Raimund's orangery meeting with Corbin has started."}
  - {id: flag.raimund_meeting_overheard, type: bool, desc: "The player overheard the sale."}
  - {id: flag.masquerade_alarm, type: bool, desc: "The Anchor House alarm was raised."}
  - {id: flag.corbin_exposed, type: bool, desc: "The player unmasked Corbin."}
  - {id: flag.pieter_bribed, type: bool, desc: "The watchman called the yard patrol in for dice."}
  - {id: flag.gaspard_down, type: bool, desc: "Gaspard was seized before he could burn the crates."}
  - {id: flag.warehouse_release, type: bool, desc: "Gaspard received the Duke's release; no raid needed."}
  - {id: flag.warehouse_alarm, type: bool, desc: "The warehouse alarm was raised."}
  - {id: flag.attre_loud_raid, type: bool, desc: "The warehouse raid went loud (Attre -30)."}
  - {id: flag.crate_east_taken, type: bool, desc: "East crate looted (+2 bulbs)."}
  - {id: flag.crate_west_taken, type: bool, desc: "West crate looted (+2 bulbs)."}
  - {id: flag.crate_east_burned, type: bool, desc: "East crate burned by Gaspard."}
  - {id: flag.crate_west_burned, type: bool, desc: "West crate burned by Gaspard."}
reads:
  - var.bulbs_recovered
  - item.grey_lily_bulbs
  - item.wenna_antidote
  - item.anselm_journal
  - item.kosk_writ
  - item.pale_feather
  - flag.skerra_cutter
  - clue.bulbs_to_attre
  - clue.courier_foam
  - clue.chalice_pollen
  - perk.kingmaker
```

## 9. Quest hooks
Contributes the optional objective `lead_attre` of `quest.main_a2/the_marnadal_road` (declared in `a2.01`). `clue.raimund_ledger_silver` plus `clue.anselm_cipher` unlocks `ded.anselm_treason_proven` (declared in `a2.07`), which satisfies the required `proof` objective. `clue.raimund_ledger_silver` also unlocks `ded.poison_via_attre` (declared by act1).

Side-quest hooks (side slice): the quay board offers a hired boat to `morrow_gull` (60 crowns, gdd §7.5) and the Isle of Skerra. Both are owned by their side-quest files.

## 10. Rumors and event cards (optional)

Rumor 6 (`rumor.r06_raimund_crown`, side slice) is the Attre tavern rumor. It is half-true: there is no crown, but there is a dying heir the Duke won't let anyone name.

## 11. Failure states and branches

```yaml branches
paths:
  - id: quiet_heist
    when: "Player enters by invitation, servants' gate or sea stair, gets the study key (Investigate 6 desk, Lucan bribe 60, Persuade 6 or Intimidate 6), and opens the strongbox unseen."
    outcome: "Ledger; ms.a2_attre_ledger; no reputation loss."
    sets: ["reach_milestone(ms.a2_attre_ledger)"]
  - id: loud_heist
    when: "Player forces the strongbox, or is seen in a restricted area."
    outcome: "Ledger; alarm; Attre -20; fight out via the gallery or sea stair."
    sets: ["reach_milestone(ms.a2_attre_ledger)"]
  - id: allied
    when: "Player shows the ledger and passes Persuade 6 or Sway, or tells Raimund about Aimeric (clue), or shows Anselm's journal."
    outcome: "flag.raimund_allied, Attre +50, release writ, ledger handed over if not stolen."
    sets: ["set_flag(flag.raimund_allied)", "reach_milestone(ms.a2_attre_ledger)"]
  - id: blackmail
    when: "Player shows the ledger and threatens."
    outcome: "flag.raimund_blackmailed, Attre -10, release writ."
    sets: ["set_flag(flag.raimund_blackmailed)"]
  - id: sell_antidote
    when: "Player brings a dose to the terrace and sells it."
    outcome: "Aimeric lives; 300 crowns; Attre +50; Crown -10; one fewer dose for the Queen."
    sets: ["set_flag(flag.antidote_sold_raimund)"]
  - id: warehouse_quiet
    when: "Player seizes Gaspard first (or bribes Pieter and sneaks), then loots both crates."
    outcome: "+4 bulbs."
    sets: []
  - id: warehouse_released
    when: "Player hands Gaspard the Duke's release."
    outcome: "+4 bulbs, no fight."
    sets: ["set_flag(flag.warehouse_release)"]
failures:
  - id: warehouse_loud
    result: soft_fail
    recover: "Gaspard burns every unlooted crate. Bulbs from Gull Tower and the travel card still count. If none exist, Wenna's line resolves as failed (a2.05), which leads to the Boy King ending, never a soft-lock."
  - id: masquerade_alarm
    result: soft_fail
    recover: "Attre -20 and Raimund withdraws. The study remains reachable by fighting. See Open questions for a later audience."
  - id: player_dies
    result: reload_checkpoint
    recover: "Reload masquerade_entry, gallery_cp, warehouse_entry or loft_cp."
guarantees:
  - "ms.a2_attre_ledger is reachable with no check and no crowns: climb the sea stair (no gate), go up through the cellar and gallery, lever the strongbox open, and fight out."
  - "The Act II gate never needs Attre: the journal alone proves treason, and Wenna's line can resolve with Gull Tower bulbs or as failed."
```

## 12. Open questions
- **Meeting Raimund after an alarm:** once `flag.masquerade_alarm` is set, Raimund is absent from this zone for good. A later audience could be a harbour variant (he receives the player at the Anchor House gate by day). This file does not add it; the terrace dialogue is therefore lost after an alarm unless the player is allied by other means. Recommend a day-time `dlg.raimund_terrace` entry point in the harbour for players with the ledger.
- **Guard archetype:** Attre's ducal guards use `enemy.bandit` variants. A `enemy.ducal_guard` reskin would read better.
- **Disguise rules:** the sea-stair and servants'-gate entries leave the player "not permitted" (no invitation). gdd §6.5 does not say whether a masquerade mask can be picked up inside; this file assumes not.
- `item.masquerade_invitation` is declared here (gdd §6.9 key item); the Drowned Rat safehouse references it (checked by A08).
- `clue.aimeric_lily_sick` gives a check-free alliance route. That is deliberate: the leverage is moral, not a dice roll.
