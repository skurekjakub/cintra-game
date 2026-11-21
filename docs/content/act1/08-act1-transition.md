---
section_id: a1.08
title: "Act I Transition: South"
act: 1
story_ref: "story.md §5 (Act I Transition), §4 (60-days row = stage 1); gdd.md §6.1 (stage 1 effects), §6.13 (Maelis joins at Act I end), §6.12 (Varn tiers), §7.1 (Act I transition)"
zones: [zone.palace_hall]
available_when: "ms(ms.act1_complete)"
escalation_stage_required: {min: 1, max: 1}
milestones_set: []
milestones_read: [ms.act1_complete, ms.a1_gull_done]
level_band: [4, 4]
---

# Act I Transition: South

## 1. Scene summary

Back in the war room, smoke still in their clothes, Kosk lays out what the Fair proved: the Pale Choir is real, it reaches into the palace, and it wants the heir dead or worse. The Queen has taken to her bed. The news comes in while they talk: Varn is on his feet in the Lion Hall demanding a regency council, and Kosk goes out to shout him down (the stage-1 court clash). When Kosk comes back, he gives Hale their orders: ride south along the Marnadal road. Find the one who grows grey lily and knows the counter-dose. Find the true fourth verse. Find Dravin Ostrel. Follow the Choir's map to Hanged Man's Oak. **Prince Aldric stays in Cintra** under the heaviest guard Kosk can trust. Before leaving, Hale can climb the east tower to say goodbye to the boy, who asks for a promise, and Sister Maelis may turn up at the palace gate with a satchel of books, asking to come along. The section sets Act II, starts the Marnadal Road quest, and opens the south of the map.

## 2. Progress and escalation

- Entered at stage 1 (Cracked Stone), set by `ms.act1_complete`. Stage 1's world effects (gdd §6.1) play here: the Kosk–Varn clash in the Lion Hall (beat `kosk_varn_clash`, declared in section 2's palace zone), the Ring's crack widening (section 5 variant), Varn −10 unless blackmailed (system), Crown Lands prices +10% (system).
- This section sets no milestone. It runs `set_act(2)`, `start_quest(quest.main_a2)`, and the map changes. A05's Act II content takes over from here.
- Outcome flags for Act II and III: `flag.maelis_joined_a1`, `flag.aldric_promise`, `flag.aldric_guard_doubled`, `flag.varn_toll_pass`.

## 3. Location layout

This section uses `zone.palace_hall` (declared in `02-audience-at-court.md`): the **war_room** for Kosk's orders, the **lion_hall** for the Varn clash (stage-1 variant `stage1_court`), the **gatehouse** for Maelis, and the east tower stair for Aldric's farewell. No new zone block. Aldric's farewell is played at the top of the tower stair landing (the sickroom zone's antechamber is the Queen's; Aldric is kept in a guarded room on the landing below it).

## 4. NPCs present

