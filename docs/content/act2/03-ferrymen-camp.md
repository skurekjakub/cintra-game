---
section_id: a2.03
title: "Ferrymen's Camp"
act: 2
story_ref: "story.md §3 Ninefingers Jory, §6 Ferrymen's Camp, §11 rumor 7"
zones: [zone.ferrymen_camp]
available_when: "ms(ms.act1_complete) and not ms(ms.act2_twist)"
escalation_stage_required: {min: 1, max: 3}
milestones_set: [ms.a2_jory_dealt, ms.a2_cipher_taken]
milestones_read: [ms.a2_jory_dealt, ms.act1_complete, ms.act2_twist]
level_band: [5, 7]
---

# Ferrymen's Camp

## 1. Scene summary
Ninefingers Jory runs every crossing on the middle Marnadal from a camp of barges lashed nose-to-bank into a wooden wall. His floating hall is a fat grain barge called the *Lamprey*. For months his boats have carried humming ironbound crates across the river for St. Corwen and handed them to hooded monks on the Vel Aram track. Lately the cargo has frightened him: two boatmen who prised one open died coughing black. The player needs three things from him: the truth about the crates (`clue.jory_iron_crates`), passage across the river (`flag.jory_crossing_granted`), and his goodwill if they later want a safe escort for Wenna's antidote. Jory can be bribed, frightened, reasoned with, hired out (clearing drowners from his eel weirs), or overthrown by storming the camp. If the Oak courier escaped in `a2.02`, Jory's men robbed him at the crossing, and Jory now holds Anselm's cipher for sale. The dramatic question: how far will the player go to buy a bandit's loyalty, and what does that loyalty cost the people downriver? The section ends at `ms.a2_jory_dealt`.

## 2. Progress and escalation
- `ms.a2_jory_dealt` is set when Jory admits the crate trade by any route: bribe, persuasion, intimidation, the weir job, or storming the camp (taking the manifest from his strongbox).
- `ms.a2_cipher_taken` is also set here if the player buys or takes the cipher (only when `flag.oak_courier_escaped`).
- `flag.jory_crossing_granted` opens the `ferrymen_camp — marnadal_field` edge without the ford hazard.
- Ferrymen reputation tiers drive later content. **Friendly** gives the rider escort in `a2.05` (`flag.rider_escort_hired`). **Allied** opens the `ferrymen_camp ~ attre` barge edge (map rule, gdd §7.5).
- **Stage 1:** base camp. **Stage 2:** the river runs dark with mineral silt; the weirs are choked with black sludge (`deep_mud` hazard spreads to the shallows); boatmen grumble that the Choir has poisoned the river. **Stage 3:** two Choir zealots stand openly on the landing, haggling with Jory for the next run (`enc.ferry_choir_agents`) if Jory has not been dealt with yet.

## 3. Location layout
Dusk, exterior, about 200 × 140 m of the Marnadal's north bank, river flowing west to east.
- **Toll landing:** where the Tigg track meets the river. A chain across the track between two posts, a toll hut, two toll-men. Player entry. Open mud with stacked eel-traps for low cover.
- **Barge wall:** a stockade of five old hulls stood on end and roped together, enclosing the camp. One gap (the **gate**) faces the landing. The hulls are climbable at the east end (a broken rib, crouch-height gap), which is the stealth route in.
- **Camp yard:** 40 × 30 m inside the wall. Tents, cookfires, a **dog pit** (a sunken ring where boatmen bet on fights), racks of drying eels (soft cover).
- **The Lamprey:** Jory's floating hall, moored to the yard's south edge by two gangplanks. Deck with a brazier and a long table; aft **cabin** with Jory's map table and an iron-banded strongbox.
- **Crate shed:** a plank shed on stilts at the yard's west end, padlocked, guarded by Bollard. Inside, one last Choir crate, which hums faintly when touched.
- **Rope ferry:** a flat ferry on a tarred cable to the south bank, wound by a winch house. Using it, with leave or by force, is the crossing.
- **Eel weirs:** 150 m downstream along a bank path. Wicker weirs across the shallows, a drowned skiff, flooded reeds (`deep_mud`). Drowners nest here. Marit's hut stands on piles at the path's start.

Intended route: landing → gate → yard → the *Lamprey* (Jory). The weirs and the shed are side branches.

