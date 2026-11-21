---
section_id: side.abbey_ledgers
title: "The Locked Scriptorium"
act: 1
story_ref: "story.md §10 Abbey of St. Corwen; §3 Sister Maelis, The Pale Choir; §5.4"
zones: [zone.abbey_scriptorium]
available_when: "ms(ms.a1_abbey_done)"
escalation_stage_required: {min: 0, max: 3}
milestones_set: []
milestones_read: [ms.a1_abbey_done, ms.act2_twist]
level_band: [3, 6]
---

# The Locked Scriptorium

## 1. Scene summary
After the player has seen the sliced *Book of the Lion*, Sister Maelis comes to them in secret. Abbot Anselm locked the scriptorium the same week the verse was cut, and set Brother Hollin to sleep across its door. Inside the inner press is a psalter Anselm reads every morning that is not a psalter, and an alms ledger whose silver goes to "a merchant of Peixe". Maelis cannot take them herself; Hollin watches her. At night the player slips into the scriptorium: candle-lit copying desks, a lamp gallery patrolled by lay brothers, a bell tower, and a drain into the catacombs. They take the key or pick the press, find the full Choir membership list hidden in the hollow psalter, and get out by the door, the bell rope, or the drain. Maelis copies the list and her runner Pip carries it to the Lord Marshal: the court's spies are purged, the antidote rider and Maelis herself are safer, and Maelis leaves the Abbey to walk with the player. The dramatic question: how much of a holy house can you rob before you become what you are hunting?

## 2. Progress and escalation
- **Availability:** from `ms.a1_abbey_done` (Act I) through Act II. Escalation stage 0–3. Closes (abandoned) at `ms.act2_twist`: Anselm is gone and the Abbey is turned out by Kosk's men.
- **Location:** map node `map.cintra`. The new zone `zone.abbey_scriptorium` is reached from the cloister of `zone.abbey_st_corwen` (A04) through the scriptorium door, which opens only while the quest is active.
- **Milestones:** none set. Reads `ms.a1_abbey_done` and `ms.act2_twist`.
- **Escalation look:** stage 0, the scriptorium smells of lamp oil and vellum. Stage 1, Anselm has had the lower windows bricked; one lay brother more on the gallery (a zone variant). Stage 2, river damp has got into the walls: the drain is half flooded (deep water slows the crawl). Stage 3, Choir agents no longer hide: Hollin wears his pale feather openly on his collar and the alarm encounter gains one Choir member (gdd §6.1 rule, applied by the system).
- **Payoffs wired:** `item.choir_list` and `flag.choir_list_exposed` (gdd §6.2: no Maelis poisoning, no rider interception; gdd §6.14: −2 finale bodyguards). `recruit(companion.maelis)`. `clue.list_names_pell` supports Pell in the poisoner theory. `clue.abbey_silver_ledger` ties Abbey silver to Attre. In Act II, `item.choir_robe` lets the player walk in disguised (`disguise_tag: choir`).

## 3. Location layout
The scriptorium is the upper floor of the Abbey's east range, over the vestry. The player is meant to enter by the cloister door, cross the vestry where Maelis waits with a shaded candle, climb the night stair to the **copying hall**, and work toward the **inner press** at the far end while avoiding the gallery patrol.

- **Vestry (entry):** low vaulted room of copes and censers. Maelis waits here (or in the herb garden after an alarm). Pip keeps watch at the cloister door. A night stair climbs to the hall.
- **Copying hall:** forty paces long, twelve wide. Two rows of slanted desks with stools (half cover; crouch behind them). Lecterns with chained books. Iron candle-trees every ten paces: lit ones throw full light (suspicion ×1); the player can pinch out four of them (interactables) to make shadow lanes. Brother Hollin keeps vigil at a lectern by the press door.
- **Lamp gallery:** a wooden balcony running along the north wall above the hall, reached by a ladder at each end. One lay brother walks it end to end. From the gallery the guard sees the whole central aisle; the desks along the south wall are in his blind spot.
- **Hollin's cell:** a cupboard-sized room off the hall's west end: pallet, scourge, a key peg (the scriptorium key hangs there while he keeps vigil), and a pale feather sewn into a spare collar.
- **Inner press room:** behind an iron-banded door at the east end. Tall oak presses. The locked one holds the alms ledger and the hollow psalter with the Choir list.
- **Bell tower stair:** off the press room. A spiral stair to the bell chamber; the bell rope runs down the outside wall to the herb garden (an escape route; ringing it on the way down is optional and loud).
- **Catacomb drain:** a grate in the press room floor. A crawl through a stone channel (deep water at stage 2+) that comes out in the herb garden by the well.
- **Herb garden:** walled, dark, outside the east range. Fallback meeting point.

Sight lines: the gallery guard covers the central aisle; Hollin's vigil lectern faces the press door, his back to the hall. The intended stealth route runs along the south desks under the gallery, pinching candles, to Hollin's cell for the key, then behind Hollin to the press door.

