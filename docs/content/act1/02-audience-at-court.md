---
section_id: a1.02
title: "Audience at Court"
act: 1
story_ref: "story.md §3 Court & Crown, §5.2 (and the §5.1 note on the passes); gdd.md §7.1 #2"
zones: [zone.cintra_streets, zone.palace_hall]
available_when: "ms(ms.a1_rat_survived)"
escalation_stage_required: {min: 0, max: 0}
milestones_set: [ms.a1_audience_done]
milestones_read: [ms.a1_rat_survived, ms.a1_audience_done, ms.a1_sickroom_done, ms.a1_abbey_done, ms.a1_ring_done, ms.act1_complete]
level_band: [2, 2]
---

# Audience at Court

## 1. Scene summary

At first light Hale climbs the Lion Steps with a dead man's letter. Queen Ysolde holds a brief council in the Lion Hall, wrapped in heavy velvet to hide the tremor in her hands. Hale tells the story of the Drowned Rat in front of the people who matter: Lord Marshal Kosk, grim and silent; Chancellor Varn, sweating and loud, who demands the letter be handed to the Chancellery and the sellsword locked up; and Abbot Anselm, the Queen's gentle confessor, who offers prayers for the courier and the Abbey's library to study the dwarven seal. The Queen reads the letter, goes white, and closes the council. Afterwards, in private, Kosk hires Hale with the Marshal's writ, because he cannot trust guards on Varn's payroll. He explains why no one can simply ride to Ostrel: the high passes are already snowed in, and Ostrel's gate will not open for anyone until the Crown's business in Cintra is settled. He sets out the leads: the Queen's sickroom, the Abbey's *Book of the Lion*, the Ring of Nine, and the dark Gull Tower. On the way out, Prince Aldric catches Hale in the cloister garden with a wooden sword and a hundred questions. The dramatic question: *who in this hall can be trusted?* The section ends when Kosk hires Hale (`ms.a1_audience_done`); the Aldric scene and Varn's approach are optional but strongly placed.

## 2. Progress and escalation

- Stage 0. `ms.a1_audience_done` is reached when Kosk gives the writ (`dlg.kosk_hire`, no check on the main path). It also gives `faction.crown` +15 (gdd §6.12) and opens the Gull Tower map edge (gdd §7.5, edge condition is the milestone itself).
- This file also owns the hub (`zone.cintra_streets`) and the palace hall (`zone.palace_hall`), so later Act I and Act II beats that happen there are wired here as **variants and triggers**:
  - `t_fair_summons` (palace hall): when the Act I gate is met, a page brings Hale to Kosk for the Fair announcement (`dlg.kosk_fair_announce`, declared in `07-harvest-fair.md`).
  - Triggers `t_aldric_farewell` (tower stair) and `t_maelis_gate` (gatehouse) start the Act I farewells after Kosk's orders (dialogues in `08-act1-transition.md`).
  - Variant `stage1_court` (stage ≥ 1): Kosk and Varn clash openly in the Lion Hall (gdd §6.1 stage 1 effect), played in `08-act1-transition.md`.
  - Trigger `t_varn_ambush` (hub): if Varn is Hostile once stage 1 begins, his toughs ambush the player once in the market square (`enc.hub_varn_ambush`, declared in `08-act1-transition.md`; gdd §6.12).
  - Variant `act2_hall`: Aldric's gallery seat is empty during the day (he is kept under guard in the east tower).

## 3. Location layout

### 3.1 Cintra streets (`zone.cintra_streets`, hub)

The hub is a compact walkable slice of the capital, about 160 × 120 m, built around one market square. Day look. Every exit is a named gate or stair, so the player always knows where the next zone is.

```
                 [LION STEPS -> palace gate]
                         |
 [CORWEN BRIDGE]--- MARKET SQUARE (Lion Fountain) ---[CHANCELLERY LANE -> clerks' stair]
   -> Abbey              |              \
                         |               [LION GATE -> Ring of Nine road, stables map board]
                  [FISHMARKET ARCH -> docks]
```

- **market_square**: cobbles round the Lion Fountain (a weathered stone lion with its tail broken off). Cintra Market stalls on three sides: Goodwife Marta Kell's general stall (shop), a cooper, a fishwife, a ballad-seller who sings the news (rumor source). A **notice pillar** (readables). Pigeons, mud, a gibbet with an empty cage.
- **lion_steps**: a broad stair up to the palace gatehouse (north). Corporal Hesse and two palace guards on the gate. They wear Varn's blue cord on their sleeves under the royal colors (Investigate 4 to notice).
- **chancellery_lane** (NE): a narrow lane between the Chancellery tower and the river toll-house. The **clerks' stair** door leads up into the Chancellery (`zone.chancellery_rooftops`, opened by section 3). At night the top window of the tower glows.
- **corwen_bridge** (W): a stone bridge over a channel of the Yaruga to the Abbey of St. Corwen on the far bank. Beggars on the bridge. The Abbey bells are visible from here.
- **lion_gate** (E): the old city gate, the road out past barrow-mounds to the Ring of Nine (`zone.ring_of_nine`), and the gate stables with the **travel map board** (gdd §6.3).
- **fishmarket_arch** (S): back down to the docks.

### 3.2 The palace (`zone.palace_hall`)

A grey stone palace, cold even in autumn. Dawn look through tall east windows.

- **gatehouse** (S): a vaulted entry, guardroom to one side. Spawn from the streets.
- **lion_hall** (centre, 30 × 14 m): the council hall. Pillars down both sides (cover, though no fighting is expected here). At the north end a low dais with the Queen's carved chair under a banner of the lion. A long council table below the dais: Kosk stands at its east end, Varn sits at the west, Anselm stands at the Queen's left hand. Petitioners' bench by the south doors.
- **gallery** (W side, raised 4 m, reached by a stair from the hall): a wooden gallery where Prince Aldric watches councils he is not allowed to sit in.
- **antechamber** (SE): a waiting room with a brazier and benches. Varn's approach happens here.
- **war_room** (E): Kosk's private room: a big table with the 1262 realm survey map, a rack of swords, a cot (he sleeps here). Lockable. Used here for the hire, in section 7 for the Fair announcement, and in section 8 for the orders south.
- **cloister_garden** (NE, open to the sky): a square of clipped box hedges, a fig tree, a practice pell (a wooden post) with Aldric's wooden sword marks on it.
- **tower_stair** (E): to the Queen's sickroom in the east tower (`zone.palace_sickroom`). Guarded; opens with the writ.
- **service_passage** (N): to the kitchens (`zone.palace_kitchens`).

