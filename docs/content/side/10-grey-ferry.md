---
section_id: side.grey_ferry
title: "The Grey Ferry"
act: 2
story_ref: "story.md §10 Grey Ferry; §2 Battle of Marnadal (1263); §3 Kosk's secret; gdd §7.4, §6.1 stage 2 dark-river variant"
zones: [zone.grey_ferry_landing, zone.grey_ferry_crossing]
available_when: "ms(ms.act1_complete)"
escalation_stage_required: {min: 1, max: 4}
milestones_set: []
milestones_read: [ms.act1_complete]
level_band: [6, 10]
---

# The Grey Ferry

## 1. Scene summary
Below Ferrymen's Camp, the Marnadal narrows between clay bluffs, and an old rope ferry still crosses it. The ferryman never speaks. He takes a coin from the living and drops it in a clay bowl. He takes nothing from the dead, but he carries them too, and the drovers swear that the raft rides lower at dusk than its passengers explain. Among the dead who ride is Corporal Aled Venn, who died at Marnadal in 1263 and has been crossing back and forth ever since. If the player pays what he was owed, in silver or in honor, Venn will answer one question truthfully, and only one. The important question is what really happened at Marnadal. His answer gives the player the lie that made Lord Marshal Kosk burn the Strept halls, and it lets Kosk own his crime and apologize in Act III without being argued into it. The dramatic question: what will the player spend the one true thing on?

## 2. Progress and escalation
- **Availability:** Act II and Act III. Opens on `ms.act1_complete` (stage 1 or higher). Never closes.
- **Map node and zones:** `map.grey_ferry`, reached from `map.ferrymen_camp` (valley edge, no condition). Revealed by rumor r19, by the Ferrymen's Camp drovers (A05), or by plain discovery. Zones: `zone.grey_ferry_landing`, `zone.grey_ferry_crossing`.
- **Milestones:** none set.
- **Payoff:** `clue.grey_ferry_truth` unlocks `ded.marnadal_truth` (gdd §7.4), which lets the player get `item.kosk_apology` without a Presence 7 check (A06, Act III). The alternative answers give `clue.ghost_choir_road` (with a map pin to Vel Aram) or `clue.ghost_vault_weapons`.
- **Stage variants:**
  - **Stage 1:** grey autumn water, a fog bank midstream, the bowl half-full of old coins.
  - **Stage 2 (Dark River):** gdd §6.1 names the Grey Ferry's dark-river variant. The river runs black with mineral silt. The raft drags and the ferryman poles harder. Drowners driven out of the fouled shallows nest on the far shore (`enc.grey_ferry_drowners`). More dead ride the raft, and they are restless.
  - **Stage 3:** a Choir notice nailed to the rope post forbids "commerce with the damned" on the Abbey's authority. It has been torn half off.
  - **Stage 4:** snow on the bluffs and ice at the landing's edge. Venn still rides.

## 3. Location layout
**The landing** is a shelf of grey shingle at the foot of a clay bluff. The track comes down a cut in the bluff from the north. At the water's edge stands the rope post, a tarred oak trunk with the ferry rope running from an iron ring out into the fog. Beside it is the ferryman's lean-to with his bowl and his tally board, where a notch is cut for every crossing and a burned mark for every dead passenger. Upstream is the **drowned chapel**, a soldiers' chapel built after Marnadal and half-sunk when the bank slumped. Its nave is flooded to the knee and the altar stands dry on a step. The muster roll of Venn's company hangs there in a waxed bag, nailed to the altar by someone who could not bear to throw it away. Downstream, a **gibbet** stands on the shingle: an Abbey sentence on a ferry-thief, long rotted. The landing is open ground with little cover (the lean-to, the chapel doorway, an overturned skiff).

**The crossing** is the raft itself: twelve paces of tarred planks, a rail on two sides, the rope over the ferryman's shoulder. It moves into **mid channel**, where fog closes in and the dead become visible as grey shapes along the rails. At the far side is **the far shore**: a gravel spit with cairns the drovers built for drowned men and a bramble bank above. At stage 2 and above, the drowners lair there. The raft is a small arena. The rails give half-cover from crossbow fire, and going off the edge means deep water (the player is dragged back to the raft with damage, never drowned).