```yaml zone
id: zone.abbey_scriptorium
name: "Scriptorium of St. Corwen"
kind: interior
map_node: map.cintra
time_of_day: night
cold_rate: 0
disguise_tag: choir
music: stealth_abbey
areas:
  - {id: vestry, description: "Vaulted room of copes, censers and chests. One shaded candle. The night stair leads up."}
  - {id: copying_hall, description: "Forty paces of slanted desks and stools in two rows, chained lecterns, iron candle-trees."}
  - {id: south_desks, description: "The desk row under the gallery's blind spot. Half cover, crouch lane."}
  - {id: lamp_gallery, description: "Wooden balcony along the north wall, ladders at both ends. Overlooks the central aisle."}
  - {id: hollin_cell, description: "Cupboard cell: pallet, scourge, a key peg, a spare collar with a feather sewn inside."}
  - {id: vigil_lectern, description: "Hollin's lectern before the iron-banded press door."}
  - {id: press_room, description: "Tall oak presses smelling of beeswax. A floor grate. A door to the bell stair."}
  - {id: bell_stair, description: "Spiral stair up to the bell chamber; the bell rope hangs out of a louvre down the east wall."}
  - {id: drain, description: "Stone channel under the floor grate, a crawl in black water."}
  - {id: herb_garden, description: "Walled garden outside the east range. A well, rosemary beds, a door to the cloister."}
spawns:
  - {id: cloister_door, area: vestry, default: true}
  - {id: garden_landing, area: herb_garden}
  - {id: gallery_ladder, area: lamp_gallery}
  - {id: press_door, area: vigil_lectern}
exits:
  - id: to_cloister
    area: vestry
    to_zone: zone.abbey_st_corwen
    to_spawn: scriptorium_door
    condition: "not flag(flag.scriptorium_alarm)"
    effects: []
  - id: garden_gate
    area: herb_garden
    to_zone: zone.abbey_st_corwen
    to_spawn: herb_garden_gate
    condition: "true"
    effects: []
  - id: bell_rope_down
    area: bell_stair
    to_zone: zone.abbey_scriptorium
    to_spawn: garden_landing
    condition: "true"
    effects: []
  - id: drain_crawl
    area: press_room
    to_zone: zone.abbey_scriptorium
    to_spawn: garden_landing
    condition: "true"
    effects: []
interactables:
  - id: candle_tree_1
    area: copying_hall
    kind: lever
    label: "Pinch out the candles"
    condition: "true"
    check: null
    once: true
    effects: []
    fail_effects: []
  - id: candle_tree_2
    area: copying_hall
    kind: lever
    label: "Pinch out the candles"
    condition: "true"
    check: null
    once: true
    effects: []
    fail_effects: []
  - id: candle_tree_3
    area: south_desks
    kind: lever
    label: "Pinch out the candles"
    condition: "true"
    check: null
    once: true
    effects: []
    fail_effects: []
  - id: candle_tree_4
    area: south_desks
    kind: lever
    label: "Pinch out the candles"
    condition: "true"
    check: null
    once: true
    effects: []
    fail_effects: []
  - id: key_peg
    area: hollin_cell
    kind: pickup
    label: "Take the brass key"
    condition: "not has_item(item.scriptorium_key)"
    check: null
    once: true
    effects: ["give_item(item.scriptorium_key, 1)"]
    fail_effects: []
  - id: feather_collar
    area: hollin_cell
    kind: search
    label: "Search the spare collar"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.pale_feather, 1)"]
    fail_effects: []
  - id: inner_press_key
    area: press_room
    kind: container
    label: "Unlock the inner press"
    condition: "has_item(item.scriptorium_key) and not has_item(item.choir_list)"
    check: null
    once: true
    effects: ["play_beat(press_opened)", "give_item(item.choir_list, 1)", "give_item(item.abbey_silver_ledger, 1)", "add_clue(clue.abbey_silver_ledger)", "add_clue(clue.list_names_pell)"]
    fail_effects: []
  - id: inner_press_pick
    area: press_room
    kind: container
    label: "Pick the press lock"
    condition: "not has_item(item.scriptorium_key) and not has_item(item.choir_list)"
    check: {skill: investigate, dc: 6}
    once: false
    effects: ["play_beat(press_opened)", "give_item(item.choir_list, 1)", "give_item(item.abbey_silver_ledger, 1)", "add_clue(clue.abbey_silver_ledger)", "add_clue(clue.list_names_pell)"]
    fail_effects: ["play_beat(lock_rattle)", "start_dialogue(dlg.hollin_caught)"]
  - id: rubric_desk
    area: copying_hall
    kind: readable
    label: "Read the open copy-book"
    condition: "true"
    check: null
    once: true
    effects: []
    fail_effects: []
  - id: ring_the_bell
    area: bell_stair
    kind: lever
    label: "Ring the bell as you go"
    condition: "true"
    check: null
    once: true
    effects: ["play_beat(bell_rung)", "set_flag(flag.scriptorium_alarm)", "add_rep(faction.abbey, -5)"]
    fail_effects: []
  - id: handoff_vestry
    area: vestry
    kind: search
    label: "Give Maelis the ledgers"
    condition: "has_item(item.choir_list) and not flag(flag.maelis_ledgers_done)"
    check: null
    once: false
    effects: ["start_dialogue(dlg.maelis_ledgers_done)"]
    fail_effects: []
  - id: handoff_garden
    area: herb_garden
    kind: search
    label: "Give Maelis the ledgers"
    condition: "has_item(item.choir_list) and not flag(flag.maelis_ledgers_done)"
    check: null
    once: false
    effects: ["start_dialogue(dlg.maelis_ledgers_done)"]
    fail_effects: []
triggers:
  - id: alarm_fight
    area: copying_hall
    on: beat_done
    source: alarm_raised
    condition: "not flag(flag.scriptorium_alarm)"
    once: true
    effects: ["set_flag(flag.scriptorium_alarm)", "add_rep(faction.abbey, -5)", "start_encounter(enc.scriptorium_alarm)"]
  - id: first_entry
    area: vestry
    on: enter
    source: null
    condition: "not visited(zone.abbey_scriptorium)"
    once: true
    effects: ["set_checkpoint(vestry_start)"]
hazards:
  - {id: candle_fire, area: copying_hall, kind: fire, params: {damage_per_second: 5}}
  - {id: drain_water, area: drain, kind: deep_mud, params: {speed_mult: 0.5}}
checkpoints:
  - {id: vestry_start, area: vestry}
  - {id: press_room_cp, area: press_room}
beats:
  - {id: press_opened, description: "The press door swings; inside, ledgers in calfskin and a psalter that thuds when lifted. Its pages are cut hollow around a folded list."}
  - {id: lock_rattle, description: "The pick snaps against the ward. The sound runs the length of the hall. Hollin's head comes up."}
  - {id: alarm_raised, description: "A guard's suspicion fills: 'Brothers! Thief in the house of God!' Candles flare along the gallery."}
  - {id: bell_rung, description: "The great bell booms over Cintra at the wrong hour. Lights come on in the dorter windows."}
  - {id: pip_rings_vespers, description: "Pip rings the small vespers bell in the cloister. The gallery brother grumbles and climbs down to see why."}
  - {id: faddo_leaves, description: "Brother Faddo whistles the other lay brother up to the bell chamber for dice."}
  - {id: hollin_bound, description: "Hollin is gagged with his own girdle and tied to his lectern."}
npcs:
  - {npc: npc.maelis, area: vestry, condition: "not flag(flag.scriptorium_alarm) and not flag(flag.maelis_ledgers_done)"}
  - {npc: npc.maelis, area: herb_garden, condition: "flag(flag.scriptorium_alarm) and not flag(flag.maelis_ledgers_done)"}
  - {npc: npc.novice_pip, area: vestry, condition: "true"}
  - {npc: npc.brother_hollin, area: vigil_lectern, condition: "not flag(flag.hollin_dealt)"}
  - {npc: npc.brother_faddo, area: lamp_gallery, condition: "not flag(flag.faddo_bribed)"}
encounters: [enc.scriptorium_alarm]
loot:
  - {container: vestry_chest, items: [{item: item.poultice, count: 1}], condition: "true"}
variants:
  - id: stage1_bricked
    when: "stage() >= 1"
    description: "Lower windows freshly bricked. A second lay brother patrols the gallery."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: stage2_flooded_drain
    when: "stage() >= 2"
    description: "River damp: the drain is waist deep in black water."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: stage3_open_feathers
    when: "stage() >= 3"
    description: "Hollin wears his pale feather openly on his collar."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: faddo_bribed
    when: "flag(flag.faddo_bribed)"
    description: "The gallery is empty; dice rattle faintly from the bell chamber."
    npcs_absent: [npc.brother_faddo]
    encounters_disabled: []
    interactables_disabled: []
  - id: after_raid
    when: "flag(flag.maelis_ledgers_done)"
    description: "The press stands open and empty. Hollin's lectern is bare. Pip sweeps the vestry."
    npcs_absent: [npc.brother_hollin, npc.brother_faddo]
    encounters_disabled: [enc.scriptorium_alarm]
    interactables_disabled: [inner_press_key, inner_press_pick, key_peg]
```