```yaml zone
id: zone.cintra_streets
name: "Cintra"
kind: hub
map_node: map.cintra
time_of_day: day
cold_rate: 0
disguise_tag: null
music: city_day
areas:
  - {id: market_square, description: "Cobbled square round the broken-tailed Lion Fountain. Market stalls on three sides, ballad-seller, notice pillar, an empty gibbet cage."}
  - {id: lion_steps, description: "Broad stair north to the palace gatehouse. Corporal Hesse and two palace guards wearing Varn's blue cord under the royal colors."}
  - {id: chancellery_lane, description: "Narrow NE lane between the Chancellery tower and the river toll-house. The clerks' stair door. The tower's top window glows at night."}
  - {id: corwen_bridge, description: "Stone bridge west over a Yaruga channel to the Abbey of St. Corwen. Beggars. The bell tower visible over the water."}
  - {id: lion_gate, description: "Old east gate. Road out to the barrow-mounds and the Ring of Nine. Gate stables with the travel map board."}
  - {id: fishmarket_arch, description: "South arch down to the Fishmarket and Eel Row."}
spawns:
  - {id: docks_gate, area: fishmarket_arch, default: true}
  - {id: palace_gate, area: lion_steps, default: false}
  - {id: chancellery_door, area: chancellery_lane, default: false}
  - {id: abbey_lane, area: corwen_bridge, default: false}
  - {id: lion_gate, area: lion_gate, default: false}
  - {id: map_arrival, area: lion_gate, default: false}
  - {id: alley_mouth, area: market_square, default: false}
exits:
  - id: to_docks
    area: fishmarket_arch
    to_zone: zone.cintra_docks
    to_spawn: market_gate
    condition: "true"
    effects: []
  - id: to_palace
    area: lion_steps
    to_zone: zone.palace_hall
    to_spawn: from_streets
    condition: "flag(flag.summoned_by_kosk) or has_item(item.kosk_writ)"
    effects: []
  - id: to_chancellery
    area: chancellery_lane
    to_zone: zone.chancellery_rooftops
    to_spawn: clerks_stair
    condition: "flag(flag.varn_light_seen) or flag(flag.varn_chase_lost) or rumor_heard(rumor.r02_varn_ledgers)"
    effects: []
  - id: to_abbey
    area: corwen_bridge
    to_zone: zone.abbey_st_corwen
    to_spawn: almonry_steps
    condition: "ms(ms.a1_audience_done)"
    effects: []
  - id: to_ring
    area: lion_gate
    to_zone: zone.ring_of_nine
    to_spawn: road_in
    condition: "ms(ms.a1_audience_done)"
    effects: []
  - {id: travel_gate, area: lion_gate, to_map: true, label: "Travel (gate stables)", condition: "ms(ms.a1_audience_done)", effects: []}
interactables:
  - id: notice_pillar
    area: market_square
    kind: readable
    label: "Notice pillar"
    condition: "true"
    check: null
    once: false
    effects: ["play_beat(read_pillar)"]
  - id: hesse_cord
    area: lion_steps
    kind: search
    label: "Look at the gate guards"
    condition: "true"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["play_beat(blue_cord_noticed)", "set_flag(flag.saw_varn_cord)"]
    fail_effects: []
  - id: fountain
    area: market_square
    kind: readable
    label: "The Lion Fountain"
    condition: "true"
    check: null
    once: false
    effects: ["play_beat(read_fountain)"]
triggers:
  - id: t_first_hub
    area: fishmarket_arch
    "on": enter
    source: null
    condition: "not ms(ms.a1_audience_done)"
    once: true
    effects: ["play_beat(dawn_city)"]
  - id: t_varn_ambush
    area: market_square
    "on": enter
    source: null
    condition: "stage() >= 1 and rep_tier(faction.varn) == hostile and not flag(flag.varn_ambush_done)"
    once: true
    effects: ["set_flag(flag.varn_ambush_done)", "play_beat(varn_toughs)", "start_encounter(enc.hub_varn_ambush)"]
  - id: t_gull_news
    area: market_square
    "on": enter
    source: null
    condition: "ms(ms.a1_audience_done) and not ms(ms.a1_gull_done) and stage() <= 1"
    once: true
    effects: ["play_beat(ballad_gull)", "add_map_pin(map.gull_tower)"]
hazards: []
checkpoints:
  - {id: hub_square, area: market_square}
beats:
  - {id: dawn_city, description: "Dawn over Cintra. Smoke from a thousand chimneys, the Abbey bells ringing properly now for Prime. Brask's soldier points up the Lion Steps and leaves."}
  - {id: read_pillar, description: "Notices: a reward for news of 'the vandal who cut the Holy Book' (St. Corwen, signed Anselm, Abbot); toll rates for the Yaruga raised again 'by order of the Chancellery'; 'MEN WANTED for the Marnadal Watch'."}
  - {id: blue_cord_noticed, description: "Under each palace guard's royal surcoat, a twist of blue silk cord at the sleeve: Chancellery livery. Hesse sees Hale looking and tugs his cuff down."}
  - {id: read_fountain, description: "The stone lion of Corvan, tail broken off generations ago. Children say the lion lost its tail to the dwarves as the price of the crown."}
  - {id: varn_toughs, description: "Three men in Chancellery blue cord step out of an alley mouth by the fountain, cudgels out. 'The Chancellor sends his regards.' Stallholders drag their shutters down. (gdd §6.12: Varn Hostile ambush, once.)"}
  - {id: ballad_gull, description: "The ballad-seller sings a new verse: the Gull Tower light on the headland has gone dark three nights running, and the fishing boats come home by guesswork. Map pin: Gull Tower."}
npcs:
  - {npc: npc.marta_kell, area: market_square, condition: "true"}
  - {npc: npc.ballad_seller, area: market_square, condition: "true"}
  - {npc: npc.corporal_hesse, area: lion_steps, condition: "stage() <= 3"}
encounters: [enc.hub_varn_ambush]
loot: []
variants:
  - id: stage1_city
    when: "stage() >= 1"
    description: "Black crepe on some doors. The ballad-seller sings about Kosk and Varn shouting in the Lion Hall. Prices up (gdd §6.1). More soldiers in Kosk's red-and-iron than palace guards."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: stage4_city
    when: "stage() >= 4"
    description: "Act III: the hub is closed except for the Lion Steps (gdd §6.1). Shutters down, the market empty, Kosk's men at every corner."
    npcs_absent: [npc.marta_kell, npc.ballad_seller]
    encounters_disabled: []
    interactables_disabled: []
    exits_disabled: [travel_gate]
```

