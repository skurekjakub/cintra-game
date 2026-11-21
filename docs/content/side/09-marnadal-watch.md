---
section_id: side.marnadal_watch
title: "Marnadal Watch"
act: 2
story_ref: "story.md §10 Marnadal Watch; §11 Lowlands d8 4; gdd §7.4, §6.13 ally.kosk_cavalry"
zones: [zone.marnadal_watch_tower]
available_when: "ms(ms.act1_complete)"
escalation_stage_required: {min: 1, max: 4}
milestones_set: []
milestones_read: [ms.act1_complete, ms.act2_twist]
level_band: [5, 10]
---

# Marnadal Watch

## 1. Scene summary
Marnadal Watch is a border tower on the spur above the Tigg–Strept road. Its beacon is the first link in the chain of signal fires that runs back to Cintra. The garrison has deserted. Their pay stopped coming two seasons ago, and the tremors from Amell scare them more than the Marshal's rope. One squire, Tobin Ashe, sixteen years old, has barred himself in the tower with a crossbow and a dead captain's orders. Sergeant Rask and the deserters squat in the burned village below the walls, and they sit on the only pitch kegs left. The player has to restore the beacon (fuel and a repaired iron cage), then deal with Rask: bring him back to duty, buy him off, scare him off, or fight him. The beacon can only be lit once the Choir's goal is known, because the fire tells Lord Marshal Kosk to ride for Amell, and he will only do it once. The dramatic question: will anyone still answer for the realm when nobody has been paid to?

## 2. Progress and escalation
- **Availability:** Act II and Act III. The quest opens on `ms.act1_complete` (stage 1 or higher). It never closes, so it can be finished on the Act III mountain route (`map.marnadal_watch` sits on the `marnadal_watch — stairs_foot` mountain edge).
- **Map node and zone:** `map.marnadal_watch`, reached from `map.tigg` (valley edge, no condition). The node is revealed by the lowlands d8 4 deserter card (`flag.marnadal_watch_hook`), by rumor r15, or by plain discovery from Tigg. Zone: `zone.marnadal_watch_tower`.
- **Milestones:** none set. Lighting the beacon reads `ded.reversed_oath_plan` (from Vel Aram) or `ms.act2_twist`.
- **Payoff:** `flag.watch_signal_lit`. In the finale, `ally.kosk_cavalry` joins only if `flag.watch_signal_lit` **and** `rep_tier(faction.crown) >= friendly` (gdd §6.13). This quest gives Crown +5 for restoring the beacon, +10 for lighting it, and +5 if Rask's men return to duty.
- **Stage variants:**
  - **Stage 1:** autumn mud, a grey sky, deserters cooking stolen sheep in the village.
  - **Stage 2 (Dark River):** snow on the beacon platform, and the river in the gorge below runs black. The deserters talk of leaving for Sodden. The zone gets a cold rate on the platform only (described in the variant; the platform brazier is a warmth source once lit).
  - **Stage 3 (Open Knives):** Choir agents work openly. If the beacon is restored, a Choir raid comes up the cliff path to topple it on the player's next visit (`enc.watch_choir_raid`, or `enc.watch_choir_raid_garrisoned` if Rask's men are back).
  - **Stage 4 (Solstice, Act III):** if the player ordered Tobin to light the beacon when word came, it is burning as the player arrives and the flag is set on entry. Otherwise the player lights it by hand. Deserters who were not brought back have gone.

## 3. Location layout
The Watch stands on a knuckle of rock with the gorge on its east side. The road climbs from the south through the burned village, under the gatehouse arch and into the yard. The square tower is four storeys tall. Its roof is the beacon platform: an iron fire-cage on a stone plinth, open to the wind. A goat path, the **cliff path**, climbs the gorge face on the east and comes out behind the barracks. It is how the Choir raid arrives, and how a careful player can reach the deserters' store unseen.

Route: road gate → village (deserters, Rask) → gatehouse → yard → tower door (Tobin) → tower stair → beacon platform. Sight lines: from the beacon platform the player can see the whole village and the cliff path. From the village, the tower door is in plain view, so guards notice anyone forcing it.

Cover: the village has half-burned cottage walls, a stone well and stacked turf. The yard has a collapsed hay wain, the barracks porch and the cistern lip. The platform has the plinth and a crenellated parapet (crossbowmen use the parapet gaps).

