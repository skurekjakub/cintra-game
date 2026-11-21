---
section_id: a3.02
title: "Dun Strept"
act: 3
story_ref: "story.md §2 Strept Highlands, §3 Hesk Ironjaw, §7.2 Dun Strept; gdd §6.12 faction.strept, §6.13 ally.strept_warband, §7.3 row 2"
zones: [zone.dun_strept]
available_when: "ms(ms.act1_complete)"
escalation_stage_required: {min: 1, max: 4}
milestones_set: [ms.a3_strept_resolved]
milestones_read: [ms.act1_complete, ms.act2_twist]
level_band: [8, 10]
---

# Dun Strept

## 1. Scene summary
Dun Strept is the Strept clans' hill-fort, a palisade of black pine on a crag above the Strept river. Beside Hesk Ironjaw's new longhouse, the roofless ruin of the hall Kosk burned in 1263 is kept exactly as it fell. Hesk will not lift a finger for Cintra until Cintra pays for Marnadal: the champion's **bronze-and-iron torc** brought home from the field, or **Kosk's written apology and blood-price**. The first time the player speaks with him in Act III, a horn sounds from the crag. Choir sappers are climbing the north cliff to blow up the clans' **standing stone**, the last copy of the four verses outside Anselm's reach. Defending the stone is the fastest way to earn Hesk's respect, and the stone itself confirms the true fourth verse (`clue.standing_stone_verse`). The stone-keeper Ama Kerrow remembers the soft-voiced monk who carried forged levy letters into the clan halls in 1263. That truth can turn the clans' hatred onto the Choir. Depending on Strept reputation, Hesk gives nothing, **guides** around the Stairs' rear-guard (`flag.strept_guides`, Friendly), or guides plus **Corra Ironjaw's war-band** (`ally.strept_warband`, Allied). The dramatic question: can a lowlander carrying a Cintran crown make a highland chief bleed for a Cintran boy? The section ends when Hesk gives his answer (`ms.a3_strept_resolved`).

The zone can also be visited in Act II (the Silver Mine side quest sits next to it, gdd §7.4). In Act II Hesk only takes the torc and names his terms. The Choir raid and his decision happen in Act III only.

## 2. Progress and escalation
- **Stages 1–3 (Act II):** `zone.dun_strept` has its `act_two` look: no snow on the lower town, the stone ring guarded, no raid. Hesk accepts the torc (reputation counts toward Act III), shares the Marnadal story and states his terms. The trader, the alewife and the stone-keeper work as in Act III.
- **Stage 4 (Act III):** snow lies on the crag. The first Act III conversation with Hesk triggers the raid horn. Hesk's decision node is available.
- `ms.a3_strept_resolved` is set when Hesk gives an answer in Act III: refuse, guides, or guides plus war-band. If the player raises their reputation and asks again, the answer is re-evaluated. The milestone is write-once, but the flags and the ally update.

**Reputation arithmetic (faction.strept starts at −10, gdd §6.12):**

| Source | Change | Where |
|---|---|---|
| Torc returned | +40 | Hesk dialogue (Act II or III) |
| Cairn rite spoken over the torc (`flag.torc_rite_known`) | +10 | Hesk dialogue |
| Standing stone defended | +15 | `enc.strept_stone_raid` won |
| Refusing to defend the stone, or abandoning the raid | −10 | Hesk dialogue / leaving the zone |
| Kosk's apology delivered | +30 | Hesk dialogue |
| Blood-price paid from the player's purse (Bribe 250) | +20 | Hesk dialogue, only if no apology was given |
| [Clue] The feathered envoy (`clue.marnadal_provocateur`) | +10 | Hesk dialogue |
| Persuade 8 pass | +10 | Hesk dialogue |
| Intimidate 8 pass / fail | +5 / −10 | Hesk dialogue |
| [Sway] Kingmaker | +10 | Hesk dialogue |
| Silver Mine side quest (A07) | +10 | elsewhere |

Typical results: torc only gives +30 (Friendly: guides). Torc + stone + rite (or apology) reaches Allied (war-band). Apology + stone gives +35 (Friendly). Reaching Allied without the torc needs apology, stone and two more sources (clue, persuade, sway, or the Silver Mine).

## 3. Location layout
The player arrives at the foot of a switchback road climbing the crag from the east, past cairns for the 1263 dead. Strept scouts watch from the rocks, and on the first Act III arrival a horn passes the news uphill. The road ends at a palisade gate with a squat tower and a brazier where the gatewarden Kellan stands. Inside is the **lower town**: turf-roofed longhouses, sheep pens, a tarred awning over the market (Ewin's fur stall, Una's ale bench). The town climbs to a level shelf where two buildings face each other across a muddy yard. One is the **Ash Hall**, the 1263 ruin: charred posts, no roof, names cut into every surviving beam. The other is **Hesk's longhouse**: a single long fire-trench, benches, war-gear on the walls, and the high seat at the far end. A rope-railed **stone path** climbs behind the longhouse to the crag top. There, in the **stone ring**, nine low stones surround one tall carved stone. A sheer north cliff drops to the river, with a **goat track** up its face, which is where the Choir climbs. Below the ring, on the south slope, lies the **cairn field**, where one cairn has stood empty since 1263. Combat space is the stone ring (about 25 m across, with stones as cover, the cliff edge as a hazard, and the sapper's approach up the goat track). Everything else is dialogue and trade.

