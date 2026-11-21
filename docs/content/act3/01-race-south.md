---
section_id: a3.01
title: "The Race South"
act: 3
story_ref: "story.md §6 Act II Twist (aftermath), §7.1 The Race South; gdd §6.1 stage 4, §6.2 twist resolution, §6.3 mountain edges, §7.3 row 1"
zones: [zone.palace_war_room]
available_when: "ms(ms.act2_twist)"
escalation_stage_required: {min: 4, max: 4}
milestones_set: [ms.a3_departed]
milestones_read: [ms.act2_twist]
level_band: [9, 9]
---

# The Race South

## 1. Scene summary
The catacombs are empty and the Abbey's river gate stands open. Aldric and Anselm are gone. The player comes back up into the palace, where Lord Marshal Kosk has turned his map room into a war council. What happens there depends on how the antidote line ended. If the Queen lives and can speak, she is carried in on a litter and hands over the Lion's Crown herself. If she lies in a coma, Kosk hands it over under an emergency writ. If she is dead, Kosk hands over a dead woman's crown for a twelve-year-old king. The crown is the one thing the lock needs that Anselm does not have. Kosk's outrider reports that the Choir took the Marnadal Stairs and left a rear-guard on the switchbacks. Kosk lays out three roads: straight up the Stairs (fast, but the rear-guard waits and the snow takes its toll), east through Dun Strept (guides and spears, if Hesk can be won), or down the Ravensford road to Assengard for Dravin and his Iron-Key. Kosk can also be pushed into writing his apology to the Strept clans, and he says what it would take to bring his cavalry into the mountain. The dramatic question is whether the player can leave the palace with more than a crown and a grudge. The section ends when the player opens Kosk's campaign map and takes the road south (`ms.a3_departed`).

## 2. Progress and escalation
- Escalation is at stage 4 (Solstice) for all of Act III. The Cintra hub is closed. Only the palace, and inside it this war room, can be visited (gdd §6.1 stage 4). Only the mountain encounter tables are in use.
- `ms.a3_departed` is set the first time the player uses the campaign map (`kosk_map`). The interactable needs only `item.lion_crown`, which the war council hands over in its opening nodes with no check.
- The war room can be revisited for the whole of Act III, through the palace. This matters because the apology can still be won later, with `ded.marnadal_truth` from the Grey Ferry, and because Kosk's cavalry answer changes once the Watch is lit.
- Route consequences live in other sections. They are not costs paid here:
  - **Direct ascent:** without `flag.strept_guides`, the rear-guard ambush on switchback seven is forced (a3.04). Mountain edges without guides or Dravin trigger the gdd §6.3 "Snow-choked pass" hazard (Grit 6).
  - **Through Dun Strept:** Hesk's guides open the Shepherd's Ledge around the barricade. An Allied war-band fights in the Stairs and removes two finale bodyguards.
  - **Assengard:** Dravin joins with the Iron-Key. Without the key (or the Silver Mine breach) there is no way into Karak Ostrel (gdd §7.3).

## 3. Location layout
The war room is Kosk's map room on the palace's second floor, entered by a single door from the palace hall. It is a long, low, oak-panelled room. A great table runs along its middle, covered by the 1262 realm survey with tin pins stuck into it. The south wall is a bay of tall windows looking toward the Amell, which is invisible tonight behind rain. There is a hearth on the east wall, with the Queen's litter in an alcove beside it when she is present. Kosk's field gear and a supply crate lie against the west wall. In the north-west corner Varn has claimed a writing desk he was not offered. The room is small on purpose: a dialogue space, not a combat space. The player enters at the door. The Marshal stands at the far end of the table and the conversation starts at once. When it ends, the player walks the table to the map and leaves through it.