```yaml zone
id: zone.marnadal_watch_tower
name: "Marnadal Watch"
kind: exterior
map_node: map.marnadal_watch
time_of_day: dusk
cold_rate: 0
disguise_tag: null
music: watch_wind_desolate
areas:
  - {id: road_gate, description: "Muddy switchback below the village. A toppled waymarker carved with the Lion. Default arrival."}
  - {id: village, description: "Six burned cottages round a stone well. Deserters' lean-tos, a cookfire, sheep bones, a tethered mule. Rask holds court on an upturned cart."}
  - {id: pitch_store, description: "The old smithy, roof intact, door chained. Three pitch kegs inside under sacking. The back wall's planks are rotten."}
  - {id: gatehouse, description: "Arch with a jammed portcullis stuck half-down. Crouch under it. Murder-holes above, empty."}
  - {id: yard, description: "Flagged yard, cistern with a cracked lip, collapsed hay wain, barracks with doors kicked in, the captain's grave under a cairn of roof slates."}
  - {id: barracks, description: "Empty bunks, a pay chest broken open and empty, a muster board with names scratched out one by one."}
  - {id: tower_door, description: "Iron-studded oak door, barred from inside. A slit window above it where Tobin's crossbow shows."}
  - {id: tower_stair, description: "Spiral stair, four landings: guardroom, store, the captain's room, the bell loft. Tobin's bedroll on the third landing."}
  - {id: beacon_platform, description: "Roof of the tower. Iron fire-cage on a plinth, two of its four bands snapped. A brazier, a signal horn on a chain, the parapet."}
  - {id: cliff_path, description: "Goat path up the gorge face from the river. Loose scree, a rope rail half-rotted. Comes out behind the barracks."}
spawns:
  - {id: road_arrival, area: road_gate, default: true}
  - {id: cliff_top, area: cliff_path, default: false}
  - {id: platform, area: beacon_platform, default: false}
  - {id: village_fire, area: village, default: false}
exits: []
interactables:
  - id: road_board
    area: road_gate
    kind: map_board
    label: "Take the road"
    condition: "true"
    check: null
    once: false
    effects: []
  - id: muster_board
    area: barracks
    kind: readable
    label: "Read the muster board"
    condition: "true"
    check: null
    once: true
    effects: []
  - id: pay_chest
    area: barracks
    kind: search
    label: "Search the broken pay chest"
    condition: "true"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["add_crowns(6)"]
    fail_effects: []
  - id: tower_door_knock
    area: tower_door
    kind: door
    label: "Hail the tower"
    condition: "true"
    check: null
    once: false
    effects: ["start_dialogue(dlg.tobin_main)"]
  - id: pitch_store_door
    area: pitch_store
    kind: door
    label: "Break the chain on the smithy door"
    condition: "not flag(flag.watch_pitch_taken) and not flag(flag.watch_deserters_dealt)"
    check: null
    once: true
    effects: []
  - id: pitch_store_backwall
    area: pitch_store
    kind: search
    label: "Work loose the rotten back planks"
    condition: "not flag(flag.watch_pitch_taken)"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["give_item(item.beacon_pitch, 3)", "set_flag(flag.watch_pitch_taken)"]
    fail_effects: []
  - id: pitch_kegs
    area: pitch_store
    kind: pickup
    label: "Take the pitch kegs"
    condition: "flag(flag.watch_deserters_dealt) and not flag(flag.watch_pitch_taken)"
    check: null
    once: true
    effects: ["give_item(item.beacon_pitch, 3)", "set_flag(flag.watch_pitch_taken)"]
  - id: beacon_cage
    area: beacon_platform
    kind: search
    label: "Refit the snapped bands of the fire-cage"
    condition: "flag(flag.tobin_trusts) and not flag(flag.watch_cage_repaired)"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["set_flag(flag.watch_cage_repaired)", "complete_objective(quest.side_marnadal_watch, repair_cage)"]
    fail_effects: []
  - id: beacon_fuel
    area: beacon_platform
    kind: search
    label: "Stack the pitch kegs in the cage"
    condition: "flag(flag.watch_cage_repaired) and items(item.beacon_pitch) >= 3 and not flag(flag.watch_beacon_restored)"
    check: null
    once: true
    effects: ["take_item(item.beacon_pitch, 3)", "set_flag(flag.watch_beacon_restored)", "add_rep(faction.crown, 5)", "play_beat(beacon_built)"]
  - id: beacon_torch
    area: beacon_platform
    kind: lever
    label: "Light the beacon"
    condition: "flag(flag.watch_beacon_restored) and not flag(flag.watch_signal_lit) and (ded(ded.reversed_oath_plan) or ms(ms.act2_twist))"
    check: null
    once: true
    effects: ["set_flag(flag.watch_signal_lit)", "add_rep(faction.crown, 10)", "play_beat(beacon_lit)"]
  - id: platform_brazier
    area: beacon_platform
    kind: rest
    label: "Rest by the brazier"
    condition: "flag(flag.tobin_trusts)"
    check: null
    once: false
    effects: ["heal_player(full)"]
  - id: captain_cairn
    area: yard
    kind: readable
    label: "Read the slate on the captain's cairn"
    condition: "true"
    check: null
    once: true
    effects: []
triggers:
  - id: tobin_warning_shot
    area: gatehouse
    on: enter
    source: null
    condition: "not flag(flag.tobin_trusts)"
    once: true
    effects: ["play_beat(warning_bolt)"]
  - id: deserters_notice_store
    area: pitch_store
    on: interact
    source: pitch_store_door
    condition: "not flag(flag.watch_deserters_dealt)"
    once: true
    effects: ["start_dialogue(dlg.rask_caught_thief)"]
  - id: choir_raid_alone
    area: yard
    on: enter
    source: null
    condition: "stage() >= 3 and flag(flag.watch_beacon_restored) and not flag(flag.watch_raid_repelled) and not flag(flag.rask_returned)"
    once: false
    effects: ["play_beat(raid_horns)", "start_encounter(enc.watch_choir_raid)"]
  - id: choir_raid_garrisoned
    area: yard
    on: enter
    source: null
    condition: "stage() >= 3 and flag(flag.watch_beacon_restored) and not flag(flag.watch_raid_repelled) and flag(flag.rask_returned)"
    once: false
    effects: ["play_beat(raid_horns)", "start_encounter(enc.watch_choir_raid_garrisoned)"]
  - id: tobin_lit_it
    area: road_gate
    on: enter
    source: null
    condition: "ms(ms.act2_twist) and flag(flag.tobin_ordered_to_light) and flag(flag.watch_beacon_restored) and not flag(flag.watch_signal_lit)"
    once: true
    effects: ["set_flag(flag.watch_signal_lit)", "add_rep(faction.crown, 10)", "play_beat(beacon_already_burning)"]
hazards:
  - {id: cliff_scree, area: cliff_path, kind: trap, params: {slide_damage: 15, check_skill: agility}}
  - {id: gorge_drop, area: cliff_path, kind: collapse, params: {fall: lethal}}
  - {id: platform_wind, area: beacon_platform, kind: cold, params: {cold_rate_when_stage_ge_2: 2}}
  - {id: cookfire, area: village, kind: fire, params: {damage_per_second: 5}}
checkpoints:
  - {id: watch_arrival, area: road_gate}
  - {id: before_deserters, area: village}
  - {id: before_raid, area: yard}
beats:
  - {id: warning_bolt, description: "A crossbow bolt thunks into the gatehouse post a hand's width from the player. A cracking voice: 'Next one's your throat!'"}
  - {id: tobin_unbars, description: "The bar scrapes, the door opens a crack. A thin boy in a too-big Watch tabard, crossbow shaking."}
  - {id: rask_kneels, description: "Rask unbuckles the Watch badge he kept in his purse and pins it back on. His men follow, one by one, not looking at each other."}
  - {id: beacon_built, description: "The kegs settle into the cage. Tobin claps a hand on the iron and laughs once, too loud."}
  - {id: beacon_lit, description: "Pitch catches with a roar. A column of black smoke and orange light. Far to the north, minutes later, a second point of fire answers, then a third."}
  - {id: beacon_already_burning, description: "Smoke stands over the Watch before the player reaches the gate. Tobin waves from the parapet with both arms."}
  - {id: raid_horns, description: "A bone horn below the cliff. Pale-feathered figures climb over the gorge lip with pry-bars and oil."}
npcs:
  - {npc: npc.squire_tobin, area: tower_door, condition: "not flag(flag.tobin_trusts)"}
  - {npc: npc.squire_tobin, area: beacon_platform, condition: "flag(flag.tobin_trusts)"}
  - {npc: npc.sergeant_rask, area: village, condition: "not flag(flag.rask_returned) and not flag(flag.watch_deserters_dealt)"}
  - {npc: npc.sergeant_rask, area: yard, condition: "flag(flag.rask_returned)"}
encounters: [enc.watch_deserters, enc.watch_choir_raid, enc.watch_choir_raid_garrisoned]
loot:
  - {container: barracks_locker, items: [{item: item.poultice, count: 2}], condition: "true"}
  - {container: captain_chest, items: [{item: item.field_draught, count: 1}], condition: "flag(flag.tobin_trusts)"}
variants:
  - id: snow_stage2
    when: "stage() >= 2"
    description: "Snow lies on the platform and the parapet. The gorge river runs black with silt. The platform's wind hazard applies cold; the lit brazier and, later, the beacon are warmth sources. Deserters argue about walking to Sodden."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: choir_open_stage3
    when: "stage() >= 3"
    description: "A pale feather is nailed to the gatehouse post. Fresh boot prints on the cliff path."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: deserters_gone_act3
    when: "act() == 3 and not flag(flag.rask_returned)"
    description: "The village is empty: cold cookfire, the mule gone. Whoever was left took the Strept road or the Sodden one."
    npcs_absent: [npc.sergeant_rask]
    encounters_disabled: [enc.watch_deserters]
    interactables_disabled: [pitch_store_door]
  - id: deserters_gone_act3_store_open
    when: "act() == 3 and not flag(flag.rask_returned) and not flag(flag.watch_pitch_taken)"
    description: "The deserters left the smithy chain hanging open. The kegs are still there under the sacking."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: beacon_burning
    when: "flag(flag.watch_signal_lit)"
    description: "The beacon burns day and night. Tobin keeps it fed with roof timbers. The northern fires answer."
    npcs_absent: []
    encounters_disabled: [enc.watch_choir_raid, enc.watch_choir_raid_garrisoned]
    interactables_disabled: [beacon_torch]
```