```yaml zone
id: zone.ferrymen_camp
name: "Ferrymen's Camp"
kind: exterior
map_node: map.ferrymen_camp
time_of_day: dusk
cold_rate: 0
disguise_tag: null
music: river_camp
areas:
  - {id: toll_landing, description: "Track meets river. Chain across the road, toll hut, stacked eel-traps (low cover). Player entry."}
  - {id: barge_wall, description: "Five hulls on end roped into a stockade. Gate gap facing the landing; climbable broken rib at the east end."}
  - {id: camp_yard, description: "40 x 30 m: tents, cookfires, drying-eel racks (soft cover), the dog pit (sunken ring)."}
  - {id: lamprey_deck, description: "Jory's grain barge. Deck with brazier and long table, two gangplanks to the yard."}
  - {id: lamprey_cabin, description: "Aft cabin: map table, Jory's chair, iron-banded strongbox."}
  - {id: crate_shed, description: "Plank shed on stilts, padlocked. One ironbound Choir crate inside that hums when touched."}
  - {id: rope_ferry, description: "Flat ferry on a tarred cable and the winch house. The crossing south."}
  - {id: weir_path, description: "Bank path 150 m downstream. Marit's hut on piles at the start."}
  - {id: eel_weirs, description: "Wicker weirs across the shallows, a drowned skiff, flooded reeds. Drowner nest."}
spawns:
  - {id: toll_landing, area: toll_landing, default: true}
  - {id: ferry_arrival, area: rope_ferry}
  - {id: weir_reeds, area: eel_weirs}
  - {id: yard_tents, area: camp_yard}
  - {id: lamprey_aft, area: lamprey_deck}
exits: []
interactables:
  - id: travel_marker
    area: toll_landing
    kind: map_board
    label: "Leave by the Tigg track (travel)"
    condition: "true"
    check: null
    once: false
    effects: []
  - id: ferry_winch
    area: rope_ferry
    kind: map_board
    label: "Cross on the rope ferry (travel south)"
    condition: "flag(flag.jory_crossing_granted)"
    check: null
    once: false
    effects: []
  - id: shed_door
    area: crate_shed
    kind: door
    label: "Force the shed's padlock"
    condition: "not flag(flag.crate_shed_opened) and not ms(ms.a2_jory_dealt)"
    check: null
    once: true
    effects: ["set_flag(flag.crate_shed_opened)", "add_rep(faction.ferrymen, -10)", "play_beat(bollard_shouts)"]
  - id: choir_crate
    area: crate_shed
    kind: search
    label: "Prise open the humming crate"
    condition: "flag(flag.crate_shed_opened) or ms(ms.a2_jory_dealt)"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["add_clue(clue.dwarven_chain_crate)"]
    fail_effects: ["damage_player(10)"]
  - id: strongbox
    area: lamprey_cabin
    kind: container
    label: "Break open Jory's strongbox"
    condition: "flag(flag.jory_dead)"
    check: null
    once: true
    effects: ["give_item(item.jory_manifest, 1)", "add_clue(clue.jory_iron_crates)", "add_crowns(150)", "reach_milestone(ms.a2_jory_dealt)"]
  - id: strongbox_cipher
    area: lamprey_cabin
    kind: container
    label: "Take the monk's satchel from the strongbox"
    condition: "flag(flag.jory_dead) and flag(flag.oak_courier_escaped) and not has_item(item.anselm_cipher)"
    check: null
    once: true
    effects: ["give_item(item.anselm_cipher, 1)", "give_item(item.oak_orders, 1)", "add_clue(clue.anselm_cipher)", "reach_milestone(ms.a2_cipher_taken)"]
  - id: map_table
    area: lamprey_cabin
    kind: readable
    label: "Study Jory's river chart"
    condition: "true"
    check: null
    once: true
    effects: ["add_map_pin(map.grey_ferry)", "add_map_pin(map.witchs_mere)"]
  - id: drowned_skiff
    area: eel_weirs
    kind: search
    label: "Search the drowned skiff"
    condition: "flag(flag.weir_cleared)"
    check: null
    once: true
    effects: ["give_item(item.tamas_ring, 1)"]
  - id: camp_fire
    area: camp_yard
    kind: rest
    label: "Sit at the boatmen's fire (rest)"
    condition: "rep_tier(faction.ferrymen) >= neutral and not flag(flag.jory_dead)"
    check: null
    once: false
    effects: ["heal_player(full)", "set_checkpoint(camp_rest)"]
triggers:
  - id: meet_at_gate
    area: barge_wall
    on: enter
    source: null
    condition: "not flag(flag.jory_met) and not flag(flag.jory_dead)"
    once: true
    effects: ["set_flag(flag.jory_met)", "start_dialogue(dlg.bollard_gate)"]
  - id: weirs_attack
    area: eel_weirs
    on: enter
    source: null
    condition: "not flag(flag.weir_cleared)"
    once: false
    effects: ["set_checkpoint(weir_path_cp)", "start_encounter(enc.weir_drowners)"]
  - id: choir_agents_present
    area: toll_landing
    on: enter
    source: null
    condition: "stage() >= 3 and not ms(ms.a2_jory_dealt) and not flag(flag.jory_choir_agents_dealt)"
    once: true
    effects: ["play_beat(choir_haggling)"]
hazards:
  - {id: weir_shallows, area: eel_weirs, kind: deep_mud, params: {speed_mult: 0.6}}
  - {id: dog_pit_drop, area: camp_yard, kind: trap, params: {fall_damage: 5}}
checkpoints:
  - {id: camp_arrival, area: toll_landing}
  - {id: camp_rest, area: camp_yard}
  - {id: weir_path_cp, area: weir_path}
beats:
  - {id: bollard_shouts, description: "Bollard bellows from the yard. Boatmen look up from the fires; nobody draws yet."}
  - {id: choir_haggling, description: "Two zealots in grey stand on the landing arguing silver with Jory, who sees the player and smiles."}
  - {id: jory_yields, description: "Jory, bloody, sits down on his own deck and holds up his remaining nine fingers."}
  - {id: ferry_taken, description: "With Jory dead, the player kicks the winch-house door open. The ferry is the player's now."}
npcs:
  - {npc: npc.jory, area: lamprey_deck, condition: "not flag(flag.jory_dead) and not (stage() >= 3 and not ms(ms.a2_jory_dealt) and not flag(flag.jory_choir_agents_dealt))"}
  - {npc: npc.jory, area: toll_landing, condition: "stage() >= 3 and not ms(ms.a2_jory_dealt) and not flag(flag.jory_choir_agents_dealt)"}
  - {npc: npc.bollard, area: barge_wall, condition: "not flag(flag.jory_dead)"}
  - {npc: npc.marit, area: weir_path, condition: "true"}
encounters: [enc.weir_drowners, enc.ferry_camp_assault, enc.ferry_choir_agents]
loot:
  - {container: strongbox, items: [{item: item.field_draught, count: 2}], condition: "true"}
variants:
  - id: dark_river
    when: "stage() >= 2"
    description: "The river runs dark with silt; black sludge clogs the weirs. Boatmen spit and swear the Choir has poisoned the water."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: camp_taken
    when: "flag(flag.jory_dead)"
    description: "The surviving boatmen have fled downriver. Cookfires cold, the Lamprey's deck bloody, the ferry yours."
    npcs_absent: [npc.jory, npc.bollard]
    encounters_disabled: [enc.ferry_camp_assault, enc.ferry_choir_agents]
    interactables_disabled: [camp_fire]
  - id: weirs_clear
    when: "flag(flag.weir_cleared)"
    description: "The weirs are mended; two boatmen tend the traps again."
    npcs_absent: []
    encounters_disabled: [enc.weir_drowners]
    interactables_disabled: []
```

