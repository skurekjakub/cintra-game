---
section_id: a3.06
title: "Karak Ostrel"
act: 3
story_ref: "story.md §1 Premise (the Deep-Vaults), §7.3 Assengard (Weeping Gate), §7.6 Karak Ostrel, §10 Silver Mine, §11 rumor 5; gdd §6.7 enemy.iron_warden, §6.13 Maelis/Dravin field abilities, §7.3 row 6 and Karak Ostrel entry"
zones: [zone.ko_weeping_gate, zone.ko_forge_of_echoes, zone.ko_drowned_library, zone.ko_bridge_nine_anvils, zone.ko_lower_halls]
available_when: "ms(ms.a3_departed)"
escalation_stage_required: {min: 4, max: 4}
milestones_set: [ms.a3_ostrel_entered, ms.a3_lock_reached]
milestones_read: [ms.a3_roost_resolved, ms.a3_dravin_joined]
level_band: [10, 11]
---

# Karak Ostrel

## 1. Scene summary
Karak Ostrel is the largest dungeon in the game: a dwarven fortress-forge, frozen and sealed for a century, with its own dwarves still inside, dead at their posts. They locked themselves in with Corvan's weapons to tend the lock. Now the vault's pressure is dropping and its iron-wardens are waking. The player enters by the **Weeping Gate**, a postern beneath the Old Grey Matron, opened with Dravin's Iron-Key. The alternative is the **Lower Halls**, through the Silver Mine breach (A07), where the source of the miners' knocking labours. From there the route runs down through the **Forge of Echoes**: a rune-plate floor that must be walked in the words of the True Oath, a gear-train that must be woken in the right order to drive the bellows and the lift, Choir looters, and alcoves of iron-wardens. Next comes the **Drowned Library**, a flooded rotunda of iron-leaf books that must be drained through three sluices. On its sunken lectern lies the **Rite of Command** (`clue.vault_command_rite`, Lore 7 or Maelis), the only route to the Bitter Bargain. The **Bridge of Nine Anvils** spans the Abyss of Bolts. The Choir retracted it behind them by striking its anvils in the reversed order, and the player must strike the nine anvils in the order of the True Oath under fire from the far gatehouse. Lore pickups along the way tell the story of the Pact: why Corvan needed the weapons, why the dwarves sealed them, how the reversed chant was built into the lock as a war-switch, and what the throne can still be commanded to do. The section ends in the Hall of Mirrors, before the Lock Chamber door (`ms.a3_lock_reached`).

## 2. Progress and escalation
- Stage 4 only. The vault is venting: warm air rises from below, the frozen upper halls drip, and alcove wardens stir. All of this is set dressing for "pressure dropping", not a clock.
- `ms.a3_ostrel_entered` is set when the Weeping Gate opens, or on first entry to the Lower Halls through the breach.
- `ms.a3_lock_reached` is set on entering the Hall of Mirrors (`antechamber`) at the east end of the Bridge.
- **Companions.** Dravin (with the Key) stills iron-wardens and reads warden-runes. Maelis reads dwarven runes (Lore checks pass automatically where marked, and she unlocks the Rite of Command). Either one opens the inner bulkhead from the Lower Halls (gdd §7.3). Rest points at the gate hearth and the Hall of Mirrors let the player change the active companion (see Open questions).
- **Mane-Cleaver** (`item.mane_cleaver`, ×2.0 vs `construct`) and Jasia's warden-breaker (×1.5) make the warden fights much easier. This is automatic through `bonus_vs`.
- The war-band (if Allied) holds the main portal outside. That is why the Choir sends no reinforcements through the upper halls behind the player. The Choir's way in was the **main portal** and the **Engine Road**, a wide dwarven wagon road that runs from the portal to the Lock Chamber's lower west gate. The player never walks it. It is where the finale's reinforcements and Kosk's cavalry come from (a3.07).

### Route map

```
Roost chasm climb ──► WEEPING GATE (ledge → postern → vestibule → tally hall / hearth) ──► spiral stair
                                                                                             │
Silver Mine breach ─► LOWER HALLS (pressure-hammer gallery → warden racks → inner bulkhead) ─► FORGE OF ECHOES
                                                                                             │ (bellows run → lift)
                                                                                     DROWNED LIBRARY (3 sluices → reading hall)
                                                                                             │ (bronze door)
                                                                                     BRIDGE OF NINE ANVILS (3 platforms → gatehouse)
                                                                                             │
                                                                                     HALL OF MIRRORS ──► LOCK CHAMBER (a3.07)
```

## 3. Location layout