```yaml zone
id: zone.grey_ferry_landing
name: "The Grey Ferry"
kind: exterior
map_node: map.grey_ferry
time_of_day: dusk
cold_rate: 0
disguise_tag: null
music: grey_ferry_hush
areas:
  - {id: bluff_cut, description: "Track down through a clay cut from the north. Default arrival. Drovers' cart ruts, a rag tied to a thornbush for luck."}
  - {id: landing, description: "Grey shingle shelf. The tarred rope post and iron ring. The raft tied up, low in the water."}
  - {id: lean_to, description: "The ferryman's lean-to: a clay bowl of coins, a tally board of notches and burn marks, a pallet, a lantern that is never lit."}
  - {id: drowned_chapel, description: "Half-sunk soldiers' chapel. Flooded nave to the knee, rotten pews, a dry altar step. A waxed bag nailed to the altar."}
  - {id: gibbet, description: "Rotted Abbey gibbet downstream. An iron cage with bones. A brass plate: 'For theft of the ferry's silver.'"}
spawns:
  - {id: track_arrival, area: bluff_cut, default: true}
  - {id: raft_return, area: landing, default: false}
exits:
  - id: board_raft
    area: landing
    to_zone: zone.grey_ferry_crossing
    to_spawn: raft_bow
    condition: "flag(flag.ferry_fare_paid)"
    effects: []
interactables:
  - id: track_board
    area: bluff_cut
    kind: map_board
    label: "Climb back to the road"
    condition: "true"
    check: null
    once: false
    effects: []
  - id: ferryman
    area: landing
    kind: search
    label: "Approach the ferryman"
    condition: "true"
    check: null
    once: false
    effects: ["start_dialogue(dlg.ferryman_gestures)"]
  - id: tally_board
    area: lean_to
    kind: readable
    label: "Study the tally board"
    condition: "true"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["add_xp(30)"]
    fail_effects: []
  - id: coin_bowl
    area: lean_to
    kind: search
    label: "Take coins from the bowl"
    condition: "not flag(flag.ferryman_wronged)"
    check: null
    once: true
    effects: ["add_crowns(25)", "set_flag(flag.ferryman_wronged)", "play_beat(dead_turn)"]
  - id: muster_roll
    area: drowned_chapel
    kind: pickup
    label: "Take the waxed bag from the altar"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.marnadal_muster_roll, 1)"]
  - id: gibbet_plate
    area: gibbet
    kind: readable
    label: "Read the gibbet plate"
    condition: "true"
    check: null
    once: true
    effects: []
  - id: chapel_poor_box
    area: drowned_chapel
    kind: container
    label: "Search the chapel poor box"
    condition: "true"
    check: null
    once: true
    effects: []
triggers:
  - id: first_sight
    area: landing
    on: enter
    source: null
    condition: "not visited(zone.grey_ferry_crossing)"
    once: true
    effects: ["play_beat(raft_rides_low)"]
  - id: thief_punished
    area: landing
    on: interact
    source: coin_bowl
    condition: "true"
    once: true
    effects: ["start_encounter(enc.grey_ferry_revenants)"]
hazards:
  - {id: chapel_flood, area: drowned_chapel, kind: deep_mud, params: {speed_mult: 0.6}}
  - {id: river_edge, area: landing, kind: tide, params: {pull_back_damage: 10}}
checkpoints:
  - {id: ferry_arrival, area: bluff_cut}
beats:
  - {id: raft_rides_low, description: "The raft is empty, but it sits two hands deeper in the water than an empty raft should. The ferryman looks at the player, then at the bowl."}
  - {id: dead_turn, description: "Every grey shape the player has not yet noticed along the shingle turns its head at once."}
npcs:
  - {npc: npc.grey_ferryman, area: landing, condition: "true"}
encounters: [enc.grey_ferry_revenants]
loot:
  - {container: chapel_poor_box, items: [{item: item.poultice, count: 1}], condition: "true"}
variants:
  - id: dark_river
    when: "stage() >= 2"
    description: "The Marnadal runs black with silt. Oily scum on the shingle. Three more burn marks on the tally board since the last visit."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: choir_notice
    when: "stage() >= 3"
    description: "An Abbey notice nailed to the rope post, half torn away: '...forbidden all commerce with the damned, on pain of...'"
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: winter
    when: "stage() >= 4"
    description: "Snow on the bluffs, a skin of ice at the water's edge. The ferryman breaks it with his pole each crossing."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
```

