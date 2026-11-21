---
section_id: side.barrows
title: "The Barrows of the Old Kings"
act: 1
story_ref: "story.md §10 Barrows of the Old Kings; §1 Corvan the Lion; §8 The Lion's Oath"
zones: [zone.barrows_field, zone.barrows_tomb]
available_when: "ms(ms.a1_audience_done) and act() <= 2"
escalation_stage_required: {min: 0, max: 3}
milestones_set: []
milestones_read: [ms.a1_audience_done, ms.act2_twist]
level_band: [3, 7]
---

# The Barrows of the Old Kings

## 1. Scene summary
On the downs west of Cintra the old kings lie under grass mounds, and the greatest mound is Corvan the Lion's. Grave-robbers under Seb Mattock dug through its flank for the gold. They found it, and they found something that does not sleep: Corvan's shade rose and killed six of them in the dark. The rest camp among the mounds with the loot, too greedy to leave and too frightened to go back. The player can take the sack of grave goods from Mattock by threat, argument, purchase, royal writ, the help of a young robber who wants out, or the sword. Then they must go down into the tomb, past collapsing passages and the spear-traps of Corvan's shield-bearers, to the burial chamber, where the shade demands his blade back. The player can lay it down and leave, persuade the dead king that his own Pact is failing and he must lend his sword to the living, or face him in a duel of parries. Win or persuade, and the player carries **Mane-Cleaver**, the rune-tempered greatsword that shears through Ostrel's iron-wardens. The dramatic question: what does a dead king owe a kingdom he built with weapons he had to bury?

## 2. Progress and escalation
- **Availability:** from `ms.a1_audience_done` (Act I) through Act II. Escalation stage 0–3. Closes (abandoned) at `ms.act2_twist`. The map node `map.barrows` is reached by the `cintra—barrows` edge, which opens on a rumor or quest hook (gdd §7.5): `rumor.r11_corvan_tomb` pins it. Entering `zone.barrows_field` starts the quest.
- **Location:** map node `map.barrows` (lowlands). Zones `zone.barrows_field` (exterior, dusk) and `zone.barrows_tomb` (dungeon).
- **Milestones:** none set. Reads `ms.a1_audience_done`, `ms.act2_twist`.
- **Escalation look:** stage 0, robbers' camp intact. **Act II (stage ≥ 1) variant: the massacre.** If the player has not dealt with the robbers by Act II, the shade has come out for them: Mattock and his men lie frozen in their bedrolls with hoarfrost in their beards; the grave goods are on Mattock's corpse; only Lisle survived, hiding in the horse lines. At stage 2 the downs' streams run grey with silt. At stage 3 a Choir zealot's corpse lies at the breach: the Choir came for the sword too, and the shade answered.
- **Payoff wired:** `item.mane_cleaver` (greatsword, 30 slash, block 80%, ×2.0 vs `construct`): the iron-wardens of Karak Ostrel (gdd §6.7) and the soot-hound at Vel Aram. `clue.corvan_tomb_oath` gives the first two lines of the true Oath in original chisel (theory.fourth_verse).

## 3. Location layout
**The barrow field.** Rolling chalk downs, wind-bent grass, a dozen grass mounds in a crescent. The player arrives on the drove road at the south end.
- **Drove road (entry):** sunken track between hedges. Arrival spawn.
- **Standing stones:** three leaning stones on a rise; full cover. The robbers' lookout sits on the middle one.
- **Robbers' camp:** in the hollow between three mounds. Two tents, a cook fire (fire hazard), a handcart of shovels, and the **loot tent** pitched against a mound so its back is in shadow. Picket line with four horses on the east side.
- **The fresh graves:** six shallow graves dug in a row, spades still in them. Lisle sits here.
- **Corvan's mound:** the great barrow at the crescent's north end. On its flank, a raw **breach shaft** shored with stolen fence posts drops into the tomb. The original door (sealed, carved) faces east and is under the turf.

**The tomb.** Built by Cintran masons with dwarven help: dressed stone, iron clamps, rune-cut lintels. The route runs breach → antechamber → Hall of Shields → Oath Door → burial chamber.
- **Breach tunnel:** a robber-dug crawl through chalk into the antechamber wall. Cold rises from inside.
- **Antechamber:** a stone room with a cracked lintel. The robbers knocked out a roof slab: a **collapse** hazard triggers when the player crosses unless the beam is shored first (interactable). Two frozen robbers lie here: loot.
- **Hall of Shields:** a long gallery of twenty niches, each with a seated skeleton in rusted mail holding a shield. Floor plates trigger **spear traps** from the niches (trap hazard). An Investigate 4 check spots the plate pattern; a lever behind the third niche locks them. Cover: the niches themselves.
- **Oath Door:** bronze-faced stone doors carved with a lion and a dwarf clasping a single bolt between them, and two lines of verse in the old chisel. The robbers broke the left leaf; the right still stands.
- **Burial chamber:** round, domed, cold enough to show breath (cold hazard). A stone bier with a carved effigy, an empty sword-rest on its breast, niches of grave goods (looted). The shade rises from the effigy when the player approaches. Duel arena: a 14 m circle with the bier at the centre and four pillars.

