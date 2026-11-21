---
section_id: a1.07
title: "The Chociebuż Harvest Fair"
act: 1
story_ref: "story.md §5.7 (climax), §3 (Aldric, Pale Choir); gdd.md §6.13 (ally.aldric escort), §6.11 (ded.choir_exists), §6.18 (escort death), §7.1 #7 and the Act I gate"
zones: [zone.chociebuz_fair]
available_when: "ms(ms.a1_audience_done) and count_ms(ms.a1_sickroom_done, ms.a1_abbey_done, ms.a1_ring_done) >= 2"
escalation_stage_required: {min: 0, max: 0}
milestones_set: [ms.act1_complete]
milestones_read: [ms.a1_audience_done, ms.a1_sickroom_done, ms.a1_abbey_done, ms.a1_ring_done, ms.act1_complete]
level_band: [3, 4]
---

# The Chociebuż Harvest Fair

## 1. Scene summary

Once two of the Marshal's leads are run down, Kosk calls Hale to the war room. Prince Aldric has decided to ride through the Chociebuż Harvest Fair, a market town an hour from the capital, to show the realm that the heir is strong while the Queen is not. The Queen has agreed; Kosk cannot stop him; he wants Hale at the boy's stirrup. At the fair, between the ribbons and the pie stalls, Hale can prepare: search the oil row for staged grease casks, ask Kosk for crossbowmen on the granary roof, look twice at a chestnut-seller who watches the Prince too closely. Then the procession moves, the Choir's grease fire roars up across the oil row, Aldric's pony bolts, and assassins come out of the smoke with poisoned knives while crossbowmen shoot from the granary. Hale must keep the boy alive (if Aldric dies, the game is over) and bring down the ringleader, the Wren. Captured or killed, the Wren carries a pale gull feather in his collar and a route map to **Hanged Man's Oak**. In the quiet afterwards, Aldric, shaking, thanks Hale the only way a twelve-year-old prince knows how. The dramatic question: *can you protect the boy?* The section ends with Act I complete (`ms.act1_complete`).

## 2. Progress and escalation

- **Act I gate** (gdd §7.1): `ms.a1_audience_done` and two of {sickroom, abbey, ring}. When it is met, the palace trigger `t_fair_summons` (section 2) brings Hale to Kosk for `dlg.kosk_fair_announce`.
- **Point of no return.** Accepting the ride sets `flag.fair_started`, which closes sections 3–5 (`available_when`). The UI shows the gdd's warning ("unfinished leads will close"). Gull Tower stays open. The player can decline and come back via `dlg.kosk` option `fair_ready`.
- `ms.act1_complete` is reached at the end of `dlg.aldric_after_fair` (no check). This raises the escalation stage to 1 (gdd §6.1), and the Act I transition (section 8) begins immediately.
- `flag.aldric_trusts_player` is set here if `var.aldric_bond >= 3` (A05/A06 may read it).

## 3. Location layout

Chociebuż is a market town on the King's Road. Day look: bright autumn sun, bunting, smoke from cook-fires, a huge crowd. About 150 × 100 m. The crowd is soft cover and an obstacle: civilians block movement and line of sight until they panic (beat `grease_fire`), after which they flee toward the edges and clear the streets over ~10 s.

```
 W                                                                                        E
 [kings_road] --gate arch (wheat sheaves)-- RIBBON STREET (80 m, stalls both sides) ---- HARVEST GREEN
                                                |  (procession route)                    hay-bale stage, maypole
                                     chestnut_corner (the Wren's brazier)                cattle pens (E edge)
                                                |                                        GRANARY (N edge, tall,
                                            OIL_ROW (side row S: chandler, oil, lard vats,  roof = crossbow nest)
                                                     pitch boiler; grease casks under stalls)
                                                |
                                           church_lane (S) --- small chapel --- ford (river, exit)
```