```yaml zone
id: zone.grey_ferry_crossing
name: "The Grey Ferry: mid channel"
kind: arena
map_node: map.grey_ferry
time_of_day: dusk
cold_rate: 0
disguise_tag: null
music: grey_ferry_fog
areas:
  - {id: raft, description: "Twelve paces of tarred planks, rails on two sides, the rope over the ferryman's shoulder. The dead stand along the rails as grey shapes."}
  - {id: mid_channel, description: "The raft in thick fog. No banks visible. The sound of water and of many men breathing who do not breathe."}
  - {id: far_shore, description: "Gravel spit with drovers' cairns for drowned men. Bramble bank above. At stage 2+ the drowners' lair: churned silt, gnawed bones."}
spawns:
  - {id: raft_bow, area: raft, default: true}
  - {id: shore_landing, area: far_shore, default: false}
exits:
  - id: return_landing
    area: raft
    to_zone: zone.grey_ferry_landing
    to_spawn: raft_return
    condition: "true"
    effects: []
interactables:
  - id: venn
    area: mid_channel
    kind: search
    label: "Speak to the soldier at the stern"
    condition: "not flag(flag.ghost_question_asked)"
    check: null
    once: false
    effects: ["start_dialogue(dlg.venn_crossing)"]
  - id: step_ashore
    area: raft
    kind: door
    label: "Step off onto the far shore"
    condition: "true"
    check: null
    once: false
    effects: ["goto_zone(zone.grey_ferry_crossing, shore_landing)"]
  - id: drover_cairns
    area: far_shore
    kind: search
    label: "Search the drovers' cairns"
    condition: "true"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["add_crowns(15)"]
    fail_effects: []
  - id: drowner_cache
    area: far_shore
    kind: container
    label: "Search the drowners' bone pile"
    condition: "stage() >= 2"
    check: null
    once: true
    effects: []
triggers:
  - id: fog_closes
    area: mid_channel
    on: enter
    source: null
    condition: "true"
    once: true
    effects: ["play_beat(fog_closes)"]
  - id: dead_ask_toll
    area: mid_channel
    on: enter
    source: null
    condition: "flag(flag.ferryman_wronged) and not flag(flag.dead_toll_settled)"
    once: false
    effects: ["start_dialogue(dlg.dead_toll)"]
  - id: drowners_rise
    area: far_shore
    on: enter
    source: null
    condition: "stage() >= 2"
    once: true
    effects: ["play_beat(silt_boils)", "start_encounter(enc.grey_ferry_drowners)"]
hazards:
  - {id: deep_water, area: raft, kind: tide, params: {fall_off_damage: 15, return_to: raft}}
  - {id: far_silt, area: far_shore, kind: deep_mud, params: {speed_mult: 0.6, condition: "stage() >= 2"}}
checkpoints:
  - {id: before_crossing, area: raft}
  - {id: before_far_shore, area: far_shore}
beats:
  - {id: fog_closes, description: "The banks vanish. Grey shapes stand along the rails: soldiers in 1263 Crown kit, faces worn smooth. One at the stern still has a corporal's knot on his shoulder."}
  - {id: venn_answers, description: "Venn's shape sharpens for the answer: a young man, mud to the thigh, a burned hand. When he finishes, he is just fog again."}
  - {id: venn_rests, description: "Venn steps off the raft onto water that holds him, and walks away downstream until the fog takes him. The raft rises a finger's breadth."}
  - {id: silt_boils, description: "The black silt at the spit's edge boils. Pale hands, then heads."}
npcs:
  - {npc: npc.grey_ferryman, area: raft, condition: "true"}
  - {npc: npc.aled_venn, area: mid_channel, condition: "not flag(flag.ghost_question_asked)"}
encounters: [enc.grey_ferry_revenants, enc.grey_ferry_drowners]
loot:
  - {container: drowner_cache, items: [{item: item.poultice, count: 2}], condition: "stage() >= 2"}
variants:
  - id: dark_river
    when: "stage() >= 2"
    description: "Black water. The raft drags. Twice as many grey shapes stand at the rails, shifting and muttering."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: venn_gone
    when: "flag(flag.ghost_question_asked)"
    description: "There is a space at the stern where no grey shape stands."
    npcs_absent: [npc.aled_venn]
    encounters_disabled: []
    interactables_disabled: [venn]
```

The `step_ashore` interactable reuses `goto_zone` inside the same zone to move the player to the far shore spawn (the raft is beached on the spit for the duration). Returning uses `return_landing`.

