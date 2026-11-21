# Act II slice: ids

Slice: `docs/content/act2/` (A05). Every id this slice declares or defines, plus the ids it needs from other slices.
Local ids (dialogue nodes, zone areas, spawns, beats, option ids, checkpoints) are not listed, except the spawns other slices exit into.
Ids that `gdd.md` names (for example `ms.a2_*`, `item.anselm_cipher`, `flag.raimund_allied`) are listed where this slice is the first to declare or define them.

## Section files

| section_id | file | main milestone |
|---|---|---|
| `a2.01` | `01-tigg-crossroads.md` | `ms.a2_tigg_resolved` (+ master stage of `quest.main_a2`, order 10) |
| `a2.02` | `02-hanged-mans-oak.md` | `ms.a2_cipher_taken` |
| `a2.03` | `03-ferrymen-camp.md` | `ms.a2_jory_dealt` (also `ms.a2_cipher_taken` if the courier escaped) |
| `a2.04` | `04-marnadal-field.md` | `ms.a2_torc_taken` |
| `a2.05` | `05-witchs-mere.md` | `ms.a2_wenna_line_resolved` |
| `a2.06` | `06-attre.md` | `ms.a2_attre_ledger` |
| `a2.07` | `07-vel-aram.md` | `ms.a2_vel_aram_cleared` |
| `a2.08` | `08-return-and-twist.md` | `ms.a2_return_cintra`, `ms.act2_twist` (+ `quest.main_a2` orders 20, 30) |

## New ids defined in this slice

