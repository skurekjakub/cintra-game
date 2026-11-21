---
section_id: a1.04
title: "The Abbey of St. Corwen"
act: 1
story_ref: "story.md §3 (Anselm, Maelis), §5.4; gdd.md §6.11 (fourth verse theory), §7.1 #4, §7.4 (abbey ledgers hook)"
zones: [zone.abbey_st_corwen]
available_when: "ms(ms.a1_audience_done) and not flag(flag.fair_started)"
escalation_stage_required: {min: 0, max: 0}
milestones_set: [ms.a1_abbey_done]
milestones_read: [ms.a1_audience_done, ms.a1_abbey_done]
level_band: [2, 3]
---

# The Abbey of St. Corwen

## 1. Scene summary

Across Corwen Bridge, the Abbey of St. Corwen is all warm stone, beeswax and singing. Beggars line the almonry steps where the Abbot feeds the poor on Sundays. In the library, young Sister Maelis, the archivist, shows Hale the *Book of the Lion*, Corvan's own book of the Oath. The fourth verse has been sliced out with a knife: not torn by vandals, but cut cleanly along the gutter by someone with a steady hand. Abbot Anselm arrives, sorrowful and kind. He says he discovered the "vandalism" days ago, and since the Crown must have the Oath, he writes out the fourth verse "from memory" for Hale: a false verse. When he is called away to Vespers, Maelis whispers what frightens her: the Book was kept in the reliquary vault, the vault was never forced, and only the Abbot holds its key. If she doesn't trust Hale enough to say it aloud, she slips a note into Hale's satchel instead. Around the Abbey, a careful eye finds beeswax on the bell ropes (someone has been ringing the midnight bells) and fresh oil on the hinges of the crypt's catacomb gate. The dramatic question: *what does a holy man gain from a missing verse?* The section ends when Hale has the sliced book, the false verse and Maelis's warning (`ms.a1_abbey_done`).

## 2. Progress and escalation

- Stage 0. `ms.a1_abbey_done` fires once Hale holds `clue.only_anselm_key`, by whichever of the two routes gives it: Maelis's whisper (`dlg.maelis_whisper`) or her note at the gate (`t_note_at_gate`). Exactly one of the two fires (`flag.maelis_whispered` vs `flag.maelis_note_pending`). It pays `add_xp(200)`.
- `item.false_fourth_verse` is always given by Anselm (no check). Compared with the stone at the Ring of Nine it unlocks `ded.anselm_lied` (section 5).
- Anselm cannot be exposed in Act I. Any accusation is deflected (see `dlg.anselm` in section 2).
- Variants: after the twist (Act II) the crypt's catacomb gate becomes the entrance to `zone.abbey_catacombs` (A05). At stage ≥ 1 the Abbey grows quieter and Maelis more frightened.
- A07's side quest *Abbey ledgers* starts from Maelis's conversation (`dlg.maelis_ledgers_offer`) and uses the cloister door to `zone.abbey_scriptorium`.

## 3. Location layout

A Romanesque abbey on the river's far bank, about 70 × 45 m including the cloister. Day look, shafts of light, incense. The player is never in danger here, and the layout is built for looking: every important object is a lit point of interest.

```
                        N
   [bell_tower]   +-------------------------+   [abbots_lodging] (locked)
        |         |  choir_stalls (E end)   |-------|
   +----+---------+-------------------------+       |
   | reliquary    |          NAVE           |  library (Maelis, the Book on a lectern)
   | (iron grille)|  columns, side chapels  |-------+
   +--------------+  Corvan's effigy        |  cloister (garth, well, scriptorium door)
        crypt stair (under the nave, down to the crypt and the catacomb gate)
   +--------------------[ west doors ]------+
              almonry_steps (W front, beggars, bridge)
```