## 4. NPCs present
**Voice notes.**
- **The ferryman:** never speaks. All of his "dialogue" is direction text and the player's own lines. He is tall and stooped, with a drover's hood and hands like old rope. He communicates with the bowl, the tally board, the pole and his eyes. He nods once for yes and looks away for no. When he is wronged, he simply stops poling, and the dead do the rest.
- **Corporal Aled Venn:** twenty-two forever, a Cintran farm boy from the Yaruga flats, a runner in Captain Haldane's foot company. His voice is quiet and very clear, as if it comes from just behind the player's ear. He speaks in plain, short sentences, the way a soldier reports. He is not angry. He is tired of carrying what he saw. He calls the player "friend" once they have paid him, and before that nothing at all.

```yaml npc
id: npc.grey_ferryman
name: "The Grey Ferryman"
faction: null
role: "Silent ferryman of the Grey Ferry"
motive: "Carry everyone who crosses, living or dead, and keep the tally even."
secret: "He was the Watch's ferry-sergeant at Marnadal and cut the rope to save his raft while the routed men behind him drowned. He has not spoken since."
disposition: neutral
essential: true
dialogue: dlg.ferryman_gestures
barks: []
combat: null
shop: null
```

```yaml npc
id: npc.aled_venn
name: "Corporal Aled Venn"
faction: null
role: "Ghost of a Cintran runner killed at Marnadal, 1263"
motive: "Be paid what he was owed, and set down what he saw."
secret: "He was the runner who brought the chaplain to the Marshal's tent the night the halls were burned. He has always believed it was his fault."
disposition: neutral
essential: true
dialogue: dlg.venn_crossing
barks: ["Mid channel. Not before.", "We were owed.", "Haldane's company. Third file. Still here."]
combat: null
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.ferryman_gestures
participants: [npc.grey_ferryman]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "flag(flag.ferry_fare_paid)", next: already_paid}
    else: approach
  approach:
    type: line
    speaker: npc.grey_ferryman
    text: "..."
    direction: "He looks at the player, then at the clay bowl, then out at the fog. He waits."
    effects: ["start_quest(quest.side_grey_ferry)"]
    next: choice
  choice:
    type: choice
    options:
      - id: pay
        text: "Drop ten crowns in the bowl. [Bribe 10]"
        tag: bribe
        bribe: 10
        next: paid
      - id: haul
        text: "I've no silver to spare. I'll haul the rope myself."
        next: hauled
      - id: ask_dead
        text: "They say you carry the dead. Is it true?"
        next: dead_answer
      - id: ask_venn
        text: "I'm looking for a soldier who died at Marnadal."
        next: venn_answer
      - id: threaten
        text: "Talk, old man, or I put you in the river. [Intimidate 6]"
        tag: intimidate
        check: {skill: intimidate, dc: 6, pass: threat_pass, fail: threat_fail}
        once: true
      - id: leave
        text: "Never mind."
        next: bye
  paid:
    type: line
    speaker: npc.grey_ferryman
    text: "..."
    direction: "He nods once, cuts a notch on the tally board, and steps onto the raft. He holds the rope out of the way so the player can board."
    effects: ["set_flag(flag.ferry_fare_paid)", "complete_objective(quest.side_grey_ferry, board)"]
    next: bye
  hauled:
    type: line
    speaker: npc.grey_ferryman
    text: "..."
    direction: "A long look. Then he hands over the rope and takes the pole himself. He does not cut a notch."
    effects: ["set_flag(flag.ferry_fare_paid)", "complete_objective(quest.side_grey_ferry, board)"]
    next: bye
  dead_answer:
    type: line
    speaker: npc.grey_ferryman
    text: "..."
    direction: "He points at the burn marks on the tally board, dozens of them. Then at the fog. Then he nods."
    next: choice
  venn_answer:
    type: line
    speaker: npc.grey_ferryman
    text: "..."
    direction: "He stops. He touches his own shoulder where a corporal's knot would sit. He points to the middle of the river."
    next: choice
  threat_pass:
    type: line
    speaker: npc.grey_ferryman
    text: "..."
    direction: "He does not flinch, but he unties the raft. Behind him the shingle is suddenly crowded with grey shapes who watch the player."
    effects: ["set_flag(flag.ferry_fare_paid)", "set_flag(flag.ferryman_wronged)", "complete_objective(quest.side_grey_ferry, board)"]
    next: bye
  threat_fail:
    type: line
    speaker: npc.grey_ferryman
    text: "..."
    direction: "He looks through the player as if they were fog. He sits down on his pallet."
    next: choice
  already_paid:
    type: line
    speaker: npc.grey_ferryman
    text: "..."
    direction: "He gestures to the raft."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.dead_toll
participants: [npc.grey_ferryman]
start: toll
nodes:
  toll:
    type: line
    speaker: player
    text: "The fog's full of them. They're looking at me."
    direction: "Grey hands reach toward the player's purse, not touching. The ferryman has stopped poling."
    next: toll_choice
  toll_choice:
    type: choice
    options:
      - id: pay_back
        text: "Put the coins back in the ferryman's bowl. [Bribe 25]"
        tag: bribe
        bribe: 25
        next: settled
      - id: rite
        text: "Speak the Strept rite for the unquiet dead. [Lore 4]"
        tag: lore
        condition: "flag(flag.torc_rite_known)"
        show_locked: true
        check: {skill: lore, dc: 4, pass: settled, fail: refuse}
      - id: refuse
        text: "The dead get nothing from me."
        next: refuse
  settled:
    type: line
    speaker: npc.grey_ferryman
    text: "..."
    direction: "The hands withdraw. He poles again."
    effects: ["set_flag(flag.dead_toll_settled)", "clear_flag(flag.ferryman_wronged)"]
    next: bye
  refuse:
    type: effect
    effects: ["start_encounter(enc.grey_ferry_revenants)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.venn_crossing
participants: [npc.aled_venn]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "flag(flag.venn_paid)", next: ask_intro}
    else: first
  first:
    type: line
    speaker: npc.aled_venn
    text: "You can see me. Good. Most just feel cold. I'm Venn. Haldane's company, third file. We were owed four months when we died. Nobody paid the dead."
    effects: ["complete_objective(quest.side_grey_ferry, find_venn)"]
    next: first_2
  first_2:
    type: line
    speaker: npc.aled_venn
    text: "Pay me what I was owed, and I'll answer you one thing true. Only one. The dead don't get to talk twice."
    next: pay_choice
  pay_choice:
    type: choice
    options:
      - id: silver
        text: "Twelve crowns. Silver, like the Crown should have paid you. [Bribe 12]"
        tag: bribe
        bribe: 12
        next: paid_silver
      - id: roll
        text: "Read the names from the muster roll of Haldane's company. [Item: Muster roll]"
        tag: item
        condition: "has_item(item.marnadal_muster_roll)"
        show_locked: true
        next: paid_roll
      - id: torc_rite
        text: "I've walked Marnadal Field and spoken the rite for the clan dead. Let me speak it for yours. [Clue: Torc rite]"
        tag: clue
        condition: "flag(flag.torc_rite_known)"
        show_locked: true
        next: paid_rite
      - id: soldier_rite
        text: "Speak the old soldiers' farewell: 'Pay drawn, kit stowed, march ended.' [Lore 6]"
        tag: lore
        check: {skill: lore, dc: 6, pass: paid_lore, fail: lore_fail}
        once: true
      - id: what_owed
        text: "What exactly were you owed?"
        next: owed
      - id: later
        text: "Not yet."
        next: bye
  owed:
    type: line
    speaker: npc.aled_venn
    text: "Silver, for four months. Or our names said out loud by someone living. Haldane kept the roll. The chaplains nailed it up in that sorry chapel and left it to rot."
    next: pay_choice
  lore_fail:
    type: line
    speaker: npc.aled_venn
    text: "Close. That's a cavalry farewell. We were foot. It doesn't fit."
    next: pay_choice
  paid_silver:
    type: line
    speaker: npc.aled_venn
    direction: "The coins fall through his hand and ring on the planks. The ferryman picks them up and puts them in his own pouch, not the bowl."
    text: "Huh. Real silver. That's more than Kosk's paymaster ever managed."
    effects: ["set_flag(flag.venn_paid)", "complete_objective(quest.side_grey_ferry, pay_venn)"]
    next: ask_intro
  paid_roll:
    type: line
    speaker: player
    text: "Aled Venn. Corran Moss. Tibb Hallow. Wenslow the Elder, Wenslow the Younger. Jory Pike..."
    direction: "The player reads all thirty-one names. With each one, a grey shape at the rail turns and is gone. Venn's is read last."
    effects: ["set_flag(flag.venn_paid)", "complete_objective(quest.side_grey_ferry, pay_venn)", "add_rep(faction.strept, 2)"]
    next: paid_roll_2
  paid_roll_2:
    type: line
    speaker: npc.aled_venn
    text: "You said Wenslow twice. That's right. Two brothers. Nobody ever gets that right. All right, friend."
    next: ask_intro
  paid_rite:
    type: line
    speaker: npc.aled_venn
    text: "A clan rite for Cintran dead. That's a joke we'd have liked. Go on, then. It fits better than you'd think."
    effects: ["set_flag(flag.venn_paid)", "complete_objective(quest.side_grey_ferry, pay_venn)"]
    next: ask_intro
  paid_lore:
    type: line
    speaker: npc.aled_venn
    text: "March ended. Gods. I'd forgotten the words. All right, friend."
    effects: ["set_flag(flag.venn_paid)", "complete_objective(quest.side_grey_ferry, pay_venn)"]
    next: ask_intro
  ask_intro:
    type: line
    speaker: npc.aled_venn
    text: "One question. Think on it. I'll know if you try to fit two in one."
    next: ask_choice
  ask_choice:
    type: choice
    options:
      - id: q_marnadal
        text: "What really happened at Marnadal? Why did the Marshal burn the halls?"
        next: a_marnadal
      - id: q_crates
        text: "Where do the monks carry their iron crates?"
        next: a_crates
      - id: q_ostrel
        text: "What sleeps under Karak Ostrel?"
        next: a_ostrel
      - id: q_wait
        text: "Let me think. I'll come back."
        next: bye
  a_marnadal:
    type: line
    speaker: npc.aled_venn
    text: "The war was over by then. The clans were beaten. The halls held old men, women and children. No fighters. I know. I scouted them that afternoon."
    next: a_marnadal_2
  a_marnadal_2:
    type: line
    speaker: npc.aled_venn
    text: "That night a chaplain came to the lines. I took him to the Marshal's tent myself. He said the clans had hanged our prisoners at Dun Edra. Twenty men, strung on the hall beams."
    next: a_marnadal_3
  a_marnadal_3:
    type: line
    speaker: npc.aled_venn
    text: "There were no prisoners at Dun Edra. Nobody hanged. The Marshal believed him, because he wanted it over. He gave the order at midnight. I carried it."
    next: a_marnadal_4
  a_marnadal_4:
    type: line
    speaker: npc.aled_venn
    text: "The chaplain had a soft voice. Grey stole, the Lion stitched on it. He prayed with the torchmen before they went. I died the next morning at the ford. I've been carrying it since."
    effects: ["add_clue(clue.grey_ferry_truth)", "set_flag(flag.ghost_question_asked)", "play_beat(venn_answers)"]
    next: farewell
  a_crates:
    type: line
    speaker: npc.aled_venn
    text: "The dead walk the old Marnadal road at night. Hooded men walk it with us now, hauling crates that hum. Up past the field, to the old border fort. Vel Aram. They don't see us. We see them."
    effects: ["add_clue(clue.ghost_choir_road)", "add_map_pin(map.vel_aram)", "set_flag(flag.ghost_question_asked)", "play_beat(venn_answers)"]
    next: farewell
  a_ostrel:
    type: line
    speaker: npc.aled_venn
    text: "The dead hear it under the mountain. Iron that walks. Casks of the black that burned Corvan's enemies. Men sworn in blood, gone to iron. The lock is groaning. We all hear it."
    effects: ["add_clue(clue.ghost_vault_weapons)", "set_flag(flag.ghost_question_asked)", "play_beat(venn_answers)"]
    next: farewell
  farewell:
    type: line
    speaker: npc.aled_venn
    text: "That's my march ended. Tell someone, friend. That's all the dead want. Someone to know."
    effects: ["play_beat(venn_rests)"]
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.grey_ferry_revenants
zone: zone.grey_ferry_crossing
enemies:
  - {enemy: enemy.revenant_footman, count: 3, spawn: raft_bow, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: before_crossing
avoidable_by: ["dlg.dead_toll"]
on_won: ["set_flag(flag.dead_toll_settled)", "clear_flag(flag.ferryman_wronged)"]
on_yielded: []
on_player_fled: []
```
Fought on the raft. The revenants climb over the rails out of the fog. They rise again after 6 s unless the last hit was blunt or fire, or unless `flag.torc_rite_known` is set (gdd §6.7). The rail edge is a deep-water hazard: a kick can push a revenant overboard, which removes it from the fight. When the bowl is robbed on the landing, the trigger starts this encounter there instead. The encounter's `zone` names the crossing, and the landing version uses the same enemy group, which spawns out of the shallows. **Non-combat alternatives:** never rob the bowl, never threaten the ferryman, or settle the dead's toll in `dlg.dead_toll` (Bribe 25, or the Strept rite with `flag.torc_rite_known`). Venn's offer is not lost after the fight.