```yaml zone
id: zone.palace_hall
name: "The Lion Hall"
kind: interior
map_node: map.cintra
time_of_day: dawn
cold_rate: 0
disguise_tag: null
music: court_cold
areas:
  - {id: gatehouse, description: "Vaulted south entry with a guardroom."}
  - {id: lion_hall, description: "30 x 14 m council hall. Pillars both sides. Dais with the Queen's carved chair under the lion banner. Long council table below. Petitioners' bench by the south doors."}
  - {id: gallery, description: "West wooden gallery, raised 4 m, stair from the hall. Aldric's seat."}
  - {id: antechamber, description: "SE waiting room. Brazier, benches, a tapestry of Corvan and the dwarf-king shaking hands over an anvil."}
  - {id: war_room, description: "Kosk's private room east of the hall. Table with the 1262 realm survey map, sword rack, a soldier's cot. Lockable."}
  - {id: cloister_garden, description: "NE garden open to the sky. Clipped box hedges, a fig tree, a practice pell scarred by a boy's wooden sword."}
  - {id: tower_stair, description: "East stair to the Queen's sickroom in the east tower. Two of Kosk's men on the door."}
  - {id: service_passage, description: "North passage to the kitchens. Smells of bread and lye."}
spawns:
  - {id: from_streets, area: gatehouse, default: true}
  - {id: from_sickroom, area: tower_stair, default: false}
  - {id: from_kitchens, area: service_passage, default: false}
  - {id: war_room, area: war_room, default: false}
  - {id: from_catacombs, area: service_passage, default: false}
exits:
  - id: to_streets
    area: gatehouse
    to_zone: zone.cintra_streets
    to_spawn: palace_gate
    condition: "true"
    effects: []
  - id: to_sickroom
    area: tower_stair
    to_zone: zone.palace_sickroom
    to_spawn: antechamber
    condition: "has_item(item.kosk_writ)"
    effects: []
  - id: to_kitchens
    area: service_passage
    to_zone: zone.palace_kitchens
    to_spawn: from_hall
    condition: "has_item(item.kosk_writ)"
    effects: []
interactables:
  - id: survey_map
    area: war_room
    kind: readable
    label: "The realm survey of 1262"
    condition: "ms(ms.a1_audience_done)"
    check: null
    once: false
    effects: ["play_beat(read_survey)"]
  - id: corvan_tapestry
    area: antechamber
    kind: readable
    label: "Tapestry of the Pact"
    condition: "true"
    check: {skill: lore, dc: 6}
    once: true
    effects: ["play_beat(tapestry_lore)"]
    fail_effects: ["play_beat(tapestry_plain)"]
  - id: aldric_pell
    area: cloister_garden
    kind: search
    label: "The practice pell"
    condition: "true"
    check: null
    once: true
    effects: ["play_beat(pell_marks)"]
triggers:
  - id: t_audience
    area: lion_hall
    "on": enter
    source: null
    condition: "not ms(ms.a1_audience_done)"
    once: true
    effects: ["set_checkpoint(before_audience)", "play_beat(council_sits)", "start_dialogue(dlg.audience_council)"]
  - id: t_varn_approach
    area: antechamber
    "on": enter
    source: null
    condition: "ms(ms.a1_audience_done) and not flag(flag.varn_approached)"
    once: true
    effects: ["start_dialogue(dlg.varn_antechamber)"]
  - id: t_aldric_garden
    area: cloister_garden
    "on": enter
    source: null
    condition: "ms(ms.a1_audience_done) and not flag(flag.met_aldric)"
    once: true
    effects: ["play_beat(aldric_at_pell)", "start_dialogue(dlg.aldric_garden)"]
  - id: t_fair_summons
    area: gatehouse
    "on": enter
    source: null
    condition: "ms(ms.a1_audience_done) and count_ms(ms.a1_sickroom_done, ms.a1_abbey_done, ms.a1_ring_done) >= 2 and not flag(flag.fair_announced)"
    once: true
    effects: ["play_beat(page_summons)", "goto_zone(zone.palace_hall, war_room)", "start_dialogue(dlg.kosk_fair_announce)"]
  - id: t_aldric_farewell
    area: tower_stair
    "on": enter
    source: null
    condition: "ms(ms.act1_complete) and act() >= 2 and not flag(flag.aldric_farewell_done)"
    once: true
    effects: ["start_dialogue(dlg.aldric_farewell)"]
  - id: t_maelis_gate
    area: gatehouse
    "on": enter
    source: null
    condition: "ms(ms.act1_complete) and act() >= 2 and rep_tier(faction.abbey) >= friendly and not flag(flag.maelis_accused) and flag(flag.maelis_showed_book) and not in_party(companion.maelis) and not flag(flag.maelis_joined_a1) and not flag(flag.maelis_stays_watch)"
    once: true
    effects: ["start_dialogue(dlg.maelis_joins)"]
hazards: []
checkpoints:
  - {id: before_audience, area: lion_hall}
  - {id: act2_start, area: war_room}
beats:
  - {id: council_sits, description: "Brask walks Hale up the hall. The Queen in heavy wine-dark velvet, gloved hands folded hard to stop them shaking. Kosk standing, Varn seated and dabbing his neck, Anselm at the Queen's left. A boy's face in the gallery."}
  - {id: queen_reads, description: "The Queen breaks Dravin's seal herself. Her gloved hand trembles; the paper rattles. She reads it twice, looks at Anselm, then at nothing. 'Leave us,' she says to the hall, and the council ends."}
  - {id: hire_handshake, description: "Kosk presses the writ into Hale's hand: a folded parchment with the Marshal's seal in red wax and a small iron badge pinned through it."}
  - {id: aldric_at_pell, description: "Thwack, thwack: a boy in a too-fine doublet is beating the practice pell with a wooden sword, badly, furiously. He stops when he sees Hale."}
  - {id: spar_aldric, description: "Hale and Aldric trade slow blows with wooden swords at the pell. Hale shows him how to take a cut on the flat and step in."}
  - {id: aldric_lands_hit, description: "Aldric's wooden sword cracks against Hale's ribs. He stares, then grins for the first time."}
  - {id: page_summons, description: "A page in the Marshal's colors runs up: 'The Lord Marshal asks for you. Now, please.'"}
  - {id: read_survey, description: "The 1262 realm survey: Cintra, the Yaruga, Attre on the coast, the Marnadal valley south, the Góry Amell. Karak Ostrel is a small anvil symbol in the mountains, with no road drawn to it."}
  - {id: tapestry_lore, description: "Hale reads the tapestry's border: four lines of stitched verse, the first three of the Oath, and a fourth line picked out and re-stitched in newer thread that does not match. Someone has mended it. Badly."}
  - {id: tapestry_plain, description: "Corvan and a dwarf-king clasp hands over an anvil. Old, faded, beautiful."}
  - {id: pell_marks, description: "The pell is hacked by a child's sword, always at the same height: a grown man's throat."}
  - {id: kosk_varn_clash, description: "Stage 1 court variant (played in section 8): Varn and Kosk on their feet in the Lion Hall, shouting over the Queen's empty chair about the regency."}
npcs:
  - {npc: npc.kosk, area: lion_hall, condition: "not ms(ms.a1_audience_done)"}
  - {npc: npc.kosk, area: war_room, condition: "ms(ms.a1_audience_done)"}
  - {npc: npc.varn, area: lion_hall, condition: "not ms(ms.a1_audience_done)"}
  - {npc: npc.varn, area: antechamber, condition: "ms(ms.a1_audience_done) and not flag(flag.varn_approached)"}
  - {npc: npc.anselm, area: lion_hall, condition: "not ms(ms.a1_audience_done)"}
  - {npc: npc.ysolde, area: lion_hall, condition: "not ms(ms.a1_audience_done)"}
  - {npc: npc.aldric, area: gallery, condition: "not ms(ms.a1_audience_done)"}
  - {npc: npc.aldric, area: cloister_garden, condition: "ms(ms.a1_audience_done) and not ms(ms.act1_complete)"}
  - {npc: npc.sergeant_brask, area: gatehouse, condition: "true"}
encounters: []
loot: []
variants:
  - id: stage1_court
    when: "stage() >= 1"
    description: "The Queen's chair is empty and draped. Kosk's soldiers have replaced the palace guards on the tower stair. The hall is colder; fewer petitioners. Varn's clerks huddle at the west end of the table."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: act2_hall
    when: "act() >= 2"
    description: "Aldric is kept in the east tower under guard; the gallery seat and the garden pell are empty. He can be visited through the war room (section 8 owns the farewell; Act II return is A05)."
    npcs_absent: [npc.aldric]
    encounters_disabled: []
    interactables_disabled: []
```

## 4. NPCs present

**Voice notes.**
- **Lord Marshal Bertran Kosk**: sixty, grey-cropped, a voice like a gate dragged over stone. Says little, means all of it. Soldier's metaphors. Never says "please" except to the Queen. Tired. When Marnadal comes up, he goes quiet and changes the subject.
- **Chancellor Orsik Varn**: fat, florid, perfumed over sweat. Talks in long subordinate clauses, interrupts, uses legal words wrongly. Loud in public, wheedling in private. Fidgets with his rings. Ink on his fingers, smoke in his clothes.
- **Abbot Anselm**: seventies, white-bearded, very gentle, never raises his voice. Calls people "my child". Scripture and small kindnesses. Every line can be read twice: he believes he is the only honest man in the palace, and he means everything he says about corruption.
- **Queen Ysolde**: forty, gaunt, sharp, dry humor. Speaks in short sentences because longer ones hurt. Pain shows only in pauses.
- **Prince Aldric**: twelve, proud, quick, sullen with adults who talk down to him, eager with anyone who doesn't. Asks direct questions. Repeats things Anselm told him as if they were his own ideas.
- **Corporal Hesse**: bored, venal, polite to anyone with a seal.
- **Marta Kell**: brisk market trader, gossip.
- **Ballad-seller (Tam Fiddle)**: sings the news, sells rumors for a copper.

```yaml npc
id: npc.kosk
name: "Lord Marshal Bertran Kosk"
faction: faction.crown
role: "Lord Marshal of Cintra, commander of the royal army"
motive: "Order, the Queen alive as long as possible, and Aldric safely crowned. Keep Varn's hands off the regency."
secret: "In 1263 he ordered the burning of three Strept clan halls to end the Marnadal guerrilla war. He is haunted by it, and the clans spit on his badge."
disposition: neutral
essential: true
dialogue: dlg.kosk
barks: ["Speak plainly.", "Not here.", "I've buried better men for less.", "The Queen first. Always."]
combat: null
shop: null
```

```yaml npc
id: npc.varn
name: "Chancellor Orsik Varn"
faction: faction.varn
role: "Chancellor of Cintra, keeper of the treasury and the river tolls"
motive: "Seize the regency when the Queen dies, and keep his books from ever being opened."
secret: "He has embezzled thousands of crowns from the Yaruga river tolls over ten years, and burns the incriminating ledgers in his solar after midnight. He is a thief, not a poisoner."
disposition: wary
essential: true
dialogue: dlg.varn
barks: ["Most irregular. Most irregular!", "The Chancellery will want a full account.", "Do you know who I am?", "Mind the carpet, it's Verden wool."]
combat: null
shop: null
```

```yaml npc
id: npc.anselm
name: "Abbot Anselm of St. Corwen"
faction: faction.abbey
role: "Abbot of St. Corwen and the Queen's confessor"
motive: "Publicly: to comfort the Queen and guard the Abbey's books. In truth: to burn the old order down by unsealing Karak Ostrel."
secret: "Leader of the Pale Choir. Former army chaplain at Marnadal (1263), disgusted by noble cruelty. Poisons the Queen's communion wine with grey lily, cut the fourth verse from the Book of the Lion, and means to make Aldric speak the Pact reversed."
disposition: friendly
essential: true
dialogue: dlg.anselm
barks: ["Peace, my child.", "God sees the ledger, even when men burn it.", "I will pray for you.", "So young, to carry so much."]
combat: enemy.anselm_human
shop: null
```

```yaml npc
id: npc.ysolde
name: "Queen Ysolde"
faction: faction.crown
role: "Queen of Cintra"
motive: "Live long enough to see Aldric safe and the winter lock spoken. Hide her decline from the vultures."
secret: "She knows the truth of the Deep-Vaults and the nineteen-year Oath, and has confided it only in Anselm. She is being poisoned with grey lily, not dying of fever."
disposition: neutral
essential: true
dialogue: dlg.ysolde
barks: ["Enough.", "Help me up. No one else sees this.", "My son is not porcelain."]
combat: null
shop: null
```