Note on the Act III store: when the deserters are gone, `flag.watch_deserters_dealt` is set on entry by Tobin's dialogue (node `act3_gone`), which enables `pitch_kegs`, so the fuel is never lost.

## 4. NPCs present
**Voice notes.**
- **Tobin Ashe:** sixteen, a wool merchant's third son, bought into the Watch as a squire last spring. His voice cracks under stress. He quotes the dead captain's standing orders word for word as if they were scripture. He is brave in the way of someone who has not yet been hurt. He calls the player "sir" or "ma'am" whatever they say, until they tell him not to.
- **Sergeant Rask:** fifty, a Marnadal veteran with a ruined knee, flat northern vowels and no illusions. He speaks in short sums: what he's owed, what he has, what it costs. He is not cruel. He is tired, and ashamed of it, and the shame comes out as contempt. He calls Tobin "the boy" and never by name, because he is afraid of liking him.

```yaml npc
id: npc.squire_tobin
name: "Tobin Ashe"
faction: faction.crown
role: "Squire of Marnadal Watch, its last garrison"
motive: "Keep the beacon ready as the dead captain ordered, and not die alone doing it."
secret: "He has never fired the crossbow at a man. The bolt at the gate was meant to miss, and it nearly didn't."
disposition: wary
essential: true
dialogue: dlg.tobin_main
barks: ["Standing orders: the beacon is not to go dark.", "Who goes there? I mean it!", "The captain said the fire speaks for us when we can't.", "Rask isn't wicked. He's just stopped."]
combat: null
shop: null
```

