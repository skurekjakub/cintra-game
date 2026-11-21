---
section_id: side.morrow_gull
title: "The Wreck of the Morrow Gull"
act: 2
story_ref: "story.md §10 Wreck of the Morrow Gull; gdd.md §7.4, §6.2 (mitigation flag.food_taster_exposed), §6.7 enemy.sea_serpent, §7.5 attre—morrow_gull"
zones: [zone.morrow_gull_reef, zone.morrow_gull_wreck]
available_when: "ms(ms.act1_complete) and visited(zone.attre_harbor)"
escalation_stage_required: {min: 1, max: 3}
milestones_set: []
milestones_read: [ms.act1_complete, ms.act2_twist]
level_band: [6, 8]
---

# The Wreck of the Morrow Gull

## 1. Scene summary
The cog *Morrow Gull* ran onto the Teeth reef off Attre in the spring gale, fleeing a Crown revenue cutter with her lanterns out. She carried wool on the manifest. Under the wool she carried Abbey correspondence for Port Peixe. Old Harl Brine, the last salvage diver in Attre who still works, has been anchored over the wreck for a while, too afraid to go down. Something big and territorial has made a lair in the ribs of an older hull beside her, and it took his partner. The player dives the wreck: the hold, the forecastle and the captain's cabin, with a breath meter refilled only at trapped air pockets. In the captain's strongbox is a watertight dispatch tube. The letter inside names the royal food-taster, Pell, and says he is paid in Abbey silver. The player can fight the serpent in its own element, or lure it off with seal-oil chum and dive while it feeds. Too many trips bring it back. The scene ends with the tube on its way to the Lord Marshal and the poisoner's hand at court exposed.

## 2. Progress and escalation
- **Availability:** Act II, from `ms.act1_complete` once the player has been to `zone.attre_harbor` (escalation stage 1–3). It closes at `ms.act2_twist`.
- **Map node:** `map.morrow_gull`, reached over the `attre — morrow_gull` edge (needs `flag.skerra_cutter` from 05-isle-of-skerra.md, or a hired boat for 60 crowns; the map's edge rule handles this). Zones: `zone.morrow_gull_reef` and `zone.morrow_gull_wreck`.
- **Hooks:** rumor `rumor.r12_morrow_gull` (Attre tavern talk), Jessa Rook's map pin in 05, or Harl's barks at the reef. The quest starts on first entry to the reef.
- **Milestones:** none set. The section reads `ms.act1_complete` and `ms.act2_twist`.
- **Payoff:** `item.taster_dispatch` and `clue.taster_dispatch` (theory.poisoner, supports Pell and Anselm). Sending or carrying the tube to Kosk sets `flag.food_taster_exposed`, one of the two Queen mitigations (gdd §6.2), and `flag.taster_dispatch_sent`. Crown reputation +10.
- **Stage variants:**
  - Stage 1–2: grey swell, gulls. Harl alone in his boat.
  - Stage 3: Harl reports a Choir-hired lugger circling the reef at dusk, looking for the same box. He is more frightened and asks 20 crowns more for the lure (60 instead of 40). Nothing else changes, because the Choir never got a diver down.
  - If Pell was already exposed in Act I (`flag.food_taster_exposed`), the dispatch still matters: it ties his pay to Abbey silver (the clue supports Anselm), and Kosk pays for it.

## 3. Location layout
**The reef** is open sea under a low sky. Harl's **boat** is a broad clinker salvage boat with a hand winch, a stone diving weight on a rope, a rack of rusted hooks and the lure barrels' cradle at the stern. A **marker buoy** a few strokes off the bow floats over the wreck. The **Teeth** are a line of black rocks breaking the swell to the north, with a gull colony and a cairn for drowned men. The Shrike (or the hired boat) is moored alongside, depending on how the player came.

**The wreck** is the underwater arena. The player goes down the diving rope to the **rope bottom**: grey sand, kelp, and two boulders for cover. The *Morrow Gull* lies on her port side, broken-backed:
- **Hull breach:** a split along her keel and the main way in. Dark. Sunlight comes through in bars.
- **Cargo hold:** rotten wool bales drift like drowned sheep. Two drowners nest in the hold, which is where the drowner encounter fires. Crates hold salvage (bolts, a fire oil, Attre coin).
- **Forecastle air pocket:** a trapped bubble under the forward deck. Surfacing here refills the breath meter. Barnacled lamp hooks.
- **Captain's cabin (aft):** the door hangs on one hinge. Inside are the captain's bones, still in his chair, and the iron **strongbox** bolted to the deck, which holds the dispatch tube and coin. Beside it is the **aft air pocket**, a smaller bubble in the stern lantern housing.
- **The serpent's lair:** the bleached ribs of a far older hull beside the cog, half-buried, with bones of seals and one man (Harl's partner, Osk, with his knife still in his belt).

