---
section_id: side.brzezina
title: "The Hunting Lodge at Brzezina"
act: 2
story_ref: "story.md §10 Brzezina Woods; §2 Sodden; §11 Lowlands d8 5"
zones: [zone.brzezina_woods, zone.brzezina_lodge]
available_when: "ms(ms.act1_complete) and (flag(flag.brzezina_hook) or rumor_heard(rumor.r18_brzezina_lodge))"
escalation_stage_required: {min: 1, max: 3}
milestones_set: []
milestones_read: [ms.act1_complete, ms.act2_twist]
level_band: [5, 8]
---

# The Hunting Lodge at Brzezina

## 1. Scene summary
Baron Oswin Hollec holds the birch woods and the three fords on Cintra's north-east border. Tonight he hosts a "hunt" at his lodge, and his guest of honour is a quiet woman in grey who drinks Sodden wine and never takes off her gloves: Ivena Drozd, spymaster of Sodden. Hollec lost two sons at Marnadal under Kosk's banner and never saw a crown of the war indemnity; Sodden has promised him a margravate if he opens his fords the morning Cintra's civil war begins. The player can come in as a hired guest, bribe a kitchen maid, creep along the ivy to the solar window and listen, or cut through the baron's retainers. With Hollec's letters in hand they decide: expose him to the Crown, squeeze him for silver, or end him. Drozd, whatever happens, slips away into the birches with a smile and a promise: she will remember the player's face. The dramatic question: when a lord betrays a Crown that betrayed him first, who exactly is the traitor?

## 2. Progress and escalation
- **Availability:** Act II (after `ms.act1_complete`), once the hook is known: `flag.brzezina_hook` (lowlands travel card 5, the Sodden tinker) or `rumor.r18_brzezina_lodge`. Escalation stage 1–3. Closes (abandoned) at `ms.act2_twist`.
- **Location:** map node `map.brzezina_woods` (lowlands; edge `cintra—brzezina_woods` opens on the quest hook, gdd §7.5). Zones `zone.brzezina_woods` (exterior, dusk) and `zone.brzezina_lodge` (interior).
- **Milestones:** none set. Reads `ms.act1_complete`, `ms.act2_twist`.
- **Escalation look:** stage 1, a hunt feast with Cintran banners. Stage 2, rain; the stream at the ford is swollen and grey with silt, and Drozd's boat is ready at the ford as well as her horses. Stage 3, Hollec no longer hides it: a Sodden green-and-black pennant hangs in the solar and the retainers wear Sodden boots; the retainer group gains one member (gdd §6.1, applied by the system).
- **Payoff wired:** `flag.brzezina_plot_exposed`: no Sodden flank in the epilogue (gdd §6.15). `flag.drozd_rival`: Drozd recurs (travel card, epilogue slide). `flag.hollec_blackmailed`: 150 crowns, plot still live unless exposed later.

## 3. Location layout
**The woods.** White birch on black peat, a cart track running north from the King's Road to the lodge clearing. The player arrives at the **gate post**, where Huntsman Garr checks guests.
- **Gate post:** a log barrier across the track, a brazier, two hounds on chains. Garr's post.
- **Birch stand:** dense birches west of the track: shadow, crouch lane, the stealth route around the lodge to the north side.
- **Kennels:** a long hut of baying hounds near the clearing's west edge. Noise: running past it raises suspicion faster (it counts as "full view" for the kennel boy).
- **Lodge clearing:** an open lawn before the lodge, lit by torches. Two retainers walk a loop.
- **Ivy wall:** the north face of the lodge, old ivy thick as rope up to the solar balcony window. Climbable; the window is the overhearing spot.
- **Kitchen yard:** east side: woodpile, a well, the kitchen door. Hanka works here.
- **The ford:** a hundred paces north, a stream crossing where Drozd's two Sodden escorts hold her horses (and a skiff at stage ≥ 2). Her escape route.

**The lodge.** A long timber hall on a stone undercroft.
- **Great hall:** antler chandelier, a long table with a dozen guests (minor gentry, two Sodden "wine merchants"), a hearth big enough to roast a stag (fire hazard), a minstrels' gallery on the south wall (cover, overlooks the table). Hollec presides; Castellan Brana stands behind his chair.
- **Kitchen:** low, smoky, hanging game; door to the kitchen yard; back stair to the solar.
- **Solar:** upstairs. Hollec's private room: a writing desk, an iron-bound strongbox (the letters), a map of the three fords on the wall, the balcony window to the ivy.
- **Gallery stair:** from the hall to the solar, guarded by one retainer during the meeting.
- **Cellar:** casks branded with Sodden's mark: wine bought at a loss, a cover for money moving.

Flow: the meeting between Hollec and Drozd happens in the solar first (overhear it from the ivy, or from the back stair). Then both go down to the feast. The letters stay in the solar strongbox. The confrontation happens at the high table.