```yaml zone
id: zone.palace_war_room
name: "The Marshal's Map Room"
kind: interior
map_node: map.cintra
time_of_day: night
cold_rate: 0
disguise_tag: null
music: war_council
areas:
  - {id: door_hall, description: "Single oak door from the palace hall; two of Kosk's own guards outside, none of Varn's."}
  - {id: map_table, description: "Ten-metre table under the 1262 survey; tin pins mark Choir sightings from Tigg to the Stairs. Candles in iron dishes."}
  - {id: litter_alcove, description: "Alcove by the east hearth; the Queen's litter, two maids, a brazier of sage."}
  - {id: window_bay, description: "Tall south windows streaming with rain; the outrider waits here, still in wet mail."}
  - {id: supply_wall, description: "West wall: Kosk's campaign chest, a crate of mountain supplies, a rack of spare crossbows."}
  - {id: varn_corner, description: "North-west corner: a writing desk Varn has taken over, ink and sealing wax and three unsent letters."}
spawns:
  - {id: war_room_door, area: door_hall, default: true}
  - {id: map_end, area: map_table}
exits:
  - id: to_palace_hall
    area: door_hall
    to_zone: zone.palace_hall
    to_spawn: war_room
    condition: "true"
    effects: []
  - {id: kosk_map, area: map_table, to_map: true, label: "Take the road south", condition: "has_item(item.lion_crown)", effects: ["unlock_map_node(map.stairs_foot)", "unlock_map_node(map.dun_strept)", "unlock_map_node(map.assengard)", "add_map_pin(map.marnadal_watch)", "reach_milestone(ms.a3_departed)"]}
interactables:
  - id: supply_crate
    area: supply_wall
    kind: container
    label: "Open the supply crate"
    condition: "true"
    check: null
    once: true
    effects: []
    fail_effects: []
  - id: scout_report
    area: window_bay
    kind: pickup
    label: "Take the outrider's report"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.lenka_scout_report, 1)", "add_map_pin(map.stairs_foot)"]
    fail_effects: []
  - id: aldric_gloves
    area: map_table
    kind: search
    label: "Look at the gloves on the map"
    condition: "true"
    check: null
    once: true
    effects: ["play_beat(gloves_on_map)"]
    fail_effects: []
  - id: varn_letters
    area: varn_corner
    kind: search
    label: "Read Varn's unsent letters"
    condition: "not flag(flag.varn_exposed)"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["give_item(item.varn_unsent_letters, 1)"]
    fail_effects: ["play_beat(varn_catches_you)"]
triggers:
  - id: council_opens
    area: door_hall
    "on": enter
    source: null
    condition: "not flag(flag.a3_war_council_held)"
    once: true
    effects: ["set_flag(flag.a3_war_council_held)", "set_checkpoint(war_council)", "start_dialogue(dlg.a3_war_council)"]
hazards: []
checkpoints:
  - {id: war_council, area: door_hall}
beats:
  - {id: queen_carried_in, description: "Two maids and a guard carry the Queen's litter from the alcove to the table's end. She waves the guard off and grips the table edge."}
  - {id: crown_case_opened, description: "A plain walnut case. Inside on black velvet, the Lion's Crown: a dull gold circlet, a lion's mask at the brow, worn smooth by four hundred years of foreheads. It is handed to the player."}
  - {id: kosk_draws_route, description: "Kosk drags a tin pin from Cintra down the Marnadal road, then traces three lines with a thick finger: up the Stairs, east to Dun Strept, south to Assengard."}
  - {id: gloves_on_map, description: "A pair of small riding gloves lies on the survey where Aldric left them at the last council. Kosk sees the player looking and turns away."}
  - {id: varn_catches_you, description: "Varn clears his throat behind the player. 'Private correspondence, I believe.' He gathers the letters into his sleeve."}
  - {id: kosk_signs_apology, description: "Kosk writes standing up, without sitting, and blots the page with his sleeve. He seals it with his own ring, not the Crown's."}
npcs:
  - {npc: npc.kosk, area: map_table, condition: "true"}
  - {npc: npc.ysolde, area: litter_alcove, condition: "flag(flag.queen_alive) and queen() <= 2"}
  - {npc: npc.varn, area: varn_corner, condition: "not flag(flag.varn_exposed)", dialogue: dlg.a3_varn_war_room}
  - {npc: npc.outrider_lenka, area: window_bay, condition: "true"}
  - {npc: npc.maelis, area: window_bay, condition: "flag(flag.maelis_recruited) and not flag(flag.maelis_dead)", dialogue: dlg.a3_maelis_war_room}
  - {npc: npc.dravin, area: supply_wall, condition: "flag(flag.dravin_recruited)"}
encounters: []
loot:
  - {container: supply_crate, items: [{item: item.frost_tallow, count: 2}, {item: item.field_draught, count: 3}, {item: item.fire_oil, count: 2}, {item: item.crossbow_bolt, count: 12}], condition: "true"}
variants:
  - id: after_departure
    when: "ms(ms.a3_departed)"
    description: "The table is cleared down to the Amell sheet. Kosk works alone through the night; the litter is gone back to the sickroom."
    npcs_absent: [npc.ysolde, npc.outrider_lenka]
    encounters_disabled: []
    interactables_disabled: [aldric_gloves]
```