```yaml zone
id: zone.barrows_field
name: "Barrows of the Old Kings"
kind: exterior
map_node: map.barrows
time_of_day: dusk
cold_rate: 0
disguise_tag: null
music: downs_wind
areas:
  - {id: drove_road, description: "Sunken drove road between hedges at the south end of the downs."}
  - {id: standing_stones, description: "Three leaning stones on a rise. Full cover. Lookout perch."}
  - {id: robbers_camp, description: "Hollow between three mounds: two tents, cook fire, handcart of shovels."}
  - {id: loot_tent, description: "A tent pitched against a mound, its back in shadow."}
  - {id: picket_line, description: "Four horses on a rope line. Lisle hides here in the Act II variant."}
  - {id: fresh_graves, description: "Six shallow graves in a row, spades still standing in the earth."}
  - {id: corvan_mound, description: "The great barrow. A breach shaft shored with fence posts drops into its flank."}
spawns:
  - {id: drove_road_in, area: drove_road, default: true}
  - {id: breach_top, area: corvan_mound}
  - {id: camp_edge, area: robbers_camp}
exits:
  - id: into_breach
    area: corvan_mound
    to_zone: zone.barrows_tomb
    to_spawn: breach_bottom
    condition: "true"
    effects: []
  - {id: map_board_road, area: drove_road, to_map: true, label: "Leave the downs (travel)", condition: "true", effects: []}
interactables:
  - id: loot_tent_back
    area: loot_tent
    kind: search
    label: "Slip under the tent's back"
    condition: "flag(flag.lisle_helped) and not has_item(item.corvan_grave_goods) and not flag(flag.grave_goods_returned)"
    check: null
    once: true
    effects: ["give_item(item.corvan_grave_goods, 1)", "set_flag(flag.barrows_robbers_dealt)", "play_beat(robbers_discover_theft)"]
    fail_effects: []
  - id: mattock_corpse
    area: robbers_camp
    kind: search
    label: "Search Mattock's frozen body"
    condition: "act() >= 2 and not flag(flag.barrows_robbers_dealt) and not has_item(item.corvan_grave_goods) and not flag(flag.grave_goods_returned)"
    check: null
    once: true
    effects: ["give_item(item.corvan_grave_goods, 1)", "add_crowns(35)", "set_flag(flag.barrows_robbers_dealt)"]
    fail_effects: []
  - id: grave_markers
    area: fresh_graves
    kind: readable
    label: "Read the grave markers"
    condition: "true"
    check: null
    once: true
    effects: []
    fail_effects: []
  - id: handcart
    area: robbers_camp
    kind: container
    label: "Search the handcart"
    condition: "true"
    check: null
    once: true
    effects: []
    fail_effects: []
triggers:
  - id: arrive
    area: drove_road
    "on": enter
    source: null
    condition: "not quest_active(quest.side_barrows) and not quest_done(quest.side_barrows)"
    once: true
    effects: ["start_quest(quest.side_barrows)", "set_checkpoint(downs_arrival)"]
  - id: lookout
    area: standing_stones
    "on": enter
    source: null
    condition: "not flag(flag.barrows_robbers_dealt) and act() <= 1"
    once: true
    effects: ["play_beat(lookout_whistle)"]
  - id: shade_bars_road
    area: drove_road
    "on": exit_attempt
    source: map_board_road
    condition: "has_item(item.corvan_grave_goods) and not flag(flag.grave_goods_returned)"
    once: false
    effects: ["play_beat(shade_rises_field)", "goto_zone(zone.barrows_tomb, bier)", "start_dialogue(dlg.corvan_shade)"]
  - id: robbers_turn
    area: loot_tent
    "on": beat_done
    source: robbers_discover_theft
    condition: "act() <= 1"
    once: true
    effects: ["start_dialogue(dlg.mattock_theft)"]
hazards:
  - {id: cook_fire, area: robbers_camp, kind: fire, params: {damage_per_second: 5}}
checkpoints:
  - {id: downs_arrival, area: drove_road}
  - {id: breach_top_cp, area: corvan_mound}
beats:
  - {id: lookout_whistle, description: "The lookout on the stones whistles twice. Mattock steps out of a tent, a crossbow loose in one hand."}
  - {id: robbers_discover_theft, description: "A robber lifts the tent flap and shouts. Heads turn toward the player."}
  - {id: shade_rises_field, description: "The wind drops. Frost runs across the grass from Corvan's mound, and a tall shape in a lion helm stands in the road. Then there is only cold and dark."}
  - {id: robbers_flee, description: "The robbers throw packs on horses and ride hard down the drove road."}
npcs:
  - {npc: npc.seb_mattock, area: robbers_camp, condition: "not flag(flag.barrows_robbers_dealt) and act() <= 1"}
  - {npc: npc.lisle, area: fresh_graves, condition: "act() <= 1 and not flag(flag.lisle_gone)"}
  - {npc: npc.lisle, area: picket_line, condition: "act() >= 2 and not flag(flag.lisle_gone)"}
encounters: [enc.barrows_robbers]
loot:
  - {container: handcart, items: [{item: item.poultice, count: 2}], condition: "true"}
variants:
  - id: act2_massacre
    when: "act() >= 2 and not flag(flag.barrows_robbers_dealt)"
    description: "Hoarfrost on the grass in a mild autumn. The robbers lie dead in their bedrolls, eyes open, hoarfrost in their beards. Mattock clutches the sack."
    npcs_absent: [npc.seb_mattock]
    encounters_disabled: [enc.barrows_robbers]
    interactables_disabled: [loot_tent_back]
  - id: stage2_silt
    when: "stage() >= 2"
    description: "The chalk streams on the downs run grey with silt."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: stage3_choir_corpse
    when: "stage() >= 3"
    description: "A Choir zealot lies frozen at the breach, a pale feather at his throat and a pry-bar in his hand."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: robbers_gone
    when: "flag(flag.barrows_robbers_dealt) and act() <= 1"
    description: "Camp abandoned or bloodied; the cook fire smoulders."
    npcs_absent: [npc.seb_mattock]
    encounters_disabled: [enc.barrows_robbers]
    interactables_disabled: [loot_tent_back]
```