- **kings_road**: the arrival. A timber gate arch hung with wheat sheaves. Kosk's escort forms up: Aldric on a grey pony, four of Kosk's riders, Sergeant Brask. Spawn. Kosk's briefing happens here.
- **ribbon_street**: the main street, 8 m wide, stalls on both sides: ribbons, apples, pies, a puppet show, a bear-ward with a muzzled old bear. The procession route runs west to east along it. Stall awnings are low cover; stall counters half cover.
- **chestnut_corner**: the junction of Ribbon Street and Oil Row. A chestnut-seller with a brazier, hood up, watching the gate. He is the Wren.
- **oil_row**: a narrow side row (5 m wide) of greasy trades: a tallow-chandler, an oil-seller (Hanka), pie-men with lard vats, a pitch boiler. **Grease casks** have been staged under three stalls, their bungs loosened. When the Wren throws his brazier, the row goes up: `grease_fire` hazard along the whole row and the junction.
- **harvest_green**: the open green at the east end. A hay-bale stage where the Reeve waits with the harvest crown for Aldric to present. A maypole. Cattle pens on the east edge: if the fire reaches the green, the cattle break out (`stampede` hazard, a line across the green, telegraphed by bellowing). Kosk waits by the stage.
- **granary**: a tall timber granary on the north side of the green, 9 m high, with a loading door and a flat-topped roof ridge. Two Choir crossbowmen hide in the loft and shoot from the roof once the fire starts, unless Kosk's own crossbowmen are posted there first. A ladder inside reaches the roof (melee route to them).
- **church_lane**: a lane south from Oil Row past the little chapel of St. Corwen to the river ford. The Wren's escape route: if he drops below 30% HP he runs for the ford; Hale must catch him (he is slowed by the crowd).
- **ford**: the river ford. The fight ends here if the Wren flees this far (he is cornered by Kosk's riders coming round: beat `wren_cornered`).

```yaml zone
id: zone.chociebuz_fair
name: "The Chociebuż Harvest Fair"
kind: exterior
map_node: map.chociebuz
time_of_day: day
cold_rate: 0
disguise_tag: null
music: fair_festive
areas:
  - {id: kings_road, description: "Arrival on the King's Road. Timber gate arch with wheat sheaves. Kosk's escort forms up."}
  - {id: ribbon_street, description: "Main street, 8 m wide, 80 m long. Stalls both sides (awnings low cover, counters half cover), puppet show, bear-ward. Procession route."}
  - {id: chestnut_corner, description: "Junction of Ribbon Street and Oil Row. A hooded chestnut-seller with a brazier."}
  - {id: oil_row, description: "5 m side row: tallow-chandler, Hanka's oil stall, lard vats, pitch boiler. Grease casks staged under three stalls."}
  - {id: harvest_green, description: "Open green: hay-bale stage, maypole, cattle pens on the east edge."}
  - {id: granary, description: "9 m timber granary on the green's north side. Loft, inside ladder, flat roof ridge: the crossbow nest."}
  - {id: church_lane, description: "Lane south past the chapel of St. Corwen to the river."}
  - {id: ford, description: "River ford, end of the escape route."}
spawns:
  - {id: kings_road, area: kings_road, default: true}
  - {id: oil_smoke, area: oil_row, default: false}
  - {id: granary_roof, area: granary, default: false}
  - {id: chestnut, area: chestnut_corner, default: false}
  - {id: green_crowd, area: harvest_green, default: false}
exits:
  - id: road_back
    area: kings_road
    to_zone: zone.cintra_streets
    to_spawn: lion_gate
    condition: "ms(ms.act1_complete)"
    effects: []
interactables:
  - id: grease_casks
    area: oil_row
    kind: search
    label: "Look under the stalls"
    condition: "not flag(flag.procession_started) and not flag(flag.grease_found)"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["set_flag(flag.grease_found)", "play_beat(casks_found)"]
    fail_effects: ["play_beat(casks_missed)"]
  - id: hanka_stall
    area: oil_row
    kind: search
    label: "Talk to the oil-seller"
    condition: "not flag(flag.procession_started)"
    check: null
    once: false
    effects: ["start_dialogue(dlg.hanka)"]
  - id: chestnut_seller
    area: chestnut_corner
    kind: search
    label: "Buy chestnuts"
    condition: "not flag(flag.procession_started) and not flag(flag.wren_unmasked)"
    check: null
    once: false
    effects: ["start_dialogue(dlg.wren_chestnuts)"]
  - id: start_bell
    area: kings_road
    kind: lever
    label: "Tell Kosk you're ready (start the procession)"
    condition: "flag(flag.fair_briefed) and not flag(flag.procession_started)"
    check: null
    once: true
    effects: ["set_flag(flag.procession_started)", "set_checkpoint(procession)", "play_beat(procession_moves)"]
  - id: fair_stall_loot
    area: ribbon_street
    kind: container
    label: "An abandoned stall"
    condition: "flag(flag.fair_fight_over)"
    check: null
    once: true
    effects: []
triggers:
  - id: t_fair_arrive
    area: kings_road
    "on": enter
    source: null
    condition: "not flag(flag.fair_briefed)"
    once: true
    effects: ["set_checkpoint(fair_arrival)", "play_beat(fair_sights)", "start_dialogue(dlg.kosk_fair_briefing)"]
  - id: t_strike_full
    area: chestnut_corner
    "on": enter
    source: null
    condition: "flag(flag.procession_started) and not flag(flag.fair_strike_begun) and not flag(flag.wren_unmasked) and not flag(flag.fair_roof_watch)"
    once: true
    effects: ["set_flag(flag.fair_strike_begun)", "set_checkpoint(the_strike)", "play_beat(wren_signal)", "start_encounter(enc.fair_strike)"]
  - id: t_strike_watched
    area: chestnut_corner
    "on": enter
    source: null
    condition: "flag(flag.procession_started) and not flag(flag.fair_strike_begun) and not flag(flag.wren_unmasked) and flag(flag.fair_roof_watch)"
    once: true
    effects: ["set_flag(flag.fair_strike_begun)", "set_checkpoint(the_strike)", "play_beat(wren_signal)", "start_encounter(enc.fair_strike_watched)"]
  - id: t_fire
    area: chestnut_corner
    "on": beat_done
    source: wren_signal
    condition: "not flag(flag.grease_found)"
    once: true
    effects: ["play_beat(grease_fire)"]
  - id: t_fizzle
    area: chestnut_corner
    "on": beat_done
    source: wren_signal
    condition: "flag(flag.grease_found)"
    once: true
    effects: ["play_beat(grease_fizzles)"]
  - id: t_pony_bolts
    area: chestnut_corner
    "on": beat_done
    source: grease_fire
    condition: "not flag(flag.aldric_close_guard)"
    once: true
    effects: ["play_beat(aldric_thrown)"]
hazards:
  - {id: grease_fire, area: oil_row, kind: fire, enabled_by: {"on": beat_done, source: grease_fire}, params: {damage_per_second: 6, spreads_to: [chestnut_corner], duration_s: 90, applies_status: burning}}
  - {id: stampede, area: harvest_green, kind: trap, enabled_by: {"on": beat_done, source: grease_fire}, params: {effect: stampede, delay_s: 20, damage: 25, knockdown: true, telegraph: bellowing_2s, repeats_every_s: 30}}
  - {id: lard_vats, area: oil_row, kind: fire, enabled_by: {"on": beat_done, source: grease_fire}, params: {damage_per_second: 10, radius_m: 1.0, applies_status: burning}}
checkpoints:
  - {id: fair_arrival, area: kings_road}
  - {id: procession, area: ribbon_street}
  - {id: the_strike, area: chestnut_corner}
beats:
  - {id: fair_sights, description: "Bunting, bagpipes, the smell of roast pork and burnt sugar. A bear-ward, a puppet Corvan slaying a puppet dragon. The crowd cheers when it sees the royal grey pony. Aldric sits very straight."}
  - {id: casks_found, description: "Under the chandler's counter, the oil-seller's and the pie-man's: squat casks of rendered grease with their bungs knocked loose, a trail of grease soaked into the straw between them. Brask's riders roll them out into the street."}
  - {id: casks_missed, description: "Straw, crates, dropped coins, a sleeping dog. Nothing Hale can see."}
  - {id: procession_moves, description: "A horn. Aldric's pony steps off under the wheat arch, Hale at his stirrup, Brask and four riders behind. The crowd presses close, cheering, reaching to touch the boy's boots."}
  - {id: wren_signal, description: "At the junction, the chestnut-seller stands, pulls back his hood, and hurls his brazier into Oil Row."}
  - {id: grease_fire, description: "Oil Row goes up with a roar. A wall of fire and black smoke across the junction. The crowd screams and stampedes. Out of the smoke come hooded figures with blackened blades."}
  - {id: grease_fizzles, description: "The brazier lands in wet straw where the grease casks used to be. A puff of smoke, a hiss. Hooded figures come out of the crowd anyway, but the street is clear and Brask is already shouting."}
  - {id: aldric_thrown, description: "Aldric's pony shies from the fire and throws him. The boy hits the cobbles by the chandler's stall and lies stunned: Aldric is downed. Revive him (hold Interact) within 20 seconds."}
  - {id: crossbows_fire, description: "Bolts thud into the stage and the cobbles from the granary roof. Two crossbowmen in grey on the ridge."}
  - {id: roof_watch_holds, description: "Kosk's own crossbowmen on the granary roof shout and loose at something in the loft below them. Whatever was up there doesn't come out."}
  - {id: wren_flees, description: "The Wren breaks off, vanishes into a puff of smoke, and reappears running down Church Lane toward the ford."}
  - {id: wren_cornered, description: "At the ford, Kosk's riders come round through the shallows and cut the Wren off. He turns at bay, knee-deep in the river."}
  - {id: wren_down, description: "The Wren goes down on one knee in the mud, knife gone, hood torn back: a thin, pale young man with a monk's tonsure growing out."}
  - {id: fair_quiet, description: "Smoke drifting. Cattle loose on the green. A puppet Corvan lying in the gutter. Brask helping Aldric to his feet; his doublet is singed and his hands are shaking."}
npcs:
  - {npc: npc.kosk, area: kings_road, condition: "not flag(flag.procession_started)"}
  - {npc: npc.kosk, area: harvest_green, condition: "flag(flag.procession_started)"}
  - {npc: npc.aldric, area: kings_road, condition: "true"}
  - {npc: npc.sergeant_brask, area: kings_road, condition: "true"}
  - {npc: npc.wren, area: chestnut_corner, condition: "not flag(flag.fair_strike_begun) and not flag(flag.wren_unmasked)"}
  - {npc: npc.hanka, area: oil_row, condition: "not flag(flag.fair_strike_begun)"}
  - {npc: npc.reeve_matthis, area: harvest_green, condition: "true"}
encounters: [enc.fair_strike, enc.fair_strike_watched, enc.fair_wren_early]
loot:
  - {container: fair_stall_loot, items: [{item: item.antitoxin, count: 1}, {item: item.fire_oil, count: 1}], condition: "true"}
variants:
  - id: after_fair
    when: "ms(ms.act1_complete)"
    description: "The fair is over. Burnt stalls on Oil Row, wheat sheaves trampled, Kosk's soldiers guarding the road. The townsfolk watch the Marshal's riders leave in silence."
    npcs_absent: [npc.wren, npc.hanka]
    encounters_disabled: [enc.fair_strike, enc.fair_strike_watched, enc.fair_wren_early]
    interactables_disabled: [grease_casks, hanka_stall, chestnut_seller, start_bell]
```

## 4. NPCs present

**Voice notes.**
- **The Wren**: a novice of St. Corwen turned killer, twenty, soft-spoken, educated, utterly calm. Speaks like a seminarian reciting. Uses "brother" for everyone.
- **Hanka**: the oil-seller, loud and practical, terrified after the fire.
- **Reeve Matthis**: the town's fat, proud reeve, out of his depth.
- **Aldric** at the fair: performing courage for the crowd, then, after the attack, a frightened child for one scene, then a prince again.

```yaml npc
id: npc.wren
name: "The Wren"
faction: faction.choir
role: "Pale Choir assassin, ringleader of the Fair attack"
motive: "To kill the heir in public, in fire, so the realm sees the old order burn. Or, failing that, to die well."
secret: "A former novice of St. Corwen. Carries a pale gull feather in his collar and a route map to Hanged Man's Oak, the Choir's dead-drop, where he was to report."
disposition: hostile
essential: false
dialogue: dlg.wren_chestnuts
barks: ["Chestnuts! Hot chestnuts, brother!", "The fire is honest, brother.", "For the dead of Marnadal.", "Sing, brothers."]
combat: enemy.choir_assassin
shop: null
```

```yaml npc
id: npc.hanka
name: "Hanka, oil-seller"
faction: null
role: "Oil and tallow seller at the fair"
motive: "Sell lamp oil and get home before dark."
secret: "A quiet young man paid her a silver mark this morning to 'store a cask or two' under her counter. She thought it was for the pie-men."
disposition: friendly
essential: true
dialogue: dlg.hanka
barks: ["Lamp oil! Clean-burning lamp oil!", "Mind your sleeves by the vats!", "My stall! My stall!"]
combat: null
shop: {stock: [{item: item.fire_oil, count: 4}], price_mod: 0.9}
```

```yaml npc
id: npc.reeve_matthis
name: "Reeve Matthis of Chociebuż"
faction: faction.crown
role: "Reeve of Chociebuż, master of the Harvest Fair"
motive: "A perfect fair with a prince in it, to be talked about for twenty years."
secret: null
disposition: friendly
essential: true
dialogue: null
barks: ["Your Highness! Your Highness, this way!", "The harvest crown, Your Highness, if you would...", "Fire! Fire! Water, you idiots!"]
combat: null
shop: null
```

## 5. Dialogue trees

### 5.1 Kosk announces the Fair (war room)

```yaml dialogue
id: dlg.kosk_fair_announce
participants: [npc.kosk, npc.aldric]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "flag(flag.fair_announced)", next: again}
    else: open
  open:
    type: line
    speaker: npc.kosk
    text: "Sit down. The boy has decided to ride through the Harvest Fair at Chociebuż tomorrow. Show the realm its heir is strong, while its Queen... isn't. Her Majesty agreed. I didn't."
    effects: ["set_flag(flag.fair_announced)"]
    next: aldric_in
  aldric_in:
    type: line
    speaker: npc.aldric
    text: "Because I'm not porcelain. If I hide in the tower, every lord in Cintra will think she's already dead and I'm already nothing. I'm riding. You can come, or you can watch from a window."
    direction: "He has come in without knocking. Kosk doesn't stop him."
    next: hub
  again:
    type: line
    speaker: npc.kosk
    text: "Well? The boy's been in his riding boots since dawn."
    next: hub
  hub:
    type: choice
    options:
      - id: ready
        text: "I'll ride at his stirrup."
        next: confirm
      - id: dissuade
        text: "Highness, someone's poisoning your mother. A fair is a crowd of strangers with knives. Stay home. [Persuade 8]"
        tag: persuade
        condition: "not flag(flag.fair_dissuade_tried)"
        check: {skill: persuade, dc: 8, pass: dissuade_pass, fail: dissuade_fail}
        once: true
      - id: not_yet
        text: "Not yet. There are things I need to finish first."
        next: not_yet
  dissuade_pass:
    type: line
    speaker: npc.aldric
    text: "...You're right. You're right, and I'm still going, because if I'm afraid now I'll be afraid forever. But I'll wear a mail shirt under the doublet, and I'll keep you close. Is that fair?"
    effects: ["set_flag(flag.fair_dissuade_tried)", "set_flag(flag.aldric_close_guard)", "add_var(var.aldric_bond, 1)"]
    next: hub
  dissuade_fail:
    type: line
    speaker: npc.aldric
    text: "You sound like Varn. I'm going."
    effects: ["set_flag(flag.fair_dissuade_tried)"]
    next: hub
  not_yet:
    type: line
    speaker: npc.kosk
    text: "Then be quick. He goes with or without you, and I'd rather it was with."
    next: bye
  confirm:
    type: line
    speaker: npc.kosk
    text: "Good. Once we ride, there's no coming back to the leads you've left loose; I'll need every man on the boy. Be certain."
    direction: "UI: point-of-no-return confirmation (gdd §7.1): 'Starting the Fair closes unfinished Act I leads (Sickroom, Abbey, Ring of Nine). Gull Tower stays open.'"
    next: confirm_hub
  confirm_hub:
    type: choice
    options:
      - id: go
        text: "I'm certain. We ride."
        effects: ["set_flag(flag.fair_started)", "unlock_map_node(map.chociebuz)"]
        next: go
      - id: wait
        text: "Give me a little longer."
        next: not_yet
  go:
    type: effect
    effects: ["goto_zone(zone.chociebuz_fair, kings_road)"]
    next: bye
  bye:
    type: end
```

### 5.2 Kosk's briefing at the gate

```yaml dialogue
id: dlg.kosk_fair_briefing
participants: [npc.kosk, npc.sergeant_brask]
start: open
nodes:
  open:
    type: line
    speaker: npc.kosk
    text: "Ribbon Street to the green. He gives the reeve's harvest crown to some farmer's girl, he waves, we leave. Brask and four riders behind him, you beside him. I'll be at the stage. Questions?"
    effects: ["set_flag(flag.fair_briefed)"]
    next: hub
  hub:
    type: choice
    options:
      - id: roof
        text: "That granary overlooks the whole green. Put your crossbowmen on the roof."
        condition: "rep_tier(faction.crown) >= friendly and not flag(flag.fair_roof_watch)"
        effects: ["set_flag(flag.fair_roof_watch)"]
        next: roof
      - id: roof_persuade
        text: "Spare me two crossbowmen for the granary roof. Humor me. [Persuade 6]"
        tag: persuade
        condition: "rep_tier(faction.crown) < friendly and not flag(flag.fair_roof_watch)"
        check: {skill: persuade, dc: 6, pass: roof, fail: roof_fail}
        once: true
      - id: look
        text: "Give me time to walk the route before he rides."
        next: look
      - id: feather
        text: "Watch for anyone with a pale feather in their collar. That's how they know each other. [Clue: Pale feather]"
        tag: clue
        condition: "has_clue(clue.pale_feather)"
        next: feather
      - id: ready
        text: "No questions."
        next: ready
  roof:
    type: line
    speaker: npc.kosk
    text: "Done. Brask, two bows on the granary. Now."
    effects: ["set_flag(flag.fair_roof_watch)"]
    next: hub
  roof_fail:
    type: line
    speaker: npc.kosk
    text: "I've no men to waste guarding hay. They stay with the boy."
    next: hub
  look:
    type: line
    speaker: npc.kosk
    text: "Walk it. Quickly. When you're done, tell me at the arch and we'll sound the horn."
    next: bye
  feather:
    type: line
    speaker: npc.sergeant_brask
    text: "Feathers. Right. I'll pass it down the line. If one of my lads sees a goose-plume he'll knock its owner flat. Possibly correctly."
    next: hub
  ready:
    type: line
    speaker: npc.kosk
    text: "Then tell me when. Not before you're ready; after that it's too late."
    next: bye
  bye:
    type: end
```

### 5.3 The chestnut-seller (spotting the Wren)

```yaml dialogue
id: dlg.wren_chestnuts
participants: [npc.wren, npc.sergeant_brask]
start: open
nodes:
  open:
    type: line
    speaker: npc.wren
    text: "Chestnuts, brother? Hot and sweet. A copper a twist. The Prince will pass right by here; best view in the fair."
    direction: "Hood up, eyes on the gate arch, not on his chestnuts. His hands are very clean for a chestnut-seller."
    next: hub
  hub:
    type: choice
    options:
      - id: buy
        text: "A twist, then. [Bribe 1]"
        tag: bribe
        bribe: 1
        next: buy
      - id: look
        text: "Look at him properly. [Investigate 6]"
        tag: investigate
        check: {skill: investigate, dc: 6, pass: spotted, fail: missed}
        once: true
      - id: feather
        text: "Nice collar, brother. Is that a feather? [Clue: Pale feather]"
        tag: clue
        condition: "has_clue(clue.pale_feather)"
        next: spotted
      - id: walk
        text: "Not hungry."
        next: bye
  buy:
    type: line
    speaker: npc.wren
    text: "God keep you, brother. Mind the fire."
    next: bye
  missed:
    type: line
    speaker: npc.wren
    text: "Something wrong, brother? Only chestnuts."
    next: bye
  spotted:
    type: line
    speaker: player
    text: "A seminarian's hands, no burns from the brazier. A ring of pale feather down at the collar. And grease on his sleeve, the same grease as Oil Row."
    next: spotted_hub
  spotted_hub:
    type: choice
    options:
      - id: take
        text: "You're no chestnut-seller. Hands where I can see them."
        effects: ["set_flag(flag.wren_unmasked)", "set_flag(flag.fair_strike_begun)", "set_checkpoint(the_strike)"]
        next: unmasked
      - id: wait
        text: "Walk away and tell Brask to watch him."
        effects: ["set_flag(flag.wren_watched)"]
        next: watched
  unmasked:
    type: line
    speaker: npc.wren
    text: "Ah. Well, brother. The fire was meant to be honest. Steel will do."
    direction: "He kicks the brazier at Hale and draws two blackened knives. Two cutthroats come out of the crowd. The procession has not started; Aldric is safe behind Brask at the arch."
    effects: ["start_encounter(enc.fair_wren_early)"]
    next: bye
  watched:
    type: line
    speaker: npc.sergeant_brask
    text: "That one? Right. I'll have a man stand behind him with a cudgel. If he so much as sneezes, he'll wake up in Cintra."
    direction: "With the Wren watched, his signal comes late: the procession can pass the junction before the strike (the strike still happens, but Aldric's pony does not bolt)."
    effects: ["set_flag(flag.aldric_close_guard)"]
    next: bye
  bye:
    type: end
```

### 5.4 Hanka the oil-seller

```yaml dialogue
id: dlg.hanka
participants: [npc.hanka]
start: open
nodes:
  open:
    type: line
    speaker: npc.hanka
    text: "Lamp oil, clean-burning! Or fire oil for your blade, if you're the sort. Which you look like."
    next: hub
  hub:
    type: choice
    options:
      - id: shop
        text: "Let me see the fire oil."
        effects: ["open_shop(npc.hanka)"]
        next: bye
      - id: casks
        text: "Anyone pay you to keep something under your counter?"
        next: casks
      - id: bye_opt
        text: "Just looking."
        next: bye
  casks:
    type: line
    speaker: npc.hanka
    text: "Well, yes, a quiet young fellow, this morning. A silver mark for a cask or two under the counter. For the pie-men, he said. Why? ...Why are you looking at my counter like that?"
    effects: ["set_flag(flag.hanka_told)"]
    next: bye
  bye:
    type: end
```

The `grease_casks` search (Investigate 4) is easier to find after Hanka's hint: the level builder adds a glint to the casks when `flag.hanka_told` is set (presentation; the check stays Investigate 4). Hanka's hint does not bypass the check; the second route without a check is `dlg.wren_chestnuts` (unmasking the Wren before the signal means the fire never starts).

### 5.5 The Wren, beaten

```yaml dialogue
id: dlg.wren_downed
participants: [npc.wren, npc.kosk]
start: open
nodes:
  open:
    type: line
    speaker: npc.wren
    text: "Finish it, brother. The Choir sings for the dead kings. Soon it will sing for the living. I am only a note in the song."
    direction: "On one knee in the mud, hood torn back, a novice's tonsure half grown out."
    effects: ["give_item(item.pale_feather, 1)", "give_item(item.route_map_oak, 1)", "add_clue(clue.pale_feather)", "add_clue(clue.route_map_oak)", "add_map_pin(map.hanged_mans_oak)"]
    next: search_line
  search_line:
    type: line
    speaker: player
    text: "In his collar, a pale gull feather. In his satchel, a map: the King's Road south, the Marnadal valley, and an X under an oak marked 'H.M.O.'"
    next: hub
  hub:
    type: choice
    options:
      - id: who
        text: "Who sings the song? [Intimidate 6]"
        tag: intimidate
        check: {skill: intimidate, dc: 6, pass: who_pass, fail: who_fail}
        once: true
      - id: abbey
        text: "You're a novice. From St. Corwen. [Clue: The untasted communion wine]"
        tag: clue
        condition: "has_clue(clue.communion_wine) or has_clue(clue.only_anselm_key)"
        next: abbey
      - id: capture
        text: "You'll sing for the Marshal."
        effects: ["set_flag(flag.fair_assassin_captured)", "add_rep(faction.crown, 5)"]
        next: capture
      - id: kill
        text: "Then here's your last note."
        effects: ["set_flag(flag.fair_assassin_killed)"]
        next: kill
  who_pass:
    type: line
    speaker: npc.wren
    text: "You'll find the hymn-book under the hanging tree, brother, and you'll read it too late. The bells have already rung."
    next: hub
  who_fail:
    type: line
    speaker: npc.wren
    text: "Pain is a prayer. Pray harder."
    next: hub
  abbey:
    type: line
    speaker: npc.wren
    text: "I was. I was a novice of St. Corwen until I saw what the lords did at Marnadal. Ask your Abbot what he saw. No. Don't. He'd only bless you."
    direction: "He smiles. It is the most unsettling thing he does."
    next: hub
  capture:
    type: line
    speaker: npc.kosk
    text: "Chain him. Hands and mouth. If he has poison in a tooth, I want it out before he's on the horse."
    direction: "Kosk's riders drag the Wren up."
    next: to_aldric
  kill:
    type: line
    speaker: npc.kosk
    text: "Done is done. A shame. Dead men tell the gallows nothing."
    next: to_aldric
  to_aldric:
    type: effect
    effects: ["start_dialogue(dlg.aldric_after_fair)"]
    next: bye
  bye:
    type: end
```

### 5.6 Aldric after the Fair (Aldric scene 3)

```yaml dialogue
id: dlg.aldric_after_fair
participants: [npc.aldric, npc.kosk]
start: open
nodes:
  open:
    type: line
    speaker: npc.aldric
    text: "I'm all right. I'm all right. I'm... it was so loud. Everyone was screaming. I couldn't find my sword. I didn't even have my sword."
    direction: "Sitting on a hay bale by the burnt stage, singed doublet, hands shaking. Brask has stepped back to give them a moment."
    next: hub
  hub:
    type: choice
    options:
      - id: brave
        text: "You were brave. You stayed on your feet when it mattered."
        effects: ["add_var(var.aldric_bond, 1)"]
        next: brave
      - id: truth
        text: "You were scared. So was I. That's what it's like. Nobody tells you that part."
        effects: ["add_var(var.aldric_bond, 2)"]
        next: truth
      - id: duty
        text: "You're alive, Highness. That was my job."
        next: duty
  brave:
    type: line
    speaker: npc.aldric
    text: "I wasn't. But thank you for saying it in front of Brask."
    next: token_check
  truth:
    type: line
    speaker: npc.aldric
    text: "You were scared? ...Good. I mean, not good. But good. I thought it was only me."
    next: token_check
  duty:
    type: line
    speaker: npc.aldric
    text: "Your job. Yes. I suppose it was."
    next: token_check
  token_check:
    type: branch
    cases:
      - {if: "var(var.aldric_bond) >= 2", next: token}
    else: no_token
  token:
    type: line
    speaker: npc.aldric
    text: "Here. It's stupid. My father carved it. A lion with no tail, like the fountain. Keep it. So that when you're gone you remember someone here is waiting for you to come back."
    direction: "He presses a small, worn wooden lion into Hale's hand."
    effects: ["give_item(item.aldric_lion, 1)"]
    next: trust_check
  no_token:
    type: line
    speaker: npc.aldric
    text: "Kosk will send you away now, won't he? Everyone gets sent away."
    next: trust_check
  trust_check:
    type: branch
    cases:
      - {if: "var(var.aldric_bond) >= 3", next: trusted}
    else: kosk_comes
  trusted:
    type: line
    speaker: npc.aldric
    text: "I trust you. I don't trust anybody. Not Varn, not the guards. Not even Father Anselm, all the way. But you came when it mattered. I'll remember."
    effects: ["set_flag(flag.aldric_trusts_player)"]
    next: kosk_comes
  kosk_comes:
    type: line
    speaker: npc.kosk
    text: "Highness, the horses. Sellsword, you ride back with me. We have a great deal to talk about, and none of it here."
    effects: ["play_beat(fair_quiet)", "reach_milestone(ms.act1_complete)"]
    next: chain
  chain:
    type: effect
    effects: ["goto_zone(zone.palace_hall, war_room)", "start_dialogue(dlg.kosk_orders_south)"]
    next: bye
  bye:
    type: end
```

## 6. Encounters

The strike is an **escort fight**: `ally.aldric` (HP 200) is on the field. If he is downed, Hale has 20 s to revive him (hold Interact 2 s); if he dies, `game_over(escort_aldric)` and reload `the_strike` (gdd §6.13, §6.18). Aldric is downed at the start only if his pony bolts (`aldric_thrown`, skipped with `flag.aldric_close_guard`). Assassins prefer Aldric as a target; attack tokens apply to the player only.

| Encounter | Wave 1 | Wave 2 (after wave_cleared) | When |
|---|---|---|---|
| `enc.fair_strike` | 2 assassins + 2 cutthroats from the smoke | the Wren + 1 cutthroat at the junction, 2 crossbowmen on the granary roof | Default |
| `enc.fair_strike_watched` | same | the Wren + 1 cutthroat (roof held by Kosk's bows) | `flag.fair_roof_watch` |
| `enc.fair_wren_early` | the Wren + 2 cutthroats at the chestnut corner | 2 assassins out of the crowd | The Wren unmasked before the procession; no fire, Aldric behind Brask at the arch |

```yaml encounter
id: enc.fair_strike
zone: zone.chociebuz_fair
target_priority: [ally.aldric]
enemies:
  - {enemy: enemy.choir_assassin, count: 2, spawn: oil_smoke, variant: null}
  - {enemy: enemy.choir_cutthroat, count: 2, spawn: oil_smoke, variant: null}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.choir_assassin, count: 1, spawn: chestnut, variant: wren}, {enemy: enemy.choir_cutthroat, count: 1, spawn: chestnut, variant: null}, {enemy: enemy.choir_crossbowman, count: 2, spawn: granary_roof, variant: null}]}
attack_tokens: null
allow_yield: true
allies: [ally.aldric, npc.sergeant_brask]
checkpoint: the_strike
avoidable_by: []
on_won: ["set_flag(flag.fair_fight_over)", "play_beat(wren_down)", "start_dialogue(dlg.wren_downed)"]
on_yielded: ["set_flag(flag.fair_fight_over)", "play_beat(wren_down)", "start_dialogue(dlg.wren_downed)"]
on_player_fled: []
escorts:
  - {ally: ally.aldric, game_over: escort_aldric}
```

```yaml encounter
id: enc.fair_strike_watched
zone: zone.chociebuz_fair
target_priority: [ally.aldric]
enemies:
  - {enemy: enemy.choir_assassin, count: 2, spawn: oil_smoke, variant: null}
  - {enemy: enemy.choir_cutthroat, count: 2, spawn: oil_smoke, variant: null}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.choir_assassin, count: 1, spawn: chestnut, variant: wren}, {enemy: enemy.choir_cutthroat, count: 1, spawn: chestnut, variant: null}]}
attack_tokens: null
allow_yield: true
allies: [ally.aldric, npc.sergeant_brask]
checkpoint: the_strike
avoidable_by: []
on_won: ["set_flag(flag.fair_fight_over)", "play_beat(roof_watch_holds)", "play_beat(wren_down)", "start_dialogue(dlg.wren_downed)"]
on_yielded: ["set_flag(flag.fair_fight_over)", "play_beat(wren_down)", "start_dialogue(dlg.wren_downed)"]
on_player_fled: []
escorts:
  - {ally: ally.aldric, game_over: escort_aldric}
```

```yaml encounter
id: enc.fair_wren_early
zone: zone.chociebuz_fair
target_priority: [ally.aldric]
enemies:
  - {enemy: enemy.choir_assassin, count: 1, spawn: chestnut, variant: wren, downed_at_zero: true}
  - {enemy: enemy.choir_cutthroat, count: 2, spawn: chestnut, variant: null}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.choir_assassin, count: 2, spawn: green_crowd, variant: null}]}
attack_tokens: null
allow_yield: true
allies: [ally.aldric, npc.sergeant_brask]
checkpoint: the_strike
avoidable_by: ["dlg.wren_chestnuts"]
on_won: ["set_flag(flag.fair_fight_over)", "play_beat(wren_down)", "start_dialogue(dlg.wren_downed)"]
on_yielded: ["set_flag(flag.fair_fight_over)", "play_beat(wren_down)", "start_dialogue(dlg.wren_downed)"]
on_player_fled: []
escorts:
  - {ally: ally.aldric, game_over: escort_aldric}
```

**The `wren` variant** of `enemy.choir_assassin`: the ringleader. Same stat block with +30% HP. He is **never killed outright** by the encounter: at 0 HP he drops to one knee (`wren_down`) so that the capture-or-kill choice is a dialogue (gdd says assassins have no `can_yield`; this variant overrides it to a scripted "downed" state). Below 30% HP he uses smoke vanish and runs down Church Lane (`wren_flees`) to the ford, where Kosk's riders corner him (`wren_cornered`); the fight finishes there.

**Tactics notes.** Grease fire: the Oil Row and junction burn for 90 s (dodge-roll puts out Burning). Crossbowmen on the granary: climb the inside ladder to reach them, shoot them (35 HP, 2 bolts), or use the stage and stalls as cover. Cattle stampede on the green 20 s after the fire, telegraphed by bellowing. Assassins smoke-vanish and backstab: keep Aldric at your back against a wall. Antitoxin cures their poison. Sergeant Brask is a scripted ally (she shields Aldric; she cannot die).

**Non-combat alternatives.** None that avoid the strike: the Choir commits to it. Preparation shrinks it: casks found (no fire, no bolting pony, no stampede), roof watch (no crossbowmen), Wren unmasked (the fight happens early at the arch with the prince behind guards, and wave 2 is smaller), Wren watched or Aldric dissuaded (Aldric stays close, pony doesn't bolt).

## 7. Items and clues

```yaml item
id: item.pale_feather
name: "Pale gull feather"
category: key
description: "A pale gull feather, the kind stitched into a collar or boot lining by members of the Pale Choir. Taken from the Wren's collar. Part of a Choir disguise (with a Choir robe)."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.route_map_oak
name: "Route map to Hanged Man's Oak"
category: document
description: "A hand-drawn map from the Wren's satchel: the King's Road south into the Marnadal valley, and an X under a lone oak marked 'H.M.O.'"
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "South by the King's Road past Tigg. Left at the crooked crossroads. Follow the dry ditch to the lone oak where the hanged man was. H.M.O. Report there. The trunk is hollow. Leave nothing in your own hand. Sing."
```

```yaml item
id: item.aldric_lion
name: "Aldric's wooden lion"
category: trinket
description: "A small wooden lion, worn smooth by a child's hands, its tail broken off like the fountain's. Carved by the late King for his son. Aldric gave it to you after the Fair."
price: 0
stack_max: 1
equip_slot: trinket
weapon: null
armor: null
trinket: {mods: []}
consumable: null
readable_text: null
```

```yaml clue
id: clue.pale_feather
theory: theory.choir
title: "The pale feather"
text: "Members of the Pale Choir mark themselves with a pale gull feather sewn into a collar, cowl hem or boot lining. Pell had one. The Wren had one. Who else?"
supports: []
refutes: []
```

```yaml clue
id: clue.route_map_oak
theory: theory.choir
title: "A map to Hanged Man's Oak"
text: "The Fair assassin carried a map to Hanged Man's Oak in the Marnadal valley, south of Tigg: a hollow oak where the Choir's agents report."
supports: []
refutes: []
```

```yaml deduction
id: ded.choir_exists
theory: theory.choir
condition: "has_clue(clue.pale_feather) and has_clue(clue.route_map_oak)"
title: "The Pale Choir is real"
text: "A sworn brotherhood marked by pale feathers, with agents in the palace kitchens and the Abbey's shadow, assassins at the Fair, and a dead-drop at Hanged Man's Oak. The Choir sings for the dead kings."
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.act1_complete, type: milestone, xp: 250, desc: "Act I complete: Aldric saved at the Fair, the Choir's trail found. Escalation stage 1."}
  - {id: flag.fair_announced, type: bool, desc: "Kosk has announced the Fair ride."}
  - {id: flag.fair_started, type: bool, desc: "The player accepted the ride: point of no return for Act I leads 3-5."}
  - {id: flag.fair_dissuade_tried, type: bool, desc: "The player tried to talk Aldric out of riding."}
  - {id: flag.aldric_close_guard, type: bool, desc: "Aldric rides close to Hale (dissuaded, or the Wren watched): his pony does not bolt."}
  - {id: flag.fair_briefed, type: bool, desc: "Kosk's briefing at the gate has played."}
  - {id: flag.fair_roof_watch, type: bool, desc: "Kosk's crossbowmen hold the granary roof."}
  - {id: flag.grease_found, type: bool, desc: "The grease casks were found and removed (no fire)."}
  - {id: flag.hanka_told, type: bool, desc: "Hanka admitted a stranger paid her to store casks."}
  - {id: flag.wren_unmasked, type: bool, desc: "The player unmasked the Wren before the procession."}
  - {id: flag.wren_watched, type: bool, desc: "Brask's man is watching the Wren."}
  - {id: flag.procession_started, type: bool, desc: "The procession has begun."}
  - {id: flag.fair_strike_begun, type: bool, desc: "The Choir's strike has begun."}
  - {id: flag.fair_fight_over, type: bool, desc: "The Fair fight is over."}
  - {id: flag.fair_assassin_captured, type: bool, desc: "The Wren was captured alive for Kosk."}
  - {id: flag.fair_assassin_killed, type: bool, desc: "The Wren was killed."}
  - {id: flag.aldric_trusts_player, type: bool, desc: "Aldric trusts the player personally (var.aldric_bond >= 3 at the Fair). For the Act II twist and Act III finale."}
reads:
  - ms.a1_audience_done
  - ms.a1_sickroom_done
  - ms.a1_abbey_done
  - ms.a1_ring_done
  - var.aldric_bond
```

## 9. Quest hooks

```yaml quest_stages
quest: quest.main_a1
order: 50
stages:
  - id: the_fair
    journal: "Prince Aldric insists on riding through the Harvest Fair at Chociebuż. Kosk wants me at the boy's stirrup. If the Choir wants to strike at the heir, they could not ask for a better place."
    objectives:
      - {id: ride, text: "Ride with the Prince to the Harvest Fair", condition: "flag(flag.procession_started)", optional: false}
      - {id: prepare, text: "Find the danger before it finds the Prince", condition: "flag(flag.grease_found) or flag(flag.fair_roof_watch) or flag(flag.wren_unmasked)", optional: true, xp: 40}
      - {id: protect, text: "Keep Prince Aldric alive", condition: "flag(flag.fair_fight_over)", optional: false}
      - {id: ringleader, text: "Deal with the ringleader", condition: "flag(flag.fair_assassin_captured) or flag(flag.fair_assassin_killed)", optional: false}
    on_complete: []
    next: []
```

Milestone XP for `ms.act1_complete` (250) is paid by `add_xp(250)` beside the milestone in `dlg.aldric_after_fair`.

## 10. Rumors and event cards (optional)

None.

## 11. Failure states and branches

```yaml branches
paths:
  - id: full_strike
    when: "No preparation."
    outcome: "Fire, bolting pony (Aldric downed at start), two waves including granary crossbowmen, stampede."
    sets: ["set_flag(flag.fair_fight_over)"]
  - id: prepared_strike
    when: "Any of: casks found, roof watch, Aldric close guard."
    outcome: "Smaller or safer strike (no fire / no crossbowmen / Aldric not thrown)."
    sets: ["set_flag(flag.fair_fight_over)"]
  - id: early_strike
    when: "Wren unmasked at the chestnut corner before the procession."
    outcome: "enc.fair_wren_early with Aldric behind the guards; no fire."
    sets: ["set_flag(flag.wren_unmasked)", "set_flag(flag.fair_fight_over)"]
  - id: capture_or_kill
    when: "The Wren is downed."
    outcome: "Feather, route map, ded.choir_exists, Hanged Man's Oak pin. Captured or killed (flag)."
    sets: ["set_flag(flag.fair_assassin_captured)"]
  - id: aldric_scene
    when: "After the fight."
    outcome: "Bond +0..2; the wooden lion at bond >= 2; flag.aldric_trusts_player at bond >= 3; ms.act1_complete; transition to section 8."
    sets: ["reach_milestone(ms.act1_complete)"]
failures:
  - id: aldric_dies
    result: game_over
    recover: "game_over(escort_aldric): reload the_strike (gdd §6.18)."
  - id: player_dies
    result: reload_checkpoint
    recover: "Reload the_strike (or fair_arrival before the procession)."
  - id: declined_ride
    result: soft_fail
    recover: "Declining in dlg.kosk_fair_announce keeps the leads open; dlg.kosk option fair_ready reopens the announcement."
guarantees:
  - "ms.act1_complete: the strike always ends with the Wren downed (scripted 'wren' variant), dlg.wren_downed always gives the feather and map, and dlg.aldric_after_fair has no checks on its path to the milestone. The only failure is escort death, which reloads."
  - "item.route_map_oak and item.pale_feather are given unconditionally on entering dlg.wren_downed."
```

## 12. Open questions

1. **Scripted downed state for the Wren (resolved by A08).** The `wren` entry has `downed_at_zero: true` (content-format §J.4).
2. **Escort game over (resolved by A08).** The Fair encounters list `escorts: [{ally: ally.aldric, game_over: escort_aldric}]` (§J.4).
3. **Assassin target priority (resolved by A08).** `target_priority: [ally.aldric]` (§J.4).
4. **Brask as an ally (resolved by A08).** `allies` accepts npc ids (§J.4).
