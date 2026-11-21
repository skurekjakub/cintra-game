---
section_id: a3.04
title: "The Marnadal Stairs"
act: 3
story_ref: "story.md §2 Góry Amell, §7.1 Race South (direct ascent), §7.4 The Marnadal Stairs, §11 Góry Amell table; gdd §6.4 Chill, §6.7 sharpshooter/frost troll, §7.3 rows 1 and 4, §7.4 Ravensford"
zones: [zone.stairs_switchbacks, zone.stairs_rope_spans, zone.stairs_ice_bridges]
available_when: "ms(ms.a3_departed)"
escalation_stage_required: {min: 4, max: 4}
milestones_set: [ms.a3_stairs_crossed]
milestones_read: [ms.a3_departed, ms.a3_strept_resolved]
level_band: [9, 10]
---

# The Marnadal Stairs

## 1. Scene summary
The Marnadal Stairs are a dwarven stair of thousands of hand-deep steps, cut switchback after switchback up a cliff to the high gorges. Beyond them, rope bridges and natural ice-bridges lead to the ridge under the Old Grey Matron. The climb comes in three zones. On the **Switchbacks**, the Choir rear-guard under Brother Ostwin holds a barricade on the seventh turn, with a prisoner chained in their baggage: Tobiasz, the palace servant who led Aldric out through the catacombs. Without Strept guides the player must go through the barricade (fight, or talk them off with Choir disguise, Anselm's cipher, threats or silver). With guides, a shepherds' ledge path leads around it. At the **Rope Spans**, swaying bridges cross glacial gorges under Choir sharpshooters hung in nests on the far cliff. The Choir's own secret pass (`clue.choir_secret_pass`, from Ravensford) leads under the gorges through an ice cave and skips them entirely. On the **Ice Bridges**, two frost trolls, displaced from their goat-hunting grounds by the Choir's blasting, hunt the glacier in whiteout bursts. Mutton bait, old dwarven fire-pots and stealth all get the player past without killing them. Warmth is the resource: braziers, fire-pots and the gorge hut stand between the player and the Chill meter. The section ends when the player reaches the upper ridge (`ms.a3_stairs_crossed`).

## 2. Progress and escalation
- Stage 4 only. The blizzard, Chill and every encounter are always present. They are the story's "heavy snows close high passes" made physical (stage 2 onward).
- **The direct-ascent rule (gdd §7.3):** without `flag.strept_guides`, the barricade on switchback seven cannot be bypassed, so the rear-guard segment is forced: fight or talk. With guides, the Shepherd's Ledge path is visible and passable, and the rear-guard can be skipped or hit from behind.
- **War-band:** if `in_party(ally.strept_warband)`, Corra's highlanders fight in the barricade fight and take one sharpshooter nest at the spans (the `_warband` encounter versions have one fewer sharpshooter).
- **Choir secret pass:** with `has_clue(clue.choir_secret_pass)`, the ice cave under the west anchor is open, and the sharpshooter segment is skipped.
- `ms.a3_stairs_crossed` is set when the player takes the upper ridge path out of the Ice Bridges.
- Returning from Karak Ostrel's Weeping Gate by the long way down (a3.06) lands at the stairs-foot camp. All encounters stay cleared after their milestone variants.

## 3. Location layout

### 3.1 The Switchbacks (`zone.stairs_switchbacks`)
The **stairs-foot camp** is a shepherd's bothy with a fire-ring (rest, and the travel-map exit), with the Marnadal Watch tower visible far below. From there the stair climbs a south-facing cliff in twelve switchbacks, each a flight of 40–60 m.
- **Lower flights (turns 1–5):** two abreast, a rotted rail on the drop side, open sky. Ice patches on the steps make sprinting risky.
- **Broken Shrine (turn 4):** a way-shrine with a carved Oath line and a cold brazier. Lighting it gives warmth, and it is the last warmth for a long way.
- **Goat Gate (turn 6):** a dwarven arch spanning the stair. With guides, the **Shepherd's Ledge** branches left through a gap in the arch's footing. It is a 1 m ledge along the cliff above the switchbacks, with goat droppings and old iron pegs.
- **Rear-guard barricade (turn 7):** carts, sharpened stakes and stacked crates across the stair, with crossbow loopholes and a watch-fire. A rock **spur** 10 m above the barricade, on the uphill side, holds a sharpshooter. Coming from below, the player is in his line of fire for the last 30 m of turn 7. Cover: the Goat Gate pillars, a fallen cart, and the inside corner of the turn.
- **Baggage hollow:** a wind-hollow behind and above the barricade with mules, baggage and the chained prisoner. The Shepherd's Ledge comes down into it from above.
- **Upper flights (turns 8–12):** narrower, ice on every step, blizzard gusts at the open corners (whiteout bursts every 30–40 s, 6 s long).
- **Wind Notch:** a cleft at the top of the stair, opening onto the gorges. It is the exit to the Rope Spans.

### 3.2 The Rope Spans (`zone.stairs_rope_spans`)
A chain of three rope bridges hops across glacial gorges between rock pillars.
- **West anchor:** the platform below the Wind Notch, with dwarven anchor-posts, and the **ice cave mouth** hidden under its lip (visible only with the secret-pass clue).
- **Span 1:** 40 m long, intact, swaying. Crossing while sprinting tips the player against the rope (a stagger).
- **Mid pillar:** a rock pillar with the **gorge hut**, a dwarven anchor-house with a stove that still draws (rest).
- **Span 2:** 70 m long. A third of its planks are gone, so the player must step on the side ropes in places (slow walk). It runs under fire from the **sniper cliff**, the opposite cliff face, where three Choir nests hang from ropes 15–25 m away. Cover on the span: two prayer-flag cairns built on wider plank sections, and the span's own sag at its middle (out of sight of nest 1).
- **Span 3:** 25 m, short and steep, to the **east anchor** and the exit.
- **Ice cave (secret pass):** a tunnel through the gorge ice, under span 1 and span 2, with frozen falls and Choir mule-dung. It comes out at the east anchor.

### 3.3 The Ice Bridges (`zone.stairs_ice_bridges`)
A glacier tongue cut by crevasses, crossed on natural ice-bridges, under the white flank of the Old Grey Matron.
- **Gorge edge:** the arrival point from the spans.
- **First bridge:** an ice-bridge 3 m wide over a 20 m crevasse. **Troll A** waits on the crevasse floor under it and climbs up when the player is halfway across.
- **Crevasse floor:** bone-strewn (goats, a mule, a Choir boot). It is troll A's lair, reachable by an ice-chute.
- **Serac field:** a maze of ice towers that gives cover and breaks sight lines. Whiteout pockets drift through it. **Troll B** patrols a loop through the seracs and past the fire-pot terrace.
- **Fire-pot terrace:** a dwarven rest-terrace cut into a rock island, with three iron fire-pots still holding old pitch. Lighting them makes a warm zone, and trolls will not enter firelight.
- **Troll den:** a cave on the serac field's edge where troll B sleeps. It holds Choir loot from a mule the trolls dragged off.
- **Far bridge:** a long, cracked ice-bridge to the ridge path.
- **Upper ridge path:** the exit to Wyvern's Roost.

```yaml zone
id: zone.stairs_switchbacks
name: "The Marnadal Stairs: Switchbacks"
kind: exterior
map_node: map.stairs_foot
time_of_day: dusk
cold_rate: 3
disguise_tag: null
music: blizzard_climb
areas:
  - {id: stairs_foot_camp, description: "Shepherd's bothy and fire-ring at the foot of the dwarven stair; the Marnadal Watch tower far below."}
  - {id: lower_flights, description: "Turns 1-5: steps a hand deep, two abreast, a rotted rail on the drop side; ice patches."}
  - {id: broken_shrine, description: "Turn 4 way-shrine: roof fallen, a lion's head worn smooth, a carved line under rime, a cold iron brazier."}
  - {id: goat_gate, description: "Turn 6: a dwarven arch over the stair; beyond, the stair narrows."}
  - {id: shepherd_ledge, description: "A 1 m goat ledge with iron pegs, running above turn 7 to the baggage hollow; only with Strept guides."}
  - {id: rearguard_barricade, description: "Turn 7: carts, stakes, stacked crates with loopholes, a watch-fire; a rock spur 10 m above for the sharpshooter."}
  - {id: baggage_hollow, description: "Wind-hollow above the barricade: mules, baggage, a chained prisoner, a tarp shelter."}
  - {id: upper_flights, description: "Turns 8-12: narrow, iced, blizzard gusts at open corners."}
  - {id: wind_notch, description: "Cleft at the top of the stair opening onto the gorges."}
spawns:
  - {id: stairs_foot_camp, area: stairs_foot_camp, default: true}
  - {id: ledge_end, area: baggage_hollow}
  - {id: barricade_front, area: rearguard_barricade}
  - {id: barricade_spur, area: rearguard_barricade}
  - {id: wind_notch_top, area: wind_notch}
exits:
  - id: to_rope_spans
    area: wind_notch
    to_zone: zone.stairs_rope_spans
    to_spawn: west_anchor
    condition: "true"
    effects: []
interactables:
  - id: foot_board
    area: stairs_foot_camp
    kind: map_board
    label: "Go down to the valley roads"
    condition: "true"
    check: null
    once: false
    effects: []
    fail_effects: []
  - id: foot_fire
    area: stairs_foot_camp
    kind: rest
    label: "Rest at the shepherds' fire"
    condition: "true"
    check: null
    once: false
    effects: ["heal_player(full)", "set_checkpoint(stairs_foot)"]
    fail_effects: []
  - id: shrine_line
    area: broken_shrine
    kind: readable
    label: "Brush the rime off the carving"
    condition: "not flag(flag.shrine_oath_found)"
    check: null
    once: true
    effects: ["set_flag(flag.shrine_oath_found)", "add_clue(clue.shrine_oath_line)"]
    fail_effects: []
  - id: shrine_brazier
    area: broken_shrine
    kind: lever
    label: "Light the shrine brazier"
    condition: "true"
    check: null
    once: true
    effects: ["play_beat(shrine_brazier_lit)"]
    fail_effects: []
  - id: ledge_path
    area: goat_gate
    kind: door
    label: "Follow the shepherds onto the ledge"
    condition: "flag(flag.strept_guides)"
    check: null
    once: false
    effects: ["set_flag(flag.stairs_ledge_taken)", "goto_zone(zone.stairs_switchbacks, ledge_end)"]
    fail_effects: []
  - id: barricade_gate
    area: rearguard_barricade
    kind: door
    label: "Drag the cart aside"
    condition: "flag(flag.stairs_rearguard_resolved)"
    check: null
    once: true
    effects: ["play_beat(barricade_opened)"]
    fail_effects: []
  - id: drop_on_barricade
    area: baggage_hollow
    kind: lever
    label: "Drop onto the barricade from behind"
    condition: "not flag(flag.stairs_rearguard_resolved)"
    check: null
    once: true
    effects: ["play_beat(attack_from_behind)", "start_encounter(enc.stairs_rearguard)"]
    fail_effects: []
  - id: prisoner
    area: baggage_hollow
    kind: search
    label: "The chained man"
    condition: "not flag(flag.tobiasz_freed) and not flag(flag.tobiasz_left)"
    check: null
    once: false
    effects: ["start_dialogue(dlg.tobiasz)"]
    fail_effects: []
  - id: choir_baggage
    area: baggage_hollow
    kind: container
    label: "Search the rear-guard's baggage"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.rearguard_orders, 1)"]
    fail_effects: []
triggers:
  - id: rearguard_hail
    area: rearguard_barricade
    on: enter
    source: null
    condition: "not flag(flag.stairs_rearguard_resolved) and not flag(flag.stairs_rearguard_talked)"
    once: true
    effects: ["set_flag(flag.stairs_rearguard_talked)", "set_checkpoint(before_barricade)", "play_beat(barricade_hail)", "start_dialogue(dlg.ostwin_barricade)"]
  - id: rearguard_return
    area: rearguard_barricade
    on: enter
    source: null
    condition: "not flag(flag.stairs_rearguard_resolved) and flag(flag.stairs_rearguard_talked) and not flag(flag.stairs_ledge_taken)"
    once: false
    effects: ["start_encounter(enc.stairs_rearguard)"]
  - id: guides_point
    area: goat_gate
    on: enter
    source: null
    condition: "flag(flag.strept_guides)"
    once: true
    effects: ["play_beat(guides_point_ledge)"]
  - id: direct_bark
    area: goat_gate
    on: enter
    source: null
    condition: "not flag(flag.strept_guides)"
    once: true
    effects: ["play_beat(no_way_round)"]
hazards:
  - {id: step_ice, area: lower_flights, kind: cold, params: {slip_on_sprint: true, stagger_s: 0.8}}
  - {id: whiteout_upper, area: upper_flights, kind: cold, params: {burst_every_s: [30, 40], burst_length_s: 6, chill_per_second: 6, visibility_m: 6}}
  - {id: drop_side, area: upper_flights, kind: collapse, params: {fall: lethal, rail: "none above turn 8"}}
checkpoints:
  - {id: stairs_foot, area: stairs_foot_camp}
  - {id: before_barricade, area: goat_gate}
beats:
  - {id: shrine_brazier_lit, description: "The old coal catches with a cough of soot. For a moment the carved lion's face is warm-lit."}
  - {id: guides_point_ledge, description: "The two Strept shepherds stop at the Goat Gate. One taps the arch's footing with a crook: there is a gap, and a ledge. 'Goats go this way. So do we.'"}
  - {id: no_way_round, description: "The player looks for another way past the turn above and sees only cliff. Smoke from a fire on the seventh turn. Voices."}
  - {id: barricade_hail, description: "A voice from behind the crates: 'That's far enough!' A crossbow-stock pokes through a loophole. On the spur above, a long shape shifts against the snow."}
  - {id: attack_from_behind, description: "The player drops from the hollow onto the crates. The rear-guard turn, too late, crossbows still pointed downhill. Choir enemies start the fight unaware for 2 s."}
  - {id: barricade_opened, description: "A cart creaks aside on frozen wheels. The stair above is clear."}
  - {id: rearguard_leaves, description: "The rear-guard shoulder their packs and climb past the player without looking at them, Ostwin last, his hand on his feather."}
  - {id: rearguard_deserts, description: "Ostwin's men pick up their gear and go down the stair, not up. Ostwin stands alone a moment, then follows them."}
npcs:
  - {npc: npc.brother_ostwin, area: rearguard_barricade, condition: "not flag(flag.stairs_rearguard_resolved)"}
  - {npc: npc.tobiasz, area: baggage_hollow, condition: "not flag(flag.tobiasz_freed) and not flag(flag.tobiasz_left)"}
encounters: [enc.stairs_rearguard, enc.stairs_rearguard_shaken]
loot:
  - {container: choir_baggage, items: [{item: item.fire_oil, count: 2}, {item: item.frost_tallow, count: 1}, {item: item.crossbow_bolt, count: 12}, {item: item.field_draught, count: 1}], condition: "true"}
variants:
  - id: rearguard_gone
    when: "flag(flag.stairs_rearguard_resolved)"
    description: "Barricade cleared or abandoned; watch-fire out; trampled snow."
    npcs_absent: [npc.brother_ostwin]
    encounters_disabled: [enc.stairs_rearguard, enc.stairs_rearguard_shaken]
    interactables_disabled: [drop_on_barricade]
```

```yaml zone
id: zone.stairs_rope_spans
name: "The Marnadal Stairs: Rope Spans"
kind: exterior
map_node: map.stairs_foot
time_of_day: dusk
cold_rate: 4
disguise_tag: null
music: blizzard_climb
areas:
  - {id: west_anchor, description: "Rock platform below the Wind Notch; dwarven anchor-posts as thick as a man; the ice cave mouth under its lip."}
  - {id: span_1, description: "40 m rope bridge, intact, swaying; prayer-flags frozen stiff."}
  - {id: mid_pillar, description: "Rock pillar with a dwarven anchor-house (the gorge hut): a stove, two bunks, a winch."}
  - {id: span_2, description: "70 m rope bridge with a third of its planks gone; two prayer-flag cairns on wider sections give cover; the middle sags out of sight of nest 1."}
  - {id: sniper_cliff, description: "The opposite cliff, 15-25 m from span 2: three Choir nests, plank platforms hung on ropes from pitons."}
  - {id: span_3, description: "25 m steep span to the east anchor."}
  - {id: east_anchor, description: "East platform; trail onto the glacier."}
  - {id: ice_cave, description: "Secret pass: a tunnel through the gorge ice under spans 1 and 2; frozen falls; mule dung; Choir chalk marks."}
spawns:
  - {id: west_anchor, area: west_anchor, default: true}
  - {id: east_anchor_arrive, area: east_anchor}
  - {id: cave_exit, area: east_anchor}
  - {id: nest_1, area: sniper_cliff}
  - {id: nest_2, area: sniper_cliff}
  - {id: nest_3, area: sniper_cliff}
exits:
  - id: to_ice_bridges
    area: east_anchor
    to_zone: zone.stairs_ice_bridges
    to_spawn: gorge_edge
    condition: "true"
    effects: []
  - id: back_to_switchbacks
    area: west_anchor
    to_zone: zone.stairs_switchbacks
    to_spawn: wind_notch_top
    condition: "true"
    effects: []
interactables:
  - id: cave_mouth
    area: west_anchor
    kind: door
    label: "Squeeze into the Choir's ice cave"
    condition: "has_clue(clue.choir_secret_pass)"
    check: null
    once: false
    effects: ["set_flag(flag.stairs_secret_pass_used)", "play_beat(cave_mouth)", "goto_zone(zone.stairs_rope_spans, cave_exit)"]
    fail_effects: []
  - id: gorge_hut
    area: mid_pillar
    kind: rest
    label: "Light the gorge-hut stove"
    condition: "true"
    check: null
    once: false
    effects: ["heal_player(full)", "set_checkpoint(gorge_hut)"]
    fail_effects: []
  - id: nest_rope_1
    area: sniper_cliff
    kind: lever
    label: "Shoot nest 1's hanging rope (crossbow)"
    condition: "not flag(flag.spans_sharpshooters_cleared)"
    check: null
    once: true
    effects: ["play_beat(nest_falls)"]
    fail_effects: []
  - id: nest_rope_2
    area: sniper_cliff
    kind: lever
    label: "Shoot nest 2's hanging rope (crossbow)"
    condition: "not flag(flag.spans_sharpshooters_cleared)"
    check: null
    once: true
    effects: ["play_beat(nest_falls)"]
    fail_effects: []
  - id: hut_winch
    area: mid_pillar
    kind: lever
    label: "Tighten span 2 with the winch"
    condition: "true"
    check: null
    once: true
    effects: ["play_beat(span_tightened)"]
    fail_effects: []
triggers:
  - id: snipers_open_fire
    area: span_2
    on: enter
    source: null
    condition: "not flag(flag.spans_sharpshooters_cleared) and not in_party(ally.strept_warband)"
    once: true
    effects: ["set_checkpoint(gorge_hut)", "play_beat(first_shot)", "start_encounter(enc.stairs_sharpshooters)"]
  - id: snipers_open_fire_warband
    area: span_2
    on: enter
    source: null
    condition: "not flag(flag.spans_sharpshooters_cleared) and in_party(ally.strept_warband)"
    once: true
    effects: ["set_checkpoint(gorge_hut)", "play_beat(warband_takes_nest)", "start_encounter(enc.stairs_sharpshooters_warband)"]
hazards:
  - {id: span_sway, area: span_1, kind: trap, params: {sprint_stagger_s: 0.8, note: "Sprinting on a span staggers into the rope."}}
  - {id: missing_planks, area: span_2, kind: collapse, params: {fall: lethal, slow_walk_sections: 4, note: "Gaps crossed on the side ropes at walk speed; tightening the winch removes 2 slow sections."}}
  - {id: gorge_wind, area: span_2, kind: cold, params: {chill_per_second: 6}}
  - {id: cave_falls, area: ice_cave, kind: collapse, params: {damage: 25, telegraph_s: 1.0, note: "Icicle falls at three marked points."}}
checkpoints:
  - {id: gorge_hut, area: mid_pillar}
beats:
  - {id: cave_mouth, description: "Under the anchor's lip, behind a curtain of icicles: a slot just wide enough for a laden mule, with a chalk feather on the wall. The Choir's own road."}
  - {id: first_shot, description: "A bolt hums past and splits a plank at the player's feet. On the far cliff, three hanging platforms, grey shapes kneeling on each."}
  - {id: warband_takes_nest, description: "Corra and a highlander go up the sniper cliff on bare hands and axe-picks. The third nest goes quiet; a grey body tumbles into the gorge."}
  - {id: nest_falls, description: "The rope parts with a crack. The nest swings, tips, and the sharpshooter goes with it into the white."}
  - {id: span_tightened, description: "The winch groans; span 2 lifts and steadies; two of the worst gaps close up."}
npcs: []
encounters: [enc.stairs_sharpshooters, enc.stairs_sharpshooters_warband]
loot: []
variants:
  - id: snipers_gone
    when: "flag(flag.spans_sharpshooters_cleared) or flag(flag.stairs_secret_pass_used)"
    description: "Nests empty or cut down; ropes trailing from pitons."
    npcs_absent: []
    encounters_disabled: [enc.stairs_sharpshooters, enc.stairs_sharpshooters_warband]
    interactables_disabled: [nest_rope_1, nest_rope_2]
```

```yaml zone
id: zone.stairs_ice_bridges
name: "The Marnadal Stairs: Ice Bridges"
kind: exterior
map_node: map.stairs_foot
time_of_day: dusk
cold_rate: 5
disguise_tag: null
music: glacier_hunt
areas:
  - {id: gorge_edge, description: "Arrival from the spans; a cairn and a frozen rope."}
  - {id: first_bridge, description: "Ice-bridge 3 m wide over a 20 m crevasse; blue ice, wind-polished."}
  - {id: crevasse_floor, description: "Troll A's lair: bones of goats and a mule, a Choir boot; reached by an ice chute."}
  - {id: serac_field, description: "Maze of ice towers 4-10 m high; whiteout pockets drift through; troll B's patrol loop."}
  - {id: fire_pot_terrace, description: "Dwarven rest-terrace on a rock island: three iron fire-pots full of old pitch, a stone bench, carved warmth-runes."}
  - {id: troll_den, description: "Cave on the serac edge: troll B's sleeping hollow; a dragged-off Choir mule and its packs."}
  - {id: far_bridge, description: "Long cracked ice-bridge to the ridge path."}
  - {id: upper_ridge_path, description: "Wind-scoured path up to the saddle under the Old Grey Matron."}
spawns:
  - {id: gorge_edge, area: gorge_edge, default: true}
  - {id: troll_bridge_under, area: crevasse_floor}
  - {id: troll_den_inside, area: troll_den}
  - {id: ridge_path_end, area: upper_ridge_path}
exits:
  - id: to_roost
    area: upper_ridge_path
    to_zone: zone.wyverns_roost
    to_spawn: saddle_south
    condition: "true"
    effects: ["reach_milestone(ms.a3_stairs_crossed)"]
  - id: back_to_spans
    area: gorge_edge
    to_zone: zone.stairs_rope_spans
    to_spawn: east_anchor_arrive
    condition: "true"
    effects: []
interactables:
  - id: throw_bait
    area: gorge_edge
    kind: lever
    label: "Throw the mutton haunch down into the crevasse below the bridge"
    condition: "has_item(item.mutton_bait) and not flag(flag.troll_a_resolved)"
    check: null
    once: true
    effects: ["take_item(item.mutton_bait, 1)", "set_flag(flag.troll_a_resolved)", "set_flag(flag.troll_a_baited)", "play_beat(troll_takes_bait)", "add_xp(120)"]
    fail_effects: []
  - id: fire_pot_1
    area: fire_pot_terrace
    kind: lever
    label: "Light the first fire-pot"
    condition: "true"
    check: null
    once: true
    effects: ["add_var(var.ice_fire_pots, 1)", "play_beat(pot_lit)"]
    fail_effects: []
  - id: fire_pot_2
    area: fire_pot_terrace
    kind: lever
    label: "Light the second fire-pot"
    condition: "true"
    check: null
    once: true
    effects: ["add_var(var.ice_fire_pots, 1)", "play_beat(pot_lit)"]
    fail_effects: []
  - id: fire_pot_3
    area: fire_pot_terrace
    kind: lever
    label: "Light the third fire-pot"
    condition: "true"
    check: null
    once: true
    effects: ["add_var(var.ice_fire_pots, 1)", "play_beat(pot_lit)"]
    fail_effects: []
  - id: terrace_rest
    area: fire_pot_terrace
    kind: rest
    label: "Warm yourself on the terrace"
    condition: "var(var.ice_fire_pots) >= 3"
    check: null
    once: false
    effects: ["heal_player(full)", "set_checkpoint(fire_terrace)"]
    fail_effects: []
  - id: mule_packs
    area: troll_den
    kind: container
    label: "Search the dead mule's packs"
    condition: "true"
    check: null
    once: true
    effects: []
    fail_effects: []
  - id: warmth_runes
    area: fire_pot_terrace
    kind: readable
    label: "Read the carved runes"
    condition: "true"
    check: {skill: lore, dc: 6}
    once: true
    effects: ["play_beat(runes_read)", "add_xp(45)"]
    fail_effects: []
triggers:
  - id: troll_a_rises
    area: first_bridge
    on: enter
    source: null
    condition: "not flag(flag.troll_a_resolved)"
    once: true
    effects: ["set_checkpoint(gorge_edge_cp)", "play_beat(troll_rises)", "start_encounter(enc.ice_bridge_troll)"]
  - id: terrace_warm
    area: fire_pot_terrace
    on: interact
    source: fire_pot_3
    condition: "var(var.ice_fire_pots) >= 3 and not flag(flag.troll_b_resolved)"
    once: true
    effects: ["set_flag(flag.troll_b_turned)", "set_flag(flag.troll_b_resolved)", "play_beat(troll_turns_from_fire)", "add_xp(120)"]
  - id: troll_b_wakes
    area: troll_den
    on: enter
    source: null
    condition: "not flag(flag.troll_b_resolved)"
    once: true
    effects: ["play_beat(den_wakes)", "start_encounter(enc.serac_troll)"]
hazards:
  - {id: whiteout_seracs, area: serac_field, kind: cold, params: {burst_every_s: [25, 35], burst_length_s: 8, chill_per_second: 7, visibility_m: 5}}
  - {id: crevasse_drop, area: first_bridge, kind: collapse, params: {fall: "to crevasse_floor, 30 damage"}}
  - {id: far_bridge_crack, area: far_bridge, kind: collapse, params: {sprint_breaks_section: true, damage: 40, note: "Sprinting on the far bridge drops a section into a 4 m slot; climb out at the far end."}}
  - {id: terrace_fire, area: fire_pot_terrace, kind: fire, params: {damage_per_second: 5, note: "Only inside the pots' 1 m rim. The terrace around them is warmth (Chill drains)."}}
checkpoints:
  - {id: gorge_edge_cp, area: gorge_edge}
  - {id: fire_terrace, area: fire_pot_terrace}
beats:
  - {id: troll_rises, description: "Halfway across the bridge, a white arm the size of a pine trunk hooks over the edge. The troll hauls itself up, steaming, eyes like wet slate."}
  - {id: troll_takes_bait, description: "The mutton thuds onto the crevasse floor. Below the bridge something huge and pale unfolds from the bones and lopes after it, snuffling."}
  - {id: pot_lit, description: "Pitch older than Cintra catches with a slow roar. The warmth-runes on the bench seem to darken in the light."}
  - {id: troll_turns_from_fire, description: "Troll B comes round the seracs on its loop, sees the three fires on the terrace, and veers away with a grunt, back toward its den, giving the terrace a wide berth."}
  - {id: den_wakes, description: "In the den's dark, a pile of white fur rolls over. The smell of the dead mule is suddenly very strong."}
  - {id: runes_read, description: "'Here is warmth for the watch. The cold-folk will not cross fire.' Dwarven, very old. The dwarves knew about trolls."}
npcs: []
encounters: [enc.ice_bridge_troll, enc.serac_troll]
loot:
  - {container: mule_packs, items: [{item: item.field_draught, count: 2}, {item: item.fire_oil, count: 2}, {item: item.frost_tallow, count: 1}, {item: item.pale_feather, count: 1}], condition: "true"}
variants:
  - id: troll_a_gone
    when: "flag(flag.troll_a_resolved)"
    description: "Bridge clear; crevasse floor quiet or the troll gnawing below."
    npcs_absent: []
    encounters_disabled: [enc.ice_bridge_troll]
    interactables_disabled: [throw_bait]
  - id: troll_b_gone
    when: "flag(flag.troll_b_resolved)"
    description: "Troll B dead or keeping to its den edge away from the fire."
    npcs_absent: []
    encounters_disabled: [enc.serac_troll]
    interactables_disabled: []
```

Troll B's patrol (level design): a loop of about 90 s through the serac field, passing within 8 m of the terrace and across the path to the far bridge. Its sight cone is the gdd stealth cone (90°, 12 m; 6 m in a whiteout pocket). If the player is seen, `enc.serac_troll` starts at once. That is a presentation hook into the same encounter, as with the den trigger. Crouching through whiteout pockets (gdd §6.5) lets the player slip past. If the player kills troll B in the patrol fight, `flag.troll_b_resolved` is set through `on_won`.

## 4. NPCs present

```yaml npc
id: npc.brother_ostwin
name: "Brother Ostwin"
faction: faction.choir
role: "Captain of the Choir rear-guard on the Marnadal Stairs"
motive: "Hold the stair until solstice dawn so no one follows the Abbot."
secret: "He dug the burial pits at Marnadal in 1263 and was paid for it by the same lords who billed the Crown for the graves. He knows he has been left here to die and has decided to be grateful."
disposition: hostile
essential: false
dialogue: dlg.ostwin_barricade
barks: ["Hold the stair, brothers.", "The light is coming.", "He said you'd be angry. He said you'd be late.", "Shoot the one with the crown."]
combat: enemy.choir_zealot
shop: null
```
*Voice:* an ex-soldier's flat Marnadal valley vowels with a monk's vocabulary on top. Very calm. He uses "brother" for everyone, the player included.

```yaml npc
id: npc.tobiasz
name: "Tobiasz"
faction: faction.choir
role: "Bribed palace servant who led Aldric out through the Abbey catacombs; chained by the rear-guard when he tried to turn back"
motive: "Live; and, now that it is too late, undo what he did."
secret: "He took Choir silver to pay his mother's debts to Varn's toll-farmers. He has the feather sewn in his boot and has not been able to cut it out."
disposition: friendly
essential: false
dialogue: dlg.tobiasz
barks: ["Please. Please, I'm not one of them. I was.", "He was so small in that tunnel.", "It's so cold. Is it always this cold?"]
combat: null
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.ostwin_barricade
participants: [npc.brother_ostwin]
start: open
nodes:
  open:
    type: line
    speaker: npc.brother_ostwin
    text: "That's far enough, brother. The Abbot said someone would come. He said you'd be angry, and he said you'd be late."
    direction: "Behind the crates, only his head and a feather in his hood visible. Above him on the spur, the sharpshooter's stock settles against a shoulder."
    next: hub
  hub:
    type: choice
    options:
      - id: aldric
        text: "Is the boy alive?"
        once: true
        next: aldric
      - id: why
        text: "Why are you doing this?"
        once: true
        next: why
      - id: robe
        text: "[Item: Choir robe] New word from the top, brother. You're called up. All of you. The Abbot wants every blade at the Lock when the light comes. [Persuade 8]"
        tag: item
        condition: "has_item(item.choir_robe)"
        once: true
        check: {skill: persuade, dc: 8, pass: robe_pass, fail: robe_fail}
      - id: cipher
        text: "[Item: Anselm's cipher] Read your own orders, brother. 'Hold the stair till dawn. No relief.' He's left you here to freeze. [Persuade 6]"
        tag: item
        condition: "has_item(item.anselm_cipher)"
        once: true
        check: {skill: persuade, dc: 6, pass: cipher_pass, fail: cipher_fail}
      - id: threaten
        text: "Six of you on an ice stair, and I'm the one walking up it. Count again. [Intimidate 8]"
        tag: intimidate
        once: true
        check: {skill: intimidate, dc: 8, pass: threaten_pass, fail: threaten_fail}
      - id: bribe
        text: "Your crossbowmen are hired, not sworn. Twenty-five crowns each to walk down and forget my face. [Bribe 50]"
        tag: bribe
        bribe: 50
        once: true
        next: bribe_pass
      - id: fight
        text: "Then we do this the hard way."
        next: fight
  aldric:
    type: line
    speaker: npc.brother_ostwin
    text: "Alive, and singing, badly. He keeps stopping to spit at the Abbot. The Abbot lets him. He says the boy will need his anger later."
    next: hub
  why:
    type: line
    speaker: npc.brother_ostwin
    text: "I dug the pits at Marnadal, brother. Clansmen in one, our boys in the other. A lord's steward paid me by the yard. I'd like to see what the lords dig for themselves."
    next: hub
  robe_pass:
    type: line
    speaker: npc.brother_ostwin
    text: "...Every blade. Yes. That sounds like him. Brothers, pack up. We climb."
    effects: ["play_beat(rearguard_leaves)", "set_flag(flag.stairs_rearguard_resolved)", "set_flag(flag.stairs_rearguard_climbed)", "add_xp(300)"]
    next: bye
  robe_fail:
    type: line
    speaker: npc.brother_ostwin
    text: "I know every face that went up this stair. I don't know yours. Loose!"
    next: fight
  cipher_pass:
    type: line
    speaker: npc.brother_ostwin
    text: "No relief. He did say that, didn't he. I thought it was a test of faith. It was just a plan."
    direction: "He reads it twice. Then he takes the feather out of his hood and drops it in the fire."
    effects: ["play_beat(rearguard_deserts)", "set_flag(flag.stairs_rearguard_resolved)", "set_flag(flag.stairs_rearguard_deserted)", "add_xp(300)"]
    next: bye
  cipher_fail:
    type: line
    speaker: npc.brother_ostwin
    text: "Forgeries. The Abbot warned us about forgeries. Loose!"
    next: fight
  threaten_pass:
    type: line
    speaker: npc.brother_ostwin
    text: "The hirelings are running. Let them. Some of us came up here to die, brother. You'll have to oblige."
    direction: "Two crossbowmen scramble down the far side of the barricade and are gone."
    effects: ["set_flag(flag.stairs_rearguard_shaken)"]
    next: fight_small
  threaten_fail:
    type: line
    speaker: npc.brother_ostwin
    text: "I've been threatened by better men, and buried them. Loose!"
    next: fight
  bribe_pass:
    type: line
    speaker: npc.brother_ostwin
    text: "Go on, then, you two. Take the silver. Faith was never in your contract."
    direction: "The crossbowmen take the purse and leave. Ostwin and the zealots don't move."
    effects: ["set_flag(flag.stairs_rearguard_shaken)"]
    next: fight_small
  fight:
    type: effect
    effects: ["start_encounter(enc.stairs_rearguard)"]
    next: bye
  fight_small:
    type: effect
    effects: ["start_encounter(enc.stairs_rearguard_shaken)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.tobiasz
participants: [npc.tobiasz]
start: open
nodes:
  open:
    type: line
    speaker: npc.tobiasz
    text: "Don't. Don't hurt me. I'm not one of them. I was. I'm not now. They chained me when I tried to go back down."
    direction: "Chained by one ankle to a mule's picket, wrapped in a stolen palace livery cloak, lips blue."
    next: hub
  hub:
    type: choice
    options:
      - id: who
        text: "Who are you?"
        once: true
        next: who
      - id: aldric
        text: "Tell me about the prince."
        once: true
        next: aldric
      - id: anselm
        text: "What is Anselm carrying?"
        once: true
        next: anselm
      - id: list
        text: "[Item: Choir membership list] Your name is on this, Tobiasz. Under the palace servants. Who else is with Anselm in that mountain?"
        tag: item
        condition: "has_item(item.choir_list)"
        once: true
        next: list
      - id: free
        text: "Hold still."
        next: free
      - id: leave
        text: "You chose your side. Stay with it."
        next: left
  who:
    type: line
    speaker: npc.tobiasz
    text: "Tobiasz. Under-steward of the night stair. I had the key to the old catacomb door. They paid my mother's toll debts. That's all it cost. A key and a door."
    next: hub
  aldric:
    type: line
    speaker: npc.tobiasz
    text: "He didn't cry. He kept asking for you by name. In the tunnel he was so small. The Abbot carried him the last bit, singing to him."
    next: hub
  anselm:
    type: line
    speaker: npc.tobiasz
    text: "A black flask. He breathes from it at night and coughs till he spits grey. He says he's getting used to the air of the deep vaults. 'The mountain will breathe for me,' he says."
    effects: ["add_clue(clue.anselm_breathes_ash)"]
    next: hub
  list:
    type: line
    speaker: npc.tobiasz
    text: "Brother Jarek and Brother Wick, the bodyguards. They're farm boys from Tigg. They don't hate anyone. They'd lay their blades down if anyone gave them a reason that wasn't a sermon."
    next: hub
  free:
    type: line
    speaker: npc.tobiasz
    text: "Thank you. I'll go down. I'll go to the Marshal and tell him what I did. Tell the prince... no. Don't tell him anything about me."
    direction: "You break the picket. He stumbles away down the stair, shaking."
    effects: ["set_flag(flag.tobiasz_freed)", "add_xp(60)"]
    next: bye
  left:
    type: line
    speaker: npc.tobiasz
    text: "Please..."
    effects: ["set_flag(flag.tobiasz_left)"]
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.stairs_rearguard
zone: zone.stairs_switchbacks
enemies:
  - {enemy: enemy.choir_zealot, count: 2, spawn: barricade_front, variant: null}
  - {enemy: enemy.choir_zealot, count: 1, spawn: barricade_front, variant: captain}
  - {enemy: enemy.choir_crossbowman, count: 2, spawn: barricade_front, variant: null}
  - {enemy: enemy.choir_sharpshooter, count: 1, spawn: barricade_spur, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: [ally.strept_warband]
checkpoint: before_barricade
avoidable_by: ["dlg.ostwin_barricade"]
on_won: ["set_flag(flag.stairs_rearguard_resolved)", "set_flag(flag.stairs_rearguard_killed)"]
on_yielded: ["set_flag(flag.stairs_rearguard_resolved)"]
on_player_fled: []
```

```yaml encounter
id: enc.stairs_rearguard_shaken
zone: zone.stairs_switchbacks
enemies:
  - {enemy: enemy.choir_zealot, count: 2, spawn: barricade_front, variant: null}
  - {enemy: enemy.choir_zealot, count: 1, spawn: barricade_front, variant: captain}
  - {enemy: enemy.choir_sharpshooter, count: 1, spawn: barricade_spur, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: [ally.strept_warband]
checkpoint: before_barricade
avoidable_by: ["dlg.ostwin_barricade"]
on_won: ["set_flag(flag.stairs_rearguard_resolved)", "set_flag(flag.stairs_rearguard_killed)"]
on_yielded: ["set_flag(flag.stairs_rearguard_resolved)"]
on_player_fled: []
```

Barricade design. The approach is a 30 m run up turn 7 under the sharpshooter's line (his tell is 0.8 s, gdd §6.7). The crossbowmen shoot through loopholes and fall back up the stair if the player gets within 4 m. The zealots leap the crates to meet the player on the stair. The sharpshooter's spur can be reached by a 3 m chimney on the barricade's left. Kicking him off the spur kills him (fall). The war-band, if present, charges up the stair alongside the player and draws the zealots. Attacking from the baggage hollow (`drop_on_barricade`) gives the 2 s unaware start of `attack_from_behind`: the crossbowmen are facing downhill, and the sharpshooter is facing away. Base counts; stage 4 adds +1 zealot (gdd §6.1).

```yaml encounter
id: enc.stairs_sharpshooters
zone: zone.stairs_rope_spans
enemies:
  - {enemy: enemy.choir_sharpshooter, count: 1, spawn: nest_1, variant: null}
  - {enemy: enemy.choir_sharpshooter, count: 1, spawn: nest_2, variant: null}
  - {enemy: enemy.choir_sharpshooter, count: 1, spawn: nest_3, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: gorge_hut
avoidable_by: []
on_won: ["set_flag(flag.spans_sharpshooters_cleared)"]
on_yielded: []
on_player_fled: ["set_flag(flag.spans_sharpshooters_cleared)"]
```

```yaml encounter
id: enc.stairs_sharpshooters_warband
zone: zone.stairs_rope_spans
enemies:
  - {enemy: enemy.choir_sharpshooter, count: 1, spawn: nest_1, variant: null}
  - {enemy: enemy.choir_sharpshooter, count: 1, spawn: nest_2, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: [ally.strept_warband]
checkpoint: gorge_hut
avoidable_by: []
on_won: ["set_flag(flag.spans_sharpshooters_cleared)"]
on_yielded: []
on_player_fled: ["set_flag(flag.spans_sharpshooters_cleared)"]
```

Span design. This is a shooting gallery with the player as the target. The sharpshooters cannot be reached in melee. They are fought with the crossbow (nests 15–25 m away), or by shooting their hanging ropes (`nest_rope_1`/`_2`, which kill the occupant), or by simply running span 2 from cover to cover. **Reaching the east anchor ends the segment** (`on_player_fled` counts as cleared, because the nests can no longer see the glacier). Tightening the winch at the gorge hut first shortens the slow-walk gaps. Nest 3 is the war-band's. The stage-4 +1 member does not apply here: each nest holds one shooter.

```yaml encounter
id: enc.ice_bridge_troll
zone: zone.stairs_ice_bridges
enemies:
  - {enemy: enemy.frost_troll, count: 1, spawn: troll_bridge_under, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: [ally.strept_warband]
checkpoint: gorge_edge_cp
avoidable_by: []
on_won: ["set_flag(flag.troll_a_resolved)", "set_flag(flag.troll_a_killed)"]
on_yielded: []
on_player_fled: ["set_flag(flag.troll_a_resolved)"]
```

```yaml encounter
id: enc.serac_troll
zone: zone.stairs_ice_bridges
enemies:
  - {enemy: enemy.frost_troll, count: 1, spawn: troll_den_inside, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: [ally.strept_warband]
checkpoint: fire_terrace
avoidable_by: []
on_won: ["set_flag(flag.troll_b_resolved)", "set_flag(flag.troll_b_killed)"]
on_yielded: []
on_player_fled: []
```

Troll design. On a 3 m bridge, troll A's grab-and-throw (gdd §6.7) can throw the player into the crevasse (30 damage, landing in its lair). Dodging sideways is limited, and back-stepping is the safe defence. It regenerates 5 HP/s in Chill unless it took fire in the last 5 s. Fire oil on the weapon, or fighting it on the fire-pot terrace, counters this. If the player crosses the bridge and leaves troll A behind on the far side, that counts as resolved (`on_player_fled`). Trolls are not fast. Troll B fights in the serac field, where the towers block its throws, and will not follow the player onto a lit terrace.

## 7. Items and clues

```yaml item
id: item.rearguard_orders
name: "Rear-guard orders"
category: document
description: "Oilcloth packet in the Choir's cipher, already decoded in pencil between the lines."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Brother Ostwin. Hold the seventh turn. No one climbs after us. When the light comes down the shafts it will not matter whether you are alive to see it. There will be no relief and no recall. You are the door I close behind me. - A. (Decoded beneath, in a second hand: 'no relief and no recall' - God help us.)"
```

```yaml clue
id: clue.anselm_breathes_ash
theory: theory.anselm_plan
title: "The black flask"
text: "Anselm breathes from a black flask at night and coughs grey. He says he is 'getting used to the air of the deep vaults'. He means to breathe whatever the lock vents when it opens."
supports: [anselm]
refutes: []
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.a3_stairs_crossed, type: milestone, desc: "The player reached the upper ridge above the Marnadal Stairs."}
  - {id: flag.stairs_ledge_taken, type: bool, desc: "The player used the Strept shepherds' ledge around the barricade."}
  - {id: flag.stairs_rearguard_talked, type: bool, desc: "Ostwin's hail and dialogue have played."}
  - {id: flag.stairs_rearguard_resolved, type: bool, desc: "The barricade is no longer held (any route)."}
  - {id: flag.stairs_rearguard_killed, type: bool, desc: "The rear-guard was fought."}
  - {id: flag.stairs_rearguard_climbed, type: bool, desc: "The rear-guard was sent up the mountain by a disguise (flavor: in the finale's first wave)."}
  - {id: flag.stairs_rearguard_deserted, type: bool, desc: "Ostwin's men deserted down the stair (epilogue flavor)."}
  - {id: flag.stairs_rearguard_shaken, type: bool, desc: "The hired crossbowmen left before the fight."}
  - {id: flag.tobiasz_freed, type: bool, desc: "The player freed Tobiasz (epilogue flavor)."}
  - {id: flag.tobiasz_left, type: bool, desc: "The player left Tobiasz chained."}
  - {id: flag.stairs_secret_pass_used, type: bool, desc: "The player used the Choir's ice cave."}
  - {id: flag.spans_sharpshooters_cleared, type: bool, desc: "The sharpshooter nests are no longer a threat."}
  - {id: flag.troll_a_resolved, type: bool, desc: "The ice-bridge troll is dead, baited or left behind."}
  - {id: flag.troll_a_baited, type: bool, desc: "The ice-bridge troll was lured off with bait."}
  - {id: flag.troll_a_killed, type: bool, desc: "The ice-bridge troll was killed."}
  - {id: flag.troll_b_resolved, type: bool, desc: "The serac troll is dead or turned by fire."}
  - {id: flag.troll_b_turned, type: bool, desc: "The serac troll was turned away by the fire-pots."}
  - {id: flag.troll_b_killed, type: bool, desc: "The serac troll was killed."}
  - {id: var.ice_fire_pots, type: int, min: 0, max: 3, desc: "Fire-pots lit on the Ice Bridges terrace."}
reads:
  - flag.strept_guides
  - flag.shrine_oath_found
  - clue.choir_secret_pass
  - item.choir_robe
  - item.anselm_cipher
  - item.choir_list
  - item.mutton_bait
```

## 9. Quest hooks

```yaml quest_stages
quest: quest.main_a3
order: 30
stages:
  - id: climb_the_stairs
    journal: "The Choir went up the Marnadal Stairs and left a rear-guard on the seventh turn. Above that: rope bridges, then the ice. Keep warm, keep moving."
    objectives:
      - {id: cross, text: "Climb the Marnadal Stairs to the upper ridge", condition: "ms(ms.a3_stairs_crossed) or ms(ms.a3_ostrel_entered)", optional: false}
      - {id: tobiasz, text: "Find out who led Aldric out of the palace", condition: "flag(flag.tobiasz_freed) or flag(flag.tobiasz_left)", optional: true, xp: 60}
      - {id: flask, text: "Learn what Anselm breathes at night", condition: "has_clue(clue.anselm_breathes_ash)", optional: true, xp: 40}
      - {id: spare_trolls, text: "Get past the frost trolls without killing them", condition: "flag(flag.troll_a_resolved) and flag(flag.troll_b_resolved) and not flag(flag.troll_a_killed) and not flag(flag.troll_b_killed)", optional: true, xp: 150}
    on_complete: []
    next: []
```

## 10. Rumors and event cards (optional)
None. The mountain travel table (A07) covers the approach. `event.m6_choir_rearguard` is a travel-arena version of this segment and stays separate.

## 11. Failure states and branches

```yaml branches
paths:
  - id: direct_forced
    when: "No flag.strept_guides."
    outcome: "Ostwin's barricade must be fought or talked open: robe Persuade 8 (they climb), cipher Persuade 6 (they desert), Intimidate 8 or Bribe 50 (smaller fight), or fight."
    sets: ["set_flag(flag.stairs_rearguard_resolved)"]
  - id: ledge_bypass
    when: "flag.strept_guides."
    outcome: "Shepherd's Ledge to the baggage hollow; free Tobiasz quietly and go on up, or drop on the barricade from behind."
    sets: ["set_flag(flag.stairs_ledge_taken)"]
  - id: secret_pass
    when: "has_clue(clue.choir_secret_pass)."
    outcome: "Ice cave under the gorges; no sharpshooter segment."
    sets: ["set_flag(flag.stairs_secret_pass_used)"]
  - id: spans_run
    when: "No pass."
    outcome: "Shoot the nests, cut their ropes, or run span 2 cover to cover; reaching the east anchor ends the segment."
    sets: ["set_flag(flag.spans_sharpshooters_cleared)"]
  - id: trolls
    when: "Ice Bridges."
    outcome: "Troll A: fight, bait, or cross and leave it behind. Troll B: fight, sneak through the whiteout, or turn it with three lit fire-pots."
    sets: ["set_flag(flag.troll_a_resolved)", "set_flag(flag.troll_b_resolved)"]
failures:
  - id: player_dies
    result: reload_checkpoint
    recover: "Reload stairs_foot, before_barricade, gorge_hut, gorge_edge_cp or fire_terrace."
  - id: fall
    result: reload_checkpoint
    recover: "Falls from the stair, spans or crevasses reload the last checkpoint."
  - id: chill_maxed
    result: soft_fail
    recover: "At 100 Chill the player loses 5 HP/s (gdd §6.4). Warmth: shrine brazier, gorge hut, fire-pot terrace, frost-tallow, Strept furs."
guarantees:
  - "ms.a3_stairs_crossed needs no check: fight the rear-guard (unconditional 'hard way' option), run the spans, fight or outrun the trolls, take the ridge exit."
```

## 12. Open questions
- **Crossbow-hit interactables.** `nest_rope_1/2` are `lever` interactables activated by a crossbow hit, not by Interact. The zone schema has no "shot" trigger. The presentation layer should map a bolt hit on the rope to the interactable.
- **Patrol sighting starts an encounter.** Troll B's patrol uses the stealth vision cone. Being seen should start `enc.serac_troll`, which needs a presentation hook. The content triggers only cover the den.
- **Ally ids in `allies`.** I list `ally.strept_warband` in encounter `allies`. It should spawn only when `in_party(ally.strept_warband)`. The schema example lists only npc ids.
- **Snow-choked pass.** The gdd §6.3 mountain-edge hazard is a travel event owned by the map. It is not repeated here.