```yaml npc
id: npc.aldric
name: "Prince Aldric"
faction: faction.crown
role: "Crown Prince of Cintra, twelve years old"
motive: "To be treated as a man and an heir, not a porcelain doll. To protect his mother."
secret: "He has overheard Anselm's bitter truths about the court and half believes them. Anselm has been teaching him 'old dwarvish words for patience', which he murmurs in his sleep."
disposition: wary
essential: true
dialogue: dlg.aldric
barks: ["I'm not a child.", "Show me again.", "Mother says I mustn't. I'm going to.", "Father Anselm says everyone here is lying."]
combat: null
shop: null
```

```yaml npc
id: npc.corporal_hesse
name: "Corporal Hesse"
faction: faction.varn
role: "Palace gate guard on the Chancellery's quiet payroll"
motive: "An easy post, a second wage from Varn, no trouble."
secret: "Reports every visitor to the palace to Varn's clerk, Tobiah Quill."
disposition: neutral
essential: false
dialogue: dlg.hesse
barks: ["Seal or business.", "Move along.", "The Chancellor's compliments."]
combat: enemy.bandit
shop: null
```

```yaml npc
id: npc.marta_kell
name: "Goodwife Marta Kell"
faction: null
role: "General trader at Cintra Market"
motive: "Sell, gossip, sell more."
secret: "Buys smuggled brandy from Bertha and knows all about Bertha's debt."
disposition: friendly
essential: true
dialogue: dlg.marta_kell
barks: ["Poultices! Bolts! Lamp oil!", "Fresh from Attre, that. Don't ask how.", "You look like you need a poultice, dear."]
combat: null
shop: {stock: [{item: item.poultice, count: 10}, {item: item.crossbow_bolt, count: 40}, {item: item.antitoxin, count: 3}, {item: item.fire_oil, count: 3}, {item: item.smoke_pot, count: 2}, {item: item.cintran_mace, count: 1}, {item: item.brigandine, count: 1}], price_mod: 1.0}
```

```yaml npc
id: npc.ballad_seller
name: "Tam Fiddle, ballad-seller"
faction: null
role: "Sings the news in the market square for coppers"
motive: "Coppers and an audience."
secret: "Makes up a third of what he sings."
disposition: friendly
essential: true
dialogue: dlg.ballad_seller
barks: ["A copper for the news, a silver for the truth!", "Hear of the dark light on the Gull!", "Bells at midnight, bells at midnight..."]
combat: null
shop: null
```

## 5. Dialogue trees

### 5.1 The council

```yaml dialogue
id: dlg.audience_council
participants: [npc.ysolde, npc.kosk, npc.varn, npc.anselm, npc.sergeant_brask]
start: brask
nodes:
  brask:
    type: line
    speaker: npc.sergeant_brask
    text: "Your Majesty. My lords. The sellsword from the Drowned Rat. Tomas Wyle died in this one's arms."
    next: queen_open
  queen_open:
    type: line
    speaker: npc.ysolde
    text: "So I'm told. Come closer. My eyes are as tired as the rest of me. Tell me how my courier died."
    direction: "Gloved hands folded hard in her lap."
    next: tell_hub
  tell_hub:
    type: choice
    options:
      - id: plain
        text: "He came in frothing, Majesty. Poisoned on the road. He gave me this and said one word. 'Ostrel.'"
        next: varn_interrupt
      - id: monk
        text: "Poisoned. He said a monk on the road shared his cup."
        effects: ["set_flag(flag.told_council_monk)"]
        next: anselm_monk
      - id: blunt
        text: "Badly. Then three hired knives came for his letter. I sent them home lighter."
        next: varn_interrupt
  anselm_monk:
    type: line
    speaker: npc.anselm
    text: "A monk. God forgive whoever wears our grey to do murder. Many walk the pilgrim road, Majesty, and not all of them are what they seem."
    direction: "Soft, sorrowful, a hand on his heart."
    next: varn_interrupt
  varn_interrupt:
    type: line
    speaker: npc.varn
    text: "Majesty, this is most irregular! A sellsword from a dockside sink, holding a royal dispatch? That letter belongs in the Chancellery, and this person belongs in a cell until the matter is examined."
    direction: "Half rising, dabbing his neck."
    next: varn_hub
  varn_hub:
    type: choice
    options:
      - id: hand_varn
        text: "It's addressed to the Marshal. Not the Chancellery."
        next: kosk_takes
      - id: needle
        text: "You're sweating, Chancellor. In this cold."
        tag: intimidate
        check: {skill: intimidate, dc: 4, pass: needle_pass, fail: needle_fail}
        once: true
      - id: queen_only
        text: "I'll give it to no one but the Queen."
        next: queen_takes
  needle_pass:
    type: line
    speaker: npc.varn
    text: "I... it is a warm hall. My health is no concern of... Majesty, I protest!"
    direction: "The council goes very still. Kosk almost smiles."
    effects: ["add_rep(faction.varn, -5)", "set_flag(flag.varn_rattled)"]
    next: kosk_takes
  needle_fail:
    type: line
    speaker: npc.varn
    text: "Insolence. Note it, someone. Note it!"
    effects: ["add_rep(faction.varn, -5)"]
    next: kosk_takes
  kosk_takes:
    type: line
    speaker: npc.kosk
    text: "It's dwarf iron-wax, Orsik. Your clerks couldn't break it with a hammer. Majesty."
    direction: "He takes the letter from Hale and carries it up the dais himself."
    next: queen_reads
  queen_takes:
    type: line
    speaker: npc.ysolde
    text: "Good. Someone in this hall knows who they serve. Give it here."
    next: queen_reads
  queen_reads:
    type: effect
    effects: ["play_beat(queen_reads)"]
    next: queen_after
  queen_after:
    type: line
    speaker: npc.ysolde
    text: "Ostrel. In the nineteenth winter. Of course it is. ...Leave us. All of you. Marshal, deal with this one. Father, stay."
    direction: "She hands the letter back to Kosk without looking at it. Her hand closes on Anselm's sleeve."
    next: anselm_offer
  anselm_offer:
    type: line
    speaker: npc.anselm
    text: "My child. You have done a kind thing, at cost. The Abbey's library is open to you, if the dwarven seal or the old verses would help. Sister Maelis keeps our books. And I will pray for the boy who died."
    direction: "He lays a dry, light hand on Hale's shoulder in passing."
    next: anselm_hub
  anselm_hub:
    type: choice
    options:
      - id: thanks
        text: "Thank you, Father."
        effects: ["add_rep(faction.abbey, 2)"]
        next: dismissed
      - id: verses
        text: "Old verses?"
        next: anselm_verses
      - id: cold
        text: "Save your prayers for the living."
        next: anselm_cold
  anselm_verses:
    type: line
    speaker: npc.anselm
    text: "The Book of the Lion. Corvan's own words, the Oath the Crown speaks every nineteen winters. A beautiful old thing. Come and see it, before it is too late to see anything."
    next: dismissed
  anselm_cold:
    type: line
    speaker: npc.anselm
    text: "I do, my child. Every day. That is rather the trouble."
    next: dismissed
  dismissed:
    type: line
    speaker: npc.kosk
    text: "You. With me. Not a word in the corridor."
    next: chain
  chain:
    type: effect
    effects: ["goto_zone(zone.palace_hall, war_room)", "start_dialogue(dlg.kosk_hire)"]
    next: bye
  bye:
    type: end
```

### 5.2 Kosk hires Hale (war room)