```yaml zone
id: zone.dun_strept
name: "Dun Strept"
kind: exterior
map_node: map.dun_strept
time_of_day: dusk
cold_rate: 2
disguise_tag: null
music: highland_hold
areas:
  - {id: approach_road, description: "Switchback road up the crag from the east, lined with cairns for the 1263 dead; scouts on the rocks above."}
  - {id: gate, description: "Black-pine palisade on a stone footing; squat gate tower; Kellan's brazier."}
  - {id: lower_town, description: "Turf-roofed longhouses, sheep pens, peat smoke, wet wool; children who stop playing when a lowlander passes."}
  - {id: market, description: "Tarred awning over trestles: Ewin's furs and tallow, Una's ale bench and barrels."}
  - {id: ash_hall, description: "The roofless hall burned in 1263, left as it fell; charred posts, names cut into the beams, a child's shoe nailed above the door."}
  - {id: hesk_hall, description: "Hesk's longhouse: fire-trench down the middle, benches, war-gear, the high seat at the far end under a stag skull."}
  - {id: stone_path, description: "Rope-railed path climbing the crag behind the longhouse; slick with ice in Act III."}
  - {id: stone_ring, description: "Crag top: nine knee-high stones in a ring around one tall carved stone; cover for the raid fight; open north edge."}
  - {id: north_cliff, description: "Sheer drop to the Strept river; a goat track climbs its face to the ring. Falling is a hazard."}
  - {id: keeper_hut, description: "Ama Kerrow's bothy at the ring's south side: hides, charcoal, a loom hung with stone rubbings."}
  - {id: cairn_field, description: "South slope below the ring: clan cairns, one standing empty since 1263, with a bare torc-stand on top."}
spawns:
  - {id: road_foot, area: approach_road, default: true}
  - {id: gate_inside, area: lower_town}
  - {id: hall_door, area: hesk_hall}
  - {id: stone_ring_south, area: stone_ring}
  - {id: choir_cliff_1, area: north_cliff}
  - {id: choir_cliff_2, area: north_cliff}
  - {id: choir_sapper, area: north_cliff}
  - {id: corra_post, area: stone_path}
exits:
  - {id: road_board, area: approach_road, to_map: true, label: "Take the road down", condition: "true", effects: []}
interactables:
  - id: hesk_fire
    area: hesk_hall
    kind: rest
    label: "Sit at Hesk's fire"
    condition: "rep_tier(faction.strept) >= neutral"
    check: null
    once: false
    effects: ["heal_player(full)", "set_checkpoint(hesk_hall)"]
    fail_effects: []
  - id: ash_beams
    area: ash_hall
    kind: search
    label: "Read the names cut into the beams"
    condition: "not has_clue(clue.marnadal_provocateur)"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["add_clue(clue.marnadal_provocateur)"]
    fail_effects: ["play_beat(ash_names)"]
  - id: ash_shoe
    area: ash_hall
    kind: search
    label: "Look at the shoe above the door"
    condition: "true"
    check: null
    once: true
    effects: ["play_beat(ash_shoe)"]
    fail_effects: []
  - id: standing_stone
    area: stone_ring
    kind: readable
    label: "Read the carved stone"
    condition: "not flag(flag.standing_stone_broken) and (flag(flag.strept_stone_shown) or flag(flag.strept_stone_defended))"
    check: null
    once: true
    effects: ["add_clue(clue.standing_stone_verse)", "give_item(item.standing_stone_rubbing, 1)", "play_beat(stone_read)"]
    fail_effects: []
  - id: standing_stone_touch
    area: stone_ring
    kind: search
    label: "Trace the old carving by hand"
    condition: "not flag(flag.standing_stone_broken) and not flag(flag.strept_stone_shown) and not flag(flag.strept_stone_defended) and not has_clue(clue.standing_stone_verse)"
    check: {skill: lore, dc: 6}
    once: true
    effects: ["add_clue(clue.standing_stone_verse)", "add_rep(faction.strept, -5)", "play_beat(caught_at_stone)"]
    fail_effects: ["add_rep(faction.strept, -5)", "play_beat(caught_at_stone)"]
  - id: stone_shards
    area: stone_ring
    kind: search
    label: "Sift the shattered stone"
    condition: "flag(flag.standing_stone_broken)"
    check: null
    once: true
    effects: ["play_beat(stone_shards)"]
    fail_effects: []
  - id: empty_cairn
    area: cairn_field
    kind: search
    label: "Look at the empty cairn"
    condition: "true"
    check: null
    once: false
    effects: ["play_beat(empty_cairn)"]
    fail_effects: []
  - id: sapper_body
    area: stone_ring
    kind: search
    label: "Search the sapper"
    condition: "flag(flag.strept_stone_defended)"
    check: null
    once: true
    effects: ["give_item(item.sapper_orders, 1)", "add_clue(clue.choir_erasing_verse)", "give_item(item.pale_feather, 1)"]
    fail_effects: []
triggers:
  - id: horns_on_crag
    area: approach_road
    "on": enter
    source: null
    condition: "act() == 3"
    once: true
    effects: ["play_beat(horns_on_crag)"]
  - id: raid_begins
    area: stone_ring
    "on": enter
    source: null
    condition: "flag(flag.strept_raid_called) and not flag(flag.strept_raid_done)"
    once: true
    effects: ["set_checkpoint(before_raid)", "play_beat(choir_on_cliff)", "start_encounter(enc.strept_stone_raid)"]
  - id: raid_abandoned
    area: approach_road
    "on": exit_attempt
    source: road_board
    condition: "flag(flag.strept_raid_called) and not flag(flag.strept_raid_done)"
    once: true
    effects: ["set_flag(flag.strept_raid_done)", "set_flag(flag.standing_stone_broken)", "add_rep(faction.strept, -10)", "play_beat(stone_blast)"]
hazards:
  - {id: cliff_edge, area: north_cliff, kind: collapse, params: {fall: lethal, note: "Falling off the north edge kills; reload checkpoint."}}
  - {id: ring_ice, area: stone_path, kind: cold, params: {slip_chance_on_sprint: 0.2, damage: 10}}
checkpoints:
  - {id: hesk_hall, area: hesk_hall}
  - {id: before_raid, area: stone_path}
beats:
  - {id: horns_on_crag, description: "A horn from the rocks above the road, answered from the palisade, answered again from the crag top. Every head in Dun Strept turns toward the road."}
  - {id: raid_horn, description: "Mid-conversation, three short blasts from the crag. Corra bursts into the longhouse with snow on her shoulders."}
  - {id: choir_on_cliff, description: "Grey robes come over the north edge on ropes. One man has a keg strapped to his back and a slow-match in his teeth."}
  - {id: stone_blast, description: "A flat boom from the crag top. Grit patters down on the roofs. When the smoke clears, the tall stone is a stump and the ring is full of carved fragments."}
  - {id: stone_read, description: "Ama brushes snow from the carving. Four lines in old dwarven forms, with the Strept words cut beside them in a younger hand. She reads them aloud."}
  - {id: caught_at_stone, description: "A shout from the keeper's hut. Ama Kerrow, lamp held high: 'Lowlander hands on our stone.' Word reaches the hall before the player does."}
  - {id: stone_shards, description: "Fragments of carving in the snow. One reads 'lion's blood'. The rest is gravel. Ama has rubbings, the player thinks, and so does she."}
  - {id: ash_names, description: "Names, hundreds of them, many of them small. The player cannot make sense of the marks among them."}
  - {id: ash_shoe, description: "A child's shoe, charred, nailed above the door. Nobody in Dun Strept will say whose."}
  - {id: empty_cairn, description: "An empty cairn with a bare iron stand on top, the kind a torc is hung on. Fresh pine on it, as if someone tends it every week."}
  - {id: torc_raised, description: "Hesk lifts the torc over his head. The longhouse goes silent, then someone at the back starts to keen, and the whole hall takes it up."}
  - {id: cairn_rite, description: "At the empty cairn, Hesk hangs the torc on the stand while the player speaks the words the champion taught them on Marnadal Field."}
  - {id: warband_musters, description: "Corra and three highlanders take their spears down from the wall. Hesk ties a strip of Ash Hall timber to each spear-shaft."}
npcs:
  - {npc: npc.kellan_gatewarden, area: gate, condition: "true"}
  - {npc: npc.hesk, area: hesk_hall, condition: "true"}
  - {npc: npc.corra_ironjaw, area: hesk_hall, condition: "not in_party(ally.strept_warband)"}
  - {npc: npc.ama_kerrow, area: keeper_hut, condition: "true"}
  - {npc: npc.ewin_trader, area: market, condition: "true"}
  - {npc: npc.dun_strept_alewife, area: market, condition: "true"}
encounters: [enc.strept_stone_raid]
loot: []
variants:
  - id: act_two
    when: "act() < 3"
    description: "Autumn look: no snow below the crag top; two clan spearmen guard the stone path; no horns. Hesk is cold but not desperate."
    npcs_absent: []
    encounters_disabled: [enc.strept_stone_raid]
    interactables_disabled: [sapper_body, stone_shards]
  - id: stone_broken
    when: "flag(flag.standing_stone_broken)"
    description: "The tall stone is a blasted stump; fragments in the snow; Ama sits in the ring and will not come inside."
    npcs_absent: []
    encounters_disabled: [enc.strept_stone_raid]
    interactables_disabled: [standing_stone, standing_stone_touch]
  - id: warband_gone
    when: "in_party(ally.strept_warband)"
    description: "Four spears gone from the longhouse wall; Corra's place on the bench empty."
    npcs_absent: [npc.corra_ironjaw]
    encounters_disabled: []
    interactables_disabled: []
```

