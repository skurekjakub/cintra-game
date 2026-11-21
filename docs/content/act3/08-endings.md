---
section_id: a3.08
title: "Endings"
act: 3
story_ref: "story.md §9 Campaign Endings; gdd §6.15 endings resolver and epilogue variants, §8.3 (slides beyond 3 per ending are cut candidates)"
zones: [zone.ko_lock_chamber]
available_when: "ms(ms.a3_finale_done)"
escalation_stage_required: {min: 4, max: 4}
milestones_set: [ms.game_complete]
milestones_read: [ms.a3_finale_done]
level_band: [12, 12]
---

# Endings

## 1. Scene summary
When the finale resolves, a short **closing scene** plays in the Lock Chamber, in whatever state the fight left it: sealed and still, commanded and kneeling, or torn open and venting. Aldric, and Dravin and Maelis if present, react to what happened. Then the **epilogue** plays: narrated slides **[ART]**. Each ending has three core slides, followed by variant slides chosen by flags (the Queen, Strept, Attre, the court and Varn, Maelis, Dravin, the wyvern, Sodden, Anselm's fate), and a closing slide about the player. The ending is chosen by `EndingResolver` (gdd §6.15) from the finale record and `flag.queen_alive`. Each variant slide is chosen by its own condition. Ending the epilogue sets `ms.game_complete` and returns the player to the main menu with a completion save.

## 2. Progress and escalation
- **Resolver** (gdd §6.15, first match wins):

| # | Ending | id | Condition (finale record) |
|---|---|---|---|
| 1 | The Bitter Bargain | `ending.bitter_bargain` | `finale_seized()` |
| 2 | The Shattered Lock | `ending.shattered_lock` | `finale_oath() == reversed and finale_anselm() == dead` |
| 3 | Ashes & Iron | `ending.ashes_and_iron` | `finale_oath() == reversed and finale_anselm() == fled` |
| 4 | The Lion Holds | `ending.lion_holds` | `finale_oath() == true and flag(flag.queen_alive)` |
| 5 | The Boy King | `ending.boy_king` | `finale_oath() == true and not flag(flag.queen_alive)` |

- **How each is reached** (a3.07): a True Oath win gives 4 or 5, depending on the antidote line in Act II. Commanding the vault (with the Rite and Dravin) gives 1. A lost race gives 2 if the player pursues Anselm or killed him earlier, and 3 if the player shields Aldric and Anselm escapes.
- **Slide selection** (`EpilogueSelector`): play the ending's core slides (orders 10–30) in order, then every variant slide whose condition holds, in ascending `order`, then the ending's closing slide (order 900). Slides marked "cut candidate" may be dropped under schedule pressure (gdd §8.3).
- `ms.game_complete` is set at the end of the closing dialogue, before the slides. It fires no escalation, because stage 4 is the cap.

## 3. Location layout
The closing scene uses `zone.ko_lock_chamber` (a3.07) in its post-finale state. No new zone. Staging by outcome:
- **Sealed:** gold light from all four mirror-shafts on the throne; the vents silent; wardens frozen mid-step around the floor; Choir weapons on the plates.
- **Commanded:** every warden in the room kneeling toward the throne; the vault door half-open and still; Dravin's Key standing in the throne's socket.
- **Shattered:** the vault door torn open; the rift in the north wall breathing black vapour; wreckage. The player stands at the rift's lip with Anselm gone below.
- **Ashes:** the same rupture, with the collapsed vent stack over the place where the player shielded Aldric; dust; the rift empty.
- **Escape variant (Anselm already dead):** the closing scene plays in the Hall of Mirrors with the great door shut behind them, smoke leaking under it.

## 4. NPCs present
No new NPCs. Speakers: `npc.aldric`, `npc.dravin` (if `flag.dravin_recruited`), `npc.maelis` (if `flag.maelis_recruited and not flag.maelis_dead`), and `npc.anselm` (if captured alive, or dying).

## 5. Dialogue trees

### 5.1 Closing scene

```yaml dialogue
id: dlg.a3_closing
participants: [npc.aldric, npc.dravin, npc.maelis, npc.anselm]
start: open
nodes:
  open:
    type: branch
    cases:
      - {if: "finale_seized()", next: seized_open}
      - {if: "finale_oath() == true", next: sealed_open}
      - {if: "finale_oath() == reversed and finale_anselm() == dead", next: shattered_open}
    else: ashes_open
  sealed_open:
    type: line
    speaker: npc.aldric
    text: "It's quiet. It's never been quiet in here. Is it... did I say it right? All four?"
    direction: "Kneeling at the horn, crown slipping, staring at the gold light."
    effects: ["play_beat(closing_still)"]
    next: sealed_anselm
  sealed_anselm:
    type: branch
    cases:
      - {if: "finale_anselm() == alive", next: sealed_anselm_alive}
      - {if: "finale_anselm() == dead and finale_oath() == true", next: sealed_anselm_dying}
    else: sealed_dravin
  sealed_anselm_alive:
    type: line
    speaker: npc.anselm
    text: "You said it beautifully, Your Highness. Nineteen more winters of the same. Well. I'll pray for you. Someone should."
    direction: "Sitting on the dais steps, the knife at his feet, hands folded."
    next: sealed_dravin
  sealed_anselm_dying:
    type: line
    speaker: npc.anselm
    text: "Cold. Isn't that odd. All that fire, and I'm cold. Tell the Queen... no. Tell no one anything. Let them guess."
    direction: "An old man in a burned habit on the iron floor, the ash gone out of him."
    next: sealed_dravin
  sealed_dravin:
    type: branch
    cases:
      - {if: "flag(flag.dravin_recruited)", next: sealed_dravin_line}
    else: sealed_maelis
  sealed_dravin_line:
    type: line
    speaker: npc.dravin
    text: "Twenty-second notch. I'll cut it myself. My grandfather's grandfather would've wept. Dwarves do weep, sword. We just do it in private, and practically."
    next: sealed_maelis
  sealed_maelis:
    type: branch
    cases:
      - {if: "flag(flag.maelis_recruited) and not flag(flag.maelis_dead)", next: sealed_maelis_line}
    else: sealed_queen
  sealed_maelis_line:
    type: line
    speaker: npc.maelis
    text: "I'll write it down. All of it. The right way round, this time."
    next: sealed_queen
  sealed_queen:
    type: branch
    cases:
      - {if: "flag(flag.queen_alive)", next: sealed_queen_alive}
    else: sealed_queen_dead
  sealed_queen_alive:
    type: line
    speaker: npc.aldric
    text: "I want to go home. I want to tell Mother I did it. She'll pretend she isn't proud. Take me home, {player}."
    next: finish
  sealed_queen_dead:
    type: line
    speaker: npc.aldric
    text: "She's dead, isn't she. Mother. You'd have said. You'd have said by now. ...Then I'm the king. Take me home, {player}. I've a kingdom to be frightened of."
    next: finish
  seized_open:
    type: branch
    cases:
      - {if: "flag(flag.aldric_coerced)", next: seized_coerced}
    else: seized_willing
  seized_willing:
    type: line
    speaker: npc.aldric
    text: "They're kneeling. All of them. To me. {player}, do you hear the vault? It's waiting for me to say something. What should I say?"
    direction: "His hand still on the throne's iron, eyes very bright."
    next: seized_dravin
  seized_coerced:
    type: line
    speaker: npc.aldric
    text: "There. It's done. It's yours, isn't it, really. You'll be standing behind me for the rest of my life, telling me what to say to them."
    direction: "He takes his hand off the throne as if it burned him, and doesn't look at the player."
    next: seized_dravin
  seized_dravin:
    type: line
    speaker: npc.dravin
    text: "Four hundred years my line waited to hand that Key to a king. Not for this. Leave it in the socket. I'll not touch it again."
    next: finish
  shattered_open:
    type: line
    speaker: npc.aldric
    text: "He's gone. He's dead. Good. Then why is it still breathing? {player}, what came out? What came out of there?"
    direction: "At the rift's lip, the vault's black breath rolling past them up into the mountain."
    next: shattered_dravin
  shattered_dravin:
    type: branch
    cases:
      - {if: "flag(flag.dravin_recruited)", next: shattered_dravin_line}
    else: finish
  shattered_dravin_line:
    type: line
    speaker: npc.dravin
    text: "Casks. Engines. Wardens with no throne to answer to. Half the deep vault, scattering down every tunnel to the light. We've a long walk ahead, sword. Hunting."
    next: finish
  ashes_open:
    type: line
    speaker: npc.aldric
    text: "You came for me. Not him. You let him go to come for me."
    direction: "Dragged out from under the player, grey with dust, the crown dented."
    next: ashes_more
  ashes_more:
    type: line
    speaker: npc.aldric
    text: "He's out there now. Breathing that stuff. With everything that came out of the door. ...Thank you. I'm going to hate you for it a little, later. I'm sorry."
    next: ashes_dravin
  ashes_dravin:
    type: branch
    cases:
      - {if: "flag(flag.dravin_recruited)", next: ashes_dravin_line}
    else: finish
  ashes_dravin_line:
    type: line
    speaker: npc.dravin
    text: "The valley's below us. Everything that came out of that door is going downhill. So are we, and faster. Move."
    next: finish
  finish:
    type: effect
    effects: ["reach_milestone(ms.game_complete)", "play_beat(epilogue_begins)"]
    next: bye
  bye:
    type: end
```

### 5.2 Epilogue slides
Format: one heading per slide, its `id` (`epilogue.<ending>_<nn>_<slug>`), `order`, `condition` (content-format §C, endings calls allowed), an **[ART]** note, then the narration (voiced; subtitled). Slides 10–30 are core. The 9xx slide closes. Everything in between is a variant.

#### Shared variant pool
Each variant lists its applicability inside its condition. Shared variants sit at orders 100–700, so they always come after an ending's core slides.

---

#### The Lion Holds (`ending.lion_holds`)

**`epilogue.lion_holds_10_the_lock_holds`** · order 10 · condition `"true"`
*[ART] The Lock Chamber from above, four gold shafts on the Black Iron Throne; a small figure in a crown kneeling at the horn.*
> The bolts drove home one after another, and the mountain held its breath again. In Karak Ostrel's tally hall there is a twenty-second notch now, cut fresh beside a boy's name. Nineteen winters. It is not forever. It was never meant to be.

**`epilogue.lion_holds_20_the_queen_mends`** · order 20 · condition `"true"`
*[ART] Ysolde at a palace window in early spring, a cane, a shawl, her hand on the sill.*
> Ysolde lived. The lily came out of her slowly, the way it went in, and for a long time she could not hold a cup. By the thaw she walked the length of the long gallery on a cane, and the court watched her do it and remembered whose kingdom it was.

**`epilogue.lion_holds_30_hardened`** · order 30 · condition `"true"`
*[ART] Aldric in a plain coat, older in the face than his years, at the war-room table with Kosk; the riding gloves on the map.*
> Aldric came home hardened beyond his twelve years. He sat at the Marshal's table and asked questions nobody wanted to answer, and kept asking. When they granted {player} a title and lands, it was the boy who chose the words on the patent. He chose them carefully.

**`epilogue.lion_holds_900_close`** · order 900 · condition `"true"`
*[ART] {player} on the Marnadal Stairs in summer, the switchbacks green with moss, looking up toward the Old Grey Matron.*
> They called {player} the Warden of the Stairs, which was a title the court invented and the clans found very funny. Every few years, {player} climbed the Stairs alone to the Weeping Gate, and stood there, and listened. The mountain was quiet. It is quiet still. For now.

---

#### The Boy King (`ending.boy_king`)

**`epilogue.boy_king_10_sealed`** · order 10 · condition `"true"`
*[ART] The sealed vault door, gold light fading; Aldric walking out of the chamber small between the kneeling wardens.*
> The vaults were sealed, and the boy who sealed them walked out of the mountain a king. He was twelve. He had a crown that was too big for him and a kingdom that was too big for anyone.

**`epilogue.boy_king_20_funeral`** · order 20 · condition `"true"`
*[ART] Ysolde's funeral in the Abbey of St. Corwen, a new abbot, Aldric alone at the bier in the crown.*
> They buried Ysolde in St. Corwen, under a new abbot who did not give a sermon. Aldric stood at the bier for the whole of the vigil and did not let anyone take his arm. Afterward he went straight to the council chamber, because there was no one else to go.

**`epilogue.boy_king_30_regency`** · order 30 · condition `"true"`
*[ART] Kosk and Varn on opposite sides of the council table, a boy in the middle chair; through the window, Attre's banners on a far coast.*
> Kosk and Varn fought over the regency before the funeral bells had stopped. Down the coast, Duke Raimund took the news of the Queen's death as he had always meant to, as a signal. The war Anselm wanted came anyway, in the end. It was only smaller, and slower, and made of men.

**`epilogue.boy_king_900_close`** · order 900 · condition `"true"`
*[ART] {player} kneeling before Aldric in the throne room, receiving a sword; the boy's hands steady.*
> The boy king's first act was to name {player} his sword, the one blade in Cintra he could be certain of. It was not a reward. It was a sentence. {player} served it.

---

#### The Shattered Lock (`ending.shattered_lock`)

**`epilogue.shattered_lock_10_buckled`** · order 10 · condition `"true"`
*[ART] The vault door buckled half open, black breath pouring up through the mountain's tunnels into grey daylight.*
> The vault doors buckled open, but not all the way. What the dwarves had sealed for four hundred years came out in a single breath: war-engines that walked by themselves, casks of blight in their iron cradles, and the last of the Choir, laughing in the vapour.

**`epilogue.shattered_lock_20_scatter`** · order 20 · condition `"true"`
*[ART] A Strept goat path with a stranded iron-warden on it, frost on its shoulders; below, a valley village with a burned field in a dead-straight line.*
> They scattered across the borderlands that winter. A warden found walking a goat path with no throne to answer to. A cask cracked open in a Marnadal ditch, and a dead-straight line of withered crops running away from it toward the sea.

**`epilogue.shattered_lock_30_anselm_dead`** · order 30 · condition `"true"`
*[ART] The rift's lip; a burned scrap of habit on the iron.*
> Anselm died in the breath he had opened the door for. Nobody found the body, and nobody looked very hard. His sermons were burned in the Abbey yard on the Marshal's orders, and copied out by hand in a dozen cellars before the ash was cold.

**`epilogue.shattered_lock_900_close`** · order 900 · condition `"true"`
*[ART] {player} and a small company on the road with a cart carrying a chained, dormant warden; Sodden riders watching from a ridge.*
> {player} spent the next years on the road, hunting what had come out of the mountain before Sodden could claim it. There was always one more cask. There was always someone willing to pay for it. Cintra survived. It learned to sleep lightly.

---

#### Ashes & Iron (`ending.ashes_and_iron`)

**`epilogue.ashes_and_iron_10_rupture`** · order 10 · condition `"true"`
*[ART] Karak Ostrel's main portal from the valley, soot pouring out of it like smoke from a chimney the size of a mountain.*
> Karak Ostrel ruptured. For three days the Old Grey Matron smoked like a forge, and then the things that had been breathing in the dark for four hundred years began to come down the valleys.

**`epilogue.ashes_and_iron_20_valley`** · order 20 · condition `"true"`
*[ART] Soot-choked constructs walking through Tigg in the snow; villagers fleeing across the crossroads.*
> Soot-choked constructs walked into Tigg and stood in the square. Choir fanatics with ash in their lungs walked behind them, preaching. The Marnadal ran black for a month.

**`epilogue.ashes_and_iron_30_anselm_lives`** · order 30 · condition `"true"`
*[ART] A huge soot-wreathed figure on a ridge at dusk, a crowd of grey robes below, listening.*
> Anselm lived. The ash had him now, and he had the ash. They said he preached from the high passes to anyone who would climb up to hear him, and more climbed every week.

**`epilogue.ashes_and_iron_900_close`** · order 900 · condition `"true"`
*[ART] {player} on a palisade in the snow at the mouth of the Marnadal Stairs, a mixed company of clansmen, Cintrans and strangers behind them.*
> {player} saved the boy and lost the valley. The ballads argue about whether that was the right trade. Aldric never did. He sent {player} to hold the passes, and {player} held them, for as long as there was anyone left to hold them with.

---

#### The Bitter Bargain (`ending.bitter_bargain`)

**`epilogue.bitter_bargain_10_answer`** · order 10 · condition `"true"`
*[ART] The Lock Chamber, every warden kneeling toward the throne; Aldric's small hand on black iron.*
> The vault did not open, and it did not close. It answered. Every warden in the mountain rose and turned toward the throne, and the throne belonged to a twelve-year-old boy and whoever stood behind him.

**`epilogue.bitter_bargain_20_crush`** · order 20 · condition `"true"`
*[ART] A line of iron-wardens marching down the Marnadal road; a burning Choir sanctum behind them; Sodden fen-banners fleeing across a river.*
> The Choir went first. Then the border barons who had taken Sodden silver. Then Sodden's spears, who had been waiting for a civil war and got iron instead. Nobody who saw a warden march down the Marnadal road ever argued with Cintra again.

**`epilogue.bitter_bargain_30_autocracy`** · order 30 · condition `"true"`
*[ART] Cintra's palace with a warden at every gate; a silent crowd in the square below a proclamation.*
> Cintra became a kingdom that was feared, and in time a kingdom that was only feared. Corvan had locked the arsenal away so that no king would open it in a temper. His heirs no longer needed a temper. They only needed a reason, and there was always a reason.

**`epilogue.bitter_bargain_900_close`** · order 900 · condition `"true"`
*[ART] {player} in black and iron at the king's right hand, a warden behind them like a shadow.*
> They called {player} the Marshal of Iron. It was not meant kindly. {player} made sure, every day, that it was meant obediently.

---

#### Variant slides

**The Queen and the Prince**

**`epilogue.v110_aldric_coerced`** · order 110 · condition `"finale_seized() and flag(flag.aldric_coerced)"`
*[ART] Aldric at sixteen, crowned, at a window, back turned to a figure in the doorway.*
> The king never spoke of the Lock Chamber. He spoke to {player} every day for the rest of his reign, about the wardens, the casks, the borders, and never once about anything else. Courtiers learned not to stand between them. It was like standing between a lock and its key.

**`epilogue.v115_aldric_willing`** · order 115 · condition `"finale_seized() and not flag(flag.aldric_coerced)"`
*[ART] Aldric at sixteen, laughing, a warden kneeling to him in a courtyard.*
> The king grew up loving it. That was the worst of it, people said later: not that the boy was forced, but that he wasn't. He would sit on the throne's iron in the mountain for hours, listening to it answer.

**`epilogue.v120_queen_bitter`** · order 120 · condition `"finale_seized() and flag(flag.queen_alive)"`
*[ART] Ysolde on a cane, facing a warden in a palace corridor.*
> Ysolde lived long enough to see the wardens march. She abdicated in the spring, in favour of the son who no longer needed her, and went to live at the Abbey. She did not take confession there.

**`epilogue.v130_queen_wake`** · order 130 · condition `"finale_oath() == reversed and flag(flag.queen_alive)"`
*[ART] Ysolde, frail, signing a muster order by candlelight.*
> Ysolde lived to see her kingdom burn at the edges. She signed every muster order herself, in a hand that would not stop shaking. She told no one that she had heard her confessor's voice every time she closed her eyes.

**Strept** (gdd: Strept peace when `faction.strept ≥ Friendly`)

**`epilogue.v210_strept_allied_sealed`** · order 210 · condition `"finale_oath() == true and rep_tier(faction.strept) >= allied"`
*[ART] Hesk Ironjaw riding down into Cintra through the Marnadal gate, Corra beside him, spears with Ash Hall timber tied to them.*
> For the first time in living memory, a chief of Strept rode into Cintra under a flag of his own. Corra carried the spear with the Ash Hall timber tied to it. The clans were given back the high watch the dwarves had cut for them in stone, and paid for keeping it. It was a fragile peace. Both sides tended it like a fire.

**`epilogue.v220_strept_friendly_sealed`** · order 220 · condition `"finale_oath() == true and rep_tier(faction.strept) == friendly"`
*[ART] Strept shepherds and Cintran soldiers sharing a fire at the stairs-foot bothy.*
> Strept did not forgive, but it began to trade. Shepherds came down to the Marnadal Watch to sell wool. The garrison learned to buy it at fair prices. A fragile peace, and the Ash Hall still roofless on its crag.

**`epilogue.v230_strept_cold_sealed`** · order 230 · condition `"finale_oath() == true and rep_tier(faction.strept) < friendly"`
*[ART] Dun Strept's palisade gate shut, a horn on the crag.*
> Dun Strept kept its gates shut. The clans had watched Cintrans walk up their mountain to save a Cintran boy, and saw no reason to come down. The fragile peace the court announced was mostly announcement.

**`epilogue.v240_strept_apology`** · order 240 · condition `"finale_oath() == true and flag(flag.hesk_apology_given)"`
*[ART] Kosk, old and bareheaded, in the roofless Ash Hall, Hesk watching from the door.*
> In the spring, Bertran Kosk rode to Dun Strept alone, without his badge, and stood in the Ash Hall until Hesk came to see what he wanted. Nobody knows what they said. Kosk came home with a strip of burned timber in his saddlebag and kept it on his desk until he died.

**`epilogue.v250_strept_holds_passes`** · order 250 · condition `"finale_oath() == reversed and rep_tier(faction.strept) >= friendly"`
*[ART] Highlanders on a snowy ridge rolling boulders onto a warden in a gorge.*
> The clans held the high passes. They had kept the high watch before there was a Cintra, the stone said, and they kept it now with slings and boulders and old, bitter skill. Constructs that came up the goat paths did not come down again.

**`epilogue.v260_strept_abandon`** · order 260 · condition `"finale_oath() == reversed and rep_tier(faction.strept) < friendly"`
*[ART] Dun Strept empty, its gate open in the snow, the clans walking east into the mountains.*
> The clans did not stay to die for Cintra. They packed Dun Strept onto mules and went east over passes only they knew, and left the high watch to whoever wanted it.

**`epilogue.v270_strept_bargain`** · order 270 · condition `"finale_seized()"`
*[ART] An iron-warden standing at Dun Strept's gate; Hesk facing it with a spear.*
> The clans kept the high watch, as the stone said. Now they kept it for an iron king. A warden stood at Dun Strept's gate the whole of that first year. Hesk walked past it every morning and spat.

**Attre and Raimund** (gdd: Attre independence when `faction.attre < Allied` and not `flag.raimund_allied`)

**`epilogue.v310_attre_waits`** · order 310 · condition `"finale_oath() == true and flag(flag.queen_alive) and rep_tier(faction.attre) < allied and not flag(flag.raimund_allied)"`
*[ART] Raimund at his harbour window, a gold circlet in a drawer.*
> Duke Raimund put his gold circlet back in its drawer. A living queen was bad for business, but a living queen with a hardened son and a sealed mountain was worse for rebellion. Attre stayed Cintran. Raimund stayed patient.

**`epilogue.v320_attre_ally_sealed`** · order 320 · condition `"finale_oath() == true and (rep_tier(faction.attre) >= allied or flag(flag.raimund_allied))"`
*[ART] Attre grain ships unloading at Cintra's docks, Raimund's pennant on the masts.*
> Raimund did not declare. He sent a fleet of grain to Cintra with his compliments and an invoice. The regency paid both, and Attre's ships sailed under the lion again, at a discount.

**`epilogue.v330_attre_free_boy_king`** · order 330 · condition `"finale_oath() == true and not flag(flag.queen_alive) and rep_tier(faction.attre) < allied and not flag(flag.raimund_allied)"`
*[ART] Attre's harbour, Cintran banners being torn down, the Duke crowned on the quay.*
> Attre declared itself free on the day of the Queen's funeral. Raimund wore the circlet he had had made years before and toasted the boy king's health. The sequel to the lock was written in Attre's harbour: civil war.

**`epilogue.v340_attre_bargain`** · order 340 · condition `"finale_seized() and (rep_tier(faction.attre) >= allied or flag(flag.raimund_allied))"`
*[ART] Blight-cask cradles being loaded onto an Attre ship at night.*
> Raimund knelt to the new king first, before anyone else had worked out that kneeling was required. Attre became the arsenal's port. Its ships carried what came out of the mountain to wherever the throne sent it, and Raimund grew very rich, and never slept again.

**`epilogue.v345_attre_crushed`** · order 345 · condition `"finale_seized() and rep_tier(faction.attre) < allied and not flag(flag.raimund_allied)"`
*[ART] Wardens on the walls of Attre Light; the Duke's banner burning.*
> Attre was the first city the wardens visited. Raimund had been planning independence for ten years. It lasted one afternoon.

**`epilogue.v350_attre_profiteer`** · order 350 · condition `"finale_oath() == reversed"`
*[ART] An Attre smuggler's cutter loading a cracked cask in fog.*
> Attre sealed its ports, then quietly reopened them to anyone who could pay. Raimund sold to Cintra, to Sodden, and to the Choir's survivors, and said that a merchant does not choose sides in a fire. He only sells water.

**`epilogue.v360_raimund_heir`** · order 360 · condition `"flag(flag.antidote_sold_raimund)"`
*[ART] A thin boy in Attre colours, alive, on a balcony with Raimund's hand on his shoulder.*
> The Duke's heir lived. The dose that might have saved a queen saved a merchant's son instead. Raimund never forgot who sold it to him, and he never let {player} forget it either.

**The court: Kosk, Varn and the regency**

**`epilogue.v410_varn_exposed`** · order 410 · condition `"flag(flag.varn_exposed)"`
*[ART] Varn in a plain coat boarding a ship for Brugge, a clerk carrying a single small trunk.*
> Chancellor Varn was tried for the river tolls in the spring. He was sentenced to exile instead of the rope, partly because he wept so convincingly. He left for Brugge with one trunk and wrote long letters home that nobody answered.

**`epilogue.v420_varn_blackmailed`** · order 420 · condition `"not flag(flag.varn_exposed) and flag(flag.varn_blackmailed)"`
*[ART] Varn signing a stack of documents without reading them, sweat on his brow.*
> Varn kept his chain of office and lost everything else. He signed what he was told to sign, and kept his ledgers in good order now, because someone else had a copy.

**`epilogue.v430_regency_council`** · order 430 · condition `"finale_oath() == true and flag(flag.a3_regency_council)"`
*[ART] The council table with Kosk and Varn at opposite ends, both signing the same warrant.*
> The council {player} had forced on them in the war room held. Kosk and Varn sat at opposite ends of the same table for six years and never once agreed on anything except that the other was intolerable. Cintra was governed adequately. It was a novelty.

**`epilogue.v440_varn_backed`** · order 440 · condition `"finale_oath() == true and flag(flag.a3_backed_varn) and not flag(flag.varn_exposed)"`
*[ART] Varn behind a treasury desk, a new set of ledgers, very neat.*
> Varn kept the treasury, as {player} had advised. He stole less than before. He told everyone this as if it were a virtue, and in a way it was.

**`epilogue.v450_kosk_warned`** · order 450 · condition `"finale_oath() == true and flag(flag.a3_warned_kosk_of_varn) and not flag(flag.varn_exposed)"`
*[ART] Kosk with the treasury keys on his belt, Varn watching them like a dog watches a bone.*
> Kosk kept the treasury keys on his own belt from that day on. Varn watched them every time the Marshal walked past, and said nothing, and sweated.

**`epilogue.v460_kosk_cavalry`** · order 460 · condition `"flag(flag.watch_signal_lit) and rep_tier(faction.crown) >= friendly"`
*[ART] Kosk's heavy horse riding back down the Engine Road into daylight, a boy among them.*
> Kosk's riders came out of the mountain by the old wagon road. The Watch beacon that had called them was kept lit every solstice after, by order, by a squire who never let anyone else touch the pitch.

**Maelis** (gdd: Maelis alive)

**`epilogue.v510_maelis_abbess`** · order 510 · condition `"flag(flag.maelis_recruited) and not flag(flag.maelis_dead) and rep_tier(faction.abbey) >= allied and not finale_seized()"`
*[ART] Maelis in an abbess's plain grey, opening the scriptorium's iron door for a line of novices.*
> Sister Maelis was made Abbess of St. Corwen at twenty-four, over the objections of everyone senior to her. She unlocked the scriptorium on her first day and never locked it again. The Book of the Lion was rebound with its fourth verse restored, in her own hand, the right way round.

**`epilogue.v515_maelis_archivist`** · order 515 · condition `"flag(flag.maelis_recruited) and not flag(flag.maelis_dead) and rep_tier(faction.abbey) < allied and not finale_seized()"`
*[ART] Maelis in the drained Drowned Library, copying an iron-leaf by lamplight, surrounded by seated dwarven dead.*
> Maelis went back to Karak Ostrel the next summer with lamps, paper and a mule, and stayed. She copied the Drowned Library leaf by leaf among the seated archivists, and sent the copies down the Stairs to anyone who asked, so that no one could ever cut a verse out of the world again.

**`epilogue.v520_maelis_bargain`** · order 520 · condition `"finale_seized() and flag(flag.maelis_recruited) and not flag(flag.maelis_dead)"`
*[ART] Maelis walking away from Cintra down an empty road, a satchel of books.*
> Maelis left Cintra the week the wardens marched. She took the iron-leaf copy of the Rite of Command with her, and nobody has found either of them since. {player} was sent to look, more than once, and came back empty-handed every time, and slowly.

**`epilogue.v530_maelis_dead`** · order 530 · condition `"flag(flag.maelis_dead)"`
*[ART] A plain stone in the Abbey cloister; fresh lily-free flowers; a primer of dwarven runes on top.*
> Maelis is buried in the Abbey cloister, under a stone with no verse on it, because she said once that she had read enough verses for one life. Someone leaves a book on the stone every year at the solstice. It is always the same dwarven primer, and nobody ever sees who.

**Dravin**

**`epilogue.v610_dravin_sealed`** · order 610 · condition `"flag(flag.dravin_recruited) and finale_oath() == true"`
*[ART] Dravin at the Weeping Gate with Jasia, cutting a notch in the tally; the seventh family tablet in his pack, still blank.*
> Dravin cut the twenty-second notch himself, with Jasia holding the lamp. The seventh tablet on his family shelf stayed blank. He said he would carve it when there was something to put on it besides "waited", and that this might take a while.

**`epilogue.v620_dravin_hunts`** · order 620 · condition `"flag(flag.dravin_recruited) and finale_oath() == reversed"`
*[ART] Dravin with a hammer standing over a broken warden in a valley field.*
> Dravin spent his last years hunting his ancestors' work across the borderlands with a hammer and a list. When he found a warden, he would put his hand on its cold core and say the warden-word before he broke it. He said it was only polite.

**`epilogue.v630_dravin_bargain`** · order 630 · condition `"flag(flag.dravin_recruited) and finale_seized()"`
*[ART] Dravin's Assengard forge, cold; the Iron-Key's empty cradle; Jasia at the anvil alone.*
> Dravin left the Key in the throne and walked home to Assengard, and did not speak to {player} again. On the seventh tablet on his shelf, he cut one word, and covered it with a cloth, and Jasia never lifted the cloth.

**The wyvern, Anselm, Sodden and the rest**

**`epilogue.v650_wyvern_returned`** · order 650 · condition `"flag(flag.wyvern_eggs_returned) and not finale_seized()"`
*[ART] Five young wyverns tumbling in the air over the Old Grey Matron; Tigg shepherds looking up.*
> In the spring, five young wyverns tumbled over the Old Grey Matron, learning the wind. The shepherds of Tigg lost a sheep now and then and complained loudly. Nobody tried to climb to the Roost. People who had heard the story said it was hers.

**`epilogue.v655_wyvern_slain`** · order 655 · condition `"flag(flag.wyvern_slain)"`
*[ART] A wyvern skull nailed over the Tigg inn door.*
> The shepherds of Tigg bought the wyvern's skull and nailed it over the inn door. Travellers ask about it. The innkeeper tells them about a monster, and doesn't mention the eggs.

**`epilogue.v660_anselm_trial`** · order 660 · condition `"finale_oath() == true and finale_anselm() == alive"`
*[ART] Anselm in chains before the council, serene, the Queen's empty chair or the boy king's.*
> Anselm was tried before the council in the spring. He confessed to everything and repented of nothing, and he was so gentle about it that the clerks wept while they wrote it down. They hanged him at the Ring of Nine, at dawn, which nobody thought was a good idea afterward.

**`epilogue.v665_anselm_wavered`** · order 665 · condition `"finale_oath() == true and finale_anselm() == alive and flag(flag.anselm_wavered)"`
*[ART] Anselm in a cell, writing by a slit of light.*
> In his cell he wrote one more sermon, and asked that it be given to {player}. It was four lines long. It said that the counter-gear had not listened to him either, at the end, and that he had been relieved.

**`epilogue.v670_anselm_unmade`** · order 670 · condition `"finale_oath() == true and finale_anselm() == dead"`
*[ART] An unmarked grave on Marnadal Field, mud and bones and early grass.*
> They buried what was left of Anselm on Marnadal Field, in an unmarked grave among the boys he had given last rites to. Kosk chose the place. He said it was the only justice he could think of that the Abbot would have understood.

**`epilogue.v675_anselm_bargain`** · order 675 · condition `"finale_seized()"`
*[ART] A warden standing guard outside a cell with no door.*
> Anselm was not hanged. The new king had him kept in the mountain, in a cell with no door, and a warden outside it, so that he could listen to the vault answering a crown for the rest of his life. It was the cruellest thing anyone in Cintra had ever done, and it was done by a child.

**`epilogue.v680_sodden_exposed`** · order 680 · condition `"flag(flag.brzezina_plot_exposed) and finale_oath() == reversed and finale_anselm() == fled"`
*[ART] A Sodden envoy and a Strept chief at a Cintran council table, all three unhappy.*
> With its spies in Cintra unmasked and its baron in chains, Sodden came to the table instead of the border. Three peoples who hated one another held the passes together against the ash. It was the most desperate alliance in the history of the north. It held.

**`epilogue.v685_sodden_flank`** · order 685 · condition `"not flag(flag.brzezina_plot_exposed) and finale_oath() == reversed"`
*[ART] Sodden fen-banners crossing a northern river while Cintra's army looks south.*
> While Cintra looked south at the burning mountain, Sodden's spears crossed the northern fords, guided by a Cintran baron who had been paid in advance. There was no one left to stop them.

**`epilogue.v690_sodden_quiet`** · order 690 · condition `"flag(flag.brzezina_plot_exposed) and finale_oath() == true"`
*[ART] A Sodden spymaster's empty hunting lodge in birch woods.* (cut candidate)
> The traitor baron hanged, his letters read aloud in council: Sodden waited in its fens and found nothing to wait for. Somewhere in Brzezina, a spymaster with a long memory kept a list. {player}'s name was on it.

**`epilogue.v695_tobiasz`** · order 695 · condition `"flag(flag.tobiasz_freed)"`
*[ART] Tobiasz kneeling before Kosk in the war room.* (cut candidate)
> Tobiasz walked into the Marshal's war room with frostbitten hands and confessed. Kosk listened to the whole thing and then gave him a job in the stables, far from any door that needed a key.

## 6. Encounters
None.

## 7. Items and clues
None.

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.game_complete, type: milestone, desc: "The closing scene finished; epilogue playing; completion save."}
reads:
  - ms.a3_finale_done
  - flag.queen_alive
  - flag.aldric_coerced
  - flag.dravin_recruited
  - flag.maelis_recruited
  - flag.maelis_dead
  - flag.hesk_apology_given
  - flag.raimund_allied
  - flag.antidote_sold_raimund
  - flag.varn_exposed
  - flag.varn_blackmailed
  - flag.a3_regency_council
  - flag.a3_backed_varn
  - flag.a3_warned_kosk_of_varn
  - flag.watch_signal_lit
  - flag.wyvern_eggs_returned
  - flag.wyvern_slain
  - flag.anselm_wavered
  - flag.brzezina_plot_exposed
  - flag.tobiasz_freed