Travel note: the field leaves to the travel map through the `map_board_road` exit at the drove road (`to_map: true`, content-format §J.5). Trying to leave with the grave goods still unreturned fires `shade_bars_road`.

```yaml zone
id: zone.barrows_tomb
name: "Tomb of Corvan the Lion"
kind: dungeon
map_node: map.barrows
time_of_day: night
cold_rate: 1
disguise_tag: null
music: tomb_cold
areas:
  - {id: breach_tunnel, description: "Robber-dug crawl through chalk. Cold breath from inside."}
  - {id: antechamber, description: "Dressed stone, cracked lintel, a fallen roof slab. Two frozen robbers."}
  - {id: hall_of_shields, description: "Twenty niches of seated skeletons in rusted mail, shields on their knees. Floor plates."}
  - {id: oath_door, description: "Bronze-faced doors: a lion and a dwarf clasp one bolt between them. Two lines of verse. Left leaf broken."}
  - {id: burial_chamber, description: "Round domed chamber. Stone bier with an effigy and an empty sword-rest. Four pillars."}
spawns:
  - {id: breach_bottom, area: breach_tunnel, default: true}
  - {id: bier, area: burial_chamber}
exits:
  - id: climb_out
    area: breach_tunnel
    to_zone: zone.barrows_field
    to_spawn: breach_top
    condition: "true"
    effects: []
interactables:
  - id: shore_beam
    area: antechamber
    kind: lever
    label: "Shore the cracked lintel with a fence post"
    condition: "true"
    check: null
    once: true
    effects: ["play_beat(beam_shored)"]
    fail_effects: []
  - id: frozen_robbers
    area: antechamber
    kind: search
    label: "Search the frozen robbers"
    condition: "true"
    check: null
    once: true
    effects: ["add_crowns(20)", "give_item(item.poultice, 1)"]
    fail_effects: []
  - id: plate_pattern
    area: hall_of_shields
    kind: search
    label: "Study the floor plates"
    condition: "true"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["play_beat(plates_revealed)"]
    fail_effects: []
  - id: niche_lever
    area: hall_of_shields
    kind: lever
    label: "Pull the iron ring behind the third niche"
    condition: "true"
    check: null
    once: true
    effects: ["play_beat(traps_locked)"]
    fail_effects: []
  - id: oath_inscription
    area: oath_door
    kind: readable
    label: "Read the carved verse"
    condition: "true"
    check: null
    once: true
    effects: ["add_clue(clue.corvan_tomb_oath)"]
    fail_effects: []
  - id: epitaph
    area: burial_chamber
    kind: readable
    label: "Read the effigy's epitaph"
    condition: "true"
    check: null
    once: true
    effects: []
    fail_effects: []
  - id: sealing_relief
    area: hall_of_shields
    kind: readable
    label: "Read the relief above the far niche"
    condition: "true"
    check: null
    once: true
    effects: []
    fail_effects: []
triggers:
  - id: shade_wakes
    area: burial_chamber
    "on": enter
    source: null
    condition: "not flag(flag.corvan_appeased) and not flag(flag.corvan_duel_won) and not flag(flag.grave_goods_returned)"
    once: false
    effects: ["play_beat(shade_rises)", "start_dialogue(dlg.corvan_shade)"]
  - id: tomb_entry
    area: breach_tunnel
    "on": enter
    source: null
    condition: "true"
    once: true
    effects: ["set_checkpoint(tomb_entry)"]
hazards:
  - {id: lintel_collapse, area: antechamber, kind: collapse, disabled_by: {"on": beat_done, source: beam_shored}, params: {damage: 35}}
  - {id: spear_plates, area: hall_of_shields, kind: trap, disabled_by: {"on": beat_done, source: traps_locked}, params: {damage: 25, type: pierce}}
  - {id: grave_cold, area: burial_chamber, kind: cold, params: {chill_per_second: 3}}
checkpoints:
  - {id: tomb_entry, area: breach_tunnel}
  - {id: before_shade, area: oath_door}
beats:
  - {id: beam_shored, description: "The fence post jams under the lintel. Chalk dust trickles, then stops."}
  - {id: plates_revealed, description: "Scuffs in the dust show which plates the shield-bearers' feet were set to guard. Safe plates glint."}
  - {id: traps_locked, description: "A heavy clank in the walls. The spear-slots in the niches close like eyes."}
  - {id: shade_rises, description: "Frost spreads from the effigy. A tall shade in a lion-crested helm sits up out of the stone, then stands."}
  - {id: shade_kneels, description: "The shade drops to one knee, helm bowed, and laughs like a man who has not laughed in four hundred years."}
  - {id: blade_laid, description: "The great sword settles into the sword-rest on the effigy's breast. Frost climbs the blade and holds it."}
npcs:
  - {npc: npc.corvan_shade, area: burial_chamber, condition: "not flag(flag.grave_goods_returned)"}
encounters: [enc.corvan_duel]
loot: []
variants:
  - id: shade_at_rest
    when: "flag(flag.grave_goods_returned)"
    description: "The chamber is cold but still. Grave goods back in their niches; the shade is gone."
    npcs_absent: [npc.corvan_shade]
    encounters_disabled: [enc.corvan_duel]
    interactables_disabled: []
```

