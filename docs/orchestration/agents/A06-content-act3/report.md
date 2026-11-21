# A06 report: Act III "Under Amell" and endings

(Saved by the orchestrator from the agent's hand-back.)

## Files (`docs/content/act3/`, ~55k words, ~223 ids + ~60 epilogue slide ids; the agent's PyYAML validator reports 0 errors)
01 race-south (war council, `item.lion_crown`, route choice, Kosk's apology and cavalry, regency) · 02 dun-strept (Hesk, torc or apology, Choir raid on the stone, guides, war-band; rep table) · 03 assengard (Dravin, Iron-Key, counter-gear secret, Choir cell, Weeping Gate) · 04 marnadal-stairs (3 zones: barricade, rope-span sharpshooters, ice-bridge frost trolls) · 05 wyverns-roost (return eggs / slay / chasm climb; Brother Udo) · 06 karak-ostrel (5 zones room by room: rune-ring gate, echo-dome plates, gear-train, sluices, nine anvils, Lower Halls; 10 lore docs; Rite of Command) · 07 lock-chamber (ritual meter in level terms, the Zealot, Command the Vault, aftermath) · 08 endings (5 endings × 3 core slides + close; ~40 flag-driven variants) · `_index.md` · `_ids.md`.

## Rulings made by the writer
- Dravin is a station actor at the gear-brake in the finale whenever `flag.dravin_recruited` (never fights or is targeted); Maelis fights if recruited and alive. Elsewhere, one active companion.
- What interrupts Anselm: kicks, staggers and bolts stop human Anselm's shove; the Zealot's bellows-lung weak point (×1.5 damage, ×2 poise) or a stagger stops his pull.
- Iron-wardens never target the wearer of the Lion's Crown (Aldric in the finale).
- Adds per reversed verse: R1 3 zealots + 1 crossbowman (Kosk's cavalry kills it if present); R2 1 warden + 2 zealots; R3 2 sharpshooters + transformation; R4 2 wardens. Vents N/S → E/W → all.
- True Oath win: human Anselm surrenders (alive); the Zealot is unmade (dead).
- Dravin forged the counter-gear for Abbey silver. The mine knocking = Lower Halls pressure-hammers.
- Strept rep: torc +40, rite +10, stone defended +15, apology +30, blood-price Bribe 250 +20, clue +10, Persuade 8 +10, Sway +10. Friendly = guides, Allied = war-band.
- Bitter Bargain: Persuade 8 → willing Aldric; Intimidate 7 → coerced; both fail → he refuses.
- The forced ambush is skipped only with `flag.strept_guides`.

## GDD/format issues → A08
1. Kosk badge penalty: −20 (§6.9) vs −2 (§6.10) → −2 used.
2. DC 7s mandated by the gdd (off the 4/6/8/10 scale), kept.
3. One active companion (§6.13) vs the finale using two → finale-only exception.
4. No crown item in the gdd → added `item.lion_crown`.
5. No effect op to set the finale record and no `epilogue` block type → `play_beat` with a beat→use-case contract table (a3.07 §3.3) plus a proposed `yaml epilogue` schema.
6. No exit-to-map in the zone schema → `map_board` interactables.
7. No equipped/disguised condition → `has_item(item.choir_robe)` stand-in.
8. Missing XP for `enemy.anselm_human` and `enemy.ash_bound_zealot`; `enemy.anselm_human` is not in the §6.7 table.
9. Anselm's fate on a True Oath win was unspecified (resolved above); a mountain-edge guide-rule inconsistency between §6.3 and §7.3.
10. `set_act(3)` ownership (act2/08 vs a3.01): a3.01 does it, guarded.

## Cross-slice reconciliation
Torc hall name "Darrach" and cairn-words vs A05 act2/04; `npc.ysolde` assumed; expects `flag.varn_exposed`, `flag.maelis_recruited`, `flag.maelis_dead`, `flag.antidote_sold_raimund`, `flag.aldric_trusts_player`; `clue.marnadal_chaplain` undeclared (A04 says Kosk gives it in a1.02, so check the declaration); **bolt id clash** `item.crossbow_bolt` (A04, A06) vs `item.crossbow_bolts` (A05, A07); `item.lion_crown` must not be redeclared; the A07 mine exit into `zone.ko_lower_halls/mine_breach` should require `act() == 3`.
