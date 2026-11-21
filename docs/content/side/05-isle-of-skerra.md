---
section_id: side.skerra
title: "The Seal-Wife of Skerra"
act: 2
story_ref: "story.md §10 Isle of Skerra; gdd.md §7.4, §6.1 (stage 3 Attre fortification), §7.5 (cintra~attre sea edge, attre—morrow_gull)"
zones: [zone.skerra_village, zone.skerra_seal_rocks]
available_when: "ms(ms.act1_complete)"
escalation_stage_required: {min: 1, max: 3}
milestones_set: []
milestones_read: [ms.act1_complete, ms.act2_twist]
level_band: [5, 7]
---

# The Seal-Wife of Skerra

## 1. Scene summary
Skerra is a knuckle of rock and turf off the Attre coast, home to forty fisherfolk who have not put a boat to sea since the equinox gale. A fog sits on the cove and will not lift. Seals tear every net set in the water, and every hull that pushes past the skerry comes back with seals hanging off the oars. The children are eating limpets. Captain Jessa Rook's smuggling cutter *Shrike* sits at the jetty with a Skerra-born crew that will not sail. The truth is ugly and everyone half-knows it. After the gale, Tam Corley found a woman on the seal rocks, took the sealskin she had shed and hid it, and now keeps her in his hut as his "wife". That broke the old bargain the village made with the seals: shoals every spring, and no hand ever laid on a seal-wife's skin. Grandmother Aud knows where the pelt is. She has also already promised it to Attre oil-men, who pay well for seal-wife skins. The dramatic question is what the player does with a stolen woman's skin when the village, the smugglers and the buyers all want something different. It ends with the fog lifting (the cutter and crew are the player's) or with the pelt sold and the cove left to starve.

## 2. Progress and escalation
- **Availability:** Act II, from `ms.act1_complete` (escalation stage 1–3). The quest closes at `ms.act2_twist` if it is unfinished.
- **Map node:** `map.isle_skerra`, reached by the `attre — isle_skerra` lowlands edge. Zones: `zone.skerra_village` (hub) and `zone.skerra_seal_rocks`.
- **Hooks:** rumor `rumor.r13_skerra_fog` (14-rumors.md), Attre harbor gossip, or simply sailing there once the node shows. The quest starts the first time the player enters `zone.skerra_village`.
- **Milestones:** none set. The section reads `ms.act1_complete` (availability) and `ms.act2_twist` (closing).
- **Payoff:** `flag.skerra_cutter`. The map's `cintra ~ attre (sea)` and `attre — morrow_gull` edges read it, and it is one of the three ways past Raimund's stage 3 land fortification (gdd §6.1). Jessa also hands over one `item.serpent_lure` (used in 06-wreck-morrow-gull.md) and keeps more in stock.
- **Stage variants:**
  - Stage 1–2: the fog is grey and wet. Villagers are thin and sullen. The pelt buyers have been waiting on the causeway for several tides.
  - Stage 3 (Open Knives): word of Raimund's border fortification reaches the island. Jessa's first line changes: she is now the only quiet way into Attre and knows it. The buyers are edgier, and their leader will not haggle (the *sell* price stays the same, but the Intimidate DC on him rises from 6 to 8).
  - After `flag.skerra_fog_lifted`: the fog is gone, boats are out, the smokehouse racks are full, and the music changes.
  - After `flag.skerra_pelt_sold`: the fog stays for good. Villagers spit as the player passes. Jessa will not speak to the player.

## 3. Location layout
**Skerra village** is a crescent of turf-roofed stone huts around a shingle cove, all on one slope that runs down to the water. The player lands at the **jetty** on the west arm, where the *Shrike* is moored: a low, black-tarred cutter with a single mast. Beached rowboats lie keel-up with their nets slashed. Above the jetty are the **net racks**, a forest of poles hung with torn net that is good cover for sneaking past the villagers. Further up stands **Aud's longhouse**, the biggest building, with a peat fire, a long table and a smoke-hole. On her table sits a small silver tally-chit stamped with the Attre tower, which an observant player can notice. East along the cove is **Tam Corley's hut**, the last before the rocks. It has a net loft above the byre, a hearth with a heavy flat hearthstone, and a box bed where Ronat sits staring at the wall. The **smokehouse** (empty racks, a cat) and the **tide shrine** (a cairn of seal skulls under a slate roof, where the old bargain is cut into a driftwood beam) sit between. At the east end, the **causeway head** leads down to the seal rocks.

**The seal rocks** are a tidal causeway of black weed-slick stones running out to a flat skerry. The causeway has kelp-draped boulders for cover and pools where the tide surges in over the stones (tide hazard: standing in the surge does damage and pushes the player toward deeper water). Halfway along is a ruined net-hut, where the Attre buyers camp. At the far end, the **skerry top** is flat rock where the pod hauls out. Thirty seals watch the player in silence. Under the skerry is a **tide cave**, used only for the scene where Ronat goes back to the sea.

Intended route: land, talk to Aud and Jessa, learn the truth (from Ronat, Tam or Aud), get the pelt from Tam's hearth, carry it out along the causeway (the buyers stop the player there), and give it to Ronat on the skerry top.