```

## 9. Quest hooks

```yaml quest_stages
quest: quest.main_a3
order: 80
stages:
  - id: epilogue
    journal: "It's over, one way or another. What's left is what people will say about it."
    objectives:
      - {id: done, text: "See it through", condition: "ms(ms.game_complete)", optional: false}
    on_complete: []
    next: []
```

## 10. Rumors and event cards (optional)
None.

## 11. Failure states and branches

```yaml branches
paths:
  - id: bitter_bargain
    when: "finale_seized()."
    outcome: "ending.bitter_bargain; core 10-30, variants v110/v115, v120, v270, v340/v345, v520, v630, v675, close 900."
    sets: ["reach_milestone(ms.game_complete)"]
  - id: shattered_lock
    when: "finale_oath() == reversed and finale_anselm() == dead."
    outcome: "ending.shattered_lock; variants for Strept (v250/v260), Attre (v350), Sodden (v685), Dravin (v620)."
    sets: ["reach_milestone(ms.game_complete)"]
  - id: ashes_and_iron
    when: "finale_oath() == reversed and finale_anselm() == fled."
    outcome: "ending.ashes_and_iron; variants for Strept, Attre, Sodden alliance (v680) or flank (v685), Dravin."
    sets: ["reach_milestone(ms.game_complete)"]
  - id: lion_holds
    when: "finale_oath() == true and flag.queen_alive."
    outcome: "ending.lion_holds; variants for Strept (v210-v240), Attre (v310/v320), court, Maelis, Dravin, wyvern, Anselm."
    sets: ["reach_milestone(ms.game_complete)"]
  - id: boy_king
    when: "finale_oath() == true and not flag.queen_alive."
    outcome: "ending.boy_king; variants as Lion Holds, with v330 (Attre independence) instead of v310."
    sets: ["reach_milestone(ms.game_complete)"]
