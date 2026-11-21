# Act I slice: ids

Slice: `docs/content/act1/` (A04). Every id this slice defines, so the reconciliation pass can merge and de-duplicate, followed by the ids this slice needs from other slices.
Local ids (dialogue nodes, areas, spawns, beats, checkpoints, option ids, enemy `variant` names) are not listed. "(gdd-named)" marks ids that `gdd.md` already names; this slice is where they are first declared.

## Section files

| section_id | file | quest contribution |
|---|---|---|
| `a1.01` | `01-drowned-rat.md` | `quest.main_a1` order 10 (`survive_the_rat`) |
| `a1.02` | `02-audience-at-court.md` | order 30 (`audience`, `follow_the_leads`) |
| `a1.03` | `03-sickroom-red-herring.md` | objective `sickroom` |
| `a1.04` | `04-abbey-st-corwen.md` | objective `abbey` |
| `a1.05` | `05-ring-of-nine.md` | objective `ring` |
| `a1.06` | `06-gull-tower.md` | objective `gull` (optional) |
| `a1.07` | `07-harvest-fair.md` | order 50 (`the_fair`) |
| `a1.08` | `08-act1-transition.md` | order 60 (`orders_south`); `set_act(2)`, `start_quest(quest.main_a2)` |

## New ids defined in this slice

