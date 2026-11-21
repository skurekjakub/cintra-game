---
section_id: a3.03
title: "Assengard"
act: 3
story_ref: "story.md §1 Hook (Dravin's letter), §2 Mag Turga, §3 Dravin Ostrel, §7.3 Assengard; gdd §6.13 companion.dravin, §7.2 (optional in Act II), §7.3 row 3"
zones: [zone.assengard]
available_when: "ms(ms.act1_complete)"
escalation_stage_required: {min: 1, max: 4}
milestones_set: [ms.a3_dravin_joined]
milestones_read: [ms.act1_complete, ms.act2_twist]
level_band: [7, 10]
---

# Assengard

## 1. Scene summary
Assengard is a pine-and-tar market town of Mag Turga on the Assen river. Its upper end runs into a cliff, where an old dwarven boundary-house has been turned into a smithy. **Dravin Ostrel** lives there: an aging dwarf, the last of Karak Ostrel's gate-warden line, and the man who wrote the letter that killed a courier. He keeps the **Iron-Key** to the mountain in a vault cut into the rock behind his forge. He has a secret: last spring a soft-handed monk paid him in Abbey silver to forge a set of gear-teeth to a drawing, and only afterwards did he understand he had made a **counter-gear**, the part that lets the lock run backward. That guilt is why he wrote. He will join the player with the Key once he is shown proof of Anselm's plan (`ded.anselm_treason_proven`). In Act III the abduction is proof enough. He also tells of a forgotten postern, the **Weeping Gate** beneath the Old Grey Matron peak, that bypasses the snow-choked main portals.

In Act II the player can come early. Dravin is suspicious and needs proof before he joins. In Act III the Choir gets there first: a cell is trying to burn Dravin out of his vault and take the Key, so that no one can follow Anselm through the Weeping Gate. The player can fight them, or order them off with Choir disguise and Anselm's own cipher. The section ends when Dravin joins (`ms.a3_dravin_joined`).

## 2. Progress and escalation
- **Stages 1–3 (Act II):** no raid. Dravin is in his forge. He joins only with `ded.anselm_treason_proven` (gdd §6.13). Without it, his options are shown locked, but the player can still hear about the bolts, the lock and his secret.
- **Stage 4 (Act III):** a light-snow look. If Dravin has not yet joined, the Choir cell is in the forge yard when the player arrives (`enc.assengard_forge_raid`, or a talk-down). After the raid, Dravin joins unconditionally: the Act II gate already guaranteed `ded.anselm_treason_proven`, and the gdd allows Act III recruitment.
- If Dravin joined in Act II, he is already in the party in Act III, so the raid never happens. His apprentice Jasia says monks came and found the vault empty.
- `ms.a3_dravin_joined` is set when Dravin joins, in either act. It is not one of the seven Act II progress milestones (gdd §6.1), so an early recruit does not raise the escalation stage.