The **rotten deck** over the hold can collapse under a sprinting player (collapse hazard, drops them into the hold). A **current** runs across the breach and pushes the player toward the lair.

Breath meter (gdd §6.7 serpent row): 60 s, refilled only in the two air pockets or at the surface. Running out does damage over time until the player reaches air.

Intended route: talk to Harl; get or make a lure; drop it; dive; go through the breach, then the hold or over the deck, to the aft pocket and the cabin; open the strongbox; get back to the rope; surface.

```yaml zone
id: zone.morrow_gull_reef
name: "The Teeth, above the Morrow Gull"
kind: exterior
map_node: map.morrow_gull
time_of_day: day
cold_rate: 0
disguise_tag: null
music: reef_swell
areas:
  - {id: harl_boat, description: "Broad salvage boat: hand winch, diving weight on a rope, rusted hooks, a cradle for lure barrels at the stern."}
  - {id: marker_buoy, description: "A tarred float over the wreck. The diving rope runs down from here."}
  - {id: teeth_rocks, description: "Black reef rocks, gull colony, a cairn for drowned men. Reached by a short swim."}
spawns:
  - {id: boat_deck, area: harl_boat, default: true}
  - {id: surfaced, area: marker_buoy}
exits:
  - id: dive
    area: marker_buoy
    to_zone: zone.morrow_gull_wreck
    to_spawn: rope_bottom
    condition: "quest_active(quest.side_morrow_gull)"
    effects: ["add_var(var.morrow_dive_trips, 1)"]
  - {id: sail_back, area: harl_boat, to_map: true, label: "Sail back to Attre", condition: "true", effects: []}
interactables:
  - id: drop_lure
    area: harl_boat
    kind: lever
    label: "Tip the chum barrel overboard"
    condition: "has_item(item.serpent_lure) and not flag(flag.serpent_lured) and not flag(flag.serpent_slain)"
    check: null
    once: false
    effects: ["take_item(item.serpent_lure, 1)", "set_flag(flag.serpent_lured)", "set_var(var.morrow_dive_trips, 0)", "play_beat(lure_dropped)"]
  - id: drowned_cairn
    area: teeth_rocks
    kind: readable
    label: "Read the names on the cairn"
    condition: "true"
    check: null
    once: false
    effects: []
  - id: rest_boat
    area: harl_boat
    kind: rest
    label: "Rest in the boat"
    condition: "true"
    check: null
    once: false
    effects: ["heal_player(full)"]
triggers:
  - id: arrive
    area: harl_boat
    "on": enter
    source: null
    condition: "not quest_active(quest.side_morrow_gull) and not quest_done(quest.side_morrow_gull)"
    once: true
    effects: ["start_quest(quest.side_morrow_gull)", "set_checkpoint(reef_boat)"]
  - id: surfaced_with_tube
    area: marker_buoy
    "on": enter
    source: null
    condition: "has_item(item.taster_dispatch) and not flag(flag.taster_dispatch_read)"
    once: true
    effects: ["start_dialogue(dlg.harl_dispatch)"]
hazards: []
checkpoints:
  - {id: reef_boat, area: harl_boat}
beats:
  - {id: lure_dropped, description: "The barrel bursts on the swell. An oily slick spreads. Far off, something long rolls once, grey, and is gone toward the smell."}
  - {id: tube_opened, description: "Harl prises the wax plug with a knife. Inside, dry as bread: a folded letter with an Abbey seal-impression scraped off."}
npcs:
  - {npc: npc.harl_brine, area: harl_boat, condition: "true"}
encounters: []
loot: []
variants:
  - id: stage_3
    when: "stage() >= 3"
    description: "A lugger with no flag circles at the edge of sight. Harl keeps looking at it."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: done
    when: "quest_done(quest.side_morrow_gull)"
    description: "Harl is pulling up the last of the cog's bronze fittings, humming."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
```

