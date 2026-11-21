---
section_id: a3.07
title: "The Lock Chamber"
act: 3
story_ref: "story.md §1 Premise, §7.7 Finale, §8 The Lion's Oath, §9 Endings; gdd §6.13 allies, §6.14 ritual meter, §6.15 endings resolver, §6.17 finale timings"
zones: [zone.ko_lock_chamber]
available_when: "ms(ms.a3_lock_reached)"
escalation_stage_required: {min: 4, max: 4}
milestones_set: [ms.a3_finale_done]
milestones_read: [ms.a3_lock_reached, ms.a3_dravin_joined, ms.a3_strept_resolved]
level_band: [11, 12]
---

# The Lock Chamber

## 1. Scene summary
Solstice dawn. The great door opens on a round vault under the mountain: a floor of iron plates over turning machinery, four bronze gear-wheels half-sunk in pits, a ring of steam vents, and at the centre, on a raised dais, the **Black Iron Throne**. Four mirror-shafts carry the first grey light down onto it. Anselm stands behind the throne's bronze speaking-horn with a knife at Aldric's throat. The boy is chanting the Pact backward, one forced line at a time. The fight is a race against the **ritual meter** (gdd §6.14). One reversed verse completes every `T_rev` seconds, whatever happens, and each one opens the vault door a step and wakes more of its breath. The player must cut down the bodyguards on the dais, **free Aldric** (pressing the Lion's Crown onto his head in the same motion), and then hold the floor while he speaks the four **true verses** at the speaking-horn, each taking `T_true` seconds, each interrupted and reset whenever he is hit. If three reversed verses complete while Anselm lives, he drinks the venting ash-breath and becomes the **Ash-Bound Zealot**. Win the race and the vault seals for nineteen more winters. Lose it and the vault ruptures, and the player must choose between pursuing Anselm into the breach and shielding the boy. If the player found the Rite of Command and brought Dravin, the throne offers a third path in the moment after Aldric is freed: **Command the Vault**. The section ends when the finale resolves (`ms.a3_finale_done`). The closing scene and epilogues are in a3.08.

## 2. Progress and escalation
- Stage 4. This is the only real-time timer in the game. It is a combat mechanic, not a clock (gdd change log, §6.14).
- **Entry:** from the Hall of Mirrors (a3.06) through the great door. Checkpoint `pre_finale` is set as the door opens. Death anywhere in the finale reloads `pre_finale` (gdd §6.14 rule 10).
- `ms.a3_finale_done` is set by the finale encounter's `on_won`, which fires on **any** `FinaleResolved` (true oath, reversed oath after the aftermath, or vault seized). See the Open questions.
- The finale record (`oath`, `anselm`, `vault_seized`, `coerced`) is produced by the `finale` domain (`architecture.md` §4.9). Content cannot set it with effects. The content hooks are beats (`play_beat`) that the scene implements by calling the matching use case (table in §3.3).

## 3. Location layout

### 3.1 Arena

```
                         N
           ┌──────────── gallery ring (8 m up) ────────────┐
           │  [BRAKE STATION]          (vault door below)  │
     perch W ●     ╔════════ VAULT DOOR (4 steps) ════════╗ ● perch E
           │       ║  alcove (warden spawns)              ║ │
   ENGINE  │  NW pit ◎          V1 ≈          ◎ NE pit      │
   ROAD ═══╡        V8 ≈     ▲P-N           ≈ V2            │
   GATE    │              ┌──────────┐                      │
   (west,  │   ▲P-W  V7 ≈ │  DAIS r5 │ ≈ V3  ▲P-E           │
   floor)  │              │ ⛬THRONE  │                      │
           │        V6 ≈  │ horn ▼   │    ≈ V4              │
           │  SW pit ◎    └──────────┘      ◎ SE pit        │
           │                  ▲P-S     V5 ≈                 │
           │         south ramps ╲    ╱ south ramps         │
           └─────────────────── GREAT DOOR (6 m up) ─────────┘
                         S
   ◎ gear pit (16 m from centre)   ≈ steam vent V1–V8 (12 m ring)   ▲ rune pillar (8 m, full cover)
```

- **Great door (south rim):** enters 6 m above the floor. Two curved **south ramps** lead down, with low balustrades for half cover. The door seals behind the player on entry (beat `door_seals`), so there is no fleeing.
- **Floor ring:** 50 m across, iron plates over the mechanism. It shudders on every reversed verse (camera shake, scaled by accessibility settings).
- **Steam vents V1–V8:** a ring 12 m from the centre, at the compass points and diagonals. Inactive at the start. They activate as reversed verses complete (§3.2).
- **Gear pits (NE, NW, SE, SW):** 16 m from the centre, each holding a bronze gear-wheel 10 m across turning half-sunk, with broken railings. Falling in deals 40 damage, and the gear throws the player out onto the floor ring. A Choir human kicked in dies, crushed. Constructs and bosses are not pushed by kicks.
- **Rune pillars P-N, P-E, P-S, P-W:** 8 m from the centre, 2 m thick. Full cover from the gallery perches and the Engine Road gate. Each carries a **steam-valve wheel** the player can turn to vent the nearest vent pair on demand (a weapon; §3.2).
- **Dais:** radius 5 m, three steps, the ritual position. The **Black Iron Throne** at its centre has a crown-cradle and a key-socket. In front of it (south side) stands the **bronze speaking-horn**, a 2 m bell-mouth of bronze where the verses are spoken. Aldric kneels at the horn, which shields him from the north. The **bodyguard slots** S1–S6 ring the dais inside 5 m.
- **Gallery ring:** an upper walkway 8 m up, with **sharpshooter perches** at the east and west and stairs down at the north. The **brake station** is on the north gallery: the gear-brake housing, a great lever and an Iron-Key socket. Dravin works it. A portcullis drops behind him (beat `brake_engaged`), so he is out of the fight and cannot be attacked.
- **Vault door (north wall, below the gallery):** a disc of black iron 20 m across that opens in four steps, one per reversed verse. Behind it is heat and the deep vault's breath. The **vault alcove** at its foot is where iron-wardens step out.
- **Engine Road gate (west, floor level):** a wide arch for the dwarven wagon road from the main portal. Reinforcements enter here, and so does **Kosk's cavalry**.
- **Mirror-shafts:** four shafts in the dome carry the solstice dawn onto the throne. Presentation only: each reversed verse turns one mirror dark, each true verse turns one gold **[ART]**.
- **Breach rift and escape route:** aftermath only. The rift is the rupture behind the open vault door, Anselm's escape route. The escape route runs back up the south ramps to the great door, which unseals in the aftermath.

### 3.2 The ritual meter in level-design terms

**Timing** (gdd §6.14, §6.17; data, not code):

| Value | Story | Normal | Hard | Modifiers |
|---|---|---|---|---|
| `T_rev` (one reversed verse) | 70 s | 50 s | 40 s | ×1.25 with **Dravin's gear-brake** (Dravin recruited and the player holds `item.iron_key`) |
| `T_true` (one true verse) | 16 s | 20 s | 22 s | ×0.8 if **Maelis is present and `faction.abbey` is Allied** |
| Reversed verses to rupture | 4 | 4 | 4 | — |
| True verses to win | 4 | 4 | 4 | Verse 4 needs `item.true_fourth_verse` (always held, Act II gate) |

**Design target, Normal, no modifiers:** the rupture comes 200 s after the fight starts. Breaking the bodyguards and freeing Aldric should take 60–100 s, leaving 100–140 s for 80 s of channeling plus interruptions. With the brake the rupture comes at 250 s, and with the Maelis bonus the channeling takes 64 s. The player should feel they have **one or two resets of slack**, not more.

**Phase table:**

| Reversed verses done | Reversed line Aldric is forced to speak (beat) | Vault door | Vents active (4 s on, 4 s off, 1 s hiss tell) | Reinforcements (`waves`) | Other |
|---|---|---|---|---|---|
| 0 (start) | *(begins on fight start)* | shut | none | bodyguards S1–S{N} on the dais | Anselm holds Aldric |
| 1 | "From light to dark the winters turn," | step 1 (25%) | V1, V5 (N, S) | **R1:** 3 zealots + 1 crossbowman from the Engine Road gate | **Kosk's cavalry** (if present) charges through the gate and kills all of R1 on arrival |
| 2 | "Let bar and bolt to ashes burn." | step 2 (50%) | + V3, V7 (E, W) | **R2:** 1 iron-warden from the vault alcove + 2 zealots down the north gallery stair | Wardens never target anyone wearing the Lion's Crown (they know it) |
| 3 | "By lion's blood the gates unbind," | step 3 (75%) | all 8 | **R3:** 2 sharpshooters to the east and west perches | **Transformation:** if Anselm lives, he becomes the Ash-Bound Zealot (full HP) |
| 4 | "Wake what the mountain left behind." | **rupture** | all 8, permanent | **R4:** 2 iron-wardens from the breach | Aftermath (§3.2, Loss) |

Escalation stage 4 adds +1 member to each Choir group (R1, R2's zealots, and the bodyguards, if the slot count allows), as in gdd §6.1. The bodyguard count below is computed **before** this, and the minimum of 2 applies after it.

**Bodyguards** (gdd §6.14 rule 3): `N = max(2, 6 − 2·[in_party(ally.strept_warband)] − 2·[flag.choir_list_exposed] − 2·[perk.kingmaker])`. Slots fill in this order, so the strongest mix appears only at N = 6:

| Slot | Position (inside 5 m) | Enemy |
|---|---|---|
| S1 | NE step | `enemy.choir_zealot` |
| S2 | NW step | `enemy.choir_zealot` |
| S3 | behind the throne, N | `enemy.choir_sharpshooter` (fires over the throne at the player; at point-blank range he retreats round the throne) |
| S4 | SE step | `enemy.choir_zealot` |
| S5 | SW step | `enemy.choir_sharpshooter` |
| S6 | S step, beside the horn | `enemy.choir_zealot` |

What each reduction means in the fiction: the war-band is holding the main portal and the Engine Road mouth outside, so those two bodyguards were never sent in. The Choir list put two of the inner circle in Kosk's cells. With Kingmaker, Brothers Jarek and Wick kneel at the dais edge when the player speaks to them (pre-fight dialogue) and take no part. The `kingmaker_kneel` beat plays whenever `perk.kingmaker` is held, through the Sway line or, if the player skips it, on fight start.

**Freeing Aldric** (rule 3): once every bodyguard inside 5 m is down (dead, yielded or fled), a **"Free Aldric"** prompt appears at Aldric (hold Interact 1.5 s). Anselm is shoved off the dais. The player presses **the Lion's Crown** onto Aldric's head in the same animation (beat `free_and_crown`). The crown is always carried (`item.lion_crown`, a3.01), so this adds no extra step or condition. Aldric moves to the horn and starts verse 1 (`aldric_state = channeling`).

**What Aldric needs:**
- **The crown:** placed during Free Aldric. Without it the lock would not know his voice (story §1). It is guaranteed.
- **The true fourth verse:** carried by the player (Act II gate). Aldric reads verse 4 from it on the horn's lectern-lip. The player does not need to do anything.
- **Protection time:** 4 × `T_true` of **uninterrupted** channeling per verse. Any hit on Aldric resets the current verse's progress to 0 (rule 4). Completed verses stay completed.
- **Staying up:** Aldric has 200 HP (gdd §6.13). At 0 he is **downed**: channeling stops, and the player has 20 s to revive him (hold Interact 2 s). If he is not revived, it is game over and a reload of `pre_finale`. While downed, his current verse progress is lost.
- **His position:** he channels kneeling at the horn on the south side of the throne. The throne and horn block shots from the north (the gallery stairs and the vault alcove). He is exposed from the east and west perches, the Engine Road gate, and the south ramps. Standing between him and a perch blocks that shooter's line. Turning the valve on the pillar between him and a perch blinds that perch for 6 s, because steam blocks sight.

**What targets Aldric:**
- While **held:** no one. Anselm's knife is the threat in fiction only (Aldric cannot be killed while held).
- While **channeling:** Choir zealots and crossbowmen from the waves choose Aldric over the player 2:1 when equidistant. Sharpshooters target Aldric whenever they have a line to him and the player is more than 8 m from them. Iron-wardens ignore anyone wearing the crown, so they target the player and companions only. Anselm (human) moves to shove Aldric. The Ash-Bound Zealot uses slag shards on Aldric and the ritual pull (below).

**What interrupts Anselm.** The reversed meter **cannot** be interrupted: the counter-gear Dravin forged has its own momentum (rule 2). Anselm's own actions can be:
- **Human form** (`enemy.anselm_human`: HP 150, armor 5, no melee): after the shove off the dais he alternates between throwing smoke (6 s sight-break, centred on himself) and walking back to Aldric to **shove** him, which counts as a hit and resets the verse. A kick, any stagger, or a crossbow hit cancels the shove approach and knocks him back 1.5 m. Killing him in human form is allowed (rule 9). He never transforms, and the meter keeps running.
- **Ash-Bound Zealot, phase 1** (`enemy.ash_bound_zealot`, HP 2000, ≥ 50%): a soot aura within 4 m (Soot status, gdd §6.4), **slag shards** (a 3-shard volley with a 1.0 s tell, aimed at Aldric if he is channeling and in line, otherwise at the player), and a slag slam (a 3 m area with a 1.2 s tell). Staggering him (poise 200) cancels whatever he is winding up.
- **Ash-Bound Zealot, phase 2** (< 50%): the **ritual pull**. He plants himself on the throne mechanism's north side and channels for 3 s, pulling every combatant within 15 m (Aldric included) toward the nearest gear pit at 1.5 m/s. Aldric pulled into a pit is downed. **Interrupts:** any hit on the **bellows-lung weak point** on his back (the ribs flaring between the shoulders, `clue.zealot_bellows_lung` from a3.05 hints at it), or a full stagger. Weak-point hits deal ×1.5 damage and ×2 poise damage. He channels the pull every 14 s.

**Dravin's gear-brake.** If `flag.dravin_recruited` and `has_item(item.iron_key)`, Dravin leaves the player's side at the great door, climbs the north gallery stair, sets the Key in the brake socket and drops the portcullis behind him (beat `brake_engaged`). `T_rev` ×1.25 for the whole fight. He is a station actor: never targeted, never downed. He calls out each reversed verse ("Third tooth's turning!") and the vault door steps.

**Companions in the finale.** Dravin is at the brake. If Maelis is recruited and alive (`flag.maelis_recruited and not flag.maelis_dead`), she fights as the combat companion (sling, poultice throws) and stands at the throne-runes when Aldric channels. This is what gives the Allied channel bonus. If neither is available, the player fights alone. This departs from the one-active-companion rule for the finale only (see Open questions).

**Kosk's cavalry** (`ally.kosk_cavalry`: `flag.watch_signal_lit` and `rep_tier(faction.crown) >= friendly`): when R1 spawns at the Engine Road gate, a horn sounds down the road and twenty of Kosk's heavy horse ride through the gate and over R1 (beat `cavalry_charge`). R1 is killed and does not count. The riders wheel out again (they cannot fight in the vents) and hold the gate, so no further enemies come from the west.

**Command the Vault** (rule 8): after Free Aldric and before `true_verses` reaches 1, if `has_clue(clue.vault_command_rite)` and Dravin is present (`flag.dravin_recruited`), a second prompt appears at the throne: **"Command the Vault"**. Choosing it opens `dlg.a3_command_vault` (game time stops in dialogue). If it succeeds, the beat `vault_commanded` resolves the fight with `vault_seized = true` (plus `coerced` if Intimidate was used). If it fails or the player backs out, Aldric goes back to the horn and the prompt does not return.

**Win (True Oath, rule 6):** `true_verses` reaches 4 first. Beat `vault_sealed`: the four mirrors go gold, the vault door slams shut and its bolts drive home one after another like a drumroll, and the vents inhale. Every warden goes dormant where it stands, and Choir humans throw down their weapons or run for the Engine Road. **Anselm:** if he is alive in human form, he drops the knife and sits down on the dais steps (`anselm = alive`, captured). If he is the Zealot, the vault's in-breath tears the ash-breath out of him and he collapses back into a man, dying (`anselm = dead`, beat `zealot_unmade`).

**Loss (Reversed Oath finished, rule 7):** `reversed_verses` reaches 4 first. Beat `vault_ruptures`: the door tears fully open, the breach rift splits the north wall, all vents run permanently, and R4 (two wardens) steps out of the breach. **Aftermath:**
- **Zealot alive:** he fights on. At 25% HP he breaks off and runs for the breach rift (beat `anselm_flees`), and `dlg.a3_aftermath_choice` opens. **Pursue Anselm:** a 20 s chase into the rift, ending in a scripted kill at the rift's lip (`anselm = dead`, beat `anselm_falls`). The vent collapse comes down behind the player. Aldric survives it: Maelis drags him clear if she is present, and otherwise he scrambles out of the fall line himself. **Shield Aldric:** the player throws themselves over the boy as the vent collapse comes down (beat `shield_aldric`), and Anselm escapes up the rift (`anselm = fled`).
- **Anselm already dead:** a 60 s **escape sequence** (beat `escape_collapse`). The great door unseals, and the player must get Aldric up the south ramps and out through the Hall of Mirrors while debris falls (collapse hazards with 1 s shadows) and vents blast. Aldric follows at the player's pace, with the same downed rules. Reaching the Hall of Mirrors resolves the finale. If the 60 s run out, the collapse is fatal and the game reloads `pre_finale`.

### 3.3 Beat → use-case contract (for the scene)

| Beat | The scene calls | Notes |
|---|---|---|
| `first_ray` | `StartFinaleUseCase()` | Starts the meter with difficulty `T_rev`/`T_true` and modifiers |
| `brake_engaged` | `RitualMeter.apply_modifier(gear_brake, 1.25)` | Only if Dravin is recruited and the Key is held |
| `free_and_crown` | `FreeAldricUseCase()` | Fired by the Free Aldric prompt |
| `vault_commanded` | `FinaleChoiceUseCase(command)` | Plus `coerced` if `flag.aldric_coerced` |
| `pursue_anselm` | `FinaleChoiceUseCase(pursue)` | |
| `shield_aldric` | `FinaleChoiceUseCase(shield)` | |

```yaml zone
id: zone.ko_lock_chamber
name: "Karak Ostrel: The Lock Chamber"
kind: arena
map_node: map.stairs_foot
time_of_day: dawn
cold_rate: 0
disguise_tag: null
music: finale_lock
areas:
  - {id: great_door, description: "Bronze door at the south rim, 6 m above the floor; seals on entry until the aftermath."}
  - {id: south_ramps, description: "Two curved ramps down from the door; low balustrades (half cover)."}
  - {id: floor_ring, description: "Circular iron-plate floor 50 m across over turning machinery; shudders on each reversed verse."}
  - {id: vent_ring, description: "Eight steam vents V1-V8 in a ring 12 m from the centre."}
  - {id: gear_pits, description: "Four pits at the diagonals 16 m out, each with a 10 m bronze gear turning half-sunk; broken railings."}
  - {id: rune_pillars, description: "Four 2 m pillars 8 m out at the compass points; full cover; each with a steam-valve wheel."}
  - {id: dais, description: "Raised round dais, radius 5 m, three steps; the Black Iron Throne at the centre with crown-cradle and key-socket; the bronze speaking-horn on its south side."}
  - {id: gallery_ring, description: "Walkway 8 m up circling the chamber; sharpshooter perches east and west; stair down at the north."}
  - {id: brake_station, description: "North gallery: gear-brake housing, a great lever, an Iron-Key socket; a portcullis behind it."}
  - {id: vault_door, description: "North wall: a 20 m disc of black iron that opens in four steps; the vault alcove at its foot."}
  - {id: engine_road_gate, description: "West arch at floor level; the dwarven wagon road from the main portal."}
  - {id: mirror_shafts, description: "Four shafts in the dome; bronze mirrors carry the dawn down to the throne."}
  - {id: breach_rift, description: "Aftermath only: the rupture behind the open vault door; a ramp of broken stone climbing into steam."}
  - {id: escape_route, description: "Aftermath only: south ramps to the great door and the Hall of Mirrors."}
spawns:
  - {id: great_door, area: great_door, default: true}
  - {id: dais_anselm, area: dais}
  - {id: dais_aldric, area: dais}
  - {id: guard_s1, area: dais}
  - {id: guard_s2, area: dais}
  - {id: guard_s3, area: dais}
  - {id: guard_s4, area: dais}
  - {id: guard_s5, area: dais}
  - {id: guard_s6, area: dais}
  - {id: kneel_jarek, area: dais}
  - {id: kneel_wick, area: dais}
  - {id: engine_gate, area: engine_road_gate}
  - {id: gallery_stair, area: gallery_ring}
  - {id: perch_east, area: gallery_ring}
  - {id: perch_west, area: gallery_ring}
  - {id: vault_alcove, area: vault_door}
  - {id: breach, area: breach_rift}
  - {id: brake_dravin, area: brake_station}
exits:
  - id: escape_out
    area: escape_route
    to_zone: zone.ko_bridge_nine_anvils
    to_spawn: antechamber
    condition: "false"
    effects: []
interactables:
  - id: valve_n
    area: rune_pillars
    kind: lever
    label: "Spin the north valve"
    condition: "true"
    check: null
    once: false
    effects: ["play_beat(valve_vent_n)"]
    fail_effects: []
  - id: valve_e
    area: rune_pillars
    kind: lever
    label: "Spin the east valve"
    condition: "true"
    check: null
    once: false
    effects: ["play_beat(valve_vent_e)"]
    fail_effects: []
  - id: valve_s
    area: rune_pillars
    kind: lever
    label: "Spin the south valve"
    condition: "true"
    check: null
    once: false
    effects: ["play_beat(valve_vent_s)"]
    fail_effects: []
  - id: valve_w
    area: rune_pillars
    kind: lever
    label: "Spin the west valve"
    condition: "true"
    check: null
    once: false
    effects: ["play_beat(valve_vent_w)"]
    fail_effects: []
triggers:
  - id: door_seals
    area: great_door
    on: enter
    source: null
    condition: "true"
    once: true
    effects: ["set_checkpoint(pre_finale)", "play_beat(door_seals)"]
  - id: confrontation
    area: south_ramps
    on: enter
    source: null
    condition: "not flag(flag.finale_begun)"
    once: true
    effects: ["set_flag(flag.finale_begun)", "play_beat(anselm_knife)", "start_dialogue(dlg.a3_anselm_knife)"]
  - id: closing
    area: floor_ring
    on: encounter_done
    source: enc.lock_chamber_finale
    condition: "true"
    once: true
    effects: ["start_dialogue(dlg.a3_closing)"]
hazards:
  - {id: steam_vents, area: vent_ring, kind: steam, params: {damage_per_second: 12, cycle_on_s: 4, cycle_off_s: 4, tell_s: 1.0, blocks_sight: true, activation: "V1,V5 at reversed 1; +V3,V7 at 2; all at 3; permanent at 4"}}
  - {id: gear_pits, area: gear_pits, kind: trap, params: {damage: 40, eject: true, crush_humans_kicked_in: true}}
  - {id: valve_cones, area: rune_pillars, kind: steam, params: {damage_per_second: 20, duration_s: 6, cooldown_s: 20, note: "Player-triggered by valve_*; vents the two nearest vents into a 6 m cone; blocks sight."}}
  - {id: collapse_debris, area: escape_route, kind: collapse, params: {damage: 35, shadow_telegraph_s: 1.0, active: "aftermath only"}}
  - {id: soot_aura, area: dais, kind: trap, params: {status: soot, note: "Carried by the Ash-Bound Zealot (4 m); listed for flash-reduction settings."}}
checkpoints:
  - {id: pre_finale, area: great_door}
beats:
  - {id: door_seals, description: "The great door swings shut behind the player and a bar drops across it on the far side. Below, the chamber: gears, vents, the throne in grey dawn-light."}
  - {id: anselm_knife, description: "On the dais, Anselm behind the speaking-horn, one hand in Aldric's hair, a thin knife at the boy's throat. Six (or fewer) grey robes around them. The boy is mid-line, voice cracking."}
  - {id: kingmaker_kneel, description: "Brothers Jarek and Wick look at each other, lay their blades on the dais steps, and kneel with their hands on their heads."}
  - {id: first_ray, description: "The first ray of solstice dawn reaches the bottom of the mirror-shafts and lands on the throne. Every gear in the room starts to turn. The meter begins."}
  - {id: brake_engaged, description: "On the north gallery Dravin rams the Iron-Key into the brake socket and hauls the lever. A long scream of metal on metal; the great gears slow by a visible fraction. A portcullis drops behind him."}
  - {id: reversed_verse_1, description: "Aldric, forced, into the horn: 'From light to dark the winters turn,' The floor lurches; the first mirror goes dark; the vault door grinds open a quarter."}
  - {id: reversed_verse_2, description: "Aldric: 'Let bar and bolt to ashes burn.' Half the door open; heat rolls out; an iron shape steps from the alcove."}
  - {id: reversed_verse_3, description: "Aldric: 'By lion's blood the gates unbind,' Three mirrors dark; every vent screaming; black vapour pouring from the door."}
  - {id: reversed_verse_4, description: "Aldric: 'Wake what the mountain left behind.' The last mirror dies."}
  - {id: free_and_crown, description: "The player hauls Aldric from Anselm's grip and in the same movement presses the Lion's Crown onto his head. Anselm is flung off the dais steps. The boy stumbles to the horn."}
  - {id: true_verse_1, description: "Aldric, into the horn, voice steadying: 'By iron forged in mountain deep,' A mirror flares gold."}
  - {id: true_verse_2, description: "Aldric: 'By lion's blood the watch we keep.' Two mirrors gold; the vault door shudders against its own momentum."}
  - {id: true_verse_3, description: "Aldric: 'Let bolt and bar hold fast the night,' Three mirrors gold; the vents falter."}
  - {id: true_verse_4, description: "Aldric, reading the last line from the Vel Aram leaf on the horn's lip: 'Till nineteen winters turn to light.'"}
  - {id: verse_broken, description: "Aldric is struck and the line breaks off mid-word; the gold in the current mirror drains away. He starts the line again."}
  - {id: cavalry_charge, description: "A horn down the Engine Road. Kosk's heavy horse come through the west arch at full gallop, twenty abreast, and ride the reinforcements into the floor. They wheel and hold the gate."}
  - {id: anselm_transforms, description: "Anselm, staggering at the foot of the open door, opens his black flask, drinks, and walks into the vapour. What walks out is larger, wreathed in soot, skin cracked with glowing slag, ribs flaring open at his back like a bellows."}
  - {id: vault_sealed, description: "Four gold mirrors. The vault door slams; bolts drive home one after another like a drumroll; the vents inhale with a vast sound; every warden in the room stops."}
  - {id: zealot_unmade, description: "The vault's in-breath tears the ash out of the Zealot in a black spiral. What falls on the floor is an old man in a burned habit, dying."}
  - {id: vault_ruptures, description: "The door tears fully open. The north wall splits into a rift. Heat, black breath, and the sound of something very large moving far below."}
  - {id: anselm_flees, description: "The Zealot breaks off, bleeding slag, and lopes for the rift, laughing or weeping."}
  - {id: pursue_anselm, description: "The player goes after him up the rift through the steam."}
  - {id: anselm_falls, description: "At the rift's lip the player cuts him down. He falls into the vault's breath without a sound."}
  - {id: shield_aldric, description: "The player throws themselves over Aldric as the vent stack above them comes down. When the dust clears, the rift is empty."}
  - {id: escape_collapse, description: "The great door's bar shatters. 'Out! Now!' Sixty seconds of falling stone and screaming vents between the dais and the Hall of Mirrors."}
  - {id: vault_commanded, description: "Dravin sets the Key in the throne. Aldric lays his hand on it and says the words. Every warden in the room turns toward the throne and goes down on one knee. Far below, the vault answers with a sound like an army standing up."}
  - {id: valve_vent_n, description: "The north valve spins; V1 and V2 roar out in a scalding cone."}
  - {id: valve_vent_e, description: "The east valve spins; V3 and V4 roar out."}
  - {id: valve_vent_s, description: "The south valve spins; V5 and V6 roar out."}
  - {id: valve_vent_w, description: "The west valve spins; V7 and V8 roar out."}
  - {id: closing_still, description: "Silence after noise; the gears coasting to a halt; dust falling through the light."}
  - {id: epilogue_begins, description: "Fade to the first epilogue slide (a3.08)."}
npcs:
  - {npc: npc.anselm, area: dais, condition: "true"}
  - {npc: npc.aldric, area: dais, condition: "true"}
  - {npc: npc.dravin, area: brake_station, condition: "flag(flag.dravin_recruited)"}
  - {npc: npc.brother_jarek, area: dais, condition: "perk(perk.kingmaker)"}
  - {npc: npc.brother_wick, area: dais, condition: "perk(perk.kingmaker)"}
encounters: [enc.lock_chamber_finale]
loot: []
variants: []
```

The `escape_out` exit is `false` in data because the aftermath escape is driven by the finale domain: reaching the Hall of Mirrors during `escape_collapse` resolves the finale, and no zone transition happens until the closing dialogue. It is listed so that the level builder places the door collider.

## 4. NPCs present
`npc.anselm` and `npc.aldric` are declared in Act I (A04). `npc.dravin` is declared in a3.03. New:

```yaml npc
id: npc.brother_jarek
name: "Brother Jarek"
faction: faction.choir
role: "One of Anselm's dais bodyguards; a farm boy from Tigg"
motive: "Believe in something larger than Tigg."
secret: "He has never killed anyone and has been dreading this dawn for a month."
disposition: hostile
essential: false
dialogue: null
barks: ["He's twelve, Abbot.", "I'm sorry. I'm sorry."]
combat: enemy.choir_zealot
shop: null
```

```yaml npc
id: npc.brother_wick
name: "Brother Wick"
faction: faction.choir
role: "One of Anselm's dais bodyguards; Jarek's cousin"
motive: "Follow Jarek."
secret: null
disposition: hostile
essential: false
dialogue: null
barks: ["Jarek? Jarek, what do we do?"]
combat: enemy.choir_zealot
shop: null
```

*Anselm's voice:* grandfatherly, soft, never raised. A preacher's cadences, used for terrible things. He is genuinely kind to Aldric in tone, and that is the worst part. *Aldric's voice:* a twelve-year-old trying to sound like a king and mostly failing, then succeeding at the worst possible moment. He calls the player by name.

## 5. Dialogue trees

```yaml dialogue
id: dlg.a3_anselm_knife
participants: [npc.anselm, npc.aldric, npc.brother_jarek]
start: open
nodes:
  open:
    type: line
    speaker: npc.anselm
    text: "Ah. {player}. I told Brother Ostwin you'd come. He never listens. Come down where I can see you, there's a good soul. Slowly."
    direction: "Behind the speaking-horn, one hand in Aldric's hair, the knife resting along the boy's throat."
    next: aldric_first
  aldric_first:
    type: branch
    cases:
      - {if: "flag(flag.aldric_trusts_player)", next: aldric_trust}
    else: aldric_plain
  aldric_trust:
    type: line
    speaker: npc.aldric
    text: "{player}! I didn't say it! I didn't say any of it on purpose, I swear, he keeps..."
    next: anselm_hush
  aldric_plain:
    type: line
    speaker: npc.aldric
    text: "Don't come closer. He means it. He's meant everything he's said since the catacombs."
    next: anselm_hush
  anselm_hush:
    type: line
    speaker: npc.anselm
    text: "Hush, Your Highness. Save your voice. You'll need all of it when the light comes down the shafts."
    next: hub
  hub:
    type: choice
    options:
      - id: why
        text: "Why? She trusted you with everything."
        once: true
        next: why
      - id: marnadal
        text: "[Clue: The Marnadal chaplain] You were at Marnadal. You lit that war, then you buried it."
        tag: clue
        condition: "has_clue(clue.marnadal_chaplain) or ded(ded.choir_lit_marnadal) or ded(ded.marnadal_truth)"
        once: true
        next: marnadal
      - id: vaults
        text: "You know what's down there. Casks. Engines. It'll kill the poor first."
        once: true
        next: vaults
      - id: boy
        text: "Aldric. Look at me, not at the knife."
        once: true
        next: boy
      - id: crown
        text: "[Item: The Lion's Crown] I brought this for him. Your lock knows it. It won't know you."
        tag: item
        condition: "has_item(item.lion_crown)"
        once: true
        next: crown
      - id: list
        text: "[Clue: The Choir list] Count your guards, Abbot. Half the names on your list are in Kosk's cells."
        tag: clue
        condition: "flag(flag.choir_list_exposed)"
        once: true
        next: list
      - id: warband
        text: "Your men at the main portal aren't coming. The clans are holding the road."
        condition: "in_party(ally.strept_warband)"
        once: true
        next: warband
      - id: sway
        text: "Brothers. You came for justice. There's none in cutting a boy's throat. Put down your blades. [Sway]"
        tag: sway
        condition: "perk(perk.kingmaker)"
        once: true
        next: sway
      - id: persuade
        text: "It isn't too late to walk out of here a priest instead of a butcher. [Persuade 10]"
        tag: persuade
        once: true
        check: {skill: persuade, dc: 10, pass: persuade_pass, fail: persuade_fail}
      - id: intimidate
        text: "Cut him and you lose the only throat your lock answers to. Then it's just you and me. [Intimidate 8]"
        tag: intimidate
        once: true
        check: {skill: intimidate, dc: 8, pass: intimidate_pass, fail: intimidate_fail}
      - id: enough
        text: "Enough."
        next: begin
  why:
    type: line
    speaker: npc.anselm
    text: "She trusted me with the names of the lords who billed her treasury for Marnadal's graves. I gave her absolution twice a week. I gave her lilies once."
    next: why_more
  why_more:
    type: line
    speaker: npc.anselm
    text: "Every nineteen winters a crowned child says four lines and the same families go on eating. I'm not breaking a lock, {player}. I'm breaking a habit."
    next: hub
  marnadal:
    type: line
    speaker: npc.anselm
    text: "Lit it? I carried letters. Men who wanted a war wrote them. I only made sure the clans read them, and told the Marshal a story he wanted to hear."
    next: marnadal_more
  marnadal_more:
    type: line
    speaker: npc.anselm
    text: "Then I spent a summer giving last rites in a field of mud to boys from both sides. The Marshal got a statue. I got a sermon. This is the sermon."
    next: hub
  vaults:
    type: line
    speaker: npc.anselm
    text: "Yes. The poor first, then the lords, then whatever crawls out of Sodden to pick the bones. And afterward no one will ever dare build a crown like this again."
    next: hub
  boy:
    type: branch
    cases:
      - {if: "flag(flag.aldric_trusts_player)", next: boy_trust}
    else: boy_plain
  boy_trust:
    type: line
    speaker: npc.aldric
    text: "I'm looking. I'm not scared. That's a lie. Tell me what to do and I'll do it."
    next: boy_anselm
  boy_plain:
    type: line
    speaker: npc.aldric
    text: "I can't. He's got his hand in my hair. Just... be quick. Please."
    next: boy_anselm
  boy_anselm:
    type: line
    speaker: npc.anselm
    text: "He'll do as he's told. He's a good boy. Everyone has always made very sure of that."
    next: hub
  crown:
    type: line
    speaker: npc.anselm
    text: "Of course you brought it. Keep it. Locks need crowns. Doors only need blood."
    next: hub
  list:
    type: line
    speaker: npc.anselm
    text: "Kosk's cells. Yes, I noticed the empty places at the fire. Faith thins when it's counted."
    next: hub
  warband:
    type: line
    speaker: npc.anselm
    text: "Hesk's people. Bleeding for a Cintran boy. The world really is ending."
    next: hub
  sway:
    type: line
    speaker: npc.brother_jarek
    text: "He's twelve, Abbot."
    direction: "Two of the bodyguards look at each other, lay their blades on the dais steps, and kneel."
    effects: ["play_beat(kingmaker_kneel)"]
    next: sway_anselm
  sway_anselm:
    type: line
    speaker: npc.anselm
    text: "Then kneel, Brother Jarek, and pray it's quick when the door opens."
    next: hub
  persuade_pass:
    type: line
    speaker: npc.anselm
    text: "It's turning already, child. The counter-gear doesn't listen to sermons. Even mine."
    direction: "The knife wavers. For a breath he looks very old."
    effects: ["set_flag(flag.anselm_wavered)"]
    next: hub
  persuade_fail:
    type: line
    speaker: npc.anselm
    text: "I've heard better from better. I wrote most of it."
    next: hub
  intimidate_pass:
    type: line
    speaker: npc.anselm
    text: "Then come and take him."
    direction: "The knife moves a finger's width from Aldric's throat. The boy breathes."
    effects: ["set_flag(flag.anselm_rattled)"]
    next: hub
  intimidate_fail:
    type: line
    speaker: npc.anselm
    text: "You'll kill me eventually. I don't need eventually. I need dawn."
    next: hub
  begin:
    type: line
    speaker: npc.anselm
    text: "Then let the light decide. Sing, Your Highness."
    next: begin_fx
  begin_fx:
    type: effect
    effects: ["play_beat(first_ray)", "start_encounter(enc.lock_chamber_finale)"]
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.a3_command_vault
participants: [npc.dravin, npc.aldric]
start: open
nodes:
  open:
    type: line
    speaker: npc.dravin
    text: "Wait! The slab in the library. The throne takes a command, not just a lock. Key in the socket, the boy's hand on the iron, and every warden in this mountain answers to the crown."
    next: aldric_asks
  aldric_asks:
    type: line
    speaker: npc.aldric
    text: "Answers to me? The wardens? The... all of it?"
    direction: "Crown askew, one hand already on the throne's arm."
    next: choice
  choice:
    type: choice
    options:
      - id: persuade
        text: "Think what Cintra could do with it, Aldric. No more Choirs. No more Marnadals. No one would ever dare. [Persuade 8]"
        tag: persuade
        once: true
        check: {skill: persuade, dc: 8, pass: willing, fail: refused}
      - id: intimidate
        text: "You'll do it because I'm telling you to, and because I'm the one holding the sword. [Intimidate 7]"
        tag: intimidate
        once: true
        check: {skill: intimidate, dc: 7, pass: coerced, fail: refused}
      - id: lock
        text: "No. Lock it. Say the true verses."
        next: lock
  willing:
    type: line
    speaker: npc.aldric
    text: "Yes. Yes. Mother always said the crown had nothing in its hands. Show me where."
    next: seize_fx
  coerced:
    type: line
    speaker: npc.aldric
    text: "Fine. Show me where to put my hand."
    direction: "His face closes like a door. He doesn't look at the player again."
    effects: ["set_flag(flag.aldric_coerced)"]
    next: seize_fx
  seize_fx:
    type: line
    speaker: npc.aldric
    text: "Wake and answer."
    effects: ["play_beat(vault_commanded)"]
    next: bye
  refused:
    type: line
    speaker: npc.aldric
    text: "No. I won't. I'm not him. I'm not going to be him."
    next: lock
  lock:
    type: line
    speaker: npc.aldric
    text: "By iron forged in mountain deep..."
    direction: "He turns back to the speaking-horn and begins."
    next: bye
  bye:
    type: end
```

```yaml dialogue
id: dlg.a3_aftermath_choice
participants: [npc.aldric]
start: open
nodes:
  open:
    type: line
    speaker: npc.aldric
    text: "{player}! The roof! He's getting away!"
    direction: "The Zealot loping for the rift; above Aldric, the vent stack leaning, raining grit."
    next: choice
  choice:
    type: choice
    options:
      - id: pursue
        text: "Go after Anselm."
        next: pursue
      - id: shield
        text: "Get to the boy."
        next: shield
  pursue:
    type: effect
    effects: ["play_beat(pursue_anselm)"]
    next: bye
  shield:
    type: effect
    effects: ["play_beat(shield_aldric)"]
    next: bye
  bye:
    type: end
```

**Combat barks (presentation; played by the finale scene on meter events):**

| Event | Speaker | Line |
|---|---|---|
| Fight start, Dravin at brake | Dravin | "Brake's on! You've a quarter more than he planned for. Don't waste it!" |
| Reversed verse 1 | Anselm | "One. Hear it, Your Highness? The mountain's listening." |
| Reversed verse 2 | Dravin / Maelis | "Halfway open! Get the boy!" / "{player}, the door!" |
| Reversed verse 3, transform | Anselm | "Breathe with me." |
| Free Aldric | Aldric | "I've got it. I've got it. Keep them off me." |
| Verse broken | Aldric | "No, no, again, I'm starting again!" |
| True verse 3 | Aldric | "One more. One more!" |
| Zealot phase 2 | Anselm (Zealot) | "Come and stand in the light with me, all of you." |
| Zealot weak point hit | Anselm (Zealot) | (a bellows gasp, no words) |
| Cavalry | Kosk (off-screen) | "Cintra! For the boy!" |

## 6. Encounters

```yaml encounter
id: enc.lock_chamber_finale
zone: zone.ko_lock_chamber
enemies:
  - {enemy: enemy.anselm_human, count: 1, spawn: dais_anselm, variant: null}
  - {enemy: enemy.choir_zealot, count: 1, spawn: guard_s1, variant: bodyguard}
  - {enemy: enemy.choir_zealot, count: 1, spawn: guard_s2, variant: bodyguard}
  - {enemy: enemy.choir_sharpshooter, count: 1, spawn: guard_s3, variant: bodyguard}
  - {enemy: enemy.choir_zealot, count: 1, spawn: guard_s4, variant: bodyguard}
  - {enemy: enemy.choir_sharpshooter, count: 1, spawn: guard_s5, variant: bodyguard}
  - {enemy: enemy.choir_zealot, count: 1, spawn: guard_s6, variant: bodyguard}
waves:
  - {after: reversed_verse_1, enemies: [{enemy: enemy.choir_zealot, count: 3, spawn: engine_gate, variant: null}, {enemy: enemy.choir_crossbowman, count: 1, spawn: engine_gate, variant: null}]}
  - {after: reversed_verse_2, enemies: [{enemy: enemy.iron_warden, count: 1, spawn: vault_alcove, variant: null}, {enemy: enemy.choir_zealot, count: 2, spawn: gallery_stair, variant: null}]}
  - {after: reversed_verse_3, enemies: [{enemy: enemy.choir_sharpshooter, count: 1, spawn: perch_east, variant: null}, {enemy: enemy.choir_sharpshooter, count: 1, spawn: perch_west, variant: null}]}
  - {after: reversed_verse_4, enemies: [{enemy: enemy.iron_warden, count: 2, spawn: breach, variant: null}]}
attack_tokens: null
allow_yield: true
allies: [ally.aldric, ally.kosk_cavalry]
checkpoint: pre_finale
avoidable_by: []
on_won: ["reach_milestone(ms.a3_finale_done)"]
on_yielded: []
on_player_fled: []
```

Encounter notes:
- The `enemies` list holds the **maximum** six bodyguard slots. The finale domain spawns only S1–S{N} (§3.2). The `bodyguard` variant stays inside the 5 m dais radius and never chases the player off the dais.
- `enemy.anselm_human` is passive (holding Aldric) until `free_and_crown`. At reversed 3, if alive, he is replaced by `enemy.ash_bound_zealot` at full HP (`anselm_transforms`). Bosses ignore attack tokens (gdd §6.4).
- `ally.kosk_cavalry` spawns only if `flag(flag.watch_signal_lit) and rep_tier(faction.crown) >= friendly` (gdd §6.13). It is a scripted event, not a fighting unit.
- `ally.aldric` is the escort (200 HP, 20 s revive). His death means `game_over(aldric_died)` and a reload of `pre_finale`.
- **XP:** the finale grants the Act III top milestone value (800) through `ms.a3_finale_done`, plus per-enemy XP for what was killed. The Zealot's XP is set in data (not in gdd §6.8; see Open questions).

## 7. Items and clues
No new items. Uses `item.lion_crown` (a3.01), `item.iron_key` (a3.03), `item.true_fourth_verse` (A05), and `clue.vault_command_rite` (a3.06).

## 8. Flags set and read

```yaml flags
declare:
  - {id: ms.a3_finale_done, type: milestone, desc: "The Lock Chamber finale resolved (any outcome); a3.08 closing and epilogues follow."}
  - {id: flag.finale_begun, type: bool, desc: "The confrontation dialogue has started."}
  - {id: flag.aldric_coerced, type: bool, desc: "(gdd) Aldric was intimidated into commanding the vault (epilogue variant)."}
  - {id: flag.anselm_wavered, type: bool, desc: "Anselm hesitated under persuasion (epilogue variant if captured)."}
  - {id: flag.anselm_rattled, type: bool, desc: "Anselm loosened the knife under intimidation (flavor)."}
reads:
  - ms.a3_lock_reached
  - flag.dravin_recruited
  - flag.maelis_recruited
  - flag.maelis_dead
  - flag.choir_list_exposed
  - flag.watch_signal_lit
  - flag.aldric_trusts_player
  - ded.choir_lit_marnadal
  - ded.marnadal_truth
  - clue.marnadal_chaplain
  - clue.vault_command_rite
  - perk.kingmaker
  - item.lion_crown
  - item.iron_key
  - item.true_fourth_verse
```

## 9. Quest hooks

```yaml quest_stages
quest: quest.main_a3
order: 70
stages:
  - id: solstice_dawn
    journal: "The Lock Chamber. Anselm has the knife; Aldric has the voice; I have the crown. The light is coming down the shafts."
    objectives:
      - {id: resolve, text: "Stop the reversed Oath", condition: "ms(ms.a3_finale_done)", optional: false}
    on_complete: []
    next: []
```

## 10. Rumors and event cards (optional)
None. `rumor.r09_aldric_dwarven` (A07, "Prince Aldric mutters strange dwarven words in his sleep") is paid off here: the reversed chant was drilled into him. No effect is needed.

## 11. Failure states and branches

```yaml branches
paths:
  - id: true_oath
    when: "true_verses reaches 4 before reversed_verses reaches 4."
    outcome: "finale.oath = true. Anselm alive (human, captured) or dead (Zealot unmade). Ending Lion Holds or Boy King by flag.queen_alive."
    sets: ["reach_milestone(ms.a3_finale_done)"]
  - id: seized
    when: "Command the Vault chosen and the Persuade 8 or Intimidate 7 check passes (clue.vault_command_rite and Dravin recruited)."
    outcome: "finale.vault_seized = true; oath none; flag.aldric_coerced if Intimidate. Ending Bitter Bargain."
    sets: ["reach_milestone(ms.a3_finale_done)"]
  - id: reversed_pursue
    when: "reversed_verses reaches 4; the player pursues the fleeing Zealot."
    outcome: "finale.oath = reversed, anselm = dead. Ending Shattered Lock."
    sets: ["reach_milestone(ms.a3_finale_done)"]
  - id: reversed_shield
    when: "reversed_verses reaches 4; the player shields Aldric."
    outcome: "finale.oath = reversed, anselm = fled. Ending Ashes & Iron."
    sets: ["reach_milestone(ms.a3_finale_done)"]
  - id: reversed_anselm_dead
    when: "reversed_verses reaches 4 with Anselm already dead; the player escapes in 60 s."
    outcome: "finale.oath = reversed, anselm = dead. Ending Shattered Lock."
    sets: ["reach_milestone(ms.a3_finale_done)"]
failures:
  - id: player_dies
    result: reload_checkpoint
    recover: "Reload pre_finale (gdd §6.14 rule 10)."
  - id: aldric_dies
    result: game_over
    recover: "game_over(aldric_died); reload pre_finale (gdd §6.13, §6.18)."
  - id: escape_timeout
    result: reload_checkpoint
    recover: "The collapse kills the player and Aldric; reload pre_finale."
guarantees:
  - "ms.a3_finale_done is reached by every non-death outcome. Losing the race is not a fail state: it leads to the aftermath and an ending."
  - "Aldric can always be freed: the bodyguard count has a floor of 2 and they are ordinary enemies; the crown is always carried."
```

## 12. Open questions
- **Companions in the finale (gdd tension).** gdd §6.13 allows one active combat companion. §6.14 uses Dravin at the brake and Maelis on the channel at the same time. I made Dravin a **station** actor (present if recruited, never fighting) and let Maelis fight if recruited and alive, whatever the active slot. This is a finale-only exception. Please confirm.
- **Finale record from content.** The effect list (§E) has no op to set `finale.*`. I route the choices through `play_beat` and a beat → use-case table (§3.3). A dedicated effect such as `finale_choice(command|pursue|shield)` would be cleaner.
- **`on_won` for every resolution.** The finale encounter's `on_won` must fire on any `FinaleResolved`, including the loss branches. Otherwise `ms.a3_finale_done` and the closing scene never trigger after a lost race.
- **Wave `after:` values.** I used `reversed_verse_1..4`, which content-format §F.4 shows as an example. The encounter runner must accept them from the finale meter's events.
- **Bodyguard slot data.** The schema has no "max N, fill in order" field. I listed all six slots and described the fill rule. The finale domain should own N.
- **Weak-point numbers.** gdd §6.7 names the bellows-lung weak point but gives no multiplier. I specified ×1.5 damage and ×2 poise, and the pull interrupt. Tune in playtest.
- **Ash-Bound Zealot and Anselm XP** are missing from gdd §6.8's XP list. Suggest 0 for `enemy.anselm_human` and 800 for the Zealot.
- **Anselm's fate on a True Oath win.** gdd rule 6 says remaining enemies "collapse or flee". I made the human Anselm surrender (`alive`) and the Zealot collapse and die (`dead`). Neither affects the resolver (only reversed outcomes test `anselm`), but the epilogues use it.
