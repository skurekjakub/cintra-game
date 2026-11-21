---
section_id: side.rozrog
title: "The Woodwose of Rozrog"
act: 2
story_ref: "story.md §10 Rozrog Forest, §11 valley d8 slot 7; gdd.md §7.4, §6.3 (forest guide modifier), §6.7 enemy.woodwose, §6.13 ally.forest_guide"
zones: [zone.rozrog_charcoal_camp, zone.rozrog_sacred_grove]
available_when: "ms(ms.act1_complete)"
escalation_stage_required: {min: 1, max: 3}
milestones_set: []
milestones_read: [ms.act1_complete, ms.act2_twist]
level_band: [5, 7]
---

# The Woodwose of Rozrog

## 1. Scene summary
Deep in Rozrog, a gang of charcoal burners under a hard man called Wencel has started felling the old oaks of a grove that no burner in living memory would touch. Oak burns hottest, and grey-robed buyers have been paying Abbey silver by the cartload for the hottest charcoal the forest can make. The carts go south-east, toward the mountains, where the Choir is blasting near Ostrel. Something in the grove has answered. A woodwose, a great shaggy man-shaped beast of the deep woods, has killed two burners and smashed a clamp. Wencel wants it dead. A mute girl called Ottla lives at the edge of the grove, carves warning signs into the pines, and is the only creature the beast tolerates. The dramatic question is whether the player kills an animal defending its home for a gang of burners feeding the Choir, or makes the burners stop and makes peace. Peace earns Ottla as a silent forest guide through the border wilds. The kill earns a bounty and leaves the woods poorer.

## 2. Progress and escalation
- **Availability:** Act II, from `ms.act1_complete` (escalation stage 1–3). It closes at `ms.act2_twist`.
- **Map node:** `map.rozrog_forest`, reached by the `tigg — rozrog_forest` valley edge. Zones: `zone.rozrog_charcoal_camp` and `zone.rozrog_sacred_grove`.
- **Hooks:** `flag.rozrog_hook`, set by the valley d8 slot 7 card "Woodwose totems" (13-travel-events.md) or by `rumor.r17_rozrog_woodwose` (14-rumors.md). Both also pin `map.rozrog_forest`. Valley slot 4 (charcoal burners who saw monks) can pin it too. The quest starts on first entry to the camp whether or not the hook fired.
- **Milestones:** none set. The section reads `ms.act1_complete` and `ms.act2_twist`.
- **Payoff:** `flag.woodwose_peace` plus `add_ally(ally.forest_guide)`. With the guide, the travel encounter chance drops by 0.15 on any route with a valley edge (gdd §6.3). The alternative is `flag.woodwose_dead` and a 120-crown bounty. Either way, `clue.choir_charcoal_orders` (theory.choir) can be found.
- **Stage variants:**
  - Stage 1–2: the camp is working, with smoke and carts.
  - Stage 2 (Dark River): the stream in the grove runs grey with silt. Ottla's signs now include a new one: a mountain with a crack in it.
  - Stage 3 (Open Knives): two Choir carters wait at the camp for a load. If the burners stop cutting, the carters turn on the player on the way out (`enc.rozrog_choir_carters`). With the gdd §6.1 stage 3 rule, Choir groups get +1 member.

## 3. Location layout
**The charcoal camp** sits in a clearing hacked out of mixed pine and oak, under a permanent low roof of blue smoke. The player enters along the **cart track** from the Tigg road. The ruts are deep and iron-shod, far heavier than burners' handcarts. In the middle of the clearing are three **clamps**: domed mounds of earth and turf that smoulder for days. Their vents leak smoke that halves vision around them (cover for stealth), and stepping onto a clamp's crust burns (fire hazard). Along the west side stand the **burners' huts**, bark lean-tos and one plank hut that is Wencel's, with a tally board nailed inside the door. To the north are the **felled oaks**: a raw field of stumps as wide as cartwheels, the cut trunks stacked, and a pile of split **heartwood** waiting for the clamp. Under a birch near the stumps are two fresh **graves** marked with axe-hafts. The **watch fire** at the south edge is where the gang sits armed at night. A narrow **grove path** leaves north past the stumps. Pines along it are carved with Ottla's signs: an oak, an axe with a broken haft, an eye.