## 4. NPCs present

```yaml npc
id: npc.hesk
name: "Hesk Ironjaw"
faction: faction.strept
role: "Chieftain of the Strept clans at Dun Strept"
motive: "Justice and blood-price for 1263, and his clans never again at a Cintran's mercy."
secret: "He led the summer raids on Kosk's supply lines that made Kosk desperate enough to believe the Dun Edra lie. He knows the burning was partly his doing, and he will never say so."
disposition: wary
essential: true
dialogue: dlg.hesk
barks: ["Mind your boots in my hall. That floor's swept for the dead.", "Cintra talks with its mouth full.", "My daughter will walk you out. Or carry you.", "You still here, lowlander?"]
combat: null
shop: null
```
*Voice:* a deep, slow speaker who leaves silences. He calls everyone from below the crag "lowlander", and the player "Cintran" when he's angry. Short Strept oaths ("by the cairns"). A scar splits his jaw, so he slurs his esses when shouting.

```yaml npc
id: npc.corra_ironjaw
name: "Corra Ironjaw"
faction: faction.strept
role: "Hesk's daughter; leader of the war-band (ally.strept_warband)"
motive: "Fight the Choir that she now suspects lit Marnadal; prove the clans are more than a grudge."
secret: "She was twelve in 1263 and hid in the Ash Hall's root cellar while it burned above her. The shoe over the door is her brother's."
disposition: wary
essential: true
dialogue: dlg.corra
barks: ["Keep up, lowlander.", "Four of us. Enough to make them think it's forty.", "Monks bleed like anyone. Slower, maybe.", "Watch the ice. It's on our side, not yours."]
combat: null
shop: null
```

```yaml npc
id: npc.ama_kerrow
name: "Ama Kerrow"
faction: faction.strept
role: "Keeper of the standing stone; the clans' memory"
motive: "Keep the stone and its words, and see the man who lied to the halls named."
secret: "She sheltered the soft-voiced monk in her own bothy in the spring of 1263 and helped him read the forged levy letters aloud in three halls. She has never forgiven herself."
disposition: neutral
essential: true
dialogue: dlg.ama_kerrow
barks: ["Mind the stone. It was here before your kings.", "Rubbings, rubbings. Every winter I take another.", "The dwarves cut it for us. Not for you."]
combat: null
shop: null
```

```yaml npc
id: npc.kellan_gatewarden
name: "Kellan"
faction: faction.strept
role: "Gatewarden of Dun Strept"
motive: "Keep lowlanders out unless the chief says otherwise."
secret: null
disposition: wary
essential: false
dialogue: dlg.kellan_gate
barks: ["State your business or turn round.", "That's a Marshal's lion on your coat. Take it off or take yourself off.", "Chief's in the hall. Don't make him come out."]
combat: null
shop: null
```
*Presentation note:* when the Marshal's badge is worn (`equipped(item.kosk_badge)`, gdd §6.9), Kellan plays his second bark and spits in the snow. The −2 to checks against Strept speakers comes from the badge's `trinket.mods` (gdd §6.10). No content flag is involved.

```yaml npc
id: npc.ewin_trader
name: "Ewin"
faction: faction.strept
role: "Fur and tallow trader in the Dun Strept market"
motive: "Sell lowlanders furs at lowlander prices."
secret: "Buys Choir mules at the Stairs' foot and resells them in Assengard."
disposition: neutral
essential: false
dialogue: dlg.ewin_trader
barks: ["Furs for the high ice. Yours won't do.", "Mutton for the trolls. Don't laugh. It works.", "Coin's coin. Even Cintran."]
combat: null
shop: {stock: [{item: item.strept_furs, count: 1}, {item: item.frost_tallow, count: 4}, {item: item.mutton_bait, count: 3}, {item: item.field_draught, count: 3}, {item: item.fire_oil, count: 3}, {item: item.crossbow_bolt, count: 20}], price_mod: 1.2}
```