## 4. NPCs present
`npc.kosk`, `npc.ysolde`, `npc.varn` and `npc.maelis` are declared in Act I (A04). `npc.dravin` is declared in a3.03. New here:

```yaml npc
id: npc.outrider_lenka
name: "Lenka"
faction: faction.crown
role: "Kosk's outrider; tracked the Choir from the Abbey river gate to the Marnadal Watch"
motive: "Get back on a horse and back on the trail; she blames herself for losing them at the Watch."
secret: "She saw the boy look back at her from the wagon and did not shoot the driver, because the Abbot was holding Aldric in front of him."
disposition: friendly
essential: true
dialogue: dlg.lenka_report
barks: ["They're not hiding their tracks. They don't think anyone can follow.", "My lord gave me three horses. I killed two of them.", "If you see a grey cloak on that mountain, it's the boy. Don't shoot the grey cloak."]
combat: null
shop: null
```

**Voice notes.** *Kosk:* short sentences, a parade-ground voice that cracks under exhaustion. He doesn't swear in front of the Queen and swears constantly otherwise. He has not slept. *Ysolde:* precise and dry, rationing breath. She speaks as if dictating, and never says "please." *Varn:* florid, wounded and self-serving, but here, for once, genuinely afraid. *Lenka:* clipped field-report style, a Marnadal valley accent.

## 5. Dialogue trees

