# Act III slice: ids

Slice: `docs/content/act3/` (A06). The first table lists new ids that other slices may reference. Local ids (dialogue nodes, areas, spawns, beats, checkpoints, option ids) are not listed. Ids named in `gdd.md` are marked (gdd) when this slice is the first to declare them.

## New ids defined in this slice

### Milestones

| id | kind | defined in | meaning |
|---|---|---|---|
| `ms.a3_departed` | milestone | 01 | Left the war room with the Lion's Crown; Act III road open |
| `ms.a3_strept_resolved` | milestone | 02 | Hesk gave his Act III answer (refuse, guides, or war-band) |
| `ms.a3_dravin_joined` | milestone | 03 | Dravin joined with the Iron-Key (Act II or III; not an Act II progress milestone) |
| `ms.a3_stairs_crossed` | milestone | 04 | Reached the upper ridge above the Marnadal Stairs |
| `ms.a3_roost_resolved` | milestone | 05 | Crossed the chasm past Wyvern's Roost |
| `ms.a3_ostrel_entered` | milestone | 06 | Entered Karak Ostrel (Weeping Gate or Lower Halls breach) |
| `ms.a3_lock_reached` | milestone | 06 | Reached the Hall of Mirrors before the Lock Chamber |
| `ms.a3_finale_done` | milestone | 07 | Finale resolved (any outcome) |
| `ms.game_complete` | milestone | 08 | Closing scene finished; epilogue plays |

### Flags and vars other slices or the epilogue may read

| id | kind | defined in | meaning |
|---|---|---|---|
| `flag.strept_guides` | flag (gdd) | 02 | Strept guides: Stairs ledge bypass, mountain-edge hazards waived. Read by A07 card M2 |
| `flag.hesk_torc_given` | flag | 02 | Darrach torc returned to Hesk |
| `flag.hesk_apology_given` | flag | 02 | Kosk's apology delivered to Hesk (epilogue v240) |
| `flag.hesk_bloodprice_paid` | flag | 02 | Player paid Hesk the blood-price personally |
| `flag.hesk_warband_given` | flag | 02 | Hesk committed the war-band (`ally.strept_warband` added) |
| `flag.strept_refused` | flag | 02 | Hesk's latest Act III answer was a refusal |
| `flag.strept_stone_defended` / `flag.standing_stone_broken` | flag | 02 | The standing stone's fate |
| `flag.dravin_recruited` | flag | 03 | Dravin has joined (true even when Maelis holds the companion slot). Finale brake station and Command the Vault |
| `flag.dravin_confessed` | flag | 03 | Dravin admitted forging the counter-gear |
| `flag.a3_route_direct` | flag | 01 | Player told Kosk they would go straight up the Stairs |
| `flag.a3_backed_varn` / `flag.a3_warned_kosk_of_varn` / `flag.a3_regency_council` | flag | 01 | Regency advice (epilogue court variants) |
| `flag.stairs_rearguard_resolved` (+ `_killed`, `_climbed`, `_deserted`, `_shaken`) | flag | 04 | The Stairs barricade outcome |
| `flag.tobiasz_freed` / `flag.tobiasz_left` | flag | 04 | The servant who led Aldric out (epilogue v695) |
| `flag.troll_a_*`, `flag.troll_b_*`, `var.ice_fire_pots` | flag/var | 04 | Ice Bridges troll outcomes (local) |
| `flag.roost_resolved` | flag | 05 | Roost resolved. **Read by A07 travel card M4** (wyvern circling) |
| `flag.wyvern_eggs_returned` / `flag.wyvern_slain` | flag | 05 | The wyvern's fate (epilogue v650/v655) |
| `flag.udo_*` | flag | 05 | Brother Udo's fate (local) |
| `flag.ko_*`, `var.ko_*` | flag/var | 06 | Karak Ostrel puzzle and encounter state (local; 35 ids, see 06 §8) |
| `flag.aldric_coerced` | flag (gdd) | 07 | Aldric intimidated into commanding the vault |
| `flag.anselm_wavered` / `flag.anselm_rattled` | flag | 07 | Pre-fight dialogue outcomes (epilogue v665) |
| `flag.finale_begun` | flag | 07 | Confrontation started |

