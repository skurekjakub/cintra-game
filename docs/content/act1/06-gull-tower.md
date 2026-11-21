---
section_id: a1.06
title: "Gull Tower Goes Dark"
act: 1
story_ref: "story.md §3 (Raimund's secret), §5.6; gdd.md §6.9 (bulbs +2), §6.11 (ded.poison_via_attre), §7.1 #6, §7.5 (cintra-gull_tower edge)"
zones: [zone.gull_tower, zone.gull_tower_cellar]
available_when: "ms(ms.a1_audience_done)"
escalation_stage_required: {min: 0, max: 1}
milestones_set: [ms.a1_gull_done]
milestones_read: [ms.a1_audience_done, ms.a1_gull_done]
level_band: [3, 4]
---

# Gull Tower Goes Dark

## 1. Scene summary

The signal light on Gull Tower, a coastal watchtower on a headland west of the Yaruga mouth, has been dark for three nights, and the fishing boats come home by guesswork. Hale walks out along the cliffs and finds the keeper, Aud Harrow, dead by his own well with his throat cut, his goat dead in the gorse, and smugglers from Attre warming their hands at his fire while they wait for the tide. In the tower cellar, which opens on a sea cave, their captain Joaquim Seixal is loading crates into a lugger. The crates hold grey lily bulbs, the same poison that is in the Queen's cup, packed in straw under the brand of Attre Light, Duke Raimund's port. Hale can fight through, cut the smugglers' boat loose and bargain from strength, frighten or talk Seixal into surrender, or take his silver and let him sail. The keeper's widow, Nessa, is barricaded in the lamp room; saving her and relighting the beacon is a small kindness that the coast will remember. The dramatic question: *where does the poison come from?* The answer: through Duke Raimund's ports. The section ends when Hale learns what the crates hold (`ms.a1_gull_done`).

## 2. Progress and escalation

- Optional. Open from `ms.a1_audience_done` until escalation stage 2 (gdd §7.1: "Gull Tower stays open until stage 2"), so it can be played after the Fair, early in Act II.
- `ms.a1_gull_done` fires when Hale gains `clue.gull_bulbs`: from the crates (`cellar_crates`, no check) or, if Seixal was bribed and sailed with the crates, from the bill of lading he leaves behind (`bill_of_lading`, no check). The two are mutually exclusive. It pays `add_xp(200)`.
- With `clue.chalice_pollen` (section 3), `clue.gull_bulbs` unlocks `ded.poison_via_attre`.
- Bulbs: taking the last crate gives `item.grey_lily_bulbs` ×2 (gdd §6.9: Gull Tower +2), returned to Wenna in Act II (A05 counts them into `var.bulbs_recovered`). Burning the crates destroys them.
- Stage 1 variant: if played after the Fair, the smugglers are more numerous and nervous (variant `stage1_gull`: +1 smuggler in the yard, gdd §6.1 does not require it but Act II levels need it).

## 3. Location layout

### 3.1 Gull Tower (`zone.gull_tower`)

A round stone watchtower, four storeys, on a gorse headland 40 m above the sea. Dusk look: the sun going down red behind the tower, the beacon cold. About 90 × 70 m.

```
  [headland_path] (E, from the coast road) --- gorse, dead goat --- [tower_yard gate]
        \                                                   | yard: well (keeper's body), cart, fire with smugglers
         \--- cliff_steps (cut into the cliff, down to the cove) --> sea cave (cellar zone)
                                                            |
                                                     keeper_cottage (log book)
                                                     tower_ground (stores, cellar door)
                                                     tower_stair (spiral)
                                                     lamp_room (beacon brazier; Nessa barricaded)
```