## 4. NPCs present
**Voice notes.** Jory: amiable, never raises his voice, counts everything aloud (crowns, men, fingers). The story of his missing finger changes every time he tells it. He is frightened of the crates and hides it under jokes. Bollard: huge, slow-spoken, loyal, calls Jory "the Chief". Marit: hard, grieving, angry at Jory for sending her husband to mend the weirs with drowners in them.

```yaml npc
id: npc.jory
name: "Ninefingers Jory"
faction: faction.ferrymen
role: "River-bandit kingpin of the Marnadal crossings"
motive: "Keep the river's silver flowing and his own neck unstretched."
secret: "Two of his boatmen died coughing black after opening a Choir crate. He wants out of the trade and fears what the Choir does to men who quit."
disposition: neutral
essential: false
dialogue: dlg.jory
barks: ["Nine, ten... no, nine.", "Everything has a toll, friend.", "Silver's silver. Doesn't ask whose."]
combat: enemy.bandit
shop: null
```

```yaml npc
id: npc.bollard
name: "Bollard"
faction: faction.ferrymen
role: "Jory's lieutenant and gate-keeper"
motive: "Do what the Chief says. Keep the crate shed shut."
secret: "He was the one who carried the two dead boatmen out of the shed. He won't go near the crate."
disposition: wary
essential: false
dialogue: dlg.bollard_gate
barks: ["Chief's on the boat.", "Shed's shut.", "Mind the dogs."]
combat: enemy.bandit
shop: null
```