```yaml dialogue
id: dlg.a3_war_council
participants: [npc.kosk, npc.ysolde, npc.outrider_lenka, npc.varn]
start: open
nodes:
  open:
    type: branch
    cases:
      - {if: "flag(flag.queen_alive) and queen() <= 2", next: queen_open}
      - {if: "flag(flag.queen_alive)", next: writ_open}
    else: king_open
  queen_open:
    type: line
    speaker: npc.ysolde
    text: "Come closer, {player}. I can't raise my voice, and I won't have the Marshal repeat my words badly."
    direction: "Propped on the litter at the table's end, wrapped in velvet to the chin. Her hand trembles on a walnut case."
    effects: ["play_beat(queen_carried_in)"]
    next: queen_confess
  queen_confess:
    type: line
    speaker: npc.ysolde
    text: "I told Anselm everything. The vaults, the verses, the lock. Twenty years of confession. I handed him the knife and thanked him for his prayers."
    next: queen_crown
  queen_crown:
    type: line
    speaker: npc.ysolde
    text: "This is the Lion's Crown. The lock knows it. It will not know my son without it. Put it on his head in that chamber, and let him speak."
    effects: ["give_item(item.lion_crown, 1)", "play_beat(crown_case_opened)"]
    next: queen_invest
  queen_invest:
    type: line
    speaker: npc.ysolde
    text: "He is Co-Sovereign. I signed it this morning with a hand that wouldn't hold the pen. Tell him I watched the seal set. Tell him I wasn't frightened."
    next: brief
  writ_open:
    type: line
    speaker: npc.kosk
    text: "She hasn't woken. The witch's dose keeps her breathing, and that's all. So I wrote the writ myself and pressed her hand to the wax."
    direction: "He sets a walnut case on the map between you."
    next: writ_crown
  writ_crown:
    type: line
    speaker: npc.kosk
    text: "By emergency writ, Aldric is Co-Sovereign. The lawyers can argue about it in spring. The lock won't argue with this."
    effects: ["give_item(item.lion_crown, 1)", "play_beat(crown_case_opened)"]
    next: brief
  king_open:
    type: line
    speaker: npc.kosk
    text: "The Queen died at the second bell. You'll hear it was the fever. It wasn't."
    direction: "He hasn't changed out of the clothes he wore at her bedside."
    next: king_crown
  king_crown:
    type: line
    speaker: npc.kosk
    text: "That makes the boy king. He's twelve, he's on a mountain with a knife at his neck, and this is his crown."
    effects: ["give_item(item.lion_crown, 1)", "play_beat(crown_case_opened)"]
    next: brief
  brief:
    type: line
    speaker: npc.kosk
    text: "The lock knows the crown, not the face under it. Anselm has the boy's blood. You carry the rest. Lose it and we lose everything."
    next: lenka_report
  lenka_report:
    type: line
    speaker: npc.outrider_lenka
    text: "They rode for the Stairs, my lord. Twenty riders, a closed wagon, the boy in a grey cloak. They've left a rear-guard digging in on the switchbacks."
    next: hub
  hub:
    type: choice
    options:
      - id: routes
        text: "Show me the roads south."
        next: routes_stairs
      - id: dravin
        text: "The letter came from a smith in Assengard. Dravin Ostrel."
        condition: "not flag(flag.dravin_recruited)"
        next: dravin_info
      - id: dravin_here
        text: "Dravin rides with me. He has the Key."
        condition: "flag(flag.dravin_recruited)"
        next: dravin_here
      - id: apology
        text: "Hesk Ironjaw won't lift a spear for your badge. He might for an apology."
        condition: "not has_item(item.kosk_apology) and not flag(flag.hesk_apology_given)"
        next: apology_open
      - id: cavalry
        text: "If it goes bad inside that mountain, can you ride to us?"
        next: cavalry_branch
      - id: regency
        text: "Who holds Cintra while you wait?"
        condition: "not flag(flag.varn_exposed) and not flag(flag.a3_regency_spoken)"
        next: regency_open
      - id: supplies
        text: "What can you spare?"
        once: true
        next: supplies
      - id: queen_why
        text: "Majesty. Did he ever tell you why?"
        condition: "flag(flag.queen_alive) and queen() <= 2"
        once: true
        next: queen_why
      - id: leave
        text: "I'll ride."
        next: farewell
  routes_stairs:
    type: line
    speaker: npc.kosk
    text: "Three roads. The Stairs, straight up from Marnadal Watch. Fastest. Their rear-guard will be waiting with crossbows, and the snow will be waiting for everyone."
    effects: ["play_beat(kosk_draws_route)", "unlock_map_node(map.stairs_foot)", "add_map_pin(map.marnadal_watch)"]
    next: routes_strept
  routes_strept:
    type: line
    speaker: npc.kosk
    text: "Or east through Dun Strept. Hesk's people know the goat paths round those switchbacks. They also know my face, and they hate it."
    effects: ["unlock_map_node(map.dun_strept)"]
    next: routes_assengard
  routes_assengard:
    type: line
    speaker: npc.kosk
    text: "And Dravin's letter came from Assengard, down the Ravensford road. If anyone has a key to that mountain, he does. Without one you'll be knocking on stone."
    effects: ["unlock_map_node(map.assengard)"]
    next: routes_choice
  routes_choice:
    type: choice
    options:
      - id: direct
        text: "Straight up the Stairs. Every hour we argue, he climbs."
        effects: ["set_flag(flag.a3_route_direct)"]
        next: routes_direct
      - id: strept
        text: "Through Dun Strept. I want guides who know the ice."
        next: routes_via_strept
      - id: assengard
        text: "Dravin first. No key, no door."
        condition: "not flag(flag.dravin_recruited)"
        next: routes_via_assengard
      - id: think
        text: "Let me think on it."
        next: hub
  routes_direct:
    type: line
    speaker: npc.kosk
    text: "Then take fast horses and no banners. Lenka says the barricade's on the seventh turn. Go through them or don't go."
    next: hub
  routes_via_strept:
    type: line
    speaker: npc.kosk
    text: "Then keep my writ in your saddlebag, not on your coat. If Hesk sees my lion on you, you'll leave Dun Strept in a sack."
    next: hub
  routes_via_assengard:
    type: line
    speaker: npc.kosk
    text: "Then ride hard. He wrote that letter to the Crown. Show him what the Crown has come to."
    next: hub
  dravin_info:
    type: line
    speaker: npc.kosk
    text: "Never met him. The household rolls pay a dwarf of the 'warden line' at Assengard a stipend every year. Has done since Corvan. Nobody remembered why."
    effects: ["add_map_pin(map.assengard)"]
    next: hub
  dravin_here:
    type: line
    speaker: npc.dravin
    text: "Aye, I have it. And I know a door your Abbot doesn't. Under the Old Grey Matron. My grandfather called it the Weeping Gate."
    next: hub
  apology_open:
    type: line
    speaker: npc.kosk
    text: "An apology. For Marnadal."
    direction: "His jaw works. He looks at the map, not at you."
    next: apology_choice
  apology_choice:
    type: choice
    options:
      - id: truth
        text: "[Clue: Marnadal was a lie] A dead runner at the Grey Ferry told me what the chaplain told you about Dun Edra. There were no hanged prisoners. Write that down."
        tag: clue
        condition: "ded(ded.marnadal_truth)"
        next: apology_truth
      - id: persuade
        text: "Your badge kept that war going for five years. Your hand can end it. [Persuade 7]"
        tag: persuade
        condition: "rep_tier(faction.crown) >= friendly"
        show_locked: true
        once: true
        check: {skill: persuade, dc: 7, pass: apology_yes, fail: apology_no}
      - id: sway
        text: "A king will need the clans. Sign it for him, not for yourself. [Sway]"
        tag: sway
        condition: "perk(perk.kingmaker)"
        next: apology_yes
      - id: drop
        text: "Forget it."
        next: hub
  apology_truth:
    type: line
    speaker: npc.kosk
    text: "Dun Edra. Twenty of ours hanged, he said, and he wept saying it. I never sent anyone to count the bodies. I gave the order before he'd finished crying."
    next: apology_yes
  apology_yes:
    type: line
    speaker: npc.kosk
    text: "Bring the ink. I'll write it plain: my name, my order, my shame. And two hundred crowns of blood-price from my own purse, not the Crown's."
    effects: ["play_beat(kosk_signs_apology)", "give_item(item.kosk_apology, 1)"]
    next: apology_after
  apology_after:
    type: line
    speaker: npc.kosk
    text: "Give it to him yourself. If I ride up there with it, they'll hang me from their gate, and they'd be right to."
    next: hub
  apology_no:
    type: line
    speaker: npc.kosk
    text: "No. I won't kneel to a hill chief while the boy's life hangs on it. Find another way, or bring me a better reason."
    next: hub
  cavalry_branch:
    type: branch
    cases:
      - {if: "flag(flag.watch_signal_lit) and rep_tier(faction.crown) >= friendly", next: cavalry_yes}
      - {if: "flag(flag.watch_signal_lit)", next: cavalry_cold}
    else: cavalry_no
  cavalry_yes:
    type: line
    speaker: npc.kosk
    text: "The Watch fires are lit. I saw them from the walls. Two hundred horse are saddled. Find me a road inside that mountain wide enough to charge, and I'll be on it."
    next: hub
  cavalry_cold:
    type: line
    speaker: npc.kosk
    text: "I saw the fires. But I don't ride my last two hundred horse on the say-so of someone I'm not sure of. You know what you've done in this court. So do I."
    next: hub
  cavalry_no:
    type: line
    speaker: npc.kosk
    text: "From here? I'd need a signal I can see from the walls. The old beacon at Marnadal Watch could do it, if anyone still holds that tower."
    effects: ["add_map_pin(map.marnadal_watch)"]
    next: hub
  regency_open:
    type: line
    speaker: npc.varn
    text: "Someone must sign the bread warrants while the Marshal plays soldier. I have offered. Repeatedly. With diagrams."
    direction: "Rising from his stolen desk, a sheaf of papers already in hand."
    effects: ["set_flag(flag.a3_regency_spoken)"]
    next: regency_choice
  regency_choice:
    type: choice
    options:
      - id: back_varn
        text: "Let Varn keep the ledgers. He knows where every crown in this city is buried."
        effects: ["add_rep(faction.varn, 10)", "set_flag(flag.a3_backed_varn)"]
        next: regency_varn
      - id: warn
        text: "[Clue: Varn's ledgers] Marshal, keep the treasury keys on your own belt. He burns paper at night for a reason."
        tag: clue
        condition: "has_clue(clue.varn_ledgers)"
        effects: ["add_rep(faction.varn, -15)", "set_flag(flag.a3_warned_kosk_of_varn)"]
        next: regency_warn
      - id: council
        text: "Neither of you alone. Sit at the same table, or the city burns while you glare at each other."
        effects: ["set_flag(flag.a3_regency_council)"]
        next: regency_council
      - id: out
        text: "Not my business."
        next: hub
  regency_varn:
    type: line
    speaker: npc.varn
    text: "At last, a voice of sense. I shan't forget it, {player}. I write everything down. Well. Nearly everything."
    next: hub
  regency_warn:
    type: line
    speaker: npc.kosk
    text: "I know about the tolls, Chancellor. I've known for a year. I needed you frightened, not hanged. Sit down."
    next: hub
  regency_council:
    type: line
    speaker: npc.kosk
    text: "Same table. Fine. He sits at that end. If he talks, I'll leave."
    next: hub
  supplies:
    type: line
    speaker: npc.kosk
    text: "Frost-tallow, draughts, bolts. The crate by the wall is yours. Buy furs from the Strept if they'll sell to you. Ours are made for parades."
    next: hub
  queen_why:
    type: line
    speaker: npc.ysolde
    text: "He buried boys at Marnadal and watched lords bill my treasury for the graves. He told me so on his knees. I gave him absolution. I gave it every week."
    next: hub
  farewell:
    type: line
    speaker: npc.kosk
    text: "Bring him back. Crowned and whole. I've no one else to give the kingdom to, and I'm too old to want it."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.lenka_report
participants: [npc.outrider_lenka]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.outrider_lenka
    text: "Ask quick. My lord wants me back on the road before the horses stiffen."
    next: hub
  hub:
    type: choice
    options:
      - id: boy
        text: "How was the prince?"
        next: boy
      - id: numbers
        text: "How many are they?"
        next: numbers
      - id: rearguard
        text: "Tell me about the rear-guard."
        next: rearguard
      - id: done
        text: "Go. Ride safe."
        next: bye
  boy:
    type: line
    speaker: npc.outrider_lenka
    text: "Alive. Gagged at the Abbey gate, not by the Watch. He looked straight at me from the wagon. I had a shot. The Abbot held him in front like a shield."
    next: hub
  numbers:
    type: line
    speaker: npc.outrider_lenka
    text: "Twenty riders, maybe a dozen on foot ahead of them with mules. Grey robes, feathers. Some fight like soldiers. Some fight like they want to die."
    next: hub
  rearguard:
    type: line
    speaker: npc.outrider_lenka
    text: "Seventh switchback above the Goat Gate. Carts, stakes, a fire. One shooter up on the spur with a long bow-stock. Shepherds say there's a ledge path round it. Only shepherds."
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.a3_maelis_war_room
participants: [npc.maelis]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.maelis
    text: "I read his sermons back to myself on the way up the stairs. They're all about doors. I thought they were about heaven."
    next: hub
  hub:
    type: choice
    options:
      - id: come
        text: "The mountain will be worse than the Abbey. You don't have to come."
        next: come
      - id: runes
        text: "Can you read dwarven runes?"
        next: runes
      - id: done
        text: "We leave soon."
        next: bye
  come:
    type: line
    speaker: npc.maelis
    text: "I found the cut pages. I was the one who didn't scream. I'm coming."
    next: hub
  runes:
    type: line
    speaker: npc.maelis
    text: "The old forms, slowly. The Abbey kept a dwarven primer to read Corvan's charters. Nobody else checked it out in forty years. I did, twice."
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.a3_varn_war_room
participants: [npc.varn]
start: greet
nodes:
  greet:
    type: line
    speaker: npc.varn
    text: "You'll forgive me if I don't wish you luck. Luck is what we had before the Abbot. I'd rather you had competence."
    next: hub
  hub:
    type: choice
    options:
      - id: afraid
        text: "You look frightened, Chancellor."
        next: afraid
      - id: done
        text: "Goodbye, Chancellor."
        next: bye
  afraid:
    type: line
    speaker: npc.varn
    text: "I am a thief, {player}. Thieves need a kingdom to steal from. Whatever the Abbot wants, it isn't a kingdom."
    next: hub
  bye:
    type: end
```

