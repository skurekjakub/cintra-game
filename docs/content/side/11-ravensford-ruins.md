---
section_id: side.ravensford
title: "The Singing in the Reeds"
act: 2
story_ref: "story.md §10 Ruins near Ravensford; §7.4 Marnadal Stairs; gdd §7.4"
zones: [zone.ravensford_ruins, zone.ravensford_reeds]
available_when: "ms(ms.act1_complete)"
escalation_stage_required: {min: 1, max: 4}
milestones_set: []
milestones_read: [ms.act1_complete]
level_band: [6, 10]
---

# The Singing in the Reeds

## 1. Scene summary
Ravensford was a mill village where the Assen leaves its gorge. It burned in a border raid twenty years ago and was never rebuilt. A handful of families still live in its stone shells. One of them is Ina, eleven years old, who walks to the reed beds every dusk because she hears her brother Mirek singing out there. Mirek drowned at the end of summer. The village says he slipped. The truth is that he saw hooded monks hauling crates up the goat track above the falls, and two Choir men held him under to keep him quiet. His body is caught in the roots of a drowner nest in the reeds. The player follows Mirek's whistle through the reeds, clears or burns the nest, and brings the boy home to be buried. When he is in the ground, the Lady of the Reeds, the river's old spirit, rises at the bank. The Choir's soot has fouled her river, and she tells the player the hidden way the Choir uses into the Amell: the secret pass that skips the sharpshooters' gauntlet on the Marnadal Stairs. The dramatic question: does anyone owe anything to a drowned boy nobody important will miss?

## 2. Progress and escalation
- **Availability:** Act II and Act III. Opens on `ms.act1_complete` (stage 1 or higher). Never closes. (`clue.choir_secret_pass` matters for the Act III Stairs, so finishing it early in Act III is still useful.)
- **Map node and zones:** `map.ravensford`, reached from `map.marnadal_field` (valley edge, no condition) and leading on to `map.assengard`. Revealed by rumor r20, by Marnadal Field locals (A05), or by plain discovery. Zones: `zone.ravensford_ruins`, `zone.ravensford_reeds`.
- **Milestones:** none set.
- **Payoff:** `clue.choir_secret_pass` (gdd §7.4: the Stairs sharpshooter segment can be skipped, A06). Also `clue.mirek_saw_monks` (theory.choir).
- **Stage variants:**
  - **Stage 1:** low brown water, autumn reeds, mist at dusk.
  - **Stage 2 (Dark River):** the Assen is black with silt. A grey scum on the reeds. Drowners pushed out of the fouled deeps make the nest bigger (+1 drowner: `enc.ravensford_drowners_dark` replaces the base encounter). The Lady is angrier and her lines change.
  - **Stage 3 (Open Knives):** Choir men come back to silence the girl who keeps talking about monks. On the player's first arrival at stage 3 or above, before Mirek is freed, they are in the village (`enc.ravensford_silencers`).
  - **Stage 4:** snow and ice at the reed margins. The nest is half frozen; the drowners are sluggish (flavor only).

## 3. Location layout
**The ruins:** the track comes in from the west along the Assen bank, past a broken waymarker. The village is a crescent of roofless stone cottages around a green that has gone to nettles. On the river side stands the **mill**: a three-storey stone shell with a seized wheel in the race and a loft that still has a floor. Mirek slept in the loft and drew on its walls in charcoal. **Ina's cottage** is the one with a roof patched with turf, smoke from the chimney, and her grandmother asleep inside. On the bank below the mill is the **burial ground**, a plot of river stones and willow crosses, with one grave dug and empty. Cover: cottage walls, the millstones lying on the green, the wheel housing.

**The reeds:** a ford of stepping stones (slippery, a hazard) leads from the mill race into the reed beds. The beds are a maze of channels between mud islands, with reeds higher than a man. The deep mud slows the player. Three **listening posts** (a dead willow, a fish-weir and a sunken punt) are where the player blows Mirek's whistle and hears the song answer, which points the way. In the middle is **the nest**, a mound of rotted reed, bones and river rubbish where the drowners sleep, and Mirek's body is caught in the roots of a drowned alder at its heart. Upstream, a **reed shrine** stands on a stone: a little offering niche with old coins and a carved woman's face worn smooth. That is where the Lady can be called without the boy.