Stealth notes (gdd §6.5): Hollin and the gallery lay brother (Faddo, plus a second unnamed brother at stage ≥ 1) use standard vision cones (90°, 12 m; 6 m in the pinched-out shadow lanes) and suspicion meters. At suspicion 100 the zone plays `alarm_raised`, which fires the `alarm_fight` trigger. Takedowns are allowed on all three; a takedown of Hollin sets `flag.hollin_dealt` and lets the player take the key from his belt (the key peg interactable stays as the quieter option). In Act II, wearing `item.choir_robe` makes the player "permitted" here; only opening the press or entering Hollin's cell counts as a restricted action.

## 4. NPCs present

**Sister Maelis** (`npc.maelis`, declared by A04). Here she is braver than she feels: whispers fast, keeps her hands hidden in her sleeves so the player won't see them shake, and corrects the player's pronunciation of saints' names out of nerves.

**Brother Hollin.** Voice notes: a big, soft-spoken man who was a farrier before he took vows; speaks in short scripture-flavoured sentences, never contractions when angry. Believes every word Anselm says. Not cruel by nature, which makes his certainty worse.

**Novice Pip.** Voice notes: eleven, quick, cheeky, says "sister" to Maelis and "sir" to everyone else with exaggerated care. Loves Maelis like an older sister. Steals bread from the kitchens on principle.

**Brother Faddo.** Voice notes: a fat, lazy lay brother, not Choir, owes money at dice to half the dorter. Sighs before every sentence.

```yaml npc
id: npc.brother_hollin
name: "Brother Hollin"
faction: faction.choir
role: "Warden of the scriptorium, Choir-sworn"
motive: "Keep the Abbot's press shut and the Abbot's secrets holy."
secret: "He sewed a pale feather into his spare collar the night Anselm told him the Pact was a chain on the poor. He carried the knife that cut the Book to the river."
disposition: wary
essential: false
dialogue: dlg.hollin_caught
barks: ["The house sleeps. So should you.", "Who walks there?", "God sees the lamp you hide.", "Brothers, to me!"]
combat: enemy.choir_thug
shop: null
```