## 6. Encounters
None. The war room is a dialogue scene. The road south uses the mountain travel table (A07's `13-travel-events.md`).

## 7. Items and clues

```yaml item
id: item.lion_crown
name: "The Lion's Crown"
category: key
description: "A dull gold circlet with a lion's mask at the brow, worn smooth by four centuries of foreheads. The lock under Karak Ostrel knows it. Aldric must wear it to speak the True Oath."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.kosk_apology
name: "Kosk's written apology and blood-price"
category: key
description: "One page in the Marshal's square hand, sealed with his own ring, and a purse of two hundred crowns. For Hesk Ironjaw of Dun Strept."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "To Hesk Ironjaw and the halls of Strept. In the summer of 1263 I, Bertran Kosk, Lord Marshal of Cintra, ordered the burning of three clan halls with the old and the young inside them. I was told our prisoners had been hanged at Dun Edra. I did not send anyone to count them. That is my crime and not my soldiers'. I send with this the blood-price my own purse can bear, which is too little, and my name, which is worth less. I ask nothing in return. Your people may ask what they like of me. Kosk."
```

```yaml item
id: item.lenka_scout_report
name: "Outrider's report"
category: document
description: "Lenka's field notes, rain-blotted: the Choir's route from the Abbey river gate to the Marnadal Stairs."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "River gate open, no guards. Hoofprints south, 20 horse, 1 wagon (closed, iron-shod). Marnadal Watch: passed by night, the tower dark. Stairs foot: mules and men on foot already climbing. Barricade at the 7th turn above the Goat Gate, fire, 6 or 7 men, one shooter on the spur. Boy seen in grey cloak in the wagon. Alive. Strept shepherds at the foot say a ledge path runs round the 7th turn, 'for goats and the clans'. Did not engage. - L."
```

```yaml item
id: item.varn_unsent_letters
name: "Varn's unsent letters"
category: document
description: "Three letters in Varn's florid hand, unsigned and unsealed."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "1. To the Duke of Attre: 'Should the worst befall the Prince, Cintra will require a friend on the coast, and the coast will require a friend in the Chancellery...' 2. To the envoy of Brugge: 'The Marshal is a soldier and will not survive a winter of politics...' 3. To no one, crossed out many times: 'If the boy comes home I will give it all back. I will. I will give it all back.'"
```

No new clues are found here. The section reads `clue.varn_ledgers` (A04) and `ded.marnadal_truth` (A07).

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.a3_departed, type: milestone, desc: "The player left the war room by Kosk's campaign map with the Lion's Crown. Act III's road is open."}
  - {id: flag.a3_war_council_held, type: bool, desc: "The war council dialogue has auto-started once."}
  - {id: flag.a3_route_direct, type: bool, desc: "The player told Kosk they would go straight up the Stairs (barks only)."}
  - {id: flag.a3_regency_spoken, type: bool, desc: "The regency question was raised with Varn present."}
  - {id: flag.a3_backed_varn, type: bool, desc: "The player recommended Varn hold the treasury (epilogue court variant)."}
  - {id: flag.a3_warned_kosk_of_varn, type: bool, desc: "The player warned Kosk about Varn's ledgers (epilogue court variant)."}
  - {id: flag.a3_regency_council, type: bool, desc: "The player pushed Kosk and Varn to share the council (epilogue court variant)."}