```yaml zone
id: zone.ravensford_ruins
name: "Ravensford"
kind: exterior
map_node: map.ravensford
time_of_day: dusk
cold_rate: 0
disguise_tag: null
music: ravensford_lament
areas:
  - {id: west_track, description: "Track along the Assen bank. Broken waymarker. Default arrival."}
  - {id: green, description: "Nettle-grown green, roofless cottages, two fallen millstones. A cat on a wall."}
  - {id: ina_cottage, description: "Turf-patched roof, smoke. A grandmother asleep by the fire. A shelf with a jar of lamp oil and a crock of mill tallow."}
  - {id: mill, description: "Stone shell, seized wheel in the race, a ladder to the loft. Charcoal drawings on the loft walls."}
  - {id: burial_ground, description: "River stones and willow crosses on the bank. One grave dug and empty, a spade beside it."}
  - {id: race_ford, description: "Stepping stones from the mill race into the reeds."}
spawns:
  - {id: track_arrival, area: west_track, default: true}
  - {id: from_reeds, area: race_ford, default: false}
  - {id: green_door, area: green, default: false}
exits:
  - id: into_reeds
    area: race_ford
    to_zone: zone.ravensford_reeds
    to_spawn: ford_landing
    condition: "true"
    effects: []
interactables:
  - id: track_board
    area: west_track
    kind: map_board
    label: "Take the road"
    condition: "true"
    check: null
    once: false
    effects: []
  - id: loft_drawings
    area: mill
    kind: readable
    label: "Look at the drawings on the loft wall"
    condition: "true"
    check: null
    once: true
    effects: ["add_clue(clue.mirek_saw_monks)"]
  - id: tallow_crock
    area: ina_cottage
    kind: pickup
    label: "Take the lamp oil and mill tallow"
    condition: "flag(flag.ina_trusts)"
    check: null
    once: true
    effects: ["give_item(item.reed_tallow, 1)"]
  - id: empty_grave
    area: burial_ground
    kind: search
    label: "Lay Mirek in the grave"
    condition: "has_item(item.mirek_remains)"
    check: null
    once: true
    effects: ["take_item(item.mirek_remains, 1)", "set_flag(flag.mirek_freed)", "play_beat(burial)", "start_dialogue(dlg.assen_lady)"]
triggers:
  - id: first_song
    area: green
    on: enter
    source: null
    condition: "not flag(flag.mirek_freed)"
    once: true
    effects: ["play_beat(song_on_wind)"]
  - id: silencers
    area: green
    on: enter
    source: null
    condition: "stage() >= 3 and not flag(flag.mirek_freed) and not flag(flag.silencers_dealt)"
    once: true
    effects: ["play_beat(silencers_at_door)", "start_dialogue(dlg.silencer_leader)"]
hazards:
  - {id: race_water, area: race_ford, kind: tide, params: {pull_back_damage: 10}}
  - {id: loft_floor, area: mill, kind: collapse, params: {weak_boards: true, damage: 15}}
checkpoints:
  - {id: ravensford_arrival, area: west_track}
  - {id: before_silencers, area: green}
beats:
  - {id: song_on_wind, description: "Faint, from the reeds: a boy's voice singing a mill-song, out of tune, stopping and starting as if he keeps forgetting the words."}
  - {id: silencers_at_door, description: "Three hooded men at Ina's door. One has a hand in her hair. The grandmother screams inside."}
  - {id: burial, description: "Ina fills the grave with her hands while the player shovels. She blows her whistle once. Nothing answers. Then she cries, finally."}
  - {id: lady_rises, description: "Mist gathers over the water below the burial ground and stands up into the shape of a tall woman made of river-light and reed. Her face is the worn face on the reed shrine."}
npcs:
  - {npc: npc.ina, area: green, condition: "not flag(flag.mirek_freed) and not (flag(flag.drowners_lured) and not flag(flag.nest_cleared))"}
  - {npc: npc.ina, area: burial_ground, condition: "flag(flag.mirek_freed)"}
encounters: [enc.ravensford_silencers]
loot:
  - {container: mill_chest, items: [{item: item.poultice, count: 1}], condition: "true"}
variants:
  - id: dark_river
    when: "stage() >= 2"
    description: "The Assen runs black. A grey scum lines the race. The wheel drips soot."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: choir_open
    when: "stage() >= 3"
    description: "A pale feather is tied to the waymarker with red thread: a warning."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: winter
    when: "stage() >= 4"
    description: "Snow on the roofless walls. Ice at the race."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: after_burial
    when: "flag(flag.mirek_freed)"
    description: "A new willow cross on the bank. Ina sits by it. No singing at dusk."
    npcs_absent: []
    encounters_disabled: [enc.ravensford_silencers]
    interactables_disabled: []
```