```yaml zone
id: zone.brzezina_woods
name: "Brzezina Woods"
kind: exterior
map_node: map.brzezina_woods
time_of_day: dusk
cold_rate: 0
disguise_tag: null
music: birch_woods_tense
areas:
  - {id: gate_post, description: "Log barrier across the cart track; a brazier; two chained hounds. Garr's post."}
  - {id: birch_stand, description: "Dense white birch on black peat. Shadow and crouch lanes around the lodge."}
  - {id: kennels, description: "Long hut of baying hounds at the clearing's west edge."}
  - {id: lodge_clearing, description: "Torchlit lawn before the lodge. Two retainers walk a loop."}
  - {id: ivy_wall, description: "North face of the lodge; ivy thick as rope up to the solar balcony."}
  - {id: kitchen_yard, description: "Woodpile, well, kitchen door. Steam and the smell of venison."}
  - {id: the_ford, description: "Stream crossing north of the lodge. Drozd's horses, and a skiff at stage 2 or higher."}
spawns:
  - {id: track_in, area: gate_post, default: true}
  - {id: lodge_door, area: lodge_clearing}
  - {id: kitchen_out, area: kitchen_yard}
  - {id: ivy_foot, area: ivy_wall}
  - {id: ford_bank, area: the_ford}
exits:
  - id: front_door
    area: lodge_clearing
    to_zone: zone.brzezina_lodge
    to_spawn: hall_door
    condition: "flag(flag.lodge_guest) or flag(flag.brzezina_plot_exposed) or flag(flag.hollec_blackmailed) or flag(flag.hollec_dead)"
    effects: []
  - id: kitchen_door
    area: kitchen_yard
    to_zone: zone.brzezina_lodge
    to_spawn: kitchen_in
    condition: "true"
    effects: []
  - id: climb_ivy
    area: ivy_wall
    to_zone: zone.brzezina_lodge
    to_spawn: solar_window
    condition: "true"
    effects: []
interactables:
  - id: road_board
    area: gate_post
    kind: map_board
    label: "Back to the King's Road (travel)"
    condition: "true"
    check: null
    once: false
    effects: []
    fail_effects: []
  - id: solar_listen
    area: ivy_wall
    kind: readable
    label: "Listen at the solar window"
    condition: "not flag(flag.brzezina_plot_overheard) and not flag(flag.drozd_rival)"
    check: null
    once: true
    effects: ["play_beat(overheard_plot)", "set_flag(flag.brzezina_plot_overheard)"]
    fail_effects: []
  - id: cut_tethers
    area: the_ford
    kind: lever
    label: "Cut the Sodden horses loose"
    condition: "not flag(flag.drozd_rival)"
    check: null
    once: true
    effects: ["play_beat(horses_bolt)", "set_flag(flag.drozd_horses_cut)"]
    fail_effects: []
  - id: kennel_latch
    area: kennels
    kind: lever
    label: "Lift the kennel latch"
    condition: "true"
    check: null
    once: true
    effects: ["play_beat(hounds_loose)"]
    fail_effects: []
triggers:
  - id: arrive
    area: gate_post
    on: enter
    source: null
    condition: "not quest_active(quest.side_brzezina) and not quest_done(quest.side_brzezina) and not quest_failed(quest.side_brzezina)"
    once: true
    effects: ["start_quest(quest.side_brzezina)", "set_checkpoint(woods_arrival)"]
  - id: woods_alarm
    area: lodge_clearing
    on: beat_done
    source: alarm_raised
    condition: "not flag(flag.lodge_alarm)"
    once: true
    effects: ["set_flag(flag.lodge_alarm)", "start_encounter(enc.brzezina_clearing)"]
hazards:
  - {id: peat_bog, area: birch_stand, kind: deep_mud, params: {speed_mult: 0.7}}
  - {id: gate_brazier, area: gate_post, kind: fire, params: {damage_per_second: 5}}
  - {id: ford_current, area: the_ford, kind: tide, params: {push: 1.5}}
checkpoints:
  - {id: woods_arrival, area: gate_post}
  - {id: ivy_cp, area: ivy_wall}
beats:
  - {id: overheard_plot, description: "Through the shutters: Hollec's voice, thick with wine; Drozd's, cool. Three fords, unguarded, on the morning the Queen dies. A margravate. A Sodden bride for his last son."}
  - {id: horses_bolt, description: "Drozd's horses bolt into the birches. A Sodden escort swears in fen dialect."}
  - {id: hounds_loose, description: "The baron's hounds pour out of the kennel, baying, and run for the lodge clearing. Every retainer turns to chase them."}
  - {id: alarm_raised, description: "'Intruder! At the wall!' Torches swing toward the player."}
npcs:
  - {npc: npc.huntsman_garr, area: gate_post, condition: "true"}
  - {npc: npc.hanka_maid, area: kitchen_yard, condition: "not flag(flag.hanka_helped)"}
encounters: [enc.brzezina_clearing]
loot:
  - {container: woodpile, items: [{item: item.poultice, count: 1}], condition: "true"}
variants:
  - id: stage2_rain
    when: "stage() >= 2"
    description: "Rain on the birches. The ford runs grey and high; a Sodden skiff waits under the bank."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: stage3_sodden_boots
    when: "stage() >= 3"
    description: "The retainers wear Sodden boots and no longer hide their fen accents."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: after_drozd
    when: "flag(flag.drozd_rival)"
    description: "The ford is empty; hoofprints and a dragged keel mark lead north into Sodden."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: [cut_tethers, solar_listen]
```

