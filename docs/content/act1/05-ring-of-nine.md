---
section_id: a1.05
title: "The Ring of Nine"
act: 1
story_ref: "story.md §1 (the Ring of Nine, the Pact), §4 (stage 1: the stone cracks and oozes tar), §5.5; gdd.md §6.1, §6.11 (ded.anselm_lied), §7.1 #5"
zones: [zone.ring_of_nine]
available_when: "ms(ms.a1_audience_done) and not flag(flag.fair_started)"
escalation_stage_required: {min: 0, max: 0}
milestones_set: [ms.a1_ring_done]
milestones_read: [ms.a1_audience_done, ms.a1_ring_done]
level_band: [2, 3]
---

# The Ring of Nine

## 1. Scene summary

Outside the Lion Gate, past the barrow-mounds of Cintra's first kings, nine monoliths stand in a ring on a low hill: the surface relay of the Pact, where the crowned monarch speaks the Oath every nineteen winters. Kosk's shepherds say a stone has split and the dogs have gone mad. Hale comes at night. An old tar-gatherer, Grandmother Sorrel, is scraping black ooze into pots at the foot of the hill, and the barrow ditches are full of eyes. The split stone, the one that carries the fourth verse, is weeping black alchemical tar that smells of hot iron, and the smell has driven the region's dogs and a drover's mastiffs into a frenzy. Hale can fight the pack, lure half of it off with a drover's meat, or ring the hill with burning tar so that the dogs won't cross. Then Hale reads the worn chiselling on the split stone. The fourth line is mostly eaten by tar, but enough remains, `...NETEEN WIN...`, to show that Abbot Anselm's "copy" (`Till crown and key restore the light`) is not what Corvan's masons carved. The dramatic question: *what is the Ring, and who lied about it?* The section ends when Hale reads the split stone (`ms.a1_ring_done`).

## 2. Progress and escalation