```yaml npc
id: npc.marit
name: "Marit"
faction: null
role: "Boatman's widow at the eel weirs"
motive: "Get her husband Tamas out of the water and spit in Jory's eye."
secret: "She knows the drowners came when the river turned dark, and that Jory sent Tamas anyway."
disposition: wary
essential: true
dialogue: dlg.marit
barks: ["He's still out there.", "Jory's silver. Jory's river. Jory's dead men.", "Don't go in the reeds."]
combat: null
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.bollard_gate
participants: [npc.bollard]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.bollard
    text: "Toll's for crossing. Talk's for the Chief. Chief's on the boat. Leave the steel sheathed in the yard."
    direction: "Blocking the gate gap with his whole body, then stepping aside."
    next: hub
  hub:
    type: choice
    options:
      - id: shed
        text: "What's in the shed?"
        next: shed
      - id: go
        text: "Take me to Jory."
        next: bye
  shed:
    type: line
    speaker: npc.bollard
    text: "Nothing you want. Nothing I want. Ask the Chief."
    direction: "He doesn't look at it."
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.jory
participants: [npc.jory]
start: greet
nodes:
  greet:
    type: branch
    cases:
      - {if: "flag(flag.jory_yielded)", next: greet_beaten}
      - {if: "ms(ms.a2_jory_dealt)", next: greet_after}
      - {if: "flag(flag.weir_cleared) and flag(flag.weir_job_taken)", next: weir_paid}
      - {if: "stage() >= 3 and not flag(flag.jory_choir_agents_dealt)", next: greet_agents}
    else: greet_first
  greet_first:
    type: line
    speaker: npc.jory
    text: "Ninefingers Jory. Don't count them, everyone counts them. Lost the tenth to a pike. Or a husband. Crossing's thirty crowns a head. Anything else costs more."
    direction: "Feet on the long table, a cup of something hot, counting coins in stacks of nine."
    next: hub
  greet_agents:
    type: line
    speaker: npc.jory
    text: "Ah. Company. These fine brothers were just leaving. Weren't you, brothers? No? Then perhaps my friend here can help you leave."
    direction: "On the toll landing between two grey-robed zealots, all smiles."
    next: agents_choice
  agents_choice:
    type: choice
    options:
      - id: fight
        text: "Off the landing, brothers. Now."
        next: agents_fight
      - id: wait
        text: "Finish your business, Jory. I'll wait on your boat."
        next: hub
  agents_fight:
    type: effect
    effects: ["set_checkpoint(camp_arrival)", "start_encounter(enc.ferry_choir_agents)"]
    next: bye
  greet_after:
    type: line
    speaker: npc.jory
    text: "Back again. You're bad for business and good for my nerves, and I can't decide which I mind more. What is it?"
    next: hub
  greet_beaten:
    type: line
    speaker: npc.jory
    text: "You again. Still nine. Still breathing. Say what you want and let me bleed in peace."
    next: hub
  weir_paid:
    type: line
    speaker: npc.jory
    text: "The weirs are clear. My lads say you waded in like you were born to it. A deal's a deal. Sit. Drink. Ask."
    effects: ["clear_flag(flag.weir_job_taken)", "add_rep(faction.ferrymen, 25)", "set_flag(flag.jory_crossing_granted)"]
    next: confess
  hub:
    type: choice
    options:
      - id: toll
        text: "Thirty crowns for the crossing, then. [Bribe 30]"
        tag: bribe
        condition: "not flag(flag.jory_crossing_granted)"
        bribe: 30
        next: toll_paid
      - id: crates
        text: "The iron crates you carry for the Abbey. Tell me about them."
        condition: "not ms(ms.a2_jory_dealt)"
        next: crates
      - id: cipher
        text: "A monk crossed here in a hurry, on a lathered horse. What did your men take off him?"
        condition: "flag(flag.oak_courier_escaped) and not has_item(item.anselm_cipher)"
        next: cipher
      - id: invitation
        text: "I hear you can get a man into Duke Raimund's masquerade."
        condition: "not has_item(item.masquerade_invitation)"
        next: invitation
      - id: escort
        text: "If I needed something carried fast and safe down the valley..."
        condition: "ms(ms.a2_jory_dealt)"
        next: escort
      - id: bertha
        text: "About Bertha's debt. The Drowned Rat."
        condition: "quest_active(quest.side_bertha_debt)"
        next: bertha
      - id: widow
        text: "[Item: Tamas's ring] Marit's husband. You sent him into the weirs."
        tag: item
        condition: "has_item(item.tamas_ring)"
        next: widow
      - id: leave
        text: "That's all."
        next: bye
  toll_paid:
    type: line
    speaker: npc.jory
    text: "Thirty. Lovely. Bollard! Let this one on the ferry whenever they like. A friend of the river."
    effects: ["set_flag(flag.jory_crossing_granted)", "add_rep(faction.ferrymen, 5)"]
    next: hub
  crates:
    type: line
    speaker: npc.jory
    text: "I carry what pays. Grain, wool, wine, holy relics, a bishop's mistress once. Crates? Lots of crates. Which crates?"
    direction: "His smile stays. His hand stops counting."
    next: crates_hub
  crates_hub:
    type: choice
    options:
      - id: beaten
        text: "You're sitting in your own blood, Jory. The crates."
        condition: "flag(flag.jory_yielded)"
        next: confess
      - id: bribe
        text: "[Bribe 100] The ones that hum. Here's a hundred reasons to remember."
        tag: bribe
        bribe: 100
        next: confess_bought
      - id: persuade
        text: "[Persuade 8] Two of your men died coughing black. When the Choir is done with this river, what do you think they'll need ferrymen for?"
        tag: persuade
        check: {skill: persuade, dc: 8, pass: confess_reasoned, fail: crates_fail}
      - id: dead_men
        text: "[Clue: Dwarven chain crate] [Persuade 6] I've seen what's in your shed. Dwarven chain and a furnace grate. That's not a relic. That's a machine."
        tag: clue
        condition: "has_clue(clue.dwarven_chain_crate)"
        check: {skill: persuade, dc: 6, pass: confess_reasoned, fail: crates_fail}
      - id: intimidate
        text: "[Intimidate 8] The Marshal burns traitors' boats with the traitors tied to the masts. Every barge on this river. Talk."
        tag: intimidate
        check: {skill: intimidate, dc: 8, pass: confess_scared, fail: crates_fail}
      - id: intimidate_proof
        text: "[Clue: Hooded monks] [Intimidate 6] Tigg saw your crates go south on poles. I can name the road and the night. So can the Marshal."
        tag: intimidate
        condition: "has_clue(clue.tigg_monks_south) or ded(ded.choir_muster_vel_aram)"
        check: {skill: intimidate, dc: 6, pass: confess_scared, fail: crates_fail}
      - id: sway
        text: "[Sway] You want out, Jory. I'm the door. Tell me and the Crown remembers who helped."
        tag: sway
        condition: "perk(perk.kingmaker)"
        next: confess_reasoned
      - id: job
        text: "What would it take, besides silver?"
        condition: "not flag(flag.weir_job_taken) and not flag(flag.weir_cleared)"
        next: job
      - id: storm
        text: "I'm done asking."
        next: storm_confirm
      - id: back
        text: "Never mind the crates."
        next: hub
  crates_fail:
    type: line
    speaker: npc.jory
    text: "Lovely speech. Do it again with fewer words. Or more silver."
    next: crates_hub
  job:
    type: line
    speaker: npc.jory
    text: "Drowners in my eel weirs since the river went bad. They took Tamas and his boy's skiff. Clear the weirs and we'll talk crates like old friends."
    effects: ["set_flag(flag.weir_job_taken)"]
    next: crates_hub
  storm_confirm:
    type: choice
    options:
      - id: confirm
        text: "(Draw steel. This will turn the whole camp against you.)"
        next: storm
      - id: back
        text: "(Not yet.)"
        next: crates_hub
  storm:
    type: effect
    effects: ["set_checkpoint(camp_arrival)", "add_rep(faction.ferrymen, -40)", "start_encounter(enc.ferry_camp_assault)"]
    next: bye
  confess_bought:
    type: line
    speaker: npc.jory
    text: "A hundred. You're a poet. All right, quiet now."
    effects: ["add_rep(faction.ferrymen, 10)", "set_flag(flag.jory_crossing_granted)"]
    next: confess
  confess_reasoned:
    type: line
    speaker: npc.jory
    text: "You've a mean way of saying what I think at night. Fine. Fine."
    effects: ["add_rep(faction.ferrymen, 10)", "set_flag(flag.jory_crossing_granted)"]
    next: confess
  confess_scared:
    type: line
    speaker: npc.jory
    text: "There's no need for masts. Sit down. Please. Sit down."
    effects: ["add_rep(faction.ferrymen, -20)", "set_flag(flag.jory_crossing_granted)"]
    next: confess
  confess:
    type: line
    speaker: npc.jory
    text: "Since spring. Ironbound crates from St. Corwen's cellarer, sealed with the Abbey lion. We cross them at night and hand them to hooded brothers on the Vel Aram track. They pay in Abbey silver, bars cut small."
    next: confess_2
  confess_2:
    type: line
    speaker: npc.jory
    text: "Some of them hum. Like a hive. Two of my lads opened one in the shed and coughed black for a day and died. I've one left in there. I won't touch it. Take it if you like."
    effects: ["add_clue(clue.jory_iron_crates)", "give_item(item.jory_manifest, 1)", "verify_rumor(rumor.r07_iron_crates)", "reach_milestone(ms.a2_jory_dealt)"]
    next: hub
  cipher:
    type: branch
    cases:
      - {if: "rep_tier(faction.ferrymen) >= neutral or flag(flag.jory_yielded)", next: cipher_offer}
    else: cipher_refuse
  cipher_refuse:
    type: line
    speaker: npc.jory
    text: "A monk? I see lots of monks. My memory improves with friends. Which you're not."
    next: hub
  cipher_offer:
    type: line
    speaker: npc.jory
    text: "Took his satchel as toll, let him ride on. Brass wheel and papers I can't read. I'd guess someone pays well for it. A hundred and twenty, and it's yours."
    next: cipher_choice
  cipher_choice:
    type: choice
    options:
      - id: pay
        text: "[Bribe 120] Done."
        tag: bribe
        bribe: 120
        next: cipher_sold
      - id: beaten
        text: "You'll give it to me for nothing, Jory. You owe me your fingers."
        condition: "flag(flag.jory_yielded)"
        next: cipher_sold
      - id: no
        text: "Too rich for me."
        next: hub
  cipher_sold:
    type: line
    speaker: npc.jory
    text: "Pleasure. If anyone asks, it fell off a boat."
    effects: ["give_item(item.anselm_cipher, 1)", "give_item(item.oak_orders, 1)", "add_clue(clue.anselm_cipher)", "reach_milestone(ms.a2_cipher_taken)"]
    next: hub
  invitation:
    type: line
    speaker: npc.jory
    text: "A wine merchant from Attre crossed with me. He's swimming home now, and I've his invitation to the Duke's masquerade. Sixty crowns. Wear a good mask."
    next: invitation_choice
  invitation_choice:
    type: choice
    options:
      - id: buy
        text: "[Bribe 60] I'll take it."
        tag: bribe
        bribe: 60
        next: invitation_sold
      - id: no
        text: "Not today."
        next: hub
  invitation_sold:
    type: line
    speaker: npc.jory
    text: "Lovely. Don't drink the green wine. It's the Duke's joke."
    effects: ["give_item(item.masquerade_invitation, 1)"]
    next: hub
  escort:
    type: branch
    cases:
      - {if: "rep_tier(faction.ferrymen) >= friendly", next: escort_yes}
    else: escort_no
  escort_yes:
    type: line
    speaker: npc.jory
    text: "My boats go where riders die. Send word from wherever you are and a skiff with four oars and two crossbows will carry it. For a friend of the river, no charge."
    next: hub
  escort_no:
    type: line
    speaker: npc.jory
    text: "For friends I'd lend boats. You're a customer. Customers ride."
    next: hub
  bertha:
    type: effect
    effects: ["start_dialogue(dlg.jory_bertha_debt)"]
    next: bye
  widow:
    type: line
    speaker: npc.jory
    text: "I know. I know what I did. Give it to her, not me. Tell her... no. Don't tell her anything from me."
    direction: "For once he doesn't count anything."
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.jory_yielded
participants: [npc.jory]
start: yield
nodes:
  yield:
    type: line
    speaker: npc.jory
    text: "Enough! Enough. Nine fingers, see? I'd like to keep nine. Whatever you came for, you can have."
    direction: "Sitting on his own deck, bleeding, hands up."
    next: hub
  hub:
    type: choice
    options:
      - id: spare
        text: "The crates. Everything. Then you live."
        next: spare
      - id: kill
        text: "(Kill him.)"
        next: kill
  spare:
    type: effect
    effects: ["set_flag(flag.jory_yielded)", "set_flag(flag.jory_crossing_granted)", "start_dialogue(dlg.jory)"]
    next: bye
  kill:
    type: effect
    effects: ["set_flag(flag.jory_dead)", "set_flag(flag.jory_crossing_granted)", "add_rep(faction.ferrymen, -40)", "play_beat(ferry_taken)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.marit
participants: [npc.marit]
start: greet
nodes:
  greet:
    type: branch
    cases:
      - {if: "has_item(item.tamas_ring)", next: ring}
      - {if: "flag(flag.tamas_ring_returned)", next: after}
    else: plain
  plain:
    type: line
    speaker: npc.marit
    text: "If you're Jory's, keep walking. If you're not, there's things in the reeds that took my Tamas. The river went black and they came up out of it."
    next: hub
  hub:
    type: choice
    options:
      - id: drowners
        text: "What are they?"
        next: drowners
      - id: leave
        text: "I'm sorry."
        next: bye
  drowners:
    type: line
    speaker: npc.marit
    text: "Drowners. Grey, long arms, teeth like a pike. They drag you under and hold you till you stop. Fire makes them shriek. So do I, these days."
    next: hub
  ring:
    type: line
    speaker: npc.marit
    text: "That's his. That's Tamas's ring. You went in the reeds for him. Nobody did that. Not Jory, not anyone."
    effects: ["take_item(item.tamas_ring, 1)", "set_flag(flag.tamas_ring_returned)", "add_rep(faction.ferrymen, 10)", "add_xp(60)"]
    next: ring_2
  ring_2:
    type: line
    speaker: npc.marit
    text: "The boatmen will hear of it. They'll think better of you than of him. Take this. It's his skinning knife. He'd want it used."
    effects: ["give_item(item.tamas_knife, 1)"]
    next: bye
  after:
    type: line
    speaker: npc.marit
    text: "The weirs are quiet. I sleep, a little."
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.weir_drowners
zone: zone.ferrymen_camp
enemies:
  - {enemy: enemy.drowner, count: 3, spawn: weir_reeds, variant: null}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.drowner, count: 2, spawn: weir_reeds, variant: null}]}
attack_tokens: null
allow_yield: false
allies: []
checkpoint: weir_path_cp
avoidable_by: []
on_won: ["set_flag(flag.weir_cleared)"]
on_yielded: []
on_player_fled: []
```
Design: the drowners ambush from the flooded reeds (gdd §6.7: drag grab, broken by a kick). The wicker weirs are narrow walkways above knee-deep water: fighting on them avoids the `deep_mud`, but a drag grab pulls the player off. The second wave surfaces from under the drowned skiff.