```yaml zone
id: zone.ravensford_reeds
name: "The Assen Reeds"
kind: exterior
map_node: map.ravensford
time_of_day: dusk
cold_rate: 0
disguise_tag: null
music: reeds_unease
areas:
  - {id: ford_landing, description: "Mud bank where the stepping stones end. Reeds closing in on both sides."}
  - {id: channels, description: "Maze of channels between mud islands. Reeds higher than a man. Deep mud."}
  - {id: willow_post, description: "Listening post 1: a dead willow on an island, its roots in the water."}
  - {id: weir_post, description: "Listening post 2: a broken fish-weir of woven withies."}
  - {id: punt_post, description: "Listening post 3: a sunken punt, its prow above water."}
  - {id: nest, description: "Mound of rotted reed, bones and river rubbish round a drowned alder. Drowners sleep here. A boy's body caught in the alder roots."}
  - {id: reed_shrine, description: "Upstream stone with an offering niche: old coins, a carved woman's face worn smooth."}
spawns:
  - {id: ford_landing, area: ford_landing, default: true}
  - {id: nest_water, area: nest, default: false}
exits:
  - id: back_to_village
    area: ford_landing
    to_zone: zone.ravensford_ruins
    to_spawn: from_reeds
    condition: "true"
    effects: []
interactables:
  - id: listen_willow
    area: willow_post
    kind: search
    label: "Blow Mirek's whistle and listen"
    condition: "has_item(item.mirek_whistle)"
    check: null
    once: true
    effects: ["set_flag(flag.reeds_listen_1)", "play_beat(song_answers)"]
  - id: listen_weir
    area: weir_post
    kind: search
    label: "Blow Mirek's whistle and listen"
    condition: "has_item(item.mirek_whistle) and flag(flag.reeds_listen_1)"
    check: null
    once: true
    effects: ["set_flag(flag.reeds_listen_2)", "play_beat(song_answers)"]
  - id: listen_punt
    area: punt_post
    kind: search
    label: "Blow Mirek's whistle and listen"
    condition: "has_item(item.mirek_whistle) and flag(flag.reeds_listen_2)"
    check: null
    once: true
    effects: ["set_flag(flag.nest_found)", "play_beat(song_answers)", "complete_objective(quest.side_ravensford, find_nest)"]
  - id: drowner_sign
    area: channels
    kind: search
    label: "Study the drag marks and gnawed bones"
    condition: "true"
    check: {skill: lore, dc: 6}
    once: true
    effects: ["set_flag(flag.reed_fire_known)"]
    fail_effects: []
  - id: burn_nest
    area: nest
    kind: search
    label: "Soak the nest's reeds with tallow and oil, and set them alight"
    condition: "flag(flag.nest_found) and flag(flag.reed_fire_known) and has_item(item.reed_tallow) and not flag(flag.nest_cleared)"
    check: null
    once: true
    effects: ["take_item(item.reed_tallow, 1)", "set_flag(flag.nest_cleared)", "set_flag(flag.reeds_burned)", "play_beat(nest_burns)"]
  - id: mirek_body
    area: nest
    kind: search
    label: "Free the boy from the alder roots"
    condition: "flag(flag.nest_cleared)"
    check: null
    once: true
    effects: ["start_dialogue(dlg.mirek_nest)", "give_item(item.mirek_remains, 1)", "complete_objective(quest.side_ravensford, recover_mirek)"]
  - id: shrine
    area: reed_shrine
    kind: search
    label: "Leave an offering at the reed shrine"
    condition: "not flag(flag.lady_told_pass)"
    check: null
    once: false
    effects: ["start_dialogue(dlg.assen_lady)"]
triggers:
  - id: wake_nest
    area: nest
    on: enter
    source: null
    condition: "flag(flag.nest_found) and not flag(flag.nest_cleared) and not flag(flag.drowners_lured) and stage() < 2"
    once: false
    effects: ["start_encounter(enc.ravensford_drowners)"]
  - id: wake_nest_dark
    area: nest
    on: enter
    source: null
    condition: "flag(flag.nest_found) and not flag(flag.nest_cleared) and not flag(flag.drowners_lured) and stage() >= 2"
    once: false
    effects: ["start_encounter(enc.ravensford_drowners_dark)"]
  - id: wake_nest_lured
    area: nest
    on: enter
    source: null
    condition: "flag(flag.nest_found) and flag(flag.drowners_lured) and not flag(flag.nest_cleared)"
    once: false
    effects: ["start_encounter(enc.ravensford_lure)"]
hazards:
  - {id: reed_mud, area: channels, kind: deep_mud, params: {speed_mult: 0.6}}
  - {id: deep_channel, area: channels, kind: tide, params: {pull_back_damage: 10}}
  - {id: nest_fire, area: nest, kind: fire, params: {damage_per_second: 5, active_when: "flag(flag.reeds_burned)"}}
checkpoints:
  - {id: reeds_entry, area: ford_landing}
  - {id: before_nest, area: punt_post}
beats:
  - {id: song_answers, description: "The whistle's note goes out over the reeds. A moment later the boy's song answers, from one direction, clearer than before."}
  - {id: nest_burns, description: "The tallow catches. The nest goes up with a wet roar. Pale shapes slither out shrieking and vanish into the black channels."}
  - {id: lady_rises, description: "Mist gathers over the water by the bank and stands up into the shape of a tall woman made of river-light and reed. Her face is the worn face on the shrine."}
npcs:
  - {npc: npc.mirek_ghost, area: nest, condition: "not flag(flag.mirek_freed)"}
  - {npc: npc.ina, area: ford_landing, condition: "flag(flag.drowners_lured) and not flag(flag.nest_cleared)"}
encounters: [enc.ravensford_drowners, enc.ravensford_drowners_dark, enc.ravensford_lure]
loot:
  - {container: nest_bones, items: [{item: item.poultice, count: 1}], condition: "flag(flag.nest_cleared)"}
  - {container: shrine_niche, items: [], condition: "true"}
variants:
  - id: dark_river
    when: "stage() >= 2"
    description: "Black water in every channel. Soot scum on the reeds. The nest is bigger, and stinks of oil."
    npcs_absent: []
    encounters_disabled: [enc.ravensford_drowners]
    interactables_disabled: []
  - id: winter
    when: "stage() >= 4"
    description: "Ice at the reed margins. The nest is half frozen."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: after_burial
    when: "flag(flag.mirek_freed)"
    description: "No song in the reeds. Frogs, for the first time."
    npcs_absent: [npc.mirek_ghost]
    encounters_disabled: [enc.ravensford_drowners, enc.ravensford_drowners_dark]
    interactables_disabled: []
```

