---
section_id: a2.08
title: "The Return to Cintra and the Abduction"
act: 2
story_ref: "story.md §6 The Act II Twist, §3 Queen Ysolde and Prince Aldric, §11 rumor 9; gdd §6.2 twist resolution, §7.2 Act II gate"
zones: [zone.palace_sickroom, zone.abbey_catacombs]
available_when: "ms(ms.a2_wenna_line_resolved) and ded(ded.anselm_treason_proven) and has_item(item.true_fourth_verse) and not ms(ms.act2_twist)"
escalation_stage_required: {min: 3, max: 4}
milestones_set: [ms.a2_return_cintra, ms.act2_twist]
milestones_read: [ms.a2_return_cintra, ms.a2_wenna_line_resolved, ms.act2_twist]
level_band: [8, 9]
---

# The Return to Cintra and the Abduction

## 1. Scene summary
The player rides back into Cintra with proof that the Queen's confessor is her poisoner, the true fourth verse in a leather case, and, if things went well, Wenna's cure. Kosk meets them at the sickroom door. Here the antidote line resolves. If a rider got through or the player carries a dose, Ysolde lives. If her mind is clear enough, she formally invests Prince Aldric as Co-Sovereign with the Lion's Crown. If she is comatose, Kosk invests him by emergency writ. If no cure came, the Queen dies in the night with her son holding her hand, and Kosk crowns a twelve-year-old king. Kosk means to arrest Anselm at dawn, once the boy is crowned and the Abbey's sanctuary can be broken under the new sovereign's seal. That delay is exactly what Anselm was waiting for: the lock needs a crowned voice, and the Crown has just made one. In the night the bells ring unbidden. Aldric is gone from his bed, his guards drugged, and the Abbot has vanished from St. Corwen. The player follows the trail down into the catacombs beneath the Abbey, fights through the Choir rear guard, and reaches the river sluice in time to see that the boat is gone. Scratched on the wall is a lion with no tail and one word in a boy's hand: OSTREL. The section ends with `ms.act2_twist` and the turn to Act III.

## 2. Progress and escalation
- **`ms.a2_return_cintra`** (new, not one of the seven Act II progress milestones) is reached on Kosk's first line in the twist sickroom (`dlg.twist_kosk/greet`). Its only job is to "fire a milestone", so the antidote system resolves a rider who is still on the road (gdd §6.2: "the next time a milestone fires") before the Queen's fate is decided.
- **Twist resolution** (gdd §6.2), run in `dlg.twist_kosk` / `dlg.twist_investiture`:
  1. If the player carries `item.wenna_antidote` and `flag.antidote_administered` is not set, the dose is given automatically (`administer_antidote(queen)`).
  2. `flag.queen_alive` is set if `flag.antidote_administered`.
  3. Alive and `queen() <= 2` gives `flag.aldric_co_sovereign` (Ysolde invests him). Alive and `queen() == 3` gives `flag.aldric_emergency_writ` (Kosk invests him). Not alive gives `flag.aldric_crowned_king` (the Queen dies; Kosk crowns him).
- **`ms.act2_twist`** is reached when the abduction is discovered (`dlg.twist_abduction`). The escalation stage becomes 4 (Solstice): "Prince Aldric has been abducted" is the stage card. `set_act(3)` and `start_quest(quest.main_a3)` fire at the catacomb sluice, the last beat of Act II.
- The section starts at stage 3 (the Act II gate forces it) and ends at stage 4.
- **Deviation note:** gdd §6.2 says the twist resolution happens "at `ms.act2_twist`". Here it runs just before it, right after `ms.a2_return_cintra`, because the investiture must happen *before* the abduction (Anselm needs the crowned boy). The facts it sets are identical. Logged in the report.

## 3. Location layout

**The sickroom, twist variant** (`zone.palace_sickroom`, owned by act1; this section adds a variant, see the integration patch below). It is night, a fire in the grate, and Kosk's own men on the door. The Queen's bed is curtained, with Aldric on a stool beside it. A side table holds the Lion's Crown on a cushion, brought from the treasury for the investiture. The windows look across the river to the Abbey's dark bell tower.