```yaml encounter
id: enc.grey_ferry_drowners
zone: zone.grey_ferry_crossing
enemies:
  - {enemy: enemy.drowner, count: 3, spawn: shore_landing, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: before_far_shore
avoidable_by: []
on_won: []
on_yielded: []
on_player_fled: []
```
Stage 2 and above only, on the far shore. The drowners burst out of the black silt and try drag-grabs toward the water. The far shore is optional: it holds the cairn cache and the drowners' bone pile, nothing the quest needs. **Non-combat alternative:** don't step ashore. The quest never requires the far shore.

## 7. Items and clues

```yaml item
id: item.marnadal_muster_roll
name: "Muster roll of Haldane's company"
category: document
description: "A water-stained roll in a waxed bag, nailed to the drowned chapel's altar. Thirty-one names of a Cintran foot company that died at Marnadal."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Capt. Haldane's Foot, Third Muster, Marnadal 1263. Cpl. Aled Venn (runner). Corran Moss. Tibb Hallow. Wenslow the Elder. Wenslow the Younger. Jory Pike. Brannick Cole. Sim Ostler... [thirty-one names; the last eleven marked with a cross and 'the ford']. Pay owing: four months."
```

```yaml clue
id: clue.grey_ferry_truth
theory: theory.anselm_plan
title: "What the dead runner saw at Marnadal"
text: "The Strept halls held no fighters. A soft-voiced chaplain in a grey stole told Kosk the clans had hanged twenty Cintran prisoners at Dun Edra. There were none. Kosk gave the burning order on that lie."
supports: [anselm]
refutes: []
```