- **almonry_steps** (W): broad steps from Corwen Bridge to the west doors. Beggars wait for bread. A trestle where the Abbot hands out loaves on Sundays (rumor 4's "living saint"). Spawn from the hub. Brother Ambrose, the porter, at the doors.
- **nave**: tall, cool, columns down both sides, side chapels with votive candles. In the centre the stone **effigy of Corvan the Lion** on his tomb-chest, a dwarf-carved anvil at his feet. Pilgrims kneel.
- **choir_stalls** (E): carved oak stalls where the brothers sing the hours. The singing is thin and high: the brothers call it "the pale music". A choirmaster's lectern.
- **reliquary** (N transept): a vault behind an iron grille with a heavy lock. Empty plinth where the *Book of the Lion* used to rest. The lock is unscratched (Investigate 4 confirms it was opened with its own key).
- **library** (NE, through the cloister): Maelis's domain. Shelves of chained books, a long table, the *Book of the Lion* now on a reading lectern under a window, a stone stair to the scriptorium above (barred).
- **cloister**: a square garth with a well and a pear tree, arcade walks on four sides. The **scriptorium door** (locked; A07's side quest opens it, exit to `zone.abbey_scriptorium`).
- **bell_tower** (NW): a narrow stair up to the bell chamber, three ropes. The midnight bells are rung from here.
- **crypt**: down a stair from the nave. Low vaults, tombs of past abbots, damp. At the far end, an iron **catacomb gate** into the old burial tunnels under the river bank (locked; Act II twist route, A05).
- **abbots_lodging** (NE, off the choir): Anselm's private rooms. The door is locked and Brother Ambrose bars the way in Act I.

```yaml zone
id: zone.abbey_st_corwen
name: "The Abbey of St. Corwen"
kind: interior
map_node: map.cintra
time_of_day: day
cold_rate: 0
disguise_tag: null
music: abbey_chant
areas:
  - {id: almonry_steps, description: "West steps from Corwen Bridge. Beggars, the Sunday bread trestle, Brother Ambrose at the west doors."}
  - {id: nave, description: "Tall columns, side chapels with votive candles, Corvan's effigy with a dwarf-carved anvil at his feet. Pilgrims kneel."}
  - {id: choir_stalls, description: "East end. Carved oak stalls, the choirmaster's lectern. Thin, high 'pale music'."}
  - {id: reliquary, description: "North transept vault behind an iron grille with an unscratched lock. Empty plinth."}
  - {id: library, description: "NE. Chained books, long table, the Book of the Lion on a lectern under a window. Barred stair up."}
  - {id: cloister, description: "Garth with a well and a pear tree, arcades. The locked scriptorium door."}
  - {id: bell_tower, description: "NW narrow stair to the bell chamber, three ropes."}
  - {id: crypt, description: "Low vaults under the nave, abbots' tombs, damp. Iron catacomb gate at the far end."}
  - {id: abbots_lodging, description: "Anselm's locked rooms off the choir. Ambrose bars the way."}
spawns:
  - {id: almonry_steps, area: almonry_steps, default: true}
  - {id: cloister_door, area: cloister, default: false}
  - {id: catacomb_gate, area: crypt, default: false}
exits:
  - id: to_bridge
    area: almonry_steps
    to_zone: zone.cintra_streets
    to_spawn: abbey_lane
    condition: "true"
    effects: []
  - id: to_scriptorium
    area: cloister
    to_zone: zone.abbey_scriptorium
    to_spawn: cloister_door
    condition: "quest_active(quest.side_abbey_ledgers)"
    effects: []
  - id: to_catacombs
    area: crypt
    to_zone: zone.abbey_catacombs
    to_spawn: abbey_gate
    condition: "ms(ms.act2_twist)"
    effects: []
interactables:
  - id: book_of_lion
    area: library
    kind: readable
    label: "The Book of the Lion"
    condition: "flag(flag.maelis_showed_book)"
    check: null
    once: false
    effects: ["play_beat(read_book)"]
  - id: book_cut
    area: library
    kind: search
    label: "Look closely at the cut"
    condition: "flag(flag.maelis_showed_book) and not flag(flag.cut_examined)"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["set_flag(flag.cut_examined)", "play_beat(cut_closeup)"]
    fail_effects: []
  - id: reliquary_lock
    area: reliquary
    kind: search
    label: "Examine the reliquary lock"
    condition: "true"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["play_beat(lock_unforced)", "set_flag(flag.lock_unforced_seen)"]
    fail_effects: ["play_beat(lock_plain)"]
  - id: bell_ropes
    area: bell_tower
    kind: search
    label: "Examine the bell ropes"
    condition: "not has_clue(clue.bell_rope_wax)"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["add_clue(clue.bell_rope_wax)", "play_beat(rope_wax)"]
    fail_effects: ["play_beat(rope_plain)"]
  - id: catacomb_gate
    area: crypt
    kind: search
    label: "Examine the catacomb gate"
    condition: "not has_clue(clue.catacomb_hinges)"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["add_clue(clue.catacomb_hinges)", "play_beat(hinges_oiled)"]
    fail_effects: ["play_beat(gate_plain)"]
  - id: corvan_effigy
    area: nave
    kind: readable
    label: "Corvan's effigy"
    condition: "true"
    check: {skill: lore, dc: 6}
    once: true
    effects: ["play_beat(effigy_lore)"]
    fail_effects: ["play_beat(effigy_plain)"]
  - id: lodging_door
    area: abbots_lodging
    kind: door
    label: "The Abbot's door"
    condition: "true"
    check: null
    once: false
    effects: ["play_beat(ambrose_bars)"]
  - id: votive_box
    area: nave
    kind: container
    label: "Votive offering box"
    condition: "true"
    check: null
    once: true
    effects: ["add_rep(faction.abbey, -5)", "add_crowns(9)"]
  - id: alms_trestle
    area: almonry_steps
    kind: search
    label: "Give to the beggars"
    condition: "crowns() >= 5"
    check: null
    once: true
    effects: ["add_crowns(-5)", "add_rep(faction.abbey, 3)", "play_beat(beggar_blessing)"]
triggers:
  - id: t_abbey_enter
    area: almonry_steps
    "on": enter
    source: null
    condition: "not visited(zone.abbey_st_corwen)"
    once: true
    effects: ["set_checkpoint(abbey_in)", "play_beat(abbey_arrival)"]
  - id: t_library
    area: library
    "on": enter
    source: null
    condition: "not flag(flag.maelis_showed_book)"
    once: true
    effects: ["start_dialogue(dlg.maelis_book)"]
  - id: t_anselm_arrives
    area: library
    "on": beat_done
    source: anselm_enters
    condition: "not has_item(item.false_fourth_verse)"
    once: true
    effects: ["start_dialogue(dlg.anselm_false_verse)"]
  - id: t_whisper
    area: library
    "on": beat_done
    source: anselm_leaves
    condition: "not flag(flag.maelis_whispered) and not flag(flag.maelis_note_pending)"
    once: true
    effects: ["start_dialogue(dlg.maelis_whisper)"]
  - id: t_note_at_gate
    area: almonry_steps
    "on": enter
    source: null
    condition: "flag(flag.maelis_note_pending) and not has_item(item.maelis_note)"
    once: true
    effects: ["play_beat(note_found)", "give_item(item.maelis_note, 1)", "add_clue(clue.only_anselm_key)", "reach_milestone(ms.a1_abbey_done)"]
hazards: []
checkpoints:
  - {id: abbey_in, area: almonry_steps}
beats:
  - {id: abbey_arrival, description: "Warm stone, beeswax, singing. Beggars on the steps call blessings on the Abbot. Brother Ambrose, the porter, bows Hale in: 'Sister Maelis is in the library. Father Abbot said you would come.'"}
  - {id: show_book, description: "Maelis opens the Book of the Lion on its lectern: vellum leaves, gold lions in the margins, three verses in a heavy old hand. Where the fourth should be, a stub of vellum along the gutter."}
  - {id: anselm_enters, description: "Soft steps. Abbot Anselm in the library doorway, hands folded in his sleeves, his face full of sorrow. Maelis goes very still and lowers her eyes."}
  - {id: anselm_writes, description: "Anselm takes a card and a pen at the long table and writes in a fine, unhurried hand, murmuring the words as he goes. He blots it and hands it over with a smile."}
  - {id: anselm_leaves, description: "A bell for Vespers. Anselm touches Maelis's head in blessing as he passes; she flinches, very slightly. His steps fade along the cloister."}
  - {id: note_found, description: "On the almonry steps Hale finds a folded scrap tucked into their satchel: Maelis's small, careful hand."}
  - {id: read_book, description: "The Book of the Lion, opened at the Oath: 'By iron forged in mountain deep, / By lion's blood the watch we keep. / Let bolt and bar hold fast the night,' and then the cut stub where the fourth line was."}
  - {id: cut_closeup, description: "The cut runs straight down the gutter in one stroke, no tearing, no false starts: a very sharp knife in a very steady hand. A vandal rips. This was surgery."}
  - {id: lock_unforced, description: "The reliquary lock is old and heavy and without a single scratch. Whoever opened it had the key."}
  - {id: lock_plain, description: "A big old lock. Nothing obviously wrong with it."}
  - {id: rope_wax, description: "The grips of all three bell ropes are slick with fresh beeswax, the kind used for altar candles. Someone rings these often, and with soft hands."}
  - {id: rope_plain, description: "Bell ropes. Worn. Waxy."}
  - {id: hinges_oiled, description: "The catacomb gate's hinges glisten with fresh oil, and the dust before it is scuffed by many sandalled feet, going in and coming out. Nobody has been buried here in forty years."}
  - {id: gate_plain, description: "A rusty iron gate into darkness. Locked."}
  - {id: effigy_lore, description: "Corvan's effigy rests his feet on an anvil carved with dwarven runes. Hale makes out 'BOLT' and 'NINETEEN' and the mark of Ostrel's gate-wardens: a hammer over a closed door, the same as Dravin's seal."}
  - {id: effigy_plain, description: "Corvan the Lion, carved in stone, his feet on an anvil. Pilgrims have rubbed the lion on his shield smooth."}
  - {id: ambrose_bars, description: "Brother Ambrose is there before Hale's hand touches the latch: 'Father Abbot's rooms are private, friend. Even from the Marshal.'"}
  - {id: beggar_blessing, description: "A beggar woman takes the coins: 'God and the Abbot keep you. The Abbot feeds us when the lords won't.'"}
npcs:
  - {npc: npc.maelis, area: library, condition: "true"}
  - {npc: npc.anselm, area: choir_stalls, condition: "has_item(item.false_fourth_verse) and not ms(ms.act2_twist)"}
  - {npc: npc.brother_ambrose, area: almonry_steps, condition: "not ms(ms.act2_twist)"}
encounters: []
loot: []
variants:
  - id: stage1_abbey
    when: "stage() >= 1"
    description: "Fewer brothers at the hours. Black cloth over the reliquary grille. Maelis has moved her cot into the library and sleeps by the Book."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: twist_abbey
    when: "ms(ms.act2_twist)"
    description: "Act II twist (A05): the Abbot gone, Ambrose gone, Kosk's soldiers in the nave. The catacomb gate hangs open."
    npcs_absent: [npc.anselm, npc.brother_ambrose]
    encounters_disabled: []
    interactables_disabled: [lodging_door]
```

## 4. NPCs present

**Voice notes.**
- **Sister Maelis**: twenty-two, ink on her fingers, precise, speaks quickly when excited about books and very slowly when afraid. Uses exact words ("sliced", not "torn"). Never says Anselm's name when she is accusing him; she says "the key".
- **Abbot Anselm**: as in section 2. Here, in his own house, he is at his warmest. His false verse is delivered with tender regret.
- **Brother Ambrose**: forties, a former soldier turned porter, calm, huge hands, says "friend" softly. A true believer.

```yaml npc
id: npc.maelis
name: "Sister Maelis"
faction: faction.abbey
role: "Archivist of St. Corwen"
motive: "Protect the books and the truth in them. Find out who cut the Book of the Lion, and survive finding out."
secret: "She has noticed that the Abbot's sermons about the Oath contradict the Abbey's own older chronicles, and that the cut was made inside a locked vault only he can open."
disposition: friendly
essential: true
dialogue: dlg.maelis
barks: ["Mind the chains, the books bite.", "Sliced. Not torn. Sliced.", "Please keep your voice down.", "Ink and vellum don't lie. People do."]
combat: null
shop: null
```

```yaml npc
id: npc.brother_ambrose
name: "Brother Ambrose"
faction: faction.choir
role: "Porter of St. Corwen; carries the Queen's communion wine to the palace"
motive: "Serve the Abbot, who saved him from drink and despair after Marnadal."
secret: "Pale Choir. A pale gull feather is sewn into the hem of his cowl. He rings the midnight bells on the Abbot's order and keeps the catacomb gate oiled."
disposition: friendly
essential: true
dialogue: dlg.ambrose
barks: ["Peace, friend.", "Father Abbot is at prayer.", "The pale music is for the dead. And the soon-dead."]
combat: enemy.choir_zealot
shop: null
```

## 5. Dialogue trees

### 5.1 Maelis shows the Book

```yaml dialogue
id: dlg.maelis_book
participants: [npc.maelis]
start: open
nodes:
  open:
    type: line
    speaker: npc.maelis
    text: "You're the Marshal's... yes. Father Abbot said you'd come about the Book. Please, come here, into the light. I want you to see it, because nobody else will look properly."
    direction: "She is standing beside the lectern as if guarding it."
    next: show
  show:
    type: effect
    effects: ["set_flag(flag.maelis_showed_book)", "play_beat(show_book)", "add_clue(clue.book_sliced)", "give_item(item.verses_copy, 1)"]
    next: explain
  explain:
    type: line
    speaker: npc.maelis
    text: "Three verses, in Corvan's own scribe's hand. And here, the fourth. Gone. Not torn, you see? Sliced, down the gutter, in one stroke. I've made you a fair copy of what's left."
    next: hub
  hub:
    type: choice
    options:
      - id: vandals
        text: "The Abbot's notice says vandals."
        next: vandals
      - id: when
        text: "When did this happen?"
        next: when_cut
      - id: you
        text: "You're the archivist. You had the best chance to do it. [Accuse]"
        effects: ["set_flag(flag.maelis_accused)", "add_rep(faction.abbey, -15)"]
        next: accused
      - id: verse
        text: "Do you know what the fourth verse said?"
        next: verse
      - id: done
        text: "Show me the rest later."
        next: wait
  vandals:
    type: line
    speaker: npc.maelis
    text: "Vandals tear. They scrawl. They take the gold leaf, not one line of plain ink. Whoever did this wanted that verse, exactly that verse, and nothing else."
    next: hub
  when_cut:
    type: line
    speaker: npc.maelis
    text: "I don't know. It lives in the reliquary, behind the grille. I last saw it whole on the equinox, the night the bells rang. Father Abbot found it cut... he says... some days ago."
    next: hub
  accused:
    type: line
    speaker: npc.maelis
    text: "I... I see. Yes. I suppose I would think that too. I'd ask you to look at my hands. I couldn't make a cut that clean if my life depended on it. It might."
    direction: "Her face goes white, then closed."
    next: hub
  verse:
    type: line
    speaker: npc.maelis
    text: "No. Nobody alive has needed it but the Queen, and she learned it from this page in 1249. Our older chronicles quote the first three lines. The fourth was too holy to copy. That was the rule."
    next: hub
  wait:
    type: line
    speaker: npc.maelis
    text: "Wait. Please. Father Abbot is coming. He... wanted to speak to you himself."
    next: cue
  cue:
    type: effect
    effects: ["play_beat(anselm_enters)"]
    next: bye
  bye:
    type: end
```

Every exit from the hub leads through `wait` or back to the hub; the `done` option is the one that cues Anselm. The hub's non-`done` options all loop back so the player can ask everything first.

### 5.2 Anselm and the false verse

```yaml dialogue
id: dlg.anselm_false_verse
participants: [npc.anselm, npc.maelis]
start: open
nodes:
  open:
    type: line
    speaker: npc.anselm
    text: "My child. Maelis has shown you our wound. I found it so, some days past. I did not cry it from the steps; who would it help, to know the Lion's book was defiled?"
    next: hub
  hub:
    type: choice
    options:
      - id: who
        text: "Who would want one verse cut out?"
        next: who
      - id: key
        text: "The reliquary was locked. Who has the key?"
        next: key
      - id: need
        text: "The Queen needs that verse."
        next: need
  who:
    type: line
    speaker: npc.anselm
    text: "Someone who hates the Crown, or fears it. There are many in Cintra since Marnadal. I buried their sons. I understand the hate. I cannot understand the knife."
    next: need
  key:
    type: line
    speaker: npc.anselm
    text: "I do, as abbots always have. And three times a year it hangs on a nail in the sacristy while the brothers clean. Old men forget. I am an old man."
    next: need
  need:
    type: line
    speaker: npc.anselm
    text: "She does. And so she shall have it. I have spoken the Oath beside her in my prayers for nineteen years. Let me write it for you while it is still clear in my head."
    direction: "He sits at the long table."
    next: write
  write:
    type: effect
    effects: ["play_beat(anselm_writes)", "give_item(item.false_fourth_verse, 1)"]
    next: recite
  recite:
    type: line
    speaker: npc.anselm
    text: "'Till crown and key restore the light.' There. Take it to the Marshal, with my blessing. And Maelis will mend what can be mended."
    next: after_hub
  after_hub:
    type: choice
    options:
      - id: thanks
        text: "Thank you, Father."
        next: leave
      - id: sure
        text: "You're certain of the words?"
        next: sure
      - id: suspicious
        text: "Convenient memory, Father."
        next: suspicious
  sure:
    type: line
    speaker: npc.anselm
    text: "As certain as an old man is of anything. If the Lord has let me misremember a word, the Lord will forgive me. Will the Marshal?"
    direction: "A gentle, rueful smile."
    next: leave
  suspicious:
    type: line
    speaker: npc.anselm
    text: "Everything is convenient for the man who does his duty, my child. It is only inconvenient for those who don't."
    next: leave
  leave:
    type: effect
    effects: ["play_beat(anselm_leaves)"]
    next: bye
  bye:
    type: end
```

### 5.3 Maelis's whisper

If the player has kept her trust (`faction.abbey` Friendly, which it is from the start unless the player accused her or robbed the votive box), or shows Dravin's letter, or passes Persuade 4, she says it aloud. Otherwise she sets `flag.maelis_note_pending` and the note waits at the gate.

```yaml dialogue
id: dlg.maelis_whisper
participants: [npc.maelis]
start: open
nodes:
  open:
    type: line
    speaker: npc.maelis
    text: "Is he gone? ...He's gone."
    direction: "She waits until the footsteps fade, then comes close."
    next: hub
  hub:
    type: choice
    options:
      - id: trust
        text: "You want to tell me something. Tell me."
        condition: "rep_tier(faction.abbey) >= friendly and not flag(flag.maelis_accused)"
        next: whisper
      - id: letter
        text: "A dwarf at Assengard is afraid enough to write to the Marshal. So am I. [Item: Dravin's dispatch]"
        tag: item
        condition: "has_item(item.dravin_letter)"
        next: whisper
      - id: persuade
        text: "Nobody's listening now. You're safer telling me than keeping it. [Persuade 4]"
        tag: persuade
        check: {skill: persuade, dc: 4, pass: whisper, fail: refuse}
        once: true
      - id: leave
        text: "I'll come back another day."
        next: refuse
  whisper:
    type: line
    speaker: npc.maelis
    text: "The reliquary was never forced. There is one key. It never hangs in the sacristy, whatever he says. It hangs on his belt, day and night. Only Father Abbot holds that key."
    effects: ["set_flag(flag.maelis_whispered)", "add_clue(clue.only_anselm_key)", "reach_milestone(ms.a1_abbey_done)"]
    next: sermons
  sermons:
    type: line
    speaker: npc.maelis
    text: "And his sermons. He preaches that the Oath is a chain the lords forged on the people. Our oldest chronicles say it's a lock on weapons. He knows those chronicles better than I do."
    effects: ["add_clue(clue.anselm_sermons)"]
    next: after_hub
  after_hub:
    type: choice
    options:
      - id: safe
        text: "Are you safe here?"
        next: safe
      - id: more
        text: "You look like you want to ask me something else."
        condition: "not quest_active(quest.side_abbey_ledgers) and not quest_done(quest.side_abbey_ledgers)"
        next: ledgers
      - id: bye_opt
        text: "Keep your door barred, Sister."
        next: bye
  safe:
    type: line
    speaker: npc.maelis
    text: "I'm an archivist in a house of God. Of course I'm safe. ...Come back, though. Often. People notice when the Marshal's sellsword visits."
    next: after_hub
  ledgers:
    type: effect
    effects: ["start_dialogue(dlg.maelis_ledgers_offer)"]
    next: bye
  refuse:
    type: line
    speaker: npc.maelis
    text: "Not here. Not now. Go with God, Marshal's... go with God."
    direction: "She turns back to the Book. As Hale passes, her sleeve brushes their satchel."
    effects: ["set_flag(flag.maelis_note_pending)"]
    next: bye
  bye:
    type: end
```

### 5.4 Maelis (default, later visits)

```yaml dialogue
id: dlg.maelis
participants: [npc.maelis]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "not flag(flag.maelis_showed_book)", next: first}
    else: greet
  first:
    type: line
    speaker: npc.maelis
    text: "The library is this way. Please, come, there's something you need to see."
    next: bye
  greet:
    type: line
    speaker: npc.maelis
    text: "You came back. Good. Mind the chains."
    next: hub
  hub:
    type: choice
    options:
      - id: ledgers
        text: "You said you needed help with something."
        condition: "flag(flag.maelis_whispered) and not quest_active(quest.side_abbey_ledgers) and not quest_done(quest.side_abbey_ledgers)"
        next: ledgers
      - id: ring
        text: "The stone at the Ring of Nine doesn't match the Abbot's verse."
        condition: "ded(ded.anselm_lied)"
        once: true
        next: ring
      - id: read
        text: "Tell me about the Oath."
        next: oath
      - id: bye_opt
        text: "Just checking on you."
        next: bye
  ledgers:
    type: effect
    effects: ["start_dialogue(dlg.maelis_ledgers_offer)"]
    next: bye
  ring:
    type: line
    speaker: npc.maelis
    text: "Then he lied. Or his memory is worse than his penmanship, and I have never seen him forget a single line of anything. Don't say it to anyone yet. Not until you can prove it to a court."
    effects: ["add_rep(faction.abbey, 5)"]
    next: hub
  oath:
    type: line
    speaker: npc.maelis
    text: "Four verses. Spoken by the crowned monarch at the Ring of Nine at solstice dawn, every nineteen winters, since Corvan. The chronicles say the stones 'listen'. I've always wondered what they listen with."
    next: hub
  bye:
    type: end
```

### 5.5 Brother Ambrose

```yaml dialogue
id: dlg.ambrose
participants: [npc.brother_ambrose]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.brother_ambrose
    text: "Peace, friend. Bread's on Sundays. Prayers are every day."
    next: hub
  hub:
    type: choice
    options:
      - id: wine
        text: "You carry the Queen's wine to the palace?"
        next: wine
      - id: look
        text: "That's an unusual hem on your cowl. [Investigate 8]"
        tag: investigate
        check: {skill: investigate, dc: 8, pass: feather, fail: plain}
        once: true
      - id: marnadal
        text: "You stand like a soldier."
        next: marnadal
      - id: bye_opt
        text: "Peace, Brother."
        next: bye
  wine:
    type: line
    speaker: npc.brother_ambrose
    text: "Every day, friend, sealed with the Abbey's seal and blessed by Father Abbot's own hand. It's the least we can do for her."
    next: hub
  feather:
    type: line
    speaker: player
    text: "Sewn into the hem of his cowl, where it shows only when he bows: a pale gull feather."
    direction: "Ambrose sees Hale see it, and smiles, and does not move."
    effects: ["add_clue(clue.pale_feather)", "set_flag(flag.ambrose_feather_seen)"]
    next: hub
  plain:
    type: line
    speaker: npc.brother_ambrose
    text: "Mended it myself. Badly. A porter's needlework."
    next: hub
  marnadal:
    type: line
    speaker: npc.brother_ambrose
    text: "Pikeman, 1263. Marnadal. Father Abbot carried me off that field when the lords had gone home to count their indemnities. I've carried his wine ever since."
    next: hub
  bye:
    type: end
```

## 6. Encounters

None. The Abbey is a pure investigation section. Brother Ambrose has a combat profile (`enemy.choir_zealot`) for the Act II twist and later; he never fights in Act I.

## 7. Items and clues

```yaml item
id: item.false_fourth_verse
name: "Anselm's 'copy'"
category: document
description: "A card in the Abbot's fine, unhurried hand: the fourth verse of the Oath, written 'from memory'."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "The fourth verse of the Oath of the Lion, as I have spoken it at Her Majesty's side these nineteen years: 'Till crown and key restore the light.' With my blessing. Anselm, Abbot of St. Corwen."
```

```yaml item
id: item.verses_copy
name: "Maelis's fair copy"
category: document
description: "Maelis's careful copy of what remains of the Oath in the Book of the Lion."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "From the Book of the Lion, the Oath of Corvan: 'By iron forged in mountain deep, / By lion's blood the watch we keep. / Let bolt and bar hold fast the night,' [the fourth line cut from the page]. Copied by Sr. Maelis."
```

```yaml item
id: item.maelis_note
name: "Maelis's note"
category: document
description: "A folded scrap slipped into your satchel at the Abbey."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "The reliquary was never forced. There is one key and it never leaves his belt. Burn this. M."
```

```yaml clue
id: clue.book_sliced
theory: theory.fourth_verse
title: "The fourth verse, sliced out"
text: "The fourth verse of the Oath was cut from the Book of the Lion in one clean stroke down the gutter. Vandals tear; this was done with a sharp knife by someone who wanted that one line."
supports: [anselm]
refutes: [vandals]
```

```yaml clue
id: clue.only_anselm_key
theory: theory.fourth_verse
title: "Only the Abbot holds the key"
text: "The Book was kept in the reliquary vault, which was never forced. Maelis says its only key never leaves Abbot Anselm's belt."
supports: [anselm]
refutes: [vandals]
```

```yaml clue
id: clue.anselm_sermons
theory: theory.anselm_plan
title: "The Abbot's sermons"
text: "Anselm preaches that the Oath is a chain the lords forged on the people. The Abbey's own oldest chronicles say it is a lock on Corvan's weapons. He knows those chronicles well."
supports: [anselm]
refutes: []
```

```yaml clue
id: clue.bell_rope_wax
theory: theory.choir
title: "Beeswax on the bell ropes"
text: "Someone rings St. Corwen's bells at midnight. The rope grips are slick with fresh altar beeswax. Pell's paymaster 'smelled of beeswax'."
supports: []
refutes: []
```

```yaml clue
id: clue.catacomb_hinges
theory: theory.anselm_plan
title: "Oiled hinges in the crypt"
text: "The iron gate to the old catacombs under St. Corwen has freshly oiled hinges, and sandalled feet have scuffed the dust going in and out. No one has been buried there in forty years."
supports: []
refutes: []
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.a1_abbey_done, type: milestone, xp: 200, desc: "The player has seen the sliced Book, received the false verse, and learned that only Anselm holds the key."}
  - {id: flag.maelis_showed_book, type: bool, desc: "Maelis showed the sliced Book of the Lion."}
  - {id: flag.maelis_accused, type: bool, desc: "The player accused Maelis of cutting the Book (Abbey -15; blocks her trust route)."}
  - {id: flag.maelis_whispered, type: bool, desc: "Maelis said aloud that only Anselm holds the key."}
  - {id: flag.maelis_note_pending, type: bool, desc: "Maelis refused to talk and slipped a note into the player's satchel (given at the gate)."}
  - {id: flag.cut_examined, type: bool, desc: "The player examined the cut closely (Investigate 4)."}
  - {id: flag.lock_unforced_seen, type: bool, desc: "The player confirmed the reliquary lock was opened with its key."}
  - {id: flag.ambrose_feather_seen, type: bool, desc: "The player spotted the feather in Brother Ambrose's cowl (Investigate 8). A05 may read it at the twist."}
reads:
  - ms.a1_audience_done
  - flag.fair_started
  - ms.act2_twist
```

## 9. Quest hooks

This section contributes the `abbey` objective of `quest.main_a1` stage `follow_the_leads` (declared in `02-audience-at-court.md`). It is the entry point of A07's `quest.side_abbey_ledgers` (`dlg.maelis_ledgers_offer`).

## 10. Rumors and event cards (optional)

Rumor 4 ("Abbot Anselm feeds the poor on the Abbey steps every Sunday. A living saint", cover) is staged here by the almonry trestle and the beggars' blessing. The rumor block itself is A07's.

## 11. Failure states and branches

```yaml branches
paths:
  - id: whisper_trust
    when: "Abbey reputation Friendly and Maelis not accused (the default), or Dravin's letter shown, or Persuade 4 passed."
    outcome: "clue.only_anselm_key and clue.anselm_sermons spoken aloud; ms.a1_abbey_done; the ledgers side quest is offered."
    sets: ["reach_milestone(ms.a1_abbey_done)"]
  - id: whisper_note
    when: "Player accused Maelis (and has no letter) and fails or skips Persuade 4, or chooses to leave."
    outcome: "Note at the gate: clue.only_anselm_key only; ms.a1_abbey_done."
    sets: ["reach_milestone(ms.a1_abbey_done)"]
  - id: accuse_anselm
    when: "Player calls Anselm's memory convenient."
    outcome: "No consequence in Act I beyond flavor; formal confrontation uses dlg.anselm (section 2) after ded.anselm_lied."
    sets: []
failures:
  - id: votive_theft
    result: soft_fail
    recover: "Robbing the votive box costs Abbey -5. If that drops Abbey below Friendly, Maelis needs the letter or Persuade 4, or leaves the note."
guarantees:
  - "item.false_fourth_verse is given by dlg.anselm_false_verse with no check; the dialogue always starts when dlg.maelis_book cues anselm_enters (option done)."
  - "ms.a1_abbey_done: dlg.maelis_whisper always ends in either 'whisper' (milestone) or 'refuse' (note at the gate, milestone on the next pass of the almonry steps, which the player must cross to leave)."
```

## 12. Open questions

1. **Leaving the library mid-scene.** If the player walks out of the library before choosing `done`, Anselm's arrival is delayed until they return and talk to Maelis again. `dlg.maelis` (default) should then offer a line that cues `anselm_enters`. I left the default `first` node for the case before the book is shown; the level builder should keep the library door closed during `dlg.maelis_book` (dialogue pauses the game, so this only matters if the player escapes dialogue, which is not allowed).
2. **`refutes: [vandals]` (resolved by A08).** `vandals` is a suspect id (content-format §F.6, §J.7).