```yaml zone
id: zone.brzezina_lodge
name: "Baron Hollec's Hunting Lodge"
kind: interior
map_node: map.brzezina_woods
time_of_day: night
cold_rate: 0
disguise_tag: null
music: lodge_feast
areas:
  - {id: great_hall, description: "Antler chandelier, long table of guests, a roasting hearth, banners."}
  - {id: high_table, description: "Hollec's chair under a stag's head; Drozd at his right; Brana behind him."}
  - {id: minstrel_gallery, description: "Wooden gallery over the hall's south side. Cover; sight of the high table."}
  - {id: kitchen, description: "Smoky kitchen hung with game. Back stair to the solar."}
  - {id: gallery_stair, description: "Stair from the hall to the solar. One retainer during the meeting."}
  - {id: solar, description: "Writing desk, iron-bound strongbox, a map of three fords, balcony window over the ivy."}
  - {id: cellar, description: "Undercroft full of casks branded with Sodden's mark."}
spawns:
  - {id: hall_door, area: great_hall, default: true}
  - {id: kitchen_in, area: kitchen}
  - {id: solar_window, area: solar}
exits:
  - id: hall_out
    area: great_hall
    to_zone: zone.brzezina_woods
    to_spawn: lodge_door
    condition: "true"
    effects: []
  - id: kitchen_out
    area: kitchen
    to_zone: zone.brzezina_woods
    to_spawn: kitchen_out
    condition: "true"
    effects: []
  - id: ivy_down
    area: solar
    to_zone: zone.brzezina_woods
    to_spawn: ivy_foot
    condition: "true"
    effects: []
interactables:
  - id: strongbox_key
    area: solar
    kind: container
    label: "Open the strongbox with Hanka's key"
    condition: "has_item(item.hollec_solar_key) and not has_item(item.hollec_letters) and not flag(flag.brzezina_plot_exposed)"
    check: null
    once: true
    effects: ["give_item(item.hollec_letters, 1)", "add_crowns(60)"]
    fail_effects: []
  - id: strongbox_pick
    area: solar
    kind: container
    label: "Pick the strongbox"
    condition: "not has_item(item.hollec_solar_key) and not has_item(item.hollec_letters) and not flag(flag.brzezina_plot_exposed)"
    check: {skill: investigate, dc: 6}
    once: false
    effects: ["give_item(item.hollec_letters, 1)", "add_crowns(60)"]
    fail_effects: ["play_beat(alarm_raised)"]
  - id: ford_map
    area: solar
    kind: readable
    label: "Study the map of the fords"
    condition: "true"
    check: null
    once: true
    effects: []
    fail_effects: []
  - id: sodden_casks
    area: cellar
    kind: search
    label: "Look at the cask brands"
    condition: "true"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["add_crowns(25)"]
    fail_effects: []
  - id: brana_word
    area: high_table
    kind: search
    label: "Take Castellan Brana aside"
    condition: "has_item(item.hollec_letters) and not flag(flag.brzezina_plot_exposed)"
    check: null
    once: false
    effects: ["start_dialogue(dlg.brana_castellan)"]
    fail_effects: []
  - id: stair_listen
    area: gallery_stair
    kind: readable
    label: "Listen at the solar door"
    condition: "not flag(flag.brzezina_plot_overheard) and not flag(flag.drozd_rival)"
    check: null
    once: true
    effects: ["play_beat(overheard_plot_stair)", "set_flag(flag.brzezina_plot_overheard)"]
    fail_effects: []
triggers:
  - id: lodge_alarm
    area: great_hall
    on: beat_done
    source: alarm_raised
    condition: "not flag(flag.lodge_alarm)"
    once: true
    effects: ["set_flag(flag.lodge_alarm)", "start_encounter(enc.brzezina_retainers)"]
  - id: hall_entry
    area: great_hall
    on: enter
    source: null
    condition: "true"
    once: true
    effects: ["set_checkpoint(hall_cp)"]
hazards:
  - {id: roasting_hearth, area: great_hall, kind: fire, params: {damage_per_second: 6}}
checkpoints:
  - {id: hall_cp, area: great_hall}
  - {id: solar_cp, area: solar}
beats:
  - {id: overheard_plot_stair, description: "Through the solar door: three fords left unguarded on the morning the Queen dies; a margravate for Hollec; a Sodden bride for his son."}
  - {id: alarm_raised, description: "A retainer shouts and draws. Guests scatter from the long table."}
  - {id: drozd_escapes, description: "Drozd tips a smoke pot into the hearth. Grey smoke rolls over the table; a shutter bangs; hooves at the ford, or oars."}
  - {id: hollec_arrested, description: "Castellan Brana lays a hand on Hollec's shoulder. Two retainers look at each other, then at the Marshal's seal, and step away from their lord."}
npcs:
  - {npc: npc.baron_hollec, area: high_table, condition: "not flag(flag.hollec_dead) and not flag(flag.hollec_arrested)"}
  - {npc: npc.ivena_drozd, area: high_table, condition: "not flag(flag.drozd_rival) and not flag(flag.drozd_bought)"}
  - {npc: npc.castellan_brana, area: high_table, condition: "true"}
  - {npc: npc.hanka_maid, area: kitchen, condition: "flag(flag.hanka_helped)"}
encounters: [enc.brzezina_retainers]
loot:
  - {container: desk_drawer, items: [{item: item.field_draught, count: 1}], condition: "true"}
variants:
  - id: stage3_pennant
    when: "stage() >= 3"
    description: "A green-and-black Sodden pennant hangs openly above the solar desk."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: after_exposure
    when: "flag(flag.brzezina_plot_exposed)"
    description: "The feast is over. Benches overturned; Brana's men guard the stair; the Sodden casks are being staved in."
    npcs_absent: [npc.ivena_drozd]
    encounters_disabled: [enc.brzezina_retainers]
    interactables_disabled: [strongbox_key, strongbox_pick, stair_listen]
```

Stealth notes (gdd §6.5): the clearing retainers and the stair guard use standard vision cones. A guest (`flag.lodge_guest`) is permitted in the great hall, kitchen and cellar; climbing the gallery stair, entering the solar or opening the strongbox are restricted actions. Without guest status the whole lodge is restricted. Suspicion 100 plays `alarm_raised`. Releasing the hounds (`kennel_latch`) pulls the clearing patrol away (prose rule: retainers chase the hounds out of the clearing for the rest of the visit). Takedowns work on all retainers.

## 4. NPCs present

**Ivena Drozd.** Voice notes: forty, grey-eyed, a schoolmistress's patience and a gambler's smile. Speaks perfect court Cintran with a faint fen vowel she lets slip on purpose. Compliments people precisely, which is more frightening than insults. Never threatens; she "regrets". Calls the player "Marshal's hound" once and "you" ever after.