| id | kind | defined in | meaning |
|---|---|---|---|
| `zone.tigg_village` | zone | 01-tigg-crossroads.md | Tigg |
| `zone.tigg_pastures` | zone | 01-tigg-crossroads.md | Tigg High Pastures |
| `npc.reeve_hobb` | npc | 01-tigg-crossroads.md | Reeve Hobb Tanner: Reeve of Tigg, tanner |
| `npc.ned` | npc | 01-tigg-crossroads.md | Ned: Simple drover accused of stealing stock |
| `npc.tigg_innkeeper` | npc | 01-tigg-crossroads.md | Marga of the Bent Post: Innkeeper at Tigg |
| `npc.godric` | npc | 01-tigg-crossroads.md | Old Godric: Retired crown falconer |
| `npc.ailsa` | npc | 01-tigg-crossroads.md | Ailsa: Shepherd girl at the high fold |
| `npc.brother_aske` | npc | 01-tigg-crossroads.md | Brother Aske: Keeper of the roadside shrine of St. Corwen |
| `item.field_draught` | item/consumable | 01-tigg-crossroads.md | Field draught. A stoppered flask of bitter herb-spirit sold on the southern roads. Heals deep wounds fast |
| `item.frost_tallow` | item/consumable | 01-tigg-crossroads.md | Frost-tallow. Mutton tallow cut with pine resin, rubbed into skin and furs against the cold. Halves the  |
| `item.tar_pot` | item/key | 01-tigg-crossroads.md | Pot of barn tar. Black pine tar for caulking barns. Burns slow and stinks for a mile. |
| `item.wyvern_scale` | item/key | 01-tigg-crossroads.md | Shed wyvern scale. A bronze-green scale the size of a palm, edged sharp as a sickle. Proof of what takes Tigg |
| `item.scout_note` | item/document | 01-tigg-crossroads.md | Choir scout's note. A scrap folded into the straw of the crate. |
| `clue.wyvern_eggs_stolen` | clue (theory.choir) | 01-tigg-crossroads.md | The wyvern's stolen clutch |
| `clue.tigg_monks_south` | clue (theory.choir) | 01-tigg-crossroads.md | Hooded monks on the south road |
| `ms.a2_tigg_resolved` | milestone | 01-tigg-crossroads.md | The wyvern has been driven away from Tigg (fight to 50% HP or the tar-beacon ring). |
| `flag.tigg_mob_resolved` | flag | 01-tigg-crossroads.md | The hanging at the gibbet has been resolved one way or another. |
| `flag.ned_saved` | flag | 01-tigg-crossroads.md | Ned was saved from the rope. |
| `flag.ned_held` | flag | 01-tigg-crossroads.md | Ned is held in the pound pending proof. |
| `flag.ned_hanged` | flag | 01-tigg-crossroads.md | The player walked away and Ned was hanged. |
| `flag.tar_given` | flag | 01-tigg-crossroads.md | Hobb gave leave to take tar from the pitch shed. |
| `flag.tigg_beacon_lore` | flag | 01-tigg-crossroads.md | The player knows tar smoke on the three cairns turns the wyvern. |
| `var.tigg_beacons_lit` | var | 01-tigg-crossroads.md | Number of pasture cairns lit. |
| `flag.wyvern_driven_by_smoke` | flag | 01-tigg-crossroads.md | The wyvern was turned away without a fight. Read by act3 Wyvern's Roost. |
| `flag.wyvern_fought` | flag | 01-tigg-crossroads.md | The player wounded the wyvern at Tigg. Read by act3 Wyvern's Roost. |
| `flag.tigg_bounty_paid` | flag | 01-tigg-crossroads.md | Hobb paid the 80-crown bounty. |
| `flag.ailsa_trusts` | flag | 01-tigg-crossroads.md | Ailsa lets the player rest at her fire. |
| `flag.aske_exposed` | flag | 01-tigg-crossroads.md | Brother Aske was unmasked as Choir. |
| `flag.aske_warned_oak` | flag | 01-tigg-crossroads.md | The player questioned Aske without exposing him; he signals the Oak (extra courier escort). |
| `flag.aske_cellar_found` | flag | 01-tigg-crossroads.md | The player found the shrine cellar's rear hatch. |
| `flag.oak_signal_known` | flag | 01-tigg-crossroads.md | The player knows the gibbet-lantern courier signal. Read by a2.02 (the courier walks into the ambush unescorted). |
| `rumor.tigg_monks_south` | rumor | 01-tigg-crossroads.md | Hooded monks go south past Tigg after dark, bowed under iron crates. The shrine  |
| `zone.hanged_mans_oak` | zone | 02-hanged-mans-oak.md | Hanged Man's Oak |
| `npc.brother_oswy` | npc | 02-hanged-mans-oak.md | Brother Oswy: Novice of St. Corwen, the Choir's courier to the Oak |
| `item.anselm_cipher` | item/key | 02-hanged-mans-oak.md | Anselm's cipher. A brass cipher wheel the size of a palm and a folded key-sheet in a cramped, scholarly han |
| `item.oak_orders` | item/document | 02-hanged-mans-oak.md | The Abbot's orders (decoded). Ciphered orders from St. Corwen to the Prior at Vel Aram, decoded with the wheel. |
| `item.va_report` | item/document | 02-hanged-mans-oak.md | Report from Vel Aram (ciphered). A sheet of wheel-letters left in the trunk by the Prior's runner. Unreadable without the c |
| `item.forged_dispatch` | item/document | 02-hanged-mans-oak.md | Forged Choir dispatch. Orders in Anselm's cipher, in a passable copy of his hand, written by you. |
| `item.choir_robe` | item/armor | 02-hanged-mans-oak.md | Choir robe. Undyed grey wool habit of St. Corwen, a pale feather stitched in the collar. Worn with a p |
| `clue.anselm_cipher` | clue (theory.choir) | 02-hanged-mans-oak.md | Anselm's cipher |
| `clue.choir_at_vel_aram` | clue (theory.choir) | 02-hanged-mans-oak.md | The muster at Vel Aram |
| `ded.choir_muster_vel_aram` | deduction | 02-hanged-mans-oak.md | The Choir musters at Vel Aram |
| `ms.a2_cipher_taken` | milestone | 02-hanged-mans-oak.md | The player holds Anselm's cipher (taken at the Oak, bought from Jory, or found on Oswy at Vel Aram). |
| `flag.courier_arrived` | flag | 02-hanged-mans-oak.md | The courier has come up the north track. |
| `flag.tether_cut` | flag | 02-hanged-mans-oak.md | The courier's horse was cut loose; he cannot ride away. |
| `flag.oak_courier_down` | flag | 02-hanged-mans-oak.md | The courier has been seized, turned or beaten. |
| `flag.oak_courier_escaped` | flag | 02-hanged-mans-oak.md | The courier got away on horseback; Jory robbed him at the crossing. Read by a2.03 (Jory holds the cipher) and a2.07 (Oswy hanged at the gate). |
| `flag.oak_lantern_hung` | flag | 02-hanged-mans-oak.md | The player hung the all-clear lantern; the escort stays back. |
| `flag.forged_dispatch_planted` | flag | 02-hanged-mans-oak.md | A forged order sent ten brothers away from Vel Aram. Read by a2.07. |
| `flag.oswy_witness` | flag | 02-hanged-mans-oak.md | Oswy went to Cintra to testify. Read by a2.08. |
| `flag.oswy_fled_home` | flag | 02-hanged-mans-oak.md | Oswy ran to Breza and lives. |
| `flag.oswy_returned` | flag | 02-hanged-mans-oak.md | Oswy went back to Vel Aram and will be hanged there. Read by a2.07. |
| `flag.oswy_killed` | flag | 02-hanged-mans-oak.md | The player killed Oswy. |
| `zone.ferrymen_camp` | zone | 03-ferrymen-camp.md | Ferrymen's Camp |
| `npc.jory` | npc | 03-ferrymen-camp.md | Ninefingers Jory: River-bandit kingpin of the Marnadal crossings |
| `npc.bollard` | npc | 03-ferrymen-camp.md | Bollard: Jory's lieutenant and gate-keeper |
| `npc.marit` | npc | 03-ferrymen-camp.md | Marit: Boatman's widow at the eel weirs |
| `item.jory_manifest` | item/document | 03-ferrymen-camp.md | Jory's crossing tally. A greasy tally-board copied onto paper: dates as moon-marks, crates as notches, silver as  |
| `item.tamas_ring` | item/key | 03-ferrymen-camp.md | Tamas's ring. A boatman's pewter ring, green with river slime, from the drowned skiff at the weirs. |
| `item.tamas_knife` | item/trinket | 03-ferrymen-camp.md | Tamas's skinning knife. A short, wicked eel-knife. Light in the hand; every cut finds a gap. |
| `clue.jory_iron_crates` | clue (theory.choir) | 03-ferrymen-camp.md | Iron crates across the Marnadal |
| `clue.dwarven_chain_crate` | clue (theory.anselm_plan) | 03-ferrymen-camp.md | Dwarven chain and a furnace grate |
| `ms.a2_jory_dealt` | milestone | 03-ferrymen-camp.md | Jory has admitted the crate trade (any route) or the player took his tally by force. |
| `flag.jory_crossing_granted` | flag | 03-ferrymen-camp.md | Free passage on the rope ferry (opens ferrymen_camp - marnadal_field without the ford). |
| `flag.jory_met` | flag | 03-ferrymen-camp.md | Bollard greeted the player at the gate. |
| `flag.jory_yielded` | flag | 03-ferrymen-camp.md | Jory was beaten and spared. |
| `flag.jory_dead` | flag | 03-ferrymen-camp.md | Jory was killed. Ferrymen effectively Hostile; no rider escort; no barge to Attre. |
| `flag.weir_job_taken` | flag | 03-ferrymen-camp.md | Jory asked the player to clear the eel weirs. |
| `flag.weir_cleared` | flag | 03-ferrymen-camp.md | The drowners at the weirs are dead. |
| `flag.tamas_ring_returned` | flag | 03-ferrymen-camp.md | Marit got her husband's ring back. |
| `flag.crate_shed_opened` | flag | 03-ferrymen-camp.md | The player forced the crate shed. |
| `flag.jory_choir_agents_dealt` | flag | 03-ferrymen-camp.md | The stage-3 Choir agents were driven off the landing. |
| `zone.marnadal_field` | zone | 04-marnadal-field.md | Marnadal Field |
| `npc.callum_darrach` | npc | 04-marnadal-field.md | Callum Darrach: Shade of the clans' champion of Darrach Hall, Hesk Ironjaw's sworn shield-brother |
| `npc.odo_vane` | npc | 04-marnadal-field.md | Ser Odo Vane: Shade of a Cintran knight-captain of the heavy horse |
| `npc.gammer_rusk` | npc | 04-marnadal-field.md | Gammer Rusk: Bone-picker and relic seller |
| `item.marnadal_torc` | item/key | 04-marnadal-field.md | Bronze-and-iron torc. Darrach Hall's torc: a champion's neck-ring, twisted bronze and black iron, thick as a wri |
| `item.marnadal_roll` | item/document | 04-marnadal-field.md | Muster roll of the Cintran horse, 1263. A waxed roll from a dead captain's satchel under the cairn, the ink mostly sound. |
| `clue.grey_priest_parley` | clue (theory.choir) | 04-marnadal-field.md | The grey priest under the white branch |
| `ded.choir_provoked_marnadal` | deduction | 04-marnadal-field.md | The parley that started a massacre |
| `ms.a2_torc_taken` | milestone | 04-marnadal-field.md | The player lifted Callum's torc from the clan ditch. |
| `flag.torc_rite_known` | flag | 04-marnadal-field.md | The player knows the Strept naming rite. Revenants stop rising again (gdd �6.7). Read by act3 Dun Strept. |
| `flag.new_moon_vigil` | flag | 04-marnadal-field.md | The player chose to keep vigil; the field is in its new-moon variant. Cleared on leaving. |
| `flag.field_rite_performed` | flag | 04-marnadal-field.md | The player spoke the naming rite at the clan stones during the vigil. |
| `flag.held_the_line` | flag | 04-marnadal-field.md | The player fought the charge beside Callum. |
| `flag.champion_grants_torc` | flag | 04-marnadal-field.md | Callum has given leave to take his torc. |
| `flag.odo_met` | flag | 04-marnadal-field.md | Ser Odo's shade has spoken to the player. |
| `flag.odo_stood_down` | flag | 04-marnadal-field.md | Ser Odo stood his ghost riders down; only the foot charges. |
| `flag.rusk_hostile` | flag | 04-marnadal-field.md | Gammer Rusk was driven off or fought. |
| `flag.torc_sold` | flag | 04-marnadal-field.md | The player sold the torc to Rusk. Act III must use Kosk's apology for Hesk. Read by act3 Dun Strept. |
| `zone.witchs_mere` | zone | 05-witchs-mere.md | Witch's Mere |
| `npc.wenna` | npc | 05-witchs-mere.md | Old Wenna: Hedge-witch of the mere, grower of grey lily |
| `npc.pim_reedy` | npc | 05-witchs-mere.md | Pim Reedy: Wenna's great-nephew, a fast rider on a marsh pony |
| `item.wenna_antidote` | item/key | 05-witchs-mere.md | Grey lily counter-dose. A stoppered vial of thin green liquor that smells of river mud and burnt sugar. Wenna's cu |
| `item.harbor_token` | item/key | 05-witchs-mere.md | Attre warehouse tally. A brass tally token stamped with a ship, the number nine, and the Duke of Attre's anchor.  |
| `clue.bulbs_to_attre` | clue (theory.poisoner) | 05-witchs-mere.md | The bulbs went to Attre |
| `clue.wenna_learned_hand` | clue (theory.poisoner) | 05-witchs-mere.md | A learned hand doses the Queen |
| `clue.wenna_sold_priest` | clue (theory.poisoner) | 05-witchs-mere.md | The priest who had rats |
| `ms.a2_wenna_line_resolved` | milestone | 05-witchs-mere.md | Wenna brewed 1-2 doses, or the antidote line failed. Part of the Act II gate. |
| `flag.wenna_met` | flag | 05-witchs-mere.md | The player has met Wenna. |
| `flag.wenna_bulbs_asked` | flag | 05-witchs-mere.md | Wenna has asked for her bulbs (the Wenna line is active). Read by side travel cards L3 and V6. |
| `var.bulbs_recovered` | var | 05-witchs-mere.md | Grey lily bulbs recovered for Wenna. Sources add to it (Attre crates, travel card); the handover sets it to the number actually handed over (Gull Tower bulbs from act1 are counted there). |
| `flag.wenna_told_truth` | flag | 05-witchs-mere.md | The player told Wenna who sent them. |
| `flag.wenna_lied` | flag | 05-witchs-mere.md | Wenna caught the player lying. |
| `flag.wenna_stores_stolen` | flag | 05-witchs-mere.md | The player stole from Wenna's drying rack. |
| `flag.crow_errand` | flag | 05-witchs-mere.md | Wenna asked the player to fetch her crow. |
| `flag.crow_freed` | flag | 05-witchs-mere.md | The player cut Gallows free in the reeds. |
| `flag.crow_thanked` | flag | 05-witchs-mere.md | Wenna has acknowledged the crow's return (+10). |
| `flag.wenna_confessed_priest` | flag | 05-witchs-mere.md | Wenna admitted selling grey lily to a priest. |
| `flag.mere_reeds_cleared` | flag | 05-witchs-mere.md | The drowners in the reeds are dead. |
| `flag.mere_burners_repelled` | flag | 05-witchs-mere.md | The stage-3 Choir burning party was beaten. |
| `flag.wenna_line_failed` | flag | 05-witchs-mere.md | No antidote was brewed. Leads toward the Boy King ending. |
| `var.antidote_doses_brewed` | var | 05-witchs-mere.md | Doses Wenna brewed. |
| `flag.antidote_rider_sent` | flag | 05-witchs-mere.md | A dose went to Cintra with Pim Reedy (send_antidote_rider). |
| `flag.rider_escort_hired` | flag | 05-witchs-mere.md | Jory's boatmen escort the rider; the system's interception rule treats this as an escort (gdd �6.2). |
| `flag.antidote_rider_intercepted` | flag | 05-witchs-mere.md | Set by the system when the rider is intercepted (gdd �6.2). Declared here; read by a2.08. |
| `flag.antidote_administered` | flag | 05-witchs-mere.md | The Queen has received a dose (rider got through, or administer_antidote(queen)). Set by the antidote system; declared here. |
| `flag.antidote_given_maelis` | flag | 05-witchs-mere.md | A dose saved Maelis. |
| `zone.attre_harbor` | zone | 06-attre.md | Attre Harbour |
| `zone.attre_masquerade` | zone | 06-attre.md | The Anchor House |
| `zone.attre_warehouse` | zone | 06-attre.md | Warehouse Nine |
| `npc.raimund` | npc | 06-attre.md | Duke Raimund of Attre: Merchant-prince of the Free Port |
| `npc.aimeric` | npc | 06-attre.md | Aimeric: Raimund's son and heir, nine years old |
| `npc.steward_lucan` | npc | 06-attre.md | Steward Lucan: Steward of the Anchor House |
| `npc.master_corbin` | npc | 06-attre.md | Master Corbin: The Abbey's buyer, Choir agent at the masquerade |
| `npc.velia` | npc | 06-attre.md | Velia: Forger posing as a bookbinder |
| `npc.dame_fenna` | npc | 06-attre.md | Dame Fenna: Harbour chandler |
| `npc.attre_tapster` | npc | 06-attre.md | Coll the tapster: Tapster at the Gilded Gull, rumor source |
| `npc.gaspard` | npc | 06-attre.md | Gaspard: Foreman of Warehouse Nine |
| `npc.pieter` | npc | 06-attre.md | Old Pieter: Night watchman at Warehouse Nine |
| `npc.sergeant_arnaut` | npc | 06-attre.md | Sergeant Arnaut: Commander of the land-gate checkpoint (stage 3) |
| `item.raimund_ledger` | item/document | 06-attre.md | Raimund's private shipping ledger. A calf-bound ledger in the Duke's own hand, kept in his study strongbox. Not the harbour b |
| `item.masquerade_invitation` | item/key | 06-attre.md | Masquerade invitation. Heavy card with the Anchor House seal: the bearer and one mask are welcome at the Duke's a |
| `item.study_key` | item/key | 06-attre.md | Study key. A small brass key on a broken chain link: Raimund's study strongbox. |
| `item.strongroom_key` | item/key | 06-attre.md | Warehouse Nine strongroom key. A heavy iron key from the counting-house nail. |
| `item.raimund_release` | item/document | 06-attre.md | The Duke's release. A slip under the anchor seal ordering Gaspard to release two crates to the bearer. |
| `item.corbin_orders` | item/document | 06-attre.md | Corbin's orders. Choir orders in a fair copy, taken from the Abbey's buyer. |
| `clue.raimund_ledger_silver` | clue (theory.poisoner) | 06-attre.md | Abbey silver paid for the lily |
| `clue.raimund_choir_buyer` | clue (theory.poisoner) | 06-attre.md | The Duke and the gull mask |
| `clue.abbey_silver_ingots` | clue (theory.choir) | 06-attre.md | Abbey bars in a smuggler's strongroom |
| `clue.aimeric_lily_sick` | clue (theory.poisoner) | 06-attre.md | The Duke's son is dying of the lily |
| `ms.a2_attre_ledger` | milestone | 06-attre.md | The player holds Raimund's private ledger (stolen or handed over). |
| `flag.raimund_allied` | flag | 06-attre.md | Raimund made common cause with the Crown. Read by epilogues and act3. |
| `flag.raimund_blackmailed` | flag | 06-attre.md | The player blackmailed Raimund with his ledger. |
| `flag.antidote_sold_raimund` | flag | 06-attre.md | A dose went to Aimeric. Read by a2.08 and the endings. |
| `flag.aimeric_saved` | flag | 06-attre.md | Aimeric received the counter-dose. |
| `flag.aimeric_diagnosed` | flag | 06-attre.md | The player recognised grey lily in Aimeric. |
| `flag.attre_checkpoint_passed` | flag | 06-attre.md | The player got past the stage-3 land-gate checkpoint. |
| `flag.servants_gate_open` | flag | 06-attre.md | The kitchen porter let the player in by the side door. |
| `flag.masquerade_entered` | flag | 06-attre.md | The player entered the masquerade as a guest. |
| `flag.raimund_greeted` | flag | 06-attre.md | Raimund has greeted the player at the ball. |
| `flag.raimund_meeting` | flag | 06-attre.md | Raimund's orangery meeting with Corbin has started. |
| `flag.raimund_meeting_overheard` | flag | 06-attre.md | The player overheard the sale. |
| `flag.masquerade_alarm` | flag | 06-attre.md | The Anchor House alarm was raised. |
| `flag.corbin_exposed` | flag | 06-attre.md | The player unmasked Corbin. |
| `flag.pieter_bribed` | flag | 06-attre.md | The watchman called the yard patrol in for dice. |
| `flag.gaspard_down` | flag | 06-attre.md | Gaspard was seized before he could burn the crates. |
| `flag.warehouse_release` | flag | 06-attre.md | Gaspard received the Duke's release; no raid needed. |
| `flag.warehouse_alarm` | flag | 06-attre.md | The warehouse alarm was raised. |
| `flag.attre_loud_raid` | flag | 06-attre.md | The warehouse raid went loud (Attre -30). |
| `flag.crate_east_taken` | flag | 06-attre.md | East crate looted (+2 bulbs). |
| `flag.crate_west_taken` | flag | 06-attre.md | West crate looted (+2 bulbs). |
| `flag.crate_east_burned` | flag | 06-attre.md | East crate burned by Gaspard. |
| `flag.crate_west_burned` | flag | 06-attre.md | West crate burned by Gaspard. |
| `zone.vel_aram_outer` | zone | 07-vel-aram.md | Vel Aram: Outer Works |
| `zone.vel_aram_sanctum` | zone | 07-vel-aram.md | Vel Aram: The Sanctum |
| `zone.vel_aram_vault` | zone | 07-vel-aram.md | Vel Aram: The Undercroft |
| `npc.prior_ulric` | npc | 07-vel-aram.md | Prior Ulric: Prior of the Vel Aram muster |
| `npc.novice_liss` | npc | 07-vel-aram.md | Novice Liss: Doubting novice who cleans the Abbot's cell |
| `npc.yorek` | npc | 07-vel-aram.md | Yorek: Strept clan scout, prisoner in the stable cage |
| `npc.houndwright_edrin` | npc | 07-vel-aram.md | Houndwright Edrin: Engineer who keeps the soot-hound |
| `npc.brother_aumery` | npc | 07-vel-aram.md | Brother Cellarer Aumery: Former cellarer of St. Corwen, Vel Aram's quartermaster and alchemist |
| `item.anselm_journal` | item/document | 07-vel-aram.md | Anselm's private journal. A worn octavo in a scholar's cramped hand, the covers stained with candle-smoke and wine.  |
| `item.true_fourth_verse` | item/key | 07-vel-aram.md | The authentic fourth verse. A single vellum leaf cut from the Book of the Lion, one edge knife-straight. Gilt initials |
| `item.wyvern_eggs` | item/key | 07-vel-aram.md | Two wyvern eggs. Speckled bronze-green eggs the size of helmets, still warm, wrapped in sacking. Something  |
| `item.cell_key` | item/key | 07-vel-aram.md | The Abbot's cell key. A plain iron key from the Prior's hook. |
| `item.va_muster_roll` | item/document | 07-vel-aram.md | Vel Aram muster roll. The Prior's roll of sworn brothers, by name and by trade. |
| `item.warden_maul` | item/weapon | 07-vel-aram.md | Warden's maul. A long-hafted iron maul from a pre-Cintran captain's tomb, its head cut with a ring-and-mo |
| `item.warden_tablet` | item/document | 07-vel-aram.md | Warden's slate. A slate tablet from the warden's tomb, scratched in an older script that Lore can half-rea |
| `clue.anselm_journal` | clue (theory.anselm_plan) | 07-vel-aram.md | The Abbot's own hand |
| `clue.reversed_oath` | clue (theory.anselm_plan) | 07-vel-aram.md | The Pact spoken backward |
| `clue.soot_hound_origin` | clue (theory.anselm_plan) | 07-vel-aram.md | A gate-hound out of Ostrel |
| `clue.cellarer_brewed_lily` | clue (theory.poisoner) | 07-vel-aram.md | The cellarer's tincture |
| `clue.throne_sketch` | clue (theory.anselm_plan) | 07-vel-aram.md | The chamber with the mirror-shafts |
| `ded.anselm_treason_proven` | deduction | 07-vel-aram.md | Abbot Anselm is the traitor |
| `ded.reversed_oath_plan` | deduction | 07-vel-aram.md | The lock is a key |
| `ms.a2_vel_aram_cleared` | milestone | 07-vel-aram.md | The player took the true fourth verse from Vel Aram's reliquary; the muster marches. |
| `flag.trip_line_cut` | flag | 07-vel-aram.md | The barbican bell-line is cut. |
| `flag.yorek_freed` | flag | 07-vel-aram.md | Yorek the Strept scout was freed (Strept +10; naming rite). Read by a2.04 and act3 Dun Strept. |
| `flag.postern_found` | flag | 07-vel-aram.md | The player found the capstone under the well (the sunken postern). |
| `flag.va_outer_alarm` | flag | 07-vel-aram.md | The outer works raised the alarm; the muster engaged. |
| `flag.va_left_after_clear` | flag | 07-vel-aram.md | Internal: the muster-marches beat has played. |
| `flag.va_sermon_seen` | flag | 07-vel-aram.md | Prior Ulric's sermon played. |
| `flag.va_sanctum_alarm` | flag | 07-vel-aram.md | The sanctum raised the alarm. |
| `flag.bell_rope_cut` | flag | 07-vel-aram.md | The bell rope was cut; no reinforcements from the ward. |
| `flag.powder_blown` | flag | 07-vel-aram.md | The cellarer's powder kegs exploded. |
| `flag.prior_ulric_dead` | flag | 07-vel-aram.md | Prior Ulric fell. |
| `flag.liss_turned` | flag | 07-vel-aram.md | Novice Liss was persuaded of the truth. |
| `flag.liss_left` | flag | 07-vel-aram.md | Liss left for the mill or for Maelis. Read by act3 or side (Maelis knows more). |
| `flag.cellarer_dealt` | flag | 07-vel-aram.md | Aumery was stopped, fooled or fought. |
| `flag.eggs_lost` | flag | 07-vel-aram.md | Aumery cracked the eggs; the wyvern cannot be placated in Act III. Read by act3 Wyvern's Roost. |
| `flag.edrin_dealt` | flag | 07-vel-aram.md | The Houndwright was talked down, frightened off or seized. |
| `flag.hound_awake` | flag | 07-vel-aram.md | The soot-hound woke. |
| `flag.soot_hound_dormant` | flag | 07-vel-aram.md | The furnace damper was closed; the hound sleeps. |
| `flag.soot_hound_slain` | flag | 07-vel-aram.md | The soot-hound was destroyed. |
| `flag.cell_open` | flag | 07-vel-aram.md | Anselm's cell door is open (key, lock check, or after the milestone). |
| `flag.reliquary_open` | flag | 07-vel-aram.md | The reliquary door is open. |
| `flag.reliquary_by_postern` | flag | 07-vel-aram.md | The reliquary was opened from the secret postern. |
| `flag.cistern_cleared` | flag | 07-vel-aram.md | The cistern drowners are dead. |
| `flag.tunnel_collapsed` | flag | 07-vel-aram.md | The escape crawl collapsed behind the player. |
| `zone.abbey_catacombs` | zone | 08-return-and-twist.md | The Catacombs of St. Corwen |
| `npc.hew` | npc | 08-return-and-twist.md | Hew: Palace kitchen boy, bribed to open the kitchen passage |
| `item.anselm_last_letter` | item/document | 08-return-and-twist.md | Anselm's letter to the Queen. Sealed, addressed 'To Ysolde, after', in the empty niche carved with his name. |
| `clue.guards_drugged` | clue (theory.choir) | 08-return-and-twist.md | Wine from the kitchens |
| `clue.aldric_catacomb_mark` | clue (theory.anselm_plan) | 08-return-and-twist.md | OSTREL, in a boy's hand |
| `clue.anselm_route_stairs` | clue (theory.anselm_plan) | 08-return-and-twist.md | To the mountain before the sun turns |
| `ms.a2_return_cintra` | milestone | 08-return-and-twist.md | The player returned to Cintra with the Act II gate met. Not an Act II progress milestone; it fires the pending rider resolution. |
| `ms.act2_twist` | milestone | 08-return-and-twist.md | Aldric's abduction is discovered. Escalation stage 4. |
| `flag.twist_started` | flag | 08-return-and-twist.md | The twist sickroom scene has begun. |
| `flag.queen_alive` | flag | 08-return-and-twist.md | The Queen survives the twist (= flag.antidote_administered at the resolution). Read by the endings. |
| `flag.aldric_co_sovereign` | flag | 08-return-and-twist.md | Ysolde invested Aldric herself (alive, condition <= 2). |
| `flag.aldric_emergency_writ` | flag | 08-return-and-twist.md | Kosk invested Aldric by emergency writ (Queen alive but comatose). |
| `flag.aldric_crowned_king` | flag | 08-return-and-twist.md | The Queen died; Kosk crowned Aldric king. |
| `flag.aldric_warned` | flag | 08-return-and-twist.md | The player warned Aldric about Anselm and the words. Flavor for act3 finale lines. |
| `flag.raimund_ledger_published` | flag | 08-return-and-twist.md | Kosk published Raimund's ledger (Attre -30, or -60 and alliance broken). |
| `flag.oil_wire_cut` | flag | 08-return-and-twist.md | The catacomb oil trip-wire was cut. |
| `flag.oil_trap_sprung` | flag | 08-return-and-twist.md | Internal: the player walked into the oil trap's gallery without cutting it. |
| `flag.rearguard_beaten` | flag | 08-return-and-twist.md | The Choir rear guard in the catacombs is beaten. |
| `flag.hew_spared` | flag | 08-return-and-twist.md | Hew the kitchen boy was spared to testify. |
| `flag.hew_killed` | flag | 08-return-and-twist.md | Hew was killed. |