```yaml zone
id: zone.skerra_village
name: "Skerra"
kind: hub
map_node: map.isle_skerra
time_of_day: dusk
cold_rate: 0
disguise_tag: null
music: skerra_fog
areas:
  - {id: jetty, description: "Stone jetty on the west arm. The Shrike is moored here; beached rowboats with slashed nets."}
  - {id: net_racks, description: "Poles hung with torn nets. Dense cover; villagers mend here and talk."}
  - {id: aud_longhouse, description: "Turf longhouse, peat fire, long table. An Attre silver tally-chit lies by Aud's cup."}
  - {id: smokehouse, description: "Empty fish racks, a lean cat, smell of old smoke."}
  - {id: tide_shrine, description: "Cairn of seal skulls under a slate roof. The old bargain is carved into a driftwood beam."}
  - {id: tam_hut, description: "Last hut before the rocks. Byre with a net loft above; hearth with a heavy flat hearthstone; box bed."}
  - {id: causeway_head, description: "Steps cut down to the tidal causeway. Fog thickest here."}
spawns:
  - {id: landing, area: jetty, default: true}
  - {id: from_rocks, area: causeway_head}
exits:
  - id: to_seal_rocks
    area: causeway_head
    to_zone: zone.skerra_seal_rocks
    to_spawn: from_village
    condition: "true"
    effects: []
  - {id: ferry_board, area: jetty, to_map: true, label: "Take a boat back to the mainland", condition: "true", effects: []}
interactables:
  - id: bargain_beam
    area: tide_shrine
    kind: readable
    label: "Read the carved beam"
    condition: "true"
    check: null
    once: false
    effects: ["set_flag(flag.skerra_bargain_read)"]
  - id: aud_tally_chit
    area: aud_longhouse
    kind: search
    label: "Look at the silver chit"
    condition: "not flag(flag.skerra_truth_known)"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["set_flag(flag.skerra_chit_seen)"]
    fail_effects: []
  - id: net_loft
    area: tam_hut
    kind: search
    label: "Search the net loft"
    condition: "not has_item(item.selkie_pelt) and not flag(flag.selkie_freed)"
    check: null
    once: true
    effects: ["play_beat(pup_skin_found)", "set_flag(flag.skerra_truth_known)"]
    fail_effects: []
  - id: hearthstone_search
    area: tam_hut
    kind: search
    label: "Search around the hearth"
    condition: "not flag(flag.skerra_pelt_hint) and not has_item(item.selkie_pelt) and not flag(flag.selkie_freed) and not flag(flag.skerra_pelt_sold)"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["play_beat(hearthstone_lifted)", "give_item(item.selkie_pelt, 1)", "set_flag(flag.skerra_truth_known)"]
    fail_effects: []
  - id: hearthstone_known
    area: tam_hut
    kind: search
    label: "Lever up the hearthstone"
    condition: "flag(flag.skerra_pelt_hint) and not has_item(item.selkie_pelt) and not flag(flag.selkie_freed) and not flag(flag.skerra_pelt_sold) and not flag(flag.ronat_bound)"
    check: null
    once: true
    effects: ["play_beat(hearthstone_lifted)", "give_item(item.selkie_pelt, 1)", "set_flag(flag.skerra_truth_known)"]
    fail_effects: []
  - id: longhouse_fire
    area: aud_longhouse
    kind: rest
    label: "Sit by Aud's fire"
    condition: "flag(flag.skerra_fog_lifted)"
    check: null
    once: false
    effects: ["heal_player(full)"]
triggers:
  - id: arrive
    area: jetty
    "on": enter
    source: null
    condition: "not quest_active(quest.side_skerra) and not quest_done(quest.side_skerra) and not quest_failed(quest.side_skerra)"
    once: true
    effects: ["start_quest(quest.side_skerra)", "play_beat(fog_landing)", "set_checkpoint(village_landing)"]
  - id: ronat_leaves_hut
    area: tam_hut
    "on": interact
    source: hearthstone_known
    condition: "has_item(item.selkie_pelt)"
    once: true
    effects: ["play_beat(ronat_walks_out)"]
  - id: ronat_leaves_hut_search
    area: tam_hut
    "on": interact
    source: hearthstone_search
    condition: "has_item(item.selkie_pelt)"
    once: true
    effects: ["play_beat(ronat_walks_out)"]
hazards: []
checkpoints:
  - {id: village_landing, area: jetty}
beats:
  - {id: fog_landing, description: "The boat noses through fog. Seal heads surface around it and watch, then sink without a ripple."}
  - {id: pup_skin_found, description: "In the loft, wrapped in sacking: a seal pup's skin, badly cured. A decoy, or a test. The smell is awful."}
  - {id: hearthstone_lifted, description: "Under the hearthstone, in a hollow lined with oilcloth: a grey sealskin, still supple, faintly warm."}
  - {id: ronat_walks_out, description: "Ronat rises from the box bed without a word and walks out toward the causeway, barefoot on the stones."}
  - {id: fog_lifts, description: "The fog peels back off the cove in one long breath. Gulls. Light on the water. Somebody starts weeping."}
  - {id: tam_cursed, description: "Ronat touches Tam's mouth with two wet fingers and says something no one else hears. Tam stops speaking."}
  - {id: shrike_ready, description: "Jessa's crew swarm the Shrike, shaking out the sail for the first time since the gale."}
npcs:
  - {npc: npc.aud_skerra, area: aud_longhouse, condition: "true"}
  - {npc: npc.jessa_rook, area: jetty, condition: "not flag(flag.skerra_pelt_sold)"}
  - {npc: npc.tam_corley, area: tam_hut, condition: "true"}
  - {npc: npc.selkie_ronat, area: tam_hut, condition: "not has_item(item.selkie_pelt) and not flag(flag.selkie_freed)"}
encounters: []
loot: []
variants:
  - id: fog_lifted
    when: "flag(flag.skerra_fog_lifted)"
    description: "No fog. Boats out, nets drying whole, smokehouse racks full. Children on the jetty. Music shifts to skerra_clear."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: [aud_tally_chit, net_loft, hearthstone_search, hearthstone_known]
  - id: pelt_sold
    when: "flag(flag.skerra_pelt_sold)"
    description: "Fog for good. Villagers turn their backs. The Shrike's crew have scuttled her sail in protest."
    npcs_absent: [npc.jessa_rook]
    encounters_disabled: []
    interactables_disabled: [hearthstone_search, hearthstone_known]
  - id: stage_3
    when: "stage() >= 3"
    description: "Talk of Raimund's border pickets. Jessa's crew argue over prices for a run past them."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
```