### Zones

| id | kind | defined in | meaning |
|---|---|---|---|
| `zone.palace_war_room` | zone | 01 | Kosk's map room, Act III (spawns `war_room_door`, `map_end`) |
| `zone.dun_strept` | zone (gdd) | 02 | Strept hill-fort (Act II and III) |
| `zone.assengard` | zone (gdd) | 03 | Dravin's town (Act II and III) |
| `zone.stairs_switchbacks`, `zone.stairs_rope_spans`, `zone.stairs_ice_bridges` | zone (gdd) | 04 | Marnadal Stairs; map node `map.stairs_foot`; default spawn `stairs_foot_camp` |
| `zone.wyverns_roost`, `zone.roost_chasm_climb` | zone (gdd) | 05 | Roost and chasm climb |
| `zone.ko_weeping_gate`, `zone.ko_forge_of_echoes`, `zone.ko_drowned_library`, `zone.ko_bridge_nine_anvils` | zone (gdd) | 06 | Karak Ostrel |
| `zone.ko_lower_halls` | zone (gdd) | 06 | Alt. entry. **Spawn `mine_breach`** (default) for A07's Silver Mine exit |
| `zone.ko_lock_chamber` | zone (gdd) | 07 | Finale arena (spawn `great_door`) |

### NPCs

| id | kind | defined in | meaning |
|---|---|---|---|
| `npc.outrider_lenka` | npc | 01 | Kosk's outrider |
| `npc.hesk` | npc | 02 | Hesk Ironjaw |
| `npc.corra_ironjaw` | npc | 02 | Hesk's daughter, leader of `ally.strept_warband` |
| `npc.ama_kerrow` | npc | 02 | Keeper of the standing stone |
| `npc.kellan_gatewarden` | npc | 02 | Dun Strept gatewarden |
| `npc.ewin_trader` | npc | 02 | Dun Strept shop (furs, mutton bait) |
| `npc.dun_strept_alewife` | npc | 02 | Una the alewife; **the rumor source A07 expects** |
| `npc.dravin` | npc | 03 | Dravin Ostrel (companion `companion.dravin`) |
| `npc.jasia` | npc | 03 | Dravin's apprentice; Assengard forge shop |
| `npc.reeve_bogna` | npc | 03 | Reeve of Assengard |
| `npc.brother_wendel` | npc | 03 | Choir cell leader at Assengard |
| `npc.brother_ostwin` | npc | 04 | Choir rear-guard captain on the Stairs |
| `npc.tobiasz` | npc | 04 | Bribed palace servant who led Aldric out through the catacombs |
| `npc.wyvern` | npc | 05 | The wyvern as an interactable actor (combat `enemy.wyvern_roost`) |
| `npc.brother_udo` | npc | 05 | Choir alchemist who stole the eggs |
| `npc.choir_scribe` | npc | 06 | Brother Leszek, library scribe |
| `npc.brother_jarek`, `npc.brother_wick` | npc | 07 | Dais bodyguards who kneel to Kingmaker |

### Items