```yaml zone
id: zone.morrow_gull_wreck
name: "The Morrow Gull"
kind: arena
map_node: map.morrow_gull
time_of_day: day
cold_rate: 0
disguise_tag: null
music: underwater_dread
underwater:
  breath_s: 60
  damage_per_second_when_empty: 6
  air_pockets: [air_pocket_fore, air_pocket_aft]
  ranged_allowed: false
areas:
  - {id: rope_bottom, description: "Grey sand and kelp at the foot of the diving rope. Two boulders for cover. Exit back up."}
  - {id: hull_breach, description: "A split along the cog's keel; bars of sunlight; a cross-current pushing toward the lair."}
  - {id: cargo_hold, description: "Rotten wool bales drifting like drowned sheep. Salvage crates. Drowner nest."}
  - {id: rotten_deck, description: "Main deck over the hold, soft as cheese. A shortcut aft, if it holds."}
  - {id: air_pocket_fore, description: "Trapped bubble under the forward deck. Surfacing here refills breath."}
  - {id: captain_cabin, description: "Aft cabin. The captain's bones in his chair; an iron strongbox bolted to the deck."}
  - {id: air_pocket_aft, description: "Small bubble in the stern lantern housing beside the cabin."}
  - {id: serpent_lair, description: "Ribs of an older hull. Seal bones, and Osk's body with his knife in his belt."}
spawns:
  - {id: rope_bottom, area: rope_bottom, default: true}
  - {id: lair_mouth, area: serpent_lair}
  - {id: hold_nest, area: cargo_hold}
exits:
  - id: climb_rope
    area: rope_bottom
    to_zone: zone.morrow_gull_reef
    to_spawn: surfaced
    condition: "true"
    effects: []
interactables:
  - id: strongbox
    area: captain_cabin
    kind: container
    label: "Prise open the strongbox"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.taster_dispatch, 1)", "add_crowns(80)", "play_beat(strongbox_open)"]
    fail_effects: []
  - id: hold_crates
    area: cargo_hold
    kind: container
    label: "Search the crates"
    condition: "true"
    check: null
    once: true
    effects: []
    fail_effects: []
  - id: captain_bones
    area: captain_cabin
    kind: search
    label: "Search the captain"
    condition: "true"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["add_crowns(15)", "play_beat(captain_ring)"]
    fail_effects: []
  - id: osk_body
    area: serpent_lair
    kind: search
    label: "Take Osk's knife for Harl"
    condition: "true"
    check: null
    once: true
    effects: ["set_flag(flag.osk_knife_found)"]
    fail_effects: []
triggers:
  - id: serpent_unlured
    area: hull_breach
    "on": enter
    source: null
    condition: "not flag(flag.serpent_lured) and not flag(flag.serpent_slain)"
    once: false
    effects: ["set_checkpoint(wreck_bottom)", "play_beat(serpent_rises)", "start_encounter(enc.morrow_gull_serpent)"]
  - id: serpent_returns
    area: rope_bottom
    "on": enter
    source: null
    condition: "flag(flag.serpent_lured) and var(var.morrow_dive_trips) >= 3 and not flag(flag.serpent_slain)"
    once: false
    effects: ["clear_flag(flag.serpent_lured)", "set_checkpoint(wreck_bottom)", "play_beat(serpent_returns)", "start_encounter(enc.morrow_gull_serpent)"]
  - id: hold_drowners
    area: cargo_hold
    "on": enter
    source: null
    condition: "true"
    once: true
    effects: ["start_encounter(enc.morrow_gull_hold)"]
hazards:
  - {id: breach_current, area: hull_breach, kind: tide, params: {push_toward: serpent_lair, strength: 0.6}}
  - {id: soft_deck, area: rotten_deck, kind: collapse, params: {tripped_by: sprint_or_heavy_landing, drop_to: cargo_hold}}
checkpoints:
  - {id: wreck_bottom, area: rope_bottom}
beats:
  - {id: serpent_rises, description: "Sand lifts in the lair. A head the size of a rowboat slides out of the old ribs and turns one milky eye on the player."}
  - {id: serpent_returns, description: "The kelp bends against the current. It has finished the chum and come home."}
  - {id: strongbox_open, description: "The lid gives with a crack of rust. Wet coin, and a tarred leather tube sealed with wax at both ends."}
  - {id: captain_ring, description: "A silver ring on the captain's finger bone, stamped with the Peixe harbour mark."}
npcs: []
encounters: [enc.morrow_gull_serpent, enc.morrow_gull_hold]
loot:
  - {container: hold_crates, items: [{item: item.fire_oil, count: 1}, {item: item.crossbow_bolt, count: 6}], condition: "true"}
variants:
  - id: serpent_dead
    when: "flag(flag.serpent_slain)"
    description: "The serpent's body lies across the ribs of the old hull, crabs already at it."
    npcs_absent: []
    encounters_disabled: [enc.morrow_gull_serpent]
    interactables_disabled: []
```

