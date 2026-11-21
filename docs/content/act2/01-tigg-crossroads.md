---
section_id: a2.01
title: "Tigg and the Crooked Crossroads"
act: 2
story_ref: "story.md §2 (Autumn 1268 wyvern), §6 Tigg & The Crooked Crossroads, §7.5 Wyvern's Roost (setup)"
zones: [zone.tigg_village, zone.tigg_pastures]
available_when: "ms(ms.act1_complete) and not ms(ms.act2_twist)"
escalation_stage_required: {min: 1, max: 3}
milestones_set: [ms.a2_tigg_resolved]
milestones_read: [ms.a2_attre_ledger, ms.a2_cipher_taken, ms.a2_jory_dealt, ms.a2_tigg_resolved, ms.a2_torc_taken, ms.a2_vel_aram_cleared, ms.a2_wenna_line_resolved, ms.act1_complete, ms.act2_twist]
level_band: [5, 6]
---

# Tigg and the Crooked Crossroads

## 1. Scene summary
Tigg is a drover village where the Cintra road meets the Marnadal valley road, at a crossroads whose waymarker was bent sideways by a siege wagon in Corvan's day. Sheep and cattle vanish from the high fold every dusk, and the village has decided a halfwit drover named Ned is the thief. When the player arrives, Ned is standing on a cart under the gibbet with a rope round his neck. The real culprit is a mountain wyvern. Tremors and Choir blasting near Ostrel drove her down off the crags, and she is following the scent of two eggs that Choir scouts stole from her nest and carried south along this road. The player can save or abandon Ned, find the dead Choir scout and the empty egg crate in the pastures (`clue.wyvern_eggs_stolen`), unmask the shrine-keeper who feeds the hooded monks, and then drive the wyvern off, either in a boss fight (she flees at half health) or by relighting three old tar beacons so the smoke turns her away. The dramatic question: will the player stop at killing the monster, or read what the monster is telling them? The section ends when the wyvern leaves Tigg (`ms.a2_tigg_resolved`).

## 2. Progress and escalation
- `ms.a2_tigg_resolved` is set when the wyvern is driven off: by winning `enc.tigg_wyvern` (she flees at 50% HP, so the win is a drive-off by design), or by lighting the third tar beacon before she is engaged.
- The wyvern must survive. She returns as the Act III Wyvern's Roost boss or ally (`act3/05-wyverns-roost.md`). Flags `flag.wyvern_fought` and `flag.wyvern_driven_by_smoke` tell Act III how she was turned away.
- **Stage 1:** the base layout. Mob at the gibbet on first entry.
- **Stage 2 (`stage() >= 2`):** refugees from the lower Marnadal camp on the green (three lean-tos, a cookfire) and talk of the river running dark with silt. Marga's prices are already raised by the system. One extra bark set.
- **Stage 3 (`stage() >= 3`):** pale-feather proclamations are nailed to the gibbet. If Brother Aske was never exposed, he preaches openly at the crossroads with two zealots (`enc.tigg_proclaimers`). If he was exposed, the shrine is boarded and chalked with feathers.
- **After `ms.a2_tigg_resolved`:** the fold is restocked, villagers greet the player by name, the bounty is paid on asking.

## 3. Location layout
**Tigg village** (day, exterior, roughly 120 × 90 m). The north road from Cintra enters past the tanner's yard. The **Crooked Crossroads** sits at the centre: a 30 × 30 m open square of rutted mud, the bent waymarker in the middle (the travel-map interact), an iron gibbet on a 3 m turf mound on the west side, and the wattle-walled roadside **shrine of St. Corwen** on the east side with a trapdoor cellar. Two hay wains give low cover. South of the square is the **green** (40 × 25 m) with the stone **pound**, the well, and Godric's bench. **The Bent Post** inn (interior area: taproom, two rooms upstairs, a rest bed) fronts the green. The **reeve's house** and the **pitch shed** (tar for the barns, three tar pots on a shelf) are on the east lane. The **pasture track** leaves from the south-east corner behind the pound; the **south road** leaves due south toward the Marnadal crossings.