```yaml deduction
id: ded.marnadal_truth
theory: theory.anselm_plan
condition: "has_clue(clue.grey_ferry_truth)"
title: "Marnadal was a lie told to a tired man"
text: "Kosk burned the halls, but a Choir chaplain fed him the reason. Told this, Kosk can own the crime without hiding behind it, and write the apology Hesk demands."
```

```yaml clue
id: clue.ghost_choir_road
theory: theory.choir
title: "The dead see crates on the old road"
text: "Ghosts walking the old Marnadal road at night see hooded men hauling humming crates south to Vel Aram, the old border fort."
supports: []
refutes: []
```

```yaml clue
id: clue.ghost_vault_weapons
theory: theory.anselm_plan
title: "What the dead hear under Amell"
text: "Walking iron, casks of the black that burned Corvan's enemies, blood-sworn men gone to iron. The dead hear Ostrel's lock groaning."
supports: []
refutes: []
```

Readables: the **tally board** (Investigate 4) shows two kinds of mark. Notches for the living run to the hundreds. Burn marks for the dead come in clusters. The largest cluster is a hundred and forty marks on one plank, under a carved "63". The **gibbet plate** reads: "By sentence of the Abbey of St. Corwen, for theft of the ferry's silver. The dead are owed." The second sentence was scratched in later by another hand.