```yaml zone
id: zone.skerra_seal_rocks
name: "The Seal Rocks"
kind: exterior
map_node: map.isle_skerra
time_of_day: dusk
cold_rate: 0
disguise_tag: null
music: skerra_rocks
areas:
  - {id: causeway, description: "Weed-slick black stones, kelp boulders for cover, surge pools where the tide floods in."}
  - {id: net_hut_ruin, description: "Roofless net hut halfway out. The Attre buyers' camp: bedrolls, a brazier, a cart-crate for the pelt."}
  - {id: skerry_top, description: "Flat rock at the far end where thirty seals haul out and watch in silence."}
  - {id: tide_cave, description: "Sea cave under the skerry. Used only for Ronat's return to the sea."}
spawns:
  - {id: from_village, area: causeway, default: true}
  - {id: causeway_far, area: net_hut_ruin}
exits:
  - id: back_to_village
    area: causeway
    to_zone: zone.skerra_village
    to_spawn: from_rocks
    condition: "true"
    effects: []
interactables:
  - id: buyers_crate
    area: net_hut_ruin
    kind: container
    label: "Search the buyers' crate"
    condition: "flag(flag.skerra_buyers_dealt)"
    check: null
    once: true
    effects: ["add_crowns(35)"]
    fail_effects: []
triggers:
  - id: buyers_block
    area: causeway
    "on": enter
    source: null
    condition: "has_item(item.selkie_pelt) and not flag(flag.skerra_buyers_dealt)"
    once: true
    effects: ["set_checkpoint(causeway_start)", "start_dialogue(dlg.fenn_galt_causeway)"]
  - id: ronat_waiting
    area: skerry_top
    "on": enter
    source: null
    condition: "has_item(item.selkie_pelt)"
    once: true
    effects: ["start_dialogue(dlg.ronat_rocks)"]
hazards:
  - {id: surge_pools, area: causeway, kind: tide, params: {damage_per_second: 4, push_toward: deep_water}}
  - {id: slick_weed, area: causeway, kind: trap, params: {slip_on_sprint: true, stagger_s: 0.8}}
checkpoints:
  - {id: causeway_start, area: causeway}
beats:
  - {id: ronat_takes_pelt, description: "Ronat takes the pelt in both hands and presses her face into it."}
  - {id: ronat_goes_to_sea, description: "She walks into the tide cave. A grey seal slides out the other side. The pod goes into the water as one."}
  - {id: fog_lifts, description: "The fog peels back off the cove in one long breath. Gulls. Light on the water."}
npcs:
  - {npc: npc.fenn_galt, area: net_hut_ruin, condition: "not flag(flag.skerra_buyers_dealt) and not flag(flag.skerra_pelt_sold)"}
  - {npc: npc.selkie_ronat, area: skerry_top, condition: "has_item(item.selkie_pelt)"}
encounters: [enc.skerra_pelt_buyers]
loot: []
variants:
  - id: freed
    when: "flag(flag.selkie_freed)"
    description: "The pod is gone from the skerry. One grey seal remains, far out, watching."
    npcs_absent: [npc.selkie_ronat]
    encounters_disabled: [enc.skerra_pelt_buyers]
    interactables_disabled: []
```

## 4. NPCs present
**Voice notes.**
- **Grandmother Aud:** short sentences, sea-cant, never answers a question directly the first time. Speaks of the village as "we" and of herself never. She is tired and she is not sorry.
- **Tam Corley:** big, red-handed, defensive, self-pitying. Calls Ronat "my wife" in every sentence, as if saying it makes it true. Gets loud when afraid.
- **Ronat:** speaks rarely, softly, with odd word order, as if the language is borrowed. Never raises her voice. Never says please.
- **Jessa Rook:** dry, quick, a smuggler's humor. Loyal to Skerra crew first, coin second, kingdoms never.
- **Fenn Galt:** pleasant Attre trader's voice over a knife. Calls the pelt "the merchandise".

```yaml npc
id: npc.aud_skerra
name: "Grandmother Aud"
faction: null
role: "Elder of Skerra"
motive: "Get her village through the winter, by whatever bargain is cheapest."
secret: "She knows Tam has the pelt and has already promised it to Attre buyers for 250 crowns to buy grain."
disposition: wary
essential: true
dialogue: dlg.aud_fog
barks: ["Fog's not weather. Weather leaves.", "Mind the nets. They're all we've got and they're cut.", "Eat, if you brought anything. We didn't."]
combat: null
shop: null
```

