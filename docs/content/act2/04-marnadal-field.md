---
section_id: a2.04
title: "Battle of Marnadal Field"
act: 2
story_ref: "story.md §2 Battle of Marnadal (1263), §3 Kosk's secret and Hesk Ironjaw, §6 Battle of Marnadal Field, §11 rumor 8"
zones: [zone.marnadal_field]
available_when: "ms(ms.act1_complete)"
escalation_stage_required: {min: 1, max: 4}
milestones_set: [ms.a2_torc_taken]
milestones_read: [ms.a2_torc_taken, ms.a2_vel_aram_cleared, ms.act1_complete]
level_band: [6, 8]
---

# Battle of Marnadal Field

## 1. Scene summary
Five years ago, on this valley floor between the Marnadal and the Strept foothills, Lord Marshal Kosk's heavy horse broke the highland clans. The dead were never properly buried: the Cintrans burned their own, and the clansmen were pushed into a ditch and left. On the night of the new moon, the bitter dead re-enact the charge. Revenant cavaliers thunder down the old lanes at a shield-wall of revenant clansmen, and both sides turn on anything living between them. Among the clan dead stands **Callum Darrach**, champion of Darrach Hall and Hesk Ironjaw's sworn shield-brother. He asks the player to carry the hall's **bronze-and-iron torc** home to Dun Strept, and he will only give it to someone who has held the line beside him or who knows the clan's naming rite. The dead also hold a truth: a grey priest walked into the clan camp under a white branch the night before the battle and swore the halls would burn whether the clans knelt or fought. The Cintrans' own chaplain that year was a man named Anselm. The dramatic question: what does the player owe the dead of a war the Crown won? The section ends when the torc is taken (`ms.a2_torc_taken`).

## 2. Progress and escalation
- **The vigil is a camp choice, not a clock.** At the vigil stones the player chooses "Keep vigil until the new moon rises". That sets `flag.new_moon_vigil` and switches the zone to its `new_moon` variant (revenants, Callum, Ser Odo). Leaving by the map marker clears the flag. Without the vigil, the field is a quiet, dark plain of mud and bone where scavengers dig.
- `ms.a2_torc_taken` is set when the player lifts the torc from the clan ditch after Callum grants it. Callum grants it either after the player holds the line through the charge (`enc.marnadal_charge`) or after they perform the naming rite at the clan stones (`flag.torc_rite_known`).
- `flag.torc_rite_known` is a gdd output. While it is set, revenants no longer rise again after 6 s (gdd §6.7 enemy rule). Sources: Callum teaches it when he grants the torc; Lore 6 at the clan stones; Gammer Rusk sells it (40 crowns); Yorek, the Strept prisoner freed at Vel Aram (`flag.yorek_freed`), recites it.
- **Stage 1–2:** as written; at stage 2 a black silt mist lies on the river reach. **Stage 3:** a Choir column marches across the field toward Vel Aram (`enc.field_choir_column`) if Vel Aram is not cleared. **Stage 4 (Act III):** the zone stays open so a player who skipped the torc can still fetch it before Dun Strept. The Choir column is gone and snow lies on the dyke.

## 3. Location layout
Night, exterior, about 300 × 200 m. North is the river, south the foothills.
- **Ford road** (north edge): where the crossing and the ford come out. Player entry. A broken Cintran waystone.
- **Cintran lines** (north rise, 60 × 30 m): where the heavy horse formed up. Rotted lance-stakes in rows, a collapsed timber command platform (climbable, 3 m, the best view of the field), and the stone cairn over the burned Cintran dead. At the vigil, Ser Odo Vane's ghost stands on the platform.
- **Charge lanes** (centre, 150 m long): three parallel strips of churned mud, 8 m wide, separated by low banks of bones and broken lances (knee-high, half cover). They are `deep_mud`. During the charge, riders come down the lanes north to south, and a lane flares with a pale light 2 s before a rider enters it (the dodge tell).
- **Strept dyke** (south): a 120 m low stone wall (1 m, full cover crouched) where the clans stood. The **clan stones** are three carved standing stones behind the dyke's centre, cut with clan marks and a naming verse. This is where Callum stands.
- **Clan ditch** (south-west): a long trench 40 m × 4 m where the clan dead were thrown, now a bog of bone and black water. The torc lies with Callum's bones at the ditch's far end. `deep_mud` throughout.
- **Bone-pickers' camp** (west): a tarp shelter, a cart, spoil heaps, three diggers and Gammer Rusk.
- **Vigil stones** (east): a ring of old stones on a hillock with a fire pit. The camp choice and rest point.