```yaml dialogue
id: dlg.kosk_hire
participants: [npc.kosk]
start: open
nodes:
  open:
    type: line
    speaker: npc.kosk
    text: "Sit. No, stand, you'll fall asleep. I've had eight palace guards on my stair this month and I trust two. The rest draw a second wage from Varn's purse. You don't. Yet."
    direction: "The war room. He bolts the door himself."
    next: offer
  offer:
    type: line
    speaker: npc.kosk
    text: "So here it is. Somebody poisoned my courier to stop that letter. I want to know who, and why, and I want it done by someone nobody at court has bought. Crown's pay. My writ. My protection, such as it is."
    next: hire_hub
  hire_hub:
    type: choice
    options:
      - id: accept
        text: "I'll take it."
        next: accept
      - id: haggle
        text: "Crown's pay is famous for arriving late. Make it worth the risk. [Persuade 6]"
        tag: persuade
        check: {skill: persuade, dc: 6, pass: haggle_pass, fail: haggle_fail}
        once: true
      - id: why_me
        text: "Why not your own soldiers?"
        next: why_me
      - id: ostrel
        text: "Why not just ride to Ostrel and ask this Dravin?"
        next: passes
  why_me:
    type: line
    speaker: npc.kosk
    text: "Because my soldiers wear my badge, and every door in this palace closes when they knock. A sellsword can drink in the kitchens. A sellsword can be bought, and so can be bribed into telling me who else is buying."
    next: hire_hub
  passes:
    type: line
    speaker: npc.kosk
    text: "I asked the Warden of the Roads an hour ago. Snow came early to the Amell. The high passes are shut already; only goat tracks and the Marnadal Stairs, and nobody climbs those in winter and lives."
    next: passes_b
  passes_b:
    type: line
    speaker: npc.kosk
    text: "And Ostrel's gate doesn't open for a sellsword with a letter. It opens for the Crown. Whatever's wrong under that mountain, it starts here, in Cintra. So we solve Cintra first."
    effects: ["set_flag(flag.passes_closed_known)"]
    next: hire_hub
  haggle_pass:
    type: line
    speaker: npc.kosk
    text: "Ha. Brask said you'd a mouth on you. Fine. Double the advance, and if you're dead I'll see you buried somewhere dry."
    effects: ["add_crowns(40)"]
    next: accept
  haggle_fail:
    type: line
    speaker: npc.kosk
    text: "It's Crown's pay or the Fishmarket, sellsword. Pick."
    next: hire_hub
  accept:
    type: line
    speaker: npc.kosk
    text: "Good. This is my writ. Show it to any guard in red and iron and they'll open for you. Show it to Varn's men and watch them sweat. Forty crowns on account. Don't drink it all at Bertha's."
    direction: "He hands back Dravin's letter with the writ: 'Keep that. Dravin will want to see his own seal one day.'"
    effects: ["play_beat(hire_handshake)", "give_item(item.kosk_writ, 1)", "give_item(item.kosk_badge, 1)", "add_crowns(40)", "add_rep(faction.crown, 15)", "reach_milestone(ms.a1_audience_done)"]
    next: leads
  leads:
    type: line
    speaker: npc.kosk
    text: "Now listen. The Queen isn't dying of fever. I've watched men die of fever. That courier died the way she's dying, only faster. So that's where you start."
    next: leads_hub
  leads_hub:
    type: choice
    options:
      - id: sickroom
        text: "The Queen's sickroom."
        next: lead_sick
      - id: abbey
        text: "The Abbot mentioned a book."
        next: lead_abbey
      - id: ring
        text: "What's this Oath every nineteen winters?"
        next: lead_ring
      - id: gull
        text: "Anything else on fire this week?"
        next: lead_gull
      - id: chaplain
        text: "How long have you known the Abbot?"
        once: true
        next: chaplain
      - id: done
        text: "I know where to start."
        next: farewell
  lead_sick:
    type: line
    speaker: npc.kosk
    text: "East tower. My writ gets you past the door. Look at her cup, her food, her taster, her physician. Look at everyone. Look at me, if you like. I'd rather you did."
    next: leads_hub
  lead_abbey:
    type: line
    speaker: npc.kosk
    text: "The Book of the Lion. The Oath's written in it, the one she has to speak at the Ring of Nine this winter. If someone wants that lock to fail, they'll want that book. Go see Anselm's archivist."
    next: leads_hub
  lead_ring:
    type: line
    speaker: npc.kosk
    text: "Nine standing stones outside the Lion Gate. The crowned monarch speaks four verses there at solstice dawn. Shepherds say one stone's split and the hounds have gone mad round it. Find out what's wrong."
    next: leads_hub
  lead_gull:
    type: line
    speaker: npc.kosk
    text: "The Gull Tower light on the headland's been dark three nights. Keeper's not answering. Might be drink. Might be Attre's smugglers. If you've time, go and look. If you don't, don't."
    effects: ["add_map_pin(map.gull_tower)"]
    next: leads_hub
  chaplain:
    type: line
    speaker: npc.kosk
    text: "Anselm? He marched with us to Marnadal in '63, as chaplain. Buried half my men with his own hands. Never forgave any of us for that war, I think. Can't say I blame him. He's a good man."
    direction: "He looks at the map, not at Hale."
    effects: ["add_clue(clue.marnadal_chaplain)"]
    next: leads_hub
  farewell:
    type: line
    speaker: npc.kosk
    text: "Two of those leads, at least, before you come back to me. And sellsword: the Prince will try to talk to you. He talks to everyone who isn't me. Be kind to him. He's had little enough of it."
    next: bye
  bye:
    type: end
```

### 5.3 Kosk (default, later visits)

```yaml dialogue
id: dlg.kosk
participants: [npc.kosk]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "not ms(ms.a1_audience_done)", next: busy}
    else: greet
  busy:
    type: line
    speaker: npc.kosk
    text: "Not now."
    next: bye
  greet:
    type: line
    speaker: npc.kosk
    text: "Report."
    next: hub
  hub:
    type: choice
    options:
      - id: progress
        text: "Where do things stand?"
        next: progress
      - id: hair
        text: "I need a lock of the Queen's hair. There are people who can read poison in it."
        condition: "not has_item(item.ysolde_hair) and not flag(flag.hair_leave)"
        tag: persuade
        check: {skill: persuade, dc: 5, pass: hair_pass, fail: hair_fail}
        once: true
      - id: varn_tell
        text: "Varn's stealing from the tolls. Here's proof. [Item: Half-burned toll ledger]"
        tag: item
        condition: "has_item(item.varn_ledger_scrap) and not flag(flag.varn_exposed) and not flag(flag.varn_blackmailed)"
        effects: ["set_flag(flag.varn_exposed)", "add_rep(faction.varn, -40)", "add_rep(faction.crown, 5)"]
        next: varn_tell
      - id: fair_ready
        text: "About the Prince and the fair. I'm ready."
        condition: "flag(flag.fair_announced) and not flag(flag.fair_started)"
        next: fair_ready
      - id: anselm_lie
        text: "The Abbot gave me a false verse. The stone at the Ring proves it."
        condition: "ded(ded.anselm_lied)"
        next: anselm_lie
      - id: taster_tube
        text: "A dispatch tube from the Morrow Gull wreck. It names who paid your food-taster. [Item: Watertight dispatch tube]"
        tag: item
        condition: "has_item(item.taster_dispatch) and not flag(flag.taster_dispatch_sent)"
        effects: ["start_dialogue(dlg.kosk_taster_dispatch)"]
        next: bye
      - id: bye_opt
        text: "Nothing yet."
        next: bye
  progress:
    type: branch
    cases:
      - {if: "count_ms(ms.a1_sickroom_done, ms.a1_abbey_done, ms.a1_ring_done) >= 2", next: progress_ready}
    else: progress_more
  progress_ready:
    type: line
    speaker: npc.kosk
    text: "Enough to know we're at war with someone. Come to the war room when you're ready; there's a matter of the Prince and a fair."
    next: hub
  progress_more:
    type: line
    speaker: npc.kosk
    text: "Not enough. Sickroom, Abbey, the Ring. Bring me two of them."
    next: hub
  fair_ready:
    type: effect
    effects: ["start_dialogue(dlg.kosk_fair_announce)"]
    next: bye
  hair_pass:
    type: line
    speaker: npc.kosk
    text: "Witchcraft. ...Do it. Gods help me, do it. Tell her maid I said so. Not a word to the Abbot; he'd have both our heads for heresy."
    effects: ["set_flag(flag.hair_leave)"]
    next: hub
  hair_fail:
    type: line
    speaker: npc.kosk
    text: "I'll not have hedge-witches pawing at the Queen. Ask me when you've something better than rumor."
    next: hub
  varn_tell:
    type: line
    speaker: npc.kosk
    text: "Ten years of tolls. That greasy... He's a thief, not a poisoner, you're sure? Then he's a thief I can hang later. Leave him to me."
    next: hub
  anselm_lie:
    type: line
    speaker: npc.kosk
    text: "An old man's memory against a stone half-eaten by tar. I can't arrest the Queen's confessor for a bad recitation. Bring me more than chisel-marks and I'll listen. Until then, watch him."
    effects: ["set_flag(flag.kosk_warned_of_anselm)"]
    next: hub
  bye:
    type: end
```

### 5.4 Varn in the antechamber

