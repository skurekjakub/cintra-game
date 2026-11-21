---
section_id: a2.05
title: "Witch's Mere"
act: 2
story_ref: "story.md §3 Old Wenna, §6 Witch's Mere, §10 Old Wenna's Hut (hook), §11 rumor 1; gdd §6.2 antidote line"
zones: [zone.witchs_mere]
available_when: "ms(ms.act1_complete) and not ms(ms.act2_twist)"
escalation_stage_required: {min: 1, max: 3}
milestones_set: [ms.a2_wenna_line_resolved]
milestones_read: [ms.a2_wenna_line_resolved, ms.act1_complete, ms.act2_twist]
level_band: [5, 8]
---

# Witch's Mere

## 1. Scene summary
Old Wenna lives on a stilt-hut in a black fen mere south of Marnadal Field. She grows the only cultivated grey lily in the realm, or did until raiders dug up her whole bed in the summer. She knows the counter-dose that can pull Queen Ysolde back from grey lily poisoning, but she wants nothing to do with Cintra: the Crown never did anything for the mere but tax it. She will brew only if the player brings back her stolen bulbs, which went south to Duke Raimund's warehouse in Attre (some also passed through Gull Tower in Act I). How many bulbs come back, and how much she likes the player, decide whether she brews two doses, one, or none. Then comes the hardest choice in Act II: what to do with each dose. Send it ahead by fast rider (a gamble once the Choir rules the roads), carry it home, spend it on a poisoned friend, or sell it to a duke for his dying son. Wenna also carries a secret: two winters ago she sold a sack of grey lily to a soft-spoken priest "for rats in the Abbey granary". The dramatic question: what is one life worth against another, and who decides? The section ends when the antidote line is resolved (`ms.a2_wenna_line_resolved`): doses brewed, or the player admits there is nothing left to bring.

## 2. Progress and escalation
- `ms.a2_wenna_line_resolved` is set when Wenna brews (1 or 2 doses) or when the line fails (no bulbs, or Wenna is Hostile and fewer than 3 bulbs are left to give). It is part of the Act II gate. The gate needs the line **resolved**, not an antidote in hand (gdd §7.2).
- **Dose rule** (gdd §6.2, §6.12): all 6 bulbs (`var.bulbs_recovered >= 6`) and Wenna Friendly or better gives **2 doses**; 1–5 bulbs gives **1 dose**; Wenna Hostile brews **1 dose** only if at least 3 bulbs are returned; 0 bulbs gives none.
- **Wenna reputation** starts at −10 (Wary). In this file: telling her the truth about who sent you +5, lying while carrying the Marshal's writ −10, freeing her crow Gallows +10, each bulb handed over +2, stealing from her drying rack −30. The hair side quest adds +15 (side slice). Six bulbs plus the truth plus the crow is Friendly (+17).
- **Dose outcomes** (each dose, chosen in `dlg.wenna_doses`):
  1. **Rider**: Pim Reedy rides for Cintra (40 crowns) → `send_antidote_rider()`. If Ferrymen are Friendly or better and Jory lives, Jory's boatmen escort the rider for free (`flag.rider_escort_hired`). The interception rule is applied by the system (gdd §6.2).
  2. **Carry**: keep `item.wenna_antidote`. It is administered at the Act II twist (`a2.08`) or by hand at the sickroom.
  3. **Maelis**: if Maelis is a poisoned companion (`flag.maelis_poisoned`), `administer_antidote(maelis)`.
  4. **Sell to Raimund**: carried to Attre and sold in `a2.06` (+50 Attre, 300 crowns).
  5. **Bulbs burned**: if both Attre crates burned and no other bulbs were found, there is nothing to brew. The line fails, which leads toward the Boy King ending.
- **Stage 1:** the base mere. **Stage 2:** the mere water runs black; drowners in the reeds are doubled (`enc.mere_drowners_dark`). **Stage 3:** a Choir burning party comes for Wenna on arrival, because she is the only person who can undo their poison (`enc.mere_burners`). Wenna warns that a lone rider will not reach Cintra unless the Choir's spies have been exposed.