```yaml npc
id: npc.tam_corley
name: "Tam Corley"
faction: null
role: "Fisherman of Skerra"
motive: "Keep the woman he took and the life he thinks he deserves."
secret: "The pelt is under his hearthstone. The pup skin in the loft is a decoy he cured to fool searchers."
disposition: hostile
essential: true
dialogue: dlg.tam_corley
barks: ["She's my wife. Ask anyone.", "Get out of my house.", "I fed her. I keep her warm. What's the crime in that?"]
combat: null
shop: null
```

```yaml npc
id: npc.selkie_ronat
name: "Ronat"
faction: null
role: "The seal-wife"
motive: "Her skin back, and the sea."
secret: "She cannot take back what was stolen from her. It must be given, which is why she has not simply lifted the stone."
disposition: neutral
essential: true
dialogue: dlg.ronat_hut
barks: ["The water is close.", "He sleeps on it. He sleeps warm.", "You smell of road."]
combat: null
shop: null
```

```yaml npc
id: npc.jessa_rook
name: "Captain Jessa Rook"
faction: null
role: "Smuggler, captain of the cutter Shrike"
motive: "Get her crew back to sea and earning."
secret: "Her crew run grey lily and Abbey crates for Attre when the price is right. She stopped after she saw what was in one."
disposition: neutral
essential: true
dialogue: dlg.jessa_rook
barks: ["Shrike's the fastest hull on this coast. Was.", "Fog doesn't care what you're carrying.", "Don't touch the lines."]
combat: null
shop: {stock: [{item: item.serpent_lure, count: 3}], price_mod: 1.0}
```