```yaml encounter
id: enc.ferry_camp_assault
zone: zone.ferrymen_camp
enemies:
  - {enemy: enemy.bandit, count: 3, spawn: yard_tents, variant: sword}
  - {enemy: enemy.bandit, count: 2, spawn: yard_tents, variant: spear}
  - {enemy: enemy.bandit, count: 1, spawn: toll_landing, variant: shield}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.bandit, count: 2, spawn: lamprey_aft, variant: sword}, {enemy: enemy.bandit, count: 1, spawn: lamprey_aft, variant: shield}]}
attack_tokens: null
allow_yield: true
allies: []
checkpoint: camp_arrival
avoidable_by: ["dlg.jory"]
on_won: ["play_beat(jory_yields)", "start_dialogue(dlg.jory_yielded)"]
on_yielded: ["play_beat(jory_yields)", "start_dialogue(dlg.jory_yielded)"]
on_player_fled: ["add_rep(faction.ferrymen, -10)"]
```
Design: wave 1 is the yard crew (the shield variant is Bollard). Wave 2 is Jory and his deck guard on the *Lamprey*; the second shield variant in wave 2 represents Jory himself with his boat-hook and buckler. However the fight ends, it hands over to `dlg.jory_yielded`, where the player decides whether he lives. The dog pit is a `trap` drop in the yard; brazier coals on the deck can be kicked to start a fire.