## Local dialogues and encounters

| ids | kind | defined in | meaning |
|---|---|---|---|
| `dlg.tigg_mob`, `dlg.reeve_hobb`, `dlg.godric`, `dlg.marga`, `dlg.ailsa`, `dlg.ned_thanks`, `dlg.aske`, `dlg.aske_open` | dialogue | 01-tigg-crossroads.md | Local dialogues of this section |
| `enc.tigg_wyvern`, `enc.tigg_wolves`, `enc.aske_unmasked`, `enc.tigg_proclaimers` | encounter | 01-tigg-crossroads.md | Local encounters of this section |
| `dlg.oswy_seized`, `dlg.oswy_parley`, `dlg.oswy_brother` | dialogue | 02-hanged-mans-oak.md | Local dialogues of this section |
| `enc.oak_escort`, `enc.oak_escort_reinforced`, `enc.oak_courier_chase` | encounter | 02-hanged-mans-oak.md | Local encounters of this section |
| `dlg.bollard_gate`, `dlg.jory`, `dlg.jory_yielded`, `dlg.marit` | dialogue | 03-ferrymen-camp.md | Local dialogues of this section |
| `enc.weir_drowners`, `enc.ferry_camp_assault`, `enc.ferry_choir_agents` | encounter | 03-ferrymen-camp.md | Local encounters of this section |
| `dlg.vigil_choice`, `dlg.callum_darrach`, `dlg.odo_vane`, `dlg.gammer_rusk` | dialogue | 04-marnadal-field.md | Local dialogues of this section |
| `enc.marnadal_charge`, `enc.marnadal_footmen`, `enc.field_bone_pickers`, `enc.field_choir_column` | encounter | 04-marnadal-field.md | Local encounters of this section |
| `dlg.wenna`, `dlg.wenna_doses`, `dlg.pim` | dialogue | 05-witchs-mere.md | Local dialogues of this section |
| `enc.mere_drowners`, `enc.mere_drowners_dark`, `enc.mere_burners` | encounter | 05-witchs-mere.md | Local encounters of this section |
| `dlg.attre_checkpoint`, `dlg.velia`, `dlg.attre_porter`, `dlg.raimund_ball`, `dlg.raimund_terrace`, `dlg.raimund_ally_gifts`, `dlg.lucan`, `dlg.corbin`, `dlg.aimeric`, `dlg.pieter`, `dlg.gaspard_seized`, `dlg.gaspard_release` | dialogue | 06-attre.md | Local dialogues of this section |
| `enc.attre_checkpoint`, `enc.masquerade_alarm`, `enc.corbin_unmasked`, `enc.warehouse_yard`, `enc.warehouse_hall`, `enc.warehouse_alarm` | encounter | 06-attre.md | Local encounters of this section |
| `dlg.prior_ulric`, `dlg.liss`, `dlg.yorek`, `dlg.houndwright`, `dlg.aumery` | dialogue | 07-vel-aram.md | Local dialogues of this section |
| `enc.va_sentries`, `enc.va_patrol_a`, `enc.va_muster`, `enc.va_patrol_b`, `enc.va_prior`, `enc.va_bell_reinforcements`, `enc.va_reagent`, `enc.va_soot_hound`, `enc.va_cistern_drowners` | encounter | 07-vel-aram.md | Local encounters of this section |
| `dlg.twist_kosk`, `dlg.twist_investiture`, `dlg.twist_abduction`, `dlg.hew_yields`, `dlg.twist_sluice` | dialogue | 08-return-and-twist.md | Local dialogues of this section |
| `enc.catacomb_rearguard` | encounter | 08-return-and-twist.md | Local encounters of this section |

