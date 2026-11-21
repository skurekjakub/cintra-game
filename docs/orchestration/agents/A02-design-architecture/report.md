# A02 Report: Design and architecture

(Saved by the orchestrator: the agent's own write to this path was blocked.)

## Files produced
- `docs/design/gdd.md`: pillars, core loops, 18 system sections, zones per act with act gates, 12 side quests, travel graph, vertical-slice vs full scope, [ART] plug-in points.
- `docs/design/architecture.md`: 4 layers with inward-only dependencies, 18 bounded domains (API sketch, events, must-not-know), typed event bus, composition root plus one autoload, data format, testing, folder layout, coding standards, tooling usage.
- `docs/design/content-format.md`: per-section markdown template with `yaml <block>` blocks, condition language, effect list, block schemas, markdown→JSON converter rules (§H), writer checklist.

## Time mechanic removed (user D4)
- The `calendar` domain is replaced by `escalation`, stage 0–4, driven by milestones and never decreasing: stage 1 at end of Act I; stage 2 after 3 Act II main milestones; stage 3 after 5 milestones or when the Act II gate is met; stage 4 at the Act II twist. The story's 90/60/30/10/0-day rows map onto stages 0–4.
- Queen's condition = escalation stage minus two possible Act I fixes: securing the chalice, exposing the food-taster.
- Queen survival depends on the antidote outcome: sent by rider (intercepted at stage 3 unless the Choir list is exposed or an escort is hired), carried back, given to a poisoned Maelis instead, sold to Raimund, or never brewed (bulbs burned).
- Travel has no time cost; one encounter check per journey using the d8 terrain tables. At stage ≥2, a d6 roll of 1–2 swaps the result for an escalation event.
- The only timer is the finale ritual meter, in real time: 4 reversed verses vs 4 true verses.
- The content format uses `milestones_set` and `escalation_stage_required` instead of a calendar cost.

## Key decisions
1. The Act II gate needs the antidote line *resolved*, not the antidote in hand. Failure leads to the Boy King ending, not a dead end. This deviates from story.md on purpose.
2. Dialogue checks are fixed thresholds (attribute + bonuses ≥ difficulty), shown as labels such as `[Persuade 6]`.
3. Bitter Bargain is a finale choice ("Command the Vault"). It needs the command-rite clue from the Drowned Library and Dravin present.
4. Shattered Lock vs Ashes & Iron is chosen after a lost ritual: pursue Anselm (he dies) or shield Aldric (he escapes).
5. Content is JSON, not `.tres`: it diffs cleanly, agents and the converter can write it, it loads headless, and schema tests check it.
6. Typed event bus keyed by event class. Domain objects collect their events; application code publishes them. The order is deterministic.
7. The only autoload is `Services`, so single scenes can run from the editor. Everything else is injected from the composition root.
8. One shared condition language and one effect registry. New effects are new handlers (open/closed).
9. The Godot project lives in `game/`.
10. An architecture test enforces the layer and domain rules, bans engine calls in the domain, and caps files at 300 lines.
11. Content tests check that every quest is completable, every act gate passable, and all 5 endings reachable.

## Test framework
GUT 9.7.1 (`godot_4_7` branch) in `game/addons/gut/`. Fallback: GdUnit4 v6.2.x.
```powershell
$env:GODOT = "C:\Users\skure\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7.2-stable_windows_arm64_console.exe"
& $env:GODOT --headless --path game --import
& $env:GODOT --headless --path game -s res://addons/gut/gut_cmdln.gd -gconfig=res://.gutconfig.json -gexit
```
Wrap in `tools/test.ps1`.

## Open risks
- GUT on 4.7.2 is unverified; confirm on the first run, fall back to GdUnit4 if it fails.
- The `godot` on PATH (`~/.local/bin/godot`) is 4.7.0. Always use `$env:GODOT` (4.7.2).
- Pacing without a clock needs playtesting.
- Combat tuning depends on the art pick ([ART]).
- Rule re-evaluation fixpoint is capped at 8 rounds; a content test guards against effect cycles.
- The markdown→JSON converter has no owner yet (spec in content-format.md §H).
- IP: Sapkowski place names; characters and assets original.