**Baron Oswin Hollec.** Voice notes: a heavy, red-faced man of sixty with a boar-spear voice, loud with wine and grief. Speaks of his dead sons by name (Teodor and Jan) whenever cornered. Cruel to servants, sentimental about dogs.

**Castellan Brana.** Voice notes: a one-armed veteran of the Marnadal war, terse, rarely speaks more than one sentence. Loyal to the Crown's law before her lord. Has been waiting for an excuse.

**Huntsman Garr.** Voice notes: gruff, practical, smells of hounds. Judges people by their boots.

**Hanka.** Voice notes: a scullery maid, nineteen, sharp-tongued and quick. Her brother was hanged for poaching a hare in these woods; she has never forgiven the baron.

```yaml npc
id: npc.ivena_drozd
name: "Ivena Drozd"
faction: null
role: "Spymaster of Sodden; recurring rival"
motive: "Buy Cintra's border lords one by one, so Sodden takes the north-east without a battle when the Crown falls apart."
secret: "Sodden's king does not know how far she has gone; the promises she made Hollec are her own, and she means to keep none of them."
disposition: neutral
essential: true
dialogue: dlg.drozd_table
barks: ["Charming lodge. Draughty, like its owner.", "We will meet again. I so rarely say that and mean it.", "Wine, Marshal's hound? It's from my side of the river."]
combat: enemy.choir_assassin
shop: null
```

```yaml npc
id: npc.baron_hollec
name: "Baron Oswin Hollec"
faction: null
role: "Baron of Brzezina, holder of the three north-east fords"
motive: "Revenge on a Crown that spent his sons at Marnadal and paid him nothing, and a title nobody can take away."
secret: "He has already taken Sodden silver: the cellar casks were paid for at five times their price."
disposition: wary
essential: false
dialogue: dlg.hollec_confront
barks: ["More wine! Sodden wine, the good stuff.", "Teodor would have liked this hunt.", "Out of my way, girl."]
combat: enemy.bandit
shop: null
```

```yaml npc
id: npc.castellan_brana
name: "Castellan Brana"
faction: faction.crown
role: "Castellan of Brzezina, a Marnadal veteran"
motive: "Keep the fords Cintran; keep her oath to the Crown."
secret: "She has suspected the Sodden wine for a season and has no proof."
disposition: neutral
essential: true
dialogue: dlg.brana_castellan
barks: ["Keep your hands where I see them.", "Hm.", "The baron's guests have strange boots."]
combat: null
shop: null
```

```yaml npc
id: npc.huntsman_garr
name: "Huntsman Garr"
faction: null
role: "The baron's huntsman, keeper of the gate post"
motive: "Keep the gentry fed and the riff-raff out."
secret: null
disposition: wary
essential: false
dialogue: dlg.garr_gate
barks: ["Guests only tonight.", "Mind the hounds. They mind you.", "Good boots. Shame about the face."]
combat: enemy.bandit
shop: null
```