reads:
  - ms.act2_twist
  - flag.queen_alive
  - flag.varn_exposed
  - flag.maelis_recruited
  - flag.maelis_dead
  - flag.dravin_recruited
  - flag.hesk_apology_given
  - flag.watch_signal_lit
  - ded.marnadal_truth
  - clue.varn_ledgers
  - perk.kingmaker
```

## 9. Quest hooks

```yaml quest_stages
quest: quest.main_a3
order: 10
stages:
  - id: ride_south
    journal: "Anselm has Aldric and a long lead up the Marnadal Stairs. The lock will not know the boy without the Lion's Crown, and the Crown is in my pack. Kosk offered three roads: the Stairs, Dun Strept, or Assengard and the Iron-Key."
    objectives:
      - {id: take_crown, text: "Take the Lion's Crown", condition: "has_item(item.lion_crown)", optional: false}
      - {id: take_road, text: "Take the road south from Kosk's map", condition: "ms(ms.a3_departed)", optional: false}
      - {id: kosk_apology, text: "Win Kosk's written apology to the Strept clans", condition: "has_item(item.kosk_apology) or flag(flag.hesk_apology_given)", optional: true, xp: 120}
      - {id: cavalry_word, text: "Ask Kosk about his cavalry", condition: "flag(flag.watch_signal_lit) and rep_tier(faction.crown) >= friendly", optional: true, xp: 60}
    on_complete: []
    next: []