```yaml npc
id: npc.novice_pip
name: "Pip"
faction: faction.abbey
role: "Abbey novice and Sister Maelis's runner"
motive: "Help Sister Maelis; never go back to the gutter he came from."
secret: "He knows every drain and coal-chute in the Abbey because he used them to steal before he took the tonsure."
disposition: friendly
essential: true
dialogue: dlg.pip_lookout
barks: ["Quiet as mice, sir.", "Brother Faddo snores on the third ladder rung. Don't ask me how I know.", "Sister says you're the good kind of trouble."]
combat: null
shop: null
```

```yaml npc
id: npc.brother_faddo
name: "Brother Faddo"
faction: faction.abbey
role: "Lay brother on the night gallery watch"
motive: "Get through the night without work, and win back what he lost at dice."
secret: "Owes thirty crowns to a dice-cutter in Gutter Lane."
disposition: neutral
essential: false
dialogue: dlg.faddo_bribe
barks: ["Mmh. Nobody here. Nobody ever here.", "Six again. Always six for them.", "Who's there? ...Rats. It's always rats."]
combat: enemy.choir_thug
shop: null
```

## 5. Dialogue trees

`dlg.maelis_ledgers_offer` is chained from Maelis's dialogue in `zone.abbey_st_corwen` (A04 adds an option with `start_dialogue(dlg.maelis_ledgers_offer)`, condition `ms(ms.a1_abbey_done) and not quest_active(quest.side_abbey_ledgers) and not quest_done(quest.side_abbey_ledgers)`).