```yaml npc
id: npc.hanka_maid
name: "Hanka"
faction: null
role: "Scullery maid at the lodge"
motive: "See the baron pay for something, once."
secret: "She knows where the strongbox key is kept: inside the stag's-head boot by the solar hearth."
disposition: neutral
essential: false
dialogue: dlg.hanka_kitchen
barks: ["Out of my kitchen unless you're carrying wood.", "Venison again. They eat like the war's over.", "Don't touch that, it's for the Sodden lady."]
combat: null
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.garr_gate
participants: [npc.huntsman_garr]
start: open
nodes:
  open:
    type: branch
    cases:
      - {if: "flag(flag.lodge_guest)", next: already}
    else: greet
  already:
    type: line
    speaker: npc.huntsman_garr
    text: "Go on in, then. Don't sit near the Sodden lot. They tip badly."
    next: bye
  greet:
    type: line
    speaker: npc.huntsman_garr
    text: "The baron hunts with guests tonight. You're not a guest. You've a guest's boots, mind. Stolen?"
    direction: "Leaning on a boar-spear, hounds straining at his heel."
    next: hub
  hub:
    type: choice
    options:
      - id: hired
        text: "I'm a hired blade. The baron's guests travel far, and the roads are bad. [Persuade 6]"
        tag: persuade
        check: {skill: persuade, dc: 6, pass: hired_pass, fail: hired_fail}
        once: true
      - id: bribe
        text: "Here's my invitation."
        tag: bribe
        bribe: 40
        effects: ["set_flag(flag.lodge_guest)"]
        next: bribe_line
      - id: writ
        text: "Crown business. [Item: Marshal's writ]"
        tag: item
        condition: "has_item(item.kosk_writ)"
        once: true
        next: writ_line
      - id: threaten
        text: "Lift the barrier or I lift you over it. [Intimidate 6]"
        tag: intimidate
        check: {skill: intimidate, dc: 6, pass: threat_pass, fail: threat_fail}
        once: true
      - id: leave
        text: "Enjoy the hunt."
        next: bye
  hired_pass:
    type: line
    speaker: npc.huntsman_garr
    text: "Bad roads, aye. Highwaymen everywhere since the Watch emptied. Go in. Eat in the kitchen if they won't seat you."
    effects: ["set_flag(flag.lodge_guest)"]
    next: bye
  hired_fail:
    type: line
    speaker: npc.huntsman_garr
    text: "The guests brought their own blades. Grey ones, Sodden steel. Go back down the road."
    next: hub
  bribe_line:
    type: line
    speaker: npc.huntsman_garr
    text: "That's a fine invitation. Signed in silver. In you go."
    next: bye
  writ_line:
    type: line
    speaker: npc.huntsman_garr
    text: "Crown business, at a hunt full of Sodden wine merchants? I'll pretend I didn't see that paper, friend. For your sake. Guests only."
    next: hub
  threat_pass:
    type: line
    speaker: npc.huntsman_garr
    text: "All right. All right. But I never let you through, and if you're caught I'll say so."
    direction: "He lifts the barrier and looks hard at the hounds."
    next: bye
  threat_fail:
    type: line
    speaker: npc.huntsman_garr
    text: "Try it, and the hounds eat first. Go round, if you're so keen. Through the bog, like a poacher."
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.hanka_kitchen
participants: [npc.hanka_maid]
start: open
nodes:
  open:
    type: line
    speaker: npc.hanka_maid
    text: "Out of my kitchen unless you're carrying wood. ...You're not one of theirs. Not with those eyes. What do you want?"
    next: hub
  hub:
    type: choice
    options:
      - id: ask_solar
        text: "What does the baron keep in his solar?"
        next: solar_answer
      - id: brother
        text: "Someone in this house wronged you. I can see it."
        once: true
        next: brother_answer
      - id: bribe
        text: "Thirty crowns for the strongbox key and a back way up."
        tag: bribe
        bribe: 30
        effects: ["give_item(item.hollec_solar_key, 1)", "set_flag(flag.hanka_helped)"]
        next: key_line
      - id: leave
        text: "Just passing through."
        next: bye
  solar_answer:
    type: line
    speaker: npc.hanka_maid
    text: "Letters. He writes at night with the door bolted and the Sodden lady's seal on the desk. Then he locks them in the iron box and drinks till he cries."
    next: hub
  brother_answer:
    type: line
    speaker: npc.hanka_maid
    text: "My brother poached a hare in these woods. One hare, in the bad winter. The baron hanged him from that birch by the well. He said it was the law."
    next: brother_hub
  brother_hub:
    type: choice
    options:
      - id: justice
        text: "Then let's see how the baron likes the law. Help me. [Persuade 6]"
        tag: persuade
        check: {skill: persuade, dc: 6, pass: justice_pass, fail: justice_fail}
        once: true
      - id: back
        text: "I'm sorry."
        next: hub
  justice_pass:
    type: effect
    effects: ["give_item(item.hollec_solar_key, 1)", "set_flag(flag.hanka_helped)"]
    next: key_line
  justice_fail:
    type: line
    speaker: npc.hanka_maid
    text: "Pretty words. Everybody who wants something from a maid has pretty words. Carry wood or go."
    next: hub
  key_line:
    type: line
    speaker: npc.hanka_maid
    text: "He hides it in the boot of the stag's head by the solar hearth, the fool. Here. Back stair, behind the hanging hares. If they catch you, you've never seen me."
    direction: "She pulls a black iron key from her apron and slaps it on the table."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.drozd_table
participants: [npc.ivena_drozd]
start: open
nodes:
  open:
    type: line
    speaker: npc.ivena_drozd
    text: "The Marshal's new hound, at a baron's table. Sit. You've earned a cup. You came through Garr, or the bog, or the kitchen? The kitchen. You smell of onions."
    direction: "She pours without looking at the cup."
    next: hub
  hub:
    type: choice
    options:
      - id: who
        text: "And you are a wine merchant."
        next: who_answer
      - id: read
        text: "Your signet's turned inward. Sodden's heron, I'd guess. [Investigate 6]"
        tag: investigate
        check: {skill: investigate, dc: 6, pass: read_pass, fail: read_fail}
        once: true
      - id: offer
        text: "What does Sodden want with a border baron?"
        next: offer_line
      - id: leave
        text: "Enjoy the wine."
        next: bye
  who_answer:
    type: line
    speaker: npc.ivena_drozd
    text: "I am Ivena, and I sell wine. Mostly I sell time. Cintra is about to run out of it, and some men would like to buy a little before the price goes up."
    next: hub
  read_pass:
    type: line
    speaker: npc.ivena_drozd
    text: "Clever. Most people look at my face. Yes, the heron. Keep that to yourself and I'll keep to myself that you came in through a kitchen."
    effects: ["set_flag(flag.brzezina_plot_overheard)"]
    next: hub
  read_fail:
    type: line
    speaker: npc.ivena_drozd
    text: "You're staring at my hands. Are you a glover, or a thief? Never mind. Drink."
    next: hub
  offer_line:
    type: line
    speaker: npc.ivena_drozd
    text: "Nothing that need trouble you. In fact here is a hundred crowns not to be troubled. Walk out to the road, and tomorrow you'll have been somewhere else."
    direction: "A purse slides across the cloth."
    next: offer_hub
  offer_hub:
    type: choice
    options:
      - id: take
        text: "Somewhere else sounds pleasant."
        effects: ["add_crowns(100)", "set_flag(flag.drozd_bought)"]
        next: taken
      - id: refuse
        text: "Keep it."
        next: refused
  taken:
    type: line
    speaker: npc.ivena_drozd
    text: "A sensible animal. I'll leave first; our business here is done anyway. Don't make me regret you."
    direction: "She rises, kisses Hollec's cheek, and is gone through the hall door."
    next: bye
  refused:
    type: line
    speaker: npc.ivena_drozd
    text: "Pity. I liked you more with a price. Now I'll have to like you as a problem."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.hollec_confront
participants: [npc.baron_hollec, npc.ivena_drozd, npc.castellan_brana]
start: open
nodes:
  open:
    type: branch
    cases:
      - {if: "flag(flag.hollec_blackmailed) and has_item(item.hollec_letters)", next: squeezed_again}
      - {if: "has_item(item.hollec_letters) and not flag(flag.drozd_rival) and not flag(flag.drozd_bought)", next: reveal_drozd}
      - {if: "has_item(item.hollec_letters)", next: reveal_alone}
    else: host
  host:
    type: line
    speaker: npc.baron_hollec
    text: "Who let this one in? Garr? Garr lets dogs in now. Eat, drink, and stay out of my solar."
    next: host_hub
  host_hub:
    type: choice
    options:
      - id: sons
        text: "I hear you lost sons at Marnadal."
        once: true
        next: sons_answer
      - id: yielded_letters
        text: "Where are your letters, baron?"
        condition: "flag(flag.hollec_yielded)"
        next: yield_letters
      - id: bye_opt
        text: "My lord."
        next: bye
  sons_answer:
    type: line
    speaker: npc.baron_hollec
    text: "Teodor and Jan. Seventeen and nineteen. Kosk put them in the first line at the river because they were mine and I was far away. The Crown sent me a letter. One letter."
    direction: "His cup stops halfway to his mouth."
    next: host_hub
  yield_letters:
    type: line
    speaker: npc.baron_hollec
    text: "The strongbox. The key's in the stag's boot by the hearth. Take them. Take them and let me live, I've no sons left to bury me."
    effects: ["give_item(item.hollec_letters, 1)"]
    next: reveal_alone
  reveal_drozd:
    type: line
    speaker: npc.ivena_drozd
    text: "Ah. That's my handwriting on the table. I did warn you about the kitchen, Oswin. Hound: I will remember your face. Try to remember mine."
    direction: "She drops a smoke pot into the hearth without looking at it."
    effects: ["play_beat(drozd_escapes)", "set_flag(flag.drozd_rival)"]
    next: reveal_alone
  reveal_alone:
    type: line
    speaker: npc.baron_hollec
    text: "So. My letters. Well, what will it be? You'll hang me for wanting what Kosk took from me? Or are you the sort who has a price?"
    next: hub
  hub:
    type: choice
    options:
      - id: arrest_writ
        text: "Castellan Brana. The Lord Marshal's writ. Hold your lord for the Crown. [Item: Marshal's writ]"
        tag: item
        condition: "has_item(item.kosk_writ)"
        effects: ["take_item(item.hollec_letters, 1)", "set_flag(flag.brzezina_plot_exposed)", "set_flag(flag.hollec_arrested)", "add_rep(faction.crown, 15)", "play_beat(hollec_arrested)"]
        next: arrested
      - id: send_crown
        text: "These go to the Lord Marshal. Brana, your lord is not to leave this lodge."
        effects: ["take_item(item.hollec_letters, 1)", "set_flag(flag.brzezina_plot_exposed)", "set_flag(flag.hollec_arrested)", "add_rep(faction.crown, 10)", "play_beat(hollec_arrested)"]
        next: arrested
      - id: why
        text: "Why, Hollec? Truly."
        once: true
        next: why_answer
      - id: blackmail
        text: "A hundred and fifty crowns, and these stay in my pocket. Close your fords to Sodden, and we'll never speak of it."
        condition: "not flag(flag.hollec_blackmailed)"
        effects: ["add_crowns(150)", "set_flag(flag.hollec_blackmailed)"]
        next: paid
      - id: kill
        text: "Draw, baron."
        effects: ["start_encounter(enc.brzezina_retainers)"]
        next: bye
      - id: leave
        text: "I'll think about it."
        next: bye
  why_answer:
    type: line
    speaker: npc.baron_hollec
    text: "Because Cintra eats its own. The Queen's dying, the Marshal and the Chancellor are fighting over her bed, and Sodden at least pays for what it takes."
    next: hub
  arrested:
    type: line
    speaker: npc.castellan_brana
    text: "Hm. About time. My lord, your sword."
    next: arrested_two
  arrested_two:
    type: line
    speaker: npc.baron_hollec
    text: "Brana. You too. Of course you too. Take it. Tell Kosk my sons said hello."
    next: bye
  paid:
    type: line
    speaker: npc.baron_hollec
    text: "Here. Silver for silence. You're no better than her, you know. Just cheaper."
    direction: "He throws a purse; it bursts on the table."
    next: bye
  squeezed_again:
    type: line
    speaker: npc.baron_hollec
    text: "Back for more? I paid you. The fords are shut. Mostly."
    next: squeezed_hub
  squeezed_hub:
    type: choice
    options:
      - id: expose_late
        text: "I've changed my mind. Brana, hold him for the Crown."
        effects: ["take_item(item.hollec_letters, 1)", "clear_flag(flag.hollec_blackmailed)", "set_flag(flag.brzezina_plot_exposed)", "set_flag(flag.hollec_arrested)", "add_rep(faction.crown, 10)", "play_beat(hollec_arrested)"]
        next: arrested
      - id: fine
        text: "Mostly will do."
        next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.brana_castellan
participants: [npc.castellan_brana]
start: open
nodes:
  open:
    type: line
    speaker: npc.castellan_brana
    text: "You've been in the solar. You've his letters. I can see the seal from here. Show me."
    direction: "She reads one-handed, the paper flat on her thigh."
    next: hub
  hub:
    type: choice
    options:
      - id: give
        text: "They're yours. See they reach the Lord Marshal."
        effects: ["take_item(item.hollec_letters, 1)", "set_flag(flag.brzezina_plot_exposed)", "add_rep(faction.crown, 10)"]
        next: given
      - id: keep
        text: "Not yet."
        next: kept
  given:
    type: branch
    cases:
      - {if: "flag(flag.hollec_dead)", next: given_dead}
    else: given_alive
  given_dead:
    type: line
    speaker: npc.castellan_brana
    text: "A dead traitor and a live plot. The letters will hang the plot. Go, before the guests start asking who killed their host."
    next: bye
  given_alive:
    type: line
    speaker: npc.castellan_brana
    text: "I'll ride them to Cintra myself. And the baron will be in his own cellar when I come back."
    effects: ["set_flag(flag.hollec_arrested)", "play_beat(hollec_arrested)"]
    next: bye
  kept:
    type: line
    speaker: npc.castellan_brana
    text: "Hm. Then you're a thief and I've seen nothing."
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.brzezina_retainers
zone: zone.brzezina_lodge
enemies:
  - {enemy: enemy.bandit, count: 3, spawn: hall_door, variant: sodden_retainer}
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: hall_door, variant: sodden}
  - {enemy: enemy.bandit, count: 1, spawn: hall_door, variant: baron}
  - {enemy: enemy.choir_assassin, count: 1, spawn: hall_door, variant: drozd}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.bandit, count: 2, spawn: kitchen_in, variant: sodden_retainer}]}
attack_tokens: null
allow_yield: true
allies: []
checkpoint: hall_cp
avoidable_by: ["dlg.hollec_confront", "dlg.garr_gate", "dlg.hanka_kitchen"]
on_won: ["set_flag(flag.hollec_dead)", "set_flag(flag.drozd_rival)", "add_rep(faction.crown, -5)"]
on_yielded: ["set_flag(flag.hollec_yielded)", "set_flag(flag.drozd_rival)", "start_dialogue(dlg.hollec_confront)"]
on_player_fled: ["set_flag(flag.drozd_rival)"]
```

