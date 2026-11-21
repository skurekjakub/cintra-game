---
section_id: a2.02
title: "Hanged Man's Oak"
act: 2
story_ref: "story.md §3 The Pale Choir (dead-drop), §6 Hanged Man's Oak"
zones: [zone.hanged_mans_oak]
available_when: "ms(ms.act1_complete) and not ms(ms.act2_twist) and (has_item(item.route_map_oak) or ded(ded.choir_exists))"
escalation_stage_required: {min: 1, max: 3}
milestones_set: [ms.a2_cipher_taken]
milestones_read: [ms.a2_cipher_taken, ms.act1_complete, ms.act2_twist]
level_band: [5, 7]
---

# Hanged Man's Oak

## 1. Scene summary
Hanged Man's Oak is a dead gallows oak on a knoll above four drove tracks in the Marnadal woods. Rusted chains still hang from its limbs with the bones of men hanged in Corvan's time. Its trunk is hollow, and the Pale Choir uses it as a dead-drop: a courier from St. Corwen comes up the north track by night, leaves Anselm's ciphered orders, and collects the reports that runners from Vel Aram leave. The player arrives with the route map from the Fair assassin and must take the courier's cipher. There are four ways in: a stealth seizure at the trunk, a parley that turns the frightened novice courier, a chase if he bolts, or a disguise if the player already wears a Choir robe. With the cipher in hand, a sharp player can forge a dispatch and plant it in the trunk to strip guards from Vel Aram. The decoded report names the muster at Vel Aram. The dramatic question: how much mercy does a seventeen-year-old kitchen boy in a traitor's robe deserve? The section ends with `ms.a2_cipher_taken`, or with the courier escaping, which is a soft failure. Jory's men rob the fleeing courier at the river crossing, so the cipher can then be bought from Jory or taken from his strongbox by force. Oswy himself reaches Vel Aram empty-handed and is hanged on its gate.

## 2. Progress and escalation
- `ms.a2_cipher_taken` is set whenever `item.anselm_cipher` is first obtained here: by seizure, parley, chase or disguise. The same milestone can also be reached in `a2.03` (bought from Jory, demanded from a beaten Jory, or taken from his strongbox), so the lead never soft-locks.
- Reading the Vel Aram report with the cipher gives `clue.choir_at_vel_aram`. Having the cipher gives `clue.anselm_cipher`, which unlocks `ded.choir_muster_vel_aram` (declared here) and with it the `hanged_mans_oak — vel_aram` and `marnadal_field — vel_aram` map edges.
- `flag.forged_dispatch_planted` thins Vel Aram's patrols (read by `a2.07`) if Vel Aram is not cleared yet.
- **Stage 1–2:** as written. **Stage 3:** the courier rides with his escort already drawn (the system rule adds one member to Choir groups). Proclamations are nailed to the oak.
- Reactivity from `a2.01`: `flag.oak_signal_known` lets the player hang the all-clear lantern so the courier sends his escort back and comes alone. `flag.aske_warned_oak` means Aske signalled danger: the reinforced escort is used.

