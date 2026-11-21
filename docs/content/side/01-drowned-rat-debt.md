---
section_id: side.bertha_debt
title: "Bertha's Debt"
act: 1
story_ref: "story.md §10 The Drowned Rat; §3 Ninefingers Jory"
zones: [zone.drowned_rat_yard, zone.drowned_rat_loft]
available_when: "ms(ms.a1_rat_survived) and act() <= 2"
escalation_stage_required: {min: 0, max: 3}
milestones_set: []
milestones_read: [ms.a1_rat_survived, ms.act2_twist]
level_band: [2, 6]
---

# Bertha's Debt

## 1. Scene summary
The night after the courier died on her floor, Bertha is in her own back yard with a cudgel at her ear. "Sallow" Mott, Ninefingers Jory's collector in Cintra, has come for the protection money, and a dead royal courier is bad for business: he doubles the debt to 200 crowns. Bertha cannot pay. The player can pay it, haggle it down, frighten Mott off, beat him in the mud, or find the little book that proves Mott has been skimming Jory for years. That last road leads south: in Act II, Ninefingers Jory himself can be shown the book and forgives the debt with real fury at his own man. However the debt ends, Bertha gives the player the loft above the taproom: a free rest, a place to hide, the best gossip on the docks, and in Act II a masquerade invitation from her cousin in the Duke's kitchens at Attre. The dramatic question: what is a tavern-keeper's safety worth to a sellsword, and whose coin pays for it?

## 2. Progress and escalation
- **Availability:** Act I after `ms.a1_rat_survived`, through Act II. Escalation stage 0–3. Closes (abandoned) at `ms.act2_twist`, when the Cintra hub closes except for the palace (gdd §6.1 stage 4).
- **Location:** map node `map.cintra`. Zones `zone.drowned_rat_yard` (back yard behind `zone.drowned_rat`) and `zone.drowned_rat_loft` (upstairs room). Both are reached from the taproom of `zone.drowned_rat` (A04).
- **Milestones:** none set. The section reads `ms.a1_rat_survived` (start) and `ms.act2_twist` (close).
- **Escalation look:** stage 0 the yard smells of tar and fish. At stage 1 a Crown proclamation about new river tolls is nailed to the alley gate. At stage 2 the gutter runs grey with silt washed down the Yaruga. At stage 3 Bertha has boarded the yard windows; a pale feather is chalked on the alley wall (Choir agents operate openly).
- **Act II continuation:** the debt can also be settled at Ferrymen's Camp with Jory (`dlg.jory_bertha_debt`), so a player who left Cintra without solving it can still finish it.

## 3. Location layout
**The yard** is a walled square of black mud behind the Drowned Rat, eight paces by twelve. The kitchen door (west) leads back into the taproom. A plank gate (east) opens on Gutter Lane, the alley that runs down to the docks. North wall: a lean-to with stacked empty barrels (full cover), the slop pit (deep mud hazard), and a rain butt. South wall: Mott's mule cart, chained to a ring, with a lidded strongbox under a tarpaulin (low cover, the skim book is hidden in the strongbox's false bottom). A brazier by the kitchen door is the only light. Sight lines: from the kitchen door you see the whole yard; the gate area is in shadow. The player enters from the kitchen door. Mott stands by the cart; his two heavies flank the gate, cutting off the alley.

**Gutter Lane** is not a separate zone. The gate exit leads to `zone.cintra_docks` (A04) at the alley mouth.