```yaml dialogue
id: dlg.maelis_ledgers_offer
participants: [npc.maelis]
start: open
nodes:
  open:
    type: line
    speaker: npc.maelis
    text: "Not here. Walk with me to the well, and look at the roses, not at me. Brother Hollin watches whoever I speak to."
    direction: "She keeps her eyes on the rose beds."
    next: ask
  ask:
    type: line
    speaker: npc.maelis
    text: "The Abbot locked the scriptorium the week the verse was cut. In the inner press there's a psalter he reads every morning. It's heavier than prayer. And an alms ledger."
    next: hub
  hub:
    type: choice
    options:
      - id: what_ledger
        text: "What's in the alms ledger?"
        next: ledger_answer
      - id: why_me
        text: "Why not take them yourself?"
        next: why_me_answer
      - id: key
        text: "How do I get in?"
        next: key_answer
      - id: key_copy
        text: "You must have a key somewhere. You're the archivist."
        tag: sway
        condition: "rep_tier(faction.abbey) >= friendly and not has_item(item.scriptorium_key)"
        show_locked: true
        next: key_copy_answer
      - id: accept
        text: "Tonight, then. Where will you be?"
        effects: ["start_quest(quest.side_abbey_ledgers)"]
        next: accept_answer
      - id: refuse
        text: "Robbing an abbey for a nun. Not yet."
        next: refuse_answer
  ledger_answer:
    type: line
    speaker: npc.maelis
    text: "Alms go out to the poor. These went out to 'a merchant of Peixe', in silver, by the chest. The poor of Cintra don't live in Peixe."
    next: hub
  why_me_answer:
    type: line
    speaker: npc.maelis
    text: "Because Hollin sleeps across the door and counts my steps. If I'm caught, I'm a sister with a fever who wandered. If you're caught, you're a thief. Thieves can run."
    next: hub
  key_answer:
    type: line
    speaker: npc.maelis
    text: "Hollin keeps vigil at night and hangs the key in his cell. Brother Faddo walks the gallery; he'd sell his sandals for a dice stake. Pip knows every drain in the house."
    next: hub
  key_copy_answer:
    type: line
    speaker: npc.maelis
    text: "I had a copy cut when I was made archivist, before the Abbot changed the press locks. It still fits the inner press, I think. I never dared try."
    direction: "She drops a brass key into the player's palm as if passing alms."
    effects: ["give_item(item.scriptorium_key, 1)"]
    next: hub
  accept_answer:
    type: line
    speaker: npc.maelis
    text: "In the vestry under the scriptorium, after compline. If anything goes wrong, the herb garden by the well. Pip will find you either way. God forgive us both."
    next: bye
  refuse_answer:
    type: line
    speaker: npc.maelis
    text: "Then I'll pray you change your mind before I change my habit for a shroud."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.pip_lookout
participants: [npc.novice_pip]
start: open
nodes:
  open:
    type: branch
    cases:
      - {if: "has_item(item.choir_list) and not flag(flag.choir_list_exposed) and flag(flag.maelis_ledgers_done)", next: courier_offer}
      - {if: "quest_done(quest.side_abbey_ledgers)", next: after}
    else: greet
  greet:
    type: line
    speaker: npc.novice_pip
    text: "Evening, sir. Brother Faddo's on the gallery and Brother Hollin's at his lectern, praying with his eyes open. He does that."
    next: hub
  hub:
    type: choice
    options:
      - id: distract
        text: "Can you draw the gallery brother away?"
        once: true
        next: distract_answer
      - id: routes
        text: "If it goes wrong, how do I get out?"
        next: routes_answer
      - id: go
        text: "Keep watch."
        next: bye
  distract_answer:
    type: line
    speaker: npc.novice_pip
    text: "I'll ring the little vespers bell in the cloister. He'll climb down grumbling to box my ears. Count to sixty and go."
    effects: ["play_beat(pip_rings_vespers)"]
    next: bye
  routes_answer:
    type: line
    speaker: npc.novice_pip
    text: "The bell rope down the east wall, if you don't mind your hands. Or the grate in the press room floor. It's wet and it smells, but it comes out by the well."
    next: hub
  courier_offer:
    type: line
    speaker: npc.novice_pip
    text: "Sister said you might want that list carried to the Lord Marshal after all. I can be at the palace gate before the bread's out."
    next: courier_hub
  courier_hub:
    type: choice
    options:
      - id: send
        text: "Take it. Into Kosk's hand, nobody else's."
        effects: ["set_flag(flag.choir_list_exposed)", "add_rep(faction.crown, 5)", "add_rep(faction.abbey, 5)"]
        next: sent
      - id: keep
        text: "Not yet."
        next: bye
  sent:
    type: line
    speaker: npc.novice_pip
    text: "Into his hand. I'll bite anyone else who reaches for it."
    next: bye
  after:
    type: line
    speaker: npc.novice_pip
    text: "The house is all whispers now, sir. Brothers looking at each other's collars."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.faddo_bribe
participants: [npc.brother_faddo]
start: open
nodes:
  open:
    type: line
    speaker: npc.brother_faddo
    text: "Who's... oh. You're not a rat. You're worse than a rat, you're a visitor. The house is closed. Go and be closed somewhere else."
    direction: "Sighing, propped on the gallery rail."
    next: hub
  hub:
    type: choice
    options:
      - id: bribe
        text: "I hear you need a stake. Go and win it back somewhere else for a while."
        tag: bribe
        bribe: 30
        effects: ["set_flag(flag.faddo_bribed)", "play_beat(faddo_leaves)"]
        next: bribed
      - id: persuade
        text: "Brother, you've been on your feet all night. The Abbot won't know. Go and sit down. [Persuade 6]"
        tag: persuade
        check: {skill: persuade, dc: 6, pass: persuade_pass, fail: persuade_fail}
        once: true
      - id: threaten
        text: "Shout and I'll put you over that rail. [Intimidate 6]"
        tag: intimidate
        check: {skill: intimidate, dc: 6, pass: threat_pass, fail: threat_fail}
        once: true
      - id: leave
        text: "Sorry, brother. Wrong door."
        next: leave_line
  bribed:
    type: line
    speaker: npc.brother_faddo
    text: "God loves a cheerful giver. I'll be up the bell tower with Brother Osk, losing this. Don't steal anything I'd be blamed for."
    next: bye
  persuade_pass:
    type: line
    speaker: npc.brother_faddo
    text: "My feet. You're right about my feet. Nobody ever asks about my feet."
    effects: ["set_flag(flag.faddo_bribed)", "play_beat(faddo_leaves)"]
    next: bye
  persuade_fail:
    type: line
    speaker: npc.brother_faddo
    text: "And then I'm the one Hollin flogs. No. Go away before I have to do something."
    next: hub
  threat_pass:
    type: line
    speaker: npc.brother_faddo
    text: "Not a sound. I'm a stone. Stones don't see anything."
    direction: "He sits down hard on the gallery boards and covers his eyes."
    effects: ["set_flag(flag.faddo_bribed)"]
    next: bye
  threat_fail:
    type: line
    speaker: npc.brother_faddo
    text: "Brother Hollin! Brother Hollin, there's a man up here!"
    effects: ["play_beat(alarm_raised)"]
    next: bye
  leave_line:
    type: line
    speaker: npc.brother_faddo
    text: "Every night, someone's wrong door."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.hollin_caught
participants: [npc.brother_hollin]
start: open
nodes:
  open:
    type: line
    speaker: npc.brother_hollin
    text: "The scriptorium is closed by the Abbot's order. You are in the house of God at night with a thief's tools. Speak, and speak true."
    direction: "He rises from the lectern, filling the aisle."
    next: hub
  hub:
    type: choice
    options:
      - id: abbot_sent
        text: "The Abbot sent me for the alms ledger. He didn't want to wake you. [Persuade 8]"
        tag: persuade
        check: {skill: persuade, dc: 8, pass: abbot_pass, fail: abbot_fail}
        once: true
      - id: feather
        text: "Peace, brother. We wear the same feather. [Item: Pale feather]"
        tag: item
        condition: "has_item(item.pale_feather)"
        once: true
        next: feather_answer
      - id: book
        text: "You know who cut the Book of the Lion, Hollin. You carried the knife to the river. [Clue: The sliced book]"
        tag: clue
        condition: "has_clue(clue.book_sliced)"
        once: true
        next: book_answer
      - id: threaten
        text: "Give me the key and you keep your teeth. Shout and you don't. [Intimidate 8]"
        tag: intimidate
        check: {skill: intimidate, dc: 8, pass: threat_pass, fail: threat_fail}
        once: true
      - id: writ
        text: "Lord Marshal's business. Stand aside. [Item: Marshal's writ]"
        tag: item
        condition: "has_item(item.kosk_writ)"
        once: true
        next: writ_answer
      - id: fight
        text: "Draw steel."
        effects: ["play_beat(alarm_raised)"]
        next: bye
      - id: retreat
        text: "I'm lost. I'll go."
        next: retreat_answer
  abbot_pass:
    type: line
    speaker: npc.brother_hollin
    text: "He works himself to the bone for this kingdom. Take the ledger and go softly. I'll pray for you both."
    direction: "He lifts the key from his belt and goes back to his lectern, eyes closed."
    effects: ["give_item(item.scriptorium_key, 1)", "set_flag(flag.hollin_dealt)"]
    next: bye
  abbot_fail:
    type: line
    speaker: npc.brother_hollin
    text: "The Abbot sends no one at night. The Abbot sends me. Brothers!"
    effects: ["play_beat(alarm_raised)"]
    next: bye
  feather_answer:
    type: branch
    cases:
      - {if: "skill(lore) >= 6", next: feather_pass}
    else: feather_fail
  feather_pass:
    type: line
    speaker: npc.brother_hollin
    text: "The light from dark. Forgive me. They said a sister would come for the list one day, and to give it only to a feather. Go quickly."
    effects: ["give_item(item.scriptorium_key, 1)", "set_flag(flag.hollin_dealt)"]
    next: bye
  feather_fail:
    type: line
    speaker: npc.brother_hollin
    text: "Then say the words. ...No? A feather off a dead man. Brothers, to me!"
    effects: ["play_beat(alarm_raised)"]
    next: bye
  book_answer:
    type: line
    speaker: npc.brother_hollin
    text: "I carried no... The Abbot said the page was a chain. A chain on the poor. You cannot understand it, you're the nobles' dog."
    direction: "His big hands open and close."
    next: book_hub
  book_hub:
    type: choice
    options:
      - id: book_press
        text: "Give me the key and I'll forget your face when they hang the cutters. [Persuade 6]"
        tag: persuade
        check: {skill: persuade, dc: 6, pass: book_pass, fail: book_fail}
        once: true
      - id: book_fight
        text: "Then we finish this."
        effects: ["play_beat(alarm_raised)"]
        next: bye
  book_pass:
    type: line
    speaker: npc.brother_hollin
    text: "Take it. Take it and let me pray. I did not know it would come to keys and thieves."
    effects: ["give_item(item.scriptorium_key, 1)", "set_flag(flag.hollin_dealt)", "play_beat(hollin_bound)"]
    next: bye
  book_fail:
    type: line
    speaker: npc.brother_hollin
    text: "No. No, the Abbot is right, and you are the lie. Brothers!"
    effects: ["play_beat(alarm_raised)"]
    next: bye
  threat_pass:
    type: line
    speaker: npc.brother_hollin
    text: "There. There is your key. God sees you."
    direction: "He unhooks it slowly and lets the player bind him with his own girdle."
    effects: ["give_item(item.scriptorium_key, 1)", "set_flag(flag.hollin_dealt)", "play_beat(hollin_bound)"]
    next: bye
  threat_fail:
    type: line
    speaker: npc.brother_hollin
    text: "I shod horses that kicked harder than you. Brothers!"
    effects: ["play_beat(alarm_raised)"]
    next: bye
  writ_answer:
    type: line
    speaker: npc.brother_hollin
    text: "The Marshal burned the Strept halls with children in them. His writ is ash in God's house. Brothers, to me!"
    effects: ["play_beat(alarm_raised)"]
    next: bye
  retreat_answer:
    type: line
    speaker: npc.brother_hollin
    text: "Then be lost elsewhere. I will walk you down. And I will remember your face."
    effects: ["goto_zone(zone.abbey_st_corwen, scriptorium_door)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.maelis_ledgers_done
participants: [npc.maelis]
start: open
nodes:
  open:
    type: branch
    cases:
      - {if: "flag(flag.scriptorium_alarm)", next: loud}
    else: quiet
  loud:
    type: line
    speaker: npc.maelis
    text: "The whole house is awake. Hollin saw me run. I can't go back in there now, not ever. Show me. Quickly, before they come round the well."
    direction: "Breathless, her hood torn."
    next: read
  quiet:
    type: line
    speaker: npc.maelis
    text: "You're back. You're not bleeding. God is occasionally kind. Show me."
    next: read
  read:
    type: line
    speaker: npc.maelis
    text: "Pell, the Queen's taster. Hollin. Three of the Queen's own maids. A watch corporal. A clerk of the Chancellery. Thirty-eight names, and men who cut throats for hire."
    direction: "She reads by the shaded candle, lips white."
    next: read_two
  read_two:
    type: line
    speaker: npc.maelis
    text: "And the alms ledger. Abbey silver, chest after chest, to Peixe. To Duke Raimund's port. The Abbot is buying something from Attre with the bread of the poor."
    next: hub
  hub:
    type: choice
    options:
      - id: send_kosk
        text: "Copy it. Send the copy to the Lord Marshal tonight."
        effects: ["set_flag(flag.choir_list_exposed)", "add_rep(faction.crown, 5)"]
        next: sent
      - id: keep
        text: "Not yet. The Marshal's house leaks too. I'll keep it until I know who to trust."
        next: kept
  sent:
    type: line
    speaker: npc.maelis
    text: "Pip will run it to the palace gate. Kosk's men will be pulling feathers out of collars by noon. And I'm coming with you. There's nothing left for me in this house."
    effects: ["set_flag(flag.maelis_ledgers_done)", "add_rep(faction.abbey, 15)", "recruit(companion.maelis)"]
    next: bye
  kept:
    type: line
    speaker: npc.maelis
    text: "Then you're keeping thirty-eight knives in your pocket. Every day they stay sheathed is a day they choose where to cut. But it's your neck. And mine: I'm coming with you."
    effects: ["set_flag(flag.maelis_ledgers_done)", "add_rep(faction.abbey, 5)", "recruit(companion.maelis)"]
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.scriptorium_alarm
zone: zone.abbey_scriptorium
enemies:
  - {enemy: enemy.choir_thug, count: 2, spawn: gallery_ladder, variant: lay_brother}
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: gallery_ladder, variant: null}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.choir_thug, count: 1, spawn: press_door, variant: warden}]}
attack_tokens: null
allow_yield: true
allies: []
checkpoint: press_room_cp
avoidable_by: ["dlg.hollin_caught", "dlg.faddo_bribe"]
on_won: ["set_flag(flag.hollin_dealt)"]
on_yielded: ["set_flag(flag.hollin_dealt)"]
on_player_fled: []
```