Note: `play_beat(lady_rises)` is played from `dlg.assen_lady`, which can start in either zone, so the beat is listed in both zones.

## 4. NPCs present
**Voice notes.**
- **Ina:** eleven, sharp-tongued, frightened under it. She talks fast and in the present tense about Mirek ("he sings the mill-song wrong, he always does"). She does not cry until the burial. She gives orders to adults because she has had to. She calls the player "you", never by name.
- **Mirek (the voice):** never seen whole. A boy's voice singing the Ravensford mill-song, off-key and stopping. In the nest, he speaks a few lines in a small, cold, matter-of-fact voice, as if he is reporting something he has thought about for a long time.
- **The Lady of the Reeds:** ancient, slow, and not kind. She speaks in the plural sometimes ("we"), means the river, and has no interest in kings. She is grieved and angry about the soot in her water. She never raises her voice. The river does it for her (the music swells, the water rises a little at her feet).

```yaml npc
id: npc.ina
name: "Ina"
faction: null
role: "Girl of Ravensford who hears her drowned brother"
motive: "Bring Mirek home, and make someone believe he didn't slip."
secret: "She saw the two men walk back from the reeds that evening, wet to the waist. She has told nobody because one of them smiled at her."
disposition: wary
essential: true
dialogue: dlg.ina_main
barks: ["He sings it wrong. He always sang it wrong.", "Don't step on the graves.", "Gran's asleep. Talk quiet.", "You're not from the Abbey, are you?"]
combat: null
shop: null
```

```yaml npc
id: npc.mirek_ghost
name: "Mirek"
faction: null
role: "Ina's drowned brother, a voice in the reeds"
motive: "Go home. Not be cold."
secret: "He followed the monks up the goat track on purpose, hoping for a reward from the Marshal's men."
disposition: neutral
essential: true
dialogue: dlg.mirek_nest
barks: ["...the wheel goes round, the water goes down...", "...Ina?...", "...cold..."]
combat: null
shop: null
```