## Spawns other slices exit into

| zone / spawn | used by |
|---|---|
| `zone.witchs_mere` / `from_hollow` | side/08 `zone.wenna_scrying_hollow` exit `up_to_hut` |
| `zone.abbey_catacombs` / `abbey_gate` | act1/04 `zone.abbey_st_corwen` exit `to_catacombs` |
| `zone.abbey_catacombs` / `palace_stair` | act1/03 sickroom twist exit (integration patch in a2.08) |
| `zone.attre_harbor` / `quay`, `land_gate` | sea and land arrivals (side: Skerra cutter, Morrow Gull boat) |

## Enemy variants used (rows needed in enemy data; no new archetypes)

| enemy | variant | used in | meaning |
|---|---|---|---|
| `enemy.choir_thug` | `courier` | 02 | Brother Oswy: lower HP, no combo, flees, yields early |
| `enemy.choir_thug` | `alchemist` | 07 | Brother Cellarer Aumery: throws poison flasks |
| `enemy.choir_zealot` | `prior` | 07 | Prior Ulric: about 140 HP, fervour from the start, never yields |
| `enemy.bandit` | `sword`, `spear`, `shield` | 03, 04, 06 | gdd §6.7 variants; Attre ducal guards and Jory's crew use them |

## Map nodes used (gdd §7.5)