```yaml npc
id: npc.dun_strept_alewife
name: "Una"
faction: faction.strept
role: "Alewife of Dun Strept; rumor source"
motive: "Hear everything first."
secret: null
disposition: neutral
essential: false
dialogue: dlg.una_alewife
barks: ["Heather ale. It's better than what you drink down there.", "Miners say the hill's knocking again.", "You're the one with the crown in your pack. Everyone knows."]
combat: null
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.hesk
participants: [npc.hesk, npc.corra_ironjaw]
start: open
nodes:
  open:
    type: branch
    cases:
      - {if: "act() < 3 and flag(flag.hesk_met)", next: a2_again}
      - {if: "act() < 3", next: a2_first}
      - {if: "flag(flag.strept_raid_called) and not flag(flag.strept_raid_done)", next: raid_waiting}
      - {if: "flag(flag.strept_stone_defended) and not flag(flag.hesk_thanked)", next: thanks}
      - {if: "flag(flag.hesk_met_a3)", next: again}
    else: a3_first
  a2_first:
    type: line
    speaker: npc.hesk
    text: "Cintra. In my hall. In daylight. My grandmother would have had your ears for her doorpost."
    direction: "He doesn't rise from the high seat."
    effects: ["set_flag(flag.hesk_met)"]
    next: a2_hub
  a2_again:
    type: line
    speaker: npc.hesk
    text: "Back again. You've the look of someone with something in their pack, or nothing at all."
    next: a2_hub
  a2_hub:
    type: choice
    options:
      - id: torc
        text: "[Item: Bronze-and-iron torc] I carried this off Marnadal Field. Its owner asked me to bring it home."
        tag: item
        condition: "has_item(item.marnadal_torc)"
        next: torc_take
      - id: provocateur
        text: "[Clue: The feathered envoy] The man who carried the levy letters into your halls in 1263 wore a pale feather. The Choir started Marnadal."
        tag: clue
        condition: "has_clue(clue.marnadal_provocateur) and not flag(flag.hesk_told_provocateur)"
        next: provo
      - id: terms
        text: "What would it take for the clans to help Cintra?"
        next: a2_terms
      - id: stone
        text: "They say your clans keep a carved stone."
        condition: "not flag(flag.strept_stone_shown)"
        next: stone_ask
      - id: leave
        text: "I'll go."
        next: bye
  a2_terms:
    type: line
    speaker: npc.hesk
    text: "Bring Darrach Hall's torc home from that field. Or bring me Kosk on his knees, in ink if not in person. Then come back when Cintra needs us, and see what it bought."
    next: a2_hub
  a3_first:
    type: line
    speaker: npc.hesk
    text: "Cintra. I can smell the Marshal's horses on you from the gate."
    effects: ["set_flag(flag.hesk_met_a3)", "set_flag(flag.hesk_met)"]
    next: a3_first_tone
  a3_first_tone:
    type: branch
    cases:
      - {if: "rep_tier(faction.strept) >= friendly", next: a3_warm}
    else: a3_cold
  a3_warm:
    type: line
    speaker: npc.hesk
    text: "You've done right by the clans before. That buys you a seat at my fire. It doesn't buy my spears."
    next: horn
  a3_cold:
    type: line
    speaker: npc.hesk
    text: "Speak quick. My people buried their grandparents in ash because men who talk like you said it was necessary."
    next: horn
  horn:
    type: line
    speaker: npc.corra_ironjaw
    text: "Father! Monks on the north cliff, roped like goats, with a powder keg. They're going for the stone!"
    effects: ["play_beat(raid_horn)"]
    next: horn_choice
  horn_choice:
    type: choice
    options:
      - id: help
        text: "Then let's stop them."
        effects: ["set_flag(flag.strept_raid_called)"]
        next: horn_help
      - id: why
        text: "Why would the Choir want your stone?"
        once: true
        next: horn_why
      - id: refuse
        text: "Your stone. Your fight."
        effects: ["set_flag(flag.strept_raid_called)", "set_flag(flag.strept_raid_refused)"]
        next: horn_refuse
  horn_why:
    type: line
    speaker: npc.hesk
    text: "Because it says what your Abbot's book doesn't any more. Go and ask them with steel."
    next: horn_choice
  horn_help:
    type: line
    speaker: npc.hesk
    text: "Corra, take them up the stone path. If the Cintran runs, push them off the cliff after the monks."
    next: bye
  horn_refuse:
    type: effect
    effects: ["set_flag(flag.strept_raid_done)", "set_flag(flag.standing_stone_broken)", "add_rep(faction.strept, -10)", "play_beat(stone_blast)"]
    next: refuse_after
  refuse_after:
    type: line
    speaker: npc.hesk
    text: "Hear that? Four hundred years of carving. Gone while you stood at my fire. Talk, then. I'm listening, and I'm not your friend."
    next: hub
  raid_waiting:
    type: line
    speaker: npc.hesk
    text: "Why are you still at my fire? The stone, Cintran!"
    next: bye
  thanks:
    type: line
    speaker: npc.hesk
    text: "You bled on our stone. That's worth more than your Marshal's ink. Sit. Ama says you read it with her. Good."
    effects: ["set_flag(flag.hesk_thanked)", "set_flag(flag.strept_stone_shown)"]
    next: hub
  again:
    type: line
    speaker: npc.hesk
    text: "Say what you came to say."
    next: hub
  hub:
    type: choice
    options:
      - id: torc
        text: "[Item: Bronze-and-iron torc] I carried this off Marnadal Field. Its owner asked me to bring it home."
        tag: item
        condition: "has_item(item.marnadal_torc)"
        next: torc_take
      - id: apology
        text: "[Item: Kosk's apology] The Marshal's own hand. His name, his order, his blood-price."
        tag: item
        condition: "has_item(item.kosk_apology)"
        next: apology_take
      - id: bloodprice
        text: "Then I'll pay the blood-price myself. [Bribe 250]"
        tag: bribe
        bribe: 250
        condition: "not flag(flag.hesk_bloodprice_paid) and not flag(flag.hesk_apology_given)"
        next: bloodprice
      - id: provocateur
        text: "[Clue: The feathered envoy] The man who carried the levy letters into your halls in 1263 wore a pale feather. The Choir started Marnadal."
        tag: clue
        condition: "has_clue(clue.marnadal_provocateur) and not flag(flag.hesk_told_provocateur)"
        next: provo
      - id: persuade
        text: "The Choir has a Cintran boy. If they open that mountain, your clans are the first village downhill. [Persuade 8]"
        tag: persuade
        condition: "not flag(flag.hesk_persuaded)"
        once: true
        check: {skill: persuade, dc: 8, pass: persuade_pass, fail: persuade_fail}
      - id: intimidate
        text: "I came up your mountain through Choir knives. I can go down through yours. [Intimidate 8]"
        tag: intimidate
        once: true
        check: {skill: intimidate, dc: 8, pass: intim_pass, fail: intim_fail}
      - id: sway
        text: "Aldric will be king by spring. Be the chief who stood beside him, not the one who waited to see. [Sway]"
        tag: sway
        condition: "perk(perk.kingmaker) and not flag(flag.hesk_swayed)"
        next: sway
      - id: stone
        text: "Your stone. What does it say?"
        condition: "not flag(flag.strept_stone_shown) and not flag(flag.standing_stone_broken)"
        next: stone_ask
      - id: answer
        text: "What will you give, Hesk?"
        next: decision
      - id: leave
        text: "I'll be back."
        next: bye
  torc_take:
    type: line
    speaker: npc.hesk
    text: "Darrach Hall's torc. I saw it go down into the mud on a dead man's neck. Twenty of us went looking for it after. We came back with eleven."
    direction: "He takes it in both hands. The longhouse goes quiet."
    effects: ["take_item(item.marnadal_torc, 1)", "set_flag(flag.hesk_torc_given)", "add_rep(faction.strept, 40)", "play_beat(torc_raised)"]
    next: torc_rite_check
  torc_rite_check:
    type: branch
    cases:
      - {if: "flag(flag.torc_rite_known)", next: torc_rite_offer}
    else: torc_end
  torc_rite_offer:
    type: choice
    options:
      - id: rite
        text: "His spirit taught me the cairn-words. Let me say them over the empty cairn."
        next: torc_rite
      - id: no_rite
        text: "He's yours now. That's enough."
        next: torc_end
  torc_rite:
    type: line
    speaker: player
    text: "Home from the mud. Home from the iron. The hill holds you now."
    direction: "At the empty cairn, while Hesk hangs the torc on its stand."
    effects: ["add_rep(faction.strept, 10)", "play_beat(cairn_rite)"]
    next: torc_rite_after
  torc_rite_after:
    type: line
    speaker: npc.hesk
    text: "Where does a lowlander learn the cairn-words? No. Don't tell me. He's home. That's all I'll ask of the dead tonight."
    next: torc_end
  torc_end:
    type: line
    speaker: npc.hesk
    text: "You brought a dead man home when your Marshal couldn't be bothered to count ours. Sit down."
    next: back_hub
  back_hub:
    type: branch
    cases:
      - {if: "act() < 3", next: a2_hub}
    else: hub
  apology_take:
    type: line
    speaker: npc.hesk
    text: "'I gave the order. I did not send anyone to count.' He writes like a soldier. No excuses in it. Almost none."
    direction: "He reads it twice, lips moving, then hands it to Corra to read a third time."
    effects: ["take_item(item.kosk_apology, 1)", "set_flag(flag.hesk_apology_given)", "add_rep(faction.strept, 30)"]
    next: apology_after
  apology_after:
    type: line
    speaker: npc.hesk
    text: "Two hundred crowns for three halls. The silver's an insult. The words aren't. I'll keep the words, and the widows will keep the silver."
    next: hub
  bloodprice:
    type: line
    speaker: npc.hesk
    text: "Coin from a hired sword's purse. It's not your shame you're buying off. Still. Coin feeds widows."
    direction: "He weighs the purse in one hand, then tosses it to the bench where the old women sit."
    effects: ["set_flag(flag.hesk_bloodprice_paid)", "add_rep(faction.strept, 20)"]
    next: hub
  provo:
    type: line
    speaker: npc.hesk
    text: "A pale feather. There was a monk. Soft voice. He brought letters in the Marshal's name demanding our sons for the levy. We burned the letters, and the war came."
    effects: ["set_flag(flag.hesk_told_provocateur)", "add_rep(faction.strept, 10)"]
    next: provo_after
  provo_after:
    type: line
    speaker: npc.hesk
    text: "If that's true, we've been killing the wrong lowlanders for five years. I'll have to think on that. Not tonight."
    next: back_hub
  persuade_pass:
    type: line
    speaker: npc.hesk
    text: "Downhill. Aye. Corvan's dwarves didn't seal that mountain for Cintra's sake alone. My grandmother said the clans held the watch before there were kings."
    effects: ["set_flag(flag.hesk_persuaded)", "add_rep(faction.strept, 10)"]
    next: hub
  persuade_fail:
    type: line
    speaker: npc.hesk
    text: "Cintra's boys have always been worth more than ours. Tell me something I don't know."
    next: hub
  intim_pass:
    type: line
    speaker: npc.hesk
    text: "Ha! There's a spine in there after all. Fine. You'll be heard."
    direction: "He laughs, and half the hall laughs with him."
    effects: ["add_rep(faction.strept, 5)"]
    next: hub
  intim_fail:
    type: line
    speaker: npc.corra_ironjaw
    text: "Say that again, lowlander, and you'll go down the quick way. Off the north edge."
    effects: ["add_rep(faction.strept, -10)"]
    next: hub
  sway:
    type: line
    speaker: npc.hesk
    text: "Beside a Cintran king. My father would have spat. My father's in the Ash Hall's floor. Go on, then."
    effects: ["set_flag(flag.hesk_swayed)", "add_rep(faction.strept, 10)"]
    next: hub
  stone_ask:
    type: branch
    cases:
      - {if: "rep_tier(faction.strept) >= friendly", next: stone_show}
    else: stone_refuse
  stone_show:
    type: line
    speaker: npc.hesk
    text: "It says what your Abbot cut out of his book. Four lines, carved before there was a Cintra. Ama keeps it. Tell her I sent you."
    effects: ["set_flag(flag.strept_stone_shown)"]
    next: back_hub
  stone_refuse:
    type: line
    speaker: npc.hesk
    text: "It's not for lowlander eyes. Earn my fire first."
    next: back_hub
  decision:
    type: branch
    cases:
      - {if: "rep_tier(faction.strept) >= allied and not flag(flag.hesk_warband_given)", next: decide_allied}
      - {if: "rep_tier(faction.strept) >= friendly and not flag(flag.strept_guides)", next: decide_friendly}
      - {if: "flag(flag.hesk_warband_given)", next: decide_all_given}
      - {if: "flag(flag.strept_guides)", next: decide_guides_given}
    else: decide_refuse
  decide_allied:
    type: line
    speaker: npc.hesk
    text: "You'll have guides. And you'll have Corra and three of my best. They'll hold the Choir's dogs outside that mountain while you go in after the boy."
    effects: ["set_flag(flag.strept_guides)", "set_flag(flag.strept_stone_shown)", "set_flag(flag.hesk_warband_given)", "add_ally(ally.strept_warband)", "play_beat(warband_musters)", "reach_milestone(ms.a3_strept_resolved)"]
    next: decide_allied_corra
  decide_allied_corra:
    type: line
    speaker: npc.corra_ironjaw
    text: "Four of us. Enough to make them think it's forty. I'll be at the gate when you're ready."
    next: bye
  decide_friendly:
    type: line
    speaker: npc.hesk
    text: "Guides, then. Two shepherds who know the ledge path round your Choir's barricade. Spears are another matter. Spears you haven't earned."
    effects: ["set_flag(flag.strept_guides)", "set_flag(flag.strept_stone_shown)", "reach_milestone(ms.a3_strept_resolved)"]
    next: bye
  decide_guides_given:
    type: line
    speaker: npc.hesk
    text: "You have my guides. Give me more reason and I'll give you more men."
    next: hub
  decide_all_given:
    type: line
    speaker: npc.hesk
    text: "You have everything in this hall that can hold a spear. Go and use it."
    next: bye
  decide_refuse:
    type: line
    speaker: npc.hesk
    text: "Nothing. Not a guide. Not a goat. Cintra burned my halls and now Cintra wants my sons. Climb your Stairs alone."
    effects: ["set_flag(flag.strept_refused)", "reach_milestone(ms.a3_strept_resolved)"]
    next: refuse_corra
  refuse_corra:
    type: line
    speaker: npc.corra_ironjaw
    text: "Father..."
    direction: "He silences her with a look. She glances at the player on the way out: not yet a no."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.ama_kerrow
participants: [npc.ama_kerrow]
start: open
nodes:
  open:
    type: branch
    cases:
      - {if: "flag(flag.standing_stone_broken) and not has_clue(clue.standing_stone_verse)", next: broken_rubbing}
    else: greet
  greet:
    type: line
    speaker: npc.ama_kerrow
    text: "Another lowlander at my door. The last one I let in was a monk. Look where that got us."
    next: hub
  broken_rubbing:
    type: line
    speaker: npc.ama_kerrow
    text: "They broke it. Four hundred winters, and a keg of powder. Well. I've taken a rubbing every solstice since I was a girl. Here. Read it before I burn it for warmth."
    direction: "She sits in the ring among the shards, a roll of hide across her knees."
    effects: ["add_clue(clue.standing_stone_verse)", "give_item(item.standing_stone_rubbing, 1)"]
    next: hub
  hub:
    type: choice
    options:
      - id: show
        text: "Hesk sent me. Show me the stone."
        condition: "flag(flag.strept_stone_shown) and not has_clue(clue.standing_stone_verse) and not flag(flag.standing_stone_broken)"
        next: show
      - id: persuade_show
        text: "The Choir wants every copy of those verses gone. Let me see yours before they get it. [Persuade 6]"
        tag: persuade
        condition: "not flag(flag.strept_stone_shown) and not has_clue(clue.standing_stone_verse) and not flag(flag.standing_stone_broken)"
        once: true
        check: {skill: persuade, dc: 6, pass: show, fail: persuade_fail}
      - id: bribe_show
        text: "For the cairns, then. [Bribe 40]"
        tag: bribe
        bribe: 40
        condition: "not flag(flag.strept_stone_shown) and not has_clue(clue.standing_stone_verse) and not flag(flag.standing_stone_broken)"
        next: bribe_show
      - id: compare
        text: "[Item: The authentic fourth verse] I have this from the Choir's own vault. Does it match?"
        tag: item
        condition: "has_item(item.true_fourth_verse) and has_clue(clue.standing_stone_verse)"
        once: true
        next: compare
      - id: monk
        text: "You said a monk. Which monk?"
        condition: "not has_clue(clue.marnadal_provocateur)"
        next: monk_open
      - id: older
        text: "Who carved the stone?"
        next: older
      - id: leave
        text: "I'll leave you to it."
        next: bye
  show:
    type: line
    speaker: npc.ama_kerrow
    text: "Come, then. Mind the third step, it's ice. And take your gloves off. Nobody reads this stone with gloves on."
    effects: ["set_flag(flag.strept_stone_shown)"]
    next: hub
  persuade_fail:
    type: line
    speaker: npc.ama_kerrow
    text: "Every lowlander wants to save something. Bring me the chief's word."
    next: hub
  bribe_show:
    type: line
    speaker: npc.ama_kerrow
    text: "Silver for the dead. Shameless. The dead don't mind. Come on, then."
    effects: ["set_flag(flag.strept_stone_shown)"]
    next: hub
  compare:
    type: line
    speaker: npc.ama_kerrow
    text: "'Till nineteen winters turn to light.' Word for word. Your Choir copied it right before they cut it out. Thieves are careful with what they steal."
    effects: ["add_xp(120)"]
    next: hub
  monk_open:
    type: line
    speaker: npc.ama_kerrow
    text: "The spring before the war. A soft voice, a grey stole, a feather sewn in his collar. I thought it was a gull's. He had letters he couldn't read us himself, he said, his eyes were weak."
    next: monk_choice
  monk_choice:
    type: choice
    options:
      - id: notice
        text: "You read them for him. Didn't you. [Investigate 6]"
        tag: investigate
        once: true
        check: {skill: investigate, dc: 6, pass: monk_confess, fail: monk_shut}
      - id: kind
        text: "Whatever he made you do, he's done worse since. Tell me. [Persuade 4]"
        tag: persuade
        condition: "rep_tier(faction.strept) >= friendly"
        show_locked: true
        once: true
        check: {skill: persuade, dc: 4, pass: monk_confess, fail: monk_shut}
      - id: drop
        text: "Never mind."
        next: hub
  monk_confess:
    type: line
    speaker: npc.ama_kerrow
    text: "I read them aloud in three halls. 'The Marshal demands your sons.' I watched the young men burn them. Then the Marshal came. You tell Hesk. I never could."
    effects: ["add_clue(clue.marnadal_provocateur)"]
    next: hub
  monk_shut:
    type: line
    speaker: npc.ama_kerrow
    text: "My eyes are weak too, these days. Go away."
    next: hub
  older:
    type: line
    speaker: npc.ama_kerrow
    text: "The dwarves. For us. Before Corvan, the clans kept the high watch for the mountain-folk. 'The watch we keep,' it says. That was us. Cintra took the words and forgot whose they were."
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.corra
participants: [npc.corra_ironjaw]
start: open
nodes:
  open:
    type: branch
    cases:
      - {if: "flag(flag.strept_raid_called) and not flag(flag.strept_raid_done)", next: raid_go}
    else: greet
  raid_go:
    type: line
    speaker: npc.corra_ironjaw
    text: "Up the stone path, now. Stay low past the ring stones, their crossbows are on the cliff lip. The keg man's the one who matters."
    next: bye
  greet:
    type: line
    speaker: npc.corra_ironjaw
    text: "Lowlander."
    next: hub
  hub:
    type: choice
    options:
      - id: father
        text: "Your father hates Cintra. Do you?"
        next: father
      - id: shoe
        text: "The shoe over the Ash Hall door."
        condition: "flag(flag.strept_stone_defended)"
        once: true
        next: shoe
      - id: done
        text: "Never mind."
        next: bye
  father:
    type: line
    speaker: npc.corra_ironjaw
    text: "I hate whoever lit it. Five years I thought that was Kosk. Lately I've been thinking about who carried the matches."
    next: hub
  shoe:
    type: line
    speaker: npc.corra_ironjaw
    text: "My brother's. I was in the root cellar under him. Don't say you're sorry. Just get your prince out, so somebody's brother comes home this winter."
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.kellan_gate
participants: [npc.kellan_gatewarden]
start: greet
nodes:
  greet:
    type: branch
    cases:
      - {if: "rep_tier(faction.strept) >= friendly", next: friendly}
    else: wary
  friendly:
    type: line
    speaker: npc.kellan_gatewarden
    text: "Chief says you're to be let in. Chief says a lot of things lately."
    next: bye
  wary:
    type: line
    speaker: npc.kellan_gatewarden
    text: "In, then. Hands where I can see them. You don't go up the stone path without the chief's word."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.ewin_trader
participants: [npc.ewin_trader]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.ewin_trader
    text: "Furs, tallow, mutton. The furs halve the cold. The mutton halves the troll. Buy both."
    next: hub
  hub:
    type: choice
    options:
      - id: shop
        text: "Show me."
        effects: ["open_shop(npc.ewin_trader)"]
        next: bye
      - id: mutton
        text: "Mutton for trolls?"
        next: mutton
      - id: done
        text: "Not today."
        next: bye
  mutton:
    type: line
    speaker: npc.ewin_trader
    text: "Frost trolls hunt the ice-bridges since the blasting drove the goats off. Throw a haunch down a crevasse and the troll goes after it. Then you walk past. Mostly."
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.una_alewife
participants: [npc.dun_strept_alewife]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.dun_strept_alewife
    text: "Sit. Drink. Listen. In that order."
    next: hub
  hub:
    type: choice
    options:
      - id: news
        text: "What's the talk?"
        next: news
      - id: choir
        text: "Seen monks pass?"
        next: choir
      - id: done
        text: "Thanks."
        next: bye
  news:
    type: line
    speaker: npc.dun_strept_alewife
    text: "Miners at the silver workings say the hill knocks at night, regular as a smith. And the wyvern's back on the Grey Matron ridge, screaming like a widow."
    effects: ["add_map_pin(map.silver_mine)"]
    next: hub
  choir:
    type: line
    speaker: npc.dun_strept_alewife
    text: "Mules. Dozens, up the Stairs' foot, loaded heavy. Ewin bought three back off them cheap. Don't tell the chief."
    next: hub
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.strept_stone_raid
zone: zone.dun_strept
enemies:
  - {enemy: enemy.choir_zealot, count: 2, spawn: choir_cliff_1, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 2, spawn: choir_cliff_2, variant: null}
  - {enemy: enemy.choir_zealot, count: 1, spawn: choir_sapper, variant: sapper}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.choir_zealot, count: 2, spawn: choir_cliff_1, variant: null}]}
attack_tokens: null
allow_yield: true
allies: [npc.corra_ironjaw]
checkpoint: before_raid
avoidable_by: []
on_won: ["set_flag(flag.strept_stone_defended)", "set_flag(flag.strept_raid_done)", "add_rep(faction.strept, 15)", "set_flag(flag.strept_stone_shown)"]
on_yielded: ["set_flag(flag.strept_stone_defended)", "set_flag(flag.strept_raid_done)", "add_rep(faction.strept, 15)", "set_flag(flag.strept_stone_shown)"]
on_player_fled: ["set_flag(flag.strept_raid_done)", "set_flag(flag.standing_stone_broken)", "add_rep(faction.strept, -10)", "play_beat(stone_blast)"]
```