Notes: two lay brothers with cudgels come down the gallery ladder while a crossbowman (a Choir-sworn brother with a hunting crossbow) holds the gallery rail. When they fall, Hollin (`warden` variant: thug stats, +20 HP) comes from his lectern. All four can yield; the player can spare or kill them, and killing monks in the scriptorium costs `faction.abbey` −5 per kill (applied by the encounter's yield system as a standard "execute" penalty; see open questions). The player can also break off at any time through the bell rope or the drain; leaving the fight does not lose anything already taken. If the press has not been opened yet, it can still be opened after the fight (or picked: the fail branch no longer matters once the alarm is up).

## 7. Items and clues

```yaml item
id: item.scriptorium_key
name: "Scriptorium key"
category: key
description: "A brass key worn smooth by a big thumb. Fits the inner press of St. Corwen's scriptorium."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.choir_list
name: "Choir membership list"
category: document
description: "Folded vellum from a hollowed psalter: thirty-eight names in Anselm's small, beautiful hand, each with a feather drawn beside it."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "The Choir of the Last Light. House: Pell, taster to the Queen's table. Agna, Ruth, Sabine, of the Queen's chamber. Corporal Dace, palace watch, north gate. Tibor, clerk of the Chancellery. Brothers of this house: Hollin, Osk, Benedek, Wido, Lukas, and nine more. Of the river: Mott's hooks. Of the road: twelve hired, paid by the head. Muster at Vel Aram when the light turns."
```

```yaml item
id: item.abbey_silver_ledger
name: "Abbey alms ledger"
category: document
description: "A calfskin alms ledger. The last two years of entries are in Anselm's own hand."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Alms to the poor of Cintra, Michaelmas: 4 crowns, bread. To a merchant of Peixe, for physick: 300 crowns silver, by chest. To the same, for bulbs of physick: 450 crowns silver. To the same: 600. To the poor: 2 crowns."
```

```yaml clue
id: clue.list_names_pell
theory: theory.poisoner
title: "The taster is on the Choir's list"
text: "Anselm's hidden list names Pell, the Queen's food-taster, among the Choir of the Last Light."
supports: [pell]
refutes: []
```

```yaml clue
id: clue.abbey_silver_ledger
theory: theory.poisoner
title: "Abbey silver to Peixe"
text: "The Abbey's alms ledger shows chests of silver paid by Anselm's hand to 'a merchant of Peixe' for 'bulbs of physick'."
supports: [anselm, raimund]
refutes: []
```

The readable copy-book on the hall desk (`rubric_desk`) is lore only: a novice's copy of St. Corwen's rule with Anselm's marginal note, "The lion's peace is a wolf's peace. Ask the halls of Marnadal."

## 8. Flags set and read

```yaml flags
declare:
  - {id: flag.choir_list_exposed, type: bool, desc: "The Choir list reached the Lord Marshal; court spies purged (gdd 6.2, 6.14)."}
  - {id: flag.scriptorium_alarm, type: bool, desc: "The scriptorium raid went loud."}
  - {id: flag.maelis_ledgers_done, type: bool, desc: "Maelis has the ledgers out of the Abbey; she has left the Abbey to travel with the player."}
  - {id: flag.hollin_dealt, type: bool, desc: "Hollin was talked, threatened, tricked, taken down or beaten; he no longer guards the press."}
  - {id: flag.faddo_bribed, type: bool, desc: "Brother Faddo left the gallery."}
reads:
  - ms.a1_abbey_done
  - ms.act2_twist
  - clue.book_sliced
  - item.kosk_writ
  - item.pale_feather
  - item.choir_robe
```

## 9. Quest hooks

```yaml quest
id: quest.side_abbey_ledgers
kind: side
title: "The Locked Scriptorium"
giver: npc.maelis
available: "ms(ms.a1_abbey_done)"
closes_on: "ms(ms.act2_twist)"
xp: 400
stages:
  - id: break_in
    journal: "Sister Maelis wants the Abbot's hollow psalter and alms ledger out of the locked scriptorium. She'll wait in the vestry after compline, or the herb garden if it goes wrong."
    objectives:
      - {id: enter, text: "Get into the scriptorium at night", condition: "visited(zone.abbey_scriptorium)", optional: false}
      - {id: key, text: "Get Brother Hollin's key", condition: "has_item(item.scriptorium_key)", optional: true, xp: 30}
      - {id: open_press, text: "Open the inner press", condition: "has_item(item.choir_list)", optional: false}
      - {id: quietly, text: "Do it without raising the alarm", condition: "has_item(item.choir_list) and not flag(flag.scriptorium_alarm)", optional: true, xp: 75}
    on_complete: []
    next: []
  - id: hand_off
    journal: "I have a list of thirty-eight names and a ledger of silver. Maelis is waiting."
    objectives:
      - {id: maelis, text: "Bring the ledgers to Maelis", condition: "flag(flag.maelis_ledgers_done)", optional: false}
      - {id: kosk, text: "Get the list to the Lord Marshal", condition: "flag(flag.choir_list_exposed)", optional: true, xp: 60}
    on_complete: []
    next: []
outcome_effects:
  completed: []
  failed: []
```

## 10. Rumors and event cards (optional)
None here. `rumor.r16_scriptorium_locked` (in `14-rumors.md`) points players at Maelis.

## 11. Failure states and branches

```yaml branches
paths:
  - id: ghost
    when: "Player pinches candles, takes the key from Hollin's peg (or Maelis's copy), opens the press, leaves by the vestry."
    outcome: "No alarm; list and ledger; Maelis joins; optional send to Kosk."
    sets: ["set_flag(flag.maelis_ledgers_done)"]
  - id: talker
    when: "Caught by Hollin: Persuade 8, the feather with Lore 6, the sliced-book clue with Persuade 6, or Intimidate 8."
    outcome: "Hollin hands over the key; no alarm."
    sets: ["set_flag(flag.hollin_dealt)"]
  - id: loud
    when: "Alarm: failed check, suspicion 100, the bell rung, or the player draws steel."
    outcome: "enc.scriptorium_alarm; Abbey -5; Maelis flees to the herb garden; she cannot return to the Abbey and joins."
    sets: ["set_flag(flag.scriptorium_alarm)"]
  - id: send_list
    when: "Player tells Maelis (or later Pip, or Bertha in her loft) to send the list to Kosk."
    outcome: "flag.choir_list_exposed: no Maelis poisoning, no rider interception, -2 finale bodyguards; Crown +5."
    sets: ["set_flag(flag.choir_list_exposed)"]
  - id: keep_list
    when: "Player keeps the list."
    outcome: "No flag yet. The list can still be sent from Pip (vestry) or Bertha's loft (side.bertha_debt) until the Act II twist."
    sets: []
failures:
  - id: player_dies
    result: reload_checkpoint
    recover: "Reload vestry_start or press_room_cp."
  - id: escorted_out
    result: soft_fail
    recover: "Hollin walks the player out (retreat option). The quest stays active; return by the cloister door and try again, or talk Faddo or Pip into helping."
  - id: lockpick_fails
    result: soft_fail
    recover: "Hollin confronts the player (dlg.hollin_caught); every outcome either yields the key or starts the alarm fight, after which the press can be opened freely."
  - id: maelis_seen
    result: soft_fail
    recover: "Maelis is never captured or killed here: on an alarm she escapes by the drain with Pip and meets the player in the herb garden."
  - id: closes_at_twist
    result: soft_fail
    recover: "At ms.act2_twist the quest is abandoned; a list still held is useless against a Choir already in the open."
guarantees:
  - "item.choir_list is always obtainable: the press can be opened with the key (peg, Maelis, Hollin) or picked, and after an alarm fight the press stays openable with no further check."
  - "flag.maelis_ledgers_done needs no check: hand the list to Maelis at the vestry or the herb garden."
  - "No main milestone depends on this quest."
```

## 12. Open questions
- **Stealth alarm as a beat:** this file assumes the stealth system plays the zone beat `alarm_raised` when a guard reaches suspicion 100 (gdd §6.5 "the zone's alarm branch fires"). If the engine uses a different hook (for example a reserved trigger `on: alarm`), rename the trigger here.
- **Executing yielded monks:** a per-kill Abbey −5 penalty is described in prose; there is no encounter field for "on execute" effects. Either add one to the encounter schema or drop the penalty.
- **Two placements of one NPC:** Maelis appears in two areas with exclusive conditions. Confirm the zone schema allows repeated `npc` entries.
- **Interacting with Maelis here** runs her default dialogue (A04). The hand-off uses interactables (`handoff_vestry`, `handoff_garden`) so it does not depend on A04's dialogue.
- **Feather password:** Hollin accepts a pale feather plus Lore 6 (knowing the Choir's call-and-response, "the light from dark", from Anselm's sermons). A branch node on `skill(lore) >= 6` is used rather than a check node so the player cannot retry; flag if branches should not test skills.
- **Maelis joining:** gdd §6.13 lets Maelis join at Act I end with Abbey Friendly "or the scriptorium quest done". Here she joins when the ledgers are handed over, which can happen mid-Act I. If companions must not join before `ms.act1_complete`, the recruit effect should move to the Act I transition with a condition on `flag.maelis_ledgers_done`.
- Pip's sending the list after the quest ends: the vestry stays reachable (cloister door exit condition is only the alarm flag). After an alarm, the vestry door is barred, so a kept list can be sent from Bertha's loft only.