```yaml npc
id: npc.fenn_galt
name: "Fenn Galt"
faction: faction.attre
role: "Attre oil-merchant and buyer of rare skins"
motive: "Collect the seal-wife pelt Aud promised him and sell it in Attre for ten times the price."
secret: "He works for a Port Peixe house that also ships grey lily for the Duke's men."
disposition: wary
essential: false
dialogue: dlg.fenn_galt_causeway
barks: ["Merchandise wants keeping dry.", "We had an arrangement with the old woman.", "Lovely fog. Bad for business."]
combat: enemy.bandit
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.aud_fog
participants: [npc.aud_skerra]
start: greet
nodes:
  greet:
    type: branch
    cases:
      - {if: "flag(flag.skerra_fog_lifted)", next: after_fog}
      - {if: "flag(flag.skerra_pelt_sold)", next: after_sold}
    else: first
  first:
    type: line
    speaker: npc.aud_skerra
    text: "Another boat. You can go back in it. Nothing here to buy and nothing to steal but cut net."
    direction: "Doesn't look up from the fire."
    next: hub
  hub:
    type: choice
    options:
      - id: fog
        text: "What's wrong with the cove?"
        next: fog_answer
      - id: bargain
        text: "The beam at the shrine. Tell me about the bargain."
        condition: "flag(flag.skerra_bargain_read)"
        next: bargain_answer
      - id: chit
        text: "That's an Attre tally-chit by your cup. Who's buying what? [Clue]"
        tag: clue
        condition: "flag(flag.skerra_chit_seen) and not flag(flag.skerra_truth_known)"
        next: confess
      - id: press
        text: "You know why this is happening. Your face says so. [Persuade 6]"
        tag: persuade
        condition: "not flag(flag.skerra_truth_known)"
        check: {skill: persuade, dc: 6, pass: confess, fail: press_fail}
        once: true
      - id: threaten
        text: "I've seen villages starve. Talk, or I sail and you all go the same way. [Intimidate 6]"
        tag: intimidate
        condition: "not flag(flag.skerra_truth_known)"
        check: {skill: intimidate, dc: 6, pass: confess_bitter, fail: threaten_fail}
        once: true
      - id: where
        text: "Where would Tam hide it?"
        condition: "flag(flag.skerra_truth_known) and not flag(flag.skerra_pelt_hint) and not has_item(item.selkie_pelt)"
        next: hint
      - id: leave
        text: "I'll look around."
        next: bye
  fog_answer:
    type: line
    speaker: npc.aud_skerra
    text: "Fog came in with the gale and sat down. The seals cut the nets. Every boat that pushes out comes back with seals hanging off the oars. One didn't come back."
    next: hub
  bargain_answer:
    type: line
    speaker: npc.aud_skerra
    text: "My grandmother's grandmother made it. Shoals every spring. In return, no seal is clubbed, and no hand touches a skin left on the rocks. That's all it says. That's all it ever needed to say."
    next: hub
  press_fail:
    type: line
    speaker: npc.aud_skerra
    text: "My face says I'm old and hungry. Go read someone else's."
    next: hub
  threaten_fail:
    type: line
    speaker: npc.aud_skerra
    text: "Sail, then. We've been threatened by better. The sea's doing it now."
    next: hub
  confess:
    type: line
    speaker: npc.aud_skerra
    text: "Tam found her on the rocks after the gale. Took the skin she'd left. Keeps her like a wife. And I sold the skin to Attre men before he'd even dried it, for grain. There. Now you know what we are."
    effects: ["set_flag(flag.skerra_truth_known)"]
    next: hub
  confess_bitter:
    type: line
    speaker: npc.aud_skerra
    text: "Fine. Tam Corley stole a seal-wife's skin and keeps her for a wife. I promised that skin to Attre for grain. There's your talk. Choke on it."
    effects: ["set_flag(flag.skerra_truth_known)"]
    next: hub
  hint:
    type: line
    speaker: npc.aud_skerra
    text: "Tam's a cold man who likes his comforts. He'll have it where he keeps warm."
    effects: ["set_flag(flag.skerra_pelt_hint)"]
    next: hub
  after_fog:
    type: line
    speaker: npc.aud_skerra
    text: "Boats are out. Fish in the racks. I'll not thank you. Thanks is for people who've nothing to be ashamed of. Sit by the fire if you want."
    next: bye
  after_sold:
    type: line
    speaker: npc.aud_skerra
    text: "You got there before me. Hope the silver's warm. We'll bury the first child in your name."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.tam_corley
participants: [npc.tam_corley]
start: greet
nodes:
  greet:
    type: branch
    cases:
      - {if: "flag(flag.selkie_freed)", next: after_freed}
      - {if: "flag(flag.ronat_bound)", next: after_bound}
    else: first
  first:
    type: line
    speaker: npc.tam_corley
    text: "This is my house. That's my wife. Say what you want and get out."
    direction: "Stands between the player and the box bed."
    next: hub
  hub:
    type: choice
    options:
      - id: wife
        text: "Your wife doesn't talk much."
        next: wife_answer
      - id: accuse
        text: "You stole her skin, Tam. The whole cove is paying for it. [Clue]"
        tag: clue
        condition: "flag(flag.skerra_truth_known) and not has_item(item.selkie_pelt)"
        next: accuse_answer
      - id: persuade
        text: "The seals will drown your neighbours one boat at a time. Give it back before they start on you. [Persuade 8]"
        tag: persuade
        condition: "flag(flag.skerra_truth_known) and not has_item(item.selkie_pelt)"
        check: {skill: persuade, dc: 8, pass: tam_gives, fail: persuade_fail}
        once: true
      - id: intimidate
        text: "Lift the stone, Tam, or I lift you onto it. [Intimidate 6]"
        tag: intimidate
        condition: "flag(flag.skerra_truth_known) and not has_item(item.selkie_pelt)"
        check: {skill: intimidate, dc: 6, pass: tam_gives, fail: intimidate_fail}
        once: true
      - id: buy
        text: "Aud's selling it to Attre anyway. Sell it to me first. [Bribe 80]"
        tag: bribe
        condition: "flag(flag.skerra_truth_known) and not has_item(item.selkie_pelt)"
        bribe: 80
        next: tam_sells
      - id: leave
        text: "I'm going."
        next: bye
  wife_answer:
    type: line
    speaker: npc.tam_corley
    text: "She talks when she wants. Came out of the gale with nothing. I gave her a roof. Who else would?"
    next: hub
  accuse_answer:
    type: line
    speaker: npc.tam_corley
    text: "Paying? They'd have let her freeze. I'm the only one who did right by her. You go tell them that."
    next: hub
  persuade_fail:
    type: line
    speaker: npc.tam_corley
    text: "Let them drown. Not one of them ever brought me a fish when my boat was holed."
    next: hub
  intimidate_fail:
    type: line
    speaker: npc.tam_corley
    text: "Lay a hand on me in my house and the whole cove will hold you down. Go on. Try."
    direction: "Grabs a gaff hook from the wall."
    next: hub
  tam_gives:
    type: line
    speaker: npc.tam_corley
    text: "Take it, then. Take it. It's under the hearth. She'll go, and I'll have nothing. Nothing."
    direction: "Sits down on the floor."
    effects: ["set_flag(flag.skerra_pelt_hint)", "set_flag(flag.tam_broken)"]
    next: bye
  tam_sells:
    type: line
    speaker: npc.tam_corley
    text: "Hearth. Under the flat stone. You never had it from me."
    effects: ["set_flag(flag.skerra_pelt_hint)"]
    next: bye
  after_freed:
    type: line
    speaker: npc.tam_corley
    text: "She didn't look back. Not once. You'd think she'd look back."
    next: bye
  after_bound:
    type: line
    speaker: npc.tam_corley
    direction: "Opens his mouth. No sound comes out. He points at the door."
    text: "..."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.ronat_hut
participants: [npc.selkie_ronat, npc.tam_corley]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.selkie_ronat
    text: "You are not from the water. You are not from here."
    direction: "She does not turn from the wall."
    next: hub
  hub:
    type: choice
    options:
      - id: who
        text: "Who are you?"
        next: who_answer
      - id: skin
        text: "Where is your skin?"
        condition: "not flag(flag.skerra_pelt_hint)"
        next: skin_answer
      - id: why_not
        text: "If you know where it is, why not take it?"
        condition: "flag(flag.skerra_pelt_hint)"
        next: why_answer
      - id: bargain
        text: "If the sea let the boats go, would you stay? Keep the village alive. [Persuade 8]"
        tag: persuade
        condition: "flag(flag.skerra_truth_known) and not flag(flag.ronat_bound)"
        check: {skill: persuade, dc: 8, pass: bound, fail: bargain_fail}
        once: true
      - id: leave
        text: "I'll be back."
        next: bye
  who_answer:
    type: line
    speaker: npc.selkie_ronat
    text: "Ronat, he calls me. It was not my name. My name is wet. It does not live in air."
    effects: ["set_flag(flag.skerra_truth_known)"]
    next: hub
  skin_answer:
    type: line
    speaker: npc.selkie_ronat
    text: "He sleeps on it. He sleeps warm."
    direction: "Her eyes go to the hearth, once."
    effects: ["set_flag(flag.skerra_pelt_hint)", "set_flag(flag.skerra_truth_known)"]
    next: hub
  why_answer:
    type: line
    speaker: npc.selkie_ronat
    text: "What is stolen from us must be given back. Taken, it is only stolen twice. That is how it is with my kind."
    next: hub
  bargain_fail:
    type: line
    speaker: npc.selkie_ronat
    text: "You ask me to sit in the dark for them. They sat in the dark for me. They watched."
    next: hub
  bound:
    type: line
    speaker: npc.selkie_ronat
    text: "For the small ones, then. Not for him. The pod will let the boats pass. And Tam Corley will not speak again, to me or to anyone."
    effects: ["play_beat(tam_cursed)", "set_flag(flag.ronat_bound)", "set_flag(flag.skerra_fog_lifted)", "play_beat(fog_lifts)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.ronat_rocks
participants: [npc.selkie_ronat]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.selkie_ronat
    text: "You carry it. I can smell it from the water."
    direction: "The seals on the skerry all lift their heads."
    next: hub
  hub:
    type: choice
    options:
      - id: give
        text: "It's yours. Go home."
        next: given
      - id: not_yet
        text: "Not yet."
        next: wait
  given:
    type: effect
    effects: ["take_item(item.selkie_pelt, 1)", "play_beat(ronat_takes_pelt)"]
    next: thanks
  thanks:
    type: line
    speaker: npc.selkie_ronat
    text: "Given. Not taken. The pod will remember your smell. Tell the old woman the bargain stands, and the next one who touches a skin, the sea keeps."
    effects: ["play_beat(ronat_goes_to_sea)", "set_flag(flag.selkie_freed)", "set_flag(flag.skerra_fog_lifted)", "play_beat(fog_lifts)"]
    next: bye
  wait:
    type: line
    speaker: npc.selkie_ronat
    text: "I have waited in a box bed. I can wait on a rock."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.fenn_galt_causeway
participants: [npc.fenn_galt]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.fenn_galt
    text: "That bundle under your arm is our merchandise. Paid for, in grain, to the old woman. We'll take it here, thank you, and pay you a finder's cut."
    direction: "Two men step out of the ruined hut behind him."
    next: hub
  hub:
    type: choice
    options:
      - id: sell
        text: "How much?"
        next: price
      - id: attre_rep
        text: "I'm a friend of the Duke's. Go home, Fenn. [Attre: Friendly]"
        tag: sway
        condition: "rep_tier(faction.attre) >= friendly"
        show_locked: true
        next: backs_off
      - id: intimidate
        text: "You've got three men and a fog. I've got a sword and a bad mood. Walk away. [Intimidate 6]"
        tag: intimidate
        condition: "stage() <= 2"
        check: {skill: intimidate, dc: 6, pass: backs_off, fail: fight_line}
        once: true
      - id: intimidate_hard
        text: "Raimund's pickets won't save you out here. Walk away. [Intimidate 8]"
        tag: intimidate
        condition: "stage() >= 3"
        check: {skill: intimidate, dc: 8, pass: backs_off, fail: fight_line}
        once: true
      - id: refuse
        text: "It isn't merchandise. It's hers."
        next: fight_line
  price:
    type: line
    speaker: npc.fenn_galt
    text: "Two hundred and fifty crowns. The old woman gets her grain either way. You walk off richer, and nobody on this rock ever has to see you again."
    next: price_choice
  price_choice:
    type: choice
    options:
      - id: take_money
        text: "Done. Take it."
        effects: ["take_item(item.selkie_pelt, 1)", "add_crowns(250)", "add_rep(faction.attre, 5)", "set_flag(flag.skerra_pelt_sold)", "set_flag(flag.skerra_buyers_dealt)", "fail_quest(quest.side_skerra)"]
        next: sold
      - id: no_deal
        text: "No."
        next: fight_line
  sold:
    type: line
    speaker: npc.fenn_galt
    text: "Pleasure. Skins like this don't come twice in a lifetime. Don't stay for supper."
    next: bye
  backs_off:
    type: line
    speaker: npc.fenn_galt
    text: "No skin is worth a slit belly. The old woman keeps her grain. We'll call the fog our loss."
    effects: ["set_flag(flag.skerra_buyers_dealt)", "add_xp(60)"]
    next: bye
  fight_line:
    type: line
    speaker: npc.fenn_galt
    text: "Then we'll take it off what's left of you."
    effects: ["start_encounter(enc.skerra_pelt_buyers)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.jessa_rook
participants: [npc.jessa_rook]
start: greet
nodes:
  greet:
    type: branch
    cases:
      - {if: "flag(flag.skerra_cutter)", next: crewed}
      - {if: "flag(flag.skerra_fog_lifted) and flag(flag.selkie_freed)", next: offer_free}
      - {if: "flag(flag.skerra_fog_lifted) and flag(flag.ronat_bound)", next: offer_uneasy}
      - {if: "stage() >= 3", next: first_stage3}
    else: first
  first:
    type: line
    speaker: npc.jessa_rook
    text: "If you came to hire the fastest hull on the coast, she's tied to that jetty by fog. We tried once. Seals took the oars and Danno went over. Didn't come up."
    next: hub
  first_stage3:
    type: line
    speaker: npc.jessa_rook
    text: "Heard Raimund's pickets have shut the land road into Attre. Every smuggler on this coast is rich this season, except the ones stuck in a fog. Guess which I am."
    next: hub
  hub:
    type: choice
    options:
      - id: what
        text: "What would get you out to sea?"
        next: what_answer
      - id: cargo
        text: "What did you used to run?"
        next: cargo_answer
      - id: lure
        text: "Do you sell seal-oil chum?"
        next: shop
      - id: leave
        text: "Later."
        next: bye
  what_answer:
    type: line
    speaker: npc.jessa_rook
    text: "Lift the fog and the Shrike's yours, any coast you name. My lads are Skerra born. Whatever's wrong in that cove, they'll owe whoever fixes it."
    next: hub
  cargo_answer:
    type: line
    speaker: npc.jessa_rook
    text: "Wine, wool, grey lily once for an Abbey buyer at Peixe. Opened a crate by mistake and saw the monks' feathers packed in with it. Never again."
    next: hub
  shop:
    type: effect
    effects: ["open_shop(npc.jessa_rook)"]
    next: bye
  offer_free:
    type: line
    speaker: npc.jessa_rook
    text: "You gave the seal-wife back her skin. My crew watched her go into the cave. Shrike is yours. Cintra, Attre, the Morrow Gull reef, wherever. And take a barrel of chum, you'll want it out there."
    effects: ["play_beat(shrike_ready)", "set_flag(flag.skerra_cutter)", "give_item(item.serpent_lure, 1)", "add_map_pin(map.morrow_gull)"]
    next: crewed
  offer_uneasy:
    type: line
    speaker: npc.jessa_rook
    text: "The fog's gone. Tam can't talk and that woman's still in his hut. My lads don't like how it was done. They want paying, or a reason."
    next: uneasy_choice
  uneasy_choice:
    type: choice
    options:
      - id: reason
        text: "She chose it, for the children. You're alive because of her. Honour that. [Persuade 6]"
        tag: persuade
        check: {skill: persuade, dc: 6, pass: uneasy_yes, fail: uneasy_no}
        once: true
      - id: lean
        text: "Your lads ran grey lily for the Abbey. They don't get to be squeamish. [Intimidate 6]"
        tag: intimidate
        check: {skill: intimidate, dc: 6, pass: uneasy_yes, fail: uneasy_no}
        once: true
      - id: pay
        text: "Pay them. [Bribe 100]"
        tag: bribe
        bribe: 100
        next: uneasy_yes
      - id: later
        text: "Think on it."
        next: uneasy_later
  uneasy_no:
    type: line
    speaker: npc.jessa_rook
    text: "Pretty words don't sail a boat. Silver does. Hundred crowns for the crew and we cast off."
    next: uneasy_later
  uneasy_later:
    type: line
    speaker: npc.jessa_rook
    text: "Offer stands. Hundred crowns, any time you're on the island."
    next: bye
  uneasy_yes:
    type: line
    speaker: npc.jessa_rook
    text: "Right. Shrike's yours. Don't ask me to look at Tam's door when we cast off."
    effects: ["play_beat(shrike_ready)", "set_flag(flag.skerra_cutter)", "give_item(item.serpent_lure, 1)", "add_map_pin(map.morrow_gull)"]
    next: crewed
  crewed:
    type: line
    speaker: npc.jessa_rook
    text: "Name a coast. If Raimund's men have the land road shut, we'll go in by water under their noses."
    next: crewed_hub
  crewed_hub:
    type: choice
    options:
      - id: lure2
        text: "More chum."
        next: shop
      - id: bye
        text: "Be ready."
        next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.skerra_pelt_buyers
zone: zone.skerra_seal_rocks
enemies:
  - {enemy: enemy.bandit, count: 2, spawn: causeway_far, variant: sword}
  - {enemy: enemy.bandit, count: 1, spawn: causeway_far, variant: spear}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: causeway_start
avoidable_by: ["dlg.fenn_galt_causeway"]
on_won: ["set_flag(flag.skerra_buyers_dealt)"]
on_yielded: ["set_flag(flag.skerra_buyers_dealt)", "add_crowns(40)"]
on_player_fled: []
```