Intended route: ford road → (Rusk) → vigil stones → choose the vigil → the dyke and Callum → the charge or the rite → the ditch.

```yaml zone
id: zone.marnadal_field
name: "Marnadal Field"
kind: exterior
map_node: map.marnadal_field
time_of_day: night
cold_rate: 0
disguise_tag: null
music: field_of_bones
areas:
  - {id: ford_road, description: "North edge where the crossing and the ford come out. Broken Cintran waystone. Player entry."}
  - {id: cintran_lines, description: "North rise 60 x 30 m. Rotted lance-stakes, collapsed command platform (climbable, 3 m), cairn over the burned Cintran dead."}
  - {id: charge_lanes, description: "Three parallel mud lanes, 150 m long, 8 m wide, divided by knee-high banks of bones and broken lances (half cover)."}
  - {id: strept_dyke, description: "120 m low stone wall (1 m, full cover crouched) where the clans stood. Three carved clan stones behind its centre."}
  - {id: clan_ditch, description: "40 x 4 m trench of bone and black water south-west of the dyke. Callum's bones and torc at the far end."}
  - {id: pickers_camp, description: "West edge: tarp shelter, cart, spoil heaps. Gammer Rusk and three diggers."}
  - {id: vigil_stones, description: "Ring of old stones on an eastern hillock, fire pit. Camp choice and rest point."}
spawns:
  - {id: ford_road, area: ford_road, default: true}
  - {id: river_reach, area: ford_road}
  - {id: lanes_north, area: charge_lanes}
  - {id: dyke_line, area: strept_dyke}
  - {id: lines_stakes, area: cintran_lines}
  - {id: pickers, area: pickers_camp}
exits: []
interactables:
  - id: travel_marker
    area: ford_road
    kind: map_board
    label: "Leave the field (travel)"
    condition: "true"
    check: null
    once: false
    effects: ["clear_flag(flag.new_moon_vigil)"]
  - id: vigil_fire
    area: vigil_stones
    kind: rest
    label: "Make camp at the vigil stones"
    condition: "true"
    check: null
    once: false
    effects: ["heal_player(full)", "set_checkpoint(vigil_camp)", "start_dialogue(dlg.vigil_choice)"]
  - id: clan_stones_read
    area: strept_dyke
    kind: readable
    label: "Read the carved clan stones"
    condition: "true"
    check: {skill: lore, dc: 6}
    once: true
    effects: ["set_flag(flag.torc_rite_known)"]
    fail_effects: []
  - id: naming_rite
    area: strept_dyke
    kind: lever
    label: "Speak the naming rite at the clan stones"
    condition: "flag(flag.torc_rite_known) and flag(flag.new_moon_vigil) and not flag(flag.field_rite_performed)"
    check: null
    once: true
    effects: ["set_flag(flag.field_rite_performed)", "add_rep(faction.strept, 10)", "play_beat(revenants_kneel)"]
  - id: cintran_cairn
    area: cintran_lines
    kind: search
    label: "Search the Cintran cairn"
    condition: "true"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["give_item(item.marnadal_roll, 1)"]
    fail_effects: []
  - id: torc_bones
    area: clan_ditch
    kind: pickup
    label: "Lift the torc from Callum's bones"
    condition: "flag(flag.champion_grants_torc) and not has_item(item.marnadal_torc) and not ms(ms.a2_torc_taken)"
    check: null
    once: true
    effects: ["give_item(item.marnadal_torc, 1)", "set_flag(flag.torc_rite_known)", "play_beat(champion_rests)", "reach_milestone(ms.a2_torc_taken)"]
  - id: ditch_without_leave
    area: clan_ditch
    kind: search
    label: "Dig in the ditch"
    condition: "not flag(flag.champion_grants_torc)"
    check: null
    once: false
    effects: ["damage_player(10)", "apply_status(chill, 20)"]
triggers:
  - id: meet_champion
    area: strept_dyke
    on: enter
    source: null
    condition: "flag(flag.new_moon_vigil) and not ms(ms.a2_torc_taken)"
    once: false
    effects: ["start_dialogue(dlg.callum_darrach)"]
  - id: meet_odo
    area: cintran_lines
    on: enter
    source: null
    condition: "flag(flag.new_moon_vigil) and not flag(flag.odo_met)"
    once: true
    effects: ["set_flag(flag.odo_met)", "start_dialogue(dlg.odo_vane)"]
  - id: charge_on_lanes
    area: charge_lanes
    on: enter
    source: null
    condition: "flag(flag.new_moon_vigil) and not flag(flag.field_rite_performed) and not flag(flag.held_the_line) and not flag(flag.odo_stood_down)"
    once: false
    effects: ["set_checkpoint(vigil_camp)", "play_beat(charge_sounds)", "start_encounter(enc.marnadal_charge)"]
  - id: charge_footonly
    area: charge_lanes
    on: enter
    source: null
    condition: "flag(flag.new_moon_vigil) and not flag(flag.field_rite_performed) and not flag(flag.held_the_line) and flag(flag.odo_stood_down)"
    once: false
    effects: ["set_checkpoint(vigil_camp)", "start_encounter(enc.marnadal_footmen)"]
  - id: choir_column
    area: ford_road
    on: enter
    source: null
    condition: "stage() == 3 and not ms(ms.a2_vel_aram_cleared)"
    once: true
    effects: ["start_encounter(enc.field_choir_column)"]
hazards:
  - {id: lane_mud, area: charge_lanes, kind: deep_mud, params: {speed_mult: 0.6}}
  - {id: ditch_bog, area: clan_ditch, kind: deep_mud, params: {speed_mult: 0.5}}
checkpoints:
  - {id: field_arrival, area: ford_road}
  - {id: vigil_camp, area: vigil_stones}
beats:
  - {id: new_moon_rises, description: "The last light goes. Mist pours off the river. Along the dyke, grey shapes stand up out of the mud and lock shields. On the north rise, horses that are not there stamp and blow."}
  - {id: charge_sounds, description: "A horn that is not there. The lanes flare pale one by one as the dead cavalry comes."}
  - {id: revenants_kneel, description: "The player speaks the names. Along the dyke the clansmen lower their shields and kneel; on the rise the riders turn their heads away. The charge never comes."}
  - {id: champion_rests, description: "Callum's shade watches the torc leave the water, nods once, and is gone. The ditch is only mud."}
  - {id: odo_stands_down, description: "Ser Odo lowers his sword. Behind him the ghost riders dismount and lead their horses away into the mist."}
npcs:
  - {npc: npc.callum_darrach, area: strept_dyke, condition: "flag(flag.new_moon_vigil) and not ms(ms.a2_torc_taken)"}
  - {npc: npc.odo_vane, area: cintran_lines, condition: "flag(flag.new_moon_vigil)"}
  - {npc: npc.gammer_rusk, area: pickers_camp, condition: "not flag(flag.rusk_hostile)"}
encounters: [enc.marnadal_charge, enc.marnadal_footmen, enc.field_bone_pickers, enc.field_choir_column]
loot:
  - {container: cintran_cairn, items: [{item: item.fire_oil, count: 1}], condition: "true"}
variants:
  - id: quiet_night
    when: "not flag(flag.new_moon_vigil)"
    description: "Dark, quiet, wind in the lance-stakes. No dead walk. Scavenger lanterns bob at the west edge."
    npcs_absent: [npc.callum_darrach, npc.odo_vane]
    encounters_disabled: [enc.marnadal_charge, enc.marnadal_footmen]
    interactables_disabled: [naming_rite]
  - id: new_moon
    when: "flag(flag.new_moon_vigil)"
    description: "New moon. Mist on the field, revenant shield-wall on the dyke, ghost riders on the rise. Lanes flare before each charge."
    npcs_absent: []
    encounters_disabled: [enc.field_bone_pickers]
    interactables_disabled: []
  - id: black_mist
    when: "stage() >= 2"
    description: "A black silt mist lies on the river reach and the ford road."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: winter
    when: "stage() >= 4"
    description: "Snow on the dyke and the lance-stakes. The pickers have gone."
    npcs_absent: [npc.gammer_rusk]
    encounters_disabled: [enc.field_bone_pickers, enc.field_choir_column]
    interactables_disabled: []
  - id: laid_to_rest
    when: "ms(ms.a2_torc_taken) and flag(flag.field_rite_performed)"
    description: "Stones set on the dyke in a neat row. The dead do not walk here any more."
    npcs_absent: [npc.callum_darrach]
    encounters_disabled: [enc.marnadal_charge, enc.marnadal_footmen]
    interactables_disabled: []
```