Readable texts (lore pickups):
- **Grave markers (field):** six crosses scratched on shovel blades: "Hob", "Long Ned", "the Pole", "Tansy", "Dirk", "Hob's brother". Under them, in better letters: "Took by the king. Don't go down."
- **Relief (Hall of Shields):** a carving of a mountain with a door, and two kings with their hands on a single bar across it: one tall with a lion helm, one short and broad with a forge hammer. Below, a band of dwarven runes and a Cintran gloss: "What we used, we lock. What we lock, we watch. Corvan and Ostrel, in the year of the Sealing."
- **Epitaph (effigy):** "Corvan, called the Lion, who broke six kings and then broke his own engines. Let his sword keep his sleep, and his sleep keep the realm."

## 4. NPCs present

**The Shade of King Corvan.** Voice notes: a deep, unhurried voice with old Cintran word order ("Bring you back what was taken?"). Speaks to the player as to a soldier, never as an equal. Weary more than wrathful; he remembers what the engines did. Respects steel and plain speaking, despises begging.

**Seb Mattock.** Voice notes: a big, sunburnt sexton turned robber, jovial and practical, talks about the dead as "tenants". Frightened under the jokes: his hands shake when the wind drops.

**Lisle.** Voice notes: sixteen, a gravedigger's boy, stammers when lying, speaks clearly when he talks about the men he buried. Wants to go home to his mother in Chociebuż.

```yaml npc
id: npc.corvan_shade
name: "Shade of King Corvan"
faction: null
role: "The restless shade of Cintra's founder"
motive: "Have what was taken returned, and his blade kept from unworthy hands."
secret: "He used Ostrel's blight-casks on his rivals' cities and has never stopped hearing it. He knows the Pact needs a crowned voice and fears it was always too thin a lock."
disposition: hostile
essential: true
dialogue: dlg.corvan_shade
barks: ["Who digs in a king's house?", "Steel answers. Words wait.", "Again. Meet it, don't flinch from it.", "What was taken comes back."]
combat: enemy.corvan_shade
shop: null
```

```yaml npc
id: npc.seb_mattock
name: "Seb Mattock"
faction: null
role: "Chief of the grave-robbers"
motive: "Sell the king's gold in Attre and live to spend it."
secret: "He knows the shade will come for them, and has been sleeping with Lisle as his shield in the tent mouth."
disposition: wary
essential: false
dialogue: dlg.mattock_camp
barks: ["Mind the graves, they're fresh.", "Tenants don't complain. Usually.", "That cold again. Feel that?"]
combat: enemy.bandit
shop: null
```