### 3.1 The Weeping Gate (`zone.ko_weeping_gate`)
- **Ledge:** the arrival point. A wind-blasted shelf on the Old Grey Matron's flank where the chasm climb tops out (west end) and where the wyvern lands (east end). Frozen sky-bridge chains hang off the edge.
- **Gate face:** a postern 8 m high cut into the cliff. Four carved warden-faces flank it, and meltwater seeps through their eyes and freezes in their beards: the "weeping". Each face holds a rune disc in its mouth: **iron**, **lion**, **night**, and a cracked fourth that is unreadable.
- **Keyhole plinth:** a waist-high iron plinth before the door, with a key socket and three rune rings around it. The rings must show iron, lion and night (the faces' runes) before the Key will turn. Dravin sets them without being asked.
- **Vestibule:** a 40 m vaulted hall with two ranks of dwarven sentries in plate, dead at their posts for a century, frost in their beards. The floor is rune tiles. The sentries all stand on **anvil-rune** tiles, and those are the safe path. Other tiles are pressure plates that discharge (trap) and wake the alcove warden.
- **Warden alcove:** a niche at the vestibule's east end holding a dormant iron-warden, rune core dark. It is the teaching encounter for wardens.
- **Tally hall:** a side chamber whose walls are the gate-warden's tally, one carved notch per nineteen-year cycle, with the monarch's name beside it. Lore.
- **Gate hearth:** the guardroom, whose hearth still takes fuel. Rest point and companion swap.
- **Descent:** a spiral stair down to the Forge of Echoes. Warm air rises up it.
- **Down path:** a goat track from the ledge's east end down the mountain's far side to the Stairs' foot. It is the long way back to the map.

### 3.2 The Forge of Echoes (`zone.ko_forge_of_echoes`)
- **West gallery:** a balcony 12 m above the forge floor where the spiral stair arrives. Dwarven statues with hammers stand along it. A stair goes down at each end.
- **Forge floor:** 60 × 30 m. Four cold furnaces down the middle, rows of anvils, and ore-cart rails. The **Choir tents** are pitched between the anvils: a looting party sorting dwarven weapons into crates.
- **Echo dome:** a domed chamber off the north end where every footstep repeats nine times. Its floor is a 3 × 3 grid of rune plates with a central empty tile: **iron, mountain, lion, watch** (the True Oath's opening words) and **ash, burn, unbind, wake** (the reversed chant's). At the back, a sealed reliquary.
- **Bellows row:** four great bellows along the east wall, linked by bronze shafts to the gear room.
- **Gear room:** behind the bellows. Three gear-trains (small, middle, great), each with a lever, an empty **crank socket**, and the forge-master's plaque.
- **Slag pits:** a sunken area of old slag channels at the south end, still hot in the depths, with steam vents. The missing **gear crank** lies in the lowest channel.
- **Warden alcoves:** twelve along the east wall above the bellows, each holding an iron-warden. Ten are dark. Two (A and B) glow faintly.
- **Lift cage:** an iron cage on chains at the north-east corner, down to the Drowned Library. It runs only while the bellows drive the gears.
- **Inner bulkhead:** a round rune-sealed bulkhead in the south wall, to the Lower Halls.

### 3.3 The Drowned Library (`zone.ko_drowned_library`)
- **Lift bottom:** the cage lands on the upper reading gallery.
- **Upper gallery:** a ring gallery around a flooded rotunda, with iron-leaf books in caged shelves. The water lies 6 m below, black and still. **Sluice wheel 1** is in a wheel-house on this gallery.
- **Mid stacks:** half-flooded shelving aisles, with walkways of floating shelf-lids that dip under the player's weight. A cracked **blight-cask** in the east aisle leaks green into the water (poison hazard). **Sluice wheel 2** stands waist-deep here.
- **Choir scriptorium:** a dry alcove on the mid level where the Choir set up braziers and is burning iron-leaves after copying a few.
- **Low spiral:** a spiral stair to the bottom, flooded until wheel 2 is open. **Sluice wheel 3** is at its foot.
- **Reading hall:** the lowest floor, under 3 m of water until drained. Stone desks with dwarven archivists still seated at them, preserved by cold. On a dais stands the **High King's lectern** with the **command slab**.
- **Drain shaft:** a grated shaft that roars when the sluices open.
- **Bronze door:** at the reading hall's east end, to the Bridge approach.

### 3.4 The Bridge of Nine Anvils (`zone.ko_bridge_nine_anvils`)
- **Approach hall:** a broad hall ending at the **Abyss of Bolts**, a shaft 200 m deep over the deep vaults. Far below, the vault bulkheads steam.
- **West abutment (platform 0):** the bridge's west end, with anvils **iron**, **mountain** and **lion** set in scrambled order, each with a chained rune-mallet.
- **Section A:** a retractable bridge-plate to **platform 1**, a pillar-top with anvils **blood**, **watch** and **bolt**.
- **Section B:** to **platform 2**, with anvils **bar**, **night** and **light**.
- **Section C:** to the **east gatehouse**, a dwarven gatehouse with arrow slits facing the bridge, a winch, and two **Lock Guard** wardens flanking its inner door.
- **Hall of Mirrors (antechamber):** beyond the gatehouse. Polished bronze mirrors angled up into shafts in the ceiling. The last rest point. The great door to the Lock Chamber.

All sections start retracted. Each platform's three anvils must be struck in Oath order (1–3, 4–6, 7–9) to extend the next section. The anvils on a platform stand 4–6 m apart, so the player crosses open stone under fire from the gatehouse between strikes. Cover on each platform: the anvil blocks themselves and a fallen statue.

### 3.5 The Lower Halls (`zone.ko_lower_halls`) — alternative entry
- **Mine breach:** where the Silver Mine's deepest gallery broke into dressed dwarven stone. Rubble, miners' ropes, a Strept lamp.
- **Pressure-hammer gallery:** a long gallery where six great **pressure-hammers** rise and fall in rhythm against the vault's outer bulkhead, labouring to hold pressure. This is the knocking the miners hear. Crossing it means timing the hammers (crush hazard). The **Hammer-Tender**, an iron-warden, still walks the gallery oiling them.
- **Warden racks:** a barracks with eight warden racks. Two are occupied and wake when the player passes.
- **Miners' shrine:** a dwarven miners' shrine with a log-book. Lore.
- **Inner bulkhead:** a rune-sealed bulkhead into the Forge of Echoes' south wall. Dravin or Maelis is needed (gdd §7.3).

```yaml zone
id: zone.ko_weeping_gate
name: "Karak Ostrel: The Weeping Gate"
kind: dungeon
map_node: map.stairs_foot
time_of_day: night
cold_rate: 2
disguise_tag: null
music: ostrel_deep
areas:
  - {id: ledge, description: "Wind-blasted shelf on the mountain's flank; frozen sky-bridge chains; the chasm stair at the west end, a landing space at the east."}
  - {id: gate_face, description: "8 m postern; four carved warden-faces weeping meltwater frozen in their beards; rune discs in their mouths (iron, lion, night, cracked)."}
  - {id: keyhole_plinth, description: "Iron plinth with a key socket and three rune rings."}
  - {id: vestibule, description: "40 m vaulted hall; two ranks of dead dwarven sentries in plate; rune-tile floor; safe tiles bear the anvil-rune."}
  - {id: vestibule_traps, description: "The non-anvil tiles of the vestibule floor (pressure plates)."}
  - {id: warden_alcove, description: "Niche at the east end; a dormant iron-warden, rune core dark."}
  - {id: tally_hall, description: "Side chamber: the warden's tally carved on every wall, one notch per nineteen winters, a monarch's name beside each."}
  - {id: gate_hearth, description: "Guardroom with a hearth that still takes fuel; benches; a dwarven kettle."}
  - {id: descent, description: "Spiral stair down to the Forge; warm air rising."}
  - {id: down_path, description: "Goat track down the mountain's far side from the ledge's east end."}
spawns:
  - {id: chasm_top, area: ledge, default: true}
  - {id: wyvern_landing, area: ledge}
  - {id: vestibule_start, area: vestibule}
  - {id: warden_alcove, area: warden_alcove}
  - {id: descent_top, area: descent}
exits:
  - id: to_forge
    area: descent
    to_zone: zone.ko_forge_of_echoes
    to_spawn: gate_stair
    condition: "flag(flag.ko_weeping_gate_open)"
    effects: []
  - id: long_way_down
    area: down_path
    to_zone: zone.stairs_switchbacks
    to_spawn: stairs_foot_camp
    condition: "true"
    effects: []
  - id: back_down_chasm
    area: ledge
    to_zone: zone.roost_chasm_climb
    to_spawn: chasm_top_return
    condition: "true"
    effects: []
interactables:
  - id: ring_iron
    area: keyhole_plinth
    kind: lever
    label: "Turn the outer ring to the iron rune"
    condition: "not flag(flag.ko_gate_rings_set) and not flag(flag.ko_ring_iron)"
    check: null
    once: true
    effects: ["set_flag(flag.ko_ring_iron)", "play_beat(ring_click)"]
    fail_effects: []
  - id: ring_lion
    area: keyhole_plinth
    kind: lever
    label: "Turn the middle ring to the lion rune"
    condition: "not flag(flag.ko_gate_rings_set) and not flag(flag.ko_ring_lion)"
    check: null
    once: true
    effects: ["set_flag(flag.ko_ring_lion)", "play_beat(ring_click)"]
    fail_effects: []
  - id: ring_night
    area: keyhole_plinth
    kind: lever
    label: "Turn the inner ring to the night rune"
    condition: "not flag(flag.ko_gate_rings_set) and not flag(flag.ko_ring_night)"
    check: null
    once: true
    effects: ["set_flag(flag.ko_ring_night)", "play_beat(ring_click)"]
    fail_effects: []
  - id: dravin_rings
    area: keyhole_plinth
    kind: lever
    label: "Let Dravin set the rings"
    condition: "in_party(companion.dravin) and not flag(flag.ko_gate_rings_set)"
    check: null
    once: true
    effects: ["set_flag(flag.ko_gate_rings_set)", "play_beat(dravin_sets_rings)"]
    fail_effects: []
  - id: turn_key
    area: keyhole_plinth
    kind: door
    label: "Turn the Iron-Key"
    condition: "has_item(item.iron_key) and (flag(flag.ko_gate_rings_set) or (flag(flag.ko_ring_iron) and flag(flag.ko_ring_lion) and flag(flag.ko_ring_night))) and not flag(flag.ko_weeping_gate_open)"
    check: null
    once: true
    effects: ["set_flag(flag.ko_gate_rings_set)", "set_flag(flag.ko_weeping_gate_open)", "play_beat(gate_opens)", "set_checkpoint(gate_inside)", "reach_milestone(ms.a3_ostrel_entered)", "verify_rumor(rumor.r05_dwarves_inside)"]
    fail_effects: []
  - id: no_key
    area: keyhole_plinth
    kind: search
    label: "Examine the lock"
    condition: "not has_item(item.iron_key)"
    check: null
    once: false
    effects: ["play_beat(no_key)"]
    fail_effects: []
  - id: faces
    area: gate_face
    kind: search
    label: "Look at the weeping faces"
    condition: "true"
    check: null
    once: true
    effects: ["play_beat(faces_runes)"]
    fail_effects: []
  - id: sentry
    area: vestibule
    kind: search
    label: "Search the sentry at the head of the rank"
    condition: "flag(flag.ko_weeping_gate_open)"
    check: null
    once: true
    effects: ["give_item(item.ko_lore_last_muster, 1)", "add_clue(clue.ko_dwarves_sealed_in)"]
    fail_effects: []
  - id: tally
    area: tally_hall
    kind: readable
    label: "Read the tally"
    condition: "flag(flag.ko_weeping_gate_open)"
    check: null
    once: true
    effects: ["give_item(item.ko_lore_warden_tally, 1)"]
    fail_effects: []
  - id: still_gate_warden
    area: warden_alcove
    kind: lever
    label: "Dravin: speak the warden-word, Key raised"
    condition: "has_item(item.iron_key) and in_party(companion.dravin) and not flag(flag.ko_gate_warden_resolved)"
    check: null
    once: true
    effects: ["set_flag(flag.ko_gate_warden_resolved)", "set_flag(flag.ko_gate_warden_stilled)", "play_beat(warden_stilled)", "add_xp(150)"]
    fail_effects: []
  - id: read_gate_warden
    area: warden_alcove
    kind: lever
    label: "Maelis: read the stand-down rune on its core"
    condition: "in_party(companion.maelis) and not flag(flag.ko_gate_warden_resolved)"
    check: {skill: lore, dc: 6}
    once: true
    effects: ["set_flag(flag.ko_gate_warden_resolved)", "set_flag(flag.ko_gate_warden_stilled)", "play_beat(warden_stilled)", "add_xp(150)"]
    fail_effects: ["play_beat(rune_overload)"]
  - id: hearth
    area: gate_hearth
    kind: rest
    label: "Light the guardroom hearth"
    condition: "flag(flag.ko_weeping_gate_open)"
    check: null
    once: false
    effects: ["heal_player(full)", "set_checkpoint(gate_hearth)"]
    fail_effects: []
triggers:
  - id: plate_trap
    area: vestibule_traps
    on: enter
    source: null
    condition: "not flag(flag.ko_gate_warden_resolved)"
    once: false
    effects: ["damage_player(20)", "play_beat(rune_overload)"]
  - id: warden_wakes
    area: vestibule_traps
    on: beat_done
    source: rune_overload
    condition: "not flag(flag.ko_gate_warden_resolved)"
    once: true
    effects: ["set_flag(flag.ko_gate_warden_resolved)", "play_beat(warden_wakes)", "start_encounter(enc.ko_gate_warden)"]
  - id: dravin_reads_floor
    area: vestibule
    on: enter
    source: null
    condition: "in_party(companion.dravin) or in_party(companion.maelis)"
    once: true
    effects: ["play_beat(companion_warns_tiles)"]
hazards:
  - {id: ledge_drop, area: ledge, kind: collapse, params: {fall: lethal}}
  - {id: rune_tiles, area: vestibule_traps, kind: trap, params: {damage: 20, discharge: "rune overload, 2 m"}}
checkpoints:
  - {id: gate_ledge, area: ledge}
  - {id: gate_inside, area: vestibule}
  - {id: gate_hearth, area: gate_hearth}
beats:
  - {id: ring_click, description: "The ring turns with a deep, oiled click that the player feels through the boots."}
  - {id: dravin_sets_rings, description: "Dravin spins the three rings without looking (iron, lion, night) and mutters a dwarven word to each."}
  - {id: gate_opens, description: "The Key goes in to the bow. A sound like a mountain clearing its throat. The postern swings inward on a hinge-pin as thick as a tree, and a breath of warm, stale, iron-tasting air rolls out over the snow."}
  - {id: no_key, description: "The socket is shaped for a key as long as a forearm. 'No key, no door,' the player thinks. Dravin has it, in Assengard."}
  - {id: faces_runes, description: "Each warden-face holds a disc in its mouth: iron, lion, night. The fourth is cracked across. The ice-beards are tinted rust-red."}
  - {id: companion_warns_tiles, description: "Dravin (or Maelis): 'Step where the dead stand. Anvil-marks. Nothing else.'"}
  - {id: rune_overload, description: "A tile flares blue-white under the player's boot; a crack of discharge; every dead sentry in the hall rattles in its plate."}
  - {id: warden_wakes, description: "In the east alcove, a rune core kindles orange. Iron joints shed a century of frost in a shower."}
  - {id: warden_stilled, description: "The rune core flickers, dims, and the warden settles back into its alcove with a sigh of cooling iron."}
npcs: []
encounters: [enc.ko_gate_warden]
loot: []
variants:
  - id: gate_open
    when: "flag(flag.ko_weeping_gate_open)"
    description: "Postern open; warm air steaming out over the ledge."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: [ring_iron, ring_lion, ring_night, dravin_rings, no_key]
  - id: gate_warden_done
    when: "flag(flag.ko_gate_warden_resolved)"
    description: "The alcove warden is still, or a wreck."
    npcs_absent: []
    encounters_disabled: [enc.ko_gate_warden]
    interactables_disabled: [still_gate_warden, read_gate_warden]
```

```yaml zone
id: zone.ko_forge_of_echoes
name: "Karak Ostrel: The Forge of Echoes"
kind: dungeon
map_node: map.stairs_foot
time_of_day: night
cold_rate: 1
disguise_tag: choir
music: forge_echo
areas:
  - {id: west_gallery, description: "Balcony 12 m above the floor; statues with hammers; stairs down at each end."}
  - {id: forge_floor, description: "60 x 30 m; four cold furnaces; rows of anvils; ore-cart rails; Choir tents among the anvils."}
  - {id: choir_tents, description: "Three tents, crates of dwarven blades and axe-heads, a brazier, a pot of stew."}
  - {id: echo_dome, description: "Domed chamber off the north end; footsteps repeat nine times; reliquary at the back."}
  - {id: plate_iron, description: "Echo dome rune plate: iron."}
  - {id: plate_mountain, description: "Echo dome rune plate: mountain."}
  - {id: plate_lion, description: "Echo dome rune plate: lion."}
  - {id: plate_watch, description: "Echo dome rune plate: watch."}
  - {id: plate_ash, description: "Echo dome rune plate: ash."}
  - {id: plate_burn, description: "Echo dome rune plate: burn."}
  - {id: plate_unbind, description: "Echo dome rune plate: unbind."}
  - {id: plate_wake, description: "Echo dome rune plate: wake."}
  - {id: bellows_row, description: "Four barn-sized bellows along the east wall, bronze shafts to the gear room."}
  - {id: gear_room, description: "Three gear-trains (small, middle, great) with levers; an empty crank socket; the forge-master's plaque."}
  - {id: slag_pits, description: "Sunken slag channels, still hot in the depths; steam vents; ore-cart wreckage; the crank in the lowest channel."}
  - {id: warden_alcoves, description: "Twelve alcoves above the bellows; ten dark, two (A and B) faintly glowing."}
  - {id: lift_cage, description: "Iron cage lift on chains at the north-east corner, down to the library."}
  - {id: inner_bulkhead, description: "Round rune-sealed bulkhead in the south wall, to the Lower Halls."}
spawns:
  - {id: gate_stair, area: west_gallery, default: true}
  - {id: choir_tents, area: choir_tents}
  - {id: alcove_a, area: warden_alcoves}
  - {id: alcove_b, area: warden_alcoves}
  - {id: bulkhead_inside, area: inner_bulkhead}
  - {id: lift_top, area: lift_cage}
exits:
  - id: up_to_gate
    area: west_gallery
    to_zone: zone.ko_weeping_gate
    to_spawn: descent_top
    condition: "flag(flag.ko_weeping_gate_open)"
    effects: []
  - id: lift_down
    area: lift_cage
    to_zone: zone.ko_drowned_library
    to_spawn: lift_bottom
    condition: "flag(flag.ko_bellows_running)"
    effects: []
  - id: bulkhead_to_lower
    area: inner_bulkhead
    to_zone: zone.ko_lower_halls
    to_spawn: bulkhead_outside
    condition: "flag(flag.ko_bulkhead_open)"
    effects: []
interactables:
  - id: plaque
    area: gear_room
    kind: readable
    label: "Read the forge-master's plaque"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.ko_lore_forge_plaque, 1)"]
    fail_effects: []
  - id: crank
    area: slag_pits
    kind: pickup
    label: "Pull the crank out of the slag"
    condition: "not has_item(item.ko_gear_crank) and not flag(flag.ko_crank_seated)"
    check: null
    once: true
    effects: ["give_item(item.ko_gear_crank, 1)", "play_beat(crank_found)"]
    fail_effects: []
  - id: crank_socket_empty
    area: gear_room
    kind: search
    label: "Look at the empty socket"
    condition: "not has_item(item.ko_gear_crank) and not flag(flag.ko_crank_seated)"
    check: null
    once: false
    effects: ["play_beat(socket_empty)"]
    fail_effects: []
  - id: crank_socket
    area: gear_room
    kind: lever
    label: "Seat the crank"
    condition: "has_item(item.ko_gear_crank) and not flag(flag.ko_crank_seated)"
    check: null
    once: true
    effects: ["take_item(item.ko_gear_crank, 1)", "set_flag(flag.ko_crank_seated)", "play_beat(crank_seated)"]
    fail_effects: []
  - id: lever_small
    area: gear_room
    kind: lever
    label: "Engage the small gear-train"
    condition: "flag(flag.ko_crank_seated) and var(var.ko_gear_train) == 0"
    check: null
    once: false
    effects: ["add_var(var.ko_gear_train, 1)", "play_beat(gear_engage)"]
    fail_effects: []
  - id: lever_middle
    area: gear_room
    kind: lever
    label: "Engage the middle gear-train"
    condition: "flag(flag.ko_crank_seated) and var(var.ko_gear_train) == 1"
    check: null
    once: false
    effects: ["add_var(var.ko_gear_train, 1)", "play_beat(gear_engage)"]
    fail_effects: []
  - id: lever_middle_early
    area: gear_room
    kind: lever
    label: "Engage the middle gear-train"
    condition: "flag(flag.ko_crank_seated) and var(var.ko_gear_train) == 0"
    check: null
    once: false
    effects: ["damage_player(25)", "play_beat(steam_burst)"]
    fail_effects: []
  - id: lever_great
    area: gear_room
    kind: lever
    label: "Engage the great gear-train"
    condition: "flag(flag.ko_crank_seated) and var(var.ko_gear_train) == 2"
    check: null
    once: true
    effects: ["add_var(var.ko_gear_train, 1)", "set_flag(flag.ko_bellows_running)", "play_beat(bellows_roar)", "set_checkpoint(bellows_on)"]
    fail_effects: []
  - id: lever_great_early
    area: gear_room
    kind: lever
    label: "Engage the great gear-train"
    condition: "flag(flag.ko_crank_seated) and var(var.ko_gear_train) <= 1"
    check: null
    once: false
    effects: ["set_var(var.ko_gear_train, 0)", "damage_player(35)", "play_beat(steam_burst)"]
    fail_effects: []
  - id: reliquary
    area: echo_dome
    kind: container
    label: "Open the reliquary"
    condition: "flag(flag.ko_echo_solved)"
    check: null
    once: true
    effects: ["give_item(item.ko_lore_ash_sworn, 1)", "add_clue(clue.ko_pact_origin)"]
    fail_effects: []
  - id: still_alcove_a
    area: warden_alcoves
    kind: lever
    label: "Dravin: still the warden in alcove A"
    condition: "has_item(item.iron_key) and in_party(companion.dravin) and not flag(flag.ko_alcove_a_stilled) and not flag(flag.ko_forge_wardens_resolved)"
    check: null
    once: true
    effects: ["set_flag(flag.ko_alcove_a_stilled)", "play_beat(warden_stilled)", "add_xp(150)"]
    fail_effects: []
  - id: still_alcove_b
    area: warden_alcoves
    kind: lever
    label: "Dravin: still the warden in alcove B"
    condition: "has_item(item.iron_key) and in_party(companion.dravin) and not flag(flag.ko_alcove_b_stilled) and not flag(flag.ko_forge_wardens_resolved)"
    check: null
    once: true
    effects: ["set_flag(flag.ko_alcove_b_stilled)", "play_beat(warden_stilled)", "add_xp(150)"]
    fail_effects: []
  - id: read_alcove_a
    area: warden_alcoves
    kind: lever
    label: "Maelis: read alcove A's stand-down rune"
    condition: "in_party(companion.maelis) and not flag(flag.ko_alcove_a_stilled) and not flag(flag.ko_forge_wardens_resolved)"
    check: {skill: lore, dc: 6}
    once: true
    effects: ["set_flag(flag.ko_alcove_a_stilled)", "play_beat(warden_stilled)", "add_xp(150)"]
    fail_effects: ["damage_player(20)"]
  - id: read_alcove_b
    area: warden_alcoves
    kind: lever
    label: "Maelis: read alcove B's stand-down rune"
    condition: "in_party(companion.maelis) and not flag(flag.ko_alcove_b_stilled) and not flag(flag.ko_forge_wardens_resolved)"
    check: {skill: lore, dc: 6}
    once: true
    effects: ["set_flag(flag.ko_alcove_b_stilled)", "play_beat(warden_stilled)", "add_xp(150)"]
    fail_effects: ["damage_player(20)"]
  - id: bulkhead_open
    area: inner_bulkhead
    kind: lever
    label: "Open the rune bulkhead"
    condition: "(in_party(companion.dravin) or in_party(companion.maelis)) and not flag(flag.ko_bulkhead_open)"
    check: null
    once: true
    effects: ["set_flag(flag.ko_bulkhead_open)", "play_beat(bulkhead_turns)"]
    fail_effects: []
  - id: choir_crates
    area: choir_tents
    kind: container
    label: "Go through the Choir's crates"
    condition: "flag(flag.ko_forge_choir_resolved)"
    check: null
    once: true
    effects: []
    fail_effects: []
  - id: furnace_warm
    area: forge_floor
    kind: rest
    label: "Rest by the lit furnace"
    condition: "flag(flag.ko_bellows_running)"
    check: null
    once: false
    effects: ["heal_player(full)", "set_checkpoint(bellows_on)"]
    fail_effects: []
triggers:
  - id: choir_spot
    area: forge_floor
    on: enter
    source: null
    condition: "not flag(flag.ko_forge_choir_resolved) and not has_item(item.choir_robe)"
    once: true
    effects: ["set_checkpoint(forge_gallery)", "play_beat(looters_turn)", "start_encounter(enc.ko_forge_choir)"]
  - id: echo_iron
    area: plate_iron
    on: enter
    source: null
    condition: "var(var.ko_echo_step) == 0"
    once: false
    effects: ["add_var(var.ko_echo_step, 1)", "play_beat(echo_true)"]
  - id: echo_mountain
    area: plate_mountain
    on: enter
    source: null
    condition: "var(var.ko_echo_step) == 1"
    once: false
    effects: ["add_var(var.ko_echo_step, 1)", "play_beat(echo_true)"]
  - id: echo_mountain_wrong
    area: plate_mountain
    on: enter
    source: null
    condition: "var(var.ko_echo_step) == 0"
    once: false
    effects: ["damage_player(30)", "play_beat(rune_overload)"]
  - id: echo_lion
    area: plate_lion
    on: enter
    source: null
    condition: "var(var.ko_echo_step) == 2"
    once: false
    effects: ["add_var(var.ko_echo_step, 1)", "play_beat(echo_true)"]
  - id: echo_lion_wrong
    area: plate_lion
    on: enter
    source: null
    condition: "var(var.ko_echo_step) <= 1"
    once: false
    effects: ["set_var(var.ko_echo_step, 0)", "damage_player(30)", "play_beat(rune_overload)"]
  - id: echo_watch
    area: plate_watch
    on: enter
    source: null
    condition: "var(var.ko_echo_step) == 3"
    once: false
    effects: ["add_var(var.ko_echo_step, 1)", "set_flag(flag.ko_echo_solved)", "play_beat(reliquary_opens)", "add_xp(200)"]
  - id: echo_watch_wrong
    area: plate_watch
    on: enter
    source: null
    condition: "var(var.ko_echo_step) <= 2"
    once: false
    effects: ["set_var(var.ko_echo_step, 0)", "damage_player(30)", "play_beat(rune_overload)"]
  - id: echo_ash
    area: plate_ash
    on: enter
    source: null
    condition: "var(var.ko_echo_step) < 4"
    once: false
    effects: ["set_var(var.ko_echo_step, 0)", "damage_player(30)", "play_beat(rune_overload)"]
  - id: echo_burn
    area: plate_burn
    on: enter
    source: null
    condition: "var(var.ko_echo_step) < 4"
    once: false
    effects: ["set_var(var.ko_echo_step, 0)", "damage_player(30)", "play_beat(rune_overload)"]
  - id: echo_unbind
    area: plate_unbind
    on: enter
    source: null
    condition: "var(var.ko_echo_step) < 4"
    once: false
    effects: ["set_var(var.ko_echo_step, 0)", "damage_player(30)", "play_beat(rune_overload)"]
  - id: echo_wake
    area: plate_wake
    on: enter
    source: null
    condition: "var(var.ko_echo_step) < 4"
    once: false
    effects: ["set_var(var.ko_echo_step, 0)", "damage_player(30)", "play_beat(rune_overload)"]
  - id: wardens_wake_echo
    area: echo_dome
    on: beat_done
    source: rune_overload
    condition: "not flag(flag.ko_forge_wardens_resolved) and not flag(flag.ko_alcove_a_stilled) and not flag(flag.ko_alcove_b_stilled)"
    once: true
    effects: ["set_flag(flag.ko_forge_wardens_resolved)", "play_beat(alcoves_wake)", "start_encounter(enc.ko_forge_wardens)"]
  - id: wardens_wake_bellows_two
    area: gear_room
    on: beat_done
    source: bellows_roar
    condition: "not flag(flag.ko_forge_wardens_resolved) and not flag(flag.ko_alcove_a_stilled) and not flag(flag.ko_alcove_b_stilled)"
    once: true
    effects: ["set_flag(flag.ko_forge_wardens_resolved)", "play_beat(alcoves_wake)", "start_encounter(enc.ko_forge_wardens)"]
  - id: wardens_wake_bellows_one
    area: gear_room
    on: beat_done
    source: bellows_roar
    condition: "not flag(flag.ko_forge_wardens_resolved) and ((flag(flag.ko_alcove_a_stilled) and not flag(flag.ko_alcove_b_stilled)) or (flag(flag.ko_alcove_b_stilled) and not flag(flag.ko_alcove_a_stilled)))"
    once: true
    effects: ["set_flag(flag.ko_forge_wardens_resolved)", "play_beat(alcoves_wake)", "start_encounter(enc.ko_forge_warden_single)"]
  - id: first_visit_lore
    area: west_gallery
    on: enter
    source: null
    condition: "true"
    once: true
    effects: ["verify_rumor(rumor.r05_dwarves_inside)", "play_beat(forge_reveal)"]
hazards:
  - {id: slag_heat, area: slag_pits, kind: fire, params: {damage_per_second: 8, note: "Glowing channels in the lowest pit; the crank sits on a cooled crust 1 m from one."}}
  - {id: slag_steam, area: slag_pits, kind: steam, params: {damage_per_second: 12, cycle_on_s: 3, cycle_off_s: 5, vents: 4}}
  - {id: echo_plates, area: echo_dome, kind: trap, params: {damage: 30, note: "Wrong plate: rune overload discharge; see echo triggers."}}
checkpoints:
  - {id: forge_gallery, area: west_gallery}
  - {id: bellows_on, area: forge_floor}
beats:
  - {id: forge_reveal, description: "From the gallery: the whole Forge, cold and silver with frost, four furnaces like sleeping kilns, and at the far end, firelight and grey tents. Every footstep comes back nine times from the dome."}
  - {id: looters_turn, description: "A Choir looter straightens with a dwarven axe-head in his hands and shouts. The echo makes it a crowd."}
  - {id: crank_found, description: "A bronze crank as long as a leg, its grip worn to the shape of dwarven hands, set in slag like a sword in a stone."}
  - {id: socket_empty, description: "An empty square socket. Scratches round it: someone wrenched the crank out and threw it."}
  - {id: crank_seated, description: "The crank slides home. The three gear-trains shiver."}
  - {id: gear_engage, description: "A train of gears engages with a sound like a cathedral door. The indicator needle on the plaque swings one notch."}
  - {id: steam_burst, description: "The trains bind; a bellows-seam bursts and steam floods the gear room. The levers spring back."}
  - {id: bellows_roar, description: "The great train turns. Four bellows draw a breath you can feel in your chest and blow. The furnaces roar alight one after another down the hall. The lift chains jerk taut."}
  - {id: alcoves_wake, description: "Along the east wall, two rune cores kindle orange. Iron men step down out of their alcoves, frost falling off them like dust."}
  - {id: warden_stilled, description: "The rune core flickers, dims, and the warden settles back with a sigh of cooling iron."}
  - {id: echo_true, description: "The plate rings, and the dome rings back the note nine times, falling, like a bell telling an hour."}
  - {id: rune_overload, description: "The plate flares blue-white and discharges up the player's legs; the dome screams it back."}
  - {id: reliquary_opens, description: "The fourth true note. The echoes do not fall this time. They hold. The reliquary's door slides down into the floor."}
  - {id: bulkhead_turns, description: "Dravin's palm (or Maelis's whispered reading) on the rune-seal; the bulkhead's spokes turn and it rolls aside into the wall."}
npcs: []
encounters: [enc.ko_forge_choir, enc.ko_forge_wardens, enc.ko_forge_warden_single]
loot:
  - {container: choir_crates, items: [{item: item.fire_oil, count: 2}, {item: item.field_draught, count: 2}, {item: item.crossbow_bolt, count: 15}, {item: item.pale_feather, count: 1}], condition: "true"}
  - {container: reliquary, items: [{item: item.echo_hammer, count: 1}], condition: "true"}
variants:
  - id: furnaces_lit
    when: "flag(flag.ko_bellows_running)"
    description: "Furnaces roaring; frost melting off everything; the hall full of moving light and the bellows' slow breathing."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: [lever_small, lever_middle, lever_middle_early, lever_great_early]
  - id: looters_gone
    when: "flag(flag.ko_forge_choir_resolved)"
    description: "Tents trampled; the stew pot overturned."
    npcs_absent: []
    encounters_disabled: [enc.ko_forge_choir]
    interactables_disabled: []
  - id: wardens_done
    when: "flag(flag.ko_forge_wardens_resolved) or (flag(flag.ko_alcove_a_stilled) and flag(flag.ko_alcove_b_stilled))"
    description: "Alcoves A and B dark, or two iron wrecks on the floor."
    npcs_absent: []
    encounters_disabled: [enc.ko_forge_wardens, enc.ko_forge_warden_single]
    interactables_disabled: [still_alcove_a, still_alcove_b, read_alcove_a, read_alcove_b]
```

**Disguise in the Forge.** `disguise_tag: choir`: a player wearing the Choir robe is "permitted". The looters do not engage on sight (the `choir_spot` trigger tests `has_item(item.choir_robe)` as a stand-in for "wearing"). They can still be fought, and stealth takedowns among the anvils work as in gdd §6.5. If combat breaks out anywhere in the hall, the presentation hook should start `enc.ko_forge_choir`.

```yaml zone
id: zone.ko_drowned_library
name: "Karak Ostrel: The Drowned Library"
kind: dungeon
map_node: map.stairs_foot
time_of_day: night
cold_rate: 3
disguise_tag: choir
music: library_drip
areas:
  - {id: lift_bottom, description: "The cage lands on the upper reading gallery."}
  - {id: upper_gallery, description: "Ring gallery around a flooded rotunda; caged shelves of iron-leaf books; black water 6 m below."}
  - {id: sluice_upper, description: "Wheel-house on the upper gallery: sluice wheel 1."}
  - {id: mid_stacks, description: "Half-flooded aisles; floating shelf-lid walkways that dip; a cracked blight-cask staining the east aisle green."}
  - {id: blight_aisle, description: "East aisle of the mid stacks: green water, dead fish, a cask split along its staves."}
  - {id: sluice_mid, description: "Sluice wheel 2, waist-deep in the mid stacks."}
  - {id: choir_scriptorium, description: "Dry alcove on the mid level; braziers; torn iron-leaf foils; ink; two copying desks."}
  - {id: low_spiral, description: "Spiral stair to the bottom, flooded until wheel 2 opens; sluice wheel 3 at its foot."}
  - {id: reading_hall, description: "Lowest floor; stone desks with dwarven archivists still seated, preserved by cold; the High King's lectern on a dais."}
  - {id: drain_shaft, description: "Grated shaft that roars when the sluices open."}
  - {id: bronze_door, description: "East end of the reading hall: a bronze door onto the Bridge approach."}
spawns:
  - {id: lift_bottom, area: lift_bottom, default: true}
  - {id: choir_scribes, area: choir_scriptorium}
  - {id: library_exit_inside, area: bronze_door}
exits:
  - id: lift_up
    area: lift_bottom
    to_zone: zone.ko_forge_of_echoes
    to_spawn: lift_top
    condition: "true"
    effects: []
  - id: to_bridge
    area: bronze_door
    to_zone: zone.ko_bridge_nine_anvils
    to_spawn: approach_hall
    condition: "flag(flag.ko_library_drained)"
    effects: []
interactables:
  - id: wheel_1
    area: sluice_upper
    kind: lever
    label: "Turn sluice wheel 1"
    condition: "var(var.ko_sluice) == 0"
    check: null
    once: true
    effects: ["add_var(var.ko_sluice, 1)", "play_beat(sluice_one)"]
    fail_effects: []
  - id: wheel_2
    area: sluice_mid
    kind: lever
    label: "Turn sluice wheel 2"
    condition: "var(var.ko_sluice) == 1"
    check: null
    once: true
    effects: ["add_var(var.ko_sluice, 1)", "play_beat(sluice_two)"]
    fail_effects: []
  - id: wheel_2_jammed
    area: sluice_mid
    kind: search
    label: "Try sluice wheel 2"
    condition: "var(var.ko_sluice) == 0"
    check: null
    once: false
    effects: ["play_beat(wheel_jammed)"]
    fail_effects: []
  - id: wheel_3
    area: low_spiral
    kind: lever
    label: "Turn sluice wheel 3"
    condition: "var(var.ko_sluice) == 2"
    check: null
    once: true
    effects: ["add_var(var.ko_sluice, 1)", "set_flag(flag.ko_library_drained)", "play_beat(library_drains)", "set_checkpoint(library_drained)", "add_xp(150)"]
    fail_effects: []
  - id: pact_leaf
    area: upper_gallery
    kind: readable
    label: "Take the iron-leaf from the open cage"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.ko_lore_pact_leaf, 1)"]
    fail_effects: []
  - id: corvan_letter
    area: choir_scriptorium
    kind: readable
    label: "Read the leaf on the copying desk"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.ko_lore_corvan_letter, 1)"]
    fail_effects: []
  - id: reversal_note
    area: reading_hall
    kind: readable
    label: "Read the archivist's open book"
    condition: "flag(flag.ko_library_drained)"
    check: null
    once: true
    effects: ["give_item(item.ko_lore_reversal_note, 1)", "add_clue(clue.ko_reversal_design)"]
    fail_effects: []
  - id: command_slab_maelis
    area: reading_hall
    kind: readable
    label: "Maelis: read the slab on the High King's lectern"
    condition: "flag(flag.ko_library_drained) and in_party(companion.maelis) and not has_clue(clue.vault_command_rite)"
    check: null
    once: true
    effects: ["add_clue(clue.vault_command_rite)", "give_item(item.ko_lore_command_rite, 1)", "play_beat(slab_read)"]
    fail_effects: []
  - id: command_slab
    area: reading_hall
    kind: readable
    label: "Read the slab on the High King's lectern [Lore 7]"
    condition: "flag(flag.ko_library_drained) and not in_party(companion.maelis) and not has_clue(clue.vault_command_rite)"
    check: {skill: lore, dc: 7}
    once: false
    effects: ["add_clue(clue.vault_command_rite)", "give_item(item.ko_lore_command_rite, 1)", "play_beat(slab_read)"]
    fail_effects: ["play_beat(slab_unreadable)"]
triggers:
  - id: scribes_spot
    area: choir_scriptorium
    on: enter
    source: null
    condition: "not flag(flag.ko_library_choir_resolved) and not has_item(item.choir_robe)"
    once: true
    effects: ["set_checkpoint(library_gallery)", "play_beat(scribes_burning)", "start_encounter(enc.ko_library_choir)"]
  - id: scribes_disguised
    area: choir_scriptorium
    on: enter
    source: null
    condition: "not flag(flag.ko_library_choir_resolved) and has_item(item.choir_robe)"
    once: true
    effects: ["start_dialogue(dlg.ko_scribe)"]
  - id: archivists
    area: reading_hall
    on: enter
    source: null
    condition: "flag(flag.ko_library_drained)"
    once: true
    effects: ["play_beat(archivists)"]
hazards:
  - {id: cold_water, area: mid_stacks, kind: cold, params: {chill_per_second: 9, note: "Wading; x3 Chill. Drains as sluices open."}}
  - {id: blight_leak, area: blight_aisle, kind: trap, params: {status: poison, stacks_per_s: 1, note: "Green water; antitoxin gives 30 s immunity."}}
  - {id: shelf_lids, area: mid_stacks, kind: collapse, params: {sink_after_s: 2.0, note: "Floating walkways sink if stood on; dunk = 30 Chill."}}
  - {id: drain_pull, area: drain_shaft, kind: tide, params: {pull_m_per_s: 2, active: "for 10 s after each sluice opens"}}
checkpoints:
  - {id: library_gallery, area: upper_gallery}
  - {id: library_drained, area: reading_hall}
beats:
  - {id: sluice_one, description: "Wheel 1 turns with a groan. Somewhere below, a grate opens; the black water starts to turn slowly, like a stirred pot. The mid stacks rise out of it by a metre."}
  - {id: wheel_jammed, description: "The wheel won't budge. The water's weight is on it. 'Upper sluice first,' says the plaque above it, in dwarven. Dravin or Maelis translates if present."}
  - {id: sluice_two, description: "Wheel 2 releases with a bang. The drain shaft roars. The spiral stair to the bottom appears out of the water step by step."}
  - {id: library_drains, description: "Wheel 3. The last of the water goes down the shaft in a long sucking roar. The reading hall emerges, dripping: desks, lectern, and seated at the desks, the archivists."}
  - {id: archivists, description: "Thirty dwarves at their desks, pens still in some hands, preserved by the cold water. Each has an open book in front of them. The last entries are all dated the same day."}
  - {id: scribes_burning, description: "Two monks feeding iron-leaf foils into a brazier with tongs; the foils curl and blacken. 'Copy the verses, burn the rest,' one says."}
  - {id: slab_read, description: "The command slab: a dark stone tablet with dense dwarven script. Read aloud slowly, it is not a lock at all. It is an order of battle."}
  - {id: slab_unreadable, description: "The script is too old and too dense. Words float up (throne, key, crown, answer) and sink again. Not yet."}
npcs:
  - {npc: npc.choir_scribe, area: choir_scriptorium, condition: "not flag(flag.ko_library_choir_resolved)"}
encounters: [enc.ko_library_choir]
loot: []
variants:
  - id: half_drained
    when: "var(var.ko_sluice) >= 1"
    description: "Mid stacks above water; walkways resting on the floor."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: [wheel_2_jammed]
  - id: drained
    when: "flag(flag.ko_library_drained)"
    description: "Dripping, steaming; the reading hall open; the bronze door reachable."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: scribes_gone
    when: "flag(flag.ko_library_choir_resolved)"
    description: "Braziers kicked over, half-burned foils cooling in puddles."
    npcs_absent: [npc.choir_scribe]
    encounters_disabled: [enc.ko_library_choir]
    interactables_disabled: []
```

```yaml zone
id: zone.ko_bridge_nine_anvils
name: "Karak Ostrel: The Bridge of Nine Anvils"
kind: dungeon
map_node: map.stairs_foot
time_of_day: night
cold_rate: 2
disguise_tag: null
music: bridge_drums
areas:
  - {id: approach_hall, description: "Broad hall from the library's bronze door ending at the Abyss of Bolts."}
  - {id: abyss, description: "A 200 m shaft; far below, the vault bulkheads steam and tick."}
  - {id: platform_0, description: "West abutment: anvils iron, mountain, lion (scrambled), each with a chained rune-mallet; a fallen statue for cover."}
  - {id: section_a, description: "Retractable bridge-plate, platform 0 to platform 1."}
  - {id: platform_1, description: "Pillar-top: anvils blood, watch, bolt; anvil blocks for cover."}
  - {id: section_b, description: "Retractable bridge-plate, platform 1 to platform 2."}
  - {id: platform_2, description: "Pillar-top: anvils bar, night, light; a broken statue for cover."}
  - {id: section_c, description: "Retractable bridge-plate, platform 2 to the gatehouse."}
  - {id: east_gatehouse, description: "Dwarven gatehouse with arrow slits facing the bridge; a winch; two Lock Guard wardens flank the inner door."}
  - {id: antechamber, description: "The Hall of Mirrors: bronze mirrors angled up into ceiling shafts; benches; the great door to the Lock Chamber."}
spawns:
  - {id: approach_hall, area: approach_hall, default: true}
  - {id: gatehouse_slits, area: east_gatehouse}
  - {id: platform_1_far, area: platform_1}
  - {id: guard_p0, area: platform_0}
  - {id: guard_p1, area: platform_1}
  - {id: guard_p2, area: platform_2}
  - {id: lock_guards, area: east_gatehouse}
  - {id: antechamber, area: antechamber}
exits:
  - id: back_to_library
    area: approach_hall
    to_zone: zone.ko_drowned_library
    to_spawn: library_exit_inside
    condition: "true"
    effects: []
  - id: to_lock_chamber
    area: antechamber
    to_zone: zone.ko_lock_chamber
    to_spawn: great_door
    condition: "ms(ms.a3_lock_reached)"
    effects: []
interactables:
  - id: anvil_iron
    area: platform_0
    kind: lever
    label: "Strike the iron anvil"
    condition: "var(var.ko_anvil_step) == 0"
    check: null
    once: false
    effects: ["add_var(var.ko_anvil_step, 1)", "play_beat(anvil_true)"]
    fail_effects: []
  - id: anvil_mountain
    area: platform_0
    kind: lever
    label: "Strike the mountain anvil"
    condition: "var(var.ko_anvil_step) == 1"
    check: null
    once: false
    effects: ["add_var(var.ko_anvil_step, 1)", "play_beat(anvil_true)"]
    fail_effects: []
  - id: anvil_mountain_early
    area: platform_0
    kind: lever
    label: "Strike the mountain anvil"
    condition: "var(var.ko_anvil_step) == 0"
    check: null
    once: false
    effects: ["damage_player(30)", "play_beat(anvil_discord_p0)"]
    fail_effects: []
  - id: anvil_lion
    area: platform_0
    kind: lever
    label: "Strike the lion anvil"
    condition: "var(var.ko_anvil_step) == 2"
    check: null
    once: false
    effects: ["add_var(var.ko_anvil_step, 1)", "set_flag(flag.ko_section_a)", "play_beat(section_extends)", "set_checkpoint(bridge_p1)"]
    fail_effects: []
  - id: anvil_lion_early
    area: platform_0
    kind: lever
    label: "Strike the lion anvil"
    condition: "var(var.ko_anvil_step) <= 1"
    check: null
    once: false
    effects: ["set_var(var.ko_anvil_step, 0)", "damage_player(30)", "play_beat(anvil_discord_p0)"]
    fail_effects: []
  - id: anvil_blood
    area: platform_1
    kind: lever
    label: "Strike the blood anvil"
    condition: "var(var.ko_anvil_step) == 3"
    check: null
    once: false
    effects: ["add_var(var.ko_anvil_step, 1)", "play_beat(anvil_true)"]
    fail_effects: []
  - id: anvil_watch
    area: platform_1
    kind: lever
    label: "Strike the watch anvil"
    condition: "var(var.ko_anvil_step) == 4"
    check: null
    once: false
    effects: ["add_var(var.ko_anvil_step, 1)", "play_beat(anvil_true)"]
    fail_effects: []
  - id: anvil_watch_early
    area: platform_1
    kind: lever
    label: "Strike the watch anvil"
    condition: "var(var.ko_anvil_step) == 3"
    check: null
    once: false
    effects: ["damage_player(30)", "play_beat(anvil_discord_p1)"]
    fail_effects: []
  - id: anvil_bolt
    area: platform_1
    kind: lever
    label: "Strike the bolt anvil"
    condition: "var(var.ko_anvil_step) == 5"
    check: null
    once: false
    effects: ["add_var(var.ko_anvil_step, 1)", "set_flag(flag.ko_section_b)", "play_beat(section_extends)", "set_checkpoint(bridge_p2)"]
    fail_effects: []
  - id: anvil_bolt_early
    area: platform_1
    kind: lever
    label: "Strike the bolt anvil"
    condition: "var(var.ko_anvil_step) == 3 or var(var.ko_anvil_step) == 4"
    check: null
    once: false
    effects: ["set_var(var.ko_anvil_step, 3)", "damage_player(30)", "play_beat(anvil_discord_p1)"]
    fail_effects: []
  - id: anvil_bar
    area: platform_2
    kind: lever
    label: "Strike the bar anvil"
    condition: "var(var.ko_anvil_step) == 6"
    check: null
    once: false
    effects: ["add_var(var.ko_anvil_step, 1)", "play_beat(anvil_true)"]
    fail_effects: []
  - id: anvil_night
    area: platform_2
    kind: lever
    label: "Strike the night anvil"
    condition: "var(var.ko_anvil_step) == 7"
    check: null
    once: false
    effects: ["add_var(var.ko_anvil_step, 1)", "play_beat(anvil_true)"]
    fail_effects: []
  - id: anvil_night_early
    area: platform_2
    kind: lever
    label: "Strike the night anvil"
    condition: "var(var.ko_anvil_step) == 6"
    check: null
    once: false
    effects: ["damage_player(30)", "play_beat(anvil_discord_p2)"]
    fail_effects: []
  - id: anvil_light
    area: platform_2
    kind: lever
    label: "Strike the light anvil"
    condition: "var(var.ko_anvil_step) == 8"
    check: null
    once: false
    effects: ["add_var(var.ko_anvil_step, 1)", "set_flag(flag.ko_section_c)", "play_beat(bridge_whole)", "set_checkpoint(bridge_gate)", "add_xp(300)"]
    fail_effects: []
  - id: anvil_light_early
    area: platform_2
    kind: lever
    label: "Strike the light anvil"
    condition: "var(var.ko_anvil_step) == 6 or var(var.ko_anvil_step) == 7"
    check: null
    once: false
    effects: ["set_var(var.ko_anvil_step, 6)", "damage_player(30)", "play_beat(anvil_discord_p2)"]
    fail_effects: []
  - id: still_lock_guards
    area: east_gatehouse
    kind: lever
    label: "Dravin: raise the Key to the Lock Guards"
    condition: "has_item(item.iron_key) and in_party(companion.dravin) and not flag(flag.ko_lock_guards_resolved)"
    check: null
    once: true
    effects: ["set_flag(flag.ko_lock_guards_resolved)", "set_flag(flag.ko_lock_guards_stilled)", "play_beat(guards_kneel)", "add_xp(300)"]
    fail_effects: []
  - id: choir_orders
    area: east_gatehouse
    kind: readable
    label: "Read the orders pinned in the gatehouse"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.ko_lore_choir_orders, 1)"]
    fail_effects: []
  - id: mirror_rest
    area: antechamber
    kind: rest
    label: "Rest before the great door"
    condition: "true"
    check: null
    once: false
    effects: ["heal_player(full)", "set_checkpoint(mirrors)"]
    fail_effects: []
triggers:
  - id: gatehouse_fire
    area: platform_0
    on: enter
    source: null
    condition: "not flag(flag.ko_bridge_gatehouse_resolved)"
    once: true
    effects: ["set_checkpoint(bridge_p0)", "play_beat(gatehouse_opens_fire)", "start_encounter(enc.ko_bridge_gatehouse)"]
  - id: zealots_cross
    area: platform_1
    on: interact
    source: anvil_bolt
    condition: "not flag(flag.ko_bridge_zealots_resolved)"
    once: true
    effects: ["play_beat(zealots_cross)", "start_encounter(enc.ko_bridge_zealots)"]
  - id: guard_p0_wakes
    area: platform_0
    on: beat_done
    source: anvil_discord_p0
    condition: "not flag(flag.ko_anvil_guard_0)"
    once: true
    effects: ["set_flag(flag.ko_anvil_guard_0)", "play_beat(anvil_guard_rises)", "start_encounter(enc.ko_anvil_guard_0)"]
  - id: guard_p1_wakes
    area: platform_1
    on: beat_done
    source: anvil_discord_p1
    condition: "not flag(flag.ko_anvil_guard_1)"
    once: true
    effects: ["set_flag(flag.ko_anvil_guard_1)", "play_beat(anvil_guard_rises)", "start_encounter(enc.ko_anvil_guard_1)"]
  - id: guard_p2_wakes
    area: platform_2
    on: beat_done
    source: anvil_discord_p2
    condition: "not flag(flag.ko_anvil_guard_2)"
    once: true
    effects: ["set_flag(flag.ko_anvil_guard_2)", "play_beat(anvil_guard_rises)", "start_encounter(enc.ko_anvil_guard_2)"]
  - id: lock_guards_wake
    area: east_gatehouse
    on: enter
    source: null
    condition: "not flag(flag.ko_lock_guards_resolved) and not (has_item(item.iron_key) and in_party(companion.dravin))"
    once: true
    effects: ["set_flag(flag.ko_lock_guards_resolved)", "play_beat(lock_guards_wake)", "start_encounter(enc.ko_lock_guards)"]
  - id: lock_reached
    area: antechamber
    on: enter
    source: null
    condition: "true"
    once: true
    effects: ["reach_milestone(ms.a3_lock_reached)", "play_beat(mirrors)", "set_checkpoint(mirrors)"]
hazards:
  - {id: abyss_fall, area: abyss, kind: collapse, params: {fall: lethal}}
  - {id: discord_discharge, area: platform_0, kind: trap, params: {damage: 30, note: "Wrong anvil: rune discharge; same on platforms 1 and 2."}}
  - {id: abyss_updraft, area: section_b, kind: steam, params: {damage_per_second: 6, cycle_on_s: 2, cycle_off_s: 6, note: "Hot venting from the deep vaults rolls up through the bridge gaps."}}
checkpoints:
  - {id: bridge_p0, area: approach_hall}
  - {id: bridge_p1, area: platform_1}
  - {id: bridge_p2, area: platform_2}
  - {id: bridge_gate, area: section_c}
  - {id: mirrors, area: antechamber}
beats:
  - {id: gatehouse_opens_fire, description: "Across the abyss, shutters bang open on the gatehouse's slits. The first bolt sparks off the iron anvil a hand from the player's head."}
  - {id: anvil_true, description: "The mallet rings the anvil. The note goes down the abyss and comes back up as a groan of machinery. A locking pin under the bridge withdraws."}
  - {id: anvil_discord_p0, description: "A wrong note. The anvil discharges blue-white up the mallet's chain. Somewhere under platform 0, iron moves."}
  - {id: anvil_discord_p1, description: "A wrong note. Discharge. Under platform 1, iron moves."}
  - {id: anvil_discord_p2, description: "A wrong note. Discharge. Under platform 2, iron moves."}
  - {id: anvil_guard_rises, description: "An iron-warden climbs up over the platform's edge from a maintenance niche beneath, frost streaming off it."}
  - {id: section_extends, description: "With a long grinding rumble the next bridge-plate slides out over the abyss and locks into the pillar ahead."}
  - {id: zealots_cross, description: "Before the plate has finished locking, three zealots come running across it from platform 2, blades out, singing."}
  - {id: bridge_whole, description: "The ninth note. The last plate slides home. For a moment the whole bridge hums like a struck bell."}
  - {id: lock_guards_wake, description: "Either side of the gatehouse's inner door, two great wardens with tower-shields straighten with a scream of iron."}
  - {id: guards_kneel, description: "Dravin raises the Key and says a word. Both Lock Guards drop to one knee and lower their shields, rune cores pulsing slow."}
  - {id: mirrors, description: "The Hall of Mirrors. Bronze mirrors angled up into shafts. Through the shafts, very faint and very far up, the sky is turning from black to iron-grey. Behind the great door, a child's voice, chanting."}
npcs: []
encounters: [enc.ko_bridge_gatehouse, enc.ko_bridge_zealots, enc.ko_anvil_guard_0, enc.ko_anvil_guard_1, enc.ko_anvil_guard_2, enc.ko_lock_guards]
loot: []
variants:
  - id: section_a_out
    when: "flag(flag.ko_section_a)"
    description: "Section A extended and locked."
    npcs_absent: []
    encounters_disabled: [enc.ko_anvil_guard_0]
    interactables_disabled: [anvil_iron, anvil_mountain, anvil_mountain_early, anvil_lion, anvil_lion_early]
  - id: section_b_out
    when: "flag(flag.ko_section_b)"
    description: "Section B extended and locked."
    npcs_absent: []
    encounters_disabled: [enc.ko_anvil_guard_1]
    interactables_disabled: [anvil_blood, anvil_watch, anvil_watch_early, anvil_bolt, anvil_bolt_early]
  - id: bridge_whole
    when: "flag(flag.ko_section_c)"
    description: "The whole bridge spans the abyss."
    npcs_absent: []
    encounters_disabled: [enc.ko_anvil_guard_2]
    interactables_disabled: [anvil_bar, anvil_night, anvil_night_early, anvil_light, anvil_light_early]
```

```yaml zone
id: zone.ko_lower_halls
name: "Karak Ostrel: The Lower Halls"
kind: dungeon
map_node: map.silver_mine
time_of_day: night
cold_rate: 1
disguise_tag: null
music: ostrel_deep
areas:
  - {id: mine_breach, description: "Rubble where the Silver Mine broke through into dressed dwarven stone; miners' ropes; a Strept lamp left burning."}
  - {id: hammer_gallery, description: "Long gallery; six pressure-hammers rise and fall in rhythm against the vault's outer bulkhead; oil on the floor."}
  - {id: warden_racks, description: "Barracks of eight warden racks; six empty, two occupied."}
  - {id: miners_shrine, description: "Dwarven miners' shrine: a carved pick and lamp, offering bowls, a log-book."}
  - {id: inner_bulkhead, description: "Rune-sealed bulkhead into the Forge of Echoes' south wall."}
spawns:
  - {id: mine_breach, area: mine_breach, default: true}
  - {id: hammer_tender, area: hammer_gallery}
  - {id: racks, area: warden_racks}
  - {id: bulkhead_outside, area: inner_bulkhead}
exits:
  - id: back_to_mine
    area: mine_breach
    to_zone: zone.silver_mine_breach
    to_spawn: from_ostrel
    condition: "true"
    effects: []
  - id: into_forge
    area: inner_bulkhead
    to_zone: zone.ko_forge_of_echoes
    to_spawn: bulkhead_inside
    condition: "flag(flag.ko_bulkhead_open)"
    effects: []
interactables:
  - id: bulkhead_rune
    area: inner_bulkhead
    kind: lever
    label: "Open the rune bulkhead"
    condition: "(in_party(companion.dravin) or in_party(companion.maelis)) and act() == 3 and not flag(flag.ko_bulkhead_open)"
    check: null
    once: true
    effects: ["set_flag(flag.ko_bulkhead_open)", "play_beat(bulkhead_turns)"]
    fail_effects: []
  - id: bulkhead_sealed
    area: inner_bulkhead
    kind: search
    label: "Examine the bulkhead"
    condition: "not in_party(companion.dravin) and not in_party(companion.maelis) and not flag(flag.ko_bulkhead_open)"
    check: null
    once: false
    effects: ["play_beat(bulkhead_sealed)"]
    fail_effects: []
  - id: still_tender
    area: hammer_gallery
    kind: lever
    label: "Dravin: still the Hammer-Tender"
    condition: "has_item(item.iron_key) and in_party(companion.dravin) and not flag(flag.ko_tender_resolved)"
    check: null
    once: true
    effects: ["set_flag(flag.ko_tender_resolved)", "set_flag(flag.ko_tender_stilled)", "play_beat(tender_stilled)", "add_xp(150)"]
    fail_effects: []
  - id: read_tender
    area: hammer_gallery
    kind: lever
    label: "Read the stand-down rune on the Tender's back while it oils a hammer [Lore 8]"
    condition: "not flag(flag.ko_tender_resolved)"
    check: {skill: lore, dc: 8}
    once: true
    effects: ["set_flag(flag.ko_tender_resolved)", "set_flag(flag.ko_tender_stilled)", "play_beat(tender_stilled)", "add_xp(150)"]
    fail_effects: ["play_beat(tender_turns)"]
  - id: miners_log
    area: miners_shrine
    kind: readable
    label: "Read the log-book"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.ko_lore_knocker_log, 1)"]
    fail_effects: []
  - id: shrine_rest
    area: miners_shrine
    kind: rest
    label: "Rest at the shrine"
    condition: "true"
    check: null
    once: false
    effects: ["heal_player(full)", "set_checkpoint(lower_shrine)"]
    fail_effects: []
triggers:
  - id: enter_ostrel
    area: mine_breach
    on: enter
    source: null
    condition: "true"
    once: true
    effects: ["reach_milestone(ms.a3_ostrel_entered)", "verify_rumor(rumor.r05_dwarves_inside)", "set_checkpoint(lower_breach)", "play_beat(hammers_heard)"]
  - id: tender_fight
    area: hammer_gallery
    on: beat_done
    source: tender_turns
    condition: "not flag(flag.ko_tender_killed)"
    once: true
    effects: ["start_encounter(enc.ko_hammer_tender)"]
  - id: racks_wake
    area: warden_racks
    on: enter
    source: null
    condition: "not flag(flag.ko_racks_resolved)"
    once: true
    effects: ["set_flag(flag.ko_racks_resolved)", "play_beat(racks_wake)", "start_encounter(enc.ko_warden_racks)"]
hazards:
  - {id: pressure_hammers, area: hammer_gallery, kind: trap, params: {damage: 80, cycle_s: 4.0, offset_s: [0, 0.7, 1.4, 2.1, 2.8, 3.5], note: "Six hammers in a rolling rhythm; safe windows 1.2 s each; oil on the floor makes sprinting slip."}}
checkpoints:
  - {id: lower_breach, area: mine_breach}
  - {id: lower_shrine, area: miners_shrine}
beats:
  - {id: hammers_heard, description: "The knocking, at last, close: BOOM. BOOM. Six great hammers labouring against a bulkhead the size of a church, keeping the deep vault's pressure in."}
  - {id: tender_stilled, description: "The Hammer-Tender stops mid-step with its oil-can raised, and goes dark. The hammers keep their rhythm without it."}
  - {id: tender_turns, description: "The Tender feels the touch on its back, turns, and swings the oil-can like a mace."}
  - {id: racks_wake, description: "Two of the eight racks clank. Two wardens unhook themselves and turn their dull orange cores toward the intruder."}
  - {id: bulkhead_turns, description: "A palm on the rune-seal and a word; the bulkhead's spokes turn and it rolls aside."}
  - {id: bulkhead_sealed, description: "Rune-sealed. No keyhole, no lever: the seal wants to be read, not forced. Dravin or Maelis could."}
npcs: []
encounters: [enc.ko_hammer_tender, enc.ko_warden_racks]
loot: []
variants:
  - id: tender_done
    when: "flag(flag.ko_tender_resolved)"
    description: "The Tender still, or broken among the oil."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: [still_tender, read_tender]
```

## 4. NPCs present

```yaml npc
id: npc.choir_scribe
name: "Brother Leszek"
faction: faction.choir
role: "Choir scribe burning the Drowned Library's iron-leaves"
motive: "Copy the verses, burn everything else, as ordered."
secret: "He has been hiding one iron-leaf, the Corvan letter, in his robe, because it made him cry."
disposition: hostile
essential: false
dialogue: dlg.ko_scribe
barks: ["Copy the verses, burn the rest.", "Mind the water, brother, it bites.", "So many books. So many."]
combat: enemy.choir_zealot
shop: null
```

Dravin and Maelis are companions (declared elsewhere). Their **barks for this section** (presentation, triggered by area entry):
- Weeping Gate vestibule. *Dravin:* "Grandfather's company. Every one of them. Don't step where they didn't." *Maelis:* "They're standing on the same rune. Anvil. We should too."
- Echo dome. *Dravin:* "Iron, mountain, lion, watch. The first two lines of the Pact. Dwarves don't waste a floor." *Maelis:* "Ash, burn, unbind, wake. Those are the Abbot's words. Don't step on his words."
- Gear room. *Dravin:* "Small wakes middle, middle wakes great. Every apprentice learns it before they learn their letters."
- Drowned Library. *Maelis:* "Iron-leaf. They wrote on metal so the water couldn't have it. And the Choir's burning it." *Dravin:* "Thirty archivists. They sat down at their desks and let the water come."
- Bridge. *Dravin:* "He played it backward to pull the plates. Play it forward." *Maelis:* "Every word of the true Oath, in order. Nine anvils. We know nine words."

## 5. Dialogue trees

```yaml dialogue
id: dlg.ko_scribe
participants: [npc.choir_scribe]
start: open
nodes:
  open:
    type: line
    speaker: npc.choir_scribe
    text: "Brother? You're late. The Abbot said every hand at the Lock by first light. We're nearly done. Copy the verses, burn the rest."
    direction: "He doesn't look up from the brazier, feeding a foil in with tongs."
    next: hub
  hub:
    type: choice
    options:
      - id: why_burn
        text: "Why burn it all?"
        once: true
        next: why_burn
      - id: leaf
        text: "You've got a leaf hidden in your robe, brother. What is it? [Investigate 6]"
        tag: investigate
        once: true
        check: {skill: investigate, dc: 6, pass: leaf_pass, fail: leaf_fail}
      - id: dismiss
        text: "The Abbot wants you at the Lock now. Both of you. Leave this. [Persuade 6]"
        tag: persuade
        once: true
        check: {skill: persuade, dc: 6, pass: dismiss_pass, fail: dismiss_fail}
      - id: attack
        text: "Put the tongs down."
        next: attack
      - id: walk
        text: "Carry on, brother."
        next: bye
  why_burn:
    type: line
    speaker: npc.choir_scribe
    text: "The Abbot says a kingdom is only as strong as what it remembers. So we remember the verses, and Cintra forgets everything else. Clean."
    next: hub
  leaf_pass:
    type: line
    speaker: npc.choir_scribe
    text: "It's a letter. From Corvan himself, to their High King. He was sorry. He was so sorry. I couldn't burn it. Take it. Don't tell the Abbot."
    effects: ["give_item(item.ko_lore_corvan_letter, 1)"]
    next: hub
  leaf_fail:
    type: line
    speaker: npc.choir_scribe
    text: "Hidden? No. No, brother. Feed the fire."
    next: hub
  dismiss_pass:
    type: line
    speaker: npc.choir_scribe
    text: "Now? Yes. Yes, of course. Brother Mikul, the light! Leave the tongs!"
    direction: "They hurry off toward the bronze door and the bridge."
    effects: ["set_flag(flag.ko_library_choir_resolved)", "add_xp(160)"]
    next: bye
  dismiss_fail:
    type: line
    speaker: npc.choir_scribe
    text: "Without finishing? He'd have our tongues. Who sent you, brother? What's your name in the Choir?"
    direction: "His hand goes to the knife at his belt."
    next: attack
  attack:
    type: effect
    effects: ["start_encounter(enc.ko_library_choir)"]
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.ko_gate_warden
zone: zone.ko_weeping_gate
enemies:
  - {enemy: enemy.iron_warden, count: 1, spawn: warden_alcove, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: gate_inside
avoidable_by: []
on_won: ["set_flag(flag.ko_gate_warden_resolved)"]
on_yielded: []
on_player_fled: []
```

The **teaching warden**. One iron-warden in a long hall. Its shield bash has a 0.6 s tell, and its rune overload is an area attack with a 1.5 s glow (gdd §6.7). After a stagger, its rune core is exposed for 3 s, and that is the damage window. The dead sentries are obstacles that block its bash charge. The safe anvil tiles do not matter once it is awake (the trap tiles only fire while the warden is unresolved).

```yaml encounter
id: enc.ko_forge_choir
zone: zone.ko_forge_of_echoes
enemies:
  - {enemy: enemy.choir_zealot, count: 3, spawn: choir_tents, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: choir_tents, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: forge_gallery
avoidable_by: []
on_won: ["set_flag(flag.ko_forge_choir_resolved)"]
on_yielded: ["set_flag(flag.ko_forge_choir_resolved)"]
on_player_fled: []
```

```yaml encounter
id: enc.ko_forge_wardens
zone: zone.ko_forge_of_echoes
enemies:
  - {enemy: enemy.iron_warden, count: 1, spawn: alcove_a, variant: null}
  - {enemy: enemy.iron_warden, count: 1, spawn: alcove_b, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: forge_gallery
avoidable_by: []
on_won: ["set_flag(flag.ko_forge_wardens_resolved)"]
on_yielded: []
on_player_fled: []
```

```yaml encounter
id: enc.ko_forge_warden_single
zone: zone.ko_forge_of_echoes
enemies:
  - {enemy: enemy.iron_warden, count: 1, spawn: alcove_a, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: forge_gallery
avoidable_by: []
on_won: ["set_flag(flag.ko_forge_wardens_resolved)"]
on_yielded: []
on_player_fled: []
```

Forge fights. The looters fight among the anvils (low cover everywhere). The zealots' self-immolation bursts can set the tents alight (fire hazard). The two alcove wardens drop 12 m from the alcoves to the floor in front of the bellows. When the bellows are running, a warden staggered in front of a bellows mouth takes a blast (40 fire) every 6 s as the bellows breathe. That is the arena trick.

```yaml encounter
id: enc.ko_library_choir
zone: zone.ko_drowned_library
enemies:
  - {enemy: enemy.choir_zealot, count: 2, spawn: choir_scribes, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 2, spawn: choir_scribes, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: library_gallery
avoidable_by: ["dlg.ko_scribe"]
on_won: ["set_flag(flag.ko_library_choir_resolved)"]
on_yielded: ["set_flag(flag.ko_library_choir_resolved)"]
on_player_fled: []
```

Library fight. The scriptorium alcove is dry, but the approach is waist-deep water (Chill ×3). The crossbowmen stand on the floating shelf-lid walkways, and a kick sinks the lid and dunks them (a 2 s stagger, then they wade). Brother Leszek is one of the two zealots.

```yaml encounter
id: enc.ko_bridge_gatehouse
zone: zone.ko_bridge_nine_anvils
enemies:
  - {enemy: enemy.choir_sharpshooter, count: 2, spawn: gatehouse_slits, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: gatehouse_slits, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: bridge_p0
avoidable_by: []
on_won: ["set_flag(flag.ko_bridge_gatehouse_resolved)"]
on_yielded: []
on_player_fled: []
```

```yaml encounter
id: enc.ko_bridge_zealots
zone: zone.ko_bridge_nine_anvils
enemies:
  - {enemy: enemy.choir_zealot, count: 3, spawn: platform_1_far, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: bridge_p1
avoidable_by: []
on_won: ["set_flag(flag.ko_bridge_zealots_resolved)"]
on_yielded: []
on_player_fled: []
```

```yaml encounter
id: enc.ko_anvil_guard_0
zone: zone.ko_bridge_nine_anvils
enemies:
  - {enemy: enemy.iron_warden, count: 1, spawn: guard_p0, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: bridge_p0
avoidable_by: []
on_won: []
on_yielded: []
on_player_fled: []
```

```yaml encounter
id: enc.ko_anvil_guard_1
zone: zone.ko_bridge_nine_anvils
enemies:
  - {enemy: enemy.iron_warden, count: 1, spawn: guard_p1, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: bridge_p1
avoidable_by: []
on_won: []
on_yielded: []
on_player_fled: []
```

```yaml encounter
id: enc.ko_anvil_guard_2
zone: zone.ko_bridge_nine_anvils
enemies:
  - {enemy: enemy.iron_warden, count: 1, spawn: guard_p2, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: bridge_p2
avoidable_by: []
on_won: []
on_yielded: []
on_player_fled: []
```

```yaml encounter
id: enc.ko_lock_guards
zone: zone.ko_bridge_nine_anvils
enemies:
  - {enemy: enemy.iron_warden, count: 2, spawn: lock_guards, variant: tower_shield}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: bridge_gate
avoidable_by: []
on_won: ["set_flag(flag.ko_lock_guards_resolved)"]
on_yielded: []
on_player_fled: []
```

Bridge gauntlet. The gatehouse shooters (two sharpshooters with laser-sight tells, one crossbowman) fire across the abyss throughout the puzzle. They are 40–60 m from platform 0 and 15 m from platform 2. They can be shot back through the slits (a weak-point hit) or ignored by moving cover to cover. When section C extends, the player can storm the gatehouse, and that ends the fight. The **zealots** come across section B when it extends, singing. Kicking a zealot off an extended plate sends him into the abyss. A wrong anvil wakes that platform's **Anvil Guard** (one warden, once per platform). The **Lock Guards** are a tower-shield variant: frontal blocks negate damage, so kick, flank, or Mane-Cleaver. They wake on entering the gatehouse unless Dravin raises the Key to them (`still_lock_guards`), which must be done from the doorway before stepping in. The presentation should give a 2 s grace on entry so the stilling is possible. Base counts. Stage 4 adds +1 to Choir groups (zealots, and the gatehouse crew).

```yaml encounter
id: enc.ko_hammer_tender
zone: zone.ko_lower_halls
enemies:
  - {enemy: enemy.iron_warden, count: 1, spawn: hammer_tender, variant: tender}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: lower_breach
avoidable_by: []
on_won: ["set_flag(flag.ko_tender_resolved)", "set_flag(flag.ko_tender_killed)"]
on_yielded: []
on_player_fled: []
```

```yaml encounter
id: enc.ko_warden_racks
zone: zone.ko_lower_halls
enemies:
  - {enemy: enemy.iron_warden, count: 2, spawn: racks, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: lower_shrine
avoidable_by: []
on_won: []
on_yielded: []
on_player_fled: []
```

Lower Halls. The Hammer-Tender never leaves its gallery. It fights among the pressure hammers, which hit it as hard as they hit the player: a staggered Tender under a falling hammer takes 160. The gallery can be crossed without waking it at all. It notices only a touch, a failed Lore read, or an attack.

## 7. Items and clues

```yaml item
id: item.ko_gear_crank
name: "Forge gear-crank"
category: key
description: "A bronze crank as long as a leg, its grip worn to the shape of dwarven hands. Fits the gear room's socket in the Forge of Echoes."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.echo_hammer
name: "Echo-hammer"
category: weapon
description: "A dwarven war-hammer from the Forge's reliquary. Its head rings a note that iron answers. Wardens hate it."
price: 0
stack_max: 1
equip_slot: main_hand
weapon: {base: 27, type: blunt, block_pct: 0.65, armor_pen: 25, bonus_vs: {construct: 1.6}, moveset: mace}
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.ko_lore_warden_tally
name: "The gate-warden's tally"
category: document
description: "A copy of the tally carved on the Weeping Gate's walls."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Cycle the First. Corvan, the Lion. Held. Cycle the Second. Corvan, grey now. Held. ... Cycle the Fourteenth. Wardens sealed in; the watch passes to the gate-warden Odrik, outside. ... Cycle the Twenty-first. Ysolde, a girl. Held. (Fresh chisel-marks, a different hand, low on the wall:) Cycle the Twenty-second. ______."
```

```yaml item
id: item.ko_lore_last_muster
name: "The last muster order"
category: document
description: "An iron-leaf order clutched in a dead sentry's gauntlet."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "By the High King's word, to every hand of Ostrel. The Lion's kingdom stands. Its enemies are dead. What we made for it must not wake. We will not leave it to be found. We close the doors on ourselves and keep the deep watch from inside, until the bolts hold of their own weight or the last of us is gone. The gate-warden Odrik goes out with the Key to wait upon the Lion's heirs. Stand to your posts. Do not grieve; it is a good watch. - Odrun, last High King under Ostrel."
```

```yaml item
id: item.ko_lore_forge_plaque
name: "Forge-master's plaque"
category: document
description: "A bronze plaque in the gear room, transcribed."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "The small wheel wakes the middle; the middle wakes the great; the great wakes the fire. Wake them out of order and the fire wakes you. The crank is the master's and goes home with the master. (Scratched beneath, fresh: 'Crank in the slag. Let them try. - Brother Kasimir')"
```

```yaml item
id: item.ko_lore_ash_sworn
name: "Ledger of the Ash-Sworn"
category: document
description: "An iron-leaf ledger from the Forge's reliquary."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "For the Lion's war, by the King under the Mountain's leave: four hundred men of Cintra, blood-sworn, given the ash-breath of the deep vault. Their lungs grew to bellows. They did not tire; they did not feel fire; they did not stop. Of four hundred, nineteen lived to see peace, and those nineteen asked to be sealed below with the vault. We granted it. The breath is in the vault still. Let no one breathe it again."
```

```yaml item
id: item.ko_lore_pact_leaf
name: "Iron-leaf of the Pact"
category: document
description: "The dwarven copy of the Pact between Corvan and the High King, on beaten iron foil."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Between Corvan, Lion of Cintra, and the High King under Ostrel. The weapons made for the Lion's war are sealed in the deep vault behind bolt and bar. The vault breathes, and every nineteen winters its breath must be let out and its bolts set again, or they will fail. This is done by the Lion's blood, crowned, at the Ring of Nine, speaking these words:\n\nBy iron forged in mountain deep,\nBy lion's blood the watch we keep.\nLet bolt and bar hold fast the night,\nTill nineteen winters turn to light.\n\nThe mountain-folk keep the deep watch. The clans keep the high watch. The Lion keeps the words."
```

```yaml item
id: item.ko_lore_corvan_letter
name: "Corvan's letter"
category: document
description: "An iron-leaf letter in a big, unpractised hand: King Corvan's own."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Brother under the Mountain. I won. You know what with. I have seen what the casks do to a field and what your breath does to a man and I will not sleep easy again. Lock it away. Lock it where my sons can't reach it and their sons can't find it. If they must have a key, let it be words and a crown and a long cold walk, so that no king opens it in a temper. I owe you a kingdom. I am sorry it was this one. - C."
```

```yaml item
id: item.ko_lore_reversal_note
name: "The archivist's last entry"
category: document
description: "The open book on the senior archivist's desk, last entry."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "For the record, since the water is coming. The lock was built as a war-switch before it was a lock. The engineers made it to open for war and close for peace with the same words, the closing said forward, the opening said back. The High King had the opening struck from every copy but the throne itself. The backward words, spoken by the Lion's blood at the throne, will open every bolt at once and let the vault breathe all its breath. It cannot be undone by speaking forward after; only by speaking forward first. The water is at my knees. A good watch."
```

```yaml item
id: item.ko_lore_command_rite
name: "The Rite of Command"
category: document
description: "Transcription of the command slab on the High King's lectern."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Should the Lion's kingdom stand in mortal need, and the King under the Mountain consent, let the warden of the gate set the Key in the throne, and the Lion's blood, crowned, set a hand on the throne and say: 'Wake and answer.' Then the vault does not open and does not close. It obeys. The wardens rise and take the throne's word. The casks and the engines go where the throne sends them. This is the Lion's last sword. The King under the Mountain will not consent. There is no King under the Mountain. Read this and grieve."
```

```yaml item
id: item.ko_lore_choir_orders
name: "Orders in the gatehouse"
category: document
description: "A sheet nailed to the gatehouse door in Anselm's hand."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Brothers. Hold the bridge until the first light comes down the mirror-shafts. Then come to the Lock and stand where I have shown you. Do not be afraid of what you hear from the vault. It has been waiting longer than any of us. When the door opens, the old men's world ends, and ours does not begin; there is no 'ours'. There is only the open door. Thank you. I have loved you all. - A."
```

```yaml item
id: item.ko_lore_knocker_log
name: "Miners' shrine log-book"
category: document
description: "A dwarven miners' log-book from the Lower Halls shrine."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "The hammers keep the outer bulkhead. So long as they beat, the vault holds its breath behind it. The Tender oils them. We have taught it to oil them forever. When the last of us is gone, listen: if the hammers stop, run. If they beat faster, the vault is losing its breath, and someone up above has a choice to make."
```

```yaml clue
id: clue.vault_command_rite
theory: theory.anselm_plan
title: "The Rite of Command"
text: "The throne in the Lock Chamber can be commanded instead of locked or opened. With the gate-warden's Key in the throne and the crowned Lion's blood saying 'Wake and answer', the wardens, casks and engines obey the throne. Dravin must be there to set the Key."
supports: []
refutes: []
```

```yaml clue
id: clue.ko_pact_origin
theory: theory.anselm_plan
title: "The Ash-Sworn"
text: "Corvan's shock-troops were four hundred men given the deep vault's 'ash-breath'. Their lungs grew to bellows and they did not tire or burn. Nineteen survived and asked to be sealed below. The breath is still in the vault."
supports: [anselm]
refutes: []
```

```yaml clue
id: clue.ko_reversal_design
theory: theory.anselm_plan
title: "A war-switch"
text: "The lock was built to open for war and close for peace with the same words: forward closes, backward opens. Once the backward words are finished, speaking forward cannot undo them. Only speaking forward first can."
supports: [anselm]
refutes: []
```

```yaml clue
id: clue.ko_dwarves_sealed_in
theory: theory.anselm_plan
title: "A good watch"
text: "The last High King of Ostrel sealed his people inside with Corvan's weapons to keep the deep watch, and sent the gate-warden Odrik out with the Key to wait for Cintra's kings. The rumors were true."
supports: []
refutes: []
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.a3_ostrel_entered, type: milestone, desc: "The player entered Karak Ostrel (Weeping Gate opened or Lower Halls breach)."}
  - {id: ms.a3_lock_reached, type: milestone, desc: "The player reached the Hall of Mirrors before the Lock Chamber."}
  - {id: flag.ko_ring_iron, type: bool, desc: "Weeping Gate outer ring set."}
  - {id: flag.ko_ring_lion, type: bool, desc: "Weeping Gate middle ring set."}
  - {id: flag.ko_ring_night, type: bool, desc: "Weeping Gate inner ring set."}
  - {id: flag.ko_gate_rings_set, type: bool, desc: "All three rings set (by Dravin or by hand)."}
  - {id: flag.ko_weeping_gate_open, type: bool, desc: "The Weeping Gate is open."}
  - {id: flag.ko_gate_warden_resolved, type: bool, desc: "The vestibule warden is stilled or fought."}
  - {id: flag.ko_gate_warden_stilled, type: bool, desc: "The vestibule warden was stilled."}
  - {id: var.ko_echo_step, type: int, min: 0, max: 4, desc: "Correct plates stepped in the echo dome."}
  - {id: flag.ko_echo_solved, type: bool, desc: "Echo dome solved; reliquary open."}
  - {id: flag.ko_crank_seated, type: bool, desc: "The gear crank is in its socket."}
  - {id: var.ko_gear_train, type: int, min: 0, max: 3, desc: "Gear-trains engaged in order."}
  - {id: flag.ko_bellows_running, type: bool, desc: "The Forge's bellows run: furnaces lit, lift working."}
  - {id: flag.ko_alcove_a_stilled, type: bool, desc: "Alcove warden A stilled."}
  - {id: flag.ko_alcove_b_stilled, type: bool, desc: "Alcove warden B stilled."}
  - {id: flag.ko_forge_wardens_resolved, type: bool, desc: "The Forge's alcove-warden fight has happened (or never will)."}
  - {id: flag.ko_forge_choir_resolved, type: bool, desc: "The Forge looters are dealt with."}
  - {id: flag.ko_bulkhead_open, type: bool, desc: "The Lower Halls / Forge bulkhead is open."}
  - {id: var.ko_sluice, type: int, min: 0, max: 3, desc: "Library sluices opened in order."}
  - {id: flag.ko_library_drained, type: bool, desc: "The Drowned Library is drained."}
  - {id: flag.ko_library_choir_resolved, type: bool, desc: "The library scribes are dealt with."}
  - {id: var.ko_anvil_step, type: int, min: 0, max: 9, desc: "Anvils struck in True Oath order."}
  - {id: flag.ko_section_a, type: bool, desc: "Bridge section A extended."}
  - {id: flag.ko_section_b, type: bool, desc: "Bridge section B extended."}
  - {id: flag.ko_section_c, type: bool, desc: "Bridge section C extended; bridge whole."}
  - {id: flag.ko_anvil_guard_0, type: bool, desc: "Platform 0 anvil guard woken."}
  - {id: flag.ko_anvil_guard_1, type: bool, desc: "Platform 1 anvil guard woken."}
  - {id: flag.ko_anvil_guard_2, type: bool, desc: "Platform 2 anvil guard woken."}
  - {id: flag.ko_bridge_gatehouse_resolved, type: bool, desc: "Gatehouse shooters dealt with."}
  - {id: flag.ko_bridge_zealots_resolved, type: bool, desc: "Bridge zealots dealt with."}
  - {id: flag.ko_lock_guards_resolved, type: bool, desc: "Lock Guards stilled or fought."}
  - {id: flag.ko_lock_guards_stilled, type: bool, desc: "Lock Guards knelt to the Key."}
  - {id: flag.ko_tender_resolved, type: bool, desc: "Hammer-Tender stilled or fought."}
  - {id: flag.ko_tender_stilled, type: bool, desc: "Hammer-Tender stilled."}
  - {id: flag.ko_tender_killed, type: bool, desc: "Hammer-Tender destroyed."}
  - {id: flag.ko_racks_resolved, type: bool, desc: "Warden racks fight happened."}
reads:
  - item.iron_key
  - item.choir_robe
  - item.mane_cleaver
  - flag.lower_breach_open
  - rumor.r05_dwarves_inside
```

## 9. Quest hooks

```yaml quest_stages
quest: quest.main_a3
order: 50
stages:
  - id: into_ostrel
    journal: "Karak Ostrel. The dwarves never left. They're still at their posts. Somewhere below, past the Forge and the Library and a bridge over nothing, Anselm has the boy at the throne."
    objectives:
      - {id: enter, text: "Enter Karak Ostrel", condition: "ms(ms.a3_ostrel_entered)", optional: false}
      - {id: bellows, text: "Wake the Forge of Echoes", condition: "flag(flag.ko_bellows_running)", optional: false}
      - {id: echo, text: "Answer the echo dome", condition: "flag(flag.ko_echo_solved)", optional: true, xp: 100}
      - {id: still_wardens, text: "Still the wardens instead of breaking them", condition: "flag(flag.ko_gate_warden_stilled) or flag(flag.ko_alcove_a_stilled) or flag(flag.ko_tender_stilled)", optional: true, xp: 80}
    on_complete: []
    next: []
  - id: to_the_lock
    journal: "The Library drowned with its archivists at their desks. The bridge beyond answers only to the Oath, word by word. The light is coming."
    objectives:
      - {id: drain, text: "Drain the Drowned Library", condition: "flag(flag.ko_library_drained)", optional: false}
      - {id: bridge, text: "Cross the Bridge of Nine Anvils", condition: "ms(ms.a3_lock_reached)", optional: false}
      - {id: rite, text: "Read the slab on the High King's lectern", condition: "has_clue(clue.vault_command_rite)", optional: true, xp: 150}
      - {id: war_switch, text: "Learn why the reversed words open the lock", condition: "has_clue(clue.ko_reversal_design)", optional: true, xp: 60}
    on_complete: []
    next: []
```

## 10. Rumors and event cards (optional)
`rumor.r05_dwarves_inside` (A07) is verified on entering the Weeping Gate or the Lower Halls (`verify_rumor`).

## 11. Failure states and branches

```yaml branches
paths:
  - id: weeping_gate
    when: "has_item(item.iron_key) at the plinth; rings set by Dravin or by hand from the faces' runes."
    outcome: "ms.a3_ostrel_entered; vestibule, hearth, descent to the Forge."
    sets: ["reach_milestone(ms.a3_ostrel_entered)"]
  - id: no_key_at_gate
    when: "The player reached the ledge without the Key."
    outcome: "No entry. The down path returns to the Stairs' foot and the map: fetch Dravin at Assengard, or use the Silver Mine breach."
    sets: []
  - id: lower_halls
    when: "flag.lower_breach_open (A07) and the A07 exit into zone.ko_lower_halls."
    outcome: "ms.a3_ostrel_entered; the hammer gallery; inner bulkhead needs Dravin or Maelis in the party."
    sets: ["reach_milestone(ms.a3_ostrel_entered)"]
  - id: forge
    when: "Crank from the slag pits, seated, trains small, middle, great."
    outcome: "Bellows run; lift to the library; alcove wardens wake unless stilled."
    sets: ["set_flag(flag.ko_bellows_running)"]
  - id: library
    when: "Sluices 1, 2, 3 in order."
    outcome: "Reading hall and the bronze door open; command slab readable (Maelis or Lore 7)."
    sets: ["set_flag(flag.ko_library_drained)"]
  - id: bridge
    when: "Nine anvils in True Oath order."
    outcome: "Bridge whole; gatehouse; Hall of Mirrors; ms.a3_lock_reached."
    sets: ["reach_milestone(ms.a3_lock_reached)"]
failures:
  - id: player_dies
    result: reload_checkpoint
    recover: "Every zone has checkpoints at its entry and after each puzzle stage."
  - id: wrong_plate_or_anvil
    result: soft_fail
    recover: "Damage and at most one warden per platform or dome; the sequence resets to the platform start; retry is free."
  - id: command_rite_failed
    result: soft_fail
    recover: "Lore 7 failed without Maelis: the slab can be retried (once: false) after gaining Wits, or skipped. Only the Bitter Bargain ending needs it."
  - id: lower_halls_no_reader
    result: soft_fail
    recover: "Bulkhead sealed without Dravin or Maelis: go back through the mine to the map and fetch Dravin (Assengard) or swap Maelis in at a rest point."
guarantees:
  - "ms.a3_ostrel_entered via the Weeping Gate needs only item.iron_key, which Dravin always gives in Act III (a3.03), and the rings, whose runes are shown on the gate faces (no check)."
  - "Every puzzle (rings, gear-trains, sluices, anvils) is deterministic and needs no check; the echo dome is optional."
  - "ms.a3_lock_reached needs no check: the Lock Guards can be fought if not stilled, and the gatehouse shooters can be ignored."
```

## 12. Open questions
- **Companion swap.** Rest points at the gate hearth, the Forge furnace, the Lower Halls shrine and the Hall of Mirrors should offer "change companion" (gdd §6.13, one active). The effect list has `recruit` and `dismiss` but no "swap to waiting". The companions domain should own this.
- **Disguise as a condition.** Several triggers use `has_item(item.choir_robe)` to mean "wearing the Choir disguise". A condition call such as `equipped(item.x)` or `disguised()` would be more accurate.
- **Interactables by position.** Pairs like `lever_middle`/`lever_middle_early` share one physical lever with mutually exclusive conditions. The presentation should map both to the same prop.
- **Exit to the Silver Mine.** `back_to_mine` targets `zone.silver_mine_breach` spawn `from_ostrel` (expected from A07). A07's breach exit into `zone.ko_lower_halls` / `mine_breach` should carry the condition `act() == 3`. The inner bulkhead also checks `act() == 3`.
- **Mane-Cleaver payoff.** The gdd §6.7/§6.9 tag bonus applies automatically. The 11 warden encounters in this section and the finale make it the "concrete payoff" of the Barrows side quest.
- **Knocking alignment.** A07's `clue.vault_knocking` says the knocking is "Ostrel's pressure-hammers labouring". The Lower Halls show exactly that: six pressure-hammers, tended by the Hammer-Tender warden.