## 3. Location layout
The player arrives over the **river bridge**, a covered timber bridge with a toll-hut that nobody mans. Beyond it is the **market square**: log-built halls with carved gables, a well, pine stalls, and the reek of pitch from the **sawmill yard** on the river side. **The Tarred Goose** inn (a rest point) faces the **reeve's hall** across the square. A cobbled lane climbs north to the cliff. At its end is **Dravin's forge yard**: a walled yard with an open-fronted human forge (Jasia's shop) built against the face of a dwarven **boundary-house**, whose door is a round slab of iron set in carved stone. Behind it is the **key vault**, cut into the rock, where Dravin keeps the Iron-Key and his family's records. A dwarven **warden's stair** climbs the cliff from the yard to a **lookout** with a clear view south-east to the Old Grey Matron, its white flank and the black notch where the Weeping Gate lies. On the shelf beside the stair, the **cairn garden** holds Dravin's family cairns, each with a stone tablet. The Choir comes out of the **pine edge** west of the yard and over the sawmill roofs.

Combat space in Act III is the forge yard (about 20 × 15 m). It holds the forge (cover, and a fire hazard if the Choir's pitch spreads), the anvil block, stacked timber, and the sawmill roof line above the west wall, where the crossbowmen take position.

```yaml zone
id: zone.assengard
name: "Assengard"
kind: exterior
map_node: map.assengard
time_of_day: day
cold_rate: 0
disguise_tag: choir
music: pine_marches
areas:
  - {id: river_bridge, description: "Covered timber bridge over the Assen; an empty toll-hut; wet planks."}
  - {id: market_square, description: "Log halls with carved gables, a well, pine-plank stalls; Mag Turga burghers in fur hats."}
  - {id: goose_inn, description: "The Tarred Goose: low common room, a hearth big enough to roast a pig, rooms upstairs."}
  - {id: reeve_hall, description: "Reeve Bogna's hall: a timber hall with a carved lynx over the door; tally-boards of mule sales."}
  - {id: sawmill_yard, description: "River-side sawmill, log stacks, pitch vats; its roof line overlooks the forge yard's west wall."}
  - {id: forge_yard, description: "Walled yard at the lane's end: Jasia's open forge against the dwarven boundary-house, an anvil block, a quench trough, stacked timber."}
  - {id: boundary_door, description: "A round iron slab door in carved stone; warden-marks on the frame; scorch marks in Act III."}
  - {id: key_vault, description: "Rock-cut vault behind the door: dwarven tool racks, the key's iron cradle, a stone table with the counter-gear drawing pinned flat under a hammer."}
  - {id: warden_stair, description: "A dwarven stair, a thousand shallow steps, up the cliff from the yard."}
  - {id: lookout, description: "Cliff-top platform with a carved sight-stone pointing south-east at the Old Grey Matron."}
  - {id: cairn_garden, description: "A shelf beside the stair: seven family cairns with stone tablets; juniper planted between."}
  - {id: pine_edge, description: "Forest edge west of the forge yard; the Choir's approach in Act III."}
spawns:
  - {id: bridge_end, area: river_bridge, default: true}
  - {id: forge_yard, area: forge_yard}
  - {id: inn_door, area: goose_inn}
  - {id: choir_yard, area: forge_yard}
  - {id: choir_roof, area: sawmill_yard}
  - {id: vault_inside, area: key_vault}
exits: []
interactables:
  - id: bridge_board
    area: river_bridge
    kind: map_board
    label: "Take the road"
    condition: "true"
    check: null
    once: false
    effects: []
    fail_effects: []
  - id: goose_rest
    area: goose_inn
    kind: rest
    label: "Take a room at the Tarred Goose (15 crowns)"
    condition: "crowns() >= 15"
    check: null
    once: false
    effects: ["add_crowns(-15)", "heal_player(full)", "set_checkpoint(goose_inn)"]
    fail_effects: []
  - id: cairn_tablets
    area: cairn_garden
    kind: readable
    label: "Read the cairn tablets"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.warden_line_tablets, 1)"]
    fail_effects: []
  - id: sight_stone
    area: lookout
    kind: search
    label: "Look along the sight-stone"
    condition: "true"
    check: null
    once: true
    effects: ["play_beat(sight_stone)"]
    fail_effects: []
  - id: gear_drawing
    area: key_vault
    kind: readable
    label: "Study the drawing under the hammer"
    condition: "flag(flag.dravin_confessed)"
    check: null
    once: true
    effects: ["give_item(item.counter_gear_drawing, 1)"]
    fail_effects: []
  - id: boundary_door_in
    area: boundary_door
    kind: door
    label: "Enter the vault"
    condition: "flag(flag.dravin_recruited) or flag(flag.dravin_confessed)"
    check: null
    once: false
    effects: ["goto_zone(zone.assengard, vault_inside)"]
    fail_effects: []
  - id: vault_rack
    area: key_vault
    kind: container
    label: "Search Dravin's tool racks"
    condition: "flag(flag.dravin_recruited)"
    check: null
    once: true
    effects: []
    fail_effects: []
  - id: pitch_fire
    area: forge_yard
    kind: lever
    label: "Douse the pitch with the quench trough"
    condition: "flag(flag.assengard_raid_done)"
    check: null
    once: true
    effects: ["play_beat(pitch_doused)", "add_xp(30)"]
    fail_effects: []
triggers:
  - id: cell_at_forge
    area: forge_yard
    on: enter
    source: null
    condition: "act() == 3 and not flag(flag.dravin_recruited) and not flag(flag.assengard_raid_done)"
    once: true
    effects: ["set_checkpoint(before_cell)", "play_beat(cell_at_forge)", "start_dialogue(dlg.assengard_cell_leader)"]
hazards:
  - {id: pitch_spill, area: forge_yard, kind: fire, params: {damage_per_second: 6, note: "Burning pitch along the boundary door in Act III while the cell is active."}}
checkpoints:
  - {id: goose_inn, area: goose_inn}
  - {id: before_cell, area: forge_yard}
beats:
  - {id: cell_at_forge, description: "Five grey robes in the forge yard. Two pour pitch along the base of the iron door; one has a torch. Two crossbows on the sawmill roof. From behind the door, a muffled dwarven voice cursing in two languages."}
  - {id: cell_withdraws, description: "The cell leader lowers his torch, signals the roof, and the Choir files out through the pines without looking back."}
  - {id: pitch_doused, description: "A bucket from the quench trough; the pitch hisses out. The iron door is blistered but whole."}
  - {id: door_opens, description: "The iron slab door grinds aside on a dwarven pivot. Dravin stands in the gap with a hammer in one hand and a lamp in the other, beard singed."}
  - {id: dravin_fetches_key, description: "Dravin goes into the vault and comes back with a key as long as a forearm: black iron, its bit a block of interlocking rune-teeth, its bow a lion's head with a dwarf's beard."}
  - {id: sight_stone, description: "Along the sight-stone's groove: the Old Grey Matron, white, with a black notch under its shoulder. Dravin's voice, if he's with you: 'There. That's the door they forgot.'"}
npcs:
  - {npc: npc.dravin, area: forge_yard, condition: "not flag(flag.dravin_recruited)"}
  - {npc: npc.jasia, area: forge_yard, condition: "true"}
  - {npc: npc.reeve_bogna, area: reeve_hall, condition: "true"}
  - {npc: npc.brother_wendel, area: forge_yard, condition: "act() == 3 and not flag(flag.dravin_recruited) and not flag(flag.assengard_raid_done)"}
encounters: [enc.assengard_forge_raid]
loot:
  - {container: vault_rack, items: [{item: item.fire_oil, count: 2}, {item: item.crossbow_bolt, count: 10}], condition: "flag(flag.dravin_recruited)"}
variants:
  - id: act_three_snow
    when: "act() == 3"
    description: "Light snow on the gables; the market half-empty; shutters closed at the sight of grey robes."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: after_raid
    when: "flag(flag.assengard_raid_done)"
    description: "Scorched door, pitch on the cobbles, a broken crossbow on the sawmill roof."
    npcs_absent: [npc.brother_wendel]
    encounters_disabled: [enc.assengard_forge_raid]
    interactables_disabled: []
  - id: dravin_gone
    when: "flag(flag.dravin_recruited)"
    description: "The forge is cold except for Jasia's hearth; Dravin's hammer hook is empty."
    npcs_absent: [npc.dravin, npc.brother_wendel]
    encounters_disabled: [enc.assengard_forge_raid]
    interactables_disabled: []
```

`disguise_tag: choir`: in Act III, a player wearing `item.choir_robe` is "permitted" in this zone. That is what the cell leader's talk-down reads (gdd §6.5).

## 4. NPCs present

```yaml npc
id: npc.dravin
name: "Dravin Ostrel"
faction: null
role: "Last smith of Karak Ostrel's gate-warden line; keeper of the Iron-Key (companion.dravin)"
motive: "Keep the oath his line swore to Corvan's kings: be at the gate when it fails. Undo what his own hammer did."
secret: "Last spring he forged a counter-gear to a monk's drawing for Abbey silver. It is the part that lets the lock run backward. He wrote to the Crown only after he worked out what he had made."
disposition: wary
essential: true
dialogue: dlg.dravin
barks: ["Mind the anvil. It's older than your kingdom.", "Hammer's hot, temper's hotter.", "Dwarves don't run. We walk fast and swear.", "Iron listens. People don't.", "Stay behind me when the wardens wake."]
combat: null
shop: null
```
*Voice:* gruff and economical, with a Mag Turga burr over something older. He says "aye" and "lad" or "lass" (or "sword", for the player). He swears in dwarven, rendered as harsh syllables with no translation. He is technical when he talks about iron and silent about himself until pushed. He is very funny without trying.

```yaml npc
id: npc.jasia
name: "Jasia"
faction: null
role: "Dravin's human apprentice; runs the Assengard forge shop"
motive: "Keep the forge alive and get Dravin to come home."
secret: "Dravin has named her heir to the forge but not to the Key; he has never told her what the Key opens, and she has read every page in the vault anyway."
disposition: friendly
essential: true
dialogue: dlg.jasia
barks: ["He'll pretend he doesn't like you. He does.", "Dwarven-pattern mail. Lighter than it looks.", "Bring him back with both eyebrows."]
combat: null
shop: {stock: [{item: item.ostrel_mail, count: 1}, {item: item.warden_breaker, count: 1}, {item: item.crossbow_bolt, count: 30}, {item: item.fire_oil, count: 4}, {item: item.field_draught, count: 4}, {item: item.antitoxin, count: 2}], price_mod: 1.0}
```

```yaml npc
id: npc.reeve_bogna
name: "Reeve Bogna"
faction: null
role: "Reeve of Assengard for the march of Mag Turga"
motive: "Keep the town out of Cintra's quarrel and the Choir's."
secret: "Sold the Choir twelve mules and two barrels of quarry powder last summer and recorded them as 'pilgrims' supplies'."
disposition: neutral
essential: false
dialogue: dlg.reeve_bogna
barks: ["Mag Turga keeps its own counsel.", "Monks? Pilgrims. Paying pilgrims.", "If you're here for the dwarf, he's up the lane, swearing."]
combat: null
shop: null
```

```yaml npc
id: npc.brother_wendel
name: "Brother Wendel"
faction: faction.choir
role: "Leader of the Choir cell sent to burn out Dravin and take the Iron-Key"
motive: "Do the Abbot's will and get back up the mountain in time to see the light come down."
secret: "He has never been inside Karak Ostrel and is terrified of it."
disposition: hostile
essential: false
dialogue: dlg.assengard_cell_leader
barks: ["Open the door, smith, and nobody burns.", "The light is coming.", "Brothers, more pitch."]
combat: enemy.choir_zealot
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.dravin
participants: [npc.dravin]
start: open
nodes:
  open:
    type: branch
    cases:
      - {if: "flag(flag.dravin_recruited)", next: road_greet}
      - {if: "act() == 3", next: a3_open}
    else: a2_open
  a2_open:
    type: line
    speaker: npc.dravin
    text: "Shut the gate behind you. Hammer's hot, temper's hotter. What do you want?"
    direction: "He doesn't stop working. Every third stroke he looks at your belt, not your face, to see what you carry."
    next: a2_hub
  a2_hub:
    type: choice
    options:
      - id: letter
        text: "[Item: Dravin's dispatch] Your courier died at the Drowned Rat. He got this far."
        tag: item
        condition: "has_item(item.dravin_letter) and not flag(flag.dravin_letter_shown)"
        next: letter
      - id: bolts
        text: "What's grinding loose under Ostrel?"
        next: bolts
      - id: proof
        text: "[Clue: Anselm's treason] The Abbot of St. Corwen means to open your vaults. I can prove it."
        tag: clue
        condition: "ded(ded.anselm_treason_proven)"
        show_locked: true
        next: join_proof
      - id: lore
        text: "Those marks on your door frame are warden-runes, not decoration. [Lore 6]"
        tag: lore
        once: true
        check: {skill: lore, dc: 6, pass: lore_pass, fail: lore_fail}
      - id: persuade
        text: "You wrote to the Crown three times. The Crown finally sent someone. Let me help. [Persuade 6]"
        tag: persuade
        condition: "not flag(flag.dravin_confessed)"
        once: true
        check: {skill: persuade, dc: 6, pass: secret, fail: persuade_fail}
      - id: key
        text: "Give me the Key, dwarf."
        tag: intimidate
        once: true
        next: key_refuse
      - id: leave
        text: "I'll be back."
        next: bye
  letter:
    type: line
    speaker: npc.dravin
    text: "My seal. My hand. I sent two before this. Nobody answered."
    direction: "He turns the iron-wax seal with a black thumbnail."
    effects: ["set_flag(flag.dravin_letter_shown)"]
    next: letter_after
  letter_after:
    type: line
    speaker: npc.dravin
    text: "And the lad who carried it died of lily on a dockside floor. Grand. Ask what you came to ask."
    next: back_hub
  bolts:
    type: line
    speaker: npc.dravin
    text: "Every nineteen winters a crowned head speaks the Pact and the deep bolts reset. This cycle they're grinding loose before the solstice. Something's been at them from inside."
    next: bolts_more
  bolts_more:
    type: line
    speaker: npc.dravin
    text: "My grandfather walked out of that mountain the day they sealed it, with the Key and orders to wait for a king. We've been waiting four hundred years. You're not a king."
    next: back_hub
  lore_pass:
    type: line
    speaker: npc.dravin
    text: "...Aye. 'Here the watch waits.' Nobody's read that frame aloud in my lifetime. Sit. Don't touch anything."
    effects: ["add_xp(60)"]
    next: back_hub
  lore_fail:
    type: line
    speaker: npc.dravin
    text: "Decoration, aye. Very pretty. Mind the door on the way out."
    next: back_hub
  persuade_fail:
    type: line
    speaker: npc.dravin
    text: "You're a sword with a writ. I wrote for a king."
    next: back_hub
  secret:
    type: line
    speaker: npc.dravin
    text: "Last spring a monk brought me a drawing. Gear-teeth, dwarven pattern, cut backward. Paid in Abbey silver. I forged them. I didn't ask."
    direction: "He sets the hammer down for the first time."
    next: secret_more
  secret_more:
    type: line
    speaker: npc.dravin
    text: "I worked out what it was that same night. A counter-gear. Seat it in the throne mechanism and the lock runs the wrong way. That's why I wrote. That's why I can't sleep."
    effects: ["add_clue(clue.counter_gear_commission)", "set_flag(flag.dravin_confessed)"]
    next: back_hub
  key_refuse:
    type: line
    speaker: npc.dravin
    text: "Try and take it. I've a hammer, a vault door a yard thick, and nothing left to lose but my temper."
    direction: "He lifts the hammer one inch. It is enough."
    next: back_hub
  back_hub:
    type: branch
    cases:
      - {if: "act() == 3", next: a3_hub}
    else: a2_hub
  a3_open:
    type: line
    speaker: npc.dravin
    text: "They came for the Key. Five of them, with a priest's blessing and a bucket of pitch."
    direction: "Standing in the scorched doorway, beard singed on one side."
    effects: ["play_beat(door_opens)"]
    next: a3_open_more
  a3_open_more:
    type: line
    speaker: npc.dravin
    text: "And you came for it too. You've the look of someone who's lost a king."
    next: a3_hub
  a3_hub:
    type: choice
    options:
      - id: abducted
        text: "Anselm has Prince Aldric. He's taking him into the Lock Chamber to speak the Pact backward at solstice dawn."
        next: join_proof
      - id: letter
        text: "[Item: Dravin's dispatch] Your courier died at the Drowned Rat. He got this far."
        tag: item
        condition: "has_item(item.dravin_letter) and not flag(flag.dravin_letter_shown)"
        next: letter
      - id: bolts
        text: "What's grinding loose under Ostrel?"
        next: bolts
      - id: persuade
        text: "You knew they'd come for the Key. Why did they think they needed it? [Persuade 6]"
        tag: persuade
        condition: "not flag(flag.dravin_confessed)"
        once: true
        check: {skill: persuade, dc: 6, pass: secret, fail: persuade_fail}
      - id: leave
        text: "Not yet."
        next: bye
  join_proof:
    type: line
    speaker: npc.dravin
    text: "Show me."
    direction: "You lay it out on the anvil: the journal, the cipher, the ledger, the reversed lines. In Act III the scorch marks on his own door say the rest."
    next: join_read
  join_read:
    type: line
    speaker: npc.dravin
    text: "The Abbot. Soft hands, a reversed chant and my counter-gear. Wait here."
    effects: ["play_beat(dravin_fetches_key)"]
    next: join_key
  join_key:
    type: line
    speaker: npc.dravin
    text: "This is the Iron-Key of Ostrel. My line has kept it four hundred years for a king who never came to fetch it. You'll do."
    effects: ["give_item(item.iron_key, 1)", "recruit(companion.dravin)", "set_flag(flag.dravin_recruited)", "add_clue(clue.weeping_gate_route)", "reach_milestone(ms.a3_dravin_joined)"]
    next: join_gate
  join_gate:
    type: line
    speaker: npc.dravin
    text: "The main portals will be choked with snow and full of Choir. There's a postern under the Old Grey Matron. The Weeping Gate. Nobody's opened it since my grandfather walked out."
    next: join_last
  join_last:
    type: line
    speaker: npc.dravin
    text: "One more thing. If that counter-gear's seated, I know where it's weak. Get me to the gear-brake in the Lock Chamber and I'll slow the cursed thing down."
    next: bye
  road_greet:
    type: line
    speaker: npc.dravin
    text: "Talk while we walk. Dwarves can do both."
    next: road_hub
  road_hub:
    type: choice
    options:
      - id: gate
        text: "Tell me about the Weeping Gate."
        next: road_gate
      - id: wardens
        text: "What are the iron-wardens?"
        next: road_wardens
      - id: gear
        text: "The counter-gear. Can it be stopped?"
        condition: "flag(flag.dravin_confessed)"
        next: road_gear
      - id: dwarves
        text: "Where did the dwarves go?"
        next: road_dwarves
      - id: family
        text: "Do you have family, Dravin?"
        once: true
        next: road_family
      - id: done
        text: "Let's move."
        next: bye
  road_gate:
    type: line
    speaker: npc.dravin
    text: "Meltwater runs through the warden-faces on the door and freezes in their beards. Looks like weeping. It isn't. It's a drain. Dwarves are practical even when they're grieving."
    next: road_hub
  road_wardens:
    type: line
    speaker: npc.dravin
    text: "Iron men with a rune-core for a heart. They sleep while the vault's pressure holds. Pressure's dropping, so they're waking. They'll stand down for the Key if I'm the one holding it."
    next: road_hub
  road_gear:
    type: line
    speaker: npc.dravin
    text: "Stopped, no. Once it's turning, the whole lock has momentum. Slowed, aye. There's a brake on the north gallery. With the Key in it I can buy you a quarter more time."
    next: road_hub
  road_dwarves:
    type: line
    speaker: npc.dravin
    text: "Nowhere. They locked themselves in with Corvan's weapons to tend the lock until it wasn't needed. Your tavern drunks are right about that much. Expect bones."
    next: road_hub
  road_family:
    type: line
    speaker: npc.dravin
    text: "Seven cairns on the shelf behind my forge, and a human girl who thinks I don't know she reads my papers. That's family enough for a dwarf."
    next: road_hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.assengard_cell_leader
participants: [npc.brother_wendel]
start: open
nodes:
  open:
    type: line
    speaker: npc.brother_wendel
    text: "Stay back! This is the Abbot's business. Open the door, smith, or we'll cook you in your own vault!"
    direction: "Torch raised over the pitch. His hand is shaking."
    next: hub
  hub:
    type: choice
    options:
      - id: robe_orders
        text: "[Item: Choir robe] [Item: Anselm's cipher] Brother. New orders in the Abbot's cipher: the Key no longer matters. You're called up to the Lock Chamber before the light. [Persuade 6]"
        tag: item
        condition: "has_item(item.choir_robe) and has_item(item.anselm_cipher)"
        once: true
        check: {skill: persuade, dc: 6, pass: withdraw, fail: robe_fail}
      - id: robe_only
        text: "[Item: Choir robe] I've come from the mountain. The Abbot wants you there, not here. [Persuade 8]"
        tag: item
        condition: "has_item(item.choir_robe) and not has_item(item.anselm_cipher)"
        once: true
        check: {skill: persuade, dc: 8, pass: withdraw, fail: robe_fail}
      - id: scare
        text: "You've never been inside that mountain, have you? I'm going in. You can come and meet what's waking up. [Intimidate 8]"
        tag: intimidate
        once: true
        check: {skill: intimidate, dc: 8, pass: flee, fail: scare_fail}
      - id: why
        text: "Why does Anselm want the Key so badly?"
        once: true
        next: why
      - id: fight
        text: "Put the torch down or I'll put you down."
        next: fight
  withdraw:
    type: line
    speaker: npc.brother_wendel
    text: "...The light is coming. Yes. Yes, of course. Brothers! Leave the pitch. We climb."
    effects: ["play_beat(cell_withdraws)", "set_flag(flag.assengard_raid_done)", "set_flag(flag.assengard_cell_withdrew)", "add_xp(240)"]
    next: bye
  robe_fail:
    type: line
    speaker: npc.brother_wendel
    text: "I don't know your face. Brother Ostwin knows every face. Kill them!"
    next: fight
  flee:
    type: line
    speaker: npc.brother_wendel
    text: "No. No, I'm not going in there. Not for anyone."
    direction: "He drops the torch in the quench trough and runs for the pines. Two of the robes follow him. The rest close in."
    effects: ["set_flag(flag.assengard_cell_shaken)"]
    next: fight_small
  scare_fail:
    type: line
    speaker: npc.brother_wendel
    text: "The Abbot told us about people like you. Burn them with the dwarf!"
    next: fight
  why:
    type: line
    speaker: npc.brother_wendel
    text: "Because a locked door can be followed through. The Abbot wants no one behind him when the light comes down. That's all I know. That's all I want to know."
    next: hub
  fight:
    type: effect
    effects: ["start_encounter(enc.assengard_forge_raid)"]
    next: bye
  fight_small:
    type: effect
    effects: ["start_encounter(enc.assengard_forge_raid_shaken)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.jasia
participants: [npc.jasia]
start: greet
nodes:
  greet:
    type: branch
    cases:
      - {if: "flag(flag.dravin_recruited) and act() == 3", next: greet_gone}
    else: greet_plain
  greet_gone:
    type: line
    speaker: npc.jasia
    text: "Monks came for him after you left. Found the vault empty and shouted at the door for an hour. I sold them nothing."
    next: hub
  greet_plain:
    type: line
    speaker: npc.jasia
    text: "If you want the old man, he's swearing at the anvil. If you want to buy something, I'm the one who'll take your money."
    next: hub
  hub:
    type: choice
    options:
      - id: shop
        text: "Show me what you sell."
        effects: ["open_shop(npc.jasia)"]
        next: bye
      - id: about
        text: "What's he like?"
        next: about
      - id: papers
        text: "You read his papers."
        condition: "flag(flag.dravin_confessed)"
        once: true
        next: papers
      - id: done
        text: "Thanks."
        next: bye
  about:
    type: line
    speaker: npc.jasia
    text: "Stubborn as a pig-iron ingot and twice as warm once you get him going. He took me in when the river took my parents. Don't tell him I said warm."
    next: hub
  papers:
    type: line
    speaker: npc.jasia
    text: "Every page. That's how I know the drawing on his table isn't his. The hand's too neat. A scribe's hand. Abbey-taught."
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.reeve_bogna
participants: [npc.reeve_bogna]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.reeve_bogna
    text: "Cintran. Mag Turga pays its dues and minds its own business. What business brings you?"
    next: hub
  hub:
    type: choice
    options:
      - id: monks
        text: "Monks have been buying in Assengard. What did they buy?"
        next: monks
      - id: tally
        text: "Your mule tally says 'pilgrims'. Pilgrims don't buy quarry powder. [Investigate 6]"
        tag: investigate
        once: true
        check: {skill: investigate, dc: 6, pass: tally_pass, fail: tally_fail}
      - id: done
        text: "Good day, Reeve."
        next: bye
  monks:
    type: line
    speaker: npc.reeve_bogna
    text: "Mules, rope, salt pork. Pilgrims' supplies. They paid in good silver and went south-east up the old quarry road. That's all."
    next: hub
  tally_pass:
    type: line
    speaker: npc.reeve_bogna
    text: "...Two barrels of powder. For the quarry road, they said, it was blocked. Then the wyvern came down off the Grey Matron screaming. I didn't put that together until you did."
    effects: ["add_crowns(40)", "add_xp(45)"]
    direction: "She slides a small purse across the table without being asked."
    next: hub
  tally_fail:
    type: line
    speaker: npc.reeve_bogna
    text: "Pilgrims buy what pilgrims need. Good day."
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.assengard_forge_raid
zone: zone.assengard
enemies:
  - {enemy: enemy.choir_zealot, count: 3, spawn: choir_yard, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 2, spawn: choir_roof, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: [npc.dravin]
checkpoint: before_cell
avoidable_by: ["dlg.assengard_cell_leader"]
on_won: ["set_flag(flag.assengard_raid_done)", "start_dialogue(dlg.dravin)"]
on_yielded: ["set_flag(flag.assengard_raid_done)", "start_dialogue(dlg.dravin)"]
on_player_fled: []
```

```yaml encounter
id: enc.assengard_forge_raid_shaken
zone: zone.assengard
enemies:
  - {enemy: enemy.choir_zealot, count: 2, spawn: choir_yard, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: choir_roof, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: [npc.dravin]
checkpoint: before_cell
avoidable_by: ["dlg.assengard_cell_leader"]
on_won: ["set_flag(flag.assengard_raid_done)", "start_dialogue(dlg.dravin)"]
on_yielded: ["set_flag(flag.assengard_raid_done)", "start_dialogue(dlg.dravin)"]
on_player_fled: []
```

Design notes. Brother Wendel is one of the three zealots in the full raid (his npc block lists `enemy.choir_zealot`). Two seconds after the fight starts, Dravin bursts out of the vault door and fights alongside as a scripted helper with his hammer. The crossbowmen on the sawmill roof can be shot, or reached up the log stacks. The pitch along the door is a fire hazard during the fight. Zealots self-immolate at 0 HP (gdd §6.7): their 2 m fire burst can ignite the pitch, so fighting away from the door is wiser. If the player flees, the cell stays. Coming back to the yard re-runs the leader's dialogue, because the trigger is `once` but the leader's npc condition still holds. Talking to Wendel then starts the same choice again.

## 7. Items and clues

```yaml item
id: item.iron_key
name: "The Iron-Key of Ostrel"
category: key
description: "A forearm-long key of black iron; its bit is a block of interlocking rune-teeth, its bow a lion's head with a dwarf's beard. Opens the Weeping Gate. With Dravin, stills iron-wardens and works the Lock Chamber's gear-brake."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.counter_gear_drawing
name: "The counter-gear drawing"
category: document
description: "A scribe's drawing of dwarven gear-teeth, cut backward, with dimensions in an Abbey hand."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Seven teeth, reverse pitch, to seat on the throne-shaft behind the third ring. Bronze-faced iron. To be delivered unassembled. Payment on delivery, silver of St. Corwen. (Margin, in Dravin's hand: 'God forgive me, it's a counter-gear.')"
```

```yaml item
id: item.warden_line_tablets
name: "Tablets of the warden line"
category: document
description: "Seven cairn tablets from Dravin's family shelf, copied."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Odrik, who walked out of the mountain with the Key on the day of sealing, and waited. Odrin, who waited. Dravna, who waited and wrote to the king. Odrik the Younger, who waited. Dorrin, who waited. Dravik, who waited and was paid. (The seventh tablet is blank, the stone already cut and dressed.)"
```

```yaml item
id: item.ostrel_mail
name: "Ostrel-pattern mail"
category: armor
description: "Dwarven-pattern riveted mail with a quilted liner, made in Assengard to an old Ostrel pattern. Lighter than it looks."
price: 420
stack_max: 1
equip_slot: armor
weapon: null
armor: {armor: 34, resist: {cold: 0.85}}
consumable: null
readable_text: null
```

```yaml item
id: item.warden_breaker
name: "Warden-breaker maul"
category: weapon
description: "A dwarven maul with a wedge-shaped head, made for cracking iron plate. Slow, brutal, good against constructs."
price: 380
stack_max: 1
equip_slot: main_hand
weapon: {base: 24, type: blunt, block_pct: 0.65, armor_pen: 20, bonus_vs: {construct: 1.5}, moveset: mace}
armor: null
consumable: null
readable_text: null
```

```yaml clue
id: clue.counter_gear_commission
theory: theory.anselm_plan
title: "The counter-gear"
text: "Last spring an Abbey scribe commissioned Dravin to forge seven reversed gear-teeth. Seated on the throne-shaft, they let Ostrel's lock run backward. Anselm prepared the machine as well as the words."
supports: [anselm]
refutes: []
```

```yaml clue
id: clue.weeping_gate_route
theory: theory.anselm_plan
title: "The Weeping Gate"
text: "A forgotten postern beneath the Old Grey Matron, above the collapsed sky-bridge past Wyvern's Roost. The Iron-Key opens it. It bypasses the snow-choked main portals that the Choir holds."
supports: []
refutes: []
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.a3_dravin_joined, type: milestone, desc: "Dravin Ostrel joined with the Iron-Key (Act II or III)."}
  - {id: flag.dravin_recruited, type: bool, desc: "Dravin has joined. Read by the Lock Chamber (gear-brake station, Command the Vault) and epilogues; unlike in_party, true even when Maelis holds the companion slot."}
  - {id: flag.dravin_letter_shown, type: bool, desc: "Dravin was shown his own dispatch."}
  - {id: flag.dravin_confessed, type: bool, desc: "Dravin admitted forging the counter-gear."}
  - {id: flag.assengard_raid_done, type: bool, desc: "The Choir cell at the forge is gone (fought, yielded, or withdrew)."}
  - {id: flag.assengard_cell_withdrew, type: bool, desc: "The cell was talked into leaving for the mountain."}
  - {id: flag.assengard_cell_shaken, type: bool, desc: "The cell leader fled; a reduced fight followed."}
reads:
  - ded.anselm_treason_proven
  - item.dravin_letter
  - item.choir_robe
  - item.anselm_cipher
```

## 9. Quest hooks

```yaml quest_stages
quest: quest.main_a3
order: 20
stages:
  - id: key_to_the_mountain
    journal: "Karak Ostrel is sealed. Dravin Ostrel of Assengard keeps the Iron-Key to a forgotten postern, the Weeping Gate. The Strept clans know the paths around the Choir's barricade on the Stairs, if Hesk can be won."
    objectives:
      - {id: get_key, text: "Get the Iron-Key from Dravin Ostrel, or find another way into the mountain", condition: "has_item(item.iron_key) or ms(ms.a3_ostrel_entered)", optional: false}
      - {id: strept_guides, text: "Win guides from the Strept clans", condition: "flag(flag.strept_guides)", optional: true, xp: 150}
      - {id: strept_warband, text: "Bring Hesk's war-band", condition: "in_party(ally.strept_warband)", optional: true, xp: 200}
      - {id: watch_signal, text: "Light the beacon at Marnadal Watch so Kosk can ride", condition: "flag(flag.watch_signal_lit)", optional: true, xp: 100}
      - {id: counter_gear, text: "Learn what Dravin forged for the Abbey", condition: "has_clue(clue.counter_gear_commission)", optional: true, xp: 80}
    on_complete: []
    next: []
```

The required objective accepts `ms.a3_ostrel_entered`, so a player who enters through the Silver Mine breach (a3.06, Lower Halls) without the Key still completes the stage.

## 10. Rumors and event cards (optional)
None.

## 11. Failure states and branches

```yaml branches
paths:
  - id: join_act_two
    when: "Act II with ded.anselm_treason_proven."
    outcome: "Dravin joins early with the Key; no Act III raid."
    sets: ["recruit(companion.dravin)", "give_item(item.iron_key, 1)", "reach_milestone(ms.a3_dravin_joined)"]
  - id: refuse_act_two
    when: "Act II without the deduction."
    outcome: "Dravin talks but won't join; the proof option is shown locked. Return any time."
    sets: []
  - id: raid_fought
    when: "Act III, the player fights the cell."
    outcome: "Dravin helps, then joins unconditionally."
    sets: ["set_flag(flag.assengard_raid_done)"]
  - id: raid_talked_down
    when: "Choir robe + cipher Persuade 6, or robe alone Persuade 8."
    outcome: "The cell leaves for the mountain (flavor: they are part of the finale's first wave); same XP as fighting."
    sets: ["set_flag(flag.assengard_cell_withdrew)"]
  - id: raid_shaken
    when: "Intimidate 8."
    outcome: "Wendel and two others flee; a smaller fight."
    sets: ["set_flag(flag.assengard_cell_shaken)"]
failures:
  - id: player_dies
    result: reload_checkpoint
    recover: "Reload before_cell."
  - id: player_flees_raid
    result: soft_fail
    recover: "The cell stays; re-enter the yard and talk to Wendel again or fight."
guarantees:
  - "ms.a3_dravin_joined in Act III needs no check: fight the cell (fight option is unconditional), then choose 'Anselm has Prince Aldric...' in a3_hub."
  - "If Dravin joined in Act II, the Act III raid never fires (condition not flag.dravin_recruited)."
```

## 12. Open questions
- **One active companion vs the finale (gdd).** gdd §6.13 allows one combat companion at a time, but §6.14 wants Dravin at the gear-brake and Maelis on the verse channel, and §7.3 uses either one for rune doors. My resolution: `flag.dravin_recruited` makes Dravin a scripted **station** actor in the Lock Chamber (the gear-brake on the north gallery, and the voice for Command the Vault) whatever the active slot holds. In the finale only, Maelis fights if she is recruited and alive, whatever the active slot holds, so her channel bonus applies whenever Abbey is Allied. See a3.07.
- **Recruiting Dravin while Maelis is active.** `recruit(companion.dravin)` should put Dravin in the slot and send Maelis to "waiting" (rejoinable at any rest point). The companions domain should define this swap.
- **Talk-down XP.** `add_xp(240)` approximates the encounter's XP (3 zealots × 40 + 2 crossbowmen × 12 = 144, plus the stage 4 extra member). The gdd says a fight skipped through dialogue awards the same XP as winning it, which ideally the system computes automatically.