```

## 10. Rumors and event cards (optional)
None. Act III uses A07's mountain table and escalation pool.

## 11. Failure states and branches

```yaml branches
paths:
  - id: queen_hands_crown
    when: "flag.queen_alive and queen() <= 2."
    outcome: "Ysolde gives the Crown herself; queen_why option available. Aldric is Co-Sovereign (flag.aldric_co_sovereign, set at the twist)."
    sets: ["give_item(item.lion_crown, 1)"]
  - id: writ_crown
    when: "flag.queen_alive and queen() == 3."
    outcome: "Kosk gives the Crown under the emergency writ (flag.aldric_emergency_writ)."
    sets: ["give_item(item.lion_crown, 1)"]
  - id: king_crown
    when: "not flag.queen_alive."
    outcome: "Kosk gives the dead Queen's crown; Aldric is king (flag.aldric_crowned_king). Leads toward the Boy King ending if the oath is won."
    sets: ["give_item(item.lion_crown, 1)"]
  - id: apology_won
    when: "ded.marnadal_truth, Persuade 7 with Crown Friendly, or Sway."
    outcome: "item.kosk_apology for Hesk (a3.02)."
    sets: ["give_item(item.kosk_apology, 1)"]
  - id: apology_refused
    when: "Persuade 7 fails or Crown below Friendly and no clue or Sway."
    outcome: "No apology. The torc, or the player's own blood-price (Bribe 250), still works at Dun Strept. The war room stays open: bring ded.marnadal_truth later."
    sets: []
  - id: depart
    when: "The player uses Kosk's map."
    outcome: "ms.a3_departed; map nodes stairs_foot, dun_strept, assengard unlocked."
    sets: ["reach_milestone(ms.a3_departed)"]