```yaml npc
id: npc.sergeant_rask
name: "Sergeant Rask"
faction: faction.crown
role: "Deserted sergeant of Marnadal Watch, leader of the deserters"
motive: "Get his men paid or get them away alive before whatever is waking in Amell comes down the road."
secret: "He buried the captain himself and kept the Watch badge in his purse. He would go back if anyone gave him a reason he could say out loud."
disposition: wary
essential: false
dialogue: dlg.rask_camp
barks: ["Two seasons. Not a copper.", "The Crown wants a watch, the Crown can pay a watch.", "Ground shakes at night. You feel it? We feel it.", "Mind the cookfire. And mind your hands."]
combat: enemy.bandit
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.tobin_main
participants: [npc.squire_tobin]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "act() == 3 and not flag(flag.rask_returned) and not flag(flag.watch_deserters_dealt)", next: act3_gone}
      - {if: "flag(flag.tobin_trusts)", next: hub_intro}
    else: gate_first
  act3_gone:
    type: line
    speaker: npc.squire_tobin
    text: "They left in the night. Rask didn't say goodbye. He left the smithy chain open, though. I think that was goodbye."
    effects: ["set_flag(flag.watch_deserters_dealt)", "set_flag(flag.tobin_trusts)"]
    next: hub_intro
  gate_first:
    type: line
    speaker: npc.squire_tobin
    text: "Stand where I can see you! This is a Crown fortification and I am its garrison. All of it."
    direction: "Through the slit window above the door. Crossbow tip trembling."
    next: gate_choice
  gate_choice:
    type: choice
    options:
      - id: writ
        text: "I carry the Lord Marshal's writ. Read the seal. [Item: Marshal's writ]"
        tag: item
        condition: "has_item(item.kosk_writ)"
        show_locked: true
        next: gate_writ
      - id: persuade
        text: "You've held this tower alone. That's done. Let me help you hold it. [Persuade 4]"
        tag: persuade
        check: {skill: persuade, dc: 4, pass: gate_open, fail: gate_suspicious}
      - id: intimidate
        text: "Open the door before I take it off its hinges. [Intimidate 6]"
        tag: intimidate
        check: {skill: intimidate, dc: 6, pass: gate_scared, fail: gate_suspicious}
      - id: disarm
        text: "Lay down your sword in the mud and step back from the door."
        next: gate_disarm
      - id: leave
        text: "Keep your tower, boy."
        next: bye
  gate_writ:
    type: line
    speaker: npc.squire_tobin
    text: "That's... that's the Marshal's lion. Gods. Wait. The bar sticks."
    effects: ["set_flag(flag.tobin_trusts)", "play_beat(tobin_unbars)"]
    next: inside_intro
  gate_open:
    type: line
    speaker: npc.squire_tobin
    text: "The captain said a true man asks to help and a liar asks to come in. You asked to help. Wait there."
    effects: ["set_flag(flag.tobin_trusts)", "play_beat(tobin_unbars)"]
    next: inside_intro
  gate_scared:
    type: line
    speaker: npc.squire_tobin
    text: "All right! All right. Don't. The door's older than both of us."
    effects: ["set_flag(flag.tobin_trusts)", "play_beat(tobin_unbars)"]
    next: inside_intro
  gate_suspicious:
    type: line
    speaker: npc.squire_tobin
    text: "That's what Rask's men say before they try the door. Prove it some other way."
    next: gate_choice
  gate_disarm:
    type: line
    speaker: npc.squire_tobin
    direction: "A long pause. The crossbow withdraws."
    text: "Nobody's done that. Rask's lot just shout. All right. You can pick it up again inside."
    effects: ["set_flag(flag.tobin_trusts)", "play_beat(tobin_unbars)"]
    next: inside_intro
  inside_intro:
    type: line
    speaker: npc.squire_tobin
    text: "Tobin Ashe, squire. The garrison walked when the pay stopped. Captain Mallory died of the lung-rot. I've kept the bell and the beacon. The beacon's broken."
    next: start_q
  start_q:
    type: branch
    cases:
      - {if: "quest_active(quest.side_marnadal_watch) or quest_done(quest.side_marnadal_watch)", next: hub}
    else: start_q_fx
  start_q_fx:
    type: effect
    effects: ["start_quest(quest.side_marnadal_watch)", "complete_objective(quest.side_marnadal_watch, meet_tobin)"]
    next: hub
  hub_intro:
    type: line
    speaker: npc.squire_tobin
    text: "Sir. The fire's still waiting."
    next: hub
  hub:
    type: choice
    options:
      - id: what_beacon
        text: "Tell me about the beacon."
        next: about_beacon
      - id: what_rask
        text: "Who's camped in the village?"
        next: about_rask
      - id: help_cage
        text: "Show me how the cage goes back together."
        condition: "not flag(flag.watch_cage_repaired)"
        next: cage_help
      - id: when_light
        text: "The beacon's ready. Why not light it now?"
        condition: "flag(flag.watch_beacon_restored) and not flag(flag.watch_signal_lit) and not ded(ded.reversed_oath_plan) and not ms(ms.act2_twist)"
        next: too_early
      - id: light_now
        text: "I know where the Choir is going. Amell. It's time."
        condition: "flag(flag.watch_beacon_restored) and not flag(flag.watch_signal_lit) and (ded(ded.reversed_oath_plan) or ms(ms.act2_twist))"
        next: light_crown_check
      - id: order_tobin
        text: "If word comes that the Choir marches on Amell, light it yourself."
        condition: "flag(flag.watch_beacon_restored) and not flag(flag.watch_signal_lit) and not flag(flag.tobin_ordered_to_light)"
        next: order_given
      - id: varn_pay
        text: "Do you know why the pay stopped?"
        condition: "has_item(item.varn_ledger_scrap) or flag(flag.varn_blackmailed)"
        next: pay_truth
      - id: bye_opt
        text: "Keep the bar on the door."
        next: bye
  about_beacon:
    type: line
    speaker: npc.squire_tobin
    text: "First fire on the southern chain. Light it, and Hollow Hill sees it, then Tigg Church, then the Cintra walls. It means one thing only: the enemy marches on the mountains. The Marshal's horse rides on it."
    next: about_beacon_2
  about_beacon_2:
    type: line
    speaker: npc.squire_tobin
    text: "The cage snapped two bands in the frost. And the pitch is in the smithy. Rask's lot chained it. Said it's worth more sold than burned."
    next: hub
  about_rask:
    type: line
    speaker: npc.squire_tobin
    text: "Sergeant Rask and eleven men. Nine now. They don't hurt me. They just stopped. Rask says a watch nobody pays is a joke nobody laughs at."
    next: hub
  cage_help:
    type: line
    speaker: npc.squire_tobin
    text: "Captain made me learn it. Hot-drift the band, wedge it, quench it with the cistern water. I can't hold the hammer and the tongs both. You can."
    direction: "Tobin leads up to the platform. The repair plays as a short two-person scene."
    effects: ["set_flag(flag.watch_cage_repaired)", "complete_objective(quest.side_marnadal_watch, repair_cage)"]
    next: hub
  too_early:
    type: line
    speaker: npc.squire_tobin
    text: "Because it only says one thing, and it only says it once. Light it now and the Marshal rides south to an empty mountain. Find out where they're going. Then we light it."
    next: hub
  light_crown_check:
    type: branch
    cases:
      - {if: "rep_tier(faction.crown) >= friendly", next: light_go}
    else: light_warn
  light_warn:
    type: line
    speaker: npc.squire_tobin
    text: "The captain said the Marshal rides for a fire, but he rides harder for a friend. If he doesn't know your name, he may send a troop, not the whole horse. Light it anyway?"
    next: light_warn_choice
  light_warn_choice:
    type: choice
    options:
      - id: light_anyway
        text: "Light it. Let him decide what to send."
        next: light_go
      - id: wait
        text: "Not yet."
        next: hub
  light_go:
    type: line
    speaker: npc.squire_tobin
    text: "Then go up and give it the torch, sir. It should be you. I'll ring the bell."
    direction: "The player lights it with the beacon_torch interactable."
    next: bye
  order_given:
    type: line
    speaker: npc.squire_tobin
    text: "When the Abbey's people are known to march on Amell. Yes. I'll watch the road from the platform. If I see them, or a rider brings it, I'll light it before you're back."
    effects: ["set_flag(flag.tobin_ordered_to_light)"]
    next: hub
  pay_truth:
    type: line
    speaker: npc.squire_tobin
    text: "The Chancellor's toll money paid the Watch? And he... Gods. Tell Rask. Not me. Tell Rask."
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.rask_camp
participants: [npc.sergeant_rask]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "flag(flag.rask_returned)", next: returned_hub}
    else: open
  open:
    type: line
    speaker: npc.sergeant_rask
    text: "Another one come up the road with clean boots. If the Crown sent you, you can tell the Crown it owes nine men two seasons' wages and one captain a decent burial."
    direction: "Seated on an upturned cart, whittling. Doesn't get up."
    next: hub
  hub:
    type: choice
    options:
      - id: why
        text: "Why did you leave the tower?"
        next: why_left
      - id: buy_pitch
        text: "I'll buy the pitch kegs. [Bribe 40]"
        tag: bribe
        bribe: 40
        effects: ["give_item(item.beacon_pitch, 3)", "set_flag(flag.watch_pitch_taken)"]
        next: sold
      - id: pardon
        text: "The Marshal pardons deserters who come back to their post. I'll carry your names to him. [Persuade 6]"
        tag: persuade
        condition: "not flag(flag.rask_refused)"
        check: {skill: persuade, dc: 6, pass: return_pass, fail: return_fail}
        once: true
      - id: friend_of_crown
        text: "Kosk knows my name. If I say you came back, he'll believe it. [Persuade 4]"
        tag: persuade
        condition: "rep_tier(faction.crown) >= friendly and not flag(flag.rask_refused)"
        show_locked: true
        check: {skill: persuade, dc: 4, pass: return_pass, fail: return_fail}
        once: true
      - id: arrears
        text: "Two seasons' wages. Here. Now go back up that hill. [Bribe 100]"
        tag: bribe
        bribe: 100
        next: return_paid
      - id: evidence
        text: "Your pay didn't vanish. Chancellor Varn skimmed the river tolls that fed it. Here's his own ledger. [Clue]"
        tag: clue
        condition: "has_item(item.varn_ledger_scrap) or flag(flag.varn_blackmailed)"
        show_locked: true
        next: return_evidence
      - id: threaten
        text: "Hand over the pitch and walk away, or I hang the lot of you as deserters. [Intimidate 6]"
        tag: intimidate
        check: {skill: intimidate, dc: 6, pass: scared_off, fail: fight_start}
        once: true
      - id: fight
        text: "Then I'll take the pitch."
        next: fight_start
      - id: leave
        text: "Enjoy your mutton."
        next: bye
  why_left:
    type: line
    speaker: npc.sergeant_rask
    text: "Pay stopped. Bread stopped. Captain coughed his lungs up and the relief never came. And the ground shakes under Amell at night like something turning over in its sleep. We're soldiers. Not offerings."
    next: why_left_2
  why_left_2:
    type: line
    speaker: npc.sergeant_rask
    text: "The boy stayed. Fine. Somebody has to be the fool in every story."
    next: hub
  sold:
    type: line
    speaker: npc.sergeant_rask
    text: "Silver's silver. Take your kegs. Burn them for whatever lord you like."
    effects: ["complete_objective(quest.side_marnadal_watch, get_pitch)"]
    next: bye
  return_pass:
    type: line
    speaker: npc.sergeant_rask
    text: "Pardon. Names carried. You know how many times I've heard a Crown man promise? But you came up here. Nobody else did."
    next: returned_fx
  return_fail:
    type: line
    speaker: npc.sergeant_rask
    text: "Words. I've eaten better words than those, and I'm still hungry."
    effects: ["set_flag(flag.rask_refused)"]
    next: hub
  return_paid:
    type: line
    speaker: npc.sergeant_rask
    text: "That's real coin. Not a promise. Fine. A paid watch is a watch."
    next: returned_fx
  return_evidence:
    type: line
    speaker: npc.sergeant_rask
    direction: "Reads it twice. His jaw works."
    text: "So it wasn't the war, or the plague, or the will of the gods. It was a fat man's purse. Then we don't owe him. We owe the boy, and the captain under those slates."
    next: returned_fx
  returned_fx:
    type: effect
    effects: ["set_flag(flag.rask_returned)", "set_flag(flag.watch_deserters_dealt)", "give_item(item.beacon_pitch, 3)", "set_flag(flag.watch_pitch_taken)", "add_rep(faction.crown, 5)", "complete_objective(quest.side_marnadal_watch, get_pitch)", "play_beat(rask_kneels)"]
    next: returned_line
  returned_line:
    type: line
    speaker: npc.sergeant_rask
    text: "Kegs are yours. My lads'll take the walls. Tell the boy... no. I'll tell him."
    next: bye
  scared_off:
    type: line
    speaker: npc.sergeant_rask
    text: "We're not dying for pitch. Take it. We'll be on the Sodden road by dark, and you can hang the wind."
    effects: ["set_flag(flag.watch_deserters_dealt)", "add_rep(faction.crown, -2)"]
    next: bye
  fight_start:
    type: effect
    effects: ["start_encounter(enc.watch_deserters)"]
    next: bye
  returned_hub:
    type: choice
    options:
      - id: report
        text: "Report, Sergeant."
        next: returned_report
      - id: bye2
        text: "As you were."
        next: bye
  returned_report:
    type: branch
    cases:
      - {if: "stage() >= 3", next: report_choir}
    else: report_quiet
  report_choir:
    type: line
    speaker: npc.sergeant_rask
    text: "Feathers on the cliff path. They'll come for the fire. Let them. We've got walls again."
    next: bye
  report_quiet:
    type: line
    speaker: npc.sergeant_rask
    text: "Walls manned. The boy's asleep for once. Ground still shakes. We shake back."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.rask_caught_thief
participants: [npc.sergeant_rask]
start: caught
nodes:
  caught:
    type: line
    speaker: npc.sergeant_rask
    text: "Hands off the chain. That pitch is the only pay we're getting this year."
    direction: "Three deserters step up behind him."
    next: caught_choice
  caught_choice:
    type: choice
    options:
      - id: talk
        text: "Let's talk about pay, then."
        effects: ["start_dialogue(dlg.rask_camp)"]
        next: bye
      - id: fight
        text: "Then come and stop me."
        effects: ["start_encounter(enc.watch_deserters)"]
        next: bye
      - id: back
        text: "Fine. I'm going."
        next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.rask_yielded
participants: [npc.sergeant_rask, npc.squire_tobin]
start: down
nodes:
  down:
    type: line
    speaker: npc.sergeant_rask
    text: "Enough. Enough. You've made your point on my ribs. Kill me or say what you want."
    direction: "On one knee in the mud, sword thrown aside."
    next: down_choice
  down_choice:
    type: choice
    options:
      - id: return
        text: "Get up and go back to your post. [Persuade 4]"
        tag: persuade
        check: {skill: persuade, dc: 4, pass: yield_return, fail: yield_leave}
      - id: spare
        text: "Take your men and go."
        next: yield_leave
      - id: execute
        text: "Deserters hang."
        next: yield_execute
  yield_return:
    type: line
    speaker: npc.sergeant_rask
    text: "Beaten back to duty. There's a song in that somewhere. A bad one."
    effects: ["set_flag(flag.rask_returned)", "add_rep(faction.crown, 5)", "play_beat(rask_kneels)"]
    next: bye
  yield_leave:
    type: line
    speaker: npc.sergeant_rask
    text: "We'll go. Watch the cliff path. We were the only ones who did."
    next: bye
  yield_execute:
    type: line
    speaker: npc.squire_tobin
    text: "Don't! Please. He buried the captain. He buried him with his own hands."
    direction: "Tobin from the gatehouse. The player's choice stands; the game plays the execution off-screen if the player confirms."
    next: execute_confirm
  execute_confirm:
    type: choice
    options:
      - id: confirm
        text: "The law is the law."
        effects: ["add_rep(faction.crown, 2)", "set_flag(flag.rask_executed)"]
        next: bye
      - id: relent
        text: "Go. Before I change my mind."
        next: yield_leave
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.watch_deserters
zone: zone.marnadal_watch_tower
enemies:
  - {enemy: enemy.bandit, count: 1, spawn: village_fire, variant: shield}
  - {enemy: enemy.bandit, count: 2, spawn: village_fire, variant: spear}
  - {enemy: enemy.bandit, count: 1, spawn: village_fire, variant: sword}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: before_deserters
avoidable_by: ["dlg.rask_camp"]
on_won: ["set_flag(flag.watch_deserters_dealt)", "add_rep(faction.crown, -2)"]
on_yielded: ["set_flag(flag.watch_deserters_dealt)", "start_dialogue(dlg.rask_yielded)"]
on_player_fled: []
```
The shield bandit is Rask (L6 stat block). The other three are L5 variants. They fight in the village among the cottage walls and the cookfire. Rask yields at 20% HP. If he yields, the others break and run.