```yaml npc
id: npc.lisle
name: "Lisle"
faction: null
role: "Young grave-robber who wants out"
motive: "Get away from Mattock and go home."
secret: "He was the one who first broke the king's sword-rest open. The shade looked at him and let him live."
disposition: neutral
essential: true
dialogue: dlg.lisle_out
barks: ["I dug them proper. Deep as I could.", "Don't go down there.", "He looked at me. He just looked."]
combat: null
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.mattock_camp
participants: [npc.seb_mattock]
start: open
nodes:
  open:
    type: branch
    cases:
      - {if: "has_item(item.corvan_grave_goods) or flag(flag.grave_goods_returned)", next: nothing_left}
    else: greet
  nothing_left:
    type: line
    speaker: npc.seb_mattock
    text: "You've had what we had. Leave us our horses."
    next: bye
  greet:
    type: line
    speaker: npc.seb_mattock
    text: "Evening. If you're from the parish, we're surveyors. If you're from the Crown, we're also surveyors. If you're from the king down there, we're leaving."
    direction: "Laughing too loud, crossbow resting on his shoulder."
    next: hub
  hub:
    type: choice
    options:
      - id: what_happened
        text: "Six fresh graves. What happened?"
        next: what_answer
      - id: persuade
        text: "He killed six of you in the dark. He'll come up for the rest. Give the sack back to him and ride while you can. [Persuade 6]"
        tag: persuade
        check: {skill: persuade, dc: 6, pass: persuade_pass, fail: persuade_fail}
        once: true
      - id: writ
        text: "Robbing a king's grave is treason. Hand it over and I'll forget your faces. [Item: Marshal's writ] [Persuade 4]"
        tag: item
        condition: "has_item(item.kosk_writ)"
        check: {skill: persuade, dc: 4, pass: writ_pass, fail: writ_fail}
        once: true
      - id: threaten
        text: "The shade killed six of you. I'm worse, and I'm awake. [Intimidate 6]"
        tag: intimidate
        check: {skill: intimidate, dc: 6, pass: threat_pass, fail: threat_fail}
        once: true
      - id: buy
        text: "I'll buy the lot. Gold, cups and that sword."
        tag: bribe
        bribe: 80
        effects: ["give_item(item.corvan_grave_goods, 1)", "set_flag(flag.barrows_robbers_dealt)"]
        next: bought
      - id: fight
        text: "I'll take it."
        effects: ["start_encounter(enc.barrows_robbers)"]
        next: bye
      - id: leave
        text: "Enjoy your survey."
        next: bye
  what_answer:
    type: line
    speaker: npc.seb_mattock
    text: "We went in for the gold, found it, and Lisle cracked the sword-rest. Then it was cold, and then it was screaming. Six of us. The rest got out with the sack."
    next: hub
  persuade_pass:
    type: line
    speaker: npc.seb_mattock
    text: "...You felt it too, coming over the stones? Gods. Take it. Take the bloody thing back to him. Lads, saddle up."
    direction: "He kicks the sack across to the player."
    effects: ["give_item(item.corvan_grave_goods, 1)", "set_flag(flag.barrows_robbers_dealt)", "play_beat(robbers_flee)"]
    next: bye
  persuade_fail:
    type: line
    speaker: npc.seb_mattock
    text: "Ghost stories. We've got a sword that'd buy a ship in Attre, and you want us to give it to the wind."
    next: hub
  writ_pass:
    type: line
    speaker: npc.seb_mattock
    text: "The Marshal's seal. Well. Treason's a long rope. Here. We were never here, and you never saw Lisle, he's only a boy."
    effects: ["give_item(item.corvan_grave_goods, 1)", "set_flag(flag.barrows_robbers_dealt)", "add_rep(faction.crown, 3)", "play_beat(robbers_flee)"]
    next: bye
  writ_fail:
    type: line
    speaker: npc.seb_mattock
    text: "A paper from Cintra. Out here, the Marshal's a rumor and I'm a crossbow."
    next: hub
  threat_pass:
    type: line
    speaker: npc.seb_mattock
    text: "Easy. Easy. Nobody needs to join the tenants. It's yours."
    effects: ["give_item(item.corvan_grave_goods, 1)", "set_flag(flag.barrows_robbers_dealt)", "play_beat(robbers_flee)"]
    next: bye
  threat_fail:
    type: line
    speaker: npc.seb_mattock
    text: "Big talk, little grave. Lads!"
    effects: ["start_encounter(enc.barrows_robbers)"]
    next: bye
  bought:
    type: line
    speaker: npc.seb_mattock
    text: "Eighty crowns and no ghosts. Best sale I ever made. He's your tenant now."
    effects: ["play_beat(robbers_flee)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.mattock_theft
participants: [npc.seb_mattock]
start: open
nodes:
  open:
    type: line
    speaker: npc.seb_mattock
    text: "Thief! Thief in my own tent, with my own boy holding the flap! Put it down."
    next: hub
  hub:
    type: choice
    options:
      - id: point_mound
        text: "Look at the mound, Mattock. Frost on the grass. He's coming. Do you want to be holding this when he does? [Intimidate 4]"
        tag: intimidate
        check: {skill: intimidate, dc: 4, pass: point_pass, fail: point_fail}
        once: true
      - id: fight
        text: "Come and take it."
        effects: ["start_encounter(enc.barrows_robbers)"]
        next: bye
  point_pass:
    type: line
    speaker: npc.seb_mattock
    text: "...Keep it. Keep it and keep walking. We're done here. Lisle, you little traitor, you can walk home."
    effects: ["play_beat(robbers_flee)"]
    next: bye
  point_fail:
    type: line
    speaker: npc.seb_mattock
    text: "Frost. It's autumn, you fool. Lads, take it off him."
    effects: ["start_encounter(enc.barrows_robbers)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.lisle_out
participants: [npc.lisle]
start: open
nodes:
  open:
    type: branch
    cases:
      - {if: "act() >= 2 and not flag(flag.barrows_robbers_dealt)", next: survivor}
    else: greet
  survivor:
    type: line
    speaker: npc.lisle
    text: "He came up. Nobody woke. I was with the horses, I'd gone to cry where they couldn't see. He walked past me. He just looked at me again."
    direction: "Shivering in a horse blanket."
    next: hub
  greet:
    type: line
    speaker: npc.lisle
    text: "I dug them proper. Deep as I could in chalk. Hob wanted to be by the road so he'd see people. I put him by the road."
    next: hub
  hub:
    type: choice
    options:
      - id: help
        text: "Help me get the sack out of the tent, and you're out of this. [Persuade 4]"
        tag: persuade
        condition: "act() <= 1 and not flag(flag.barrows_robbers_dealt)"
        check: {skill: persuade, dc: 4, pass: help_pass, fail: help_fail}
        once: true
      - id: help_coin
        text: "Ten crowns says you can unlace the back of that tent."
        tag: bribe
        condition: "act() <= 1 and not flag(flag.barrows_robbers_dealt)"
        bribe: 10
        effects: ["set_flag(flag.lisle_helped)"]
        next: help_pass_line
      - id: sword_rest
        text: "Mattock says you opened the sword-rest."
        once: true
        next: rest_answer
      - id: go_home
        text: "Go home, Lisle. Chociebuż is that way."
        effects: ["set_flag(flag.lisle_gone)", "add_xp(20)"]
        next: home_answer
      - id: leave
        text: "Stay out of the way."
        next: bye
  help_pass:
    type: effect
    effects: ["set_flag(flag.lisle_helped)"]
    next: help_pass_line
  help_pass_line:
    type: line
    speaker: npc.lisle
    text: "The back's only laced to a peg. I'll pull it when Mattock's at the fire. Then I'm gone. Don't tell him it was me. He'll tell anyway."
    next: bye
  help_fail:
    type: line
    speaker: npc.lisle
    text: "He'd skin me. He would. I'm sorry."
    next: hub
  rest_answer:
    type: line
    speaker: npc.lisle
    text: "It was my pry-bar. The king's face was under the frost, looking up. When it was all screaming he turned his head and looked at me, and let me run. Why me?"
    next: hub
  home_answer:
    type: line
    speaker: npc.lisle
    text: "Home. Yes. My mam'll kill me. That's all right. That's the right kind of killing."
    next: bye
  bye:
    type: end
```