- **headland_path**: the coast road ends in a sheep-track through gorse to the tower. The keeper's goat lies dead in the gorse, shot with a crossbow bolt. Spawn from the map.
- **tower_yard**: a dry-stone-walled yard. A **well**, with Aud Harrow's body slumped against it. A handcart. A fire in a ring of stones where three smugglers sit dicing and drinking the keeper's ale, crossbows propped against the wall. Low walls and the cart are cover. The yard gate faces the path.
- **keeper_cottage**: one room against the tower's flank: a cot, a table, the **keeper's log** (readable), a shelf.
- **tower_ground**: the tower's ground floor: rope, oil casks for the beacon, the **cellar door** (exit down to `zone.gull_tower_cellar`).
- **tower_stair**: a spiral up the tower wall, arrow slits.
- **lamp_room**: the top: a great iron beacon basket, unlit, a stack of oiled wood. The trapdoor is barricaded from below with a chest; Nessa Harrow is behind it with a boathook.
- **cliff_steps**: a narrow stair cut into the cliff face from the headland, down to the cove (exit to the cellar zone's `sea_cave`). Wind, spray. No railing: a misstep near the edge costs health (trap hazard, avoidable by walking the inner side).

### 3.2 The cellar and sea cave (`zone.gull_tower_cellar`)

- **cellar**: a vaulted cellar under the tower. Crates stacked to the ceiling once; now only a few remain. A ramp at the far end goes down through rock into the sea cave. Seixal and two men are carrying crates.
- **sea_cave**: a natural cave with a shingle beach, the tide sloshing in. The lugger *Dorada* is moored to an iron ring, half-loaded. A rock ledge leads up to the cliff steps (exit up to the headland).

```yaml zone
id: zone.gull_tower
name: "Gull Tower"
kind: exterior
map_node: map.gull_tower
time_of_day: dusk
cold_rate: 0
disguise_tag: null
music: coast_wind
areas:
  - {id: headland_path, description: "Sheep-track through gorse from the coast road. The keeper's goat dead with a bolt in it."}
  - {id: tower_yard, description: "Dry-stone yard. Well with the keeper's body, a handcart, a fire with three dicing smugglers. Low walls and cart = cover."}
  - {id: keeper_cottage, description: "One room against the tower. Cot, table, the keeper's log, a shelf."}
  - {id: tower_ground, description: "Ground floor stores: rope, beacon oil casks, the cellar door."}
  - {id: tower_stair, description: "Spiral up the tower wall, arrow slits."}
  - {id: lamp_room, description: "Top floor. Iron beacon basket, oiled wood. Trapdoor barricaded from below by Nessa."}
  - {id: cliff_steps, description: "Narrow stair cut in the cliff from the headland to the cove. No railing, wind and spray."}
spawns:
  - {id: headland_path, area: headland_path, default: true}
  - {id: cellar_door, area: tower_ground, default: false}
  - {id: cliff_foot, area: cliff_steps, default: false}
  - {id: yard_fire, area: tower_yard, default: false}
exits:
  - id: to_cellar
    area: tower_ground
    to_zone: zone.gull_tower_cellar
    to_spawn: tower_stair
    condition: "true"
    effects: []
  - id: to_cove
    area: cliff_steps
    to_zone: zone.gull_tower_cellar
    to_spawn: sea_cave
    condition: "true"
    effects: []
interactables:
  - id: map_leave
    area: headland_path
    kind: map_board
    label: "Back to the coast road"
    condition: "true"
    check: null
    once: false
    effects: []
  - id: keeper_body
    area: tower_yard
    kind: search
    label: "Search the keeper's body"
    condition: "flag(flag.gull_yard_clear)"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["play_beat(keeper_wounds)", "set_flag(flag.keeper_examined)"]
    fail_effects: ["play_beat(keeper_plain)"]
  - id: keeper_log
    area: keeper_cottage
    kind: readable
    label: "The keeper's log"
    condition: "true"
    check: null
    once: false
    effects: ["give_item(item.gull_keeper_log, 1)"]
  - id: cottage_shelf
    area: keeper_cottage
    kind: container
    label: "Shelf"
    condition: "true"
    check: null
    once: true
    effects: []
  - id: lamp_trapdoor
    area: tower_stair
    kind: door
    label: "Call up through the trapdoor"
    condition: "not flag(flag.nessa_saved)"
    check: null
    once: false
    effects: ["start_dialogue(dlg.nessa)"]
  - id: beacon
    area: lamp_room
    kind: lever
    label: "Light the beacon"
    condition: "flag(flag.nessa_saved) and not flag(flag.gull_beacon_lit)"
    check: null
    once: true
    effects: ["set_flag(flag.gull_beacon_lit)", "play_beat(beacon_lit)", "add_rep(faction.crown, 5)", "add_xp(50)"]
triggers:
  - id: t_gull_enter
    area: headland_path
    on: enter
    source: null
    condition: "not visited(zone.gull_tower)"
    once: true
    effects: ["set_checkpoint(gull_path)", "play_beat(dark_tower)"]
  - id: t_yard_fight
    area: tower_yard
    on: enter
    source: null
    condition: "not flag(flag.gull_yard_clear) and not flag(flag.gull_yard_engaged)"
    once: false
    effects: ["set_checkpoint(gull_yard)", "set_flag(flag.gull_yard_engaged)", "play_beat(smugglers_rise)", "start_encounter(enc.gull_yard)"]
hazards:
  - {id: cliff_edge, area: cliff_steps, kind: trap, params: {effect: fall, damage_pct_max_hp: 25, avoid_by: inner_side, respawn_at: cliff_foot}}
checkpoints:
  - {id: gull_path, area: headland_path}
  - {id: gull_yard, area: tower_yard}
beats:
  - {id: dark_tower, description: "The tower stands black against a red sky, its beacon cold. Gulls wheel and cry. In the gorse, the keeper's goat, a crossbow bolt through its neck. Laughter and the click of dice from the yard."}
  - {id: smugglers_rise, description: "Three men at the keeper's fire, Attre sea-coats, gold rings in their ears. 'Shit. Visitors.' They grab crossbows and cudgels."}
  - {id: keeper_wounds, description: "Aud Harrow, sixty, throat cut from behind with one stroke. Knuckles split: he fought. Under his nails, a thread of blue sailcloth. In his fist, a crumpled crate label: a lighthouse brand, ATTRE LIGHT."}
  - {id: keeper_plain, description: "An old man, killed from behind. The gulls have been at him."}
  - {id: beacon_lit, description: "Nessa thrusts a torch into the oiled wood and the beacon roars up. Far out on the dark water, one, two, five fishing boats turn their bows toward the light."}
npcs:
  - {npc: npc.nessa_harrow, area: lamp_room, condition: "true"}
encounters: [enc.gull_yard]
loot:
  - {container: cottage_shelf, items: [{item: item.poultice, count: 2}, {item: item.crossbow_bolt, count: 6}], condition: "true"}
variants:
  - id: yard_clear
    when: "flag(flag.gull_yard_clear)"
    description: "The yard fire burns low. The smugglers dead, gone or tied to the cart."
    npcs_absent: []
    encounters_disabled: [enc.gull_yard]
    interactables_disabled: []
  - id: after_gull
    when: "ms(ms.a1_gull_done) and flag(flag.gull_beacon_lit)"
    description: "The beacon burns. A fishing family has come up from the cove to help Nessa bury Aud. They nod to Hale."
    npcs_absent: []
    encounters_disabled: [enc.gull_yard]
    interactables_disabled: []
```

```yaml zone
id: zone.gull_tower_cellar
name: "Gull Tower Cellar and Sea Cave"
kind: dungeon
map_node: map.gull_tower
time_of_day: night
cold_rate: 0
disguise_tag: null
music: cave_tide
areas:
  - {id: cellar, description: "Vaulted cellar, a few crates left, lanterns, a ramp down through rock to the sea cave."}
  - {id: sea_cave, description: "Shingle beach, tide sloshing, the lugger Dorada moored to an iron ring, half-loaded. Rock ledge up to the cliff steps."}
spawns:
  - {id: tower_stair, area: cellar, default: true}
  - {id: sea_cave, area: sea_cave, default: false}
  - {id: crate_stack, area: cellar, default: false}
exits:
  - id: up_tower
    area: cellar
    to_zone: zone.gull_tower
    to_spawn: cellar_door
    condition: "true"
    effects: []
  - id: up_cliff
    area: sea_cave
    to_zone: zone.gull_tower
    to_spawn: cliff_foot
    condition: "true"
    effects: []
interactables:
  - id: mooring_line
    area: sea_cave
    kind: lever
    label: "Cut the Dorada's mooring line"
    condition: "not flag(flag.dorada_cut) and not flag(flag.gull_cellar_clear)"
    check: null
    once: true
    effects: ["set_flag(flag.dorada_cut)", "play_beat(dorada_drifts)"]
  - id: cellar_crates
    area: cellar
    kind: search
    label: "Break open a crate"
    condition: "flag(flag.gull_cellar_clear) and not flag(flag.seixal_bribed) and not has_clue(clue.gull_bulbs)"
    check: null
    once: true
    effects: ["add_clue(clue.gull_bulbs)", "play_beat(crates_opened)", "reach_milestone(ms.a1_gull_done)", "add_xp(200)", "start_dialogue(dlg.gull_crates_choice)"]
  - id: bill_of_lading
    area: cellar
    kind: pickup
    label: "A paper trodden into the floor"
    condition: "flag(flag.seixal_bribed) and not has_clue(clue.gull_bulbs)"
    check: null
    once: true
    effects: ["give_item(item.gull_bill_of_lading, 1)", "add_clue(clue.gull_bulbs)", "reach_milestone(ms.a1_gull_done)", "add_xp(200)"]
triggers:
  - id: t_cellar_enter
    area: cellar
    on: enter
    source: null
    condition: "not flag(flag.gull_cellar_clear) and not flag(flag.gull_cellar_engaged)"
    once: false
    effects: ["set_checkpoint(gull_cellar)", "start_dialogue(dlg.seixal)"]
  - id: t_cave_enter
    area: sea_cave
    on: enter
    source: null
    condition: "not flag(flag.gull_cellar_clear) and not visited(zone.gull_tower_cellar)"
    once: true
    effects: ["play_beat(cave_unseen)"]
hazards:
  - {id: cave_tide, area: sea_cave, kind: tide, params: {static: true, depth: knee, speed_mult_in_water: 0.7}}
checkpoints:
  - {id: gull_cellar, area: cellar}
beats:
  - {id: cave_unseen, description: "Hale comes down the cliff ledge into the sea cave unseen. Lantern light and voices up the ramp. The lugger Dorada rocks at her mooring, half full of crates."}
  - {id: dorada_drifts, description: "The mooring line parts. The Dorada swings out on the ebb, crates and all, and drifts toward the cave mouth. A shout from the ramp: 'The boat! The boat!'"}
  - {id: crates_opened, description: "Straw, and in the straw, fat grey bulbs like garlic, dozens of them, smelling faintly of lilies. Each crate branded with a lighthouse: ATTRE LIGHT. Most crates have already gone; two bulbs' worth of good stock is left."}
  - {id: crates_burned, description: "Beacon oil over the straw, a torch, and the last crates go up with a sweet, sickening smoke. Nobody will poison a queen with these."}
  - {id: seixal_sails, description: "Seixal's men pole the Dorada out of the cave with the crates. He touches his cap. 'Compliments of Attre.' A paper flutters from his coat onto the cellar floor."}
npcs:
  - {npc: npc.seixal, area: cellar, condition: "not flag(flag.gull_cellar_clear)"}
encounters: [enc.gull_cellar]
loot: []
variants:
  - id: cellar_clear
    when: "flag(flag.gull_cellar_clear)"
    description: "Lanterns guttering, the ramp empty. The Dorada gone or drifting at the cave mouth."
    npcs_absent: [npc.seixal]
    encounters_disabled: [enc.gull_cellar]
    interactables_disabled: [mooring_line]
```

## 4. NPCs present

**Voice notes.**
- **Joaquim Seixal**: Attre sea-captain, forties, gold teeth, a charming Peixe lilt, calls everyone "senhor" or "senhora" whatever they are. Businesslike about murder.
- **Nessa Harrow**: the keeper's widow, sixties, coastal, tough, grief coming out as fury. Short sentences, salt in them.

```yaml npc
id: npc.seixal
name: "Joaquim Seixal"
faction: faction.attre
role: "Captain of the Attre lugger Dorada; smuggler on the Duke's coast run"
motive: "Get the last crates out before Cintran soldiers come looking for the dead keeper, and get paid in Port Peixe."
secret: "Works for the Duke's factor at Port Peixe. The bulbs were sold to grey-robed buyers who paid in silver; the factor said the Duke wanted no questions asked. Ordered the keeper killed when he saw the crates."
disposition: wary
essential: false
dialogue: dlg.seixal
barks: ["Easy, senhor. Business.", "Load faster, the tide doesn't wait!", "The Duke's compliments.", "Nobody needs to die. Again."]
combat: enemy.bandit
shop: null
```

```yaml npc
id: npc.nessa_harrow
name: "Nessa Harrow"
faction: null
role: "Widow of Gull Tower's keeper"
motive: "Live, see her husband's killers hang, and light the beacon he kept for thirty years."
secret: "Her mother was a hedge-herbalist; she knows grey lily as 'widow's-bell' and has heard of a marsh-woman in the south who grows it."
disposition: wary
essential: true
dialogue: dlg.nessa
barks: ["Thirty years he kept that light.", "Bury him facing the sea.", "Widow's-bell. Of course it is."]
combat: null
shop: null
```

## 5. Dialogue trees

### 5.1 Seixal in the cellar

The cellar parley always opens when Hale enters the cellar (from the tower stair or the cave). Cutting the *Dorada* loose first (`flag.dorada_cut`) strengthens every option.

```yaml dialogue
id: dlg.seixal
participants: [npc.seixal]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "flag(flag.dorada_cut)", next: open_cut}
    else: open
  open:
    type: line
    speaker: npc.seixal
    text: "Ah, senhor. You killed my lads in the yard, or got past them, either way impressive. Put that away. Let's talk like merchants. I'm almost loaded and almost gone."
    direction: "Seixal on the ramp with a lantern; two sailors behind him with a crate between them, hands drifting to knives."
    next: hub
  open_cut:
    type: line
    speaker: npc.seixal
    text: "That was my boat. That was my boat! You know what that boat cost? ...Fine. Fine, senhor. You have my attention."
    direction: "Seixal staring past Hale at the empty mooring ring."
    next: hub
  hub:
    type: choice
    options:
      - id: what
        text: "What's in the crates?"
        next: what
      - id: keeper
        text: "You killed the keeper."
        next: keeper
      - id: scare
        text: "The Marshal hangs smugglers off the Lion Gate. Murderers he hangs slowly. Drop it and walk. [Intimidate 6]"
        tag: intimidate
        check: {skill: intimidate, dc: 6, pass: surrender, fail: scare_fail}
        once: true
      - id: duke
        text: "When this comes out, your Duke will hang you himself to keep his hands clean. Give me the paper trail and live. [Persuade 6]"
        tag: persuade
        check: {skill: persuade, dc: 6, pass: talk, fail: duke_fail}
        once: true
      - id: stranded
        text: "Your boat's halfway to Attre without you. Surrender, or swim."
        condition: "flag(flag.dorada_cut)"
        next: surrender
      - id: take_bribe
        text: "Make me an offer."
        condition: "not flag(flag.dorada_cut)"
        next: offer
      - id: fight
        text: "No more talk."
        next: fight
  what:
    type: line
    speaker: npc.seixal
    text: "Medicine, senhor. Flower bulbs, for a physic garden. Very rare. Very expensive. My buyers are holy men; they pay in silver and never haggle. I love holy men."
    next: hub
  keeper:
    type: line
    speaker: npc.seixal
    text: "The old man came down with a lantern and saw the brand on a crate. My lads panicked. It's regrettable. I'll light a candle for him in Peixe."
    next: hub
  scare_fail:
    type: line
    speaker: npc.seixal
    text: "The Marshal is a long way away, senhor, and the sea is very close."
    next: hub
  duke_fail:
    type: line
    speaker: npc.seixal
    text: "The Duke loves me like a son. A son he rarely sees. But still."
    next: hub
  offer:
    type: line
    speaker: npc.seixal
    text: "Fifty crowns, Attre gold, and you never came down these stairs. We sail with the tide, you light the old man's beacon. Everyone goes home."
    next: offer_hub
  offer_hub:
    type: choice
    options:
      - id: accept
        text: "Fifty crowns. Go."
        effects: ["add_crowns(50)", "set_flag(flag.seixal_bribed)", "set_flag(flag.gull_cellar_clear)", "add_rep(faction.attre, 5)", "play_beat(seixal_sails)"]
        next: sails
      - id: refuse
        text: "No."
        next: hub
  sails:
    type: line
    speaker: npc.seixal
    text: "A pleasure, senhor. If you're ever in Attre, ask for Joaquim. Everyone knows Joaquim."
    next: bye
  surrender:
    type: line
    speaker: npc.seixal
    text: "Hah. You win, senhor. Take your crates. Take me, if you must. The Marshal's cells are drier than my boat."
    direction: "He sets down the lantern. His sailors drop their knives."
    effects: ["set_flag(flag.seixal_captured)", "set_flag(flag.gull_cellar_clear)", "add_rep(faction.crown, 5)", "add_rep(faction.attre, -5)"]
    next: interrogate
  talk:
    type: line
    speaker: npc.seixal
    text: "You're right. Of course you're right. Here, the manifest. Port Peixe, the Duke's factor's own seal. Sold to grey-robed buyers for Abbey silver. I'm only the boat. Take me to your Marshal."
    effects: ["set_flag(flag.seixal_captured)", "set_flag(flag.gull_cellar_clear)", "give_item(item.gull_bill_of_lading, 1)", "add_rep(faction.crown, 5)", "add_rep(faction.attre, -5)"]
    next: interrogate
  interrogate:
    type: line
    speaker: npc.seixal
    text: "One thing for free, senhor. The holy men wanted the bulbs dry and whole, not crushed. Whatever they're brewing, they need a lot of it, slowly. Like a man who means to take his time."
    next: bye
  fight:
    type: line
    speaker: npc.seixal
    text: "Pity. I liked you. Boys!"
    effects: ["set_flag(flag.gull_cellar_engaged)", "start_encounter(enc.gull_cellar)"]
    next: bye
  bye:
    type: end
```

### 5.2 Seixal yields

```yaml dialogue
id: dlg.seixal_yield
participants: [npc.seixal]
start: beg
nodes:
  beg:
    type: line
    speaker: npc.seixal
    text: "Enough, enough! Joaquim surrenders! Joaquim is a merchant, not a hero!"
    next: hub
  hub:
    type: choice
    options:
      - id: who
        text: "Who bought the bulbs?"
        next: who
      - id: kosk
        text: "You're going to the Marshal."
        effects: ["set_flag(flag.seixal_captured)", "add_rep(faction.crown, 5)"]
        next: kosk
      - id: kill
        text: "For the keeper."
        effects: ["set_flag(flag.seixal_dead)"]
        next: kill
  who:
    type: line
    speaker: npc.seixal
    text: "Grey robes! Hoods! Paid in silver at Peixe, through the Duke's factor. The Duke takes his tenth of everything that moves on his coast. He didn't ask what. He never asks."
    effects: ["give_item(item.gull_bill_of_lading, 1)"]
    next: hub
  kosk:
    type: line
    speaker: npc.seixal
    text: "Drier than my boat. Yes. Yes, good."
    next: bye
  kill:
    type: line
    speaker: player
    text: "That's for Aud Harrow."
    direction: "It is quick. The tide sloshes in the cave."
    next: bye
  bye:
    type: end
```

### 5.3 The crates

```yaml dialogue
id: dlg.gull_crates_choice
participants: [npc.nessa_harrow]
start: choice
nodes:
  choice:
    type: choice
    options:
      - id: take
        text: "Take the good bulbs. Someone may need to know what this poison is made of."
        effects: ["give_item(item.grey_lily_bulbs, 2)", "set_flag(flag.gull_bulbs_taken)"]
        next: take
      - id: burn
        text: "Burn them. All of them."
        effects: ["set_flag(flag.gull_bulbs_burned)", "play_beat(crates_burned)"]
        next: burn
  take:
    type: line
    speaker: player
    text: "Two of the bulbs are firm and whole. Hale wraps them in sailcloth. The rest are crushed or rotten."
    next: nessa_check
  burn:
    type: line
    speaker: player
    text: "Sweet smoke, and the last of the Duke's poison goes up the ramp and out to sea."
    next: nessa_check
  nessa_check:
    type: branch
    cases:
      - {if: "flag(flag.nessa_saved)", next: nessa_line}
    else: bye
  nessa_line:
    type: line
    speaker: npc.nessa_harrow
    text: "Widow's-bell. My mother called it that. There's a marsh-woman down south past the Marnadal grows it on purpose, they say. Mad, or worse."
    effects: ["add_map_pin(map.witchs_mere)"]
    next: bye
  bye:
    type: end
```

### 5.4 Nessa at the trapdoor

```yaml dialogue
id: dlg.nessa
participants: [npc.nessa_harrow]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "flag(flag.gull_yard_clear)", next: open_clear}
    else: open_danger
  open_danger:
    type: line
    speaker: npc.nessa_harrow
    text: "Come up that ladder and I'll put this hook through your eye, Attre scum!"
    direction: "A voice from behind the barricaded trapdoor."
    next: danger_hub
  danger_hub:
    type: choice
    options:
      - id: crown
        text: "I'm not from Attre. The Marshal sent me. [Persuade 4]"
        tag: persuade
        check: {skill: persuade, dc: 4, pass: saved, fail: stay_shut}
        once: true
      - id: writ
        text: "The Marshal's writ. Look through the gap. [Item: Marshal's writ]"
        tag: item
        condition: "has_item(item.kosk_writ)"
        next: saved
      - id: later
        text: "Stay there. I'll deal with the men in the yard."
        next: bye
  stay_shut:
    type: line
    speaker: npc.nessa_harrow
    text: "That's what they'd say. Go away. Come back when they're dead."
    next: bye
  open_clear:
    type: line
    speaker: npc.nessa_harrow
    text: "Are they dead? The ones in the yard? ...Good. Good."
    direction: "The chest scrapes back. A grey-haired woman with a boathook and red eyes."
    next: saved
  saved:
    type: line
    speaker: npc.nessa_harrow
    text: "He went down with the lantern to see what they were landing. Thirty years he kept this light, and they cut his throat over a crate of flowers. Help me light it. He'd want it lit."
    effects: ["set_flag(flag.nessa_saved)"]
    next: saved_hub
  saved_hub:
    type: choice
    options:
      - id: help
        text: "Let's light it."
        next: bye
      - id: what_landed
        text: "What were they landing?"
        next: what_landed
  what_landed:
    type: line
    speaker: npc.nessa_harrow
    text: "Crates. Lighthouse brand on them; that's Attre Light, the Duke's port. Every new moon since midsummer. Aud wrote it all in his log, the fool. Honest fool."
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.gull_yard
zone: zone.gull_tower
enemies:
  - {enemy: enemy.bandit, count: 2, spawn: yard_fire, variant: smuggler_cudgel}
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: yard_fire, variant: attre_smuggler}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: gull_yard
avoidable_by: []
on_won: ["set_flag(flag.gull_yard_clear)"]
on_yielded: ["set_flag(flag.gull_yard_clear)"]
on_player_fled: ["clear_flag(flag.gull_yard_engaged)"]
```

```yaml encounter
id: enc.gull_cellar
zone: zone.gull_tower_cellar
enemies:
  - {enemy: enemy.bandit, count: 1, spawn: crate_stack, variant: smuggler_captain}
  - {enemy: enemy.bandit, count: 2, spawn: crate_stack, variant: smuggler_knife}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: gull_cellar
avoidable_by: ["dlg.seixal"]
on_won: ["set_flag(flag.gull_cellar_clear)", "set_flag(flag.seixal_dead)"]
on_yielded: ["set_flag(flag.gull_cellar_clear)", "start_dialogue(dlg.seixal_yield)"]
on_player_fled: ["clear_flag(flag.gull_cellar_engaged)"]
```

**Notes.**
- Bandit variants (gdd §6.7 band L3–6): `smuggler_cudgel` (L3, 55 HP, 10 blunt, armor 10), `smuggler_knife` (L3, 55 HP, 10 slash, fast), `smuggler_captain` (Seixal, L4, 75 HP, 13 slash, armor 15, yields readily). The yard crossbowman uses the Choir crossbowman stat block with an Attre look (`attre_smuggler`): there is no generic crossbow bandit in gdd §6.7.
- **Non-combat alternatives.** The yard can be skipped entirely by taking the cliff steps to the sea cave (the smugglers in the yard never notice). In the cellar, Intimidate 6, Persuade 6, a stranded captain (boat cut) or a bribe all end it without a fight.
- **Stage 1 variant:** if `stage() >= 1` when the player arrives, the level builder adds one `smuggler_knife` at `yard_fire` (a data variant of `enc.gull_yard`; see Open questions).

## 7. Items and clues

```yaml item
id: item.grey_lily_bulbs
name: "Grey lily bulbs"
category: key
description: "Fat grey bulbs that smell faintly of lilies: the source of the poison in the Queen's cup. Someone who grows them might know a cure. (Count also tracked by var.bulbs_recovered once returned, gdd §6.2.)"
price: 0
stack_max: 6
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.gull_keeper_log
name: "Gull Tower keeper's log"
category: document
description: "Aud Harrow's log of lights, weather and ships, in a careful, honest hand."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Midsummer, new moon: lugger, no lights, landed at the cove. Crates. Lighthouse brand - Attre Light. Again at the next new moon. Again. Equinox: told them I'd write to the harbourmaster at Cintra. They laughed. Tonight I'll go down and look in the crates myself."
```

```yaml item
id: item.gull_bill_of_lading
name: "Port Peixe manifest"
category: document
description: "A bill of lading under the seal of the Duke of Attre's factor at Port Peixe."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Port Peixe, for the Duke's account (one tenth). Lugger Dorada, J. Seixal master. Twelve crates 'physic bulbs, dry', consigned to bearer at Gull Cove, paid in full in silver by the brothers' agent. No questions."
```

```yaml clue
id: clue.gull_bulbs
theory: theory.poisoner
title: "Grey lily through Attre Light"
text: "Smugglers on the Duke of Attre's coast run landed crates of grey lily bulbs at Gull Tower, branded Attre Light and sold through the Duke's factor at Port Peixe to grey-robed buyers who paid in silver. They killed the keeper who saw them."
supports: [raimund]
refutes: []
```

```yaml deduction
id: ded.poison_via_attre
theory: theory.poisoner
condition: "(has_clue(clue.chalice_pollen) and has_clue(clue.gull_bulbs)) or has_clue(clue.raimund_ledger_silver)"
title: "The poison came through Attre"
text: "The grey lily in the Queen's cup came in through Duke Raimund's ports. The Duke sold it, or let it be sold. Someone in grey paid for it in silver."
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.a1_gull_done, type: milestone, desc: "The player learned the Gull Tower crates hold grey lily from Attre."}
  - {id: flag.gull_yard_clear, type: bool, desc: "The smugglers in the yard are dealt with."}
  - {id: flag.gull_cellar_clear, type: bool, desc: "Seixal's crew in the cellar is dealt with (any route)."}
  - {id: flag.gull_yard_engaged, type: bool, desc: "The yard fight is running (no re-trigger); cleared if the player flees."}
  - {id: flag.gull_cellar_engaged, type: bool, desc: "The cellar fight is running (no re-trigger of Seixal's parley); cleared if the player flees."}
  - {id: flag.keeper_examined, type: bool, desc: "The player examined the keeper's wounds (Investigate 4)."}
  - {id: flag.dorada_cut, type: bool, desc: "The player cut the smugglers' lugger loose."}
  - {id: flag.seixal_bribed, type: bool, desc: "The player took Seixal's 50 crowns and let him sail with the crates (no bulbs)."}
  - {id: flag.seixal_captured, type: bool, desc: "Seixal surrendered and was handed to the Crown. A05 may use him as a witness in Attre."}
  - {id: flag.seixal_dead, type: bool, desc: "Seixal was killed."}
  - {id: flag.gull_bulbs_taken, type: bool, desc: "The player took the 2 good bulbs (item.grey_lily_bulbs x2)."}
  - {id: flag.gull_bulbs_burned, type: bool, desc: "The player burned the last crates."}
  - {id: flag.nessa_saved, type: bool, desc: "Nessa Harrow came down from the lamp room."}
  - {id: flag.gull_beacon_lit, type: bool, desc: "The Gull Tower beacon is relit (Crown +5)."}
reads:
  - ms.a1_audience_done
  - flag.chalice_secured
```

## 9. Quest hooks

This section contributes the optional `gull` objective of `quest.main_a1` stage `follow_the_leads` (declared in `02-audience-at-court.md`). Because Gull Tower can be finished in early Act II, its XP is paid by `add_xp(200)` with the milestone, not by the objective.

## 10. Rumors and event cards (optional)

None. The ballad-seller in the hub (section 2) announces the dark tower.

## 11. Failure states and branches

```yaml branches
paths:
  - id: fight_through
    when: "Player fights the yard and the cellar."
    outcome: "Crates opened (clue, milestone), take or burn the bulbs, Seixal dead or yielded."
    sets: ["reach_milestone(ms.a1_gull_done)"]
  - id: cliff_route
    when: "Player takes the cliff steps, cuts the Dorada loose, and enters the cellar from the cave."
    outcome: "Seixal stranded; the 'stranded' option ends it with no check."
    sets: ["set_flag(flag.dorada_cut)", "reach_milestone(ms.a1_gull_done)"]
  - id: talk_down
    when: "Intimidate 6 or Persuade 6 in the cellar."
    outcome: "Seixal captured (manifest with Persuade). Crates opened."
    sets: ["set_flag(flag.seixal_captured)", "reach_milestone(ms.a1_gull_done)"]
  - id: bribed
    when: "Player accepts 50 crowns."
    outcome: "Seixal sails with the crates. Manifest left on the floor gives the clue and milestone. No bulbs. Attre +5."
    sets: ["set_flag(flag.seixal_bribed)", "reach_milestone(ms.a1_gull_done)"]
  - id: beacon
    when: "Nessa saved, beacon lit."
    outcome: "Crown +5, 50 XP."
    sets: ["set_flag(flag.gull_beacon_lit)"]
failures:
  - id: player_dies
    result: reload_checkpoint
    recover: "Reload gull_path, gull_yard or gull_cellar."
  - id: cliff_fall
    result: soft_fail
    recover: "A fall costs 25% max HP and puts the player at the cliff foot."
  - id: window_closed
    result: soft_fail
    recover: "If the player never comes before stage 2, the section closes: no Gull bulbs (Wenna can still get 6 from other sources only if A05's counts allow it; otherwise the 2-dose outcome needs all six, gdd §6.2)."
guarantees:
  - "ms.a1_gull_done: cliff steps + cut the line + 'stranded' option + crates, with no check and no fight; or the bribe + manifest, no check."
```

## 12. Open questions

1. **Stage-variant encounters.** gdd §6.1 stage 3 adds +1 member to Choir groups, but there is no data hook for "encounter variant by stage". Gull Tower at stage 1 would benefit from +1 smuggler. Proposed: an `enemies_by_stage` field, or two encounters selected by trigger conditions as in `05-ring-of-nine.md`.
2. **Bulb total.** gdd §6.2 makes 2 doses need all 6 bulbs. If the Gull bulbs are burned or bribed away, A05 must make sure 6 are still reachable elsewhere, or burning here costs the 2-dose outcome. That is an intended trade-off unless the designer objects.
3. **Generic crossbow bandit.** gdd §6.7 has no ranged bandit. I reused `enemy.choir_crossbowman` with an `attre_smuggler` variant. A designer may prefer a `bandit` variant `crossbow`.