**The loft** is a low room under the eaves above the taproom: a straw bed with a decent blanket (rest point), a sea chest (stash), a slit window that looks over the docks (the gossip window: Bertha's bell rope hangs beside it), and a trapdoor in the floor that drops into the cellar for a fast exit. It is reached by the taproom's back stairs, which Bertha unlocks once the debt is cleared.

```yaml zone
id: zone.drowned_rat_yard
name: "Yard behind the Drowned Rat"
kind: exterior
map_node: map.cintra
time_of_day: night
cold_rate: 0
disguise_tag: null
music: tavern_tense
areas:
  - {id: kitchen_step, description: "Stone step by the kitchen door. A brazier, a chopping block, a bucket of scrubbing water gone pink."}
  - {id: yard_mud, description: "Open mud, ankle deep, trodden into ruts. No cover."}
  - {id: lean_to, description: "North wall. Stacked barrels (full cover), the rain butt, a coil of rope."}
  - {id: slop_pit, description: "Northeast corner. Kitchen slops and fish heads over knee-deep sucking mud."}
  - {id: cart_corner, description: "South wall. Mott's mule cart chained to an iron ring; a tarpaulin over a strongbox. Low cover."}
  - {id: alley_gate, description: "East. A plank gate onto Gutter Lane, in deep shadow."}
spawns:
  - {id: from_rat, area: kitchen_step, default: true}
  - {id: from_lane, area: alley_gate}
  - {id: gate, area: alley_gate}
  - {id: cart, area: cart_corner}
exits:
  - id: kitchen_door
    area: kitchen_step
    to_zone: zone.drowned_rat
    to_spawn: from_yard
    condition: "true"
    effects: []
  - id: gutter_lane
    area: alley_gate
    to_zone: zone.cintra_docks
    to_spawn: gutter_lane
    condition: "true"
    effects: []
interactables:
  - id: mott_strongbox
    area: cart_corner
    kind: search
    label: "Search Mott's strongbox"
    condition: "not has_item(item.mott_skim_book) and not flag(flag.bertha_tip_skim)"
    check: {skill: investigate, dc: 6}
    once: true
    effects: ["give_item(item.mott_skim_book, 1)", "add_crowns(12)"]
    fail_effects: ["add_crowns(12)"]
  - id: mott_strongbox_tipped
    area: cart_corner
    kind: search
    label: "Feel for the false bottom Bertha mentioned"
    condition: "not has_item(item.mott_skim_book) and flag(flag.bertha_tip_skim)"
    check: null
    once: true
    effects: ["give_item(item.mott_skim_book, 1)", "add_crowns(12)"]
    fail_effects: []
  - id: kitchen_knock
    area: kitchen_step
    kind: door
    label: "Knock for Bertha"
    condition: "flag(flag.bertha_debt_cleared) and not flag(flag.bertha_safehouse)"
    check: null
    once: false
    effects: ["start_dialogue(dlg.bertha_debt_settled)"]
    fail_effects: []
  - id: rain_butt
    area: lean_to
    kind: pickup
    label: "Wash off the mud"
    condition: "true"
    check: null
    once: false
    effects: []
    fail_effects: []
  - id: lean_to_barrel
    area: lean_to
    kind: container
    label: "Search the barrels"
    condition: "true"
    check: null
    once: true
    effects: []
    fail_effects: []
triggers:
  - id: collection_night
    area: kitchen_step
    "on": enter
    source: null
    condition: "ms(ms.a1_rat_survived) and act() <= 2 and not quest_active(quest.side_bertha_debt) and not quest_done(quest.side_bertha_debt) and not quest_failed(quest.side_bertha_debt)"
    once: true
    effects: ["play_beat(mott_shakes_bertha)", "start_dialogue(dlg.mott_collection)"]
  - id: jory_reprisal
    area: alley_gate
    "on": enter
    source: null
    condition: "flag(flag.mott_driven_off) and flag(flag.bertha_debt_cleared) and act() == 2 and not flag(flag.jory_reprisal_done) and not flag(flag.mott_skim_exposed) and rep_tier(faction.ferrymen) < friendly"
    once: true
    effects: ["play_beat(reprisal_gate)", "start_encounter(enc.yard_reprisal)"]
hazards:
  - {id: slop_mud, area: slop_pit, kind: deep_mud, params: {speed_mult: 0.6}}
  - {id: brazier_fire, area: kitchen_step, kind: fire, params: {damage_per_second: 5}}
checkpoints:
  - {id: yard_entry, area: kitchen_step}
beats:
  - {id: mott_shakes_bertha, description: "Mott has Bertha by the apron strings against the cart; a heavy taps her ear with a cudgel. Mott turns, smiling, when the kitchen door opens."}
  - {id: mott_tears_tally, description: "Mott snaps the split tally-stick over his knee and drops the halves in the mud."}
  - {id: mott_retreats, description: "Mott backs out through the gate, heavies first, spitting in the slop pit."}
  - {id: reprisal_gate, description: "The alley gate splinters. Three of Jory's river men shoulder in with boathooks."}
npcs:
  - {npc: npc.mott_sallow, area: cart_corner, condition: "not flag(flag.bertha_debt_cleared) and not flag(flag.mott_driven_off)"}
  - {npc: npc.bertha, area: kitchen_step, condition: "not flag(flag.bertha_safehouse) and not quest_done(quest.side_bertha_debt)"}
encounters: [enc.yard_collectors, enc.yard_reprisal]
loot:
  - {container: lean_to_barrel, items: [{item: item.poultice, count: 1}], condition: "true"}
variants:
  - id: stage1_toll_notice
    when: "stage() >= 1"
    description: "A Crown notice of new river tolls nailed to the alley gate, already torn and pissed on."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: stage2_silt
    when: "stage() >= 2"
    description: "The gutter in Gutter Lane runs grey with river silt. The yard smells of wet stone."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: stage3_boarded
    when: "stage() >= 3"
    description: "Yard windows boarded. A pale feather chalked on the alley wall. Bertha keeps the kitchen door barred."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
  - id: debt_cleared
    when: "flag(flag.bertha_debt_cleared)"
    description: "Mott's cart is gone; the iron ring hangs empty. Only the ruts remain."
    npcs_absent: [npc.mott_sallow]
    encounters_disabled: [enc.yard_collectors]
    interactables_disabled: [mott_strongbox, mott_strongbox_tipped]
```

```yaml zone
id: zone.drowned_rat_loft
name: "The Loft above the Drowned Rat"
kind: interior
map_node: map.cintra
time_of_day: night
cold_rate: 0
disguise_tag: null
music: safehouse_quiet
areas:
  - {id: stair_head, description: "Top of the back stairs. A low door with a new bolt on the inside."}
  - {id: bed_nook, description: "Straw bed under the eaves, a wool blanket, a candle stub in a saucer."}
  - {id: window_slit, description: "Slit window over the docks. Bertha's bell rope hangs beside it."}
  - {id: trapdoor, description: "A trapdoor in the floorboards, dropping into the cellar behind the ale barrels."}
spawns:
  - {id: from_taproom, area: stair_head, default: true}
exits:
  - id: back_stairs
    area: stair_head
    to_zone: zone.drowned_rat
    to_spawn: from_loft
    condition: "true"
    effects: []
  - id: cellar_drop
    area: trapdoor
    to_zone: zone.drowned_rat
    to_spawn: cellar
    condition: "true"
    effects: []
interactables:
  - id: loft_bed
    area: bed_nook
    kind: rest
    label: "Sleep (safehouse rest)"
    condition: "flag(flag.bertha_safehouse)"
    check: null
    once: false
    effects: ["heal_player(full)", "set_checkpoint(loft_rest)"]
    fail_effects: []
  - id: bell_rope
    area: window_slit
    kind: readable
    label: "Ring for Bertha"
    condition: "flag(flag.bertha_safehouse)"
    check: null
    once: false
    effects: ["start_dialogue(dlg.bertha_loft)"]
    fail_effects: []
  - id: sea_chest
    area: bed_nook
    kind: container
    label: "Sea chest"
    condition: "true"
    check: null
    once: true
    effects: ["give_item(item.poultice, 2)", "give_item(item.smoke_pot, 1)"]
    fail_effects: []
triggers: []
hazards: []
checkpoints:
  - {id: loft_rest, area: bed_nook}
beats: []
npcs: []
encounters: []
loot: []
variants:
  - id: stage3_shuttered
    when: "stage() >= 3"
    description: "The window slit is stuffed with rags. Bertha has left a cudgel by the bed."
    npcs_absent: []
    encounters_disabled: []
    interactables_disabled: []
```

## 4. NPCs present

**Bertha** is declared by A04 (`npc.bertha`). Here she is frightened rather than brisk: she keeps scrubbing the step while she talks, because if she stops she will cry. Voice: Cintra dockside, short sentences, "love" for everyone she likes and no one she fears.

**"Sallow" Mott.** Voice notes: soft, almost kind, a clerk's vocabulary in a cutthroat's mouth. Calls debts "arrangements" and threats "reminders". Yellow skin and yellow teeth from a liver going bad, hence the name. Never raises his voice; lets his heavies do the shouting. When frightened he talks faster and starts adding numbers out loud.

```yaml npc
id: npc.mott_sallow
name: "Sallow Mott"
faction: faction.ferrymen
role: "Ninefingers Jory's debt collector in Cintra"
motive: "Bring Jory his take, and a little more for himself, before his liver kills him."
secret: "He has skimmed a fifth of every Cintra collection for six years and keeps the true tally in a little book in his strongbox."
disposition: wary
essential: false
dialogue: dlg.mott_collection
barks: ["Arrangements are arrangements.", "Mind the mud, friend. It keeps things.", "Jory sends his regards. I send mine.", "Two hundred. I can count it for you, if letters trouble you."]
combat: enemy.bandit
shop: null
```

## 5. Dialogue trees

The yard conversation (`dlg.mott_collection`) starts automatically the first time the player enters the yard after `ms.a1_rat_survived` (trigger `collection_night`), and on any later interaction with Mott while the debt stands. `dlg.bertha_debt_plea` is offered from Bertha's taproom dialogue (A04 adds the option). `dlg.bertha_debt_settled` closes the quest. `dlg.bertha_loft` is the safehouse conversation. `dlg.jory_bertha_debt` is chained from Jory's dialogue at Ferrymen's Camp (A05 adds the option).

```yaml dialogue
id: dlg.bertha_debt_plea
participants: [npc.bertha]
start: open
nodes:
  open:
    type: branch
    cases:
      - {if: "flag(flag.bertha_debt_cleared)", next: already_done}
      - {if: "quest_active(quest.side_bertha_debt)", next: plea_again}
    else: plea
  already_done:
    type: line
    speaker: npc.bertha
    text: "It's done, love. I sleep with one eye open now instead of none."
    next: bye
  plea:
    type: line
    speaker: npc.bertha
    text: "You saved my tavern from three men last night. There's a fourth in my yard who's worse, because he's polite. Mott. Jory's man."
    direction: "Twisting her apron in both hands."
    effects: ["start_quest(quest.side_bertha_debt)"]
    next: hub
  plea_again:
    type: line
    speaker: npc.bertha
    text: "Mott's still out there with his cart. He says two hundred now, on account of the dead man bringing trouble."
    next: hub
  hub:
    type: choice
    options:
      - id: how_much
        text: "How much do you owe?"
        next: how_much_answer
      - id: why_jory
        text: "Why does a river bandit own a Cintra tavern?"
        next: why_jory_answer
      - id: dirt
        text: "Anything I can use against Mott?"
        once: true
        next: dirt_answer
      - id: crown_help
        text: "Go to the watch. You've a Marshal's man drinking here now."
        next: crown_answer
      - id: bye_opt
        text: "I'll look at him."
        next: bye
  how_much_answer:
    type: line
    speaker: npc.bertha
    text: "It was a hundred a season to keep the river men from my cellar. Mott says two hundred now. I've thirty in the jar and a dead courier's boots."
    next: hub
  why_jory_answer:
    type: line
    speaker: npc.bertha
    text: "Every barrel I pour came up the Yaruga on Jory's barges. Don't pay, and the barges stop. Or the barrels arrive with a fire in them."
    next: hub
  dirt_answer:
    type: line
    speaker: npc.bertha
    text: "He counts twice. Once out loud for Jory, once in a little book for himself. Keeps it in the bottom of that strongbox on his cart. I've seen him fiddle the boards."
    effects: ["set_flag(flag.bertha_tip_skim)"]
    next: hub
  crown_answer:
    type: line
    speaker: npc.bertha
    text: "The watch drinks here free because I pay them too. The Crown keeps the docks the way you keep a dog. You feed it and you don't ask what it eats."
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.mott_collection
participants: [npc.mott_sallow, npc.bertha]
start: open
nodes:
  open:
    type: branch
    cases:
      - {if: "quest_active(quest.side_bertha_debt)", next: greet_again}
    else: greet_first
  greet_first:
    type: line
    speaker: npc.mott_sallow
    text: "Ah. The hero of the taproom. Mistress Bertha and I are discussing an arrangement. You're welcome to listen. Listening's free."
    direction: "Letting go of Bertha's apron, one finger at a time."
    effects: ["start_quest(quest.side_bertha_debt)"]
    next: terms
  greet_again:
    type: line
    speaker: npc.mott_sallow
    text: "Back again. Have you come to pay, or to stand in my light?"
    next: hub
  terms:
    type: line
    speaker: npc.mott_sallow
    text: "Royal couriers dying on the floor. Choir boys kicking doors. That's a riskier house than it was. Riskier houses pay more. Two hundred crowns."
    next: bertha_cuts_in
  bertha_cuts_in:
    type: line
    speaker: npc.bertha
    text: "I haven't got two hundred. I haven't got fifty."
    next: hub
  hub:
    type: choice
    options:
      - id: pay_full
        text: "Here. Two hundred. Count it."
        condition: "crowns() >= 200"
        show_locked: true
        effects: ["add_crowns(-200)", "add_rep(faction.ferrymen, 5)"]
        next: paid
      - id: haggle
        text: "Two hundred for a dead man she didn't kill? Jory gets a hundred, and a tavern that's still standing. [Persuade 6]"
        tag: persuade
        check: {skill: persuade, dc: 6, pass: haggle_pass, fail: haggle_fail}
        once: true
      - id: skim_book
        text: "Jory might like to read your little book. [Item: Mott's tally book]"
        tag: item
        condition: "has_item(item.mott_skim_book)"
        show_locked: false
        next: book_shown
      - id: friend_of_jory
        text: "Jory calls me friend. Put it on his books and let him settle it with me."
        tag: sway
        condition: "rep_tier(faction.ferrymen) >= friendly"
        show_locked: true
        next: friend_answer
      - id: writ
        text: "I'm the Lord Marshal's man. This house is under his protection. [Item: Marshal's writ]"
        tag: item
        condition: "has_item(item.kosk_writ)"
        once: true
        next: writ_answer
      - id: threaten
        text: "Here's my arrangement. You walk out that gate with your teeth. [Intimidate 6]"
        tag: intimidate
        check: {skill: intimidate, dc: 6, pass: threat_pass, fail: threat_fail}
        once: true
      - id: fight
        text: "Enough talk."
        effects: ["start_encounter(enc.yard_collectors)"]
        next: bye
      - id: leave
        text: "Not my debt."
        next: leave_line
  paid:
    type: line
    speaker: npc.mott_sallow
    text: "Generous. Foolish, but generous. Jory will hear your name kindly."
    direction: "He snaps the tally-stick over his knee."
    effects: ["play_beat(mott_tears_tally)", "set_flag(flag.bertha_debt_cleared)"]
    next: to_bertha
  haggle_pass:
    type: line
    speaker: npc.mott_sallow
    text: "A hundred. And the house still standing. Jory does like a house that stands. A hundred, then, and we part friends."
    next: haggle_hub
  haggle_hub:
    type: choice
    options:
      - id: pay_half
        text: "A hundred. Done."
        condition: "crowns() >= 100"
        show_locked: true
        effects: ["add_crowns(-100)", "add_rep(faction.ferrymen, 5)"]
        next: paid
      - id: later
        text: "I'll find the coin."
        next: later_line
  later_line:
    type: line
    speaker: npc.mott_sallow
    text: "Find it before I find something of hers to sell."
    next: bye
  haggle_fail:
    type: line
    speaker: npc.mott_sallow
    text: "Kind words don't sink, friend. Neither do I. Two hundred."
    next: hub
  book_shown:
    type: line
    speaker: npc.mott_sallow
    text: "Where did you... That's private reckoning. Give it here. Please. Jory nails men to the ferry rail for less than that book."
    direction: "His voice climbs; he starts counting under his breath."
    next: book_hub
  book_hub:
    type: choice
    options:
      - id: squeeze
        text: "Tear the tally and forget this house. Then the book stays a secret."
        effects: ["set_flag(flag.bertha_debt_cleared)", "add_crowns(40)"]
        next: squeezed
      - id: keep_for_jory
        text: "No. Jory reads it. You can run while he does."
        next: run_line
      - id: book_back
        text: "Never mind."
        next: hub
  squeezed:
    type: line
    speaker: npc.mott_sallow
    text: "Forty for your trouble. Forgotten. All forgotten. Bertha who?"
    direction: "He presses coins into the player's hand and snaps the tally-stick."
    effects: ["play_beat(mott_tears_tally)"]
    next: to_bertha
  run_line:
    type: line
    speaker: npc.mott_sallow
    text: "Then I'll be in Attre by the time his barge lands. You've made an enemy of a sick man, friend. Sick men have nothing to lose."
    effects: ["set_flag(flag.mott_driven_off)", "play_beat(mott_retreats)"]
    next: run_bertha
  run_bertha:
    type: line
    speaker: npc.bertha
    text: "He's gone, but the debt isn't, love. It's Jory's debt. You'll have to put that book in Jory's own hand."
    next: bye
  friend_answer:
    type: line
    speaker: npc.mott_sallow
    text: "On Jory's books. Yes. He did say you were to be humoured. Consider the Rat a gift between friends. I'll tell him you asked nicely."
    direction: "He snaps the tally-stick, sour as old milk."
    effects: ["play_beat(mott_tears_tally)", "set_flag(flag.bertha_debt_cleared)"]
    next: to_bertha
  writ_answer:
    type: line
    speaker: npc.mott_sallow
    text: "The Marshal's writ runs on dry land, friend. Every barrel this woman pours came up the river. The river doesn't read."
    next: hub
  threat_pass:
    type: line
    speaker: npc.mott_sallow
    text: "No need. No need at all. I'll tell Jory the house is under new management. He'll want to meet the manager."
    direction: "Backing toward the gate, palms out."
    effects: ["set_flag(flag.mott_driven_off)", "set_flag(flag.bertha_debt_cleared)", "add_rep(faction.ferrymen, -10)", "play_beat(mott_retreats)"]
    next: threat_bertha
  threat_bertha:
    type: line
    speaker: npc.bertha
    text: "Gods. He'll send worse than him, you know. But it's quiet tonight."
    next: to_bertha
  threat_fail:
    type: line
    speaker: npc.mott_sallow
    text: "Oh, you're very frightening. Boys? Show the hero how mud tastes."
    effects: ["start_encounter(enc.yard_collectors)"]
    next: bye
  leave_line:
    type: line
    speaker: npc.bertha
    text: "No. No, I suppose it isn't."
    next: bye
  to_bertha:
    type: effect
    effects: ["start_dialogue(dlg.bertha_debt_settled)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.bertha_debt_settled
participants: [npc.bertha]
start: open
nodes:
  open:
    type: branch
    cases:
      - {if: "flag(flag.bertha_safehouse)", next: already}
    else: thanks
  already:
    type: line
    speaker: npc.bertha
    text: "The loft's yours, love. Bolt's on the inside."
    next: bye
  thanks:
    type: line
    speaker: npc.bertha
    text: "I can't pay you back in coin. But there's a room over the taproom nobody knows is there. Bed, bolt, and a trap to the cellar. It's yours."
    direction: "She presses an iron key into the player's palm and closes their fingers on it."
    effects: ["set_flag(flag.bertha_safehouse)", "add_xp(50)"]
    next: offer
  offer:
    type: line
    speaker: npc.bertha
    text: "And I hear things. Sailors talk to the woman pouring. Ring the bell up there and I'll tell you what's true and what's ale."
    next: hub
  hub:
    type: choice
    options:
      - id: thanks_opt
        text: "That's worth more than coin."
        next: warm
      - id: cynic
        text: "I'd rather have had the coin."
        next: cynic_answer
  warm:
    type: line
    speaker: npc.bertha
    text: "Don't go soft on me now. Soft men end up on my floor."
    next: bye
  cynic_answer:
    type: line
    speaker: npc.bertha
    text: "Coin you spend. A door that bolts, you keep. Go on up."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.bertha_loft
participants: [npc.bertha]
start: open
nodes:
  open:
    type: line
    speaker: npc.bertha
    text: "You rang, your lordship? I've a taproom of drunks who'd like their ale."
    direction: "Leaning in the doorway, wiping a mug."
    next: hub
  hub:
    type: choice
    options:
      - id: gossip
        text: "What's the talk on the docks?"
        once: true
        next: gossip_branch
      - id: credibility
        text: "How do I tell your true rumors from the ale?"
        next: credibility_answer
      - id: invitation
        text: "I need a way into the Duke's masquerade at Attre."
        condition: "act() == 2 and not flag(flag.bertha_invitation_given) and not has_item(item.masquerade_invitation)"
        next: invitation_answer
      - id: choir_list
        text: "I've a list of names the Lord Marshal must see. Can you get it to him?"
        condition: "has_item(item.choir_list) and not flag(flag.choir_list_exposed)"
        next: list_answer
      - id: leave
        text: "Go pour your ale."
        next: bye
  gossip_branch:
    type: branch
    cases:
      - {if: "act() == 2", next: gossip_act2}
    else: gossip_act1
  gossip_act1:
    type: line
    speaker: npc.bertha
    text: "Grave-robbers went out to the Old Kings' barrows and only half came back. The Abbey's locked its scriptorium. And the Marnadal Watch garrison walked off, every man but a boy."
    effects: ["add_rumor(rumor.r11_corvan_tomb)", "add_rumor(rumor.r16_scriptorium_locked)", "add_rumor(rumor.r15_watch_deserted)"]
    next: gossip_more_1
  gossip_more_1:
    type: line
    speaker: npc.bertha
    text: "Oh, and a baron up Brzezina way has been buying Sodden wine by the cartload. A baron who drinks his enemy's wine is a baron who's been bought."
    effects: ["add_rumor(rumor.r18_brzezina_lodge)"]
    next: hub
  gossip_act2:
    type: line
    speaker: npc.bertha
    text: "A diver in Attre swears the Morrow Gull went down with a royal dispatch aboard. Skerra's boats can't put out for fog. Miners near Dun Strept hear knocking under their feet."
    effects: ["add_rumor(rumor.r12_morrow_gull)", "add_rumor(rumor.r13_skerra_fog)", "add_rumor(rumor.r14_mine_knocking)"]
    next: gossip_more_2
  gossip_more_2:
    type: line
    speaker: npc.bertha
    text: "Charcoal men in Rozrog are being hunted by something big. The Grey Ferry takes coin from the dead. And there's a girl at Ravensford who says the river sings in her brother's voice."
    effects: ["add_rumor(rumor.r17_rozrog_woodwose)", "add_rumor(rumor.r19_grey_ferry)", "add_rumor(rumor.r20_ravensford_singing)"]
    next: hub
  credibility_answer:
    type: line
    speaker: npc.bertha
    text: "Ask me who said it. A sailor lies about women. A soldier lies about fights. A priest lies about everything. I'll mark which is which in your book."
    next: hub
  invitation_answer:
    type: line
    speaker: npc.bertha
    text: "My cousin Dorota scrubs pots in the Duke's kitchens. They print more invitations than guests come. Here. Wear a clean shirt and don't eat with your fingers."
    direction: "She takes a folded card stamped with a gull from her bodice."
    effects: ["give_item(item.masquerade_invitation, 1)", "set_flag(flag.bertha_invitation_given)"]
    next: hub
  list_answer:
    type: line
    speaker: npc.bertha
    text: "The Marshal's sergeant drinks here Thursdays. Leave it with me. Nobody searches a fat woman carrying a tray."
    direction: "She tucks the list under the tray cloth."
    effects: ["set_flag(flag.choir_list_exposed)", "add_rep(faction.crown, 5)"]
    next: hub
  bye:
    type: end
```

```yaml dialogue
id: dlg.jory_bertha_debt
participants: [npc.jory]
start: open
nodes:
  open:
    type: branch
    cases:
      - {if: "flag(flag.bertha_debt_cleared)", next: settled}
    else: raise
  settled:
    type: line
    speaker: npc.jory
    text: "Bertha's square. I don't chew the same bone twice."
    next: bye
  raise:
    type: line
    speaker: npc.jory
    text: "Bertha. The Drowned Rat. Two hundred, Mott says. You've come all this way to argue about a tavern? Talk, then. The river's patient. I'm not."
    direction: "Cleaning the stump of his missing finger with a knife point."
    next: hub
  hub:
    type: choice
    options:
      - id: book
        text: "Your man Mott has been robbing you. Here's his book. [Item: Mott's tally book]"
        tag: item
        condition: "has_item(item.mott_skim_book)"
        next: book_read
      - id: pay
        text: "Two hundred, and Bertha's free of you."
        condition: "crowns() >= 200"
        show_locked: true
        effects: ["add_crowns(-200)", "add_rep(faction.ferrymen, 5)", "set_flag(flag.bertha_debt_cleared)"]
        next: paid_line
      - id: buy_off
        text: "A hundred and twenty and we never speak of the Rat again."
        tag: bribe
        bribe: 120
        effects: ["set_flag(flag.bertha_debt_cleared)"]
        next: bought_line
      - id: worth
        text: "A tavern that pays you in news is worth more than one that pays in coin. Let her pour, and I'll send you what she hears. [Persuade 8]"
        tag: persuade
        check: {skill: persuade, dc: 8, pass: worth_pass, fail: worth_fail}
        once: true
      - id: friend
        text: "Call it a favour between friends."
        tag: sway
        condition: "rep_tier(faction.ferrymen) >= friendly"
        show_locked: true
        effects: ["set_flag(flag.bertha_debt_cleared)"]
        next: friend_line
      - id: leave
        text: "Another time."
        next: bye
  book_read:
    type: line
    speaker: npc.jory
    text: "Six years. A fifth of every sack. That yellow little worm. He'll swim home tied to an anchor."
    direction: "Reading by the brazier, lips moving. His jaw works."
    effects: ["take_item(item.mott_skim_book, 1)", "set_flag(flag.mott_skim_exposed)", "set_flag(flag.bertha_debt_cleared)", "add_rep(faction.ferrymen, 15)", "add_crowns(50)"]
    next: book_thanks
  book_thanks:
    type: line
    speaker: npc.jory
    text: "Bertha's debt dies with him. And here's fifty of the silver he stole. I pay people who find my leaks."
    next: bye
  paid_line:
    type: line
    speaker: npc.jory
    text: "Coin on the table. That's how I like a conversation to end."
    next: bye
  bought_line:
    type: line
    speaker: npc.jory
    text: "A hundred and twenty. Less than owed, more than I'd get from a burned tavern. Done."
    next: bye
  worth_pass:
    type: line
    speaker: npc.jory
    text: "News, from the Marshal's own drinking hole. You've a merchant's mouth on you. Fine. The Rat pours free of me. But I want every whisper."
    effects: ["set_flag(flag.bertha_debt_cleared)", "add_rep(faction.ferrymen, 5)"]
    next: bye
  worth_fail:
    type: line
    speaker: npc.jory
    text: "I can buy news anywhere. I can't buy two hundred crowns anywhere. Try again with silver."
    next: hub
  friend_line:
    type: line
    speaker: npc.jory
    text: "For you. Once. Tell her she owes me nothing, and tell her to stop watering the beer."
    next: bye
  bye:
    type: end
```

## 6. Encounters

```yaml encounter
id: enc.yard_collectors
zone: zone.drowned_rat_yard
enemies:
  - {enemy: enemy.bandit, count: 2, spawn: gate, variant: cudgel}
  - {enemy: enemy.bandit, count: 1, spawn: cart, variant: collector}
waves:
  - {after: wave_cleared, enemies: [{enemy: enemy.bandit, count: 1, spawn: from_lane, variant: spear}]}
attack_tokens: null
allow_yield: true
allies: [npc.bertha]
checkpoint: yard_entry
avoidable_by: ["dlg.mott_collection"]
on_won: ["set_flag(flag.bertha_debt_cleared)", "set_flag(flag.mott_driven_off)", "add_rep(faction.ferrymen, -10)", "start_dialogue(dlg.bertha_debt_settled)"]
on_yielded: ["set_flag(flag.bertha_debt_cleared)", "set_flag(flag.mott_driven_off)", "add_rep(faction.ferrymen, -10)", "give_item(item.mott_skim_book, 1)", "start_dialogue(dlg.bertha_debt_settled)"]
on_player_fled: []
```

Notes: Mott (the `collector` variant: lowest bandit stats, HP 55) yields first; when he yields, the remaining heavies stop and he hands over the strongbox key, which is why `on_yielded` gives the skim book. The fourth man, a spear variant, comes through the gate from Gutter Lane after the first group falls. Bertha's "ally" behaviour is a single scripted thrown bucket of scalding water (a 1 s stagger on the nearest enemy) the first time the player drops below 50% HP. If the player flees through the kitchen door or the lane mid-fight, nothing changes: the debt stands and Mott is back by his cart on the next visit.

```yaml encounter
id: enc.yard_reprisal
zone: zone.drowned_rat_yard
enemies:
  - {enemy: enemy.bandit, count: 3, spawn: from_lane, variant: boathook}
waves: []
attack_tokens: null
allow_yield: true
allies: []
checkpoint: yard_entry
avoidable_by: []
on_won: ["set_flag(flag.jory_reprisal_done)"]
on_yielded: ["set_flag(flag.jory_reprisal_done)"]
on_player_fled: ["set_flag(flag.jory_reprisal_done)"]
```

Notes: Jory's reprisal for a forced settlement. It only fires in Act II, only once, and never if Jory has already read the skim book (he then blames Mott, not Bertha). Fleeing also ends it: the river men smash the yard barrels and leave. This encounter never closes the safehouse.

## 7. Items and clues

```yaml item
id: item.bertha_debt_tally
name: "Split tally-stick"
category: document
description: "Half of a notched hazel stick. Each notch is a season Bertha paid. The new notches are cut deep and angry."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Notches for nine seasons paid. Two fresh cuts beside them, each marked with a crude ferry hook: double, and double again."
```

```yaml item
id: item.mott_skim_book
name: "Mott's tally book"
category: document
description: "A greasy little book in a careful clerk's hand. Two columns per house: what Jory was told, and what was taken."
price: 0
stack_max: 1
equip_slot: null
weapon: null
armor: null
consumable: null
readable_text: "Rat (Bertha) - told J. 100, took 125. Three Anchors - told J. 60, took 75. Widow Peck - told J. 40, took 50 and her ring. Six years of it. The last page: 'Enough for a house in Attre and a doctor who doesn't ask.'"
```

The tally-stick is flavor and is not required: the split-tally beat replaces it. It is listed for the converter because the debt-settled scene shows it and a later reader may give it to the player as a keepsake (open question).

No clues: this is a money-and-loyalty quest, not an investigation.

## 8. Flags set and read

```yaml flags
declare:
  - {id: flag.bertha_debt_cleared, type: bool, desc: "Bertha's debt to Jory is settled by any route."}
  - {id: flag.bertha_safehouse, type: bool, desc: "The loft is the player's safehouse: free rest (counts as a safehouse rest, gdd 6.2), rumor credibility from Bertha, masquerade contact."}
  - {id: flag.mott_skim_exposed, type: bool, desc: "Jory has read Mott's tally book."}
  - {id: flag.bertha_invitation_given, type: bool, desc: "Bertha handed over her masquerade invitation."}
  - {id: flag.bertha_tip_skim, type: bool, desc: "Bertha told the player where Mott hides his tally book."}
  - {id: flag.mott_driven_off, type: bool, desc: "Mott left the yard without being paid (threat, fight, flight, or deferred to Jory)."}
  - {id: flag.jory_reprisal_done, type: bool, desc: "Jory's Act II reprisal in the yard has happened."}
reads:
  - ms.a1_rat_survived
  - ms.act2_twist
  - flag.choir_list_exposed
  - item.kosk_writ
  - item.choir_list
  - item.masquerade_invitation
```

`flag.choir_list_exposed` is declared in `02-abbey-ledgers.md`. Bertha's loft is one of the places the list can be sent from.

## 9. Quest hooks

```yaml quest
id: quest.side_bertha_debt
kind: side
title: "Bertha's Debt"
giver: npc.bertha
available: "ms(ms.a1_rat_survived) and act() <= 2"
closes_on: "ms(ms.act2_twist)"
xp: 250
stages:
  - id: clear_debt
    journal: "Sallow Mott, Ninefingers Jory's collector, wants 200 crowns from Bertha of the Drowned Rat. She can't pay. Pay him, talk him down, scare him off, or find something Jory would rather know."
    objectives:
      - {id: settle, text: "Settle Bertha's debt", condition: "flag(flag.bertha_debt_cleared)", optional: false}
      - {id: find_book, text: "Find Mott's private tally book", condition: "has_item(item.mott_skim_book) or flag(flag.mott_skim_exposed)", optional: true, xp: 40}
      - {id: tell_jory, text: "Show Jory how his collector robs him", condition: "flag(flag.mott_skim_exposed)", optional: true, xp: 60}
    on_complete: []
    next: []
  - id: back_to_bertha
    journal: "The debt is dead. Bertha wants to see me."
    objectives:
      - {id: see_bertha, text: "Return to Bertha at the Drowned Rat", condition: "flag(flag.bertha_safehouse)", optional: false}
    on_complete: []
    next: []
outcome_effects:
  completed: ["add_rep(faction.crown, 2)"]
  failed: []
```

## 10. Rumors and event cards (optional)
None defined here. Bertha's gossip adds `rumor.r11`–`rumor.r20` (defined in `14-rumors.md`).

## 11. Failure states and branches

```yaml branches
paths:
  - id: pay
    when: "Player pays 200, or 100 after a Persuade 6 haggle."
    outcome: "Debt cleared; Ferrymen +5; safehouse."
    sets: ["set_flag(flag.bertha_debt_cleared)", "set_flag(flag.bertha_safehouse)"]
  - id: threaten
    when: "Intimidate 6 passes on Mott."
    outcome: "Debt cleared by force; Ferrymen -10; Jory's reprisal in Act II unless he reads the book; safehouse."
    sets: ["set_flag(flag.bertha_debt_cleared)", "set_flag(flag.mott_driven_off)", "set_flag(flag.bertha_safehouse)"]
  - id: fight
    when: "Player fights Mott and his heavies in the yard."
    outcome: "Debt cleared; Ferrymen -10; skim book if Mott yields; safehouse."
    sets: ["set_flag(flag.bertha_debt_cleared)", "set_flag(flag.mott_driven_off)", "set_flag(flag.bertha_safehouse)"]
  - id: squeeze_mott
    when: "Player shows Mott his own book and lets him keep his secret."
    outcome: "Debt cleared; +40 crowns; Ferrymen unchanged; safehouse."
    sets: ["set_flag(flag.bertha_debt_cleared)", "set_flag(flag.bertha_safehouse)"]
  - id: jory_reads_book
    when: "Act II: player hands the book to Jory at Ferrymen's Camp."
    outcome: "Debt forgiven; Ferrymen +15; +50 crowns; Mott's fate is an anchor; safehouse on return."
    sets: ["set_flag(flag.mott_skim_exposed)", "set_flag(flag.bertha_debt_cleared)", "set_flag(flag.bertha_safehouse)"]
  - id: jory_other
    when: "Act II: player pays, bribes (120), persuades (8) or uses Ferrymen Friendly with Jory."
    outcome: "Debt cleared; safehouse on return to the Rat (knock at the kitchen door)."
    sets: ["set_flag(flag.bertha_debt_cleared)", "set_flag(flag.bertha_safehouse)"]
failures:
  - id: player_dies_yard
    result: reload_checkpoint
    recover: "Reload yard_entry. Mott is back by his cart."
  - id: player_flees_fight
    result: soft_fail
    recover: "Debt still stands. Mott remains in the yard; every route stays open."
  - id: mott_ran_for_attre
    result: soft_fail
    recover: "Player refused Mott's deal and kept the book for Jory: Mott leaves, the debt is still Jory's. Settle it at Ferrymen's Camp in Act II (dlg.jory_bertha_debt), with the book or any other option."
  - id: cannot_pay
    result: soft_fail
    recover: "Haggle, threaten, fight, the skim book (free with Bertha's tip), or Jory in Act II."
  - id: quest_closes
    result: soft_fail
    recover: "At ms.act2_twist the Cintra hub closes and the quest is abandoned. No main-quest consequence."
guarantees:
  - "flag.bertha_debt_cleared is reachable without any check: start the fight (dlg.mott_collection option fight) and win, or the skim book via Bertha's tip (no check) then the squeeze option."
  - "No main milestone depends on this quest."
```

## 12. Open questions
- **Rumor credibility rule (resolved by A08):** Bertha's rumors carry `credibility_when` (content-format §J.7).
- **Safehouse rest and the Maelis poisoning (gdd §6.2):** the `loft_bed` rest counts as a "safehouse rest". The poisoning trigger itself belongs to the companions/escalation domain, not this file.
- **Rest interactable:** gdd says a safehouse rest heals fully; the `rest` kind is used with `heal_player(full)` and a checkpoint. If the engine applies rest effects automatically for `kind: rest`, the effects list is redundant but harmless.
- **Ally Bertha:** `allies: [npc.bertha]` expects a scripted helper. Her one scripted throw is described in prose; the encounter system needs a hook for it (same as A04's Drowned Rat bottle throw).
- `item.smoke_pot` and `item.poultice` are declared in act1 (checked by A08).
- `item.bertha_debt_tally` is not handed out by any effect yet. Keep as flavor or drop.
