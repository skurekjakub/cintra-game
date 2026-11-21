# Application, Infrastructure, Content Pipeline and Save Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the save domain, the application layer (session, ports, effects, fixpoint, policies, use cases, queries), the infrastructure (content loader, schemas, parsers, save/settings/Godot adapters), the composition root with `Services` and a boot `Main.tscn`, the markdown→JSON content converter, and the content validation suite.

**Architecture:** Domain aggregates (planned by P1/P2) are held by one `GameSession`. Use cases mutate them, apply effects through a registry-based `EffectDispatcher`, then a `SessionCommitter` pumps every aggregate outbox onto the `EventBus` and republishes `FactsChanged` until the session fingerprint stops changing (cap 8 rounds). Content is JSON validated against per-kind schemas and turned into typed definitions by one parser per kind. `GameComposer` is the only class that names concrete infrastructure.

**Tech Stack:** Godot 4.7.2, typed GDScript, GUT 9.7.1; Python ≥ 3.12 (stdlib only) with vendored PyYAML 6.0.4 for the converter.

**Spec:** `docs/design/architecture.md` §2, §3.2–§3.4, §4.18, §5, §6, §8, §9.4, §11; `docs/design/content-format.md` §C, §E, §F, §H; `docs/design/gdd.md` §6.1, §6.2, §6.8, §6.10, §6.12, §6.14–§6.17, §7.

## Global Constraints

- Godot binary: `$env:GODOT` (4.7.2 console). Never the `godot` on PATH.
- Static typing everywhere; `untyped_declaration` is an error; any `unsafe_*` warning is a review blocker. Ids are `StringName`.
- One class per file, no inner classes, `snake_case.gd` = `class_name PascalCase`. Files ≤ 300 lines (aim ≤ 200), functions ≤ 30 lines, ≤ 4 parameters, nesting ≤ 3.
- Expected failures return `Result.err(code)` with a code from the table below. Programmer errors use `assert()`.
- Layer rule (architecture test): domain and application never use `JSON`, `FileAccess`, `DirAccess`, `OS`, `Time`, `Engine`, `ProjectSettings`, `Input`, `InputMap`, `Node`. JSON text only exists in infrastructure. Only presentation reads `Services`.
- Header comment of every class cites the architecture/gdd/content-format section it implements.
- **Never cache a `GameSession` aggregate in a field.** Read `session.world`, `session.inventory`… at call time: `StartNewGameUseCase` and `LoadGameUseCase` replace them.
- Tests: `tools/test.ps1 -Test <path>`; done means `tools/test.ps1` exits 0. Deterministic: `SeededRandom(seed)` or `ScriptedRandom`, `FixedWallClock`, no real-time waits.
- Infra tests that touch disk write only under `user://test_tmp/<test_name>/` and delete it in `after_each`.
- Converter: `python -I`; stdlib plus `tools/content_convert/vendor/yaml` only. Converter tests: `python -I -m unittest discover -s tools/content_convert/tests -t tools/content_convert -v` → `OK`.
- **content-format §J "Addendum 1" is part of the format.** Wherever this plan cites content-format §C, §E or §F, include the §J additions (new condition calls, effect ops, trigger kinds and fields) in schemas (Tasks 13, 14), converter required fields (Task 17), parsers (Tasks 24–28), reachability mapping (Task 30) and effect handlers (Task 43a).
- Commits (orchestrator) include the `.gd.uid` sidecars Godot creates next to new scripts; the `git add` lines name folders so sidecars are included.

**Error codes** (use exactly these `StringName`s):

| Area | Codes |
|---|---|
| content | `content_invalid` (detail = every error, one per line), `unknown_id` |
| save | `save_bad_slot`, `save_not_found`, `save_corrupt`, `save_invalid`, `save_version_unsupported`, `save_migration_missing`, `save_missing_section`, `save_write_failed`, `save_not_allowed` |
| effects | `effect_unknown_op`, `effect_cannot_pay` |
| session/fixpoint | `fixpoint_cap_reached` |
| use cases | `unknown_id`, `not_available`, `condition_false`, `invalid_attributes`, `dialogue_active`, `no_active_dialogue`, `no_active_finale`, `not_in_zone`, `insufficient_crowns`, `no_skill_points`, `not_for_sale` |

## API extensions (beyond architecture.md sketches)