Notes: three Sodden retainers (bandit sword-and-buckler variant) and a Sodden bowman on the minstrels' gallery; the baron fights with a boar-spear (bandit spear stats, +30 HP). The `drozd` variant of `enemy.choir_assassin` never dies: at 20% HP, or after 30 s of fighting, whichever comes first, she uses smoke vanish, plays `drozd_escapes`, and leaves the fight; she is not counted for the win. If she was already gone (`flag.drozd_rival` or `flag.drozd_bought`), the encounter spawns without her (open question: needs a spawn condition). Two more retainers come from the kitchen when the first group falls. The roasting hearth is a fire hazard. If Hollec yields, the confrontation dialogue starts (he gives the letters if the player does not have them). If he dies, the letters are still in the strongbox and Castellan Brana takes them from the player.

```yaml encounter
id: enc.brzezina_clearing
zone: zone.brzezina_woods
enemies:
  - {enemy: enemy.bandit, count: 2, spawn: lodge_door, variant: sodden_retainer}
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: lodge_door, variant: sodden}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: woods_arrival
avoidable_by: ["dlg.garr_gate"]
on_won: []
on_yielded: []
on_player_fled: []
```

Notes: the clearing patrol if the player is spotted outside. Beating them does not end the quest: the lodge is still enterable by the kitchen or the ivy, but every guest has run upstairs and `flag.lodge_alarm` is set, so the next lodge entry starts `enc.brzezina_retainers` on sight (the `lodge_alarm` trigger is already spent; the variant is described in open questions).

