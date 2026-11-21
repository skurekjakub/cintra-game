---
section_id: a1.03
title: "The Sickroom and the Red Herring"
act: 1
story_ref: "story.md §3 (Ysolde, Aldric, Varn), §5.3; gdd.md §6.2 (mitigations), §6.5 (stealth), §6.18 (lost chase), §7.1 #3"
zones: [zone.palace_sickroom, zone.palace_kitchens, zone.chancellery_rooftops]
available_when: "ms(ms.a1_audience_done) and not flag(flag.fair_started)"
escalation_stage_required: {min: 0, max: 0}
milestones_set: [ms.a1_sickroom_done]
milestones_read: [ms.a1_audience_done, ms.a1_sickroom_done]
level_band: [2, 3]
---

# The Sickroom and the Red Herring

## 1. Scene summary

With the Marshal's writ, Hale climbs the east tower to the Queen's sickroom. The physician calls it a wasting fever. The silver chalice on the Queen's prie-dieu says otherwise: fine grey-gold pollen caught in the engraving under the rim, and the same lily-sweet smell as the courier's froth. Hale can persuade Kosk to put the chalice and the wine under his own men's guard (the first mitigation of the Queen's decline), take a lock of the Queen's hair with Kosk's leave, and, if the Queen trusts them, hear from her own mouth what the Oath at the Ring of Nine is for. Prince Aldric sits at the window seat holding his mother's hand and asks Hale to tell him the truth. Down in the kitchens, the royal food-taster Pell is suddenly paying his dice debts in new gold; exposing him is the second mitigation. And the cook mentions that the Chancellor's lamp burns past midnight and the smoke from his chimney smells of paper. That night, Hale catches Chancellor Varn burning ledgers in a brazier and chases him across the Chancellery leads. Caught, Varn sobs that he is a thief, not a poisoner: ten years of skimmed river tolls. The dramatic question: *who wants the Queen dead?* The answer, for now, is "not Varn." The section ends when Hale holds the chalice evidence and the Varn chase is resolved, won or lost (`ms.a1_sickroom_done`).

## 2. Progress and escalation

- Stage 0. The Queen's condition is 0 (Weak): gdd §6.2 `base_condition = min(stage, 3) = 0`, so the confide dialogue is available.
- `ms.a1_sickroom_done` = "has `clue.chalice_pollen`" **and** "the Varn chase resolved" (`flag.varn_chase_won` or `flag.varn_chase_lost`). Either order works:
  - If the chase is resolved first, the milestone fires when the chalice is searched (`t_sick_done_chalice`).
  - If the chalice is searched first, the milestone fires when the chase resolves (`dlg.varn_caught` node `done_check`, or `t_sick_done_escape`).
  Each path pays `add_xp(200)` once (the two never both fire).
- **Mitigations** (gdd §6.2), both optional:
  - `flag.chalice_secured`: `dlg.kosk_chalice`, needs `clue.chalice_pollen` plus Persuade 4, or `perk.keen_eye` (no check).
  - `flag.food_taster_exposed`: `dlg.pell`, needs `clue.taster_gold` and a confrontation (several approaches). Declared here; A07's Morrow Gull tube also sets it.
- This section closes when the Fair starts (`flag.fair_started`, point of no return). The solar re-search for a lost chase stays available in later acts (gdd §6.18).

## 3. Location layout

### 3.1 The Queen's sickroom (`zone.palace_sickroom`)

The top two floors of the palace's east tower. Day look, curtains half drawn, braziers, the smell of poppy and sickness. About 16 × 12 m on the main floor.

```
   [servants_stair]  (down to kitchens, NW)
   +-----------+-----------------------+----------+
   | dressing  |      BEDCHAMBER       | ORATORY  |
   | room      |  four-poster (Queen)  | prie-dieu|
   | (maid,    |                       | CHALICE  |
   | hairbrush)|  window_seat (E) ---> | flagon   |
   +-----------+-----------+-----------+----------+
               | ANTECHAMBER: physician's table,  |
               | Kosk's two men, tonic shelf      |
               +----[tower stair, from the hall]--+
```

- **antechamber** (S): where visitors wait. Master Idris Fell's table with his notes, a shelf of tonics (poppy syrup, the Abbot's "restorative"), two of Kosk's soldiers on the door. Spawn from the hall.
- **bedchamber** (centre): a great curtained four-poster. The Queen propped on pillows in wine-dark velvet even in bed, gloves on.
- **window_seat** (E side of the bedchamber): a cushioned stone seat in a deep window. Aldric sits here when he is allowed to visit.
- **oratory** (NE alcove): a prie-dieu before an icon of the lion and the anvil, a silver chalice on a linen cloth, a stoneware flagon sealed in St. Corwen's red wax. The Abbot brings the communion wine each evening himself.
- **dressing_room** (NW): clothes chests, a dresser with the Queen's silver hairbrush. Ilse the maid.
- **servants_stair** (NW corner): a narrow spiral stair down to the kitchens.

### 3.2 The palace kitchens (`zone.palace_kitchens`)

The palace's working basement and yard. Day look, hot, loud, steamy.

- **great_kitchen**: two hearths with spits, a bread oven, long scrubbed tables. Cook Marit rules it. Hall passage spawn here.
- **scullery**: washing troughs. Jeb the scullion, twelve, sharp-eared.
- **servants_hall**: a long trestle where off-duty servants eat and dice. Pell's place at the end. A row of wooden **lockers** on the wall, one with a P burned into it.
- **wine_cellar**: casks, and a stack of small crates stamped with St. Corwen's seal, "For Her Majesty's Communion".
- **kitchen_yard**: a walled yard with a well and three great chimney stacks. A woodpile and a lean-to roof make a climbable route up onto the roofs that join the Chancellery's leads (exit to `zone.chancellery_rooftops` at `kitchen_roofs`, night).
- **servants_stair** (NE): up to the sickroom.

### 3.3 The Chancellery and its roofs (`zone.chancellery_rooftops`, night)

The Chancellery is a square five-storey tower built against the palace's north wall, with the river toll-house roofed onto its east side. Night look: moonlight, chimney smoke, wet slates.

```
  Tanners' Lane (street level, N)        carriage --> [escape point]
        ^ tanners_drop (low roof, 3 m drop)
        |
  TOLL-HOUSE ROOF (pitched slate, loose)  <--- plank ---  THE LEADS (flat lead roof, chimneys, parapets)
                                                              ^ solar window
  palace KITCHEN ROOFS --- gable_bridge (plank) ---------------+
                                                       SOLAR (top floor): brazier, strongbox
                                                       CLERKS' HALL (floor 3): desks, Quill asleep
                                                       CLERKS' STAIR (ground, from Chancellery Lane)
```

- **clerks_stair** (ground to floor 3): a stone spiral stair from the street door. One hired guard on the landing (vision cone, lantern). Spawn from the streets.
- **clerks_hall** (floor 3): rows of sloped desks and ledger presses. Tobiah Quill, Varn's clerk, asleep over a ledger. A second hired guard walks a loop between the presses. Shadows between the presses are hiding spots (crouch).
- **solar** (top floor): Varn's private study. Turkey carpet, a brazier glowing with burning ledger pages, an iron strongbox, a window onto the leads. If Hale reaches the solar door unseen, Varn is caught red-handed.
- **the_leads** (roof): a flat lead roof with four chimney stacks (cover), knee-high parapets. Varn's escape route: out of the solar window, across the leads.
- **toll_house_roof**: a pitched slate roof a little lower, reached by a plank Varn keeps there. Loose slates: a sliding hazard on the steep side.
- **gable_bridge**: a plank across a 2 m gap between the palace kitchen roofs and the leads. The roof route in. Spawn `kitchen_roofs`.
- **tanners_drop**: a lean-to roof over Tanners' Lane, then a 3 m drop to the lane. Varn's carriage waits below with a driver. If Varn gets in, he escapes.
- **tanners_lane** (street level): a dark lane behind the tower. Reachable from the clerks' stair door before going up. The carriage and its driver, Mossy, are here.

**The chase.** Once Varn is alerted (an alarm in the tower, or he sees Hale at the solar window or door), he snatches a satchel of half-burned ledgers and runs: window → leads → plank → toll-house roof → tanners_drop → carriage. He runs a fixed route (about 70 m). The chase is lost if he reaches the carriage, or if he stays more than 25 m ahead for 5 seconds (beat `varn_escapes`). It is won when Hale gets within 2 m and grabs him (interactable `grab_varn`, beat `varn_caught`). Varn's obstacles: he kicks a brazier over on the leads (fire), flings loose ledger pages (a brief blind flutter), and pulls the plank after him if Hale is more than 6 m behind (Hale must sprint-jump the 2 m gap or go round by the toll-house gutter). If the carriage was sent away first, Varn is cornered at the drop and the chase cannot be lost.