## 4. NPCs present
**Voice notes.** Harl Brine is seventy, deaf in one ear from diving, and talks too loudly. He is superstitious, mercenary, and grieving his partner Osk in a way he will not name. He counts everything in coin and fathoms, and says "lad" or "lass" to everyone regardless.

```yaml npc
id: npc.harl_brine
name: "Harl Brine"
faction: faction.attre
role: "Old salvage diver of Attre harbour"
motive: "Get the Morrow Gull's coin up before the Choir's lugger does, and not die like Osk."
secret: "He sold the wreck's position once already, to a Peixe agent, before the serpent made it worthless. He fears the agent will come back."
disposition: neutral
essential: true
dialogue: dlg.harl_reef
barks: ["Mind the rope, it's all that brings you back.", "Osk went down there. Didn't come up.", "Sixty seconds of air, give or take your fear."]
combat: null
shop: {stock: [{item: item.serpent_lure, count: 2}], price_mod: 1.0}
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.harl_reef
participants: [npc.harl_brine]
start: greet
nodes:
  greet:
    type: branch
    cases:
      - {if: "flag(flag.taster_dispatch_read)", next: after}
      - {if: "flag(flag.serpent_slain)", next: slain}
    else: first
  first:
    type: line
    speaker: npc.harl_brine
    text: "You've the look of somebody who wants something off the bottom. So did Osk. He's still down there, with my good knife."
    direction: "Shouting slightly. Doesn't stop coiling rope."
    next: hub
  hub:
    type: choice
    options:
      - id: wreck
        text: "Tell me about the Morrow Gull."
        next: wreck_answer
      - id: thing
        text: "What took Osk?"
        next: thing_answer
      - id: terms
        text: "I'll dive. What's your cut?"
        next: terms_answer
      - id: lure_buy
        text: "Sell me chum to draw it off. [40 crowns]"
        condition: "stage() <= 2 and crowns() >= 40 and not has_item(item.serpent_lure)"
        effects: ["add_crowns(-40)", "give_item(item.serpent_lure, 1)"]
        next: lure_sold
      - id: lure_buy_s3
        text: "Sell me chum to draw it off. [60 crowns]"
        condition: "stage() >= 3 and crowns() >= 60 and not has_item(item.serpent_lure)"
        effects: ["add_crowns(-60)", "give_item(item.serpent_lure, 1)"]
        next: lure_sold
      - id: lure_make
        text: "You've a gut-bucket and seal-fat. I can rig a lure from that. [Lore 6]"
        tag: lore
        condition: "not has_item(item.serpent_lure)"
        check: {skill: lore, dc: 6, pass: lure_made, fail: lure_fail}
        once: true
      - id: lugger
        text: "Who's in the lugger?"
        condition: "stage() >= 3"
        next: lugger_answer
      - id: leave
        text: "Let me look at the water."
        next: bye
  wreck_answer:
    type: line
    speaker: npc.harl_brine
    text: "Wool, says the manifest. Wool doesn't make a captain douse his lanterns and run on the Teeth to dodge a Crown cutter. Something in that cabin was worth drowning for."
    next: hub
  thing_answer:
    type: line
    speaker: npc.harl_brine
    text: "Serpent. Long as three boats, grey as a gravestone. Came up the coast after the spring gale and found the old hull beside her. Took Osk off the rope like a gull takes a sprat."
    next: hub
  terms_answer:
    type: line
    speaker: npc.harl_brine
    text: "Captain's box will have coin. Coin's mine, papers are yours. My boat, my rope, my reef. Fair's fair."
    next: terms_choice
  terms_choice:
    type: choice
    options:
      - id: accept
        text: "Fair."
        next: hub
      - id: haggle
        text: "Osk's body is down there. I'll bring his knife back. Half the coin. [Persuade 6]"
        tag: persuade
        check: {skill: persuade, dc: 6, pass: haggle_pass, fail: haggle_fail}
        once: true
      - id: lean
        text: "Your boat, your rope, my neck. I keep what I find. [Intimidate 6]"
        tag: intimidate
        check: {skill: intimidate, dc: 6, pass: haggle_pass, fail: haggle_fail}
        once: true
  haggle_pass:
    type: line
    speaker: npc.harl_brine
    text: "Half. And Osk's knife. Done. Don't make me regret it from the surface."
    effects: ["set_flag(flag.harl_half_share)"]
    next: hub
  haggle_fail:
    type: line
    speaker: npc.harl_brine
    text: "Coin's mine. Take it or swim home."
    next: hub
  lure_sold:
    type: line
    speaker: npc.harl_brine
    text: "Tip it off the stern and dive the moment it's gone. It'll feed. Not forever. Go down too often and it'll remember where the real meat is."
    next: hub
  lure_made:
    type: line
    speaker: npc.harl_brine
    text: "Guts, blood and fat in a stoved keg. That's how my father did it. You're no Attre lad, but you'd pass."
    effects: ["give_item(item.serpent_lure, 1)"]
    next: hub
  lure_fail:
    type: line
    speaker: npc.harl_brine
    text: "That's a bucket of fish slop. It'd draw gulls. Buy a proper barrel or bring one from Skerra."
    next: hub
  lugger_answer:
    type: line
    speaker: npc.harl_brine
    text: "Monks don't fly flags. Two of 'em on the rail, in grey. No diver. They're waiting for someone like you to bring the box up."
    next: hub
  slain:
    type: line
    speaker: npc.harl_brine
    text: "You killed it. Down there, in its own water. I'll dive again. I'll dive again till I'm a hundred."
    next: hub
  after:
    type: line
    speaker: npc.harl_brine
    text: "Still here? There's bronze on her rail I mean to have. Mind your back in Attre. Men who'd sink a cog for a letter would sink you."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.harl_dispatch
participants: [npc.harl_brine]
start: open
nodes:
  open:
    type: line
    speaker: npc.harl_brine
    text: "That's no wool. Waxed both ends, tarred leather. Give it here, I'll get the plug out without wetting it."
    next: opened
  opened:
    type: effect
    effects: ["play_beat(tube_opened)", "add_clue(clue.taster_dispatch)", "set_flag(flag.taster_dispatch_read)"]
    next: letter
  letter:
    type: line
    speaker: player
    text: "'To the merchant at Peixe. The taster Pell is ours and paid in full from the alms chest, as before. He tastes and swallows nothing. The cup is clean when it leaves him.'"
    next: share
  share:
    type: branch
    cases:
      - {if: "flag(flag.harl_half_share) and flag(flag.osk_knife_found)", next: share_half_knife}
      - {if: "flag(flag.harl_half_share)", next: share_half}
      - {if: "flag(flag.osk_knife_found)", next: knife_only}
    else: coin_harl
  share_half_knife:
    type: line
    speaker: npc.harl_brine
    text: "Half the coin, as agreed. And Osk's knife. I'll put it in the cairn on the Teeth with his name."
    effects: ["add_crowns(40)", "add_xp(40)"]
    next: pell_branch
  share_half:
    type: line
    speaker: npc.harl_brine
    text: "Half the coin, as agreed."
    effects: ["add_crowns(40)"]
    next: pell_branch
  knife_only:
    type: line
    speaker: npc.harl_brine
    text: "You brought Osk's knife. Keep a share of the coin, then. Don't argue with me."
    effects: ["add_crowns(25)", "add_xp(40)"]
    next: pell_branch
  coin_harl:
    type: line
    speaker: npc.harl_brine
    text: "Coin's mine, as agreed. Paper's yours. Glad I can't read."
    effects: ["add_crowns(-80)"]
    next: pell_branch
  pell_branch:
    type: branch
    cases:
      - {if: "flag(flag.food_taster_exposed)", next: already}
    else: send_choice
  already:
    type: line
    speaker: player
    text: "Pell's already in the Marshal's cells. But this says who paid him. Abbey alms. That matters more."
    next: send_choice
  send_choice:
    type: choice
    options:
      - id: send
        text: "Can it go north quickly and quietly?"
        next: nephew
      - id: carry
        text: "I'll carry it to the Lord Marshal myself."
        next: carry_line
  nephew:
    type: line
    speaker: npc.harl_brine
    text: "My sister's boy Corrin crews the Crown packet to Cintra. Sealed in my oilskin, put in the Marshal's own hand, no harbour clerk the wiser. He owes me."
    next: nephew_choice
  nephew_choice:
    type: choice
    options:
      - id: trust
        text: "Do it."
        effects: ["take_item(item.taster_dispatch, 1)", "set_flag(flag.taster_dispatch_sent)", "set_flag(flag.food_taster_exposed)", "add_rep(faction.crown, 10)"]
        next: sent
      - id: "no"
        text: "No. I'll keep it."
        next: carry_line
  sent:
    type: line
    speaker: npc.harl_brine
    text: "Gone, then. Whoever drinks that Queen's cup will have a new taster. Pray this one swallows."
    next: bye
  carry_line:
    type: line
    speaker: npc.harl_brine
    text: "Your neck. Don't drown with it."
    next: bye
  bye:
    type: end
```