```yaml encounter
id: enc.ferry_choir_agents
zone: zone.ferrymen_camp
enemies:
  - {enemy: enemy.choir_zealot, count: 2, spawn: toll_landing, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: camp_arrival
avoidable_by: []
on_won: ["set_flag(flag.jory_choir_agents_dealt)", "add_rep(faction.ferrymen, 10)"]
on_yielded: ["set_flag(flag.jory_choir_agents_dealt)", "add_rep(faction.ferrymen, 10)", "add_clue(clue.choir_at_vel_aram)"]
on_player_fled: []
```
Design: stage 3 only. The zealots self-immolate at 0 HP (2 m fire burst). If the fight is kept off the barges, Jory is grateful.

## 7. Items and clues

```yaml item
id: item.jory_manifest
name: "Jory's crossing tally"
category: document
description: "A greasy tally-board copied onto paper: dates as moon-marks, crates as notches, silver as bars."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Abbey lion, cellarer's mark. Crossed south, Vel Aram track: four crates, then six, then three, then nine (two humming). Paid: bars, Abbey stamp, cut small. Two lads dead after the shed. Last crate kept back. Never again. Never again. Again, they paid double."
```

```yaml item
id: item.tamas_ring
name: "Tamas's ring"
category: key
description: "A boatman's pewter ring, green with river slime, from the drowned skiff at the weirs."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.tamas_knife
name: "Tamas's skinning knife"
category: trinket
description: "A short, wicked eel-knife. Light in the hand; every cut finds a gap."
price: 40
stack_max: 1
equip_slot: trinket
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml clue
id: clue.jory_iron_crates
theory: theory.choir
title: "Iron crates across the Marnadal"
text: "Since spring, Jory's barges have carried ironbound crates sealed with the Abbey lion from St. Corwen's cellarer to hooded monks on the Vel Aram track, paid in Abbey silver. Some hum; opening one killed two men."
supports: [anselm]
refutes: []
```

