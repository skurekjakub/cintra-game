# Side slice: ids

Slice: `docs/content/side/` (A07). New ids that other slices may reference, plus ids this slice needs from other slices.
Local ids (dialogue nodes, zone areas, spawns, beats, option ids) are not listed.

## Section files

| section_id | file | quest |
|---|---|---|
| `side.bertha_debt` | `01-drowned-rat-debt.md` | `quest.side_bertha_debt` |
| `side.abbey_ledgers` | `02-abbey-ledgers.md` | `quest.side_abbey_ledgers` |
| `side.barrows` | `03-barrows-old-kings.md` | `quest.side_barrows` |
| `side.brzezina` | `04-brzezina-woods.md` | `quest.side_brzezina` |
| `side.skerra` | `05-isle-of-skerra.md` | `quest.side_skerra` |
| `side.morrow_gull` | `06-wreck-morrow-gull.md` | `quest.side_morrow_gull` |
| `side.rozrog` | `07-rozrog-forest.md` | `quest.side_rozrog` |
| `side.wenna_hair` | `08-wenna-hair.md` | `quest.side_wenna_hair` |
| `side.marnadal_watch` | `09-marnadal-watch.md` | `quest.side_marnadal_watch` |
| `side.grey_ferry` | `10-grey-ferry.md` | `quest.side_grey_ferry` |
| `side.ravensford` | `11-ravensford-ruins.md` | `quest.side_ravensford` |
| `side.silver_mine` | `12-silver-mine.md` | `quest.side_silver_mine` |
| `side.travel_events` | `13-travel-events.md` | none |
| `side.rumors` | `14-rumors.md` | none |

## New ids defined in this slice

Ids already named in `gdd.md` (for example `quest.side_*`, `item.mane_cleaver`, `flag.watch_signal_lit`) are listed when this slice is the first to declare or set them.