Note: `coin_harl` takes back the 80 crowns that the strongbox interaction granted, because by default the coin is Harl's. The `add_crowns(-80)` cannot fail here: the 80 were added when the box was opened, and no shop or bribe can be used underwater between those two moments. A reviewer may prefer the strongbox to give 0 crowns and this node to give the split instead (see Open questions).

```yaml dialogue
id: dlg.kosk_taster_dispatch
participants: [npc.kosk]
start: hand
nodes:
  hand:
    type: line
    speaker: npc.kosk
    text: "Pell. Paid from the Abbey's alms chest. I had that man tasting for her since she was a girl."
    direction: "Reads twice. Folds it very small."
    effects: ["take_item(item.taster_dispatch, 1)", "set_flag(flag.taster_dispatch_sent)", "set_flag(flag.food_taster_exposed)", "add_rep(faction.crown, 10)"]
    next: after
  after:
    type: branch
    cases:
      - {if: "ded(ded.taster_is_bought)", next: already_knew}
    else: new
  already_knew:
    type: line
    speaker: npc.kosk
    text: "You told me he was bought. Now I know by whom. I'll keep this out of Varn's reach and out of the Abbot's ear."
    next: bye
  new:
    type: line
    speaker: npc.kosk
    text: "He'll be in irons by the evening bell. Whoever pours her wine from now pours it under my men's eyes."
    next: bye
  bye:
    type: end
```