**The catacombs beneath St. Corwen** (`zone.abbey_catacombs`, dungeon, about 90 × 50 m, a linear chase with two side pockets).
1. **Palace stair** (entry): a narrow stair from the palace chapel's crypt (behind a tomb slab that is now open) down 12 m into the old catacomb line. Drugged guards lie on the steps.
2. **Ossuary gallery:** a 40 m corridor lined floor to vault with skulls and long bones in patterns (lions, crowns). Wall niches give half cover. A **trip-wire oil trap** is strung across the gallery's midpoint: a cord to a pot of lamp oil over a candle (`fire` hazard; Investigate 4 to spot and cut, otherwise it bursts into a 4 m fire wall that blocks the gallery for 10 s and burns).
3. **Servants' junction:** a crossroads chamber where the passage from the palace kitchens joins (the bribed servants' route). Overturned lantern, a dropped kitchen apron, a dropped pale feather. The **rear guard** waits here (`enc.catacomb_rearguard`).
4. **Abbots' tombs** (side pocket, north): carved effigies of St. Corwen's abbots. The newest niche is empty and carved ready: *ANSELM, Abbot*. A hidden cache in it holds Anselm's spare purse and a letter.
5. **Flooded crypt:** a 20 m stretch of knee-deep river seep (`deep_mud`). Fallen masonry gives cover.
6. **Abbey crypt stair** (side exit, south): up into the Abbey of St. Corwen (`zone.abbey_st_corwen`, act1).
7. **Sluice chamber:** the river exit, an iron sluice gate on the Yaruga with a mooring ring and cut ropes. The boat is gone. On the wall by the ring, a tailless lion and the word OSTREL are scratched with a ring-stone (Aldric's sign from Act I, `flag.aldric_promise`).

```text
INTEGRATION PATCH for zone.palace_sickroom (owned by act1/03-sickroom-red-herring.md).
Please add to that zone block:

spawns:
  - {id: twist_door, area: <sickroom door area>}
interactables:
  - id: give_antidote_by_hand
    area: <bedside area>
    kind: lever
    label: "Give the Queen the counter-dose"
    condition: "has_item(item.wenna_antidote) and not flag(flag.antidote_administered) and not ms(ms.act2_twist)"
    check: null
    once: true
    effects: ["administer_antidote(queen)"]
triggers:
  - id: twist_return
    area: <sickroom door area>
    on: enter
    source: null
    condition: "ms(ms.a2_wenna_line_resolved) and ded(ded.anselm_treason_proven) and has_item(item.true_fourth_verse) and not flag(flag.twist_started)"
    once: true
    effects: ["set_flag(flag.twist_started)", "start_dialogue(dlg.twist_kosk)"]
beats:
  - {id: queen_dies, description: "Ysolde's breathing stops between one word and the next. Aldric does not let go of her hand."}
  - {id: investiture, description: "Ysolde (or Kosk) sets the Lion's Crown on Aldric's head; the guards on the door kneel."}
  - {id: night_falls, description: "Fade. Candles burnt low. The palace sleeps."}
  - {id: bells_at_night, description: "Across the river the Abbey bells ring, unbidden, wrong, all at once."}
variants:
  - id: twist_night
    when: "flag(flag.twist_started)"
    description: "Night. Kosk's men on the door, the Crown on a cushion by the bed, Aldric on a stool."
    npcs_absent: [npc.anselm]
    encounters_disabled: []
    interactables_disabled: []
exits:
  - id: to_catacombs
    area: <sickroom door area>
    to_zone: zone.abbey_catacombs
    to_spawn: palace_stair
    condition: "ms(ms.act2_twist)"
    effects: []

The map's "Return to Cintra" action (unlocked by the Act II gate) should place the player at
zone.palace_sickroom / twist_door.
```

```yaml zone
id: zone.abbey_catacombs
name: "The Catacombs of St. Corwen"
kind: dungeon
map_node: map.cintra
time_of_day: night
cold_rate: 0
disguise_tag: null
music: catacomb_pursuit
areas:
  - {id: palace_stair, description: "Narrow stair 12 m down from the palace chapel crypt. Drugged guards on the steps. Entry."}
  - {id: ossuary_gallery, description: "40 m corridor lined with skulls and long bones in lion and crown patterns. Wall niches (half cover). Oil trip-wire at the midpoint."}
  - {id: servants_junction, description: "Crossroads chamber where the kitchen passage joins. Overturned lantern, apron, a pale feather. The rear guard."}
  - {id: abbots_tombs, description: "North side pocket: abbots' effigies; the newest niche carved 'ANSELM, Abbot', empty, with a hidden cache."}
  - {id: flooded_crypt, description: "20 m of knee-deep river seep, fallen masonry for cover."}
  - {id: abbey_crypt_stair, description: "South side exit up into the Abbey of St. Corwen."}
  - {id: sluice_chamber, description: "Iron sluice gate on the Yaruga, a mooring ring with cut ropes. A tailless lion and 'OSTREL' scratched by the ring."}
spawns:
  - {id: palace_stair, area: palace_stair, default: true}
  - {id: abbey_gate, area: abbey_crypt_stair}
  - {id: junction, area: servants_junction}
  - {id: kitchen_passage, area: servants_junction}
  - {id: crypt_water, area: flooded_crypt}
exits:
  - id: back_to_palace
    area: palace_stair
    to_zone: zone.palace_sickroom
    to_spawn: twist_door
    condition: "true"
    effects: []
  - id: to_abbey
    area: abbey_crypt_stair
    to_zone: zone.abbey_st_corwen
    to_spawn: catacomb_gate
    condition: "true"
    effects: []
interactables:
  - id: drugged_guard
    area: palace_stair
    kind: search
    label: "Check the drugged guard"
    condition: "true"
    check: null
    once: true
    effects: ["add_clue(clue.guards_drugged)"]
  - id: oil_wire
    area: ossuary_gallery
    kind: lever
    label: "Cut the cord across the gallery"
    condition: "not flag(flag.oil_wire_cut)"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["set_flag(flag.oil_wire_cut)"]
    fail_effects: ["play_beat(oil_burst)"]
  - id: anselm_niche
    area: abbots_tombs
    kind: container
    label: "Search the empty niche carved with Anselm's name"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.anselm_last_letter, 1)", "add_crowns(90)"]
  - id: ring_mark
    area: sluice_chamber
    kind: readable
    label: "Look at the marks by the mooring ring"
    condition: "true"
    check: null
    once: true
    effects: ["add_clue(clue.aldric_catacomb_mark)"]
  - id: river_end
    area: sluice_chamber
    kind: lever
    label: "Look out over the river"
    condition: "has_clue(clue.aldric_catacomb_mark)"
    check: null
    once: true
    effects: ["play_beat(empty_river)", "start_dialogue(dlg.twist_sluice)"]
triggers:
  - id: rearguard
    area: servants_junction
    on: enter
    source: null
    condition: "not flag(flag.rearguard_beaten)"
    once: true
    effects: ["set_checkpoint(junction_cp)", "play_beat(rearguard_waits)", "start_encounter(enc.catacomb_rearguard)"]
  - id: oil_trap_walk
    area: ossuary_gallery
    on: enter
    source: null
    condition: "not flag(flag.oil_wire_cut) and not flag(flag.oil_trap_sprung)"
    once: true
    effects: ["set_flag(flag.oil_trap_sprung)"]
hazards:
  - {id: oil_wall, area: ossuary_gallery, kind: fire, params: {active_after_beat: oil_burst, damage_per_second: 8, duration_s: 10, disabled_by_flag: flag.oil_wire_cut}}
  - {id: seep, area: flooded_crypt, kind: deep_mud, params: {speed_mult: 0.7}}
checkpoints:
  - {id: catacomb_entry, area: palace_stair}
  - {id: junction_cp, area: servants_junction}
beats:
  - {id: oil_burst, description: "A cord parts, a pot of lamp oil tips onto a candle, and a wall of fire fills the gallery."}
  - {id: rearguard_waits, description: "Lanterns snuff out in the junction. Grey robes step out of the niches, Brother Ambrose of St. Corwen at their head; two kitchen boys with cleavers hang back, terrified."}
  - {id: empty_river, description: "The sluice opens on the black Yaruga. Far off, a lantern on a boat, going upriver, south, toward the hills. Then nothing."}
npcs: []
encounters: [enc.catacomb_rearguard]
loot:
  - {container: anselm_niche, items: [{item: item.field_draught, count: 1}], condition: "true"}
variants: []
```

## 4. NPCs present
This section references NPCs declared by act1: `npc.kosk`, `npc.ysolde`, `npc.aldric`, `npc.varn`, `npc.maelis` (and `companion.maelis`), and `npc.anselm` (absent). It declares one new minor NPC.

**Voice notes.** Kosk: clipped, tired, a soldier who has decided something terrible is necessary and is doing it carefully. Ysolde: precise, dry, every sentence costing her; she speaks to her son as a queen first and a mother second, and lets the order slip once. Aldric: proud, trying to sound older, a twelve-year-old's sudden honesty; he trusts the player (Act I) and also trusts "Father Anselm". Hew: a kitchen boy who took Choir silver and now wishes he hadn't.

```yaml npc
id: npc.hew
name: "Hew"
faction: faction.choir
role: "Palace kitchen boy, bribed to open the kitchen passage"
motive: "Not to hang for what he did for six silver bars."
secret: "He heard the Abbot tell the prince they were going 'to the mountain, before the sun turns', and the prince went quietly."
disposition: wary
essential: false
dialogue: dlg.hew_yields
barks: ["I didn't know! I didn't know!", "Six bars. Only six.", "Don't let them hang me."]
combat: enemy.choir_thug
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.twist_kosk
participants: [npc.kosk]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.kosk
    text: "You're back. You look like the road chewed you. Inside, quietly. She sleeps more than she wakes now. Tell me you brought what I sent you for."
    direction: "At the sickroom door, his own men on the stairs, no palace livery in sight."
    effects: ["reach_milestone(ms.a2_return_cintra)"]
    next: rider
  rider:
    type: branch
    cases:
      - {if: "flag(flag.antidote_rider_sent) and flag(flag.antidote_rider_intercepted)", next: rider_lost}
      - {if: "flag(flag.antidote_rider_sent) and flag(flag.antidote_administered) and flag(flag.rider_escort_hired)", next: rider_escort_ok}
      - {if: "flag(flag.antidote_rider_sent) and flag(flag.antidote_administered)", next: rider_ok}
    else: proof
  rider_lost:
    type: line
    speaker: npc.kosk
    text: "Your rider. A boy on a marsh pony. We found him on the Tigg road with his throat cut and a feather in his mouth. The flask was smashed. I'm sorry. He rode well."
    next: proof
  rider_ok:
    type: line
    speaker: npc.kosk
    text: "Your rider came through. A boy on a marsh pony, half dead in the saddle. The Queen's physician gave it to her with my hand on his wrist. She's... better. Not well. Better."
    next: proof
  rider_escort_ok:
    type: line
    speaker: npc.kosk
    text: "Your rider came up the river in a skiff full of Jory's cutthroats, if you'll believe it. They wouldn't leave the boy's side till the dose was in her. She's better."
    next: proof
  proof:
    type: branch
    cases:
      - {if: "has_item(item.anselm_journal)", next: proof_journal}
    else: proof_ledger
  proof_journal:
    type: line
    speaker: npc.kosk
    text: "Anselm. In his own hand. Her confessor. I let him in this room every morning for a year and held the door for him. God's blood. Every word of this hangs him."
    direction: "Reading the journal by the fire, his jaw working."
    next: proof_more
  proof_ledger:
    type: line
    speaker: npc.kosk
    text: "The cipher in Anselm's hand, and the Duke's own ledger paid in Abbey silver. Her confessor. I held the door for him every morning. That hangs him. That hangs him twice."
    next: proof_more
  proof_more:
    type: branch
    cases:
      - {if: "flag(flag.oswy_witness)", next: oswy}
    else: plan
  oswy:
    type: line
    speaker: npc.kosk
    text: "And your novice, Oswy. He's in my cells singing like a lark. Kitchen passages, couriers, the cellarer's lily. He'll live, if he keeps singing."
    next: plan
  plan:
    type: line
    speaker: npc.kosk
    text: "The Abbot is keeping vigil in St. Corwen. Sanctuary. I can't break it without the sovereign's seal, and the sovereign is in that bed. So: the boy is invested tonight. At dawn, under his seal, I take Anselm."
    next: plan_choice
  plan_choice:
    type: choice
    options:
      - id: now
        text: "Take him now. Sanctuary or not. Every hour he's free is a knife."
        next: now
      - id: guard_boy
        text: "Then double the guard on Aldric tonight. Your men, not the palace's."
        next: guard_boy
      - id: publish
        text: "[Item: Raimund's ledger] One more thing. This ledger. Publish it. The realm should know what Attre sold."
        tag: item
        condition: "has_item(item.raimund_ledger) and not flag(flag.raimund_ledger_published)"
        next: publish
      - id: agree
        text: "Dawn, then."
        next: to_queen
  now:
    type: line
    speaker: npc.kosk
    text: "And have the Chancellor tell the court I broke sanctuary on a dying woman's watch, the night before a crowning? No. Dawn. He's an old priest in a locked church. Where would he go?"
    next: plan_choice
  guard_boy:
    type: line
    speaker: npc.kosk
    text: "Already done. Six of mine on his door. I'm not a fool. Not twice."
    next: plan_choice
  publish:
    type: branch
    cases:
      - {if: "flag(flag.raimund_allied)", next: publish_allied}
    else: publish_plain
  publish_allied:
    type: line
    speaker: npc.kosk
    text: "Raimund. Who you tell me swore to close his ports to the Choir. You want me to cry this from the steps and make him an enemy in the same breath? Are you sure?"
    next: publish_confirm
  publish_plain:
    type: line
    speaker: npc.kosk
    text: "The Duke of Attre sold the lily that is killing my Queen. Yes. I'll have it read on the cathedral steps. Attre will scream. Let it."
    effects: ["set_flag(flag.raimund_ledger_published)", "add_rep(faction.attre, -30)", "add_rep(faction.crown, 10)"]
    next: plan_choice
  publish_confirm:
    type: choice
    options:
      - id: yes
        text: "Publish it. He sold the poison. Let him answer."
        next: publish_betray
      - id: no
        text: "No. Keep it. He may yet be worth more as a friend."
        next: plan_choice
  publish_betray:
    type: line
    speaker: npc.kosk
    text: "So be it. You've a harder heart than I took you for. Attre will remember."
    effects: ["set_flag(flag.raimund_ledger_published)", "clear_flag(flag.raimund_allied)", "add_rep(faction.attre, -60)", "add_rep(faction.crown, 10)"]
    next: plan_choice
  to_queen:
    type: branch
    cases:
      - {if: "has_item(item.wenna_antidote) and not flag(flag.antidote_administered)", next: give_dose}
    else: resolve
  give_dose:
    type: line
    speaker: npc.kosk
    text: "The witch's cure? Give it here. No, you do it. My hands aren't steady enough tonight."
    direction: "The player tips the vial between the Queen's lips. She coughs, swallows, sleeps."
    effects: ["administer_antidote(queen)"]
    next: resolve
  resolve:
    type: branch
    cases:
      - {if: "flag(flag.antidote_administered)", next: alive}
    else: dying
  alive:
    type: effect
    effects: ["set_flag(flag.queen_alive)", "start_dialogue(dlg.twist_investiture)"]
    next: bye
  dying:
    type: effect
    effects: ["start_dialogue(dlg.twist_investiture)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.twist_investiture
participants: [npc.ysolde, npc.aldric, npc.kosk, npc.varn]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "flag(flag.queen_alive) and queen() <= 2", next: queen_wakes}
      - {if: "flag(flag.queen_alive)", next: comatose}
    else: death
  queen_wakes:
    type: line
    speaker: npc.ysolde
    text: "Bertran. You've let a sellsword into my bedroom. Again. ...You. Kosk tells me I owe you my breath. I don't like owing. Come here so I can see you."
    direction: "Propped on pillows, grey under the eyes but lucid, one hand trembling on the coverlet."
    next: queen_thanks
  queen_thanks:
    type: line
    speaker: npc.ysolde
    text: "My confessor. Twelve years I told that man my sins and he fed me his. Well. I'll not die to please him. Aldric. Kneel. No, not there. Here, where I can reach."
    next: varn_protest
  varn_protest:
    type: line
    speaker: npc.varn
    text: "Majesty, this is most irregular. A co-sovereign at twelve, at night, without the council..."
    direction: "In the doorway in a dressing gown, flanked by Kosk's men who did not let him further."
    next: queen_silences
  queen_silences:
    type: line
    speaker: npc.ysolde
    text: "So is poison, Orsik. Go to bed."
    next: invest
  invest:
    type: line
    speaker: npc.ysolde
    text: "Aldric, son of Ysolde, of Corvan's line. I name you Co-Sovereign of Cintra, to rule with me while I live and alone when I don't. Wear it. It's heavier than it looks. So is everything."
    effects: ["set_flag(flag.aldric_co_sovereign)", "play_beat(investiture)"]
    next: aldric
  comatose:
    type: line
    speaker: npc.kosk
    text: "She took the cure, but she's too far gone to wake for it. She breathes. That's what we have. And the boy needs the Crown's authority tonight, not when she opens her eyes."
    direction: "The Queen is still, her breathing slow and even. Varn hovers in the doorway."
    next: writ
  writ:
    type: line
    speaker: npc.kosk
    text: "By emergency writ of the Lord Marshal, in the Queen's incapacity: Aldric, her son, is Co-Sovereign of Cintra with the Lion's Crown. Chancellor, you'll witness. Sign it."
    effects: ["set_flag(flag.aldric_emergency_writ)", "play_beat(investiture)"]
    next: aldric
  death:
    type: line
    speaker: npc.ysolde
    text: "Aldric. Don't cry where they can see. Cry later. Listen. There's a lock under the mountain. Every nineteen years... Bertran knows. Learn it. Don't let anyone teach you to say it wrong."
    direction: "Barely a whisper. Aldric holds her hand. Kosk stands at the bed's foot."
    next: death_2
  death_2:
    type: line
    speaker: npc.ysolde
    text: "You were always braver than me. Be..."
    effects: ["play_beat(queen_dies)"]
    next: crowned
  crowned:
    type: line
    speaker: npc.kosk
    text: "The Queen is dead. Long live the King. Aldric. Majesty. Stand up. I'm sorry. Stand up. Cintra needs to see a king tonight, not a boy."
    direction: "He lifts the Crown from its cushion with both hands."
    effects: ["set_flag(flag.aldric_crowned_king)", "play_beat(investiture)"]
    next: aldric
  aldric:
    type: branch
    cases:
      - {if: "flag(flag.aldric_trusts_player)", next: aldric_trust}
    else: aldric_plain
  aldric_plain:
    type: line
    speaker: npc.aldric
    text: "It's heavy. She said it would be. You're the Marshal's sellsword. You came back. Father Anselm says the mountain listens to kings now. Do you think it's listening to me?"
    direction: "The Crown sitting low on his brow."
    next: aldric_choice
  aldric_trust:
    type: line
    speaker: npc.aldric
    text: "It's heavy. She said it would be. ...You came back. I knew you would. Father Anselm says the mountain listens to kings now. Do you think it's listening to me?"
    direction: "The Crown sitting low on his brow. He looks at the player, not at Kosk."
    next: aldric_choice
  aldric_choice:
    type: choice
    options:
      - id: warn
        text: "Aldric. Listen to me. Anselm is the one who poisoned your mother. If he comes to you, if he asks you to say anything, any words at all, you refuse. Promise me."
        next: warn
      - id: brave
        text: "I think the mountain had better listen. You're the King's voice now."
        next: brave
      - id: quiet
        text: "Get some sleep, your Grace. Kosk's men are on your door."
        next: quiet
  warn:
    type: line
    speaker: npc.aldric
    text: "Father Anselm? No. He... he taught me the old words. He said they were a secret between kings. I promise. I promise. I won't say them for anyone."
    direction: "Pale. Then nodding hard."
    effects: ["set_flag(flag.aldric_warned)"]
    next: night
  brave:
    type: line
    speaker: npc.aldric
    text: "The King's voice. Yes. I'll practise. Father Anselm says I already know the words better than anyone."
    next: night
  quiet:
    type: line
    speaker: npc.aldric
    text: "Six of Kosk's men. Six. I'm not a porcelain doll, you know. But. Thank you."
    next: night
  night:
    type: effect
    effects: ["play_beat(night_falls)", "play_beat(bells_at_night)", "reach_milestone(ms.act2_twist)", "start_dialogue(dlg.twist_abduction)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.twist_abduction
participants: [npc.kosk, npc.maelis]
start: alarm
nodes:
  alarm:
    type: line
    speaker: npc.kosk
    text: "He's gone. The boy's gone. Six men on his door, all six asleep on their feet. Wine from the kitchens. And the Abbey's just sent word: the Abbot left his vigil at midnight and never came back."
    direction: "In the corridor outside Aldric's room in shirtsleeves, a sword in his hand, the bells still ringing across the river."
    next: guard_note
  guard_note:
    type: branch
    cases:
      - {if: "flag(flag.aldric_guard_doubled)", next: guard_doubled}
    else: hinges
  guard_doubled:
    type: line
    speaker: npc.kosk
    text: "The guard I set on the Abbot's visits after you warned me. Asleep too. He never came near the boy tonight. He didn't need to. The kitchens did it for him."
    next: hinges
  hinges:
    type: branch
    cases:
      - {if: "has_clue(clue.catacomb_hinges)", next: hinges_line}
    else: how
  hinges_line:
    type: line
    speaker: player
    text: "The catacomb gate in the Abbey crypt. Its hinges were fresh-oiled when I saw it. They've been using that road for weeks."
    next: how
  how:
    type: branch
    cases:
      - {if: "in_party(companion.maelis)", next: maelis_here}
      - {if: "not flag(flag.maelis_dead)", next: maelis_arrives}
      - {if: "flag(flag.liss_left)", next: liss_arrives}
    else: kosk_finds
  maelis_here:
    type: line
    speaker: npc.maelis
    text: "The catacombs. There's a passage from the Abbey crypt that comes up under the palace chapel. Anselm showed me the plans once, as a curiosity. He was showing me a door."
    next: go
  maelis_arrives:
    type: line
    speaker: npc.maelis
    text: "I ran from the Abbey when the bells started. The catacombs. There's a passage from our crypt to the palace chapel. Anselm showed me once. He was showing me a door."
    direction: "Out of breath at the corridor's end, a lantern and a ring of keys in her fists."
    next: go
  liss_arrives:
    type: line
    speaker: npc.kosk
    text: "A novice from Vel Aram came to the gate an hour ago, a girl, Liss. She says you sent her. She says the Abbot used to talk about a passage under the chapel. The catacombs."
    next: go
  kosk_finds:
    type: line
    speaker: npc.kosk
    text: "The chapel crypt. The slab on the old abbot's tomb has been moved. There's a stair under it. Into the catacombs. Go. I'll seal the gates and the river."
    next: go
  go:
    type: choice
    options:
      - id: down
        text: "I'm going down."
        next: down
  down:
    type: effect
    effects: ["set_checkpoint(catacomb_entry)", "goto_zone(zone.abbey_catacombs, palace_stair)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.hew_yields
participants: [npc.hew]
start: beg
nodes:
  beg:
    type: line
    speaker: npc.hew
    text: "Don't! Don't, I didn't know, I only opened the kitchen door and poured the wine! Six bars! He said the prince would be safe, he said the prince wanted to go!"
    direction: "On his knees in the junction, cleaver dropped, apron bloody from a cut hand."
    next: hub
  hub:
    type: choice
    options:
      - id: where
        text: "Where are they taking him?"
        next: where
      - id: wanted
        text: "Wanted to go?"
        next: wanted
      - id: spare
        text: "Get up the stair. Tell the Marshal everything. Maybe he lets you live."
        next: spare
      - id: kill
        text: "(Kill him.)"
        next: kill
  where:
    type: line
    speaker: npc.hew
    text: "The river, a boat at the sluice, south. The Abbot said, 'to the mountain, before the sun turns.' The Stairs. He said the Marnadal Stairs."
    effects: ["add_clue(clue.anselm_route_stairs)"]
    next: hub
  wanted:
    type: line
    speaker: npc.hew
    text: "He didn't fight. The Abbot talked to him, soft, and the prince just... went. Saying words. Funny words. Like a song backwards."
    effects: ["verify_rumor(rumor.r09_aldric_dwarven)"]
    next: hub
  spare:
    type: line
    speaker: npc.hew
    text: "Yes. Yes. Thank you. I'll tell him all of it."
    effects: ["set_flag(flag.hew_spared)"]
    next: bye
  kill:
    type: line
    speaker: npc.hew
    text: "No..."
    effects: ["set_flag(flag.hew_killed)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.twist_sluice
participants: [npc.maelis]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "in_party(companion.maelis)", next: maelis}
    else: alone
  maelis:
    type: line
    speaker: npc.maelis
    text: "A lion with no tail, and Ostrel. He wrote it with his ring. He knew where they were taking him and he told us. That's a king. Now we have to get there before the sun does."
    direction: "Touching the scratched lion with two fingers."
    next: end_act
  alone:
    type: branch
    cases:
      - {if: "flag(flag.aldric_promise)", next: alone_promise}
    else: alone_plain
  alone_promise:
    type: line
    speaker: player
    text: "A tailless lion. He promised he'd leave one wherever they took him, and he kept it. Ostrel. The courier's last word, and now his."
    next: end_act
  alone_plain:
    type: line
    speaker: player
    text: "Ostrel. The courier's last word. The boy's last word. All roads lead to the same door."
    next: end_act
  end_act:
    type: effect
    effects: ["set_act(3)", "start_quest(quest.main_a3)", "add_map_pin(map.stairs_foot)"]
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.catacomb_rearguard
zone: zone.abbey_catacombs
enemies:
  - {enemy: enemy.choir_zealot, count: 2, spawn: junction, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: crypt_water, variant: null}
  - {enemy: enemy.choir_thug, count: 2, spawn: kitchen_passage, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: [npc.maelis]
checkpoint: junction_cp
avoidable_by: []
on_won: ["set_flag(flag.rearguard_beaten)", "start_dialogue(dlg.hew_yields)"]
on_yielded: ["set_flag(flag.rearguard_beaten)", "start_dialogue(dlg.hew_yields)"]
on_player_fled: []
```
Design: the short fight the gdd asks for. Two zealots hold the junction, a crossbowman fires from the flooded crypt beyond, and two bribed kitchen boys (thugs, `can_yield`) hang back and yield at the first hit under 20%. Hew is one of them; the encounter always ends in his yield dialogue (if the player killed both boys, Hew is played as the one who crawled behind the lantern; he is scripted to survive to the dialogue). Zealot self-immolation in the narrow junction is the main danger. Maelis (if in the party) fights with her sling.

## 7. Items and clues

```yaml item
id: item.anselm_last_letter
name: "Anselm's letter to the Queen"
category: document
description: "Sealed, addressed 'To Ysolde, after', in the empty niche carved with his name."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Ysolde. If you read this you have lived, which I did not intend, or you are dead and someone kinder reads it. I loved you as a confessor loves a penitent: knowing everything, forgiving nothing. Your father's men burned children at Marnadal and you signed the indemnity. Your son will open the door the Lion shut, and what comes out will not care whose blood is noble. I am sorry it must be him. He is the best of you. - Anselm."
```

```yaml clue
id: clue.guards_drugged
theory: theory.choir
title: "Wine from the kitchens"
text: "Aldric's guards were drugged with wine sent up from the palace kitchens: grey lily in a stronger measure, enough to stand them asleep."
supports: [anselm]
refutes: []
```

```yaml clue
id: clue.aldric_catacomb_mark
theory: theory.anselm_plan
title: "OSTREL, in a boy's hand"
text: "At the catacomb sluice, scratched with a ring-stone: a lion with no tail, and one word, OSTREL. Aldric's mark, the broken-tailed lion of his wooden toy. He knows where he is being taken, and he left a trail."
supports: [anselm]
refutes: []
```

```yaml clue
id: clue.anselm_route_stairs
theory: theory.anselm_plan
title: "To the mountain before the sun turns"
text: "A bribed kitchen boy heard Anselm promise Aldric they would reach 'the mountain, before the sun turns', by boat upriver and then the Marnadal Stairs."
supports: [anselm]
refutes: []
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.a2_return_cintra, type: milestone, desc: "The player returned to Cintra with the Act II gate met. Not an Act II progress milestone; it fires the pending rider resolution."}
  - {id: ms.act2_twist, type: milestone, desc: "Aldric's abduction is discovered. Escalation stage 4."}
  - {id: flag.twist_started, type: bool, desc: "The twist sickroom scene has begun."}
  - {id: flag.queen_alive, type: bool, desc: "The Queen survives the twist (= flag.antidote_administered at the resolution). Read by the endings."}
  - {id: flag.aldric_co_sovereign, type: bool, desc: "Ysolde invested Aldric herself (alive, condition <= 2)."}
  - {id: flag.aldric_emergency_writ, type: bool, desc: "Kosk invested Aldric by emergency writ (Queen alive but comatose)."}
  - {id: flag.aldric_crowned_king, type: bool, desc: "The Queen died; Kosk crowned Aldric king."}
  - {id: flag.aldric_warned, type: bool, desc: "The player warned Aldric about Anselm and the words. Flavor for act3 finale lines."}
  - {id: flag.raimund_ledger_published, type: bool, desc: "Kosk published Raimund's ledger (Attre -30, or -60 and alliance broken)."}
  - {id: flag.oil_wire_cut, type: bool, desc: "The catacomb oil trip-wire was cut."}
  - {id: flag.oil_trap_sprung, type: bool, desc: "Internal: the player walked into the oil trap's gallery without cutting it."}
  - {id: flag.rearguard_beaten, type: bool, desc: "The Choir rear guard in the catacombs is beaten."}
  - {id: flag.hew_spared, type: bool, desc: "Hew the kitchen boy was spared to testify."}
  - {id: flag.hew_killed, type: bool, desc: "Hew was killed."}
reads:
  - flag.antidote_rider_sent
  - flag.antidote_rider_intercepted
  - flag.antidote_administered
  - flag.rider_escort_hired
  - flag.raimund_allied
  - flag.oswy_witness
  - flag.liss_left
  - flag.maelis_dead
  - flag.aldric_promise
  - flag.aldric_trusts_player
  - flag.aldric_guard_doubled
  - clue.catacomb_hinges
  - item.wenna_antidote
  - item.anselm_journal
  - item.raimund_ledger
  - item.true_fourth_verse
  - ded.anselm_treason_proven
  - companion.maelis
```

## 9. Quest hooks

```yaml quest_stages
quest: quest.main_a2
order: 20
stages:
  - id: return_to_cintra
    journal: "I have the cure (or the knowledge there is none), the proof, and the true verse. Cintra, then. Kosk is waiting."
    objectives:
      - {id: see_kosk, text: "Return to the Queen's sickroom in Cintra", condition: "ms(ms.a2_return_cintra)", optional: false, xp: 100}
      - {id: crown, text: "See Aldric given the Crown's authority", condition: "flag(flag.aldric_co_sovereign) or flag(flag.aldric_emergency_writ) or flag(flag.aldric_crowned_king)", optional: false, xp: 100}
    on_complete: []
    next: []
```

```yaml quest_stages
quest: quest.main_a2
order: 30
stages:
  - id: the_abduction
    journal: "The bells rang in the night. Aldric is gone, and Anselm with him. There is a passage under the chapel."
    objectives:
      - {id: rearguard, text: "Fight through the catacombs", condition: "flag(flag.rearguard_beaten)", optional: false, xp: 150}
      - {id: trail, text: "Find where they took him", condition: "has_clue(clue.aldric_catacomb_mark)", optional: false, xp: 250}
      - {id: route, text: "Learn Anselm's road", condition: "has_clue(clue.anselm_route_stairs)", optional: true, xp: 60}
      - {id: letter, text: "Search the niche carved with Anselm's name", condition: "has_item(item.anselm_last_letter)", optional: true, xp: 40}
    on_complete: []
    next: []
```

## 10. Rumors and event cards (optional)
Rumor 9 (`rumor.r09_aldric_dwarven`, side slice) is verified by Hew's "like a song backwards" in `dlg.hew_yields`.

## 11. Failure states and branches

```yaml branches
paths:
  - id: queen_invests
    when: "The antidote was administered (rider through, or carried) and queen() <= 2 at the twist."
    outcome: "flag.queen_alive, flag.aldric_co_sovereign. Lion Holds remains possible."
    sets: ["set_flag(flag.queen_alive)", "set_flag(flag.aldric_co_sovereign)"]
  - id: emergency_writ
    when: "Antidote administered but queen() == 3."
    outcome: "flag.queen_alive, flag.aldric_emergency_writ (flavor only)."
    sets: ["set_flag(flag.queen_alive)", "set_flag(flag.aldric_emergency_writ)"]
  - id: queen_dies
    when: "No antidote reached the Queen (rider intercepted, dose given to Maelis or sold, no bulbs, line failed)."
    outcome: "flag.aldric_crowned_king. Boy King or a lost-ritual ending."
    sets: ["set_flag(flag.aldric_crowned_king)"]
  - id: abduction
    when: "Always, after the investiture."
    outcome: "ms.act2_twist (stage 4); the catacomb chase; set_act(3)."
    sets: ["reach_milestone(ms.act2_twist)"]
  - id: ledger_published
    when: "Player has Raimund's ledger and tells Kosk to publish it."
    outcome: "Attre -30 (or -60 and flag.raimund_allied cleared); Crown +10."
    sets: ["set_flag(flag.raimund_ledger_published)"]
failures:
  - id: player_dies_catacombs
    result: reload_checkpoint
    recover: "Reload catacomb_entry or junction_cp."
  - id: oil_trap
    result: soft_fail
    recover: "Damage and a 10 s fire wall; the gallery reopens."
guarantees:
  - "ms.act2_twist is reached with no check and no fight: entering the twist sickroom always plays the Kosk and investiture dialogues, which end in the abduction."
  - "set_act(3) is reached with no check: fight the rear guard (one encounter), read the marks by the ring, look out over the river."
```

## 12. Open questions
- **Sickroom ownership:** the twist runs in act1's `zone.palace_sickroom`. The integration patch above lists exactly what act1's zone block needs (a spawn, one interactable, one trigger, four beats, a variant, an exit). If act1 prefers, the twist could use a separate `zone.palace_sickroom_night`, but gdd §7.2 calls it a variant.
- **Order of the twist resolution** (see §2 deviation note): flags are set just before `ms.act2_twist`, not at it.
- **`set_act(3)` placement:** stage 4 already "begins Act III" in gdd §6.1. Act is set here at the sluice so the catacombs remain Act II content; the escalation card and the act change are one short catacomb chase apart.
- **`start_quest(quest.main_a3)`** is fired here. act3 should not start it again in `act3/01-race-south.md`.
- **`flag.maelis_dead`** is assumed to be set by the companion system when the scripted Maelis poisoning kills her (gdd §6.13). It is listed as expected.
- `map.stairs_foot` is used as a map pin for the Race South; act3 owns the map unlocks.