```yaml dialogue
id: dlg.varn_antechamber
participants: [npc.varn]
start: open
nodes:
  open:
    type: line
    speaker: npc.varn
    text: "Ah! The hero of the docks. A word, a small word, in confidence. The Marshal is a soldier. Admirable. Blunt. He does not understand how a court works. I do."
    direction: "Rings flashing, he steers Hale toward the brazier. Up close: ink on his fingers and a smell of burnt paper in his robes."
    effects: ["set_flag(flag.varn_approached)"]
    next: pitch
  pitch:
    type: line
    speaker: npc.varn
    text: "Twenty crowns now, twenty a week, simply to tell my clerk what the Marshal has you doing. A retainer. Entirely lawful. I am, after all, the law's purse."
    next: hub
  hub:
    type: choice
    options:
      - id: take
        text: "Twenty crowns a week? Done."
        effects: ["add_crowns(20)", "add_rep(faction.varn, 10)", "set_flag(flag.varn_retainer)"]
        next: take
      - id: refuse
        text: "I've already got a master."
        effects: ["add_rep(faction.varn, -5)"]
        next: refuse
      - id: smoke
        text: "You smell of smoke, Chancellor. Burning something? [Investigate 4]"
        tag: investigate
        check: {skill: investigate, dc: 4, pass: smoke_pass, fail: smoke_fail}
        once: true
      - id: flatter
        text: "The court's lucky to have a mind like yours. [Persuade 4]"
        tag: persuade
        check: {skill: persuade, dc: 4, pass: flatter_pass, fail: flatter_fail}
        once: true
  take:
    type: line
    speaker: npc.varn
    text: "Splendid! Splendid. My clerk is Tobiah Quill, you'll find him at the Chancellery. Discretion, now."
    next: bye
  refuse:
    type: line
    speaker: npc.varn
    text: "A pity. Masters change, you know. Regents too. Remember who offered first."
    next: bye
  smoke_pass:
    type: line
    speaker: npc.varn
    text: "Smoke? Smoke. The braziers, of course, the Chancellery is a draughty old tower and I work late, very late, for the realm. Good day!"
    direction: "He backs away fast, tugging his sleeves over his inky fingers."
    effects: ["set_flag(flag.varn_smells_smoke)"]
    next: bye
  smoke_fail:
    type: line
    speaker: npc.varn
    text: "The braziers. The Chancellery is cold. Now, my offer?"
    next: hub
  flatter_pass:
    type: line
    speaker: npc.varn
    text: "Lucky. Yes. They are. Someone sees it at last. Here, here, a token of my esteem, and my door is open to you. Within reason."
    effects: ["add_crowns(10)", "add_rep(faction.varn, 5)"]
    next: hub
  flatter_fail:
    type: line
    speaker: npc.varn
    text: "Oh, don't try to butter me, I was buttering kings when you were in swaddling."
    next: hub
  bye:
    type: end
```

### 5.5 Varn (default)

```yaml dialogue
id: dlg.varn
participants: [npc.varn]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "flag(flag.varn_blackmailed)", next: blackmailed}
      - {if: "flag(flag.varn_exposed)", next: exposed}
    else: plain
  plain:
    type: line
    speaker: npc.varn
    text: "The Chancellery is extremely busy. Extremely. Make an appointment with Quill."
    next: bye
  blackmailed:
    type: line
    speaker: npc.varn
    text: "You. What now? I paid. I am paying. Lower your voice."
    next: bye
  exposed:
    type: line
    speaker: npc.varn
    text: "Get away from me. The Marshal has my books, my keys, my clerk. Are you happy? Is the realm safer?"
    next: bye
  bye:
    type: end
```

### 5.6 Anselm (default)

Anselm's default conversation is gentle and useless by design. He never confesses in Act I. If the player confronts him with `ded.anselm_lied`, he deflects and remembers it (`flag.anselm_suspects_player`, readable by A05).

```yaml dialogue
id: dlg.anselm
participants: [npc.anselm]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.anselm
    text: "My child. You look tired. Everyone in this city looks tired; it's the bells, I think, or the war that never quite ended."
    next: hub
  hub:
    type: choice
    options:
      - id: queen
        text: "How is the Queen, Father?"
        next: queen
      - id: court
        text: "What do you make of this court?"
        next: court
      - id: verse_lie
        text: "Your 'copy' of the fourth verse doesn't match the stone at the Ring."
        condition: "ded(ded.anselm_lied)"
        next: verse_lie
      - id: bless
        text: "Bless me, Father."
        once: true
        effects: ["heal_player(full)", "add_rep(faction.abbey, 2)"]
        next: bless
      - id: bye_opt
        text: "Good day, Father."
        next: bye
  queen:
    type: line
    speaker: npc.anselm
    text: "In pain, and brave about it. I bring her the sacrament each evening, and a little poppy for the nights. It is all an old priest can do."
    next: hub
  court:
    type: line
    speaker: npc.anselm
    text: "I have heard the confessions of half these lords. I will not break the seal. But I will say this: God keeps a ledger, even when men burn theirs."
    next: hub
  verse_lie:
    type: line
    speaker: npc.anselm
    text: "Does it not? Then I am an old man with a poor memory, and a stone is a stone. Bring me a rubbing and Maelis and I will puzzle over it together. Truly."
    direction: "Not a flicker. Only, afterwards, he watches Hale leave."
    effects: ["set_flag(flag.anselm_suspects_player)"]
    next: hub
  bless:
    type: line
    speaker: npc.anselm
    text: "Go in peace, and come home in it. Few do, these days."
    direction: "A thumb on Hale's brow. His hand smells of beeswax and something sweeter."
    next: hub
  bye:
    type: end
```

### 5.7 Queen Ysolde (default)

The Queen's main conversation is in the sickroom (`dlg.ysolde_sickroom`, section 3). In the hall she has only this.

```yaml dialogue
id: dlg.ysolde
participants: [npc.ysolde]
start: line
nodes:
  line:
    type: line
    speaker: npc.ysolde
    text: "Not here. Too many ears and not enough honest ones. Come to my rooms, if the Marshal lets you."
    next: bye
  bye:
    type: end
```

### 5.8 Aldric in the cloister garden (Aldric scene 1)

Aldric's loyalty is tracked in `var.aldric_bond` (0–6). It is set to 0 here and raised by kind, honest or respectful choices across Act I. At the end of Act I, `flag.aldric_trusts_player` is set if the bond is 3 or more (section 7); Act II's twist and Act III's finale may read it.