| id | kind | defined in | meaning |
|---|---|---|---|
| `zone.drowned_rat_yard` | zone | 01 | Muddy back yard and alley behind the Drowned Rat, where Jory's collectors call |
| `zone.drowned_rat_loft` | zone | 01 | Bertha's upstairs safehouse room (rest point) |
| `npc.mott_sallow` | npc | 01 | "Sallow" Mott, Jory's debt collector in Cintra; skims Jory's take |
| `item.bertha_debt_tally` | document | 01 | Jory's split tally-stick recording Bertha's debt |
| `item.mott_skim_book` | document | 01 | Mott's private tally book: proof he skims Jory's collections |
| `flag.bertha_debt_cleared` | flag | 01 | Bertha's debt to Jory is settled (any route) |
| `flag.bertha_safehouse` | flag | 01 | The Drowned Rat loft is the player's safehouse: free rest, rumor credibility from Bertha, masquerade contact |
| `flag.mott_skim_exposed` | flag | 01 | Jory knows Mott skimmed him |
| `flag.bertha_invitation_given` | flag | 01 | Bertha has handed over her masquerade invitation |
| `dlg.jory_bertha_debt` | dialogue | 01 | Settling Bertha's debt with Jory himself at Ferrymen's Camp (chained from A05's Jory dialogue) |
| `zone.abbey_scriptorium` | zone | 02 | The locked scriptorium of St. Corwen at night (stealth) |
| `npc.brother_hollin` | npc | 02 | Choir-sworn scriptorium warden |
| `npc.novice_pip` | npc | 02 | Abbey novice and Maelis's runner |
| `item.scriptorium_key` | key | 02 | Brass key to the scriptorium's inner press |
| `item.choir_list` | document | 02 | (gdd) Full Choir membership list |
| `item.abbey_silver_ledger` | document | 02 | Abbey alms ledger showing silver paid out to "a merchant of Peixe" |
| `clue.list_names_pell` | clue | 02 | The Choir list names Pell the food-taster (theory.poisoner, supports pell) |
| `clue.abbey_silver_ledger` | clue | 02 | Abbey silver paid to Attre (theory.poisoner, supports anselm, raimund) |
| `flag.choir_list_exposed` | flag | 02 | (gdd) The list reached the Lord Marshal; court spies purged |
| `flag.scriptorium_alarm` | flag | 02 | The scriptorium raid went loud |
| `flag.maelis_ledgers_done` | flag | 02 | Maelis's ledgers are out of the Abbey |
| `dlg.maelis_ledgers_offer` | dialogue | 02 | Maelis asks for help (chained from A04's Maelis dialogue) |
| `zone.barrows_field` | zone | 03 | The barrow field and the grave-robbers' camp |
| `zone.barrows_tomb` | zone | 03 | Corvan's tomb (dungeon) |
| `npc.corvan_shade` | npc | 03 | Shade of King Corvan (combat `enemy.corvan_shade`) |
| `npc.seb_mattock` | npc | 03 | Seb Mattock, chief of the grave-robbers |
| `npc.lisle` | npc | 03 | Lisle, a young robber who wants out |
| `item.mane_cleaver` | weapon | 03 | (gdd) Corvan's rune-tempered greatsword |
| `item.corvan_grave_goods` | key | 03 | Sack of stolen grave goods from Corvan's tomb |
| `clue.corvan_tomb_oath` | clue | 03 | The tomb door carries the Oath's first two lines in old chisel (theory.fourth_verse) |
| `flag.corvan_appeased` | flag | 03 | The shade accepted the player without a duel (parley) |
| `flag.corvan_duel_won` | flag | 03 | The player won Corvan's duel |
| `flag.grave_goods_returned` | flag | 03 | The stolen grave goods are back in the tomb |
| `zone.brzezina_woods` | zone | 04 | Birch woods around the hunting lodge |
| `zone.brzezina_lodge` | zone | 04 | Baron Hollec's hunting lodge (interior) |
| `npc.ivena_drozd` | npc | 04 | Ivena Drozd, Sodden spymaster; recurring rival |
| `npc.baron_hollec` | npc | 04 | Baron Oswin Hollec, traitorous Cintran border baron |
| `item.hollec_letters` | document | 04 | Hollec's correspondence with Sodden: the northern-flank plan |
| `flag.brzezina_plot_exposed` | flag | 04 | (gdd) The Sodden flank plot was exposed to the Crown |
| `flag.hollec_blackmailed` | flag | 04 | The player kept the letters and squeezed Hollec instead |
| `flag.drozd_rival` | flag | 04 | Drozd escaped and holds a grudge (recurring rival hooks) |
| `zone.skerra_village` | zone | 05 | Skerra fishing village (hub) |
| `zone.skerra_seal_rocks` | zone | 05 | The seal rocks and tide caves |
| `npc.aud_skerra` | npc | 05 | Grandmother Aud, Skerra's elder |
| `npc.tam_corley` | npc | 05 | Tam Corley, the fisherman who stole the selkie's pelt |
| `npc.selkie_ronat` | npc | 05 | Ronat, the seal-wife |
| `npc.jessa_rook` | npc | 05 | Jessa Rook, captain of the smuggler's cutter *Shrike* |
| `item.selkie_pelt` | key | 05 | Ronat's stolen sealskin |
| `item.serpent_lure` | consumable | 05 | A barrel of seal-oil chum that draws the Morrow Gull serpent off (also sold in 06) |
| `flag.skerra_cutter` | flag | 05 | (gdd) The *Shrike* and crew serve the player: sea edges open, stage 3 fortification bypassed |
| `flag.selkie_freed` | flag | 05 | Ronat has her pelt back |
| `zone.morrow_gull_reef` | zone | 06 | Harl's boat and the reef above the wreck |
| `zone.morrow_gull_wreck` | zone | 06 | The sunken cog (underwater arena, breath meter) |
| `npc.harl_brine` | npc | 06 | Harl Brine, old Attre salvage diver |
| `item.taster_dispatch` | document | 06 | (gdd) Watertight dispatch tube naming the food-taster |
| `clue.taster_dispatch` | clue | 06 | The tube's contents (theory.poisoner, supports pell, anselm) |
| `flag.taster_dispatch_sent` | flag | 06 | The tube was sent to the Lord Marshal |
| `flag.serpent_slain` | flag | 06 | The Morrow Gull serpent is dead |
| `zone.rozrog_charcoal_camp` | zone | 07 | Charcoal burners' camp in Rozrog |
| `zone.rozrog_sacred_grove` | zone | 07 | The woodwose's oak grove |
| `npc.wencel_burner` | npc | 07 | Wencel, boss of the charcoal burners |
| `npc.ottla` | npc | 07 | Ottla, the mute woods-girl who becomes `ally.forest_guide` |
| `npc.woodwose` | npc | 07 | The woodwose (combat `enemy.woodwose`) |
| `clue.choir_charcoal_orders` | clue | 07 | Monks pay silver for charcoal by the cartload (theory.choir) |
| `flag.woodwose_peace` | flag | 07 | (gdd) Peace made with the woodwose |
| `flag.woodwose_dead` | flag | 07 | The woodwose was killed |
| `zone.wenna_scrying_hollow` | zone | 08 | The hollow behind Wenna's hut where she reads the hair |
| `npc.wenna_crow` | npc | 08 | Wenna's one-eyed crow, "Gallows" |
| `flag.queen_reading_known` | flag | 08 | Wenna has read the Queen's condition from the hair |
| `flag.wenna_kept_strand` | flag | 08 | The player let Wenna keep a strand of the Queen's hair |
| `dlg.wenna_hair_offer` | dialogue | 08 | Wenna's offer (chained from A05's Wenna dialogue) |
| `zone.marnadal_watch_tower` | zone | 09 | Marnadal Watch: yard, tower and beacon platform |
| `npc.squire_tobin` | npc | 09 | Tobin Ashe, the squire left holding the tower |
| `npc.sergeant_rask` | npc | 09 | Sergeant Rask, leader of the deserters |
| `item.beacon_pitch` | key | 09 | Pitch kegs for the beacon |
| `flag.watch_beacon_restored` | flag | 09 | The beacon is repaired and fuelled |
| `flag.watch_signal_lit` | flag | 09 | (gdd) The beacon was lit: Kosk's cavalry rides for Amell |
| `flag.rask_returned` | flag | 09 | Rask's deserters returned to duty |
| `zone.grey_ferry_landing` | zone | 10 | The Grey Ferry landing and drowned chapel |
| `zone.grey_ferry_crossing` | zone | 10 | The ferry raft midstream (small arena) |
| `npc.grey_ferryman` | npc | 10 | The silent ferryman |
| `npc.aled_venn` | npc | 10 | Corporal Aled Venn, a soldier who died at Marnadal (ghost) |
| `item.marnadal_muster_roll` | document | 10 | Water-stained muster roll of Venn's company |
| `clue.grey_ferry_truth` | clue | 10 | What the ghost saw at Marnadal (theory.anselm_plan, supports anselm) |
| `ded.marnadal_truth` | deduction | 10 | (gdd) Kosk burned the halls on a chaplain's lie: unlocks Kosk's apology without a check |
| `clue.ghost_choir_road` | clue | 10 | Alternative answer: the dead watch iron crates go up the old road (theory.choir) |
| `clue.ghost_vault_weapons` | clue | 10 | Alternative answer: what Corvan sealed under Ostrel (theory.anselm_plan) |
| `flag.ghost_question_asked` | flag | 10 | The one question has been asked |
| `zone.ravensford_ruins` | zone | 11 | Burned mill village of Ravensford on the Assen |
| `zone.ravensford_reeds` | zone | 11 | Reed beds and the drowner nest |
| `npc.ina` | npc | 11 | Ina, the girl who hears her brother |
| `npc.mirek_ghost` | npc | 11 | Mirek, Ina's drowned brother (a voice in the reeds) |
| `npc.assen_lady` | npc | 11 | The Lady of the Reeds, the Assen's nymph |
| `item.mirek_whistle` | key | 11 | Mirek's reed whistle |
| `clue.mirek_saw_monks` | clue | 11 | Mirek saw monks hauling crates up a goat track (theory.choir) |
| `clue.choir_secret_pass` | clue | 11 | (gdd) The Choir's secret pass: lets the player skip the Stairs sharpshooter segment |
| `flag.mirek_freed` | flag | 11 | Mirek's spirit is at rest |
| `zone.silver_mine_camp` | zone | 12 | Miners' camp at the pithead |
| `zone.silver_mine_shafts` | zone | 12 | Upper and flooded galleries (dungeon) |
| `zone.silver_mine_breach` | zone | 12 | The deep breach into dwarven stonework |
| `npc.brannoc` | npc | 12 | Brannoc, Strept mine foreman |
| `npc.old_kettle` | npc | 12 | Old Kettle, a miner who reads dwarf-marks |
| `item.kettle_chart` | document | 12 | Kettle's chart of the breach route |
| `clue.vault_knocking` | clue | 12 | The knocking is Ostrel's pressure-hammers labouring (theory.anselm_plan) |
| `flag.lower_breach_open` | flag | 12 | The Lower Halls breach into Karak Ostrel is open (alt. entry, gdd §7.3) |
| `flag.mine_charges_cut` | flag | 12 | The Choir's collapse charges in the breach were cut |
| `clue.cairn_marker` | clue | 13 | (gdd) Dwarven ghost's cairn: a hidden cache (theory.fourth_verse) |
| `clue.shrine_oath_line` | clue | 13 | (gdd) Roadside shrine carved with an Oath line (theory.fourth_verse) |
| `clue.pilgrim_feather` | clue | 13 | A pilgrim hides a pale feather (theory.choir) |
| `flag.cairn_cache_taken` | flag | 13 | The cairn cache was looted |
| `flag.marnadal_watch_hook` | flag | 13 | Watch hook started (deserter card or rumor) |
| `flag.brzezina_hook` | flag | 13 | Brzezina hook started (Sodden tinker card or rumor) |
| `flag.rozrog_hook` | flag | 13 | Rozrog hook started (woodwose totems or rumor) |
| `event.*`, `esc.*` | event cards | 13 | See 13-travel-events.md |
| `npc.deserter_wat` | npc | 13 | Wat Mabry, Watch deserter selling kit (travel card L4) |
| `item.watch_brigandine` | armor | 13 | Marnadal Watch brigandine (armor 22) |
| `flag.lily_wagon_searched`, `flag.pilgrim_spy_exposed`, `flag.knight_duel_won`, `flag.shrine_oath_found`, `flag.blue_fires_active`, `flag.drozd_road_met` | flag | 13 | Travel card state (see 13 §8) |
| `enc.travel_*`, `enc.esc_*`, `zone.arena_lowlands_1/2`, `zone.arena_valley_1/2`, `zone.arena_mountain_1/2` | encounter, zone | 13 | Travel fights and their arenas |
| `event.ford_marnadal`, `event.snow_choked_pass` | event card | 13 | Forced map-edge hazards (gdd §6.3) |
| `dlg.bertha_debt_plea` | dialogue | 01 | Bertha asks for help (chained from A04's Bertha dialogue) |
| `dlg.mott_collection`, `dlg.bertha_debt_settled`, `dlg.bertha_loft`, `enc.yard_collectors`, `enc.yard_reprisal` | dialogue, encounter | 01 | Debt scenes; Jory's one-time reprisal if the debt was cleared by force |
| `flag.bertha_tip_skim`, `flag.mott_driven_off`, `flag.jory_reprisal_done` | flag | 01 | Debt quest state |
| `npc.brother_faddo` | npc | 02 | Bribable lay brother on scriptorium watch |
| `dlg.pip_lookout`, `dlg.faddo_bribe`, `dlg.hollin_caught`, `dlg.maelis_ledgers_done`, `enc.scriptorium_alarm` | dialogue, encounter | 02 | Scriptorium scenes |
| `flag.hollin_dealt`, `flag.faddo_bribed` | flag | 02 | Scriptorium state |
| `dlg.mattock_camp`, `dlg.mattock_theft`, `dlg.lisle_out`, `dlg.corvan_shade`, `dlg.corvan_duel_end`, `enc.barrows_robbers`, `enc.corvan_duel` | dialogue, encounter | 03 | Barrows scenes |
| `flag.barrows_robbers_dealt`, `flag.lisle_helped`, `flag.lisle_gone` | flag | 03 | Barrows state |
| `npc.castellan_brana`, `npc.huntsman_garr`, `npc.hanka_maid`, `item.hollec_solar_key` | npc, item | 04 | Brzezina lodge cast; solar key |
| `dlg.garr_gate`, `dlg.hanka_kitchen`, `dlg.drozd_table`, `dlg.hollec_confront`, `dlg.brana_castellan`, `enc.brzezina_retainers`, `enc.brzezina_clearing` | dialogue, encounter | 04 | Brzezina scenes |
| `flag.drozd_bought`, `flag.lodge_guest`, `flag.brzezina_plot_overheard`, `flag.drozd_horses_cut`, `flag.hanka_helped`, `flag.lodge_alarm`, `flag.hollec_dead`, `flag.hollec_arrested`, `flag.hollec_yielded` | flag | 04 | Brzezina state; `flag.hollec_*` usable by epilogues |
| `npc.fenn_galt`, `enc.skerra_pelt_buyers` | npc, encounter | 05 | Attre pelt buyer and his men |
| `flag.skerra_fog_lifted`, `flag.ronat_bound`, `flag.skerra_pelt_sold`, `flag.skerra_buyers_dealt`, `flag.skerra_truth_known`, `flag.skerra_pelt_hint`, `flag.skerra_bargain_read`, `flag.skerra_chit_seen`, `flag.tam_broken` | flag | 05 | Skerra state |
| `dlg.kosk_taster_dispatch` | dialogue | 06 | Handing the tube to Kosk (chained from A04's Kosk dialogue when `has_item(item.taster_dispatch)`) |
| `enc.morrow_gull_serpent`, `enc.morrow_gull_hold` | encounter | 06 | Serpent boss; drowners in the hold |
| `flag.taster_dispatch_read`, `flag.serpent_lured`, `flag.harl_half_share`, `flag.osk_knife_found`, `var.morrow_dive_trips` | flag, var | 06 | Wreck state |
| `npc.choir_carter`, `item.oak_heartwood` | npc, item | 07 | Stage 3 Choir charcoal buyer; heartwood offering |
| `enc.rozrog_woodwose`, `enc.rozrog_burners`, `enc.rozrog_choir_carters` | encounter | 07 | Rozrog fights |
| `flag.burners_stop_cutting`, `flag.burners_driven_off`, `flag.wencel_turned`, `flag.rozrog_met_wencel`, `flag.rozrog_hunt`, `flag.rozrog_bounty_paid`, `flag.ottla_signs_read`, `flag.rozrog_carters_dealt` | flag | 07 | Rozrog state |
| `enc.wenna_hollow_watchers`, `flag.wenna_deceived`, `flag.wenna_hollow_watchers_dealt` | encounter, flag | 08 | Stage 3 Choir watchers; lying to Wenna |
| `dlg.tobin_main`, `dlg.rask_camp`, `dlg.rask_caught_thief`, `dlg.rask_yielded`, `enc.watch_deserters`, `enc.watch_choir_raid`, `enc.watch_choir_raid_garrisoned` | dialogue, encounter | 09 | Watch scenes |
| `dlg.ferryman_gestures`, `dlg.dead_toll`, `dlg.venn_crossing`, `enc.grey_ferry_revenants`, `enc.grey_ferry_drowners` | dialogue, encounter | 10 | Grey Ferry scenes |
| `item.reed_tallow`, `item.mirek_remains` | item | 11 | Ravensford items |
| `dlg.ina_main`, `dlg.mirek_nest`, `dlg.assen_lady`, `dlg.silencer_leader`, `enc.ravensford_drowners`, `enc.ravensford_drowners_dark`, `enc.ravensford_lure`, `enc.ravensford_silencers` | dialogue, encounter | 11 | Ravensford scenes |
| `item.rune_rubbing` | item | 12 | Rubbing of the bulkhead runes |
| `dlg.brannoc_main`, `dlg.kettle_main`, `enc.mine_drowners`, `enc.mine_choir_sappers`, `enc.mine_stray_warden` | dialogue, encounter | 12 | Silver Mine scenes |
| Local flags in 09–12 (`flag.tobin_trusts`, `flag.venn_paid`, `flag.nest_cleared`, `flag.mine_gallery_drained`, ...) | flag | 09–12 | Declared in each file's `flags` block; not needed by other slices |
| `rumor.r01_*` .. `rumor.r20_*` | rumor | 14 | See 14-rumors.md |

## Expected from other slices

| id | kind | expected owner | why this slice needs it |
|---|---|---|---|
| `npc.bertha`, `zone.drowned_rat` (exit `back_door` to `zone.drowned_rat_yard`/`from_rat`, stairs exit to `zone.drowned_rat_loft`/`from_taproom` when `flag(flag.bertha_safehouse)`) | npc, zone | A04 | Bertha's debt quest; safehouse |
| `npc.maelis`, `zone.abbey_st_corwen` (exit to `zone.abbey_scriptorium`/`cloister_door` when `quest_active(quest.side_abbey_ledgers)`), and an option in Maelis's dialogue that runs `start_dialogue(dlg.maelis_ledgers_offer)` | npc, zone, dialogue hook | A04 | Abbey ledgers |
| `npc.kosk`, `npc.pell`, `npc.anselm` | npc | A04 | Referenced in lines and clue support lists |
| `item.ysolde_hair` (sickroom, Presence 5 with Kosk's leave; must stay obtainable in Act II) | item | A04 | Wenna's hair quest |
| `flag.food_taster_exposed` (declared where Pell is first exposed) | flag | A04 | Set by 06 when the Morrow Gull tube is sent |
| `ded.taster_is_bought` condition must accept `has_clue(clue.taster_dispatch)` | deduction | A04 | gdd §6.11 "taster_gold, or taster_dispatch" |
| `item.kosk_writ` | item | A04 | Officials' checks in 04 and 09 |
| `npc.jory`, `zone.ferrymen_camp`, option in Jory's dialogue running `start_dialogue(dlg.jory_bertha_debt)` | npc, dialogue hook | A05 | Bertha's debt settled with Jory |
| `npc.wenna`, `zone.witchs_mere` (exit to `zone.wenna_scrying_hollow`/`from_hut`), option in Wenna's dialogue running `start_dialogue(dlg.wenna_hair_offer)` | npc, zone, dialogue hook | A05 | Wenna's hair quest |
| `flag.wenna_bulbs_asked` | flag | A05 | Wenna has asked for her bulbs (Wenna line active): travel cards L3, V6 |
| `var.bulbs_recovered`, `item.grey_lily_bulbs`, `item.wenna_antidote`, `flag.antidote_administered`, `flag.antidote_rider_sent` | var, item, flag | A05 | Bulb card; Wenna's reading |
| `item.masquerade_invitation` | item | A05 | Bertha hands one over (gdd §6.9 lists Bertha as a source) |
| `zone.attre_harbor` | zone | A05 | Morrow Gull, Skerra |
| `ded.reversed_oath_plan`, `ded.choir_muster_vel_aram`, `flag.torc_rite_known` | deduction, flag | A05 | Watch lighting window; ghost answers; revenant rising |
| `zone.ko_lower_halls` (spawn `mine_breach`) | zone | A06 | Silver Mine breach exit in Act III |
| `flag.strept_guides` | flag | A06 | Travel card M2 |
| Readers of this slice: `flag.watch_signal_lit` (cavalry), `flag.lower_breach_open`, `clue.choir_secret_pass` (Stairs), `ded.marnadal_truth` (Kosk apology), `item.mane_cleaver`, `flag.choir_list_exposed`, `flag.brzezina_plot_exposed` (epilogue), `flag.drozd_rival` (epilogue) | — | A04–A06 | Payoffs |
| `map.*` node ids from gdd §7.5 (`map.barrows`, `map.brzezina_woods`, `map.isle_skerra`, `map.morrow_gull`, `map.rozrog_forest`, `map.marnadal_watch`, `map.grey_ferry`, `map.ravensford`, `map.silver_mine`, `map.vel_aram`, `map.witchs_mere`, ...) | map | design / converter | `add_map_pin`, `unlock_map_node` |
| `npc.bertha`'s dialogue: option running `start_dialogue(dlg.bertha_debt_plea)`; `zone.drowned_rat` spawns `back_door`, `loft_stairs`, `cellar`; `zone.cintra_docks` spawn `gutter_lane` | dialogue hook, spawns | A04 | Debt quest entry and exits |
| `zone.abbey_st_corwen` spawns `scriptorium_door`, `herb_garden_gate` | spawns | A04 | Scriptorium exits |
| `npc.kosk`'s dialogue: option `has_item(item.taster_dispatch)` running `start_dialogue(dlg.kosk_taster_dispatch)` | dialogue hook | A04 | Morrow Gull tube by hand |
| `clue.book_sliced`, `clue.chalice_pollen`, `clue.varn_ledgers`, `ded.poison_via_attre`, `ded.anselm_treason_proven`, `ded.choir_exists` | clue, deduction | A04/A05 | Read in conditions and rumor verification |
| `item.pale_feather`, `item.dravin_letter`, `item.varn_ledger_scrap`, `flag.varn_blackmailed`, `flag.chalice_secured` | item, flag | A04 | Read in conditions |
| `item.choir_robe` | item | A05 | Disguise in scriptorium (Choir-tagged), travel card M6 |
| `clue.jory_iron_crates`, `flag.jory_crossing_granted` | clue, flag | A05 | Rumor 7 verification; ford hazard |
| `clue.marnadal_chaplain` | clue | A05/A06 | Grey Ferry; the reconciliation pass may let `ded.marnadal_truth` accept it too |
| `item.kosk_apology` | item | A06 | Grey Ferry lines mention the apology route |
| `flag.roost_resolved` | flag | A06 | Travel card M4 requires the Roost unresolved |
| `zone.ko_forge_of_echoes` | zone | A06 | Rumor 5 verification |
| Consumables `item.poultice`, `item.field_draught`, `item.antitoxin`, `item.fire_oil`, `item.frost_tallow`, `item.smoke_pot`, `item.crossbow_bolts` | item | A04 (first shops) | gdd §6.9 names them without ids |
| Tavern keepers for rumor sources: `npc.tigg_innkeeper`, `npc.attre_tapster`, `npc.dun_strept_alewife` | npc | A05 / A06 | Rumor `sources` |
