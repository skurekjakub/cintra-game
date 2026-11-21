---
section_id: a3.05
title: "Wyvern's Roost"
act: 3
story_ref: "story.md §2 (1268 wyvern), §6 Tigg, §7.5 Wyvern's Roost; gdd §6.7 enemy.wyvern_roost, §6.13 ally.wyvern, §7.3 row 5"
zones: [zone.wyverns_roost, zone.roost_chasm_climb]
available_when: "ms(ms.a3_departed)"
escalation_stage_required: {min: 4, max: 4}
milestones_set: [ms.a3_roost_resolved]
milestones_read: [ms.a3_stairs_crossed, ms.a2_tigg_resolved]
level_band: [10, 10]
---

# Wyvern's Roost

## 1. Scene summary
Above the ice the path tops out on a wind-scoured saddle under the Old Grey Matron. Across a 60 m chasm, on the far cliff, is the black notch of the Weeping Gate. The dwarven sky-bridge that once spanned it lies in pieces at the bottom, dropped by the Choir's blasting. On the stump of a fallen dwarven watch-tower, the wyvern from Tigg has built her nest of pine boughs, wool and bones. She is guarding a clutch of three, and grieving for two. The Choir stole those two eggs for their alchemy, and the player may be carrying them, recovered from the reagent store at Vel Aram. Brother Udo, the alchemist who stole them, is still here, marooned on a rock pillar since she caught his party. The choice: **return the eggs**, and she carries the player across the chasm to the Weeping Gate. Or **slay her** (`enemy.wyvern_roost`, a full boss). Or **slip past** her and climb the collapsed chasm wall the hard way while she harries the climb from the air. The section ends when the player is across (`ms.a3_roost_resolved`).