```yaml dialogue
id: dlg.aldric_garden
participants: [npc.aldric]
start: open
nodes:
  open:
    type: line
    speaker: npc.aldric
    text: "You're the one from the docks. Brask says you killed three men with a hearth poker. Is it true? Don't lie, everybody lies to me."
    direction: "Wooden sword still raised. Out of breath. He is small for twelve and trying not to be."
    effects: ["set_flag(flag.met_aldric)", "set_var(var.aldric_bond, 0)"]
    next: hub
  hub:
    type: choice
    options:
      - id: truth
        text: "No. A sword, mostly. And not three. It's never as clean as the story."
        effects: ["add_var(var.aldric_bond, 1)"]
        next: truth
      - id: brag
        text: "Three? It was ten, Your Highness. With my bare hands."
        next: brag
      - id: bow
        text: "Your Highness. I shouldn't keep you."
        next: bow
  truth:
    type: line
    speaker: npc.aldric
    text: "Oh. ...Thank you. Nobody ever tells me the boring version. That's how I know it's real."
    next: spar_ask
  brag:
    type: line
    speaker: npc.aldric
    text: "Liar. You're like the rest of them. Everyone here thinks I'm six."
    next: spar_ask
  bow:
    type: line
    speaker: npc.aldric
    text: "You're not keeping me. Nobody keeps me. That's the problem. Stay. That's an order. I'm allowed to give those."
    next: spar_ask
  spar_ask:
    type: line
    speaker: npc.aldric
    text: "Show me how. Not the stupid dancing-master way. The real way. The way you'd do it if someone was trying to kill you."
    direction: "He holds out a second wooden sword, hilt first."
    next: spar_hub
  spar_hub:
    type: choice
    options:
      - id: teach
        text: "All right. Feet first. Take the cut on the flat, then step in. Again."
        effects: ["play_beat(spar_aldric)", "add_var(var.aldric_bond, 1)"]
        next: teach
      - id: let_hit
        text: "Come on, then. Hit me."
        effects: ["play_beat(aldric_lands_hit)"]
        next: let_hit
      - id: refuse
        text: "You're the heir. If I bruise you, the Marshal hangs me."
        next: refuse
  teach:
    type: line
    speaker: npc.aldric
    text: "Like that? Like... that! Ha! Again. No, show me the bit where you stepped in. Again!"
    next: talk_mother
  let_hit:
    type: branch
    cases:
      - {if: "var(var.aldric_bond) >= 1", next: let_hit_known}
    else: let_hit_suspicious
  let_hit_known:
    type: line
    speaker: npc.aldric
    text: "You let me. ...You did, didn't you. Don't. Next time, don't let me. Promise."
    effects: ["add_var(var.aldric_bond, 1)"]
    next: talk_mother
  let_hit_suspicious:
    type: line
    speaker: npc.aldric
    text: "I hit you! I... you let me. Everyone lets me. It doesn't count if they let me."
    next: talk_mother
  refuse:
    type: line
    speaker: npc.aldric
    text: "That's what they all say. Fine. Go and do your important things."
    next: talk_mother
  talk_mother:
    type: line
    speaker: npc.aldric
    text: "Is my mother dying? They won't tell me. I hear her at night through the wall. Father Anselm says God tests the good. I think God should test someone else."
    next: mother_hub
  mother_hub:
    type: choice
    options:
      - id: honest
        text: "I don't know yet. But the Marshal's hired me to find out why she's sick. I'll tell you what I find."
        effects: ["add_var(var.aldric_bond, 1)", "set_flag(flag.aldric_promised_truth)"]
        next: honest
      - id: soothe
        text: "She'll be fine, Highness. Don't worry."
        next: soothe
      - id: anselm
        text: "Father Anselm talks to you a lot?"
        next: anselm_talk
  honest:
    type: line
    speaker: npc.aldric
    text: "You will? Promise on your sword. ...Good. Then I'll tell you something. Nobody watches the kitchens. Pell the taster has gold now. Real gold. Where does a taster get gold?"
    next: close
  soothe:
    type: line
    speaker: npc.aldric
    text: "That's what Varn says. And the physician. You all practise it in a mirror."
    next: close
  anselm_talk:
    type: line
    speaker: npc.aldric
    text: "Every day. He's the only one who tells me the truth about this place. That they're all thieves. He's teaching me old dwarf words, for patience. Ar-veth tor halun... I can't do the rest yet."
    direction: "He says the words carefully, proudly, like a lesson."
    effects: ["set_flag(flag.heard_aldric_words)"]
    next: close
  close:
    type: line
    speaker: npc.aldric
    text: "You can go now. But come back. Practise with me again, when you've found something. That's an order too."
    next: bye
  bye:
    type: end
```

### 5.9 Aldric (default, later)

```yaml dialogue
id: dlg.aldric
participants: [npc.aldric]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "ms(ms.act1_complete)", next: after_fair}
      - {if: "flag(flag.met_aldric)", next: again}
    else: first
  first:
    type: line
    speaker: npc.aldric
    text: "Shh. I'm not supposed to be up here. Go away before Brask sees you talking to me."
    next: bye
  again:
    type: line
    speaker: npc.aldric
    text: "You came back. Did you find anything? You promised."
    next: again_hub
  again_hub:
    type: choice
    options:
      - id: report
        text: "Some things. Your mother's cup was poisoned. The Marshal's men guard it now."
        condition: "flag(flag.chalice_secured) and flag(flag.aldric_promised_truth)"
        once: true
        effects: ["add_var(var.aldric_bond, 1)"]
        next: report
      - id: spar
        text: "Practice?"
        once: true
        effects: ["play_beat(spar_aldric)"]
        next: spar
      - id: later
        text: "Not yet, Highness."
        next: later
  report:
    type: line
    speaker: npc.aldric
    text: "Poisoned. I knew it. I knew it! ...Thank you for telling me. You're the only one who did what you said."
    next: bye
  spar:
    type: line
    speaker: npc.aldric
    text: "Watch. Feet first. Flat of the blade. Step in. See? I've been practising on the pell every day."
    next: bye
  later:
    type: line
    speaker: npc.aldric
    text: "Then hurry."
    next: bye
  after_fair:
    type: line
    speaker: npc.aldric
    text: "They won't let me out of the tower now. Not even the garden. Because of the fair. Come and see me before you go. Please."
    next: bye
  bye:
    type: end
```

### 5.10 Minor dialogues

```yaml dialogue
id: dlg.hesse
participants: [npc.corporal_hesse]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "has_item(item.kosk_writ)", next: writ}
      - {if: "flag(flag.summoned_by_kosk)", next: summoned}
    else: shoo
  writ:
    type: line
    speaker: npc.corporal_hesse
    text: "The Marshal's writ. Of course. Go on through. The Chancellor sends his compliments, I'm sure."
    next: bye
  summoned:
    type: line
    speaker: npc.corporal_hesse
    text: "Brask's sellsword. They're expecting you. Lion Hall, straight up, don't touch anything."
    next: bye
  shoo:
    type: line
    speaker: npc.corporal_hesse
    text: "Seal or business. No? Then move along."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.marta_kell
participants: [npc.marta_kell]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.marta_kell
    text: "Poultices, bolts, lamp oil, and a nice bit of Attre steel if you've the coin. What'll it be, dear?"
    next: hub
  hub:
    type: choice
    options:
      - id: shop
        text: "Show me your wares."
        effects: ["open_shop(npc.marta_kell)"]
        next: bye
      - id: oil
        text: "What's fire oil good for?"
        next: oil
      - id: bye_opt
        text: "Just looking."
        next: bye
  oil:
    type: line
    speaker: npc.marta_kell
    text: "Rub it on a blade and light it, if you're mad. The shepherds buy it to keep the dogs off since the hounds round the Ring went strange. Dogs hate fire."
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.ballad_seller
participants: [npc.ballad_seller]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.ballad_seller
    text: "A copper for the news, a silver for the truth! Which will it be, friend?"
    next: hub
  hub:
    type: choice
    options:
      - id: news
        text: "A copper's worth. [Bribe 1]"
        tag: bribe
        bribe: 1
        next: news
      - id: decline
        text: "Neither."
        next: bye
  news:
    type: line
    speaker: npc.ballad_seller
    text: "Oh, the Gull Tower's dark and the boats come home blind, and the bells ring at midnight for nobody's mass, and the Chancellor's lamp burns all night in his tower. Tra-la."
    direction: "Draws a rumor from the Cintra pool as well (A07 rumors)."
    effects: ["add_map_pin(map.gull_tower)"]
    next: bye
  bye:
    type: end
```

## 6. Encounters

None. The Audience is a pure dialogue section. (A hostile `faction.varn` adds a hub thug ambush after stage 1, gdd §6.12; that encounter belongs to the stage-1 hub and is listed in `08-act1-transition.md`.)

## 7. Items and clues

```yaml item
id: item.kosk_writ
name: "Marshal's writ"
category: key
description: "A folded parchment under the Lord Marshal's red seal. Opens palace doors. It came with an iron lion badge."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Let the bearer pass and be aided in all things, on the business of the Crown and by my order. Bertran Kosk, Lord Marshal of Cintra."
```

```yaml item
id: item.kosk_badge
name: "Marshal's badge"
category: trinket
description: "An iron lion badge on a pin, the Lord Marshal's mark. Worn, it loosens officials' tongues. Strept clansmen spit at it."
price: 0
stack_max: 1
equip_slot: trinket
weapon: null
armor: null
trinket:
  mods:
    - {mod: check_all, value: 2, vs_faction: faction.crown}
    - {mod: check_all, value: -2, vs_faction: faction.strept}
consumable: null
readable_text: null
```

```yaml item
id: item.antitoxin
name: "Antitoxin"
category: consumable
description: "Bitter charcoal-and-milk-thistle draught. Cures poison and keeps it off for half a minute (gdd §6.9)."
price: 18
stack_max: 5
equip_slot: null
weapon: null
armor: null
consumable: {effects: ["cure_status(poison)", "status_immunity(poison, 30)"], use_time: 1.0}
readable_text: null
```

```yaml item
id: item.fire_oil
name: "Fire oil"
category: consumable
description: "A stoppered flask of rendered tallow and pitch. Coat a blade and light it: the weapon deals fire for 60 seconds (gdd §6.9). Beasts hate it."
price: 15
stack_max: 5
equip_slot: null
weapon: null
armor: null
consumable: {effects: ["imbue_weapon(fire, 60)"], use_time: 1.0}
readable_text: null
```

```yaml item
id: item.smoke_pot
name: "Smoke pot"
category: consumable
description: "A clay pot of damp straw and saltpetre. Smash it to break enemy sight for 6 seconds (gdd §6.9)."
price: 20
stack_max: 5
equip_slot: null
weapon: null
armor: null
consumable: {effects: ["break_enemy_sight(6)"], use_time: 0.5}
readable_text: null
```