```yaml zone
id: zone.palace_sickroom
name: "The Queen's Sickroom"
kind: interior
map_node: map.cintra
time_of_day: day
cold_rate: 0
disguise_tag: null
music: sickroom_quiet
areas:
  - {id: antechamber, description: "South waiting room. Physician's table and notes, tonic shelf, two of Kosk's soldiers."}
  - {id: bedchamber, description: "Great curtained four-poster. The Queen in velvet and gloves."}
  - {id: window_seat, description: "Deep cushioned window on the east side. Aldric's seat."}
  - {id: oratory, description: "NE alcove. Prie-dieu, icon of the lion and the anvil, silver chalice on linen, St. Corwen-sealed flagon."}
  - {id: dressing_room, description: "NW. Chests, dresser with the Queen's silver hairbrush. Ilse the maid."}
  - {id: servants_stair, description: "Narrow NW spiral down to the kitchens."}
spawns:
  - {id: antechamber, area: antechamber, default: true}
  - {id: servants_stair, area: servants_stair, default: false}
  - {id: twist_door, area: antechamber}                # a2.08: the map's "Return to Cintra" lands here
exits:
  - id: to_hall
    area: antechamber
    to_zone: zone.palace_hall
    to_spawn: from_sickroom
    condition: "true"
    effects: []
  - id: to_kitchens
    area: servants_stair
    to_zone: zone.palace_kitchens
    to_spawn: servants_stair
    condition: "true"
    effects: []
  - id: to_catacombs                                   # a2.08: the abductors' route
    area: antechamber
    to_zone: zone.abbey_catacombs
    to_spawn: palace_stair
    condition: "ms(ms.act2_twist)"
    effects: []
interactables:
  - id: chalice
    area: oratory
    kind: search
    label: "Examine the silver chalice"
    condition: "not has_clue(clue.chalice_pollen)"
    check: null
    once: true
    effects: ["add_clue(clue.chalice_pollen)", "play_beat(pollen_found)"]
  - id: flagon
    area: oratory
    kind: search
    label: "Examine the sealed flagon"
    condition: "not has_clue(clue.communion_wine)"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["add_clue(clue.communion_wine)", "play_beat(flagon_seal)"]
    fail_effects: ["play_beat(flagon_plain)"]
  - id: physician_notes
    area: antechamber
    kind: readable
    label: "Master Fell's notes"
    condition: "true"
    check: null
    once: false
    effects: ["play_beat(read_fell_notes)"]
  - id: call_kosk
    area: antechamber
    kind: search
    label: "Show the Marshal the chalice"
    condition: "has_clue(clue.chalice_pollen) and not flag(flag.chalice_secured)"
    check: null
    once: false
    effects: ["start_dialogue(dlg.kosk_chalice)"]
  - id: hairbrush
    area: dressing_room
    kind: search
    label: "Take a lock from the Queen's hairbrush"
    condition: "flag(flag.hair_leave) and not has_item(item.ysolde_hair)"
    check: null
    once: true
    effects: ["give_item(item.ysolde_hair, 1)", "play_beat(hair_taken)"]
  - id: give_antidote_by_hand                          # a2.08: a carried dose, by hand
    area: bedchamber
    kind: lever
    label: "Give the Queen the counter-dose"
    condition: "has_item(item.wenna_antidote) and not flag(flag.antidote_administered) and not ms(ms.act2_twist)"
    check: null
    once: true
    effects: ["administer_antidote(queen)"]
triggers:
  - id: t_sick_enter
    area: antechamber
    "on": enter
    source: null
    condition: "not visited(zone.palace_sickroom)"
    once: true
    effects: ["set_checkpoint(sickroom_in)", "play_beat(sickroom_air)"]
  - id: t_aldric_window
    area: window_seat
    "on": enter
    source: null
    condition: "not flag(flag.aldric_sickroom_done) and not ms(ms.act1_complete)"
    once: true
    effects: ["start_dialogue(dlg.aldric_sickroom)"]
  - id: t_sick_done_chalice
    area: oratory
    "on": interact
    source: chalice
    condition: "flag(flag.varn_chase_won) or flag(flag.varn_chase_lost)"
    once: true
    effects: ["reach_milestone(ms.a1_sickroom_done)"]
  - id: twist_return                                   # a2.08: the Act II gate opens the twist
    area: antechamber
    "on": enter
    source: null
    condition: "ms(ms.a2_wenna_line_resolved) and ded(ded.anselm_treason_proven) and has_item(item.true_fourth_verse) and not flag(flag.twist_started)"
    once: true
    effects: ["set_flag(flag.twist_started)", "start_dialogue(dlg.twist_kosk)"]
hazards: []
checkpoints:
  - {id: sickroom_in, area: antechamber}
beats:
  - {id: sickroom_air, description: "Heat, poppy smoke, and under it something sweet. The soldiers on the door glance at the writ and step aside."}
  - {id: pollen_found, description: "Close-up: in the lion engraving under the chalice rim, a crust of fine grey-gold dust. A sweet smell, the same as the courier's lips. The clue links to 'Froth at the courier's mouth' on the board."}
  - {id: flagon_seal, description: "The flagon's red wax bears St. Corwen's seal, unbroken until tonight's mass. The dregs inside smell faintly sweet. A tag on the cord: 'For Her Majesty. Untasted, by the Abbot's order.'"}
  - {id: flagon_plain, description: "Abbey wine in an Abbey flagon. Nothing Hale can make out."}
  - {id: read_fell_notes, description: "Master Fell's notes: 'Wasting fever, chronic. Tremor of the hands, numbness of the feet, sweats at night. Prescribed: poppy. The Abbot's restorative tonic, twice daily.' A later line, crossed out: 'Fever? No fever.'"}
  - {id: hair_taken, description: "Ilse watches, lips pressed thin, as Hale winds a few grey-streaked strands from the brush into a twist of linen."}
  - {id: chalice_guarded, description: "Kosk's soldier wraps the chalice and flagon in linen and carries them out. From now on the Queen's wine comes up under the Marshal's seal."}
  - {id: queen_dies, description: "a2.08. Ysolde's breathing stops between one word and the next. Aldric does not let go of her hand."}
  - {id: investiture, description: "a2.08. Ysolde (or Kosk) sets the Lion's Crown on Aldric's head; the guards on the door kneel."}
  - {id: night_falls, description: "a2.08. Fade. Candles burnt low. The palace sleeps."}
  - {id: bells_at_night, description: "a2.08. Across the river the Abbey bells ring, unbidden, wrong, all at once."}
npcs:
  - {npc: npc.ysolde, area: bedchamber, condition: "true", dialogue: dlg.ysolde_sickroom}
  - {npc: npc.kosk, area: antechamber, condition: "not flag(flag.chalice_secured)"}
  - {npc: npc.aldric, area: window_seat, condition: "not ms(ms.act1_complete)"}
  - {npc: npc.physician_fell, area: antechamber, condition: "true"}
  - {npc: npc.maid_ilse, area: dressing_room, condition: "true"}
encounters: []
loot: []
variants:
  - id: chalice_taken
    when: "flag(flag.chalice_secured)"
    description: "The prie-dieu is bare except for a plain pewter cup. One of Kosk's men stands in the oratory."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: [chalice, flagon]
  - id: stage1_sickroom
    when: "stage() >= 1"
    description: "The Queen is bedridden, feverish, curtains closed. Anselm's tonic bottles crowd the shelf (gdd §6.2 condition 1+ is read by the Queen's dialogue)."
    npcs_absent: [npc.kosk]
    encounters_disabled: []
    interactables_disabled: []
  - id: twist_night                                    # a2.08
    when: "flag(flag.twist_started)"
    description: "Night. Kosk's men on the door, the Crown on a cushion by the bed, Aldric on a stool."
    npcs_absent: [npc.anselm]
    encounters_disabled: []
    interactables_disabled: []
```