`dlg.kosk_taster_dispatch` is a chained conversation. A04's Kosk dialogue should offer an option with `condition: "has_item(item.taster_dispatch)"` and `effects: ["start_dialogue(dlg.kosk_taster_dispatch)"]` (listed under Expected in the report).

## 6. Encounters

```yaml encounter
id: enc.morrow_gull_serpent
zone: zone.morrow_gull_wreck
enemies:
  - {enemy: enemy.sea_serpent, count: 1, spawn: lair_mouth, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: wreck_bottom
avoidable_by: []
on_won: ["set_flag(flag.serpent_slain)"]
on_yielded: []
on_player_fled: []
```

The serpent fight is a boss fight underwater. The serpent lunges along straight lines from the lair, wraps the player against hull timbers, and retreats into the old ribs to recover. Its weak window is after a lunge that misses into the hull, when its head is stuck in the timbers for a moment. The air pockets are safe ground: the serpent cannot reach into the bubbles, so the player can breathe there but cannot fight from them. If the player climbs the rope mid-fight (`on_player_fled`), the encounter ends. The serpent stays hostile and the `serpent_unlured` trigger fires again on the next dive unless a lure is dropped.

**Non-combat alternative:** drop `item.serpent_lure` from Harl's boat (bought from Harl, bought or gifted by Jessa in 05, or rigged with Lore 6). While `flag.serpent_lured` is set and fewer than three dives have been made since the lure dropped, the serpent is away feeding and the wreck is safe except for the hold drowners. On the third dive, the serpent is waiting at the rope bottom. A careful player needs one dive (straight to the cabin, using the aft air pocket) or two (also the hold crates or Osk's knife). Greedy players meet it.