| id | kind | defined in | meaning |
|---|---|---|---|
| `item.lion_crown` | key | 01 | The physical Lion's Crown; Aldric must wear it for the True Oath. **A05: do not redeclare; give or reference** |
| `item.kosk_apology` | key (gdd) | 01 | Kosk's apology and blood-price |
| `item.lenka_scout_report`, `item.varn_unsent_letters` | document | 01 | Flavor documents |
| `item.strept_furs` | armor | 02 | Halves Chill (needs an item field; see 02 Open questions) |
| `item.mutton_bait` | consumable | 02 | Troll bait (used in 04) |
| `item.standing_stone_rubbing`, `item.sapper_orders` | document | 02 | Stone verses; Choir orders |
| `item.iron_key` | key (gdd) | 03 | The Iron-Key of Ostrel |
| `item.counter_gear_drawing`, `item.warden_line_tablets` | document | 03 | Dravin's secret; family lore |
| `item.ostrel_mail` | armor | 03 | Armor 34 (Jasia's shop) |
| `item.warden_breaker` | weapon | 03 | Maul, ×1.5 vs construct (Jasia's shop) |
| `item.rearguard_orders` | document | 04 | Anselm's "no relief" orders |
| `item.udo_reagent_notes` | document | 05 | The egg reagent |
| `item.ko_gear_crank` | key | 06 | Forge puzzle crank |
| `item.echo_hammer` | weapon | 06 | Reliquary hammer, ×1.6 vs construct |
| `item.ko_lore_*` (10) | document | 06 | Pact lore pickups: warden_tally, last_muster, forge_plaque, ash_sworn, pact_leaf, corvan_letter, reversal_note, command_rite, choir_orders, knocker_log |

### Clues and deductions

| id | kind | defined in | meaning |
|---|---|---|---|
| `clue.standing_stone_verse` | clue (gdd) | 02 | Strept stone confirms the fourth verse (theory.fourth_verse) |
| `clue.marnadal_provocateur` | clue | 02 | The feathered envoy of 1263 (theory.choir) |
| `clue.choir_erasing_verse` | clue | 02 | Anselm wants no copy of the verses left (theory.fourth_verse) |
| `ded.choir_lit_marnadal` | deduction | 02 | `marnadal_provocateur` and (`marnadal_chaplain` or `ded.marnadal_truth`) |
| `clue.counter_gear_commission` | clue | 03 | Dravin forged the counter-gear (theory.anselm_plan) |
| `clue.weeping_gate_route` | clue | 03 | The Weeping Gate postern |
| `clue.anselm_breathes_ash` | clue | 04 | Anselm's black flask |
| `clue.ash_reagent` | clue | 05 | Ash-breath and the eggs |
| `clue.zealot_bellows_lung` | clue | 05 | The Zealot's weak point |
| `clue.vault_command_rite` | clue (gdd) | 06 | The Rite of Command (Bitter Bargain requirement) |
| `clue.ko_pact_origin`, `clue.ko_reversal_design`, `clue.ko_dwarves_sealed_in` | clue | 06 | Pact lore |

### Encounters and dialogues
All `enc.*` (25) and `dlg.*` (23) ids are local to this slice. Of note for other slices: `dlg.a3_war_council` (Kosk, Act III; see 01 Open questions), `dlg.hesk`, `dlg.dravin`, `enc.lock_chamber_finale` (the finale encounter the finale domain drives).

### Epilogue slide ids
`epilogue.<ending>_<nn>_<slug>` and `epilogue.v<nnn>_<slug>`: about 60 slides in 08. The id prefix `epilogue.` is a proposal (architecture §8.2 lists no epilogue example).

## Expected from other slices

| id | kind | expected owner | why this slice needs it |
|---|---|---|---|
| `ms.act2_twist`, `ms.act1_complete`, `ms.a2_tigg_resolved` | milestone | A04 / A05 | Section availability |
| `flag.queen_alive`, `flag.aldric_co_sovereign`, `flag.aldric_emergency_writ`, `flag.aldric_crowned_king` | flag (gdd) | A05 (act2/08 twist) | Crown handover branch in 01; endings |
| `npc.kosk`, `npc.ysolde`, `npc.varn`, `npc.aldric`, `npc.anselm`, `npc.maelis` | npc | A04 | Speakers in 01, 07, 08. Ysolde's id is assumed (`npc.ysolde`) |
| `zone.palace_hall` with spawn `war_room_door` | zone | A04 | War room exit. A04 should add an exit `to zone.palace_war_room / war_room_door` when `act() == 3` |
| `flag.varn_exposed` | flag | A04 | Varn turned in to Kosk (01 presence, 08 v410) |
| `flag.varn_blackmailed`, `clue.varn_ledgers` | flag, clue (gdd) | A04 | Regency option; epilogue v420 |
| `flag.aldric_trusts_player` | flag | A04 | Aldric's loyalty from Act I scenes. Branches in 07 dialogue (optional; falls back cleanly if never set) |
| `flag.maelis_recruited`, `flag.maelis_dead` | flag | A04 / A07 / A05 | Maelis joined (Abbey Friendly or scriptorium quest) / died of Choir poison (gdd §6.2). Finale presence, epilogues |
| `flag.antidote_sold_raimund` | flag | A05 | Epilogue v360 |
| `flag.raimund_allied` | flag (gdd) | A05 | Epilogue Attre variants |
| `flag.torc_rite_known`, `item.marnadal_torc` | flag, item (gdd) | A05 | Hesk's torc scene. **Reconcile the champion's hall name ("Darrach") and the cairn-words with act2/04** |
| `flag.wyvern_fought`, `flag.wyvern_driven_by_smoke` | flag | A05 (declared in act2/01) | Roost look variants |
| `item.wyvern_eggs`, `item.true_fourth_verse`, `item.anselm_cipher`, `item.choir_robe`, `item.pale_feather`, `item.dravin_letter`, `item.kosk_writ` | item (gdd) | A04 / A05 | Throughout |
| `ded.anselm_treason_proven` | deduction (gdd) | A05 | Dravin's Act II join |
| `clue.marnadal_chaplain` | clue (gdd) | A05 (?) | Ded/dialogue option in 02, 07. No slice has declared it yet. If no one does, the conditions still fall back to `ded.marnadal_truth` |
| `ded.marnadal_truth`, `clue.grey_ferry_truth` | deduction, clue | A07 (side/10) | Kosk's apology without a check; 07 Marnadal option |
| `flag.watch_signal_lit` | flag (gdd) | A07 (side/09) | Cavalry terms (01), finale ally (07) |
| `flag.choir_list_exposed`, `item.choir_list` | flag, item (gdd) | A07 (side/02) | −2 bodyguards; Tobiasz option; Anselm line |
| `flag.brzezina_plot_exposed` | flag (gdd) | A07 (side/04) | Sodden epilogue variants |
| `clue.choir_secret_pass` | clue (gdd) | A07 (side/11) | Stairs ice-cave bypass |
| `flag.shrine_oath_found`, `clue.shrine_oath_line` | flag, clue | A07 (side/13) | Second source at the switchbacks shrine (04 sets the same flag) |
| `flag.lower_breach_open`, `zone.silver_mine_breach` with spawn `from_ostrel` | flag, zone | A07 (side/12) | Lower Halls return exit. A07's exit into `zone.ko_lower_halls / mine_breach` should carry `act() == 3` |
| `rumor.r05_dwarves_inside` | rumor | A07 (side/14) | Verified on entering Karak Ostrel |
| `item.poultice`, `item.field_draught`, `item.antitoxin`, `item.fire_oil`, `item.frost_tallow`, `item.crossbow_bolt` | item | A04 / A05 / A07 | Loot and shops. Note: A04 declares `item.crossbow_bolt`, while A05 and A07 use `item.crossbow_bolts`. This slice uses `item.crossbow_bolt` |
| `quest.main_a3` | quest (gdd) | this slice + converter | Started in 01 if not already active |
| `map.cintra`, `map.dun_strept`, `map.assengard`, `map.stairs_foot`, `map.marnadal_watch`, `map.silver_mine` | map | design / converter | Unlocks, pins, zone `map_node` |
| `enemy.anselm_human` | enemy | gdd §6.7 text | Finale; not in the §6.7 table (stat line in prose only) |
| `perk.kingmaker` | perk (gdd) | design | Sway options; bodyguard count |
