# A07 report: side quests, travel events, rumors

(Saved by the orchestrator from the agent's hand-back.)

## Files (`docs/content/side/`, ~76.5k words, 364 new ids; YAML parsed clean, no duplicate ids)
01 drowned-rat-debt · 02 abbey-ledgers · 03 barrows-old-kings · 04 brzezina-woods · 05 isle-of-skerra · 06 wreck-morrow-gull · 07 rozrog-forest · 08 wenna-hair · 09 marnadal-watch · 10 grey-ferry · 11 ravensford-ruins · 12 silver-mine · 13 travel-events (all 21 d8 slots 1–7 × 3 terrains, a Drozd variant, 9 `esc.*` escalation cards, 2 forced hazards) · 14 rumors (10 story + 10 side, with truth, sources, on_hear, verified_by) · `_index.md` · `_ids.md`.

New ids: 12 quests, 28 zones (6 travel arenas), 33 NPCs, 46 dialogues, 43 encounters, 21 items, 14 clues, 1 deduction, 33 event cards, 20 rumors, 113 flags/vars.

## Payoffs
Barrows → `item.mane_cleaver`; Morrow Gull → `item.taster_dispatch` → `flag.food_taster_exposed`; Skerra → `flag.skerra_cutter` + `item.serpent_lure`; Silver Mine → `flag.lower_breach_open`, +10 Strept, exit to `zone.ko_lower_halls` (Act III); Marnadal Watch → `flag.watch_signal_lit`; Abbey ledgers → `item.choir_list` → `flag.choir_list_exposed` + Maelis recruited; Rozrog → `ally.forest_guide`; Brzezina → `flag.brzezina_plot_exposed`, Drozd rival; Grey Ferry → `ded.marnadal_truth`; Ravensford → `clue.choir_secret_pass`; Wenna's hair → Queen's condition, doses, rider risk; Bertha → `flag.bertha_safehouse`.

Availability: Act I–II (closes at `ms.act2_twist`): Bertha, Abbey ledgers, Barrows. Act II: Brzezina, Skerra, Morrow Gull, Rozrog, Wenna's hair. Act II–III: Watch, Grey Ferry, Ravensford, Silver Mine.

## Format/GDD issues → for A08 reconciliation and the rules plan
1. Files use `NN-` prefixes plus the gdd slug (gdd §7.4 has no prefix).
2. **Attribute checks needed** (`check: {skill: agility|grit}`); `skill()` covers only the 4 dialogue skills.
3. gdd §6.3 DCs 5 and 7 are off the 4/6/8/10 scale (kept as written).
4. **Missing effect ops:** percent damage, take random consumable, one-journey modifier, `draw_rumor()`, clear flag on zone exit, ambush/first-strike opening, conditional encounter allies, underwater breath hazard, leave-to-map exit, **`cancel_journey()`** (used as the safe exit on forced hazards; it fails the safe-exit rule until §E has it).
5. Rumor credibility from Bertha needs a rumors-domain rule and the NPC source of each rumor.
6. `esc.*` card ids may need to become `event.esc_*`.
7. Lowlands slot 5 has two mutually exclusive cards; the first whose requirement is true wins.
8. `flag.food_taster_exposed` should be declared by A04; `ded.taster_is_bought` must also accept `has_clue(clue.taster_dispatch)`.
9. Silver Mine inner bulkhead is owned by A06.
10. Kosk's cavalry also needs Crown ≥ Friendly; A06's route should pass `map.marnadal_watch`.

## Resolved by the writer
Side quests set no milestones; Wenna's reading gives no date; beacon lighting needs `ded.reversed_oath_plan` or `ms.act2_twist`; the Choir list names Pell but does not set the taster flag; Grey Ferry always offers the Marnadal question; Drozd always escapes; Maelis can join in Act I; Mane-Cleaver armor penetration 20; consumable ids assumed (`item.poultice`, `item.field_draught`, `item.antitoxin`, `item.fire_oil`, `item.frost_tallow`, `item.smoke_pot`, `item.crossbow_bolts`).

## Hooks other slices must add
A04: Bertha → `dlg.bertha_debt_plea`, Maelis → `dlg.maelis_ledgers_offer`, Kosk → `dlg.kosk_taster_dispatch`. A05: Jory → `dlg.jory_bertha_debt`, Wenna → `dlg.wenna_hair_offer`.