```yaml encounter
id: enc.morrow_gull_hold
zone: zone.morrow_gull_wreck
enemies:
  - {enemy: enemy.drowner, count: 2, spawn: hold_nest, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: wreck_bottom
avoidable_by: []
on_won: []
on_yielded: []
on_player_fled: []
```

The drowners only fire if the player enters the cargo hold, which is optional. The rotten-deck shortcut aft skips the hold, unless the player sprints on the deck and falls through it.

## 7. Items and clues

```yaml item
id: item.taster_dispatch
name: "Watertight dispatch tube"
category: document
description: "Tarred leather, waxed at both ends, from the Morrow Gull's strongbox. The Abbey seal-impression has been scraped off the letter inside."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "To the merchant at Peixe. The taster Pell is ours and paid in full from the alms chest, as before. He tastes and swallows nothing. The cup is clean when it leaves him. Send the second crate by the Gull. Burn this. A."
```

```yaml clue
id: clue.taster_dispatch
theory: theory.poisoner
title: "The Morrow Gull dispatch"
text: "A letter to a Peixe merchant: the food-taster Pell is 'ours', paid from the Abbey alms chest. He pretends to taste and swallows nothing. Signed only 'A.'"
supports: [pell, anselm]
refutes: [varn]
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: flag.taster_dispatch_sent, type: bool, desc: "The Morrow Gull tube reached the Lord Marshal (by Harl's nephew or by hand)."}
  - {id: flag.taster_dispatch_read, type: bool, desc: "The tube has been opened and read with Harl."}
  - {id: flag.serpent_slain, type: bool, desc: "The Morrow Gull serpent is dead."}
  - {id: flag.serpent_lured, type: bool, desc: "A lure is drawing the serpent away from the wreck."}
  - {id: flag.harl_half_share, type: bool, desc: "Harl agreed to split the strongbox coin."}
  - {id: flag.osk_knife_found, type: bool, desc: "The player took Osk's knife from the serpent's lair."}
  - {id: var.morrow_dive_trips, type: int, min: 0, max: 9, desc: "Dives since the last lure was dropped. At 3 the serpent returns."}
reads:
  - flag.food_taster_exposed
  - flag.skerra_cutter
  - ded.taster_is_bought
  - ms.act1_complete
  - ms.act2_twist
```

## 9. Quest hooks

