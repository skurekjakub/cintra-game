---
section_id: side.wenna_hair
title: "A Lock of the Queen's Hair"
act: 2
story_ref: "story.md §10 Old Wenna's Hut (reframed: no exact day), §3 Old Wenna; gdd.md §7.4, §6.2 (Queen's condition, antidote doses, rider interception), §10 design risk 'rider rule opaque'"
zones: [zone.wenna_scrying_hollow]
available_when: "act() == 2 and visited(zone.witchs_mere)"
escalation_stage_required: {min: 1, max: 3}
milestones_set: []
milestones_read: [ms.a2_wenna_line_resolved, ms.act2_twist]
level_band: [5, 8]
---

# A Lock of the Queen's Hair

## 1. Scene summary
Old Wenna will not take a Cintran's word for anything, least of all the Queen's health. She asks the player to bring her a lock of Ysolde's hair. With it, in a hollow behind her hut, in a stone basin of black mere-water and lily ash, she will say how far the grey lily has climbed in the Queen and what it will take to bring her back. In the story she named the exact day of death. With no calendar in the game, she names the **stage** of the poison instead, says how many doses her bulbs would make, and says whether a rider carrying the cure would live on the road right now. Then comes the test of trust. Before she reads, she asks to keep one strand of the hair. A hedge-witch holding a royal's hair has a hold on the royal, and the player has to decide how far to trust a woman who grows the poison that is killing the Queen. The scene ends with the player knowing exactly where the Queen stands, and with Wenna warmer or colder for how they handled her.

## 2. Progress and escalation
- **Availability:** Act II, once the player has visited `zone.witchs_mere` (escalation stage 1–3). It closes at `ms.act2_twist`, when the antidote question resolves itself (gdd §6.2).
- **Location:** `map.witchs_mere`. The offer is made in A05's `zone.witchs_mere`. The reading happens in this section's `zone.wenna_scrying_hollow`, behind the hut.
- **Start:** A05's Wenna dialogue should offer an option that runs `start_dialogue(dlg.wenna_hair_offer)` (wired in a2.05's Wenna dialogue; checked by A08).
- **The hair:** `item.ysolde_hair` comes from A04's sickroom (Presence 5, with Kosk's leave). If the player does not have it, the quest sends them back to Cintra. The `cintra — tigg` edge is open in Act II, and the Cintra hub stays open until stage 4.
- **Milestones:** none set. The section reads `ms.a2_wenna_line_resolved` (what Wenna says about doses) and `ms.act2_twist` (closing).
- **Payoff:** `flag.queen_reading_known` and +15 Wenna reputation (gdd §7.4), plus another +15 if she is allowed to keep a strand. In data, the reading reveals:
  1. `queen()` (0–3), or that the antidote has already been given;
  2. the dose count the current `var.bulbs_recovered` would make (gdd §6.2: 6 bulbs with Wenna Friendly make 2 doses; 1–5 make 1; 0 make none; Hostile Wenna brews 1 only at 3 or more);
  3. whether a rider sent **now** would be intercepted (gdd §6.2: stage ≥ 3, `flag.choir_list_exposed` false, and no Ferrymen escort, which needs Ferrymen ≥ Friendly).
  This answers gdd §10's risk that the rider rule is opaque.
- **Stage variants:**
  - Stage 1–2: mist on the mere, frogs. Wenna sharp but not afraid.
  - Stage 3 (Open Knives): the hollow is watched. If the player has not let Wenna keep a strand, two Choir watchers wait on the path up after the reading (`enc.wenna_hollow_watchers`). They are the same men who kill riders on the mere road. If the player let her keep a strand, her crow Gallows warns them and the watchers are found sleeping and chased off without a fight.

## 3. Location layout
**The scrying hollow** is a bowl in the peat behind Wenna's hut, ringed with stunted alders. It is reached by a **path** of sunk planks from the back of the hut. The **hollow floor** is spongy moss with a ring of flat stones. In the middle stands the **scrying basin**: a hollowed boulder full of black mere-water with a skin of ash on it. Around its lip the peat is **deep mud** (it slows the player and is a hazard only in the fight variant). On the north side is a **bone rack**: drying herbs, frog skins, a crow's perch made from a sheep's jawbone, where Gallows sits. The south side of the hollow opens onto **reeds** at the mere's edge. They are thick enough to hide in, and they are where the stage 3 watchers lurk.

The scene is mostly dialogue at the basin. The only real movement is walking down, and back up at stage 3.