`map.tigg`, `map.hanged_mans_oak`, `map.ferrymen_camp`, `map.marnadal_field`, `map.witchs_mere`, `map.attre`, `map.vel_aram`, `map.cintra`, `map.grey_ferry` (pin), `map.stairs_foot` (pin at the end of Act II).

## Expected from other slices

| id | kind | expected owner | why this slice needs it |
|---|---|---|---|
| `ms.act1_complete`, `quest.main_a2` (started by act1/08) | milestone, quest | A04 | Every Act II section's `available_when`; the master stage |
| `npc.kosk`, `npc.ysolde`, `npc.aldric`, `npc.varn`, `npc.maelis`, `npc.anselm`, `companion.maelis` | npc, companion | A04 | Twist speakers, Maelis branches |
| `zone.palace_sickroom` plus the integration patch in a2.08 (spawn `twist_door`, interactable `give_antidote_by_hand`, trigger `twist_return`, beats `queen_dies`, `investiture`, `night_falls`, `bells_at_night`, variant `twist_night`, exit `to_catacombs`) | zone | A04 | The twist runs in act1's sickroom |
| `zone.abbey_st_corwen` / spawn `catacomb_gate` | zone | A04 | Catacomb exit up into the Abbey |
| `zone.gull_tower` | zone | A04 | `visited()` check in Velia's dialogue |
| `item.kosk_writ`, `item.pale_feather`, `item.grey_lily_bulbs`, `item.poultice`, `item.antitoxin`, `item.fire_oil`, `item.smoke_pot`, `item.crossbow_bolt` | item | A04 | Conditions, shops, loot |
| `clue.chalice_pollen`, `clue.courier_foam`, `clue.catacomb_hinges`, `clue.marnadal_chaplain`, `ded.choir_exists`, `ded.poison_via_attre` | clue, deduction | A04 | Conditions. `ded.poison_via_attre` must accept `clue.raimund_ledger_silver` (declared here) |
| `flag.aldric_promise`, `flag.aldric_trusts_player`, `flag.aldric_guard_doubled` | flag | A04 | Twist lines (tailless-lion mark, Aldric's trust, the beaten guard) |
| `flag.kosk_badge_worn` | flag (system) | inventory system | Callum Darrach refuses the player while the writ is worn as a badge. act3/02 treats the badge as a check modifier only; the inventory should maintain this flag |
| `flag.maelis_poisoned`, `flag.maelis_dead` | flag (system) | escalation / companion system (gdd §6.2, §6.13) | Wenna's Maelis dose; twist branches |
| `flag.choir_list_exposed` | flag | A07 (side/02) | Rider interception warning |
| `flag.skerra_cutter` | flag | A07 (side/05) | Attre stage-3 checkpoint bypass |
| `quest.side_bertha_debt`, `dlg.jory_bertha_debt` | quest, dialogue | A07 (side/01) | Jory's hub option chains into it |
| `quest.side_wenna_hair`, `dlg.wenna_hair_offer`, `zone.wenna_scrying_hollow` / spawn `from_hut` | quest, dialogue, zone | A07 (side/08) | Wenna's hub option chains into it; islet exit |
| `rumor.r03_dragon_amell`, `rumor.r07_iron_crates`, `rumor.r08_new_moon_dead`, `rumor.r09_aldric_dwarven` | rumor | A07 (side/14) | `verify_rumor` in a2.01, a2.03, a2.04, a2.08 |
| `event.ford_marnadal` | event card | A07 (side/13) | Ford hazard on `ferrymen_camp — marnadal_field` (removed by `flag.jory_crossing_granted`) |
| `quest.main_a3`, `map.stairs_foot` | quest, map | A06 | Started and pinned at the end of a2.08 (act3/01 also starts it defensively; keep one owner) |
| `flag.maelis_recruited` | flag | A04 / A07 | Not read here, but act3 reads it; this slice uses `in_party(companion.maelis)` |
| `perk.kingmaker`, `faction.*`, `theory.*`, `enemy.*` | data | design / systems | gdd-named data ids |

## Ids other slices read from this slice

| id | read by | why |
|---|---|---|
| `flag.wyvern_fought`, `flag.wyvern_driven_by_smoke`, `item.wyvern_eggs`, `flag.eggs_lost` | act3/05 | How the wyvern was turned at Tigg; eggs for the Roost |
| `item.marnadal_torc`, `flag.torc_rite_known`, `flag.torc_sold`, `flag.yorek_freed`, `ded.choir_provoked_marnadal` | act3/02 | Hesk, the cairn rite, a freed scout's word |
| `item.true_fourth_verse`, `ded.reversed_oath_plan`, `clue.reversed_oath`, `clue.soot_hound_origin` | act3/06, act3/07, side | The Oath; the finale |
| `flag.queen_alive`, `flag.aldric_co_sovereign`, `flag.aldric_emergency_writ`, `flag.aldric_crowned_king`, `flag.aldric_warned` | act3, endings | Twist outcome |
| `flag.raimund_allied`, `flag.raimund_blackmailed`, `flag.antidote_sold_raimund`, `flag.aimeric_saved`, `flag.raimund_ledger_published` | endings | Attre epilogue |
| `flag.antidote_administered`, `flag.antidote_rider_sent`, `flag.antidote_rider_intercepted`, `flag.rider_escort_hired`, `flag.wenna_bulbs_asked`, `var.bulbs_recovered`, `item.wenna_antidote` | antidote system, side/08, side/13 | gdd §6.2 |
| `item.anselm_cipher`, `item.forged_dispatch`, `item.choir_robe`, `item.masquerade_invitation`, `item.raimund_ledger`, `item.anselm_journal` | side, act3 | gdd §6.9 key items (defined here) |
| `flag.liss_left`, `flag.oswy_witness` | act3 / side (flavor) | Witnesses who reached Cintra or Maelis |

## Possible duplicates for reconciliation

- `clue.marnadal_chaplain`: declared by act1/02. This slice only adds it (Ser Odo, Anselm's stole). Not redeclared.
- `item.grey_lily_bulbs`: declared by act1/06. Not redeclared. `var.bulbs_recovered` is declared here (a2.05).
- `item.masquerade_invitation`, `item.choir_robe`: declared here (a2.06, a2.02). Side/01 (Bertha) gives the invitation and should reference it.
- `flag.antidote_administered`, `flag.antidote_rider_intercepted`: declared here (a2.05) although the antidote system sets them. They could move to a system declarations file.
- `item.field_draught`, `item.frost_tallow`: declared here (a2.01, the first Act II shop). act1 declares the other consumables.
- Name collisions avoided with other slices: Jory's lieutenant is **Bollard** (side/12 has "Old Kettle"), the weir widow is **Marit** (act1 has the maid Ilse), the Tigg drover is **Ned** (side/13 has Wat Mabry), the falconer is **Godric**, the rider is **Pim Reedy** (side/05 has Tam Corley), the cellarer is **Aumery** (side/01 has "Sallow" Mott), Wenna's crow is **Gallows** (side/08), and the Marnadal champion is **Callum Darrach** of Darrach Hall (act3/02's torc; side/12 has the miner Brannoc).
