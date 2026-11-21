# Act II: The Marnadal Road (index)

Slice owner: A05. Levels 5–8. An open sandbox: sections 01–07 can be played in any order once `ms.act1_complete` is reached (Hanged Man's Oak also needs the route map or `ded.choir_exists`; Vel Aram needs `ded.choir_muster_vel_aram`). Section 08 opens when the Act II gate is met.

**Act II gate (gdd §7.2):** `ms.a2_wenna_line_resolved` and `ded.anselm_treason_proven` and `has_item(item.true_fourth_verse)`.
**Escalation:** stage 1 on entry; stage 2 after 3 of the 7 Act II milestones; stage 3 after 5 or when the gate is met; stage 4 at `ms.act2_twist`. Every section has stage variants.

## Files in suggested play order

| # | File | Section | One-line summary |
|---|---|---|---|
| 1 | `01-tigg-crossroads.md` | a2.01 | Save a halfwit from a lynch mob, find the Choir's stolen wyvern eggs in the evidence, and turn the wyvern away from Tigg by tar-smoke or by a drive-off boss fight. Holds the master stage of `quest.main_a2`. |
| 2 | `03-ferrymen-camp.md` | a2.03 | Bribe, frighten, reason with, work for (drowners at the weirs) or overthrow Ninefingers Jory for the truth about the Abbey's humming iron crates and the river crossing. |
| 3 | `02-hanged-mans-oak.md` | a2.02 | Ambush, turn or fool a frightened novice courier at the Choir's gallows-oak dead-drop for Anselm's cipher; optionally forge a dispatch that strips guards from Vel Aram. |
| 4 | `04-marnadal-field.md` | a2.04 | Keep vigil on the 1263 battlefield; stand the revenant charge beside the champion of Darrach Hall or speak the clans' naming rite, and carry his torc home; learn who carried the parley that started the massacre. |
| 5 | `05-witchs-mere.md` | a2.05 | Win over Old Wenna, return her stolen grey lily bulbs, and choose the fate of each counter-dose: fast rider, carry it, Maelis, or Raimund. |
| 6 | `06-attre.md` | a2.06 | The masquerade and Warehouse Nine: steal Raimund's ledger, overhear the Choir buy, save or lose the last bulbs, and blackmail, ally with, or sell a cure to a duke whose son is dying of his own lily. |
| 7 | `07-vel-aram.md` | a2.07 | Full dungeon: the Choir's muster and sanctum, Anselm's journal, the wyvern eggs, the chained soot-hound and the reliquary holding the true fourth verse; a drowned postern as the secret way in. |
| 8 | `08-return-and-twist.md` | a2.08 | Return to Cintra: the antidote resolves, Aldric is invested (or crowned over his mother's body), and in the night he and Anselm vanish; chase through the catacombs to an empty river and a tailless lion scratched beside the word OSTREL. |
| — | `_ids.md` | — | Every id this slice defines, the spawns other slices exit into, and the ids expected from other slices. |

## How the gate is always reachable (no soft-locks)

- **Antidote line:** Wenna resolves it with any number of bulbs, or with none (the "nothing left" option is shown whenever brewing is impossible). A failed line leads to the Boy King ending, never a dead end.
- **Proof:** the journal at Vel Aram alone proves treason (check-free route: the Prior's key, or the cell-key hook, plus "smash the box"). The cipher plus Raimund's ledger is the alternative.
- **True verse:** Vel Aram only. The node unlocks from `clue.jory_iron_crates` (a2.03, check-free by the weir job or by storming the camp) or `clue.anselm_cipher` (a2.02 or a2.03). The reliquary is reachable by fighting the soot-hound without any check.

## Antidote outcomes (gdd §6.2), where they happen

| Outcome | Where | Flags |
|---|---|---|
| Fast rider | a2.05 `dlg.wenna_doses` (40 crowns, or Jory's escort if Ferrymen ≥ Friendly) | `flag.antidote_rider_sent`, `flag.rider_escort_hired`, system sets `flag.antidote_administered` or `flag.antidote_rider_intercepted` |
| Carry | a2.05; administered automatically in a2.08 or by hand at the sickroom | `item.wenna_antidote`, `flag.antidote_administered` |
| Maelis | a2.05 (if `flag.maelis_poisoned` and she is in the party) | `flag.antidote_given_maelis` |
| Sell to Raimund | a2.06 terrace | `flag.antidote_sold_raimund`, `flag.aimeric_saved` |
| Bulbs burned | a2.06 loud warehouse raid; a2.05 "nothing left" | `flag.crate_east_burned`, `flag.crate_west_burned`, `flag.wenna_line_failed` |

## XP estimate (for the budget test, gdd §6.8)

A full clear of this slice gives roughly 6,500–7,500 XP: objective XP 3,550 (`quest.main_a2` orders 10–30), 22 clues × 30, 4 deductions × 90, 13 first visits × 30, about 15 passed checks × 30, and about 2,000 from enemies (wyvern 400, soot-hound 600). The gate-only path (Wenna, Vel Aram, the twist) gives roughly 2,800. Acts I+II need at least 5,250 in total, so the budget is met with margin. A completionist may enter Act III at level 9–10.