The shade's conversation runs when the player enters the burial chamber, or is dragged there by `shade_bars_road`.

```yaml dialogue
id: dlg.corvan_shade
participants: [npc.corvan_shade]
start: open
nodes:
  open:
    type: branch
    cases:
      - {if: "has_item(item.corvan_grave_goods)", next: demand}
    else: no_goods
  no_goods:
    type: line
    speaker: npc.corvan_shade
    text: "You come empty-handed into a king's house, while thieves sleep on my gold under my own sky. Bring you back what was taken. Then speak."
    direction: "The shade does not move. Frost creeps toward the player's boots."
    next: no_goods_hub
  no_goods_hub:
    type: choice
    options:
      - id: ask_pact
        text: "You made the Pact with Ostrel. It's failing."
        once: true
        next: pact_tease
      - id: go
        text: "I'll bring it."
        next: bye
  pact_tease:
    type: line
    speaker: npc.corvan_shade
    text: "Then the living have a great deal to do, and you are wasting it on the dead. Go."
    next: no_goods_hub
  demand:
    type: line
    speaker: npc.corvan_shade
    text: "You carry what was taken. My cup. My ring. My blade, that was laid on my breast to keep my sleep. Lay them down."
    direction: "He stands from the effigy, tall as a door, lion crest brushing the dome."
    next: hub
  hub:
    type: choice
    options:
      - id: return_all
        text: "Here. All of it. Sleep, king."
        next: return_all_line
      - id: parley
        text: "The Pact you made under Amell is failing. The bolts grind loose. The mountain will need your blade more than your sleep does. [Lore 6]"
        tag: lore
        check: {skill: lore, dc: 6, pass: lend, fail: parley_fail}
        once: true
      - id: letter
        text: "Read this, if the dead read. It's sealed in Ostrel's iron-wax. [Item: Dravin's letter]"
        tag: item
        condition: "has_item(item.dravin_letter)"
        once: true
        next: letter_answer
      - id: oath_lines
        text: "By iron forged in mountain deep, by lion's blood the watch we keep. Your words are on your door. Someone means to say them backward. [Clue: Tomb Oath]"
        tag: clue
        condition: "has_clue(clue.corvan_tomb_oath)"
        once: true
        next: oath_answer
      - id: duel
        text: "If the blade wants a worthy hand, test mine."
        next: duel_accept
      - id: keep
        text: "I'm keeping the sword."
        next: duel_forced
  return_all_line:
    type: line
    speaker: npc.corvan_shade
    text: "Honest. That is rarer than courage, in my experience. Go up into the light, soldier. Tell no one where I lie."
    effects: ["take_item(item.corvan_grave_goods, 1)", "set_flag(flag.grave_goods_returned)", "play_beat(blade_laid)", "add_rep(faction.crown, 5)", "add_xp(100)"]
    next: bye
  parley_fail:
    type: line
    speaker: npc.corvan_shade
    text: "You speak of my Pact like a child reciting a lesson. If you would carry my steel, show me steel."
    next: hub
  letter_answer:
    type: line
    speaker: npc.corvan_shade
    text: "Ostrel's wax. Ostrel's hand. 'The lower bolts grind loose.' So. It comes in my grandsons' grandsons' time after all. Tell me what you know. [Lore 4]"
    next: letter_hub
  letter_hub:
    type: choice
    options:
      - id: letter_parley
        text: "A priest means to open the vaults with a stolen verse and a royal child. Lend me your sword. [Lore 4]"
        tag: lore
        check: {skill: lore, dc: 4, pass: lend, fail: parley_fail}
        once: true
      - id: letter_duel
        text: "Test me, then."
        next: duel_accept
  oath_answer:
    type: line
    speaker: npc.corvan_shade
    text: "Backward. Yes. Ostrel's High King made it so the lock could be opened, because a lock that cannot be opened is a tomb. I said it was madness. He said all locks are."
    next: hub
  lend:
    type: line
    speaker: npc.corvan_shade
    text: "Then take it up, and the cup and ring stay with me. It is called Mane-Cleaver. It was quenched in Ostrel's forge to cut Ostrel's iron. Bring it back when the mountain sleeps."
    direction: "He lifts the blade from the sack and holds it out, hilt first."
    effects: ["take_item(item.corvan_grave_goods, 1)", "set_flag(flag.grave_goods_returned)", "set_flag(flag.corvan_appeased)", "give_item(item.mane_cleaver, 1)", "play_beat(shade_kneels)"]
    next: bye
  duel_accept:
    type: line
    speaker: npc.corvan_shade
    text: "Good. Lay down the cup and ring; they are not yours to fight for. Then draw. Meet my strokes, do not run from them."
    effects: ["start_encounter(enc.corvan_duel)"]
    next: bye
  duel_forced:
    type: line
    speaker: npc.corvan_shade
    text: "Then you are a thief with better manners. Draw."
    effects: ["start_encounter(enc.corvan_duel)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.corvan_duel_end
participants: [npc.corvan_shade]
start: open
nodes:
  open:
    type: line
    speaker: npc.corvan_shade
    text: "Enough. You meet a blow like a man who means to be standing tomorrow. Take it. Mane-Cleaver. It was quenched in Ostrel's forge to cut Ostrel's iron."
    direction: "Kneeling, he lays the blade across his forearms and offers it."
    next: last
  last:
    type: line
    speaker: npc.corvan_shade
    text: "The cup and ring stay with me. And when the mountain sleeps again, so will the blade. Go."
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.barrows_robbers
zone: zone.barrows_field
enemies:
  - {enemy: enemy.bandit, count: 3, spawn: camp_edge, variant: sword}
  - {enemy: enemy.bandit, count: 1, spawn: camp_edge, variant: chief_crossbow}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: downs_arrival
avoidable_by: ["dlg.mattock_camp", "dlg.mattock_theft", "dlg.lisle_out"]
on_won: ["give_item(item.corvan_grave_goods, 1)", "set_flag(flag.barrows_robbers_dealt)"]
on_yielded: ["give_item(item.corvan_grave_goods, 1)", "set_flag(flag.barrows_robbers_dealt)", "play_beat(robbers_flee)"]
on_player_fled: []
```

