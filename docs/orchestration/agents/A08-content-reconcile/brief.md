# Brief A08 — Content reconciliation + format addendum

## Goal
Make the four content slices (`docs/content/act1|act2|act3|side/`) one consistent body of content, and extend the content format so everything the writers needed has a defined shape. After you finish, the future markdown→JSON converter and the content validation tests can process every file without special cases.

## Read first
- `docs/design/content-format.md` (whole), `docs/design/gdd.md` (§6, §7), `CLAUDE.md`.
- The four writer reports, which list every issue: `docs/orchestration/agents/A04-content-act1/report.md`, `A05-content-act2/report.md`, `A06-content-act3/report.md`, `A07-content-side/report.md`.
- Each slice's `_ids.md` and `_index.md`.
- A04's validator: `C:\Users\skure\AppData\Local\Temp\claude\f82cef077b1ec211\fe7622d7-f626-4cfc-b340-9272070adc79\scratchpad\a04\val.py` (Python, PyYAML). Copy it to your own scratchpad subfolder `a08/` and extend it to run across all slices at once (cross-slice id resolution). Run Python with `-I`.

## Orchestrator rulings (binding; apply them)
1. **Kosk badge:** −2 to checks against Strept speakers, as in gdd §6.10. Fix §6.9's −20. Add the condition call `equipped(item_id)`. Content that needs "badge worn" uses `equipped(item.kosk_badge)`; drop `flag.kosk_badge_worn`.
2. **DC scale:** any integer 4–10 is allowed. Update content-format §I and the checklist. Keep the gdd's 5s and 7s.
3. **Act transitions:** the section that ends an act owns `set_act(N+1)` and `start_quest(quest.main_aN+1)`. a1.08 owns act 2; a2.08 owns act 3. Remove the fallback from act3/01.
4. **Bolts:** the canonical id is `item.crossbow_bolt`. Replace `item.crossbow_bolts` everywhere.
5. **Forest guide:** `ally.forest_guide`. Fix gdd §6.3.
6. **New id kind** `epilogue`. Add the suspect id `vandals` to F.6.
7. **The a2.08 → act1 sickroom patch:** apply it into act1's `03-sickroom-red-herring.md` zone block (the spawn, interactable, trigger, beats, variant and exit), then remove the patch text from a2.08, leaving a pointer.
8. **A07's mine exit** into `zone.ko_lower_halls/mine_breach` requires `act() == 3`.
9. **Escalation-card ids:** keep `esc.*` only if `esc` is added as an id kind; otherwise rename to `event.esc_*`. Prefer the rename; it needs no new kind.
10. **Undeclared or assumed ids** (`npc.ysolde`, `clue.marnadal_chaplain`, the consumables A07 assumed, the tavern keepers, `flag.varn_exposed`, `flag.maelis_recruited`, `flag.maelis_dead`, and so on): declare each exactly once, in the slice that first sets or introduces it, and fix references to match.

## Format addendum
Write `docs/design/content-format.md` §J "Addendum 1". Consolidate every missing construct from the four reports into defined syntax:
- **Condition calls:** `equipped`, an attribute-check form, and anything else needed.
- **Effect ops:** `cancel_journey`, `draw_rumor`, `end_encounter`, percent damage, take random consumable, a one-journey modifier, clear a flag on zone exit, force boss flee, `set_finale_record` (or confirm the `play_beat` contract), consumable effects (antitoxin, fire oil, smoke pot, frost tallow), and the rest.
- **Triggers:** a combat-event trigger, a stealth alarm, hazards switched on by an event.
- **Encounter fields:** ambush/first strike, conditional allies, posture/patrol lists, target priority, "downed" non-yielding enemies, escort-death game over, variants by escalation stage.
- **Zone fields:** exit-to-map, per-zone NPC dialogue override, underwater breath hazard, the chase spec.
- **Other:** XP on milestones, `participants: []` allowed, a trinket stat block, and the `epilogue` block schema (start from A06's proposal).

Keep each addition minimal and consistent with the existing grammar. Then update the content to use the new syntax wherever a writer used a workaround: free-form params, prose patrols, `map_board` stand-ins, `has_item(item.choir_robe)` used for "disguised", and so on.

Also list, in §J.x "For the converter", the YAML pitfalls: YAML 1.1 booleans (`on:`, `yes`/`no`). State that the converter must treat the documents with YAML 1.2 core-schema semantics, and recommend quoting `"on"` keys in content anyway. Then quote them in all content files.

## Registry
Write `docs/content/_registry.md`: one merged table of every id across all slices (id, kind, declared in file, used in files). Generate it with your script, not by hand. Delete the four per-slice `_ids.md` files once everything they listed is resolved; keep each `_index.md`.

## Balance note
The writers report XP far above the gdd curve: Act I full clear ~3,000; Act II full clear ~7,000. Do not rebalance now. Add a "Balance notes" section to `docs/content/_registry.md` listing the XP totals per slice (computed by your script) against the gdd §6.8 level table and the intended act-end levels (Act I end ≈ 4, Act II end ≈ 8, Act III end ≈ 12).

## Rules
- Edit only `docs/content/**`, `docs/design/content-format.md` and the specific gdd lines named in the rulings. Do not touch `game/`, `docs/superpowers/`, or `docs/art-direction/`.
- Do not commit. If a write is blocked, describe it in your final message.
- Final message (your report, since you cannot write report files), under 40 lines: what changed per slice, the addendum's list of additions, the final validator result (errors = 0 across all slices, cross-slice ids resolved), and anything you could not resolve.