## 4. NPCs present
**Voice notes.** Callum: a highland champion's formal cadence, rolling Strept r's, speaks of himself in the past tense, bitter but never pleading. He calls the player "living one". Ser Odo Vane: a Cintran knight who still thinks it is 1263, clipped and courtly, ashamed under the courtesy. Gammer Rusk: a toothless, merry scavenger, calls everyone "duck", sells the dead's buttons and knows the dead's customs.

```yaml npc
id: npc.callum_darrach
name: "Callum Darrach"
faction: faction.strept
role: "Shade of the clans' champion of Darrach Hall, Hesk Ironjaw's sworn shield-brother"
motive: "To go home. Darrach Hall's torc must reach Hesk so the hall's dead can be spoken over at its cairn."
secret: "He spoke with the grey priest under the white branch and chose to fight. He blames himself for the halls."
disposition: wary
essential: true
dialogue: dlg.callum_darrach
barks: ["Hold.", "They come again. They always come again.", "Name me, living one."]
combat: null
shop: null
```

```yaml npc
id: npc.odo_vane
name: "Ser Odo Vane"
faction: faction.crown
role: "Shade of a Cintran knight-captain of the heavy horse"
motive: "To finish the charge and be told it was worth it."
secret: "He carried the torch to the first clan hall on Kosk's order and has never stopped smelling the smoke."
disposition: neutral
essential: true
dialogue: dlg.odo_vane
barks: ["Form on me!", "For the Lion.", "Smoke. Always smoke."]
combat: null
shop: null
```

