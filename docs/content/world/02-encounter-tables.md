---
section_id: world.encounter_tables
title: "Travel Encounter Tables"
act: 0                                    # not bound to an act (content-format §J.9)
story_ref: "gdd.md §6.3; story.md §11"
zones: []
available_when: "true"
escalation_stage_required: {min: 0, max: 4}
milestones_set: []
milestones_read: []
level_band: [1, 12]
---

# Travel Encounter Tables

## 1. Summary
The three terrain tables of gdd §6.3, in the `encounter_table` format of content-format §J.9. Every entry runs an event card from `side/13-travel-events.md`; the cards hold the choices, checks and fights.

- **d8.** Slots 1–7 are the story's table rows. Slot 8 is the story's escalation row (the withered line, the black river, the blue fires), which is also the first entry of the terrain's pool.
- **Escalation rule** (gdd §6.3): at stage ≥ 2, if the result is not already a pool entry, a d6 of 1–2 replaces it with a random pool entry.
- **Drowner weight at stage 2** (gdd §6.1, "drowner encounters ×2 weight on valley tables"): from stage 2, valley slot 4 rolls the drowner shallows (`alt`), so the drowners occupy two of the eight slots.
- **Recurring rival** (side 04): once `flag.drozd_rival` is set, lowlands slot 5 rolls Drozd's carriage instead of the tinker, until she has been met on the road.
- **Rerolls** (gdd §6.3): an entry whose `requires` is false, or the same card as the previous journey, is rerolled up to three times; then the road is quiet. Each entry copies its card's `requires`.
- Stage 4 uses the mountain table only (gdd §6.1). Stage 3 adds one member to Choir groups (system rule).

## 2. Tables
```yaml encounter_table
terrain: lowlands
entries:
  - {slot: 1, kind: event_card, ref: event.l1_tax_collectors, requires: "true", alt: null}
  - {slot: 2, kind: event_card, ref: event.l2_pilgrims_feather, requires: "not flag(flag.pilgrim_spy_exposed)", alt: null}
  - {slot: 3, kind: event_card, ref: event.l3_lily_wagon, requires: "ms(ms.a1_audience_done) and not flag(flag.lily_wagon_searched)", alt: null}
  - {slot: 4, kind: event_card, ref: event.l4_watch_deserter, requires: "true", alt: null}
  - {slot: 5, kind: event_card, ref: event.l5_sodden_tinker, requires: "not flag(flag.drozd_rival)", alt: {when: "flag(flag.drozd_rival) and not flag(flag.drozd_road_met)", kind: event_card, ref: event.l5_drozd_returns}}
  - {slot: 6, kind: event_card, ref: event.l6_harvest_supper, requires: "true", alt: null}
  - {slot: 7, kind: event_card, ref: event.l7_disgraced_knight, requires: "true", alt: null}
  - {slot: 8, kind: event_card, ref: event.esc_l_withered_line, requires: "true", alt: null}
escalation_pool:
  - {id: esc.l_withered_line, kind: event_card, ref: event.esc_l_withered_line, requires: "true"}
  - {id: esc.l_feather_proclamations, kind: event_card, ref: event.esc_l_feather_proclamations, requires: "stage() >= 2"}
  - {id: esc.l_refugee_column, kind: event_card, ref: event.esc_l_refugee_column, requires: "stage() >= 2"}
```

```yaml encounter_table
terrain: valley
entries:
  - {slot: 1, kind: event_card, ref: event.v1_ferry_toll, requires: "true", alt: null}
  - {slot: 2, kind: event_card, ref: event.v2_revenant_patrol, requires: "true", alt: null}
  - {slot: 3, kind: event_card, ref: event.v3_starving_wolves, requires: "true", alt: null}
  - {slot: 4, kind: discovery, ref: event.v4_charcoal_burners, requires: "true", alt: {when: "stage() >= 2", kind: event_card, ref: event.v5_drowner_shallows}}
  - {slot: 5, kind: event_card, ref: event.v5_drowner_shallows, requires: "true", alt: null}
  - {slot: 6, kind: discovery, ref: event.v6_wenna_crow, requires: "true", alt: null}
  - {slot: 7, kind: discovery, ref: event.v7_woodwose_totems, requires: "not flag(flag.woodwose_peace) and not flag(flag.woodwose_dead)", alt: null}
  - {slot: 8, kind: event_card, ref: event.esc_v_black_river, requires: "true", alt: null}
escalation_pool:
  - {id: esc.v_black_river, kind: event_card, ref: event.esc_v_black_river, requires: "true"}
  - {id: esc.v_drowner_swarm, kind: event_card, ref: event.esc_v_drowner_swarm, requires: "stage() >= 2"}
  - {id: esc.v_blight_wagon, kind: event_card, ref: event.esc_v_blight_wagon, requires: "stage() >= 2"}
```

```yaml encounter_table
terrain: mountain
entries:
  - {slot: 1, kind: hazard, ref: event.m1_rockslide, requires: "true", alt: null}
  - {slot: 2, kind: event_card, ref: event.m2_strept_scouts, requires: "true", alt: null}
  - {slot: 3, kind: event_card, ref: event.m3_frost_troll, requires: "true", alt: null}
  - {slot: 4, kind: event_card, ref: event.m4_wyvern_circling, requires: "not flag(flag.roost_resolved)", alt: null}
  - {slot: 5, kind: discovery, ref: event.m5_dwarven_ghost, requires: "not flag(flag.cairn_cache_taken)", alt: null}
  - {slot: 6, kind: event_card, ref: event.m6_choir_rearguard, requires: "ms(ms.act1_complete)", alt: null}
  - {slot: 7, kind: discovery, ref: event.m7_oath_shrine, requires: "not flag(flag.shrine_oath_found)", alt: null}
  - {slot: 8, kind: event_card, ref: event.esc_m_blue_fires, requires: "true", alt: null}
escalation_pool:
  - {id: esc.m_blue_fires, kind: event_card, ref: event.esc_m_blue_fires, requires: "true"}
  - {id: esc.m_tremor, kind: hazard, ref: event.esc_m_tremor, requires: "true"}
  - {id: esc.m_stray_warden, kind: event_card, ref: event.esc_m_stray_warden, requires: "stage() >= 4"}
```

## 3. Open questions
- gdd §6.3 says a d8 of 8 draws from the escalation pool. The table format holds one entry per slot, so slot 8 is the story's own escalation row; the escalation rule still draws from the whole pool.
- Several gdd "combat" rows (revenant patrol, wolves, drowners, frost troll, Choir rear-guard) are event cards that offer a way round the fight (A07), so their kind is `event_card`.