```yaml quest
id: quest.side_morrow_gull
kind: side
title: "The Wreck of the Morrow Gull"
giver: npc.harl_brine
available: "ms(ms.act1_complete) and visited(zone.attre_harbor)"
closes_on: "ms(ms.act2_twist)"
xp: 500
stages:
  - id: dive
    journal: "The cog Morrow Gull lies on the Teeth reef off Attre. Her captain ran her aground rather than be boarded. Harl Brine says something in her cabin was worth drowning for, and something in the water took his partner."
    objectives:
      - {id: tube, text: "Recover what the captain was hiding", condition: "has_item(item.taster_dispatch) or flag(flag.taster_dispatch_sent)", optional: false}
      - {id: knife, text: "Bring back Osk's knife", condition: "flag(flag.osk_knife_found)", optional: true, xp: 40}
      - {id: serpent, text: "Kill the serpent", condition: "flag(flag.serpent_slain)", optional: true, xp: 100}
    on_complete: []
    next: []
  - id: read
    journal: "A waxed dispatch tube from the captain's strongbox. Harl can open it without wetting the letter."
    objectives:
      - {id: read, text: "Open the tube with Harl", condition: "flag(flag.taster_dispatch_read)", optional: false}
    on_complete: []
    next: []
  - id: deliver
    journal: "The letter names Pell, the Queen's food-taster, as bought with Abbey silver. The Lord Marshal needs to see it."
    objectives:
      - {id: deliver, text: "Get the dispatch to Lord Marshal Kosk", condition: "flag(flag.taster_dispatch_sent)", optional: false}
    on_complete: []
    next: []
outcome_effects:
  completed: []
  failed: []
```

## 10. Rumors and event cards (optional)
None here. `rumor.r12_morrow_gull` is in 14-rumors.md.

## 11. Failure states and branches

```yaml branches
paths:
  - id: lure_dive
    when: "Player drops a lure and makes one or two dives."
    outcome: "Tube recovered without the boss fight. Serpent alive."
    sets: ["give_item(item.taster_dispatch, 1)"]
  - id: fight
    when: "Player dives without a lure, or overstays, and kills the serpent."
    outcome: "flag.serpent_slain; tube recovered; Harl's optional XP."
    sets: ["set_flag(flag.serpent_slain)", "give_item(item.taster_dispatch, 1)"]
  - id: sent_by_nephew
    when: "Player lets Harl's nephew carry the tube on the Crown packet."
    outcome: "flag.taster_dispatch_sent, flag.food_taster_exposed, Crown +10."
    sets: ["set_flag(flag.taster_dispatch_sent)", "set_flag(flag.food_taster_exposed)"]
  - id: carried
    when: "Player keeps the tube and hands it to Kosk in Cintra (dlg.kosk_taster_dispatch)."
    outcome: "Same flags as sent_by_nephew, with Kosk's reaction."
    sets: ["set_flag(flag.taster_dispatch_sent)", "set_flag(flag.food_taster_exposed)"]
failures:
  - id: player_dies_underwater
    result: reload_checkpoint
    recover: "Reload wreck_bottom (autosaved on every serpent trigger) or reef_boat."
  - id: lure_check_failed
    result: soft_fail
    recover: "Buy the lure from Harl or Jessa, or fight."
  - id: tube_never_delivered
    result: soft_fail
    recover: "If ms.act2_twist fires with the tube in hand, the quest is abandoned; the clue still counts for ded.taster_is_bought."
guarantees:
  - "item.taster_dispatch reachable with no check: dive (fight the serpent) and open the strongbox (no check)."
  - "flag.taster_dispatch_sent reachable with no check: dlg.harl_dispatch option 'send' then 'trust'."
```

## 12. Open questions
- **Underwater rules (resolved by A08).** The wreck zone has `underwater: {breath_s: 60, damage_per_second_when_empty: 6, air_pockets: [...], ranged_allowed: false}` (content-format §J.5).
- **Coin split.** The strongbox gives 80 crowns at once, and `coin_harl` takes 80 back if no deal was struck. Cleaner alternative: the strongbox gives 0 and `dlg.harl_dispatch` hands out the share. This is left as written so the player sees the coin.
- `item.fire_oil` and `item.crossbow_bolt` are declared in act1 (checked by A08).
- The rumor "The serpent's lair" and the escalation of the Choir lugger are flavor only. A lugger fight on the way back would be a natural add-on if Act II needs more naval content.