**The sacred grove** is old oak, moss and ferns, dim even at noon. The **grove edge** is where the path arrives. Past it is the **oak ring**, nine huge oaks around a mossy floor with standing stones grown into their roots. On the east side, the **stump scar** is where the burners have cut three of the nine down; the stumps still weep sap. Under the biggest root-tangle on the north side is the **woodwose lair**, a hollow strewn with sheep bones, a burner's boot, and a bed of bracken. Ottla's **bower** is to the west: a lean-to of woven hazel with carved bone and wood signs hanging like chimes. A **stream** runs along the south side. Wading in it puts out Burning, which matters because the woodwose is weak to fire and a player using fire oil may set the bracken alight.

Intended route: camp (Wencel, the tally, the graves) → stop the cutting → grove (Ottla's signs) → carry heartwood to the stump scar → offering → peace. Kill route: camp → hunt agreement → grove → the woodwose comes out at the oak ring → bounty.

```yaml zone
id: zone.rozrog_charcoal_camp
name: "Charcoal Camp, Rozrog"
kind: exterior
map_node: map.rozrog_forest
time_of_day: day
cold_rate: 0
disguise_tag: null
music: forest_smoke
areas:
  - {id: cart_track, description: "Deep iron-shod ruts from the Tigg road. Entry."}
  - {id: clamp_mounds, description: "Three smouldering earth clamps. Smoke halves vision; the crust burns."}
  - {id: burners_huts, description: "Bark lean-tos and Wencel's plank hut with a tally board inside the door."}
  - {id: felled_oaks, description: "Stumps wide as cartwheels; stacked trunks; split oak heartwood waiting for the clamp."}
  - {id: graves, description: "Two fresh graves under a birch, marked with axe-hafts."}
  - {id: watch_fire, description: "Fire ring with log seats where the gang keeps armed watch."}
  - {id: grove_path, description: "Narrow path north past the stumps. Pines carved with signs."}
spawns:
  - {id: road_in, area: cart_track, default: true}
  - {id: from_grove, area: grove_path}
exits:
  - id: to_grove
    area: grove_path
    to_zone: zone.rozrog_sacred_grove
    to_spawn: from_camp
    condition: "true"
    effects: []
  - {id: leave_road, area: cart_track, to_map: true, label: "Take the road back to Tigg", condition: "true", effects: []}
interactables:
  - id: tally_board
    area: burners_huts
    kind: search
    label: "Read the tally board"
    condition: "not has_clue(clue.choir_charcoal_orders)"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["add_clue(clue.choir_charcoal_orders)"]
    fail_effects: []
  - id: heartwood_pile
    area: felled_oaks
    kind: pickup
    label: "Take a split of oak heartwood"
    condition: "not has_item(item.oak_heartwood) and not flag(flag.woodwose_peace)"
    check: null
    once: false
    effects: ["give_item(item.oak_heartwood, 1)"]
  - id: graves_read
    area: graves
    kind: search
    label: "Look at the graves"
    condition: "true"
    check: null
    once: true
    effects: ["play_beat(graves_seen)"]
    fail_effects: []
  - id: pine_signs
    area: grove_path
    kind: readable
    label: "Study the carved signs"
    condition: "true"
    check: null
    once: false
    effects: []
  - id: watch_fire_rest
    area: watch_fire
    kind: rest
    label: "Rest by the watch fire"
    condition: "flag(flag.woodwose_peace) or flag(flag.woodwose_dead)"
    check: null
    once: false
    effects: ["heal_player(full)"]
triggers:
  - id: arrive
    area: cart_track
    "on": enter
    source: null
    condition: "not quest_active(quest.side_rozrog) and not quest_done(quest.side_rozrog)"
    once: true
    effects: ["start_quest(quest.side_rozrog)", "set_checkpoint(camp_track)"]
  - id: carters_turn
    area: cart_track
    "on": enter
    source: null
    condition: "stage() >= 3 and flag(flag.burners_stop_cutting) and not flag(flag.rozrog_carters_dealt)"
    once: true
    effects: ["set_checkpoint(camp_track)", "play_beat(carters_draw)", "start_encounter(enc.rozrog_choir_carters)"]
hazards:
  - {id: clamp_crust, area: clamp_mounds, kind: fire, params: {damage_per_second: 6, applies_burning: true}}
checkpoints:
  - {id: camp_track, area: cart_track}
  - {id: camp_huts, area: burners_huts}
beats:
  - {id: graves_seen, description: "Two graves. One axe-haft is snapped and tied back together with twine. A child's carved horse lies on the second."}
  - {id: carters_draw, description: "The grey carters by the empty wagon stand up from the wheel and draw blades from under their robes."}
  - {id: burners_pack, description: "The gang throws turf over the clamps and shoulders axes, cursing, to work the pine slope instead."}
  - {id: bounty_paid, description: "Wencel counts silver onto a stump. Some of it is stamped with a swan."}
npcs:
  - {npc: npc.wencel_burner, area: burners_huts, condition: "not flag(flag.burners_driven_off)"}
  - {npc: npc.choir_carter, area: cart_track, condition: "stage() >= 3 and not flag(flag.rozrog_carters_dealt)"}
encounters: [enc.rozrog_burners, enc.rozrog_choir_carters]
loot: []
variants:
  - id: driven_off
    when: "flag(flag.burners_driven_off)"
    description: "Camp abandoned: clamps collapsing, huts empty, a dog left behind."
    npcs_absent: [npc.wencel_burner]
    encounters_disabled: [enc.rozrog_burners]
    interactables_disabled: []
  - id: peace
    when: "flag(flag.woodwose_peace)"
    description: "No oak in the stacks. The gang burns pine. Someone has planted acorns around the stumps and fenced them with stakes."
    npcs_absent: []
    encounters_disabled: [enc.rozrog_burners]
    interactables_disabled: [heartwood_pile]
```

```yaml zone
id: zone.rozrog_sacred_grove
name: "The Oak Ring"
kind: exterior
map_node: map.rozrog_forest
time_of_day: dusk
cold_rate: 0
disguise_tag: null
music: grove_hush
areas:
  - {id: grove_edge, description: "Where the path meets the old oak. Ferns to the knee."}
  - {id: oak_ring, description: "Nine huge oaks (six standing) around a mossy floor; standing stones grown into the roots. Arena for the woodwose."}
  - {id: stump_scar, description: "Three fresh oak stumps weeping sap. The offering place."}
  - {id: woodwose_lair, description: "Hollow under a root-tangle: sheep bones, a burner's boot, a bracken bed (flammable)."}
  - {id: ottla_bower, description: "Woven hazel lean-to hung with carved bone and wood signs like chimes."}
  - {id: stream, description: "Shallow stream along the south side. Wading puts out Burning."}
spawns:
  - {id: from_camp, area: grove_edge, default: true}
  - {id: ring_north, area: oak_ring}
exits:
  - id: back_to_camp
    area: grove_edge
    to_zone: zone.rozrog_charcoal_camp
    to_spawn: from_grove
    condition: "true"
    effects: []
interactables:
  - id: offering_place
    area: stump_scar
    kind: lever
    label: "Lay the heartwood on the stump and plant acorns"
    condition: "flag(flag.burners_stop_cutting) and flag(flag.ottla_signs_read) and has_item(item.oak_heartwood) and not flag(flag.woodwose_peace) and not flag(flag.woodwose_dead)"
    check: null
    once: true
    effects: ["take_item(item.oak_heartwood, 1)", "play_beat(woodwose_comes)", "set_flag(flag.woodwose_peace)", "add_ally(ally.forest_guide)", "play_beat(ottla_follows)"]
  - id: challenge_beast
    area: woodwose_lair
    kind: lever
    label: "Call the beast out"
    condition: "not flag(flag.woodwose_peace) and not flag(flag.woodwose_dead)"
    check: null
    once: false
    effects: ["set_checkpoint(grove_edge_cp)", "start_encounter(enc.rozrog_woodwose)"]
  - id: bracken_bed
    area: woodwose_lair
    kind: search
    label: "Search the lair"
    condition: "true"
    check: null
    once: true
    effects: ["play_beat(lair_searched)"]
    fail_effects: []
  - id: hanging_signs
    area: ottla_bower
    kind: readable
    label: "Look at the hanging signs"
    condition: "true"
    check: null
    once: false
    effects: []
triggers:
  - id: woodwose_territory
    area: oak_ring
    "on": enter
    source: null
    condition: "not flag(flag.burners_stop_cutting) and not flag(flag.woodwose_peace) and not flag(flag.woodwose_dead)"
    once: false
    effects: ["set_checkpoint(grove_edge_cp)", "play_beat(woodwose_charges)", "start_encounter(enc.rozrog_woodwose)"]
  - id: ottla_flees
    area: grove_edge
    "on": encounter_done
    source: enc.rozrog_woodwose
    condition: "flag(flag.woodwose_dead)"
    once: true
    effects: ["play_beat(ottla_sign_left)"]
hazards:
  - {id: bracken_fire, area: woodwose_lair, kind: fire, params: {ignites_on: fire_damage, damage_per_second: 5}}
  - {id: root_snare, area: oak_ring, kind: trap, params: {root_s: 1.0, mash_to_break: true}}
checkpoints:
  - {id: grove_edge_cp, area: grove_edge}
beats:
  - {id: woodwose_charges, description: "Ferns explode. A shaggy grey shape twice a man's height comes through the ring on all fours and rears up, roaring, between the player and the stumps."}
  - {id: woodwose_comes, description: "Ottla presses acorns into the earth by the stump. The woodwose steps out of the oaks, sniffs the heartwood, the girl, the player, and sits down in the moss."}
  - {id: ottla_follows, description: "Ottla shoulders a hazel staff and a bag of signs, looks back once at the beast, and stands at the player's side."}
  - {id: ottla_sign_left, description: "On the grove path's last pine, fresh-cut: a stick figure with a sword, and a slash through it. Ottla is gone."}
  - {id: lair_searched, description: "Among the bones: a burner's axe-head bent double, and a doll of moss and twine that no beast made."}
npcs:
  - {npc: npc.ottla, area: ottla_bower, condition: "not flag(flag.woodwose_dead) and not flag(flag.woodwose_peace)"}
  - {npc: npc.woodwose, area: oak_ring, condition: "flag(flag.woodwose_peace)"}
encounters: [enc.rozrog_woodwose]
loot: []
variants:
  - id: dark_river
    when: "stage() >= 2"
    description: "The stream runs grey with silt. A new sign hangs at Ottla's bower: a mountain with a crack through it."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: peace
    when: "flag(flag.woodwose_peace)"
    description: "The woodwose dozes in the moss of the ring and ignores the player. Acorns staked around the stumps."
    npcs_absent: []
    encounters_disabled: [enc.rozrog_woodwose]
    interactables_disabled: [challenge_beast]
  - id: dead
    when: "flag(flag.woodwose_dead)"
    description: "The beast's body in the ring, flies already. The bower stripped, its signs taken."
    npcs_absent: [npc.ottla]
    encounters_disabled: [enc.rozrog_woodwose]
    interactables_disabled: [offering_place, challenge_beast]
```

## 4. NPCs present
**Voice notes.**
- **Wencel:** a charcoal-black man in every crease. Practical and grieving, two of his men are dead. He is greedy for the first silver his gang has ever seen and not stupid. He swears by "smoke and ash". He respects strength and money, in that order.
- **Ottla:** mute, maybe twelve or thirteen, wild-haired, barefoot. She never speaks. Her "lines" are carved signs the player reads aloud and interprets. She points, she draws in the dirt, and she flinches from metal.
- **The woodwose:** an animal, not a monster: a huge old ape-like forest dweller of the deep wood. It roars, beats the ground, and never speaks.
- **The Choir carter:** polite, flat, with a feather in his collar and a cudgel under his robe.

```yaml npc
id: npc.wencel_burner
name: "Wencel"
faction: null
role: "Boss of the Rozrog charcoal burners"
motive: "Keep selling oak charcoal to the grey buyers and kill the beast that killed his men."
secret: "He knew the grove was forbidden. His grandmother told him why. He cut it anyway because the silver was ten times pine."
disposition: wary
essential: false
dialogue: dlg.wencel_burner
barks: ["Smoke and ash, another stranger.", "Mind the clamps, the crust'll take your boots off.", "Two good men in the ground for a forest."]
combat: enemy.bandit
shop: null
```

```yaml npc
id: npc.ottla
name: "Ottla"
faction: null
role: "Mute girl of the oak grove"
motive: "Save the grove and the beast that has kept her alive."
secret: "She carved the warning totems the burners blame on the woodwose. She was left in the woods as a baby, and the woodwose let her be."
disposition: wary
essential: true
dialogue: dlg.ottla_signs
barks: []
combat: null
shop: null
```

```yaml npc
id: npc.woodwose
name: "The Woodwose"
faction: null
role: "Territorial beast of the oak grove"
motive: "Keep the old oaks standing and the burners out."
secret: null
disposition: hostile
essential: false
dialogue: null
barks: []
combat: enemy.woodwose
shop: null
```

```yaml npc
id: npc.choir_carter
name: "Grey carter"
faction: faction.choir
role: "Choir buyer collecting charcoal (stage 3 only)"
motive: "Load the wagon and go."
secret: "A pale gull feather is sewn inside his collar."
disposition: neutral
essential: false
dialogue: null
barks: ["Charity of the Abbey, friend. Move along.", "We pay well for warmth."]
combat: enemy.choir_zealot
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.wencel_burner
participants: [npc.wencel_burner]
start: greet
nodes:
  greet:
    type: branch
    cases:
      - {if: "flag(flag.woodwose_dead) and not flag(flag.rozrog_bounty_paid)", next: bounty}
      - {if: "flag(flag.woodwose_dead)", next: after_dead}
      - {if: "flag(flag.woodwose_peace)", next: after_peace}
      - {if: "flag(flag.burners_stop_cutting)", next: stopped}
    else: first
  first:
    type: line
    speaker: npc.wencel_burner
    text: "If you're from the reeve, we've paid. If you're from the Abbey, the load's not ready. If you're a sword for hire, there's a beast in those oaks I'll pay to see dead."
    effects: ["set_flag(flag.rozrog_met_wencel)"]
    next: hub
  hub:
    type: choice
    options:
      - id: beast
        text: "Tell me about the beast."
        next: beast_answer
      - id: buyers
        text: "Who buys your charcoal?"
        next: buyers_answer
      - id: oaks
        text: "You're cutting the old grove. Why?"
        next: oaks_answer
      - id: stop_persuade
        text: "Cut pine and deadfall. The beast only kills in the grove. Leave it and you'll lose no one else. [Persuade 6]"
        tag: persuade
        check: {skill: persuade, dc: 6, pass: agrees, fail: persuade_fail}
        once: true
      - id: stop_intimidate
        text: "The oaks stop falling today, or your gang does. [Intimidate 6]"
        tag: intimidate
        check: {skill: intimidate, dc: 6, pass: agrees_sullen, fail: intimidate_fail}
        once: true
      - id: stop_bribe
        text: "This covers the difference between oak and pine. Stop cutting. [Bribe 50]"
        tag: bribe
        bribe: 50
        next: agrees
      - id: stop_clue
        text: "Your grey buyers wear the pale feather. You're burning a holy grove to help the people who poisoned the Queen. [Clue]"
        tag: clue
        condition: "has_clue(clue.choir_charcoal_orders) or has_item(item.pale_feather) or ded(ded.choir_exists)"
        show_locked: true
        next: turns
      - id: stop_writ
        text: "This is crown forest, and I carry the Lord Marshal's writ. No more oak. [Item: Marshal's writ]"
        tag: item
        condition: "has_item(item.kosk_writ) and rep_tier(faction.crown) >= friendly"
        show_locked: true
        next: agrees_sullen
      - id: hunt
        text: "I'll kill your beast. What's it worth?"
        next: hunt_answer
      - id: drive_off
        text: "Pack up your clamps and get out of Rozrog."
        next: drive_answer
      - id: leave
        text: "I'll look around."
        next: bye
  beast_answer:
    type: line
    speaker: npc.wencel_burner
    text: "Big as a byre door, grey hair, hands like shovels. Tore Jan's arm off at the shoulder. Came back for Pavo two nights after. It leaves those carved sticks on the pines. Warnings, the lads say."
    next: hub
  buyers_answer:
    type: line
    speaker: npc.wencel_burner
    text: "Abbey men. Grey robes, quiet, pay in good silver and want oak, only oak, hottest burn there is. Carts go south-east. I don't ask what for."
    next: buyers_more
  buyers_more:
    type: branch
    cases:
      - {if: "not has_clue(clue.choir_charcoal_orders)", next: buyers_clue}
    else: hub
  buyers_clue:
    type: effect
    effects: ["add_clue(clue.choir_charcoal_orders)"]
    next: hub
  oaks_answer:
    type: line
    speaker: npc.wencel_burner
    text: "My gran said never the ring. Gran's dead and the Abbey pays ten times for oak. You'd cut it too, with silver like that on the table."
    next: hub
  persuade_fail:
    type: line
    speaker: npc.wencel_burner
    text: "Pine pays pine prices. My lads have been hungry too long to go back to that."
    next: hub
  intimidate_fail:
    type: line
    speaker: npc.wencel_burner
    text: "Seven of us, one of you, and every one of us has an axe. Say it again."
    direction: "The gang at the watch fire stand up."
    next: hub
  agrees:
    type: line
    speaker: npc.wencel_burner
    text: "Fine. Pine and deadfall. Smoke and ash, the buyers'll squeal. If that thing comes for us anyway, I'm cutting the whole ring down to the roots."
    effects: ["set_flag(flag.burners_stop_cutting)", "play_beat(burners_pack)"]
    next: bye
  agrees_sullen:
    type: line
    speaker: npc.wencel_burner
    text: "No more oak. You'll be gone tomorrow, and the buyers won't. Remember that when they cut my throat for it."
    effects: ["set_flag(flag.burners_stop_cutting)", "play_beat(burners_pack)"]
    next: bye
  turns:
    type: line
    speaker: npc.wencel_burner
    text: "The feather lot? Smoke and ash. Jan said one of them had a feather in his collar. We buried Jan for a fanatic's cart. No more oak. And no more sales to grey robes."
    effects: ["set_flag(flag.burners_stop_cutting)", "set_flag(flag.wencel_turned)", "play_beat(burners_pack)", "add_xp(45)"]
    next: turns_clue
  turns_clue:
    type: branch
    cases:
      - {if: "not has_clue(clue.choir_charcoal_orders)", next: buyers_clue_end}
    else: bye
  buyers_clue_end:
    type: effect
    effects: ["add_clue(clue.choir_charcoal_orders)"]
    next: bye
  hunt_answer:
    type: line
    speaker: npc.wencel_burner
    text: "Hundred and twenty crowns, Abbey silver, the day I see its head. It lairs under the big roots at the north of the ring."
    next: hunt_choice
  hunt_choice:
    type: choice
    options:
      - id: accept
        text: "Done."
        effects: ["set_flag(flag.rozrog_hunt)"]
        next: bye
      - id: think
        text: "Let me think."
        next: hub
  drive_answer:
    type: line
    speaker: npc.wencel_burner
    text: "You and whose army? Lads!"
    effects: ["start_encounter(enc.rozrog_burners)"]
    next: bye
  stopped:
    type: line
    speaker: npc.wencel_burner
    text: "We're on pine. Happy? Go tell your beast, if you speak its tongue."
    next: bye
  bounty:
    type: line
    speaker: npc.wencel_burner
    text: "Dead? Truly? Here. Hundred and twenty. Swan-stamped, some of it. Spend it before you ask where it came from."
    effects: ["add_crowns(120)", "set_flag(flag.rozrog_bounty_paid)", "play_beat(bounty_paid)"]
    next: bye
  after_dead:
    type: line
    speaker: npc.wencel_burner
    text: "We'll have the whole ring down by spring. Good oak, that."
    next: bye
  after_peace:
    type: line
    speaker: npc.wencel_burner
    text: "Nothing's come out of those trees since. The lads say the girl planted acorns. Fine by me, so long as nothing tears my arm off."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.ottla_signs
participants: [npc.ottla]
start: greet
nodes:
  greet:
    type: line
    speaker: player
    text: "A girl, crouched in the hazel. She holds up a carved disc: an oak tree. Then another: an axe with a broken haft."
    direction: "Ottla does not speak. She watches the player's hands and the sword."
    next: hub
  hub:
    type: choice
    options:
      - id: who
        text: "Who are you? Are you alone out here?"
        next: who_answer
      - id: beast
        text: "The beast. Is it yours?"
        next: beast_answer
      - id: how
        text: "How do I make it stop killing?"
        next: how_answer
      - id: stopped
        text: "The burners have stopped cutting oak."
        condition: "flag(flag.burners_stop_cutting)"
        next: stopped_answer
      - id: hunt
        text: "Wencel is paying me to kill it."
        condition: "flag(flag.rozrog_hunt)"
        next: hunt_answer
      - id: leave
        text: "I'll go."
        next: bye
  who_answer:
    type: line
    speaker: player
    text: "She scratches in the dirt with a stick: a baby, the oaks around it, a big hairy shape standing over it. Then she points at herself."
    next: hub
  beast_answer:
    type: line
    speaker: player
    text: "She shakes her head. Not hers. She draws the shape again, then the oaks, then puts her hand flat on her chest. It belongs to the trees, and so does she."
    next: hub
  how_answer:
    type: line
    speaker: player
    text: "She holds up the axe disc and snaps a twig. Then an acorn, pressed into the ground. Then an open hand. Stop the axes. Plant. Give back what was taken."
    effects: ["set_flag(flag.ottla_signs_read)"]
    next: hub
  stopped_answer:
    type: line
    speaker: player
    text: "She points at the heartwood stacked by the camp, then at the stumps in the ring. Bring it back. She takes a fistful of acorns from her apron and holds it out."
    effects: ["set_flag(flag.ottla_signs_read)"]
    next: hub
  hunt_answer:
    type: line
    speaker: player
    text: "She goes very still. Then she holds up the eye disc, turns it to face the player, and walks away into the hazel."
    next: bye
  bye:
    type: end
```

The player character voices Ottla's signs. This keeps her mute in data: every `speaker` is `player`, and the lines read the carved signs aloud, in place of spoken text.

## 6. Encounters

```yaml encounter
id: enc.rozrog_woodwose
zone: zone.rozrog_sacred_grove
enemies:
  - {enemy: enemy.woodwose, count: 1, spawn: ring_north, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: grove_edge_cp
avoidable_by: ["dlg.wencel_burner", "dlg.ottla_signs"]
on_won: ["set_flag(flag.woodwose_dead)"]
on_yielded: []
on_player_fled: []
```

The woodwose fights in the oak ring. It charges, grabs and slams, tears up root-snares, and throws standing-stone chips. It is `heavy`: hits below 25 poise do not stagger it (gdd §6.7). It is weak to fire (`f:w`). The bracken bed in its lair catches fire from fire damage, which helps the player but also burns them. The stream puts Burning out. The beast enters from `ring_north`, on the far side of the ring.

**Non-combat alternative:** stop the cutting (any of the five Wencel options), read Ottla's signs, and lay heartwood at the stump scar. The fight never happens: `woodwose_territory` checks `not flag(flag.burners_stop_cutting)`. Even then the player can still call the beast out at the lair to fight it.

```yaml encounter
id: enc.rozrog_burners
zone: zone.rozrog_charcoal_camp
enemies:
  - {enemy: enemy.bandit, count: 3, spawn: road_in, variant: charcoal_burner}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.bandit, count: 1, spawn: road_in, variant: charcoal_burner}]}
attack_tokens: null
allow_yield: true
allies: []
checkpoint: camp_huts
avoidable_by: ["dlg.wencel_burner"]
on_won: ["set_flag(flag.burners_driven_off)", "set_flag(flag.burners_stop_cutting)"]
on_yielded: ["set_flag(flag.burners_driven_off)", "set_flag(flag.burners_stop_cutting)"]
on_player_fled: []
```

Wencel is the second-wave bandit (axe). The gang fight among the clamps, where the smoke halves vision and the crust burns. Yielding burners beg and run. Driving them off counts as stopping the cutting, and the peace route stays open.

```yaml encounter
id: enc.rozrog_choir_carters
zone: zone.rozrog_charcoal_camp
enemies:
  - {enemy: enemy.choir_zealot, count: 1, spawn: road_in, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: road_in, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies:
  - {ally: npc.wencel_burner, condition: "flag(flag.wencel_turned)"}
checkpoint: camp_track
avoidable_by: []
on_won: ["set_flag(flag.rozrog_carters_dealt)", "give_item(item.pale_feather, 1)"]
on_yielded: ["set_flag(flag.rozrog_carters_dealt)", "give_item(item.pale_feather, 1)"]
on_player_fled: ["set_flag(flag.rozrog_carters_dealt)"]
```

This fires only at stage 3, and only once the burners have stopped. The stage 3 rule adds one Choir member. If `flag.wencel_turned`, Wencel fights beside the player (listed in `allies`; presentation should spawn him only when the flag is set). The zealot self-immolates at 0 HP (gdd §6.7), so fighting near the wagon of charcoal is dangerous: the wagon can catch.

## 7. Items and clues

```yaml item
id: item.oak_heartwood
name: "Split of oak heartwood"
category: key
description: "A dense red-brown split from the heart of a grove oak, still wet with sap. Too good to burn."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml clue
id: clue.choir_charcoal_orders
theory: theory.choir
title: "Charcoal for the grey buyers"
text: "Grey-robed buyers pay Abbey silver by the cartload for oak charcoal, the hottest burn, and carry it south-east toward the Amell. Blasting powder needs charcoal."
supports: []
refutes: []
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: flag.woodwose_peace, type: bool, desc: "Peace made with the woodwose (gdd). The woodwose is peaceful."}
  - {id: flag.woodwose_dead, type: bool, desc: "The woodwose was killed."}
  - {id: flag.burners_stop_cutting, type: bool, desc: "The charcoal burners no longer cut the grove oaks (talked, paid, ordered, or driven off)."}
  - {id: flag.burners_driven_off, type: bool, desc: "The burners were beaten and fled Rozrog."}
  - {id: flag.wencel_turned, type: bool, desc: "Wencel learned his buyers are Choir and refuses them."}
  - {id: flag.rozrog_met_wencel, type: bool, desc: "The player has spoken to Wencel."}
  - {id: flag.rozrog_hunt, type: bool, desc: "The player accepted Wencel's bounty on the beast."}
  - {id: flag.rozrog_bounty_paid, type: bool, desc: "Wencel paid the 120-crown bounty."}
  - {id: flag.ottla_signs_read, type: bool, desc: "Ottla showed the player how to make the offering."}
  - {id: flag.rozrog_carters_dealt, type: bool, desc: "The stage 3 Choir carters were fought or fled."}
reads:
  - flag.rozrog_hook
  - ded.choir_exists
  - ms.act1_complete
  - ms.act2_twist
```

## 9. Quest hooks

```yaml quest
id: quest.side_rozrog
kind: side
title: "The Woodwose of Rozrog"
giver: npc.wencel_burner
available: "ms(ms.act1_complete)"
closes_on: "ms(ms.act2_twist)"
xp: 400
stages:
  - id: the_burners
    journal: "Charcoal burners in Rozrog say a beast in the old oak grove has killed two of their men. Their boss, Wencel, wants it dead."
    objectives:
      - {id: meet, text: "Speak to Wencel at the charcoal camp", condition: "flag(flag.rozrog_met_wencel) or flag(flag.burners_driven_off)", optional: false}
      - {id: orders, text: "Find out who buys the charcoal", condition: "has_clue(clue.choir_charcoal_orders)", optional: true, xp: 30}
    on_complete: []
    next: []
  - id: the_choice
    journal: "The burners are felling a sacred grove because grey-robed buyers pay ten times for oak. The beast is defending its trees. A mute girl lives at the grove's edge."
    objectives:
      - {id: choose, text: "Stop the cutting, or kill the beast", condition: "flag(flag.burners_stop_cutting) or flag(flag.woodwose_dead)", optional: false}
    on_complete: []
    next: []
  - id: settled
    journal: "One way or another, Rozrog's grove is settled."
    objectives:
      - {id: resolve, text: "Make the offering at the stumps, or end the beast", condition: "flag(flag.woodwose_peace) or flag(flag.woodwose_dead)", optional: false}
      - {id: bounty, text: "Collect Wencel's bounty", condition: "flag(flag.rozrog_bounty_paid)", optional: true, xp: 20}
      - {id: carters, text: "Deal with the grey carters", condition: "flag(flag.rozrog_carters_dealt)", optional: true, xp: 40}
    on_complete: []
    next: []
outcome_effects:
  completed: []
  failed: []
```

## 10. Rumors and event cards (optional)
None here. The hook card (valley slot 7, "Woodwose totems") and `rumor.r17_rozrog_woodwose` are in 13 and 14.

## 11. Failure states and branches

```yaml branches
paths:
  - id: peace
    when: "Burners stop cutting (Persuade 6, Intimidate 6, Bribe 50, feather/clue, writ with Crown Friendly, or driven off), Ottla's signs read, heartwood laid at the stumps."
    outcome: "flag.woodwose_peace; ally.forest_guide (Ottla) joins; Rozrog camp burns pine."
    sets: ["set_flag(flag.woodwose_peace)", "add_ally(ally.forest_guide)"]
  - id: kill
    when: "Player kills the woodwose (in the ring while cutting continues, or by calling it out at the lair)."
    outcome: "flag.woodwose_dead; Wencel pays 120 if not driven off; Ottla leaves; no guide."
    sets: ["set_flag(flag.woodwose_dead)"]
  - id: drive_off
    when: "Player fights the gang out of Rozrog."
    outcome: "flag.burners_driven_off and flag.burners_stop_cutting; peace still possible; no bounty."
    sets: ["set_flag(flag.burners_driven_off)", "set_flag(flag.burners_stop_cutting)"]
failures:
  - id: player_dies_woodwose
    result: reload_checkpoint
    recover: "Reload grove_edge_cp."
  - id: player_dies_burners
    result: reload_checkpoint
    recover: "Reload camp_huts."
  - id: all_wencel_checks_failed
    result: soft_fail
    recover: "Bribe 50, the feather/clue option, the writ, or driving them off remain; the hunt is always available."
  - id: grove_entered_early
    result: soft_fail
    recover: "Entering the ring before the cutting stops starts the woodwose fight; retreat to grove_edge ends it via exit (encounter on_player_fled is empty); talk to Wencel and return."
guarantees:
  - "quest.side_rozrog completable with no check: drive the burners off (fight) or kill the woodwose (fight)."
  - "Peace reachable with no check: drive the burners off (fight), ask Ottla 'How do I make it stop killing?' (no check), pick up heartwood (no check), lay it at the stumps."
```

## 12. Open questions
- `enemy.bandit` variant `charcoal_burner` (axe, no shield, low armor) is a new data variant. gdd §6.7 lists sword, spear and shield variants "by data", so this needs adding to the enemy data.
- `npc.choir_carter` uses `enemy.choir_zealot` as its combat profile, while the encounter lists the zealot directly. The npc block exists only for barks and placement at stage 3.
- Wencel as an ally (resolved by A08): `{ally: npc.wencel_burner, condition: "flag(flag.wencel_turned)"}` (content-format §J.4).