No new NPCs. Present: `npc.kosk`, `npc.varn` (or Tobiah Quill's absence if Varn is exposed), `npc.aldric`, `npc.maelis`, `npc.sergeant_brask`.

## 5. Dialogue trees

### 5.1 Kosk's orders

```yaml dialogue
id: dlg.kosk_orders_south
participants: [npc.kosk, npc.varn, npc.sergeant_brask]
start: open
nodes:
  open:
    type: line
    speaker: npc.kosk
    text: "Sit. Drink that. Feathers in the kitchen, feathers at the Fair, knives in the crowd. Whatever this Choir is, it isn't a rumor any more. And it wants the boy."
    direction: "The war room. Kosk pours two cups of something brown and drinks one himself, standing."
    next: prisoners
  prisoners:
    type: branch
    cases:
      - {if: "flag(flag.pell_arrested) and flag(flag.fair_assassin_captured)", next: both_dead}
      - {if: "flag(flag.pell_arrested)", next: pell_dead}
      - {if: "flag(flag.fair_assassin_captured)", next: wren_dead}
    else: clash
  both_dead:
    type: line
    speaker: npc.kosk
    text: "And my prisoners are no use. Pell hanged himself in his cell with a belt he didn't own. The Wren bit something in his cheek on the road and died smiling. Somebody inside my walls is tidying up."
    next: clash
  pell_dead:
    type: line
    speaker: npc.kosk
    text: "And Pell hanged himself in his cell last night. With a belt he didn't own. Somebody inside my walls is tidying up."
    next: clash
  wren_dead:
    type: line
    speaker: npc.kosk
    text: "And your assassin bit something hidden in his cheek on the road back. Died smiling. Never said another word."
    next: clash
  clash:
    type: line
    speaker: npc.sergeant_brask
    text: "My lord. The Chancellor is in the Lion Hall with half the council. He's calling for a regency, now, today. He says the heir isn't safe in your hands."
    direction: "Brask at the door. Shouting audible from the hall."
    next: clash_route
  clash_route:
    type: branch
    cases:
      - {if: "flag(flag.varn_exposed)", next: clash_exposed}
      - {if: "flag(flag.varn_blackmailed)", next: clash_blackmailed}
    else: clash_plain
  clash_plain:
    type: effect
    effects: ["play_beat(kosk_varn_clash)"]
    next: clash_plain_line
  clash_plain_line:
    type: line
    speaker: npc.varn
    text: "Safe? Safe! The boy nearly burned to death under your protection, Marshal! The realm needs a regent with a head, not a butcher with a sword!"
    direction: "In the Lion Hall, Varn on his feet over the Queen's empty chair, Kosk advancing on him. The council scatters."
    next: back_in
  clash_blackmailed:
    type: effect
    effects: ["play_beat(kosk_varn_clash)"]
    next: clash_blackmailed_line
  clash_blackmailed_line:
    type: line
    speaker: npc.varn
    text: "The realm needs a regent, Marshal! It... it needs... Ah. Ah, I see we have company. Perhaps this is a matter for... a later council."
    direction: "Varn sees Hale in the doorway, goes grey, and sits down mid-sentence."
    next: back_in
  clash_exposed:
    type: line
    speaker: npc.sergeant_brask
    text: "Not Varn, my lord. Varn's under guard in his own tower, thanks to our friend here. It's his clerk Quill reading Varn's petition. Nobody's listening to Quill."
    next: back_in
  back_in:
    type: line
    speaker: npc.kosk
    text: "Done. For today. That fat thief will try again every day the Queen stays in bed. So I can't leave Cintra, and I can't send soldiers south without leaving the boy bare. Which leaves you."
    next: orders
  orders:
    type: line
    speaker: npc.kosk
    text: "Ride south, down the Marnadal road. I want three things before the snow closes the valley. Listen."
    next: orders_hub
  orders_hub:
    type: choice
    options:
      - id: antidote
        text: "The poison."
        next: antidote
      - id: verse
        text: "The fourth verse."
        next: verse
      - id: dravin
        text: "Dravin Ostrel."
        next: dravin
      - id: oak
        text: "The Wren's map."
        next: oak
      - id: anselm
        text: "And the Abbot?"
        condition: "ded(ded.anselm_lied) or has_clue(clue.only_anselm_key)"
        next: anselm
      - id: understood
        text: "Understood."
        next: aldric_stays
  antidote:
    type: line
    speaker: npc.kosk
    text: "Grey lily, Fell calls it, now he's found his tongue. It grows wild nowhere in Cintra. Someone grows it. Whoever grows a poison knows its cure. Rumor says there's a marsh-witch south of the Marnadal. Find her."
    effects: ["add_map_pin(map.witchs_mere)"]
    next: orders_hub
  verse:
    type: line
    speaker: npc.kosk
    text: "Whoever cut that verse out of the book either has it, or knows where it's carved. The Queen can't speak three lines of an oath. Nor can the boy. Find me the true words."
    next: orders_hub
  dravin:
    type: line
    speaker: npc.kosk
    text: "The dwarf who wrote the letter. Assengard, in the pine marches. He holds the old gate's key, if the stories are right. I've written to him. Bring him proof he can't argue with, and he'll come."
    next: orders_hub
  oak:
    type: line
    speaker: npc.kosk
    text: "Hanged Man's Oak. South of Tigg. If it's where they leave their orders, I want those orders. Go carefully; a dead-drop is watched."
    effects: ["add_map_pin(map.hanged_mans_oak)"]
    next: orders_hub
  anselm:
    type: line
    speaker: npc.kosk
    text: "I've told the guard the Abbot sees the boy only with one of my men in the room. It's an insult to a holy man and I'll answer for it. Bring me proof, real proof, and I'll do more."
    effects: ["set_flag(flag.aldric_guard_doubled)"]
    next: orders_hub
  aldric_stays:
    type: line
    speaker: npc.kosk
    text: "The boy stays here, in the east tower, with my best men on the stair. He'll hate it. He'll want to say goodbye. Let him; he listens to you more than to me."
    next: varn_gift
  varn_gift:
    type: branch
    cases:
      - {if: "rep_tier(faction.varn) >= friendly and not flag(flag.varn_exposed)", next: varn_pass}
    else: pay
  varn_pass:
    type: line
    speaker: npc.sergeant_brask
    text: "And this came for you from the Chancellery. Quill brought it himself. A purse and a toll pass for the river roads. With the Chancellor's 'warmest regards'."
    effects: ["add_crowns(150)", "give_item(item.varn_toll_pass, 1)", "set_flag(flag.varn_toll_pass)"]
    next: pay
  pay:
    type: line
    speaker: npc.kosk
    text: "Here's coin for the road. Horses at the Lion Gate. Go south, sellsword. Come back with the cure, the verse and the dwarf, and I'll see you made a knight, if there's still a realm to make knights in."
    effects: ["add_crowns(100)", "set_act(2)", "start_quest(quest.main_a2)", "unlock_map_node(map.tigg)", "unlock_map_node(map.attre)", "unlock_map_node(map.ferrymen_camp)", "set_checkpoint(act2_start)"]
    next: bye
  bye:
    type: end
```

### 5.2 Aldric's farewell (Aldric scene 4)

Played when the player climbs the tower stair after the orders (trigger `t_aldric_farewell` in the palace zone, section 2). Aldric's bond decides what he asks and gives.

```yaml dialogue
id: dlg.aldric_farewell
participants: [npc.aldric]
start: open
nodes:
  open:
    type: line
    speaker: npc.aldric
    text: "They're sending you away. I knew they would. Everyone useful gets sent away and everyone useless stays and pats my head."
    direction: "A small guarded room on the tower stair, a window too narrow to climb. Two of Kosk's men outside. He is trying not to cry and mostly succeeding."
    effects: ["set_flag(flag.aldric_farewell_done)"]
    next: hub
  hub:
    type: choice
    options:
      - id: back
        text: "I'll be back, Highness. With a cure for your mother."
        next: back
      - id: duty
        text: "It's the job. The Marshal pays, I ride."
        next: duty
      - id: sign
        text: "Listen. If anyone ever takes you anywhere at night, anyone, leave me a sign. Scratch a lion with no tail. I'll find it."
        condition: "var(var.aldric_bond) >= 2"
        effects: ["set_flag(flag.aldric_promise)", "add_var(var.aldric_bond, 1)"]
        next: sign
  back:
    type: line
    speaker: npc.aldric
    text: "Promise. On your sword. ...Good. I'll practise every day. Feet first, flat of the blade, step in. When you come back I'll beat you properly."
    next: anselm_check
  duty:
    type: line
    speaker: npc.aldric
    text: "The job. Right. Then do your job and I'll do mine. Mine's living, you said. It's very boring."
    next: anselm_check
  sign:
    type: line
    speaker: npc.aldric
    text: "A lion with no tail. Like the fountain. Like my lion. ...Nobody's going to take me anywhere. But all right. I promise."
    direction: "He says it lightly, the way children promise things they think will never matter."
    next: anselm_check
  anselm_check:
    type: branch
    cases:
      - {if: "flag(flag.heard_aldric_words)", next: words}
    else: close
  words:
    type: line
    speaker: npc.aldric
    text: "Father Anselm says he'll sit with me in the evenings while you're gone, and we'll finish my patience words. All of them. He says I'll need every one."
    next: close
  close:
    type: line
    speaker: npc.aldric
    text: "Go on, then. Before I say something stupid. Go."
    next: bye
  bye:
    type: end
```

### 5.3 Maelis at the gate

Maelis joins as a companion at the end of Act I if the Abbey is Friendly and she was never accused (gdd §6.13: "Act I end (Abbey Friendly, or the scriptorium quest done)"). A07's scriptorium quest also recruits her; if she is already in the party this dialogue does not play (trigger `t_maelis_gate` in the palace zone, section 2).

```yaml dialogue
id: dlg.maelis_joins
participants: [npc.maelis]
start: open
nodes:
  open:
    type: line
    speaker: npc.maelis
    text: "I heard about the Fair. I heard you're riding south. I... I can't stay in that house. Every time he blesses me I want to scream. Take me with you."
    direction: "At the palace gatehouse, a satchel of books over her shoulder, a sling and a pouch of stones at her belt."
    next: hub
  hub:
    type: choice
    options:
      - id: yes_come
        text: "Come. I could use someone who reads dwarven."
        effects: ["recruit(companion.maelis)", "set_flag(flag.maelis_joined_a1)", "add_rep(faction.abbey, 5)"]
        next: joined
      - id: why
        text: "Can you fight?"
        next: why
      - id: stay
        text: "Stay. Watch him. I need eyes inside the Abbey more than I need a sling."
        effects: ["set_flag(flag.maelis_stays_watch)"]
        next: stay
  why:
    type: line
    speaker: npc.maelis
    text: "I grew up herding geese in Verden. I can hit a fox at forty paces with a sling. I can also read Old Dwarvish, which I suspect will matter more."
    next: hub
  joined:
    type: line
    speaker: npc.maelis
    text: "Thank you. I've brought the chronicles that quote the Oath, a sling, and bread. I didn't know what else people bring."
    next: bye
  stay:
    type: line
    speaker: npc.maelis
    text: "Eyes inside. Yes. Yes, I can do that. If I write to you, the letters will come through Bertha at the Drowned Rat. Nobody reads a tavern's mail."
    next: bye
  bye:
    type: end
```

## 6. Encounters

The stage-1 hub ambush by Varn's toughs (gdd §6.12: Varn Hostile adds a thug ambush on the first hub visit after stage 1) is defined here; its trigger lives in the hub zone (section 2, `t_varn_ambush`).

```yaml encounter
id: enc.hub_varn_ambush
zone: zone.cintra_streets
enemies:
  - {enemy: enemy.choir_thug, count: 2, spawn: alley_mouth, variant: varn_tough}
  - {enemy: enemy.bandit, count: 1, spawn: alley_mouth, variant: hired_guard}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: hub_square
avoidable_by: []
on_won: ["add_xp(40)"]
on_yielded: ["add_xp(40)"]
on_player_fled: []
```

`varn_tough` uses the Choir thug stat block with Chancellery blue cord instead of feathers. They are Varn's men, not the Choir's.

## 7. Items and clues

```yaml item
id: item.varn_toll_pass
name: "Chancellery toll pass"
category: document
description: "A pass under the Chancellery seal: the bearer travels the Crown's river and toll roads free. Varn's 'warmest regards'."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Let the bearer pass all tolls of the Yaruga and the Marnadal roads without fee or hindrance. By order of the Chancellery. O. Varn, Chancellor."
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: flag.aldric_guard_doubled, type: bool, desc: "Kosk ordered a guard present whenever Anselm sees Aldric (A05: the twist must explain how the guard was bribed or drugged)."}
  - {id: flag.varn_toll_pass, type: bool, desc: "Varn (Friendly) sent 150 crowns and a toll pass (gdd §6.12: Act II pass on the toll road)."}
  - {id: flag.aldric_farewell_done, type: bool, desc: "Aldric's farewell scene has played."}
  - {id: flag.aldric_promise, type: bool, desc: "Aldric promised to leave a tailless-lion sign if taken at night. A05: scratched lions mark the catacomb trail at the twist."}
  - {id: flag.maelis_joined_a1, type: bool, desc: "Maelis joined the party at the end of Act I."}
  - {id: flag.maelis_stays_watch, type: bool, desc: "The player asked Maelis to stay and watch the Abbey (letters via Bertha)."}
reads:
  - ms.act1_complete
  - flag.pell_arrested
  - flag.fair_assassin_captured
  - flag.varn_exposed
  - flag.varn_blackmailed
  - flag.heard_aldric_words
  - var.aldric_bond
  - flag.maelis_accused
  - flag.maelis_showed_book
  - flag.varn_ambush_done
```

## 9. Quest hooks

```yaml quest_stages
quest: quest.main_a1
order: 60
stages:
  - id: orders_south
    journal: "The Choir struck at the heir and failed. Kosk is sending me south down the Marnadal road for three things: a cure for the Queen's poison, the true fourth verse, and Dravin Ostrel. The Prince stays in Cintra."
    objectives:
      - {id: orders, text: "Take the Marshal's orders", condition: "act() >= 2", optional: false}
      - {id: farewell, text: "Say goodbye to Prince Aldric", condition: "flag(flag.aldric_farewell_done)", optional: true, xp: 20}
    on_complete: []
    next: []
```

## 10. Rumors and event cards (optional)

None. Stage 1 adds rumors to the pool (A07).

## 11. Failure states and branches

```yaml branches
paths:
  - id: orders
    when: "Always, on arriving in the war room from the Fair."
    outcome: "Act 2 set, quest.main_a2 started, Tigg, Attre and the Ferrymen's Camp unlocked; Witch's Mere and Hanged Man's Oak pinned."
    sets: ["set_act(2)", "start_quest(quest.main_a2)"]
  - id: maelis_joins
    when: "Abbey Friendly, Maelis not accused, she has shown the book, and she is not already a companion; the player accepts."
    outcome: "companion.maelis recruited."
    sets: ["recruit(companion.maelis)"]
  - id: maelis_watches
    when: "The player asks her to stay."
    outcome: "Maelis stays in the Abbey (A05: she is in danger there; A07's scriptorium quest still available)."
    sets: ["set_flag(flag.maelis_stays_watch)"]
  - id: aldric_promise
    when: "Bond >= 2 and the player asks for a sign."
    outcome: "flag.aldric_promise for the Act II twist."
    sets: ["set_flag(flag.aldric_promise)"]
failures:
  - id: skip_farewell
    result: soft_fail
    recover: "The farewell is optional. Without it there is no promise flag; Act II still works."
guarantees:
  - "set_act(2) and start_quest(quest.main_a2) are on dlg.kosk_orders_south's only path to its end; no checks."
```

## 12. Open questions

1. **Map unlocks.** gdd §7.1 says "the map unlocks the valley nodes and Attre". I unlocked `map.tigg`, `map.attre` and `map.ferrymen_camp` and pinned `map.witchs_mere` and `map.hanged_mans_oak`. A05 should confirm the Act II starting set.
2. **Stage-1 courier.** gdd §6.1 says a courier brings the stage-1 news "to wherever the player is". Here the player is already in the war room, so Brask's report plays that role.