1. **`Logger` port is renamed `GameLogger`** (Godot ≥ 4.5 ships a native `Logger` class; a `class_name Logger` would shadow it). Adapters: `GodotLogger`, `CapturingLogger`.
2. `ContentDatabase` gets a generic store (`put`, `put_raw`, `has_id`, `ids_of`, `get_def`, `get_raw`, `count`) under its typed catalogs. Kinds without a parser yet (`enemies`, `encounters`) are stored raw until the vertical-slice plan adds typed parsers.
3. Non-domain content definitions live in `src/application/content/definitions/`: `ZoneDefinition` (+ `SpawnDefinition`, `ZoneExitDefinition`, `InteractableDefinition`, `ZoneTriggerDefinition`, `ZoneNpcDefinition`, `LootDefinition`, `ZoneVariantDefinition`), `NpcDefinition`, `ShopDefinition`, `SectionDefinition`, `FlagDeclaration`, `GameRulesDefinition`, `StartingItem`, `ActGateDefinition`. **Event cards** (content-format §F.9) have no domain owner; this plan owns them as data in the travel domain's public surface: `src/domain/travel/event_card_definition.gd`, `event_card_option_definition.gd` (pure data: `Condition`, `EffectSpec`, check skill/dc as plain values, because travel may not reference dialogue's `CheckSpec`), plus `EventCardParser`, `EventCardQuery` and `ResolveEventCardUseCase` in the outer layers.
4. New content kind `game_rules` (singleton `content/game_rules.json`): new-game setup, act gates, XP source values, price multipliers, antidote numbers, rumor price, finale timers. New kind `epilogues` schema is defined here; data comes later.
5. Every converted record carries `_source: {file, line, section, act}`. Keys starting with `_` are metadata: the schema validator neither checks nor forbids them.
6. `SaveSchema._init(required_sections: Array[StringName])`; `SaveSnapshot.CURRENT_VERSION = 1`, `to_dict()`, `static from_dict(raw) -> Result`; `SaveMeta.to_dict()`, `static from_dict(raw) -> Result`.
7. Application-owned Snapshotable aggregates in `GameSession`: `location: SessionLocation` (zone, spawn, visited zones, last checkpoint, playtime), `zone_memory: ZoneMemory` (spent once-only interactables/triggers/loot), `profile: PlayerProfile` (name). Plus `outbox: EventOutbox` (P1's class, for application events) and `activity: SessionActivity` (not saved), and `shops: Dictionary[StringName, Shop]` (one P1 `Shop` per NPC, built on first use; stock is not saved and resets on load).
8. Application events in `src/application/events/` (list in Task 7). `ZoneSignalUseCase(on, source_id)` for `beat_done` / `encounter_done` triggers; `TwistResolutionPolicy` for gdd §6.2 "Twist resolution"; `MaelisPoisonPolicy` also listens to `ZoneExited`; `ZoneQuery`.
9. Milestones `ms.act1_gate_met`, `ms.act2_gate_met` (set by `ActGatePolicy` so the gate is a permanent fact the UI and journal can test). Escalation stage conditions stay the gdd's full conditions (stage 3 includes the Act II gate's deduction and item); `test_escalation_reachable` does **not** restrict them to milestones (coordinator ruling, overriding architecture §9.4's "reference only milestones"). System flags declared in `content/flags/system.json` (Task 22).
12. `EffectHandler.signature() -> EffectSignature`; `EffectDispatcher._init(signatures: EffectSignatures)`, `register(handler)` registers the handler's signature into that one shared registry (P1 binding), which is also the registry given to `EffectParser` for content loading and the content tests.
13. `SessionFactProvider.set_speaker(npc_id: StringName)` / `clear_speaker()`: the speaker context for the speaker-specific check modifiers (Task 36).
10. `IdRules.KINDS` gains `theory` and `epilogue` (clue records use `theory.*`; epilogues get `epilogue.*` ids). Done in Task 6.
11. `GameComposer.compose(config: ComposerConfig) -> GameContext`; `GameContext.is_ready()` and `content_error`. `Services.ready()` delegates to it.

## Consumes from P1 / P2

P1's plan is `docs/superpowers/plans/2026-11-21-core-state-domains.md`; its "API extensions" and "How to add an effect op" sections are binding here. Other field and method names are architecture.md's. **Construct every P1/P2 class through the constructor as actually built**; where the built class differs, follow the code and say so in the task report. Tasks naming a P1/P2 class are scheduled after that class exists.

- **P1 shared:** `FactsChanged` (field `source: StringName`), `EventOutbox` (`record`, `drain`, `is_empty`) — `GameSession.outbox` is an `EventOutbox`.
- **P1 test helpers (reuse, never redefine):** `FakeFactProvider`, `ScriptedRandom`, `ItemDefBuilder`, `ContentFormatEffects.signatures()` (the 35 §E ops), `GddEscalationRules`.
- **P1 rules:** `ConditionParser.parse(text) -> Result(Condition)` (static), `Condition.evaluate(facts)`, `Condition.referenced_ids()`, `FactProvider` (every abstract method incl. `visited`, `rumor_heard`, `queen_condition`; constants `QUEST_INACTIVE|QUEST_ACTIVE|QUEST_COMPLETED|QUEST_FAILED` = `&"inactive"|&"active"|&"completed"|&"failed"`; `finale_value` keys `FINALE_SEIZED|FINALE_OATH|FINALE_ANSELM`, seized returns `&"true"`/`&"false"`), `CheckSkills.is_check_skill`, `RepTiers`, **`EffectSignatures` (one registry instance)**, `EffectSignature.of(op, specs)`, `EffectParser.new(signatures).parse(text)` / `parse_list(texts)`, `EffectSpec.op/args/referenced_ids()`.
- **P1 world_state:** `WorldState._init(var_bounds: Dictionary[StringName, Vector2i])` (`add_var` clamps, `set_var` does not), events `FlagChanged`, `MilestoneReached`, `ActChanged`, `VarChanged`.
- **P1 escalation:** `EscalationTrack._init(rules)`, `recompute(facts)` (evaluates the stage conditions as full conditions, cascades), `pending_stage_entries()`, `mark_entry_applied(stage)`, `EscalationRules._init(stages)`, `EscalationStageDefinition`, `QueenCondition`, events `EscalationStageChanged`, `QueenConditionChanged`, `AntidoteAdministered`.
- **P1 actors:** `Attributes._init(values)`, `Attributes.create(bonus) -> Result`, `ActorSheet._init(attrs, level_provider)`, `attributes()`, `attribute(name)`, `unspent_attribute_points()` (authoritative), `spend_attribute_point`, `CheckTotals.compute(skill, sheet, perks, items)` (excludes Lore +2 with Maelis, Kosk's writ and the Strept badge: **those are owned by this plan**, Task 36). **inventory:** `ItemDefinition` + payloads, `Inventory` (`definition`, `room_for`, `all_ids`, `remove(id, n, force)`), `Equipment` (`equip`, `unequip(slot)`, `equipped(slot)`, `is_equipped(id)`), `QuickSlots.assign/clear/item_at`, `Wallet`, `Shop._init(stock, inventory, wallet)`, `buy(item_id, price_mod)`, `sell(item_id)`. **progression:** `LevelTable` (static), `ExperienceTrack` (`unspent_skill_points`, `spend_skill_point`), `SkillTreeDefinition`, `SkillNodeDefinition`, `SkillTree._init(def, track)` (`unlock` spends the point itself), `perks()`. **factions:** `FactionDefinition`, `ReputationLedger`. **rumors:** `RumorDefinition` (`verified_by`), `RumorPool` (`mark_heard(id, source)`, `is_heard`, `mark_verified`, `evaluate_verifications(facts)`).
P2's plan is `docs/superpowers/plans/2026-11-21-narrative-domains.md`; its "API extensions" and "Contract notes for P3" are binding here. Definitions take required fields in `_init` and optional ones through public vars or chainable `with_<field>()` setters; parsers may use either. **Every `pending_effects()` drains its queue** (like `drain_events()`): call it once and apply what it returns.

- **P2 quests:** `QuestDefinition` (+ `title`, `giver`, `available`, `xp`, `outcome_completed`, `outcome_failed`), `QuestStageDefinition`, `ObjectiveDefinition`, `StageTransition(stage, condition)`, `QuestLog._init(catalog)` (`start`, `evaluate`, `fail`, `complete_objective(quest_id, objective_id) -> Result`, `status()` = P1's four constants, `is_abandoned`, `journal()`, `pending_effects()`), `JournalEntry`, events `QuestStarted`, `ObjectiveCompleted`, `QuestCompleted`, `QuestFailed`, `QuestClosed`.
- **P2 investigation:** `ClueDefinition`, `DeductionDefinition`, `TheoryDefinition(id, title, suspects)`, `ClueBoard._init(clues, deductions)` (`deductions_for`), events `ClueDiscovered`, `DeductionUnlocked`.
- **P2 dialogue:** `DialogueDefinition` (+ `participants`, `faction`), `DialogueNodeDefinition`, **`DialogueNodeFactory`** (`line`, `choice`, `check`, `branch`, `effect`, `end` — parsers never touch `_internal/`), `DialogueBranchCase`, `DialogueOption` (+ `bribe`, `condition_text`), `CheckSpec(skill, dc, pass_node, fail_node)` + `with_faction()`, `CheckResolver.resolve/total/rep_mod`, `DialogueRunner._init(def, facts, memory)`, `DialogueView.kind` ∈ `line|choice|continue|end`, `DialogueOptionView`, `DialogueMemory`, event `CheckResolved`.
- **P2 companions:** `CompanionDefinition`, `Party._init(defs)` (`recruit`, `dismiss`, `in_party`, `allies`, `is_dead`, **`skill_bonus(skill)`**, `has_ability`, `set_command`, `command`, `revive`, `retreat -> Result`, `kill_scripted`, `active_companion`), `CompanionCommand` (`enum Kind`).
- **P2 travel:** `MapNodeDefinition._init(id, display_name)` + `with_unlock`, `MapEdgeDefinition._init(id, node_a, node_b, terrain)` + `with_condition`, `with_hazard(event_id, condition)`, `TravelGraph._init(nodes, edges)`, `TravelState._init(start_node)` (`unlock`, `begin_journey(to) -> Result`, `move_to`, `record_encounter(id)`, `previous_encounter`, `add_pin`, `pins`), `RoutePlanner.plan`, `Route`, `EncounterTableDefinition`, `EncounterEntryDefinition`, `EncounterRoller._init(tables, rng)` (`roll`, `drain_events`), `EncounterResult` (`kind`, `entry_id`, `terrain`, `slot`, `is_quiet()`, static `quiet(terrain)`), `EncounterModifiers` (incl. `previous_id`).
- **P2 finale:** `RitualMeter` (incl. `seize_vault(coerced)`, `choose_aftermath`, `record`), `FinaleRecord` (Snapshotable, `resolve`), `FinaleChoices._init(meter)`, **`FinaleSetup.configure(meter, facts)`** (bodyguards and modifiers; called once by `StartFinaleUseCase`). **endings:** `EndingFacts` (+ `is_consistent()`), `EndingRule._init(id, priority, condition)`, `EndingResolver`, `EpilogueSelector`, `EpilogueDefinition`.

## Content kinds (decision table; Task 6 encodes it in `ContentKinds`)

| kind | location under content root | id field → file stem | parser (task) | db catalog |
|---|---|---|---|---|
| items | `items/` | `id` suffix | ItemParser (26) | `items` |
| enemies, encounters | `enemies/`, `encounters/` | `id` suffix | raw for now | raw |
| encounter_tables | `encounter_tables/` | `terrain` (= stem) | EncounterTableParser (28) | `encounter_tables` |
| npcs, zones, event_cards | `npcs/`, `zones/`, `event_cards/` | `id` suffix | Zone (24), Npc and EventCard (25) | same names |
| dialogues, quests, clues, deductions, theories | same names | `id` suffix | P2 parsers (27) | same names |
| factions, rumors, skills | same names | `id` suffix (skills: `perk.*`) | P1 parsers (26) | same; `skills` also builds `skill_tree` |
| companions | `companions/` | `id` suffix (`companion.*` or `ally.*`) | CompanionParser (28) | `companions` |
| map_nodes, map_edges | `map/nodes/`, `map/edges/` | `id` suffix | Map parsers (28) | same |
| endings, epilogues | same names | `id` suffix | (28) | same |
| escalation | `escalation/stages.json` (singleton) | — | EscalationParser (26) | `escalation` |
| flags | `flags/<section_id or system>.json` | `section_id` | FlagDeclarationParser (25) | `flags` (one entry per declared id) |
| sections | `sections/<section_id>.json` | `section_id` | SectionParser (25) | `sections` |
| game_rules | `game_rules.json` (singleton) | — | GameRulesParser (25) | `rules` |

`content_version.json` (`{"content_version": "0.1.0"}`) sits at the root. Root entries starting with `_` (`_schemas/`, `_generated.json`) are not content.

## Review Focus

1. **JSON round trip of a save.** Numbers come back as floats and dictionary keys as `String`. Restoring a saved session after `JSON.stringify` → `JSON.parse_string` → `JsonValueNormalizer` must reproduce the identical snapshot (test in Task 35).
2. **YAML 1.1 surprises in the converter.** Content is YAML 1.2 core schema: `on: interact` (trigger blocks) must stay the key `"on"`, `answer: no` the string `"no"`, a date-like `2026-11-21` a string, while `truth: true` stays boolean (tests in Task 9).
3. **Autosave captures a half-settled session.** An autosave requested during a commit must run after the fixpoint settles, never inside a bus handler (test in Task 45).
4. **Interrupted or corrupt save.** A leftover `.tmp` or an unparsable main file must load from `.bak`, and a failing restore must leave the session untouched (tests in Tasks 18 and 35).
5. **A content effect cycle or a chain longer than the fixpoint cap.** The cap reports `fixpoint_cap_reached` instead of hanging, and the content cycle test catches the authored chain first (tests in Tasks 37 and 33).

---

## Wave 1 (no P1/P2 dependency)

### Task 1: Save snapshot values and schema

Wave: 1

**Files:**
- Create: `game/src/domain/save/save_meta.gd`, `save_snapshot.gd`, `save_schema.gd`, `game/src/domain/save/_internal/raw_values.gd`
- Test: `game/tests/unit/save/test_save_meta.gd`, `test_save_snapshot.gd`, `test_save_schema.gd`

**Interfaces:**
- Produces: `SaveMeta` (vars `slot: StringName`, `label: String`, `zone: StringName`, `spawn: StringName`, `act: int`, `stage: int`, `playtime_seconds: float`, `utc: String`; `to_dict() -> Dictionary`; `static from_dict(raw: Dictionary) -> Result`). `SaveSnapshot` (`const CURRENT_VERSION: int = 1`; `_init(meta: SaveMeta, content_version: String, sections: Dictionary[StringName, Dictionary], save_version: int = CURRENT_VERSION)`; `to_dict()`; `static from_dict(raw) -> Result`). `SaveSchema` (`_init(required_sections: Array[StringName])`; `validate(raw: Dictionary) -> Result`). `RawValues.to_int(v: Variant) -> Variant` (int, or null when not integral).

- [ ] **Step 1: Write the failing tests**

```gdscript
func test_meta_round_trips_through_dict() -> void:
	var m := _meta()  # slot &"manual_1", label "Act I · Drowned Rat", zone &"zone.drowned_rat", spawn &"front_door", act 1, stage 0, playtime 12.5, utc "2026-11-21T10:00:00Z"
	var back := SaveMeta.from_dict(m.to_dict())
	assert_true(back.is_ok())
	assert_eq((back.value as SaveMeta).zone, &"zone.drowned_rat")
	assert_eq((back.value as SaveMeta).act, 1)

func test_meta_accepts_integral_floats_from_json() -> void:
	var d := _meta().to_dict(); d["act"] = 2.0; d["stage"] = 3.0
	assert_eq((SaveMeta.from_dict(d).value as SaveMeta).stage, 3)

func test_meta_rejects_fractional_act() -> void:
	var d := _meta().to_dict(); d["act"] = 1.5
	assert_eq(SaveMeta.from_dict(d).error_code, &"save_invalid")

func test_snapshot_to_dict_uses_string_keys() -> void:
	var s := SaveSnapshot.new(_meta(), "0.1.0", {&"world": {"flags": []}})
	var d := s.to_dict()
	assert_eq(d["save_version"], 1)
	assert_true((d["sections"] as Dictionary).has("world"))

func test_snapshot_from_dict_restores_stringname_sections() -> void:
	var r := SaveSnapshot.from_dict(SaveSnapshot.new(_meta(), "0.1.0", {&"world": {"a": 1}}).to_dict())
	assert_true((r.value as SaveSnapshot).sections.has(&"world"))

func test_schema_reports_missing_section() -> void:
	var raw := SaveSnapshot.new(_meta(), "0.1.0", {&"world": {}}).to_dict()
	var r := SaveSchema.new([&"world", &"quests"]).validate(raw)
	assert_eq(r.error_code, &"save_invalid")
	assert_string_contains(r.detail, "sections.quests")

func test_schema_rejects_stage_out_of_range() -> void  # stage 5 → save_invalid, detail contains "meta.stage"
func test_schema_accepts_valid_raw() -> void           # ok
```

- [ ] **Step 2: Run** `tools/test.ps1 -Test tests/unit/save` → FAIL: parse error, `SaveMeta` not declared.

- [ ] **Step 3: Implement.** Meta field rules: `act` 1–3, `stage` 0–4, `playtime_seconds` ≥ 0, strings for the rest; `to_dict` writes `String` values for `StringName` fields. `SaveSchema.validate` checks `save_version` (int ≥ 1), `content_version` (String), `meta` (via the same rules), `sections` (Dictionary holding every required name as a Dictionary); detail is the first failing path (`meta.stage`, `sections.quests`). No JSON or file APIs.

- [ ] **Step 4: Run** `tools/test.ps1 -Test tests/unit/save` → Passing; then `tools/test.ps1` → exit 0.

- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/save game/tests/unit/save` — `feat(save): snapshot, meta and schema values`

### Task 2: Save migrations

Wave: 1

**Files:**
- Create: `game/src/domain/save/save_migration.gd`, `save_migrator.gd`, `game/tests/helpers/save/fake_rename_migration.gd`
- Test: `game/tests/unit/save/test_save_migrator.gd`

**Interfaces:**
- Produces: `@abstract SaveMigration` (`@abstract func from_version() -> int`, `@abstract func apply(raw: Dictionary) -> Dictionary`). `SaveMigrator` (`_init(migrations: Array[SaveMigration], current_version: int = SaveSnapshot.CURRENT_VERSION)`, `migrate(raw: Dictionary) -> Result` holding the upgraded Dictionary). Consumes `RawValues` (Task 1, same domain).

- [ ] **Step 1: Write the failing tests**

```gdscript
func test_current_version_passes_through_unchanged() -> void
func test_upgrades_step_by_step() -> void:
	var m := SaveMigrator.new([FakeRenameMigration.new(1, "a", "b"), FakeRenameMigration.new(2, "b", "c")], 3)
	var r := m.migrate({"save_version": 1, "sections": {"a": {}}})
	assert_eq(r.value["save_version"], 3)
	assert_true((r.value["sections"] as Dictionary).has("c"))
func test_newer_version_is_unsupported() -> void     # save_version 4 with current 3 → save_version_unsupported
func test_gap_in_chain_is_reported() -> void        # migrations from 1 only, current 3, raw v1 → save_migration_missing, detail "2"
func test_missing_version_is_invalid() -> void      # {} → save_invalid
func test_input_dictionary_is_not_mutated() -> void
```

- [ ] **Step 2: Run** `tools/test.ps1 -Test tests/unit/save/test_save_migrator.gd` → FAIL: `SaveMigrator` not declared.
- [ ] **Step 3: Implement.** Migrator deep-copies input, applies the migration whose `from_version()` equals the current number, then sets `save_version` to `n + 1` itself. Two migrations with the same `from_version` → `assert`.
- [ ] **Step 4: Run** the file, then `tools/test.ps1` → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/src/domain/save game/tests/unit/save game/tests/helpers/save` — `feat(save): step-by-step save migrator`

### Task 3: ContentDatabase generic store

Wave: 1

**Files:**
- Create: `game/src/application/content/content_database.gd`
- Test: `game/tests/application/content/test_content_database.gd`

**Interfaces:**
- Produces: `ContentDatabase` with `var content_version: String`, `put(kind: StringName, id: StringName, definition: RefCounted) -> void`, `put_raw(kind, id, record: Dictionary) -> void`, `has_id(id: StringName) -> bool` (any kind, typed or raw), `ids_of(kind) -> Array[StringName]` (sorted), `get_def(kind, id) -> Result`, `get_raw(kind, id) -> Result`, `count() -> int`.

- [ ] **Step 1: Write the failing tests**

```gdscript
func test_put_and_get_def() -> void:
	var db := ContentDatabase.new(); var d := RefCounted.new()
	db.put(&"items", &"item.iron_key", d)
	assert_same(db.get_def(&"items", &"item.iron_key").value, d)
func test_unknown_id_is_an_error() -> void:  # error_code unknown_id, detail "items:item.nope"
func test_has_id_covers_raw_records() -> void   # put_raw(&"enemies", &"enemy.wolf", {...}) → has_id true
func test_ids_of_is_sorted() -> void
func test_count_sums_all_kinds() -> void
```

- [ ] **Step 2: Run** → FAIL: `ContentDatabase` not declared.
- [ ] **Step 3: Implement** with `_defs: Dictionary[StringName, Dictionary]` and `_raw: Dictionary[StringName, Dictionary]` keyed by kind. Putting an id twice in one kind → `assert`.
- [ ] **Step 4: Run** file, then all → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/src/application/content game/tests/application/content` — `feat(app): content database store`

### Task 4: JsonReader and JsonValueNormalizer

Wave: 1

**Files:**
- Create: `game/src/infrastructure/content/json_reader.gd`, `game/src/infrastructure/save/json_value_normalizer.gd`
- Test: `game/tests/unit/infrastructure/content/test_json_reader.gd`, `game/tests/unit/infrastructure/save/test_json_value_normalizer.gd`

**Interfaces:**
- Produces: `JsonReader` (`_init(record: Dictionary, context: String, errors: Array[String] = [])`; `get_int(key: String, default: int = 0, required: bool = false) -> int`; `get_float`, `get_string`, `get_bool`, `get_array`, `get_dict` with the same shape; `get_id(key: String, kind: StringName, required: bool = true) -> StringName`; `get_optional_id(key, kind) -> StringName` (`&""` for null/missing); `child(record: Dictionary, context_suffix: String) -> JsonReader` sharing the error list; `errors() -> Array[String]`; `has_errors() -> bool`). `JsonValueNormalizer.normalize(value: Variant) -> Variant` (static).

- [ ] **Step 1: Write the failing tests**

```gdscript
func test_get_int_accepts_integral_float() -> void:
	var r := JsonReader.new({"dc": 4.0}, "dlg.x/foam")
	assert_eq(r.get_int("dc", 0, true), 4); assert_false(r.has_errors())
func test_get_int_rejects_fraction() -> void:
	var r := JsonReader.new({"dc": 4.5}, "dlg.x/foam"); r.get_int("dc")
	assert_eq(r.errors()[0], "dlg.x/foam.dc: expected an integer, got 4.5")
func test_required_missing_key_is_an_error() -> void   # message "<ctx>.<key>: required"
func test_get_id_checks_kind() -> void                 # "item.x" requested as &"zone" → error "...: expected a zone id"
func test_child_shares_errors() -> void
func test_normalizer_turns_integral_floats_into_ints() -> void:
	var n: Variant = JsonValueNormalizer.normalize({"a": 2.0, "b": [1.0, 1.5], "c": {"d": 3.0}})
	assert_eq(typeof(n["a"]), TYPE_INT); assert_eq(n["b"][1], 1.5); assert_eq(typeof(n["c"]["d"]), TYPE_INT)
func test_normalizer_leaves_huge_floats_alone() -> void  # 1e300 stays float (only |x| ≤ 2^53 converts)
```

- [ ] **Step 2: Run** `tools/test.ps1 -Test tests/unit/infrastructure` → FAIL: `JsonReader` not declared.
- [ ] **Step 3: Implement.** Error format: `"<context>.<key>: <message>"`. Strings convert to `StringName` only through `get_id`/`get_optional_id`.
- [ ] **Step 4: Run** the folder, then all → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/src/infrastructure game/tests/unit/infrastructure` — `feat(infra): json reader and number normalizer`

### Task 5: SchemaWalker and SchemaValidator

Wave: 1

**Files:**
- Create: `game/src/infrastructure/content/schema_walker.gd`, `schema_validator.gd`, `schema_keywords.gd`
- Test: `game/tests/unit/infrastructure/content/test_schema_validator.gd`, `test_schema_walker.gd`

**Interfaces:**
- Produces: `SchemaWalker.walk(value: Variant, schema: Dictionary, root: Dictionary, visitor: Callable) -> void` (static; visitor `func(path: String, value: Variant, node: Dictionary) -> void`; follows `$ref` (`#/definitions/<name>`), `properties`, schema-valued `additionalProperties`, `items`; descends only when the value has the matching container type; skips keys starting with `_`). `SchemaValidator` (`_init(condition_check: Callable, effects_check: Callable)` — each `func(text: String) -> String` returns `""` or an error message; `validate(value: Variant, schema: Dictionary) -> Array[String]`). `SchemaKeywords` static checks for scalar keywords.

Supported keywords exactly: `type` (`object|array|string|integer|number|boolean|null` or an array of them; `integer` accepts integral floats), `required`, `properties`, `additionalProperties` (false or schema), `enum`, `pattern`, `minimum`, `maximum`, `items`, `minItems`, `maxItems`, `$ref`, `definitions`, `description`, `title`, `x-id-kind` (a kind or array of kinds; value must pass `IdRules.is_valid`), `x-condition` (string passed to `condition_check`), `x-effects` (array of strings, each passed to `effects_check`). Any other keyword in a schema → error `"<path>: unsupported schema keyword 'x'"`.

- [ ] **Step 1: Write the failing tests** (validator built with `func(t): return ""` stubs unless stated)

```gdscript
func test_required_and_type() -> void:
	var errs := _v().validate({"id": 3}, {"type": "object", "required": ["id", "name"], "properties": {"id": {"type": "string"}}})
	assert_has(errs, "$.id: expected string, got integer")
	assert_has(errs, "$: missing required property 'name'")
func test_integer_accepts_integral_float() -> void
func test_additional_properties_false_ignores_underscore_keys() -> void:
	var s := {"type": "object", "properties": {"id": {"type": "string"}}, "additionalProperties": false}
	assert_eq(_v().validate({"id": "a", "_source": {"line": 3}}, s), [])
	assert_has(_v().validate({"id": "a", "extra": 1}, s), "$: unexpected property 'extra'")
func test_ref_resolves_definitions() -> void
func test_enum_pattern_min_max_items() -> void
func test_x_id_kind() -> void          # "zone.x" against x-id-kind "item" → "$.to: expected an item id, got 'zone.x'"
func test_x_condition_uses_callback() -> void   # condition_check returns "bad token" → "$.condition: bad token"
func test_x_effects_checks_each_string() -> void # path "$.effects[1]"
func test_unsupported_keyword_is_reported() -> void
func test_walker_visits_nested_paths() -> void   # collects "$", "$.nodes", "$.nodes.greet", "$.nodes.greet.next"
```

- [ ] **Step 2: Run** `tools/test.ps1 -Test tests/unit/infrastructure/content` → FAIL: `SchemaValidator` not declared.
- [ ] **Step 3: Implement.** The validator walks with `SchemaWalker` and applies node-level checks (`required`, `additionalProperties: false`, keyword checks) per visited node. Cache compiled `RegEx` per pattern string.
- [ ] **Step 4: Run** folder, then all → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/src/infrastructure/content game/tests/unit/infrastructure/content` — `feat(infra): schema subset validator`

### Task 6: ContentKinds, JsonContentReader, ContentRecordSet

Wave: 1

**Files:**
- Create: `game/src/infrastructure/content/content_kinds.gd`, `content_record.gd`, `content_record_set.gd`, `json_content_reader.gd`
- Modify: `game/src/domain/shared/id_rules.gd` (append `&"theory", &"epilogue"` to `KINDS`), `game/tests/unit/shared/test_id_rules.gd` (add `test_theory_and_epilogue_are_known_kinds`: `IdRules.is_valid(&"theory.poisoner", &"theory")` and `IdRules.is_valid(&"epilogue.strept_peace", &"epilogue")` are true)
- Test: `game/tests/unit/infrastructure/content/test_json_content_reader.gd`, `test_content_kinds.gd`

**Interfaces:**
- Produces: `ContentKinds` (static: `all() -> Array[StringName]`, `folder(kind) -> String`, `id_of(kind, data: Dictionary) -> StringName`, `expected_stem(kind, id) -> String`, `registers_global_id(kind) -> bool` — false for `escalation`, `encounter_tables`, `flags`, `sections`, `game_rules`). Values from the **Content kinds** table above. `ContentRecord` (`kind`, `id`, `path`, `data: Dictionary`). `ContentRecordSet` (`content_version: String`, `add(record) -> void`, `records(kind) -> Array[ContentRecord]`, `all() -> Array[ContentRecord]`, `errors: Array[String]`). `JsonContentReader.read(root: String) -> ContentRecordSet` (static).

- [ ] **Step 1: Write the failing tests.** `before_each` writes small JSON files to `user://test_tmp/reader/` (`items/iron_key.json` `{"id": "item.iron_key", ...}`, `content_version.json`).

```gdscript
func test_reads_records_by_kind() -> void:
	var set := JsonContentReader.read(ROOT)
	assert_eq(set.records(&"items")[0].id, &"item.iron_key"); assert_eq(set.content_version, "0.1.0")
func test_file_name_must_match_id_suffix() -> void   # items/wrong.json holding item.iron_key → error "…/items/wrong.json: file name must be iron_key.json"
func test_invalid_json_reports_path_and_line() -> void # "…/items/bad.json: invalid JSON at line 2: …"
func test_duplicate_id_is_reported() -> void
func test_singletons_and_section_keyed_kinds() -> void  # escalation/stages.json, flags/a1.01.json (section_id "a1.01"), game_rules.json
func test_underscore_entries_are_skipped() -> void      # _schemas/, _generated.json not read as content
func test_missing_content_version_is_an_error() -> void
func test_missing_folders_mean_empty_kinds() -> void
```

- [ ] **Step 2: Run** → FAIL: `JsonContentReader` not declared.
- [ ] **Step 3: Implement.** Parse with a `JSON` instance (`parse()`, `get_error_line()`, `get_error_message()`) so errors carry lines; top-level non-object → error. Files sorted by path for determinism.
- [ ] **Step 4: Run** file, then all → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/src/infrastructure/content game/tests/unit/infrastructure/content game/src/domain/shared/id_rules.gd game/tests/unit/shared/test_id_rules.gd` — `feat(infra): content reader and kind table; theory and epilogue id kinds`

### Task 7: Application events

Wave: 1

**Files:**
- Create in `game/src/application/events/`: `zone_entered.gd` (`zone_id`, `spawn_id`), `zone_first_visited.gd` (`zone_id`), `zone_exited.gd` (`zone_id`, `exit_id`), `checkpoint_reached.gd` (`checkpoint_id`), `rest_taken.gd` (`rest_point_id`), `new_game_started.gd` (`player_name`), `game_saved.gd` (`slot`), `game_loaded.gd` (`slot`, `zone_id`, `spawn_id`), `dialogue_requested.gd` (`dialogue_id`), `encounter_requested.gd` (`encounter_id`), `zone_change_requested.gd` (`zone_id`, `spawn_id`), `beat_requested.gd` (`beat_id`), `shop_requested.gd` (`npc_id`), `status_requested.gd` (`status`, `stacks`), `game_over_requested.gd` (`reason_id`), `escalation_card_requested.gd` (`stage`), `act_gate_opened.gd` (`act`), `rider_intercepted.gd`, `rider_delivered.gd`, `companion_commanded.gd` (`command: int`), `ending_shown.gd` (`ending_id`, `epilogue_ids: Array[StringName]`)
- Test: `game/tests/application/events/test_application_events.gd`

**Interfaces:**
- Produces: each class `extends DomainEvent`, typed fields set in `_init` in the order listed (ids `StringName`, `stage`/`act`/`stacks`/`command` `int`).

- [ ] **Step 1: Write the failing test**: one test per event constructing it and asserting each field, e.g. `assert_eq(ZoneEntered.new(&"zone.a", &"door").spawn_id, &"door")`, and `assert_true(RiderDelivered.new() is DomainEvent)`.
- [ ] **Step 2: Run** → FAIL: `ZoneEntered` not declared.
- [ ] **Step 3: Implement** the classes (header comment: architecture.md §3.1, §5.4).
- [ ] **Step 4: Run** file, then all → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/src/application/events game/tests/application/events` — `feat(app): application events`

### Task 8: Session-owned aggregates

Wave: 1

**Files:**
- Create in `game/src/application/session/`: `session_location.gd`, `zone_memory.gd`, `player_profile.gd`, `session_activity.gd`
- Test: `game/tests/application/session/test_session_location.gd`, `test_zone_memory.gd`, `test_player_profile.gd`, `test_session_activity.gd`

**Interfaces:**
- Produces:
  - `SessionLocation extends Snapshotable`: `zone: StringName`, `spawn: StringName`, `last_checkpoint: StringName`, `playtime_seconds: float`; `move_to(zone, spawn) -> bool` (true on first visit), `has_visited(zone) -> bool`, `visited() -> Array[StringName]`, `add_playtime(delta: float)`.
  - `ZoneMemory extends Snapshotable`: `is_spent(zone_id, local_id) -> bool`, `mark_spent(zone_id, local_id)`.
  - `PlayerProfile extends Snapshotable`: `player_name: String`.
  - (Application events are recorded in P1's `EventOutbox`, held as `GameSession.outbox`; no class of its own.)
  - `SessionActivity` (not saved): `dialogue_active`, `encounter_active`, `alarm_active`, `finale_active: bool`; `can_manual_save() -> bool` (all false); `reset()`.

- [ ] **Step 1: Write the failing tests**

```gdscript
func test_move_to_reports_first_visit_once() -> void:
	var l := SessionLocation.new()
	assert_true(l.move_to(&"zone.a", &"door")); assert_false(l.move_to(&"zone.a", &"cellar"))
	assert_eq(l.spawn, &"cellar")
func test_location_snapshot_round_trip_with_string_keys() -> void:
	# restore must accept what JSON gives back: Strings, integral floats
	var l := SessionLocation.new(); l.move_to(&"zone.a", &"door"); l.add_playtime(3.5)
	var copy := SessionLocation.new(); copy.restore(JSON_LIKE(l.to_snapshot()))  # helper: str() every StringName, float() every int
	assert_eq(copy.to_snapshot(), l.to_snapshot())
func test_zone_memory_marks_spent_per_zone() -> void
func test_activity_blocks_manual_save_in_dialogue() -> void
```

Put the `JSON_LIKE` conversion in `game/tests/helpers/save/json_like.gd` (`static func convert(d: Dictionary) -> Dictionary`).

- [ ] **Step 2: Run** `tools/test.ps1 -Test tests/application/session` → FAIL: `SessionLocation` not declared.
- [ ] **Step 3: Implement.** Snapshots store ids as `String` and arrays sorted; `restore` converts back to `StringName` and uses `float()`/`int()` on numbers.
- [ ] **Step 4: Run** folder, then all → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/src/application/session game/tests/application/session game/tests/helpers/save` — `feat(app): session-owned aggregates`

### Task 9: Converter — vendored YAML, block extraction, strict loader

Wave: 1

**Files:**
- Create: `tools/content_convert/vendor/yaml/*.py` (copied), `tools/content_convert/vendor/yaml/LICENSE`, `tools/content_convert/vendor/VENDORED.txt`, `tools/content_convert/cintra_convert/__init__.py`, `errors.py`, `markdown_blocks.py`, `yaml_loader.py`
- Test: `tools/content_convert/tests/__init__.py`, `test_markdown_blocks.py`, `test_yaml_loader.py`
- Delete: `tools/content_convert/.gitkeep`

**Language decision:** Python, run with `python -I`. Godot has no YAML parser, so a GDScript converter would need a hand-written YAML parser for nested flow mappings with quoted strings; PyYAML is mature, reports line marks, and is pure Python. PyYAML implements YAML 1.1, so this task gives it **YAML 1.2 core-schema scalar resolution** (the content must be read with 1.2 semantics) by replacing its implicit resolvers, and pins every 1.1 difference with a test. Python 3.12 is installed. Vendor PyYAML 6.0.4: copy every `*.py` from the installed package directory (`python -c "import yaml,os;print(os.path.dirname(yaml.__file__))"`) except `cyaml.py`, plus its MIT `LICENSE` from the `PyYAML-6.0.4.dist-info` folder. `VENDORED.txt` records name, version, source path and license.

**Interfaces:**
- Produces: `cintra_convert/__init__.py` inserts `<package>/../vendor` at `sys.path[0]` before importing `yaml`. `ConvertError(Exception)` with `file: str`, `line: int`, `message: str`, `__str__` = `"{file}:{line}: {message}"`. `markdown_blocks.split(text: str, file: str) -> SectionText` (`front_matter: str`, `front_line: int`, `blocks: list[Block]`); `Block(type: str, text: str, line: int)` where `line` is the 1-based line of the first YAML line. `yaml_loader.load(text: str, file: str, line: int) -> object`.
- Rules: front matter is the leading `---` … `---` pair (missing → `ConvertError(file, 1, "missing front matter")`). A fence whose info string is `yaml <type>` is a block; other fences are ignored; an unclosed fence is an error. The loader is `StrictLoader(yaml.SafeLoader)` whose `yaml_implicit_resolvers` is **rebuilt from scratch** with exactly the YAML 1.2 core schema: bool `true|True|TRUE|false|False|FALSE`; null `null|Null|NULL|~|` (empty); int `[-+]?[0-9]+`, `0o[0-7]+`, `0x[0-9a-fA-F]+`; float `[-+]?(\.[0-9]+|[0-9]+(\.[0-9]*)?)([eE][-+]?[0-9]+)?`, `[-+]?\.(inf|Inf|INF)`, `\.(nan|NaN|NAN)`. Everything else is a string — in particular `yes/no/on/off/y/n`, sexagesimal `1:30`, `0123`, `1_000`, timestamps like `2026-11-21`, and `=`. Duplicate mapping keys raise, anchors/aliases and `<<` merge keys raise, and YAML errors become `ConvertError` with absolute line numbers.

- [ ] **Step 1: Write the failing tests**

```python
def test_extracts_typed_blocks_with_lines(self):
    s = split(FIXTURE, "x.md")  # front matter, prose, ```yaml zone at line 12, ```python ignored
    self.assertEqual([b.type for b in s.blocks], ["zone", "dialogue"])
    self.assertEqual(s.blocks[0].line, 13)
def test_unclosed_fence_is_an_error(self): ...
def test_on_key_stays_a_string(self):
    self.assertEqual(load("on: interact\n", "x.md", 1), {"on": "interact"})
def test_no_and_yes_stay_strings(self):
    self.assertEqual(load("a: no\nb: yes\n", "x.md", 1), {"a": "no", "b": "yes"})
def test_true_is_boolean(self):
    self.assertIs(load("truth: true\n", "x.md", 1)["truth"], True)
def test_yaml_1_1_only_scalars_stay_strings(self):
    d = load("a: off\nb: 1:30\nc: 0123\nd: 2026-11-21\ne: 1_000\nf: y\n", "x.md", 1)
    self.assertEqual(d, {"a": "off", "b": "1:30", "c": "0123", "d": "2026-11-21", "e": "1_000", "f": "y"})
def test_core_schema_numbers_and_null(self):
    d = load("a: 4\nb: -40\nc: 1.0\nd: null\ne: ~\nf: 0x1F\n", "x.md", 1)
    self.assertEqual(d, {"a": 4, "b": -40, "c": 1.0, "d": None, "e": None, "f": 31})
def test_merge_key_is_rejected(self): ...
def test_duplicate_key_reports_absolute_line(self):
    with self.assertRaises(ConvertError) as cm: load("id: a\nid: b\n", "x.md", 40)
    self.assertEqual(cm.exception.line, 41)
def test_alias_is_rejected(self): ...
def test_flow_mapping_with_quoted_commas(self):
    self.assertEqual(load('o: {id: a, text: "x, y: z"}\n', "x.md", 1)["o"]["text"], "x, y: z")
```

- [ ] **Step 2: Run** `python -I -m unittest discover -s tools/content_convert/tests -t tools/content_convert -v` → FAIL: `ModuleNotFoundError: cintra_convert`.
- [ ] **Step 3: Implement** the modules (vendor copy first).
- [ ] **Step 4: Run** the converter tests → `OK`.
- [ ] **Step 5: Commit (orchestrator)** `git add tools/content_convert` — `feat(tools): converter block extraction and strict yaml loader`

### Task 10: Dialogue graph checker (content test helper)

Wave: 1

**Files:**
- Create: `game/tests/helpers/content/dialogue_graph_checker.gd`
- Test: `game/tests/content/checkers/test_dialogue_graph_checker.gd`

**Interfaces:**
- Produces: `DialogueGraphChecker.check(record: Dictionary) -> Array[String]` (static; works on the raw content-format §F.3 dictionary). Messages prefixed with the dialogue id.
- Rules (architecture §9.4, content-format §D): `start` exists; every node reachable from `start`; every `next`, `pass`, `fail`, branch `cases[].next` and `else` names an existing node; every node can reach an `end` node; every `choice` node has at least one *safe* option (no `condition` or condition `"true"`, no `check`, no `bribe`); every `check` has both `pass` and `fail`. Edges: `line.next`, `effect.next`, option `next` / `check.pass` / `check.fail`, `branch` cases and `else`, `check`-type node `pass`/`fail`.

- [ ] **Step 1: Write the failing tests** with inline dictionaries: a valid copy of the content-format §F.3 `dlg.bertha_intro` → `[]`; unreachable node → `"dlg.t: node 'orphan' is unreachable from 'greet'"`; missing next → `"dlg.t: node 'hub' option 'who' points to missing node 'nowhere'"`; dead end loop (a↔b without end) → `"dlg.t: node 'a' cannot reach an end node"`; choice with only conditional options → `"dlg.t: choice 'hub' has no unconditional option"`; check without fail → `"dlg.t: option 'foam' check needs pass and fail"`.
- [ ] **Step 2: Run** `tools/test.ps1 -Test tests/content/checkers` → FAIL: `DialogueGraphChecker` not declared.
- [ ] **Step 3: Implement** (BFS from start; reverse BFS from end nodes for "can reach an end").
- [ ] **Step 4: Run** folder, then all → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/tests/helpers/content game/tests/content/checkers` — `test(content): dialogue graph checker`

### Task 11: Condition relaxer (content test helper)

Wave: 1

**Files:**
- Create: `game/tests/helpers/content/condition_relaxer.gd`
- Test: `game/tests/content/checkers/test_condition_relaxer.gd`

**Interfaces:**
- Produces: `ConditionRelaxer.relax(text: String) -> String` (static). Replaces every `not <unary>` with `true`, following the content-format §C grammar: after `not`, consume a parenthesised group, or another `not <unary>`, or one value (call with balanced parentheses, INT or WORD) optionally followed by a comparison operator and a second value. Used by reachability (monotone over-approximation, architecture §9.4).

- [ ] **Step 1: Write the failing tests**

```gdscript
func test_relaxes_simple_not() -> void:
	assert_eq(ConditionRelaxer.relax("stage() >= 2 and not flag(flag.strept_guides)"), "stage() >= 2 and true")
func test_relaxes_not_over_comparison() -> void:
	assert_eq(ConditionRelaxer.relax("not stage() >= 2"), "true")
func test_relaxes_not_over_group() -> void:
	assert_eq(ConditionRelaxer.relax("a(x) or not (flag(flag.a) and ms(ms.b))"), "a(x) or true")
func test_leaves_words_containing_not() -> void:
	assert_eq(ConditionRelaxer.relax("flag(flag.notary_paid)"), "flag(flag.notary_paid)")
func test_double_not() -> void:  # "not not flag(flag.a)" → "true"
```

- [ ] **Step 2: Run** → FAIL: `ConditionRelaxer` not declared.
- [ ] **Step 3: Implement** a small tokenizer (words, ints, `(`, `)`, `,`, operators).
- [ ] **Step 4: Run** folder, then all → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/tests/helpers/content game/tests/content/checkers` — `test(content): condition relaxer`

---

## Wave 2

### Task 12: Ports, GameSettings, fakes, in-memory save repository

Wave: 2 · Depends: Task 1

**Files:**
- Create: `game/src/application/ports/content_source.gd`, `save_repository.gd`, `settings_store.gd`, `wall_clock.gd`, `game_logger.gd`, `game_settings.gd`; `game/src/infrastructure/save/in_memory_save_repository.gd`; `game/tests/helpers/fakes/capturing_logger.gd`, `fixed_wall_clock.gd`, `in_memory_content_source.gd`
- Test: `game/tests/application/ports/test_game_settings.gd`, `game/tests/unit/infrastructure/save/test_in_memory_save_repository.gd`, `game/tests/application/ports/test_fakes.gd`

**Interfaces:**
- Produces: `@abstract ContentSource.load_all() -> Result` (ContentDatabase). `@abstract SaveRepository`: `write(slot: StringName, snapshot: Dictionary) -> Result`, `read(slot) -> Result` (Dictionary), `list() -> Array[SaveMeta]` (sorted by slot), `delete(slot) -> Result`. `@abstract SettingsStore`: `load() -> GameSettings`, `save(s: GameSettings) -> Result`. `@abstract WallClock.now_utc_string() -> String` (ISO `YYYY-MM-DDTHH:MM:SSZ`). `@abstract GameLogger`: `info(message: String)`, `warn`, `error`. `GameSettings` (below). `InMemorySaveRepository extends SaveRepository` (deep-copies on write and read; `read` of a missing slot → `save_not_found`; `list` skips entries whose meta fails `SaveMeta.from_dict`). `CapturingLogger` (`lines: Array[String]` as `"INFO: …"`, `"WARN: …"`, `"ERROR: …"`; `errors() -> Array[String]`). `FixedWallClock._init(times: Array[String])` (returns them in order, then repeats the last). `InMemoryContentSource._init(db: ContentDatabase)`.
- `GameSettings` fields and defaults (gdd §6.17): `difficulty: StringName = &"normal"` (`story|normal|hard`), `bindings: Dictionary[StringName, Array] = {}` (action → serialized events, see Task 19), `toggle_actions: Array[StringName] = []` (subset of `block, sprint, crouch, aim` set to toggle instead of hold), `subtitles: bool = true`, `subtitle_size: StringName = &"m"` (`s|m|l|xl`), `subtitle_background: bool = true`, `ui_scale: float = 1.0` (clamped 0.8–1.5), `screen_shake: float = 1.0`, `camera_bob: float = 1.0` (0–1), `flash_reduction: bool = false`, `volume_master/music/sfx/voice: float = 1.0` (0–1), `skip_non_boss_combat: bool = false`. `to_dict() -> Dictionary`, `static from_dict(d: Dictionary) -> GameSettings` (unknown enum values → defaults, numbers clamped).

- [ ] **Step 1: Write the failing tests**

```gdscript
func test_settings_defaults() -> void:
	var s := GameSettings.new(); assert_eq(s.difficulty, &"normal"); assert_true(s.subtitles)
func test_settings_round_trip() -> void
func test_settings_clamps_and_rejects_unknown_values() -> void:
	var s := GameSettings.from_dict({"ui_scale": 3.0, "difficulty": "brutal", "subtitle_size": "xl"})
	assert_eq(s.ui_scale, 1.5); assert_eq(s.difficulty, &"normal"); assert_eq(s.subtitle_size, &"xl")
func test_in_memory_repo_write_read_list_delete() -> void
func test_in_memory_repo_returns_copies() -> void   # mutating the read dict does not change the stored one
func test_fixed_clock_sequence() -> void
func test_capturing_logger_prefixes() -> void
```

- [ ] **Step 2: Run** `tools/test.ps1 -Test tests/application/ports` → FAIL: `GameSettings` not declared.
- [ ] **Step 3: Implement** the ports (`@abstract`), settings, adapter and fakes.
- [ ] **Step 4: Run** both test folders, then all → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/src/application/ports game/src/infrastructure/save game/tests/helpers/fakes game/tests/application/ports game/tests/unit/infrastructure/save` — `feat(app): ports, settings value, fakes`

### Task 13: Schemas A (zones, npcs, dialogues, encounters, items, clues, deductions, quests)

Wave: 2 · Depends: Task 5

**Files:**
- Create: `game/content/_schemas/{zones,npcs,dialogues,encounters,items,clues,deductions,quests}.schema.json`, sample records `game/tests/fixtures/schemas/<kind>/valid_*.json` and `invalid_*.json` (at least one each per kind)
- Test: `game/tests/content/checkers/test_schemas_a.gd`
- Delete: `game/content/_schemas/.gdkeep`

**Interfaces:**
- Produces: one JSON Schema per kind using only Task 5's keywords. Shapes are content-format §F.1–§F.5, §F.6, §F.7 exactly (field names, enums, defaults are optional fields). Markers: every id field gets `x-id-kind`; every `condition`, `when`, `if`, `available`, `closes_on`, `verified_by`, `requires` gets `x-condition`; every effect list (`effects`, `on_complete`, `on_won`, `on_yielded`, `on_player_fled`, `on_enter`, `fail_effects`, `on_hear`, `pass_effects`) gets `x-effects`. Objects use `additionalProperties: false`. Enums: zone `kind` (interior|exterior|dungeon|arena|hub), `time_of_day`, interactable `kind` (search|container|door|readable|lever|rest|shop|map_board|pickup), trigger `on` (enter|interact|exit_attempt|beat_done|encounter_done), hazard `kind`, npc `disposition`, item `category`, `equip_slot`, option `tag`, check `skill` (persuade|intimidate|investigate|lore), clue `supports`/`refutes` items (varn|pell|anselm|raimund|vandals). `encounters.zone` is a zone id or matches `^arena:(lowlands|valley|mountain)$`. `quests` covers both shapes: main (converter output: `id`, `kind: "main"`, `title`, `stages`) and side (§F.7 header). Dialogue `nodes` is an object whose `additionalProperties` is a node schema (`type` enum line|choice|check|branch|effect|end).
- `game/tests/content/checkers/test_schemas_a.gd` loads each schema with `JSON.parse_string` and validates samples with a `SchemaValidator` built from stub checks (`func(t): return ""`).

- [ ] **Step 1: Write the failing test**

```gdscript
const KINDS := ["zones", "npcs", "dialogues", "encounters", "items", "clues", "deductions", "quests"]
func test_valid_samples_pass() -> void:       # every tests/fixtures/schemas/<kind>/valid_*.json → []
func test_invalid_samples_fail() -> void:     # every invalid_*.json → at least one error
func test_schemas_use_only_supported_keywords() -> void  # validating {} against each schema yields no "unsupported schema keyword"
func test_content_format_examples_pass() -> void  # valid_example.json per kind = the content-format §F example block as JSON
```

- [ ] **Step 2: Run** `tools/test.ps1 -Test tests/content/checkers/test_schemas_a.gd` → FAIL: missing schema files.
- [ ] **Step 3: Write** the schemas and samples.
- [ ] **Step 4: Run** the file, then all → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/content/_schemas game/tests/fixtures/schemas game/tests/content/checkers` — `feat(content): schemas for narrative kinds`

### Task 14: Schemas B (remaining kinds)

Wave: 2 · Depends: Task 5

**Files:**
- Create: `game/content/_schemas/{rumors,event_cards,flags,sections,escalation,endings,epilogues,factions,theories,skills,companions,enemies,map_nodes,map_edges,encounter_tables,game_rules}.schema.json`, samples under `game/tests/fixtures/schemas/<kind>/`
- Test: `game/tests/content/checkers/test_schemas_b.gd` (same four tests as Task 13 over these kinds)

**Interfaces — shapes** (content-format §F.8–§F.11, §H for writer kinds; the rest decided here):
- `rumors` §F.8 (`truth` enum `[true, false, "half", "cover"]`). `event_cards` §F.9 (`table_slot` integer 1–8, `"esc"` or null; check `{skill, dc, pass_effects, fail_effects}`). `flags`: `{section_id, declare: [{id, type: bool|int|milestone, min?, max?, desc}], reads: [ids]}` (`declare[].id` kinds flag|var|ms). `sections`: front matter fields + `branches` (§F.11).
- `escalation`: `{stages: [{stage 0–4, name, condition (x-condition), on_enter (x-effects), card_text: [string, string]}]}` (minItems 5, maxItems 5).
- `endings`: `{id, name, priority (integer ≥ 1), condition}`. `epilogues`: `{id (x-id-kind epilogue), ending (ending id or null), order (integer), condition, title, text}`.
- `factions`: `{id, name, leader, start (−100…100), thresholds: {wary, neutral, friendly, allied}}` (lower bounds; below `wary` is hostile).
- `theories`: `{id (theory), title, suspects: [string]}`. `skills`: `{id (perk), name, branch: blade|road|tongue, tier: 1–4 (4 = capstone), description}`. `companions`: `{id (companion|ally), name, kind: companion|ally, description}`.
- `enemies`: `{id, name, level, hp, damage, damage_type (slash|pierce|blunt|fire|cold|poison), armor, poise, resist: {<damage type>: number}, tags: [string], xp (integer ≥ 0), behavior}`.
- `map_nodes`: `{id (map), name, terrain: lowlands|valley|mountain, unlock (x-condition)}`. `map_edges`: `{id (edge), a (map), b (map), terrain, condition (x-condition), kind: road|sea|barge, hazard: {event (event id), condition (x-condition)} | null}` (gdd §6.3 forced hazards).
- `encounter_tables`: `{terrain, entries: [{slot 1–8, kind: combat|event_card|discovery|hazard, ref (enc|event|esc id or null), requires}] (exactly 8), escalation_pool: [{id (esc), kind, ref, requires}] (minItems 3)}`.
- `game_rules`: exactly the keys of Task 22's `game_rules.json` (`new_game`, `act_gates`, `xp`, `prices`, `antidote`, `rumor_price`, `finale_timers`, `finale_modifiers`).

- [ ] **Step 1–5** as Task 13 (run `tools/test.ps1 -Test tests/content/checkers/test_schemas_b.gd`; commit `git add game/content/_schemas game/tests/fixtures/schemas game/tests/content/checkers` — `feat(content): schemas for world and system kinds`).

### Task 15: JsonContentSource and ContentKindParser

Wave: 2 · Depends: Tasks 3, 5, 6

**Files:**
- Create: `game/src/infrastructure/content/content_kind_parser.gd`, `json_content_source.gd`
- Test: `game/tests/unit/infrastructure/content/test_json_content_source.gd`, helper `game/tests/helpers/content/fake_kind_parser.gd`

**Interfaces:**
- Produces: `@abstract ContentKindParser` — `@abstract func kind() -> StringName`; `@abstract func parse_into(record: ContentRecord, db: ContentDatabase) -> Array[String]` (puts definitions, returns errors); `func finish(db: ContentDatabase) -> Array[String]` (default `[]`, called once after all records). `JsonContentSource extends ContentSource` — `_init(root: String, validator: SchemaValidator, parsers: Array[ContentKindParser], cross_referencer: ContentCrossReferencer = null)`; `load_all() -> Result`; `last_records() -> ContentRecordSet` (for content tests). `ContentCrossReferencer` is Task 16; declare the parameter typed and pass `null` until then is not possible in parallel, so **this task types the 4th parameter as `RefCounted`** and Task 16 tightens it to `ContentCrossReferencer`.
- Flow: read → schema per kind from `<root>/_schemas/<kind>.schema.json` (missing schema → error `"<kind>: schema missing"`) → validate each record (errors prefixed with the record path) → parser for the kind, or `db.put_raw` → `finish` on every parser → cross-referencer (Task 16) → `Result.err(&"content_invalid", "\n".join(sorted errors))` or `Result.ok(db)`; `db.content_version` from the record set.

- [ ] **Step 1: Write the failing tests** (temp content under `user://test_tmp/source/` with real schemas copied from `res://content/_schemas/items.schema.json`):

```gdscript
func test_loads_and_parses_with_registered_parser() -> void   # FakeKindParser for items puts RefCounted → db.get_def ok
func test_kinds_without_parser_are_stored_raw() -> void
func test_reports_every_error_not_just_the_first() -> void:
	# two broken records in two kinds → error_code content_invalid; detail has 2 lines, each starting with the file path
func test_parser_errors_are_collected() -> void
func test_finish_runs_once_after_all_records() -> void
func test_content_version_is_copied() -> void
```

- [ ] **Step 2: Run** → FAIL: `JsonContentSource` not declared.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run** file, then all → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/src/infrastructure/content game/tests/unit/infrastructure/content game/tests/helpers/content` — `feat(infra): json content source with parser registry`

### Task 16: ContentCrossReferencer

Wave: 2 · Depends: Tasks 5, 6 (edits Task 15's parameter type in Wave 3 if Task 15 lands later: see Step 3)

**Files:**
- Create: `game/src/infrastructure/content/content_cross_referencer.gd`
- Modify: `game/src/infrastructure/content/json_content_source.gd` (parameter type `RefCounted` → `ContentCrossReferencer`, call `check`)
- Test: `game/tests/unit/infrastructure/content/test_content_cross_referencer.gd`

**Interfaces:**
- Produces: `ContentCrossReferencer._init(condition_ids: Callable, effect_ids: Callable)` (each `func(text: String) -> Array[StringName]`, returning `[]` when the text does not parse); `check(records: ContentRecordSet, schemas: Dictionary[StringName, Dictionary]) -> Array[String]`.
- Known ids = ids of every record whose kind `registers_global_id`, plus every `flags` `declare[].id`. Walk each record with `SchemaWalker`; for `x-id-kind` values, `x-condition` strings and each `x-effects` string, every referenced id must be known. Message: `"<path>: <json path> references unknown id '<id>'"`.

- [ ] **Step 1: Write the failing tests** (records built in memory; callables stubbed to split ids out of text with a regex `[a-z]+\.[a-z0-9_]+`):

```gdscript
func test_known_ids_pass() -> void
func test_unknown_id_field_is_reported() -> void     # exit to_zone zone.nowhere
func test_ids_inside_conditions_and_effects() -> void
func test_declared_flags_count_as_known() -> void
func test_source_reports_cross_reference_errors() -> void  # JsonContentSource with the referencer → content_invalid naming the id
```

- [ ] **Step 2: Run** → FAIL: `ContentCrossReferencer` not declared.
- [ ] **Step 3: Implement**; then tighten `JsonContentSource`'s 4th parameter type and call `check` when it is not null. (Schedule this task after Task 15 lands; the files do not overlap otherwise.)
- [ ] **Step 4: Run** content infra tests, then all → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/src/infrastructure/content game/tests/unit/infrastructure/content` — `feat(infra): content cross-referencer`

### Task 17: Converter — assemble records

Wave: 2 · Depends: Task 9

**Files:**
- Create: `tools/content_convert/cintra_convert/block_types.py`, `assemble.py`
- Test: `tools/content_convert/tests/test_assemble.py`, fixtures `tools/content_convert/tests/fixtures/valid/{act1/01-alpha.md,act1/02-beta.md,side/gamma.md}`, `tools/content_convert/tests/fixtures/invalid/*.md` (one defect each)

**Interfaces:**
- Produces: `BLOCK_TYPES: dict[str, BlockType]` with `BlockType(out_dir: str | None, required: tuple[str, ...])`; `assemble(files: list[tuple[str, str]]) -> dict[str, dict]` mapping output path (relative to the content root, e.g. `"zones/drowned_rat.json"`) to record; raises `ConvertErrors(list[ConvertError])` with **all** errors.
- Mapping (content-format §H): `zone→zones/`, `npc→npcs/`, `dialogue→dialogues/`, `encounter→encounters/`, `item→items/`, `clue→clues/`, `deduction→deductions/`, `rumor→rumors/`, `event_card→event_cards/`, `quest→quests/` (file stem = id suffix); `flags→flags/<section_id>.json` `{section_id, declare, reads, _source}`; front matter + `branches` → `sections/<section_id>.json` (front-matter keys + `branches` or `{}`); `quest_stages` → merged into `quests/<suffix>.json` as `{id, kind: "main", title, stages}` with stages sorted by `order` (stable within a block), titles from `MAIN_QUEST_TITLES = {"quest.main_a1": "Ashes in the Lion's Den", "quest.main_a2": "The Marnadal Road", "quest.main_a3": "Under Amell"}` (gdd §6.11), unknown main quest → title = id.
- Required fields: front matter `section_id, title, act`; zone `id, name, kind, areas, spawns`; npc `id, name, role, motive`; dialogue `id, participants, start, nodes`; encounter `id, zone, enemies`; item `id, name, category`; clue `id, theory, title, text`; deduction `id, theory, condition`; quest `id, kind, title, stages`; quest_stages `quest, order, stages` (each stage `id`); rumor `id, text, truth`; event_card `id, title, text, options`; flags `declare` (each `id, type`); branches none.
- Errors (`file:line: message`): unknown block type; missing required field; duplicate output path or duplicate id (both locations); duplicate `order` or stage id within a quest; a side `quest` also receiving `quest_stages`; an id declared twice in `flags`.
- `_source = {"file": <repo-relative posix path>, "line": <block line>, "section": <section_id>, "act": <act or 0 for side files>}` on every record and on every merged quest stage.

- [ ] **Step 1: Write the failing tests**

```python
def test_maps_blocks_to_output_paths(self):
    out = assemble(load_fixture_dir("valid"))
    self.assertIn("zones/alpha_room.json", out); self.assertIn("sections/a1.01.json", out); self.assertIn("flags/a1.01.json", out)
def test_merges_quest_stages_by_order(self):
    q = assemble(load_fixture_dir("valid"))["quests/main_a1.json"]
    self.assertEqual([s["id"] for s in q["stages"]], ["first", "second", "third"])
    self.assertEqual(q["title"], "Ashes in the Lion's Den"); self.assertEqual(q["stages"][0]["_source"]["section"], "a1.01")
def test_branches_embedded_in_section(self): ...
def test_source_annotation(self): ...
def test_collects_all_errors(self):
    with self.assertRaises(ConvertErrors) as cm: assemble(load_fixture_dir("invalid"))
    msgs = [str(e) for e in cm.exception.errors]
    self.assertTrue(any("unknown block type 'zonee'" in m for m in msgs))
    self.assertTrue(any("missing required field 'name'" in m for m in msgs))
    self.assertTrue(any("duplicate id 'item.dup'" in m for m in msgs))
    self.assertTrue(any("duplicate order 10 in quest.main_a1" in m for m in msgs))
    self.assertTrue(any("flag.twice declared twice" in m for m in msgs))
    self.assertTrue(any("side quest quest.side_x also receives quest_stages" in m for m in msgs))
```

- [ ] **Step 2: Run** the converter tests → FAIL: `ImportError: assemble`.
- [ ] **Step 3: Implement.** Conditions and effects are copied verbatim (content-format §H.2).
- [ ] **Step 4: Run** → `OK`.
- [ ] **Step 5: Commit (orchestrator)** `git add tools/content_convert` — `feat(tools): assemble content records from markdown blocks`

---

## Wave 3

### Task 18: JsonFileSaveRepository

Wave: 3 · Depends: Tasks 1, 4, 12

**Files:**
- Create: `game/src/infrastructure/save/json_file_save_repository.gd`
- Test: `game/tests/unit/infrastructure/save/test_json_file_save_repository.gd`

**Interfaces:**
- Produces: `JsonFileSaveRepository extends SaveRepository` — `_init(root: String = "user://saves")`. Valid slots: `quick`, `manual_1..3`, `auto_1..3` (gdd §6.16); others → `save_bad_slot`.
- `write`: `JSON.stringify(snapshot, "  ", true)` to `<slot>.json.tmp`, flush/close, if `<slot>.json` exists rename it to `<slot>.json.bak` (replacing an old `.bak`), then `DirAccess.rename` tmp → `<slot>.json`. Any failure → `save_write_failed` (detail: path).
- `read`: parse `<slot>.json`; if missing → `save_not_found`; if unparsable or not an object, try `.bak`; if both fail → `save_corrupt`. Returns `JsonValueNormalizer.normalize(parsed)`.
- `list`: every valid slot file whose `meta` parses (`SaveMeta.from_dict`), sorted by slot. `delete`: removes `.json`, `.bak`, `.tmp`.

- [ ] **Step 1: Write the failing tests** (root `user://test_tmp/saves`)

```gdscript
func test_write_then_read_round_trips_with_ints() -> void:
	repo.write(&"manual_1", _raw())  # contains "act": 1
	assert_eq(typeof(repo.read(&"manual_1").value["meta"]["act"]), TYPE_INT)
func test_second_write_keeps_a_bak() -> void
func test_corrupt_main_file_falls_back_to_bak() -> void   # overwrite manual_1.json with "{oops" → read returns the bak content
func test_leftover_tmp_is_ignored() -> void               # manual_1.json.tmp with garbage → read returns the main file
func test_both_corrupt_is_save_corrupt() -> void
func test_bad_slot() -> void                               # &"manual_9" → save_bad_slot
func test_list_returns_metas_sorted() -> void
func test_delete_removes_all_three_files() -> void
```

- [ ] **Step 2: Run** → FAIL: `JsonFileSaveRepository` not declared.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run** file, then all → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/src/infrastructure/save game/tests/unit/infrastructure/save` — `feat(infra): atomic json save repository`

### Task 19: ConfigFileSettingsStore and InputRemapApplier

Wave: 3 · Depends: Task 12

**Files:**
- Create: `game/src/infrastructure/settings/config_file_settings_store.gd`, `game/src/infrastructure/godot/input_event_codec.gd`, `game/src/infrastructure/godot/input_remap_applier.gd`
- Test: `game/tests/unit/infrastructure/settings/test_config_file_settings_store.gd`, `game/tests/unit/infrastructure/godot/test_input_remap_applier.gd`

**Interfaces:**
- Produces: `ConfigFileSettingsStore extends SettingsStore` (`_init(path: String = "user://settings.cfg")`; section `settings`, one key per `GameSettings.to_dict()` key; missing or unreadable file → defaults). `InputEventCodec` (static `encode(e: InputEvent) -> Dictionary`, `decode(d: Dictionary) -> InputEvent` or null): `{"type": "key", "physical_keycode": int}`, `{"type": "mouse_button", "button_index": int}`, `{"type": "joy_button", "button_index": int}`, `{"type": "joy_axis", "axis": int, "axis_value": float}`. `InputRemapApplier.apply(bindings: Dictionary[StringName, Array]) -> Array[String]` (static; for each action present in `InputMap`, `action_erase_events` then add decoded events; unknown action or undecodable event → a warning string, others still applied).

- [ ] **Step 1: Write the failing tests**: store round trip at `user://test_tmp/settings.cfg`; missing file gives defaults; codec round trip per event type; applier replaces the events of a test action created in `before_each` with `InputMap.add_action(&"test_action")` (erased in `after_each`); unknown action returns `"unknown action 'nope'"`.
- [ ] **Step 2: Run** → FAIL: classes not declared.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run** both folders, then all → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/src/infrastructure/settings game/src/infrastructure/godot game/tests/unit/infrastructure` — `feat(infra): settings store and input remapping`

### Task 20: OsWallClock and GodotLogger

Wave: 3 · Depends: Task 12

**Files:**
- Create: `game/src/infrastructure/godot/os_wall_clock.gd`, `godot_logger.gd`
- Test: `game/tests/unit/infrastructure/godot/test_port_adapters.gd`

**Interfaces:**
- Produces: `OsWallClock extends WallClock` (`Time.get_datetime_string_from_system(true)` + `"Z"`). `GodotLogger extends GameLogger` (`print` for info, `push_warning`, `push_error`; prefix `"[game] "`).
- [ ] **Step 1: Test**: clock string matches `^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$`; `GodotLogger.new() is GameLogger`; `info` does not error.
- [ ] **Step 2: Run** → FAIL. **Step 3: Implement.** **Step 4: Run** → pass; all → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/src/infrastructure/godot game/tests/unit/infrastructure/godot` — `feat(infra): wall clock and logger adapters`

### Task 21: Converter — writer, manifest, CLI

Wave: 3 · Depends: Task 17

**Files:**
- Create: `tools/content_convert/cintra_convert/writer.py`, `tools/content_convert/convert.py`
- Modify: `CLAUDE.md` (add a "Content conversion" section with the two commands below)
- Test: `tools/content_convert/tests/test_writer.py`, `test_cli.py`

**Interfaces:**
- Produces: `render(record: dict) -> str` = `json.dumps(record, sort_keys=True, indent=2, ensure_ascii=False) + "\n"`. `write_all(out_root: Path, records: dict[str, dict], check: bool) -> list[str]` (returns changed paths; in check mode writes nothing). Manifest `<out_root>/_generated.json` = `{"files": [sorted relative paths]}`; files listed in the previous manifest but not produced now are deleted (never touches unlisted files). CLI: `python -I tools/content_convert/convert.py [--src docs/content] [--out game/content] [--check]`; sources = every `*.md` under `--src` except names starting with `_`, sorted; exit 0 on success, 1 on conversion errors (each printed `file:line: message`, sorted) or, with `--check`, when any file would change (prints them).

- [ ] **Step 1: Write the failing tests**

```python
def test_render_is_sorted_and_indented(self): ...
def test_second_run_is_byte_identical(self):   # run twice into a TemporaryDirectory, compare bytes of every file
def test_stale_generated_file_is_removed_but_hand_authored_kept(self):
def test_check_mode_reports_changes_without_writing(self):
def test_cli_exit_codes(self):  # subprocess [sys.executable, "-I", convert.py, --src fixtures/valid, --out tmp] → 0; fixtures/invalid → 1 and stderr lines "file:line: …"
```

- [ ] **Step 2: Run** converter tests → FAIL: `ImportError: writer`.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run** → `OK`.
- [ ] **Step 5: Commit (orchestrator)** `git add tools/content_convert CLAUDE.md` — `feat(tools): content converter writer and CLI`

### Task 22: System content data

Wave: 3 · Depends: Task 14 (schemas)

**Files:**
- Create: `game/content/content_version.json` (`{"content_version": "0.1.0"}`), `game/content/game_rules.json`, `game/content/escalation/stages.json`, `game/content/endings/{bitter_bargain,shattered_lock,ashes_and_iron,lion_holds,boy_king}.json`, `game/content/factions/<8>.json`, `game/content/theories/{poisoner,fourth_verse,choir,anselm_plan}.json`, `game/content/skills/<18>.json`, `game/content/companions/{maelis,dravin,strept_warband,aldric,kosk_cavalry,forest_guide,wyvern}.json`, `game/content/enemies/<23>.json`, `game/content/flags/system.json`; remove the `.gdkeep` in each folder that now has content.
- Test: `game/tests/content/test_system_content.gd`

**Data (copy exactly):**
- `game_rules.json`: `new_game` = `{default_name: "Hale", attribute_base: 3, creation_points: 4, creation_max: 6, start_act: 1, start_zone: "zone.drowned_rat", start_spawn: null, start_map_node: "map.cintra", crowns: 30, items: [{item: "item.arming_sword", count: 1, equip: "main_hand"}, {item: "item.gambeson", count: 1, equip: "armor"}, {item: "item.crossbow", count: 1, equip: "ranged"}, {item: "item.crossbow_bolts", count: 8, equip: null}, {item: "item.poultice", count: 2, equip: null}]}` (gdd §6.6, §6.9); `act_gates` = `[{act: 1, milestone: "ms.act1_gate_met", condition: "ms(ms.a1_audience_done) and count_ms(ms.a1_sickroom_done, ms.a1_abbey_done, ms.a1_ring_done) >= 2"}, {act: 2, milestone: "ms.act2_gate_met", condition: "ms(ms.a2_wenna_line_resolved) and ded(ded.anselm_treason_proven) and has_item(item.true_fourth_verse)"}]` (gdd §7.1, §7.2); `xp` = `{clue_by_act: [20, 30, 40], deduction_by_act: [60, 90, 120], check_per_act: 15, zone_first_visit: 30, travel_combat_mult: 0.5}` (§6.8); `prices` = `{crown_lands_mult: 1.1, realm_mult: 1.2, haggler_mult: 0.8, crown_lands_nodes: ["map.cintra", "map.chociebuz", "map.gull_tower", "map.barrows", "map.brzezina_woods"]}` (§6.1, §6.8); `antidote` = `{item: "item.wenna_antidote", rider_cost: 40, sale_crowns: 300, sale_faction: "faction.attre", sale_rep: 50}` (§6.2); `rumor_price: 5` (decision; content §14 leaves it to the application); `finale_timers` = `{story: [70, 16], normal: [50, 20], hard: [40, 22]}` (§6.17); `finale_modifiers` = `{gear_brake_t_rev: 1.25, maelis_t_true: 0.8}` (§6.14).
- `escalation/stages.json` (gdd §6.1), with `A2 = "ms.a2_tigg_resolved, ms.a2_cipher_taken, ms.a2_jory_dealt, ms.a2_torc_taken, ms.a2_wenna_line_resolved, ms.a2_attre_ledger, ms.a2_vel_aram_cleared"`: stage 0 Equinox `"true"`; 1 Cracked Stone `"ms(ms.act1_complete)"`; 2 Dark River `"stage() >= 1 and count_ms(A2) >= 3"`; 3 Open Knives `"stage() >= 1 and (count_ms(A2) >= 5 or (ms(ms.a2_wenna_line_resolved) and ded(ded.anselm_treason_proven) and has_item(item.true_fourth_verse)))"` (the full Act II gate, evaluated as a full condition by `EscalationTrack.recompute`); 4 Solstice `"ms(ms.act2_twist)"`. `on_enter: []` for every stage (gdd's stage gameplay effects are rules read through `stage()`, and the conditional Varn penalty is an open item for content reconciliation). `card_text`: two lines per stage from gdd §6.1 "World changes".
- `endings` (gdd §6.15): `bitter_bargain` "The Bitter Bargain" priority 1 `"finale_seized()"`; `shattered_lock` "The Shattered Lock" 2 `"finale_oath() == reversed and finale_anselm() == dead"`; `ashes_and_iron` "Ashes & Iron" 3 `"finale_oath() == reversed and finale_anselm() == fled"`; `lion_holds` "The Lion Holds" 4 `"finale_oath() == true and flag(flag.queen_alive)"`; `boy_king` "The Boy King" 5 `"finale_oath() == true and not flag(flag.queen_alive)"`.
- `factions` (gdd §6.12; thresholds `{wary: -49, neutral: -9, friendly: 10, allied: 50}` for all): crown 0 (Kosk), varn 0, attre 0 (Raimund), strept −10 (Hesk Ironjaw), ferrymen 0 (Jory), choir −30, abbey 10 (Maelis), wenna −10.
- `theories` (§6.11): poisoner `[varn, pell, anselm, raimund]`, fourth_verse `[anselm, vandals]`, choir `[]`, anselm_plan `[]`.
- `skills` (§6.8): blade T1 steady_hand, shoulder_charge; T2 riposte_master, heavy_swing; T3 iron_skin; T4 lions_fury. road T1 quick_reload, pathfinder; T2 field_medic, cold_blooded; T3 hunters_eye; T4 second_wind. tongue T1 silver_tongue, hard_stare; T2 keen_eye, haggler; T3 read_the_room; T4 kingmaker. Descriptions = the gdd cell text.
- `companions` (§6.13): kinds companion (maelis, dravin) and ally (the rest).
- `enemies` (§6.7, §6.8 XP): every row of the §6.7 table plus `enemy.anselm_human` (HP 150, armor 5, xp 0). Use the first number of a range (bandit: level 3, hp 55, damage 10, armor 10, xp 15). Resist letters: w = 1.5, r = 0.5, i = 0.0. XP: thug 10, cutthroat 10, crossbowman 12, hound 8, bandit 15, assassin 25, drowner 20, wolf 15, revenant_footman 35, revenant_rider 60, zealot 40, sharpshooter 45, frost_troll 120, iron_warden 150, wyvern 400, wyvern_roost 800, soot_hound 600, corvan_shade 500, sea_serpent 500, woodwose 300, ash_bound_zealot 0 (finale), anselm_human 0.
- `flags/system.json` (`section_id: "system"`): declare `flag.queen_alive`, `flag.maelis_poisoned`, `flag.maelis_poison_pending`, `flag.maelis_dead`, `flag.antidote_rider_en_route`, `flag.aldric_co_sovereign`, `flag.aldric_emergency_writ`, `flag.aldric_crowned_king`, `flag.aldric_coerced` (bool) and `ms.act1_gate_met`, `ms.act2_gate_met` (milestone). Before adding each, `grep -rn "id: <id>" docs/content`; skip any id a section already declares and list skips in the report.

- [ ] **Step 1: Write the failing test**

```gdscript
func test_system_files_match_schemas() -> void   # JsonContentReader + SchemaValidator (stub checks) over res://content restricted to the kinds above → no errors
func test_five_stages_in_order() -> void          # stages[i].stage == i, names Equinox…Solstice
func test_five_endings_with_priorities_1_to_5() -> void
func test_eighteen_perks_six_per_branch() -> void
func test_faction_starts() -> void                # strept -10, choir -30, abbey 10, wenna -10, others 0
func test_new_game_rules() -> void                # crowns 30, five starting items, creation_max 6
```

- [ ] **Step 2: Run** `tools/test.ps1 -Test tests/content/test_system_content.gd` → FAIL: files missing.
- [ ] **Step 3: Write** the data files.
- [ ] **Step 4: Run** file, then all → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/content game/tests/content/test_system_content.gd` — `feat(content): system data from the gdd tables`

### Task 23: Fixture content set

Wave: 3 · Depends: Tasks 13, 14

**Files:**
- Create under `game/tests/fixtures/content/` (same layout as `game/content/`, schemas **not** copied; the fixture loader points `_schemas` at `res://content/_schemas`, see Task 34): `content_version.json` (`"0.0.1-fixture"`), `game_rules.json` (as Task 22 but `start_zone: "zone.fx_tavern"`, `start_map_node: "map.fx_town"`, act gate 1 `"ms(ms.fx_one) and ms(ms.fx_two)"`), and the records below.
- Remove: `game/tests/fixtures/content/.gdkeep`
- Test: `game/tests/content/checkers/test_fixture_content.gd`

**Fixture inventory** (one self-consistent world used by every application test):
- `zones/fx_tavern.json`: spawns `front_door` (default), `cellar`; exit `to_street` → `zone.fx_street`/`gate`, condition `"true"`; exit `locked_door` condition `"flag(flag.fx_door_open)"`; interactables `chest` (container, once, effects `["give_item(item.fx_key, 1)"]`), `lever` (lever, check `{skill: investigate, dc: 4}`, effects `["set_flag(flag.fx_lever)"]`, fail_effects `["add_var(var.fx_tries, 1)"]`), `bed` (rest), `pickup_coin` (pickup, once, `["add_crowns(5)"]`); triggers `t_enter` (on enter, once, `["start_quest(quest.fx_main)"]`), `t_after_chest` (on interact, source `chest`, once, `["reach_milestone(ms.fx_one)"]`), `t_beat` (on beat_done, source `b_intro`, `["set_flag(flag.fx_beat_seen)"]`); checkpoints `cp_start`; beats `b_intro`; npcs `npc.fx_barkeep`; encounters `enc.fx_brawl`; loot `cellar_shelf` → `item.poultice` ×1; variant `after_one` when `"ms(ms.fx_one)"` disabling interactable `pickup_coin`.
- `zones/fx_street.json`: spawn `gate` (default), map_node `map.fx_town`.
- `npcs/fx_barkeep.json`: dialogue `dlg.fx_barkeep`, shop `{stock: [{item: item.poultice, count: 5}], price_mod: 1.0}`, faction `faction.fx_guild`.
- `dialogues/fx_barkeep.json`: `greet` (line, effects `["set_flag(flag.fx_met)"]`) → `hub` (choice: `ask` → `answer`; `probe` check investigate dc 4 pass `probe_pass` (effect node `["add_clue(clue.fx_clue)"]`) fail `probe_fail`; `bribe` bribe 10 → `bye`; `leave` → `bye`) → `bye` (end).
- `items/`: `fx_key` (key), `poultice` (consumable `{effects: ["heal_player(40)"], use_time: 1.0}`, price 10, stack 10), `arming_sword` (weapon, main_hand), `gambeson` (armor), `crossbow` (weapon, ranged), `crossbow_bolts` (ammo, stack 20), `wenna_antidote` (key), `true_fourth_verse` (key).
- `quests/fx_main.json` (main, stages `find_key` [objective `get_key` `"has_item(item.fx_key)"`, optional `met` `"flag(flag.fx_met)"` xp 20] → `pull_lever` [objective `"flag(flag.fx_lever)"`], on_complete `["reach_milestone(ms.fx_two)"]`); `quests/fx_side.json` (side, available `"true"`, xp 200, one stage objective `"has_clue(clue.fx_clue)"`).
- `clues/fx_clue.json` (theory `theory.fx_theory`, supports `[varn]`), `deductions/fx_ded.json` (condition `"has_clue(clue.fx_clue)"`), `theories/fx_theory.json`.
- `factions/fx_guild.json` (start 0), `factions/attre.json`, `factions/crown.json`, `factions/strept.json` (copies of Task 22's).
- Speaker-modifier fixtures: `npcs/fx_official.json` (faction `faction.crown`, dialogue null), `npcs/fx_highlander.json` (faction `faction.strept`), `items/kosk_writ.json` (key, `equip_slot: trinket`).
- `escalation/stages.json`: 0 `"true"`, 1 `"ms(ms.fx_one)"`, 2 `"ms(ms.fx_two)"`, 3 `"ms(ms.fx_three)"`, 4 `"ms(ms.fx_four)"`; stage 1 `on_enter: ["set_flag(flag.fx_stage_one)"]`.
- `endings/`: the five real ending files copied from Task 22.
- `map/nodes/fx_town.json` (unlock `"true"`), `fx_ford.json` (unlock `"ms(ms.fx_one)"`), `map/edges/fx_town_ford.json` (lowlands, condition `"true"`).
- `encounter_tables/lowlands.json`: 8 entries (slot 1 event card `event.fx_card`, others `discovery` with ref null) and a 3-entry pool `esc.fx_a/b/c` (kind discovery).
- `event_cards/fx_card.json` (lowlands, slot 1; options `help` check intimidate dc 5 pass `["add_rep(faction.fx_guild, 5)"]` fail `["damage_player(5)"]`, `ride_on`).
- `rumors/fx_rumor.json` (sources `[npc.fx_barkeep]`, on_hear `["set_flag(flag.fx_rumor)"]`).
- `skills/`: `field_medic` (road 2), `haggler` (tongue 2), `pathfinder` (road 1), `steady_hand` (blade 1).
- `companions/`: `maelis`, `dravin` (companion), `forest_guide` (ally).
- `enemies/fx_thug.json` (xp 10); `encounters/fx_brawl.json` (zone `zone.fx_tavern`, 2 × `enemy.fx_thug`, on_won `["reach_milestone(ms.fx_three)"]`).
- `epilogues/fx_epilogue.json` (ending null, condition `"true"`).
- `flags/fx.01.json` declaring every `flag.fx_*`, `var.fx_tries` (int 0–3), `ms.fx_*` used above; `flags/system.json` copied from Task 22; `sections/fx.01.json` (act 1, zones both fixture zones, milestones_set `[ms.fx_one, ms.fx_two]`).

- [ ] **Step 1: Write the failing test**: `JsonContentReader.read("res://tests/fixtures/content")` has no errors; every record validates against `res://content/_schemas/<kind>.schema.json` (stub checks); expected record counts per kind; every dialogue passes `DialogueGraphChecker`.
- [ ] **Step 2: Run** → FAIL (missing files). **Step 3: Write** the fixtures. **Step 4: Run** → pass; all → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/tests/fixtures/content game/tests/content/checkers` — `test(content): fixture content set`

---

## Wave 4 (needs P1 `rules`; parser tasks also need the named P1/P2 definitions)

Every parser below: `class_name <Kind>Parser extends ContentKindParser` in `game/src/infrastructure/content/parsers/`, reads only through `JsonReader` and `RuleReader`, puts definitions with `db.put(<kind>, id, def)`, and has one test file `game/tests/unit/infrastructure/content/parsers/test_<kind>_parser.gd` that parses the fixture record (Task 23) or the content-format §F example and asserts the architecture-named fields, plus one bad record producing a `"<path>: …"` error.

### Task 24: RuleReader and zone definitions

Wave: 4 · Depends: P1 rules (`ConditionParser`, `EffectParser`, `Condition`, `EffectSpec`), P2 `CheckSpec`; Tasks 4, 15

**Files:**
- Create: `game/src/infrastructure/content/parsers/rule_reader.gd`, `zone_parser.gd`; in `game/src/application/content/definitions/`: `zone_definition.gd`, `spawn_definition.gd`, `zone_exit_definition.gd`, `interactable_definition.gd`, `zone_trigger_definition.gd`, `zone_npc_definition.gd`, `loot_definition.gd`, `zone_variant_definition.gd`
- Test: `game/tests/unit/infrastructure/content/parsers/test_rule_reader.gd`, `test_zone_parser.gd`, `game/tests/application/content/test_zone_definition.gd`

**Interfaces:**
- Produces: `RuleReader` (instance: `_init(effects: EffectParser)` — the parser built over the one shared `EffectSignatures` registry; `condition(r: JsonReader, key: String, default_text: String = "true") -> Condition` via the static `ConditionParser.parse`, `effects(r: JsonReader, key: String) -> Array[EffectSpec]` via `parse_list`; parse failures become reader errors `"<ctx>.<key>: <parser detail>"` and return a `"false"` condition / empty list; `check_skill(r, key) -> StringName` errors unless `CheckSkills.is_check_skill`). Every parser that reads rules takes `_init(rules: RuleReader)`. Definitions (plain `RefCounted`, fields set in `_init` or by the parser, read-only by convention):
  - `ZoneDefinition`: `id, name, kind, map_node, time_of_day: StringName`, `cold_rate: float`, `disguise_tag, music: StringName`, `spawns: Array[SpawnDefinition]`, `exits: Array[ZoneExitDefinition]`, `interactables: Array[InteractableDefinition]`, `triggers: Array[ZoneTriggerDefinition]`, `hazards: Array[Dictionary]`, `checkpoints: Array[StringName]`, `beats: Array[StringName]`, `npcs: Array[ZoneNpcDefinition]`, `encounters: Array[StringName]`, `loot: Array[LootDefinition]`, `variants: Array[ZoneVariantDefinition]`; methods `default_spawn() -> StringName`, `has_spawn(id) -> bool`, `find_exit(id) -> ZoneExitDefinition`, `find_interactable(id) -> InteractableDefinition`, `find_trigger(id) -> ZoneTriggerDefinition`, `find_loot(id) -> LootDefinition` (null when missing), `triggers_for(on: StringName, source: StringName) -> Array[ZoneTriggerDefinition]`.
  - `SpawnDefinition(id, area, is_default)`, `ZoneExitDefinition(id, area, to_zone, to_spawn, condition, effects)`, `InteractableDefinition(id, area, kind, label, condition, check: CheckSpec (null = none), once, effects, fail_effects)`, `ZoneTriggerDefinition(id, area, on, source, condition, once, effects)`, `ZoneNpcDefinition(npc, area, condition)`, `LootDefinition(container, items: Dictionary[StringName, int], condition)`, `ZoneVariantDefinition(id, when: Condition, npcs_absent, encounters_disabled, interactables_disabled: Array[StringName])`.
- Rules: `ZoneParser.parse_into` errors when no spawn or more than one is `default: true` (`"<path>: zone needs exactly one default spawn"`).

- Tests build the `RuleReader` from `EffectParser.new(ContentFormatEffects.signatures())` (P1 helper).
- [ ] **Steps 1–5** (tests: RuleReader parses `"true"` and reports a bad condition with path; ZoneParser on `fx_tavern` yields 2 spawns, default `front_door`, `triggers_for(&"interact", &"chest")` has `t_after_chest`, lever check skill `investigate` dc 4; zone with two defaults → error). Run `tools/test.ps1 -Test tests/unit/infrastructure/content/parsers` → FAIL first, then pass; all → exit 0. Commit `git add game/src/infrastructure/content/parsers game/src/application/content/definitions game/tests/unit/infrastructure/content/parsers game/tests/application/content` — `feat(content): zone definitions and parser`.

### Task 25: Other application definitions and parsers

Wave: 4 · Depends: Task 24 (RuleReader), P1 rules

**Files:**
- Create definitions (in `game/src/application/content/definitions/`): `npc_definition.gd`, `shop_definition.gd`, `section_definition.gd`, `flag_declaration.gd`, `game_rules_definition.gd`, `starting_item.gd`, `act_gate_definition.gd`; event-card data (in `game/src/domain/travel/`, header cites content-format §F.9 and gdd §6.3 "event_card"): `event_card_definition.gd`, `event_card_option_definition.gd`; parsers: `npc_parser.gd`, `event_card_parser.gd`, `section_parser.gd`, `flag_declaration_parser.gd`, `game_rules_parser.gd`
- Test: one parser test per parser, plus `game/tests/unit/travel/test_event_card_definition.gd` (`safe_options()` and `option(id)`)

**Interfaces:**
- `NpcDefinition(id, name, faction, role, disposition, essential, dialogue, barks: Array[String], combat, shop: ShopDefinition)`; `ShopDefinition(stock: Dictionary[StringName, int], price_mod: float)`.
- `EventCardDefinition._init(id, terrain, title, text)` with vars `table_slot: int` (0 = none, −1 = `"esc"`), `requires: Condition` (null = true), `options: Array[EventCardOptionDefinition]`, `combat: StringName`; `option(id) -> EventCardOptionDefinition` (null if missing), `safe_options() -> Array[EventCardOptionDefinition]` (no condition, no check, no bribe). `EventCardOptionDefinition._init(id, text)` with vars `condition: Condition` (null = true), `tag: StringName`, `check_skill: StringName` (`&""` = none), `check_dc: int`, `pass_effects`, `fail_effects`, `effects: Array[EffectSpec]`, `bribe: int`. Pure data in the travel domain (references only `rules`). `EventCardParser` errors when a card has no safe option (content-format §F.9).
- `SectionDefinition(section_id: String, title, act: int, zones, available_when: Condition, stage_min, stage_max: int, milestones_set: Array[StringName], branches: Dictionary)`.
- `FlagDeclaration(id, type: StringName (bool|int|milestone), min_value, max_value: int, section_id: String)`; the parser puts one entry per declared id under kind `flags`; a missing `min`/`max` for an int → `-2147483648` / `2147483647`.
- `GameRulesDefinition`: `default_name: String`, `attribute_base, creation_points, creation_max, start_act, crowns: int`, `start_zone, start_spawn, start_map_node: StringName`, `starting_items: Array[StartingItem]` (`item, count, equip_slot`), `act_gates: Array[ActGateDefinition]` (`act, milestone, condition`), `clue_xp_by_act, deduction_xp_by_act: Array[int]`, `check_xp_per_act, zone_first_visit_xp: int`, `travel_combat_mult, crown_lands_mult, realm_mult, haggler_mult: float`, `crown_lands_nodes: Array[StringName]`, `antidote_item: StringName`, `rider_cost, antidote_sale_crowns, antidote_sale_rep: int`, `antidote_sale_faction: StringName`, `rumor_price: int`, `finale_timers: Dictionary[StringName, Vector2]` (x = T_rev, y = T_true), `gear_brake_t_rev, maelis_t_true: float`. Stored as `db.put(&"game_rules", &"game_rules", def)`.

- [ ] **Steps 1–5** (tests assert the Task 23 fixture values: barkeep shop stock poultice 5; card option `help` check intimidate 5; `var.fx_tries` max 3; rules `crowns == 30`, `finale_timers[&"hard"] == Vector2(40, 22)`). Commit `git add game/src/application/content/definitions game/src/domain/travel/event_card_definition.gd game/src/domain/travel/event_card_definition.gd.uid game/src/domain/travel/event_card_option_definition.gd game/src/domain/travel/event_card_option_definition.gd.uid game/src/infrastructure/content/parsers game/tests/unit/infrastructure/content/parsers game/tests/unit/travel/test_event_card_definition.gd` — `feat(content): npc, event card, section, flag and rules parsers`.

### Task 26: P1-kind parsers

Wave: 4 · Depends: Task 24; P1 `ItemDefinition`, `FactionDefinition`, `RumorDefinition`, `SkillTreeDefinition`, `EscalationRules`, `EscalationStageDefinition`

**Files:** `item_parser.gd`, `faction_parser.gd`, `rumor_parser.gd`, `skill_parser.gd`, `escalation_parser.gd` + one test each.

**Interfaces:**
- `ItemParser`: §F.5 → `ItemDefinition` (weapon/armor/consumable payloads as P1 defines; consumable `effects` via `RuleReader.effects`).
- `FactionParser`: thresholds → P1's tier table. `RumorParser`: `truth` true/false booleans → `&"true"`/`&"false"`, strings → `StringName`; `available`, `verified_by` conditions; `on_hear` effects.
- `SkillParser`: collects perk records; `finish(db)` builds the one `SkillTreeDefinition` and puts it as `db.put(&"skill_tree", &"skill_tree", tree)`; also errors if a branch has a tier gap.
- `EscalationParser`: the singleton → `EscalationRules` with 5 `EscalationStageDefinition`s, put as `db.put(&"escalation", &"escalation", rules)`; error if stages are not 0..4 in order.
- [ ] **Steps 1–5** as the Wave 4 pattern. Commit `git add game/src/infrastructure/content/parsers game/tests/unit/infrastructure/content/parsers` — `feat(content): parsers for P1 content kinds`.

### Task 27: P2-kind parsers A

Wave: 4 (schedule after Task 25: the dialogue test loads an NPC through `NpcParser`) · Depends: Tasks 24, 25; P2 `QuestDefinition`, `QuestStageDefinition`, `ObjectiveDefinition`, `ClueDefinition`, `DeductionDefinition`, `TheoryDefinition`, `DialogueDefinition`, `DialogueNodeFactory`, `DialogueOption`, `CheckSpec`

**Files:** `quest_parser.gd`, `clue_parser.gd`, `deduction_parser.gd`, `theory_parser.gd`, `dialogue_parser.gd` + one test each.

**Interfaces:** `QuestParser` handles main (`kind: main`) and side quests (§F.7: `next` entries `{if, stage}` → P2 `StageTransition`; `outcome_effects.completed/failed` → `outcome_completed/outcome_failed`). `DialogueParser` builds nodes **only through `DialogueNodeFactory`** (`line`, `choice`, `check`, `branch`, `effect`, `end`) and `DialogueBranchCase`; options per §F.3 with defaults (`condition "true"`, `show_locked false`, `once false`, `bribe 0`); option checks → `CheckSpec(skill, dc, pass, fail)`. In `finish(db)` it sets each `DialogueDefinition.faction` (and every `CheckSpec.with_faction`) from the first participant NPC's `faction` (`db.get_def(&"npcs", …)`), so it needs `NpcParser` (Task 25) in the same load. `ClueParser` maps `theory`, `supports`, `refutes`, `title`, `text`; XP is not in clue data (XpPolicy applies gdd §6.8 by act).
- [ ] **Steps 1–5** (dialogue test parses the content-format §F.3 example and asserts node count 9 and option `foam` check dc 4). Commit — `feat(content): quest, investigation and dialogue parsers`.

### Task 28: P2-kind parsers B

Wave: 4 · Depends: Task 24; P2 `CompanionDefinition`, `MapNodeDefinition`, `MapEdgeDefinition`, `EncounterTableDefinition`, `EndingRule`, epilogue definition type

**Files:** `companion_parser.gd`, `map_node_parser.gd`, `map_edge_parser.gd`, `encounter_table_parser.gd`, `ending_parser.gd`, `epilogue_parser.gd` + one test each.

**Interfaces:** `MapNodeParser`: `MapNodeDefinition(id, name).with_unlock(cond)`. `MapEdgeParser`: `MapEdgeDefinition(id, a, b, terrain).with_condition(cond)`; an edge's optional `hazard: {event, condition}` field (Task 14 schema) → `with_hazard(event_id, cond)`. `EndingParser` builds `EndingRule._init(id, priority, condition)`; `finish(db)` errors on duplicate priorities. `EncounterTableParser` keys by terrain (`db.put(&"encounter_tables", &"lowlands", table)`).
- [ ] **Steps 1–5**. Commit — `feat(content): companion, map, encounter table, ending and epilogue parsers`.

### Task 29: Real-content checks — schemas, references, condition/effect parse, dialogue graphs, local refs

Wave: 4 · Depends: Tasks 10, 15, 16, P1 rules

**Files:**
- Create: `game/tests/helpers/content/content_test_kit.gd`, `game/tests/helpers/content/local_reference_checker.gd`
- Test: `game/tests/content/test_schemas.gd`, `test_references.gd`, `test_conditions_and_effects_parse.gd`, `test_dialogue_graphs.gd`, `game/tests/content/checkers/test_local_reference_checker.gd`

**Interfaces:**
- `ContentTestKit` (static): `signatures() -> EffectSignatures` (until Task 43: `ContentFormatEffects.signatures()`; Task 43 switches it to the registry filled by `EffectHandlerSet`, so ops added later with a handler are accepted), `effect_parser() -> EffectParser`, `records(root: String = "res://content") -> ContentRecordSet`, `validator() -> SchemaValidator` wired to `ConditionParser.parse` / `effect_parser().parse` (error text = `error_code: detail`), `referencer() -> ContentCrossReferencer` wired to `referenced_ids()`, `is_empty(set) -> bool` (no records outside the Task 22 system kinds).
- `LocalReferenceChecker.check(set: ContentRecordSet) -> Array[String]`: `goto_zone(zone, spawn)` → spawn exists in that zone; `complete_objective(quest, obj)` → objective exists; `play_beat(beat)` inside a zone record → beat listed in that zone's `beats`; exits' `to_spawn` exists in `to_zone`; trigger `source` names an interactable/exit/beat/encounter of the same zone.
- Real-content tests: when `ContentTestKit.is_empty(records())` call `pending("no converted content yet")`; otherwise assert the error list is empty and print each error with `gut.p`.

- [ ] **Step 1**: checker tests with inline records (spawn missing → `"zones/a.json: goto_zone(zone.b, nowhere): spawn 'nowhere' not in zone.b"`); the four real-content test files.
- [ ] **Step 2**: Run `tools/test.ps1 -Test tests/content` → FAIL (classes missing). **Step 3**: Implement. **Step 4**: `tools/test.ps1 -Suite content` → passes or pending; all → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/tests/helpers/content game/tests/content` — `test(content): schema, reference, parse and dialogue graph checks`

### Task 30: Reachability facts (provider and effect mapper)

Wave: 4 · Depends: Tasks 11, 29 (`ContentTestKit.effect_parser`), P1 `FactProvider`, `EffectSpec`, `EffectParser`

**Files:**
- Create in `game/tests/helpers/content/`: `reachable_facts.gd`, `optimistic_fact_provider.gd`, `effect_fact_mapper.gd`
- Test: `game/tests/content/checkers/test_optimistic_fact_provider.gd`, `test_effect_fact_mapper.gd`

**Interfaces:**
- `ReachableFacts`: `keys: Dictionary[StringName, bool]`; `add(key) -> bool` (true if new), `has(key) -> bool`, `var_max: Dictionary[StringName, int]`, `rep_up/rep_down: Dictionary[StringName, bool]`, `max_stage: int`, `max_act: int`, `duplicate() -> ReachableFacts`.
- Fact key convention: plain ids for flags, milestones, items, clues, deductions, perks, companions/allies, rumors (heard), zones (visited), map nodes (unlocked), `dlg.*` (startable), `enc.*` (started); `quest.x#active`, `quest.x#done`, `quest.x#failed`, `quest.x@<stage>`.
- `OptimisticFactProvider extends FactProvider` — `_init(facts: ReachableFacts, high: bool, max_check: int)`. High mode: attributes 10, `check_total` = `max_check`, `crowns` 9999, `level` 12, `reputation` 100 if `rep_up` else start value, `rep_tier` from that, `get_var` = `var_max` (0 if untouched), `escalation_stage` = `max_stage`, `act` = `max_act`, `queen_condition()` 0. Low mode: attributes 3, `check_total` 0, crowns 0, level 1, reputation −100 if `rep_down` else start, `get_var` 0, stage 0, act 1, `queen_condition()` 3. Boolean calls (incl. `visited`, `rumor_heard`, `in_party`) read `keys` in both modes; `quest_status` returns P1's `QUEST_*` constants from the `#active/#done/#failed` keys; `finale_value`: seized `&"false"`, oath `&"none"`, anselm `&"alive"`. A condition is *satisfiable* when `ConditionParser.parse(ConditionRelaxer.relax(text))` evaluates true in high **or** low mode.
- `EffectFactMapper.apply(spec: EffectSpec, facts: ReachableFacts, declared_max: Dictionary[StringName, int]) -> bool` (true if anything new): `set_flag`, `reach_milestone`, `give_item`, `add_clue`, `recruit`, `add_ally`, `add_rumor`, `unlock_map_node`, `add_map_pin` → the id; `goto_zone` → zone id; `start_quest` → `#active`; `fail_quest` → `#failed`; `start_dialogue` → dlg id; `start_encounter` → enc id; `set_act(n)` → `max_act`; `set_var`/`add_var` → `var_max` = declared max (or the literal for `set_var`); `add_rep` → `rep_up`/`rep_down` by sign; `administer_antidote(queen)` → `flag.antidote_administered`; others no-op.

- [ ] **Steps 1–5** (tests: `"stage() >= 2 and not flag(flag.x)"` satisfiable once `max_stage` 2; `"var(var.b) == 0"` satisfiable in low mode; mapper adds `quest.q#active` for `start_quest(quest.q)`). Commit `git add game/tests/helpers/content game/tests/content/checkers` — `test(content): optimistic facts for reachability`.

---

## Wave 5

### Task 31: Guarded effect index and reachability analyzer

Wave: 5 · Depends: Tasks 29, 30

**Files:**
- Create in `game/tests/helpers/content/`: `guarded_effects.gd`, `guarded_effect_index.gd`, `reachability_options.gd`, `reachability_analyzer.gd`
- Test: `game/tests/content/checkers/test_reachability_analyzer.gd` (runs on the Task 23 fixture records)

**Interfaces:**
- `GuardedEffects` value: `origin: String` (path + local id), `requires: Array[StringName]` (fact keys that must already hold), `guard: String` (condition text, `"true"` if none), `check_skill: StringName`, `check_dc: int` (0 = no check), `effects: Array[String]`, `produces: Array[StringName]` (keys added when the group fires), `act: int` (from `_source.act`, 0 = any), `losable_items: Array[StringName]` (items whose possession the guard tests).
- `GuardedEffectIndex.build(set: ContentRecordSet) -> Array[GuardedEffects]`, one group per: zone exit (requires zone; produces `to_zone`; effects), interactable (requires zone; pass effects with the check, fail effects without), trigger (requires zone), zone npc (requires zone; produces the npc's `dlg`), zone encounter (requires zone; produces enc), loot (requires zone; give_item per item), encounter outcome (`on_won`, `on_yielded`, `on_player_fled`, each requires enc), dialogue node effects and option effects (requires dlg; option guard = option condition; nodes reachable only through a check carry that check's skill/dc — computed per dialogue by BFS), quest stage (requires `#active` and the previous stage key; guard = AND of required objective conditions; produces `quest.x@stage` and, for terminal stages, `#done`; effects `on_complete`, plus `outcome_effects.completed` on done), deduction (guard condition; produces ded id), rumor (guard `available`; produces rumor; effects `on_hear`), event card option (guard `requires` AND option condition; pass/fail like interactables), escalation stage (guard condition; produces `stage` via `max_stage`; effects `on_enter`), act gate from `game_rules` (guard; produces gate milestone), map node (guard `unlock`; produces node id), consumable item (requires item; effects).
- `ReachabilityOptions`: `max_check: int = 13`, `max_act: int = 3`, `exclude_losable_items: bool = false`.
- `ReachabilityAnalyzer._init(groups: Array[GuardedEffects], options: ReachabilityOptions)`; `run(start: ReachableFacts) -> ReachableFacts` — repeat over all groups until no group adds a key: a group fires when its `requires` hold, its `act` ≤ `max_act`, its check dc ≤ `max_check`, its guard is satisfiable (Task 30) and, with `exclude_losable_items`, it tests no losable item (an item of category other than key/document, or one named in any `take_item`). Firing applies `EffectFactMapper` to every effect and adds `produces`. `new_game_facts(set) -> ReachableFacts` (static): start zone visited, start map node, starting items, `max_act` 1.

- [ ] **Step 1: Tests** on fixtures: from new-game facts, `ms.fx_one`, `ms.fx_two`, `quest.fx_main#done`, `ded.fx_ded`, `map.fx_ford` become reachable; with `max_check = 3` the lever's `flag.fx_lever` is not reachable and `quest.fx_main#done` is not; `exclude_losable_items` blocks a group guarded by `has_item(item.poultice)`.
- [ ] **Steps 2–5** as usual. Commit `git add game/tests/helpers/content game/tests/content/checkers` — `test(content): reachability analyzer`.

### Task 32: Trigger graph (effect cycles) and XP budget

Wave: 5 · Depends: Task 31

**Files:**
- Create: `game/tests/helpers/content/trigger_graph.gd`, `xp_budget.gd`
- Test: `game/tests/content/checkers/test_trigger_graph.gd`, `test_xp_budget.gd`

**Interfaces:**
- `TriggerGraph.build(groups: Array[GuardedEffects]) -> TriggerGraph` (static) over *automatic* groups only (quest stages, deductions, escalation stages, act gates, map nodes — the ones `FactsChanged` policies fire). Edge A→B when a key A writes (its effect ids + `produces`, with `@stage` for escalation) appears in B's guard ids (`Condition.referenced_ids()`, plus `@stage` when the guard text contains `stage()`). `find_cycle() -> Array[String]` (origins, empty if none), `longest_chain() -> int` (edges on the longest path).
- `XpBudget.compute(set: ContentRecordSet, rules: Dictionary) -> Dictionary[int, int]` (act → XP available in that act's records, by `_source.act`; side files (act 0) count toward the act of their quest's `available` lower bound, else act 2): objective `xp`, side quest `xp`, clues × `clue_by_act[act-1]`, deductions × `deduction_by_act[act-1]`, every dialogue/interactable/event-card check × `check_per_act × act` (counted once per check), each zone × `zone_first_visit`, `add_xp(N)` effects, encounters Σ count × enemy `xp` (× `travel_combat_mult` when `zone` starts with `arena:`). `rules` is the parsed `game_rules.json` dictionary.
- [ ] **Steps 1–5** (tests: a two-trigger loop is reported with both origins; a 3-step chain has `longest_chain() == 2`; fixture XP for act 1 equals the hand-summed value written in the test). Commit — `test(content): trigger graph and xp budget`.

### Task 33: Real-content reachability tests

Wave: 6 · Depends: Tasks 31, 32, P2 `EndingResolver`, `EndingFacts`, Task 28

**Files:** `game/tests/content/test_quests_completable.gd`, `test_act_gates.gd`, `test_endings.gd`, `test_escalation_reachable.gd`, `test_map.gd`, `test_xp_budget.gd`, `test_effect_cycles.gd`

**Interfaces / assertions** (architecture §9.4; each `pending` when the content is empty):
- quests completable: from `new_game_facts`, every main quest stage key and every required objective condition becomes satisfiable; every side quest reaches `#done`.
- act gates: for act 1 options `{max_check: 8, max_act: 1, exclude_losable_items: true}`, act 2 `{10, 2, true}`; the act gate condition (from `game_rules`) is satisfiable. Max checks derive from gdd §6.6/§6.8: creation max 6 + attribute points by level 4 (1) / level 8 (3) + 1 perk.
- endings: build `EndingResolver` from the loaded `endings`; over `queen_alive ∈ {true,false}` × `oath ∈ {true, reversed, none}` × `anselm ∈ {alive, dead, fled}` × `vault_seized ∈ {true,false}`, valid combinations are `vault_seized ⇔ oath == none` and `oath == reversed ⇒ anselm ∈ {dead, fled}` (16 combinations); each resolves ok; invalid ones return an error; the set of produced ids equals the 5 ending ids. Reachability: `clue.vault_command_rite`, `item.true_fourth_verse`, `item.wenna_antidote`, `companion.dravin` and `flag.antidote_administered` are reachable.
- escalation: stages 1–4 reachable (`max_stage` reaches 4). The conditions are evaluated as full conditions; there is no milestones-only restriction (coordinator ruling).
- map: every map node reachable from `map.cintra` through edges (ignoring edge conditions) and its `unlock` satisfiable under full reachability; every edge terrain has an encounter table with 8 entries and a pool ≥ 3.
- xp budget: act 1 ≥ 1350; acts 1+2 ≥ 5250; total ≥ 13283 (11550 × 1.15).
- effect cycles: `find_cycle()` empty and `longest_chain() < 8` (the fixpoint cap, architecture §5.4).
- [ ] **Steps 1–5**: run `tools/test.ps1 -Suite content` → pass or pending. Commit `git add game/tests/content` — `test(content): reachability, endings, map, xp and cycle checks`.

### Task 34: Parser catalog, typed database accessors, fixture loader

Wave: 5 · Depends: Tasks 24–28

**Files:**
- Create: `game/src/infrastructure/content/content_parser_catalog.gd`, `game/tests/helpers/content/fixture_content.gd`
- Modify: `game/src/application/content/content_database.gd`
- Modify: `game/src/infrastructure/content/json_content_source.gd` (optional `schemas_root: String` 5th… keep ≤ 4 params: move `cross_referencer` and `schemas_root` into a `JsonContentOptions` value `game/src/infrastructure/content/json_content_options.gd`)
- Test: `game/tests/unit/infrastructure/content/test_content_parser_catalog.gd`, `game/tests/application/content/test_content_database_typed.gd`

**Interfaces:**
- `ContentParserCatalog.all(rules: RuleReader) -> Array[ContentKindParser]` (static; one instance of every parser; `NpcParser` before `DialogueParser`).
- `JsonContentOptions`: `schemas_root: String` (default `<root>/_schemas`), `cross_referencer: ContentCrossReferencer`. `JsonContentSource._init(root, validator, parsers, options: JsonContentOptions = null)`.
- `ContentDatabase` typed accessors returning `Result`: `get_item`, `get_zone`, `get_npc`, `get_dialogue`, `get_quest`, `get_clue`, `get_deduction`, `get_theory`, `get_faction`, `get_rumor`, `get_companion`, `get_map_node`, `get_map_edge`, `get_event_card`, `get_ending`, `get_section`, `get_flag_declaration`; singletons `rules() -> GameRulesDefinition`, `escalation_rules() -> EscalationRules`, `skill_tree() -> SkillTreeDefinition`; collections `zones() -> Array[ZoneDefinition]`, `map_nodes()`, `map_edges()`, `encounter_tables()`, `rumors()`, `factions()`, `endings() -> Array[EndingRule]`, `epilogues()`. Field sketch names from architecture §5.2 map to these accessors.
- `FixtureContent.database(signatures: EffectSignatures = null) -> ContentDatabase` (static, cached per registry): loads `res://tests/fixtures/content` with schemas from `res://content/_schemas`, all parsers over `RuleReader.new(EffectParser.new(signatures or ContentFormatEffects.signatures()))` and the cross-referencer; asserts ok.
- [ ] **Steps 1–5** (tests: catalog covers every kind in `ContentKinds.all()` except `enemies`, `encounters`; fixture db `get_zone(&"zone.fx_tavern").is_ok()`, `rules().crowns == 30`, `skill_tree()` not null). Commit — `feat(content): parser catalog and typed content accessors`.

### Task 35: GameSession and GameSessionFactory

Wave: 5 · Depends: Tasks 8, 34; all P1/P2 aggregates

**Files:**
- Create: `game/src/application/session/game_session.gd`, `game_session_factory.gd`
- Test: `game/tests/application/session/test_game_session.gd`, `test_session_json_round_trip.gd`

**Interfaces:**
- `GameSession`: fields from architecture §5.1 (`world`, `escalation`, `queen`, `quests`, `board`, `dialogue_memory`, `sheet`, `inventory`, `equipment`, `quick_slots`, `wallet`, `xp`, `skills`, `reputation`, `travel`, `party`, `rumors`, `finale`, `rng: SeededRandom`, `location: SessionLocation`) plus `zone_memory`, `profile`, `outbox: EventOutbox` (P1), `activity: SessionActivity`, `shops: Dictionary[StringName, Shop]` (not saved), `encounter_roller: EncounterRoller` (not saved; built over `session.rng`). `const SECTIONS: Array[StringName] = [&"world", &"escalation", &"queen", &"quests", &"board", &"dialogue_memory", &"sheet", &"inventory", &"equipment", &"quick_slots", &"wallet", &"xp", &"skills", &"reputation", &"travel", &"party", &"rumors", &"finale", &"location", &"zone_memory", &"profile", &"rng"]`. `snapshot() -> Dictionary[StringName, Dictionary]`; `restore(sections: Dictionary[StringName, Dictionary]) -> Result` — checks every name is present **before** touching any aggregate (`save_missing_section`, detail = name), restores `rng` first via `set_state`; `fingerprint() -> int` = `hash(snapshot())`.
- `GameSessionFactory._init(db: ContentDatabase)`; `populate(session: GameSession, seed: int) -> void` assigns fresh aggregates built from content with the P1/P2 constructors: `WorldState(var_bounds)` (from every `int` `FlagDeclaration`: `Vector2i(min, max)`), `EscalationTrack(db.escalation_rules())`, `QueenCondition()`, `QuestLog(all quest defs)`, `ClueBoard(clues, deductions)`, `DialogueMemory()`, `ActorSheet(Attributes.new(), func() -> int: return session.xp.level())`, `Inventory(item catalog)`, `Equipment`, `QuickSlots`, `Wallet`, `ExperienceTrack()`, `SkillTree(db.skill_tree(), session.xp)`, `ReputationLedger(faction defs)`, `TravelState(rules().start_map_node)`, `Party(companion defs)`, `RumorPool(rumor defs, session.rng)`, `FinaleRecord()`, `SeededRandom(seed)`, `EncounterRoller(tables, session.rng)`; empty `location`/`zone_memory`/`profile`/`shops`, `activity.reset()`.
- [ ] **Step 1: Tests**: populate twice replaces aggregates (`assert_ne` identity); `snapshot().keys()` equals `SECTIONS`; restore of a snapshot reproduces it; restore missing `quests` → `save_missing_section` **and** `fingerprint()` unchanged; `test_session_json_round_trip`: mutate several aggregates through their public APIs (flag, var, milestone, item ×3, crowns, xp, reputation, location), `JSON.parse_string(JSON.stringify(snapshot))` → `JsonValueNormalizer.normalize` → restore into a second populated session → `snapshot()` equal (Review Focus 1).
- [ ] **Steps 2–5**. Commit `git add game/src/application/session game/tests/application/session` — `feat(app): game session aggregate root`.

## Wave 6

### Task 36: SessionFactProvider

Wave: 6 · Depends: Task 35, P1 `FactProvider`, `CheckTotals`

**Files:** `game/src/application/session/session_fact_provider.gd`; test `game/tests/application/session/test_session_fact_provider.gd`

**Files (add):** `game/src/application/session/check_modifiers.gd`; test `test_check_modifiers.gd`.

**Interfaces:**
- `SessionFactProvider extends FactProvider` — `_init(session: GameSession, db: ContentDatabase)`; implements every abstract method of P1's `FactProvider`: flags/vars/milestones → `world`; `item_count` → `inventory.count`; `has_clue`/`has_deduction` → `board`; `quest_status`/`quest_stage` → `quests` (P1's `QUEST_*` values); `attribute` → `sheet.attribute`; `check_total(skill)` → `CheckTotals.compute(skill, sheet, skills.perks(), inventory.all_ids())` **+ `party.skill_bonus(skill)`** (Lore +2 with Maelis, gdd §6.10, per P2) **+ `CheckModifiers.speaker_bonus(skill, speaker, session, db)`**; `reputation`/`rep_tier` → `reputation`; `escalation_stage` → `escalation.stage()`; `act` → `world.act()`; `in_party` → `party.in_party`; `has_perk` → `skills.has`; `crowns` → `wallet.balance()`; `level` → `xp.level()`; `finale_value(FINALE_SEIZED|FINALE_OATH|FINALE_ANSELM)` → `finale` record (seized `&"true"`/`&"false"`); `visited` → `location.has_visited`; `rumor_heard` → `rumors.is_heard`; `queen_condition` → `queen.condition()`. `set_speaker(npc_id)` / `clear_speaker()` hold the current speaker (`&""` = none).
- `CheckModifiers.speaker_bonus(skill: StringName, speaker: StringName, session: GameSession, db: ContentDatabase) -> int` (static; gdd §6.9, §6.10; application-owned per P1): with a speaker whose NPC `faction` is `faction.crown` or `faction.varn` ("officials") and `item.kosk_writ` held → +2 to every dialogue skill; with a speaker whose faction is `faction.strept` and `item.kosk_writ` equipped (worn as the badge) → −2; no speaker → 0. Attribute checks (hazards) get no speaker bonus.
- [ ] **Steps 1–5** (one test per FactProvider method against a fixture session; lore +2 with Maelis recruited via `party.skill_bonus`; writ +2 with a crown speaker, −2 with a Strept speaker when equipped, 0 after `clear_speaker()`). Commit — `feat(app): session fact provider and speaker check modifiers`.

### Task 37: Event pump, fixpoint settler, committer

Wave: 6 · Depends: Task 35, P1 `FactsChanged`

**Files:** `game/src/application/session/session_event_pump.gd`, `facts_settler.gd`, `session_committer.gd`; tests `test_session_event_pump.gd`, `test_facts_settler.gd`, `test_session_committer.gd` in `game/tests/application/session/`

**Interfaces:**
- `SessionEventPump._init(session: GameSession, bus: EventBus)`; `pump() -> int` — drains the outbox of every session aggregate that has `drain_events()` in the built code (listed explicitly, no `has_method`; includes `session.encounter_roller`) plus `session.outbox.drain()`, publishes them, repeats until a full pass drains nothing (assert after 100 passes); returns events published.
- `FactsSettler._init(session: GameSession, bus: EventBus, pump: SessionEventPump, max_rounds: int = 8)`; `settle() -> Result` — per round: `before = session.fingerprint()`, publish `FactsChanged.new(&"settle")`, `pump.pump()`, stop with `ok(rounds)` when the fingerprint is unchanged; after `max_rounds` still changing → `err(&"fixpoint_cap_reached")` (architecture §5.4).
- `SessionCommitter._init(pump: SessionEventPump, settler: FactsSettler, logger: GameLogger, assert_on_cap: bool = true)`; `commit() -> Result` — pump, settle, on cap `logger.error(...)` and `assert(false)` when `assert_on_cap`; then runs after-commit hooks; `add_after_commit(hook: Callable)`.
- [ ] **Step 1: Tests**: a `FactsChanged` subscriber that sets a flag once → settles in 2 rounds; a subscriber that increments a var forever → `fixpoint_cap_reached` after exactly 8 publications (committer built with `assert_on_cap = false`, error logged); events recorded while handlers run are published in order; after-commit hook runs once after settling and sees the settled fingerprint.
- [ ] **Steps 2–5**. Commit — `feat(app): event pump and FactsChanged fixpoint`.

### Task 38: EffectDispatcher and handler base

Wave: 6 · Depends: P1 `EffectSpec`, `EffectSignature`, `EffectSignatures`, `EffectParser`

**Files:** `game/src/application/effects/effect_handler.gd`, `effect_dispatcher.gd`; test `game/tests/application/effects/test_effect_dispatcher.gd`, helper `game/tests/helpers/effects/recording_handler.gd` (`_init(op: StringName, specs: Array[String])`)

**Interfaces** (P1 "How to add an effect op" is binding):
- `@abstract EffectHandler`: `@abstract func signature() -> EffectSignature` (e.g. `EffectSignature.of(&"give_item", ["id:item", "int=1"])`, the `ArgSpec` strings of P1's `ContentFormatEffects`), `func precheck(spec: EffectSpec, totals: Dictionary[StringName, int]) -> Result` (default ok; may accumulate into `totals`), `@abstract func apply(spec: EffectSpec, source: StringName) -> Result`.
- `EffectDispatcher._init(signatures: EffectSignatures)` — the single shared registry, also handed to `EffectParser.new(signatures)` for content. `register(handler: EffectHandler)` → `signatures.register(handler.signature())` (P1 asserts on duplicates) and maps the op to the handler. `signatures() -> EffectSignatures`, `has_op(op) -> bool`, `ops() -> Array[StringName]`, `apply_all(effects: Array[EffectSpec], source: StringName) -> Result` — prechecks every spec first (unknown op → `effect_unknown_op`, detail op; any precheck error aborts with nothing applied), then applies in order, stopping at the first error (returned); ok value = count applied.
- [ ] **Steps 1–5** (tests with `RecordingHandler`: register puts the signature in the registry so `EffectParser.new(registry).parse("rec(flag.a)")` becomes ok; order preserved; unknown op applies nothing; precheck failure applies nothing; apply error stops the rest). Commit — `feat(app): effect dispatcher over the shared signature registry`.

## Waves 7–8 — effect handlers (`game/src/application/effects/handlers/`, tests in `game/tests/application/effects/handlers/`, all over `FixtureContent.database()` and a populated session)

Every handler: `_init(services: SessionServices, …)` (Task 39 creates `session_services.gd`), reads `services.session.<aggregate>` and `services.db` at call time (the composer registers handlers before content and session exist), `signature()` returns exactly the spec strings P1's `ContentFormatEffects` uses for that op, arguments via `StringName(spec.args[i])` / `int(spec.args[i])` (the parser already applied defaults). One test per op asserting the domain state after `apply`, built over `SessionHarnessLite` (Task 39).

### Task 39: World handlers, SessionServices, lite harness

Wave: 7 · Depends: Tasks 35–38
**Files:** `game/src/application/session/session_services.gd` (plain holder; fields listed in Task 43), `game/tests/helpers/session/session_harness_lite.gd` (`static create(seed := 1) -> SessionServices`: fixture db, populated session, bus, provider, dispatcher over a fresh `EffectSignatures`, committer with `assert_on_cap = false`, `CapturingLogger`, `FixedWallClock`, `InMemorySaveRepository`; no handlers registered), handlers `set_flag_handler.gd` (`_init(services, value: bool)` serves `set_flag` (true) and `clear_flag` (false), op chosen by `value`), `set_var_handler.gd` (`_init(services, additive: bool)`: `world.set_var` / `world.add_var`; clamping is `WorldState`'s, P1 extension 9), `reach_milestone_handler.gd`, `set_act_handler.gd`.
- [ ] Steps 1–5. Tests: `add_var(var.fx_tries, 5)` ends at 3 (WorldState bounds from the declaration). Commit `git add game/src/application/session game/src/application/effects game/tests/helpers/session game/tests/application/effects` — `feat(app): world effect handlers and session services`.

### Task 40: Inventory, actor, progression, faction, investigation handlers

Wave: 8 · Depends: Task 39
**Files:** `give_item_handler.gd`, `take_item_handler.gd` (`remove(id, n, true)` — scripted effects may take key items; when the removal takes the last copy of an equipped item, `equipment.unequip(slot)` first, P1 note on Equipment), `add_crowns_handler.gd` (precheck: `totals[&"crowns"] += n`, error `effect_cannot_pay` when `balance + totals[&"crowns"] < 0` — content-format §E), `heal_player_handler.gd` (`full` → heal to max; ×1.5 when `source == &"consumable"` and `perk.field_medic` — gdd §6.8), `damage_player_handler.gd`, `add_xp_handler.gd` (`xp.grant(n, &"effect")`), `add_rep_handler.gd`, `add_clue_handler.gd`.
- [ ] Steps 1–5. Tests include: list `["add_crowns(-50)", "give_item(item.fx_key, 1)"]` with 30 crowns applies nothing and returns `effect_cannot_pay`. Commit — `feat(app): inventory and character effect handlers`.

### Task 41: Quest, travel, companion and rumor handlers

Wave: 8 · Depends: Task 39
**Files:** `start_quest_handler.gd` (looks up `db.get_quest`), `fail_quest_handler.gd`, `complete_objective_handler.gd` (`quests.complete_objective`), `unlock_map_node_handler.gd`, `add_map_pin_handler.gd` (`travel.add_pin`), `party_join_handler.gd` (`_init(services, op)` for `recruit` [id:companion] and `add_ally` [id:ally]), `party_leave_handler.gd` (`dismiss`, `remove_ally`), `add_rumor_handler.gd` (`rumors.mark_heard(id, &"effect")`), `verify_rumor_handler.gd`.
- [ ] Steps 1–5. Commit — `feat(app): quest, travel, party and rumor effect handlers`.

### Task 42: Request handlers, checkpoint, antidote service and handlers

Wave: 8 · Depends: Tasks 7, 39
**Files:** `request_effect_handler.gd` (`_init(services, sig: EffectSignature, factory: Callable)` where `factory(spec) -> DomainEvent`; records into `session.outbox`), `set_checkpoint_handler.gd` (sets `location.last_checkpoint`, records `CheckpointReached`), `game/src/application/effects/antidote_service.gd`, `administer_antidote_handler.gd`, `send_antidote_rider_handler.gd`.
**Interfaces:** `AntidoteService._init(services)`: `administer(target: StringName) -> Result` — needs `rules().antidote_item` (`not_available` otherwise); removes it with force; `queen` → `queen.administer_antidote()` + `set_flag(flag.antidote_administered)`; `maelis` → `set_flag(flag.antidote_given_maelis)`, `set_flag(flag.maelis_poisoned, false)`. `send_by_rider() -> Result` — dose required; `wallet.spend(rider_cost)` (`insufficient_crowns`); removes dose; intercepted iff `escalation.stage() >= 3 and not flag.choir_list_exposed and not flag.rider_escort_hired` (gdd §6.2) → `set_flag(flag.antidote_rider_intercepted)` + `RiderIntercepted`; else `set_flag(flag.antidote_rider_en_route)`. `sell_to_raimund() -> Result` — dose removed, `wallet.add(300)`, `add_rep(faction.attre, 50)`, `set_flag(flag.antidote_sold_raimund)`. `deliver_rider() -> bool` — if en route: administer to queen without an item, clear en route, record `RiderDelivered`. Content using `send_antidote_rider()` must not also charge crowns (report to content reconciliation).
- [ ] Steps 1–5. Tests: interception at stage 3 vs escort flag vs stage 2. Commit — `feat(app): request effects and antidote service`.

## Wave 9

### Task 43: EffectHandlerSet and SessionHarness

Wave: 9 · Depends: Tasks 39–42

**Files:** `game/src/application/effects/effect_handler_set.gd`, `game/tests/helpers/session/session_harness.gd`; modify `game/tests/helpers/content/content_test_kit.gd` (`signatures()` now returns the registry of a dispatcher filled by `EffectHandlerSet`); test `game/tests/application/effects/test_effect_handler_set.gd`

**Interfaces:**
- `SessionServices` (parameter object, created in Task 39): `session`, `db`, `bus`, `facts: SessionFactProvider`, `signatures: EffectSignatures`, `dispatcher`, `committer`, `logger: GameLogger`, `clock: WallClock`, `saves: SaveRepository`, `settings: GameSettings`. (`AntidoteService` is stateless; each user builds `AntidoteService.new(services)`.)
- `EffectHandlerSet.register_all(services: SessionServices) -> void` (static): one `dispatcher.register(<Handler>.new(...))` line per content-format §E op (35); request ops map `start_dialogue→DialogueRequested`, `start_encounter→EncounterRequested`, `goto_zone→ZoneChangeRequested`, `play_beat→BeatRequested`, `open_shop→ShopRequested`, `game_over→GameOverRequested`, `apply_status→StatusRequested`. Ops from a later format addendum add one line each here.
- `SessionHarness.create(seed: int = 1) -> SessionServices` (static): `SessionHarnessLite.create(seed)` + `EffectHandlerSet.register_all`.
- [ ] Tests: `test_registry_matches_content_format_effects` — for every op of `ContentFormatEffects.signatures()` the harness registry has the op with the same param specs, and the op counts are equal (P1 binding); applying `EffectParser.new(services.signatures).parse("set_flag(flag.fx_met)")` through the dispatcher works. Steps 1–5. Commit `git add game/src/application/effects game/tests/helpers game/tests/application/effects` — `feat(app): effect handler registration and test harness`.

### Task 43a: Effect ops from content-format §J "Addendum 1"

Wave: 10 (parallel with the policies: touches only `effects/handlers/`, `effect_handler_set.gd` and their tests) · Depends: Task 43; content-format §J published

**Files:** one `game/src/application/effects/handlers/<op>_handler.gd` and one `game/tests/application/effects/handlers/test_<op>_handler.gd` per §J effect op; modify `effect_handler_set.gd` (one `dispatcher.register(...)` line per op), `game/tests/helpers/content/effect_fact_mapper.gd` (the fact key each §J op produces, if any), `game/tests/application/effects/test_effect_handler_set.gd`.

**Interfaces:** P1's "How to add an effect op" exactly: each handler's `signature()` uses the argument specs §J lists; `apply` reads aggregates at call time. Ops whose meaning is a presentation request (journey cancel, status cure, enemy sight, flee, …) record an application event: add one small event class per such op in `game/src/application/events/` and construct it with `RequestEffectHandler`. Ops that need a domain method no P1/P2 class provides: stop and report them to the orchestrator instead of adding domain code.

- [ ] **Step 1:** For each §J op, write its handler test (state after `apply`, plus one bad-argument parse through `EffectParser.new(services.signatures)`), and extend `test_registry_matches_content_format_effects` to expect the 35 §E ops plus the §J ops.
- [ ] **Step 2:** Run `tools/test.ps1 -Test tests/application/effects` → FAIL (handler classes missing).
- [ ] **Step 3:** Implement the handlers and add the registration lines.
- [ ] **Step 4:** Run the folder, `tools/test.ps1 -Suite content`, then `tools/test.ps1` → exit 0.
- [ ] **Step 5: Commit (orchestrator)** `git add game/src/application/effects game/src/application/events game/tests/application/effects game/tests/helpers/content` — `feat(app): effect handlers for format addendum 1`

## Wave 10 — policies (`game/src/application/policies/`, tests `game/tests/application/policies/`)

Each policy: `_init(services: SessionServices)`, `attach(bus: EventBus) -> void` storing its `BusSubscription`s, `detach()`. Tests use `SessionHarness`, attach only the policy under test, and drive it with `committer.commit()` or direct publishes.

### Task 44: Escalation, Queen, Twist, Rider, Maelis policies

Wave: 10 · Depends: Task 43
**Behaviour** (gdd §6.1, §6.2; architecture §5.4):
- `EscalationPolicy` (FactsChanged): `escalation.recompute(facts)`; for each `pending_stage_entries()`: `dispatcher.apply_all(entry.on_enter, &"escalation")`, `mark_entry_applied(stage)`, record `EscalationCardRequested(stage)`. Test: reaching `ms.fx_one` → stage 1, `flag.fx_stage_one` set, card requested once; a save/restore after entry does not re-apply.
- `QueenPolicy` (EscalationStageChanged, FlagChanged for `flag.chalice_secured`/`flag.food_taster_exposed`, MilestoneReached): `queen.recompute(stage, mitigations)`; on milestones with antidote administered → `improve_on_milestone()`.
- `TwistResolutionPolicy` (MilestoneReached `ms.act2_twist`): carried dose → `antidote.administer(&"queen")`; `flag.queen_alive = flag.antidote_administered`; alive and condition ≤ 2 → `flag.aldric_co_sovereign`; alive and 3 → `flag.aldric_emergency_writ`; dead → `flag.aldric_crowned_king`.
- `RiderPolicy` (MilestoneReached): `antidote.deliver_rider()`.
- `MaelisPoisonPolicy` (EscalationStageChanged to 3: if `party.active_companion() == &"companion.maelis"` and not `flag.choir_list_exposed` → `flag.maelis_poison_pending`; RestTaken: pending → `flag.maelis_poisoned`, clear pending; ZoneExited: poisoned and not `flag.antidote_given_maelis` → `party.kill_scripted(&"companion.maelis")`, `flag.maelis_dead`).
- [ ] Steps 1–5 (one test file per policy). Commit — `feat(app): escalation, queen, twist, rider and maelis policies`.

### Task 45: Quest, deduction, map, act gate, XP and autosave policies

Wave: 10 · Depends: Task 43
**Behaviour:**
- `QuestProgressPolicy` (FactsChanged): `quests.evaluate(facts)`; `dispatcher.apply_all(quests.pending_effects(), &"quest")` (the call drains the queue, P2 contract).
- `DeductionPolicy`: `board.evaluate_deductions(facts)`. `MapUnlockPolicy`: unlock every map node whose `unlock` holds and is not unlocked. `ActGatePolicy`: for each `rules().act_gates` whose condition holds → `world.reach_milestone(gate.milestone)`; when newly reached record `ActGateOpened(act)`.
- `XpPolicy` — amounts from `rules()` (gdd §6.8): `QuestCompleted` → the side quest's `xp`; `ObjectiveCompleted` → objective `xp`; `ClueDiscovered` → `clue_xp_by_act[act-1]`; `DeductionUnlocked` → `deduction_xp_by_act[act-1]`; `CheckResolved` passed → `check_xp_per_act × act`; `ZoneFirstVisited` → 30. Source names `&"quest"`, `&"objective"`, `&"clue"`, `&"deduction"`, `&"check"`, `&"zone"`. Combat XP is added by the vertical-slice plan.
- `AutosavePolicy._init(services, save: SaveGameUseCase)` — wired later; **this task defines it against a `Callable` save action** `_init(services, save_action: Callable)`: on `ZoneEntered`, `EscalationStageChanged`, `ActChanged`, `CheckpointReached` set `_pending = true`; registers `committer.add_after_commit(flush)`; `flush()` calls `save_action.call(&"auto")` once when pending (Review Focus 3). Test: an autosave triggered by an event inside a commit stores a snapshot equal to `session.snapshot()` after the commit.
- [ ] Steps 1–5. Commit — `feat(app): progress, xp and autosave policies`.

### Task 46: PolicySet

Wave: 11 · Depends: Tasks 44, 45
**Files:** `game/src/application/policies/policy_set.gd`; test `test_policy_set.gd`. `PolicySet.attach_all(services: SessionServices, save_action: Callable) -> Array[RefCounted]` (static; constructs and attaches all eleven policies in architecture §5.4 order plus `TwistResolutionPolicy`). `SessionHarness.create(seed, with_policies := false)` gains the flag (modify the helper). Test: fixture new session + `start_quest(quest.fx_main)` + `give_item(item.fx_key)` + commit → stage `pull_lever` active and `ms.fx_one`… settles within 8 rounds.
- [ ] Steps 1–5. Commit — `feat(app): policy wiring`.

## Wave 12 — use cases (`game/src/application/use_cases/<area>/`, tests `game/tests/application/use_cases/<area>/`)

Each use case: `_init(services: SessionServices, …)`, one public `execute(...) -> Result`, ends with `services.committer.commit()` when it changed state. Tests use `SessionHarness.create(1, true)`.

### Task 47: Session use cases

Wave: 12 · Depends: Task 46
**Files:** `start_new_game_use_case.gd`, `save_game_use_case.gd`, `load_game_use_case.gd`, `apply_effects_use_case.gd` (+ `game/src/application/use_cases/session/new_game_setup.gd`: `player_name: String`, `attributes: Dictionary[StringName, int]` bonus points per attribute)
**Behaviour:**
- `StartNewGameUseCase(factory: GameSessionFactory)` `.execute(setup: NewGameSetup, seed: int) -> Result`: bonus points sum must equal `creation_points` (4) and base + bonus ≤ `creation_max` (6) per attribute, else `invalid_attributes`; empty name → `default_name`; `factory.populate`; apply attributes; starting items (equip when `equip_slot`), `wallet.add(30)`, `world.set_act(1)`, `travel` at start node; record `NewGameStarted`; then run `EnterZoneUseCase` for `start_zone` (default spawn). Returns ok(zone entry).
- `SaveGameUseCase(schema/migrator not needed)` `.execute(slot: StringName, label: String = "") -> Result`: `&"auto"` → the first missing of `auto_1..3`, else the one with the oldest `utc`; manual/quick slots require `activity.can_manual_save()` (`save_not_allowed`); builds `SaveSnapshot(meta, db.content_version, session.snapshot())` with meta from location/world/escalation/clock, label default = zone name; `saves.write(slot, snapshot.to_dict())`; records `GameSaved`.
- `LoadGameUseCase(factory, migrator: SaveMigrator, schema: SaveSchema)` `.execute(slot) -> Result`: read → migrate → validate → `SaveSnapshot.from_dict` → content version mismatch → `logger.warn` and continue → populate a **new** `GameSession` and restore it first; only on success copy its aggregates into the live session (session untouched on failure, Review Focus 4) → `activity.reset()` → record `GameLoaded(slot, zone, spawn)` → commit. Returns ok(meta).
- `ApplyEffectsUseCase.execute(effects: Array[EffectSpec], source: StringName) -> Result`: dispatcher then commit.
- [ ] Tests: invalid attributes (a 7, or 3 points); starting crowns 30 and bolts 8; save → load restores flags; `auto` rotation over four saves overwrites `auto_1`; manual save during dialogue → `save_not_allowed`; loading a save with save_version 99 → `save_version_unsupported` and fingerprint unchanged. Steps 1–5. Commit — `feat(app): new game, save and load use cases`.

### Task 48: Zone use cases and ZoneQuery

Wave: 12 · Depends: Task 46
**Files:** `enter_zone_use_case.gd`, `exit_zone_use_case.gd`, `interact_use_case.gd`, `trigger_zone_event_use_case.gd`, `zone_signal_use_case.gd`, `rest_use_case.gd`, `pick_up_item_use_case.gd`, `zone_rules.gd` (helper: active variants, `is_interactable_enabled`, `fire_triggers(zone, on, source)`), `game/src/application/queries/zone_query.gd`, `zone_view.gd`
**Behaviour** (content-format §F.1):
- Enter: unknown zone/spawn → `unknown_id`; `location.move_to`; first visit records `ZoneFirstVisited`; records `ZoneEntered`; fires `enter`-area triggers only through `TriggerZoneEventUseCase` (presentation reports area entry), not here.
- Exit(exit_id): fire `exit_attempt` triggers for the exit, then condition (`condition_false`), exit effects, `ZoneExited`, then Enter `to_zone`/`to_spawn`.
- Interact(id): disabled by an active variant, spent (`once`) or condition false → `not_available`; with a check → `CheckResolver.resolve` → effects or `fail_effects`, record `CheckResolved`; mark spent when `once`; fire `interact` triggers with that source. Returns ok(passed: bool).
- TriggerZoneEvent(trigger_id): condition, once, effects. ZoneSignal(on: `beat_done|encounter_done`, source_id): fires matching triggers. Rest(id): interactable kind `rest` → `sheet.full_restore()`, `RestTaken`. PickUp(container_id): loot condition, not spent → give items, mark spent.
- `ZoneQuery.view(zone_id) -> ZoneView` (`active_variants`, `enabled_interactables`, `present_npcs`, `enabled_encounters: Array[StringName]`).
- [ ] Tests over `zone.fx_tavern` per behaviour, incl. variant `after_one` hides `pickup_coin`. Commit — `feat(app): zone use cases and zone query`.

### Task 49: Dialogue use cases

Wave: 12 · Depends: Task 46, P2 `DialogueRunner`
**Files:** `game/src/application/session/active_dialogue.gd` (`runner: DialogueRunner`, `dialogue_id`), `start_dialogue_use_case.gd`, `choose_dialogue_option_use_case.gd`, `advance_dialogue_use_case.gd`
**Behaviour:** start (unknown → `unknown_id`; active → `dialogue_active`) builds `DialogueRunner.new(def, services.facts, session.dialogue_memory)`, sets `activity.dialogue_active` and `facts.set_speaker(def.participants[0])` (speaker check modifiers, Task 36). Shared step `DialogueStep.settle(view) -> DialogueView` (`game/src/application/use_cases/dialogue/dialogue_step.gd`): apply `runner.pending_effects()` (drains) with source `&"dialogue"` and record `runner.drain_events()` into `session.outbox`; **while `view.kind == &"continue"`, apply the pending effects, commit, then `view = runner.advance()`** (P2 protocol: later nodes must see the facts just set); when `view.kind == &"end"` clear the active dialogue, `facts.clear_speaker()`, `activity.dialogue_active = false`; commit; return the view. Choose/advance without one → `no_active_dialogue`.
- [ ] Tests on `dlg.fx_barkeep`: start sets `flag.fx_met` and returns the `hub` choice (the `continue` pause is consumed inside the use case); `probe` passes through the effect node and adds `clue.fx_clue` with Wits 4; failing `probe` with Wits 3 locks it; bribe 10 spends crowns; after `bye` the speaker is cleared. Commit — `feat(app): dialogue use cases`.

### Task 50: Inventory and progression use cases

Wave: 12 · Depends: Task 46
**Files:** `use_item_use_case.gd` (consumable: remove 1, effects with source `&"consumable"`), `equip_item_use_case.gd`, `assign_quick_slot_use_case.gd`, `buy_item_use_case.gd` (`execute(npc_id, item_id)`: shop from `session.shops` or built `Shop.new(npc.shop.stock, inventory, wallet)`; item not in the NPC's stock → `not_for_sale`; else `shop.buy(item_id, PriceModifier.compute(...))` passed through), `sell_item_use_case.gd` (**if the item is equipped and this is its last copy, `equipment.unequip(slot)` first** (P1 note), then `shop.sell`), `price_modifier.gd` (`compute(npc: NpcDefinition, zone: ZoneDefinition, session: GameSession, rules: GameRulesDefinition) -> float` = `shop.price_mod` × `realm_mult` at stage ≥ 3, else × `crown_lands_mult` at stage ≥ 1 when the zone's map node is in `crown_lands_nodes`; × `haggler_mult` with `perk.haggler`), `spend_skill_point_use_case.gd` (`skills.unlock(perk_id)` passed through; P1's `SkillTree` spends the point and returns `no_skill_points`), `spend_attribute_point_use_case.gd` (`sheet.spend_attribute_point(attr)`; `sheet.unspent_attribute_points()` is authoritative).
- [ ] Tests: poultice heals 40 (60 with Field Medic); buy at stage 1 in a Crown Lands zone costs 11 for a 10-crown item; item not in stock → `not_for_sale`; selling the equipped only `item.arming_sword` leaves `main_hand` empty and pays the shop's sell price. Commit — `feat(app): inventory and progression use cases`.

### Task 51: Travel, rumor and companion use cases

Wave: 12 · Depends: Task 46, P2 travel
**Files:** `plan_journey_use_case.gd`, `travel_use_case.gd` (+ `journey_outcome.gd`: `route`, `encounter: EncounterResult`, `avoided: bool`), `pathfinder_avoidance.gd` (policy helper), `resolve_event_card_use_case.gd`, `game/src/application/queries/event_card_query.gd` + `event_card_view.gd` + `event_card_option_view.gd`, `buy_rumor_use_case.gd`, `recruit_companion_use_case.gd`, `command_companion_use_case.gd`, `revive_companion_use_case.gd`
**Behaviour** (gdd §6.3, §6.10; content-format §F.9):
- Travel(to): `RoutePlanner.plan(...)` (error passed through); `travel.begin_journey(to)`; `EncounterModifiers` from `perk.pathfinder`, `ally.forest_guide` in party and `previous_id = travel.previous_encounter()`; `result = session.encounter_roller.roll(route, facts, stage, modifiers)`; **`travel.record_encounter(result.entry_id)` after every roll** (P2 contract; `&""` when quiet); `PathfinderAvoidance.try_avoid(result, facts) -> bool`: with `perk.pathfinder` and a `combat` result, a Wits check (`facts.check_total(&"wits") >= 5`, no speaker) avoids it once per journey (outcome `avoided = true`, encounter replaced by `EncounterResult.quiet(terrain)`); `travel.move_to(to)`; commit; ok(JourneyOutcome).
- `EventCardQuery.view(card_id) -> Result(EventCardView)`: title, text, options with `enabled` (condition holds; bribe options only when `crowns >= bribe × haggler bribe factor 0.7` with `perk.haggler`, gdd §6.8) and `requirement_text` (`"[Intimidate 5]"`, `"[Bribe 15]"`); options whose condition fails are hidden.
- ResolveEventCard(card_id, option_id): unknown → `unknown_id`; hidden/disabled option → `not_available`; bribe → `wallet.spend` (`insufficient_crowns`); check → `CheckResolver.resolve(CheckSpec.new(option.check_skill, option.check_dc, &"", &""), facts)` then `pass_effects` or `fail_effects`, record `CheckResolved`; always `effects`; commit; ok(passed: bool).
- BuyRumor: `wallet.spend(rules().rumor_price)`, `rumors.draw(source, facts)`, apply `on_hear`. Command: `party.set_command(kind)` and record `CompanionCommanded`. Recruit/Revive pass through `Party`.
- [ ] Tests on fixture map/table/card/rumor: `record_encounter` stores the rolled id (next journey's `previous_encounter()`); pathfinder with Wits 5 turns a scripted `combat` roll (via `ScriptedRandom`) into a quiet road, Wits 4 does not; `fx_card` `help` with Intimidate 5 adds guild rep, 4 damages the player; the view hides an option whose condition fails. Commit — `feat(app): travel, rumor and companion use cases`.

### Task 52: Antidote, finale and ending use cases

Wave: 12 · Depends: Task 46, P2 finale and endings
**Files:** `send_antidote_by_rider_use_case.gd`, `administer_antidote_use_case.gd`, `sell_antidote_use_case.gd` (all over `AntidoteService`), `game/src/application/session/active_finale.gd`, `start_finale_use_case.gd` (`RitualMeter.new(t_rev, t_true)` from `rules().finale_timers[settings.difficulty]` (gdd §6.17), then **`FinaleSetup.configure(meter, facts)` exactly once** (P2: bodyguards, gear brake, Maelis modifier); `activity.finale_active = true`), `tick_finale_use_case.gd` (`execute(delta: float)`; drains meter events into the outbox), `free_aldric_use_case.gd`, `finale_choice_use_case.gd` (`pursue` / `shield` → `meter.choose_aftermath(...)`; `command_persuade` / `command_intimidate` → require `FinaleChoices.new(meter).can_command_vault(facts)`, then resolve Persuade 8 or Intimidate 7 with `CheckResolver.resolve(CheckSpec.new(skill, dc, &"", &""), facts)` **before** calling `meter.seize_vault(coerced)` (coerced = intimidate path; also sets `flag.aldric_coerced`), a failed check → `condition_false`; the resolved record goes to `session.finale`), `resolve_ending_use_case.gd` (EndingFacts from the record and `flag.queen_alive` → `EndingResolver.resolve` → `EpilogueSelector.select` → record `EndingShown`; returns ok(ending id)).
- [ ] Tests: Hard difficulty builds the meter with 40/22 before `FinaleSetup` runs; Command the Vault with Persuade 7 fails and does not seize; with Persuade 8 seizes, and the ending resolves to `ending.bitter_bargain`. Commit — `feat(app): antidote, finale and ending use cases`.

### Task 53: Queries A

Wave: 12 · Depends: Task 46
**Files** (`game/src/application/queries/`): `journal_query.gd` + `journal_entry_view.gd`, `investigation_board_query.gd` + `theory_view.gd` (clues, suspect standings, deductions), `inventory_query.gd` + `inventory_view.gd`, `character_query.gd` + `character_view.gd` (name, level, xp, next-level xp from `LevelTable`, attributes, derived stats, unspent points, perks), `faction_query.gd` + `faction_view.gd`.
- [ ] Tests on fixture state; queries never change `session.fingerprint()`. Commit — `feat(app): journal, board, inventory, character and faction queries`.

### Task 54: Queries B

Wave: 12 · Depends: Task 46
**Files:** `map_query.gd` + `map_view.gd` (unlocked or pinned nodes, edges with `passable` from conditions, `preview(to) -> Result`), `rumor_query.gd` + `rumor_view.gd` (truth shown only when `credibility_visible`), `escalation_query.gd` + `escalation_view.gd` (stage, stage name, cards seen = stages ≤ current, Queen label: 0 "Weak", 1 "Bedridden", 2 "Lucid only at dawn", 3 "Comatose" — gdd §6.2), `save_slots_query.gd` + `save_slot_view.gd` (all seven slots, empty ones flagged).
- [ ] Steps 1–5. Commit — `feat(app): map, rumor, escalation and save slot queries`.

## Wave 13 — composition

### Task 55: GameContext, ComposerConfig, GameComposer

Wave: 13 · Depends: Tasks 18–20, 34, 47–54

**Files:** `game/src/presentation/bootstrap/composer_config.gd`, `game_context.gd`, `game_composer.gd`, `use_case_assembler.gd`, `query_assembler.gd`; test `game/tests/application/composition/test_game_composer.gd`

**Interfaces:**
- `ComposerConfig`: `content_root = "res://content"`, `schemas_root = ""` (default under content root), `save_root = "user://saves"`, `settings_path = "user://settings.cfg"`, `seed: int = 0`, `cross_reference: bool = true`, `assert_on_fixpoint_cap: bool = true`.
- `GameContext`: `services: SessionServices`, `settings: GameSettings`, `settings_store: SettingsStore`, one typed field per use case (snake_case of the class without `UseCase`, e.g. `start_new_game`, `enter_zone`) and per query (`journal`, `board`, …), `content_error: String`; `is_ready() -> bool` (`content_error == ""`).
- `GameComposer.compose(config: ComposerConfig) -> GameContext` (static): the only class naming `JsonContentSource`, `ContentParserCatalog`, `SchemaValidator`, `ContentCrossReferencer`, `JsonFileSaveRepository`, `ConfigFileSettingsStore`, `OsWallClock`, `GodotLogger`, `InputRemapApplier`. Order (the effect registry must be complete before content parses): (1) `SessionServices` with an empty `GameSession`, `EventBus`, one `EffectSignatures`, `EffectDispatcher.new(signatures)`, logger, clock, save repository; (2) `EffectHandlerSet.register_all(services)`; (3) load content with `ContentParserCatalog.all(RuleReader.new(EffectParser.new(signatures)))` — failure → context with `content_error` and nothing else built; (4) `services.db = db`, settings load + `InputRemapApplier.apply`, `GameSessionFactory.populate(session, seed)`, provider, pump/settler/committer; (5) `UseCaseAssembler.build(ctx)`, `PolicySet.attach_all(services, ctx.save_game.execute)`, `QueryAssembler.build(ctx)`. `SaveSchema.new(GameSession.SECTIONS)`, `SaveMigrator.new([])`. Test also asserts every op of `ContentFormatEffects.signatures()` is in the composed registry with the same specs (P1 binding).
- [ ] Tests: compose with `content_root = "res://tests/fixtures/content"`, `schemas_root = "res://content/_schemas"`, `save_root = "user://test_tmp/saves"` → ready, every context field non-null; `start_new_game` → `save_game(&"quick")` → `load_game(&"quick")` ok; a broken content root → not ready, `content_error` names the file. Commit `git add game/src/presentation/bootstrap game/tests/application/composition` — `feat(bootstrap): game composer and context`.

### Task 56: Services autoload, Main.tscn, smoke test

Wave: 14 · Depends: Task 55

**Files:** `game/src/presentation/bootstrap/services.gd`, `main.gd`, `game/scenes/main/Main.tscn` (remove `game/scenes/main/.gdkeep`), modify `game/project.godot` (`[application] run/main_scene="res://scenes/main/Main.tscn"`; `[autoload] Services="*res://src/presentation/bootstrap/services.gd"`); test `game/tests/smoke/test_main.gd`

**Interfaces:**
- `Services extends Node`: `var context: GameContext`, `func ready() -> bool`, `func bootstrap_for_debug() -> GameContext` (composes with fixture content and `user://debug_saves`, stores it in `context`).
- `main.gd` (`extends Node`, `class_name MainScene`): `@export var content_root := "res://content"`, `@export var schemas_root := ""`; `_ready()` composes (seed from `Time.get_ticks_usec()`), sets `Services.context`, and fills `%StatusLabel` with `"The Lion's Shadow — content <version> (<count> records)"` or `"Content failed to load:\n<content_error>"`. Main.tscn: `Node` root (`main.gd`) with a `Label` child named `StatusLabel` (unique name). No EventBridge (vertical-slice plan).
- [ ] Tests: instantiate `Main.tscn`, set `content_root` to the fixtures and `schemas_root` to `res://content/_schemas` before `add_child_autofree`, await 3 frames, assert `Services.ready()` and the label text starts with "The Lion's Shadow"; a bad root shows the failure text. Then run the project with the Godot MCP (`run_project` on `game/`, `get_debug_output`, `stop_project`): zero script errors.
- [ ] Commit (orchestrator) `git add game/src/presentation/bootstrap game/scenes/main game/project.godot game/tests/smoke` — `feat(bootstrap): Services autoload and Main boot scene`.

### Task 57: Convert the authored content and report

Wave: 15 · Depends: Tasks 21, 33, 56; content reconciliation (A08) preferably done

**Files:** generated `game/content/**` (converter output) only.
- [ ] Run `python -I tools/content_convert/convert.py`; fix nothing in `docs/content` (other agents own it). Record conversion errors verbatim.
- [ ] Run `tools/test.ps1 -Suite content` and record every failure line.
- [ ] If conversion succeeded, commit (orchestrator) `git add game/content` — `chore(content): convert authored sections`. Report both lists to the orchestrator for the reconciliation agent; this task does not require a green content suite.

---

## Gaps and notes for the orchestrator

- **Data without an author:** map nodes and edges (gdd §7.5 leaves node unlock conditions and three edge conditions vague), encounter tables (entries must reference ids from `side/13-travel-events.md`) and epilogues have schemas and parsers here but no data; their content tests stay `pending` until the reconciliation agent authors them.
- **Content vs. effect list:** writers use ops outside content-format §E (`draw_rumor`, `cancel_journey`, `weapon_imbue`, `take_random_consumable`, …); the ones §J adopts get handlers in Task 43a, the rest fail Task 29's checks. Content also uses both `item.crossbow_bolt` and `item.crossbow_bolts`.
- **Event cards** are owned here (data in `domain/travel/`, parser, query, use case) because no P2 domain owns them.
- **Speaker modifiers:** "officials" for Kosk's writ = NPCs of `faction.crown` or `faction.varn`; the badge penalty applies to every Strept-speaker check while the writ is equipped. Both are decisions (gdd names no official list).
- **Stage 1 Varn penalty** ("−10 unless `flag.varn_blackmailed`") cannot be an unconditional `on_enter` effect; it needs a guarded content trigger (reconciliation).

## Coverage map

| Spec section | Tasks |
|---|---|
| architecture §4.18 save domain | 1, 2 |
| §5.1 GameSession, SessionFactProvider | 8, 35, 36 |
| §5.2 ports, ContentDatabase | 3, 12, 34 |
| §3.4 effects and dispatcher (+ P1 "How to add an effect op") | 38, 39–43, 43a |
| content-format §J Addendum 1 | 13, 14, 17, 24–28, 30, 43a |
| content-format §F.9 event cards | 14, 25, 51 |
| §5.3 use cases (non-combat) | 47–52 |
| §5.4 policies and fixed point | 37, 44–46 |
| §5.5 queries | 48 (ZoneQuery), 53, 54 |
| §6 infrastructure (loader, validator, parsers, cross-referencer, save repo, settings, adapters) | 4, 5, 6, 15, 16, 18, 19, 20, 24–28, 34 |
| §3.3 composition root, Services, Main.tscn | 55, 56 |
| §8.3 content layout, `content_version.json`, save versioning | 6, 22, 47 |
| §9.4 content validation tests | 10, 11, 13, 14, 22, 23, 29–33 |
| content-format §H converter | 9, 17, 21, 57 |
| gdd §6.1 escalation stages | 22, 44 |
| gdd §6.2 Queen, antidote, rider, Maelis, twist | 42, 44, 52 |
| gdd §6.6, §6.9 new game | 22, 47 |
| gdd §6.8 XP sources and budget | 22, 32, 33, 45 |
| gdd §6.12 factions | 22 |
| gdd §6.14, §6.15 finale and endings | 22, 33, 52 |
| gdd §6.16 save and load | 18, 45, 47 |
| gdd §6.17 settings | 12, 19 |
| gdd §7.1/§7.2 act gates | 22, 33, 45 |