```yaml encounter
id: enc.watch_choir_raid
zone: zone.marnadal_watch_tower
enemies:
  - {enemy: enemy.choir_zealot, count: 2, spawn: cliff_top, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 2, spawn: cliff_top, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: [npc.squire_tobin]
checkpoint: before_raid
avoidable_by: []
on_won: ["set_flag(flag.watch_raid_repelled)", "add_rep(faction.crown, 3)"]
on_yielded: []
on_player_fled: []
```
The zealots go for the tower stair with pry-bars to topple the fire-cage. The crossbowmen take the barracks roof. Tobin shoots from the parapet (scripted ally: one bolt every few seconds at the nearest zealot, low damage). The stage 3 rule adds +1 Choir member automatically (gdd §6.1). If the player leaves through the map board mid-fight, the raid has not succeeded: the trigger re-arms on the next visit, and the beacon stays restored. The raid never destroys the beacon off-screen. **Non-combat alternative:** none for the raid itself (the Choir is always hostile), but Rask's returned men turn it into the easier garrisoned version below.

```yaml encounter
id: enc.watch_choir_raid_garrisoned
zone: zone.marnadal_watch_tower
enemies:
  - {enemy: enemy.choir_zealot, count: 2, spawn: cliff_top, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 2, spawn: cliff_top, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: [npc.squire_tobin, npc.sergeant_rask]
checkpoint: before_raid
avoidable_by: []
on_won: ["set_flag(flag.watch_raid_repelled)", "add_rep(faction.crown, 3)"]
on_yielded: []
on_player_fled: []
```
Same raid. Rask and two returned deserters (scripted allies) hold the gatehouse and the barracks porch, so the crossbowmen never get the barracks roof.