Notes: three sword robbers rush; Mattock (`chief_crossbow` variant: crossbow, then a mattock in melee) keeps to the standing stones. The cook fire is a hazard for anyone kicked into it. When Mattock yields, the rest throw down. If the loot-tent theft started this fight, `on_won` and `on_yielded` give the sack only if the player does not already hold it (the engine ignores a duplicate key-item grant; see open questions).

```yaml encounter
id: enc.corvan_duel
zone: zone.barrows_tomb
enemies:
  - {enemy: enemy.corvan_shade, count: 1, spawn: bier, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: before_shade
avoidable_by: ["dlg.corvan_shade"]
on_won: ["take_item(item.corvan_grave_goods, 1)", "set_flag(flag.grave_goods_returned)", "set_flag(flag.corvan_duel_won)", "give_item(item.mane_cleaver, 1)", "play_beat(shade_kneels)", "start_dialogue(dlg.corvan_duel_end)"]
on_yielded: []
on_player_fled: []
```

Notes: a duel in the burial chamber (gdd §6.7 `enemy.corvan_shade`: 700 HP, slash-resistant, fire-weak; each parry deals 5% of his max HP). The chamber's cold hazard builds Chill; braziers do not exist here, so the fight rewards parrying rather than trading blows. He does not die: at 0 HP he kneels (`shade_kneels`). The exit is closed for the duel. Player death reloads `before_shade`. Fire oil on the player's weapon is the intended "prepared" answer.

## 7. Items and clues

```yaml item
id: item.mane_cleaver
name: "Mane-Cleaver"
category: weapon
description: "Corvan the Lion's greatsword. Rune-tempered in Ostrel's forge, its edge is grey as frost and never quite warm. It shears through dwarven iron."
price: 0
stack_max: 1
equip_slot: main_hand
weapon: {base: 30, type: slash, block_pct: 0.8, armor_pen: 20, bonus_vs: {construct: 2.0}, moveset: greatsword}
armor: null
consumable: null
readable_text: "Runes on the fuller, in dwarven: 'Made to unmake what we made.'"
```

```yaml item
id: item.corvan_grave_goods
name: "Sack of Corvan's grave goods"
category: key
description: "A robbers' sack: a gold cup, a signet ring with a lion, and a great sword wrapped in sacking. The hilt is so cold it burns through gloves; it cannot be wielded."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml clue
id: clue.corvan_tomb_oath
theory: theory.fourth_verse
title: "The Oath on Corvan's door"
text: "Corvan's tomb door bears, in the old chisel, 'By iron forged in mountain deep, / By lion's blood the watch we keep.' The Oath's lines are older than any copy in the Abbey."
supports: []
refutes: []
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: flag.corvan_appeased, type: bool, desc: "The shade lent Mane-Cleaver after a parley (no duel)."}
  - {id: flag.corvan_duel_won, type: bool, desc: "The player won Corvan's duel."}
  - {id: flag.grave_goods_returned, type: bool, desc: "The stolen grave goods are back in the tomb."}
  - {id: flag.barrows_robbers_dealt, type: bool, desc: "Mattock's band no longer holds the sack (talked, bought, fought, robbed, or dead in the Act II variant)."}
  - {id: flag.lisle_helped, type: bool, desc: "Lisle unlaced the loot tent."}
  - {id: flag.lisle_gone, type: bool, desc: "Lisle went home to Chociebuz."}
reads:
  - ms.a1_audience_done
  - ms.act2_twist
  - item.kosk_writ
  - item.dravin_letter
  - rumor.r11_corvan_tomb
```

## 9. Quest hooks