## 3. Location layout
Dusk, exterior, about 160 × 160 m of birch fen around a black mere 80 m across.
- **Fen path** (north): the path from Marnadal Field, a corduroy of sunk logs through bog (`deep_mud` off the logs). Player entry. An **offerings cairn** where locals leave coins and bread for cures.
- **Pim's croft** (north-east shore): a turf hut, a pony shed, Pim Reedy. This is where the rider leaves from.
- **Causeway:** a 50 m plank walk on posts across the mere to the islet. Planks are 1.5 m wide with no rail. Drowners can drag the player off into black water. Marsh-gas pockets bubble beside it (a `fire` hazard if lit; fire oil or a zealot's self-immolation sets them off).
- **Islet** (centre, 30 × 25 m): **Wenna's hut** on 2 m stilts (one room: hearth, brewing bench, drying rack, a sleeping loft), and the **ravaged lily bed**: three raised beds dug out to the clay, with old hobnail boot prints set hard in the mud.
- **Reed beds** (south and west): head-high reeds in thigh-deep water. A dead alder stands in them with the crow's tangle. Drowner nest.
- **Sunken punt:** a half-drowned boat at the reeds' edge, holding a raider's dropped bundle.

Intended route: fen path → offerings cairn → causeway → islet → Wenna; then the reeds for the crow.

```yaml zone
id: zone.witchs_mere
name: "Witch's Mere"
kind: exterior
map_node: map.witchs_mere
time_of_day: dusk
cold_rate: 0
disguise_tag: null
music: mere_hush
areas:
  - {id: fen_path, description: "Corduroy of sunk logs through bog from the north. Offerings cairn. Player entry."}
  - {id: pims_croft, description: "North-east shore: turf hut, pony shed. Pim Reedy, the rider."}
  - {id: causeway, description: "50 m plank walk on posts to the islet, 1.5 m wide, no rail. Marsh-gas pockets bubble alongside."}
  - {id: islet, description: "30 x 25 m islet: Wenna's stilt hut (2 m stilts; hearth, brewing bench, drying rack, loft) and the dug-out lily bed."}
  - {id: reed_beds, description: "Head-high reeds in thigh-deep water, south and west. The dead alder with the crow's tangle. Drowner nest."}
  - {id: sunken_punt, description: "Half-drowned boat at the reeds' edge."}
spawns:
  - {id: fen_path, area: fen_path, default: true}
  - {id: reeds_deep, area: reed_beds}
  - {id: causeway_far, area: causeway}
  - {id: fen_north, area: fen_path}
  - {id: from_hollow, area: islet}
exits:
  - id: to_hollow
    area: islet
    to_zone: zone.wenna_scrying_hollow
    to_spawn: from_hut
    condition: "quest_active(quest.side_wenna_hair) or quest_done(quest.side_wenna_hair)"
    effects: []
interactables:
  - id: travel_marker
    area: fen_path
    kind: map_board
    label: "Leave the mere (travel)"
    condition: "true"
    check: null
    once: false
    effects: []
  - id: offerings_cairn
    area: fen_path
    kind: readable
    label: "Look at the offerings cairn"
    condition: "true"
    check: null
    once: false
    effects: []
  - id: lily_bed
    area: islet
    kind: search
    label: "Examine the dug-out lily bed"
    condition: "true"
    check: {skill: investigate, dc: 4}
    once: true
    effects: ["add_clue(clue.bulbs_to_attre)", "add_map_pin(map.attre)"]
    fail_effects: []
  - id: drying_rack
    area: islet
    kind: container
    label: "Take herbs from Wenna's drying rack (theft)"
    condition: "not flag(flag.wenna_stores_stolen)"
    check: null
    once: true
    effects: ["set_flag(flag.wenna_stores_stolen)", "add_rep(faction.wenna, -30)", "give_item(item.antitoxin, 3)", "give_item(item.frost_tallow, 1)"]
  - id: crow_tangle
    area: reed_beds
    kind: search
    label: "Cut the crow free of the old net"
    condition: "flag(flag.crow_errand) and not flag(flag.crow_freed)"
    check: null
    once: true
    effects: ["set_flag(flag.crow_freed)", "give_item(item.harbor_token, 1)", "add_clue(clue.bulbs_to_attre)", "play_beat(crow_flies)"]
  - id: punt_bundle
    area: sunken_punt
    kind: search
    label: "Search the sunken punt"
    condition: "true"
    check: null
    once: true
    effects: ["add_crowns(25)", "give_item(item.smoke_pot, 1)"]
  - id: hut_hearth
    area: islet
    kind: rest
    label: "Sit by Wenna's hearth (rest)"
    condition: "rep_tier(faction.wenna) >= neutral"
    check: null
    once: false
    effects: ["heal_player(full)", "set_checkpoint(hut_rest)"]
triggers:
  - id: reeds_drowners
    area: reed_beds
    on: enter
    source: null
    condition: "stage() < 2 and not flag(flag.mere_reeds_cleared)"
    once: false
    effects: ["start_encounter(enc.mere_drowners)"]
  - id: reeds_drowners_dark
    area: reed_beds
    on: enter
    source: null
    condition: "stage() >= 2 and not flag(flag.mere_reeds_cleared)"
    once: false
    effects: ["start_encounter(enc.mere_drowners_dark)"]
  - id: burners_arrive
    area: fen_path
    on: enter
    source: null
    condition: "stage() >= 3 and not flag(flag.mere_burners_repelled)"
    once: true
    effects: ["set_checkpoint(mere_arrival)", "play_beat(burners_on_causeway)", "start_encounter(enc.mere_burners)"]
hazards:
  - {id: fen_bog, area: fen_path, kind: deep_mud, params: {speed_mult: 0.5, off_path_only: true}}
  - {id: marsh_gas, area: causeway, kind: fire, params: {ignites_on: fire, burst_damage: 30, radius_m: 3}}
  - {id: black_water, area: reed_beds, kind: deep_mud, params: {speed_mult: 0.6}}
checkpoints:
  - {id: mere_arrival, area: fen_path}
  - {id: hut_rest, area: islet}
beats:
  - {id: crow_flies, description: "The one-eyed crow beats free, drops something brass on the player's boot, and flaps off toward the hut cawing."}
  - {id: wenna_brews, description: "Wenna grinds the bulbs in a stone bowl, simmers them in three waters over the hearth, and decants a thin green liquor into stoppered vials."}
  - {id: rider_rides, description: "Pim Reedy swings onto his marsh pony with the vial in his shirt and splashes off up the fen path into the dusk."}
  - {id: burners_on_causeway, description: "Torches on the causeway. Grey robes. A zealot pours lamp oil on the hut's stilts while Wenna curses from the doorway with a fire-pot in her fist."}
npcs:
  - {npc: npc.wenna, area: islet, condition: "true"}
  - {npc: npc.pim_reedy, area: pims_croft, condition: "not flag(flag.antidote_rider_sent)"}
encounters: [enc.mere_drowners, enc.mere_drowners_dark, enc.mere_burners]
loot: []
variants:
  - id: black_mere
    when: "stage() >= 2"
    description: "The mere water is black and slick; dead fish along the causeway posts."
    npcs_absent: []
    encounters_disabled: [enc.mere_drowners]
    interactables_disabled: []
  - id: hut_scorched
    when: "flag(flag.mere_burners_repelled)"
    description: "Two stilts charred, the causeway's far planks burnt through and patched with a door."
    npcs_absent: []
    encounters_disabled: [enc.mere_burners]
    interactables_disabled: []
  - id: line_done
    when: "ms(ms.a2_wenna_line_resolved)"
    description: "The brewing bench is scrubbed. Wenna has planted one sickly lily seedling in the dug-out bed."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: [lily_bed]
```

## 4. NPCs present
**Voice notes.** Wenna: seventy, sharp, transactional, insults as punctuation, never says "please" or "thank you" but pays her debts exactly. She calls the Queen "your Ysolde" and the player "you". When she is moved, she gets ruder. Pim Reedy: nineteen, freckled, eager, proud of his pony (Nettle), terrified of his great-aunt.

```yaml npc
id: npc.wenna
name: "Old Wenna"
faction: faction.wenna
role: "Hedge-witch of the mere, grower of grey lily"
motive: "Get her bulbs back and be left alone."
secret: "Two winters ago she sold a sack of grey lily to a soft-spoken priest 'for rats in the Abbey granary'. She has guessed whose rats."
disposition: wary
essential: true
dialogue: dlg.wenna
barks: ["Wipe your feet or drown, your choice.", "Gallows! Where's that bird.", "Everything costs. Cures cost most."]
combat: null
shop: null
```

```yaml npc
id: npc.pim_reedy
name: "Pim Reedy"
faction: faction.wenna
role: "Wenna's great-nephew, a fast rider on a marsh pony"
motive: "Do one brave thing that isn't fetching eels."
secret: null
disposition: friendly
essential: true
dialogue: dlg.pim
barks: ["Nettle can outrun anything on four legs.", "Aunt Wenna's in a mood. She's always in a mood.", "Ride? Me? Where?"]
combat: null
shop: null
```

## 5. Dialogue trees

```yaml dialogue
id: dlg.wenna
participants: [npc.wenna]
start: greet
nodes:
  greet:
    type: branch
    cases:
      - {if: "ms(ms.a2_wenna_line_resolved)", next: greet_after}
      - {if: "rep_tier(faction.wenna) == hostile", next: greet_hostile}
      - {if: "flag(flag.wenna_met)", next: greet_again}
    else: first
  first:
    type: line
    speaker: npc.wenna
    text: "Stop there. Another sword at my door. Last ones dug up my garden and broke my crow's wing. What do you want, and who sent you?"
    direction: "In the hut doorway, a one-eyed crow on her shoulder, a knife for cutting roots in her hand."
    effects: ["set_flag(flag.wenna_met)"]
    next: who
  who:
    type: choice
    options:
      - id: truth
        text: "The Lord Marshal sent me. The Queen is dying of grey lily, and they say you know the cure."
        next: truth
      - id: lie
        text: "No one sent me. I'm just passing through."
        next: lie
      - id: sway
        text: "[Sway] Someone used your lilies to kill a queen. I'm the one who can make them answer for it."
        tag: sway
        condition: "perk(perk.kingmaker)"
        next: truth
  truth:
    type: line
    speaker: npc.wenna
    text: "Kosk. Of course. The Crown remembers the mere when it needs something. Well. At least you didn't lie. Come in, then. Don't touch anything."
    effects: ["set_flag(flag.wenna_told_truth)", "add_rep(faction.wenna, 5)"]
    next: hub
  lie:
    type: branch
    cases:
      - {if: "has_item(item.kosk_writ)", next: lie_caught}
    else: lie_passes
  lie_caught:
    type: line
    speaker: npc.wenna
    text: "Passing through a mere at the end of nowhere with palace sealing-wax on your fingers? Gallows smelled it from the causeway. Lie to me again and you can swim home."
    effects: ["set_flag(flag.wenna_lied)", "add_rep(faction.wenna, -10)"]
    next: hub
  lie_passes:
    type: line
    speaker: npc.wenna
    text: "Nobody passes through here. But fine. Come in. Don't touch anything."
    next: hub
  greet_again:
    type: line
    speaker: npc.wenna
    text: "You again. Bulbs or nothing? Speak."
    next: hub
  greet_hostile:
    type: line
    speaker: npc.wenna
    text: "Thief. Liar. Whatever you are. Say your piece from the causeway and then get off my water."
    next: hub
  greet_after:
    type: line
    speaker: npc.wenna
    text: "It's done. What's brewed is brewed. What do you want now, a kiss?"
    next: hub
  hub:
    type: choice
    options:
      - id: cure
        text: "Can you cure the Queen?"
        condition: "not ms(ms.a2_wenna_line_resolved)"
        next: cure
      - id: bulbs
        text: "Where did your bulbs go?"
        condition: "not ms(ms.a2_wenna_line_resolved)"
        next: bulbs
      - id: poisoner
        text: "What kind of person poisons with grey lily?"
        next: poisoner
      - id: priest
        text: "[Persuade 6] You've sold lily before, haven't you? To someone. Tell me."
        tag: persuade
        condition: "rep_tier(faction.wenna) >= neutral and not flag(flag.wenna_confessed_priest)"
        check: {skill: persuade, dc: 6, pass: priest, fail: priest_fail}
        once: true
      - id: crow
        text: "Your crow. Where is he?"
        condition: "not flag(flag.crow_errand) and not flag(flag.crow_freed)"
        next: crow
      - id: crow_back
        text: "[Item: Brass token] Gallows's free. He dropped this on my boot."
        tag: item
        condition: "flag(flag.crow_freed) and has_item(item.harbor_token) and not flag(flag.crow_thanked)"
        next: crow_back
      - id: hair
        text: "Can you tell how far the poison has gone in her?"
        condition: "not quest_active(quest.side_wenna_hair) and not quest_done(quest.side_wenna_hair)"
        next: hair
      - id: brew
        text: "I've brought your bulbs. Brew the cure."
        condition: "has_item(item.grey_lily_bulbs) and not ms(ms.a2_wenna_line_resolved)"
        next: brew_count
      - id: nothing
        text: "There's nothing left to bring you. The bulbs are gone."
        condition: "not ms(ms.a2_wenna_line_resolved) and (not has_item(item.grey_lily_bulbs) or (rep_tier(faction.wenna) == hostile and items(item.grey_lily_bulbs) < 3))"
        next: nothing_confirm
      - id: maelis
        text: "My companion. She's been poisoned. Can you help her?"
        condition: "in_party(companion.maelis) and flag(flag.maelis_poisoned)"
        next: maelis
      - id: doses
        text: "About the doses..."
        condition: "has_item(item.wenna_antidote)"
        next: to_doses
      - id: leave
        text: "I'll be back."
        next: bye
  cure:
    type: line
    speaker: npc.wenna
    text: "Grey lily has a twin, root to root. Boil the bulb three times in three waters and you get the counter. I can. Not without bulbs. And my bulbs are in a thief's crate somewhere."
    next: cure_2
  cure_2:
    type: line
    speaker: npc.wenna
    text: "Six sound bulbs make a full brew, two doses, if I'm in a mood to be generous. Fewer makes one thin dose. None makes nothing. Bring them all if you want her to live."
    effects: ["set_flag(flag.wenna_bulbs_asked)"]
    next: hub
  bulbs:
    type: line
    speaker: npc.wenna
    text: "Hobnails in my beds. Harbour boots. They dug at night, packed the bulbs in salt like herring, and went south. Attre's south. Everything stolen goes to Attre and comes back dearer."
    effects: ["add_clue(clue.bulbs_to_attre)", "add_map_pin(map.attre)", "set_flag(flag.wenna_bulbs_asked)"]
    next: hub
  poisoner:
    type: line
    speaker: npc.wenna
    text: "Grey lily's slow. Too much and she drops in a day, too little and she gets better. Whoever's doing it doses like a physician. Or a priest who's sat by a lot of deathbeds and paid attention."
    effects: ["add_clue(clue.wenna_learned_hand)"]
    next: hub
  priest_fail:
    type: line
    speaker: npc.wenna
    text: "I sell cures. Mind your own trade."
    next: hub
  priest:
    type: line
    speaker: npc.wenna
    text: "Two winters back. A soft-voiced priest in a good grey cloak, Cintra accent. Said there were rats in his Abbey granary. Paid in silver bars cut small. I sold him a sack."
    direction: "She looks at the hearth, not the player."
    next: priest_2
  priest_2:
    type: line
    speaker: npc.wenna
    text: "There were never any rats. I knew it when I took the silver. So now you know why I'll brew your cure. Don't make me say it twice."
    effects: ["set_flag(flag.wenna_confessed_priest)", "add_clue(clue.wenna_sold_priest)"]
    next: hub
  crow:
    type: line
    speaker: npc.wenna
    text: "Gallows. He went into the reeds after something shiny three days back and he won't come out. Drowners in there. If you want to be useful, fetch my bird."
    effects: ["set_flag(flag.crow_errand)"]
    next: hub
  crow_back:
    type: line
    speaker: npc.wenna
    text: "He's back, the wretch, and pecking my cheese. Fine. You're less useless than most. What's that he gave you? Harbour tally. Attre warehouse mark. There's your thieves."
    effects: ["set_flag(flag.crow_thanked)", "add_rep(faction.wenna, 10)"]
    next: hub
  hair:
    type: line
    speaker: npc.wenna
    text: "From here? No. Bring me a lock of her hair and I'll tell you how deep it's gone and what it'll take. Every strand's a diary."
    effects: ["start_dialogue(dlg.wenna_hair_offer)"]
    next: bye
  maelis:
    type: line
    speaker: npc.wenna
    text: "Grey lily in her too. In a wine cup, by the colour of her nails. Your Choir is thorough. One dose would do it. If you've got one."
    next: hub
  brew_count:
    type: branch
    cases:
      - {if: "rep_tier(faction.wenna) == hostile and items(item.grey_lily_bulbs) < 3", next: brew_refuse}
      - {if: "items(item.grey_lily_bulbs) < 6", next: brew_warn}
    else: brew_confirm
  brew_refuse:
    type: line
    speaker: npc.wenna
    text: "That? For you? You stole from me and lied to me and now you want my last bulbs boiled for your queen. No. Bring me more or don't come back."
    next: hub
  brew_warn:
    type: line
    speaker: npc.wenna
    text: "That's not six. I brew once. Whatever you hand me now is all the cure there will ever be, because the bed is dug out and nothing grows back by spring. Sure?"
    next: brew_confirm
  brew_confirm:
    type: choice
    options:
      - id: yes
        text: "Brew it."
        next: handover
      - id: wait
        text: "Wait. I'll look for more."
        next: hub
  handover:
    type: branch
    cases:
      - {if: "items(item.grey_lily_bulbs) >= 7", next: take_7}
      - {if: "items(item.grey_lily_bulbs) == 6", next: take_6}
      - {if: "items(item.grey_lily_bulbs) == 5", next: take_5}
      - {if: "items(item.grey_lily_bulbs) == 4", next: take_4}
      - {if: "items(item.grey_lily_bulbs) == 3", next: take_3}
      - {if: "items(item.grey_lily_bulbs) == 2", next: take_2}
    else: take_1
  take_7:
    type: effect
    effects: ["take_item(item.grey_lily_bulbs, 7)", "set_var(var.bulbs_recovered, 6)", "add_rep(faction.wenna, 12)"]
    next: brewing
  take_6:
    type: effect
    effects: ["take_item(item.grey_lily_bulbs, 6)", "set_var(var.bulbs_recovered, 6)", "add_rep(faction.wenna, 12)"]
    next: brewing
  take_5:
    type: effect
    effects: ["take_item(item.grey_lily_bulbs, 5)", "set_var(var.bulbs_recovered, 5)", "add_rep(faction.wenna, 10)"]
    next: brewing
  take_4:
    type: effect
    effects: ["take_item(item.grey_lily_bulbs, 4)", "set_var(var.bulbs_recovered, 4)", "add_rep(faction.wenna, 8)"]
    next: brewing
  take_3:
    type: effect
    effects: ["take_item(item.grey_lily_bulbs, 3)", "set_var(var.bulbs_recovered, 3)", "add_rep(faction.wenna, 6)"]
    next: brewing
  take_2:
    type: effect
    effects: ["take_item(item.grey_lily_bulbs, 2)", "set_var(var.bulbs_recovered, 2)", "add_rep(faction.wenna, 4)"]
    next: brewing
  take_1:
    type: effect
    effects: ["take_item(item.grey_lily_bulbs, 1)", "set_var(var.bulbs_recovered, 1)", "add_rep(faction.wenna, 2)"]
    next: brewing
  brewing:
    type: line
    speaker: npc.wenna
    text: "Sit. Don't talk. Three waters, and the third one stinks."
    effects: ["play_beat(wenna_brews)"]
    next: dose_count
  dose_count:
    type: branch
    cases:
      - {if: "var(var.bulbs_recovered) >= 6 and rep_tier(faction.wenna) >= friendly", next: two_doses}
    else: one_dose
  two_doses:
    type: line
    speaker: npc.wenna
    text: "Two. Two good doses. One will bring your queen back from the edge if it reaches her lips. Don't waste the other. Don't sell it either. I know you lot."
    effects: ["give_item(item.wenna_antidote, 2)", "set_var(var.antidote_doses_brewed, 2)", "reach_milestone(ms.a2_wenna_line_resolved)"]
    next: to_doses
  one_dose:
    type: line
    speaker: npc.wenna
    text: "One. Thin, but it'll hold her if it reaches her. One dose, one life. Choose whose before you leave this hut."
    effects: ["give_item(item.wenna_antidote, 1)", "set_var(var.antidote_doses_brewed, 1)", "reach_milestone(ms.a2_wenna_line_resolved)"]
    next: to_doses
  to_doses:
    type: effect
    effects: ["start_dialogue(dlg.wenna_doses)"]
    next: bye
  nothing_confirm:
    type: choice
    options:
      - id: confirm
        text: "(Admit it. There will be no cure from the mere.)"
        next: nothing
      - id: back
        text: "(Not yet. There may still be bulbs somewhere.)"
        next: hub
  nothing:
    type: line
    speaker: npc.wenna
    text: "Then there's no cure. Your Ysolde lives or dies by her own strength now, and she hasn't got much. Don't look at me like that. I didn't burn them."
    effects: ["set_flag(flag.wenna_line_failed)", "set_var(var.antidote_doses_brewed, 0)", "reach_milestone(ms.a2_wenna_line_resolved)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.wenna_doses
participants: [npc.wenna, npc.pim_reedy]
start: ask
nodes:
  ask:
    type: branch
    cases:
      - {if: "not has_item(item.wenna_antidote)", next: none_left}
      - {if: "stage() >= 3 and not flag(flag.choir_list_exposed)", next: ask_unsafe}
    else: ask_plain
  ask_plain:
    type: line
    speaker: npc.wenna
    text: "Well? Pim can ride it to Cintra faster than you can walk it. Or you carry it. Or you've got some other use in mind. Say."
    next: choose
  ask_unsafe:
    type: line
    speaker: npc.wenna
    text: "Roads crawl with feathers now. A lone boy on a pony won't see Cintra's gate. Unless the Choir's eyes are put out, or someone rides with him who knows the river. Choose."
    next: choose
  choose:
    type: choice
    options:
      - id: rider
        text: "[Bribe 40] Pim rides it to Cintra tonight. Straight to the Lord Marshal."
        tag: bribe
        condition: "has_item(item.wenna_antidote) and not flag(flag.antidote_rider_sent) and not flag(flag.antidote_administered)"
        bribe: 40
        next: rider_go
      - id: escort
        text: "Pim rides with Jory's boatmen. They owe me."
        condition: "has_item(item.wenna_antidote) and not flag(flag.antidote_rider_sent) and not flag(flag.antidote_administered) and rep_tier(faction.ferrymen) >= friendly and not flag(flag.jory_dead)"
        next: escort_go
      - id: maelis
        text: "Give it to Maelis. Now."
        condition: "has_item(item.wenna_antidote) and in_party(companion.maelis) and flag(flag.maelis_poisoned)"
        next: maelis_go
      - id: carry
        text: "I'll carry it myself."
        next: carry
  rider_go:
    type: line
    speaker: npc.pim_reedy
    text: "Me? To the Marshal? Nettle, did you hear that? I'll not stop for anything. Not for anything, I swear it."
    effects: ["set_flag(flag.antidote_rider_sent)", "send_antidote_rider()", "play_beat(rider_rides)"]
    next: ask
  escort_go:
    type: line
    speaker: npc.pim_reedy
    text: "Boatmen? With crossbows? Aunt, I'm going with an escort! Like a lord!"
    effects: ["set_flag(flag.rider_escort_hired)", "set_flag(flag.antidote_rider_sent)", "send_antidote_rider()", "play_beat(rider_rides)"]
    next: ask
  maelis_go:
    type: line
    speaker: npc.wenna
    text: "Hold her head. All of it, girl, don't spit. There. She'll be sick for a day and then she'll live, which is more than most get."
    effects: ["administer_antidote(maelis)", "set_flag(flag.antidote_given_maelis)", "add_rep(faction.abbey, 10)"]
    next: ask
  carry:
    type: line
    speaker: npc.wenna
    text: "Keep it warm, keep it dark, keep it away from dukes. Now get out, I've a bed to dig over."
    next: bye
  none_left:
    type: line
    speaker: npc.wenna
    text: "That's all of it spoken for. Off you go."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.pim
participants: [npc.pim_reedy]
start: plain
nodes:
  plain:
    type: line
    speaker: npc.pim_reedy
    text: "You're going to see Aunt Wenna? Mind the third plank on the causeway, it bites. If she needs anything carried, Nettle's the fastest pony between here and the Yaruga."
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.mere_drowners
zone: zone.witchs_mere
enemies:
  - {enemy: enemy.drowner, count: 3, spawn: reeds_deep, variant: null}
waves: []
attack_tokens: null
allow_yield: false
allies: []
checkpoint: mere_arrival
avoidable_by: []
on_won: ["set_flag(flag.mere_reeds_cleared)"]
on_yielded: []
on_player_fled: []
```

```yaml encounter
id: enc.mere_drowners_dark
zone: zone.witchs_mere
enemies:
  - {enemy: enemy.drowner, count: 4, spawn: reeds_deep, variant: null}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.drowner, count: 2, spawn: causeway_far, variant: null}]}
attack_tokens: null
allow_yield: false
allies: []
checkpoint: mere_arrival
avoidable_by: []
on_won: ["set_flag(flag.mere_reeds_cleared)"]
on_yielded: []
on_player_fled: []
```
Design: at stage 2 the black water doubles the nest. The second wave climbs the causeway posts behind the player.

```yaml encounter
id: enc.mere_burners
zone: zone.witchs_mere
enemies:
  - {enemy: enemy.choir_zealot, count: 2, spawn: causeway_far, variant: null}
  - {enemy: enemy.choir_crossbowman, count: 1, spawn: fen_north, variant: null}
waves: []
attack_tokens: null
allow_yield: true
allies: [npc.wenna]
checkpoint: mere_arrival
avoidable_by: []
on_won: ["set_flag(flag.mere_burners_repelled)", "add_rep(faction.wenna, 10)"]
on_yielded: ["set_flag(flag.mere_burners_repelled)", "add_rep(faction.wenna, 10)"]
on_player_fled: []
```
Design: stage 3 only. Two zealots on the causeway soak the stilts with oil; the crossbowman covers from the fen path behind the player. Wenna throws one fire-pot (scripted ally action), which can set off the marsh gas. A zealot's death-burst on the causeway also ignites it. Wenna cannot die (essential); if the player loses, reload `mere_arrival`.

## 7. Items and clues

```yaml item
id: item.wenna_antidote
name: "Grey lily counter-dose"
category: key
description: "A stoppered vial of thin green liquor that smells of river mud and burnt sugar. Wenna's cure. One vial, one life."
price: 0
stack_max: 2
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml item
id: item.harbor_token
name: "Attre warehouse tally"
category: key
description: "A brass tally token stamped with a ship, the number nine, and the Duke of Attre's anchor. Gallows's shiny thing."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: null
```

```yaml clue
id: clue.bulbs_to_attre
theory: theory.poisoner
title: "The bulbs went to Attre"
text: "Harbour hobnails in Wenna's dug-out beds and a brass tally from warehouse nine with the Duke's anchor: Wenna's grey lily was stolen to order and shipped to Duke Raimund's harbour."
supports: [raimund]
refutes: []
```

```yaml clue
id: clue.wenna_learned_hand
theory: theory.poisoner
title: "A learned hand doses the Queen"
text: "Grey lily must be measured to kill slowly. Wenna says whoever doses the Queen does it like a physician, or a priest who has sat by many deathbeds."
supports: [anselm]
refutes: [varn]
```

```yaml clue
id: clue.wenna_sold_priest
theory: theory.poisoner
title: "The priest who had rats"
text: "Two winters ago Wenna sold a sack of grey lily to a soft-voiced priest in a grey cloak with a Cintra accent, for 'rats in the Abbey granary', paid in silver bars cut small."
supports: [anselm]
refutes: []
```

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.a2_wenna_line_resolved, type: milestone, desc: "Wenna brewed 1-2 doses, or the antidote line failed. Part of the Act II gate."}
  - {id: flag.wenna_met, type: bool, desc: "The player has met Wenna."}
  - {id: flag.wenna_bulbs_asked, type: bool, desc: "Wenna has asked for her bulbs (the Wenna line is active). Read by side travel cards L3 and V6."}
  - {id: var.bulbs_recovered, type: int, min: 0, max: 6, desc: "Grey lily bulbs recovered for Wenna. Sources add to it (Attre crates, travel card); the handover sets it to the number actually handed over (Gull Tower bulbs from act1 are counted there)."}
  - {id: flag.wenna_told_truth, type: bool, desc: "The player told Wenna who sent them."}
  - {id: flag.wenna_lied, type: bool, desc: "Wenna caught the player lying."}
  - {id: flag.wenna_stores_stolen, type: bool, desc: "The player stole from Wenna's drying rack."}
  - {id: flag.crow_errand, type: bool, desc: "Wenna asked the player to fetch her crow."}
  - {id: flag.crow_freed, type: bool, desc: "The player cut Gallows free in the reeds."}
  - {id: flag.crow_thanked, type: bool, desc: "Wenna has acknowledged the crow's return (+10)."}
  - {id: flag.wenna_confessed_priest, type: bool, desc: "Wenna admitted selling grey lily to a priest."}
  - {id: flag.mere_reeds_cleared, type: bool, desc: "The drowners in the reeds are dead."}
  - {id: flag.mere_burners_repelled, type: bool, desc: "The stage-3 Choir burning party was beaten."}
  - {id: flag.wenna_line_failed, type: bool, desc: "No antidote was brewed. Leads toward the Boy King ending."}
  - {id: var.antidote_doses_brewed, type: int, min: 0, max: 2, desc: "Doses Wenna brewed."}
  - {id: flag.antidote_rider_sent, type: bool, desc: "A dose went to Cintra with Pim Reedy (send_antidote_rider)."}
  - {id: flag.rider_escort_hired, type: bool, desc: "Jory's boatmen escort the rider; the system's interception rule treats this as an escort (gdd §6.2)."}
  - {id: flag.antidote_rider_intercepted, type: bool, desc: "Set by the system when the rider is intercepted (gdd §6.2). Declared here; read by a2.08."}
  - {id: flag.antidote_administered, type: bool, desc: "The Queen has received a dose (rider got through, or administer_antidote(queen)). Set by the antidote system; declared here."}
  - {id: flag.antidote_given_maelis, type: bool, desc: "A dose saved Maelis."}