```yaml npc
id: npc.assen_lady
name: "The Lady of the Reeds"
faction: null
role: "The Assen river's old spirit"
motive: "Have her water clean again, and the men who foul it gone from her banks."
secret: "She let the drowners nest in her reeds because she has grown too weak to drive them out. The soot is killing her."
disposition: wary
essential: true
dialogue: dlg.assen_lady
barks: []
combat: null
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.ina_main
participants: [npc.ina]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "flag(flag.mirek_freed)", next: after}
      - {if: "flag(flag.ina_trusts)", next: hub}
    else: first
  first:
    type: line
    speaker: npc.ina
    text: "If you're from the Abbey, Gran says we already gave. If you're a soldier, we've got nothing worth taking. If you're neither, you can listen."
    direction: "Sitting on a millstone, arms round her knees, looking at the reeds."
    next: first_choice
  first_choice:
    type: choice
    options:
      - id: listen
        text: "I'm listening."
        next: tell
      - id: song
        text: "I heard singing in the reeds on the way in."
        next: tell_song
      - id: leave
        text: "I'm only passing through."
        next: bye
  tell_song:
    type: line
    speaker: npc.ina
    text: "You heard it? Nobody else hears it. Gran says it's herons."
    next: tell
  tell:
    type: line
    speaker: npc.ina
    text: "My brother's Mirek. He went in the river at the end of summer. They never found him. Everyone says he slipped. He didn't slip. He swims better than the otters."
    next: tell_2
  tell_2:
    type: line
    speaker: npc.ina
    text: "He sings out there every dusk. The mill-song. He always gets the third verse wrong. I want him home, in the ground by Mam. I can't go in the reeds. Things live in the reeds now."
    effects: ["set_flag(flag.ina_trusts)", "start_quest(quest.side_ravensford)"]
    next: hub
  hub:
    type: choice
    options:
      - id: whistle
        text: "How do I find him out there?"
        condition: "not has_item(item.mirek_whistle)"
        next: give_whistle
      - id: things
        text: "What lives in the reeds?"
        next: things
      - id: slipped
        text: "Why are you so sure he didn't slip?"
        next: slipped
      - id: men
        text: "You saw something that evening. Tell me. [Persuade 6]"
        tag: persuade
        condition: "not flag(flag.ina_told_men)"
        check: {skill: persuade, dc: 6, pass: men_pass, fail: men_fail}
        once: true
      - id: drawings
        text: "Mirek drew hooded men with crates on the loft wall. Is that what he saw? [Clue]"
        tag: clue
        condition: "has_clue(clue.mirek_saw_monks) and not flag(flag.ina_told_men)"
        show_locked: true
        next: men_pass
      - id: song_lure
        text: "Could you sing his song from the bank? Draw the things away while I go in."
        condition: "flag(flag.nest_found) and not flag(flag.nest_cleared) and not flag(flag.drowners_lured)"
        next: lure
      - id: bye_opt
        text: "I'll see what I can do."
        next: bye
  give_whistle:
    type: line
    speaker: npc.ina
    text: "This was his. I found it in the race, caught on the wheel. We made two. Blow it out there. He always answers my whistle. Always."
    direction: "She takes a reed whistle from round her neck and holds it out without looking at it."
    effects: ["give_item(item.mirek_whistle, 1)", "complete_objective(quest.side_ravensford, get_whistle)"]
    next: hub
  things:
    type: line
    speaker: npc.ina
    text: "Pale things with long arms. They came after the summer, when the river went funny. They took Hobb's goat. They hate Gran's lamp. She swings it at the window and they go."
    effects: ["set_flag(flag.reed_fire_known)"]
    next: hub
  slipped:
    type: line
    speaker: npc.ina
    text: "Because he went up the goat track over the falls that day. He came back all bright-eyed and said he'd seen something worth a silver crown to the Marshal's men. Next day he was gone."
    next: hub
  men_pass:
    type: line
    speaker: npc.ina
    text: "Two men. They walked back from the reeds that night, wet to here. Monks' boots. One of them smiled at me. He had a white feather sewn in his collar."
    direction: "Very quietly."
    effects: ["set_flag(flag.ina_told_men)", "add_clue(clue.mirek_saw_monks)"]
    next: hub
  men_fail:
    type: line
    speaker: npc.ina
    text: "I didn't see anything. Leave it."
    next: hub
  lure:
    type: line
    speaker: npc.ina
    text: "I'll sing it right. That'll annoy them. Stay on the dry islands, and when they come at the bank, you go round the back."
    direction: "Ina follows the player to the ford landing. Entering the nest then starts the split fight (enc.ravensford_lure)."
    effects: ["set_flag(flag.drowners_lured)"]
    next: bye
  after:
    type: line
    speaker: npc.ina
    text: "He's not singing any more. It's quiet. I don't like the quiet. But he's by Mam now. Thank you."
    next: after_choice
  after_choice:
    type: choice
    options:
      - id: lady
        text: "The Lady of the river spoke to me."
        condition: "flag(flag.lady_told_pass)"
        next: after_lady
      - id: bye2
        text: "Look after your gran."
        next: bye
  after_lady:
    type: line
    speaker: npc.ina
    text: "Gran says nobody's seen her since Gran was little. You must have been very sad for her to come."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.mirek_nest
participants: [npc.mirek_ghost]
start: voice
nodes:
  voice:
    type: line
    speaker: npc.mirek_ghost
    text: "You've got Ina's whistle. Is she cross? She'll be cross. I went up the track without her."
    direction: "The voice comes from the alder roots. Nothing is visible but the snagged shape under the water."
    next: voice_choice
  voice_choice:
    type: choice
    options:
      - id: what_saw
        text: "What did you see up the track, Mirek?"
        next: saw
      - id: home
        text: "I'm taking you home."
        next: home
  saw:
    type: line
    speaker: npc.mirek_ghost
    text: "Monks with crates on poles. Humming crates. They went up past the falls where the goats go, and then into the rock where there isn't a path. Two came back down after me."
    effects: ["add_clue(clue.mirek_saw_monks)"]
    next: voice_choice
  home:
    type: line
    speaker: npc.mirek_ghost
    text: "By Mam. Yes. It's cold here."
    next: bye
  bye:
    type: end
```

`dlg.mirek_nest` plays when the player frees the body (`mirek_body` effects).

