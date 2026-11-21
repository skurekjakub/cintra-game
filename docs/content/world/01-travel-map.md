---
section_id: world.travel_map
title: "The Travel Map"
act: 0                                    # not bound to an act (content-format §J.9)
story_ref: "gdd.md §6.3, §7.5; story.md §11"
zones: []
available_when: "true"
escalation_stage_required: {min: 0, max: 4}
milestones_set: []
milestones_read: []
level_band: [1, 12]
---

# The Travel Map

## 1. Summary
Every node and edge of the travel map (gdd §7.5), in the world block format of content-format §J.9. A node is a destination once its `unlock` holds; `unlock_map_node` unlocks it at once, and `add_map_pin` shows it on the parchment early. Side-quest nodes unlock when a rumor, card or dialogue pins them (`map_pinned`, §J.1), so a pin both reveals and opens them (gdd §6.3, "rumors and documents add map pins that reveal undiscovered nodes"). A route may pass through nodes that are not unlocked yet; only the destination must be.

Edges are undirected. An edge is passable while its `condition` holds. A `hazard` is a forced event card shown when the route crosses the edge and the hazard condition holds; the card's safe exit is `cancel_journey()`.

- **Mountain edges** (gdd §6.3): at stage ≥ 2, without Strept guides (`flag.strept_guides`, or this journey's `flag.journey_guides` from the Strept scouts card) and without Dravin, the route forces `event.snow_choked_pass`. The edge stays passable.
- **The Marnadal ford** (gdd §6.3): `ferrymen_camp — marnadal_field` forces `event.ford_marnadal` unless Jory granted the crossing.
- **Attre at stage 3** (gdd §6.1): the land-gate fortification is a zone event at `zone.attre_harbor` (a2.06, `dlg.attre_checkpoint`), so the Attre roads carry no hazard. The cutter's sea edge bypasses it.
- **Morrow Gull** (gdd §7.5, "the cutter or a hired boat, 60 crowns"): without the cutter, the route forces `event.hire_boat_morrow_gull` below.
- **Act III**: stage 4 (gdd §6.1) closes the Cintra hub except the palace; the map nodes stay open. `map.stairs_foot` leads into the Marnadal Stairs zones (a3.04), which are entered from the zone, not by an edge.

## 2. Map nodes
```yaml map_node
id: map.cintra
name: "Cintra"
terrain: lowlands
unlock: "true"
```

```yaml map_node
id: map.chociebuz
name: "Chociebuz Harvest Fair"
terrain: lowlands
unlock: "ms(ms.a1_audience_done) and count_ms(ms.a1_sickroom_done, ms.a1_abbey_done, ms.a1_ring_done) >= 2"
```

```yaml map_node
id: map.gull_tower
name: "Gull Tower"
terrain: lowlands
unlock: "ms(ms.a1_audience_done)"
```

```yaml map_node
id: map.barrows
name: "Barrows of the Old Kings"
terrain: lowlands
unlock: "map_pinned(map.barrows) or quest_active(quest.side_barrows) or quest_done(quest.side_barrows)"
```

```yaml map_node
id: map.brzezina_woods
name: "Brzezina Woods"
terrain: lowlands
unlock: "map_pinned(map.brzezina_woods) or quest_active(quest.side_brzezina) or quest_done(quest.side_brzezina)"
```

```yaml map_node
id: map.tigg
name: "Tigg Crossroads"
terrain: valley
unlock: "ms(ms.act1_complete)"
```

```yaml map_node
id: map.attre
name: "Attre"
terrain: lowlands
unlock: "ms(ms.act1_complete)"
```

```yaml map_node
id: map.isle_skerra
name: "Isle of Skerra"
terrain: lowlands
unlock: "ms(ms.act1_complete) and (map_pinned(map.isle_skerra) or visited(zone.attre_harbor))"
```

```yaml map_node
id: map.morrow_gull
name: "Wreck of the Morrow Gull"
terrain: lowlands
unlock: "map_pinned(map.morrow_gull) or quest_active(quest.side_morrow_gull) or quest_done(quest.side_morrow_gull)"
```

```yaml map_node
id: map.hanged_mans_oak
name: "Hanged Man's Oak"
terrain: valley
unlock: "ms(ms.act1_complete) and (has_item(item.route_map_oak) or ded(ded.choir_exists))"
```

```yaml map_node
id: map.ferrymen_camp
name: "Ferrymen's Camp"
terrain: valley
unlock: "ms(ms.act1_complete)"
```

```yaml map_node
id: map.rozrog_forest
name: "Rozrog Forest"
terrain: valley
unlock: "ms(ms.act1_complete) and map_pinned(map.rozrog_forest)"
```

```yaml map_node
id: map.marnadal_watch
name: "Marnadal Watch"
terrain: mountain
unlock: "ms(ms.act1_complete) and map_pinned(map.marnadal_watch)"
```

```yaml map_node
id: map.marnadal_field
name: "Marnadal Field"
terrain: valley
unlock: "ms(ms.act1_complete)"
```

```yaml map_node
id: map.grey_ferry
name: "Grey Ferry"
terrain: valley
unlock: "ms(ms.act1_complete) and map_pinned(map.grey_ferry)"
```

```yaml map_node
id: map.witchs_mere
name: "Witch's Mere"
terrain: valley
unlock: "ms(ms.act1_complete)"
```

```yaml map_node
id: map.vel_aram
name: "Vel Aram"
terrain: valley
unlock: "ded(ded.choir_muster_vel_aram)"
```

```yaml map_node
id: map.ravensford
name: "Ravensford Ruins"
terrain: valley
unlock: "ms(ms.act1_complete) and map_pinned(map.ravensford)"
```

```yaml map_node
id: map.assengard
name: "Assengard"
terrain: mountain
unlock: "ded(ded.anselm_treason_proven) or map_pinned(map.assengard) or act() >= 3"
```

```yaml map_node
id: map.dun_strept
name: "Dun Strept"
terrain: mountain
unlock: "map_pinned(map.dun_strept) or act() >= 3"
```

```yaml map_node
id: map.silver_mine
name: "The Silver Mine"
terrain: mountain
unlock: "ms(ms.act1_complete) and map_pinned(map.silver_mine)"
```

```yaml map_node
id: map.stairs_foot
name: "Foot of the Marnadal Stairs"
terrain: mountain
unlock: "act() >= 3"
```

## 3. Map edges
```yaml map_edge
id: edge.cintra_chociebuz
a: map.cintra
b: map.chociebuz
terrain: lowlands
kind: road
condition: "true"
hazard: null
```

```yaml map_edge
id: edge.cintra_gull_tower
a: map.cintra
b: map.gull_tower
terrain: lowlands
kind: road
condition: "ms(ms.a1_audience_done)"
hazard: null
```

```yaml map_edge
id: edge.cintra_barrows
a: map.cintra
b: map.barrows
terrain: lowlands
kind: road
condition: "true"
hazard: null
```

```yaml map_edge
id: edge.cintra_brzezina_woods
a: map.cintra
b: map.brzezina_woods
terrain: lowlands
kind: road
condition: "true"
hazard: null
```

```yaml map_edge
id: edge.cintra_tigg
a: map.cintra
b: map.tigg
terrain: lowlands
kind: road
condition: "ms(ms.act1_complete)"
hazard: null
```

```yaml map_edge
id: edge.cintra_attre
a: map.cintra
b: map.attre
terrain: lowlands
kind: road
condition: "ms(ms.act1_complete)"
hazard: null
```

```yaml map_edge
id: edge.cintra_attre_sea
a: map.cintra
b: map.attre
terrain: lowlands
kind: sea
condition: "flag(flag.skerra_cutter)"
hazard: null
```

```yaml map_edge
id: edge.attre_isle_skerra
a: map.attre
b: map.isle_skerra
terrain: lowlands
kind: sea
condition: "true"
hazard: null
```

```yaml map_edge
id: edge.attre_morrow_gull
a: map.attre
b: map.morrow_gull
terrain: lowlands
kind: sea
condition: "true"
hazard: {event: event.hire_boat_morrow_gull, condition: "not flag(flag.skerra_cutter)"}
```

```yaml map_edge
id: edge.tigg_hanged_mans_oak
a: map.tigg
b: map.hanged_mans_oak
terrain: valley
kind: road
condition: "has_item(item.route_map_oak) or ded(ded.choir_exists)"
hazard: null
```

```yaml map_edge
id: edge.tigg_ferrymen_camp
a: map.tigg
b: map.ferrymen_camp
terrain: valley
kind: road
condition: "true"
hazard: null
```

```yaml map_edge
id: edge.tigg_rozrog_forest
a: map.tigg
b: map.rozrog_forest
terrain: valley
kind: road
condition: "true"
hazard: null
```

```yaml map_edge
id: edge.tigg_marnadal_watch
a: map.tigg
b: map.marnadal_watch
terrain: valley
kind: road
condition: "true"
hazard: null
```

```yaml map_edge
id: edge.ferrymen_camp_marnadal_field
a: map.ferrymen_camp
b: map.marnadal_field
terrain: valley
kind: road
condition: "true"
hazard: {event: event.ford_marnadal, condition: "not flag(flag.jory_crossing_granted)"}
```

```yaml map_edge
id: edge.ferrymen_camp_grey_ferry
a: map.ferrymen_camp
b: map.grey_ferry
terrain: valley
kind: road
condition: "true"
hazard: null
```

```yaml map_edge
id: edge.marnadal_field_witchs_mere
a: map.marnadal_field
b: map.witchs_mere
terrain: valley
kind: road
condition: "true"
hazard: null
```

```yaml map_edge
id: edge.marnadal_field_vel_aram
a: map.marnadal_field
b: map.vel_aram
terrain: valley
kind: road
condition: "ded(ded.choir_muster_vel_aram)"
hazard: null
```

```yaml map_edge
id: edge.marnadal_field_ravensford
a: map.marnadal_field
b: map.ravensford
terrain: valley
kind: road
condition: "true"
hazard: null
```

```yaml map_edge
id: edge.hanged_mans_oak_vel_aram
a: map.hanged_mans_oak
b: map.vel_aram
terrain: valley
kind: road
condition: "ded(ded.choir_muster_vel_aram)"
hazard: null
```

```yaml map_edge
id: edge.witchs_mere_attre
a: map.witchs_mere
b: map.attre
terrain: valley
kind: road
condition: "true"
hazard: null
```

```yaml map_edge
id: edge.ferrymen_camp_attre_barge
a: map.ferrymen_camp
b: map.attre
terrain: valley
kind: barge
condition: "rep_tier(faction.ferrymen) >= allied"
hazard: null
```

```yaml map_edge
id: edge.ravensford_assengard
a: map.ravensford
b: map.assengard
terrain: valley
kind: road
condition: "true"
hazard: null
```

```yaml map_edge
id: edge.marnadal_watch_dun_strept
a: map.marnadal_watch
b: map.dun_strept
terrain: mountain
kind: road
condition: "true"
hazard: {event: event.snow_choked_pass, condition: "stage() >= 2 and not flag(flag.strept_guides) and not flag(flag.journey_guides) and not in_party(companion.dravin)"}
```

```yaml map_edge
id: edge.marnadal_watch_stairs_foot
a: map.marnadal_watch
b: map.stairs_foot
terrain: mountain
kind: road
condition: "true"
hazard: {event: event.snow_choked_pass, condition: "stage() >= 2 and not flag(flag.strept_guides) and not flag(flag.journey_guides) and not in_party(companion.dravin)"}
```

```yaml map_edge
id: edge.dun_strept_silver_mine
a: map.dun_strept
b: map.silver_mine
terrain: mountain
kind: road
condition: "true"
hazard: {event: event.snow_choked_pass, condition: "stage() >= 2 and not flag(flag.strept_guides) and not flag(flag.journey_guides) and not in_party(companion.dravin)"}
```

```yaml map_edge
id: edge.dun_strept_stairs_foot
a: map.dun_strept
b: map.stairs_foot
terrain: mountain
kind: road
condition: "true"
hazard: {event: event.snow_choked_pass, condition: "stage() >= 2 and not flag(flag.strept_guides) and not flag(flag.journey_guides) and not in_party(companion.dravin)"}
```

```yaml map_edge
id: edge.assengard_stairs_foot
a: map.assengard
b: map.stairs_foot
terrain: mountain
kind: road
condition: "true"
hazard: {event: event.snow_choked_pass, condition: "stage() >= 2 and not flag(flag.strept_guides) and not flag(flag.journey_guides) and not in_party(companion.dravin)"}
```

## 4. Forced hazard cards
`event.ford_marnadal` and `event.snow_choked_pass` are in `side/13-travel-events.md`. The boat to the Morrow Gull is here.

```yaml event_card
id: event.hire_boat_morrow_gull
terrain: none
table_slot: null
requires: "not flag(flag.skerra_cutter)"
title: "A boat to the Teeth"
text: "No cutter of your own. A harbour skipper will row you out to the Teeth reef and wait, for sixty crowns and not a copper less."
options:
  - {id: hire, text: "Hire the boat. [Bribe 60]", tag: bribe, bribe: 60, next: null}
  - {id: turn_back, text: "Keep your coin and stay ashore.", effects: ["cancel_journey()"], next: null}
combat: null
```

## 5. Open questions
- The `attre — isle_skerra` and `attre — morrow_gull` edges are marked `sea` (gdd §7.5 writes them as roads); travel by sea counts as lowlands (gdd §6.3).
- Whether valley nodes stay open in Act III is not specified by the gdd (A05). They stay open here; stage 4 only changes the encounter tables to mountain ones (gdd §6.1).