## 2. Progress and escalation
- Stage 4 only.
- How the Tigg encounter ended (A05) changes her look and one beat. `flag.wyvern_fought` leaves a crossbow scar on her left wing and makes her hiss at the player's crossbow. `flag.wyvern_driven_by_smoke` makes her flinch from the player's torch. Neither changes the rules.
- **With `item.wyvern_eggs`:** walking onto the nest approach opens the stand-off (`dlg.wyvern_standoff`). Set the eggs down and she becomes `ally.wyvern`. Draw steel and the fight starts. Back away and nothing happens yet.
- **Without the eggs:** walking onto the nest approach starts the fight. The player can avoid the nest entirely and take the chasm climb from the lower ledge, in which case she harries the climb.
- `ms.a3_roost_resolved` and `flag.roost_resolved` (read by A07's travel card M4) are set when the eggs are returned, when she is slain, or when the player tops the chasm climb.
- The war-band, if present, parts from the player here: Corra's squad heads around the mountain's shoulder to the main portal, to pin down the Choir there (gdd §6.13, "outside Ostrel"). `ally.strept_warband` stays in the party for the finale's bodyguard count.

## 3. Location layout

### 3.1 The Roost (`zone.wyverns_roost`)
The **saddle** is a 40 m wide neck of wind-packed snow between two rock shoulders, where the player arrives from the south up the ridge path. North of it is the **tower ruin**, the stump of a dwarven watch-tower 8 m high, with four fallen pillars around its base. They are the cover in the fight: the wyvern's stoops cannot pass through them. The **nest shelf** is a basalt shelf on top of the stump, reached by a ramp of rubble on its east side (the **nest approach**). It holds the nest, three eggs, sheep skulls from Tigg, and a strip of Choir robe. West of the tower is the **Choir camp**: a collapsed tent, an alchemist's travelling kit and two dead monks, dragged and dropped. North again is the **chasm edge**, the broken stub of the sky-bridge with its iron chains hanging into the drop. The Weeping Gate is visible across the chasm, 60 m away. A 30 m **pillar** of rock stands off the chasm edge, with a frightened man on top: Udo. Below the chasm edge on the east side, a cut stair drops to the **lower ledge** where the chasm climb begins. In the boss fight she holds the air over the saddle and the chasm, and lands on the tower stump or the saddle for ground phases.

### 3.2 The Chasm Climb (`zone.roost_chasm_climb`)
A traverse down, across and up the chasm, along dwarven works:
- **Climb bottom:** the lower ledge.
- **Chain-walk:** 50 m of dwarven hand-chains bolted along the chasm wall over a 1 m ledge, with ice in places (walk only). It is exposed: if she is hostile, this is where she stoops.
- **Fallen span:** a section of the sky-bridge wedged across the chasm 30 m down, an angled crawlway of dressed stone with gaps.
- **Ice chimney:** a vertical cleft on the far side with steps cut into the ice. A series of dwarven iron ladders (door-type interactions) climbs it.
- **Wind shelf:** an exposed shelf two-thirds of the way up. Strong gusts. A second stoop point.
- **Chasm top:** a cut stair onto the Weeping Gate's ledge. This is the exit.

```yaml zone
id: zone.wyverns_roost
name: "Wyvern's Roost"
kind: exterior
map_node: map.stairs_foot
time_of_day: day
cold_rate: 4
disguise_tag: null
music: roost_wind
areas:
  - {id: saddle_south, description: "Wind-packed snow saddle, 40 m wide, between two rock shoulders; arrival from the ridge path."}
  - {id: tower_ruin, description: "8 m stump of a dwarven watch-tower; four fallen pillars round its base (stoop cover)."}
  - {id: nest_approach, description: "Rubble ramp up the east side of the stump."}
  - {id: nest_shelf, description: "Basalt shelf on the stump: nest of pine boughs and wool, three eggs, sheep skulls, a strip of grey robe."}
  - {id: choir_camp, description: "West of the tower: a collapsed tent, an alchemist's kit, two dead monks."}
  - {id: chasm_edge, description: "Broken stub of the dwarven sky-bridge; chains hanging into a 60 m chasm; the Weeping Gate visible on the far cliff."}
  - {id: udo_pillar, description: "A 30 m rock pillar off the chasm edge, 6 m from it; a man on top, wrapped in a blanket."}
  - {id: lower_ledge, description: "Cut stair below the chasm edge's east side; start of the chasm climb."}
spawns:
  - {id: saddle_south, area: saddle_south, default: true}
  - {id: wyvern_perch, area: nest_shelf}
  - {id: chasm_edge, area: chasm_edge}
exits:
  - id: to_climb
    area: lower_ledge
    to_zone: zone.roost_chasm_climb
    to_spawn: climb_bottom
    condition: "true"
    effects: []
  - id: back_to_ice
    area: saddle_south
    to_zone: zone.stairs_ice_bridges
    to_spawn: ridge_path_end
    condition: "true"
    effects: []
interactables:
  - id: ride_wyvern
    area: chasm_edge
    kind: door
    label: "Climb onto her back"
    condition: "in_party(ally.wyvern)"
    check: null
    once: false
    effects: ["play_beat(wyvern_flight)", "goto_zone(zone.ko_weeping_gate, wyvern_landing)"]
    fail_effects: []
  - id: udo_chain
    area: chasm_edge
    kind: lever
    label: "Swing the old sky-bridge chain across to the pillar"
    condition: "not flag(flag.udo_resolved)"
    check: null
    once: true
    effects: ["play_beat(udo_crosses)", "start_dialogue(dlg.udo)"]
    fail_effects: []
  - id: alchemist_kit
    area: choir_camp
    kind: readable
    label: "Go through the alchemist's kit"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.udo_reagent_notes, 1)"]
    fail_effects: []
  - id: dead_monks
    area: choir_camp
    kind: container
    label: "Search the dead monks"
    condition: "true"
    check: null
    once: true
    effects: []
    fail_effects: []
  - id: nest_eggs_after
    area: nest_shelf
    kind: search
    label: "Look at the nest"
    condition: "flag(flag.wyvern_slain)"
    check: null
    once: true
    effects: ["play_beat(orphan_clutch)"]
    fail_effects: []
triggers:
  - id: she_watches
    area: saddle_south
    "on": enter
    source: null
    condition: "not flag(flag.roost_resolved)"
    once: true
    effects: ["set_checkpoint(saddle)", "play_beat(she_watches)"]
  - id: warband_parts
    area: saddle_south
    "on": enter
    source: null
    condition: "in_party(ally.strept_warband)"
    once: true
    effects: ["play_beat(warband_parts)"]
  - id: standoff
    area: nest_approach
    "on": enter
    source: null
    condition: "has_item(item.wyvern_eggs) and not flag(flag.roost_resolved)"
    once: false
    effects: ["start_dialogue(dlg.wyvern_standoff)"]
  - id: nest_attack
    area: nest_approach
    "on": enter
    source: null
    condition: "not has_item(item.wyvern_eggs) and not flag(flag.roost_resolved)"
    once: false
    effects: ["set_checkpoint(saddle)", "play_beat(nest_rage)", "start_encounter(enc.roost_wyvern)"]
hazards:
  - {id: chasm_drop, area: chasm_edge, kind: collapse, params: {fall: lethal}}
  - {id: saddle_wind, area: saddle_south, kind: cold, params: {gust_every_s: [12, 18], push_m: 1.5}}
checkpoints:
  - {id: saddle, area: saddle_south}
beats:
  - {id: she_watches, description: "She is on the tower stump, wings half-mantled, head low. She watches the player cross the saddle and does not move. Three eggs behind her. Sheep skulls."}
  - {id: warband_parts, description: "Corra points with her spear around the mountain's shoulder. 'The main portal's that way. We'll make them think we're the army. Go in by your door, lowlander.' The highlanders lope off into the snow."}
  - {id: nest_rage, description: "She rises with a shriek that shakes snow off the ruin, tail high, the stinger beaded."}
  - {id: eggs_scented, description: "Her head snaps round as the player steps on the ramp. Nostrils flare. She knows what is in the pack."}
  - {id: eggs_returned, description: "The player sets the two eggs down. She noses each one, rolls them into the nest with her snout, wraps her tail around all five, and lowers her head to the player's height."}
  - {id: wyvern_flight, description: "She crouches. The player climbs to the hollow behind her wing-roots, hands in the ruff. Three wingbeats and the chasm is under them; the Weeping Gate's ledge rushes up. She lands, waits for the player to slide off, and is gone."}
  - {id: udo_crosses, description: "The old chain swings, catches on the pillar's lip. A thin man in a filthy grey robe inches across it on his belly and collapses at the player's feet."}
  - {id: udo_given, description: "The player shoves Udo toward the nest. She does not hesitate."}
  - {id: orphan_clutch, description: "Three eggs, cooling. With the two the player carries, five. Nothing on this mountain will hatch them now."}
npcs:
  - {npc: npc.wyvern, area: nest_shelf, condition: "not flag(flag.wyvern_slain) and not flag(flag.wyvern_eggs_returned)"}
encounters: [enc.roost_wyvern]
loot:
  - {container: dead_monks, items: [{item: item.pale_feather, count: 2}, {item: item.antitoxin, count: 2}, {item: item.crossbow_bolt, count: 8}], condition: "true"}
variants:
  - id: roost_peace
    when: "flag(flag.wyvern_eggs_returned)"
    description: "She lies curled around the nest; she lifts her head when the player passes, nothing more."
    npcs_absent: []
    encounters_disabled: [enc.roost_wyvern]
    interactables_disabled: []
  - id: roost_slain
    when: "flag(flag.wyvern_slain)"
    description: "Her body across the saddle, wings broken; snow already settling on her."
    npcs_absent: [npc.wyvern]
    encounters_disabled: [enc.roost_wyvern]
    interactables_disabled: [ride_wyvern]
  - id: scarred
    when: "flag(flag.wyvern_fought)"
    description: "A healed crossbow tear through her left wing membrane; she tracks the player's crossbow, not their face."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
```

```yaml zone
id: zone.roost_chasm_climb
name: "The Collapsed Chasm"
kind: exterior
map_node: map.stairs_foot
time_of_day: day
cold_rate: 5
disguise_tag: null
music: roost_wind
areas:
  - {id: climb_bottom, description: "Lower ledge under the chasm edge; dwarven bolts in the wall."}
  - {id: chain_walk, description: "50 m of hand-chains over a 1 m ledge along the chasm wall; ice patches; exposed to the sky."}
  - {id: fallen_span, description: "A section of the sky-bridge wedged 30 m down; dressed stone at a 20 degree angle, gaps to step over."}
  - {id: ice_chimney, description: "Vertical cleft on the far side; steps cut in the ice and three dwarven iron ladders."}
  - {id: wind_shelf, description: "Exposed shelf two-thirds up; gusts; a second stoop point."}
  - {id: chasm_top, description: "Cut stair onto the Weeping Gate's ledge."}
spawns:
  - {id: climb_bottom, area: climb_bottom, default: true}
  - {id: sky, area: chain_walk}
  - {id: chasm_top_return, area: chasm_top}
exits:
  - id: to_weeping_gate
    area: chasm_top
    to_zone: zone.ko_weeping_gate
    to_spawn: chasm_top
    condition: "true"
    effects: ["set_flag(flag.roost_resolved)", "reach_milestone(ms.a3_roost_resolved)"]
  - id: back_to_roost
    area: climb_bottom
    to_zone: zone.wyverns_roost
    to_spawn: chasm_edge
    condition: "true"
    effects: []
interactables:
  - id: ladder_1
    area: ice_chimney
    kind: door
    label: "Climb the first iron ladder"
    condition: "true"
    check: null
    once: false
    effects: ["play_beat(ladder_climb)"]
    fail_effects: []
  - id: ladder_2
    area: ice_chimney
    kind: door
    label: "Climb the second iron ladder"
    condition: "true"
    check: null
    once: false
    effects: ["play_beat(ladder_climb)"]
    fail_effects: []
  - id: ladder_3
    area: wind_shelf
    kind: door
    label: "Climb the last ladder to the top"
    condition: "true"
    check: null
    once: false
    effects: ["play_beat(ladder_climb)"]
    fail_effects: []
  - id: span_cache
    area: fallen_span
    kind: container
    label: "A dwarven tool-box wedged in the span"
    condition: "true"
    check: null
    once: true
    effects: []
    fail_effects: []
triggers:
  - id: harry_begins
    area: chain_walk
    "on": enter
    source: null
    condition: "not flag(flag.wyvern_slain) and not flag(flag.wyvern_eggs_returned)"
    once: true
    effects: ["set_checkpoint(climb_start)", "play_beat(she_stoops)", "start_encounter(enc.climb_wyvern_harry)"]
hazards:
  - {id: chasm_fall, area: chain_walk, kind: collapse, params: {fall: lethal}}
  - {id: icefall, area: fallen_span, kind: collapse, params: {damage: 25, telegraph_s: 1.0, sites: 3}}
  - {id: shelf_gusts, area: wind_shelf, kind: cold, params: {gust_every_s: [8, 12], push_m: 1.0, chill_per_second: 6}}
checkpoints:
  - {id: climb_start, area: climb_bottom}
  - {id: span_middle, area: fallen_span}
  - {id: chimney_top, area: wind_shelf}
beats:
  - {id: she_stoops, description: "A shadow over the chain-walk. She comes down the chasm like a thrown axe, tail first, and rakes the wall a metre above the player's head."}
  - {id: ladder_climb, description: "Rungs iced over; the player climbs hand over hand (2 s, interruptible by a stoop)."}
  - {id: she_gives_up, description: "On the wind shelf she makes one last pass, screams, and turns back to her nest."}
npcs: []
encounters: [enc.climb_wyvern_harry]
loot:
  - {container: span_cache, items: [{item: item.fire_oil, count: 2}, {item: item.field_draught, count: 2}], condition: "true"}
variants:
  - id: no_wyvern
    when: "flag(flag.wyvern_slain) or flag(flag.wyvern_eggs_returned)"
    description: "Only wind on the climb."
    npcs_absent: []
    encounters_disabled: [enc.climb_wyvern_harry]
    interactables_disabled: []
```

## 4. NPCs present

```yaml npc
id: npc.wyvern
name: "The wyvern"
faction: null
role: "Mountain wyvern of the Old Grey Matron; the Tigg livestock-taker; mother of the stolen eggs"
motive: "Keep her clutch alive. Get back what was taken."
secret: null
disposition: hostile
essential: false
dialogue: dlg.wyvern_standoff
barks: []
combat: enemy.wyvern_roost
shop: null
```
*Voice:* no words. Hisses, rattles, a bellows-like growl, and one high scream. Her "lines" in dialogue are sound transcriptions, with body language in `direction`.

```yaml npc
id: npc.brother_udo
name: "Brother Udo"
faction: faction.choir
role: "Choir alchemist; led the party that stole the wyvern's eggs"
motive: "Get off this mountain alive."
secret: "He did not believe in Anselm's purpose. He joined for the laboratory and the silver."
disposition: friendly
essential: false
dialogue: dlg.udo
barks: ["She's been circling for days. Days!", "I'm a chemist, not a fanatic.", "Don't let her see me."]
combat: null
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.wyvern_standoff
participants: [npc.wyvern]
start: open
nodes:
  open:
    type: line
    speaker: npc.wyvern
    text: "Hhhhhhhsss."
    direction: "She drops off the stump onto the ramp in one movement, wings half-spread, and puts her head a yard from the player's. Her eyes go to the pack."
    effects: ["play_beat(eggs_scented)"]
    next: hub
  hub:
    type: choice
    options:
      - id: eggs
        text: "[Item: Wyvern eggs] Unwrap the eggs. Set them down slowly."
        tag: item
        condition: "has_item(item.wyvern_eggs)"
        next: eggs_down
      - id: sheathe
        text: "Lower your weapon. Stand still."
        once: true
        next: still
      - id: fight
        text: "Draw steel."
        next: fight
      - id: back
        text: "Back away down the ramp."
        next: back
  still:
    type: line
    speaker: npc.wyvern
    text: "Krrrrrr."
    direction: "The rattle in her throat drops a note. She doesn't attack. She doesn't move either. Her eyes stay on the pack."
    next: hub
  eggs_down:
    type: line
    speaker: npc.wyvern
    text: "Hhh. Krrrr."
    direction: "She noses each egg, rolls them up the ramp with her snout, curls around the nest. Then she lowers her head to the player's height and stays there."
    effects: ["take_item(item.wyvern_eggs, 1)", "set_flag(flag.wyvern_eggs_returned)", "set_flag(flag.roost_resolved)", "add_ally(ally.wyvern)", "play_beat(eggs_returned)", "reach_milestone(ms.a3_roost_resolved)", "add_xp(800)"]
    next: bye
  fight:
    type: effect
    effects: ["set_checkpoint(saddle)", "play_beat(nest_rage)", "start_encounter(enc.roost_wyvern)"]
    next: bye
  back:
    type: line
    speaker: npc.wyvern
    text: "Hsss."
    direction: "She lets the player go, watching every step."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.udo
participants: [npc.brother_udo]
start: open
nodes:
  open:
    type: line
    speaker: npc.brother_udo
    text: "Water. No. Don't. First get me away from the edge. She hasn't eaten since she caught Brother Fenno, and that was two blizzards ago."
    direction: "Grey-faced, frostbitten, a wool blanket over a torn Choir robe."
    effects: ["set_flag(flag.udo_resolved)"]
    next: hub
  hub:
    type: choice
    options:
      - id: eggs
        text: "Why did you take her eggs?"
        once: true
        next: eggs
      - id: anselm
        text: "What did Anselm want them for?"
        once: true
        next: anselm
      - id: weak
        text: "If Anselm breathes the vault fumes, what happens to him?"
        condition: "has_clue(clue.ash_reagent) or has_clue(clue.anselm_breathes_ash)"
        once: true
        next: weak
      - id: go
        text: "Go down the mountain. Don't stop until you're out of Cintra."
        next: go
      - id: feed
        text: "She hasn't eaten in a while, you said."
        condition: "flag(flag.wyvern_eggs_returned)"
        next: feed
      - id: leave
        text: "You can find your own way down."
        next: leave
  eggs:
    type: line
    speaker: npc.brother_udo
    text: "Wyvern yolk is half sulphur. Rendered down, it coats the lungs. Like tarring a ship's hull. You can breathe filth through it for an hour and not die. Probably."
    next: hub
  anselm:
    type: line
    speaker: npc.brother_udo
    text: "The vaults breathe out when the lock opens. Corvan's dwarves made shock-troops with that air. Ash-breath. The Abbot means to stand in it and drink it, and come out the way they did."
    effects: ["add_clue(clue.ash_reagent)"]
    next: hub
  weak:
    type: line
    speaker: npc.brother_udo
    text: "The lungs swell. The ribs open at the back like a bellows to make room. The old drawings show it. If you must hit him, hit him there, between the shoulders, where it pumps."
    effects: ["add_clue(clue.zealot_bellows_lung)"]
    next: hub
  go:
    type: line
    speaker: npc.brother_udo
    text: "I will. I swear it. I never believed a word of his sermons, you know. I only wanted the laboratory."
    effects: ["set_flag(flag.udo_freed)", "add_xp(60)"]
    next: bye
  feed:
    type: line
    speaker: npc.brother_udo
    text: "What? No. No, wait, I can be useful, I can..."
    direction: "The player looks at the nest. The wyvern is already looking back."
    effects: ["set_flag(flag.udo_fed_to_wyvern)", "play_beat(udo_given)"]
    next: bye
  leave:
    type: line
    speaker: npc.brother_udo
    text: "In this? Alone? That's murder with extra steps."
    effects: ["set_flag(flag.udo_abandoned)"]
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.roost_wyvern
zone: zone.wyverns_roost
enemies:
  - {enemy: enemy.wyvern_roost, count: 1, spawn: wyvern_perch, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: saddle
avoidable_by: ["dlg.wyvern_standoff"]
on_won: ["set_flag(flag.wyvern_slain)", "set_flag(flag.roost_resolved)", "reach_milestone(ms.a3_roost_resolved)"]
on_yielded: []
on_player_fled: []
```

Boss design, in arena terms:
- **Air phase** (opening, and again at 66% and 33% HP): she circles the saddle and chasm at 25–30 m and stoops every 7–9 s. The fallen pillars block stoops: a stoop that would pass through a pillar aborts, and she pulls up. A crossbow weak-point hit on a wing grounds her for 4 s (gdd §6.7). A gust (`saddle_wind`) pushes the player 1.5 m toward the chasm every 12–18 s, so fighting near the edge is a mistake.
- **Ground phase:** tail sting (poison), wing buffets (knockback 3 m), a bite with a 1.0 s tell, and a nest-guard rage: within 6 m of the nest shelf, her damage is +25% and she does not take to the air.
- She does **not** flee at 50% here (unlike Tigg). She fights to the death at her nest.
- If the player leaves the zone (back to the Ice Bridges, or down to the climb), the fight ends with no result. She returns to the nest and her HP resets.
- Fire oil, and the torch flinch if `flag.wyvern_driven_by_smoke`, deal normal damage. They are not weaknesses.

```yaml encounter
id: enc.climb_wyvern_harry
zone: zone.roost_chasm_climb
enemies:
  - {enemy: enemy.wyvern_roost, count: 1, spawn: sky, variant: harry}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: climb_start
avoidable_by: []
on_won: ["set_flag(flag.wyvern_slain)"]
on_yielded: []
on_player_fled: []
```

The `harry` variant is air-only and makes 4 scripted stoop passes: two on the chain-walk, one on the fallen span, one on the wind shelf. Each has a 1.2 s shadow-and-shriek tell. A stoop hit deals 34 damage and staggers. On the chain-walk, a hit while the player is standing next to a chain anchor is survivable, while a hit on an open stretch knocks the player off (death). The anchors are 6–8 m apart, so the player reads the tell and moves to the next anchor. After the wind-shelf pass she gives up (beat `she_gives_up`) and the encounter ends with no result. A crossbow wing hit during a pass makes her abort that pass. Killing her from the climb is possible but unlikely (900 HP). If it happens, `on_won` marks her slain.

## 7. Items and clues

```yaml item
id: item.udo_reagent_notes
name: "Udo's reagent notes"
category: document
description: "An alchemist's day-book, frost-stiffened, the last pages written with a shaking hand."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Yolk of wyvern, 2 eggs, render to sulphur-paste, cut with lily-root for the cough. Dose for one man, one hour of ash-breath. Abbot insists on the full hour. Brother Fenno taken this morning. Mother circles. Cannot reach the eggs. Cannot reach the camp. The pillar is cold. If anyone finds this: we deserved it. Not the Abbot. Us. We knew what the eggs were for."
```

```yaml clue
id: clue.ash_reagent
theory: theory.anselm_plan
title: "Ash-breath"
text: "When the lock opens, the deep vaults vent the same alchemical 'ash-breath' that Corvan's dwarves used to make their shock-troops. Anselm means to breathe it and become one. The stolen wyvern eggs were meant to coat his lungs against it."
supports: [anselm]
refutes: []
```

```yaml clue
id: clue.zealot_bellows_lung
theory: theory.anselm_plan
title: "Where it pumps"
text: "A man who drinks the ash-breath grows lungs like a smith's bellows. The ribs open at the back to make room. Strike between the shoulders, where it pumps."
supports: [anselm]
refutes: []
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.a3_roost_resolved, type: milestone, desc: "The player crossed the chasm past Wyvern's Roost (eggs returned, wyvern slain, or the climb)."}
  - {id: flag.roost_resolved, type: bool, desc: "The Roost is resolved. Read by A07 travel card M4 (wyvern circling)."}
  - {id: flag.wyvern_eggs_returned, type: bool, desc: "The eggs were returned; ally.wyvern added (epilogue variant)."}
  - {id: flag.wyvern_slain, type: bool, desc: "The wyvern was killed (epilogue variant)."}
  - {id: flag.udo_resolved, type: bool, desc: "Udo was brought off his pillar."}
  - {id: flag.udo_freed, type: bool, desc: "Udo was sent down the mountain."}
  - {id: flag.udo_fed_to_wyvern, type: bool, desc: "The player gave Udo to the wyvern."}
  - {id: flag.udo_abandoned, type: bool, desc: "The player left Udo to find his own way."}
reads:
  - item.wyvern_eggs
  - flag.wyvern_fought
  - flag.wyvern_driven_by_smoke
  - ally.strept_warband
```

## 9. Quest hooks

```yaml quest_stages
quest: quest.main_a3
order: 40
stages:
  - id: the_upper_ridge
    journal: "The sky-bridge to the Weeping Gate is down. The wyvern from Tigg nests on the ridge, short two eggs. I may be carrying them."
    objectives:
      - {id: across, text: "Cross the chasm to the Weeping Gate", condition: "ms(ms.a3_roost_resolved) or ms(ms.a3_ostrel_entered)", optional: false}
      - {id: eggs_home, text: "Return the wyvern's eggs", condition: "flag(flag.wyvern_eggs_returned)", optional: true, xp: 100}
      - {id: reagent, text: "Learn what the eggs were for", condition: "has_clue(clue.ash_reagent)", optional: true, xp: 40}
    on_complete: []
    next: []
```

## 10. Rumors and event cards (optional)
None. A07's travel card M4 (wyvern circling) should test `not flag(flag.roost_resolved)`, which this section declares.

## 11. Failure states and branches

```yaml branches
paths:
  - id: return_eggs
    when: "has_item(item.wyvern_eggs), the player sets them down at the stand-off."
    outcome: "ally.wyvern; she flies the player to the Weeping Gate's ledge (skips the climb)."
    sets: ["set_flag(flag.wyvern_eggs_returned)", "add_ally(ally.wyvern)", "reach_milestone(ms.a3_roost_resolved)"]
  - id: slay
    when: "The player fights her (no eggs at the nest, or 'Draw steel')."
    outcome: "Boss fight; then the chasm climb with no harrying."
    sets: ["set_flag(flag.wyvern_slain)", "reach_milestone(ms.a3_roost_resolved)"]
  - id: slip_past
    when: "The player avoids the nest and takes the lower ledge."
    outcome: "Chasm climb with 4 stoop passes; topping the climb resolves the Roost."
    sets: ["set_flag(flag.roost_resolved)", "reach_milestone(ms.a3_roost_resolved)"]
  - id: udo
    when: "The player swings the chain to Udo's pillar."
    outcome: "clue.ash_reagent and clue.zealot_bellows_lung (finale weak point); free, abandon, or feed him to the wyvern (after the eggs)."
    sets: ["set_flag(flag.udo_resolved)"]
failures:
  - id: player_dies
    result: reload_checkpoint
    recover: "Reload saddle, climb_start, span_middle or chimney_top."
  - id: knocked_off_chain_walk
    result: reload_checkpoint
    recover: "Reload climb_start."
guarantees:
  - "ms.a3_roost_resolved needs no check: the chasm climb's exit sets it, and the climb is always open from the lower ledge."
```

## 12. Open questions
- **Talking to an animal.** The stand-off is a `dialogue` whose speaker is the wyvern. Her lines are sound transcriptions, which follows the "no stage directions in text" rule as written. If the converter or UI wants no subtitle for non-speech, flag the npc as `non_verbal`.
- **Peaceful XP.** Returning the eggs grants `add_xp(800)`, equal to `enemy.wyvern_roost.xp`, to honour the gdd's "a fight skipped... awards the same XP" spirit, even though this is not a dialogue skip in the strict sense.
- **Zone leave resets a boss.** Leaving mid-fight resets her HP. This follows gdd §6.16 ("Enemies killed in the current zone visit are not saved"); please confirm it applies to boss HP too.
- **Ladders as doors.** The control scheme has no jump or climb verb. Ladders are `door` interactables with a 2 s climb beat.