## 3. Location layout
Night, exterior, about 140 × 120 m of oak-and-birch wood with a bald knoll at the centre.
- **North track** (entry from Tigg and the travel map): a sunken drove-way 4 m below the bracken. The courier rides in this way. The player's default spawn is at the track's mouth, 80 m from the oak.
- **Horse hollow:** a dell 40 m north of the oak with a hitching stone. The courier tethers his horse here. Cutting the tether stops him escaping on horseback.
- **Bracken slope:** waist-high bracken and three fallen trunks ringing the knoll. These are full stealth cover when crouched. The intended hide spots are the **north stump** (8 m from the trunk) and the **root cave** (an eroded hollow under the oak's west roots, 3 m from the trunk).
- **Oak knoll:** a bare 20 m circle around the oak. The hollow trunk opens on the south side at chest height. Three chained skeletons hang from the north limb, and their creaking hides footsteps (half noise). The oak's dead crown is a `collapse` hazard: heavy fighting under it (two kicks or a fire burst) drops a limb.
- **Lookout rock:** a granite boss 25 m east, 4 m high. An escort crossbowman stands here (sight line over the knoll and the bracken; vision 12 m in darkness for the purposes of the cone is halved to 6 m, see gdd §6.5).
- **Charcoal clearing:** an abandoned burners' clearing 50 m south-west with two smouldering mounds (`fire` hazard) and a burners' hut. The south track to Vel Aram leaves from here.
- **Stream ford:** a muddy ford on the south track (`deep_mud` hazard). The escort waits here when the all-clear lantern is hung.

The intended flow: arrive, read the knoll, choose a hide spot, wait for the courier, act when he kneels at the trunk.

```yaml zone
id: zone.hanged_mans_oak
name: "Hanged Man's Oak"
kind: exterior
map_node: map.hanged_mans_oak
time_of_day: night
cold_rate: 0
disguise_tag: choir
music: oak_silence
areas:
  - {id: north_track, description: "Sunken drove-way 4 m below the bracken. Courier's approach. Player entry."}
  - {id: horse_hollow, description: "Dell 40 m north of the oak with a hitching stone."}
  - {id: bracken_slope, description: "Waist-high bracken, three fallen trunks. Hide spots: north stump (8 m from trunk) and root cave (3 m, under the west roots)."}
  - {id: oak_knoll, description: "Bare 20 m circle round the dead oak. Hollow trunk opening on the south side. Chained skeletons creak on the north limb (half footstep noise)."}
  - {id: lookout_rock, description: "Granite boss 25 m east, 4 m high. Escort crossbowman post."}
  - {id: charcoal_clearing, description: "Abandoned burners' clearing, two smouldering mounds, a burners' hut. South track to Vel Aram."}
  - {id: stream_ford, description: "Muddy ford on the south track. Escort waits here when the lantern is hung."}
spawns:
  - {id: north_track, area: north_track, default: true}
  - {id: south_track, area: charcoal_clearing}
  - {id: courier_road, area: north_track}
  - {id: lookout, area: lookout_rock}
  - {id: ford, area: stream_ford}
  - {id: knoll_east, area: oak_knoll}
exits: []
interactables:
  - id: travel_marker
    area: north_track
    kind: map_board
    label: "Leave the Oak (travel)"
    condition: "true"
    check: null
    once: false
    effects: []
  - id: hollow_trunk
    area: oak_knoll
    kind: container
    label: "Reach into the hollow trunk"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.va_report, 1)"]
  - id: read_report
    area: oak_knoll
    kind: readable
    label: "Decode the Vel Aram report"
    condition: "has_item(item.va_report) and has_item(item.anselm_cipher)"
    check: null
    once: true
    effects: ["add_clue(clue.choir_at_vel_aram)", "add_map_pin(map.vel_aram)"]
  - id: hang_lantern
    area: oak_knoll
    kind: lever
    label: "Hang a lit lantern on the low chain (the all-clear)"
    condition: "flag(flag.oak_signal_known) and not flag(flag.courier_arrived)"
    check: null
    once: true
    effects: ["set_flag(flag.oak_lantern_hung)"]
  - id: wait_for_courier
    area: bracken_slope
    kind: lever
    label: "Settle into the bracken and wait for the courier"
    condition: "not flag(flag.courier_arrived) and not ms(ms.a2_cipher_taken)"
    check: null
    once: true
    effects: ["set_checkpoint(before_courier)", "set_flag(flag.courier_arrived)", "play_beat(courier_arrives)"]
  - id: cut_tether
    area: horse_hollow
    kind: lever
    label: "Cut the horse's tether"
    condition: "flag(flag.courier_arrived) and not flag(flag.oak_courier_down) and not flag(flag.oak_courier_escaped)"
    check: null
    once: true
    effects: ["set_flag(flag.tether_cut)", "play_beat(horse_bolts)"]
  - id: seize_courier
    area: oak_knoll
    kind: lever
    label: "Seize the courier from behind"
    condition: "flag(flag.courier_arrived) and not flag(flag.oak_courier_down) and not flag(flag.oak_courier_escaped)"
    check: null
    once: true
    effects: ["set_flag(flag.oak_courier_down)", "play_beat(courier_seized)", "start_dialogue(dlg.oswy_seized)"]
  - id: step_out
    area: oak_knoll
    kind: lever
    label: "Step out of cover and speak to him"
    condition: "flag(flag.courier_arrived) and not flag(flag.oak_courier_down) and not flag(flag.oak_courier_escaped)"
    check: null
    once: true
    effects: ["start_dialogue(dlg.oswy_parley)"]
  - id: forge_dispatch
    area: oak_knoll
    kind: readable
    label: "Forge a dispatch in Anselm's cipher"
    condition: "has_item(item.anselm_cipher) and not has_item(item.forged_dispatch) and not flag(flag.forged_dispatch_planted)"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["give_item(item.forged_dispatch, 1)"]
    fail_effects: []
  - id: plant_dispatch
    area: oak_knoll
    kind: lever
    label: "Plant the forged dispatch in the trunk"
    condition: "has_item(item.forged_dispatch)"
    check: null
    once: true
    effects: ["take_item(item.forged_dispatch, 1)", "set_flag(flag.forged_dispatch_planted)", "play_beat(dispatch_planted)"]
  - id: burners_hut
    area: charcoal_clearing
    kind: search
    label: "Search the burners' hut"
    condition: "true"
    check: null
    once: true
    effects: ["add_crowns(20)"]
triggers:
  - id: courier_bolts_on_alarm
    area: oak_knoll
    on: beat_done
    source: alarm
    condition: "flag(flag.courier_arrived) and not flag(flag.oak_courier_down) and not flag(flag.tether_cut)"
    once: true
    effects: ["play_beat(courier_escapes)", "set_flag(flag.oak_courier_escaped)", "start_encounter(enc.oak_escort)"]
  - id: courier_runs_on_foot
    area: oak_knoll
    on: beat_done
    source: alarm
    condition: "flag(flag.courier_arrived) and not flag(flag.oak_courier_down) and flag(flag.tether_cut)"
    once: true
    effects: ["start_encounter(enc.oak_courier_chase)"]
  - id: disguised_greeting
    area: oak_knoll
    on: beat_done
    source: courier_at_trunk
    condition: "has_item(item.choir_robe) and has_item(item.pale_feather) and not flag(flag.oak_courier_down)"
    once: true
    effects: ["start_dialogue(dlg.oswy_brother)"]
hazards:
  - {id: dead_crown, area: oak_knoll, kind: collapse, params: {trigger: heavy_impacts, impacts: 2, damage: 40, knockdown: true}}
  - {id: smoulder_mounds, area: charcoal_clearing, kind: fire, params: {damage_per_second: 5}}
  - {id: ford_mud, area: stream_ford, kind: deep_mud, params: {speed_mult: 0.6}}
checkpoints:
  - {id: oak_arrival, area: north_track}
  - {id: before_courier, area: bracken_slope}
beats:
  - {id: courier_arrives, description: "Hoofbeats on the north track. A hooded rider tethers at the hollow and walks up the knoll alone, escort taking post on the rock (and at the ford if reinforced). He kneels at the trunk."}
  - {id: courier_at_trunk, description: "The courier kneels at the hollow, swapping papers. He stays kneeling about as long as a prayer."}
  - {id: horse_bolts, description: "The cut horse shies and trots off into the dark."}
  - {id: courier_seized, description: "The player clamps a hand over the courier's mouth and drags him into the root cave."}
  - {id: alarm, description: "Stealth alarm: the escort shouts. Played by the stealth system on suspicion 100, or by dialogue when the courier bolts."}
  - {id: courier_escapes, description: "The courier sprints for the hollow, vaults onto his horse and gallops north. His escort covers him."}
  - {id: dispatch_planted, description: "The forged dispatch slides into the trunk among the dead leaves."}
npcs:
  - {npc: npc.brother_oswy, area: oak_knoll, condition: "flag(flag.courier_arrived) and not flag(flag.oak_courier_escaped)"}
encounters: [enc.oak_escort, enc.oak_escort_reinforced, enc.oak_courier_chase]
loot:
  - {container: hollow_trunk, items: [{item: item.crossbow_bolt, count: 4}], condition: "true"}
variants:
  - id: lantern_all_clear
    when: "flag(flag.oak_lantern_hung)"
    description: "The courier sees the lantern, sends his escort back to the ford, and walks up alone."
    npcs_absent: []
    encounters_disabled: [enc.oak_escort, enc.oak_escort_reinforced]
    interactables_disabled: []
  - id: warned
    when: "flag(flag.aske_warned_oak) and not flag(flag.oak_lantern_hung)"
    description: "Aske's lantern signalled danger. Two escorts and a crossbowman come with the courier."
    npcs_absent: []
    encounters_disabled: [enc.oak_escort]
    interactables_disabled: []
  - id: base_escort
    when: "not flag(flag.aske_warned_oak) and not flag(flag.oak_lantern_hung)"
    description: "One zealot and one crossbowman escort the courier."
    npcs_absent: []
    encounters_disabled: [enc.oak_escort_reinforced]
    interactables_disabled: []
  - id: proclamations
    when: "stage() >= 3"
    description: "Feather proclamations nailed to the oak's trunk above the hollow."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: oak_spent
    when: "ms(ms.a2_cipher_taken) or flag(flag.oak_courier_escaped)"
    description: "No more couriers come. The trunk holds only leaves and whatever the player put there."
    npcs_absent: [npc.brother_oswy]
    encounters_disabled: [enc.oak_escort, enc.oak_escort_reinforced, enc.oak_courier_chase]
    interactables_disabled: [wait_for_courier, seize_courier, step_out, cut_tether]
```

## 4. NPCs present
**Voice notes.** Brother Oswy: seventeen, a former Abbey kitchen boy, Cintra docks accent, talks too fast, keeps calling the player "sir" whatever the player looks like. He recites the Choir's words like a lesson he was beaten into learning. He is not a killer, and he knows exactly what happens to couriers who lose the cipher.

```yaml npc
id: npc.brother_oswy
name: "Brother Oswy"
faction: faction.choir
role: "Novice of St. Corwen, the Choir's courier to the Oak"
motive: "Get the papers in and out of the trunk without dying."
secret: "He has seen Abbot Anselm burn the pages of the Book of the Lion's index in the kitchen oven, and he knows couriers who lose the cipher are hanged."
disposition: hostile
essential: false
dialogue: null
barks: ["Saint keep me, saint keep me.", "Who's there?", "I've a knife! I've a knife, I swear!"]
combat: enemy.choir_thug
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.oswy_seized
participants: [npc.brother_oswy]
start: gasp
nodes:
  gasp:
    type: line
    speaker: npc.brother_oswy
    text: "Don't! Don't, sir, please, I'm only the post-boy, I only carry it!"
    direction: "Pinned in the root cave, papers clutched to his chest."
    next: hub
  hub:
    type: choice
    options:
      - id: satchel
        text: "The satchel. Everything. Now."
        next: satchel
      - id: who
        text: "Who sends you?"
        next: who
      - id: vel_aram
        text: "Where do the reports come from?"
        next: vel_aram
  who:
    type: line
    speaker: npc.brother_oswy
    text: "The Father Abbot writes them himself, sir. In the wheel-letters. I can't read them, I swear on the saint. I only know his hand. Everyone knows his hand."
    effects: ["add_clue(clue.anselm_cipher)"]
    next: hub
  vel_aram:
    type: line
    speaker: npc.brother_oswy
    text: "From the old fort. Vel Aram, south past the battlefield. The Prior's runner leaves them. There's a lot of brothers there now. A lot."
    effects: ["add_clue(clue.choir_at_vel_aram)", "add_map_pin(map.vel_aram)"]
    next: hub
  satchel:
    type: line
    speaker: npc.brother_oswy
    text: "Take it. Take it all. The wheel and the key-sheet. They'll hang me for losing it, you know. They hang you on the gate."
    effects: ["give_item(item.anselm_cipher, 1)", "give_item(item.oak_orders, 1)", "add_clue(clue.anselm_cipher)", "reach_milestone(ms.a2_cipher_taken)"]
    next: fate
  fate:
    type: choice
    options:
      - id: robe
        text: "Your robe too. And the feather."
        condition: "not has_item(item.choir_robe)"
        next: robe
      - id: witness
        text: "You're going to Cintra. Tell the Lord Marshal everything you just told me, and you'll live."
        next: witness
      - id: home
        text: "Don't go back to them. Go north, go home, go anywhere."
        next: home
      - id: release
        text: "Get out of my sight."
        next: release
      - id: kill
        text: "(Kill him.)"
        next: kill
  robe:
    type: line
    speaker: npc.brother_oswy
    text: "It's cold, sir. Here. It was never mine anyway."
    effects: ["give_item(item.choir_robe, 1)", "give_item(item.pale_feather, 1)"]
    next: fate
  witness:
    type: line
    speaker: npc.brother_oswy
    text: "The Marshal? He'll... All right. All right. Better a Marshal's cell than the gate at Vel Aram."
    effects: ["set_flag(flag.oswy_witness)", "add_rep(faction.crown, 5)"]
    next: bye
  home:
    type: line
    speaker: npc.brother_oswy
    text: "Home's the Abbey. But... my aunt's in Breza. Saint keep you, sir. Nobody's ever said go."
    effects: ["set_flag(flag.oswy_fled_home)"]
    next: bye
  release:
    type: line
    speaker: npc.brother_oswy
    text: "Yes, sir. Yes."
    direction: "He runs south, toward Vel Aram, because it is the only place he knows."
    effects: ["set_flag(flag.oswy_returned)"]
    next: bye
  kill:
    type: line
    speaker: npc.brother_oswy
    text: "Please..."
    effects: ["set_flag(flag.oswy_killed)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.oswy_parley
participants: [npc.brother_oswy]
start: freeze
nodes:
  freeze:
    type: line
    speaker: npc.brother_oswy
    text: "Stay back! Don't come closer, I'll run, I've a horse, I'll run!"
    direction: "On his feet by the trunk, papers behind his back, glancing at the lookout rock."
    next: hub
  hub:
    type: choice
    options:
      - id: persuade
        text: "[Persuade 6] You're a kitchen boy in a borrowed robe. Nobody here wants you dead. Put the papers on the ground."
        tag: persuade
        check: {skill: persuade, dc: 6, pass: yields, fail: bolts}
      - id: intimidate
        text: "[Intimidate 6] Your horse is forty paces away and my crossbow is right here. Choose."
        tag: intimidate
        check: {skill: intimidate, dc: 6, pass: yields, fail: bolts}
      - id: bribe
        text: "[Bribe 40] Forty crowns says you were robbed on the road and never saw a face."
        tag: bribe
        bribe: 40
        next: yields
      - id: queen
        text: "[Clue: Chalice pollen] Your Abbot is poisoning the Queen, boy. Grey lily in her own chalice. Is that what you ride for?"
        tag: clue
        condition: "has_clue(clue.chalice_pollen)"
        next: shaken
      - id: tether
        text: "Your horse is gone, brother. I cut it loose. There's nowhere to run."
        condition: "flag(flag.tether_cut)"
        next: yields
      - id: rush
        text: "(Rush him.)"
        next: bolts
  shaken:
    type: line
    speaker: npc.brother_oswy
    text: "No. No, he gives her the tonics, he prays with her... the lily. The kitchen. The cellarer's lily. Oh saint."
    direction: "He sits down in the leaves."
    next: yields
  yields:
    type: line
    speaker: npc.brother_oswy
    text: "All right! Here. The wheel, the key-sheet, the orders. Don't hurt me."
    effects: ["set_flag(flag.oak_courier_down)", "give_item(item.anselm_cipher, 1)", "give_item(item.oak_orders, 1)", "add_clue(clue.anselm_cipher)", "reach_milestone(ms.a2_cipher_taken)"]
    next: fate
  bolts:
    type: line
    speaker: npc.brother_oswy
    text: "Brothers! Brothers, to me!"
    effects: ["play_beat(alarm)"]
    next: bye
  fate:
    type: choice
    options:
      - id: robe
        text: "The robe and the feather too."
        condition: "not has_item(item.choir_robe)"
        next: robe
      - id: witness
        text: "Go to Cintra. Tell the Lord Marshal what you carry and for whom."
        next: witness
      - id: home
        text: "Go home, boy. Not to them."
        next: home
      - id: release
        text: "Go."
        next: release
  robe:
    type: line
    speaker: npc.brother_oswy
    text: "Here. Take it. I never liked it."
    effects: ["give_item(item.choir_robe, 1)", "give_item(item.pale_feather, 1)"]
    next: fate
  witness:
    type: line
    speaker: npc.brother_oswy
    text: "The Marshal. All right. Better him than the Prior."
    effects: ["set_flag(flag.oswy_witness)", "add_rep(faction.crown, 5)"]
    next: bye
  home:
    type: line
    speaker: npc.brother_oswy
    text: "My aunt's in Breza. I'll go to Breza. Thank you. Thank you."
    effects: ["set_flag(flag.oswy_fled_home)"]
    next: bye
  release:
    type: line
    speaker: npc.brother_oswy
    text: "Yes, sir."
    direction: "He runs south toward Vel Aram."
    effects: ["set_flag(flag.oswy_returned)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.oswy_brother
participants: [npc.brother_oswy]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.brother_oswy
    text: "Oh! Brother, you scared the life out of me. Are you the Prior's runner? You're early. The swan sings...?"
    direction: "Relieved, still kneeling at the trunk. He waits for the countersign."
    next: hub
  hub:
    type: choice
    options:
      - id: lore
        text: "[Lore 6] '...and the old song ends.' (Guess at the Choir hymn's next line.)"
        tag: lore
        check: {skill: lore, dc: 6, pass: accepted, fail: suspicious}
      - id: report
        text: "[Item: Vel Aram report] The Prior's report. Give me the Abbot's orders and the wheel. The Prior wants to check the key-sheet himself."
        tag: item
        condition: "has_item(item.va_report)"
        next: accepted
      - id: bluff
        text: "[Persuade 8] No time for songs, brother. Something hunts the road tonight. Give me the satchel and ride."
        tag: persuade
        check: {skill: persuade, dc: 8, pass: accepted, fail: suspicious}
      - id: drop
        text: "(Drop the act and grab him.)"
        next: grabbed
  accepted:
    type: line
    speaker: npc.brother_oswy
    text: "The wheel too? He never... all right, the Prior's the Prior. Here. Saint keep you on the road, brother."
    effects: ["set_flag(flag.oak_courier_down)", "give_item(item.anselm_cipher, 1)", "give_item(item.oak_orders, 1)", "add_clue(clue.anselm_cipher)", "reach_milestone(ms.a2_cipher_taken)", "set_flag(flag.oswy_returned)"]
    direction: "He leaves for the north track, unaware. He will be blamed at Vel Aram."
    next: bye
  suspicious:
    type: line
    speaker: npc.brother_oswy
    text: "That's not... that's not how it goes. Who are you? Brothers!"
    effects: ["play_beat(alarm)"]
    next: bye
  grabbed:
    type: effect
    effects: ["set_flag(flag.oak_courier_down)", "play_beat(courier_seized)", "start_dialogue(dlg.oswy_seized)"]
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.oak_escort
zone: zone.hanged_mans_oak
enemies:
  - {enemy: enemy.choir_zealot, count: 1, spawn: knoll_east, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: lookout, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: before_courier
avoidable_by: ["dlg.oswy_parley", "dlg.oswy_brother"]
on_won: []
on_yielded: ["add_clue(clue.choir_at_vel_aram)"]
on_player_fled: []
```
Design: placed at zone load in stealth posture once `courier_arrives` plays (the zealot walks a 12 m loop round the knoll's east half; the crossbowman stands on the rock). Engages on alarm. A yielding escort names Vel Aram.

```yaml encounter
id: enc.oak_escort_reinforced
zone: zone.hanged_mans_oak
enemies:
  - {enemy: enemy.choir_zealot, count: 2, spawn: knoll_east, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: lookout, variant: null}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.choir_crossbowman, count: 1, spawn: ford, variant: null}]}
attack_tokens: null
allow_yield: true
allies: []
checkpoint: before_courier
avoidable_by: ["dlg.oswy_parley", "dlg.oswy_brother"]
on_won: []
on_yielded: ["add_clue(clue.choir_at_vel_aram)"]
on_player_fled: []
```
Design: used when Aske warned the Oak. The second zealot patrols the bracken slope's west half (past the root cave, so the root cave is risky). The ford crossbowman joins once the first wave is down.

```yaml encounter
id: enc.oak_courier_chase
zone: zone.hanged_mans_oak
enemies:
  - {enemy: enemy.choir_thug, count: 1, spawn: knoll_east, variant: courier}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: before_courier
avoidable_by: []
on_won: ["set_flag(flag.oak_courier_down)", "set_flag(flag.oswy_killed)", "give_item(item.anselm_cipher, 1)", "give_item(item.oak_orders, 1)", "give_item(item.choir_robe, 1)", "add_clue(clue.anselm_cipher)", "reach_milestone(ms.a2_cipher_taken)"]
on_yielded: ["set_flag(flag.oak_courier_down)", "start_dialogue(dlg.oswy_seized)"]
on_player_fled: []
```
Design: with his horse gone, Oswy runs on foot down the north track. He yields at the first hit that takes him under 20% HP or when cornered at the hollow. The escort encounter (whichever variant is active) also engages; this file starts only the chase because the escort enemies engage on the same alarm through stealth.

## 7. Items and clues

```yaml item
id: item.anselm_cipher
name: "Anselm's cipher"
category: key
description: "A brass cipher wheel the size of a palm and a folded key-sheet in a cramped, scholarly hand. The wheel letters are keyed to verses of the Book of the Lion."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Key-sheet. Turn the outer ring to the verse of the day; read inner to outer. Burn this sheet if taken. - A."
```

```yaml item
id: item.oak_orders
name: "The Abbot's orders (decoded)"
category: document
description: "Ciphered orders from St. Corwen to the Prior at Vel Aram, decoded with the wheel."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "To the Prior at V.A. Hold the muster until word comes from St. Corwen. Keep the hound chained and fed on coal; it is not to be woken for vermin. The iron goes up the Stairs at the turning. The boy will come to us crowned. Be patient. The old order rots from the head; we have only to wait for the head to fall. - A."
```

```yaml item
id: item.va_report
name: "Report from Vel Aram (ciphered)"
category: document
description: "A sheet of wheel-letters left in the trunk by the Prior's runner. Unreadable without the cipher."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "(Decoded with the wheel.) Father. The muster stands at thirty-one sworn and armed. The hound is chained in the undercroft and answers to the Houndwright. The Cellarer has the eggs warm for the reagents. Iron crates still come by the ferrymen; their chief asks more each time. The page you sent is sealed in the reliquary as you asked. - Prior Ulric."
```

```yaml item
id: item.forged_dispatch
name: "Forged Choir dispatch"
category: document
description: "Orders in Anselm's cipher, in a passable copy of his hand, written by you."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "To the Prior at V.A. Send ten sworn brothers north to the Oak at once to escort the Abbot's envoy. Wait there for him. Tell no one. - A."
```

```yaml item
id: item.choir_robe
name: "Choir robe"
category: armor
description: "Undyed grey wool habit of St. Corwen, a pale feather stitched in the collar. Worn with a pale feather, it passes in Choir places."
price: 0
stack_max: 1
equip_slot: armor
weapon: null
armor: {armor: 4, resist: {}}
consumable: null
readable_text: null
```

```yaml clue
id: clue.anselm_cipher
theory: theory.choir
title: "Anselm's cipher"
text: "The Choir's dead-drop orders are written in a cipher keyed to the Book of the Lion, on a key-sheet in Abbot Anselm's own hand. The courier swears the Abbot writes them himself."
supports: [anselm]
refutes: []
```

```yaml clue
id: clue.choir_at_vel_aram
theory: theory.choir
title: "The muster at Vel Aram"
text: "The Choir is gathering at the ruined fortress of Vel Aram, south past Marnadal Field: thirty-odd sworn brothers, a chained 'hound' in the undercroft, and a sealed reliquary holding 'the page'. They mean to march on the mountains."
supports: [anselm]
refutes: []
```

```yaml deduction
id: ded.choir_muster_vel_aram
theory: theory.choir
condition: "has_clue(clue.anselm_cipher) or has_clue(clue.jory_iron_crates)"
title: "The Choir musters at Vel Aram"
text: "The cipher's orders and the ferrymen's iron crates both point to the same place: the old border fortress of Vel Aram. Whatever the Choir plans for the mountains, it starts there."
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.a2_cipher_taken, type: milestone, desc: "The player holds Anselm's cipher (taken at the Oak, bought from Jory, or found on Oswy at Vel Aram)."}
  - {id: flag.courier_arrived, type: bool, desc: "The courier has come up the north track."}
  - {id: flag.tether_cut, type: bool, desc: "The courier's horse was cut loose; he cannot ride away."}
  - {id: flag.oak_courier_down, type: bool, desc: "The courier has been seized, turned or beaten."}
  - {id: flag.oak_courier_escaped, type: bool, desc: "The courier got away on horseback; Jory robbed him at the crossing. Read by a2.03 (Jory holds the cipher) and a2.07 (Oswy hanged at the gate)."}
  - {id: flag.oak_lantern_hung, type: bool, desc: "The player hung the all-clear lantern; the escort stays back."}
  - {id: flag.forged_dispatch_planted, type: bool, desc: "A forged order sent ten brothers away from Vel Aram. Read by a2.07."}
  - {id: flag.oswy_witness, type: bool, desc: "Oswy went to Cintra to testify. Read by a2.08."}
  - {id: flag.oswy_fled_home, type: bool, desc: "Oswy ran to Breza and lives."}
  - {id: flag.oswy_returned, type: bool, desc: "Oswy went back to Vel Aram and will be hanged there. Read by a2.07."}
  - {id: flag.oswy_killed, type: bool, desc: "The player killed Oswy."}
reads:
  - flag.oak_signal_known
  - flag.aske_warned_oak
  - clue.chalice_pollen
  - ded.choir_exists
  - item.route_map_oak
  - ms.a2_vel_aram_cleared
```

## 9. Quest hooks
Contributes the optional objective `lead_oak` of `quest.main_a2/the_marnadal_road` (declared in `a2.01`). Contributes to the required `proof` objective (`clue.anselm_cipher` is half of the cipher-and-ledger route to `ded.anselm_treason_proven`, declared in `a2.07`).

## 10. Rumors and event cards (optional)
None. The route map (Act I) and Brother Aske (`a2.01`) point here.

## 11. Failure states and branches

```yaml branches
paths:
  - id: seized
    when: "Player waits, reaches the trunk unseen and seizes the courier."
    outcome: "Cipher, orders, optional robe; ms.a2_cipher_taken; choose Oswy's fate."
    sets: ["reach_milestone(ms.a2_cipher_taken)"]
  - id: parley
    when: "Player steps out and passes Persuade 6, Intimidate 6, pays 40, shows the chalice clue, or has already cut the tether."
    outcome: "Oswy hands everything over; ms.a2_cipher_taken."
    sets: ["reach_milestone(ms.a2_cipher_taken)"]
  - id: disguise
    when: "Player wears the Choir robe and a pale feather (from Vel Aram) and passes Lore 6, Persuade 8, or shows the Vel Aram report."
    outcome: "Oswy hands over the cipher believing the player is the Prior's man; he returns to Vel Aram and is blamed."
    sets: ["reach_milestone(ms.a2_cipher_taken)"]
  - id: chase
    when: "Alarm raised after the tether was cut."
    outcome: "Oswy flees on foot; win or yield gives the cipher."
    sets: ["reach_milestone(ms.a2_cipher_taken)"]
  - id: forged_dispatch
    when: "Player has the cipher and passes Investigate 6 at the trunk, then plants the forgery."
    outcome: "flag.forged_dispatch_planted: ten fewer brothers at Vel Aram (a2.07 patrol variants)."
    sets: ["set_flag(flag.forged_dispatch_planted)"]
failures:
  - id: courier_escapes
    result: soft_fail
    recover: "flag.oak_courier_escaped. Jory's men rob Oswy at the crossing. The cipher can be bought from Jory (a2.03, Ferrymen >= Neutral, 120 crowns), demanded from a beaten Jory, or taken from his strongbox after storming the camp (no check, no crowns). Vel Aram itself is still reachable through clue.jory_iron_crates."
  - id: player_dies
    result: reload_checkpoint
    recover: "Reload before_courier."
  - id: forgery_failed
    result: soft_fail
    recover: "Investigate check failed: no forgery. Vel Aram is simply at full strength."
guarantees:
  - "ms.a2_cipher_taken has a check-free path here (wait, then seize at the trunk; or bribe 40 if the player can pay), and more in a2.03 (purchase, or storming the camp, which needs no check and no crowns)."
  - "The Act II gate never needs the cipher: ded.anselm_treason_proven can come from the journal alone."
```

## 12. Open questions
- **Alarm hook:** the format has no trigger type for a stealth alarm. This file uses the convention `on: beat_done, source: alarm`, where the stealth system (or a dialogue) plays the zone's `alarm` beat. Vel Aram and Attre use the same convention.
- **Stealth posture of encounters:** encounter enemies here must spawn in a patrol or sentry state at `courier_arrives` and engage only on alarm. The encounter schema has no field for that. Proposed: `posture: patrol | sentry | hostile` on `encounter`.
- **Seizure as an interactable:** the seize interaction is a scripted takedown on a lever-type interactable. It assumes the stealth system raises the alarm before the player can reach the trunk if seen.
- `enemy.choir_thug` with `variant: courier` (lower HP, no combo, flees) needs a variant entry in enemy data.