```yaml zone
id: zone.palace_kitchens
name: "The Palace Kitchens"
kind: interior
map_node: map.cintra
time_of_day: day
cold_rate: 0
disguise_tag: null
music: kitchen_bustle
areas:
  - {id: great_kitchen, description: "Two hearths with spits, bread oven, long scrubbed tables. Cook Marit."}
  - {id: scullery, description: "Washing troughs, steam. Jeb the scullion."}
  - {id: servants_hall, description: "Long trestle where servants eat and dice. Pell's place at the end. Wall of wooden lockers, one branded P."}
  - {id: wine_cellar, description: "Casks and small crates stamped with St. Corwen's seal: For Her Majesty's Communion."}
  - {id: kitchen_yard, description: "Walled yard, well, three chimney stacks. Woodpile and lean-to roof climb to the roofs that join the Chancellery leads."}
  - {id: servants_stair, description: "NE spiral up to the sickroom."}
spawns:
  - {id: from_hall, area: great_kitchen, default: true}
  - {id: servants_stair, area: servants_stair, default: false}
  - {id: yard_gate, area: kitchen_yard, default: false}
exits:
  - id: to_hall
    area: great_kitchen
    to_zone: zone.palace_hall
    to_spawn: from_kitchens
    condition: "true"
    effects: []
  - id: to_sickroom
    area: servants_stair
    to_zone: zone.palace_sickroom
    to_spawn: servants_stair
    condition: "true"
    effects: []
  - id: to_roofs
    area: kitchen_yard
    to_zone: zone.chancellery_rooftops
    to_spawn: kitchen_roofs
    condition: "flag(flag.varn_light_seen) and not flag(flag.varn_chase_won) and not flag(flag.varn_chase_lost)"
    effects: []
interactables:
  - id: dice_game
    area: servants_hall
    kind: search
    label: "Watch the dice game"
    condition: "not has_clue(clue.taster_gold) and not flag(flag.pell_arrested)"
    check: null
    once: true
    effects: ["play_beat(pell_gold_flash)", "add_clue(clue.taster_gold)"]
  - id: pell_locker
    area: servants_hall
    kind: search
    label: "Search the locker branded P"
    condition: "not flag(flag.pell_arrested)"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["give_item(item.pell_purse, 1)", "add_clue(clue.taster_gold)", "play_beat(locker_purse)"]
    fail_effects: ["play_beat(locker_stuck)"]
  - id: communion_crates
    area: wine_cellar
    kind: readable
    label: "Crates stamped with St. Corwen's seal"
    condition: "true"
    check: null
    once: false
    effects: ["play_beat(read_crates)"]
  - id: pantry_hook
    area: great_kitchen
    kind: container
    label: "Hanging larder"
    condition: "true"
    check: null
    once: true
    effects: []
triggers:
  - id: t_kitchen_enter
    area: great_kitchen
    "on": enter
    source: null
    condition: "not visited(zone.palace_kitchens)"
    once: true
    effects: ["play_beat(kitchen_noise)"]
hazards:
  - {id: spit_fire, area: great_kitchen, kind: fire, params: {damage_per_second: 5, radius_m: 1.2, applies_status: burning}}
checkpoints:
  - {id: kitchens_in, area: great_kitchen}
beats:
  - {id: kitchen_noise, description: "Clatter, steam, shouting. Marit with a ladle like a mace. Everyone stops for one breath when they see the Marshal's writ, then pretends they didn't."}
  - {id: pell_gold_flash, description: "At the end of the trestle, Pell, a thin man in the taster's white tabard, slaps down a gold crown to cover a bet. New gold, unclipped. The table goes quiet. Pell grins too wide and pockets his winnings."}
  - {id: locker_purse, description: "Inside the locker, under a spare tabard: a purse of undyed linen, the kind used for altar cloths, holding eleven new gold crowns."}
  - {id: locker_stuck, description: "The lock is cheap but stubborn. A scullion is watching. Better leave it."}
  - {id: read_crates, description: "Small crates of communion wine, stamped with St. Corwen's seal. Delivery chits signed 'Br. Ambrose, porter'. One flagon a day, every day since spring."}
  - {id: pell_taken, description: "Two of Kosk's men march Pell up the servants' stair in his white tabard. The whole kitchen watches in silence."}
npcs:
  - {npc: npc.cook_marit, area: great_kitchen, condition: "true"}
  - {npc: npc.scullion_jeb, area: scullery, condition: "true"}
  - {npc: npc.pell, area: servants_hall, condition: "not flag(flag.pell_arrested)"}
encounters: []
loot:
  - {container: pantry_hook, items: [{item: item.poultice, count: 1}], condition: "true"}
variants:
  - id: pell_gone
    when: "flag(flag.pell_arrested)"
    description: "Pell's place at the trestle is empty. Someone has scratched a feather into his locker door."
    npcs_absent: [npc.pell]
    encounters_disabled: []
    interactables_disabled: [dice_game, pell_locker]
```

```yaml zone
id: zone.chancellery_rooftops
name: "The Chancellery by Night"
kind: exterior
map_node: map.cintra
time_of_day: night
cold_rate: 0
disguise_tag: null
music: chase_roofs
areas:
  - {id: tanners_lane, description: "Dark street-level lane behind the tower. Varn's carriage and driver Mossy wait here."}
  - {id: clerks_stair, description: "Ground-to-third-floor stone spiral from the Chancellery Lane door. One hired guard with a lantern on the landing."}
  - {id: clerks_hall, description: "Floor 3. Sloped desks, ledger presses (shadows to hide in). Quill asleep over a ledger. A second guard walks a loop."}
  - {id: solar, description: "Top floor. Turkey carpet, brazier burning ledger pages, iron strongbox, window onto the leads."}
  - {id: the_leads, description: "Flat lead roof, four chimney stacks (cover), knee-high parapets. Varn's plank to the toll-house roof at the east edge."}
  - {id: toll_house_roof, description: "Lower pitched slate roof, loose slates on the steep side, a gutter walk round the north edge."}
  - {id: gable_bridge, description: "Plank across a 2 m gap from the palace kitchen roofs to the leads. Roof route in."}
  - {id: tanners_drop, description: "Lean-to roof over Tanners' Lane, 3 m drop. Escape point for Varn."}
spawns:
  - {id: clerks_stair, area: tanners_lane, default: true}
  - {id: kitchen_roofs, area: gable_bridge, default: false}
  - {id: guard_landing, area: clerks_stair, default: false}
  - {id: guard_hall, area: clerks_hall, default: false}
exits:
  - id: to_lane
    area: tanners_lane
    to_zone: zone.cintra_streets
    to_spawn: chancellery_door
    condition: "true"
    effects: []
  - id: to_kitchens
    area: gable_bridge
    to_zone: zone.palace_kitchens
    to_spawn: yard_gate
    condition: "true"
    effects: []
interactables:
  - id: carriage_driver
    area: tanners_lane
    kind: search
    label: "Talk to the carriage driver"
    condition: "not flag(flag.carriage_gone) and not flag(flag.varn_alerted)"
    check: null
    once: false
    effects: ["start_dialogue(dlg.mossy_driver)"]
  - id: solar_door
    area: solar
    kind: door
    label: "Open the solar door"
    condition: "not flag(flag.varn_alerted) and not flag(flag.varn_chase_won) and not flag(flag.varn_chase_lost)"
    check: null
    once: true
    effects: ["set_flag(flag.varn_red_handed)", "play_beat(varn_red_handed)", "start_dialogue(dlg.varn_caught)"]
  - id: solar_window
    area: the_leads
    kind: search
    label: "Look through the solar window"
    condition: "not flag(flag.varn_alerted) and not flag(flag.varn_chase_won) and not flag(flag.varn_chase_lost)"
    check: null
    once: true
    effects: ["set_flag(flag.varn_alerted)", "play_beat(varn_sees_face)", "play_beat(varn_flees)"]
  - id: grab_varn
    area: tanners_drop
    kind: search
    label: "Grab Varn"
    condition: "flag(flag.varn_alerted) and not flag(flag.varn_chase_won) and not flag(flag.varn_chase_lost)"
    check: null
    once: true
    effects: ["play_beat(varn_caught)", "start_dialogue(dlg.varn_caught)"]
  - id: solar_hearth
    area: solar
    kind: search
    label: "Search the cold brazier and the hearth"
    condition: "flag(flag.varn_chase_lost) and not has_clue(clue.varn_ledgers)"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["give_item(item.varn_ledger_scrap, 1)", "add_clue(clue.varn_ledgers)", "play_beat(scrap_found)"]
    fail_effects: ["play_beat(scrap_ash)"]
  - id: quill_desk
    area: clerks_hall
    kind: search
    label: "Read the ledger under Quill's elbow"
    condition: "true"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["add_clue(clue.abbey_silver_tolls)"]
    fail_effects: []
triggers:
  - id: t_roofs_enter
    area: tanners_lane
    "on": enter
    source: null
    condition: "not flag(flag.varn_alerted)"
    once: true
    effects: ["set_checkpoint(chancellery_in)", "play_beat(solar_glow)"]
  - id: t_roofs_enter_top
    area: gable_bridge
    "on": enter
    source: null
    condition: "not flag(flag.varn_alerted)"
    once: true
    effects: ["set_checkpoint(roofs_in)", "play_beat(solar_glow)"]
  - id: t_alarm
    area: clerks_hall
    "on": alarm
    source: null
    condition: "not flag(flag.varn_alerted)"
    once: true
    effects: ["play_beat(guard_alarm)", "set_flag(flag.varn_alerted)", "start_encounter(enc.chancellery_guards)", "play_beat(varn_flees)"]
  - id: t_cornered
    area: tanners_drop
    "on": beat_done
    source: varn_cornered
    condition: "not flag(flag.varn_chase_won)"
    once: true
    effects: ["play_beat(varn_caught)", "start_dialogue(dlg.varn_caught)"]
  - id: t_escaped
    area: tanners_drop
    "on": beat_done
    source: varn_escapes
    condition: "true"
    once: true
    effects: ["set_flag(flag.varn_chase_lost)", "add_rumor(rumor.r02_varn_ledgers)"]
  - id: t_sick_done_escape
    area: tanners_drop
    "on": beat_done
    source: varn_escapes
    condition: "has_clue(clue.chalice_pollen)"
    once: true
    effects: ["reach_milestone(ms.a1_sickroom_done)"]
hazards:
  - {id: kicked_brazier, area: the_leads, kind: fire, enabled_by: {"on": beat_done, source: varn_flees}, params: {damage_per_second: 5, radius_m: 1.5, applies_status: burning}}
  - {id: loose_slates, area: toll_house_roof, kind: trap, params: {effect: slide, slide_m: 3, stagger_s: 0.8, avoid_by: gutter_walk}}
  - {id: plank_gap, area: the_leads, kind: trap, params: {effect: gap, width_m: 2, needs: sprint_jump, opens_if_player_behind_m: 6}}
chases:
  - id: varn_chase
    quarry: npc.varn
    start_on: {"on": beat_done, source: varn_flees}
    route: [solar, the_leads, toll_house_roof, tanners_drop]
    lose_distance_m: 25
    lose_after_s: 5
    catch_distance_m: 2
    cornered_when: "flag(flag.carriage_gone)"
    on_caught: []
    on_escaped: ["play_beat(varn_escapes)"]
    on_cornered: ["play_beat(varn_cornered)"]
checkpoints:
  - {id: chancellery_in, area: tanners_lane}
  - {id: roofs_in, area: gable_bridge}
  - {id: chase_start, area: the_leads}
beats:
  - {id: solar_glow, description: "Above, the Chancellery's top window glows orange. A thread of black smoke from the solar chimney smells of burning paper."}
  - {id: guard_alarm, description: "Fired by the stealth system when a hired guard's suspicion reaches 100 (gdd §6.5): 'Intruder! Wake the Chancellor!'"}
  - {id: varn_red_handed, description: "The solar door swings open on Varn on his knees at the brazier, feeding it ledger pages, sleeves rolled, face lit orange. He freezes with a page in each hand."}
  - {id: varn_sees_face, description: "Through the glass, Varn looks up from the brazier and sees Hale's face. He shrieks."}
  - {id: varn_flees, description: "Varn snatches a satchel of half-burned ledgers, kicks the brazier over, and scrambles out of the solar window onto the leads, surprisingly fast. Chase begins; checkpoint chase_start."}
  - {id: varn_caught, description: "Hale catches Varn by the collar at the edge of the drop. The satchel splits; half-burned pages flutter down into Tanners' Lane. Varn bursts into tears."}
  - {id: varn_escapes, description: "Varn drops onto the lean-to, into the carriage. 'Drive! Drive, Mossy, damn you!' Wheels on cobbles; gone. A single scorched page drifts down. Played by the chase (`chases.varn_chase.on_escaped`)."}
  - {id: varn_cornered, description: "Varn reaches the drop and finds the lane empty: no carriage. He turns, wheezing, back to the parapet. Played by the chase (`on_cornered`) instead of varn_escapes when flag.carriage_gone is set."}
  - {id: scrap_found, description: "In the cold ash under the brazier grate, one ledger quire that didn't burn through: toll sums, two columns that don't agree, ten years running."}
  - {id: scrap_ash, description: "Ash, ash, and more ash. If anything survived, Hale can't find it."}
npcs:
  - {npc: npc.varn, area: solar, condition: "not flag(flag.varn_chase_won) and not flag(flag.varn_chase_lost)"}
  - {npc: npc.tobiah_quill, area: clerks_hall, condition: "true"}
  - {npc: npc.mossy_driver, area: tanners_lane, condition: "not flag(flag.carriage_gone)"}
encounters: [enc.chancellery_guards]
loot: []
variants:
  - id: after_chase
    when: "flag(flag.varn_chase_won) or flag(flag.varn_chase_lost)"
    description: "The solar is dark and cold, the brazier tipped over, a scorched patch on the leads. Quill has gone. One guard, half-asleep."
    npcs_absent: [npc.varn, npc.mossy_driver]
    encounters_disabled: [enc.chancellery_guards]
    interactables_disabled: [carriage_driver, solar_door, solar_window, grab_varn]
```