## 8. Flags set and read

```yaml flags
declare:
  - {id: flag.ghost_question_asked, type: bool, desc: "Venn has given his one truthful answer."}
  - {id: flag.ferry_fare_paid, type: bool, desc: "The ferryman will carry the player (paid, rope hauled, or threatened)."}
  - {id: flag.ferryman_wronged, type: bool, desc: "The player robbed the bowl or threatened the ferryman; the dead demand a toll midstream."}
  - {id: flag.dead_toll_settled, type: bool, desc: "The dead's toll was paid, the rite spoken, or the revenants beaten."}
  - {id: flag.venn_paid, type: bool, desc: "Venn has been paid what he was owed and will answer."}
reads:
  - ms.act1_complete
  - flag.torc_rite_known
```

## 9. Quest hooks

```yaml quest
id: quest.side_grey_ferry
kind: side
title: "What the Dead Are Owed"
giver: npc.grey_ferryman
available: "ms(ms.act1_complete)"
closes_on: null
xp: 350
stages:
  - id: cross
    journal: "The Grey Ferry below Ferrymen's Camp carries the living for silver and the 1263 dead for nothing. The drovers say a soldier rides the raft who will answer one question true."
    objectives:
      - {id: board, text: "Get passage on the Grey Ferry", condition: "flag(flag.ferry_fare_paid)", optional: false}
      - {id: roll_found, text: "Find what the dead soldiers left behind", condition: "has_item(item.marnadal_muster_roll)", optional: true, xp: 60}
    on_complete: []
    next: []
  - id: the_soldier
    journal: "Mid channel the fog fills with soldiers of 1263. Corporal Aled Venn says he will answer one question if he is paid what he was owed."
    objectives:
      - {id: find_venn, text: "Speak to the soldier at the stern", condition: "flag(flag.venn_paid) or flag(flag.ghost_question_asked)", optional: false}
      - {id: pay_venn, text: "Pay Venn what he was owed", condition: "flag(flag.venn_paid)", optional: false}
    on_complete: []
    next: []
  - id: the_question
    journal: "Venn will answer one question truthfully. Only one."
    objectives:
      - {id: ask, text: "Ask Venn your one question", condition: "flag(flag.ghost_question_asked)", optional: false}
      - {id: marnadal_truth, text: "Learn the truth of Marnadal", condition: "ded(ded.marnadal_truth)", optional: true, xp: 90}
    on_complete: []
    next: []
outcome_effects:
  completed: []
  failed: []
```