reads:
  - flag.maelis_poisoned
  - flag.choir_list_exposed
  - flag.jory_dead
  - item.grey_lily_bulbs
  - item.kosk_writ
  - companion.maelis
  - quest.side_wenna_hair
  - perk.kingmaker
```

## 9. Quest hooks
Contributes the required objective `antidote_line` and the optional `lead_wenna` of `quest.main_a2/the_marnadal_road` (declared in `a2.01`).

Side-quest hook: `dlg.wenna` option `hair` chains into `dlg.wenna_hair_offer` (side slice), which starts `quest.side_wenna_hair`. The islet exit `to_hollow` leads to the side slice's `zone.wenna_scrying_hollow` (spawn `from_hut`); its return exit lands on this zone's `from_hollow` spawn.

## 10. Rumors and event cards (optional)
Rumor 1 ("The Queen's not dying of fever... Ask the marsh-witch") and the valley event "Wenna's one-eyed crow" (gdd §6.3, slot 6) are owned by the side slice and point here. The crow card's hint should read the current Wenna objective: not met (go to the mere), met without bulbs (Attre), or bulbs in hand (return).

## 11. Failure states and branches

```yaml branches
paths:
  - id: two_doses
    when: "Player brings 6 bulbs and Wenna is Friendly or better after the handover (truth +5, crow +10, bulbs +12, or the hair quest)."
    outcome: "2 doses; ms.a2_wenna_line_resolved; dose choices."
    sets: ["reach_milestone(ms.a2_wenna_line_resolved)"]
  - id: one_dose
    when: "Player brings 1-5 bulbs, or 6 without Friendly, or 3+ while Hostile."
    outcome: "1 dose; ms.a2_wenna_line_resolved."
    sets: ["reach_milestone(ms.a2_wenna_line_resolved)"]
  - id: line_failed
    when: "Player has no bulbs (or is Hostile with fewer than 3) and confirms there is nothing left."
    outcome: "No antidote; flag.wenna_line_failed; the Queen will die at the twist (Boy King path)."
    sets: ["reach_milestone(ms.a2_wenna_line_resolved)"]
  - id: rider
    when: "Player pays 40 or uses Jory's escort."
    outcome: "send_antidote_rider(); system resolves interception (stage >= 3 and no Choir list and no escort means lost)."
    sets: ["set_flag(flag.antidote_rider_sent)"]
  - id: carry
    when: "Player keeps the vial(s)."
    outcome: "Administered at a2.08 automatically, or sold to Raimund in a2.06."
    sets: []
  - id: maelis
    when: "Maelis is a poisoned companion and the player gives her a dose."
    outcome: "Maelis lives; Abbey +10; that dose is gone."
    sets: ["set_flag(flag.antidote_given_maelis)"]