Notes for the level builder:
- Two guards (`enc.chancellery_guards` spawn points `guard_landing` and `guard_hall`) are **patrol NPCs under the stealth system** before the alarm, and become the encounter after it. Takedowns from behind are non-lethal (gdd §6.5) and remove a guard from the encounter.
- `grab_varn` is the catch interaction. In level terms it is attached to Varn himself and is usable anywhere along the chase route; it is placed in `tanners_drop` because that is where the cornered and red-handed variants end. The chase controller fires `varn_escapes` or `varn_cornered` (if `flag.carriage_gone`).

## 4. NPCs present

**Voice notes.**
- **Queen Ysolde** in the sickroom: drier and more honest than in the hall; she has stopped performing for anyone but her son.
- **Pell**: thin, nervous, too cheerful, sweats; speaks in quick little jokes that fall flat. When cornered, whines.
- **Cook Marit**: loud, warm, furious, protective of "her" kitchen and her Queen. Uses food metaphors.
- **Jeb**: twelve, mercenary, quick. Calls everyone "sir" sarcastically.
- **Master Idris Fell**: an old physician who drinks, frightened, pompous on the surface.
- **Tobiah Quill**: Varn's clerk, dry, precise, terrified.
- **Mossy**: Varn's carriage driver, slow, greedy, loyal to whoever paid last.

```yaml npc
id: npc.pell
name: "Pell"
faction: faction.choir
role: "Royal food-taster"
motive: "Money, and to stop being the man who might die for someone else's supper."
secret: "Bribed by the Pale Choir in spring to stop tasting the Queen's communion wine. Wears a pale gull feather stitched inside his boot lining. He never saw his paymaster's face."
disposition: friendly
essential: true
dialogue: dlg.pell
barks: ["Tastes like duty!", "Lucky streak, lads, lucky streak.", "I don't know anything about anything.", "Ha! Ha. No."]
combat: null
shop: null
```

```yaml npc
id: npc.cook_marit
name: "Marit, head cook"
faction: null
role: "Head cook of the palace kitchens"
motive: "Feed the palace and protect her Queen, whom she has cooked for since Ysolde was a girl."
secret: "Has been sending up broth secretly tasted by herself, because she doesn't trust Pell."
disposition: friendly
essential: true
dialogue: dlg.cook_marit
barks: ["Out of my kitchen unless you're carrying onions.", "Mind the spit!", "Twenty years I've fed her. Twenty years."]
combat: null
shop: null
```

```yaml npc
id: npc.scullion_jeb
name: "Jeb"
faction: null
role: "Scullion boy"
motive: "Coins, and to get out of the scullery one day."
secret: "Saw Pell counting gold in the privy, and saw a grey-hooded man at the yard gate in spring."
disposition: neutral
essential: true
dialogue: dlg.scullion_jeb
barks: ["Pots don't wash themselves, sir. More's the pity.", "Got a coin, sir?", "I see everything. Nobody sees me."]
combat: null
shop: null
```

```yaml npc
id: npc.physician_fell
name: "Master Idris Fell"
faction: faction.crown
role: "Royal physician"
motive: "Keep his post and his reputation, and not be blamed when the Queen dies."
secret: "He has suspected poison for a month and said nothing, afraid of being wrong in front of the Abbot and Varn."
disposition: wary
essential: true
dialogue: dlg.physician_fell
barks: ["A wasting fever. Classic presentation.", "Please do not touch the tonics.", "I have been a physician for thirty years."]
combat: null
shop: null
```

```yaml npc
id: npc.maid_ilse
name: "Ilse"
faction: faction.crown
role: "The Queen's maid"
motive: "Care for the Queen, keep strangers out of her things."
secret: null
disposition: wary
essential: true
dialogue: null
barks: ["Her Majesty is resting.", "Don't touch her brushes.", "If the Marshal says so."]
combat: null
shop: null
```

```yaml npc
id: npc.tobiah_quill
name: "Tobiah Quill"
faction: faction.varn
role: "Chancellor Varn's private clerk"
motive: "Survive his master's crimes without being hanged for them."
secret: "Keeps a second, honest copy of the toll books in case he ever needs to save his own neck."
disposition: wary
essential: true
dialogue: null
barks: ["The Chancellor is not receiving.", "I only write what I'm told.", "Please. I have children. Probably."]
combat: null
shop: null
```

```yaml npc
id: npc.mossy_driver
name: "Mossy"
faction: faction.varn
role: "Varn's carriage driver"
motive: "Get paid, stay warm, ask no questions."
secret: "Drives Varn to a moneylender in Attre Street every week with a strongbox."
disposition: neutral
essential: false
dialogue: dlg.mossy_driver
barks: ["Waiting for the master.", "Cold night for it.", "Didn't see nothing."]
combat: null
shop: null
```

## 5. Dialogue trees

### 5.1 The Queen in her sickroom