## 7. Items and clues

```yaml item
id: item.hollec_letters
name: "Baron Hollec's letters"
category: document
description: "A bundle of letters tied with green ribbon: Sodden's heron seal on half of them, Hollec's boar on the rest."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Hollec to I.D.: 'The Teodor ford, the Mill ford and the Black ford will be unwatched from the morning the bell tolls for her. My men will be at the hunt. Your columns may cross dry-shod.' I.D. to Hollec: 'On that morning you are Margrave of the Brzezina March under the heron. A bride for Stefan is arranged. Burn this.' He did not burn it."
```

```yaml item
id: item.hollec_solar_key
name: "Black iron key"
category: key
description: "Hidden in the boot of a stuffed stag's head. Opens Baron Hollec's strongbox."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

No investigation-board clues: the Sodden plot is not one of the four theories. Its evidence is the letters item and the flags below.

Readable texts:
- **Map of the fords (solar):** three crossings inked in red, each with a number of men struck through and "0" written beside it.
- **Cask brands (cellar, Investigate 4):** the casks are Sodden's royal vintner's mark, bought at five times the market price; the tally sheet nailed to the cellar door is in Drozd's hand. Hidden silver in the last cask (+25 crowns).

## 8. Flags set and read

```yaml flags
declare:
  - {id: flag.brzezina_plot_exposed, type: bool, desc: "The Sodden northern-flank plot was exposed to the Crown (gdd 6.15 epilogue: no Sodden flank)."}
  - {id: flag.hollec_blackmailed, type: bool, desc: "The player kept the letters and took Hollec's silver."}
  - {id: flag.drozd_rival, type: bool, desc: "Drozd escaped knowing the player's face; recurring rival hooks."}
  - {id: flag.drozd_bought, type: bool, desc: "The player took Drozd's hundred crowns to look away (she leaves early)."}
  - {id: flag.lodge_guest, type: bool, desc: "Garr let the player in as a guest."}
  - {id: flag.brzezina_plot_overheard, type: bool, desc: "The player heard or deduced the plot (solar window, solar door, or Drozd's signet)."}
  - {id: flag.drozd_horses_cut, type: bool, desc: "Drozd's horses were cut loose; she escapes by river instead."}
  - {id: flag.hanka_helped, type: bool, desc: "Hanka gave the strongbox key."}
  - {id: flag.lodge_alarm, type: bool, desc: "An alarm was raised at Brzezina."}
  - {id: flag.hollec_dead, type: bool, desc: "Baron Hollec was killed."}
  - {id: flag.hollec_arrested, type: bool, desc: "Castellan Brana holds Hollec for the Crown."}
  - {id: flag.hollec_yielded, type: bool, desc: "Hollec yielded in the fight."}
reads:
  - ms.act1_complete
  - ms.act2_twist
  - flag.brzezina_hook
  - rumor.r18_brzezina_lodge
  - item.kosk_writ