## 7. Items and clues

```yaml item
id: item.beacon_pitch
name: "Pitch keg"
category: key
description: "A small keg of pine pitch stamped with the Watch's tower mark. Three of them will feed the Marnadal beacon."
price: 0
stack_max: 3
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

Readables (zone text, not items):
- **Muster board:** "Marnadal Watch, autumn muster. Capt. E. Mallory. Sgt. Rask. Squire T. Ashe. Twelve men." Eleven names are scratched out, each in a different hand. The last line, in a careful boy's hand: "T. Ashe. Present."
- **Captain's cairn slate:** "Eadric Mallory, Captain. He kept the fire. Buried by Rask."

No clues. This quest pays off in ally terms, not investigation. The Varn evidence it reads belongs to Act I.

## 8. Flags set and read

```yaml flags
declare:
  - {id: flag.watch_beacon_restored, type: bool, desc: "The Marnadal beacon's cage is repaired and fuelled."}
  - {id: flag.watch_signal_lit, type: bool, desc: "The Marnadal beacon was lit. Kosk's cavalry rides for Amell (finale ally if Crown >= Friendly)."}
  - {id: flag.rask_returned, type: bool, desc: "Rask and his deserters returned to duty."}
  - {id: flag.watch_cage_repaired, type: bool, desc: "Fire-cage bands refitted."}
  - {id: flag.watch_pitch_taken, type: bool, desc: "The player has the deserters' pitch kegs."}
  - {id: flag.watch_deserters_dealt, type: bool, desc: "The deserters are no longer guarding the store (fought, scared off, returned, or gone in Act III)."}
  - {id: flag.watch_raid_repelled, type: bool, desc: "The stage 3 Choir raid on the beacon was beaten."}
  - {id: flag.tobin_trusts, type: bool, desc: "Tobin opened the tower to the player."}
  - {id: flag.tobin_ordered_to_light, type: bool, desc: "Tobin will light the beacon himself once the Choir's goal is known (applies on the player's next arrival after the twist)."}
  - {id: flag.rask_refused, type: bool, desc: "Rask rejected the player's first plea; persuasion options are closed (bribe and evidence remain)."}
  - {id: flag.rask_executed, type: bool, desc: "The player hanged Rask as a deserter."}
