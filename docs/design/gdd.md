# The Lion's Shadow — Game Design Document

Status: v1 (A02, 2026-11-21). Binding inputs: `story.md`, `docs/orchestration/STATE.md` (D1–D3, C1–C4, C6–C8).
Companion documents: `architecture.md` (software structure), `content-format.md` (per-section content template).

> **Change log.** v1 has **no time mechanic**: no calendar, no day counter, no travel or rest cost in days, and no deadlines. Orchestrator call C5 was revoked by the user. Escalation (the Queen's condition, unrest in the realm, signs from the vaults) is driven by **story progress**: act transitions and main-quest milestones. The only real-time timer in the game is the finale's four-stage ritual meter, which is a combat mechanic (§6.14).

> **Art direction (D3) is not chosen yet.** This document does not depend on the camera or the art style. Places where the art pick plugs in are marked **[ART]**. See §9.

> **IP note.** Place names come from the story outline. All characters, plot, and assets are original. Never use CD Projekt assets, UI, or visual likeness.

---

## 1. Overview

| | |
|---|---|
| Genre | Single-player real-time action RPG with investigation and dialogue |
| Platform | Windows PC, keyboard+mouse and gamepad (C8) |
| Engine | Godot 4.7.2, statically typed GDScript (D2, C6) |
| Structure | A hub and discrete zones, reached from a travel map (C4) |
| Protagonist | One controllable hired sword, named by the player (default name **Hale**) (C2) |
| Followers | Story companions who fight under AI control for stretches of the game (C2) |
| Combat | Real-time: light and heavy attacks, block and parry, dodge, stamina, crossbow (C3). The game pauses only for menus and dialogue |
| Length target | 12–18 hours for the main path, 25+ hours with all side quests |
| Levels | 1–12 across three acts (Act I: 1–4, Act II: 5–8, Act III: 9–12) |

## 2. Pillars

1. **Investigate, don't assume.** Everyone at court lies about something. Clues support or rule out suspects on a visible board, red herrings get chases of their own, and evidence opens dialogue that brute force cannot.
2. **Mud and iron.** Combat is weighty and grounded. Stamina decides every swing, groups are small but dangerous, and monsters are either animals or weapons. Magic is low: alchemy, old dwarven engineering, ghosts at the edges.
3. **The realm reacts to what you do.** Each milestone you reach visibly worsens the kingdom. Factions remember you. Your choices decide which of five endings you get.
4. **Every road leads to Ostrel.** Side quests are never filler. Each one pays off concretely in Act III (an ally, a route, a weapon, a weaker finale guard).

## 3. Player Fantasy

You are a sellsword who happened to be in the wrong tavern. A dying courier hands you a letter that half the kingdom would kill for. You become the one blade the Lord Marshal can trust. You read liars, chase thieves across rooftops, and bargain with river bandits and hedge-witches. In the end you climb into a frozen dwarven fortress to drag a twelve-year-old king-to-be away from a knife while the mountain's old weapons stir.

## 4. Core Loops

| Loop | Duration | Shape |
|---|---|---|
| Moment-to-moment | 10 s – 2 min | Move, then either read the scene (interactables, NPC barks) or fight (space, stamina, timing), then loot or gather clues |
| Per zone | 15–45 min | Enter (autosave), take on the zone's objectives through combat, dialogue or stealth, collect clues and items, set milestones, exit to the hub or map |
| Per journey | 1–3 min | Open the map, pick an unlocked destination, possibly hit one encounter (combat, event card, discovery or hazard), arrive |
| Per milestone | ~1 hour | Main milestones raise the **escalation stage** (§6.1). The world changes: new rumors, harder roads, the Queen gets worse, faction moves |
| Per act | 4–6 hours | Meet the act gate. A transition cutscene plays, the map expands, and the stakes reset upward |

---

## 5. Protagonist and Controls

The player creates Hale (name, a portrait preset **[ART]**, 4 bonus attribute points). Hale has no fixed backstory beyond being "a hired sword between contracts". Dialogue options give Hale an attitude: dutiful, mercenary, or cynical. Attitude is flavor only and is not tracked.

| Action | Keyboard + mouse | Gamepad (Xbox layout) |
|---|---|---|
| Move | WASD | Left stick |
| Camera / aim | Mouse **[ART: camera model]** | Right stick |
| Light attack | LMB | RB |
| Heavy attack (hold to charge) | Hold LMB 0.4 s, or Shift+LMB | RT |
| Block / parry | RMB | LB |
| Dodge | Space | B |
| Sprint | Hold Space while moving | Click left stick |
| Kick | F | Y + direction |
| Crossbow (aim / fire) | Hold Q, then LMB | Hold LT, then RT |
| Quick slots 1–4 | 1–4 | D-pad |
| Interact / talk | E | A |
| Crouch (stealth) | C | Click right stick |
| Lock-on toggle | Middle mouse / Tab | Click right stick (hold) |
| Journal / map / inventory | J / M / I | View button, then tabs |
| Pause | Esc | Menu |

All bindings can be rebound (§6.17).

---

## 6. Systems

Every rule below is written so that it can be implemented and unit-tested. Numbers are starting tuning values. They live in data files, not in code (see `architecture.md` §5).

### 6.1 Story progress, milestones and escalation

There is **no clock**. The world worsens only when the player advances the story.

**Milestones** are permanent, write-once facts set by content effects (`ms.<id>`), for example `ms.a1_audience_done`. **Act II progress** is the number of Act II main milestones achieved, out of the seven in §7.2:
`ms.a2_tigg_resolved`, `ms.a2_cipher_taken`, `ms.a2_jory_dealt`, `ms.a2_torc_taken`, `ms.a2_wenna_line_resolved`, `ms.a2_attre_ledger`, `ms.a2_vel_aram_cleared`.

**The escalation stage** is an integer from 0 to 4. It only ever increases. After every milestone change it is recalculated as the highest stage whose condition holds:

| Stage | Name | Condition (any stage condition true ⇒ at least this stage) | Story equivalent |
|---|---|---|---|
| 0 | Equinox | New game | "90 days" |
| 1 | Cracked Stone | `ms.act1_complete` | "60 days" |
| 2 | Dark River | stage ≥ 1 and Act II progress ≥ 3 | "30 days" |
| 3 | Open Knives | stage ≥ 1 and (Act II progress ≥ 5 or Act II gate met) | "10 days" |
| 4 | Solstice | `ms.act2_twist` | "0 days" / finale |

**Effects when each stage begins** (each is applied once, from data in `content/escalation/stages.json`):

| Stage | World changes | Gameplay effect |
|---|---|---|
| 0 | Abbey bells ring at midnight (Drowned Rat ambient). Rumor of a wyvern over Tigg added to the pool | none |
| 1 | The crack in the Ring of Nine widens and the stone oozes tar. Kosk and Varn clash openly at court (court scene variant). A courier brings the news to wherever the player is | Varn reputation −10 unless `flag.varn_blackmailed`. Prices +10% in Crown Lands |
| 2 | The Marnadal river runs dark with mineral silt. Heavy snow closes the high passes | **Escalation encounter rule** turns on (§6.3). Mountain edges need guides or trigger a forced cold hazard (§6.3). Drowner encounters ×2 weight on valley tables. Grey Ferry zone gets its dark-river variant |
| 3 | Choir agents operate openly. Duke Raimund fortifies Attre's borders unless Attre reputation ≥ Allied | Choir encounter groups +1 member. Attre land entry needs `item.masquerade_invitation`, the smuggler's cutter (Skerra), or a checkpoint fight. Rider interception risk (§6.2). Prices +20% realm-wide |
| 4 | Solstice dawn approaches. Prince Aldric has been abducted | Act III begins. Cintra hub closes except for the palace. Mountain encounter tables only |

Each stage-up shows a short **Escalation card** (an illustration **[ART]** plus two lines of text) and adds a journal entry. The *Signs* tab of the codex records all stage changes.

**Tests:** recalculating the stage is a pure function of the milestone set. The stage never decreases. Each stage's on-enter effects run exactly once, even across save and load.

### 6.2 The Queen's condition

The Queen's condition is a derived value, not a timer.

```
mitigations     = count(flag.chalice_secured, flag.food_taster_exposed)        # 0..2
base_condition  = min(escalation_stage, 3)
queen_condition = clamp(base_condition - mitigations, 0, 3)  while antidote not administered
```

| Condition | Label | Effect |
|---|---|---|
| 0 | Weak (hand tremors) | Brief audiences are possible. The *Queen confides* dialogue is available and grants `clue.queen_knows_vaults` |
| 1 | Bedridden (fever, Anselm's "tonics") | Short sickroom conversations only. The confide dialogue is still possible if a Presence 6 check passes |
| 2 | Lucid only at dawn | One line at the sickroom. No new clues |
| 3 | Comatose | No interaction. The sickroom shows her laboured breathing |

**Mitigations (Act I):**
- `flag.chalice_secured`: in the sickroom, persuade Kosk to put the Queen's chalice and wine under the guard of his own men. This needs `clue.chalice_pollen` plus Presence 4, or the Keen Eye perk.
- `flag.food_taster_exposed`: expose Pell, the royal food-taster, through `clue.taster_gold` and a confrontation, or through the Morrow Gull dispatch tube (side quest).

**The antidote line (Act II):** Wenna brews the antidote once her bulbs come back (§7.2, Witch's Mere and Attre).
- Recovering **all** bulbs (`var.bulbs_recovered == 6`) with Wenna reputation ≥ Friendly makes **2 doses**. Recovering 1–5 bulbs makes **1 dose**. Recovering 0 bulbs (both crates burned in a loud raid) means **no antidote**, and the Wenna line resolves as failed.
- With each dose the player chooses one of:
  1. **Send it by fast rider** (at Witch's Mere, costs 40 crowns). The rider is **intercepted** if escalation stage ≥ 3 when sent, **and** `flag.choir_list_exposed` is false, **and** no escort was hired (Jory's boatmen escort needs Ferrymen ≥ Friendly). If the rider gets through, `flag.antidote_administered` is set the next time a milestone fires. If intercepted, the dose is lost and the player is told by courier.
  2. **Carry it** as `item.wenna_antidote`. It is administered automatically at the Act II twist, or by hand at the sickroom whenever the player is in Cintra.
  3. **Spend it elsewhere**: on Sister Maelis (see below), or sell it to Duke Raimund for his ailing heir (+50 Attre reputation, 300 crowns). The second option is a deliberate Realpolitik temptation.
- **Maelis poisoned:** when stage 3 begins, if Maelis is an active companion and `flag.choir_list_exposed` is false, the Choir poisons her at the next camp or safehouse rest. She dies at the next zone exit unless she receives a dose.
- Once `flag.antidote_administered` is set, the Queen stops declining. Her condition is frozen at its current value and improves by one step at each later milestone, down to 0 (Weak).

**Twist resolution (at `ms.act2_twist`):** `flag.queen_alive = flag.antidote_administered`. If the Queen is alive and her condition is ≤ 2, she formally invests Aldric (`flag.aldric_co_sovereign`). If she is alive but comatose, Kosk invests Aldric by emergency writ (`flag.aldric_emergency_writ`), which only changes flavor. If she is dead, Kosk crowns Aldric king (`flag.aldric_crowned_king`). In every case Aldric carries the Crown's authority into Act III. The ending (§6.15) reads `flag.queen_alive`.

### 6.3 Travel

**The map** is a graph of nodes (locations) joined by edges (roads). It has no time cost. Nodes unlock by flags (for example, an Act II south node unlocks on `ms.act1_complete`). The map shows only discovered nodes; rumors and documents add **map pins** that reveal undiscovered nodes. **[ART]** The map's look (parchment, survey map of 1262) is decided by art direction.

**Journey:** the player picks any unlocked node that can be reached. The route is the shortest path by edge count through **passable** edges (ties broken by fewest mountain edges, then alphabetically by node id, so it is deterministic). The party token animates along the route (presentation only, at most 3 seconds, skippable).

**Edge passability:** an edge may carry a condition, for example:
- `ferrymen_camp—marnadal_field`: `flag.jory_crossing_granted` or the player picks the ford (forced hazard event "Ford the Marnadal" with an Agility 5 check; failing costs 25% HP and one random consumable).
- Mountain edges at stage ≥ 2 without `flag.strept_guides` or Dravin in the party: forced hazard event "Snow-choked pass" with a Grit 6 check; failing applies Chill and costs 30% HP. The edge stays passable.

**Encounter check, once per journey:**

```
chance  = 0.35 + 0.10 * (edges_on_route - 1)        capped at 0.75
chance -= 0.15 if perk.pathfinder
chance -= 0.15 if ally.forest_guide and route has a valley edge
chance  = max(chance, 0.05)
terrain = terrain shared by most edges on the route (ties: terrain of the last edge)
```

If the check passes, roll a d8 on the terrain's table (seeded RNG, state stored in the save). Then, **escalation rule:** if escalation stage ≥ 2 and the result is not already an escalation entry, roll a d6. On 1–2, replace the result with a random entry from that terrain's **escalation pool**.

Reroll rules: entries whose `requires` condition is false (for example "Wyvern circling" after the Roost is resolved) and an entry identical to the previous journey's result are rerolled, up to 3 times. If all rerolls fail, the road is quiet.

**Encounter kinds:**
- `combat`: load the terrain's small arena (`zone.arena_<terrain>_<n>`) with the listed enemies. Enemies flee when 70% of the group is down. XP from travel combat is ×0.5.
- `event_card`: a modal card with 2–4 choices (dialogue rules from §6.10 apply), resolved in place.
- `discovery`: a pickup, clue, rumor, or map pin, shown as a toast.
- `hazard`: a skill check with a failure penalty.

**Terrain tables** (from story §11; terrains are `lowlands`, `valley`, `mountain`; sea legs count as `lowlands`):

| d8 | Lowlands & King's Roads | Marnadal Valley & Woods | Góry Amell & Strept |
|---|---|---|---|
| 1 | Tax collectors shaking down peasants (event card: intervene, bribe, or ignore; Crown ±) | Ferrymen demanding triple toll (event card / combat; free if Ferrymen ≥ Friendly) | Rockslide or avalanche (hazard, Agility 6) |
| 2 | Pilgrims to St. Corwen; one hides a pale feather (event card, Wits 5 exposes a Choir spy, +Clue) | Revenant patrol (combat: 3 revenant footmen) | Strept scouts shadowing (event card; Strept ≥ Friendly makes them guides for this journey) |
| 3 | Attre wagon with grey lily bulbs (event card / combat; may give +1 `var.bulbs_recovered` if the Wenna line is active) | Starving wolves (combat: 4 wolves) | Frost troll under an ice bridge (combat: 1 frost troll) |
| 4 | Marnadal Watch deserter selling stolen gear (shop card; starts the Marnadal Watch hook) | Charcoal burners saw hooded monks (discovery: map pin Vel Aram or Rozrog) | Wyvern circling (event card; requires the Roost unresolved) |
| 5 | Sodden spy as a tinker (event card, Wits 6; starts the Brzezina hook) | Drowner ambush in shallows (combat: 3 drowners) | Dwarven ghost pointing at a cairn (discovery once: `clue.cairn_marker`, a hidden cache) |
| 6 | Harvest supper: safe beds and news (full heal, +1 rumor) | Wenna's one-eyed crow (discovery: hint toward the current Wenna objective) | Choir rear-guard ambush on a switchback (combat: 2 zealots + 1 sharpshooter) |
| 7 | Highwaymen led by a disgraced knight (combat: 4 bandits, or a Presence 7 duel challenge) | Woodwose totems (discovery: starts the Rozrog hook) | Roadside shrine with a carved Oath line (discovery: `clue.shrine_oath_line`) |
| 8 | **Escalation:** crops withered in a dead-straight line toward Amell | **Escalation:** the river runs thick and black with soot | **Escalation:** every lantern and campfire burns cold blue |

**Escalation pools** (used by d8 = 8 and by the escalation rule):

| Terrain | Pool |
|---|---|
| Lowlands | `esc.l_withered_line` (story 8; lore card), `esc.l_feather_proclamations` (combat: 3 Choir zealots nailing proclamations), `esc.l_refugee_column` (event card: share supplies for Crown +5, or pass) |
| Valley | `esc.v_black_river` (story 8; lore card, Chill), `esc.v_drowner_swarm` (combat: 5 drowners), `esc.v_blight_wagon` (combat: 2 zealots guarding a burning blight-cask wagon; fire hazard) |
| Mountain | `esc.m_blue_fires` (story 8; campfires give no warmth during this journey's arrival zone), `esc.m_tremor` (hazard Grit 7), `esc.m_stray_warden` (combat: 1 iron-warden, stage 4 only) |

**Tests:** route choice is deterministic. The encounter roll is reproducible from the seed. The escalation rule applies only at stage ≥ 2. Requirement-gated entries are never returned.

### 6.4 Combat

Combat runs in real time inside zones and arenas. Domain logic owns the numbers and state machines. Presentation owns hitboxes, animation and physics (`architecture.md` §3.2).

**Player action states:** `idle`, `move`, `sprint`, `attack_light(n)`, `attack_heavy(charge)`, `block`, `parry_window`, `dodge`, `kick`, `aim`, `reload`, `use_item`, `stagger`, `guard_broken`, `downed`, `dead`. Transitions are a data-driven table, so the rules below are testable without the scene tree.

**Moveset** (Normal difficulty; times in seconds as startup / active / recovery):

| Action | Stamina | Damage mult | Poise dmg | Timing | Notes |
|---|---|---|---|---|---|
| Light 1 / 2 / 3 | 12 each | 1.0 / 1.0 / 1.3 | 10 / 10 / 18 | 0.25/0.10/0.30 | Chains if pressed during recovery. The third hit ends the chain |
| Heavy (tap) | 30 | 1.8 | 35 | 0.55/0.15/0.45 | — |
| Heavy (full charge 1.0 s) | 30 | 2.6 | 60 | charge + 0.20/0.15/0.45 | Charging can be held up to 1.5 s |
| Block (hold) | 0.6 × incoming dmg per hit | — | — | — | Mitigation = weapon `block_pct` (swords 70%, axes 60%, maces 65%, greatsword 80%). At 0 stamina, `guard_broken` for 1.2 s |
| Parry | 0 | — | — | window 0.18 s after block press | The hit is negated, the attacker staggers 1.0 s, and a riposte window opens for 1.2 s |
| Riposte | 12 | 2.5 (crit) | 40 | light attack during the window | — |
| Dodge | 25 | — | — | 0.45 total, i-frames 0.08–0.33 | Rolling puts out Burning |
| Sprint | 8 / s | — | — | — | — |
| Kick | 15 | 0.3 | 25 | 0.20/0.10/0.35 | Breaks enemy block. Pushes enemies 1.5 m |
| Crossbow shot | 0 | bolt 22 pierce | 15 | aim ≥ 0.3 s | Reload 1.4 s (Quick Reload perk −40%). Holds 1 bolt, max 20 carried. Knocks down flying enemies on weak-point hits |
| Quick item | 0 | — | — | 1.0 s, interruptible | 4 quick slots |

**Stamina:** max = 85 + 5 × Agility. After 0.8 s without spending stamina it regenerates at 30 / s (15 / s while blocking). At 0 the player is **exhausted** and cannot attack, dodge or sprint until stamina is back to 20.

**Health:** no regeneration in combat. It is restored by consumables, a camp or safehouse rest (full), or a level-up (full).

**Damage formula** (`DamageCalculator`, tested):

```
offense   = weapon.base * attack.mult * (1 + 0.06 * (attacker.governing_attribute - 3))
armor_eff = max(0, defender.armor - weapon.armor_pen)
mitigate  = 100 / (100 + armor_eff)
resist    = defender.resist[damage_type]      # 1.0 = neutral, 0.5 resist, 1.5 weak, 0 immune
crit      = 2.5 riposte | 1.5 backstab | 1.25 vs staggered | 1.0
tag_bonus = weapon.bonus_vs[tag] or 1.0       # e.g. Mane-Cleaver 2.0 vs construct
block     = (1 - block_pct) if blocked else 1.0
final     = max(1, round(offense * mitigate * resist * crit * tag_bonus * block * difficulty.damage_taken_mult_if_player_is_defender))
```

The governing attribute is Might for melee and Agility for the crossbow. Only the highest crit multiplier applies.

**Damage types:** `slash`, `pierce`, `blunt`, `fire`, `cold`, `poison`.

**Poise:** every combatant has a poise meter (the player has 40). Hits subtract poise damage. At 0 the target staggers for 1.5 s (player: 0.8 s). Poise regenerates fully 2.0 s after the last hit. Enemies tagged `heavy` ignore stagger from hits below 25 poise damage.

**Status effects:**

| Status | Rule |
|---|---|
| Poison | 2 dmg / s for 8 s. Stacks up to 3. Cured by an antitoxin draught |
| Burning | 5 dmg / s for 4 s. Ended by dodging or water |
| Bleed | Builds up 0–100 from `slash` bleed values. At 100 it bursts for 15% max HP and resets |
| Chill | A cold-zone meter from 0 to 100 that rises outside warmth (braziers, campfires) by `zone.cold_rate` / s. At 100: −5 HP / s and −20% stamina regen. Strept furs halve the rate |
| Soot | Inside the Ash-Bound Zealot's cloud: 3 dmg / s, darkened vision vignette **[ART]** |

**Attack tokens:** at most N enemies may run a melee attack on the player at once (Story 1, Normal 2, Hard 3). The others circle, block, or use ranged attacks. Bosses ignore tokens.

**Lock-on:** optional. It cycles the nearest visible targets. Camera behavior is **[ART]**.

**Non-lethal resolution:** human enemies at ≤ 20% HP may **yield** (data flag `can_yield`), and the player may spare or execute them. Some dialogue lets a fight be skipped entirely. A fight skipped through dialogue awards the same XP as winning it.

### 6.5 Stealth (light)

Stealth exists for the Attre masquerade and warehouse, the Hanged Man's Oak courier ambush, the Abbey scriptorium ledgers, and the Varn chase.
- Crouching halves movement noise and speed.
- NPC guards have a vision cone (90°, 12 m; 6 m in darkness) and a **suspicion meter** from 0 to 100. It fills at 40 / s in full view (×0.5 crouched, ×0.5 in shadow) and drains at 10 / s. At 50 the guard investigates the last seen position. At 100 the guard raises an alarm and the zone's `alarm` branch fires.
- **Takedown** from behind while the guard is unaware: non-lethal, 1.5 s.
- **Disguise** items (masquerade invitation, Choir robe) make the player "permitted" in zones tagged with that disguise. Suspicion builds only on restricted actions: trespassing a restricted area, combat, or picking locks.

### 6.6 Actors and stats

**Attributes:** Might, Agility, Grit, Wits, Presence. Each starts at 3. At creation the player adds 4 points (no attribute above 6). The absolute maximum is 10. One attribute point is gained at levels 3, 5, 7, 9 and 11.

| Derived | Formula |
|---|---|
| Max HP | 80 + 15 × Grit + 8 × (level − 1) |
| Max stamina | 85 + 5 × Agility |
| Melee damage mod | +6% per Might above 3 (−6% per point below) |
| Crossbow damage mod | +6% per Agility above 3 |
| Poison / cold resist | 5% × Grit |
| Armor | sum of equipped armor values |

**Dialogue checks** use attributes (§6.10) plus perk and item bonuses.

**Enemies** use fixed stat blocks from data (§6.7). They do not use attributes.

### 6.7 Enemy archetypes

Stat blocks are at Normal difficulty. `L` is the design level band. `R` marks resistances (slash/pierce/blunt/fire/cold/poison); "w" means weak (1.5), "r" means resist (0.5), "i" means immune.

| id | Name | L | HP | Dmg | Armor | Poise | R | Tags | Behavior |
|---|---|---|---|---|---|---|---|---|---|
| `enemy.choir_thug` | Choir thug | 1 | 45 | 8 blunt | 5 | 20 | — | human, can_yield | Approaches, 2-hit combo, flanks in pairs |
| `enemy.choir_cutthroat` | Dockside cutthroat | 2 | 35 | 7 slash + bleed 20 | 0 | 15 | — | human, can_yield | Fast. Dodges back after attacking |
| `enemy.choir_crossbowman` | Choir crossbowman | 2 | 35 | 14 pierce (ranged) | 5 | 15 | — | human, can_yield | Keeps 8–14 m away. Retreats when the player is within 4 m |
| `enemy.bandit` | Bandit / smuggler / highwayman | 3–6 | 55–90 | 10–16 | 10–20 | 25 | — | human, can_yield | Variants (sword, spear, shield) by data `variant` |
| `enemy.feral_hound` | Tar-maddened hound | 2 | 30 | 7 slash | 0 | 10 | f:w | beast, pack | Circles, then lunges in turns. Does not flee |
| `enemy.choir_assassin` | Choir assassin | 3 | 55 | 16 slash + poison | 5 | 25 | — | human, elite | Smoke vanish (cooldown 12 s), backstabs, throws knives, starts grease fires |
| `enemy.drowner` | Drowner | 5 | 70 | 12 slash | 5 | 30 | f:w, c:r | beast, aquatic | Ambushes from water, drag grab (break it by mashing or a kick) |
| `enemy.wolf` | Starving wolf | 5 | 50 | 10 slash | 0 | 20 | c:r | beast, pack | A howl calls +1 wolf (once per pack) |
| `enemy.revenant_footman` | Marnadal revenant | 6 | 80 | 15 slash | 20 | 35 | p:r, b:w, f:w | undead | Rises again after 6 s unless the last hit was blunt or fire, or `flag.torc_rite_known` |
| `enemy.revenant_rider` | Revenant cavalier | 7 | 140 | 24 pierce (charge) | 25 | 60 | p:r, b:w, f:w | undead, heavy | Charges in a line. Dodge sideways. Same rising rule |
| `enemy.choir_zealot` | Choir zealot | 7 | 90 | 18 slash | 15 | 35 | f:r | human | Fervor buff (+25% dmg at < 50% HP). Self-immolates at 0 HP (fire burst 2 m) |
| `enemy.choir_sharpshooter` | Choir sharpshooter | 9 | 70 | 28 pierce (ranged) | 10 | 25 | — | human | Shoots from ledges. A laser-sight tell 0.8 s before firing **[ART]** |
| `enemy.frost_troll` | Frost troll | 10 | 420 | 35 blunt | 30 | 90 | c:i, f:w | beast, heavy | Slow. Grabs and throws. Regenerates 5 HP / s in Chill zones unless it took fire in the last 5 s |
| `enemy.iron_warden` | Dwarven iron-warden | 11 | 320 | 30 blunt | 80 | 100 | s:r, p:r, b:w, po:i | construct, heavy | Shield bash, rune overload (an AOE after a 1.5 s glow). Its rune core is exposed 3 s after a stagger |
| `enemy.wyvern` | Mountain wyvern (Act II drive-off) | 7 | 600 | 26 slash, tail 18 + poison | 20 | 120 | p:w (wings) | beast, boss, flying | Ground and air phases. A crossbow weak-point hit on a wing during the air phase grounds her for 4 s. Flees at 50% HP |
| `enemy.wyvern_roost` | Wyvern at her roost | 10 | 900 | 34 / tail 24 + poison | 25 | 140 | p:w (wings) | beast, boss, flying | Same moveset plus nest-guard rage. Fought only if the eggs are not returned |
| `enemy.soot_hound` | Chained soot-hound (war-construct) | 8 | 1100 | 32 blunt + soot | 60 | 150 | po:i, f:r | construct, boss | Chain-lunge, soot cloud, and a vent weak point (×2 damage) after a stagger. Mane-Cleaver ×2 |
| `enemy.ash_bound_zealot` | Ash-Bound Zealot (Anselm) | 12 | 2000 | 30 fire / 26 slash slag | 40 | 200 | f:i, po:i | human, boss | Phase 1: soot aura and slag shards. Phase 2 (< 50%): ritual pull toward the throne mechanism. A bellows-lung weak point on his back |
| `enemy.corvan_shade` | Shade of King Corvan (side) | 8 | 700 | 28 slash | 30 | 120 | s:r, f:w | undead, boss | A duel. Respects parries: each parry deals 5% of his max HP |
| `enemy.sea_serpent` | Morrow Gull serpent (side) | 7 | 650 | 30 | 20 | 150 | c:r | beast, boss, aquatic | An underwater arena. Breath meter: 60 s, refilled by air pockets |
| `enemy.woodwose` | Woodwose (side) | 6 | 400 | 28 blunt | 20 | 100 | f:w | beast, heavy | Becomes peaceful if `flag.woodwose_peace` |

Anselm before he transforms (finale) is the NPC `npc.anselm`, combat profile `enemy.anselm_human` (HP 150, armor 5, no melee, smoke and shove).

### 6.8 Progression

**XP needed for level L** (cumulative): `XP(L) = 75 × (L − 1) × (L + 2)`.

| L | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| XP | 0 | 300 | 750 | 1350 | 2100 | 3000 | 4050 | 5250 | 6600 | 8100 | 9750 | 11550 |

Level 12 is the cap. XP above the cap is discarded.

**XP sources** (target split: about 70% non-combat):

| Source | XP |
|---|---|
| Main milestone | Act I 100–250, Act II 250–500, Act III 400–800 (per data) |
| Side quest completion | 200–700 |
| Clue found | 20 (Act I), 30 (Act II), 40 (Act III) |
| Deduction unlocked | 60 / 90 / 120 by act |
| Dialogue check passed | 15 × act number |
| First visit to a zone | 30 |
| Enemy defeated or yielded | per enemy (`enemy.*.xp`: thug 10, cutthroat 10, crossbowman 12, hound 8, bandit 15–30, assassin 25, drowner 20, wolf 15, revenant 35/60, zealot 40, sharpshooter 45, troll 120, warden 150, wyvern 400/800, soot-hound 600, corvan shade 500, serpent 500, woodwose 300) |
| Travel combat | ×0.5 of the enemy XP |

**Budget check (content test):** the XP available in Act I content must be ≥ 1350, in Acts I+II ≥ 5250, and in all content ≥ 11550 × 1.15.

**Level-up:** full heal, +1 skill point (levels 2–12, 11 in total), and +1 attribute point at levels 3, 5, 7, 9 and 11.

**Skill tree:** three branches of six nodes each. A node's tier gate counts points already spent in that branch: tier 1 needs 0, tier 2 needs 2, tier 3 needs 3, and the capstone needs 5. Each node costs 1 point. With 11 points the player can finish at most one branch plus part of another.

| Branch | T1 | T1 | T2 | T2 | T3 | Capstone |
|---|---|---|---|---|---|---|
| **Blade** | `perk.steady_hand`: light attacks cost −20% stamina | `perk.shoulder_charge`: kick becomes a charge (poise 45, 3 m) | `perk.riposte_master`: parry window +0.05 s, riposte ×3.0 | `perk.heavy_swing`: charge time −30%, heavy poise +25% | `perk.iron_skin`: +15 armor | `perk.lions_fury`: staggering an enemy restores 20 stamina and 5% HP |
| **Road** | `perk.quick_reload`: reload −40% | `perk.pathfinder`: encounter chance −15%; once per journey, Wits 5 to avoid a hostile encounter | `perk.field_medic`: healing consumables +50% | `perk.cold_blooded`: Chill rate −50%, cold damage −25% | `perk.hunters_eye`: crossbow weak-point hits ×1.5 | `perk.second_wind`: once per zone, revive at 30% HP instead of dying |
| **Tongue** | `perk.silver_tongue`: +1 to Persuade checks | `perk.hard_stare`: +1 to Intimidate checks | `perk.keen_eye`: +1 to Investigate checks; hidden clues glint **[ART]** | `perk.haggler`: prices −20%, bribes −30% | `perk.read_the_room`: shows NPC disposition and marks rumors' credibility | `perk.kingmaker`: unlocks "Sway" options (each listed in dialogue data). In the finale, 2 Choir bodyguards lay down arms |

### 6.9 Inventory and items

**Categories:** weapons, armor, trinkets, consumables, ammo, key items, documents, crowns (currency).

**Equipment slots:** `main_hand`, `ranged` (crossbow), `armor`, `trinket_1`, `trinket_2`. There is no weight limit. Consumables stack (poultice 10, draught 5, bolts 20). Key items and documents cannot be dropped, sold or destroyed except by scripted effects. **Shops:** Cintra Market, Tigg inn, Attre harbor, Assengard forge, Dun Strept. Selling pays 25% of the buy price.

**Starting gear:** an arming sword (`item.arming_sword`: 12 slash, block 70%), a gambeson (armor 10), a crossbow with 8 bolts, 2 poultices (heal 40 over 2 s), 30 crowns.

**Key items and documents:**

| id | Name | Source | Use |
|---|---|---|---|
| `item.dravin_letter` | Dravin's iron-wax dispatch | The courier, Drowned Rat | Shown at Audience (Kosk hires you). Proves the Ostrel threat to Dravin and Hesk |
| `item.kosk_writ` | Marshal's writ | Audience | Opens palace areas. Comes with the Marshal's badge (`item.kosk_badge`, a trinket): worn, it gives +2 to checks with Crown officials and −2 to checks against Strept speakers (§6.10; condition `equipped(item.kosk_badge)`) |
| `item.false_fourth_verse` | Anselm's "copy" | Abbey | Compared at the Ring of Nine, it gives `ded.anselm_lied` |
| `item.pale_feather` | Pale gull feather | Fair assassin, Choir bodies | Clue. Part of the Choir disguise (with `item.choir_robe`) |
| `item.route_map_oak` | Route map to Hanged Man's Oak | Fair assassin | Unlocks the Hanged Man's Oak node |
| `item.varn_ledger_scrap` | Half-burned toll ledger | Varn chase | Blackmail Varn (`flag.varn_blackmailed`) or turn him in |
| `item.anselm_cipher` | Anselm's cipher | Hanged Man's Oak | Proof (combined with the ledger). Decodes Choir orders |
| `item.forged_dispatch` | Forged Choir dispatch | Hanged Man's Oak (Wits 6) | Plant it to send Choir guards away from Vel Aram (fewer acolytes) |
| `item.marnadal_torc` | Bronze-and-iron torc | Marnadal Field champion | Given to Hesk, it wins Strept |
| `item.grey_lily_bulbs` | Wenna's bulbs (count in `var.bulbs_recovered`, 0–6) | Attre warehouse, Gull Tower cellar (+2), event card (+1) | Returned to Wenna for the antidote |
| `item.wenna_antidote` | Grey lily counter-dose | Wenna | See §6.2 |
| `item.raimund_ledger` | Raimund's private shipping ledger | Attre | Proof (with the cipher). Leverage over Raimund |
| `item.masquerade_invitation` | Masquerade invitation | Bertha (safehouse), Jory, forger in Attre | Disguise for the Attre masquerade |
| `item.anselm_journal` | Anselm's private journal | Vel Aram | Proof of treason on its own |
| `item.true_fourth_verse` | The authentic fourth verse | Vel Aram | Required for the True Oath |
| `item.kosk_apology` | Kosk's written apology and blood-price | Kosk (Act III, Presence 7 or `ded.marnadal_truth`) | The alternative to the torc for Hesk |
| `item.iron_key` | The Iron-Key of Ostrel | Dravin (joins with it) | Opens the Weeping Gate. Applies the gear-brake in the finale |
| `item.wyvern_eggs` | Two wyvern eggs | Vel Aram reagent store | Returned at the Roost, the wyvern carries you across |
| `item.choir_list` | Full Choir membership list | Abbey scriptorium (side) | `flag.choir_list_exposed`: protects Maelis and the rider; −2 finale bodyguards |
| `item.taster_dispatch` | Watertight dispatch tube | Morrow Gull (side) | `flag.food_taster_exposed` |
| `item.ysolde_hair` | Lock of the Queen's hair | Sickroom (with Kosk's leave, Presence 5) | Wenna's Hut side quest |
| `item.mane_cleaver` | Mane-Cleaver | Barrows (side) | Greatsword: 30 slash, block 80%, ×2.0 vs `construct` |
| `item.choir_robe` | Choir robe | Vel Aram, Hanged Man's Oak courier | Disguise for Choir zones |

**Consumables:** poultice (heal 40), field draught (heal 80, Act II+ shops), antitoxin (cures poison, grants immunity for 30 s), fire oil (weapon deals fire for 60 s), frost-tallow (Chill rate −50% for one zone visit), smoke pot (breaks enemy sight for 6 s).

### 6.10 Dialogue

Dialogue is a directed graph authored in content (`content-format.md` §D). Game time stops during dialogue.

**Node types:** `line` (speaker, text, next), `choice` (a list of options), `check` (attribute check with pass/fail branches), `branch` (the first true condition wins), `effect` (applies effects, then moves on), `end`.

**Option tags** shown to the player: `[Persuade 6]`, `[Intimidate 5]`, `[Investigate 5]`, `[Lore 6]`, `[Bribe 50]`, `[Item: Iron-Key]`, `[Clue: Chalice pollen]`, `[Sway]`.

**Check rules** (deterministic; there are no dice):
- Persuade: Presence + perk bonuses + item bonuses + `rep_mod`.
- Intimidate: max(Might, Presence) + perk bonuses + `rep_mod`. −2 against Strept when `kosk_badge_worn`.
- Investigate: Wits + bonuses. Lore: Wits + 2 if Maelis is in the party.
- `rep_mod`: +1 if the speaker's faction is Friendly, +2 if Allied, −1 Wary, −2 Hostile.
- Pass if total ≥ DC. DC scale: 4 easy, 6 medium, 8 hard, 10 legendary.
- A failed check locks that option for the rest of the conversation. Options marked `once` stay locked for good.
- A **Bribe** option is visible only if the player has at least the cost (after Haggler). Paying always succeeds.
- Hidden options: an option whose condition is false is hidden unless it is marked `show_locked`. Then it is shown greyed out with its requirement, to signal that more is possible.

**Effects** use the shared effect list (`content-format.md` §E): flags, items, reputation, XP, quests, clues, combat start, zone change, companions, rumors.

### 6.11 Quests, journal and investigation

**Quest model:** each quest has ordered **stages**. Each stage has one or more **objectives** with a completion condition. A stage completes when all its required objectives are complete (optional objectives give extra XP). Stages may fork (`next` chosen by condition). Quest outcomes: `completed`, `failed`, `abandoned` (a side quest closed by escalation or an act change, if its data lists `closes_on`).

**Main quests:**
- `quest.main_a1` *Ashes in the Lion's Den*: stages follow §7.1.
- `quest.main_a2` *The Marnadal Road*: three parallel required objectives (the antidote line resolved, proof of treason, the true verse) and seven trackable leads.
- `quest.main_a3` *Under Amell*: follows §7.3.

**Side quests (12)** are listed in §7.4 with their availability and payoffs.

**Journal tabs:** Quests, Investigation (the board), People, Places, Rumors, Signs (escalation history), Bestiary.

**Investigation board:** `clue.*` entries are pinned to **theories**. A clue can `support` or `refute` a suspect in a theory. A **deduction** (`ded.*`) unlocks automatically when its clue condition holds. It gives XP, a journal line and a flag that dialogue can test.

| Theory | Suspects | Key clues | Deductions |
|---|---|---|---|
| Who is poisoning the Queen? | Varn, Pell (food-taster), Anselm, Raimund | `clue.courier_foam`, `clue.chalice_pollen`, `clue.taster_gold`, `clue.varn_ledgers`, `clue.gull_bulbs`, `clue.raimund_ledger_silver`, `clue.queen_knows_vaults` | `ded.varn_thief_not_poisoner` (varn_ledgers), `ded.poison_via_attre` (chalice_pollen and gull_bulbs, or raimund_ledger_silver), `ded.taster_is_bought` (taster_gold, or taster_dispatch) |
| What happened to the Fourth Verse? | Anselm, "vandals" | `clue.book_sliced`, `clue.only_anselm_key`, `clue.ring_true_chisel`, `clue.shrine_oath_line` | `ded.anselm_lied` (false verse held and ring_true_chisel) |
| Who are the Pale Choir? | — | `clue.pale_feather`, `clue.route_map_oak`, `clue.anselm_cipher`, `clue.jory_iron_crates`, `clue.choir_at_vel_aram` | `ded.choir_exists` (feather and route_map), `ded.choir_muster_vel_aram` (cipher or jory_iron_crates) |
| What does Anselm want? | — | `clue.anselm_journal`, `clue.reversed_oath`, `clue.marnadal_chaplain`, `clue.vault_command_rite` | `ded.anselm_treason_proven` (journal, or cipher and raimund_ledger), `ded.reversed_oath_plan` (reversed_oath) |

### 6.12 Factions and reputation

Reputation per faction ranges from −100 to +100. **Tiers:** Hostile ≤ −50, Wary −49 to −10, Neutral −9 to +9, Friendly +10 to +49, Allied ≥ +50.

| id | Faction (leader) | Start | Gains | Losses | Tier effects |
|---|---|---|---|---|---|
| `faction.crown` | Crown / Lord Marshal Kosk | 0 → +15 at Audience | Saving Aldric, exposing the taster, Marnadal Watch | Siding with Raimund's independence, selling the antidote | Friendly: palace access, Kosk's apology possible. Allied: Kosk's cavalry can join the finale (with the Marnadal Watch signal) |
| `faction.varn` | Chancellor Varn | 0 | Keeping his secret, blackmail deals | Exposing him to Kosk | Friendly: 150 crowns in funds and an Act II pass on the toll road. Hostile: court guards harass you in the Cintra hub (+1 thug ambush on the first hub visit after stage 1) |
| `faction.attre` | Duke Raimund | 0 | Blackmail turned into an alliance, selling him the antidote | A loud warehouse raid, publishing the ledger | Allied: no fortification at stage 3, the ledger is handed over, and the Bitter Bargain epilogue variant |
| `faction.strept` | Hesk Ironjaw | −10 | Torc, apology, Marnadal Field rites, Silver Mine | Kosk badge, killing clan scouts | Friendly: guides (`flag.strept_guides`). Allied: war-band in the Stairs and the finale |
| `faction.ferrymen` | "Ninefingers" Jory | 0 | Bribes, a deal, clearing Bertha's debt by negotiating | Intimidating Jory, killing ferrymen | Friendly: free crossing, rider escort. Allied: a barge route to Attre (opens the edge) |
| `faction.choir` | Pale Choir | −30 → −60 after the Drowned Rat | — (a disguise does not change reputation) | — | Always Hostile. Used for event weighting only |
| `faction.abbey` | Abbey / Sister Maelis | +10 | Protecting Maelis, the scriptorium quest | Accusing Maelis, burning the library | Friendly: Maelis can join. Allied: Maelis reads the throne runes in the finale |
| `faction.wenna` | Old Wenna | −10 | Returning bulbs, her crow's errands, the hair quest | Lying to her, stealing from the mere | Friendly with all 6 bulbs: 2 doses. Hostile: she brews 1 dose only if `var.bulbs_recovered ≥ 3` |

Reputation changes come only through effects (`add_rep(faction.x, n)`). The UI shows a +/− toast. Tier crossings emit `ReputationTierChanged`.

### 6.13 Companions

Only one **combat companion** is active at a time. **Scripted allies** join specific encounters.

| id | Companion | Availability | Role in combat | Field ability | Notes |
|---|---|---|---|---|---|
| `companion.maelis` | Sister Maelis | Act I end (Abbey Friendly, or the scriptorium quest done) through Act III | Support: a sling (6 pierce, knocks back), throws a poultice at the player below 30% HP (cooldown 45 s) | +2 Lore. Reads dwarven runes (opens rune doors in Karak Ostrel) | Can be poisoned (§6.2). In the finale: Aldric's verse channel −20% if Abbey is Allied |
| `companion.dravin` | Dravin Ostrel | Act II (Assengard, needs `ded.anselm_treason_proven`) or Act III | Tank: a hammer (20 blunt), draws aggro, shield wall when the player is downed | Opens dwarven doors, carries the Iron-Key, counts as mountain guides | In the finale he holds the gear-brake (§6.14) |
| `ally.strept_warband` | Hesk's war-band (4 highlanders) | Act III if Strept is Allied | Scripted squad in the Stairs segments and outside Ostrel | — | Finale: −2 bodyguards |
| `ally.aldric` | Prince Aldric | Fair (escort), finale (defend) | Escort NPC, HP 200. When downed he must be revived within 20 s | — | If Aldric dies at the Fair or in the finale: game over, reload |
| `ally.kosk_cavalry` | Kosk's heavy horse | Finale only, if `flag.watch_signal_lit` and Crown ≥ Friendly | One cavalry charge event that kills the first reinforcement wave | — | — |
| `ally.forest_guide` | Silent forest guide | After Rozrog | Travel modifier only (§6.3) | — | — |
| `ally.wyvern` | The wyvern | After returning the eggs | Transport only (skips `zone.roost_chasm_climb`) | — | — |

**Companion AI:** follow at 3 m, engage the player's target or the nearest threat, and obey simple commands (hold position / follow / focus my target) from a radial menu. At 0 HP a companion is **downed** and can be revived by holding Interact for 2 s within 30 s. Otherwise the companion retreats for the rest of the zone and returns at the next zone. There is no permanent death except the scripted Maelis poisoning.

### 6.14 The finale ritual meter (real-time combat timer)

The Lock Chamber fight is the only place where real time drives an outcome.

**State:** `reversed_verses` 0–4 (the "candles out" count), `true_verses` 0–4, `aldric_state` ∈ {held, freed, channeling, downed}, `anselm_state` ∈ {human, zealot, dead, fled}.

**Rules:**
1. When the fight begins, Anselm holds Aldric at the throne. The **reversed timer** starts: one reversed verse completes every `T_rev` seconds (Normal 50 s; Story 70 s; Hard 40 s). The gears grind, steam vents erupt (hazards), and the vault door opens a step **[ART]**.
2. The reversed timer keeps running for the whole fight, whatever happens to Anselm. The machinery has momentum. Modifiers: **Dravin's gear-brake** (Dravin present and the player holds `item.iron_key`) multiplies `T_rev` by 1.25.
3. **Freeing Aldric:** once the bodyguards within 5 m of the throne are down (base 6 bodyguards: zealots and sharpshooters; −2 for the war-band, −2 for `flag.choir_list_exposed`, −2 for Kingmaker, minimum 2), the player can **Free Aldric** (hold Interact 1.5 s). Anselm is shoved away and becomes a combatant.
4. **True verses:** a freed Aldric channels one true verse at a time, taking `T_true` seconds each (Normal 20 s; −20% if Maelis is present and Abbey is Allied). If Aldric is hit, the current verse's progress resets to 0. Verse 4 needs `item.true_fourth_verse`. Without it, Aldric cannot finish (the game prevents this case with the Act II gate).
5. **Transformation:** when `reversed_verses` reaches 3 and Anselm is alive, he inhales the vented fumes and becomes the **Ash-Bound Zealot** (full HP boss).
6. **Win (True Oath):** `true_verses` reaches 4 before `reversed_verses` reaches 4. The vault locks, the reversed timer stops, and any remaining enemies collapse or flee.
7. **Loss (Reversed Oath finished):** `reversed_verses` reaches 4 first. The vault ruptures and an **aftermath** phase begins: the Zealot (if alive) fights on. At 25% HP he retreats toward the breach and the player gets a prompt: **Pursue Anselm** (finish him: `anselm_state = dead`) or **Shield Aldric** (the vent collapse would crush the boy; Anselm escapes: `anselm_state = fled`). If Anselm was already dead, the aftermath is a 60 s escape sequence.
8. **Seize the Vault:** after Aldric is freed and before `true_verses` reaches 1, if `clue.vault_command_rite` is known and Dravin is present, the throne offers **Command the Vault**. Choosing it requires Aldric's cooperation: a Persuade 8 check, or an Intimidate 7 check that sets `flag.aldric_coerced`. It ends the fight with `finale.vault_seized = true`.
9. Killing Anselm in human form before stage 3 is allowed. He never transforms, and the meter keeps running.
10. If the player dies, they reload the pre-finale checkpoint.

The meter is shown as four candles in the HUD **[ART]** (the four candles of the story, as a diegetic UI motif).

### 6.15 Endings resolver

`EndingResolver.resolve(facts) -> ending_id` is a pure function, checked in this order (the first match wins):

| # | Ending | id | Condition |
|---|---|---|---|
| 1 | The Bitter Bargain | `ending.bitter_bargain` | `finale.vault_seized` |
| 2 | The Shattered Lock | `ending.shattered_lock` | `finale.oath == reversed and finale.anselm == dead` |
| 3 | Ashes & Iron | `ending.ashes_and_iron` | `finale.oath == reversed and finale.anselm == fled` |
| 4 | The Lion Holds | `ending.lion_holds` | `finale.oath == true and flag.queen_alive` |
| 5 | The Boy King | `ending.boy_king` | `finale.oath == true and not flag.queen_alive` |

`finale.oath` ∈ {true, reversed, none}. If it is `none` (vault seized), only ending 1 can apply. The resolver must fail an assertion on any fact combination that matches no ending; a unit test enumerates all combinations.

**How each ending is reached through choices and outcomes:**
- Lion Holds: the antidote reaches the Queen (rider sent at stage ≤ 2, or carried, or escorted), and the ritual is won.
- Boy King: the antidote is lost (rider intercepted, given to Maelis, sold to Raimund, or no bulbs recovered), and the ritual is won.
- Shattered Lock: the ritual is lost, and the player pursues Anselm (or killed him earlier).
- Ashes & Iron: the ritual is lost, and the player shields Aldric while Anselm escapes.
- Bitter Bargain: the player finds the command rite in the Drowned Library, brings Dravin, and chooses to command the vault.

**Epilogue variants** (slides **[ART]**) are chosen by extra flags: Strept peace (`faction.strept ≥ Friendly`), Attre independence (`faction.attre < Allied` and not `flag.raimund_allied`), Varn's fate, Maelis alive, `flag.aldric_coerced`, Sodden flank (`flag.brzezina_plot_exposed`).

### 6.16 Save and load

- **Slots:** 1 quick slot, 3 manual slots, and 3 rotating autosaves.
- **Autosave** on zone entry, before bosses and finale phases (checkpoint markers in zone data), after act transitions, and after each escalation stage-up.
- Manual saving is allowed anywhere outside combat, dialogue and active alarms.
- **Format:** JSON in `user://saves/<slot>.json` with `save_version`, `content_version`, a timestamp, the current zone and spawn, an RNG seed and state, and one section per domain (`architecture.md` §4.12). Writes are atomic (write to a temp file, then rename). Older versions are migrated step by step.
- Loading rebuilds the domain state, then the presentation reloads the zone at the saved spawn. Enemies killed in the current zone visit are not saved, so a zone resets to its post-milestone state.

### 6.17 Difficulty and accessibility

| Setting | Story | Normal | Hard |
|---|---|---|---|
| Damage taken | ×0.5 | ×1.0 | ×1.4 |
| Attack tokens | 1 | 2 | 3 |
| Parry window | 0.25 s | 0.18 s | 0.12 s |
| Finale `T_rev` / `T_true` | 70 / 16 s | 50 / 20 s | 40 / 22 s |
| Enemy HP | ×0.8 | ×1.0 | ×1.2 |

Difficulty can be changed at any time from the pause menu.

**Accessibility:** full input rebinding for keyboard and gamepad. Hold or toggle for block, sprint, crouch and aim. Subtitles on by default, with speaker names, size S/M/L/XL and a background box. UI scale from 80% to 150%. Screen shake and camera bob sliders, down to 0. Flash reduction (it caps the intensity of soot and steam VFX). Colorblind-safe cues: every color cue also has an icon or shape. Audio cues for parry windows and enemy wind-ups (a "tell" sound). Pause anywhere outside cutscenes. An option to skip non-boss combat encounters (Story difficulty only).

### 6.18 Death and failure states

- **Player death:** a "You fell" screen, then reload from the last checkpoint or autosave.
- **Escort death** (Aldric at the Fair or in the finale): game over, reload.
- **Soft failures** never block progress. They close branches: an Attre alarm makes the raid loud (bulbs may burn), a lost Varn chase means no blackmail (`clue.varn_ledgers` can still be found later through Rumor 2 and a Wits 6 search of his solar), a failed Hanged Man's Oak ambush means the courier escapes and the cipher must be bought from Jory (Ferrymen ≥ Neutral, 120 crowns).
- **Hard gates** always have at least one path that can't be failed. A content test checks this (`architecture.md` §7.3).

---

## 7. Structure: zones and scenes per act

Zone ids are `zone.<snake_case>`. **Hub** marks a zone that connects to other zones without the map. Each section below corresponds to one content file in `docs/content/`.

### 7.1 Act I: Ashes in the Lion's Den (Levels 1–4)

| # | Content file | Zones | Summary | Milestones set |
|---|---|---|---|---|
| 1 | `act1/01-drowned-rat.md` | `zone.drowned_rat`, `zone.cintra_mudflats`, `zone.cintra_docks` | The courier dies with Dravin's letter. Three Choir thugs arrive when the player reads the letter or tries to leave. Fight in the tavern, or flee through the cellar and across the mudflats (the tide rises behind each checkpoint) | `ms.a1_rat_survived` |
| 2 | `act1/02-audience-at-court.md` | `zone.cintra_streets` (hub), `zone.palace_hall` | Kosk hires you (gives `item.kosk_writ`). Varn protests. Anselm offers the Abbey's library. Includes the note that the passes are closed and Ostrel won't open until Cintra's crisis is solved | `ms.a1_audience_done` |
| 3 | `act1/03-sickroom-red-herring.md` | `zone.palace_sickroom`, `zone.palace_kitchens`, `zone.chancellery_rooftops` | Chalice pollen, Pell's gold, and Varn burning ledgers at midnight followed by a rooftop chase | `ms.a1_sickroom_done` |
| 4 | `act1/04-abbey-st-corwen.md` | `zone.abbey_st_corwen` | Maelis shows the sliced book. Anselm gives the false verse. Maelis whispers that only Anselm holds the vault key | `ms.a1_abbey_done` |
| 5 | `act1/05-ring-of-nine.md` | `zone.ring_of_nine` (night) | The split monolith weeping tar. Feral hounds. Comparing the chiseling exposes the lie | `ms.a1_ring_done` |
| 6 | `act1/06-gull-tower.md` (optional) | `zone.gull_tower`, `zone.gull_tower_cellar` | The keeper murdered by Attre smugglers. Crates of grey lily bulbs (+2 bulbs if the player later returns them to Wenna) | `ms.a1_gull_done` |
| 7 | `act1/07-harvest-fair.md` | `zone.chociebuz_fair` | Escort Aldric. Assassins start a grease fire. Capture or kill the assassin; feather and route map | `ms.act1_complete` |

**Act I gate (opening the Fair):** `ms.a1_audience_done` and at least two of {`ms.a1_sickroom_done`, `ms.a1_abbey_done`, `ms.a1_ring_done`}. Kosk then announces the ride to the Fair. Starting the Fair is a confirmed **point of no return** for Act I beats 3–5 (the UI warns that unfinished leads will close). Gull Tower stays open until stage 2.

**Act I transition:** Kosk sends the player south. Aldric stays in Cintra. The map unlocks the valley nodes and Attre. Escalation stage → 1.

### 7.2 Act II: The Marnadal Road (Levels 5–8), open sandbox

| # | Content file | Zones | Main milestone | Outputs |
|---|---|---|---|---|
| 1 | `act2/01-tigg-crossroads.md` | `zone.tigg_village`, `zone.tigg_pastures` | `ms.a2_tigg_resolved` (wyvern driven off) | `clue.wyvern_eggs_stolen`, rumor of monks heading south |
| 2 | `act2/02-hanged-mans-oak.md` | `zone.hanged_mans_oak` | `ms.a2_cipher_taken` | `item.anselm_cipher`, optional `item.forged_dispatch`, `clue.choir_at_vel_aram` |
| 3 | `act2/03-ferrymen-camp.md` | `zone.ferrymen_camp` | `ms.a2_jory_dealt` | `clue.jory_iron_crates`, `flag.jory_crossing_granted` |
| 4 | `act2/04-marnadal-field.md` | `zone.marnadal_field` (the night of the new moon is a camp choice, not a clock) | `ms.a2_torc_taken` | `item.marnadal_torc`, `flag.torc_rite_known` |
| 5 | `act2/05-witchs-mere.md` | `zone.witchs_mere` | `ms.a2_wenna_line_resolved` (doses brewed or the line failed) | `item.wenna_antidote` ×0–2 |
| 6 | `act2/06-attre.md` | `zone.attre_harbor` (hub), `zone.attre_masquerade`, `zone.attre_warehouse` | `ms.a2_attre_ledger` | `item.raimund_ledger`, bulbs, `flag.raimund_allied` (optional) |
| 7 | `act2/07-vel-aram.md` | `zone.vel_aram_outer`, `zone.vel_aram_sanctum`, `zone.vel_aram_vault` (soot-hound) | `ms.a2_vel_aram_cleared` | `item.anselm_journal`, `item.true_fourth_verse`, `clue.reversed_oath`, `item.wyvern_eggs`, `item.choir_robe` |
| 8 | `act2/08-return-and-twist.md` | `zone.palace_sickroom` (twist variant), `zone.abbey_catacombs` | `ms.act2_twist` | Antidote resolution (§6.2). Aldric and Anselm are gone. Track them through the catacombs (a short fight) |
| — | (optional in Act II) `act3/03-assengard.md` | `zone.assengard` | — | Dravin joins early if `ded.anselm_treason_proven` |

**Act II gate (unlocks "Return to Cintra"):** `ms.a2_wenna_line_resolved` **and** `ded.anselm_treason_proven` **and** `has_item(item.true_fourth_verse)`. The story says "Wenna's antidote". The game requires the antidote line to be **resolved** instead, so that failing the Wenna or Attre line leads to the Boy King ending rather than a soft-lock.

### 7.3 Act III: Under Amell (Levels 9–12)

| # | Content file | Zones | Summary |
|---|---|---|---|
| 1 | `act3/01-race-south.md` | Map with a route choice | Direct ascent (Marnadal Stairs: the extra Choir ambush segment is forced, no guides) or through Dun Strept first (guides and war-band, no forced ambush) |
| 2 | `act3/02-dun-strept.md` | `zone.dun_strept` | Hesk demands the torc or Kosk's apology. The standing stone confirms the verse (`clue.standing_stone_verse`). The war-band joins |
| 3 | `act3/03-assengard.md` | `zone.assengard` | Dravin joins with the Iron-Key once shown proof. He tells of the Weeping Gate |
| 4 | `act3/04-marnadal-stairs.md` | `zone.stairs_switchbacks`, `zone.stairs_rope_spans`, `zone.stairs_ice_bridges` | Blizzard (Chill), sharpshooters, frost trolls |
| 5 | `act3/05-wyverns-roost.md` | `zone.wyverns_roost`, `zone.roost_chasm_climb` | Return the eggs (she carries you across) or fight her. Otherwise climb the collapsed chasm |
| 6 | `act3/06-karak-ostrel.md` | `zone.ko_weeping_gate`, `zone.ko_forge_of_echoes`, `zone.ko_drowned_library`, `zone.ko_bridge_nine_anvils`, alt. `zone.ko_lower_halls` | Rune traps, zealots, iron-wardens. The Drowned Library holds `clue.vault_command_rite` (Lore 7, or Maelis present) |
| 7 | `act3/07-lock-chamber.md` | `zone.ko_lock_chamber` | The finale (§6.14). Endings (§6.15) |

**Karak Ostrel entry:** the Weeping Gate needs `item.iron_key` and access to the upper ridge (the wyvern, or `zone.roost_chasm_climb`). **Or** the Lower Halls breach through the Silver Mine side quest (no key is needed for entry, but the inner bulkhead into the Forge of Echoes needs Dravin or Maelis's rune reading).

### 7.4 Side quests (12)

| id | Content file | Location node | Window | Payoff |
|---|---|---|---|---|
| `quest.side_barrows` | `side/barrows-old-kings.md` | `barrows` (lowlands) | Act I – II | `item.mane_cleaver` (after the Corvan's shade duel or a Lore 6 parley) |
| `quest.side_morrow_gull` | `side/wreck-morrow-gull.md` | `morrow_gull` (via Attre, needs a boat) | Act II | `item.taster_dispatch` → `flag.food_taster_exposed` |
| `quest.side_skerra` | `side/isle-of-skerra.md` | `isle_skerra` | Act II | Smuggler's cutter: opens the `cintra—attre` sea edge and bypasses the stage 3 fortification |
| `quest.side_silver_mine` | `side/silver-mine.md` | `silver_mine` (near Dun Strept) | Act II – III | The Lower Halls breach into Karak Ostrel. +10 Strept |
| `quest.side_marnadal_watch` | `side/marnadal-watch.md` | `marnadal_watch` | Act II – III | `flag.watch_signal_lit` → Kosk's cavalry in the finale |
| `quest.side_abbey_ledgers` | `side/abbey-ledgers.md` | `zone.abbey_st_corwen` (scriptorium) | Act I – II (closes at `ms.act2_twist`) | `item.choir_list` → `flag.choir_list_exposed`. Maelis joins |
| `quest.side_rozrog` | `side/rozrog-forest.md` | `rozrog_forest` | Act II | `ally.forest_guide` (peace with the woodwose), or a woodwose kill |
| `quest.side_brzezina` | `side/brzezina-woods.md` | `brzezina_woods` | Act II | `flag.brzezina_plot_exposed` (no Sodden flank in the epilogue). A recurring rival NPC |
| `quest.side_grey_ferry` | `side/grey-ferry.md` | `grey_ferry` | Act II – III | One truthful answer: `ded.marnadal_truth` (unlocks Kosk's apology without a check) |
| `quest.side_ravensford` | `side/ravensford-ruins.md` | `ravensford` | Act II – III | The river nymph reveals the Choir's secret pass: `clue.choir_secret_pass` (the Stairs' sharpshooter segment can be skipped) |
| `quest.side_wenna_hair` | `side/wenna-hair.md` | `witchs_mere` | Act II (after meeting Wenna) | Wenna tells how near death the Queen is. In data: a reveal of the Queen's exact condition and whether a rider would be intercepted. +15 Wenna |
| `quest.side_bertha_debt` | `side/drowned-rat-debt.md` | `zone.drowned_rat` | Act I – II | Safehouse (free rest, rumor credibility marked, masquerade invitation contact) |

### 7.5 Travel map nodes and edges

Terrain: L = lowlands, V = valley, M = mountain. Edges are undirected.

| Edge | Terrain | Condition |
|---|---|---|
| cintra — chociebuz | L | — |
| cintra — gull_tower | L | `ms.a1_audience_done` |
| cintra — barrows | L | rumor or quest hook |
| cintra — brzezina_woods | L | quest hook |
| cintra — tigg | L | `ms.act1_complete` |
| cintra — attre | L | `ms.act1_complete`. At stage 3: fortified (§6.1) |
| cintra ~ attre (sea) | L | `flag.skerra_cutter` |
| attre — isle_skerra | L | — |
| attre — morrow_gull | L | `flag.skerra_cutter` or a hired boat (60 crowns) |
| tigg — hanged_mans_oak | V | `item.route_map_oak` or `ded.choir_exists` |
| tigg — ferrymen_camp | V | — |
| tigg — rozrog_forest | V | — |
| tigg — marnadal_watch | V | — |
| ferrymen_camp — marnadal_field | V | crossing or ford (§6.3) |
| ferrymen_camp — grey_ferry | V | — |
| marnadal_field — witchs_mere | V | — |
| marnadal_field — vel_aram | V | `ded.choir_muster_vel_aram` |
| marnadal_field — ravensford | V | — |
| hanged_mans_oak — vel_aram | V | `ded.choir_muster_vel_aram` |
| witchs_mere — attre | V | — |
| ferrymen_camp ~ attre (barge) | V | Ferrymen Allied |
| ravensford — assengard | V | — |
| marnadal_watch — dun_strept | M | — |
| marnadal_watch — stairs_foot | M | — |
| dun_strept — silver_mine | M | — |
| dun_strept — stairs_foot | M | — |
| assengard — stairs_foot | M | — |
| stairs_foot — (Marnadal Stairs zones) | — | Act III only |

---

## 8. Scope tiers

### 8.1 Vertical slice (first deliverable, C7): Act I scene 1, *The Drowned Rat*

**Contents:**
- Main menu → new game (name, attribute points) → `zone.drowned_rat`.
- The courier's death beat and dialogue with innkeeper Bertha and the dying courier (his last word: "Ostrel"). Search the body for `item.dravin_letter` and `clue.courier_foam` (Investigate 4, or Bertha tells you).
- Thugs arrive (a trigger: reading the letter or touching the front door). Three `enemy.choir_thug`. Branches:
  - **Fight** in the tavern (a combat tutorial: light/heavy, block/parry, dodge, kick). Bertha helps by throwing a bottle once.
  - **Talk** (Intimidate 6 makes one thug flee; Bribe 30 makes one thug walk) to shrink the fight.
  - **Flee** through the cellar hatch to `zone.cintra_mudflats`: deep mud (−40% speed, root pockets you mash out of), the tide rising behind each checkpoint, a crossbowman and two thugs pursuing, then the docks.
- Reach `zone.cintra_docks`: Kosk's sergeant meets the player ("The Marshal wants a word"). Slice end card.

**Systems in the slice** (each with production-quality code and tests): composition root and event bus, content loader and validation, actor stats, combat (player moveset, stamina, poise, damage, attack tokens, thug AI, crossbowman AI, yield), dialogue (line/choice/check/effect, bribe and intimidate), inventory (key item, consumables, quick slots), quests and journal (`quest.main_a1` stage 1, the clue board with one clue), progression (XP grant and the level-up toast; the skill tree screen can be a stub), escalation (stage 0, read-only), save/load (autosave on zone entry, quick save), settings (rebinding, subtitles, difficulty), death and reload.

**Not in the slice:** the travel map (stub button), factions UI (data only), companions, rumors, stealth, finale, endings.

**Acceptance criteria:** the slice can be completed both by fighting and by fleeing. All GUT suites pass headless. A smoke test loads all three zones. There are no script errors in the Godot MCP debug output during a scripted run.

### 8.2 Full game (in delivery order)

1. Act I complete (zones 2–7, Gull Tower, Bertha and Abbey side quests, stealth for the Varn chase).
2. Travel map and encounters, factions, rumors, companions (Maelis).
3. Act II sandbox (8 sections, 6 Act II side quests).
4. Act III (7 sections, remaining side quests), the finale and endings, epilogues.
5. Polish: accessibility audit, balancing pass (XP budget, difficulty), VFX and audio **[ART]**.

### 8.3 Cut candidates (only if schedule pressure appears)

The sea serpent's underwater arena (replace it with a shoreline fight), the Brzezina rival as a recurring NPC (make it one encounter), and epilogue slides beyond 3 per ending.

---

## 9. Art-direction plug-in points [ART]

The domain and application layers do not depend on the camera or the art style. D3 decides:
- The camera model (third-person over-the-shoulder, isometric, or top-down) → `presentation/camera/`, lock-on behavior, aiming, and 2D vs 3D actor scenes (`CharacterBody2D` / `CharacterBody3D`).
- The character, environment and VFX pipeline (Blender procedural, or CC0 kits per C1), portrait presets.
- UI skin: the HUD candles, map parchment, journal, escalation cards, epilogue slides.
- Telegraph language for enemy tells (glows, laser-sight, wind-up silhouettes).

Gameplay tuning values (ranges, cone sizes) are in meters/units and must be re-checked once the camera is chosen.

## 10. Open design risks

- **Act II pacing without a clock:** the stage-up thresholds (3 and 5 Act II milestones) are the only source of pressure. A playtest should confirm the escalation feels earned.
- **The rider interception rule** is opaque without the Wenna's Hut side quest. Consider adding a visible "Roads unsafe" warning at stage 3 on the rider choice card.
- **Combat tuning** depends on the camera (art pick). Expect a full retune after D3.
- **The finale meter** must be readable at a glance. The HUD candles must prototype early (slice + 1).