Fenn Galt is one of the three (spear variant). Cover is the kelp boulders, and the surge pools punish fighting in the open. Knocking a bandit into a surge pool pushes him toward deep water and out of the fight. If the player flees back to the village mid-fight, the buyers stay at the net hut and the `buyers_block` trigger has already fired. They then attack on sight in the `net_hut_ruin` area. Talking down (Attre Friendly, or Intimidate 6, or 8 at stage 3) skips the fight and awards the same XP.

## 7. Items and clues

```yaml item
id: item.selkie_pelt
name: "Grey sealskin"
category: key
description: "Supple, grey-dappled, faintly warm however long it has been out of the water. It smells of the sea and of peat smoke."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.serpent_lure
name: "Barrel of seal-oil chum"
category: consumable
description: "A small cask of rendered seal-oil, fish guts and blood. Drop it overboard and anything with teeth in the water goes to it first."
price: 40
stack_max: 3
equip_slot: null
weapon: null
armor: null
consumable: {effects: [], use_time: 0, quick_slot: false}
readable_text: null
```

No new clues. The section is a moral problem, not an investigation. Jessa's line about Abbey crates of grey lily is flavor that reinforces `ded.poison_via_attre` without granting a clue.

## 8. Flags set and read

```yaml flags
declare:
  - {id: flag.skerra_cutter, type: bool, desc: "The Shrike and crew serve the player. Opens cintra~attre sea and attre—morrow_gull edges; bypasses the stage 3 Attre land fortification."}
  - {id: flag.selkie_freed, type: bool, desc: "Ronat has her pelt back and has returned to the sea."}
  - {id: flag.skerra_fog_lifted, type: bool, desc: "The fog over Skerra cove has lifted (freed or new bargain)."}
  - {id: flag.ronat_bound, type: bool, desc: "Ronat agreed to stay among the villagers; Tam struck dumb."}
  - {id: flag.skerra_pelt_sold, type: bool, desc: "The player sold the pelt to the Attre buyers."}
  - {id: flag.skerra_buyers_dealt, type: bool, desc: "Fenn Galt's buyers are resolved (fled, beaten, or paid)."}
  - {id: flag.skerra_truth_known, type: bool, desc: "The player knows Tam stole a seal-wife's pelt."}
  - {id: flag.skerra_pelt_hint, type: bool, desc: "The player knows the pelt is under Tam's hearthstone."}
  - {id: flag.skerra_bargain_read, type: bool, desc: "The player read the carved bargain at the tide shrine."}
  - {id: flag.skerra_chit_seen, type: bool, desc: "The player noticed Aud's Attre silver chit."}
  - {id: flag.tam_broken, type: bool, desc: "Tam gave up the hiding place under pressure."}
reads:
  - ms.act1_complete
  - ms.act2_twist
```