```yaml clue
id: clue.dwarven_chain_crate
theory: theory.anselm_plan
title: "Dwarven chain and a furnace grate"
text: "The last crate in Jory's shed holds chain links the size of a fist and a coal-furnace grate, stamped with Ostrel runes and caked with black soot that burns the throat. Someone is rebuilding a dwarven machine."
supports: [anselm]
refutes: []
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.a2_jory_dealt, type: milestone, desc: "Jory has admitted the crate trade (any route) or the player took his tally by force."}
  - {id: flag.jory_crossing_granted, type: bool, desc: "Free passage on the rope ferry (opens ferrymen_camp - marnadal_field without the ford)."}
  - {id: flag.jory_met, type: bool, desc: "Bollard greeted the player at the gate."}
  - {id: flag.jory_yielded, type: bool, desc: "Jory was beaten and spared."}
  - {id: flag.jory_dead, type: bool, desc: "Jory was killed. Ferrymen effectively Hostile; no rider escort; no barge to Attre."}
  - {id: flag.weir_job_taken, type: bool, desc: "Jory asked the player to clear the eel weirs."}
  - {id: flag.weir_cleared, type: bool, desc: "The drowners at the weirs are dead."}
  - {id: flag.tamas_ring_returned, type: bool, desc: "Marit got her husband's ring back."}
  - {id: flag.crate_shed_opened, type: bool, desc: "The player forced the crate shed."}
  - {id: flag.jory_choir_agents_dealt, type: bool, desc: "The stage-3 Choir agents were driven off the landing."}
reads:
  - flag.oak_courier_escaped
  - clue.tigg_monks_south
  - ded.choir_muster_vel_aram
  - perk.kingmaker
  - rumor.r07_iron_crates
  - quest.side_bertha_debt
```

