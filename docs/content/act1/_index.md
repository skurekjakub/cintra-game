# Act I: Ashes in the Lion's Den (content index)

Slice owner: A04. Levels 1–4, escalation stage 0 (stage 1 from the end of the Fair). Files in play order. The gate to the Fair (section 7) is `ms.a1_audience_done` plus two of sections 3, 4 and 5, which can be played in any order. Section 6 is optional and stays open until stage 2.

| # | File | Section | Zones | Summary | Milestone |
|---|---|---|---|---|---|
| 1 | `01-drowned-rat.md` | `a1.01` | `zone.drowned_rat`, `zone.cintra_mudflats`, `zone.cintra_docks` | **Vertical slice.** A poisoned courier dies with Dravin's letter; three Choir thugs come for it. Fight (combat tutorial, Bertha's bottle), talk the fight down (Intimidate 6 / clue / Bribe 30), or flee through the cellar across the tidal mudflats (crossbowman, the Margery's ladder, Wick's safe path). Brask's summons on the docks. | `ms.a1_rat_survived` |
| 2 | `02-audience-at-court.md` | `a1.02` | `zone.cintra_streets` (hub), `zone.palace_hall` | Council in the Lion Hall: the Queen reads the letter, Varn protests, Anselm offers the library. Kosk hires Hale (writ, passes closed, the leads). Varn's bribe in the antechamber. **Aldric scene 1** in the cloister garden. Also owns the hub and palace triggers used by later sections. | `ms.a1_audience_done` |
| 3 | `03-sickroom-red-herring.md` | `a1.03` | `zone.palace_sickroom`, `zone.palace_kitchens`, `zone.chancellery_rooftops` | Pollen in the chalice; the Queen confides what the Oath protects; **Aldric scene 2** at the window. Pell's new gold in the kitchens. Night: catch Varn burning ledgers (stealth, or a rooftop chase): a thief, not a poisoner. Both Queen mitigations live here. | `ms.a1_sickroom_done` |
| 4 | `04-abbey-st-corwen.md` | `a1.04` | `zone.abbey_st_corwen` | Maelis shows the sliced Book of the Lion; Anselm writes the false fourth verse "from memory"; Maelis whispers (or leaves a note) that only Anselm holds the key. Beeswax on the bell ropes, oiled catacomb hinges, a feather in a porter's hem. Entry to A07's scriptorium quest. | `ms.a1_abbey_done` |
| 5 | `05-ring-of-nine.md` | `a1.05` | `zone.ring_of_nine` | Night at the nine stones: the split fourth-verse stone weeps alchemical tar, tar-maddened hounds (fight, lure with beef, or ring the hill with fire). The worn chiselling exposes Anselm's verse as false (`ded.anselm_lied`). | `ms.a1_ring_done` |
| 6 | `06-gull-tower.md` (optional) | `a1.06` | `zone.gull_tower`, `zone.gull_tower_cellar` | The dark watchtower: the murdered keeper, Attre smugglers, Captain Seixal in the sea-cave cellar. Grey lily bulbs branded Attre Light (+2 bulbs or burn them), the keeper's widow and the beacon. `ded.poison_via_attre`. | `ms.a1_gull_done` |
| 7 | `07-harvest-fair.md` | `a1.07` | `zone.chociebuz_fair` | Point of no return. Escort Aldric through the fair; prepare (grease casks, granary roof, unmask the Wren); the grease fire and the assassins' strike; capture or kill the Wren: pale feather and route map to Hanged Man's Oak. **Aldric scene 3** (the wooden lion, `flag.aldric_trusts_player`). | `ms.act1_complete` |
| 8 | `08-act1-transition.md` | `a1.08` | `zone.palace_hall` | Stage 1: the Kosk–Varn clash; prisoners dead in their cells; Kosk's orders south (antidote, true verse, Dravin, the Oak). **Aldric scene 4** (the tailless-lion promise). Maelis may join. `set_act(2)`, `quest.main_a2` starts, the south of the map opens. | — |

Other files:
- `_ids.md`: every id this slice defines, ids expected from other slices, and likely duplicates for the reconciliation pass.

**Prince Aldric's Act I arc** (brief requirement): four scenes (garden, sickroom window, after the Fair, farewell), tracked by `var.aldric_bond` (0–6). Bond ≥ 2 gives the wooden lion and the promise option; bond ≥ 3 sets `flag.aldric_trusts_player`.