## 9. Quest hooks

```yaml quest
id: quest.side_skerra
kind: side
title: "The Seal-Wife of Skerra"
giver: npc.aud_skerra
available: "ms(ms.act1_complete)"
closes_on: "ms(ms.act2_twist)"
xp: 450
stages:
  - id: the_fog
    journal: "Skerra's boats cannot leave the cove. A fog sits on the water and seals cut every net. The villagers know more than they say."
    objectives:
      - {id: learn_truth, text: "Find out what binds Skerra", condition: "flag(flag.skerra_truth_known)", optional: false}
      - {id: read_beam, text: "Read the old bargain at the tide shrine", condition: "flag(flag.skerra_bargain_read)", optional: true, xp: 30}
    on_complete: []
    next: []
  - id: the_skin
    journal: "Tam Corley stole a seal-wife's skin and keeps her as his wife. Aud has promised the skin to Attre buyers. Somebody has to decide what happens to it."
    objectives:
      - {id: resolve, text: "Decide the seal-wife's fate", condition: "flag(flag.skerra_fog_lifted)", optional: false}
      - {id: buyers, text: "Deal with the Attre buyers on the causeway", condition: "flag(flag.skerra_buyers_dealt)", optional: true, xp: 60}
    on_complete: []
    next: []
  - id: the_cutter
    journal: "The fog has lifted. Captain Jessa Rook's crew owe the one who lifted it."
    objectives:
      - {id: cutter, text: "Speak to Jessa Rook about the Shrike", condition: "flag(flag.skerra_cutter)", optional: false}
    on_complete: []
    next: []
outcome_effects:
  completed: []
  failed: []
```