```yaml dialogue
id: dlg.ysolde_sickroom
participants: [npc.ysolde]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "queen() >= 3", next: comatose}
      - {if: "queen() == 2", next: dawn_only}
      - {if: "queen() == 1", next: bedridden}
    else: open
  comatose:
    type: line
    speaker: player
    text: "She doesn't wake. Her breath rattles like wind under a door."
    next: bye
  dawn_only:
    type: line
    speaker: npc.ysolde
    text: "My son. Keep... my son."
    next: bye
  bedridden:
    type: line
    speaker: npc.ysolde
    text: "You again. I'm tired. Say it quickly, or come back when I'm dead."
    next: bedridden_hub
  bedridden_hub:
    type: choice
    options:
      - id: confide_b
        text: "Tell me what the Oath is for, Majesty. [Persuade 6]"
        tag: persuade
        condition: "not flag(flag.queen_confided)"
        check: {skill: persuade, dc: 6, pass: confide, fail: confide_fail}
        once: true
      - id: rest
        text: "Rest, Majesty."
        next: bye
  open:
    type: line
    speaker: npc.ysolde
    text: "Ah. The Marshal's sellsword. Help me sit up; no, not you, Ilse, I want to see if a mercenary has gentle hands. ...They do. How disappointing."
    direction: "Gloves on in bed. The tremor in her fingers never stops."
    next: hub
  hub:
    type: choice
    options:
      - id: poison
        text: "You're not dying of fever, Majesty. You're being poisoned."
        next: poison
      - id: oath_letter
        text: "Dravin Ostrel wrote to the Marshal. But I think he meant it for you. [Item: Dravin's dispatch]"
        tag: item
        condition: "has_item(item.dravin_letter) and not flag(flag.queen_confided)"
        next: confide
      - id: oath_son
        text: "Your son trusts me, Majesty. Trust me with what he can't know."
        condition: "var(var.aldric_bond) >= 2 and not flag(flag.queen_confided)"
        next: confide
      - id: oath_persuade
        text: "What is the Oath at the Ring of Nine really for? [Persuade 6]"
        tag: persuade
        condition: "not flag(flag.queen_confided)"
        check: {skill: persuade, dc: 6, pass: confide, fail: confide_fail}
        once: true
      - id: wine
        text: "Who brings your wine, Majesty?"
        next: wine
      - id: bye_opt
        text: "I'll let you rest."
        next: farewell
  poison:
    type: line
    speaker: npc.ysolde
    text: "I know. I've known since midsummer. A queen who knows she's being poisoned and says so starts a war over her own deathbed. I'd rather finish the Oath first."
    next: hub
  wine:
    type: line
    speaker: npc.ysolde
    text: "The Abbot, every evening. Anselm is the only man in this palace who has never asked me for anything. If you are thinking what I think you're thinking, think harder."
    next: hub
  confide:
    type: line
    speaker: npc.ysolde
    text: "Corvan sealed his weapons under Karak Ostrel. Blight, engines, men made into weapons. Every nineteen winters the crowned monarch speaks four verses at the Ring, and the locks hold."
    effects: ["set_flag(flag.queen_confided)", "add_clue(clue.queen_knows_vaults)"]
    next: confide_b
  confide_b:
    type: line
    speaker: npc.ysolde
    text: "'By iron forged in mountain deep.' That's the first. If I die before solstice dawn and my son isn't crowned, the locks will not know his voice. I have told this to no one but my confessor."
    next: confide_c
  confide_c:
    type: line
    speaker: npc.ysolde
    text: "So keep me alive, sellsword. Or keep him alive and get the Crown on his head. One of the two. Preferably both."
    next: hub_after
  hub_after:
    type: choice
    options:
      - id: promise
        text: "Both, Majesty."
        next: farewell
      - id: price
        text: "That's a lot to ask for Crown's pay."
        next: price
  price:
    type: line
    speaker: npc.ysolde
    text: "Then name your price to Kosk when it's done. If it's done, he'll pay it. If it isn't, there'll be nobody left to send you a bill."
    next: farewell
  confide_fail:
    type: line
    speaker: npc.ysolde
    text: "Prettily asked. No. Come back when you've earned it, or when I'm too tired to care."
    next: farewell
  farewell:
    type: line
    speaker: npc.ysolde
    text: "Go. And if you see my son on the way out, tell him his mother says to eat something."
    next: bye
  bye:
    type: end
```

### 5.2 Kosk and the chalice

```yaml dialogue
id: dlg.kosk_chalice
participants: [npc.kosk]
start: open
nodes:
  open:
    type: line
    speaker: npc.kosk
    text: "What's that? ...Dust. On her cup. Smells like the courier did. You're telling me it's in her wine."
    direction: "He turns the chalice in his big hands like a weapon he doesn't recognize."
    effects: ["set_flag(flag.varn_light_seen)"]
    next: hub
  hub:
    type: choice
    options:
      - id: guard_keen
        text: "Look. Here, in the engraving: it's caked in. Every dose leaves a little behind. Someone's been doing this for months."
        condition: "perk(perk.keen_eye)"
        next: secured
      - id: guard
        text: "Put your own men on her cup and her wine. Nobody else touches them. [Persuade 4]"
        tag: persuade
        check: {skill: persuade, dc: 4, pass: secured, fail: guard_fail}
        once: true
      - id: varn
        text: "Is anyone else up at night that I should know about?"
        next: varn
      - id: later
        text: "I'll keep looking first."
        next: bye
  secured:
    type: line
    speaker: npc.kosk
    text: "Done. My seal on the wine from now on, my men on the cup, and anyone who argues can argue with me. ...Thank you. I should have seen it."
    effects: ["set_flag(flag.chalice_secured)", "play_beat(chalice_guarded)", "add_rep(faction.crown, 5)"]
    next: varn
  guard_fail:
    type: line
    speaker: npc.kosk
    text: "Take the Queen's communion out of the Abbot's hands on the word of a sellsword and a pinch of dust? The court would eat me. Bring me more."
    next: hub
  varn:
    type: line
    speaker: npc.kosk
    text: "Varn. His solar burns all night. My men see the smoke from the barracks roof. A man doesn't burn that much firewood on Chancellery pay. Find out what he's burning."
    next: bye
  bye:
    type: end
```

### 5.3 Aldric at the window (Aldric scene 2)

```yaml dialogue
id: dlg.aldric_sickroom
participants: [npc.aldric]
start: open
nodes:
  open:
    type: line
    speaker: npc.aldric
    text: "Shh. She's sleeping. She sleeps all the time now. Sit. You can sit, I said so."
    direction: "At the window seat, his mother's gloved hand in both of his. He doesn't let go of it."
    effects: ["set_flag(flag.aldric_sickroom_done)"]
    next: met_check
  met_check:
    type: branch
    cases:
      - {if: "not flag(flag.met_aldric)", next: first_meet}
    else: ask
  first_meet:
    type: line
    speaker: npc.aldric
    text: "You're the sellsword from the docks. Brask told me. Everybody tells Brask everything and Brask tells me, because she thinks I should know things."
    effects: ["set_flag(flag.met_aldric)", "set_var(var.aldric_bond, 0)"]
    next: ask
  ask:
    type: line
    speaker: npc.aldric
    text: "Is somebody poisoning her? You can tell me. I'm going to be king. Kings have to know things."
    next: hub
  hub:
    type: choice
    options:
      - id: say_yes
        text: "Yes. I think so. I'm going to find out who."
        condition: "has_clue(clue.chalice_pollen)"
        effects: ["add_var(var.aldric_bond, 1)"]
        next: yes_answer
      - id: maybe
        text: "Maybe. I don't know yet. When I do, you'll hear it from me first."
        effects: ["add_var(var.aldric_bond, 1)", "set_flag(flag.aldric_promised_truth)"]
        next: maybe
      - id: lie
        text: "No, Highness. It's a fever."
        next: lie
  yes_answer:
    type: line
    speaker: npc.aldric
    text: "I knew it. Then I'll taste her food myself. Every meal. If it's poisoned it'll be me instead."
    next: taste_hub
  maybe:
    type: line
    speaker: npc.aldric
    text: "First. You promise? ...All right. Then I'll taste her food myself till you know. Every meal."
    next: taste_hub
  lie:
    type: line
    speaker: npc.aldric
    text: "Everyone says that. Her hands are cold all the time. Fevers are hot. I'm not stupid."
    next: words
  taste_hub:
    type: choice
    options:
      - id: stop
        text: "No. That's how tasters die, and then the realm has no king. Your job is to live. Leave the poison to me."
        effects: ["add_var(var.aldric_bond, 1)"]
        next: stop
      - id: brave
        text: "That's brave. Stupid, but brave."
        next: brave
  stop:
    type: line
    speaker: npc.aldric
    text: "My job is to live. ...Nobody ever said it like that. Like it's a job. All right. I'll do my job if you do yours."
    next: words
  brave:
    type: line
    speaker: npc.aldric
    text: "Stupid and brave is what Father Anselm says kings are made of. He says it's what the court lacks."
    next: words
  words:
    type: line
    speaker: npc.aldric
    text: "Look, I wrote down my patience words. Father Anselm says I'll need them one day, when I'm crowned. Ar-veth tor halun, dum ostrel vey..."
    direction: "He shows a wax tablet covered in a boy's careful dwarven runes."
    effects: ["set_flag(flag.heard_aldric_words)"]
    next: words_hub
  words_hub:
    type: choice
    options:
      - id: lore
        text: "Let me see those runes. [Lore 8]"
        tag: lore
        check: {skill: lore, dc: 8, pass: lore_pass, fail: lore_fail}
        once: true
      - id: nice
        text: "Your teacher's patient."
        next: nice
      - id: go
        text: "Look after her, Highness."
        next: go
  lore_pass:
    type: line
    speaker: player
    text: "These are dwarven runes, but every line is written mirror-wise, right to left. As if someone wanted them spoken backwards without the speaker knowing."
    direction: "Hale keeps the thought to themself; Aldric is too pleased with his tablet to notice."
    effects: ["set_flag(flag.aldric_mirror_words)"]
    next: go
  lore_fail:
    type: line
    speaker: player
    text: "Dwarven. Old. Beyond me."
    next: go
  nice:
    type: line
    speaker: npc.aldric
    text: "He's the only patient one. Everyone else is waiting for her to die."
    next: go
  go:
    type: line
    speaker: npc.aldric
    text: "Come back and tell me. You promised. Or you didn't, but come back anyway."
    next: bye
  bye:
    type: end
```

