# A04 report: Act I content

(Saved by the orchestrator from the agent's hand-back.)

## Files (`docs/content/act1/`, ~55.9k words, 270 new ids; the agent's validator reports no errors)
- **01-drowned-rat** (~10.6k): the vertical slice. 3 zones with ASCII maps; courier death; thug standoff (Intimidate 6 / clue-backed Persuade 4 / Bribe 30 each remove a thug → `var.rat_thugs_left` 3/2/1 picks the encounter); taproom fight (Bertha's bottle) and a yield dialogue; mudflats escape (4 checkpoints, rising tide, a quay crossbowman, a cuttable ladder, Wick's safe path); Brask on the docks; slice end card. Tutorial beats are built into the scene. Starting gear: `item.arming_sword`, `gambeson`, `crossbow`, `crossbow_bolt`, `poultice`.
- **02-audience-at-court** (~8.9k): hub `zone.cintra_streets`, palace hall, Kosk's hire, Varn's bribe, Anselm's offer, Aldric scene 1, shop; quests `audience` and `follow_the_leads`; the hub triggers later sections use.
- **03-sickroom-red-herring** (~9.3k): chalice pollen, both of the Queen's mitigations, her confide scene (varies with `queen()`), Aldric scene 2, 5 ways to expose Pell, the Varn chase (red-handed / roof chase / bribed driver; losing it is a soft fail).
- **04-abbey-st-corwen** (~6.5k): sliced Book, false verse "Till crown and key restore the light.", Maelis's whisper or her satchel note (the milestone is always reachable).
- **05-ring-of-nine** (~4.6k): tar stone ("...NETEEN WIN..."), hounds (fight, lure, fire, or lure + fire), `ded.anselm_lied`.
- **06-gull-tower** (~5k, optional): keeper's murder, Seixal's parley, take or burn the bulbs, `ded.poison_via_attre`.
- **07-harvest-fair** (~6.2k): point of no return; 3 escort-fight variants by preparation; capture or kill the Wren; Aldric scene 3 (wooden lion, `flag.aldric_trusts_player`).
- **08-act1-transition** (~3.2k): Kosk–Varn clash; prisoners found dead (Pell hanged, the Wren's poison tooth); Aldric scene 4 (tailless-lion promise); Maelis may join; `set_act(2)`, `start_quest(quest.main_a2)`, map unlocks (tigg, attre, ferrymen_camp; witchs_mere and hanged_mans_oak pinned; A05 to confirm).
- Aldric's arc: `var.aldric_bond` 0–6; at ≥2 `item.aldric_lion` and the promise; at ≥3 trust.
- A07 hooks wired: rat exits, abbey scriptorium exit, `dlg.maelis_ledgers_offer`, `item.ysolde_hair`, `flag.food_taster_exposed`, `ded.taster_is_bought` (accepts `clue.taster_dispatch`), `item.kosk_writ`.

## Issues → A08 reconciliation / format addendum
1. **YAML 1.1 booleans:** `on:` and ids `yes`/`no` parse as booleans in PyYAML. The converter must use YAML 1.2 semantics or map `True` back to `on`.
2. **Missing hooks:** a combat-event trigger; hazards switched on by an event (used `starts_on_beat`, `floods_after_checkpoint`); `end_encounter`; per-zone NPC dialogue; XP on milestones; consumable effects (antitoxin, fire oil, smoke pot); `draw_rumor`; game over when an escort dies; a "downed" state for an enemy that can't yield; target priority; stealth patrol lists; chase rules (specified in level terms in 03); encounters that vary by escalation stage.
3. DC 5 (Presence 5 for the hair) is off the scale; kept.
4. Extra section `a1.08` (gdd §7.1 lists 7 files); the only place `set_act` is called.
5. **XP budget:** the required path gives ~1,800 XP (≥1,350 OK); a full clear gives ~3,000+, which can reach level 5 before Act II. May need trimming.
6. Suspect id `vandals` is in gdd §6.11 but not in content-format F.6.
7. The passes are already snowed in during Act I (kept, via Kosk).
8. A same-zone `goto_zone` is used as a scene cut; needs confirming.

## Notes
The scratchpad is shared between agents; A04's validator is at `scratchpad/a04/val.py` (Python, YAML parse + graph checks). Reuse it for A08.