```yaml zone
id: zone.wenna_scrying_hollow
name: "The Hollow behind Wenna's Hut"
kind: exterior
map_node: map.witchs_mere
time_of_day: night
cold_rate: 0
disguise_tag: null
music: mere_scrying
areas:
  - {id: plank_path, description: "Sunk planks from the hut's back door down into the hollow. Exit up."}
  - {id: hollow_floor, description: "Spongy moss and a ring of flat stones."}
  - {id: scrying_basin, description: "A hollowed boulder full of black mere-water skinned with ash. Deep mud around its lip."}
  - {id: bone_rack, description: "Drying herbs, frog skins, a jawbone perch for the crow Gallows."}
  - {id: reeds, description: "Thick reeds at the mere's edge; cover; where watchers lurk at stage 3."}
spawns:
  - {id: from_hut, area: plank_path, default: true}
  - {id: reed_edge, area: reeds}
exits:
  - id: up_to_hut
    area: plank_path
    to_zone: zone.witchs_mere
    to_spawn: from_hollow
    condition: "true"
    effects: []
interactables:
  - id: basin_look
    area: scrying_basin
    kind: readable
    label: "Look into the basin"
    condition: "flag(flag.queen_reading_known)"
    check: null
    once: false
    effects: []
  - id: crow_perch
    area: bone_rack
    kind: search
    label: "Look at the crow"
    condition: "true"
    check: null
    once: false
    effects: []
  - id: watchers_camp
    area: reeds
    kind: search
    label: "Search the trampled reeds"
    condition: "flag(flag.wenna_hollow_watchers_dealt)"
    check: null
    once: true
    effects: ["add_crowns(30)", "give_item(item.pale_feather, 1)"]
    fail_effects: []
triggers:
  - id: reading_starts
    area: hollow_floor
    "on": enter
    source: null
    condition: "has_item(item.ysolde_hair) and quest_active(quest.side_wenna_hair) and not flag(flag.queen_reading_known)"
    once: true
    effects: ["set_checkpoint(hollow_cp)", "start_dialogue(dlg.wenna_hair_reading)"]
  - id: watchers_spring
    area: plank_path
    "on": exit_attempt
    source: up_to_hut
    condition: "stage() >= 3 and flag(flag.queen_reading_known) and not flag(flag.wenna_kept_strand) and not flag(flag.choir_list_exposed) and not flag(flag.wenna_hollow_watchers_dealt)"
    once: true
    effects: ["set_checkpoint(hollow_cp)", "play_beat(watchers_rise)", "start_encounter(enc.wenna_hollow_watchers)"]
  - id: crow_warns
    area: plank_path
    "on": exit_attempt
    source: up_to_hut
    condition: "stage() >= 3 and flag(flag.queen_reading_known) and flag(flag.wenna_kept_strand) and not flag(flag.choir_list_exposed) and not flag(flag.wenna_hollow_watchers_dealt)"
    once: true
    effects: ["play_beat(crow_warns)", "set_flag(flag.wenna_hollow_watchers_dealt)", "add_xp(45)"]
hazards:
  - {id: basin_mud, area: scrying_basin, kind: deep_mud, params: {speed_mult: 0.6}}
checkpoints:
  - {id: hollow_cp, area: hollow_floor}
beats:
  - {id: hair_in_water, description: "Wenna winds the lock around two fingers, dips it in the basin and holds it under. The ash skin closes over her knuckles. She does not breathe."}
  - {id: water_clouds, description: "The black water goes grey-green, the colour of a lily root, then slowly clears from the edges in."}
  - {id: crow_takes_strand, description: "Wenna pulls one hair free and holds it up. Gallows hops down from the jawbone, takes it in his beak and flies off into the alders."}
  - {id: watchers_rise, description: "Reeds part on both sides of the plank path. Two men in mud-dark cloaks, blades out. One has a crossbow."}
  - {id: crow_warns, description: "Gallows explodes out of the alders shrieking. In the reeds, two men jerk awake from a wet doze and run, leaving a pack behind."}
npcs:
  - {npc: npc.wenna, area: scrying_basin, condition: "quest_active(quest.side_wenna_hair) or quest_done(quest.side_wenna_hair)"}
  - {npc: npc.wenna_crow, area: bone_rack, condition: "true"}
encounters: [enc.wenna_hollow_watchers]
loot: []
variants:
  - id: open_knives
    when: "stage() >= 3"
    description: "Mist thick to the knee. The frogs are silent. Reeds on the south side are trampled."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: list_exposed
    when: "flag(flag.choir_list_exposed)"
    description: "No watchers. The Choir's local hands were named on the list and have fled or hanged."
    npcs_absent: []
    encounters_disabled: [enc.wenna_hollow_watchers]
    interactables_disabled: []
```