reads:
  - ms.act1_complete
  - ms.act2_twist
  - ded.reversed_oath_plan
  - flag.marnadal_watch_hook
  - flag.varn_blackmailed
  - item.varn_ledger_scrap
  - item.kosk_writ
```

## 9. Quest hooks

```yaml quest
id: quest.side_marnadal_watch
kind: side
title: "The Fire That Speaks"
giver: npc.squire_tobin
available: "ms(ms.act1_complete)"
closes_on: null
xp: 450
stages:
  - id: reach_the_watch
    journal: "A deserter on the king's road said Marnadal Watch stands empty but for one boy who won't come down. The Watch holds the first beacon of the southern chain."
    objectives:
      - {id: meet_tobin, text: "Get inside Marnadal Watch", condition: "flag(flag.tobin_trusts)", optional: false}
    on_complete: []
    next: []
  - id: restore_beacon
    journal: "Squire Tobin Ashe has held the Watch alone. The beacon's cage is broken and the pitch sits in the deserters' smithy below."
    objectives:
      - {id: get_pitch, text: "Get the pitch kegs from the deserters' store", condition: "items(item.beacon_pitch) >= 3 or flag(flag.watch_beacon_restored)", optional: false}
      - {id: repair_cage, text: "Repair the beacon's fire-cage", condition: "flag(flag.watch_cage_repaired)", optional: false}
      - {id: fuel_beacon, text: "Stack the pitch in the cage", condition: "flag(flag.watch_beacon_restored)", optional: false}
      - {id: rask_back, text: "Bring Rask's men back to duty", condition: "flag(flag.rask_returned)", optional: true, xp: 120}
    on_complete: []
    next: []
  - id: wait_for_word
    journal: "The beacon is ready. It says one thing only, once: the enemy marches on the mountains. Light it when you know where the Choir is going."
    objectives:
      - {id: know_goal, text: "Learn where the Pale Choir is marching", condition: "ded(ded.reversed_oath_plan) or ms(ms.act2_twist)", optional: false}
      - {id: hold_raid, text: "Drive the Choir off the beacon", condition: "flag(flag.watch_raid_repelled)", optional: true, xp: 100}
    on_complete: []
    next: []
  - id: light_beacon
    journal: "The Choir marches on Karak Ostrel. Light the Marnadal beacon, and the chain will carry it to the Lord Marshal."
    objectives:
      - {id: lit, text: "Light the Marnadal beacon", condition: "flag(flag.watch_signal_lit)", optional: false}
    on_complete: []
    next: []