## 9. Quest hooks
Contributes the optional objective `lead_jory` (and, when the cipher is bought or taken here, `lead_oak`) of `quest.main_a2/the_marnadal_road` (declared in `a2.01`). `clue.jory_iron_crates` unlocks `ded.choir_muster_vel_aram` (declared in `a2.02`), which opens the road to Vel Aram.

Side-quest hook: `quest.side_bertha_debt` (side slice) is resolved by negotiating Bertha's debt with Jory. That quest's own file owns the dialogue; if it is completed, its outcome effects should add Ferrymen reputation. That makes the Friendly tier reachable without the weir job.

## 10. Rumors and event cards (optional)
The ford hazard on the `ferrymen_camp — marnadal_field` edge (`event.ford_marnadal`, gdd §6.3) is owned by the travel-events file. Jory's crossing removes it.

## 11. Failure states and branches

```yaml branches
paths:
  - id: bribe
    when: "Player pays 100 crowns in the crates conversation."
    outcome: "Confession, crossing, tally; Ferrymen +10; ms.a2_jory_dealt."
    sets: ["reach_milestone(ms.a2_jory_dealt)"]
  - id: reason
    when: "Persuade 8, or the chain-crate clue with Persuade 6, or Sway."
    outcome: "Confession and crossing; Ferrymen +10."
    sets: ["reach_milestone(ms.a2_jory_dealt)"]
  - id: frighten
    when: "Intimidate 8, or Intimidate 6 with Tigg or Vel Aram evidence."
    outcome: "Confession and crossing; Ferrymen -20 (Wary): no escort, no barge."
    sets: ["reach_milestone(ms.a2_jory_dealt)"]
  - id: weir_job
    when: "Player takes the job and kills the drowners at the weirs."
    outcome: "Ferrymen +25 (Friendly from Neutral), crossing, confession; Marit's ring for +10 more."
    sets: ["reach_milestone(ms.a2_jory_dealt)"]
  - id: storm_spare
    when: "Player storms the camp and spares Jory."
    outcome: "Ferrymen -40 (Wary or worse); confession under duress; crossing; cipher free if he holds it."
    sets: ["reach_milestone(ms.a2_jory_dealt)"]
  - id: storm_kill
    when: "Player storms the camp and kills Jory."
    outcome: "Ferrymen -80 total; the ferry is the player's; the strongbox gives the tally (and the cipher if the courier escaped)."
    sets: ["reach_milestone(ms.a2_jory_dealt)"]
failures:
  - id: player_dies
    result: reload_checkpoint
    recover: "Reload camp_arrival or weir_path_cp."
  - id: checks_failed_no_crowns
    result: soft_fail
    recover: "The weir job needs no check and no crowns. Storming the camp is always available."
guarantees:
  - "ms.a2_jory_dealt is reachable with no check and no crowns: take the weir job and win enc.weir_drowners, or storm the camp and open the strongbox."
  - "If the Oak courier escaped, the cipher is reachable with no check: storm the camp (strongbox_cipher), or spare Jory and demand it."
```

## 12. Open questions
- The encounter `on_won` / `on_yielded` both hand over to `dlg.jory_yielded`. This assumes Jory is the last enemy standing and always reaches the yield threshold before death (he is scripted as essential until the dialogue). Mark Jory's combat instance `can_yield` and non-lethal until `dlg.jory_yielded`.
- `item.tamas_knife` is a trinket with no stat block in the schema (trinket bonuses are not specified in gdd §6.9). Proposed: +10% bleed build-up on slash.
- Paying the 30-crown toll grants the crossing but not the milestone. The milestone is about the crate truth, not the passage.