### 5.4 Pell

`clue.taster_gold` comes from watching the dice game (no check), the locker (Investigate 4), or Jeb (Bribe 5 or Persuade 4). The confrontation needs the clue. Approaches: Intimidate 6, Persuade 6, both clues (no check), or simply arresting him with the writ (no confession, but he is exposed).

```yaml dialogue
id: dlg.pell
participants: [npc.pell]
start: open
nodes:
  open:
    type: line
    speaker: npc.pell
    text: "Tasted the soup, tasted the bread, still alive! Ha. That's the job. What can the royal tongue do for you?"
    direction: "Too cheerful. He keeps one hand over his belt pouch."
    next: hub
  hub:
    type: choice
    options:
      - id: gold
        text: "Where does a food-taster get new gold crowns? [Clue: Pell's new gold]"
        tag: clue
        condition: "has_clue(clue.taster_gold)"
        show_locked: true
        next: gold
      - id: job
        text: "Do you taste everything she eats and drinks?"
        next: job
      - id: bye_opt
        text: "Nothing. Enjoy your soup."
        next: bye
  job:
    type: line
    speaker: npc.pell
    text: "Every crumb! Well. Not the holy wine, obviously. Can't have a taster's spit in the sacrament. The Abbot's very particular. Very holy man."
    next: hub
  gold:
    type: line
    speaker: npc.pell
    text: "Lucky streak at dice! Lucky, lucky. You can ask anyone. Ha."
    direction: "Sweat on his lip."
    next: press
  press:
    type: choice
    options:
      - id: both
        text: "You stopped tasting her wine in spring, the same spring you got rich. Who paid you to look away? [Clue: The untasted communion wine]"
        tag: clue
        condition: "has_clue(clue.communion_wine)"
        show_locked: true
        next: confess
      - id: scare
        text: "The Marshal hangs traitors from the Lion Gate. You'll be the lightest one he's ever hanged. [Intimidate 6]"
        tag: intimidate
        check: {skill: intimidate, dc: 6, pass: confess, fail: scare_fail}
        once: true
      - id: mercy
        text: "Tell me now and I'll ask the Marshal for your life. Later, I won't. [Persuade 6]"
        tag: persuade
        check: {skill: persuade, dc: 6, pass: confess, fail: mercy_fail}
        once: true
      - id: arrest
        text: "In the Marshal's name, you're under arrest. [Item: Marshal's writ]"
        tag: item
        condition: "has_item(item.kosk_writ)"
        next: arrest
      - id: back_off
        text: "Lucky streak. Right."
        next: back_off
  scare_fail:
    type: line
    speaker: npc.pell
    text: "You can't prove a thing! Dice! It was dice!"
    next: press
  mercy_fail:
    type: line
    speaker: npc.pell
    text: "Mercy, from Kosk? Ha! No. No thank you."
    next: press
  back_off:
    type: line
    speaker: npc.pell
    text: "Right! Lucky. Ha. I've, um, soup to taste."
    next: bye
  confess:
    type: line
    speaker: npc.pell
    text: "All right! All right. A man came to the yard gate in spring. Grey cloak, soft hands, smelled of beeswax. Paid me to stop tasting the communion wine. Said I wasn't fit to touch it. That's all!"
    direction: "He folds like wet bread."
    effects: ["set_flag(flag.pell_confessed)"]
    next: deeper
  deeper:
    type: choice
    options:
      - id: name
        text: "His name. [Intimidate 8]"
        tag: intimidate
        check: {skill: intimidate, dc: 8, pass: name_pass, fail: name_fail}
        once: true
      - id: boots
        text: "Take off your boots."
        next: boots
      - id: take
        text: "You're going to the Marshal."
        next: arrest
  name_pass:
    type: line
    speaker: npc.pell
    text: "No name! He never said! He said... the Choir sings for the dead kings, and soon it would sing for the living. I thought it was a hymn!"
    effects: ["set_flag(flag.pell_choir_words)"]
    next: deeper
  name_fail:
    type: line
    speaker: npc.pell
    text: "I don't know! I don't know, I don't know!"
    next: deeper
  boots:
    type: line
    speaker: player
    text: "Inside the left boot, stitched into the lining: a pale gull feather."
    direction: "Pell watches, white-faced."
    effects: ["add_clue(clue.pale_feather)"]
    next: arrest
  arrest:
    type: line
    speaker: npc.pell
    text: "You can't! I only... it was only looking away! Looking away isn't murder!"
    direction: "Kosk's men take him by the arms."
    effects: ["set_flag(flag.food_taster_exposed)", "set_flag(flag.pell_arrested)", "play_beat(pell_taken)", "add_rep(faction.crown, 5)"]
    next: bye
  bye:
    type: end
```

### 5.5 Kitchen staff

```yaml dialogue
id: dlg.cook_marit
participants: [npc.cook_marit]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.cook_marit
    text: "Writ or no writ, you're standing in my gravy. What do you want?"
    next: hub
  hub:
    type: choice
    options:
      - id: queen
        text: "Who handles the Queen's food and drink?"
        next: queen
      - id: pell
        text: "What do you make of Pell?"
        next: pell
      - id: night
        text: "Anything odd at night?"
        next: night
      - id: bye_opt
        text: "I'll get out of your gravy."
        next: bye
  queen:
    type: line
    speaker: npc.cook_marit
    text: "Me, and Pell tastes it, and up it goes. Except her wine. That comes from the Abbey sealed, and Pell hasn't tasted it since spring. 'Piety', he says. Pell's as pious as a ferret."
    effects: ["add_clue(clue.communion_wine)"]
    next: hub
  pell:
    type: line
    speaker: npc.cook_marit
    text: "Lazy, cheerful, owes everyone. Except lately he doesn't owe anyone. Paid me back four crowns he's owed since the equinox before last. In gold. Pell. Gold."
    next: hub
  night:
    type: line
    speaker: npc.cook_marit
    text: "The Chancellor's lamp. Burns past midnight over the yard, and the smoke from his chimney stinks of paper, not wood. Burning letters to his sweetheart, I'd say, if he had one."
    effects: ["set_flag(flag.varn_light_seen)"]
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.scullion_jeb
participants: [npc.scullion_jeb]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.scullion_jeb
    text: "Sir. If you're looking for the clean pots, there aren't any. If you're looking for gossip, that's extra."
    next: hub
  hub:
    type: choice
    options:
      - id: pay
        text: "Here's extra. [Bribe 5]"
        tag: bribe
        bribe: 5
        condition: "not has_clue(clue.taster_gold)"
        next: tell
      - id: kind
        text: "You've got sharp ears. The Marshal could use a pair. [Persuade 4]"
        tag: persuade
        condition: "not has_clue(clue.taster_gold)"
        check: {skill: persuade, dc: 4, pass: tell, fail: kind_fail}
        once: true
      - id: hood
        text: "Seen any strangers at the yard gate?"
        next: hood
      - id: bye_opt
        text: "Wash your pots, Jeb."
        next: bye
  tell:
    type: line
    speaker: npc.scullion_jeb
    text: "Pell counts gold in the privy. I've heard it clink, sir. Eleven, twelve coins. New ones, they ring different. He keeps the purse in his locker, the one with the P."
    effects: ["add_clue(clue.taster_gold)"]
    next: hub
  kind_fail:
    type: line
    speaker: npc.scullion_jeb
    text: "Compliments don't buy bread, sir."
    next: hub
  hood:
    type: line
    speaker: npc.scullion_jeb
    text: "In spring. Grey hood, by the yard gate, talking to Pell. Dropped a feather when he went. I kept it. ...Then I lost it. Sorry."
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.physician_fell
participants: [npc.physician_fell]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.physician_fell
    text: "A wasting fever. Classic presentation. I've written it all down; you may read it if you must, but do not touch the tonics."
    next: hub
  hub:
    type: choice
    options:
      - id: press
        text: "Your notes say 'no fever', crossed out. Which is it? [Persuade 4]"
        tag: persuade
        check: {skill: persuade, dc: 4, pass: admit, fail: deny}
        once: true
      - id: tonic
        text: "What's the Abbot's tonic?"
        next: tonic
      - id: bye_opt
        text: "Carry on, Master Fell."
        next: bye
  admit:
    type: line
    speaker: npc.physician_fell
    text: "There is no fever. Cold hands, cold feet, numbness creeping inward. I have seen it once, in a herb-wife's child in the hills. A flower. I didn't dare say. Look to what she drinks."
    next: hub
  deny:
    type: line
    speaker: npc.physician_fell
    text: "It is a fever because I say it is a fever. Good day."
    next: bye
  tonic:
    type: line
    speaker: npc.physician_fell
    text: "Honey, poppy and something of the Abbey's own receipt. He won't tell me what. Monks and their secrets. It does help her sleep."
    next: hub
  bye:
    type: end
```