```yaml dialogue
id: dlg.assen_lady
participants: [npc.assen_lady]
start: route
nodes:
  route:
    type: branch
    cases:
      - {if: "flag(flag.lady_told_pass)", next: already}
      - {if: "flag(flag.mirek_freed)", next: rise_grateful}
    else: rise_cold
  rise_grateful:
    type: line
    speaker: npc.assen_lady
    text: "You took the child out of our roots and gave him to the earth. No one has given this river anything for a long time. Only soot."
    effects: ["play_beat(lady_rises)"]
    next: grateful_2
  grateful_2:
    type: branch
    cases:
      - {if: "stage() >= 2", next: grateful_dark}
    else: grateful_plain
  grateful_dark:
    type: line
    speaker: npc.assen_lady
    text: "They pour the black into us from the high places. Our fish float. Our reeds rot. The pale things come because the deep is poison."
    next: give_pass
  grateful_plain:
    type: line
    speaker: npc.assen_lady
    text: "Men in hoods wash their black hands in our springs, high up, where we are born. The child saw them. So they gave him to us."
    next: give_pass
  give_pass:
    type: line
    speaker: npc.assen_lady
    text: "Above the falls, the goat track. Where it ends, follow the spring into the rock. Our water made that way before your kings. The hooded ones use it to come behind the stair where their bowmen wait."
    effects: ["add_clue(clue.choir_secret_pass)", "set_flag(flag.lady_told_pass)", "complete_objective(quest.side_ravensford, the_lady)"]
    next: give_pass_2
  give_pass_2:
    type: line
    speaker: npc.assen_lady
    text: "Go that way, and kill them where they wash. That is our price, and it is already paid."
    next: bye
  rise_cold:
    type: line
    speaker: npc.assen_lady
    text: "Another one with coins. Coins sink. What does a dry thing want from the river?"
    effects: ["play_beat(lady_rises)"]
    next: cold_choice
  cold_choice:
    type: choice
    options:
      - id: ask_pass
        text: "The hooded men who foul your water. Where do they go into the mountains? I'll stop them. [Persuade 8]"
        tag: persuade
        check: {skill: persuade, dc: 8, pass: give_pass, fail: cold_refuse}
        once: true
      - id: lore_offer
        text: "Clean water, salt and a name spoken: the old offering to a river mother. [Lore 6]"
        tag: lore
        check: {skill: lore, dc: 6, pass: lore_pass, fail: cold_refuse}
        once: true
      - id: silver
        text: "Pour silver into the river. [Bribe 50]"
        tag: bribe
        bribe: 50
        next: silver_scorn
      - id: boy
        text: "There's a drowned boy in your reeds. What do you want for him?"
        condition: "not flag(flag.mirek_freed)"
        next: boy_answer
      - id: leave
        text: "Nothing. Go back to your water."
        next: bye
  lore_pass:
    type: line
    speaker: npc.assen_lady
    text: "Old words. We had forgotten we liked them. Listen, then."
    next: give_pass
  silver_scorn:
    type: line
    speaker: npc.assen_lady
    text: "You pay a river in metal. That is what the hooded ones think too. Take the child home. Then come back."
    next: bye
  boy_answer:
    type: line
    speaker: npc.assen_lady
    text: "Nothing. We did not want him. They gave him to us. Take him to the earth and we will talk."
    next: bye
  cold_refuse:
    type: line
    speaker: npc.assen_lady
    text: "No. Words are wind. The child is still in our roots."
    next: bye
  already:
    type: line
    speaker: npc.assen_lady
    text: "We told you the way. Go, and wash it clean with their blood."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.silencer_leader
participants: [npc.ina]
start: open
nodes:
  open:
    type: line
    speaker: player
    text: "Let the girl go."
    direction: "The Choir leader turns, knife out, his free hand still in Ina's hair. Ina's lines here are hers; the leader is an enemy.choir_zealot with barks only."
    next: open_choice
  open_choice:
    type: choice
    options:
      - id: brother
        text: "Peace, brother. The Abbot sent me to deal with this one. Go back up the track. [Persuade 6]"
        tag: persuade
        condition: "has_item(item.choir_robe) and has_item(item.pale_feather)"
        show_locked: true
        check: {skill: persuade, dc: 6, pass: sent_away, fail: fight}
      - id: fight_opt
        text: "Draw your knife on me, not her."
        next: fight
  sent_away:
    type: line
    speaker: npc.ina
    text: "You're one of them? You're... no. You're not. You lied to them. Good."
    direction: "The silencers file off toward the goat track. The player can follow and find them gone."
    effects: ["set_flag(flag.silencers_dealt)"]
    next: bye
  fight:
    type: effect
    effects: ["start_encounter(enc.ravensford_silencers)"]
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.ravensford_drowners
zone: zone.ravensford_reeds
enemies:
  - {enemy: enemy.drowner, count: 4, spawn: nest_water, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: before_nest
avoidable_by: ["dlg.ina_main"]
on_won: ["set_flag(flag.nest_cleared)"]
on_yielded: []
on_player_fled: []
```
Stage 0–1. Four drowners erupt from the nest's water around the drowned alder. Their drag-grab pulls the player into the deep channel hazard. Kick to break it. They are weak to fire, so fire oil or the burning nest helps.