```yaml npc
id: npc.gammer_rusk
name: "Gammer Rusk"
faction: null
role: "Bone-picker and relic seller"
motive: "Dig enough brass off the dead to buy a cottage before winter."
secret: "She has tried to dig up the champion's torc four times and felt hands in the mud each time."
disposition: neutral
essential: false
dialogue: dlg.gammer_rusk
barks: ["Mind the holes, duck.", "Buttons, buckles, saints' teeth!", "The dead don't need it. I do."]
combat: enemy.bandit
shop: {stock: [{item: item.poultice, count: 4}, {item: item.fire_oil, count: 2}, {item: item.smoke_pot, count: 2}], price_mod: 0.9}
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.vigil_choice
participants: []
start: ask
nodes:
  ask:
    type: branch
    cases:
      - {if: "ms(ms.a2_torc_taken)", next: rest_only}
    else: choose
  choose:
    type: choice
    options:
      - id: vigil
        text: "Keep vigil until the new moon rises."
        effects: ["set_flag(flag.new_moon_vigil)", "play_beat(new_moon_rises)", "verify_rumor(rumor.r08_new_moon_dead)"]
        next: bye
      - id: rest
        text: "Rest and move on before dark."
        next: bye
  rest_only:
    type: line
    speaker: player
    text: "Quiet. Just the wind in the lance-stakes."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.callum_darrach
participants: [npc.callum_darrach]
start: greet
nodes:
  greet:
    type: branch
    cases:
      - {if: "flag(flag.champion_grants_torc)", next: granted_again}
      - {if: "flag(flag.kosk_badge_worn)", next: badge}
      - {if: "flag(flag.held_the_line) or flag(flag.field_rite_performed)", next: honoured}
    else: first
  badge:
    type: line
    speaker: npc.callum_darrach
    text: "You wear the Marshal's lion on your breast, living one. That badge lit our halls. Take it off, or walk back into the mist with the rest of his riders."
    direction: "The shield-wall turns its blank faces toward the player."
    next: bye
  first:
    type: line
    speaker: npc.callum_darrach
    text: "Living one. On this field. On this night. You are a fool, or you came for me. I was Callum, of Darrach Hall, champion of the clans. I held this wall."
    direction: "A tall shade in a mail shirt black with old blood, a war-axe on his shoulder, his throat bare."
    next: hub
  honoured:
    type: line
    speaker: npc.callum_darrach
    text: "You stood. Or you named us. Either way, the clans see you. Hear what I ask."
    next: ask
  hub:
    type: choice
    options:
      - id: what
        text: "What happened here?"
        next: what
      - id: priest
        text: "The war began somewhere. Who started it?"
        next: priest
      - id: want
        text: "What do you want from the living?"
        next: ask
      - id: leave
        text: "I'll leave you to your war."
        next: bye
  what:
    type: line
    speaker: npc.callum_darrach
    text: "They came down the lanes at dawn with lances and we broke them twice. The third time they did not come at us. They rode round us, to the halls, with torches. We heard our children from here."
    next: hub
  priest:
    type: line
    speaker: npc.callum_darrach
    text: "A grey priest walked into our fires the night before, under a white branch. He swore the Cintrans would burn our halls whether we knelt or fought. So we fought. They burned them anyway."
    effects: ["add_clue(clue.grey_priest_parley)"]
    next: hub
  ask:
    type: line
    speaker: npc.callum_darrach
    text: "Darrach's torc lies with my bones in their ditch. Carry it home to Dun Strept, to Hesk Ironjaw, who stood beside me. Tell him Darrach held. Until it goes home, I stand here every dark of the moon."
    next: ask_choice
  ask_choice:
    type: choice
    options:
      - id: granted
        text: "I'll carry it."
        condition: "flag(flag.held_the_line) or flag(flag.field_rite_performed)"
        next: grant
      - id: how
        text: "I'll carry it. What must I do?"
        condition: "not flag(flag.held_the_line) and not flag(flag.field_rite_performed)"
        next: test
      - id: rite_known
        text: "I know the naming. I'll speak it at the stones."
        condition: "flag(flag.torc_rite_known) and not flag(flag.field_rite_performed)"
        next: rite_go
      - id: strept_friend
        text: "The clans already know me, Callum. Hesk's people have shared their fire with me."
        condition: "rep_tier(faction.strept) >= friendly and not flag(flag.held_the_line) and not flag(flag.field_rite_performed)"
        next: grant
      - id: sway
        text: "[Sway] You don't need a test. You need someone who'll walk into Dun Strept and say your name. That's me."
        tag: sway
        condition: "perk(perk.kingmaker) and not flag(flag.held_the_line) and not flag(flag.field_rite_performed)"
        next: grant
      - id: later
        text: "Not tonight."
        next: bye
  test:
    type: line
    speaker: npc.callum_darrach
    text: "Stand the wall with me when they come down the lanes. Or speak our names at the stones so the dead lie down. Do either and the torc is yours."
    next: bye
  rite_go:
    type: line
    speaker: npc.callum_darrach
    text: "Then speak it. Name us all. We have waited five winters to hear it from anyone."
    next: bye
  grant:
    type: line
    speaker: npc.callum_darrach
    text: "Then take it from the ditch. At Darrach's cairn, give it to Hesk and say: Home from the mud. Home from the iron. The hill holds you now. Those are the naming's last words. Now you know them."
    effects: ["set_flag(flag.champion_grants_torc)", "set_flag(flag.torc_rite_known)", "add_rep(faction.strept, 5)"]
    next: bye
  granted_again:
    type: line
    speaker: npc.callum_darrach
    text: "The ditch, living one. It waits."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.odo_vane
participants: [npc.odo_vane]
start: greet
nodes:
  greet:
    type: branch
    cases:
      - {if: "flag(flag.kosk_badge_worn) or has_item(item.kosk_writ)", next: greet_marshal}
    else: greet_plain
  greet_marshal:
    type: line
    speaker: npc.odo_vane
    text: "The Marshal's man! Thank God. Form on me, the clans are holding at the wall. One more charge and the Lion has the valley."
    direction: "A knight-captain in rusted plate on the fallen platform, helm under his arm, half his face scorched."
    next: hub
  greet_plain:
    type: line
    speaker: npc.odo_vane
    text: "Halt. You are no rider of mine. Camp follower? Clansman's spy? Speak quickly, the charge sounds soon."
    direction: "A knight-captain in rusted plate on the fallen platform, helm under his arm, half his face scorched."
    next: hub
  hub:
    type: choice
    options:
      - id: chaplain
        text: "Who blessed your charge, ser?"
        next: chaplain
      - id: halls
        text: "What happened to the clan halls?"
        next: halls
      - id: stand_down
        text: "[Persuade 6] The war is over, ser. It's been over five winters. The clans surrendered. You can stand your riders down."
        tag: persuade
        condition: "not flag(flag.odo_stood_down)"
        check: {skill: persuade, dc: 6, pass: stand_down, fail: refuse}
      - id: order
        text: "[Item: Marshal's writ] Captain. By the Marshal's order: stand down the horse."
        tag: item
        condition: "has_item(item.kosk_writ) and not flag(flag.odo_stood_down)"
        next: stand_down
      - id: leave
        text: "Carry on, ser."
        next: bye
  chaplain:
    type: line
    speaker: npc.odo_vane
    text: "Our chaplain, Father Anselm. He rode back from parley with the clans that night white as milk and said they would never kneel. At dawn he blessed us. 'God burns the proud,' he said."
    effects: ["add_clue(clue.marnadal_chaplain)"]
    next: chaplain_2
  chaplain_2:
    type: line
    speaker: npc.odo_vane
    text: "After the halls he wept in the mud and cursed the Marshal to his face. A good priest. He said the nobles who ordered it would answer for every child. Odd thing to say to a Marshal."
    next: hub
  halls:
    type: line
    speaker: npc.odo_vane
    text: "The Marshal gave the order. It was the only way to end it, he said. We lit the thatch ourselves. I carried the first torch. I can still smell it. Can you smell it?"
    next: hub
  refuse:
    type: line
    speaker: npc.odo_vane
    text: "Over? Listen. Can't you hear the horn? Nothing is over."
    next: hub
  stand_down:
    type: line
    speaker: npc.odo_vane
    text: "Over. Five winters. Then what have I been riding at? ...Very well. Horse! Stand down. Lead them off, lads. Lead them off."
    effects: ["set_flag(flag.odo_stood_down)", "play_beat(odo_stands_down)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.gammer_rusk
participants: [npc.gammer_rusk]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.gammer_rusk
    text: "Evening, duck! Buttons, buckles, saints' teeth, a Cintran spur with the rowel still sharp. Or are you here for the big one, like everyone?"
    direction: "Up to her knees in a spoil heap, a lantern on a pole."
    next: hub
  hub:
    type: choice
    options:
      - id: shop
        text: "Show me your wares."
        effects: ["open_shop(npc.gammer_rusk)"]
        next: hub
      - id: big_one
        text: "The big one?"
        next: big_one
      - id: moon
        text: "They say the dead walk here."
        next: moon
      - id: rite
        text: "[Bribe 40] You know the clan customs. How do the Strept lay their dead down?"
        tag: bribe
        condition: "not flag(flag.torc_rite_known)"
        bribe: 40
        next: rite
      - id: sell
        text: "[Item: Marnadal torc] You wanted the champion's torc. Make me an offer."
        tag: item
        condition: "has_item(item.marnadal_torc)"
        next: sell
      - id: threaten
        text: "Get off this field. You're robbing graves."
        next: threaten
      - id: leave
        text: "Good digging."
        next: bye
  big_one:
    type: line
    speaker: npc.gammer_rusk
    text: "Champion's torc. Bronze and iron, thick as your wrist, in the clan ditch. Four times I've dug for it. Four times something held my ankles under the mud. I'd pay two hundred for it, duck. Two hundred."
    next: hub
  moon:
    type: line
    speaker: npc.gammer_rusk
    text: "Every dark of the moon. Make camp by the old stones on the east hill and wait, if you're tired of breathing. They charge, they die, they get up. Fire and hammers keep them down. Or the names."
    next: hub
  rite:
    type: line
    speaker: npc.gammer_rusk
    text: "Stand at their stones. Say each clan's name and its dead's names, as many as you've got, and set a stone on the wall for each. Then say 'Home from the mud. Home from the iron. The hill holds you now.' They like that. Who doesn't?"
    effects: ["set_flag(flag.torc_rite_known)"]
    next: hub
  sell:
    type: choice
    options:
      - id: sell_yes
        text: "(Sell the torc for 200 crowns. Callum's oath goes unkept.)"
        next: sold
      - id: sell_no
        text: "On second thought, it's spoken for."
        next: hub
  sold:
    type: line
    speaker: npc.gammer_rusk
    text: "Two hundred! Saints' teeth, I'm a lady. Don't you look back at that ditch, duck. Don't you look back."
    effects: ["take_item(item.marnadal_torc, 1)", "add_crowns(200)", "set_flag(flag.torc_sold)", "add_rep(faction.strept, -20)"]
    next: bye
  threaten:
    type: choice
    options:
      - id: scare
        text: "[Intimidate 4] Pack the cart and go."
        tag: intimidate
        check: {skill: intimidate, dc: 4, pass: leaves, fail: fight}
      - id: back
        text: "Forget it."
        next: hub
  leaves:
    type: line
    speaker: npc.gammer_rusk
    text: "All right, all right! Lads, the cart. The living are worse than the dead tonight."
    effects: ["set_flag(flag.rusk_hostile)", "add_rep(faction.strept, 5)"]
    next: bye
  fight:
    type: effect
    effects: ["set_flag(flag.rusk_hostile)", "start_encounter(enc.field_bone_pickers)"]
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.marnadal_charge
zone: zone.marnadal_field
enemies:
  - {enemy: enemy.revenant_rider, count: 2, spawn: lanes_north, variant: null}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.revenant_footman, count: 4, spawn: lines_stakes, variant: null}]}
  - {after: wave_cleared, enemies: [{enemy: enemy.revenant_rider, count: 1, spawn: lanes_north, variant: null}, {enemy: enemy.revenant_footman, count: 2, spawn: lines_stakes, variant: null}]}
attack_tokens: null
allow_yield: false
allies: [npc.callum_darrach]
checkpoint: vigil_camp
avoidable_by: ["dlg.odo_vane"]
on_won: ["set_flag(flag.held_the_line)", "add_rep(faction.strept, 10)"]
on_yielded: []
on_player_fled: []
```
Design: "holding the line" means fighting at the dyke. The riders charge down the lanes in sequence (each lane flares 2 s before; dodge sideways, gdd §6.7). Riders who reach the dyke wheel and come again. Wave 2 is Cintran revenant foot climbing over the bone banks. Revenants rise again after 6 s unless the last hit was blunt or fire, or `flag.torc_rite_known` is set (the rite learnt from Rusk or the stones makes this fight much easier). Callum fights at the dyke as a scripted ally and cannot fall. Fire oil from Rusk or the Cintran cairn is the tool the field hands the player. After the win, talk to Callum again: the honoured branch grants the torc.