### 5.6 Mossy the driver

```yaml dialogue
id: dlg.mossy_driver
participants: [npc.mossy_driver]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.mossy_driver
    text: "Waiting for the master. Cold night for it. You're not the master."
    next: hub
  hub:
    type: choice
    options:
      - id: bribe
        text: "Go home, Mossy. The master's walking tonight. [Bribe 20]"
        tag: bribe
        bribe: 20
        effects: ["set_flag(flag.carriage_gone)"]
        next: gone
      - id: writ
        text: "Marshal's business. Take the carriage and go. [Intimidate 4]"
        tag: intimidate
        condition: "has_item(item.kosk_writ)"
        check: {skill: intimidate, dc: 4, pass: gone_scared, fail: stay}
        once: true
      - id: leave
        text: "Stay warm."
        next: bye
  gone:
    type: line
    speaker: npc.mossy_driver
    text: "Walking, is he. Well. His feet, my bed. Night."
    direction: "He clicks to the horse and rattles off down the lane."
    next: bye
  gone_scared:
    type: line
    speaker: npc.mossy_driver
    text: "Marshal's... right. Right you are. Never here."
    effects: ["set_flag(flag.carriage_gone)"]
    next: bye
  stay:
    type: line
    speaker: npc.mossy_driver
    text: "Paper's paper. Master pays. I stay."
    next: bye
  bye:
    type: end
```

### 5.7 Varn caught

```yaml dialogue
id: dlg.varn_caught
participants: [npc.varn]
start: mark
nodes:
  mark:
    type: effect
    effects: ["set_flag(flag.varn_chase_won)", "give_item(item.varn_ledger_scrap, 1)", "add_clue(clue.varn_ledgers)"]
    next: done_check
  done_check:
    type: branch
    cases:
      - {if: "has_clue(clue.chalice_pollen) and not ms(ms.a1_sickroom_done)", next: done}
    else: open
  done:
    type: effect
    effects: ["reach_milestone(ms.a1_sickroom_done)"]
    next: open
  open:
    type: line
    speaker: npc.varn
    text: "Don't! Don't, I'll pay, I'll pay anything, whatever the Marshal's paying you, double, triple! It's only tolls! It's only money!"
    direction: "Sobbing, on his knees among scorched ledger pages, clutching his rings."
    next: hub
  hub:
    type: choice
    options:
      - id: accuse
        text: "You poisoned the Queen."
        next: accuse
      - id: read
        text: "Let's see what's worth burning."
        next: read
      - id: arrangement
        text: "We have an arrangement, Chancellor. Remember?"
        condition: "flag(flag.varn_retainer)"
        next: arrangement
      - id: decide
        text: "Here's what happens now."
        next: decide
  accuse:
    type: line
    speaker: npc.varn
    text: "Poison? Poison? I steal, I don't kill! Her Majesty alive is the only thing standing between me and Kosk's rope! When she dies, he'll hang me in a week! Why would I want her dead?"
    next: accuse_b
  accuse_b:
    type: line
    speaker: npc.varn
    text: "Ask who profits from her death. Not a fat old thief. Raimund in Attre, with his independence. Sodden. Fanatics. Anyone but me."
    next: hub
  read:
    type: line
    speaker: player
    text: "Toll sums. Two columns that don't agree, ten years running. Thousands of crowns skimmed off the Yaruga. Not one word about poison."
    next: silver_q
  silver_q:
    type: choice
    options:
      - id: silver
        text: "What else moves through your tolls that shouldn't? [Persuade 6]"
        tag: persuade
        check: {skill: persuade, dc: 6, pass: silver_pass, fail: silver_fail}
        once: true
      - id: back
        text: "Enough."
        next: hub
  silver_pass:
    type: line
    speaker: npc.varn
    text: "The Abbey. Church goods go toll-free, it's the law. St. Corwen has moved more silver through my river in a year than in the ten before. And iron crates. Heavy ones, south, by barge. For a monastery!"
    effects: ["add_clue(clue.abbey_silver_tolls)"]
    next: hub
  silver_fail:
    type: line
    speaker: npc.varn
    text: "Nothing! Wool, grain, wine. Ask Quill. Quill knows everything. Quill is a snake."
    next: hub
  arrangement:
    type: line
    speaker: npc.varn
    text: "Yes! Yes. Arrangement. Twenty a week. Thirty. Forty, and the ledger stays ash, and we never speak of tonight."
    next: hub
  decide:
    type: choice
    options:
      - id: blackmail
        text: "Your secret's safe. For a price, paid regularly."
        effects: ["set_flag(flag.varn_blackmailed)", "add_crowns(60)", "add_rep(faction.varn, 20)"]
        next: blackmail
      - id: kosk
        text: "You're coming to the Marshal. With the ledger."
        effects: ["set_flag(flag.varn_exposed)", "add_rep(faction.varn, -40)", "add_rep(faction.crown, 5)"]
        next: kosk
      - id: spare
        text: "Go home, Varn. I'm hunting a poisoner, not a thief. Your secret's your own. For now."
        effects: ["set_flag(flag.varn_spared)", "add_rep(faction.varn, 15)"]
        next: spare
  blackmail:
    type: line
    speaker: npc.varn
    text: "Sixty now. Wretch. Wretch! ...More, later. I'll find more. Gods, you're worse than the Marshal."
    next: bye
  kosk:
    type: line
    speaker: npc.varn
    text: "No! No, no, please... you'll make a regent of a butcher! Do you know what Kosk did at Marnadal? Do you?"
    direction: "Hale marches him down the stair. He doesn't fight; he just weeps."
    next: bye
  spare:
    type: line
    speaker: npc.varn
    text: "For now. Yes. For now is... for now is very generous. I won't forget it. I'm a thief, but I do pay my debts. Eventually."
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.chancellery_guards
zone: zone.chancellery_rooftops
posture: sentry
enemies:
  - {enemy: enemy.bandit, count: 1, spawn: guard_landing, variant: hired_guard}
  - {enemy: enemy.bandit, count: 1, spawn: guard_hall, variant: hired_guard, posture: patrol, route: [clerks_hall], loop_s: 30}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: chancellery_in
avoidable_by: []
on_won: []
on_yielded: []
on_player_fled: []
```

The `hired_guard` variant is the low end of the bandit band (L3, 55 HP, 10 blunt, armor 10, a cudgel and a lantern). The fight is optional and does not stop the chase: Varn flees the moment the alarm sounds, and the guards are behind the player. A player who fights them first usually loses the chase (the soft fail).

**Non-combat alternatives.** Stealth through the stair and hall (takedowns allowed) catches Varn red-handed with no chase. The roof route avoids the guards but alerts Varn at the window (chase). Paying or scaring Mossy first means the chase cannot be lost.

## 7. Items and clues

```yaml item
id: item.varn_ledger_scrap
name: "Half-burned toll ledger"
category: document
description: "A scorched quire from the Chancellery's private books: Yaruga toll sums in two columns that don't agree, ten years running."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Tolls, Yaruga mouth, Michaelmas quarter. Received: 4,210 cr. Entered: 2,980 cr. Difference to O.V., private. (The same note repeats, quarter after quarter, in Varn's hand.)"
```

```yaml item
id: item.ysolde_hair
name: "Lock of the Queen's hair"
category: key
description: "A few grey-streaked strands from Queen Ysolde's brush, twisted in linen. Taken with the Marshal's leave. Some hedge-witches can read poison in hair."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.pell_purse
name: "Pell's altar-linen purse"
category: document
description: "A purse sewn from undyed altar linen, holding eleven new gold crowns. Evidence; the coins are not yours to spend."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml clue
id: clue.chalice_pollen
theory: theory.poisoner
title: "Pollen in the Queen's chalice"
text: "Fine grey-gold pollen caked into the engraving under the rim of the Queen's silver chalice, smelling of lilies, like the courier's froth. The poison is in her communion wine."
supports: []
refutes: []
```

```yaml clue
id: clue.communion_wine
theory: theory.poisoner
title: "The untasted communion wine"
text: "The Queen's communion wine comes up sealed from the Abbey each evening, carried by the Abbot. Pell, whose duty is to taste everything, has been excused from tasting it since spring, 'for piety'."
supports: [pell, anselm]
refutes: []
```