```yaml item
id: item.cintran_mace
name: "Watchman's mace"
category: weapon
description: "A flanged iron mace of the city watch. Heavier than a sword, kinder to armor."
price: 70
stack_max: 1
equip_slot: main_hand
weapon: {base: 14, type: blunt, block_pct: 0.65, armor_pen: 5, bonus_vs: {}, moveset: mace}
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.brigandine
name: "Brigandine"
category: armor
description: "Riveted plates sewn inside a canvas coat. Old army surplus from the Marnadal war; somebody's name is scratched inside."
price: 120
stack_max: 1
equip_slot: armor
weapon: null
armor: {armor: 18, resist: {}}
consumable: null
readable_text: null
```

```yaml clue
id: clue.marnadal_chaplain
theory: theory.anselm_plan
title: "Chaplain at Marnadal"
text: "Abbot Anselm marched with Kosk's army to Marnadal in 1263 as chaplain and buried half the dead himself. Kosk says he never forgave any of them for that war."
supports: [anselm]
refutes: []
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.a1_audience_done, type: milestone, xp: 150, desc: "Kosk hired the player and gave the Marshal's writ."}
  - {id: flag.told_council_monk, type: bool, desc: "The player told the council the courier was poisoned by a monk (Anselm heard it)."}
  - {id: flag.varn_rattled, type: bool, desc: "The player rattled Varn in open council."}
  - {id: flag.passes_closed_known, type: bool, desc: "Kosk explained the closed passes and Ostrel's gate."}
  - {id: flag.varn_approached, type: bool, desc: "Varn made his antechamber offer."}
  - {id: flag.varn_retainer, type: bool, desc: "The player took Varn's 20-crown retainer."}
  - {id: flag.varn_smells_smoke, type: bool, desc: "The player noticed smoke and ink on Varn (foreshadows the ledger burning)."}
  - {id: flag.saw_varn_cord, type: bool, desc: "The player noticed the palace guards' Chancellery cord."}
  - {id: flag.met_aldric, type: bool, desc: "The player met Aldric in the cloister garden."}
  - {id: var.aldric_bond, type: int, min: 0, max: 6, desc: "Aldric's personal trust in the player across Act I. >= 3 sets flag.aldric_trusts_player at the Fair."}
  - {id: flag.aldric_promised_truth, type: bool, desc: "The player promised Aldric the truth about his mother."}
  - {id: flag.heard_aldric_words, type: bool, desc: "Aldric recited Anselm's 'dwarvish patience words' to the player (foreshadows the reversed Oath)."}
  - {id: flag.hair_leave, type: bool, desc: "Kosk gave leave to take a lock of the Queen's hair (Presence 5)."}
  - {id: flag.varn_exposed, type: bool, desc: "The player turned Varn's ledger over to Kosk."}
  - {id: flag.kosk_warned_of_anselm, type: bool, desc: "The player told Kosk that Anselm's verse is false."}
  - {id: flag.varn_ambush_done, type: bool, desc: "The once-only hub ambush by Varn's toughs (Varn Hostile after stage 1, gdd §6.12) has fired. Encounter in 08-act1-transition.md."}
  - {id: flag.anselm_suspects_player, type: bool, desc: "The player confronted Anselm with the false verse; he knows they suspect him."}
reads:
  - ms.a1_rat_survived
  - flag.summoned_by_kosk
  - flag.varn_light_seen
  - flag.varn_chase_lost
  - flag.varn_blackmailed
  - flag.chalice_secured
  - flag.fair_announced
  - ms.a1_sickroom_done
  - ms.a1_abbey_done
  - ms.a1_ring_done
  - ms.a1_gull_done
  - ms.act1_complete
```

## 9. Quest hooks

```yaml quest_stages
quest: quest.main_a1
order: 30
stages:
  - id: audience
    journal: "Sergeant Brask brought me to the Lion Hall. The Queen read Dravin's letter and turned white. Lord Marshal Kosk has hired me to find out who poisoned his courier, and who is poisoning the Queen."
    objectives:
      - {id: hired, text: "Present the letter at court", condition: "ms(ms.a1_audience_done)", optional: false}
      - {id: chaplain, text: "Ask Kosk about the Abbot", condition: "has_clue(clue.marnadal_chaplain)", optional: true, xp: 20}
    on_complete: []
    next: []
  - id: follow_the_leads
    journal: "Kosk wants at least two of his leads run down before he'll trust me with more: the Queen's sickroom, the Book of the Lion at the Abbey, and the split stone at the Ring of Nine. The Gull Tower light has gone dark too, if I have time."
    objectives:
      - {id: two_leads, text: "Follow at least two of the Marshal's leads", condition: "count_ms(ms.a1_sickroom_done, ms.a1_abbey_done, ms.a1_ring_done) >= 2", optional: false}
      - {id: sickroom, text: "Investigate the Queen's sickroom", condition: "ms(ms.a1_sickroom_done)", optional: true}
      - {id: abbey, text: "See the Book of the Lion at St. Corwen", condition: "ms(ms.a1_abbey_done)", optional: true}
      - {id: ring, text: "Find out what is wrong at the Ring of Nine", condition: "ms(ms.a1_ring_done)", optional: true}
      - {id: gull, text: "Find out why the Gull Tower is dark", condition: "ms(ms.a1_gull_done)", optional: true}
    on_complete: []
    next: []
```

Milestone XP: the linear stages carry it on their required objective (`hired`, 150 XP). The four lead milestones (`ms.a1_sickroom_done`, `ms.a1_abbey_done`, `ms.a1_ring_done`, `ms.a1_gull_done`) can be reached after this stage has already completed, so their 200 XP is paid by an `add_xp(200)` placed next to each `reach_milestone` in those files. The objectives above carry no XP, so nothing is paid twice.

## 10. Rumors and event cards (optional)

None defined here. The ballad-seller and Marta Kell are rumor sources for the Cintra pool (A07 `14-rumors.md`).

## 11. Failure states and branches

```yaml branches
paths:
  - id: hired_plain
    when: "Player tells the story and accepts Kosk's offer."
    outcome: "ms.a1_audience_done, writ, 40 crowns, Crown +15. Leads pinned."
    sets: ["reach_milestone(ms.a1_audience_done)"]
  - id: hired_haggled
    when: "Player passes Persuade 6 with Kosk."
    outcome: "As above with +40 crowns more."
    sets: ["reach_milestone(ms.a1_audience_done)"]
  - id: varn_retainer
    when: "Player takes Varn's money in the antechamber."
    outcome: "Varn +10, +20 crowns. Varn's clerk Quill expects reports (flavor in section 3; Varn is friendlier during the chase dialogue)."
    sets: ["set_flag(flag.varn_retainer)"]
  - id: aldric_scene
    when: "Player enters the cloister garden after the hire."
    outcome: "Aldric scene 1. var.aldric_bond 0-3. Hints at Pell's gold (honest path) or Anselm's dwarf words."
    sets: ["set_flag(flag.met_aldric)"]
failures:
  - id: insult_council
    result: soft_fail
    recover: "Needling Varn or snubbing Anselm only shifts reputation. Kosk always hires."
  - id: skip_aldric
    result: soft_fail
    recover: "If the player never enters the garden, Aldric's bond starts at 0 in section 3 (dlg.aldric_sickroom sets var.aldric_bond if unset) and the Fair still works."
guarantees:
  - "ms.a1_audience_done is reached by dlg.kosk_hire option 'accept', which has no condition or check, and dlg.audience_council always chains into dlg.kosk_hire."
  - "The palace gate opens with flag.summoned_by_kosk, always set in section 1."
```

## 12. Open questions

1. **Shop and consumable behavior (resolved by A08).** The consumables use the §J.2 ops (`cure_status`, `status_immunity`, `imbue_weapon`, `break_enemy_sight`).
2. **Night zones from a day hub.** `zone.chancellery_rooftops` is a night zone entered from a day hub. I assume the presentation shows a "nightfall" card on the transition; there is no clock.
3. **`goto_zone` to the same zone (resolved by A08).** Valid: a scene cut to another spawn (content-format §J.2).
4. **Kosk's writ "+2 with officials" (resolved by A08).** The writ comes with `item.kosk_badge`, a trinket whose `mods` give +2 with Crown officials and −2 with Strept speakers (§J.6, gdd §6.9). The `has_item(item.kosk_writ)` options stay: they show the writ.
5. **Hair check DC 5 (resolved by A08).** Any DC from 4 to 10 is valid (content-format §I).