```yaml encounter
id: enc.marnadal_footmen
zone: zone.marnadal_field
enemies:
  - {enemy: enemy.revenant_footman, count: 4, spawn: lines_stakes, variant: null}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.revenant_footman, count: 2, spawn: lines_stakes, variant: null}]}
attack_tokens: null
allow_yield: false
allies: [npc.callum_darrach]
checkpoint: vigil_camp
avoidable_by: []
on_won: ["set_flag(flag.held_the_line)", "add_rep(faction.strept, 10)"]
on_yielded: []
on_player_fled: []
```
Design: the charge after Ser Odo has stood his riders down. Only the foot comes.

```yaml encounter
id: enc.field_bone_pickers
zone: zone.marnadal_field
enemies:
  - {enemy: enemy.bandit, count: 3, spawn: pickers, variant: spear}
  - {enemy: enemy.bandit, count: 1, spawn: pickers, variant: sword}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: field_arrival
avoidable_by: ["dlg.gammer_rusk"]
on_won: ["add_crowns(60)"]
on_yielded: ["add_crowns(30)"]
on_player_fled: []
```

```yaml encounter
id: enc.field_choir_column
zone: zone.marnadal_field
enemies:
  - {enemy: enemy.choir_zealot, count: 2, spawn: river_reach, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: river_reach, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: field_arrival
avoidable_by: []
on_won: ["add_clue(clue.choir_at_vel_aram)"]
on_yielded: ["add_clue(clue.choir_at_vel_aram)"]
on_player_fled: []
```
Design: stage 3 only. A Choir column on the ford road heading for Vel Aram, escorting a covered cart. The player can let it pass (stay out of the ford road on arrival; the trigger fires on entering it), but the default spawn is on the ford road, so arrival by the crossing meets it.