failures: []
guarantees:
  - "Every finale record produced by a3.07 matches exactly one resolver row (rows 1-5 are exhaustive over {seized} + {true, reversed} x {alive, dead, fled}: reversed+alive cannot occur because the aftermath always ends in dead or fled)."
  - "Every ending has a core of 3 slides and a closing slide with condition 'true'."
```

## 12. Open questions
- **Epilogue data format.** content-format.md has no `epilogue` block type, and architecture §8.3 has an `epilogues/` content kind. I wrote the slides as structured markdown (id, order, condition, art, narration) so that a later schema can convert them mechanically. Proposed block: `yaml epilogue` with `{id, ending, order, condition, art, text, cut_candidate}`.
- **Reversed + alive.** `finale_anselm() == alive` with a reversed oath cannot happen: the aftermath always ends in pursue (dead) or shield (fled). The resolver's assertion would catch it if the finale domain ever produced it.
- **Flags from other slices** read here (`flag.varn_exposed`, `flag.antidote_sold_raimund`, `flag.maelis_recruited`, `flag.maelis_dead`) are listed under "Expected" in `_ids.md`.
- **Variant cap.** A thorough playthrough can match 10+ variants. Suggest a cap of 8 slides per ending (3 core + up to 4 variants by order + close), with the rest shown in a "Chronicle" page in the journal.
