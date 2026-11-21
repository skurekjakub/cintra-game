---
section_id: side.rumors
title: "Tavern Rumors"
act: 1                                   # the pool spans all acts; each rumor's `available` gates it
story_ref: "story.md §11 Tavern Rumors (d10), §10 side quests"
zones: []
available_when: "true"
escalation_stage_required: {min: 0, max: 4}
milestones_set: []
milestones_read: [ms.a1_audience_done, ms.act1_complete, ms.a2_tigg_resolved, ms.a2_attre_ledger, ms.a2_torc_taken, ms.act2_twist]
level_band: [1, 12]
---

# Tavern Rumors

## 1. Scene summary
The rumor pool. A tavern keeper (or a talkative NPC listed in `sources`) tells one unheard, available rumor when the player buys a drink (the application charges the price; gdd §6.3, architecture §4.17). Rumors 1–10 are story.md §11's d10 table, verbatim in sense and close in wording. Rumors 11–20 are new and each one points at a side quest, so a player who drinks in the right places finds every side quest without luck on the road. A rumor's `truth` is hidden until the player has `perk.read_the_room`, or hears it from Bertha once her debt is cleared (`flag.bertha_safehouse`, side 01), or verifies it (`verified_by`).

## 2. Progress and escalation
- **Stage 0:** rumor 3 (the "dragon") is in the pool from the start, as gdd §6.1 stage 0 requires.
- **Act gating:** Act I taverns (the Drowned Rat) hear court rumors; Act II rumors need `ms(ms.act1_complete)`; rumor 9 grows more pointed after the audience; rumor 10 needs stage ≥ 1 (the court's fear of Sodden starts when Kosk and Varn clash).
- **Verification** happens when the `verified_by` condition first becomes true (`RumorVerified`, which marks the journal entry and shows the truth tag).
- Rumors set no milestones.

## 3. Location layout
No zones. Sources are tavern keepers and talkative NPCs placed by other sections.

| Source | Where | Owner |
|---|---|---|
| `npc.bertha` | The Drowned Rat, Cintra | A04 |
| `npc.tigg_innkeeper` | Tigg inn | A05 (expected) |
| `npc.attre_tapster` | Attre harbor tavern | A05 (expected) |
| `npc.dun_strept_alewife` | Dun Strept mead hall | A06 (expected) |
| `npc.harl_brine` | Attre harbor (side 06) | this slice |
| `npc.aud_skerra` | Skerra (side 05) | this slice |
| `npc.wencel_burner` | Rozrog camp (side 07) | this slice |
| `npc.brannoc` | Silver Mine camp (side 12) | this slice |

## 4. NPCs present
No new NPCs.

## 5. Dialogue trees
None. Drawing a rumor is a tavern-keeper interaction handled by the rumors domain.

## 6. Encounters
None.

## 7. Items and clues
None new. Rumors feed clues indirectly (rumor 2 opens the late search of Varn's solar, gdd §6.18).

## 8. Flags set and read
```yaml flags
declare: []
reads:
  - flag.marnadal_watch_hook
  - flag.rozrog_hook
  - flag.brzezina_hook
  - flag.bertha_safehouse
  - flag.brzezina_plot_exposed
  - flag.maelis_ledgers_done
  - flag.mirek_freed
  - flag.lower_breach_open
  - flag.selkie_freed
  - flag.woodwose_peace
  - flag.woodwose_dead
```

## 9. Quest hooks
Rumors 11–20 add map pins and, where a side quest's `available` reads a hook flag, set that flag:

| Rumor | Side quest | Effect |
|---|---|---|
| r11 | `quest.side_barrows` | pin `map.barrows` (the `cintra—barrows` edge opens on "rumor or quest hook") |
| r12 | `quest.side_morrow_gull` | pin `map.morrow_gull` |
| r13 | `quest.side_skerra` | pin `map.isle_skerra` |
| r14 | `quest.side_silver_mine` | pin `map.silver_mine` |
| r15 | `quest.side_marnadal_watch` | `flag.marnadal_watch_hook`, pin `map.marnadal_watch` |
| r16 | `quest.side_abbey_ledgers` | none (Maelis starts it); tells the player to talk to her |
| r17 | `quest.side_rozrog` | `flag.rozrog_hook`, pin `map.rozrog_forest` |
| r18 | `quest.side_brzezina` | `flag.brzezina_hook`, pin `map.brzezina_woods` |
| r19 | `quest.side_grey_ferry` | pin `map.grey_ferry` |
| r20 | `quest.side_ravensford` | pin `map.ravensford` |

Wenna's hair (side 08) and Bertha's debt (side 01) are started by their givers, not by rumors.

## 10. Rumors and event cards

### 10.1 The d10 table (story.md §11)

```yaml rumor
id: rumor.r01_poisoned_cup
text: "The Queen's not dying of fever. Someone's poisoning her cup. Ask the marsh-witch."
truth: true
sources: [npc.bertha, npc.tigg_innkeeper, npc.attre_tapster]
available: "true"
on_hear: ["add_map_pin(map.witchs_mere)"]
verified_by: "has_clue(clue.chalice_pollen)"
credibility_when: "flag(flag.bertha_safehouse) and heard_from(rumor.r01_poisoned_cup, npc.bertha)"
```

```yaml rumor
id: rumor.r02_varn_ledgers
text: "Chancellor Varn burns ledgers in his solar after midnight. My cousin hauls his ash buckets. Paper ash, every night."
truth: true
sources: [npc.bertha]
available: "ms(ms.a1_audience_done)"
on_hear: []
verified_by: "has_clue(clue.varn_ledgers)"
credibility_when: "flag(flag.bertha_safehouse) and heard_from(rumor.r02_varn_ledgers, npc.bertha)"
```
True, but it covers embezzlement, not treason. gdd §6.18: after a lost Varn chase, `clue.varn_ledgers` can still be found by a Wits 6 search of his solar once this rumor is heard. The solar interactable (A04) should test `rumor_heard(rumor.r02_varn_ledgers)`. Travel card L1 can also add this rumor.

```yaml rumor
id: rumor.r03_dragon_amell
text: "There's a dragon nesting in the Amell peaks. Took a whole flock off the Tigg commons, and the shepherd's boy saw wings wider than a barn."
truth: half
sources: [npc.bertha, npc.tigg_innkeeper]
available: "true"
on_hear: ["add_map_pin(map.tigg)"]
verified_by: "ms(ms.a2_tigg_resolved)"
credibility_when: "flag(flag.bertha_safehouse) and heard_from(rumor.r03_dragon_amell, npc.bertha)"
```
Half-true: it is a wyvern. Present from stage 0 (gdd §6.1).

```yaml rumor
id: rumor.r04_living_saint
text: "Abbot Anselm feeds the poor on the Abbey steps every Sunday. A living saint, that one. Sat with my mother when she died, and never asked a penny."
truth: cover
sources: [npc.bertha, npc.tigg_innkeeper]
available: "true"
on_hear: []
verified_by: "ded(ded.anselm_treason_proven)"
credibility_when: "flag(flag.bertha_safehouse) and heard_from(rumor.r04_living_saint, npc.bertha)"
```
A cover story. "Verified" here means exposed: the journal marks it as Choir cover once Anselm's treason is proven.

```yaml rumor
id: rumor.r05_dwarves_inside
text: "The dwarves didn't abandon Karak Ostrel. They locked themselves inside with whatever they made down there, and threw away the key."
truth: true
sources: [npc.bertha, npc.tigg_innkeeper, npc.dun_strept_alewife, npc.brannoc]
available: "true"
on_hear: []
verified_by: "has_clue(clue.vault_knocking) or has_clue(clue.ghost_vault_weapons) or visited(zone.ko_forge_of_echoes)"
credibility_when: "flag(flag.bertha_safehouse) and heard_from(rumor.r05_dwarves_inside, npc.bertha)"
```

```yaml rumor
id: rumor.r06_raimund_crown
text: "Duke Raimund has a gold crown already forged, waiting in his strongroom for the day Ysolde dies. Attre won't bend the knee to a boy."
truth: half
sources: [npc.bertha, npc.attre_tapster, npc.harl_brine]
available: "true"
on_hear: ["add_map_pin(map.attre)"]
verified_by: "ms(ms.a2_attre_ledger)"
credibility_when: "flag(flag.bertha_safehouse) and heard_from(rumor.r06_raimund_crown, npc.bertha)"
```
Exaggerated: there is no crown, but he does want independence.

```yaml rumor
id: rumor.r07_iron_crates
text: "The ferrymen haul heavy iron crates across the Marnadal at night. For the Abbey, they say. Crates that hum, if you put your ear to them."
truth: true
sources: [npc.bertha, npc.tigg_innkeeper]
available: "true"
on_hear: ["add_map_pin(map.ferrymen_camp)"]
verified_by: "has_clue(clue.jory_iron_crates)"
credibility_when: "flag(flag.bertha_safehouse) and heard_from(rumor.r07_iron_crates, npc.bertha)"
```

```yaml rumor
id: rumor.r08_new_moon_dead
text: "The 1263 dead still march toward Dun Strept every new moon. My uncle saw them on the Marnadal field, still in Crown blue, still in step."
truth: true
sources: [npc.tigg_innkeeper, npc.dun_strept_alewife, npc.bertha]
available: "true"
on_hear: ["add_map_pin(map.marnadal_field)"]
verified_by: "ms(ms.a2_torc_taken)"
credibility_when: "flag(flag.bertha_safehouse) and heard_from(rumor.r08_new_moon_dead, npc.bertha)"
```

```yaml rumor
id: rumor.r09_aldric_dwarven
text: "Prince Aldric mutters strange words in his sleep. Not Cintran. The nursery maid says it sounds like stones grinding. Dwarvish, the old steward reckons."
truth: true
sources: [npc.bertha]
available: "ms(ms.a1_audience_done)"
on_hear: []
verified_by: "ms(ms.act2_twist)"
credibility_when: "flag(flag.bertha_safehouse) and heard_from(rumor.r09_aldric_dwarven, npc.bertha)"
```
True: Anselm's conditioning. The twist verifies it.

```yaml rumor
id: rumor.r10_sodden_spears
text: "Sodden already has five thousand spears massed in the fens, waiting for the Queen to die. The barons on the border are packing their plate."
truth: false
sources: [npc.bertha, npc.tigg_innkeeper, npc.attre_tapster]
available: "stage() >= 1"
on_hear: []
verified_by: "flag(flag.brzezina_plot_exposed) or flag(flag.drozd_road_met)"
credibility_when: "flag(flag.bertha_safehouse) and heard_from(rumor.r10_sodden_spears, npc.bertha)"
```
False: just border scouts. Exposing the Brzezina plot, or Drozd's own word on the road (travel card L5 rival), shows the truth: Sodden waits, it does not march.

### 10.2 Side-quest rumors

```yaml rumor
id: rumor.r11_corvan_tomb
text: "Grave-robbers broke into King Corvan's barrow. Half of them came out screaming, the rest didn't come out at all. They say the old king's walking, looking for his sword."
truth: true
sources: [npc.bertha, npc.tigg_innkeeper]
available: "ms(ms.a1_audience_done)"
on_hear: ["add_map_pin(map.barrows)"]
verified_by: "visited(zone.barrows_tomb)"
credibility_when: "flag(flag.bertha_safehouse) and heard_from(rumor.r11_corvan_tomb, npc.bertha)"
```

```yaml rumor
id: rumor.r12_morrow_gull
text: "The Morrow Gull went down off the Attre reefs last spring, with an Abbey man's letters aboard. Divers won't touch her. Something big circles the wreck."
truth: true
sources: [npc.attre_tapster, npc.harl_brine, npc.bertha]
available: "ms(ms.act1_complete)"
on_hear: ["add_map_pin(map.morrow_gull)"]
verified_by: "has_item(item.taster_dispatch)"
credibility_when: "flag(flag.bertha_safehouse) and heard_from(rumor.r12_morrow_gull, npc.bertha)"
```

```yaml rumor
id: rumor.r13_skerra_fog
text: "Skerra hasn't put a boat out in months. Fog sits on the cove like a lid. They say a Skerra man took a wife out of the sea, and the sea wants her back."
truth: true
sources: [npc.attre_tapster, npc.harl_brine]
available: "ms(ms.act1_complete)"
on_hear: ["add_map_pin(map.isle_skerra)"]
verified_by: "flag(flag.selkie_freed)"
```

```yaml rumor
id: rumor.r14_mine_knocking
text: "The Strept miners by Dun Strept hear knocking under the silver seams. Regular as a heartbeat. Dwarves knocking to be let out, the old ones say."
truth: half
sources: [npc.tigg_innkeeper, npc.dun_strept_alewife, npc.brannoc]
available: "ms(ms.act1_complete)"
on_hear: ["add_map_pin(map.silver_mine)"]
verified_by: "has_clue(clue.vault_knocking)"
```
Half-true: the knocking is real, but it is Ostrel's pressure-hammers, not living dwarves.

```yaml rumor
id: rumor.r15_watch_deserted
text: "Marnadal Watch is empty. Pay stopped coming, so the whole garrison walked off. Left one squire up there with the horn and no one to blow it for."
truth: true
sources: [npc.tigg_innkeeper, npc.bertha]
available: "ms(ms.act1_complete)"
on_hear: ["set_flag(flag.marnadal_watch_hook)", "add_map_pin(map.marnadal_watch)"]
verified_by: "visited(zone.marnadal_watch_tower)"
credibility_when: "flag(flag.bertha_safehouse) and heard_from(rumor.r15_watch_deserted, npc.bertha)"
```
Also added by travel cards L4, L7 (knight yields) and the refugee column.

```yaml rumor
id: rumor.r16_scriptorium_locked
text: "The Abbot's had the scriptorium locked at night since the equinox. And that young archivist sister looks like she hasn't slept. Jumps at her own shadow."
truth: true
sources: [npc.bertha]
available: "ms(ms.a1_audience_done) and not flag(flag.maelis_ledgers_done)"
on_hear: []
verified_by: "flag(flag.maelis_ledgers_done)"
credibility_when: "flag(flag.bertha_safehouse) and heard_from(rumor.r16_scriptorium_locked, npc.bertha)"
```

```yaml rumor
id: rumor.r17_rozrog_woodwose
text: "Something in Rozrog is killing Wencel's charcoal men. Tore one's arms off and hung him in an oak. Wencel says bear. Nobody who's seen the tracks says bear."
truth: true
sources: [npc.tigg_innkeeper, npc.wencel_burner]
available: "ms(ms.act1_complete) and not flag(flag.woodwose_peace) and not flag(flag.woodwose_dead)"
on_hear: ["set_flag(flag.rozrog_hook)", "add_map_pin(map.rozrog_forest)"]
verified_by: "flag(flag.woodwose_peace) or flag(flag.woodwose_dead)"
```

```yaml rumor
id: rumor.r18_brzezina_lodge
text: "Baron Hollec's hunting at Brzezina out of season, and his guests talk like fen-folk. Since when does a Cintran baron hunt with Sodden accents?"
truth: true
sources: [npc.bertha, npc.tigg_innkeeper]
available: "ms(ms.act1_complete) and not flag(flag.brzezina_plot_exposed)"
on_hear: ["set_flag(flag.brzezina_hook)", "add_map_pin(map.brzezina_woods)"]
verified_by: "flag(flag.brzezina_plot_exposed) or flag(flag.hollec_blackmailed)"
credibility_when: "flag(flag.bertha_safehouse) and heard_from(rumor.r18_brzezina_lodge, npc.bertha)"
```

```yaml rumor
id: rumor.r19_grey_ferry
text: "The Grey Ferry takes the dead across for silver, same as the living. Pay a dead man what he's owed and he can't lie to you. That's the rule of the river."
truth: true
sources: [npc.tigg_innkeeper, npc.dun_strept_alewife]
available: "ms(ms.act1_complete)"
on_hear: ["add_map_pin(map.grey_ferry)"]
verified_by: "flag(flag.ghost_question_asked)"
```

```yaml rumor
id: rumor.r20_ravensford_singing
text: "Little Ina at Ravensford swears her drowned brother sings to her from the Assen reeds. Same song every dusk. Her mother's stopped going down to the water."
truth: true
sources: [npc.tigg_innkeeper]
available: "ms(ms.act1_complete) and not flag(flag.mirek_freed)"
on_hear: ["add_map_pin(map.ravensford)"]
verified_by: "flag(flag.mirek_freed)"
```

## 11. Failure states and branches
```yaml branches
paths:
  - id: hear
    when: "Player buys a drink from a source with an unheard, available rumor."
    outcome: "Rumor added to the journal; on_hear effects apply."
    sets: []
  - id: verify
    when: "A rumor's verified_by first becomes true."
    outcome: "Journal shows the truth tag; RumorVerified."
    sets: []
failures:
  - id: pool_empty
    result: soft_fail
    recover: "Keeper gives a bark instead ('Nothing new, love.'). No progress depends on a rumor: every pin and hook here is also reachable by travel cards, NPCs or the map."
guarantees:
  - "No act gate or required milestone depends on hearing a rumor."
```

## 12. Open questions
- **Credibility from Bertha (resolved by A08).** Every rumor Bertha can tell has `credibility_when: "flag(flag.bertha_safehouse) and heard_from(<rumor>, npc.bertha)"` (content-format §J.7). `credibility_visible` also returns true with `perk.read_the_room` or once the rumor is verified.
- **Tavern keeper ids (resolved by A08).** `npc.tigg_innkeeper` (a2.01), `npc.attre_tapster` (a2.06) and `npc.dun_strept_alewife` (a3.02) are declared once; see `docs/content/_registry.md`.
- **Rumor 3 at stage 0.** gdd §6.1 says stage 0 "adds" the wyvern rumor to the pool. I made it available from new game instead; the effect is the same.
- **Drink price.** Not set in content; the application owns it (architecture §4.17).