- Stage 0. The tar is already seeping (the vault pressure that Dravin's letter warns about). At stage 1 the crack widens and the tar runs (variant `stage1_ring`, gdd §6.1 stage 1).
- `ms.a1_ring_done` fires when Hale examines the split stone (`split_stone`, no check). That interactable is available once the hounds are dealt with (`flag.ring_hounds_done`: won, or avoided).
- `clue.ring_true_chisel` comes with it. `ded.anselm_lied` unlocks automatically whenever the player holds both `item.false_fourth_verse` and that clue, in either order.
- The section pays `add_xp(200)` with the milestone.

## 3. Location layout

Exterior, night, cold wind, a low moon. About 120 × 80 m. The player walks east from the Lion Gate along the Barrow Road, then climbs the hill to the ring.

```
 W (Lion Gate)                                                         E
 [road_in]--- BARROW ROAD (gibbet, barrow-mounds both sides, ditches) ---+
                 drover's cart (meat)        Sorrel's camp (tar pots, lantern)
                                                     |
                                              ring_slope (hawthorns)
                                                     |
                                  RING_CIRCLE (30 m across, nine stones)
                                     N: verse stone I   NE: rune stone
                                     E: verse stone II  SE: rune stone
                                     S: verse stone III SW: rune stone
                                     W: verse stone IV (SPLIT, tar pool)   NW: rune stone
                                     centre: the voice-stone (bronze horn-mouth facing south)
```

- **barrow_road** (60 m): a sunken lane between grassy barrow-mounds. Deep ditches on both sides (the hounds' dens). A gibbet with an old cage. A **drover's cart** on its side in the ditch, oxen gone, a side of salt beef still lashed to it (pickup `item.drover_haunch`). The road is in shadow; hounds' eyes shine in the ditches but they don't attack on the road.
- **sorrel_camp** (at the hill's foot): a lean-to of hurdles, a smoky fire, a dozen clay pots of scraped tar, a horn lantern. Grandmother Sorrel. The camp is safe (the dogs fear her fire).
- **ring_slope**: a 20 m climb through hawthorn scrub, two old hawthorns (cover), a shallow **tar ditch** running round the hill's shoulder where the tar has seeped downhill (the "fire ring" if lit).
- **ring_circle**: the summit. Nine dark granite monoliths, 3–4 m tall, in a 30 m circle. Every stone is full cover. Four **verse stones** at the cardinal points, each carved with one line of the Oath in old Cintran capitals. Four **rune stones** between them, carved with dwarven runes. In the centre the squat **voice-stone**, with a bronze horn-mouth set into it facing south toward the Amell, green with age.
- **split_stone** (W, part of the circle): verse stone IV, cracked top to bottom, the crack a hand wide. Black tar wells out of it into a **tar pool** 5 m across (sticky, slows like deep mud, and **burns** if fire touches it). Down inside the crack, a glint of bronze: a pipe going down into the hill.

**Intended route.** Road (see the eyes, find the cart), Sorrel's camp (her warning and her offer), slope, ring. The hounds attack when Hale first steps inside the circle, unless both the lure and the fire ring were set.

```yaml zone
id: zone.ring_of_nine
name: "The Ring of Nine"
kind: exterior
map_node: map.cintra
time_of_day: night
cold_rate: 0
disguise_tag: null
music: ring_night
areas:
  - {id: barrow_road, description: "60 m sunken lane between barrow-mounds, deep ditches (hound dens), a gibbet, a drover's cart in the ditch with a side of salt beef."}
  - {id: sorrel_camp, description: "Lean-to of hurdles at the hill's foot, smoky fire, clay pots of scraped tar, a horn lantern. Safe."}
  - {id: ring_slope, description: "20 m climb, hawthorn scrub, two old hawthorns (cover), a shallow tar ditch round the hill's shoulder."}
  - {id: ring_circle, description: "Summit, 30 m circle of nine granite monoliths (full cover): four verse stones, four rune stones, a voice-stone with a bronze horn-mouth facing south."}
  - {id: split_stone, description: "West verse stone, cracked top to bottom. Tar pool 5 m across (sticky, flammable). Bronze pipe glinting deep in the crack."}
spawns:
  - {id: road_in, area: barrow_road, default: true}
  - {id: ditch_north, area: barrow_road, default: false}
  - {id: ditch_south, area: ring_slope, default: false}
  - {id: barrow_den, area: ring_circle, default: false}
exits:
  - id: to_gate
    area: barrow_road
    to_zone: zone.cintra_streets
    to_spawn: lion_gate
    condition: "true"
    effects: []
interactables:
  - id: drover_cart
    area: barrow_road
    kind: pickup
    label: "Cut the salt beef from the drover's cart"
    condition: "not has_item(item.drover_haunch) and not flag(flag.hounds_lured)"
    check: null
    once: true
    effects: ["give_item(item.drover_haunch, 1)"]
  - id: barrow_ditch
    area: ring_slope
    kind: search
    label: "Throw the meat into the far barrow ditch"
    condition: "has_item(item.drover_haunch) and not flag(flag.hounds_lured) and not flag(flag.ring_hounds_done)"
    check: null
    once: true
    effects: ["take_item(item.drover_haunch, 1)", "set_flag(flag.hounds_lured)", "play_beat(hounds_lured)"]
  - id: tar_ditch
    area: ring_slope
    kind: search
    label: "Light the tar ditch"
    condition: "(has_item(item.fire_oil) or flag(flag.sorrel_lantern)) and not flag(flag.tar_ring_lit) and not flag(flag.ring_hounds_done)"
    check: null
    once: true
    effects: ["set_flag(flag.tar_ring_lit)", "play_beat(tar_ring_burns)"]
  - id: split_stone_read
    area: split_stone
    kind: search
    label: "Read the split stone"
    condition: "flag(flag.ring_hounds_done) and not ms(ms.a1_ring_done)"
    check: null
    once: true
    effects: ["add_clue(clue.ring_true_chisel)", "add_clue(clue.ring_tar)", "play_beat(read_split_stone)", "reach_milestone(ms.a1_ring_done)", "add_xp(200)"]
  - id: verse_stones
    area: ring_circle
    kind: readable
    label: "Read the verse stones"
    condition: "true"
    check: null
    once: false
    effects: ["play_beat(read_verse_stones)"]
  - id: rune_stone
    area: ring_circle
    kind: search
    label: "Study the dwarven runes"
    condition: "true"
    check: {skill: lore, dc: 6}
    once: true
    effects: ["play_beat(runes_read)", "set_flag(flag.ring_runes_read)"]
    fail_effects: ["play_beat(runes_plain)"]
  - id: voice_stone
    area: ring_circle
    kind: search
    label: "Put your ear to the bronze horn"
    condition: "true"
    check: null
    once: false
    effects: ["play_beat(horn_breath)"]
  - id: tar_pots
    area: sorrel_camp
    kind: container
    label: "Sorrel's spare pots"
    condition: "flag(flag.sorrel_helped)"
    check: null
    once: true
    effects: []
triggers:
  - id: t_ring_enter
    area: barrow_road
    on: enter
    source: null
    condition: "not visited(zone.ring_of_nine)"
    once: true
    effects: ["set_checkpoint(ring_road)", "play_beat(eyes_in_ditch)"]
  - id: t_sorrel
    area: sorrel_camp
    on: enter
    source: null
    condition: "not flag(flag.sorrel_met)"
    once: true
    effects: ["start_dialogue(dlg.sorrel)"]
  - id: t_hounds_full
    area: ring_circle
    on: enter
    source: null
    condition: "not flag(flag.ring_hounds_done) and not flag(flag.ring_hounds_engaged) and not flag(flag.hounds_lured) and not flag(flag.tar_ring_lit)"
    once: false
    effects: ["set_checkpoint(ring_top)", "set_flag(flag.ring_hounds_engaged)", "play_beat(pack_rises)", "start_encounter(enc.ring_hounds)"]
  - id: t_hounds_half
    area: ring_circle
    on: enter
    source: null
    condition: "not flag(flag.ring_hounds_done) and not flag(flag.ring_hounds_engaged) and ((flag(flag.hounds_lured) and not flag(flag.tar_ring_lit)) or (flag(flag.tar_ring_lit) and not flag(flag.hounds_lured)))"
    once: false
    effects: ["set_checkpoint(ring_top)", "set_flag(flag.ring_hounds_engaged)", "play_beat(pack_rises)", "start_encounter(enc.ring_hounds_small)"]
  - id: t_hounds_avoided
    area: ring_circle
    on: enter
    source: null
    condition: "not flag(flag.ring_hounds_done) and flag(flag.hounds_lured) and flag(flag.tar_ring_lit)"
    once: true
    effects: ["set_flag(flag.ring_hounds_done)", "set_flag(flag.ring_hounds_avoided)", "play_beat(pack_held_off)", "add_xp(60)"]
hazards:
  - {id: tar_pool, area: split_stone, kind: deep_mud, params: {speed_mult: 0.6, root_pockets: 0, flammable: true, ignited_damage_per_second: 8, applies_status_when_burning: burning}}
  - {id: tar_ditch_fire, area: ring_slope, kind: fire, params: {damage_per_second: 5, starts_on_beat: tar_ring_burns, duration_s: 120, blocks: [beast]}}
checkpoints:
  - {id: ring_road, area: barrow_road}
  - {id: ring_top, area: ring_slope}
beats:
  - {id: eyes_in_ditch, description: "Wind, a low moon, the barrow-mounds black humps. In the ditches on both sides, pairs of eyes catch the light and keep pace. Panting. Nothing comes out onto the road."}
  - {id: hounds_lured, description: "The salt beef thumps into the far ditch. A snarling boil of shapes pours toward it; half the pack is fighting over meat in the dark."}
  - {id: tar_ring_burns, description: "The tar ditch catches with a whump and a line of low, stinking fire runs round the hill's shoulder. Hounds yelp and hang back beyond it."}
  - {id: pack_rises, description: "As Hale steps between the stones, the dogs come over the hill's lip: farm curs, a sheepdog with a torn collar, a drover's mastiffs. Foam on their jaws, eyes rolling, mad on the smell."}
  - {id: pack_held_off, description: "Half the pack is fighting over meat, the rest circle beyond the fire, howling. None will cross. Hale has the ring to themself."}
  - {id: pack_broken, description: "The last dog falls, or limps whimpering into the dark. Silence, except for the tar dripping from the split stone."}
  - {id: read_verse_stones, description: "North: 'BY IRON FORGED IN MOUNTAIN DEEP'. East: 'BY LION'S BLOOD THE WATCH WE KEEP'. South: 'LET BOLT AND BAR HOLD FAST THE NIGHT'. West: the split stone."}
  - {id: read_split_stone, description: "Hale scrapes tar from the west stone's face. Most of the line is eaten black. What remains: '...NETEEN WIN...' in the same old capitals. Nothing like 'crown' or 'key' or 'restore'. If Hale holds Anselm's card, it is held up beside the stone; the words don't fit the space."}
  - {id: runes_read, description: "The dwarven runes are not prayers. They are instructions: 'PRESSURE. RELIEF. SPEAK AND THE BOLTS TURN. NINETEEN.' The Ring is not a shrine. It is a valve."}
  - {id: runes_plain, description: "Angular dwarven runes, worn by four hundred winters. Beautiful and unreadable."}
  - {id: horn_breath, description: "From deep inside the bronze horn, a long slow breath of warm air that smells of hot iron, and very faintly, far below, a sound like a great bolt grinding a hair's width in its socket."}
npcs:
  - {npc: npc.grandmother_sorrel, area: sorrel_camp, condition: "true"}
encounters: [enc.ring_hounds, enc.ring_hounds_small]
loot:
  - {container: tar_pots, items: [{item: item.fire_oil, count: 2}], condition: "true"}
variants:
  - id: after_ring
    when: "ms(ms.a1_ring_done)"
    description: "The hill is quiet. Bodies of dogs dragged into a ditch, or none. The tar still drips."
    npcs_absent: []
    encounters_disabled: [enc.ring_hounds, enc.ring_hounds_small]
    interactables_disabled: [barrow_ditch, tar_ditch]
  - id: stage1_ring
    when: "stage() >= 1"
    description: "Stage 1 (gdd §6.1): the crack has widened to an arm's width and tar runs down the hill in a black stream. Kosk's soldiers stand watch at the foot of the hill by a brazier. Sorrel is gone; her pots lie smashed."
    npcs_absent: [npc.grandmother_sorrel]
    encounters_disabled: [enc.ring_hounds, enc.ring_hounds_small]
    interactables_disabled: [barrow_ditch, tar_ditch, tar_pots]
```

## 4. NPCs present

**Voice notes.** **Grandmother Sorrel**: very old, toothless, cheerful, croaky; talks to the dogs and the stones as much as to people; mercenary in a friendly way ("Everything's for sale, love, even tar").

```yaml npc
id: npc.grandmother_sorrel
name: "Grandmother Sorrel"
faction: null
role: "Tar-gatherer who sells the Ring's ooze as lamp oil"
motive: "Scrape as much free tar as she can before someone stops her. It burns longer than tallow and sells in the Fishmarket."
secret: "On the equinox night she saw monks with shuttered lanterns at the split stone, singing softly and filling jars with tar. She thought they were blessing it."
disposition: neutral
essential: true
dialogue: dlg.sorrel
barks: ["Mind my pots!", "Good dogs. Mad dogs. Good mad dogs.", "Burns lovely, this. Smells like the forge of the gods."]
combat: null
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.sorrel
participants: [npc.grandmother_sorrel]
start: open
nodes:
  open:
    type: line
    speaker: npc.grandmother_sorrel
    text: "Ho! Don't you go up there, love. The dogs'll have your knees off. They smell the black stuff and go mad as March. All except me. I smell worse."
    direction: "Scraping tar into a pot with a wooden spoon."
    effects: ["set_flag(flag.sorrel_met)"]
    next: hub
  hub:
    type: choice
    options:
      - id: tar
        text: "What is this stuff?"
        next: tar
      - id: dogs
        text: "How do I get past the dogs?"
        next: dogs
      - id: when
        text: "When did the stone split?"
        next: split_when
      - id: seen
        text: "Anyone else been up here at night?"
        next: seen
      - id: go
        text: "I'll manage."
        next: bye
  tar:
    type: line
    speaker: npc.grandmother_sorrel
    text: "Comes out of the stone. Out of the ground under it, more like. Burns like a saint's temper and smells like a smith's armpit. I sell it in the Fishmarket. Two coppers a pot."
    next: hub
  dogs:
    type: line
    speaker: npc.grandmother_sorrel
    text: "Dogs hate two things: fire and missing dinner. There's a drover's cart in the ditch, oxen bolted, beef still on it. And the black stuff in the ditch up yonder burns lovely, if you've a light."
    next: dogs_hub
  dogs_hub:
    type: choice
    options:
      - id: lantern
        text: "Lend me your lantern. [Bribe 5]"
        tag: bribe
        bribe: 5
        effects: ["set_flag(flag.sorrel_lantern)"]
        next: lantern_given
      - id: lantern_ask
        text: "Lend me your lantern, Grandmother. I'll bring it back. [Persuade 4]"
        tag: persuade
        check: {skill: persuade, dc: 4, pass: lantern_free, fail: lantern_no}
        once: true
      - id: back
        text: "Thanks."
        next: hub
  lantern_given:
    type: line
    speaker: npc.grandmother_sorrel
    text: "Five coppers! Generous. Don't drop it in the pool or you'll go up like a haystack."
    next: hub
  lantern_free:
    type: line
    speaker: npc.grandmother_sorrel
    text: "Bring it back? Nobody brings anything back. Go on, then. You've an honest face under the mud."
    effects: ["set_flag(flag.sorrel_lantern)", "set_flag(flag.sorrel_helped)"]
    next: hub
  lantern_no:
    type: line
    speaker: npc.grandmother_sorrel
    text: "Ha! No. That lantern's older than the Queen."
    next: hub
  split_when:
    type: line
    speaker: npc.grandmother_sorrel
    text: "Equinox night. The bells rang at St. Corwen's, all on their own, and the ground went 'thunk', like a door shutting under the hill. Next morning, split stone, black stuff, mad dogs. Best season I've had."
    next: hub
  seen:
    type: line
    speaker: npc.grandmother_sorrel
    text: "Monks. That same night. Grey ones, lanterns shuttered, singing soft, up at the split stone with jars. Taking tar, like me. I thought they were blessing it. Monks don't usually bless tar."
    effects: ["add_clue(clue.monks_at_ring)"]
    next: hub
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.ring_hounds
zone: zone.ring_of_nine
enemies:
  - {enemy: enemy.feral_hound, count: 3, spawn: barrow_den, variant: null}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.feral_hound, count: 2, spawn: ditch_south, variant: null}, {enemy: enemy.feral_hound, count: 1, spawn: ditch_south, variant: mastiff}]}
attack_tokens: null
allow_yield: false
allies: []
checkpoint: ring_top
avoidable_by: ["dlg.sorrel"]
on_won: ["set_flag(flag.ring_hounds_done)", "play_beat(pack_broken)"]
on_yielded: []
on_player_fled: ["clear_flag(flag.ring_hounds_engaged)"]
```

```yaml encounter
id: enc.ring_hounds_small
zone: zone.ring_of_nine
enemies:
  - {enemy: enemy.feral_hound, count: 2, spawn: barrow_den, variant: null}
  - {enemy: enemy.feral_hound, count: 1, spawn: barrow_den, variant: mastiff}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: ring_top
avoidable_by: ["dlg.sorrel"]
on_won: ["set_flag(flag.ring_hounds_done)", "play_beat(pack_broken)"]
on_yielded: []
on_player_fled: ["clear_flag(flag.ring_hounds_engaged)"]
```

**Fight notes.** Feral hounds circle and lunge in turns (gdd §6.7) and are weak to fire: fire oil on the blade, or fighting along the burning tar ditch, makes them easy. The `mastiff` variant is a drover's war-dog: same stat block ×1.5 HP and poise, slower. The tar pool is a trap for both sides: kick a hound into it while it burns. Standing stones are full cover; use them to break the pack's circling. Pack hounds do not flee (gdd); there is no yield.

**Non-combat alternatives.** Meat in the ditch halves the pack; the fire ring halves it; both together avoid the fight (`t_hounds_avoided`). Fleeing down the hill is allowed; the encounter resets on the next visit.

## 7. Items and clues

```yaml item
id: item.drover_haunch
name: "Side of salt beef"
category: key
description: "Cut from an overturned drover's cart on the Barrow Road. Heavy, salty, and very interesting to dogs."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml clue
id: clue.ring_true_chisel
theory: theory.fourth_verse
title: "The split stone's true chiselling"
text: "The Ring's fourth verse stone is split and eaten by tar, but its old capitals still read '...NETEEN WIN...'. Whatever Corvan's masons carved, it was not 'Till crown and key restore the light'."
supports: []
refutes: []
```

```yaml clue
id: clue.ring_tar
theory: theory.anselm_plan
title: "The weeping stone"
text: "The split stone weeps hot, iron-smelling alchemical tar through a bronze pipe that runs down into the hill. The ground 'shut like a door' on the equinox night. The Ring is a vent for something under the earth."
supports: []
refutes: []
```

```yaml clue
id: clue.monks_at_ring
theory: theory.choir
title: "Monks at the split stone"
text: "On the equinox night, after the bells rang, grey-robed monks with shuttered lanterns came to the split stone, singing softly, and filled jars with tar."
supports: []
refutes: []
```

```yaml deduction
id: ded.anselm_lied
theory: theory.fourth_verse
condition: "has_item(item.false_fourth_verse) and has_clue(clue.ring_true_chisel)"
title: "Anselm's verse is false"
text: "The Abbot wrote the fourth verse 'from memory'. The stone his own Oath was carved from says otherwise. A man who never forgets a line forgot this one, on purpose."
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.a1_ring_done, type: milestone, desc: "The player read the split stone at the Ring of Nine."}
  - {id: flag.sorrel_met, type: bool, desc: "Grandmother Sorrel's conversation has played."}
  - {id: flag.sorrel_lantern, type: bool, desc: "Sorrel lent her lantern (lights the tar ditch without fire oil)."}
  - {id: flag.sorrel_helped, type: bool, desc: "Sorrel gave the lantern freely; her spare pots (fire oil) open."}
  - {id: flag.hounds_lured, type: bool, desc: "Half the pack is busy with the drover's beef."}
  - {id: flag.tar_ring_lit, type: bool, desc: "The tar ditch is burning; half the pack won't cross."}
  - {id: flag.ring_hounds_done, type: bool, desc: "The hounds are beaten or held off; the split stone can be read."}
  - {id: flag.ring_hounds_engaged, type: bool, desc: "The hound fight is running (stops re-triggering when the player steps in and out of the circle; cleared if the player flees the zone)."}
  - {id: flag.ring_hounds_avoided, type: bool, desc: "The player avoided the hound fight entirely (lure and fire)."}
  - {id: flag.ring_runes_read, type: bool, desc: "The player read the dwarven runes (Lore 6): the Ring is a valve."}
reads:
  - ms.a1_audience_done
  - flag.fair_started
```

## 9. Quest hooks

This section contributes the `ring` objective of `quest.main_a1` stage `follow_the_leads` (declared in `02-audience-at-court.md`).

## 10. Rumors and event cards (optional)

None.

## 11. Failure states and branches

```yaml branches
paths:
  - id: fight_pack
    when: "Player enters the ring with no preparation."
    outcome: "Two waves (3, then 2 + mastiff). Then the split stone."
    sets: ["set_flag(flag.ring_hounds_done)"]
  - id: half_pack
    when: "Player lured the pack with the beef or lit the tar ditch (one of the two)."
    outcome: "One wave of 3 (2 + mastiff)."
    sets: ["set_flag(flag.ring_hounds_done)"]
  - id: no_fight
    when: "Player did both."
    outcome: "No fight; 60 XP (the skipped-fight award, gdd §6.4)."
    sets: ["set_flag(flag.ring_hounds_avoided)"]
  - id: compare
    when: "Player reads the split stone while holding item.false_fourth_verse (or gets it later)."
    outcome: "ded.anselm_lied unlocks; dlg.anselm, dlg.kosk and dlg.maelis gain options."
    sets: []
failures:
  - id: player_dies
    result: reload_checkpoint
    recover: "Reload ring_top (or ring_road). Preparations (beef, fire) persist if made before the checkpoint."
  - id: fled_the_pack
    result: soft_fail
    recover: "Leaving the zone mid-fight resets the hounds; return and try again, with or without preparation."
guarantees:
  - "ms.a1_ring_done: the drover's beef (no check) plus the tar ditch lit with Sorrel's lantern (Bribe 5) or fire oil from the market avoids the fight entirely; otherwise the pack can be fought. The split stone has no check."
```

## 12. Open questions

1. **Hazard blocking beasts.** `tar_ditch_fire` uses `params.blocks: [beast]` so hound AI will not path through fire. Confirm with the AI implementer that a fire hazard can act as a navigation blocker for the `beast` tag.
2. **Fire-on-tar.** The tar pool ignites if any fire touches it (fire oil, a burning hound, a thrown lantern). Proposed as a `deep_mud` hazard with `flammable: true`; may deserve its own hazard kind (`tar`).
3. **Wave spawn.** The second wave comes over the hill from `ditch_south` (behind the player), to punish fighting with your back to the slope.