```yaml encounter
id: enc.ravensford_drowners_dark
zone: zone.ravensford_reeds
enemies:
  - {enemy: enemy.drowner, count: 5, spawn: nest_water, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: before_nest
avoidable_by: ["dlg.ina_main"]
on_won: ["set_flag(flag.nest_cleared)"]
on_yielded: []
on_player_fled: []
```
Stage 2 and above. Five drowners (the dark river drives more of them into the reeds).

```yaml encounter
id: enc.ravensford_lure
zone: zone.ravensford_reeds
enemies:
  - {enemy: enemy.drowner, count: 2, spawn: nest_water, variant: null}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.drowner, count: 2, spawn: nest_water, variant: null}]}
attack_tokens: null
allow_yield: false
allies: [npc.ina]
checkpoint: before_nest
avoidable_by: []
on_won: ["set_flag(flag.nest_cleared)"]
on_yielded: []
on_player_fled: []
```
Ina's song from the ford landing draws the drowners out in pairs instead of all at once. She stands on the dry bank and the drowners never reach her (she is not an escort target). At stage 2 and above, the second wave gets a third drowner (applied by the stage rule in the scene). Same result as the full nest fight.

```yaml encounter
id: enc.ravensford_silencers
zone: zone.ravensford_ruins
enemies:
  - {enemy: enemy.choir_zealot, count: 1, spawn: green_door, variant: null}
  - {enemy: enemy.choir_cutthroat, count: 2, spawn: green_door, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: before_silencers
avoidable_by: ["dlg.silencer_leader"]
on_won: ["set_flag(flag.silencers_dealt)", "give_item(item.pale_feather, 1)"]
on_yielded: ["set_flag(flag.silencers_dealt)"]
on_player_fled: []
```
Stage 3 and above, the first visit before Mirek is freed. The fight is on the green, among the millstones. The cutthroats can yield; the zealot self-immolates at 0 HP. Ina runs into the cottage at the first blow (she is not an escort target and cannot be hurt). The stage 3 rule adds +1 Choir member. **Non-combat alternative:** wearing the Choir disguise (`item.choir_robe` and `item.pale_feather`), Persuade 6 sends them away.

## 7. Items and clues

```yaml item
id: item.mirek_whistle
name: "Mirek's reed whistle"
category: key
description: "A whistle cut from Assen reed, one of a pair Ina and her brother made. Its note carries a long way over water."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.mirek_remains
name: "Mirek, wrapped in a sailcloth"
category: key
description: "What the river left of a twelve-year-old boy, wrapped in an old sail from the mill. Light. Too light."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.reed_tallow
name: "Lamp oil and mill tallow"
category: key
description: "A jar of lamp oil and a crock of the tallow the mill once used on its axle. Enough to set a reed bed burning."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml clue
id: clue.mirek_saw_monks
theory: theory.choir
title: "A drowned boy saw monks on the goat track"
text: "Mirek of Ravensford watched hooded monks carry humming crates up the goat track over the Assen falls and into the rock. Two Choir men drowned him for it."
supports: []
refutes: []
```

```yaml clue
id: clue.choir_secret_pass
theory: theory.choir
title: "The Choir's secret pass"
text: "Above the Assen falls, the goat track ends at a spring that runs into the rock: a water-cut way that comes out behind the Marnadal Stairs, past the ledges where the Choir's sharpshooters wait."
supports: []
refutes: []
```

Readable: the **loft drawings** are charcoal on whitewash. A mill wheel, an otter, Ina with her tongue out. Then, newer and careful: a line of hooded figures with poles on their shoulders and boxes slung between them, climbing a zigzag path above a waterfall, and a mountain with a door in it. Under it, in a child's letters: "MONKS. TELL THE MARSHAL. 1 SILVER."

## 8. Flags set and read

```yaml flags
declare:
  - {id: flag.mirek_freed, type: bool, desc: "Mirek is buried; his spirit is at rest."}
  - {id: flag.ina_trusts, type: bool, desc: "Ina has told the player about Mirek (quest started)."}
  - {id: flag.ina_told_men, type: bool, desc: "Ina told the player about the two wet men with feathers."}
  - {id: flag.reeds_listen_1, type: bool, desc: "First listening post answered."}
  - {id: flag.reeds_listen_2, type: bool, desc: "Second listening post answered."}
  - {id: flag.nest_found, type: bool, desc: "The drowner nest is located."}
  - {id: flag.nest_cleared, type: bool, desc: "The drowner nest is cleared (fight, lure or fire)."}
  - {id: flag.reeds_burned, type: bool, desc: "The nest was burned out."}
  - {id: flag.reed_fire_known, type: bool, desc: "The player knows drowners flee fire (Lore 6 or Ina)."}
  - {id: flag.drowners_lured, type: bool, desc: "Ina's song lure was used."}
  - {id: flag.lady_told_pass, type: bool, desc: "The Lady of the Reeds revealed the Choir's secret pass."}
  - {id: flag.silencers_dealt, type: bool, desc: "The stage 3 Choir silencers were fought or sent away."}
reads:
  - ms.act1_complete
  - item.choir_robe
  - item.pale_feather
```