```yaml quest
id: quest.side_barrows
kind: side
title: "The Barrows of the Old Kings"
giver: null
available: "ms(ms.a1_audience_done) and act() <= 2"
closes_on: "ms(ms.act2_twist)"
xp: 450
stages:
  - id: recover_goods
    journal: "Grave-robbers broke into Corvan the Lion's barrow. The king's shade killed six of them. The rest still hold the loot: his cup, his ring, and his sword."
    objectives:
      - {id: get_sack, text: "Get the grave goods from Seb Mattock's band", condition: "has_item(item.corvan_grave_goods) or flag(flag.grave_goods_returned)", optional: false}
      - {id: spare_lisle, text: "Send Lisle home", condition: "flag(flag.lisle_gone)", optional: true, xp: 30}
    on_complete: []
    next: []
  - id: face_the_king
    journal: "The shade wants back what was taken, the blade most of all. I could lay it down, argue for it, or fight for it."
    objectives:
      - {id: tomb_door, text: "Read the verse on the tomb door", condition: "has_clue(clue.corvan_tomb_oath)", optional: true, xp: 20}
      - {id: settle, text: "Face King Corvan's shade", condition: "flag(flag.grave_goods_returned)", optional: false}
      - {id: cleaver, text: "Win Mane-Cleaver", condition: "has_item(item.mane_cleaver)", optional: true, xp: 100}
    on_complete: []
    next: []
outcome_effects:
  completed: []
  failed: []
```

## 10. Rumors and event cards (optional)
None here. `rumor.r11_corvan_tomb` (in `14-rumors.md`) pins `map.barrows`.

## 11. Failure states and branches

```yaml branches
paths:
  - id: talk_robbers
    when: "Persuade 6, Intimidate 6, the Marshal's writ with Persuade 4, or Bribe 80 with Mattock."
    outcome: "Robbers ride off; player has the sack."
    sets: ["set_flag(flag.barrows_robbers_dealt)"]
  - id: lisle_theft
    when: "Lisle unlaces the loot tent (Persuade 4 or 10 crowns)."
    outcome: "Player takes the sack; Mattock confronts them (Intimidate 4 or fight)."
    sets: ["set_flag(flag.lisle_helped)", "set_flag(flag.barrows_robbers_dealt)"]
  - id: fight_robbers
    when: "Player fights Mattock's band."
    outcome: "Sack on win or yield."
    sets: ["set_flag(flag.barrows_robbers_dealt)"]
  - id: act2_massacre
    when: "Player first arrives in Act II."
    outcome: "Robbers dead; the sack is on Mattock's frozen corpse (no check)."
    sets: ["set_flag(flag.barrows_robbers_dealt)"]
  - id: return_and_leave
    when: "Player returns everything to the shade."
    outcome: "Quest complete without Mane-Cleaver; Crown +5; +100 XP."
    sets: ["set_flag(flag.grave_goods_returned)"]
  - id: parley
    when: "Lore 6 (or Lore 4 after showing Dravin's letter)."
    outcome: "Shade lends Mane-Cleaver; cup and ring stay."
    sets: ["set_flag(flag.corvan_appeased)", "set_flag(flag.grave_goods_returned)"]
  - id: duel
    when: "Player asks for or forces the duel, or tries to leave the downs with the sack (shade drags them back)."
    outcome: "Win: Mane-Cleaver; cup and ring stay."
    sets: ["set_flag(flag.corvan_duel_won)", "set_flag(flag.grave_goods_returned)"]
failures:
  - id: player_dies_duel
    result: reload_checkpoint
    recover: "Reload before_shade. The shade waits; the player can choose the parley or return the goods instead."
  - id: player_dies_robbers
    result: reload_checkpoint
    recover: "Reload downs_arrival."
  - id: traps
    result: soft_fail
    recover: "Collapse and spear traps only deal damage; both can be disabled (beam, lever) and neither blocks the route."
  - id: closes_at_twist
    result: soft_fail
    recover: "Abandoned at ms.act2_twist. Mane-Cleaver is optional: iron-wardens can be beaten with blunt weapons and their exposed rune cores."
guarantees:
  - "The sack is reachable without a check: bribe 80, the fight, or in Act II the corpse search."
  - "flag.grave_goods_returned is reachable without a check: return_all in dlg.corvan_shade."
  - "No main milestone depends on this quest."
```

## 12. Open questions
- **Leaving the field (resolved by A08):** the downs leave to the map through an exit with `to_map: true` (content-format §J.5); the placeholder exit is gone, and `shade_bars_road` watches that exit (`exit_attempt`).
- **Forced teleport into the duel:** `shade_bars_road` uses `goto_zone` then `start_dialogue`. The dialogue must start after the zone load; confirm effect ordering across a zone change.
- **Duplicate key-item grant:** if the theft triggers the robbers' fight, `on_won` gives the sack again. The inventory should treat a second grant of a `stack_max: 1` key item as a no-op.
- **Hazard disabling (resolved by A08):** hazards use `disabled_by: {"on": beat_done, ...}` (content-format §J.3).
- **Mane-Cleaver armor_pen 20:** gdd gives base 30, block 80%, ×2.0 vs construct, but no armor penetration. 20 was chosen so it bites through iron-warden armor (80) even before the tag bonus. Designer to confirm.
- `item.poultice` is declared in act1 (checked by A08).