Design notes. The zealots come over the north edge on ropes and fight in the ring, using the stones as cover. The two crossbowmen stay on the cliff lip, 10–12 m from the ring. Kicking one back while he stands on the lip sends him off the cliff (a 1.5 m push, gdd §6.4). The **sapper** is a zealot carrying a keg on his back. He walks toward the tall stone and ignores the player unless attacked. Fire (fire oil, or a zealot's self-immolation burst) detonates his keg in place for 60 fire damage in 3 m, killing him and damaging anyone nearby, but never the stone. This is a risk the player chooses, not a timer: the keg only goes off at the stone when the player leaves the fight (`on_player_fled`). The second wave of two zealots climbs once the first group is down. Corra fights alongside with a spear (scripted helper). Escalation stage 4 adds +1 member to Choir groups (gdd §6.1 stage 3 rule). The counts above are base counts.

## 7. Items and clues

```yaml item
id: item.strept_furs
name: "Strept furs"
category: armor
description: "Sheepskin and wolf fur over boiled leather, cut for the high ice. Halves the Chill rate (gdd §6.4)."
price: 180
stack_max: 1
equip_slot: armor
weapon: null
armor: {armor: 16, resist: {cold: 0.75}, mods: [{mod: chill_rate_pct, value: -50}]}
consumable: null
readable_text: null
```

```yaml item
id: item.mutton_bait
name: "Mutton haunch"
category: consumable
description: "Frozen hind of mutton on a cord. Throw it into a crevasse to draw a frost troll off an ice-bridge (a3.04)."
price: 12
stack_max: 3
equip_slot: null
weapon: null
armor: null
consumable: {effects: [], use_time: 0, quick_slot: false}
readable_text: null
```

```yaml item
id: item.standing_stone_rubbing
name: "Rubbing of the Strept stone"
category: document
description: "Charcoal on hide: the four verses of the Pact in old dwarven forms, with the Strept words cut beside them."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "By iron forged in mountain deep,\nBy lion's blood the watch we keep.\nLet bolt and bar hold fast the night,\nTill nineteen winters turn to light.\n\n(Beneath, in the younger Strept hand: 'The clans keep the high watch. The mountain-folk keep the deep.')"
```

```yaml item
id: item.sapper_orders
name: "Sapper's orders"
category: document
description: "A strip of oilcloth sewn inside the sapper's collar, next to his feather."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Brother. The clans' stone must not stand at solstice. Break it to gravel; leave no line whole. There must be no copy of the verses outside the Abbey's keeping but mine. The light is coming. - A."
```

```yaml clue
id: clue.standing_stone_verse
theory: theory.fourth_verse
title: "The Strept standing stone"
text: "The clans' stone at Dun Strept carries all four verses of the Pact, carved by the dwarves before Cintra existed. Its fourth line matches the verse from Vel Aram word for word: 'Till nineteen winters turn to light.'"
supports: [anselm]
refutes: []
```

```yaml clue
id: clue.marnadal_provocateur
theory: theory.choir
title: "The feathered envoy of 1263"
text: "In the spring before Marnadal, a soft-voiced monk with a pale feather in his collar brought forged levy letters in Kosk's name to three Strept halls, and had a clanswoman read them aloud. The clans burned the letters, and the war followed."
supports: []
refutes: []
```

```yaml clue
id: clue.choir_erasing_verse
theory: theory.fourth_verse
title: "Leave no line whole"
text: "Anselm sent sappers to blow up the Strept stone. He wants no copy of the verses anywhere but in his own keeping."
supports: [anselm]
refutes: []
```

```yaml deduction
id: ded.choir_lit_marnadal
theory: theory.choir
condition: "has_clue(clue.marnadal_provocateur) and (has_clue(clue.marnadal_chaplain) or ded(ded.marnadal_truth))"
title: "The Choir lit Marnadal from both ends"
text: "A feathered monk goaded the clans with forged letters, and a chaplain fed Kosk a massacre that never happened. Both were Anselm. Marnadal was his war before it was anyone's."
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.a3_strept_resolved, type: milestone, desc: "Hesk gave his Act III answer: refused, guides, or guides and war-band."}
  - {id: flag.strept_guides, type: bool, desc: "(gdd) Strept guides: the Shepherd's Ledge around the Stairs barricade; counts as guides for mountain-edge hazards."}
  - {id: flag.hesk_met, type: bool, desc: "The player has spoken with Hesk (any act)."}
  - {id: flag.hesk_met_a3, type: bool, desc: "The player has spoken with Hesk in Act III (raid horn has played)."}
  - {id: flag.hesk_torc_given, type: bool, desc: "The Darrach torc was returned to Hesk (epilogue Strept variant)."}
  - {id: flag.hesk_apology_given, type: bool, desc: "Kosk's apology was delivered to Hesk (epilogue Strept variant)."}
  - {id: flag.hesk_bloodprice_paid, type: bool, desc: "The player paid the blood-price personally."}
  - {id: flag.hesk_told_provocateur, type: bool, desc: "Hesk was told the Choir started Marnadal."}
  - {id: flag.hesk_persuaded, type: bool, desc: "Hesk persuade bonus used."}
  - {id: flag.hesk_swayed, type: bool, desc: "Hesk sway bonus used."}
  - {id: flag.hesk_thanked, type: bool, desc: "Hesk's thanks for defending the stone has played."}
  - {id: flag.hesk_warband_given, type: bool, desc: "Hesk committed Corra's war-band (ally.strept_warband added)."}
  - {id: flag.strept_refused, type: bool, desc: "Hesk's latest Act III answer was a refusal."}
  - {id: flag.strept_stone_shown, type: bool, desc: "The player may read the standing stone openly."}
  - {id: flag.strept_raid_called, type: bool, desc: "The Choir raid on the stone has been announced."}
  - {id: flag.strept_raid_refused, type: bool, desc: "The player refused to defend the stone."}
  - {id: flag.strept_raid_done, type: bool, desc: "The raid is over (won, fled, or refused)."}
  - {id: flag.strept_stone_defended, type: bool, desc: "The player defended the standing stone."}
  - {id: flag.standing_stone_broken, type: bool, desc: "The Choir blew up the standing stone."}
reads:
  - ms.act1_complete
  - flag.torc_rite_known
  - ded.marnadal_truth
  - clue.marnadal_chaplain
  - item.marnadal_torc
  - item.kosk_apology
  - item.true_fourth_verse
  - perk.kingmaker
```

## 9. Quest hooks
This section has no stage of its own. Its outcomes are optional objectives of `quest.main_a3` stage `key_to_the_mountain` (a3.03, order 20): "Win guides from the Strept clans" (`flag.strept_guides`) and "Bring Hesk's war-band" (`in_party(ally.strept_warband)`).

## 10. Rumors and event cards (optional)
Una is the rumor source `npc.dun_strept_alewife` that A07's `14-rumors.md` expects. Her two lines pin the Silver Mine and tease the Roost. No new rumor blocks.

## 11. Failure states and branches

```yaml branches
paths:
  - id: refuse
    when: "Strept below Friendly when the player asks for Hesk's answer."
    outcome: "ms.a3_strept_resolved; no guides, no war-band. Stairs barricade ambush forced (a3.04). The player may raise rep and ask again."
    sets: ["reach_milestone(ms.a3_strept_resolved)"]
  - id: guides
    when: "Strept Friendly."
    outcome: "flag.strept_guides: Shepherd's Ledge open, mountain-edge hazards waived; stone shown."
    sets: ["set_flag(flag.strept_guides)", "reach_milestone(ms.a3_strept_resolved)"]
  - id: warband
    when: "Strept Allied."
    outcome: "Guides plus ally.strept_warband: Corra's squad fights in the Stairs; −2 finale bodyguards (gdd §6.14)."
    sets: ["set_flag(flag.strept_guides)", "add_ally(ally.strept_warband)", "reach_milestone(ms.a3_strept_resolved)"]
  - id: stone_defended
    when: "The player wins enc.strept_stone_raid."
    outcome: "+15 Strept, stone shown, sapper's orders and clue.choir_erasing_verse."
    sets: ["set_flag(flag.strept_stone_defended)"]
  - id: stone_lost
    when: "The player refuses, flees the raid, or leaves the zone mid-raid."
    outcome: "−10 Strept; stone broken. Ama gives the rubbing and clue.standing_stone_verse with no check."
    sets: ["set_flag(flag.standing_stone_broken)"]
  - id: act_two_torc
    when: "Torc given in Act II."
    outcome: "+40 (and +10 rite) counted toward Act III; Hesk remembers."
    sets: ["set_flag(flag.hesk_torc_given)"]
failures:
  - id: player_dies_raid
    result: reload_checkpoint
    recover: "Reload before_raid on the stone path."
  - id: fall_from_cliff
    result: reload_checkpoint
    recover: "Reload before_raid."
  - id: no_torc_no_apology
    result: soft_fail
    recover: "Bribe 250 blood-price, the provocateur clue, persuade, sway and the stone raid all still raise Strept. Dun Strept is optional; the Stairs remain passable without it."
guarantees:
  - "ms.a3_strept_resolved is reachable with no check: ask Hesk 'What will you give?' in Act III (any reputation gives an answer)."
  - "clue.standing_stone_verse is always reachable: the stone (shown or defended), the Lore 6 touch, or Ama's rubbing with no check once the stone is broken."
```

## 12. Open questions
- **The champion's name and cairn-words.** I named the torc "Darrach Hall's torc" and wrote the cairn rite as "Home from the mud. Home from the iron. The hill holds you now." act2/04 (A05, Marnadal Field) owns the champion. Reconcile the hall name and the rite text with A05.
- **Dun Edra.** A07's Grey Ferry has the chaplain claim prisoners were hanged at "Dun Edra". I treat Dun Edra as a place name only; the three burned halls are Darrach and two unnamed halls.
- **Badge penalty (resolved by A08).** −2 to checks against Strept speakers, from `item.kosk_badge`'s `trinket.mods`; gdd §6.9 now says the same.
- **Strept furs (resolved by A08).** `armor.mods: [{mod: chill_rate_pct, value: -50}]` (content-format §J.6).
- **Thrown bait (resolved by A08).** `item.mutton_bait` has `consumable: {effects: [], use_time: 0, quick_slot: false}` (§J.6).
- **Ally in `allies`.** Corra is listed as an encounter helper by npc id. When the war-band has left, the `warband_gone` variant removes her, so the raid (which can only happen before Hesk's decision) is unaffected.