## 9. Quest hooks

```yaml quest
id: quest.side_ravensford
kind: side
title: "The Singing in the Reeds"
giver: npc.ina
available: "ms(ms.act1_complete)"
closes_on: null
xp: 400
stages:
  - id: the_girl
    journal: "In burned Ravensford, a girl named Ina hears her drowned brother Mirek singing in the Assen reeds. She wants him home and in the ground."
    objectives:
      - {id: get_whistle, text: "Ask Ina how to find Mirek", condition: "has_item(item.mirek_whistle)", optional: false}
      - {id: truth, text: "Learn what Mirek saw", condition: "has_clue(clue.mirek_saw_monks)", optional: true, xp: 60}
    on_complete: []
    next: []
  - id: into_the_reeds
    journal: "Mirek's whistle answers from deep in the reeds. Follow the song."
    objectives:
      - {id: find_nest, text: "Follow the song to Mirek", condition: "flag(flag.nest_found)", optional: false}
      - {id: clear_nest, text: "Deal with what nests around him", condition: "flag(flag.nest_cleared)", optional: false}
      - {id: recover_mirek, text: "Free Mirek's body", condition: "has_item(item.mirek_remains) or flag(flag.mirek_freed)", optional: false}
    on_complete: []
    next: []
  - id: home
    journal: "Mirek is out of the river. Ina dug his grave by their mother's long ago."
    objectives:
      - {id: bury, text: "Bury Mirek at the Ravensford bank", condition: "flag(flag.mirek_freed)", optional: false}
      - {id: the_lady, text: "Hear what the river has to say", condition: "flag(flag.lady_told_pass)", optional: false}
    on_complete: []
    next: []
outcome_effects:
  completed: []
  failed: []
```

## 10. Rumors and event cards (optional)
Rumor r20 in `14-rumors.md` ("A girl at Ravensford swears her drowned brother sings in the reeds") pins `map.ravensford`.

## 11. Failure states and branches

```yaml branches
paths:
  - id: fight_nest
    when: "Player follows the whistle and fights the drowners at the nest."
    outcome: "Nest cleared; free the body; bury; the Lady gives the pass."
    sets: ["set_flag(flag.nest_cleared)", "set_flag(flag.mirek_freed)", "add_clue(clue.choir_secret_pass)"]
  - id: burn_nest
    when: "Player learns drowners flee fire (Lore 6 or Ina), takes the tallow and burns the nest."
    outcome: "No fight; nest cleared; same ending."
    sets: ["set_flag(flag.reeds_burned)", "set_flag(flag.nest_cleared)"]
  - id: ina_lure
    when: "Ina sings the drowners to the bank in pairs."
    outcome: "Split fight; nest cleared; same ending."
    sets: ["set_flag(flag.drowners_lured)", "set_flag(flag.nest_cleared)"]
  - id: lady_bargain
    when: "Player calls the Lady at the shrine before burying Mirek and passes Persuade 8 or Lore 6."
    outcome: "clue.choir_secret_pass without the burial; the quest's last objective is met but Mirek still waits to be buried."
    sets: ["add_clue(clue.choir_secret_pass)", "set_flag(flag.lady_told_pass)"]
  - id: silencers
    when: "Stage 3+, first arrival before the burial."
    outcome: "Fight or (in Choir disguise) send them away. Ina tells everything afterwards."
    sets: ["set_flag(flag.silencers_dealt)"]
failures:
  - id: player_dies
    result: reload_checkpoint
    recover: "Reload ravensford_arrival, before_silencers, reeds_entry or before_nest."
  - id: lady_refuses
    result: soft_fail
    recover: "Failed bargain checks lock. Burying Mirek always brings her back grateful, with no check."
  - id: lore_failed
    result: soft_fail
    recover: "Ina's 'things' line also teaches that they flee fire; the fight and the lure remain."
guarantees:
  - "Whistle reachable without a check (Ina's dialogue)."
  - "Nest clearable without a check (fight or lure)."
  - "clue.choir_secret_pass reachable without a check: bury Mirek, and dlg.assen_lady gives it unconditionally."
```

## 12. Open questions
- `play_beat(lady_rises)` is listed in both zones, because `dlg.assen_lady` can start at the burial ground (ruins) or at the reed shrine (reeds). If beat ids must be unique per section, rename one.
- `dlg.silencer_leader` has the enemy leader speaking only in barks, because enemies have no npc block. Participants list Ina only. That is fine if the dialogue system allows `player` lines with no NPC line answering.
- Stage 2+ adds one drowner to the lure's second wave via a scene rule. The schema has no stage-conditional waves. Alternative: a separate `enc.ravensford_lure_dark`.