## 7. Items and clues

```yaml item
id: item.marnadal_torc
name: "Bronze-and-iron torc"
category: key
description: "Darrach Hall's torc: a champion's neck-ring, twisted bronze and black iron, thick as a wrist, cold as river water. Callum Darrach wore it into the mud. It belongs at Darrach's cairn in Dun Strept."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.marnadal_roll
name: "Muster roll of the Cintran horse, 1263"
category: document
description: "A waxed roll from a dead captain's satchel under the cairn, the ink mostly sound."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Heavy horse, Marnadal, by order of the Lord Marshal. Captains: Vane, Orrin, Dask. Chaplain to the host: Fr. Anselm of St. Corwen. Note in another hand: Parley with the clans at dusk, Fr. Anselm and one brother. Answer: no surrender. The halls at dawn. By order. B.K."
```

`clue.marnadal_chaplain` is declared by act1 (`02-audience-at-court.md`, Kosk's account). Ser Odo's shade and the Anselm's-cell stole in a2.07 are further sources of the same clue; Odo's lines add the parley detail.


```yaml clue
id: clue.grey_priest_parley
theory: theory.choir
title: "The grey priest under the white branch"
text: "The night before Marnadal, a grey priest came to the clan fires under a white branch and swore the halls would burn whether the clans knelt or fought. The clans fought. Someone wanted that war."
supports: [anselm]
refutes: []
```

```yaml deduction
id: ded.choir_provoked_marnadal
theory: theory.anselm_plan
condition: "has_clue(clue.marnadal_chaplain) and has_clue(clue.grey_priest_parley)"
title: "The parley that started a massacre"
text: "Anselm and 'one brother' carried the last parley. The clans heard there was no mercy to be had; the Marshal heard there was no surrender to accept. The Choir needed Marnadal to happen. Anselm has been at this for five years."
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.a2_torc_taken, type: milestone, desc: "The player lifted Callum's torc from the clan ditch."}
  - {id: flag.torc_rite_known, type: bool, desc: "The player knows the Strept naming rite. Revenants stop rising again (gdd §6.7). Read by act3 Dun Strept."}
  - {id: flag.new_moon_vigil, type: bool, desc: "The player chose to keep vigil; the field is in its new-moon variant. Cleared on leaving."}
  - {id: flag.field_rite_performed, type: bool, desc: "The player spoke the naming rite at the clan stones during the vigil."}
  - {id: flag.held_the_line, type: bool, desc: "The player fought the charge beside Callum."}
  - {id: flag.champion_grants_torc, type: bool, desc: "Callum has given leave to take his torc."}
  - {id: flag.odo_met, type: bool, desc: "Ser Odo's shade has spoken to the player."}
  - {id: flag.odo_stood_down, type: bool, desc: "Ser Odo stood his ghost riders down; only the foot charges."}
  - {id: flag.rusk_hostile, type: bool, desc: "Gammer Rusk was driven off or fought."}
  - {id: flag.torc_sold, type: bool, desc: "The player sold the torc to Rusk. Act III must use Kosk's apology for Hesk. Read by act3 Dun Strept."}
reads:
  - flag.kosk_badge_worn
  - flag.yorek_freed
  - item.kosk_writ
  - perk.kingmaker
  - ms.a2_vel_aram_cleared
```

## 9. Quest hooks
Contributes the optional objective `lead_field` of `quest.main_a2/the_marnadal_road` (declared in `a2.01`). The torc is the Act III key to Hesk (`act3/02-dun-strept.md`), so a player who reaches Act III without it can still come back here (the section allows stage 4).

## 10. Rumors and event cards (optional)
Rumor 8 (`rumor.r08_new_moon_dead`, owned by the side slice) is verified when the player first chooses the vigil.

## 11. Failure states and branches

```yaml branches
paths:
  - id: hold_the_line
    when: "Player keeps vigil, enters the lanes, and wins enc.marnadal_charge (or enc.marnadal_footmen after Odo stands down)."
    outcome: "Callum grants the torc and teaches the rite; Strept +15."
    sets: ["set_flag(flag.held_the_line)", "set_flag(flag.champion_grants_torc)", "reach_milestone(ms.a2_torc_taken)"]
  - id: naming_rite
    when: "Player learns the rite (Lore 6 at the stones, Rusk for 40, Yorek at Vel Aram) and speaks it during the vigil."
    outcome: "The dead kneel; no charge; Callum grants the torc; Strept +15."
    sets: ["set_flag(flag.field_rite_performed)", "reach_milestone(ms.a2_torc_taken)"]
  - id: clan_friend
    when: "Strept is already Friendly, or the player has Sway."
    outcome: "Callum grants the torc without a test."
    sets: ["reach_milestone(ms.a2_torc_taken)"]
  - id: odo_stands_down
    when: "Persuade 6 or the Marshal's writ with Ser Odo."
    outcome: "No ghost riders in the charge; clue.marnadal_chaplain either way."
    sets: ["set_flag(flag.odo_stood_down)"]
  - id: torc_sold
    when: "Player sells the torc to Rusk."
    outcome: "200 crowns, Strept -20, flag.torc_sold. ms.a2_torc_taken stays set. Hesk needs Kosk's apology in Act III."
    sets: ["set_flag(flag.torc_sold)"]
failures:
  - id: player_dies_charge
    result: reload_checkpoint
    recover: "Reload vigil_camp. The vigil flag is saved with the checkpoint."
  - id: kosk_badge
    result: soft_fail
    recover: "Callum refuses while the badge is worn. Unequip it and walk back to the dyke (the trigger repeats)."
guarantees:
  - "ms.a2_torc_taken is reachable with no check: keep vigil (no gate), win the charge with Callum's help, talk to him, lift the torc."
```

## 12. Open questions
- **Kosk's badge:** gdd §6.9 says the badge gives **−20** to Strept dialogue checks; gdd §6.10 says **−2** to Intimidate against Strept. This file only reads `flag.kosk_badge_worn` (expected to be maintained by the inventory when `item.kosk_writ` is equipped as a badge) to make Callum refuse. The penalty size needs one answer.
- **Champion and rite text** are aligned with act3/02 (Darrach Hall's torc; the cairn-words "Home from the mud. Home from the iron. The hill holds you now.").
- `ded.choir_provoked_marnadal` is new and supports Act III's Kosk apology scene (Kosk can be told that the parley was poisoned). Act III may want to read it.
- The new-moon state is a flag cleared by the map marker. If the player saves and loads mid-vigil, the flag persists, which is intended.