## 10. Rumors and event cards (optional)
None defined here. `rumor.r13_skerra_fog` lives in 14-rumors.md and pins `map.isle_skerra`.

## 11. Failure states and branches

```yaml branches
paths:
  - id: free_her
    when: "Player gets the pelt (hint from Ronat, Aud or Tam, or Investigate 6 at the hearth) and gives it to Ronat on the skerry."
    outcome: "flag.selkie_freed, flag.skerra_fog_lifted; Jessa gives the Shrike free, plus one serpent lure."
    sets: ["set_flag(flag.selkie_freed)", "set_flag(flag.skerra_fog_lifted)", "set_flag(flag.skerra_cutter)"]
  - id: bind_her
    when: "Player persuades Ronat (Persuade 8) to stay for the village's sake."
    outcome: "flag.ronat_bound, fog lifts, Tam struck dumb; Jessa's crew want Persuade 6, Intimidate 6 or 100 crowns before sailing."
    sets: ["set_flag(flag.ronat_bound)", "set_flag(flag.skerra_fog_lifted)", "set_flag(flag.skerra_cutter)"]
  - id: sell_her
    when: "Player sells the pelt to Fenn Galt on the causeway."
    outcome: "+250 crowns, +5 Attre; quest failed; no cutter; Skerra stays fogged; Jessa absent."
    sets: ["set_flag(flag.skerra_pelt_sold)", "fail_quest(quest.side_skerra)"]
failures:
  - id: player_dies_causeway
    result: reload_checkpoint
    recover: "Reload causeway_start."
  - id: persuade_ronat_failed
    result: soft_fail
    recover: "The free_her path is still open; Ronat's own hint needs no check."
  - id: tam_checks_failed
    result: soft_fail
    recover: "Ronat or Aud gives the hint; the hearthstone_known search needs no check."
  - id: jessa_refuses_after_binding
    result: soft_fail
    recover: "The 100-crown payment stays on offer on every later visit (offer_uneasy re-enters on each talk until flag.skerra_cutter)."
  - id: quest_closed_by_twist
    result: soft_fail
    recover: "Quest abandoned at ms.act2_twist. Attre can still be entered by invitation or checkpoint fight; Morrow Gull by hired boat."
guarantees:
  - "flag.skerra_cutter reachable without any check: ask Ronat 'Where is your skin?' (no check) -> hearthstone_known (no check) -> fight or talk past the buyers -> give pelt -> Jessa (free)."
```

## 12. Open questions
- `item.serpent_lure` (resolved by A08) has `consumable: {effects: [], use_time: 0, quick_slot: false}` (content-format §J.6).
- Fenn Galt is both an npc and one of the three bandits in the encounter. The schema has no way to say "this npc is enemy #3 of the encounter". Presentation should bind him to the spear bandit.
- Trap hazard `slick_weed` uses params (`slip_on_sprint`, `stagger_s`) that the hazard system does not define yet.