| id | kind | defined in | meaning |
|---|---|---|---|
| `ms.a1_rat_survived` | milestone (gdd-named) | 01-drowned-rat.md | The player survived the Drowned Rat (fight, talk-down, or flight). |
| `ms.a1_audience_done` | milestone (gdd-named) | 02-audience-at-court.md | Kosk hired the player and gave the Marshal's writ. |
| `ms.a1_sickroom_done` | milestone (gdd-named) | 03-sickroom-red-herring.md | Chalice evidence found and the Varn red herring resolved (won or lost). |
| `ms.a1_abbey_done` | milestone (gdd-named) | 04-abbey-st-corwen.md | The player has seen the sliced Book, received the false verse, and learned that only Anselm holds the key. |
| `ms.a1_ring_done` | milestone (gdd-named) | 05-ring-of-nine.md | The player read the split stone at the Ring of Nine. |
| `ms.a1_gull_done` | milestone (gdd-named) | 06-gull-tower.md | The player learned the Gull Tower crates hold grey lily from Attre. |
| `ms.act1_complete` | milestone (gdd-named) | 07-harvest-fair.md | Act I complete: Aldric saved at the Fair, the Choir's trail found. Escalation stage 1. |
| `flag.courier_entered` | bool | 01-drowned-rat.md | The courier has stumbled into the Drowned Rat (beat courier_stumbles_in). |
| `flag.courier_dead` | bool | 01-drowned-rat.md | The courier has died (beat courier_dies or courier_dies_alone). |
| `flag.letter_taken` | bool | 01-drowned-rat.md | The player holds Dravin's letter (from the body or from Bertha). |
| `flag.letter_read` | bool | 01-drowned-rat.md | The player broke the iron-wax and read the letter in the tavern. |
| `flag.thugs_arrived` | bool | 01-drowned-rat.md | The Choir thugs kicked in the Drowned Rat's door. |
| `var.rat_thugs_left` | int | 01-drowned-rat.md | Thugs still in the fight after talk (3, 2 or 1). Read by the mudflats pursuit. |
| `flag.rat_thug_scared` | bool | 01-drowned-rat.md | One thug fled from Intimidate or the poison argument. |
| `flag.rat_thug_bribed` | bool | 01-drowned-rat.md | One thug took 30 crowns and walked. |
| `flag.rat_fought` | bool | 01-drowned-rat.md | The player won the tavern fight (or ended it by a yield). |
| `flag.rat_fled` | bool | 01-drowned-rat.md | The player fled through the cellar onto the mudflats. |
| `flag.rat_thug_spared` | bool | 01-drowned-rat.md | The player spared a yielding thug. |
| `flag.rat_thug_executed` | bool | 01-drowned-rat.md | The player killed a yielding thug in front of Bertha. |
| `flag.bertha_thanked` | bool | 01-drowned-rat.md | Bertha's after-fight conversation has played. |
| `flag.bertha_tended` | bool | 01-drowned-rat.md | Bertha patched the player up (full heal, once). |
| `flag.tab_paid` | bool | 01-drowned-rat.md | The player paid Bertha's 3-crown tab before the trouble (flavor; A07 may read it). |
| `flag.thugs_on_ladder` | bool | 01-drowned-rat.md | Pursuing thugs are climbing down the Margery's ladder. |
| `flag.ladder_cut` | bool | 01-drowned-rat.md | The player cut the Margery's ladder; the pursuers are stuck in the mud. |
| `flag.thugs_landed` | bool | 01-drowned-rat.md | Pursuing thugs reached the mud and engaged. |
| `flag.wick_helped` | bool | 01-drowned-rat.md | Wick showed the safe path along the weir tops. |
| `flag.bertha_at_docks` | bool | 01-drowned-rat.md | Bertha brought the forgotten letter to the docks. |
| `flag.brask_met` | bool | 01-drowned-rat.md | Sergeant Brask has met the player on the docks. |
| `flag.summoned_by_kosk` | bool | 01-drowned-rat.md | Brask summoned the player to the palace; opens the palace gate in zone.cintra_streets. |
| `flag.told_council_monk` | bool | 02-audience-at-court.md | The player told the council the courier was poisoned by a monk (Anselm heard it). |
| `flag.varn_rattled` | bool | 02-audience-at-court.md | The player rattled Varn in open council. |
| `flag.passes_closed_known` | bool | 02-audience-at-court.md | Kosk explained the closed passes and Ostrel's gate. |
| `flag.varn_approached` | bool | 02-audience-at-court.md | Varn made his antechamber offer. |
| `flag.varn_retainer` | bool | 02-audience-at-court.md | The player took Varn's 20-crown retainer. |
| `flag.varn_smells_smoke` | bool | 02-audience-at-court.md | The player noticed smoke and ink on Varn (foreshadows the ledger burning). |
| `flag.saw_varn_cord` | bool | 02-audience-at-court.md | The player noticed the palace guards' Chancellery cord. |
| `flag.met_aldric` | bool | 02-audience-at-court.md | The player met Aldric in the cloister garden. |
| `var.aldric_bond` | int | 02-audience-at-court.md | Aldric's personal trust in the player across Act I. >= 3 sets flag.aldric_trusts_player at the Fair. |
| `flag.aldric_promised_truth` | bool | 02-audience-at-court.md | The player promised Aldric the truth about his mother. |
| `flag.heard_aldric_words` | bool | 02-audience-at-court.md | Aldric recited Anselm's 'dwarvish patience words' to the player (foreshadows the reversed Oath). |
| `flag.hair_leave` | bool | 02-audience-at-court.md | Kosk gave leave to take a lock of the Queen's hair (Presence 5). |
| `flag.varn_exposed` | bool | 02-audience-at-court.md | The player turned Varn's ledger over to Kosk. |
| `flag.kosk_warned_of_anselm` | bool | 02-audience-at-court.md | The player told Kosk that Anselm's verse is false. |
| `flag.varn_ambush_done` | bool | 02-audience-at-court.md | The once-only hub ambush by Varn's toughs (Varn Hostile after stage 1, gdd §6.12) has fired. Encounter in 08-act1-transition.md. |
| `flag.anselm_suspects_player` | bool | 02-audience-at-court.md | The player confronted Anselm with the false verse; he knows they suspect him. |
| `flag.chalice_secured` | bool (gdd-named) | 03-sickroom-red-herring.md | Kosk's men guard the Queen's chalice and wine (mitigation 1, gdd §6.2). |
| `flag.food_taster_exposed` | bool (gdd-named) | 03-sickroom-red-herring.md | Pell the food-taster is exposed (mitigation 2, gdd §6.2). Also set by the Morrow Gull tube (A07). |
| `flag.pell_arrested` | bool | 03-sickroom-red-herring.md | Pell was taken by Kosk's men (any confrontation route). |
| `flag.pell_confessed` | bool | 03-sickroom-red-herring.md | Pell confessed to being paid to skip the wine. |
| `flag.pell_choir_words` | bool | 03-sickroom-red-herring.md | Pell repeated 'the Choir sings for the dead kings' (Intimidate 8). |
| `flag.queen_confided` | bool | 03-sickroom-red-herring.md | The Queen told the player what the Oath protects. |
| `flag.aldric_sickroom_done` | bool | 03-sickroom-red-herring.md | Aldric scene 2 (window seat) has played. |
| `flag.aldric_mirror_words` | bool | 03-sickroom-red-herring.md | The player noticed Aldric's 'patience words' are written mirror-wise (Lore 8). Foreshadows the reversed Oath; A05/A06 may read it. |
| `flag.varn_light_seen` | bool | 03-sickroom-red-herring.md | The player knows Varn burns something in his solar at night; opens the Chancellery. |
| `flag.varn_alerted` | bool | 03-sickroom-red-herring.md | Varn knows he is being hunted; the chase is on. |
| `flag.varn_red_handed` | bool | 03-sickroom-red-herring.md | The player reached the solar unseen and caught Varn at the brazier. |
| `flag.carriage_gone` | bool | 03-sickroom-red-herring.md | Varn's carriage was sent away; the chase cannot be lost. |
| `flag.varn_chase_won` | bool | 03-sickroom-red-herring.md | Varn was caught (chase or red-handed). |
| `flag.varn_chase_lost` | bool | 03-sickroom-red-herring.md | Varn escaped in his carriage (soft fail: no blackmail; solar re-search available). |
| `flag.varn_blackmailed` | bool (gdd-named) | 03-sickroom-red-herring.md | The player blackmails Varn (gdd §6.1 stage 1 exemption, §6.12). |
| `flag.varn_spared` | bool | 03-sickroom-red-herring.md | The player let Varn go and kept his secret for free. |
| `flag.maelis_showed_book` | bool | 04-abbey-st-corwen.md | Maelis showed the sliced Book of the Lion. |
| `flag.maelis_accused` | bool | 04-abbey-st-corwen.md | The player accused Maelis of cutting the Book (Abbey -15; blocks her trust route). |
| `flag.maelis_whispered` | bool | 04-abbey-st-corwen.md | Maelis said aloud that only Anselm holds the key. |
| `flag.maelis_note_pending` | bool | 04-abbey-st-corwen.md | Maelis refused to talk and slipped a note into the player's satchel (given at the gate). |
| `flag.cut_examined` | bool | 04-abbey-st-corwen.md | The player examined the cut closely (Investigate 4). |
| `flag.lock_unforced_seen` | bool | 04-abbey-st-corwen.md | The player confirmed the reliquary lock was opened with its key. |
| `flag.ambrose_feather_seen` | bool | 04-abbey-st-corwen.md | The player spotted the feather in Brother Ambrose's cowl (Investigate 8). A05 may read it at the twist. |
| `flag.sorrel_met` | bool | 05-ring-of-nine.md | Grandmother Sorrel's conversation has played. |
| `flag.sorrel_lantern` | bool | 05-ring-of-nine.md | Sorrel lent her lantern (lights the tar ditch without fire oil). |
| `flag.sorrel_helped` | bool | 05-ring-of-nine.md | Sorrel gave the lantern freely; her spare pots (fire oil) open. |
| `flag.hounds_lured` | bool | 05-ring-of-nine.md | Half the pack is busy with the drover's beef. |
| `flag.tar_ring_lit` | bool | 05-ring-of-nine.md | The tar ditch is burning; half the pack won't cross. |
| `flag.ring_hounds_done` | bool | 05-ring-of-nine.md | The hounds are beaten or held off; the split stone can be read. |
| `flag.ring_hounds_engaged` | bool | 05-ring-of-nine.md | The hound fight is running (stops re-triggering when the player steps in and out of the circle; cleared if the player flees the zone). |
| `flag.ring_hounds_avoided` | bool | 05-ring-of-nine.md | The player avoided the hound fight entirely (lure and fire). |
| `flag.ring_runes_read` | bool | 05-ring-of-nine.md | The player read the dwarven runes (Lore 6): the Ring is a valve. |
| `flag.gull_yard_clear` | bool | 06-gull-tower.md | The smugglers in the yard are dealt with. |
| `flag.gull_cellar_clear` | bool | 06-gull-tower.md | Seixal's crew in the cellar is dealt with (any route). |
| `flag.gull_yard_engaged` | bool | 06-gull-tower.md | The yard fight is running (no re-trigger); cleared if the player flees. |
| `flag.gull_cellar_engaged` | bool | 06-gull-tower.md | The cellar fight is running (no re-trigger of Seixal's parley); cleared if the player flees. |
| `flag.keeper_examined` | bool | 06-gull-tower.md | The player examined the keeper's wounds (Investigate 4). |
| `flag.dorada_cut` | bool | 06-gull-tower.md | The player cut the smugglers' lugger loose. |
| `flag.seixal_bribed` | bool | 06-gull-tower.md | The player took Seixal's 50 crowns and let him sail with the crates (no bulbs). |
| `flag.seixal_captured` | bool | 06-gull-tower.md | Seixal surrendered and was handed to the Crown. A05 may use him as a witness in Attre. |
| `flag.seixal_dead` | bool | 06-gull-tower.md | Seixal was killed. |
| `flag.gull_bulbs_taken` | bool | 06-gull-tower.md | The player took the 2 good bulbs (item.grey_lily_bulbs x2). |
| `flag.gull_bulbs_burned` | bool | 06-gull-tower.md | The player burned the last crates. |
| `flag.nessa_saved` | bool | 06-gull-tower.md | Nessa Harrow came down from the lamp room. |
| `flag.gull_beacon_lit` | bool | 06-gull-tower.md | The Gull Tower beacon is relit (Crown +5). |
| `flag.fair_announced` | bool | 07-harvest-fair.md | Kosk has announced the Fair ride. |
| `flag.fair_started` | bool | 07-harvest-fair.md | The player accepted the ride: point of no return for Act I leads 3-5. |
| `flag.fair_dissuade_tried` | bool | 07-harvest-fair.md | The player tried to talk Aldric out of riding. |
| `flag.aldric_close_guard` | bool | 07-harvest-fair.md | Aldric rides close to Hale (dissuaded, or the Wren watched): his pony does not bolt. |
| `flag.fair_briefed` | bool | 07-harvest-fair.md | Kosk's briefing at the gate has played. |
| `flag.fair_roof_watch` | bool | 07-harvest-fair.md | Kosk's crossbowmen hold the granary roof. |
| `flag.grease_found` | bool | 07-harvest-fair.md | The grease casks were found and removed (no fire). |
| `flag.hanka_told` | bool | 07-harvest-fair.md | Hanka admitted a stranger paid her to store casks. |
| `flag.wren_unmasked` | bool | 07-harvest-fair.md | The player unmasked the Wren before the procession. |
| `flag.wren_watched` | bool | 07-harvest-fair.md | Brask's man is watching the Wren. |
| `flag.procession_started` | bool | 07-harvest-fair.md | The procession has begun. |
| `flag.fair_strike_begun` | bool | 07-harvest-fair.md | The Choir's strike has begun. |
| `flag.fair_fight_over` | bool | 07-harvest-fair.md | The Fair fight is over. |
| `flag.fair_assassin_captured` | bool | 07-harvest-fair.md | The Wren was captured alive for Kosk. |
| `flag.fair_assassin_killed` | bool | 07-harvest-fair.md | The Wren was killed. |
| `flag.aldric_trusts_player` | bool | 07-harvest-fair.md | Aldric trusts the player personally (var.aldric_bond >= 3 at the Fair). For the Act II twist and Act III finale. |
| `flag.aldric_guard_doubled` | bool | 08-act1-transition.md | Kosk ordered a guard present whenever Anselm sees Aldric (A05: the twist must explain how the guard was bribed or drugged). |
| `flag.varn_toll_pass` | bool | 08-act1-transition.md | Varn (Friendly) sent 150 crowns and a toll pass (gdd §6.12: Act II pass on the toll road). |
| `flag.aldric_farewell_done` | bool | 08-act1-transition.md | Aldric's farewell scene has played. |
| `flag.aldric_promise` | bool | 08-act1-transition.md | Aldric promised to leave a tailless-lion sign if taken at night. A05: scratched lions mark the catacomb trail at the twist. |
| `flag.maelis_joined_a1` | bool | 08-act1-transition.md | Maelis joined the party at the end of Act I. |
| `flag.maelis_stays_watch` | bool | 08-act1-transition.md | The player asked Maelis to stay and watch the Abbey (letters via Bertha). |
| `npc.bertha` | npc | 01-drowned-rat.md | Bertha: Innkeeper of the Drowned Rat |
| `npc.courier` | npc | 01-drowned-rat.md | Tomas Wyle, royal courier: A royal courier of the Crown's southern post, poisoned on the road |
| `npc.rat_thug_leader` | npc | 01-drowned-rat.md | Cobb Rennet: Docks bruiser hired by the Pale Choir to recover the courier's letter |
| `npc.old_fenn` | npc | 01-drowned-rat.md | Old Fenn: An eel-man and the Rat's oldest regular |
| `npc.mudlark_wick` | npc | 01-drowned-rat.md | Wick: Mudlark girl who scavenges the flats |
| `npc.sergeant_brask` | npc | 01-drowned-rat.md | Sergeant Oda Brask: Lord Marshal Kosk's sergeant; runs his private patrol on the docks |
| `npc.kosk` | npc | 02-audience-at-court.md | Lord Marshal Bertran Kosk: Lord Marshal of Cintra, commander of the royal army |
| `npc.varn` | npc | 02-audience-at-court.md | Chancellor Orsik Varn: Chancellor of Cintra, keeper of the treasury and the river tolls |
| `npc.anselm` | npc (gdd-named) | 02-audience-at-court.md | Abbot Anselm of St. Corwen: Abbot of St. Corwen and the Queen's confessor |
| `npc.ysolde` | npc | 02-audience-at-court.md | Queen Ysolde: Queen of Cintra |
| `npc.aldric` | npc | 02-audience-at-court.md | Prince Aldric: Crown Prince of Cintra, twelve years old |
| `npc.corporal_hesse` | npc | 02-audience-at-court.md | Corporal Hesse: Palace gate guard on the Chancellery's quiet payroll |
| `npc.marta_kell` | npc | 02-audience-at-court.md | Goodwife Marta Kell: General trader at Cintra Market |
| `npc.ballad_seller` | npc | 02-audience-at-court.md | Tam Fiddle, ballad-seller: Sings the news in the market square for coppers |
| `npc.pell` | npc | 03-sickroom-red-herring.md | Pell: Royal food-taster |
| `npc.cook_marit` | npc | 03-sickroom-red-herring.md | Marit, head cook: Head cook of the palace kitchens |
| `npc.scullion_jeb` | npc | 03-sickroom-red-herring.md | Jeb: Scullion boy |
| `npc.physician_fell` | npc | 03-sickroom-red-herring.md | Master Idris Fell: Royal physician |
| `npc.maid_ilse` | npc | 03-sickroom-red-herring.md | Ilse: The Queen's maid |
| `npc.tobiah_quill` | npc | 03-sickroom-red-herring.md | Tobiah Quill: Chancellor Varn's private clerk |
| `npc.mossy_driver` | npc | 03-sickroom-red-herring.md | Mossy: Varn's carriage driver |
| `npc.maelis` | npc | 04-abbey-st-corwen.md | Sister Maelis: Archivist of St. Corwen |
| `npc.brother_ambrose` | npc | 04-abbey-st-corwen.md | Brother Ambrose: Porter of St. Corwen; carries the Queen's communion wine to the palace |
| `npc.grandmother_sorrel` | npc | 05-ring-of-nine.md | Grandmother Sorrel: Tar-gatherer who sells the Ring's ooze as lamp oil |
| `npc.seixal` | npc | 06-gull-tower.md | Joaquim Seixal: Captain of the Attre lugger Dorada; smuggler on the Duke's coast run |
| `npc.nessa_harrow` | npc | 06-gull-tower.md | Nessa Harrow: Widow of Gull Tower's keeper |
| `npc.wren` | npc | 07-harvest-fair.md | The Wren: Pale Choir assassin, ringleader of the Fair attack |
| `npc.hanka` | npc | 07-harvest-fair.md | Hanka, oil-seller: Oil and tallow seller at the fair |
| `npc.reeve_matthis` | npc | 07-harvest-fair.md | Reeve Matthis of Chociebuż: Reeve of Chociebuż, master of the Harvest Fair |
| `item.dravin_letter` | item/key (gdd-named) | 01-drowned-rat.md | Dravin's iron-wax dispatch |
| `item.courier_seal` | item/document | 01-drowned-rat.md | Royal courier's seal |
| `item.arming_sword` | item/weapon (gdd-named) | 01-drowned-rat.md | Arming sword |
| `item.gambeson` | item/armor | 01-drowned-rat.md | Quilted gambeson |
| `item.crossbow` | item/weapon | 01-drowned-rat.md | Hunting crossbow |
| `item.crossbow_bolt` | item/ammo | 01-drowned-rat.md | Crossbow bolt |
| `item.poultice` | item/consumable | 01-drowned-rat.md | Poultice |
| `item.kosk_writ` | item/key (gdd-named) | 02-audience-at-court.md | Marshal's writ |
| `item.antitoxin` | item/consumable | 02-audience-at-court.md | Antitoxin |
| `item.fire_oil` | item/consumable | 02-audience-at-court.md | Fire oil |
| `item.smoke_pot` | item/consumable | 02-audience-at-court.md | Smoke pot |
| `item.cintran_mace` | item/weapon | 02-audience-at-court.md | Watchman's mace |
| `item.brigandine` | item/armor | 02-audience-at-court.md | Brigandine |
| `item.varn_ledger_scrap` | item/document (gdd-named) | 03-sickroom-red-herring.md | Half-burned toll ledger |
| `item.ysolde_hair` | item/key (gdd-named) | 03-sickroom-red-herring.md | Lock of the Queen's hair |
| `item.pell_purse` | item/document | 03-sickroom-red-herring.md | Pell's altar-linen purse |
| `item.false_fourth_verse` | item/document (gdd-named) | 04-abbey-st-corwen.md | Anselm's 'copy' |
| `item.verses_copy` | item/document | 04-abbey-st-corwen.md | Maelis's fair copy |
| `item.maelis_note` | item/document | 04-abbey-st-corwen.md | Maelis's note |
| `item.drover_haunch` | item/key | 05-ring-of-nine.md | Side of salt beef |
| `item.grey_lily_bulbs` | item/key (gdd-named) | 06-gull-tower.md | Grey lily bulbs |
| `item.gull_keeper_log` | item/document | 06-gull-tower.md | Gull Tower keeper's log |
| `item.gull_bill_of_lading` | item/document | 06-gull-tower.md | Port Peixe manifest |
| `item.pale_feather` | item/key (gdd-named) | 07-harvest-fair.md | Pale gull feather |
| `item.route_map_oak` | item/document (gdd-named) | 07-harvest-fair.md | Route map to Hanged Man's Oak |
| `item.aldric_lion` | item/trinket | 07-harvest-fair.md | Aldric's wooden lion |
| `item.varn_toll_pass` | item/document | 08-act1-transition.md | Chancellery toll pass |
| `clue.courier_foam` | clue/theory.poisoner (gdd-named) | 01-drowned-rat.md | Froth at the courier's mouth |
| `clue.thug_silver` | clue/theory.choir | 01-drowned-rat.md | Paid in new silver and vellum |
| `clue.ostrel_bolts` | clue/theory.anselm_plan | 01-drowned-rat.md | The lower bolts are grinding loose |
| `clue.marnadal_chaplain` | clue/theory.anselm_plan (gdd-named) | 02-audience-at-court.md | Chaplain at Marnadal |
| `clue.chalice_pollen` | clue/theory.poisoner (gdd-named) | 03-sickroom-red-herring.md | Pollen in the Queen's chalice |
| `clue.communion_wine` | clue/theory.poisoner | 03-sickroom-red-herring.md | The untasted communion wine |
| `clue.taster_gold` | clue/theory.poisoner (gdd-named) | 03-sickroom-red-herring.md | Pell's new gold |
| `clue.varn_ledgers` | clue/theory.poisoner (gdd-named) | 03-sickroom-red-herring.md | Varn's burning ledgers |
| `clue.queen_knows_vaults` | clue/theory.poisoner (gdd-named) | 03-sickroom-red-herring.md | The Queen knows what the Oath is for |
| `clue.abbey_silver_tolls` | clue/theory.choir | 03-sickroom-red-herring.md | Abbey silver on the river |
| `clue.book_sliced` | clue/theory.fourth_verse (gdd-named) | 04-abbey-st-corwen.md | The fourth verse, sliced out |
| `clue.only_anselm_key` | clue/theory.fourth_verse (gdd-named) | 04-abbey-st-corwen.md | Only the Abbot holds the key |
| `clue.anselm_sermons` | clue/theory.anselm_plan | 04-abbey-st-corwen.md | The Abbot's sermons |
| `clue.bell_rope_wax` | clue/theory.choir | 04-abbey-st-corwen.md | Beeswax on the bell ropes |
| `clue.catacomb_hinges` | clue/theory.anselm_plan | 04-abbey-st-corwen.md | Oiled hinges in the crypt |
| `clue.ring_true_chisel` | clue/theory.fourth_verse (gdd-named) | 05-ring-of-nine.md | The split stone's true chiselling |
| `clue.ring_tar` | clue/theory.anselm_plan | 05-ring-of-nine.md | The weeping stone |
| `clue.monks_at_ring` | clue/theory.choir | 05-ring-of-nine.md | Monks at the split stone |
| `clue.gull_bulbs` | clue/theory.poisoner (gdd-named) | 06-gull-tower.md | Grey lily through Attre Light |
| `clue.pale_feather` | clue/theory.choir (gdd-named) | 07-harvest-fair.md | The pale feather |
| `clue.route_map_oak` | clue/theory.choir (gdd-named) | 07-harvest-fair.md | A map to Hanged Man's Oak |
| `ded.varn_thief_not_poisoner` | deduction (gdd-named) | 03-sickroom-red-herring.md | Varn is a thief, not a poisoner |
| `ded.taster_is_bought` | deduction (gdd-named) | 03-sickroom-red-herring.md | The taster has been bought |
| `ded.anselm_lied` | deduction (gdd-named) | 05-ring-of-nine.md | Anselm's verse is false |
| `ded.poison_via_attre` | deduction (gdd-named) | 06-gull-tower.md | The poison came through Attre |
| `ded.choir_exists` | deduction (gdd-named) | 07-harvest-fair.md | The Pale Choir is real |
| `zone.drowned_rat` | zone (gdd-named) | 01-drowned-rat.md | The Drowned Rat |
| `zone.cintra_mudflats` | zone (gdd-named) | 01-drowned-rat.md | The Mudflats under Eel Row |
| `zone.cintra_docks` | zone (gdd-named) | 01-drowned-rat.md | Eel Row and the Fishmarket |
| `zone.cintra_streets` | zone (gdd-named) | 02-audience-at-court.md | Cintra |
| `zone.palace_hall` | zone (gdd-named) | 02-audience-at-court.md | The Lion Hall |
| `zone.palace_sickroom` | zone (gdd-named) | 03-sickroom-red-herring.md | The Queen's Sickroom |
| `zone.palace_kitchens` | zone (gdd-named) | 03-sickroom-red-herring.md | The Palace Kitchens |
| `zone.chancellery_rooftops` | zone (gdd-named) | 03-sickroom-red-herring.md | The Chancellery by Night |
| `zone.abbey_st_corwen` | zone (gdd-named) | 04-abbey-st-corwen.md | The Abbey of St. Corwen |
| `zone.ring_of_nine` | zone (gdd-named) | 05-ring-of-nine.md | The Ring of Nine |
| `zone.gull_tower` | zone (gdd-named) | 06-gull-tower.md | Gull Tower |
| `zone.gull_tower_cellar` | zone (gdd-named) | 06-gull-tower.md | Gull Tower Cellar and Sea Cave |
| `zone.chociebuz_fair` | zone (gdd-named) | 07-harvest-fair.md | The Chociebuż Harvest Fair |
| `enc.rat_thugs` | encounter | 01-drowned-rat.md | 1x enemy.choir_thug, 2x enemy.choir_thug |
| `enc.rat_thugs_two` | encounter | 01-drowned-rat.md | 1x enemy.choir_thug, 1x enemy.choir_thug |
| `enc.rat_thugs_one` | encounter | 01-drowned-rat.md | 1x enemy.choir_thug |
| `enc.mudflats_crossbow` | encounter | 01-drowned-rat.md | 1x enemy.choir_crossbowman |
| `enc.mudflats_thugs` | encounter | 01-drowned-rat.md | 2x enemy.choir_thug |
| `enc.mudflats_thug` | encounter | 01-drowned-rat.md | 1x enemy.choir_thug |
| `enc.chancellery_guards` | encounter | 03-sickroom-red-herring.md | 1x enemy.bandit, 1x enemy.bandit |
| `enc.ring_hounds` | encounter | 05-ring-of-nine.md | 3x enemy.feral_hound + waves |
| `enc.ring_hounds_small` | encounter | 05-ring-of-nine.md | 2x enemy.feral_hound, 1x enemy.feral_hound |
| `enc.gull_yard` | encounter | 06-gull-tower.md | 2x enemy.bandit, 1x enemy.choir_crossbowman |
| `enc.gull_cellar` | encounter | 06-gull-tower.md | 1x enemy.bandit, 2x enemy.bandit |
| `enc.fair_strike` | encounter | 07-harvest-fair.md | 2x enemy.choir_assassin, 2x enemy.choir_cutthroat + waves |
| `enc.fair_strike_watched` | encounter | 07-harvest-fair.md | 2x enemy.choir_assassin, 2x enemy.choir_cutthroat + waves |
| `enc.fair_wren_early` | encounter | 07-harvest-fair.md | 1x enemy.choir_assassin, 2x enemy.choir_cutthroat + waves |
| `enc.hub_varn_ambush` | encounter | 08-act1-transition.md | 2x enemy.choir_thug, 1x enemy.bandit |
| `dlg.courier_dying` | dialogue | 01-drowned-rat.md | npc.courier |
| `dlg.letter_read` | dialogue | 01-drowned-rat.md | npc.bertha |
| `dlg.bertha` | dialogue | 01-drowned-rat.md | npc.bertha |
| `dlg.rat_thugs_standoff` | dialogue | 01-drowned-rat.md | npc.rat_thug_leader, npc.bertha |
| `dlg.rat_thug_yield` | dialogue | 01-drowned-rat.md | npc.rat_thug_leader |
| `dlg.old_fenn` | dialogue | 01-drowned-rat.md | npc.old_fenn |
| `dlg.wick_weirs` | dialogue | 01-drowned-rat.md | npc.mudlark_wick |
| `dlg.brask_docks` | dialogue | 01-drowned-rat.md | npc.sergeant_brask, npc.bertha |
| `dlg.audience_council` | dialogue | 02-audience-at-court.md | npc.ysolde, npc.kosk, npc.varn, npc.anselm, npc.sergeant_brask |
| `dlg.kosk_hire` | dialogue | 02-audience-at-court.md | npc.kosk |
| `dlg.kosk` | dialogue | 02-audience-at-court.md | npc.kosk |
| `dlg.varn_antechamber` | dialogue | 02-audience-at-court.md | npc.varn |
| `dlg.varn` | dialogue | 02-audience-at-court.md | npc.varn |
| `dlg.anselm` | dialogue | 02-audience-at-court.md | npc.anselm |
| `dlg.ysolde` | dialogue | 02-audience-at-court.md | npc.ysolde |
| `dlg.aldric_garden` | dialogue | 02-audience-at-court.md | npc.aldric |
| `dlg.aldric` | dialogue | 02-audience-at-court.md | npc.aldric |
| `dlg.hesse` | dialogue | 02-audience-at-court.md | npc.corporal_hesse |
| `dlg.marta_kell` | dialogue | 02-audience-at-court.md | npc.marta_kell |
| `dlg.ballad_seller` | dialogue | 02-audience-at-court.md | npc.ballad_seller |
| `dlg.ysolde_sickroom` | dialogue | 03-sickroom-red-herring.md | npc.ysolde |
| `dlg.kosk_chalice` | dialogue | 03-sickroom-red-herring.md | npc.kosk |
| `dlg.aldric_sickroom` | dialogue | 03-sickroom-red-herring.md | npc.aldric |
| `dlg.pell` | dialogue | 03-sickroom-red-herring.md | npc.pell |
| `dlg.cook_marit` | dialogue | 03-sickroom-red-herring.md | npc.cook_marit |
| `dlg.scullion_jeb` | dialogue | 03-sickroom-red-herring.md | npc.scullion_jeb |
| `dlg.physician_fell` | dialogue | 03-sickroom-red-herring.md | npc.physician_fell |
| `dlg.mossy_driver` | dialogue | 03-sickroom-red-herring.md | npc.mossy_driver |
| `dlg.varn_caught` | dialogue | 03-sickroom-red-herring.md | npc.varn |
| `dlg.maelis_book` | dialogue | 04-abbey-st-corwen.md | npc.maelis |
| `dlg.anselm_false_verse` | dialogue | 04-abbey-st-corwen.md | npc.anselm, npc.maelis |
| `dlg.maelis_whisper` | dialogue | 04-abbey-st-corwen.md | npc.maelis |
| `dlg.maelis` | dialogue | 04-abbey-st-corwen.md | npc.maelis |
| `dlg.ambrose` | dialogue | 04-abbey-st-corwen.md | npc.brother_ambrose |
| `dlg.sorrel` | dialogue | 05-ring-of-nine.md | npc.grandmother_sorrel |
| `dlg.seixal` | dialogue | 06-gull-tower.md | npc.seixal |
| `dlg.seixal_yield` | dialogue | 06-gull-tower.md | npc.seixal |
| `dlg.gull_crates_choice` | dialogue | 06-gull-tower.md | npc.nessa_harrow |
| `dlg.nessa` | dialogue | 06-gull-tower.md | npc.nessa_harrow |
| `dlg.kosk_fair_announce` | dialogue | 07-harvest-fair.md | npc.kosk, npc.aldric |
| `dlg.kosk_fair_briefing` | dialogue | 07-harvest-fair.md | npc.kosk, npc.sergeant_brask |
| `dlg.wren_chestnuts` | dialogue | 07-harvest-fair.md | npc.wren, npc.sergeant_brask |
| `dlg.hanka` | dialogue | 07-harvest-fair.md | npc.hanka |
| `dlg.wren_downed` | dialogue | 07-harvest-fair.md | npc.wren, npc.kosk |
| `dlg.aldric_after_fair` | dialogue | 07-harvest-fair.md | npc.aldric, npc.kosk |
| `dlg.kosk_orders_south` | dialogue | 08-act1-transition.md | npc.kosk, npc.varn, npc.sergeant_brask |
| `dlg.aldric_farewell` | dialogue | 08-act1-transition.md | npc.aldric |
| `dlg.maelis_joins` | dialogue | 08-act1-transition.md | npc.maelis |

## Enemy variants used (for enemy data)

All base enemy ids come from gdd §6.7. These `variant` names need entries in enemy data:

| enemy | variant | used in | meaning |
|---|---|---|---|
| `enemy.choir_thug` | `leader` | 01 | Cobb Rennet: same stats, voice set, scripted barks |
| `enemy.choir_thug` | `varn_tough` | 08 | Varn's hub ambushers: Chancellery cord, no feather |
| `enemy.choir_crossbowman` | `quay_walker` | 01 | Confined to the quay path above the mudflats; cannot be reached in melee |
| `enemy.choir_crossbowman` | `attre_smuggler` | 06 | Attre look; no generic crossbow bandit exists |
| `enemy.bandit` | `hired_guard` | 03, 08 | L3, 55 HP, 10 blunt, armor 10, cudgel and lantern |
| `enemy.bandit` | `smuggler_cudgel`, `smuggler_knife`, `smuggler_captain` | 06 | L3/L3/L4 smugglers; captain = Seixal (75 HP, yields readily) |
| `enemy.feral_hound` | `mastiff` | 05 | x1.5 HP and poise, slower |
| `enemy.choir_assassin` | `wren` | 07 | Ringleader: +30% HP, scripted downed-not-dead at 0 HP, flees to the ford below 30% |

## Map nodes used (gdd §7.5; owned by design / the map data)

`map.cintra`, `map.chociebuz` (unlocked in 07), `map.gull_tower` (pinned in 02), `map.tigg`, `map.attre`, `map.ferrymen_camp` (unlocked in 08), `map.witchs_mere` (pinned in 06 and 08), `map.hanged_mans_oak` (pinned in 07 and 08).

## Ids other slices will want to read

| id | why |
|---|---|
| `var.aldric_bond`, `flag.aldric_trusts_player`, `item.aldric_lion` | Aldric's personal loyalty from Act I (brief: pays off at the Act II twist and the finale) |
| `flag.aldric_promise` | Aldric promised to scratch a tailless lion wherever he is taken at night: a trail for A05's catacomb chase |
| `flag.heard_aldric_words`, `flag.aldric_mirror_words` | Foreshadowing of the reversed Oath (Anselm's "patience words") |
| `flag.aldric_guard_doubled` | Kosk put a guard on Anselm's visits; A05's twist should explain how it was beaten |
| `flag.anselm_suspects_player`, `flag.kosk_warned_of_anselm` | Anselm knows the player suspects him / Kosk was told |
| `flag.ambrose_feather_seen`, `npc.brother_ambrose` | Ambrose (Choir, combat `enemy.choir_zealot`) is a natural catacomb-twist accomplice |
| `clue.catacomb_hinges` | The catacomb gate is in use (twist route) |
| `flag.maelis_joined_a1`, `flag.maelis_stays_watch`, `flag.maelis_accused` | Maelis's state entering Act II |
| `item.grey_lily_bulbs` (x2), `flag.gull_bulbs_taken`, `flag.gull_bulbs_burned` | Gull Tower bulbs for Wenna (+2, gdd §6.9) |
| `flag.seixal_captured`, `flag.seixal_bribed`, `item.gull_bill_of_lading` | Attre leverage / witness for A05's Attre section |
| `flag.varn_blackmailed`, `flag.varn_exposed`, `flag.varn_spared`, `flag.varn_toll_pass`, `item.varn_toll_pass` | Varn's fate (epilogue) and his Act II toll pass (gdd §6.12) |
| `flag.chalice_secured`, `flag.food_taster_exposed` | Queen mitigations (gdd §6.2) |
| `item.ysolde_hair`, `flag.hair_leave` | A07's Wenna hair quest; obtainable in Act II through `dlg.kosk` (hair option) and the sickroom hairbrush |
| `clue.abbey_silver_tolls`, `clue.monks_at_ring`, `clue.bell_rope_wax`, `clue.anselm_sermons` | Extra Choir / Anselm evidence; A05 may use them in proof dialogues |
| `item.dravin_letter`, `item.kosk_writ`, `item.false_fourth_verse`, `item.verses_copy` | Key documents carried into Acts II-III |
| `dlg.kosk`, `dlg.anselm`, `dlg.maelis`, `dlg.aldric`, `dlg.bertha` | Default router dialogues; later slices may add branches or chain from them |

## Expected from other slices

| id | kind | expected owner | why this slice needs it |
|---|---|---|---|
| `zone.drowned_rat_yard` (spawn `from_rat`), `zone.drowned_rat_loft` (spawn `from_taproom`), `flag.bertha_safehouse` | zone, flag | A07 | Exits `back_door` and `loft_stairs` from `zone.drowned_rat` (as A07 requested) |
| `dlg.bertha_debt_offer` | dialogue | A07 | Bertha's `regular_hub/troubles` option chains into the debt quest; rename to A07's actual opening dialogue if different |
| `zone.abbey_scriptorium` (spawn `cloister_door`), `quest.side_abbey_ledgers`, `dlg.maelis_ledgers_offer` | zone, quest, dialogue | A07 | Abbey cloister exit and Maelis's ledger offer (as A07 requested) |
| `clue.taster_dispatch` | clue | A07 | `ded.taster_is_bought` accepts it (as A07 requested) |
| `rumor.r02_varn_ledgers` | rumor | A07 | Story rumor 2; opens the Chancellery from the hub and is marked heard when the Varn chase is lost. Rename if A07's id differs |
| `zone.abbey_catacombs` (spawn `abbey_gate`), `ms.act2_twist` | zone, milestone | A05 | Abbey crypt exit after the twist; Abbey and palace variants |
| `quest.main_a2` | quest | A05 | Started in 08 |
| `clue.raimund_ledger_silver` | clue | A05 | Alternative condition of `ded.poison_via_attre` (gdd §6.11) |
| `var.bulbs_recovered` | var | A05 | Mentioned only in item text; A05 counts the Gull bulbs when returned |
| `companion.maelis`, `ally.aldric`, `enemy.anselm_human`, `faction.*`, `theory.*`, `perk.keen_eye` | data | design / systems | gdd-named data ids referenced by this slice |

## Possible duplicates for reconciliation

- `item.grey_lily_bulbs`: declared here (06, first source). A07's `_ids.md` expects it from A05; A05 may declare it too.
- `clue.pale_feather`: declared in 07; also granted in 03 (Pell's boot) and 04 (Ambrose's hem). A07 uses a separate `clue.pilgrim_feather`.
- `clue.marnadal_chaplain`: gdd-named; declared here in 02 (Kosk). A05 may also declare it.
- `item.poultice`, `item.antitoxin`, `item.fire_oil`, `item.smoke_pot`, `item.crossbow_bolt`, starting gear (`item.arming_sword`, `item.gambeson`, `item.crossbow`): declared here because the new game starts in 01 and the first shop is in 02. Other slices should reference, not redeclare.
- `flag.food_taster_exposed`: declared here (03); A07's Morrow Gull sets it too (reference only).