```

`flag.brzezina_hook` is declared in `13-travel-events.md`. When `flag.drozd_rival` is set, `13-travel-events.md` may swap the lowlands slot 5 card for a Drozd variant, and the epilogue (A06) may add a Drozd slide.

## 9. Quest hooks

```yaml quest
id: quest.side_brzezina
kind: side
title: "The Hunting Lodge at Brzezina"
giver: null
available: "ms(ms.act1_complete) and (flag(flag.brzezina_hook) or rumor_heard(rumor.r18_brzezina_lodge))"
closes_on: "ms(ms.act2_twist)"
xp: 450
stages:
  - id: the_hunt
    journal: "Baron Hollec of Brzezina is entertaining Sodden 'wine merchants' at his hunting lodge. A border baron and a rival kingdom's guests: find out what is being sold."
    objectives:
      - {id: get_in, text: "Get close to the lodge", condition: "visited(zone.brzezina_lodge) or flag(flag.brzezina_plot_overheard)", optional: false}
      - {id: overhear, text: "Learn what Hollec is selling", condition: "flag(flag.brzezina_plot_overheard) or has_item(item.hollec_letters)", optional: true, xp: 40}
      - {id: letters, text: "Get Hollec's letters", condition: "has_item(item.hollec_letters) or flag(flag.brzezina_plot_exposed)", optional: false}
    on_complete: []
    next: []
  - id: judgement
    journal: "Hollec means to open three fords to Sodden the morning the Queen dies. I have his letters. Expose him, sell my silence, or end him."
    objectives:
      - {id: decide, text: "Decide Baron Hollec's fate", condition: "flag(flag.brzezina_plot_exposed) or flag(flag.hollec_blackmailed)", optional: false}
      - {id: exposed, text: "Expose the plot to the Crown", condition: "flag(flag.brzezina_plot_exposed)", optional: true, xp: 80}
    on_complete: []
    next: []
outcome_effects:
  completed: []
  failed: []
```

## 10. Rumors and event cards (optional)
None here. The hook comes from `rumor.r18_brzezina_lodge` (`14-rumors.md`) and the lowlands slot 5 card (`13-travel-events.md`).

## 11. Failure states and branches

```yaml branches
paths:
  - id: guest
    when: "Garr admits the player (Persuade 6 or Bribe 40)."
    outcome: "Free run of the hall, kitchen and cellar; Drozd's table talk; letters by Hanka's key or a pick."
    sets: ["set_flag(flag.lodge_guest)"]
  - id: sneak
    when: "Bog route, ivy wall, or kitchen door."
    outcome: "Overhear at the solar window; steal the letters from the solar."
    sets: ["set_flag(flag.brzezina_plot_overheard)"]
  - id: expose
    when: "Player gives the letters to Brana or arrests Hollec (with or without the writ)."
    outcome: "flag.brzezina_plot_exposed; Crown +10 (+15 with the writ); Hollec held."
    sets: ["set_flag(flag.brzezina_plot_exposed)"]
  - id: blackmail
    when: "Player takes 150 crowns for silence."
    outcome: "Plot unexposed; the letters stay with the player and can be used later in dlg.hollec_confront."
    sets: ["set_flag(flag.hollec_blackmailed)"]
  - id: kill
    when: "Player fights the baron's household."
    outcome: "Hollec dead; Crown -5; letters from the strongbox go to Brana to expose the plot."
    sets: ["set_flag(flag.hollec_dead)"]
  - id: drozd_bought
    when: "Player takes Drozd's hundred crowns."
    outcome: "Drozd leaves early (no escape scene); the player can still double-cross her and expose Hollec. flag.drozd_rival is not set unless she sees the letters used."
    sets: ["set_flag(flag.drozd_bought)"]
failures:
  - id: player_dies
    result: reload_checkpoint
    recover: "Reload woods_arrival, hall_cp or solar_cp."
  - id: alarm
    result: soft_fail
    recover: "The fight still leads to the letters (Hollec yields them, or the strongbox is open after the fight)."
  - id: drozd_escapes
    result: soft_fail
    recover: "By design. Drozd cannot be caught here."
  - id: closes_at_twist
    result: soft_fail
    recover: "Abandoned at ms.act2_twist; the epilogue shows the Sodden flank. A blackmailed Hollec counts as unexposed."
guarantees:
  - "The letters are reachable without a check: Hanka's bribe (30) gives the key; or the fight, after which Hollec yields them."
  - "flag.brzezina_plot_exposed is reachable without a check: give the letters to Castellan Brana (dlg.brana_castellan) or use the send_crown option."
  - "No main milestone depends on this quest."
```

## 12. Open questions
- **Drozd's scripted escape:** the encounter needs a per-enemy "escape at N% HP or after T seconds" rule (`variant: drozd`). Proposed as a data field on the variant. She must also be skipped at spawn when `flag.drozd_rival` or `flag.drozd_bought` is set: the encounter schema has no per-enemy spawn condition.
- **Repeat alarm:** after `flag.lodge_alarm` is set, a lodge re-entry should restart the household fight. Needs a variant with an `on: enter` trigger that is not `once`, or a zone-wide "hostile" state.
- **Hounds released:** the effect that pulls the clearing patrol away is prose only (no AI command effect exists). Implement as part of the `hounds_loose` beat.
- **Drozd as a recurring rival:** this file only sets `flag.drozd_rival`. The recurring appearances (a lowlands card variant, an epilogue slide) live in `13-travel-events.md` and A06's endings. gdd §8.3 lists the recurring rival as a cut candidate; the flag costs nothing if cut.
- **Crown payoff:** gdd §6.15 names `flag.brzezina_plot_exposed` for the epilogue only. No Act III combat effect is added.
- `item.field_draught` is assumed as the gdd consumable id ("field draught").
- Map edge `cintra—brzezina_woods` opens on "quest hook": suggest its condition be `flag(flag.brzezina_hook) or rumor_heard(rumor.r18_brzezina_lodge)`.