failures:
  - id: player_dies
    result: reload_checkpoint
    recover: "Reload mere_arrival or hut_rest."
  - id: wenna_hostile_few_bulbs
    result: soft_fail
    recover: "She refuses to brew; the 'nothing left' option appears so the line can still resolve (as failed). Finding more bulbs reopens the brew."
guarantees:
  - "ms.a2_wenna_line_resolved is always reachable without a check: either brew with any bulbs (no check) or confirm that nothing is left (no check, shown whenever brewing is impossible)."
```

## 12. Open questions
- **Bulb counting:** `item.grey_lily_bulbs` is declared by act1 (Gull Tower, +2, item only). `var.bulbs_recovered` is declared here. Attre and the side travel card add to both item and var; Gull Tower adds only the item. To keep the count honest, the handover sets the var to the number of bulbs actually handed over (capped at 6), and the dose rule reads it after that. Up to 7 bulbs can exist (Gull 2, Attre 2 + 2, card 1); all are taken.
- **`send_antidote_rider()` consumption:** this file assumes the effect consumes one `item.wenna_antidote`, like `administer_antidote`. If not, add `take_item(item.wenna_antidote, 1)` before it.
- **Rider escort:** gdd §6.2 says "no escort was hired" without naming a flag. This file defines `flag.rider_escort_hired`. The rider system must read it.
- `flag.antidote_rider_intercepted` and `flag.antidote_administered` are system-set but declared here (first section where they can become true). The reconciliation pass may move them to a system declarations file.
- `flag.maelis_poisoned` is assumed to be set by the escalation system (gdd §6.2, stage 3 rest). It is listed as expected.
- The side slice's hair reading (`side/08`) predicts the dose count from `var.bulbs_recovered` before the handover, so it can undercount Gull Tower bulbs by 2. Either act1's Gull Tower should also `add_var(var.bulbs_recovered, 2)`, or the reading should use `items(item.grey_lily_bulbs)`.