failures:
  - id: leave_without_talking
    result: soft_fail
    recover: "Impossible: the council auto-starts on entry and the Crown is given in its opening nodes."
  - id: exit_to_palace_hall
    result: soft_fail
    recover: "The player can leave to the palace hall and return. The council does not restart, but Kosk's default dialogue (A04) should chain to dlg.a3_war_council's hub in Act III (see Open questions)."
guarantees:
  - "item.lion_crown is given in every opening branch of dlg.a3_war_council with no check."
  - "ms.a3_departed needs only item.lion_crown and the kosk_map interactable."
```

## 12. Open questions
- **Act transition owner (resolved by A08).** a2.08 owns `set_act(3)` and `start_quest(quest.main_a3)` (content-format §J.7). This section no longer has a fallback.
- **`item.lion_crown` ownership.** The gdd says Aldric "carries the Crown's authority" into Act III but has no item for the physical crown. I declared `item.lion_crown` here and hand it to the player, because story.md §7.7 has Aldric speak the Oath "wearing the Crown". If act2/08 also gives a crown item, merge to one id.
- **Kosk's default dialogue in Act III.** `npc.kosk` is declared by A04 with its own default `dialogue`. After the council has run, interacting with Kosk in the war room should open `dlg.a3_war_council` at node `hub`. The format cannot start a dialogue at a node, so I suggest Kosk's A04 dialogue branch on `act() == 3` and `start_dialogue(dlg.a3_war_council)` (the opening re-gives nothing: `give_item` of a key item already held should be a no-op, but the converter tests should confirm this).
- **Exit to the travel map (resolved by A08).** Zones leave to the map through an exit with `to_map: true` (content-format §J.5).
- **Cross-slice ids (resolved by A08).** `npc.ysolde`, `npc.varn`, `npc.kosk` and `npc.maelis` are declared in act1; `flag.varn_exposed` and `flag.maelis_recruited` are declared where they are first set, and `flag.maelis_dead` (system-set) in a2.08. See `docs/content/_registry.md`.
- **Escalation wording.** The gdd has no time mechanic. story.md's "three-day lead" became "a long lead" and "fast horses". No mechanic in this slice counts days. Time words appear only as atmosphere in lines and narration.