Sight lines: from the gibbet mound you see the whole square and the shrine door. The shrine cellar has a second hatch behind the shrine, hidden by a woodpile (Investigate 6 to spot, or Aske's confession).

**Tigg pastures** (dusk, exterior, roughly 220 × 160 m, climbing south-east). The **village track** (60 m hedged lane) opens onto the **high fold**: a 20 × 20 m dry-stone sheepfold (walls 1.2 m, full cover when crouched), a gate, Ailsa's turf hut, and a bronze fold bell on a post. East of the fold rises the **beacon ridge**, a bare limestone spine with two old war-beacon cairns (A at the north end, B at the south end, 50 m apart, no cover, full view of the sky). The ridge drops into the **wolf gully** (6 m wide, steep scree walls, a carcass heap, beacon C at the gully head); scree slopes are a `collapse` hazard if the player sprints on them. Above the gully, reached by a goat path from the ridge, is the **feeding ledge** where the wyvern drops kills: bones, wool, a dead Choir scout, shed scales. North of the fold is the **beech hanger**, a dark wood holding the abandoned **Choir scout camp** (a lean-to, a cold fire ring, a straw-lined crate). South of the fold is the **landing field**, a 60 × 40 m open slope with four boulders (full cover) and a lightning-dead oak. This is the boss arena. The wyvern lands here on the ground phase and circles the whole valley in the air phase.

Intended route: village → (mob scene) → talk to Hobb, Godric, Marga → pastures → investigate the hanger and the ledge → beacons or fight.

```yaml zone
id: zone.tigg_village
name: "Tigg"
kind: exterior
map_node: map.tigg
time_of_day: day
cold_rate: 0
disguise_tag: null
music: village_uneasy
areas:
  - {id: north_road, description: "Rutted road from Cintra past the tanner's yard. Hides drying on frames give soft cover."}
  - {id: crossroads, description: "The Crooked Crossroads. 30 x 30 m mud square, the bent waymarker at centre, two hay wains (low cover)."}
  - {id: gibbet_mound, description: "3 m turf mound, west side of the square. Iron gibbet, a cart beneath it. Overlooks the whole square."}
  - {id: shrine, description: "Wattle shrine of St. Corwen, east side. One room: altar, offering box, lantern hook outside. Trapdoor to the cellar."}
  - {id: shrine_cellar, description: "Earth cellar, 6 x 4 m, sacks of bread, a cot, a hidden rear hatch behind the woodpile."}
  - {id: green, description: "Village green, 40 x 25 m. Stone pound (holding pen), well, Godric's bench. Refugee lean-tos at stage 2."}
  - {id: bent_post, description: "The Bent Post inn. Taproom with long table and hearth, stair to two rooms, a rest bed."}
  - {id: reeve_lane, description: "East lane: the reeve's house and the pitch shed with tar pots on a shelf."}
  - {id: south_gate, description: "South edge of the village: the pasture track (south-east) and the south road (due south)."}
spawns:
  - {id: north_road, area: north_road, default: true}
  - {id: south_road, area: south_gate}
  - {id: pasture_track, area: south_gate}
  - {id: shrine_cellar_hatch, area: shrine_cellar}
  - {id: crossroads_east, area: crossroads}
exits:
  - id: to_pastures
    area: south_gate
    to_zone: zone.tigg_pastures
    to_spawn: village_track
    condition: "true"
    effects: []
  - {id: waymarker, area: crossroads, to_map: true, label: "The bent waymarker (travel)", condition: "true", effects: []}
interactables:
  - id: bounty_notice
    area: crossroads
    kind: readable
    label: "Read the notice nailed to the waymarker"
    condition: "true"
    check: null
    once: false
    effects: ["verify_rumor(rumor.r03_dragon_amell)"]
  - id: shrine_offering_box
    area: shrine
    kind: search
    label: "Search the offering box"
    condition: "not flag(flag.aske_exposed)"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["add_clue(clue.tigg_monks_south)", "give_item(item.pale_feather, 1)"]
    fail_effects: []
  - id: shrine_trapdoor
    area: shrine
    kind: door
    label: "Open the cellar trapdoor"
    condition: "flag(flag.aske_exposed) or flag(flag.aske_cellar_found)"
    check: null
    once: false
    effects: []
  - id: woodpile_hatch
    area: shrine
    kind: search
    label: "Look behind the woodpile"
    condition: "not flag(flag.aske_exposed)"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["set_flag(flag.aske_cellar_found)"]
    fail_effects: []
  - id: cellar_cot
    area: shrine_cellar
    kind: search
    label: "Search the cot and sacks"
    condition: "true"
    check: null
    once: true
    effects: ["add_clue(clue.tigg_monks_south)", "add_crowns(35)"]
  - id: pitch_shed
    area: reeve_lane
    kind: pickup
    label: "Take the tar pots"
    condition: "flag(flag.tar_given) or flag(flag.tigg_beacon_lore)"
    check: null
    once: true
    effects: ["give_item(item.tar_pot, 3)"]
  - id: inn_bed
    area: bent_post
    kind: rest
    label: "Rent a bed (rest)"
    condition: "true"
    check: null
    once: false
    effects: ["heal_player(full)", "set_checkpoint(inn_rest)"]
  - id: pound_gate
    area: green
    kind: door
    label: "Open the pound and free Ned"
    condition: "flag(flag.ned_held) and (has_item(item.wyvern_scale) or ms(ms.a2_tigg_resolved))"
    check: null
    once: true
    effects: ["clear_flag(flag.ned_held)", "set_flag(flag.ned_saved)", "play_beat(ned_freed)", "start_dialogue(dlg.ned_thanks)"]
triggers:
  - id: mob_on_arrival
    area: crossroads
    "on": enter
    source: null
    condition: "not flag(flag.tigg_mob_resolved)"
    once: true
    effects: ["play_beat(mob_at_gibbet)", "start_dialogue(dlg.tigg_mob)"]
  - id: proclaimers
    area: crossroads
    "on": enter
    source: null
    condition: "stage() >= 3 and not flag(flag.aske_exposed)"
    once: true
    effects: ["play_beat(aske_preaches)", "start_dialogue(dlg.aske_open)"]
  - id: aske_fight_done
    area: shrine
    "on": encounter_done
    source: enc.aske_unmasked
    condition: "true"
    once: true
    effects: ["set_flag(flag.aske_exposed)", "set_flag(flag.oak_signal_known)"]
hazards: []
checkpoints:
  - {id: village_arrival, area: north_road}
  - {id: inn_rest, area: bent_post}
beats:
  - {id: mob_at_gibbet, description: "Camera finds Ned on the cart under the gibbet, rope on, a dozen villagers with torches and forks. Hobb holds the rope's end."}
  - {id: ned_hanged, description: "The cart is pulled. The player is turned away by Hobb's men; the sound carries. Ned's body stays on the gibbet."}
  - {id: mob_disperses, description: "Villagers lower forks and drift back to their doors. Hobb cuts the rope himself."}
  - {id: ned_to_pound, description: "Two drovers march Ned into the stone pound and drop the bar."}
  - {id: ned_freed, description: "Ned stumbles out of the pound, blinking, and grabs the player's sleeve."}
  - {id: aske_preaches, description: "Brother Aske on the gibbet mound, two zealots beside him, reading a feather proclamation to a thin crowd."}
  - {id: aske_flees, description: "Aske bolts through the shrine and drops into the cellar; the rear hatch bangs."}
npcs:
  - {npc: npc.reeve_hobb, area: crossroads, condition: "not flag(flag.tigg_mob_resolved)"}
  - {npc: npc.reeve_hobb, area: reeve_lane, condition: "flag(flag.tigg_mob_resolved)"}
  - {npc: npc.ned, area: gibbet_mound, condition: "not flag(flag.tigg_mob_resolved)"}
  - {npc: npc.ned, area: green, condition: "flag(flag.ned_held)"}
  - {npc: npc.ned, area: green, condition: "flag(flag.ned_saved)"}
  - {npc: npc.tigg_innkeeper, area: bent_post, condition: "true"}
  - {npc: npc.godric, area: green, condition: "true"}
  - {npc: npc.brother_aske, area: shrine, condition: "not flag(flag.aske_exposed) and stage() < 3"}
  - {npc: npc.brother_aske, area: gibbet_mound, condition: "not flag(flag.aske_exposed) and stage() >= 3"}
encounters: [enc.aske_unmasked, enc.tigg_proclaimers]
loot:
  - {container: cellar_cot, items: [{item: item.antitoxin, count: 1}], condition: "true"}
variants:
  - id: refugees
    when: "stage() >= 2"
    description: "Three refugee lean-tos on the green, a cookfire, a family from the lower Marnadal. Barks mention the river running black with silt."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: proclamations
    when: "stage() >= 3"
    description: "Pale-feather proclamations nailed to the gibbet and the waymarker: 'The rotten crown falls at the turning of the year.'"
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: ned_dead
    when: "flag(flag.ned_hanged)"
    description: "Ned's body hangs in the gibbet cage. His mother sits under it and does not look up."
    npcs_absent: [npc.ned]
    encounters_disabled: []
    interactables_disabled: [pound_gate]
  - id: shrine_boarded
    when: "flag(flag.aske_exposed)"
    description: "The shrine door is boarded. Someone has chalked a feather on the planks anyway."
    npcs_absent: [npc.brother_aske]
    encounters_disabled: [enc.tigg_proclaimers]
    interactables_disabled: [shrine_offering_box, woodpile_hatch]
  - id: tigg_saved
    when: "ms(ms.a2_tigg_resolved)"
    description: "Sheep back in the fold, a garland on the waymarker. Children play at wyvern-and-shepherd on the green."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
```

```yaml zone
id: zone.tigg_pastures
name: "Tigg High Pastures"
kind: exterior
map_node: map.tigg
time_of_day: dusk
cold_rate: 0
disguise_tag: null
music: pasture_dread
areas:
  - {id: village_track, description: "60 m hedged lane climbing from the village. Hedges are full cover from the air."}
  - {id: high_fold, description: "20 x 20 m dry-stone sheepfold, walls 1.2 m (full cover crouched), gate on the north side. Ailsa's turf hut. Fold bell on a post."}
  - {id: beacon_ridge, description: "Bare limestone spine east of the fold. Beacon cairn A (north end) and B (south end), 50 m apart. No cover. Full sky view."}
  - {id: wolf_gully, description: "6 m wide gully below the ridge. Steep scree walls, a carcass heap, beacon cairn C at its head. Wolves feed here."}
  - {id: feeding_ledge, description: "Rock shelf above the gully, reached by a goat path from the ridge. Bones, wool, shed scales, a dead Choir scout."}
  - {id: beech_hanger, description: "Dark beech wood north of the fold. Abandoned Choir scout camp: lean-to, cold fire ring, a straw-lined crate."}
  - {id: landing_field, description: "Open slope 60 x 40 m south of the fold. Four boulders (full cover), a lightning-dead oak. The wyvern's ground arena."}
spawns:
  - {id: village_track, area: village_track, default: true}
  - {id: gully_den, area: wolf_gully}
  - {id: wyvern_sky, area: landing_field}
exits:
  - id: to_village
    area: village_track
    to_zone: zone.tigg_village
    to_spawn: pasture_track
    condition: "true"
    effects: []
interactables:
  - id: cairn_plaque
    area: beacon_ridge
    kind: readable
    label: "Read the weathered plaque on cairn A"
    condition: "true"
    check: {skill: lore, dc: 6}
    once: true
    effects: ["set_flag(flag.tigg_beacon_lore)"]
    fail_effects: []
  - id: beacon_a
    area: beacon_ridge
    kind: lever
    label: "Fill cairn A with tar and light it"
    condition: "has_item(item.tar_pot) and not ms(ms.a2_tigg_resolved)"
    check: null
    once: true
    effects: ["take_item(item.tar_pot, 1)", "add_var(var.tigg_beacons_lit, 1)", "play_beat(beacon_lit)"]
  - id: beacon_b
    area: beacon_ridge
    kind: lever
    label: "Fill cairn B with tar and light it"
    condition: "has_item(item.tar_pot) and not ms(ms.a2_tigg_resolved)"
    check: null
    once: true
    effects: ["take_item(item.tar_pot, 1)", "add_var(var.tigg_beacons_lit, 1)", "play_beat(beacon_lit)"]
  - id: beacon_c
    area: wolf_gully
    kind: lever
    label: "Fill cairn C with tar and light it"
    condition: "has_item(item.tar_pot) and not ms(ms.a2_tigg_resolved)"
    check: null
    once: true
    effects: ["take_item(item.tar_pot, 1)", "add_var(var.tigg_beacons_lit, 1)", "play_beat(beacon_lit)"]
  - id: scout_corpse
    area: feeding_ledge
    kind: search
    label: "Search the dead monk"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.pale_feather, 1)", "add_clue(clue.wyvern_eggs_stolen)", "add_crowns(12)"]
  - id: ledge_scales
    area: feeding_ledge
    kind: pickup
    label: "Take a shed scale"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.wyvern_scale, 1)"]
  - id: egg_crate
    area: beech_hanger
    kind: search
    label: "Search the straw-lined crate"
    condition: "true"
    check: null
    once: true
    effects: ["add_clue(clue.wyvern_eggs_stolen)", "give_item(item.scout_note, 1)"]
  - id: camp_fire_ring
    area: beech_hanger
    kind: search
    label: "Sift the cold fire ring"
    condition: "true"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["add_clue(clue.tigg_monks_south)"]
    fail_effects: []
  - id: fold_bell
    area: high_fold
    kind: lever
    label: "Ring the fold bell and wait for her"
    condition: "not ms(ms.a2_tigg_resolved)"
    check: null
    once: false
    effects: ["set_checkpoint(before_wyvern)", "play_beat(wyvern_arrives)", "start_encounter(enc.tigg_wyvern)"]
  - id: ailsa_hut_rest
    area: high_fold
    kind: rest
    label: "Rest by Ailsa's fire"
    condition: "flag(flag.ailsa_trusts)"
    check: null
    once: false
    effects: ["heal_player(full)", "set_checkpoint(before_wyvern)"]
triggers:
  - id: wyvern_on_field
    area: landing_field
    "on": enter
    source: null
    condition: "not ms(ms.a2_tigg_resolved) and var(var.tigg_beacons_lit) < 3"
    once: false
    effects: ["set_checkpoint(before_wyvern)", "play_beat(wyvern_arrives)", "start_encounter(enc.tigg_wyvern)"]
  - id: wolves_in_gully
    area: wolf_gully
    "on": enter
    source: null
    condition: "true"
    once: true
    effects: ["start_encounter(enc.tigg_wolves)"]
  - id: ring_complete_a
    area: beacon_ridge
    "on": interact
    source: beacon_a
    condition: "var(var.tigg_beacons_lit) >= 3"
    once: true
    effects: ["play_beat(wyvern_veers_off)", "set_flag(flag.wyvern_driven_by_smoke)", "reach_milestone(ms.a2_tigg_resolved)"]
  - id: ring_complete_b
    area: beacon_ridge
    "on": interact
    source: beacon_b
    condition: "var(var.tigg_beacons_lit) >= 3"
    once: true
    effects: ["play_beat(wyvern_veers_off)", "set_flag(flag.wyvern_driven_by_smoke)", "reach_milestone(ms.a2_tigg_resolved)"]
  - id: ring_complete_c
    area: wolf_gully
    "on": interact
    source: beacon_c
    condition: "var(var.tigg_beacons_lit) >= 3"
    once: true
    effects: ["play_beat(wyvern_veers_off)", "set_flag(flag.wyvern_driven_by_smoke)", "reach_milestone(ms.a2_tigg_resolved)"]
hazards:
  - {id: gully_scree, area: wolf_gully, kind: collapse, params: {tripped_by: sprint, damage: 15, knockdown: true}}
checkpoints:
  - {id: before_wyvern, area: high_fold}
beats:
  - {id: beacon_lit, description: "Black tar smoke boils up from the cairn and leans east in the wind."}
  - {id: wyvern_arrives, description: "A shriek off the crags. The wyvern drops out of the dusk onto the landing field, wings mantled."}
  - {id: wyvern_veers_off, description: "The wyvern banks over the ring of smoke, shrieks once at the south road, and beats away toward the Amell."}
  - {id: wyvern_flees, description: "Bleeding from a wing, the wyvern hauls herself into the air and flies south-east toward the mountains."}
npcs:
  - {npc: npc.ailsa, area: high_fold, condition: "true"}
encounters: [enc.tigg_wyvern, enc.tigg_wolves]
loot:
  - {container: egg_crate, items: [{item: item.crossbow_bolt, count: 6}], condition: "true"}
variants:
  - id: pastures_quiet
    when: "ms(ms.a2_tigg_resolved)"
    description: "Smoke-stained cairns, sheep grazing the landing field. The ledge is empty."
    npcs_absent: []
    encounters_disabled: [enc.tigg_wyvern]
    interactables_disabled: [fold_bell, beacon_a, beacon_b, beacon_c]
```

## 4. NPCs present
**Voice notes.** Hobb: blunt, frightened, a man who needs someone to blame before his neighbours blame him; short sentences, says "we" for the village. Ned: slow, sing-song, says "them" for sheep and people alike. Marga: dry innkeeper humour, keeps a cudgel under the bar, knows every traveller's boots. Godric: an old crown falconer with a ruined hip, speaks of beasts with respect and of nobles with none. Ailsa: twelve, sharp, pretends not to be scared. Brother Aske: gentle, tired, pious; his voice drops when he lies.

```yaml npc
id: npc.reeve_hobb
name: "Reeve Hobb Tanner"
faction: null
role: "Reeve of Tigg, tanner"
motive: "Stop the losses before the village turns on him."
secret: "He knows Ned only butchers carcasses he finds dead; hanging him is easier than admitting he can't protect the fold."
disposition: wary
essential: true
dialogue: dlg.reeve_hobb
barks: ["Mind the road, it bites.", "Tigg looks after Tigg.", "If you're a beast-hunter, you're late."]
combat: null
shop: null
```

```yaml npc
id: npc.ned
name: "Ned"
faction: null
role: "Simple drover accused of stealing stock"
motive: "Not to hang. Then, to be useful."
secret: "He has been eating the wyvern's leftovers on the feeding ledge and kept a shed scale as a pretty thing."
disposition: friendly
essential: true
dialogue: dlg.ned_thanks
barks: ["Them up the ledge was already dead.", "She's got a shine on her, the big bird.", "I didn't take them."]
combat: null
shop: null
```

```yaml npc
id: npc.tigg_innkeeper
name: "Marga of the Bent Post"
faction: null
role: "Innkeeper at Tigg"
motive: "Keep the inn full and the road open."
secret: "She has seen the hooded monks pay Brother Aske in Abbey-stamped silver."
disposition: neutral
essential: true
dialogue: dlg.marga
barks: ["Boots off the table.", "Bed's three crowns, ale's one, trouble's extra.", "Road's been strange since harvest."]
combat: null
shop: {stock: [{item: item.poultice, count: 6}, {item: item.field_draught, count: 3}, {item: item.antitoxin, count: 3}, {item: item.crossbow_bolt, count: 20}, {item: item.fire_oil, count: 2}, {item: item.frost_tallow, count: 2}, {item: item.tar_pot, count: 3}], price_mod: 1.0}
```

```yaml npc
id: npc.godric
name: "Old Godric"
faction: null
role: "Retired crown falconer"
motive: "To be listened to once more before he dies."
secret: "He saw a wyvern once before, in his youth, guarding eggs near the Marnadal Stairs."
disposition: neutral
essential: true
dialogue: dlg.godric
barks: ["That's no dragon. Dragons are for songs.", "Hip's worse in the wet.", "Watch the sky, not the ground."]
combat: null
shop: null
```

```yaml npc
id: npc.ailsa
name: "Ailsa"
faction: null
role: "Shepherd girl at the high fold"
motive: "Keep what's left of her father's flock."
secret: "She watched the wyvern drop the dead monk and sniff at the crate he carried."
disposition: wary
essential: true
dialogue: dlg.ailsa
barks: ["Don't scare them.", "She comes when the light goes.", "My dog went up the ledge. He didn't come back."]
combat: null
shop: null
```

```yaml npc
id: npc.brother_aske
name: "Brother Aske"
faction: faction.choir
role: "Keeper of the roadside shrine of St. Corwen"
motive: "Feed and hide the Choir's couriers and light the gibbet lantern when one is due at the Oak."
secret: "A sworn brother of the Pale Choir. A pale feather is stitched into his sandal strap."
disposition: friendly
essential: false
dialogue: dlg.aske
barks: ["Bread for pilgrims, brother.", "The saint keeps the road.", "Peace on you, traveller."]
combat: enemy.choir_thug
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.tigg_mob
participants: [npc.reeve_hobb, npc.ned]
start: open
nodes:
  open:
    type: line
    speaker: npc.reeve_hobb
    text: "Stand off, stranger. This is Tigg business. Fourteen ewes and two heifers since harvest, and him with blood to the elbows. Tigg hangs its thieves."
    direction: "Holding the end of the rope. A dozen villagers with torches and hay forks behind him."
    next: wat_pleads
  wat_pleads:
    type: line
    speaker: npc.ned
    text: "I never took them! I only cut the dead ones up the ledge. They was already dead. They was already dead!"
    direction: "On the cart, rope round his neck, rocking on his heels."
    next: hub
  hub:
    type: choice
    options:
      - id: ask
        text: "What exactly has he done?"
        next: explain
      - id: writ
        text: "[Item: Marshal's writ] This man is in the Lord Marshal's custody. Cut him down."
        tag: item
        condition: "has_item(item.kosk_writ)"
        next: writ_pass
      - id: persuade
        text: "[Persuade 6] Sheep don't vanish in ones and twos from a walled fold. Something big is feeding on you, and it isn't Ned."
        tag: persuade
        check: {skill: persuade, dc: 6, pass: persuade_pass, fail: persuade_fail}
      - id: intimidate
        text: "[Intimidate 6] Cut him down, or I cut the rope, and then whoever's holding it."
        tag: intimidate
        check: {skill: intimidate, dc: 6, pass: intimidate_pass, fail: intimidate_fail}
      - id: bribe
        text: "[Bribe 30] For the lost ewes. Take it and let the man go."
        tag: bribe
        bribe: 30
        next: bribe_pass
      - id: sway
        text: "[Sway] You're the reeve, Hobb. Hang him tonight and the beast takes a heifer tomorrow. Whose neck do they want then?"
        tag: sway
        condition: "perk(perk.kingmaker)"
        next: persuade_pass
      - id: delay
        text: "[Persuade 4] Lock him in the pound. If I don't bring you the real thief, hang him then."
        tag: persuade
        check: {skill: persuade, dc: 4, pass: delay_pass, fail: delay_fail}
      - id: walk
        text: "Not my village. Not my business."
        next: walk_confirm
  explain:
    type: line
    speaker: npc.reeve_hobb
    text: "Found him on the gully path at first light, gutting a ewe. Knife in his hand. What more do you want, a confession? He can't string three words."
    next: hub
  writ_pass:
    type: line
    speaker: npc.reeve_hobb
    text: "The Marshal's seal. Out here. Fine. Fine! Take him, and you can explain to Tigg who pays for the next ewe."
    effects: ["set_flag(flag.ned_saved)", "set_flag(flag.tigg_mob_resolved)", "play_beat(mob_disperses)", "add_rep(faction.crown, 2)"]
    next: end_saved
  persuade_pass:
    type: line
    speaker: npc.reeve_hobb
    text: "Walled fold, gate barred, and the ewes gone with the wall standing... Damn you. Cut him down. But if it's not a beast, I'll hang you both."
    effects: ["set_flag(flag.ned_saved)", "set_flag(flag.tigg_mob_resolved)", "play_beat(mob_disperses)"]
    next: end_saved
  persuade_fail:
    type: line
    speaker: npc.reeve_hobb
    text: "Pretty words from a stranger with a sword. We've heard words."
    next: hub
  intimidate_pass:
    type: line
    speaker: npc.reeve_hobb
    text: "All right! All right. Nobody's dying in the square tonight. Get him down."
    direction: "The villagers step back first; Hobb follows."
    effects: ["set_flag(flag.ned_saved)", "set_flag(flag.tigg_mob_resolved)", "play_beat(mob_disperses)"]
    next: end_saved
  intimidate_fail:
    type: line
    speaker: npc.reeve_hobb
    text: "There's twelve of us and one of you. Mind your tone."
    direction: "Forks come up. Nobody moves."
    next: hub
  bribe_pass:
    type: line
    speaker: npc.reeve_hobb
    text: "Thirty. That's two ewes. It's not justice. It'll do. Cut him loose."
    effects: ["set_flag(flag.ned_saved)", "set_flag(flag.tigg_mob_resolved)", "play_beat(mob_disperses)"]
    next: end_saved
  delay_pass:
    type: line
    speaker: npc.reeve_hobb
    text: "The pound, then. One chance, stranger. Bring me the thing that takes our stock, or a piece of it."
    effects: ["set_flag(flag.ned_held)", "set_flag(flag.tigg_mob_resolved)", "play_beat(ned_to_pound)"]
    next: end_held
  delay_fail:
    type: line
    speaker: npc.reeve_hobb
    text: "And let him run in the night? No."
    next: hub
  walk_confirm:
    type: choice
    options:
      - id: confirm_walk
        text: "(Walk away. Ned will hang.)"
        next: hanged
      - id: back
        text: "(Wait. Turn back.)"
        next: hub
  hanged:
    type: line
    speaker: npc.ned
    text: "They was already dead!"
    effects: ["set_flag(flag.ned_hanged)", "set_flag(flag.tigg_mob_resolved)", "play_beat(ned_hanged)"]
    next: end_hanged
  end_saved:
    type: line
    speaker: npc.ned
    text: "You're kind. You're kind. I'll show you where she drops them."
    next: bye
  end_held:
    type: line
    speaker: npc.ned
    text: "Up the ledge. Ask the big bird. She knows."
    next: bye
  end_hanged:
    type: end
  bye:
    type: end
```

```yaml dialogue
id: dlg.reeve_hobb
participants: [npc.reeve_hobb]
start: greet
nodes:
  greet:
    type: branch
    cases:
      - {if: "ms(ms.a2_tigg_resolved) and not flag(flag.tigg_bounty_paid)", next: reward}
      - {if: "flag(flag.ned_hanged)", next: greet_guilty}
    else: greet_plain
  greet_plain:
    type: line
    speaker: npc.reeve_hobb
    text: "Well? Every dusk we lose another. Are you hunting it or drinking at Marga's?"
    next: hub
  greet_guilty:
    type: line
    speaker: npc.reeve_hobb
    text: "Don't look at me like that. We lost two more last night. So maybe it wasn't him. Maybe."
    direction: "He doesn't meet the player's eye. Ned's mother is sitting under the gibbet."
    next: hub
  hub:
    type: choice
    options:
      - id: beast
        text: "Tell me what you've seen."
        next: beast
      - id: bounty
        text: "You posted a bounty."
        next: bounty
      - id: tar
        text: "The old cairns on the ridge. I need tar to light them."
        condition: "flag(flag.tigg_beacon_lore) and not flag(flag.tar_given)"
        next: tar
      - id: free_wat
        text: "[Item: Wyvern scale] Here's your thief. Scaled, winged, and bigger than your church. Let Ned out."
        tag: item
        condition: "flag(flag.ned_held) and has_item(item.wyvern_scale)"
        next: free_wat
      - id: monks
        text: "Who comes through Tigg by night?"
        next: monks
      - id: leave
        text: "I'll handle it."
        next: bye
  beast:
    type: line
    speaker: npc.reeve_hobb
    text: "Nothing. That's the thing. The ewes are there at sunset and gone by dark, and the wall's standing. Godric says it comes from the sky. Godric's eighty."
    next: hub
  bounty:
    type: line
    speaker: npc.reeve_hobb
    text: "Eighty crowns, all Tigg could scrape. For whatever takes our stock, dead or gone. Gone's fine. Gone is better than fine."
    next: hub
  tar:
    type: line
    speaker: npc.reeve_hobb
    text: "My grandsire's lot lit those cairns when the Strept came raiding. Pitch shed's unlocked. Take three pots and don't set my roof alight."
    effects: ["set_flag(flag.tar_given)"]
    next: hub
  free_wat:
    type: line
    speaker: npc.reeve_hobb
    text: "God's teeth. Big as a cart-wheel. All right. Open the pound. And I'll... I'll say sorry to his mother."
    effects: ["clear_flag(flag.ned_held)", "set_flag(flag.ned_saved)", "play_beat(ned_freed)"]
    next: hub
  monks:
    type: line
    speaker: npc.reeve_hobb
    text: "Pilgrims for St. Corwen. Brother Aske feeds them at the shrine. Holy men walking at night's not my concern. Sheep are."
    next: hub
  reward:
    type: line
    speaker: npc.reeve_hobb
    text: "She's gone. Sheep are back in the fold and nobody's dead on my mound tonight. Eighty crowns, as promised. Tigg won't forget."
    effects: ["add_crowns(80)", "set_flag(flag.tigg_bounty_paid)", "add_rep(faction.crown, 5)"]
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.godric
participants: [npc.godric]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.godric
    text: "You're the one who cut Ned down. Or the one who didn't. Either way, sit. My hip says it'll rain and my eyes say you want to know about the sky."
    direction: "On his bench by the well, a falconer's glove on his knee."
    next: hub
  hub:
    type: choice
    options:
      - id: what
        text: "What is it?"
        next: what
      - id: why
        text: "Why would it come down to Tigg?"
        next: why
      - id: lore
        text: "[Lore 6] A wyvern hen this far down means something drove her out, or something was taken from her."
        tag: lore
        check: {skill: lore, dc: 6, pass: lore_pass, fail: lore_fail}
        once: true
      - id: drive
        text: "How do I drive her off?"
        next: drive
      - id: kill
        text: "Can she be killed?"
        next: kill
      - id: leave
        text: "Thank you, old man."
        next: bye
  what:
    type: line
    speaker: npc.godric
    text: "Not a dragon, whatever Marga's drunks say. A mountain wyvern. A hen, by the spread of the prints in the fold. Twice a war-horse, tail with a sting like a hornet's."
    next: hub
  why:
    type: line
    speaker: npc.godric
    text: "They nest high on the Amell. The ground's been shaking up there since spring, they say, and blasting. But a hen doesn't leave her clutch for a shake. She'd leave it for nothing."
    next: hub
  lore_pass:
    type: line
    speaker: npc.godric
    text: "Ha. Someone taught you. Aye. She takes a ewe, but she sniffs the road first, every time. South road. She's tracking something by the nose. Look where she drops her kills."
    effects: ["set_flag(flag.tigg_beacon_lore)"]
    next: hub
  lore_fail:
    type: line
    speaker: npc.godric
    text: "Maybe. Maybe not. You don't know beasts, I can hear it."
    next: hub
  drive:
    type: line
    speaker: npc.godric
    text: "Tar smoke. They hate it, it clogs the nose they hunt by. There's three old war cairns round the high fold. Light all three and she'll not cross the ring. Hobb has tar."
    effects: ["set_flag(flag.tigg_beacon_lore)"]
    next: hub
  kill:
    type: line
    speaker: npc.godric
    text: "You? No. Bolt her wing when she's aloft and she'll come down hard. Hurt her enough and she'll go. Then pray she doesn't remember your face."
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.marga
participants: [npc.tigg_innkeeper]
start: greet
nodes:
  greet:
    type: branch
    cases:
      - {if: "stage() >= 3", next: greet_s3}
      - {if: "stage() >= 2", next: greet_s2}
    else: greet_s1
  greet_s1:
    type: line
    speaker: npc.tigg_innkeeper
    text: "Bed's three crowns, ale's one, trouble's extra. You look like extra."
    next: hub
  greet_s2:
    type: line
    speaker: npc.tigg_innkeeper
    text: "River folk on my green, river black as a boot. Bed's still three crowns. For now."
    next: hub
  greet_s3:
    type: line
    speaker: npc.tigg_innkeeper
    text: "Feathers nailed to my door this morning. I took them down. Someone put them back. What'll it be?"
    next: hub
  hub:
    type: choice
    options:
      - id: shop
        text: "Show me what you've got."
        effects: ["open_shop(npc.tigg_innkeeper)"]
        next: hub
      - id: news
        text: "Heard anything on the road?"
        next: news
      - id: monks
        text: "Hooded travellers. Monks. Seen any?"
        next: monks
      - id: silver
        text: "[Investigate 6] You watch boots. What do the monks pay with?"
        tag: investigate
        condition: "rumor_heard(rumor.tigg_monks_south)"
        check: {skill: investigate, dc: 6, pass: silver_pass, fail: silver_fail}
        once: true
      - id: leave
        text: "Later."
        next: bye
  news:
    type: line
    speaker: npc.tigg_innkeeper
    text: "Ninefingers Jory's charging double at the crossings. Someone says the dead walk on Marnadal Field at new moon. Someone always says that."
    effects: ["add_map_pin(map.ferrymen_camp)", "add_map_pin(map.marnadal_field)"]
    next: hub
  monks:
    type: line
    speaker: npc.tigg_innkeeper
    text: "Six of them, a fortnight back, after dark. Big crate slung between two poles, heavy enough to bow them. Brother Aske lit his lantern on the gibbet for them. He does that."
    effects: ["add_rumor(rumor.tigg_monks_south)", "add_clue(clue.tigg_monks_south)"]
    next: hub
  silver_pass:
    type: line
    speaker: npc.tigg_innkeeper
    text: "Sharp. Silver. Bars cut small, with the Abbey's lion stamped on. Aske spends it here on wine he says is for the sacrament."
    effects: ["add_clue(clue.tigg_monks_south)"]
    next: hub
  silver_fail:
    type: line
    speaker: npc.tigg_innkeeper
    text: "Coin's coin, love. I don't ask."
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.ailsa
participants: [npc.ailsa]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.ailsa
    text: "Don't come in the fold, you'll spook them. What's left of them."
    direction: "Arms crossed at the fold gate, a crook taller than she is."
    next: hub
  hub:
    type: choice
    options:
      - id: seen
        text: "You've seen it, haven't you?"
        next: seen
      - id: monk
        text: "Did anyone come up here besides the beast?"
        next: monk
      - id: help
        text: "I'm here to drive it off. Can I wait by your fire?"
        next: help
      - id: leave
        text: "Keep your head down."
        next: bye
  seen:
    type: line
    speaker: npc.ailsa
    text: "She comes when the light goes. Lands on the south slope, walks right up to the wall, and looks. Then she takes one and goes up to the ledge over the gully."
    next: hub
  monk:
    type: line
    speaker: npc.ailsa
    text: "Monks camped in the beeches. One of them went up the ledge with a crate on his back and she dropped on him like a hawk on a hare. She didn't eat him. She just sniffed the crate."
    effects: ["set_flag(flag.ailsa_trusts)"]
    next: hub
  help:
    type: line
    speaker: npc.ailsa
    text: "Fire's there. Ring the bell if you want her to come. I won't. I'll be in the hut."
    effects: ["set_flag(flag.ailsa_trusts)"]
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.ned_thanks
participants: [npc.ned]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.ned
    text: "You're kind. Them up there aren't. I go up the ledge for the dead ones. She leaves them. I keep the shiny bits."
    direction: "Fishing in his shirt."
    next: hub
  hub:
    type: choice
    options:
      - id: scale
        text: "Show me the shiny bits."
        condition: "not has_item(item.wyvern_scale)"
        next: scale
      - id: ledge
        text: "Where's the ledge, Ned?"
        next: ledge
      - id: leave
        text: "Stay off the ledge for a while."
        next: bye
  scale:
    type: line
    speaker: npc.ned
    text: "Here. It's hers. You have it. You're kind."
    effects: ["give_item(item.wyvern_scale, 1)"]
    next: hub
  ledge:
    type: line
    speaker: npc.ned
    text: "Up the ridge, past the stone piles, goat path down. There's a man up there in a robe. He's been there a long time. He smells."
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.aske
participants: [npc.brother_aske]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.brother_aske
    text: "Peace on you, traveller. Bread for the road? The saint keeps the crossroads, and I keep the saint's door."
    direction: "Soft-spoken, tired, flour on his sleeves."
    next: hub
  hub:
    type: choice
    options:
      - id: pilgrims
        text: "You feed the monks who pass at night."
        next: pilgrims
      - id: lantern
        text: "Why light a lantern on the gibbet?"
        next: lantern
      - id: look
        text: "[Investigate 6] (Watch his feet while he talks.)"
        tag: investigate
        check: {skill: investigate, dc: 6, pass: feather_seen, fail: look_fail}
        once: true
      - id: feather
        text: "[Item: Pale feather] (Hold up the pale feather.) Recognise this, brother?"
        tag: item
        condition: "has_item(item.pale_feather)"
        next: feather_shown
      - id: leave
        text: "Keep your bread."
        next: bye
  pilgrims:
    type: line
    speaker: npc.brother_aske
    text: "Brothers of St. Corwen, walking the old pilgrim road to the southern chapels. The road is dangerous by day now. The saint forgives them walking by night."
    effects: ["set_flag(flag.aske_warned_oak)"]
    next: hub
  lantern:
    type: line
    speaker: npc.brother_aske
    text: "For the souls of the hanged. An old custom. Very old. Is there anything else?"
    direction: "His voice drops."
    effects: ["set_flag(flag.aske_warned_oak)"]
    next: hub
  look_fail:
    type: line
    speaker: npc.brother_aske
    text: "You look tired, friend. Sit, if you like."
    next: hub
  feather_seen:
    type: line
    speaker: player
    text: "There's a pale feather stitched into your sandal strap, brother. Same as the knife-men who tried to kill a prince at Chociebuz."
    next: confront
  feather_shown:
    type: line
    speaker: npc.brother_aske
    text: "A gull's feather. The coast is full of them."
    direction: "He curls his toes back under his robe."
    next: confront
  confront:
    type: choice
    options:
      - id: break
        text: "[Intimidate 6] The Marshal hangs Choir men at the city gate. Your gibbet's closer. Talk."
        tag: intimidate
        check: {skill: intimidate, dc: 6, pass: confess, fail: break_fail}
      - id: queen
        text: "[Clue: Chalice pollen] [Persuade 6] Your abbot is poisoning the Queen through her own cup. Is that what the saint keeps?"
        tag: clue
        condition: "has_clue(clue.chalice_pollen)"
        check: {skill: persuade, dc: 6, pass: confess_weeping, fail: break_fail}
      - id: sway
        text: "[Sway] You're a baker in a robe, Aske. They'll hang you and sing about it. Tell me and I'll tell the Marshal you helped."
        tag: sway
        condition: "perk(perk.kingmaker)"
        next: confess
      - id: fight
        text: "Then you'll answer for it now."
        next: fight
  break_fail:
    type: line
    speaker: npc.brother_aske
    text: "Brothers! The saint's door is breached!"
    direction: "He shouts toward the trapdoor."
    next: fight
  confess:
    type: line
    speaker: npc.brother_aske
    text: "I light the lantern when a courier is due at the Oak. Three nights' walk south-east. He comes on the dark of the night, hooded, and leaves orders in the hollow trunk. That's all. I bake. I light a lantern."
    effects: ["set_flag(flag.aske_exposed)", "set_flag(flag.oak_signal_known)", "clear_flag(flag.aske_warned_oak)", "add_clue(clue.tigg_monks_south)", "add_map_pin(map.hanged_mans_oak)", "play_beat(aske_flees)"]
    next: bye
  confess_weeping:
    type: line
    speaker: npc.brother_aske
    text: "He said she was already dying. He said the crown was rotten. I only light a lantern for the Oak courier. I only feed them. Saint forgive me, I only feed them."
    effects: ["set_flag(flag.aske_exposed)", "set_flag(flag.oak_signal_known)", "clear_flag(flag.aske_warned_oak)", "add_clue(clue.tigg_monks_south)", "add_map_pin(map.hanged_mans_oak)", "play_beat(aske_flees)"]
    next: bye
  fight:
    type: effect
    effects: ["set_checkpoint(village_arrival)", "start_encounter(enc.aske_unmasked)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.aske_open
participants: [npc.brother_aske]
start: preach
nodes:
  preach:
    type: line
    speaker: npc.brother_aske
    text: "The crown is rotten to the root, and at the turning of the year the root is cut. Go home, Tigg. Bar your doors. Pray for the new dawn."
    direction: "Reading from a feather proclamation on the gibbet mound. Two zealots flank him."
    next: hub
  hub:
    type: choice
    options:
      - id: stop
        text: "Get down off that mound."
        next: fight
      - id: leave
        text: "(Leave him to it.)"
        next: bye
  fight:
    type: effect
    effects: ["set_checkpoint(village_arrival)", "start_encounter(enc.tigg_proclaimers)"]
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.tigg_wyvern
zone: zone.tigg_pastures
enemies:
  - {enemy: enemy.wyvern, count: 1, spawn: wyvern_sky, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: before_wyvern
avoidable_by: []
on_won: ["play_beat(wyvern_flees)", "set_flag(flag.wyvern_fought)", "reach_milestone(ms.a2_tigg_resolved)"]
on_yielded: []
on_player_fled: []
```
Design: she starts in the air phase, circling the landing field at 25 m and stooping on the player every 8–10 s. A crossbow weak-point hit on a wing grounds her for 4 s (gdd §6.7). The boulders block stoops. The ground phase uses tail sting (poison) and wing buffets. At 50% HP she flees, which is the win. Non-combat alternative: the tar-beacon ring (zone triggers above), which avoids the fight entirely.

```yaml encounter
id: enc.tigg_wolves
zone: zone.tigg_pastures
enemies:
  - {enemy: enemy.wolf, count: 3, spawn: gully_den, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: before_wyvern
avoidable_by: []
on_won: []
on_yielded: []
on_player_fled: []
```
Design: the wolves feed on the carcass heap and attack when the player enters the gully. A howl calls a fourth wolf once. Throwing fire oil on the carcass heap scatters them (presentation behaviour of the fire hazard; the encounter ends as won when they flee).

```yaml encounter
id: enc.aske_unmasked
zone: zone.tigg_village
enemies:
  - {enemy: enemy.choir_zealot, count: 1, spawn: shrine_cellar_hatch, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 2, spawn: crossroads_east, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: village_arrival
avoidable_by: ["dlg.aske"]
on_won: ["set_flag(flag.aske_exposed)", "set_flag(flag.oak_signal_known)", "add_rep(faction.crown, 3)"]
on_yielded: ["set_flag(flag.aske_exposed)", "set_flag(flag.oak_signal_known)"]
on_player_fled: []
```
Design: Aske himself runs to the cellar and out of the rear hatch (beat `aske_flees`); the two crossbowmen use the hay wains as cover. A yielding crossbowman repeats the Oak lantern signal.

```yaml encounter
id: enc.tigg_proclaimers
zone: zone.tigg_village
enemies:
  - {enemy: enemy.choir_zealot, count: 2, spawn: crossroads_east, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: village_arrival
avoidable_by: []
on_won: ["set_flag(flag.aske_exposed)", "set_flag(flag.oak_signal_known)", "add_rep(faction.crown, 3)"]
on_yielded: ["set_flag(flag.aske_exposed)"]
on_player_fled: []
```

## 7. Items and clues

```yaml item
id: item.field_draught
name: "Field draught"
category: consumable
description: "A stoppered flask of bitter herb-spirit sold on the southern roads. Heals deep wounds fast and tastes of rot."
price: 30
stack_max: 5
equip_slot: null
weapon: null
armor: null
consumable: {effects: ["heal_player(80)"], use_time: 1.0}
readable_text: null
```

```yaml item
id: item.frost_tallow
name: "Frost-tallow"
category: consumable
description: "Mutton tallow cut with pine resin, rubbed into skin and furs against the cold. Halves the Chill rate for one zone visit (gdd §6.9)."
price: 20
stack_max: 5
equip_slot: null
weapon: null
armor: null
consumable: {effects: ["chill_rate_mod(-50)"], use_time: 2.0}
readable_text: null
```

```yaml item
id: item.tar_pot
name: "Pot of barn tar"
category: key
description: "Black pine tar for caulking barns. Burns slow and stinks for a mile."
price: 4
stack_max: 3
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.wyvern_scale
name: "Shed wyvern scale"
category: key
description: "A bronze-green scale the size of a palm, edged sharp as a sickle. Proof of what takes Tigg's sheep."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.scout_note
name: "Choir scout's note"
category: document
description: "A scrap folded into the straw of the crate."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Brother Cellarer. Two eggs, warm, wrapped. For the reagent store at V.A. as asked. The mother followed us to the Stairs' foot. Do not stop on the road. Do not light fires. She hunts by the nose. - S."
```

```yaml clue
id: clue.wyvern_eggs_stolen
theory: theory.choir
title: "The wyvern's stolen clutch"
text: "A Choir scout carried two wyvern eggs south in a straw-lined crate, bound for a 'reagent store at V.A.'. The wyvern is not raiding Tigg. She is tracking her eggs by scent."
supports: []
refutes: []
```

```yaml clue
id: clue.tigg_monks_south
theory: theory.choir
title: "Hooded monks on the south road"
text: "Hooded monks pass Tigg by night carrying heavy crates south, fed by Brother Aske at the crossroads shrine and paid in Abbey-stamped silver."
supports: [anselm]
refutes: []
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.a2_tigg_resolved, type: milestone, xp: 300, desc: "The wyvern has been driven away from Tigg (fight to 50% HP or the tar-beacon ring)."}
  - {id: flag.tigg_mob_resolved, type: bool, desc: "The hanging at the gibbet has been resolved one way or another."}
  - {id: flag.ned_saved, type: bool, desc: "Ned was saved from the rope."}
  - {id: flag.ned_held, type: bool, desc: "Ned is held in the pound pending proof."}
  - {id: flag.ned_hanged, type: bool, desc: "The player walked away and Ned was hanged."}
  - {id: flag.tar_given, type: bool, desc: "Hobb gave leave to take tar from the pitch shed."}
  - {id: flag.tigg_beacon_lore, type: bool, desc: "The player knows tar smoke on the three cairns turns the wyvern."}
  - {id: var.tigg_beacons_lit, type: int, min: 0, max: 3, desc: "Number of pasture cairns lit."}
  - {id: flag.wyvern_driven_by_smoke, type: bool, desc: "The wyvern was turned away without a fight. Read by act3 Wyvern's Roost."}
  - {id: flag.wyvern_fought, type: bool, desc: "The player wounded the wyvern at Tigg. Read by act3 Wyvern's Roost."}
  - {id: flag.tigg_bounty_paid, type: bool, desc: "Hobb paid the 80-crown bounty."}
  - {id: flag.ailsa_trusts, type: bool, desc: "Ailsa lets the player rest at her fire."}
  - {id: flag.aske_exposed, type: bool, desc: "Brother Aske was unmasked as Choir."}
  - {id: flag.aske_warned_oak, type: bool, desc: "The player questioned Aske without exposing him; he signals the Oak (extra courier escort)."}
  - {id: flag.aske_cellar_found, type: bool, desc: "The player found the shrine cellar's rear hatch."}
  - {id: flag.oak_signal_known, type: bool, desc: "The player knows the gibbet-lantern courier signal. Read by a2.02 (the courier walks into the ambush unescorted)."}
reads:
  - ms.act1_complete
  - ms.act2_twist
  - flag.ned_hanged
  - clue.chalice_pollen
  - item.kosk_writ
  - perk.kingmaker
  - rumor.r03_dragon_amell
```

## 9. Quest hooks
The master stage of `quest.main_a2` lives here (order 10) because every Act II section feeds it. It has the three required gate objectives and the seven optional leads (one per Act II main milestone). Section 08 adds orders 20 and 30.

```yaml quest_stages
quest: quest.main_a2
order: 10
stages:
  - id: the_marnadal_road
    journal: "Kosk has sent me south along the Marnadal road. Cintra needs three things before winter: Old Wenna's cure for the Queen, proof that will hang the traitor, and the true fourth verse of the Pact."
    objectives:
      - {id: antidote_line, text: "Get Old Wenna's counter-dose for the Queen, or learn that there is none", condition: "ms(ms.a2_wenna_line_resolved)", optional: false}
      - {id: proof, text: "Find proof of the traitor's guilt", condition: "ded(ded.anselm_treason_proven)", optional: false, xp: 300}
      - {id: true_verse, text: "Recover the true fourth verse", condition: "has_item(item.true_fourth_verse)", optional: false, xp: 300}
      - {id: lead_tigg, text: "Find out what is taking Tigg's sheep", condition: "ms(ms.a2_tigg_resolved)", optional: true}
      - {id: lead_oak, text: "Search Hanged Man's Oak for the Choir's orders", condition: "ms(ms.a2_cipher_taken)", optional: true}
      - {id: lead_jory, text: "Deal with Ninefingers Jory at the crossings", condition: "ms(ms.a2_jory_dealt)", optional: true}
      - {id: lead_field, text: "Walk Marnadal Field on the night of the new moon", condition: "ms(ms.a2_torc_taken)", optional: true}
      - {id: lead_attre, text: "Find out what Duke Raimund's ships carry", condition: "ms(ms.a2_attre_ledger)", optional: true}
      - {id: lead_vel_aram, text: "Break the Choir's muster at Vel Aram", condition: "ms(ms.a2_vel_aram_cleared)", optional: true}
      - {id: lead_wenna, text: "Find the hedge-witch of the mere", condition: "visited(zone.witchs_mere)", optional: true, xp: 50}
    on_complete: []
    next: []
```

## 10. Rumors and event cards (optional)

```yaml rumor
id: rumor.tigg_monks_south
text: "Hooded monks go south past Tigg after dark, bowed under iron crates. The shrine brother lights the gibbet lantern for them."
truth: true
sources: [npc.tigg_innkeeper, npc.ailsa]
available: "ms(ms.act1_complete)"
on_hear: ["add_map_pin(map.hanged_mans_oak)"]
verified_by: "flag(flag.aske_exposed) or has_clue(clue.jory_iron_crates)"
```

## 11. Failure states and branches

```yaml branches
paths:
  - id: wat_saved_now
    when: "Player uses the writ, Persuade 6, Intimidate 6, Bribe 30 or Sway at the gibbet."
    outcome: "Ned lives and hands over a wyvern scale (dlg.ned_thanks)."
    sets: ["set_flag(flag.ned_saved)"]
  - id: ned_held
    when: "Player passes Persuade 4 to delay."
    outcome: "Ned waits in the pound; freed by bringing a wyvern scale or after the wyvern is driven off."
    sets: ["set_flag(flag.ned_held)"]
  - id: ned_hanged
    when: "Player walks away from the mob (confirmed choice)."
    outcome: "Ned dies; variant ned_dead; Hobb is guilty; the ledge and scale are still reachable unaided."
    sets: ["set_flag(flag.ned_hanged)"]
  - id: smoke_ring
    when: "Player lights all three tar cairns before engaging the wyvern."
    outcome: "She veers away without a fight; ms.a2_tigg_resolved; flag.wyvern_driven_by_smoke."
    sets: ["reach_milestone(ms.a2_tigg_resolved)"]
  - id: drive_off_fight
    when: "Player rings the fold bell or enters the landing field and fights her to 50% HP."
    outcome: "She flees south-east; ms.a2_tigg_resolved; flag.wyvern_fought."
    sets: ["reach_milestone(ms.a2_tigg_resolved)"]
  - id: aske_exposed
    when: "Player confronts Aske (Investigate 6 or the feather, then Intimidate 6, chalice clue + Persuade 6, Sway, or a fight)."
    outcome: "flag.oak_signal_known: the Oak courier arrives with no escort in a2.02."
    sets: ["set_flag(flag.aske_exposed)", "set_flag(flag.oak_signal_known)"]
  - id: aske_warned
    when: "Player questions Aske about monks or the lantern and leaves without exposing him."
    outcome: "flag.aske_warned_oak: one extra Choir escort at the Oak."
    sets: ["set_flag(flag.aske_warned_oak)"]
failures:
  - id: player_dies_wyvern
    result: reload_checkpoint
    recover: "Reload before_wyvern at the fold."
  - id: no_tar
    result: soft_fail
    recover: "Tar pots are also sold by Marga (3). The fight path never needs tar."
  - id: aske_check_failed
    result: soft_fail
    recover: "A failed confrontation becomes the enc.aske_unmasked fight, which still exposes him."
guarantees:
  - "ms.a2_tigg_resolved is reachable without any check: ring the fold bell and fight the wyvern to 50% HP (no gate on the bell)."
  - "The tar path needs no check either: tar pots can be bought from Marga without the lore flag."
```

## 12. Open questions
- **Ending an encounter by a beat (A08):** `force_flee(enc.x)` and `end_encounter(enc.x, outcome)` now exist (content-format §J.2). The tar ring still works only before the fight, as designed.
- **Trigger order:** the `ring_complete_*` triggers assume an `interact` trigger fires **after** the interactable's own effects (so `var.tigg_beacons_lit` is already 3). Please confirm in the zone runtime.
- `item.frost_tallow`'s effect (resolved by A08): `chill_rate_mod(-50)` (content-format §J.2). `item.field_draught` and `item.frost_tallow` are declared here.
- `item.tar_pot` is a key item so it can't be sold, but leftover pots stay in the inventory. A `quest` item category would be cleaner.
- Stage 3 rule "Choir encounter groups +1 member" applies to `enc.aske_unmasked` and `enc.tigg_proclaimers` automatically (system rule, not authored here).