```yaml clue
id: clue.taster_gold
theory: theory.poisoner
title: "Pell's new gold"
text: "Pell, the royal food-taster, paid his debts this autumn in new, unclipped gold crowns, kept in a purse of altar linen."
supports: [pell]
refutes: []
```

```yaml clue
id: clue.varn_ledgers
theory: theory.poisoner
title: "Varn's burning ledgers"
text: "Chancellor Varn burns his private toll books at night: ten years of skimmed Yaruga tolls. He needs the Queen alive to keep Kosk from hanging him."
supports: []
refutes: [varn]
```

```yaml clue
id: clue.queen_knows_vaults
theory: theory.poisoner
title: "The Queen knows what the Oath is for"
text: "Ysolde told me: the Oath at the Ring locks the Deep-Vaults under Karak Ostrel, where Corvan sealed his weapons. If she dies before Aldric is crowned, the locks won't know his voice. She has told only her confessor."
supports: [anselm]
refutes: []
```

```yaml clue
id: clue.abbey_silver_tolls
theory: theory.choir
title: "Abbey silver on the river"
text: "Church goods pass the Yaruga tolls free. This year St. Corwen has moved more silver than in the ten years before, and heavy iron crates south by barge."
supports: []
refutes: []
```

```yaml deduction
id: ded.varn_thief_not_poisoner
theory: theory.poisoner
condition: "has_clue(clue.varn_ledgers)"
title: "Varn is a thief, not a poisoner"
text: "The ledgers he burns hide toll embezzlement. He needs the Queen alive; her death would put him at Kosk's mercy."
```

```yaml deduction
id: ded.taster_is_bought
theory: theory.poisoner
condition: "has_clue(clue.taster_gold) or has_clue(clue.taster_dispatch)"
title: "The taster has been bought"
text: "Pell was paid to stop tasting the Queen's wine. Someone opened the door for the poison; Pell only held it."
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: flag.chalice_secured, type: bool, desc: "Kosk's men guard the Queen's chalice and wine (mitigation 1, gdd §6.2)."}
  - {id: flag.food_taster_exposed, type: bool, desc: "Pell the food-taster is exposed (mitigation 2, gdd §6.2). Also set by the Morrow Gull tube (A07)."}
  - {id: flag.pell_arrested, type: bool, desc: "Pell was taken by Kosk's men (any confrontation route)."}
  - {id: flag.pell_confessed, type: bool, desc: "Pell confessed to being paid to skip the wine."}
  - {id: flag.pell_choir_words, type: bool, desc: "Pell repeated 'the Choir sings for the dead kings' (Intimidate 8)."}
  - {id: flag.queen_confided, type: bool, desc: "The Queen told the player what the Oath protects."}
  - {id: flag.aldric_sickroom_done, type: bool, desc: "Aldric scene 2 (window seat) has played."}
  - {id: flag.aldric_mirror_words, type: bool, desc: "The player noticed Aldric's 'patience words' are written mirror-wise (Lore 8). Foreshadows the reversed Oath; A05/A06 may read it."}
  - {id: flag.varn_light_seen, type: bool, desc: "The player knows Varn burns something in his solar at night; opens the Chancellery."}
  - {id: flag.varn_alerted, type: bool, desc: "Varn knows he is being hunted; the chase is on."}
  - {id: flag.varn_red_handed, type: bool, desc: "The player reached the solar unseen and caught Varn at the brazier."}
  - {id: flag.carriage_gone, type: bool, desc: "Varn's carriage was sent away; the chase cannot be lost."}
  - {id: flag.varn_chase_won, type: bool, desc: "Varn was caught (chase or red-handed)."}
  - {id: flag.varn_chase_lost, type: bool, desc: "Varn escaped in his carriage (soft fail: no blackmail; solar re-search available)."}
  - {id: flag.varn_blackmailed, type: bool, desc: "The player blackmails Varn (gdd §6.1 stage 1 exemption, §6.12)."}
  - {id: flag.varn_spared, type: bool, desc: "The player let Varn go and kept his secret for free."}
  - {id: ms.a1_sickroom_done, type: milestone, xp: 200, desc: "Chalice evidence found and the Varn red herring resolved (won or lost)."}
reads:
  - ms.a1_audience_done
  - flag.fair_started
  - flag.hair_leave
  - flag.met_aldric
  - var.aldric_bond
  - flag.aldric_promised_truth
  - flag.varn_retainer
  - flag.varn_exposed
  - flag.heard_aldric_words
```

## 9. Quest hooks

This section contributes the `sickroom` objective of `quest.main_a1` stage `follow_the_leads` (declared in `02-audience-at-court.md`, order 30). No new main-quest stages. The two mitigations are tracked in the journal through their clues and deductions.

## 10. Rumors and event cards (optional)

Losing the chase marks `rumor.r02_varn_ledgers` heard ("Chancellor Varn burns ledgers in his solar after midnight", story §11 rumor 2, A07). Hearing that rumor anywhere also opens the Chancellery door from the hub, so the solar re-search is reachable without ever starting the chase.

## 11. Failure states and branches

```yaml branches
paths:
  - id: red_handed
    when: "Player sneaks up the clerks' stair and through the hall unseen and opens the solar door."
    outcome: "No chase. dlg.varn_caught: ledger scrap, clue.varn_ledgers, then blackmail / turn in / spare."
    sets: ["set_flag(flag.varn_chase_won)"]
  - id: chase_won
    when: "Varn is alerted (window, alarm) and the player catches him on the roofs, or he is cornered because the carriage is gone."
    outcome: "As red_handed."
    sets: ["set_flag(flag.varn_chase_won)"]
  - id: chase_lost
    when: "Varn reaches his carriage or gets 25 m ahead for 5 s."
    outcome: "No blackmail. Rumor 2 marked heard. The solar can be searched later (Investigate 6) for the scrap and clue.varn_ledgers."
    sets: ["set_flag(flag.varn_chase_lost)"]
  - id: chalice_secured
    when: "Player shows Kosk the chalice and passes Persuade 4, or has Keen Eye."
    outcome: "Mitigation 1; Crown +5."
    sets: ["set_flag(flag.chalice_secured)"]
  - id: taster_exposed
    when: "Player confronts Pell with clue.taster_gold and breaks him (both clues, Intimidate 6, Persuade 6) or arrests him with the writ."
    outcome: "Mitigation 2; Crown +5. Feather clue if his boots are searched after a confession."
    sets: ["set_flag(flag.food_taster_exposed)"]
  - id: queen_confides
    when: "Queen at condition 0 or 1; player shows Dravin's letter, has Aldric bond >= 2, or passes Persuade 6."
    outcome: "clue.queen_knows_vaults; the first verse quoted."
    sets: ["set_flag(flag.queen_confided)"]
failures:
  - id: guards_alarm
    result: soft_fail
    recover: "The guards fight; Varn flees with a head start. The chase may still be won."
  - id: player_dies_roofs
    result: reload_checkpoint
    recover: "Reload chancellery_in, roofs_in or chase_start."
  - id: pell_clams_up
    result: soft_fail
    recover: "Failed checks lock only for this conversation (the clue options are not once). Talk again with the other clue, or arrest him with the writ."
  - id: chalice_persuade_failed
    result: soft_fail
    recover: "The persuade option is once. Without Keen Eye, flag.chalice_secured is lost; the Queen declines faster in Act II (gdd §6.2)."
guarantees:
  - "clue.chalice_pollen: chalice search, no check."
  - "Varn chase resolution: always reaches won or lost (the chase controller always ends in varn_caught, varn_cornered or varn_escapes). flag.varn_light_seen comes from Marit (no check) or Kosk's chalice talk (no check)."
  - "ms.a1_sickroom_done: whichever of the two parts comes last fires it (t_sick_done_chalice, dlg.varn_caught/done_check, t_sick_done_escape)."
```

## 12. Open questions

1. **Chase (resolved by A08).** `zone.chancellery_rooftops` has a `chases` entry (content-format §J.5) with the §3.3 rules; it plays `varn_escapes` / `varn_cornered`, and the `grab_varn` interactable is the catch.
2. **Patrols vs encounter (resolved by A08).** `enc.chancellery_guards` has `posture: sentry`, and the hall guard patrols `clerks_hall` (§J.4). They engage on the alarm.
3. **Hazard activation (resolved by A08).** `kicked_brazier` has `enabled_by: {"on": beat_done, source: varn_flees}` (§J.3).
4. **Dialogue override per location (resolved by A08).** The Queen uses the zone `npcs` entry's `dialogue: dlg.ysolde_sickroom` (§J.5). Kosk over the chalice and Aldric at the window stay an interactable and a trigger, because they are actions, not greetings.
5. **Clue support ids.** `clue.queen_knows_vaults` sits in the poisoner theory (gdd §6.11) and supports `anselm` only because he is the one person she told. Confirm that this is not too strong a hint for Act I.