## 4. NPCs present
**Voice notes.**
- **Wenna** (declared by A05, only referenced here): prickly, transactional, plain speech with a marsh accent. Calls the player "Cintra" whatever their name. Never says please or thank you. She trades. When she reads, her voice drops and slows, and she stops insulting the player, which unsettles more than the insults did.
- **Gallows:** one-eyed, glossy, wrong-sized for a crow. He clacks his beak and caws once at the right moments. Barks are shown as captions.

```yaml npc
id: npc.wenna_crow
name: "Gallows"
faction: faction.wenna
role: "Wenna's one-eyed crow"
motive: "Shiny things, carrion, and Wenna."
secret: "He carries things for Wenna across the whole Marnadal valley. The valley travel card 'one-eyed crow' is him."
disposition: neutral
essential: true
dialogue: null
barks: ["Kraa.", "(clacks his beak twice)", "(turns his one eye on your purse)"]
combat: null
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.wenna_hair_offer
participants: [npc.wenna]
start: open
nodes:
  open:
    type: line
    speaker: npc.wenna
    text: "You keep asking if your Queen will last. You don't know, Cintra. Neither do I, from here. Bring me a lock of her hair and I'll tell you exactly how deep the lily's got into her."
    direction: "Gutting a pike at her table without looking up."
    next: hub
  hub:
    type: choice
    options:
      - id: why
        text: "Why would you do that for Cintra?"
        next: why_answer
      - id: how
        text: "What can you tell from hair?"
        next: how_answer
      - id: have_it
        text: "I have a lock of the Queen's hair here. [Item: Lock of the Queen's hair]"
        tag: item
        condition: "has_item(item.ysolde_hair)"
        show_locked: true
        effects: ["start_quest(quest.side_wenna_hair)", "goto_zone(zone.wenna_scrying_hollow, from_hut)"]
        next: bye_now
      - id: fake
        text: "[Lie: offer your own hair] I cut this from her pillow myself. Here."
        condition: "not has_item(item.ysolde_hair) and not flag(flag.wenna_deceived)"
        next: fake_answer
      - id: accept
        text: "I'll bring it."
        condition: "not has_item(item.ysolde_hair) and not quest_active(quest.side_wenna_hair)"
        effects: ["start_quest(quest.side_wenna_hair)"]
        next: accept_answer
      - id: leave
        text: "Not now."
        next: bye
  why_answer:
    type: line
    speaker: npc.wenna
    text: "I don't. I do it for me. That lily is mine, grown in my mud, stolen out of my beds. I want to know what my plants are doing to her, and I want to know how much my cure is worth."
    next: hub
  how_answer:
    type: line
    speaker: npc.wenna
    text: "Hair keeps what the blood carried. Lily goes in through the gut, climbs the nerves, sits in the hair last. Read the hair, you read the climb."
    next: hub
  fake_answer:
    type: line
    speaker: npc.wenna
    text: "This is road-dust and sweat and cheap ale. Your own head, Cintra. Lie to me again and you can brew your own antidote out of your boots."
    direction: "Sniffs it once and flicks it into the fire."
    effects: ["set_flag(flag.wenna_deceived)", "add_rep(faction.wenna, -15)"]
    next: hub
  accept_answer:
    type: line
    speaker: npc.wenna
    text: "A lock, not a strand. Cut close to the scalp. And not from a comb. A comb's had every maid in the palace through it."
    next: bye
  bye_now:
    type: line
    speaker: npc.wenna
    text: "Round the back. Down the planks. Don't step off them."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.wenna_hair_reading
participants: [npc.wenna, npc.wenna_crow]
start: ask_strand
nodes:
  ask_strand:
    type: line
    speaker: npc.wenna
    text: "Give it here. Before I put it in the water, one thing. I keep a strand. One hair. That's my price."
    effects: ["take_item(item.ysolde_hair, 1)"]
    next: strand_choice
  strand_choice:
    type: choice
    options:
      - id: why_strand
        text: "What does a strand give you?"
        next: why_strand_answer
      - id: lore
        text: "A witch with a royal's hair can find her anywhere, or send things to her. I know the old stories. [Lore 6]"
        tag: lore
        check: {skill: lore, dc: 6, pass: lore_pass, fail: lore_fail}
        once: true
      - id: give
        text: "Keep it."
        next: give_strand
      - id: refuse
        text: "No. Every hair comes back to me."
        next: refuse_strand
  why_strand_answer:
    type: line
    speaker: npc.wenna
    text: "Insurance. Cintrans come to my mere when they need me and burn it when they don't. A strand says your Queen owes me, and I know where she sleeps."
    next: strand_choice
  lore_pass:
    type: line
    speaker: npc.wenna
    text: "Old stories, and half true. I can't send her anything but dreams. Bad ones, if I'm crossed. I won't be crossed, will I, Cintra?"
    direction: "For the first time she smiles. It is not a nice smile."
    next: strand_choice
  lore_fail:
    type: line
    speaker: npc.wenna
    text: "You know as much as a priest knows about mud. Decide."
    next: strand_choice
  give_strand:
    type: effect
    effects: ["play_beat(crow_takes_strand)", "set_flag(flag.wenna_kept_strand)", "add_rep(faction.wenna, 15)"]
    next: give_line
  give_line:
    type: line
    speaker: npc.wenna
    text: "Hm. Trusting. Or stupid. We'll see which. Now hold your tongue."
    next: read
  refuse_strand:
    type: line
    speaker: npc.wenna
    text: "Cintra to the bone. Fine. I'll read it and give every hair back, and you'll owe me twice. Hold your tongue."
    next: read
  read:
    type: effect
    effects: ["play_beat(hair_in_water)", "play_beat(water_clouds)"]
    next: condition_branch
  condition_branch:
    type: branch
    cases:
      - {if: "flag(flag.antidote_administered)", next: cured}
      - {if: "queen() == 0", next: q0}
      - {if: "queen() == 1", next: q1}
      - {if: "queen() == 2", next: q2}
    else: q3
  cured:
    type: line
    speaker: npc.wenna
    text: "My cure's in her. The lily's stopped climbing. It'll go out of her slow, the way the mere drains in a dry year. She'll walk again. She won't dance."
    next: rider_branch
  q0:
    type: line
    speaker: npc.wenna
    text: "It's in her hands and feet. Tremors, pins and needles, a cup she drops now and then. She can still sit a throne and lie to a room. That won't last as things get worse."
    next: climb_line
  q1:
    type: line
    speaker: npc.wenna
    text: "It's past her knees and elbows. Fever. She's abed and someone's feeding her tonics that make it worse. Whoever gives her those, she trusts. That's the cruel part."
    next: climb_line
  q2:
    type: line
    speaker: npc.wenna
    text: "It's at her eyes and her tongue. She's lucid at first light and lost the rest. One more step and it reaches her breathing."
    next: climb_line
  q3:
    type: line
    speaker: npc.wenna
    text: "It's at the root of her. She breathes because her body has forgotten how to stop. One dose, from my hand, is all that stands between her and the cold."
    next: climb_line
  climb_line:
    type: line
    speaker: npc.wenna
    text: "And mark this. The lily climbs every time your realm takes a step toward the dark. Not with the moon or the seasons. With the troubles. Fewer troubles, slower climb."
    next: mitigation_branch
  mitigation_branch:
    type: branch
    cases:
      - {if: "flag(flag.chalice_secured) and flag(flag.food_taster_exposed)", next: mit_both}
      - {if: "flag(flag.chalice_secured) or flag(flag.food_taster_exposed)", next: mit_one}
    else: mit_none
  mit_both:
    type: line
    speaker: npc.wenna
    text: "Her cup's guarded and the one who pretended to taste it is caught. That's bought her two steps back. Not a cure."
    next: dose_branch
  mit_one:
    type: line
    speaker: npc.wenna
    text: "Someone's closed one road the lily took to her, cup or taster. The other's still open. Close it and she gets back a step."
    next: dose_branch
  mit_none:
    type: line
    speaker: npc.wenna
    text: "Someone is still feeding it to her, every cup. Guard the cup, catch the one who tastes it, and she gets back a step for each."
    next: dose_branch
  dose_branch:
    type: branch
    cases:
      - {if: "ms(ms.a2_wenna_line_resolved) and var(var.bulbs_recovered) == 0", next: dose_none_resolved}
      - {if: "var(var.bulbs_recovered) == 6 and rep_tier(faction.wenna) >= friendly", next: dose_two}
      - {if: "var(var.bulbs_recovered) >= 3 and rep_tier(faction.wenna) <= hostile", next: dose_one_grudging}
      - {if: "var(var.bulbs_recovered) >= 1 and rep_tier(faction.wenna) > hostile", next: dose_one}
      - {if: "var(var.bulbs_recovered) >= 1", next: dose_hostile_short}
    else: dose_none_yet
  dose_two:
    type: line
    speaker: npc.wenna
    text: "All six bulbs back, and I like you well enough. Two cups. One for her, and one for whatever fool you love next."
    next: rider_branch
  dose_one:
    type: line
    speaker: npc.wenna
    text: "With the bulbs you've brought, one cup. All six and a warmer word from me, and you'd have two."
    next: rider_branch
  dose_one_grudging:
    type: line
    speaker: npc.wenna
    text: "I'd sooner spit in your cup. But there's enough root for one, so one you'll get. Don't make me regret it."
    next: rider_branch
  dose_hostile_short:
    type: line
    speaker: npc.wenna
    text: "Not enough root for me to brew for someone I hate. Bring me three bulbs at least, or make yourself less hateful."
    next: rider_branch
  dose_none_yet:
    type: line
    speaker: npc.wenna
    text: "And I've no bulbs to brew with. Six were stolen from my beds. Bring them. Six makes two cups. One makes one. None makes a funeral."
    next: rider_branch
  dose_none_resolved:
    type: line
    speaker: npc.wenna
    text: "There's no cure, Cintra. The root burned. Whatever's in that hair now runs its course."
    next: rider_branch
  rider_branch:
    type: branch
    cases:
      - {if: "flag(flag.antidote_administered)", next: rider_moot}
      - {if: "stage() >= 3 and not flag(flag.choir_list_exposed) and rep_tier(faction.ferrymen) < friendly", next: rider_dies}
      - {if: "stage() >= 3 and not flag(flag.choir_list_exposed)", next: rider_escort}
    else: rider_lives
  rider_moot:
    type: line
    speaker: npc.wenna
    text: "No need for riders now. Keep your silver."
    next: close
  rider_dies:
    type: line
    speaker: npc.wenna
    text: "The water shows me the road north. A rider on it, alone, carrying my cup. He doesn't reach the bridge. Knives in the reeds. Carry it yourself, or don't send it."
    next: close
  rider_escort:
    type: line
    speaker: npc.wenna
    text: "A rider alone dies on the road. A rider with Ninefingers' boatmen beside him gets through. You're friendly with that thief. Use it."
    next: close
  rider_lives:
    type: line
    speaker: npc.wenna
    text: "A rider sent today gets through. The roads are bad, not yet murderous. When the knives come out in the open, that changes."
    next: close
  close:
    type: line
    speaker: npc.wenna
    text: "That's what the water says. It doesn't lie. People do. Go on, back up the planks."
    effects: ["set_flag(flag.queen_reading_known)"]
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.wenna_hollow_watchers
zone: zone.wenna_scrying_hollow
enemies:
  - {enemy: enemy.choir_cutthroat, count: 1, spawn: reed_edge, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: reed_edge, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: hollow_cp
avoidable_by: []
on_won: ["set_flag(flag.wenna_hollow_watchers_dealt)"]
on_yielded: ["set_flag(flag.wenna_hollow_watchers_dealt)", "add_crowns(20)"]
on_player_fled: []
```

