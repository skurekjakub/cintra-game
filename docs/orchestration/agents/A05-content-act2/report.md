# A05 report: Act II "The Marnadal Road"

(Saved by the orchestrator from the agent's hand-back.)

## Files (`docs/content/act2/`, ~49k words in sections, ~307 new ids; the agent's checklist script passes except for one intentional item)
01 tigg-crossroads (wyvern; master stage of `quest.main_a2`: 3 gate objectives + 7 optional leads) · 02 hanged-mans-oak (cipher, forged dispatch; `ded.choir_muster_vel_aram`) · 03 ferrymen-camp (Jory) · 04 marnadal-field (revenants; Callum Darrach's torc; rite words match act3) · 05 witchs-mere (Wenna, bulbs, every antidote outcome) · 06 attre (harbour hub, masquerade, Warehouse Nine, ledger, Raimund, heir Aimeric dying of lily dust) · 07 vel-aram (24 areas, patrols, traps, soot-hound, secret drowned passage → warden's maul; `ded.anselm_treason_proven`) · 08 return-and-twist (investiture, abduction, catacombs; **includes a text patch that act1's `zone.palace_sickroom` must absorb**: a spawn, an interactable, a trigger, 4 beats, a variant, an exit) · `_index.md` · `_ids.md`.

Cross-slice: side hooks wired (`dlg.jory_bertha_debt`, `dlg.wenna_hair_offer`, scrying hollow exits, rumor sources, side rumors verified); act1 catacomb spawns and Aldric flags read (tailless lion beside "OSTREL"); act1's `item.crossbow_bolt` used; act3 names and flags matched. Renames to avoid clashes: Bollard, Marit, Ned, Godric, Pim Reedy, Brother Cellarer Aumery, the crow Gallows.

## Writer rulings
- Warehouse: 2 crates × 2 bulbs; an alarm with foreman Gaspard free and no release writ burns the unlooted crates.
- Wenna rep: truth +5, freed crow +10, +2 per bulb, lie −10, theft −30. Friendly = 2 doses. The player chooses each dose's fate; only one rider; a carried dose goes to the Queen automatically at the twist.
- Courier escape fallback: Jory robs the courier; the cipher can be bought for 120 crowns or taken by storming the camp.
- Forged dispatch removes Vel Aram patrols A and B. New moon = a camp vigil choice (`flag.new_moon_vigil`).
- Added `ms.a2_return_cintra` (doesn't count toward Act II progress), which fires on Kosk's first line so the investiture precedes the abduction.
- `flag.rider_escort_hired` defined; sending the rider uses up a dose.
- `var.bulbs_recovered` = bulbs actually handed over, capped at 6 (sources total 7).
- Marnadal Field stays reachable at stage 4.
- XP: full clear ~6,500–7,500, gate-only ~2,800 (a completionist may enter Act III at level 9–10 → balancing pass).

## Issues → A08
1. Kosk badge −20 vs −2; this slice also needs `flag.kosk_badge_worn` maintained by inventory.
2. Twist timing vs gdd §6.2 (resolved with `ms.a2_return_cintra`).
3. `set_act(3)`: done here at the catacomb sluice, and also as a fallback in act3/01. Keep one owner.
4. Bulb counting (side/08's hair reading can undercount by 2).
5. Content-format gaps: a stealth-alarm trigger (used `on: beat_done, source: alarm`), encounter posture/patrol fields, a force-boss-flee effect, XP on milestones, `participants: []` allowed, a trinket stat block, the frost-tallow op.
6. No guard archetype in §6.7: Attre guards use `enemy.bandit` variants; new `choir_thug`/`choir_zealot` variants listed in `_ids.md`.
7. The a2.08 → act1 sickroom patch must be applied.
8. Whether valley map nodes stay open in Act III is unspecified.