outcome_effects:
  completed: []
  failed: []
```

This side quest contributes no main-quest stages (content-format §H: a side quest does not receive `quest_stages`).

## 10. Rumors and event cards (optional)
The hook card (lowlands d8 4, the Watch deserter) and rumor r15 live in `13-travel-events.md` and `14-rumors.md`. Both set `flag.marnadal_watch_hook` and pin `map.marnadal_watch`.

## 11. Failure states and branches

```yaml branches
paths:
  - id: writ_or_talk_in
    when: "Player shows the writ, persuades, intimidates or lays down a weapon at the tower door."
    outcome: "flag.tobin_trusts; quest starts; brazier rest unlocked."
    sets: ["set_flag(flag.tobin_trusts)"]
  - id: rask_returns
    when: "Persuade 6 (Persuade 4 at Crown >= Friendly), Bribe 100, Varn evidence, or Persuade 4 after Rask yields."
    outcome: "Pitch handed over; deserters man the walls; Crown +5; raid becomes the garrisoned version."
    sets: ["set_flag(flag.rask_returned)", "set_flag(flag.watch_deserters_dealt)"]
  - id: buy_pitch
    when: "Bribe 40 for the kegs."
    outcome: "Pitch in hand; deserters stay in the village, neutral."
    sets: ["set_flag(flag.watch_pitch_taken)"]
  - id: steal_pitch
    when: "Investigate 6 on the rotten back wall of the smithy."
    outcome: "Pitch in hand without a confrontation."
    sets: ["set_flag(flag.watch_pitch_taken)"]
  - id: scare_or_fight
    when: "Intimidate 6, or fight enc.watch_deserters."
    outcome: "Deserters gone; Crown -2; kegs lootable from the smithy."
    sets: ["set_flag(flag.watch_deserters_dealt)"]
  - id: light_by_hand
    when: "Beacon restored and the Choir's goal known (ded.reversed_oath_plan or ms.act2_twist); player uses the beacon torch."
    outcome: "flag.watch_signal_lit; Crown +10; quest complete."
    sets: ["set_flag(flag.watch_signal_lit)"]
  - id: tobin_lights
    when: "Player ordered Tobin to light it; the player arrives at the Watch after ms.act2_twist."
    outcome: "Beacon burning on arrival; flag.watch_signal_lit set by the road_gate trigger."
    sets: ["set_flag(flag.watch_signal_lit)"]
failures:
  - id: player_dies
    result: reload_checkpoint
    recover: "Reload before_deserters or before_raid."
  - id: persuasion_failed
    result: soft_fail
    recover: "flag.rask_refused closes persuasion only. Bribe 100, the Varn evidence, buying the kegs, the back wall, intimidation and the fight stay open."
  - id: raid_abandoned
    result: soft_fail
    recover: "Leaving mid-raid changes nothing; the raid re-arms on the next visit. The beacon is never destroyed off-screen."
  - id: crown_not_friendly
    result: soft_fail
    recover: "The beacon still lights and the flag is set, but the finale cavalry also needs Crown >= Friendly. Tobin warns the player before lighting."
  - id: rask_executed
    result: soft_fail
    recover: "No returned garrison; the raid is the harder version. The quest still completes."
guarantees:
  - "flag.tobin_trusts reachable without a check (lay down your weapon)."
  - "Pitch reachable without a check: fight enc.watch_deserters and loot the store, or in Act III the deserters are gone and the store is open."
  - "Cage repair reachable without a check (Tobin's help in dlg.tobin_main)."
  - "flag.watch_signal_lit reachable without a check once ded.reversed_oath_plan or ms.act2_twist holds (beacon_torch interactable)."
```

## 12. Open questions
- Travel exits: the content format has no "to map" exit. This zone leaves via a `map_board` interactable (`road_board`). Confirm that `map_board` opens the travel map.
- `tobin_lit_it` sets the flag on the player's arrival, not at the moment of the twist. A player who never passes the Watch in Act III does not get the cavalry. Acceptable because `map.marnadal_watch` sits on a mountain edge to `stairs_foot`; flag for A06 that the Race South route choice should surface this node.
- Hazard `kind: cold` is used on the beacon platform with a stage parameter; zone `cold_rate` itself cannot change per variant in the schema. Proposal: allow `cold_rate` in variants.
- `item.field_draught` is referenced in the captain's chest loot. gdd §6.9 names the field draught but no id. Assumed `item.field_draught` (the same goes for `item.poultice`).
