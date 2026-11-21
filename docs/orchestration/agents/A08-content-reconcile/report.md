# A08 report: content reconciliation + format Addendum 1

(Saved by the orchestrator from the agent's hand-back.)

**Validator** (`scratchpad/a08/val.py`, cross-slice): 40 section files, 913 blocks, 1,357 declared ids, **0 errors**. It checks:
- YAML 1.2 booleans (and fails on any block that would load differently under 1.1);
- the §C/§J grammar and the §E/§J ops with their argument kinds;
- every id resolves and none is declared twice;
- zone, dialogue, encounter, table and epilogue structure;
- DCs are integers 4–10;
- one owner per `set_act`.

The registry generator is `registry.py`.

## Rulings 1–10 applied
1. `item.kosk_badge` trinket (a1.02): +2 with Crown officials, −2 with Strept; content uses `equipped(item.kosk_badge)`; gdd §6.9 fixed to −2.
2. DC 4–10.
3. a1.08 owns act 2, a2.08 owns act 3; the act3/01 fallbacks were removed.
4. Bolts are `item.crossbow_bolt`.
5. gdd uses `ally.forest_guide`.
6. `epilogue` kind and `vandals` suspect added.
7. The sickroom patch is merged into act1/03.
8. The mine exit requires `act() == 3`; the `from_ostrel` spawn was added.
9. `esc.*` → `event.esc_*`.
10. `flag.maelis_recruited` (a1.08), `flag.maelis_poisoned` (a2.05), `flag.maelis_dead` (a2.08); `var.bulbs_recovered` moved to a1.06 (+2 for the Gull bulbs).

## Content changes
- Quoted `"on":` keys.
- 23 `to_map` exits.
- About 30 hazards on `enabled_by`/`disabled_by`/`active_when`/`on_tripped`, plus an underwater zone for Morrow Gull.
- `"on": alarm` triggers with `raise_alarm()`.
- Encounters: postures, patrols, escorts, target priority, a downed Wren, the Drozd spawn and escape, conditional allies, stage variants, `on_executed`, openings.
- Tutorial `combat_event` triggers.
- Varn chase block and a Queen dialogue override.
- `equipped(item.choir_robe)` and `disguised()`.
- `finale_event(...)` ops.
- 61 `yaml epilogue` blocks.
- Milestone `xp` on 15 milestones.
- Consumable, trinket and fur stat blocks.
- Travel-card ops.
- `credibility_when` on Bertha's rumors.
- Hooks wired: `dlg.kosk_taster_dispatch`, `dlg.bertha_debt_plea`, the a3 war-room overrides, the a3.07 aftermath trigger and the Command the Vault interactable.

## Addendum §J
- **J.1 conditions:** `equipped`, `disguised`, `heard_from`, `map_unlocked`, `map_pinned`, attribute checks.
- **J.2 effects:** `start_encounter(enc, opening)`, `end_encounter`, `force_flee`, `damage_player_pct`, `take_random_consumable`, `set_flag_until`, `draw_rumor`, `cancel_journey`, `raise_alarm`, `finale_event`, `cure_status`, `status_immunity`, `imbue_weapon`, `chill_rate_mod`, `break_enemy_sight`.
- **J.3 triggers:** `combat_event`, `alarm`, `checkpoint`; hazard activation fields; the `tar` hazard; `activate_by: shot`.
- **J.4 encounter fields.**
- **J.5 zone fields:** `to_map`, npc override, `underwater`, `chases`.
- **J.6 item mods.**
- **J.7:** milestone xp, credibility, the epilogue schema.
- **J.8:** YAML 1.2.
- **J.9:** `map_node`, `map_edge`, `encounter_table`.
- §H covers the new block types.

## World files (scope addition)
- `docs/content/world/01-travel-map.md`: 22 nodes, 27 edges, forced hazards, a hired-boat card.
- `docs/content/world/02-encounter-tables.md`: 3 tables × 8 slots plus 3-entry pools. The drowner ×2 rule is valley slot 4's `alt`; Drozd is lowlands slot 5's `alt`.

## Registry and balance
`docs/content/_registry.md`: 1,342 ids. The `_ids.md` files were deleted.

Full-clear XP upper bounds:

| Slice | XP | Reaches level | Intended |
|---|---|---|---|
| Act I | 4,175 | 7 | ≈4 |
| Act II | 10,680 (14,855 cumulative) | 12 | ≈8 |
| Act III | 14,654 | — | ≈12 |
| Side | 16,310 | — | — |

All content totals 45,819 XP against a 13,283 budget, so a **rebalance is needed**.

## Open
- gdd §6.10 still mentions `kosk_badge_worn`.
- The +2 officials bonus on the badge is the agent's reading.
- Epilogue titles are derived from slugs.
- Slot 8 vs the gdd's pool rule.
- Design TODOs: the Kosk a3.01 dialogue chain, the lily-wagon bulb (side/13 L3), a Gull Tower stage variant, a Brzezina repeat alarm, a troll patrol sighting, a check-free route to the Queen's hair.