This fires only at stage 3 or later, after the reading, when the player did **not** let Wenna keep a strand and the Choir list has not been exposed. With the gdd §6.1 stage 3 rule (+1 Choir member), the group is three. The crossbowman holds the reeds. The cutthroat comes up the planks. The deep mud around the basin slows anyone who steps off. Wenna does not fight. She watches from the hut's back door and says afterward, "Riders' killers. They've been sat in my reeds a while."

**Non-combat alternative:** let Wenna keep a strand. At the same exit, Gallows warns and the watchers flee (`crow_warns`, same XP as a small fight). If `flag.choir_list_exposed` is set, the watchers were never there.

## 7. Items and clues
No new items or clues. The section consumes `item.ysolde_hair` (A04). The reading is a reveal, not a clue: it sets `flag.queen_reading_known`, which other dialogue (A05's rider choice card) can test to show a "Wenna said the road is unsafe" line.

## 8. Flags set and read

```yaml flags
declare:
  - {id: flag.queen_reading_known, type: bool, desc: "Wenna has read the Queen's condition from the hair."}
  - {id: flag.wenna_kept_strand, type: bool, desc: "The player let Wenna keep a strand of the Queen's hair."}
  - {id: flag.wenna_deceived, type: bool, desc: "The player tried to pass off their own hair as the Queen's."}
  - {id: flag.wenna_hollow_watchers_dealt, type: bool, desc: "The stage 3 Choir watchers in the hollow reeds are gone (fought, yielded, or scared off by Gallows)."}
reads:
  - item.ysolde_hair
  - flag.antidote_administered
  - flag.choir_list_exposed
  - flag.chalice_secured
  - flag.food_taster_exposed
  - var.bulbs_recovered
  - ms.a2_wenna_line_resolved
  - ms.act2_twist
```

## 9. Quest hooks

```yaml quest
id: quest.side_wenna_hair
kind: side
title: "A Lock of the Queen's Hair"
giver: npc.wenna
available: "act() == 2 and visited(zone.witchs_mere)"
closes_on: "ms(ms.act2_twist)"
xp: 300
stages:
  - id: fetch
    journal: "Old Wenna will read how far the grey lily has climbed in Queen Ysolde, if I bring her a lock of the Queen's hair. Cut close, not from a comb."
    objectives:
      - {id: hair, text: "Obtain a lock of the Queen's hair (the palace sickroom)", condition: "has_item(item.ysolde_hair) or flag(flag.queen_reading_known)", optional: false}
    on_complete: []
    next: []
  - id: reading
    journal: "I have the Queen's hair. Wenna reads in the hollow behind her hut."
    objectives:
      - {id: read, text: "Bring the hair to Wenna's hollow", condition: "flag(flag.queen_reading_known)", optional: false}
      - {id: trust, text: "Let Wenna keep her strand", condition: "flag(flag.wenna_kept_strand)", optional: true, xp: 30}
    on_complete: []
    next: []
outcome_effects:
  completed: ["add_rep(faction.wenna, 15)"]
  failed: []
```

## 10. Rumors and event cards (optional)
None here. The valley d8 slot 6 card (Wenna's one-eyed crow) in 13-travel-events.md hints at the current Wenna objective, including this quest's `fetch` stage.

## 11. Failure states and branches

```yaml branches
paths:
  - id: trust
    when: "Player lets Wenna keep a strand."
    outcome: "flag.wenna_kept_strand; +15 Wenna (plus +15 on completion); Gallows warns of watchers at stage 3."
    sets: ["set_flag(flag.wenna_kept_strand)", "set_flag(flag.queen_reading_known)"]
  - id: refuse
    when: "Player refuses the strand."
    outcome: "Reading still given; +15 Wenna on completion only; stage 3 watchers fight."
    sets: ["set_flag(flag.queen_reading_known)"]
  - id: deceive
    when: "Player offers their own hair as the Queen's."
    outcome: "-15 Wenna; flag.wenna_deceived; the real hair is still accepted later."
    sets: ["set_flag(flag.wenna_deceived)"]
failures:
  - id: no_hair
    result: soft_fail
    recover: "Return to the palace sickroom (A04) for item.ysolde_hair. If ms.act2_twist fires first, the quest is abandoned with no penalty."
  - id: player_dies_watchers
    result: reload_checkpoint
    recover: "Reload hollow_cp."
guarantees:
  - "flag.queen_reading_known needs no check once item.ysolde_hair is held: entering the hollow starts the reading; every option in strand_choice except the Lore check leads to the read."
  - "The quest is optional and has no required milestone; abandoning it closes nothing."
```

## 12. Open questions
- `item.ysolde_hair` is gated by Presence 5 in A04's sickroom (gdd §6.9). For the quest to be reachable by any build, A04 might add a check-free route, such as a bribe to a lady's maid or Maelis cutting it at confession. That is A04's decision; it is logged in this slice's report.
- `rep_tier(faction.wenna) <= hostile` assumes comparison with the lowest tier works (gdd: tiers are ordered and comparable).
- The dose lines read `var.bulbs_recovered` (resolved by A08): every bulb source, Gull Tower included, adds to it before the handover, and the handover sets it to the count handed over.
- The reading also tells the player how the mitigations stand (`flag.chalice_secured`, `flag.food_taster_exposed`). That uses the gdd §6.2 formula as written and invents no new rule.
