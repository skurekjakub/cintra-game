# World data: index

Slice: `docs/content/world/` (A08). Data that belongs to no story section: the travel map and the encounter tables. Both use the world blocks of content-format §J.9 (`act: 0`).

| # | File | section_id | Blocks | Summary |
|---|---|---|---|---|
| 1 | `01-travel-map.md` | `world.travel_map` | 22 `map_node`, 27 `map_edge`, 1 `event_card` | Every node and edge of gdd §7.5 with unlock and passability conditions, the forced hazards (Marnadal ford, snow-choked passes, the hired boat to the Morrow Gull) |
| 2 | `02-encounter-tables.md` | `world.encounter_tables` | 3 `encounter_table` | The d8 tables for lowlands, valley and mountain, the escalation pools (`esc.*` → `event.esc_*`), the stage-2 drowner weight and the Drozd slot |

The event cards the tables roll are in `side/13-travel-events.md`. Ids: see `../_registry.md`.