## 10. Rumors and event cards (optional)
Rumor r19 (`14-rumors.md`) pins `map.grey_ferry`. Rumor r08 ("the 1263 dead still march every new moon") is consistent with what Venn says.

## 11. Failure states and branches

```yaml branches
paths:
  - id: ask_marnadal
    when: "Player pays Venn and asks what really happened at Marnadal."
    outcome: "clue.grey_ferry_truth -> ded.marnadal_truth; Kosk's apology in Act III without a check (A06)."
    sets: ["add_clue(clue.grey_ferry_truth)", "set_flag(flag.ghost_question_asked)"]
  - id: ask_crates
    when: "Player asks where the monks carry their crates."
    outcome: "clue.ghost_choir_road and a map pin on Vel Aram. No ded.marnadal_truth; Kosk's apology then needs Presence 7."
    sets: ["add_clue(clue.ghost_choir_road)", "set_flag(flag.ghost_question_asked)"]
  - id: ask_ostrel
    when: "Player asks what sleeps under Ostrel."
    outcome: "clue.ghost_vault_weapons (lore). No ded.marnadal_truth."
    sets: ["add_clue(clue.ghost_vault_weapons)", "set_flag(flag.ghost_question_asked)"]
  - id: rob_the_bowl
    when: "Player takes the coins from the ferryman's bowl."
    outcome: "+25 crowns; revenants rise on the landing; the dead demand a toll midstream until settled."
    sets: ["set_flag(flag.ferryman_wronged)"]
failures:
  - id: player_dies
    result: reload_checkpoint
    recover: "Reload ferry_arrival, before_crossing or before_far_shore."
  - id: soldier_rite_failed
    result: soft_fail
    recover: "Lore 6 locks for good. Silver (12 crowns), the muster roll (free pickup) and the torc rite remain."
  - id: wrong_question
    result: soft_fail
    recover: "Only one answer. If it was not Marnadal, Kosk's apology stays possible through Presence 7 in Act III."
guarantees:
  - "Passage reachable without a check or crowns (haul the rope yourself)."
  - "Venn's payment reachable without a check or crowns (the muster roll is a free pickup in the drowned chapel)."
  - "ded.marnadal_truth reachable without a check: q_marnadal is always offered once Venn is paid."
```

## 12. Open questions
- The revenant encounter is declared on `zone.grey_ferry_crossing`, but robbing the bowl starts it on the landing. The schema has one `zone` per encounter. Choice: the landing trigger reuses the same encounter, and the scene places the group at the landing's water edge. If the converter or tests need strict zone matching, split it into `enc.grey_ferry_revenants_landing`.
- `step_ashore` uses `goto_zone` into the same zone to move between areas. If moving within a zone should not use `goto_zone`, the scene can treat it as a teleport to `shore_landing`.
- gdd lists `clue.marnadal_chaplain` under "What does Anselm want?". `clue.grey_ferry_truth` is a separate clue. A reconciliation pass may want `ded.anselm_treason_proven` or a chaplain deduction to also accept it.
