# Core Rules and State Domains Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the pure domain layer for `rules`, `world_state`, `escalation`, `actors`, `inventory`, `progression`, `factions` and `rumors`, plus the kernel additions `FactsChanged`, `EventOutbox` and the test fakes `ScriptedRandom` and `FakeFactProvider`.

**Architecture:** Plain typed `RefCounted` classes under `game/src/domain/<domain>/`, no scene tree, unit-tested headless with GUT. `rules` parses the condition language (content-format §C) into an AST evaluated against the abstract `FactProvider`. It also parses effect strings (§E) into `EffectSpec` values, checked against an `EffectSignatures` registry that the effect handlers fill. Stateful aggregates record `DomainEvent`s in an `EventOutbox` and implement `Snapshotable`.

**Tech Stack:** Godot 4.7.2, statically typed GDScript, GUT 9.7.1, `tools/test.ps1`.

**Spec:** `docs/design/architecture.md` §3.1, §3.4, §4.2–§4.4, §4.11–§4.14, §4.17, §9.3; `docs/design/content-format.md` §C, §E; `docs/design/gdd.md` §6.1, §6.2, §6.6, §6.8, §6.9, §6.10, §6.12; `docs/content/side/14-rumors.md` (rumor fields and credibility rule).

## Global Constraints

- Run tests only through `tools/test.ps1` (Godot 4.7.2 console build). Never use the `godot` on PATH (4.7.0).
- Static typing everywhere: `untyped_declaration` is an error, and `unsafe_*` warnings block review. Use typed arrays and dictionaries, and `StringName` for ids.
- One class per file, no inner classes. `snake_case.gd` matches `class_name PascalCase`.
- Files: aim for 200 lines or fewer, hard cap 300. Functions: 30 lines or fewer, 4 parameters or fewer, nesting 3 levels or fewer.
- Domain files must not use `Node`, `SceneTree`, `get_tree`, `Input`, `FileAccess`, `DirAccess`, `ResourceLoader`, `JSON`, `OS`, `Time`, `Engine` or `signal`. A domain may reference only itself, `shared` and `rules`. `shared` must not reference `rules`. Tests may use `JSON`.
- Ids follow `kind.snake_case` (`IdRules`). Local ids are `^[a-z][a-z0-9_]*$`.
- Expected failures return `Result.err(code)` with the exact codes named in each task. Programmer errors use `assert()`.
- Every domain class's header comment cites the gdd/architecture section it implements, and so does every test file's header comment.
- **Events:** each event is a file at `src/domain/<domain>/events/<snake>.gd`, `extends DomainEvent`, with typed fields set in `_init` in the listed order. Fields never use the bare names `old`/`new`.
- **Outbox:** every aggregate that emits holds `var _outbox := EventOutbox.new()` and exposes `func drain_events() -> Array[DomainEvent]: return _outbox.drain()`. An event is recorded only when state actually changes.
- **Snapshots:** `to_snapshot()` returns JSON-safe data: `String` keys, ids stored as `String`, and int/float/bool/String/Array/Dictionary values. `restore(data)` must accept the snapshot after `JSON.parse_string(JSON.stringify(snap))`, where ints come back as floats and ids as `String`. Convert with `int(...)` and `StringName(...)`. Restoring replaces all state and emits no events.
- **Definitions** (`*Definition`, payloads) are immutable by convention. Required fields go through `_init`, optional fields are public typed vars that only parsers and tests assign right after construction.
- Commit each `.gd.uid` sidecar that the import creates together with its `.gd`. The commit steps add whole directories for this reason.
- The test runner re-imports when a new `class_name` appears. A red step's expected failure for a missing class is "exit 1, parse/load error naming the missing class".

## API extensions (beyond the architecture.md sketches)

Other planners: use these names exactly.

1. `EventOutbox` (`domain/shared`): `record(e: DomainEvent) -> void`, `drain() -> Array[DomainEvent]`, `is_empty() -> bool`.
2. `FactsChanged` (`domain/shared`): `extends DomainEvent`, field `source: StringName` (default `&""`).
3. `FactProvider` gains `visited(zone_id) -> bool`, `rumor_heard(rumor_id) -> bool` and `queen_condition() -> int`, because §C has the calls `visited()`, `rumor_heard()` and `queen()`. It also gains constants: `QUEST_INACTIVE=&"inactive"`, `QUEST_ACTIVE=&"active"`, `QUEST_COMPLETED=&"completed"`, `QUEST_FAILED=&"failed"`. **`QuestLog.status()` (P2) must return these values.** It gains `FINALE_SEIZED=&"seized"`, `FINALE_OATH=&"oath"`, `FINALE_ANSELM=&"anselm"` as the keys of `finale_value(key) -> StringName`: seized returns `&"true"`/`&"false"`, oath returns `true|reversed|none`, anselm returns `alive|dead|fled`.
4. `RepTiers` (`rules`): the tier order `hostile < wary < neutral < friendly < allied`, shared by the condition language and `factions`.
5. `CheckSkills` (`rules`): the valid check names are the 4 dialogue skills **and the 5 attributes** (coordinator input: hazard checks use `check: {skill: agility|grit}`). `FactProvider.check_total(skill)` accepts all 9. P2's `CheckSpec` and the zone/event-card check validation should call `CheckSkills.is_check_skill`.
6. `ArgSpec` (`rules`): a typed argument spec mini-language shared by the condition calls and the effect signatures.
7. `EffectSignature` and `EffectSignatures` become a **registry instance**, not a static table. `EffectParser` is an instance, `EffectParser.new(signatures).parse(text)`, plus `parse_list(texts)`. `ConditionParser.parse(text)` stays static.
8. `LiteralCondition` (true/false), plus the value nodes `ConditionValue`, `LiteralValue` and `CallValue`, and the call tables `ConditionCalls` and `FactCalls`, all in `rules/_internal/`.
9. `WorldState._init(var_bounds: Dictionary[StringName, Vector2i] = {})`: x = min, y = max, used by `add_var` clamping (§E). `set_var` does not clamp.
10. `EscalationTrack` emits one `EscalationStageChanged(old, new)` per `recompute` that raises the stage, even when it skips stages. `EscalationRules._init(stages)`, `stages()`, `definition(stage)`, `max_stage()`.
11. `ExperienceTrack.spend_skill_point() -> Result`. `SkillTree._init(def, track: ExperienceTrack)`, `perks() -> Array[StringName]`. `SkillNodeDefinition`. `LevelTable` is static. **`ExperienceTrack.unspent_attribute_points()` returns the points *earned* by level.** Spending is recorded by `ActorSheet`, which progression cannot reference, so the authoritative unspent count is `ActorSheet.unspent_attribute_points()`.
12. `Attributes._init(values: Dictionary[StringName, int] = {})` (missing names default to 3), `get_value(attr)`, `static create(bonus) -> Result`. `ActorSheet.attributes()`, `attribute(name)`.
13. Inventory: the payloads `ItemWeaponPayload`, `ItemArmorPayload` and `ItemConsumablePayload`. `Inventory.definition(id)`, `room_for(id)`, `all_ids()`, `remove(id, n := 1, force := false)`. `Equipment.armor_total()`, `is_equipped(id)`. `QuickSlots.assign/clear/item_at`. `Shop._init(stock, inventory, wallet)`, `buy_price`, `sell_price`, `stock_of`.
14. `RumorDefinition.verified_by: Condition` (null means verified only by effect). `RumorPool.mark_heard(id, source := &"") -> bool`, `evaluate_verifications(facts)`, `is_heard(id)`, `is_verified(id)`, `heard_from(id)`.
15. Test helpers: `ScriptedRandom`, `FakeFactProvider` and `ContentFormatEffects` (the §E signatures as a registry). P2 and P3 tests should reuse them, not redefine them.

## How to add an effect op (binding for P3 and later work)

Adding an op is exactly **one handler file + one test file + one registration line**. Nothing under `domain/rules/` changes:

1. `src/application/effects/handlers/<op>_handler.gd` extends P3's `EffectHandler`. It declares `func signature() -> EffectSignature: return EffectSignature.of(&"<op>", ["id:item", "int=1"])` (the `ArgSpec` strings from Task 3) and implements `apply`.
2. `tests/application/effects/test_<op>_handler.gd`.
3. In `GameComposer`: `dispatcher.register(<Op>Handler.new(...))`. **Interface requirement on P3:** `EffectDispatcher.register(handler)` calls `signatures.register(handler.signature())` on the single `EffectSignatures` instance that is also passed to `EffectParser` (and so to the content loader and the content tests).

Task 14 proves the open/closed property with a test. Ops outside §E (cancel_journey, draw_rumor, …) are **not** planned here. They arrive with the format addendum.

## Review Focus

1. **JSON round trip of every snapshot:** after `JSON.parse_string(JSON.stringify(...))`, ints arrive as floats and `StringName` keys as `String`. A restore that keeps floats breaks `==` comparisons later. Owners: Tasks 7, 8, 9, 10, 11, 12, 16, 17, 18, 19, 20, 21 each include a `test_snapshot_survives_json_round_trip`.
2. **Real-world condition text:** irregular spacing, nested parentheses, `true` as a compare word (`finale_oath() == true`), negative ints, `rep_tier(...) > hostile`. Expected: parsed the same as tidy text. Owner: Task 13 (`test_spacing_and_parens_are_free`, `test_true_as_compare_word`, `test_negative_int_compare`).
3. **Effect arguments as authored:** `add_crowns(-40)`, `add_rep(faction.varn, -10)`, `give_item(item.poultice)` with the default count, `heal_player(full)`, and stray spaces. Owner: Task 14 (`test_negative_and_default_args`).
4. **Escalation jumps and exactly-once entries:** several milestones land in one use case (stage 0 to 2 at once, or `ms.act2_twist` with nothing else). Each entry's effects must come back exactly once, including across save and load. Owner: Task 20 (`test_cascades_through_stage_conditions`, `test_entries_not_repeated_after_restore`).
5. **Failed transactions leave no trace:** a buy that fails on crowns or stack room, removing a key item, and adding to a full stack. Expected: nothing changes and no event fires. Owners: Task 17 (`test_add_to_full_stack_fails_without_event`), Task 19 (`test_failed_buy_changes_nothing`).

---

## Wave map

| Wave | Tasks (disjoint files, parallel) |
|---|---|
| 1 | 1 kernel additions · 2 rules ports · 3 ArgSpec |
| 2 | 4 condition lexer · 5 condition AST · 6 effect signatures · 7 WorldState · 8 Attributes/ActorSheet · 9 factions · 10 XP and levels · 11 Wallet · 12 QueenCondition |
| 3 | 13 ConditionParser · 14 EffectParser · 15 CheckTotals · 16 SkillTree · 17 items and Inventory |
| 4 | 18 Equipment/QuickSlots · 19 Shop · 20 EscalationTrack · 21 RumorPool |

Every task ends with `tools/test.ps1` (the full suite, which includes the architecture test) at exit 0 before its commit step.

---

### Task 1: Kernel additions (FactsChanged, EventOutbox, ScriptedRandom)

Wave: 1

**Files:**
- Create: `game/src/domain/shared/facts_changed.gd`, `game/src/domain/shared/event_outbox.gd`, `game/tests/helpers/scripted_random.gd`
- Test: `game/tests/unit/shared/test_facts_changed.gd`, `game/tests/unit/shared/test_event_outbox.gd`, `game/tests/unit/shared/test_scripted_random.gd`

**Interfaces:**
- Consumes: `DomainEvent`, `RandomSource` (existing).
- Produces: `FactsChanged.new(source: StringName = &"")` with field `source`. `EventOutbox`: `record(event: DomainEvent) -> void`, `drain() -> Array[DomainEvent]` (returns the events in order and empties the outbox), `is_empty() -> bool`. `ScriptedRandom extends RandomSource`: `_init(ints: Array[int] = [], floats: Array[float] = [])`, where `randi_range(from, to)` returns the next scripted int and asserts it lies in `[from, to]` and that the script is not exhausted, `randf()` returns the next scripted float, and `get_state()`/`set_state()` use `{"int_index": int, "float_index": int}`.

- [ ] **Step 1: Write the failing tests**

```gdscript
# test_facts_changed.gd — architecture.md §3.2
func test_is_domain_event_with_source() -> void:
	var e := FactsChanged.new(&"use_case.pick_up")
	assert_is(e, DomainEvent)
	assert_eq(e.source, &"use_case.pick_up")
func test_source_defaults_empty() -> void:
	assert_eq(FactsChanged.new().source, &"")

# test_event_outbox.gd — architecture.md §3.1
func test_drain_returns_in_order_and_empties() -> void:
	var o := EventOutbox.new()
	o.record(FakePingEvent.new("a")); o.record(FakePingEvent.new("b"))
	var out := o.drain()
	assert_eq(out.size(), 2)
	assert_eq((out[0] as FakePingEvent).label, "a")
	assert_true(o.is_empty())
	assert_eq(o.drain().size(), 0)

# test_scripted_random.gd — architecture.md §9.3, §9.6
func test_returns_scripted_values_in_order() -> void:
	var r := ScriptedRandom.new([2, 0], [0.5])
	assert_eq(r.randi_range(0, 3), 2)
	assert_eq(r.randi_range(0, 3), 0)
	assert_eq(r.randf(), 0.5)
func test_state_round_trip_replays() -> void:
	var r := ScriptedRandom.new([1, 2, 3])
	r.randi_range(0, 9)
	var s := r.get_state()
	assert_eq(r.randi_range(0, 9), 2)
	r.set_state(s)
	assert_eq(r.randi_range(0, 9), 2)
```

- [ ] **Step 2: Run to verify they fail**
Run: `tools/test.ps1 -Test tests/unit/shared`
Expected: exit 1, a load error naming `FactsChanged` / `EventOutbox` / `ScriptedRandom`.

- [ ] **Step 3: Implement the three classes** with the signatures above. `set_state` reads the indexes through `int(...)`.

- [ ] **Step 4: Run to verify they pass**
Run: `tools/test.ps1 -Test tests/unit/shared`, then `tools/test.ps1`. Expected: exit 0.

- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/shared game/tests/helpers game/tests/unit/shared`
`git commit -m "feat(shared): FactsChanged, EventOutbox and ScriptedRandom test fake"`

---

### Task 2: Rules ports (FactProvider, RepTiers, CheckSkills, FakeFactProvider)

Wave: 1

**Files:**
- Create: `game/src/domain/rules/fact_provider.gd`, `game/src/domain/rules/rep_tiers.gd`, `game/src/domain/rules/check_skills.gd`, `game/tests/helpers/fake_fact_provider.gd`
- Test: `game/tests/unit/rules/test_rep_tiers.gd`, `game/tests/unit/rules/test_check_skills.gd`, `game/tests/unit/rules/test_fake_fact_provider.gd`

**Interfaces:**
- Produces:
  - `@abstract class_name FactProvider extends RefCounted`, read-only, with every method `@abstract`: `has_flag(id: StringName) -> bool`, `get_var(id) -> int`, `has_milestone(id) -> bool`, `item_count(id) -> int`, `has_clue(id) -> bool`, `has_deduction(id) -> bool`, `quest_status(id) -> StringName`, `quest_stage(id) -> StringName`, `attribute(attr: StringName) -> int`, `check_total(skill: StringName) -> int`, `reputation(id) -> int`, `rep_tier(id) -> StringName`, `escalation_stage() -> int`, `act() -> int`, `in_party(id) -> bool`, `has_perk(id) -> bool`, `crowns() -> int`, `level() -> int`, `finale_value(key: StringName) -> StringName`, `visited(zone_id) -> bool`, `rumor_heard(rumor_id) -> bool`, `queen_condition() -> int`. Plus the constants from API extension 3.
  - `RepTiers`: `const ORDER: Array[StringName] = [&"hostile", &"wary", &"neutral", &"friendly", &"allied"]`, `static func rank(tier: StringName) -> int` (−1 if unknown), `static func is_tier(word: StringName) -> bool`.
  - `CheckSkills`: `const DIALOGUE_SKILLS: Array[StringName] = [&"persuade", &"intimidate", &"investigate", &"lore"]`, `const ATTRIBUTES: Array[StringName] = [&"might", &"agility", &"grit", &"wits", &"presence"]`, `static is_attribute(n) -> bool`, `static is_dialogue_skill(n) -> bool`, `static is_check_skill(n) -> bool` (either list).
  - `FakeFactProvider extends FactProvider` (test helper) with public typed fields that tests set directly: `flags`, `milestones`, `clues`, `deductions`, `party`, `perks`, `visited_zones` and `rumors` (all `Dictionary[StringName, bool]`); `vars`, `items`, `attributes`, `check_totals` and `reputation` (`Dictionary[StringName, int]`); `quest_statuses`, `quest_stages`, `rep_tiers` and `finale` (`Dictionary[StringName, StringName]`); `stage: int = 0`, `act_value: int = 1`, `crowns_value: int = 0`, `level_value: int = 1`, `queen_value: int = 0`. Defaults for missing keys: false, 0, attribute 3, quest status `QUEST_INACTIVE`, quest stage `&""`, tier `&"neutral"`, finale seized `&"false"` / oath `&"none"` / anselm `&"alive"`.

- [ ] **Step 1: Write the failing tests**

```gdscript
# test_rep_tiers.gd — gdd §6.12, content-format §C
func test_order_is_hostile_to_allied() -> void:
	assert_true(RepTiers.rank(&"hostile") < RepTiers.rank(&"wary"))
	assert_true(RepTiers.rank(&"friendly") < RepTiers.rank(&"allied"))
	assert_eq(RepTiers.rank(&"neutral"), 2)
func test_unknown_tier_ranks_minus_one() -> void:
	assert_eq(RepTiers.rank(&"beloved"), -1)
	assert_false(RepTiers.is_tier(&"beloved"))

# test_check_skills.gd — gdd §6.10, §6.6 (attribute checks for hazards)
func test_dialogue_skills_and_attributes_are_check_skills() -> void:
	for n: StringName in [&"persuade", &"lore", &"agility", &"grit", &"presence"]:
		assert_true(CheckSkills.is_check_skill(n), String(n))
	assert_false(CheckSkills.is_check_skill(&"stealth"))
	assert_true(CheckSkills.is_attribute(&"wits"))
	assert_false(CheckSkills.is_dialogue_skill(&"wits"))

# test_fake_fact_provider.gd — architecture.md §4.2
func test_fact_provider_is_abstract() -> void:
	assert_true((FactProvider as Script).is_abstract())
func test_fake_defaults() -> void:
	var f := FakeFactProvider.new()
	assert_false(f.has_flag(&"flag.x"))
	assert_eq(f.attribute(&"might"), 3)
	assert_eq(f.quest_status(&"quest.main_a1"), FactProvider.QUEST_INACTIVE)
	assert_eq(f.rep_tier(&"faction.crown"), &"neutral")
	assert_eq(f.finale_value(FactProvider.FINALE_OATH), &"none")
	assert_eq(f.act(), 1)
func test_fake_returns_configured_values() -> void:
	var f := FakeFactProvider.new()
	f.flags[&"flag.x"] = true; f.items[&"item.poultice"] = 2; f.stage = 3
	assert_true(f.has_flag(&"flag.x"))
	assert_eq(f.item_count(&"item.poultice"), 2)
	assert_eq(f.escalation_stage(), 3)
```

- [ ] **Step 2: Run to verify they fail**
Run: `tools/test.ps1 -Test tests/unit/rules`. Expected: exit 1, a load error naming `RepTiers`.

- [ ] **Step 3: Implement** the four classes with the signatures above. `FactProvider`'s header cites architecture.md §3.4 and §4.2.

- [ ] **Step 4: Run to verify they pass**
Run: `tools/test.ps1 -Test tests/unit/rules`, then `tools/test.ps1`. Expected: exit 0.

- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/rules game/tests/helpers game/tests/unit/rules`
`git commit -m "feat(rules): FactProvider port, RepTiers, CheckSkills, FakeFactProvider"`

---

### Task 3: ArgSpec (typed argument specs)

Wave: 1

**Files:**
- Create: `game/src/domain/rules/arg_spec.gd`
- Test: `game/tests/unit/rules/test_arg_spec.gd`

**Interfaces:**
- Consumes: `IdRules`, `Result`.
- Produces: `class_name ArgSpec`.
  - `static func parse(spec: String) -> ArgSpec`, which asserts on a malformed spec (a programmer error). Grammar:
    - `id:<kind>[|<kind>…]` accepts an id valid for one of the kinds and returns a `StringName`.
    - `int`, `int:<min>..<max>` or `int=<default>` accepts `-?[0-9]+` and returns an `int`. `=` makes the param optional.
    - `word:<a>|<b>…` accepts one of the listed words and returns a `StringName`.
    - `local` accepts `^[a-z][a-z0-9_]*$` and returns a `StringName`.
    - `int|word:<a>|…` returns an int if the token is numeric, else the listed word.
    - A trailing `+` makes the param variadic (one or more, and it must be the last param).
  - Fields: `spec_text: String`, `optional: bool`, `default_value: Variant`, `variadic: bool`. Method `is_id() -> bool`.
  - `func convert(token: String) -> Result` returns ok(value) or err(`&"bad_arg"`, detail naming the token and the spec).
  - `static func bind(specs: Array[ArgSpec], tokens: PackedStringArray) -> Result` returns ok(`Array` of converted values with defaults filled in), err `&"bad_arg_count"` or err `&"bad_arg"`. Tokens arrive already stripped.
  - `static func ids_in(specs: Array[ArgSpec], values: Array) -> Array[StringName]` returns the values bound to id specs, variadic ones included.

- [ ] **Step 1: Write the failing tests**

```gdscript
# test_arg_spec.gd — content-format §C, §E argument kinds
func test_id_spec_checks_kind() -> void:
	var s := ArgSpec.parse("id:item")
	assert_eq(s.convert("item.iron_key").value, &"item.iron_key")
	assert_eq(s.convert("flag.x").error_code, &"bad_arg")
	assert_eq(s.convert("item.Bad").error_code, &"bad_arg")
func test_multi_kind_id() -> void:
	var s := ArgSpec.parse("id:companion|ally")
	assert_true(s.convert("ally.aldric").is_ok())
	assert_true(s.convert("companion.maelis").is_ok())
func test_int_negative_and_range() -> void:
	assert_eq(ArgSpec.parse("int").convert("-40").value, -40)
	assert_eq(ArgSpec.parse("int:1..3").convert("4").error_code, &"bad_arg")
	assert_eq(ArgSpec.parse("int").convert("4x").error_code, &"bad_arg")
func test_word_and_union() -> void:
	assert_eq(ArgSpec.parse("word:queen|maelis").convert("maelis").value, &"maelis")
	var u := ArgSpec.parse("int|word:full")
	assert_eq(u.convert("full").value, &"full")
	assert_eq(u.convert("40").value, 40)
	assert_eq(u.convert("half").error_code, &"bad_arg")
func test_local_id() -> void:
	assert_eq(ArgSpec.parse("local").convert("door_kicked").value, &"door_kicked")
	assert_eq(ArgSpec.parse("local").convert("Door").error_code, &"bad_arg")
func test_bind_fills_default_and_counts() -> void:
	var specs: Array[ArgSpec] = [ArgSpec.parse("id:item"), ArgSpec.parse("int=1")]
	assert_eq(ArgSpec.bind(specs, PackedStringArray(["item.poultice"])).value, [&"item.poultice", 1])
	assert_eq(ArgSpec.bind(specs, PackedStringArray([])).error_code, &"bad_arg_count")
	assert_eq(ArgSpec.bind(specs, PackedStringArray(["item.a", "1", "2"])).error_code, &"bad_arg_count")
func test_variadic_needs_one_or_more() -> void:
	var specs: Array[ArgSpec] = [ArgSpec.parse("id:ms+")]
	var r := ArgSpec.bind(specs, PackedStringArray(["ms.a", "ms.b", "ms.c"]))
	assert_eq(r.value.size(), 3)
	assert_eq(ArgSpec.ids_in(specs, r.value), [&"ms.a", &"ms.b", &"ms.c"] as Array[StringName])
	assert_eq(ArgSpec.bind(specs, PackedStringArray([])).error_code, &"bad_arg_count")
```

- [ ] **Step 2: Run to verify it fails**
Run: `tools/test.ps1 -Test tests/unit/rules/test_arg_spec.gd`. Expected: exit 1, a load error naming `ArgSpec`.

- [ ] **Step 3: Implement `ArgSpec`** as specified. Store the parsed kind lists in typed fields and keep the spec-string parsing in small helpers.

- [ ] **Step 4: Run to verify it passes**
Run: `tools/test.ps1 -Test tests/unit/rules`, then `tools/test.ps1`. Expected: exit 0.

- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/rules game/tests/unit/rules`
`git commit -m "feat(rules): ArgSpec typed argument specs"`

---

### Task 4: Condition lexer

Wave: 2

**Files:**
- Create: `game/src/domain/rules/_internal/condition_token.gd`, `game/src/domain/rules/_internal/condition_lexer.gd`
- Test: `game/tests/unit/rules/test_condition_lexer.gd`

**Interfaces:**
- Produces: `ConditionToken` with `_init(kind: StringName, text: String, pos: int)` and the kinds `&"lparen"`, `&"rparen"`, `&"comma"`, `&"op"`, `&"int"`, `&"word"` and `&"end"`. `ConditionLexer.tokenize(text: String) -> Result` (static) returns ok(`Array[ConditionToken]`), always ending with an `end` token. Words are `[a-z0-9_.]+` that do not start with a digit. Ints are `-?[0-9]+` (a `-` counts only when a digit follows). Ops are `== != <= >= < >`. Whitespace is skipped. Any other character, or a lone `=` or `!`, gives err `&"condition_syntax"` with a detail of `"pos N: '<char>'"`.

- [ ] **Step 1: Write the failing tests**

```gdscript
# test_condition_lexer.gd — content-format §C grammar
func _kinds(text: String) -> Array[StringName]:
	var out: Array[StringName] = []
	for t: ConditionToken in ConditionLexer.tokenize(text).value:
		out.append(t.kind)
	return out
func test_call_compare() -> void:
	assert_eq(_kinds("skill(persuade) >= 4"),
		[&"word", &"lparen", &"word", &"rparen", &"op", &"int", &"end"] as Array[StringName])
func test_dotted_ids_and_commas() -> void:
	var toks: Array = ConditionLexer.tokenize("count_ms(ms.a1_x,ms.b)").value
	assert_eq((toks[2] as ConditionToken).text, "ms.a1_x")
	assert_eq((toks[3] as ConditionToken).kind, &"comma")
func test_negative_int() -> void:
	var toks: Array = ConditionLexer.tokenize("rep(faction.crown) <= -10").value
	assert_eq((toks[5] as ConditionToken).text, "-10")
func test_bad_characters_fail() -> void:
	assert_eq(ConditionLexer.tokenize("flag(flag.x) && true").error_code, &"condition_syntax")
	assert_eq(ConditionLexer.tokenize("act() = 2").error_code, &"condition_syntax")
```

- [ ] **Step 2: Run to verify it fails**
Run: `tools/test.ps1 -Test tests/unit/rules/test_condition_lexer.gd`. Expected: exit 1, a load error naming `ConditionLexer`.

- [ ] **Step 3: Implement** the two classes.

- [ ] **Step 4: Run to verify it passes**
Run: `tools/test.ps1 -Test tests/unit/rules`, then `tools/test.ps1`. Expected: exit 0.

- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/rules game/tests/unit/rules`
`git commit -m "feat(rules): condition lexer"`

---

### Task 5: Condition AST and evaluation

Wave: 2

**Files:**
- Create: `game/src/domain/rules/condition.gd`, and in `game/src/domain/rules/_internal/`: `and_condition.gd`, `or_condition.gd`, `not_condition.gd`, `literal_condition.gd`, `compare_condition.gd`, `call_condition.gd`, `condition_value.gd`, `literal_value.gd`, `call_value.gd`, `fact_calls.gd`
- Test: `game/tests/unit/rules/test_condition_evaluation.gd`

**Interfaces:**
- Consumes: `FactProvider`, `RepTiers`, `FakeFactProvider` (Task 2).
- Produces:
  - `@abstract class_name Condition extends RefCounted`: `@abstract evaluate(facts: FactProvider) -> bool`, `@abstract referenced_ids() -> Array[StringName]` (in first-seen order, no duplicates).
  - The node constructors: `AndCondition.new(children: Array[Condition])`, `OrCondition.new(children: Array[Condition])`, `NotCondition.new(child: Condition)`, `LiteralCondition.new(value: bool)`, `CallCondition.new(call_name: StringName, args: Array, ids: Array[StringName])` and `CompareCondition.new(left: ConditionValue, op: StringName, right: ConditionValue)`.
  - `@abstract ConditionValue`: `resolve(facts) -> Variant`, `value_type() -> StringName` (one of `TYPE_INT=&"int"`, `TYPE_TIER=&"tier"`, `TYPE_WORD=&"word"`), `referenced_ids() -> Array[StringName]`. `LiteralValue.new(value: Variant, type: StringName)`. `CallValue.new(call_name, args: Array, ids: Array[StringName], type: StringName)`.
  - `FactCalls` (static): `truth(call_name, args: Array, facts) -> bool` and `value(call_name, args, facts) -> Variant`, mapping §C onto `FactProvider` as below.

| §C call | FactProvider | §C call | FactProvider |
|---|---|---|---|
| `flag(x)` | `has_flag` | `var(x)` | `get_var` |
| `ms(x)` | `has_milestone` | `items(x)` | `item_count` |
| `has_item(x)` | `item_count >= 1` | `stat(a)` | `attribute` |
| `has_clue(x)` / `ded(x)` | `has_clue` / `has_deduction` | `skill(s)` | `check_total` |
| `perk(x)` | `has_perk` | `rep(x)` / `rep_tier(x)` | `reputation` / `rep_tier` |
| `in_party(x)` | `in_party` | `stage()` / `act()` / `level()` / `crowns()` | `escalation_stage` / `act` / `level` / `crowns` |
| `quest_active/done/failed(q)` | `quest_status == QUEST_ACTIVE/COMPLETED/FAILED` | `count_ms(a, b, …)` | count of `has_milestone` |
| `visited(z)` / `rumor_heard(r)` | `visited` / `rumor_heard` | `quest_stage(q)` | `quest_stage` |
| `finale_seized()` | `finale_value(FINALE_SEIZED) == &"true"` | `queen()` | `queen_condition` |
| | | `finale_oath()` / `finale_anselm()` | `finale_value(FINALE_OATH / FINALE_ANSELM)` |

  - `CompareCondition` semantics: if either side is `tier`, compare by `RepTiers.rank` (a tier literal is a `LiteralValue(&"friendly", TYPE_TIER)`). Two `int` sides compare numerically. Two `word` sides allow only `==` and `!=` on the `StringName` (the parser guarantees this).

- [ ] **Step 1: Write the failing tests** (build the nodes directly, no parser yet)

```gdscript
# test_condition_evaluation.gd — content-format §C semantics
func _call(n: StringName, args: Array) -> CallCondition:
	var ids: Array[StringName] = []
	for a: Variant in args:
		if a is StringName and String(a).contains("."): ids.append(a)
	return CallCondition.new(n, args, ids)
func test_flag_and_ms_calls() -> void:
	var f := FakeFactProvider.new(); f.flags[&"flag.x"] = true
	assert_true(_call(&"flag", [&"flag.x"]).evaluate(f))
	assert_false(_call(&"ms", [&"ms.a1_rat_survived"]).evaluate(f))
func test_has_item_means_at_least_one() -> void:
	var f := FakeFactProvider.new(); f.items[&"item.iron_key"] = 1
	assert_true(_call(&"has_item", [&"item.iron_key"]).evaluate(f))
func test_quest_status_calls() -> void:
	var f := FakeFactProvider.new(); f.quest_statuses[&"quest.q"] = FactProvider.QUEST_COMPLETED
	assert_true(_call(&"quest_done", [&"quest.q"]).evaluate(f))
	assert_false(_call(&"quest_active", [&"quest.q"]).evaluate(f))
func test_and_or_not_literal() -> void:
	var t := LiteralCondition.new(true); var fl := LiteralCondition.new(false)
	var f := FakeFactProvider.new()
	assert_false(AndCondition.new([t, fl] as Array[Condition]).evaluate(f))
	assert_true(OrCondition.new([fl, t] as Array[Condition]).evaluate(f))
	assert_true(NotCondition.new(fl).evaluate(f))
func test_int_compare() -> void:
	var f := FakeFactProvider.new(); f.stage = 2
	var c := CompareCondition.new(CallValue.new(&"stage", [], [] as Array[StringName], ConditionValue.TYPE_INT),
		&">=", LiteralValue.new(2, ConditionValue.TYPE_INT))
	assert_true(c.evaluate(f))
func test_tier_compare_uses_order() -> void:
	var f := FakeFactProvider.new(); f.rep_tiers[&"faction.strept"] = &"allied"
	var left := CallValue.new(&"rep_tier", [&"faction.strept"], [&"faction.strept"] as Array[StringName], ConditionValue.TYPE_TIER)
	assert_true(CompareCondition.new(left, &">=", LiteralValue.new(&"friendly", ConditionValue.TYPE_TIER)).evaluate(f))
	assert_false(CompareCondition.new(left, &"<", LiteralValue.new(&"wary", ConditionValue.TYPE_TIER)).evaluate(f))
func test_count_ms_counts_reached() -> void:
	var f := FakeFactProvider.new(); f.milestones[&"ms.a"] = true; f.milestones[&"ms.c"] = true
	var v := CallValue.new(&"count_ms", [&"ms.a", &"ms.b", &"ms.c"], [&"ms.a", &"ms.b", &"ms.c"] as Array[StringName], ConditionValue.TYPE_INT)
	assert_eq(v.resolve(f), 2)
func test_finale_seized_reads_finale_value() -> void:
	var f := FakeFactProvider.new(); f.finale[FactProvider.FINALE_SEIZED] = &"true"
	assert_true(_call(&"finale_seized", []).evaluate(f))
func test_referenced_ids_dedup_in_order() -> void:
	var c := AndCondition.new([_call(&"flag", [&"flag.a"]), _call(&"flag", [&"flag.a"]), _call(&"ms", [&"ms.b"])] as Array[Condition])
	assert_eq(c.referenced_ids(), [&"flag.a", &"ms.b"] as Array[StringName])
```

- [ ] **Step 2: Run to verify it fails**
Run: `tools/test.ps1 -Test tests/unit/rules/test_condition_evaluation.gd`. Expected: exit 1, a load error naming `CallCondition`.

- [ ] **Step 3: Implement** the classes. `And` and `Or` short-circuit. `FactCalls` uses two `match` blocks, kept under 30 lines each (split bool and value calls further if needed).

- [ ] **Step 4: Run to verify it passes**
Run: `tools/test.ps1 -Test tests/unit/rules`, then `tools/test.ps1`. Expected: exit 0.

- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/rules game/tests/unit/rules`
`git commit -m "feat(rules): condition AST and evaluation against FactProvider"`

---

### Task 6: Effect signatures and EffectSpec

Wave: 2

**Files:**
- Create: `game/src/domain/rules/effect_signature.gd`, `game/src/domain/rules/effect_signatures.gd`, `game/src/domain/rules/effect_spec.gd`
- Test: `game/tests/unit/rules/test_effect_signatures.gd`

**Interfaces:**
- Consumes: `ArgSpec` (Task 3).
- Produces:
  - `EffectSignature`: `static func of(op: StringName, param_specs: Array[String]) -> EffectSignature`, fields `op: StringName` and `params: Array[ArgSpec]`.
  - `EffectSignatures` (registry instance): `register(sig: EffectSignature) -> void` (asserts the op is not already registered), `has_op(op) -> bool`, `get_signature(op) -> EffectSignature` (null if unknown), `ops() -> Array[StringName]` (sorted).
  - `EffectSpec`: `_init(op: StringName, args: Array, ids: Array[StringName])`, fields `op` and `args`, and `referenced_ids() -> Array[StringName]`.

- [ ] **Step 1: Write the failing tests**

```gdscript
# test_effect_signatures.gd — architecture.md §3.4 (open/closed registry), content-format §E
func test_of_parses_param_specs() -> void:
	var s := EffectSignature.of(&"give_item", ["id:item", "int=1"])
	assert_eq(s.op, &"give_item")
	assert_eq(s.params.size(), 2)
	assert_true(s.params[1].optional)
func test_registry_lookup_and_sorted_ops() -> void:
	var r := EffectSignatures.new()
	r.register(EffectSignature.of(&"set_flag", ["id:flag"]))
	r.register(EffectSignature.of(&"add_xp", ["int"]))
	assert_true(r.has_op(&"set_flag"))
	assert_null(r.get_signature(&"nope"))
	assert_eq(r.ops(), [&"add_xp", &"set_flag"] as Array[StringName])
func test_effect_spec_holds_values() -> void:
	var e := EffectSpec.new(&"give_item", [&"item.poultice", 2], [&"item.poultice"] as Array[StringName])
	assert_eq(e.args[1], 2)
	assert_eq(e.referenced_ids(), [&"item.poultice"] as Array[StringName])
```

- [ ] **Step 2: Run to verify it fails**
Run: `tools/test.ps1 -Test tests/unit/rules/test_effect_signatures.gd`. Expected: exit 1, a load error naming `EffectSignature`.

- [ ] **Step 3: Implement** the three classes.

- [ ] **Step 4: Run to verify it passes**
Run: `tools/test.ps1 -Test tests/unit/rules`, then `tools/test.ps1`. Expected: exit 0.

- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/rules game/tests/unit/rules`
`git commit -m "feat(rules): effect signature registry and EffectSpec"`

---

### Task 7: WorldState

Wave: 2

**Files:**
- Create: `game/src/domain/world_state/world_state.gd`, and in `game/src/domain/world_state/events/`: `flag_changed.gd`, `var_changed.gd`, `milestone_reached.gd`, `act_changed.gd`
- Test: `game/tests/unit/world_state/test_world_state.gd`

**Interfaces:**
- Consumes: `EventOutbox`, `Snapshotable`.
- Produces: `WorldState extends Snapshotable` with:
  - `_init(var_bounds: Dictionary[StringName, Vector2i] = {})`
  - `set_flag(id, value := true) -> void` (the `clear_flag` effect calls `set_flag(id, false)`), `has_flag(id) -> bool`
  - `set_var(id, value: int) -> void` (no clamping), `add_var(id, delta: int) -> void` (clamps to the bounds when the var has them), `get_var(id) -> int` (default 0)
  - `reach_milestone(id) -> bool`, `has_milestone(id) -> bool`, `milestones() -> Array[StringName]` (in reach order), `count_milestones(ids: Array[StringName]) -> int`
  - `set_act(n: int) -> void` (asserts 1..3), `act() -> int` (starts at 1)
  - `drain_events()`, `to_snapshot()`, `restore()`
  - The events: `FlagChanged(id: StringName, value: bool)`, `VarChanged(id, old_value: int, new_value: int)`, `MilestoneReached(id)`, `ActChanged(old_act: int, new_act: int)`. Each is recorded only on a real change.

- [ ] **Step 1: Write the failing tests**

```gdscript
# test_world_state.gd — architecture.md §4.3, content-format §E (add_var clamps), gdd §6.1 (write-once milestones)
func test_flags_set_clear_and_event_only_on_change() -> void:
	var w := WorldState.new()
	w.set_flag(&"flag.courier_dead"); w.set_flag(&"flag.courier_dead")
	assert_true(w.has_flag(&"flag.courier_dead"))
	assert_eq(w.drain_events().size(), 1)
	w.set_flag(&"flag.courier_dead", false)
	assert_false(w.has_flag(&"flag.courier_dead"))
	assert_false((w.drain_events()[0] as FlagChanged).value)
func test_add_var_clamps_to_bounds() -> void:
	var w := WorldState.new({&"var.bulbs_recovered": Vector2i(0, 6)})
	w.add_var(&"var.bulbs_recovered", 10)
	assert_eq(w.get_var(&"var.bulbs_recovered"), 6)
	var e := w.drain_events()[0] as VarChanged
	assert_eq([e.old_value, e.new_value], [0, 6])
	w.add_var(&"var.bulbs_recovered", -20)
	assert_eq(w.get_var(&"var.bulbs_recovered"), 0)
func test_unbounded_var_and_default_zero() -> void:
	var w := WorldState.new()
	assert_eq(w.get_var(&"var.x"), 0)
	w.add_var(&"var.x", -5)
	assert_eq(w.get_var(&"var.x"), -5)
func test_milestone_write_once_in_order() -> void:
	var w := WorldState.new()
	assert_true(w.reach_milestone(&"ms.a1_rat_survived"))
	assert_false(w.reach_milestone(&"ms.a1_rat_survived"))
	w.reach_milestone(&"ms.a1_audience_done")
	assert_eq(w.milestones(), [&"ms.a1_rat_survived", &"ms.a1_audience_done"] as Array[StringName])
	assert_eq(w.drain_events().size(), 2)
	assert_eq(w.count_milestones([&"ms.a1_audience_done", &"ms.nope"] as Array[StringName]), 1)
func test_act_changes() -> void:
	var w := WorldState.new()
	assert_eq(w.act(), 1)
	w.set_act(2); w.set_act(2)
	var events := w.drain_events()
	assert_eq(events.size(), 1)
	assert_eq((events[0] as ActChanged).new_act, 2)
func test_snapshot_survives_json_round_trip() -> void:
	var w := WorldState.new()
	w.set_flag(&"flag.a"); w.set_var(&"var.b", 3); w.reach_milestone(&"ms.c"); w.set_act(2)
	var data: Dictionary = JSON.parse_string(JSON.stringify(w.to_snapshot()))
	var r := WorldState.new(); r.restore(data)
	assert_true(r.has_flag(&"flag.a"))
	assert_eq(r.get_var(&"var.b"), 3)
	assert_typeof(r.get_var(&"var.b"), TYPE_INT)
	assert_eq(r.milestones(), [&"ms.c"] as Array[StringName])
	assert_eq(r.act(), 2)
	assert_eq(r.drain_events().size(), 0)
```

- [ ] **Step 2: Run to verify it fails**
Run: `tools/test.ps1 -Test tests/unit/world_state`. Expected: exit 1, a load error naming `WorldState`.

- [ ] **Step 3: Implement** `WorldState` and its 4 events. Snapshot shape: `{"flags": [String], "vars": {String: int}, "milestones": [String], "act": int}`. Only flags that are true are stored.

- [ ] **Step 4: Run to verify it passes**
Run: `tools/test.ps1 -Test tests/unit/world_state`, then `tools/test.ps1`. Expected: exit 0.

- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/world_state game/tests/unit/world_state`
`git commit -m "feat(world_state): flags, vars, milestones and act with events and snapshot"`

---

### Task 8: Attributes and ActorSheet

Wave: 2

**Files:**
- Create: `game/src/domain/actors/attributes.gd`, `game/src/domain/actors/actor_sheet.gd`, and in `game/src/domain/actors/events/`: `attribute_increased.gd`, `actor_healed.gd`, `actor_damaged.gd`
- Test: `game/tests/unit/actors/test_attributes.gd`, `game/tests/unit/actors/test_actor_sheet.gd`

**Interfaces:**
- Consumes: `CheckSkills.ATTRIBUTES` (Task 2), `EventOutbox`, `Result`.
- Produces:
  - `Attributes` (an immutable value): `_init(values: Dictionary[StringName, int] = {})` (missing names are 3), `get_value(attr) -> int`, `with_point(attr) -> Attributes`, `to_dict() -> Dictionary[StringName, int]`, and the constants `BASE=3`, `MAX=10`, `CREATION_POINTS=4`, `CREATION_CAP=6`. `static func create(bonus: Dictionary[StringName, int]) -> Result` returns ok(Attributes) or one of the errors `&"unknown_attribute"`, `&"wrong_point_total"` (the sum must equal 4, no negatives) or `&"attribute_over_creation_cap"` (a value above 6).
  - `ActorSheet extends Snapshotable`: `_init(attrs: Attributes, level_provider: Callable)` (the Callable returns the current level as an int), `attributes() -> Attributes`, `attribute(name) -> int`, `max_hp() -> int` = 80 + 15×Grit + 8×(level−1), `max_stamina() -> int` = 85 + 5×Agility, `melee_mod() -> float` = 1 + 0.06×(Might−3), `ranged_mod() -> float` = 1 + 0.06×(Agility−3), `resist(type: StringName) -> float` = 0.05×Grit for `&"poison"` and `&"cold"` and 0.0 otherwise, `current_hp() -> int` (starts at max and reads as `mini(hp, max_hp())`), `heal(n)`, `damage(n)`, `full_restore()`, `spend_attribute_point(attr) -> Result` (errors `&"unknown_attribute"`, `&"no_attribute_points"`, `&"attribute_at_max"`), `unspent_attribute_points() -> int` = the count of {3, 5, 7, 9, 11} at or below the level, minus points spent. Constant `ATTRIBUTE_POINT_LEVELS: Array[int] = [3, 5, 7, 9, 11]`.
  - The events: `AttributeIncreased(attribute: StringName, new_value: int)`, `ActorHealed(amount: int, current_hp: int)` and `ActorDamaged(amount: int, current_hp: int)`, where `amount` is the HP actually changed. No event fires when nothing changed.

- [ ] **Step 1: Write the failing tests.** In `test_actor_sheet.gd`, hold the level in a member `var _level: int = 1` and pass `_level_of` (a method that returns `_level`). GDScript lambdas copy captured locals.

```gdscript
# test_attributes.gd — gdd §6.6 creation rules
func test_defaults_are_three() -> void:
	assert_eq(Attributes.new().get_value(&"presence"), 3)
func test_create_with_four_points() -> void:
	var r := Attributes.create({&"might": 2, &"grit": 2})
	assert_eq((r.value as Attributes).get_value(&"might"), 5)
func test_create_rejects_wrong_total_cap_and_unknown() -> void:
	assert_eq(Attributes.create({&"might": 3}).error_code, &"wrong_point_total")
	assert_eq(Attributes.create({&"might": 4}).error_code, &"attribute_over_creation_cap")
	assert_eq(Attributes.create({&"luck": 4}).error_code, &"unknown_attribute")
func test_with_point_is_immutable() -> void:
	var a := Attributes.new()
	var b := a.with_point(&"wits")
	assert_eq([a.get_value(&"wits"), b.get_value(&"wits")], [3, 4])

# test_actor_sheet.gd — gdd §6.6 derived stats, §6.8 attribute points
func test_derived_stats() -> void:
	var s := ActorSheet.new(Attributes.new({&"grit": 5, &"agility": 5, &"might": 5}), _level_of)
	assert_eq(s.max_hp(), 155)
	_level = 4
	assert_eq(s.max_hp(), 179)
	assert_eq(s.max_stamina(), 110)
	assert_almost_eq(s.melee_mod(), 1.12, 0.0001)
	assert_almost_eq(s.resist(&"poison"), 0.25, 0.0001)
	assert_eq(s.resist(&"fire"), 0.0)
func test_below_three_lowers_melee() -> void:
	var s := ActorSheet.new(Attributes.new({&"might": 2}), _level_of)
	assert_almost_eq(s.melee_mod(), 0.94, 0.0001)
func test_damage_heal_clamp_and_events() -> void:
	var s := ActorSheet.new(Attributes.new(), _level_of)   # max 125
	s.damage(200)
	assert_eq(s.current_hp(), 0)
	assert_eq((s.drain_events()[0] as ActorDamaged).amount, 125)
	s.heal(500)
	assert_eq(s.current_hp(), 125)
	s.full_restore()
	assert_eq(s.drain_events().size(), 1)   # heal only; full_restore at max is silent
func test_attribute_points_by_level() -> void:
	var s := ActorSheet.new(Attributes.new(), _level_of)
	_level = 2
	assert_eq(s.spend_attribute_point(&"grit").error_code, &"no_attribute_points")
	_level = 3
	assert_true(s.spend_attribute_point(&"grit").is_ok())
	assert_eq(s.attribute(&"grit"), 4)
	assert_eq(s.unspent_attribute_points(), 0)
	_level = 11
	assert_eq(s.unspent_attribute_points(), 4)
func test_attribute_cap_ten() -> void:
	var s := ActorSheet.new(Attributes.new({&"might": 10}), _level_of)
	_level = 3
	assert_eq(s.spend_attribute_point(&"might").error_code, &"attribute_at_max")
func test_snapshot_survives_json_round_trip() -> void:
	_level = 5
	var s := ActorSheet.new(Attributes.new({&"wits": 6}), _level_of)
	s.spend_attribute_point(&"wits"); s.damage(10)
	var r := ActorSheet.new(Attributes.new(), _level_of)
	r.restore(JSON.parse_string(JSON.stringify(s.to_snapshot())))
	assert_eq(r.attribute(&"wits"), 7)
	assert_eq(r.current_hp(), s.current_hp())
	assert_eq(r.unspent_attribute_points(), 1)
```

- [ ] **Step 2: Run to verify they fail**
Run: `tools/test.ps1 -Test tests/unit/actors`. Expected: exit 1, a load error naming `Attributes`.

- [ ] **Step 3: Implement** the classes and events. Snapshot: `{"attributes": {String: int}, "hp": int, "points_spent": int}`. `heal`/`damage` assert `n >= 0`.

- [ ] **Step 4: Run to verify they pass**
Run: `tools/test.ps1 -Test tests/unit/actors`, then `tools/test.ps1`. Expected: exit 0.

- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/actors game/tests/unit/actors`
`git commit -m "feat(actors): Attributes and ActorSheet"`

---

### Task 9: Factions

Wave: 2

**Files:**
- Create: `game/src/domain/factions/faction_definition.gd`, `game/src/domain/factions/reputation_ledger.gd`, and in `game/src/domain/factions/events/`: `reputation_changed.gd`, `reputation_tier_changed.gd`
- Test: `game/tests/unit/factions/test_reputation_ledger.gd`

**Interfaces:**
- Consumes: `RepTiers` (Task 2), `EventOutbox`.
- Produces:
  - `FactionDefinition`: `_init(id: StringName, display_name: String, start: int = 0)`, `var thresholds: Dictionary[StringName, int]` (the lower bounds; default `{wary: -49, neutral: -9, friendly: 10, allied: 50}`, anything below wary is hostile), `tier_for(value: int) -> StringName`.
  - `ReputationLedger extends Snapshotable`: `_init(defs: Array[FactionDefinition])` (each faction starts at its `start`), `add(faction_id, delta: int) -> void` (clamps to ±100 and asserts the faction is known), `value(id) -> int`, `tier(id) -> StringName`, `rep_mod(id) -> int` (Friendly +1, Allied +2, Wary −1, Hostile −2, Neutral 0), `drain_events()`.
  - The events: `ReputationChanged(id, old_value: int, new_value: int)` and `ReputationTierChanged(id, old_tier: StringName, new_tier: StringName)`.

- [ ] **Step 1: Write the failing tests**

```gdscript
# test_reputation_ledger.gd — gdd §6.12 tiers and range, §6.10 rep_mod
func _ledger() -> ReputationLedger:
	return ReputationLedger.new([FactionDefinition.new(&"faction.crown", "Crown"),
		FactionDefinition.new(&"faction.strept", "Strept", -10)] as Array[FactionDefinition])
func test_start_values_and_tier() -> void:
	var l := _ledger()
	assert_eq(l.value(&"faction.strept"), -10)
	assert_eq(l.tier(&"faction.strept"), &"wary")
func test_tier_boundaries() -> void:
	var d := FactionDefinition.new(&"faction.x", "X")
	var cases := {-100: &"hostile", -50: &"hostile", -49: &"wary", -10: &"wary", -9: &"neutral",
		9: &"neutral", 10: &"friendly", 49: &"friendly", 50: &"allied", 100: &"allied"}
	for v: int in cases:
		assert_eq(d.tier_for(v), cases[v], str(v))
func test_add_clamps_and_emits() -> void:
	var l := _ledger()
	l.add(&"faction.crown", 150)
	assert_eq(l.value(&"faction.crown"), 100)
	var events := l.drain_events()
	assert_eq(events.size(), 2)
	assert_eq((events[1] as ReputationTierChanged).new_tier, &"allied")
	l.add(&"faction.crown", 5)
	assert_eq(l.drain_events().size(), 0)
func test_rep_mod_by_tier() -> void:
	var l := _ledger()
	assert_eq(l.rep_mod(&"faction.crown"), 0)
	assert_eq(l.rep_mod(&"faction.strept"), -1)
	l.add(&"faction.crown", 15)
	assert_eq(l.rep_mod(&"faction.crown"), 1)
	l.add(&"faction.strept", -45)
	assert_eq(l.rep_mod(&"faction.strept"), -2)
func test_snapshot_survives_json_round_trip() -> void:
	var l := _ledger(); l.add(&"faction.crown", 15)
	var r := _ledger(); r.restore(JSON.parse_string(JSON.stringify(l.to_snapshot())))
	assert_eq(r.value(&"faction.crown"), 15)
	assert_typeof(r.value(&"faction.crown"), TYPE_INT)
```

- [ ] **Step 2: Run to verify it fails**
Run: `tools/test.ps1 -Test tests/unit/factions`. Expected: exit 1, a load error naming `ReputationLedger`.

- [ ] **Step 3: Implement.** Snapshot: `{"values": {String: int}}`. `tier_for` walks `RepTiers.ORDER` from the highest tier down.

- [ ] **Step 4: Run to verify it passes**
Run: `tools/test.ps1 -Test tests/unit/factions`, then `tools/test.ps1`. Expected: exit 0.

- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/factions game/tests/unit/factions`
`git commit -m "feat(factions): reputation ledger with tiers and rep_mod"`

---

### Task 10: LevelTable and ExperienceTrack

Wave: 2

**Files:**
- Create: `game/src/domain/progression/level_table.gd`, `game/src/domain/progression/experience_track.gd`, and in `game/src/domain/progression/events/`: `xp_gained.gd`, `level_gained.gd`
- Test: `game/tests/unit/progression/test_level_table.gd`, `game/tests/unit/progression/test_experience_track.gd`

**Interfaces:**
- Produces:
  - `LevelTable` (static): `MAX_LEVEL=12`, `ATTRIBUTE_POINT_LEVELS=[3,5,7,9,11]`, `xp_for(level) -> int` = 75×(L−1)×(L+2) (asserts 1..12), `level_for(xp) -> int`, `max_xp() -> int` (11550), `skill_points_at(level) -> int` = level−1, `attribute_points_at(level) -> int`.
  - `ExperienceTrack extends Snapshotable`: `grant(amount: int, source: StringName) -> void` (asserts amount ≥ 0; XP is capped at `max_xp()` and the excess is discarded), `xp()`, `level()`, `unspent_skill_points() -> int` = `skill_points_at(level)` − spent, `unspent_attribute_points() -> int` = `attribute_points_at(level)` (the earned count, see API extension 11), `spend_skill_point() -> Result` (err `&"no_skill_points"`), `drain_events()`.
  - The events: `XpGained(amount: int, source: StringName)` with the amount actually added, only when above 0, and `LevelGained(new_level: int)`, one per level crossed and in order, recorded after the `XpGained`.

- [ ] **Step 1: Write the failing tests**

```gdscript
# test_level_table.gd — gdd §6.8
func test_xp_table_matches_gdd() -> void:
	var expected := [0, 300, 750, 1350, 2100, 3000, 4050, 5250, 6600, 8100, 9750, 11550]
	for l: int in range(1, 13):
		assert_eq(LevelTable.xp_for(l), expected[l - 1], str(l))
func test_level_for() -> void:
	assert_eq([LevelTable.level_for(0), LevelTable.level_for(299), LevelTable.level_for(300),
		LevelTable.level_for(11550), LevelTable.level_for(99999)], [1, 1, 2, 12, 12])
func test_points_at() -> void:
	assert_eq(LevelTable.skill_points_at(12), 11)
	assert_eq(LevelTable.attribute_points_at(5), 2)
	assert_eq(LevelTable.attribute_points_at(12), 5)

# test_experience_track.gd — gdd §6.8
func test_grant_levels_up_with_events() -> void:
	var t := ExperienceTrack.new()
	t.grant(1350, &"quest")
	assert_eq(t.level(), 4)
	var events := t.drain_events()
	assert_eq((events[0] as XpGained).amount, 1350)
	assert_eq([(events[1] as LevelGained).new_level, (events[3] as LevelGained).new_level], [2, 4])
func test_cap_discards_excess() -> void:
	var t := ExperienceTrack.new()
	t.grant(20000, &"cheat")
	assert_eq(t.xp(), 11550)
	assert_eq((t.drain_events()[0] as XpGained).amount, 11550)
	t.grant(10, &"quest")
	assert_eq(t.drain_events().size(), 0)
func test_zero_grant_is_silent() -> void:
	var t := ExperienceTrack.new(); t.grant(0, &"x")
	assert_eq(t.drain_events().size(), 0)
func test_skill_points() -> void:
	var t := ExperienceTrack.new(); t.grant(1350, &"q")
	assert_eq(t.unspent_skill_points(), 3)
	assert_true(t.spend_skill_point().is_ok())
	assert_eq(t.unspent_skill_points(), 2)
	t.spend_skill_point(); t.spend_skill_point()
	assert_eq(t.spend_skill_point().error_code, &"no_skill_points")
func test_snapshot_survives_json_round_trip() -> void:
	var t := ExperienceTrack.new(); t.grant(800, &"q"); t.spend_skill_point()
	var r := ExperienceTrack.new(); r.restore(JSON.parse_string(JSON.stringify(t.to_snapshot())))
	assert_eq([r.xp(), r.level(), r.unspent_skill_points()], [800, 3, 1])
```

- [ ] **Step 2: Run to verify they fail**
Run: `tools/test.ps1 -Test tests/unit/progression`. Expected: exit 1, a load error naming `LevelTable`.

- [ ] **Step 3: Implement.** Snapshot: `{"xp": int, "skill_points_spent": int}`.

- [ ] **Step 4: Run to verify they pass**
Run: `tools/test.ps1 -Test tests/unit/progression`, then `tools/test.ps1`. Expected: exit 0.

- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/progression game/tests/unit/progression`
`git commit -m "feat(progression): level table and experience track"`

---

### Task 11: Wallet

Wave: 2

**Files:**
- Create: `game/src/domain/inventory/wallet.gd`, `game/src/domain/inventory/events/crowns_changed.gd`
- Test: `game/tests/unit/inventory/test_wallet.gd`

**Interfaces:**
- Produces: `Wallet extends Snapshotable`: `_init(start: int = 0)`, `add(n: int) -> void` (asserts n ≥ 0), `spend(n: int) -> Result` (asserts n ≥ 0; err `&"insufficient_crowns"` leaves the balance unchanged), `balance() -> int`, `drain_events()`. The event is `CrownsChanged(old_balance: int, new_balance: int)`, never recorded for 0. The `add_crowns(N)` handler (P3) uses `spend(-N)` when N < 0, so a list the player cannot pay for fails (§E).

- [ ] **Step 1: Write the failing tests**

```gdscript
# test_wallet.gd — gdd §6.9 (crowns), content-format §E add_crowns
func test_add_and_spend() -> void:
	var w := Wallet.new(30)
	w.add(10)
	assert_true(w.spend(40).is_ok())
	assert_eq(w.balance(), 0)
	assert_eq(w.drain_events().size(), 2)
func test_overspend_fails_without_change() -> void:
	var w := Wallet.new(30)
	assert_eq(w.spend(31).error_code, &"insufficient_crowns")
	assert_eq(w.balance(), 30)
	assert_eq(w.drain_events().size(), 0)
func test_snapshot_survives_json_round_trip() -> void:
	var w := Wallet.new(42)
	var r := Wallet.new(); r.restore(JSON.parse_string(JSON.stringify(w.to_snapshot())))
	assert_eq(r.balance(), 42)
	assert_typeof(r.balance(), TYPE_INT)
```

- [ ] **Step 2: Run to verify it fails.** `tools/test.ps1 -Test tests/unit/inventory/test_wallet.gd`. Expected: exit 1, a load error naming `Wallet`.
- [ ] **Step 3: Implement.** Snapshot: `{"crowns": int}`.
- [ ] **Step 4: Run to verify it passes.** `tools/test.ps1 -Test tests/unit/inventory`, then `tools/test.ps1`. Expected: exit 0.
- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/inventory game/tests/unit/inventory`
`git commit -m "feat(inventory): wallet"`

---

### Task 12: QueenCondition

Wave: 2

**Files:**
- Create: `game/src/domain/escalation/queen_condition.gd`, and in `game/src/domain/escalation/events/`: `queen_condition_changed.gd`, `antidote_administered.gd`
- Test: `game/tests/unit/escalation/test_queen_condition.gd`

**Interfaces:**
- Produces: `QueenCondition extends Snapshotable` with:
  - `_init()` (condition 0)
  - `recompute(stage: int, mitigations: int) -> void`: while the antidote is not administered, condition = clamp(min(stage, 3) − mitigations, 0, 3). Once it is administered, recompute does nothing.
  - `administer_antidote() -> void`: freezes the condition and records `AntidoteAdministered` once. A repeat call is a no-op.
  - `improve_on_milestone() -> void`: −1 down to 0, only after the antidote.
  - `condition() -> int`, `antidote_administered() -> bool`, `resolve_survival() -> bool` (= `antidote_administered()`, gdd §6.2 twist resolution), `drain_events()`
  - The events: `QueenConditionChanged(old_condition: int, new_condition: int)` (only on a change) and `AntidoteAdministered()`.

- [ ] **Step 1: Write the failing tests**

```gdscript
# test_queen_condition.gd — gdd §6.2
func test_formula() -> void:
	var cases := [[0, 0, 0], [1, 0, 1], [2, 1, 1], [1, 2, 0], [3, 0, 3], [4, 0, 3], [4, 2, 1]]
	for c: Array in cases:
		var q := QueenCondition.new(); q.recompute(c[0], c[1])
		assert_eq(q.condition(), c[2], str(c))
func test_change_event_only_on_change() -> void:
	var q := QueenCondition.new()
	q.recompute(2, 0); q.recompute(2, 0)
	var events := q.drain_events()
	assert_eq(events.size(), 1)
	assert_eq((events[0] as QueenConditionChanged).new_condition, 2)
func test_antidote_freezes_then_improves_to_zero() -> void:
	var q := QueenCondition.new(); q.recompute(2, 0)
	q.administer_antidote(); q.administer_antidote()
	q.recompute(4, 0)
	assert_eq(q.condition(), 2)
	q.improve_on_milestone(); q.improve_on_milestone(); q.improve_on_milestone()
	assert_eq(q.condition(), 0)
	assert_true(q.resolve_survival())
func test_improve_before_antidote_does_nothing() -> void:
	var q := QueenCondition.new(); q.recompute(3, 0); q.improve_on_milestone()
	assert_eq(q.condition(), 3)
	assert_false(q.resolve_survival())
func test_snapshot_survives_json_round_trip() -> void:
	var q := QueenCondition.new(); q.recompute(3, 1); q.administer_antidote()
	var r := QueenCondition.new(); r.restore(JSON.parse_string(JSON.stringify(q.to_snapshot())))
	assert_eq(r.condition(), 2)
	assert_true(r.antidote_administered())
```

- [ ] **Step 2: Run to verify it fails.** `tools/test.ps1 -Test tests/unit/escalation/test_queen_condition.gd`. Expected: exit 1, a load error naming `QueenCondition`.
- [ ] **Step 3: Implement.** Snapshot: `{"condition": int, "administered": bool}`.
- [ ] **Step 4: Run to verify it passes.** `tools/test.ps1 -Test tests/unit/escalation`, then `tools/test.ps1`. Expected: exit 0.
- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/escalation game/tests/unit/escalation`
`git commit -m "feat(escalation): Queen's condition"`

---

### Task 13: ConditionParser

Wave: 3

**Files:**
- Create: `game/src/domain/rules/condition_parser.gd`, `game/src/domain/rules/_internal/condition_calls.gd`, `game/src/domain/rules/_internal/condition_reader.gd`
- Test: `game/tests/unit/rules/test_condition_parser.gd`

**Interfaces:**
- Consumes: `ConditionLexer`/`ConditionToken` (Task 4), the AST nodes and `FactCalls` (Task 5), `ArgSpec` (Task 3), `RepTiers`.
- Produces:
  - `ConditionParser.parse(text: String) -> Result` (static) returns ok(`Condition`) or one of these errors: `&"empty_condition"` (blank text), `&"condition_syntax"` (unexpected token, missing paren, trailing tokens), `&"unknown_call"`, `&"bad_arg_count"`, `&"bad_arg"`, `&"bad_call_use"` (a bool call used in a comparison, or a value call used alone) and `&"bad_compare"` (a type mismatch, an ordering op on words, or a word that is not a tier compared with `rep_tier`). The detail names the offending text.
  - `ConditionCalls` (internal, static): `returns(call_name) -> StringName` (`&"bool"`, `&"int"`, `&"tier"`, `&"word"`, or `&""` if unknown) and `params(call_name) -> Array[ArgSpec]`. Table, exactly §C:
    - bool: `flag` id:flag · `ms` id:ms · `has_item` id:item · `has_clue` id:clue · `ded` id:ded · `perk` id:perk · `in_party` id:companion|ally · `quest_active`/`quest_done`/`quest_failed` id:quest · `visited` id:zone · `rumor_heard` id:rumor · `finale_seized` (none)
    - int: `var` id:var · `items` id:item · `stat` word:might|agility|grit|wits|presence · `skill` word:persuade|intimidate|investigate|lore · `rep` id:faction · `stage`/`act`/`level`/`crowns`/`queen` (none) · `count_ms` id:ms+
    - tier: `rep_tier` id:faction
    - word: `quest_stage` id:quest · `finale_oath` · `finale_anselm` (none)
- The reader's grammar (recursive descent, §C): `or := and ("or" and)*`, `and := unary ("and" unary)*`, `unary := "not" unary | atom`, `atom := "(" or ")" | literal | call-or-compare`. The words `true`/`false` form a `LiteralCondition` **only when no op follows them**. Otherwise they are compare words (`finale_oath() == true`). A word followed by `(` is a call. A comparison operand is an INT, a value call, or a bare WORD.

- [ ] **Step 1: Write the failing tests**

```gdscript
# test_condition_parser.gd — content-format §C (grammar, calls, examples)
func _eval(text: String, f: FakeFactProvider) -> bool:
	var r := ConditionParser.parse(text)
	assert_true(r.is_ok(), "%s: %s %s" % [text, r.error_code, r.detail])
	return (r.value as Condition).evaluate(f) if r.is_ok() else false
func test_spec_examples_parse_and_evaluate() -> void:
	var f := FakeFactProvider.new()
	f.clues[&"clue.chalice_pollen"] = true; f.check_totals[&"persuade"] = 4
	f.rep_tiers[&"faction.strept"] = &"friendly"; f.stage = 2
	f.milestones[&"ms.a1_sickroom_done"] = true; f.milestones[&"ms.a1_ring_done"] = true
	f.quest_stages[&"quest.main_a1"] = &"audience"
	assert_true(_eval("has_clue(clue.chalice_pollen) and skill(persuade) >= 4", f))
	assert_true(_eval("rep_tier(faction.strept) >= friendly or has_item(item.marnadal_torc)", f))
	assert_true(_eval("stage() >= 2 and not flag(flag.strept_guides)", f))
	assert_true(_eval("count_ms(ms.a1_sickroom_done, ms.a1_abbey_done, ms.a1_ring_done) >= 2", f))
	assert_true(_eval("quest_stage(quest.main_a1) == audience", f))
func test_every_call_parses() -> void:
	for text: String in ["true", "false", "flag(flag.a)", "ms(ms.a)", "has_item(item.a)", "has_clue(clue.a)",
			"ded(ded.a)", "perk(perk.a)", "in_party(companion.maelis)", "in_party(ally.aldric)",
			"quest_active(quest.a)", "quest_done(quest.a)", "quest_failed(quest.a)", "visited(zone.a)",
			"rumor_heard(rumor.a)", "finale_seized()", "var(var.a) == 0", "items(item.a) < 3",
			"stat(grit) >= 6", "rep(faction.a) > -10", "level() >= 5", "crowns() >= 1", "act() == 2",
			"queen() <= 2", "finale_anselm() != fled"]:
		assert_true(ConditionParser.parse(text).is_ok(), text)
func test_precedence_not_and_or() -> void:
	var f := FakeFactProvider.new(); f.flags[&"flag.b"] = true
	assert_true(_eval("flag(flag.a) and flag(flag.x) or flag(flag.b)", f))
	assert_false(_eval("flag(flag.a) and (flag(flag.x) or flag(flag.b))", f))
	assert_false(_eval("not flag(flag.b) or flag(flag.a)", f))
func test_spacing_and_parens_are_free() -> void:
	var f := FakeFactProvider.new(); f.stage = 3
	assert_true(_eval("  ((stage()>=3))and(not(flag(flag.x)))  ", f))
func test_true_as_compare_word() -> void:
	var f := FakeFactProvider.new(); f.finale[FactProvider.FINALE_OATH] = &"true"
	assert_true(_eval("finale_oath() == true", f))
func test_negative_int_compare() -> void:
	var f := FakeFactProvider.new(); f.reputation[&"faction.varn"] = -20
	assert_true(_eval("rep(faction.varn) <= -10", f))
func test_errors() -> void:
	assert_eq(ConditionParser.parse("  ").error_code, &"empty_condition")
	assert_eq(ConditionParser.parse("flag(flag.a").error_code, &"condition_syntax")
	assert_eq(ConditionParser.parse("flag(flag.a) flag(flag.b)").error_code, &"condition_syntax")
	assert_eq(ConditionParser.parse("teleport(zone.a)").error_code, &"unknown_call")
	assert_eq(ConditionParser.parse("flag(ms.a)").error_code, &"bad_arg")
	assert_eq(ConditionParser.parse("flag()").error_code, &"bad_arg_count")
	assert_eq(ConditionParser.parse("stage()").error_code, &"bad_call_use")
	assert_eq(ConditionParser.parse("flag(flag.a) == 1").error_code, &"bad_call_use")
	assert_eq(ConditionParser.parse("stage() >= friendly").error_code, &"bad_compare")
	assert_eq(ConditionParser.parse("rep_tier(faction.a) >= beloved").error_code, &"bad_compare")
	assert_eq(ConditionParser.parse("quest_stage(quest.a) > audience").error_code, &"bad_compare")
	assert_eq(ConditionParser.parse("skill(sneak) >= 2").error_code, &"bad_arg")
func test_referenced_ids() -> void:
	var c := ConditionParser.parse("has_clue(clue.a) and count_ms(ms.b, ms.c) >= 1 and stage() > 0").value as Condition
	assert_eq(c.referenced_ids(), [&"clue.a", &"ms.b", &"ms.c"] as Array[StringName])
```

- [ ] **Step 2: Run to verify it fails.** `tools/test.ps1 -Test tests/unit/rules/test_condition_parser.gd`. Expected: exit 1, a load error naming `ConditionParser`.
- [ ] **Step 3: Implement** `ConditionCalls`, `ConditionReader` (holds the tokens and position; every rule method returns `Result`) and `ConditionParser.parse`, which lexes then reads. Keep each reader method at 30 lines or fewer.
- [ ] **Step 4: Run to verify it passes.** `tools/test.ps1 -Test tests/unit/rules`, then `tools/test.ps1`. Expected: exit 0.
- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/rules game/tests/unit/rules`
`git commit -m "feat(rules): condition parser for the content-format condition language"`

---

### Task 14: EffectParser, the §E signature set, and the open/closed guarantee

Wave: 3

**Files:**
- Create: `game/src/domain/rules/effect_parser.gd`, `game/tests/helpers/content_format_effects.gd`
- Test: `game/tests/unit/rules/test_effect_parser.gd`

**Interfaces:**
- Consumes: `EffectSignatures`, `EffectSignature`, `EffectSpec` (Task 6), `ArgSpec.bind`/`ids_in` (Task 3).
- Produces:
  - `EffectParser`: `_init(signatures: EffectSignatures)`, `parse(text: String) -> Result` (ok(`EffectSpec`) or one of the errors `&"effect_syntax"` (no `op(`…`)` shape, or text after the `)`), `&"unknown_op"`, `&"bad_arg_count"`, `&"bad_arg"`), and `parse_list(texts: Array[String]) -> Result` (ok(`Array[EffectSpec]`) or the first error, with `"#<index>: "` prepended to its detail). The op is the text before `(`; the args are the text between `(` and the last `)`, split on `,` and stripped; `op()` has 0 args.
  - `ContentFormatEffects` (test helper): `static func signatures() -> EffectSignatures` returns a registry with **exactly the 35 ops of content-format §E**:
    `set_flag`/`clear_flag` [id:flag] · `set_var`/`add_var` [id:var, int] · `reach_milestone` [id:ms] · `set_act` [int:1..3] · `give_item`/`take_item` [id:item, int=1] · `add_crowns` [int] · `add_rep` [id:faction, int] · `add_xp` [int] · `add_clue` [id:clue] · `start_quest`/`fail_quest` [id:quest] · `complete_objective` [id:quest, local] · `start_dialogue` [id:dlg] · `start_encounter` [id:enc] · `goto_zone` [id:zone, local] · `unlock_map_node`/`add_map_pin` [id:map] · `recruit`/`dismiss` [id:companion] · `add_ally`/`remove_ally` [id:ally] · `add_rumor`/`verify_rumor` [id:rumor] · `heal_player` [int|word:full] · `damage_player` [int] · `apply_status` [word:poison|burning|bleed|chill, int] · `play_beat` [local] · `set_checkpoint` [local] · `open_shop` [id:npc] · `administer_antidote` [word:queen|maelis] · `send_antidote_rider` [] · `game_over` [local].
    P3's composer test asserts that the composed registry contains every op here with the same specs. The ops from the later format addendum come on top.

- [ ] **Step 1: Write the failing tests**

```gdscript
# test_effect_parser.gd — content-format §E, architecture.md §3.4 (open/closed)
var _p := EffectParser.new(ContentFormatEffects.signatures())
func test_registry_has_exactly_the_35_spec_ops() -> void:
	assert_eq(ContentFormatEffects.signatures().ops().size(), 35)
func test_parses_args_with_types() -> void:
	var e := _p.parse("give_item(item.dravin_letter, 1)").value as EffectSpec
	assert_eq(e.op, &"give_item")
	assert_eq(e.args, [&"item.dravin_letter", 1])
	assert_eq(e.referenced_ids(), [&"item.dravin_letter"] as Array[StringName])
func test_negative_and_default_args() -> void:
	assert_eq((_p.parse("add_crowns(-40)").value as EffectSpec).args, [-40])
	assert_eq((_p.parse(" add_rep( faction.varn , -10 ) ").value as EffectSpec).args, [&"faction.varn", -10])
	assert_eq((_p.parse("give_item(item.poultice)").value as EffectSpec).args, [&"item.poultice", 1])
	assert_eq((_p.parse("heal_player(full)").value as EffectSpec).args, [&"full"])
	assert_eq((_p.parse("send_antidote_rider()").value as EffectSpec).args, [])
func test_local_ids_are_not_referenced_ids() -> void:
	var e := _p.parse("goto_zone(zone.cintra_docks, hatch_landing)").value as EffectSpec
	assert_eq(e.referenced_ids(), [&"zone.cintra_docks"] as Array[StringName])
func test_errors() -> void:
	assert_eq(_p.parse("set_flag flag.a").error_code, &"effect_syntax")
	assert_eq(_p.parse("set_flag(flag.a) extra").error_code, &"effect_syntax")
	assert_eq(_p.parse("teleport(zone.a)").error_code, &"unknown_op")
	assert_eq(_p.parse("set_flag(ms.a)").error_code, &"bad_arg")
	assert_eq(_p.parse("set_act(4)").error_code, &"bad_arg")
	assert_eq(_p.parse("apply_status(soot, 1)").error_code, &"bad_arg")
	assert_eq(_p.parse("set_flag()").error_code, &"bad_arg_count")
func test_parse_list_reports_index() -> void:
	var r := _p.parse_list(["set_flag(flag.a)", "nope()"] as Array[String])
	assert_eq(r.error_code, &"unknown_op")
	assert_string_starts_with(r.detail, "#1: ")
	assert_eq((_p.parse_list(["set_flag(flag.a)", "add_xp(30)"] as Array[String]).value as Array).size(), 2)
func test_new_op_needs_only_a_registered_signature() -> void:
	# The "one handler + one test + one registration line" guarantee: no parser change.
	var sigs := ContentFormatEffects.signatures()
	assert_eq(EffectParser.new(sigs).parse("cancel_journey()").error_code, &"unknown_op")
	sigs.register(EffectSignature.of(&"cancel_journey", [] as Array[String]))
	assert_true(EffectParser.new(sigs).parse("cancel_journey()").is_ok())
```

- [ ] **Step 2: Run to verify it fails.** `tools/test.ps1 -Test tests/unit/rules/test_effect_parser.gd`. Expected: exit 1, a load error naming `EffectParser`.
- [ ] **Step 3: Implement** `EffectParser` and `ContentFormatEffects` (one `register` line per op).
- [ ] **Step 4: Run to verify it passes.** `tools/test.ps1 -Test tests/unit/rules`, then `tools/test.ps1`. Expected: exit 0.
- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/rules game/tests/helpers game/tests/unit/rules`
`git commit -m "feat(rules): effect parser over a signature registry; content-format effect set"`

---

### Task 15: CheckTotals

Wave: 3

**Files:**
- Create: `game/src/domain/actors/check_totals.gd`
- Test: `game/tests/unit/actors/test_check_totals.gd`

**Interfaces:**
- Consumes: `ActorSheet` (Task 8), `CheckSkills` (Task 2).
- Produces: `CheckTotals.compute(skill: StringName, sheet: ActorSheet, perks: Array[StringName], items: Array[StringName]) -> int` (static; asserts `CheckSkills.is_check_skill(skill)`). Excluding `rep_mod` (CheckResolver adds it), it returns:
  - persuade: Presence, +1 with `perk.silver_tongue`
  - intimidate: max(Might, Presence), +1 with `perk.hard_stare`
  - investigate: Wits, +1 with `perk.keen_eye`
  - lore: Wits
  - any attribute name: that attribute's value (the hazard checks)
  - `items`: summed through `const ITEM_BONUSES: Dictionary[StringName, Dictionary] = {}` (item id to {skill: bonus}). gdd names no unconditional item bonus, so the table is empty.

  These modifiers belong to **SessionFactProvider/CheckResolver (P3/P2)**, not here: Lore +2 with Maelis in the party, and the speaker-dependent ones (kosk_writ +2 with officials, the −2 Strept badge).

- [ ] **Step 1: Write the failing tests**

```gdscript
# test_check_totals.gd — gdd §6.10 check rules, §6.8 Tongue perks
func _sheet(v: Dictionary[StringName, int]) -> ActorSheet:
	return ActorSheet.new(Attributes.new(v), func() -> int: return 1)
func test_persuade_with_perk() -> void:
	var s := _sheet({&"presence": 5})
	assert_eq(CheckTotals.compute(&"persuade", s, [] as Array[StringName], [] as Array[StringName]), 5)
	assert_eq(CheckTotals.compute(&"persuade", s, [&"perk.silver_tongue"] as Array[StringName], [] as Array[StringName]), 6)
func test_intimidate_uses_max_of_might_presence() -> void:
	var s := _sheet({&"might": 6, &"presence": 4})
	assert_eq(CheckTotals.compute(&"intimidate", s, [&"perk.hard_stare"] as Array[StringName], [] as Array[StringName]), 7)
func test_investigate_and_lore() -> void:
	var s := _sheet({&"wits": 4})
	assert_eq(CheckTotals.compute(&"investigate", s, [&"perk.keen_eye"] as Array[StringName], [] as Array[StringName]), 5)
	assert_eq(CheckTotals.compute(&"lore", s, [&"perk.keen_eye"] as Array[StringName], [] as Array[StringName]), 4)
func test_attribute_checks_for_hazards() -> void:
	var s := _sheet({&"agility": 5, &"grit": 6})
	assert_eq(CheckTotals.compute(&"agility", s, [] as Array[StringName], [] as Array[StringName]), 5)
	assert_eq(CheckTotals.compute(&"grit", s, [&"perk.silver_tongue"] as Array[StringName], [] as Array[StringName]), 6)
func test_unlisted_items_add_nothing() -> void:
	var s := _sheet({&"presence": 5})
	assert_eq(CheckTotals.compute(&"persuade", s, [] as Array[StringName], [&"item.kosk_writ"] as Array[StringName]), 5)
```

- [ ] **Step 2: Run to verify it fails.** `tools/test.ps1 -Test tests/unit/actors/test_check_totals.gd`. Expected: exit 1, a load error naming `CheckTotals`.
- [ ] **Step 3: Implement** with a `PERK_BONUSES: Dictionary[StringName, StringName]` constant (skill to perk id, +1 each).
- [ ] **Step 4: Run to verify it passes.** `tools/test.ps1 -Test tests/unit/actors`, then `tools/test.ps1`. Expected: exit 0.
- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/actors game/tests/unit/actors`
`git commit -m "feat(actors): check totals for skills and attribute checks"`

---

### Task 16: SkillTree

Wave: 3

**Files:**
- Create: `game/src/domain/progression/skill_node_definition.gd`, `game/src/domain/progression/skill_tree_definition.gd`, `game/src/domain/progression/skill_tree.gd`, `game/src/domain/progression/events/perk_unlocked.gd`
- Test: `game/tests/unit/progression/test_skill_tree.gd`

**Interfaces:**
- Consumes: `ExperienceTrack.unspent_skill_points()`/`spend_skill_point()` (Task 10).
- Produces:
  - `SkillNodeDefinition`: `_init(perk_id: StringName, branch: StringName, tier: int)`, where tier 1–3 are the tiers and 4 is the capstone. Optional `title: String` and `text: String`.
  - `SkillTreeDefinition`: `_init(nodes: Array[SkillNodeDefinition])`, `node(perk_id) -> SkillNodeDefinition` (null if unknown), `nodes_in(branch) -> Array[SkillNodeDefinition]`, `const TIER_GATES: Dictionary[int, int] = {1: 0, 2: 2, 3: 3, 4: 5}` (points already spent in that branch).
  - `SkillTree extends Snapshotable`: `_init(def: SkillTreeDefinition, track: ExperienceTrack)`, `can_unlock(perk_id) -> Result`, `unlock(perk_id) -> Result` (spends 1 point through `track.spend_skill_point()` and records `PerkUnlocked(id)`), `has(perk_id) -> bool`, `points_in(branch) -> int`, `perks() -> Array[StringName]` (in unlock order), `drain_events()`. Errors are checked in this order: `&"unknown_perk"`, `&"already_unlocked"`, `&"tier_locked"`, `&"no_skill_points"`.

- [ ] **Step 1: Write the failing tests.** The fixture is the gdd §6.8 table: Blade `steady_hand` 1, `shoulder_charge` 1, `riposte_master` 2, `heavy_swing` 2, `iron_skin` 3, `lions_fury` 4; Road `quick_reload` 1, `pathfinder` 1, `field_medic` 2, `cold_blooded` 2, `hunters_eye` 3, `second_wind` 4; Tongue `silver_tongue` 1, `hard_stare` 1, `keen_eye` 2, `haggler` 2, `read_the_room` 3, `kingmaker` 4. The branches are `&"blade"`, `&"road"` and `&"tongue"`, and every perk id is `perk.<name>`.

```gdscript
# test_skill_tree.gd — gdd §6.8 skill tree
func test_tier_gate_counts_points_in_branch() -> void:
	var t := _tree_at_level(4)   # 3 points
	assert_eq(t.can_unlock(&"perk.riposte_master").error_code, &"tier_locked")
	t.unlock(&"perk.steady_hand"); t.unlock(&"perk.shoulder_charge")
	assert_true(t.unlock(&"perk.riposte_master").is_ok())
	assert_eq(t.points_in(&"blade"), 3)
func test_eleven_points_finish_one_branch_plus_part() -> void:
	var t := _tree_at_level(12)
	for p: String in ["steady_hand", "shoulder_charge", "riposte_master", "heavy_swing", "iron_skin", "lions_fury",
			"quick_reload", "pathfinder", "field_medic", "cold_blooded", "hunters_eye"]:
		assert_true(t.unlock(StringName("perk." + p)).is_ok(), p)
	assert_eq(t.can_unlock(&"perk.second_wind").error_code, &"no_skill_points")
func test_errors_and_event() -> void:
	var t := _tree_at_level(2)
	assert_eq(t.can_unlock(&"perk.nope").error_code, &"unknown_perk")
	t.unlock(&"perk.silver_tongue")
	assert_eq(t.can_unlock(&"perk.silver_tongue").error_code, &"already_unlocked")
	assert_eq(t.can_unlock(&"perk.hard_stare").error_code, &"no_skill_points")
	assert_eq((t.drain_events()[0] as PerkUnlocked).id, &"perk.silver_tongue")
	assert_true(t.has(&"perk.silver_tongue"))
func test_snapshot_survives_json_round_trip() -> void:
	var t := _tree_at_level(3); t.unlock(&"perk.quick_reload")
	var r := SkillTree.new(_def(), _track); r.restore(JSON.parse_string(JSON.stringify(t.to_snapshot())))
	assert_eq(r.perks(), [&"perk.quick_reload"] as Array[StringName])
	assert_eq(r.points_in(&"road"), 1)
```
`_tree_at_level(n)` builds `_track` by granting `LevelTable.xp_for(n)` and returns `SkillTree.new(_def(), _track)`.

- [ ] **Step 2: Run to verify it fails.** `tools/test.ps1 -Test tests/unit/progression/test_skill_tree.gd`. Expected: exit 1, a load error naming `SkillNodeDefinition`.
- [ ] **Step 3: Implement.** Snapshot: `{"perks": [String]}`. The spent-point count lives in the track's snapshot.
- [ ] **Step 4: Run to verify it passes.** `tools/test.ps1 -Test tests/unit/progression`, then `tools/test.ps1`. Expected: exit 0.
- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/progression game/tests/unit/progression`
`git commit -m "feat(progression): skill tree with tier gates"`

---

### Task 17: Item definitions and Inventory

Wave: 3

**Files:**
- Create: in `game/src/domain/inventory/`: `item_definition.gd`, `item_weapon_payload.gd`, `item_armor_payload.gd`, `item_consumable_payload.gd`, `inventory.gd`, and in `game/src/domain/inventory/events/`: `item_added.gd`, `item_removed.gd`
- Test: `game/tests/unit/inventory/test_inventory.gd`; helper `game/tests/helpers/item_def_builder.gd`

**Interfaces:**
- Consumes: `EffectSpec` (Task 6).
- Produces:
  - `ItemDefinition`: `_init(id: StringName, category: StringName, stack_max: int = 1, price: int = 0)`, with optional vars `display_name: String`, `description: String`, `equip_slot: StringName` (`&""` or `main_hand|ranged|armor|trinket`), `tags: Array[StringName]`, `weapon: ItemWeaponPayload`, `armor: ItemArmorPayload`, `consumable: ItemConsumablePayload` and `readable_text: String`. Constants `CATEGORIES = [weapon, armor, trinket, consumable, ammo, key, document]` and `ITEM_SLOTS = [main_hand, ranged, armor, trinket]`. `is_protected() -> bool` is true for category key or document.
  - `ItemWeaponPayload`: `base: int`, `damage_type: StringName`, `block_pct: float`, `armor_pen: int`, `bonus_vs: Dictionary[StringName, float]`, `moveset: StringName`. `ItemArmorPayload`: `armor: int`, `resist: Dictionary[StringName, float]`. `ItemConsumablePayload`: `effects: Array[EffectSpec]`, `use_time: float`. Plain vars only.
  - `Inventory extends Snapshotable` with:
    - `_init(catalog: Dictionary[StringName, ItemDefinition])`
    - `add(id, n := 1) -> Result`: ok(added: int) adds `min(n, room)`; err `&"unknown_item"` or `&"stack_full"` (no room at all)
    - `remove(id, n := 1, force := false) -> Result`: err `&"protected_item"` (a key or document without force) or `&"not_enough"`; there is no partial remove
    - `count(id) -> int`, `has(id) -> bool`, `room_for(id) -> int`, `items_in(category) -> Array[StringName]` (sorted), `all_ids() -> Array[StringName]` (sorted), `definition(id) -> ItemDefinition` (null if unknown), `drain_events()`
    - The events: `ItemAdded(id, added: int, total: int)` and `ItemRemoved(id, removed: int, total: int)`.
  - `ItemDefBuilder` (test helper): `static func item(id, category, stack_max := 1, price := 0) -> ItemDefinition` and `static func catalog(defs: Array[ItemDefinition]) -> Dictionary[StringName, ItemDefinition]`.

- [ ] **Step 1: Write the failing tests**

```gdscript
# test_inventory.gd — gdd §6.9 (stacks, key items), architecture.md §4.12
func _inv() -> Inventory:
	return Inventory.new(ItemDefBuilder.catalog([ItemDefBuilder.item(&"item.poultice", &"consumable", 10, 8),
		ItemDefBuilder.item(&"item.dravin_letter", &"key"), ItemDefBuilder.item(&"item.choir_list", &"document"),
		ItemDefBuilder.item(&"item.arming_sword", &"weapon", 1, 40)] as Array[ItemDefinition]))
func test_add_count_and_partial_fill() -> void:
	var i := _inv()
	assert_eq(i.add(&"item.poultice", 8).value, 8)
	assert_eq(i.add(&"item.poultice", 5).value, 2)
	assert_eq(i.count(&"item.poultice"), 10)
func test_add_to_full_stack_fails_without_event() -> void:
	var i := _inv(); i.add(&"item.arming_sword"); i.drain_events()
	assert_eq(i.add(&"item.arming_sword").error_code, &"stack_full")
	assert_eq(i.drain_events().size(), 0)
	assert_eq(i.add(&"item.nope").error_code, &"unknown_item")
func test_remove_rules() -> void:
	var i := _inv(); i.add(&"item.poultice", 2); i.add(&"item.dravin_letter")
	assert_eq(i.remove(&"item.poultice", 3).error_code, &"not_enough")
	assert_eq(i.count(&"item.poultice"), 2)
	assert_eq(i.remove(&"item.dravin_letter").error_code, &"protected_item")
	assert_true(i.remove(&"item.dravin_letter", 1, true).is_ok())
	assert_false(i.has(&"item.dravin_letter"))
func test_items_in_category_sorted() -> void:
	var i := _inv(); i.add(&"item.choir_list"); i.add(&"item.poultice")
	assert_eq(i.items_in(&"document"), [&"item.choir_list"] as Array[StringName])
	assert_eq(i.all_ids(), [&"item.choir_list", &"item.poultice"] as Array[StringName])
func test_events() -> void:
	var i := _inv(); i.add(&"item.poultice", 2); i.remove(&"item.poultice")
	var e := i.drain_events()
	assert_eq([(e[0] as ItemAdded).total, (e[1] as ItemRemoved).total], [2, 1])
func test_snapshot_survives_json_round_trip() -> void:
	var i := _inv(); i.add(&"item.poultice", 3)
	var r := _inv(); r.restore(JSON.parse_string(JSON.stringify(i.to_snapshot())))
	assert_eq(r.count(&"item.poultice"), 3)
	assert_typeof(r.count(&"item.poultice"), TYPE_INT)
```

- [ ] **Step 2: Run to verify it fails.** `tools/test.ps1 -Test tests/unit/inventory/test_inventory.gd`. Expected: exit 1, a load error naming `ItemDefBuilder` or `Inventory`.
- [ ] **Step 3: Implement.** Snapshot: `{"counts": {String: int}}`, with zero counts removed. `add`/`remove` assert `n >= 1`.
- [ ] **Step 4: Run to verify it passes.** `tools/test.ps1 -Test tests/unit/inventory`, then `tools/test.ps1`. Expected: exit 0.
- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/inventory game/tests/helpers game/tests/unit/inventory`
`git commit -m "feat(inventory): item definitions and inventory stacks"`

---

### Task 18: Equipment and QuickSlots

Wave: 4

**Files:**
- Create: `game/src/domain/inventory/equipment.gd`, `game/src/domain/inventory/quick_slots.gd`, and in `game/src/domain/inventory/events/`: `item_equipped.gd`, `item_unequipped.gd`
- Test: `game/tests/unit/inventory/test_equipment.gd`, `game/tests/unit/inventory/test_quick_slots.gd`

**Interfaces:**
- Consumes: `Inventory.has`/`definition`/`count`, `ItemDefinition`, `ItemDefBuilder` (Task 17).
- Produces:
  - `Equipment extends Snapshotable`: `_init(inventory: Inventory)`, `SLOTS = [main_hand, ranged, armor, trinket_1, trinket_2]`, `equip(slot, id) -> Result` (errors in order: `&"unknown_slot"`, `&"not_owned"`, `&"wrong_slot"` (the item's `equip_slot` must equal the slot, where `trinket` fits `trinket_1`/`trinket_2`), `&"already_equipped"` (the same id is in another slot)), `unequip(slot) -> void`, `equipped(slot) -> StringName` (`&""` if empty), `is_equipped(id) -> bool`, `armor_total() -> int` (the sum of the equipped `armor.armor`, gdd §6.6), `drain_events()`. Equipping over an occupied slot records `ItemUnequipped(slot, old_id)` and then `ItemEquipped(slot, id)`.
  - `QuickSlots extends Snapshotable`: `_init(inventory: Inventory)`, `SIZE = 4`, `assign(index: int, id) -> Result` (errors `&"bad_index"`, `&"not_owned"`, `&"not_consumable"`; an id already in another slot moves), `clear(index) -> void`, `item_at(index) -> StringName`. A slot keeps its id when the stack runs out, and the use case checks the count.
  - **Note for P3:** `SellItemUseCase` and the `take_item` handler must unequip an item before removing its last copy.

- [ ] **Step 1: Write the failing tests**

```gdscript
# test_equipment.gd — gdd §6.9 slots, §6.6 armor sum
func test_equip_rules() -> void:
	var e := Equipment.new(_inv_with_gear())
	assert_eq(e.equip(&"belt", &"item.arming_sword").error_code, &"unknown_slot")
	assert_eq(e.equip(&"main_hand", &"item.mane_cleaver").error_code, &"not_owned")
	assert_eq(e.equip(&"armor", &"item.arming_sword").error_code, &"wrong_slot")
	assert_true(e.equip(&"main_hand", &"item.arming_sword").is_ok())
	assert_true(e.equip(&"trinket_2", &"item.lucky_coin").is_ok())
	assert_eq(e.equip(&"trinket_1", &"item.lucky_coin").error_code, &"already_equipped")
func test_swap_emits_unequip_then_equip() -> void:
	var e := Equipment.new(_inv_with_gear())
	e.equip(&"main_hand", &"item.arming_sword"); e.drain_events()
	e.equip(&"main_hand", &"item.spare_sword")
	var ev := e.drain_events()
	assert_is(ev[0], ItemUnequipped); assert_is(ev[1], ItemEquipped)
func test_armor_total() -> void:
	var e := Equipment.new(_inv_with_gear())   # gambeson armor 10
	e.equip(&"armor", &"item.gambeson")
	assert_eq(e.armor_total(), 10)
func test_snapshot_survives_json_round_trip() -> void:
	var inv := _inv_with_gear(); var e := Equipment.new(inv); e.equip(&"armor", &"item.gambeson")
	var r := Equipment.new(inv); r.restore(JSON.parse_string(JSON.stringify(e.to_snapshot())))
	assert_eq(r.equipped(&"armor"), &"item.gambeson")

# test_quick_slots.gd — gdd §6.4 quick items (4 slots)
func test_assign_rules_and_move() -> void:
	var q := QuickSlots.new(_inv_with_gear())
	assert_eq(q.assign(4, &"item.poultice").error_code, &"bad_index")
	assert_eq(q.assign(0, &"item.arming_sword").error_code, &"not_consumable")
	q.assign(0, &"item.poultice"); q.assign(2, &"item.poultice")
	assert_eq([q.item_at(0), q.item_at(2)], [&"", &"item.poultice"])
func test_snapshot_survives_json_round_trip() -> void:
	var inv := _inv_with_gear(); var q := QuickSlots.new(inv); q.assign(1, &"item.poultice")
	var r := QuickSlots.new(inv); r.restore(JSON.parse_string(JSON.stringify(q.to_snapshot())))
	assert_eq(r.item_at(1), &"item.poultice")
```
`_inv_with_gear()` builds, with `ItemDefBuilder`, an inventory that owns an arming sword and a spare sword (weapon, `main_hand`), a gambeson (armor, `armor`, `ItemArmorPayload.armor = 10`), a lucky coin (trinket, `trinket`) and 2 poultices (consumable).

- [ ] **Step 2: Run to verify they fail.** `tools/test.ps1 -Test tests/unit/inventory`. Expected: exit 1, a load error naming `Equipment`.
- [ ] **Step 3: Implement.** Snapshots: `{"slots": {String: String}}` and `{"slots": [String × 4]}`.
- [ ] **Step 4: Run to verify they pass.** `tools/test.ps1 -Test tests/unit/inventory`, then `tools/test.ps1`. Expected: exit 0.
- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/inventory game/tests/unit/inventory`
`git commit -m "feat(inventory): equipment slots and quick slots"`

---

### Task 19: Shop

Wave: 4

**Files:**
- Create: `game/src/domain/inventory/shop.gd`
- Test: `game/tests/unit/inventory/test_shop.gd`

**Interfaces:**
- Consumes: `Inventory` (`room_for`, `add`, `remove`, `definition`, `has`), `Wallet` (`balance`, `spend`, `add`).
- Produces: `Shop extends Snapshotable` with:
  - `_init(stock: Dictionary[StringName, int], inventory: Inventory, wallet: Wallet)`
  - `buy_price(item_id, price_mod: float) -> int` = `maxi(0, roundi(price × price_mod))`. `price_mod` is already combined by the application: shop `price_mod`, escalation +10%/+20% and Haggler −20%.
  - `buy(item_id, price_mod: float) -> Result`: ok(price paid). Errors, checked before any change: `&"unknown_item"`, `&"out_of_stock"`, `&"stack_full"`, `&"insufficient_crowns"`.
  - `sell_price(item_id) -> int` = `floori(price × SELL_RATE)` with `SELL_RATE = 0.25` (gdd §6.9).
  - `sell(item_id) -> Result`: ok(paid). Errors `&"not_owned"` and `&"protected_item"`. It adds 1 to the shop's stock.
  - `stock_of(id) -> int`
  - No events of its own: the `Inventory` and `Wallet` outboxes record them.

- [ ] **Step 1: Write the failing tests**

```gdscript
# test_shop.gd — gdd §6.9 (selling pays 25%), §6.1 price modifiers, §6.8 Haggler
func test_buy_applies_price_mod_and_moves_stock() -> void:
	var s := _shop(100)   # stock: 2 poultices at price 8; wallet 100
	assert_eq(s.buy(&"item.poultice", 1.1).value, 9)
	assert_eq([s.stock_of(&"item.poultice"), _inv.count(&"item.poultice"), _wallet.balance()], [1, 1, 91])
func test_failed_buy_changes_nothing() -> void:
	var s := _shop(5)
	assert_eq(s.buy(&"item.poultice", 1.0).error_code, &"insufficient_crowns")
	assert_eq([s.stock_of(&"item.poultice"), _inv.count(&"item.poultice"), _wallet.balance()], [2, 0, 5])
	assert_eq(_inv.drain_events().size() + _wallet.drain_events().size(), 0)
	assert_eq(s.buy(&"item.arming_sword", 1.0).error_code, &"out_of_stock")
func test_buy_into_full_stack_fails() -> void:
	var s := _shop(1000); _inv.add(&"item.poultice", 10)
	assert_eq(s.buy(&"item.poultice", 1.0).error_code, &"stack_full")
func test_sell_pays_quarter_and_restocks() -> void:
	var s := _shop(0); _inv.add(&"item.arming_sword")   # price 40
	assert_eq(s.sell(&"item.arming_sword").value, 10)
	assert_eq([_wallet.balance(), s.stock_of(&"item.arming_sword")], [10, 1])
func test_sell_refuses_key_and_unowned() -> void:
	var s := _shop(0); _inv.add(&"item.dravin_letter")
	assert_eq(s.sell(&"item.dravin_letter").error_code, &"protected_item")
	assert_eq(s.sell(&"item.poultice").error_code, &"not_owned")
func test_snapshot_survives_json_round_trip() -> void:
	var s := _shop(100); s.buy(&"item.poultice", 1.0)
	var r := Shop.new({} as Dictionary[StringName, int], _inv, _wallet)
	r.restore(JSON.parse_string(JSON.stringify(s.to_snapshot())))
	assert_eq(r.stock_of(&"item.poultice"), 1)
```
`_shop(crowns)` sets the members `_inv` (poultice consumable, stack 10, price 8; arming sword weapon, price 40; dravin letter key) and `_wallet = Wallet.new(crowns)`, and returns `Shop.new({&"item.poultice": 2}, _inv, _wallet)`.

- [ ] **Step 2: Run to verify it fails.** `tools/test.ps1 -Test tests/unit/inventory/test_shop.gd`. Expected: exit 1, a load error naming `Shop`.
- [ ] **Step 3: Implement.** Snapshot: `{"stock": {String: int}}`.
- [ ] **Step 4: Run to verify it passes.** `tools/test.ps1 -Test tests/unit/inventory`, then `tools/test.ps1`. Expected: exit 0.
- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/inventory game/tests/unit/inventory`
`git commit -m "feat(inventory): shop buy and sell"`

---

### Task 20: Escalation track

Wave: 4

**Files:**
- Create: `game/src/domain/escalation/escalation_stage_definition.gd`, `game/src/domain/escalation/escalation_rules.gd`, `game/src/domain/escalation/escalation_track.gd`, `game/src/domain/escalation/_internal/stage_overlay_facts.gd`, `game/src/domain/escalation/events/escalation_stage_changed.gd`
- Test: `game/tests/unit/escalation/test_escalation_track.gd`; helper `game/tests/helpers/gdd_escalation_rules.gd`

**Interfaces:**
- Consumes: `Condition`, `ConditionParser` (Task 13), `EffectSpec`, `EffectParser`, `ContentFormatEffects` (Task 14), `FactProvider`, `FakeFactProvider`.
- Produces:
  - `EscalationStageDefinition`: `_init(stage: int, condition: Condition, on_enter: Array[EffectSpec] = [], card_text: String = "")`.
  - `EscalationRules`: `_init(stages: Array[EscalationStageDefinition])` (asserts the stages are exactly 0..n in order), `stages()`, `definition(stage) -> EscalationStageDefinition`, `max_stage() -> int`.
  - `EscalationTrack extends Snapshotable` with:
    - `_init(rules: EscalationRules)` (stage 0, nothing applied)
    - `recompute(facts: FactProvider) -> int`: repeat {find the highest stage whose condition holds under `StageOverlayFacts(facts, current stage)`; if it is above the current stage, raise the stage, else stop}. It never lowers the stage, records one `EscalationStageChanged(old_stage, new_stage)` when it raises, and returns `stage()`.
    - `stage() -> int`
    - `pending_stage_entries() -> Array[EscalationStageDefinition]`: the stages ≤ `stage()` not yet marked applied, ascending. Stage 0 is pending from new game (gdd §6.1: stage 0 adds a rumor). It does not mutate.
    - `mark_entry_applied(stage: int) -> void`, `drain_events()`
  - `StageOverlayFacts extends FactProvider` (internal): `_init(inner: FactProvider, stage: int)`. It delegates every method to `inner` except `escalation_stage()`, so a stage condition such as `stage() >= 1 and …` sees the stage raised earlier in the same recompute.
  - `GddEscalationRules.build() -> EscalationRules` (test helper) uses the gdd §6.1 conditions verbatim through `ConditionParser`:
    - 0: `true`
    - 1: `ms(ms.act1_complete)`
    - 2: `stage() >= 1 and count_ms(<the 7 Act II ms>) >= 3`
    - 3: `stage() >= 1 and (count_ms(<7>) >= 5 or (ms(ms.a2_wenna_line_resolved) and ded(ded.anselm_treason_proven) and has_item(item.true_fourth_verse)))`
    - 4: `ms(ms.act2_twist)`

    The 7 milestones are `ms.a2_tigg_resolved, ms.a2_cipher_taken, ms.a2_jory_dealt, ms.a2_torc_taken, ms.a2_wenna_line_resolved, ms.a2_attre_ledger, ms.a2_vel_aram_cleared`. Each `on_enter` is one parsed effect, `set_flag(flag.stage_<n>_entered)`.

- [ ] **Step 1: Write the failing tests**

```gdscript
# test_escalation_track.gd — gdd §6.1 (pure function of milestones, never decreases, entries once across save/load)
const A2 := [&"ms.a2_tigg_resolved", &"ms.a2_cipher_taken", &"ms.a2_jory_dealt", &"ms.a2_torc_taken",
	&"ms.a2_wenna_line_resolved", &"ms.a2_attre_ledger", &"ms.a2_vel_aram_cleared"]
func test_new_game_is_stage_zero_with_entry_pending() -> void:
	var t := EscalationTrack.new(GddEscalationRules.build())
	assert_eq(t.recompute(FakeFactProvider.new()), 0)
	assert_eq(t.pending_stage_entries().size(), 1)
	assert_eq(t.drain_events().size(), 0)
func test_act1_complete_gives_stage_one() -> void:
	var f := FakeFactProvider.new(); f.milestones[&"ms.act1_complete"] = true
	assert_eq(EscalationTrack.new(GddEscalationRules.build()).recompute(f), 1)
func test_cascades_through_stage_conditions() -> void:
	var f := FakeFactProvider.new(); f.milestones[&"ms.act1_complete"] = true
	for i: int in 3: f.milestones[A2[i]] = true
	var t := EscalationTrack.new(GddEscalationRules.build())
	assert_eq(t.recompute(f), 2)
	var e := t.drain_events()
	assert_eq(e.size(), 1)
	assert_eq([(e[0] as EscalationStageChanged).old_stage, (e[0] as EscalationStageChanged).new_stage], [0, 2])
	assert_eq(t.pending_stage_entries().map(func(d: EscalationStageDefinition) -> int: return d.stage), [0, 1, 2])
func test_act2_progress_without_act1_stays_zero() -> void:
	var f := FakeFactProvider.new()
	for m: StringName in A2: f.milestones[m] = true
	assert_eq(EscalationTrack.new(GddEscalationRules.build()).recompute(f), 0)
func test_act2_gate_gives_stage_three() -> void:
	var f := FakeFactProvider.new(); f.milestones[&"ms.act1_complete"] = true
	f.milestones[&"ms.a2_wenna_line_resolved"] = true; f.deductions[&"ded.anselm_treason_proven"] = true
	f.items[&"item.true_fourth_verse"] = 1
	assert_eq(EscalationTrack.new(GddEscalationRules.build()).recompute(f), 3)
func test_twist_alone_gives_stage_four() -> void:
	var f := FakeFactProvider.new(); f.milestones[&"ms.act2_twist"] = true
	assert_eq(EscalationTrack.new(GddEscalationRules.build()).recompute(f), 4)
func test_never_decreases() -> void:
	var t := EscalationTrack.new(GddEscalationRules.build())
	var f := FakeFactProvider.new(); f.milestones[&"ms.act2_twist"] = true
	t.recompute(f)
	assert_eq(t.recompute(FakeFactProvider.new()), 4)
func test_entries_not_repeated_after_restore() -> void:
	var f := FakeFactProvider.new(); f.milestones[&"ms.act1_complete"] = true
	var t := EscalationTrack.new(GddEscalationRules.build()); t.recompute(f)
	t.mark_entry_applied(0); t.mark_entry_applied(1)
	var r := EscalationTrack.new(GddEscalationRules.build())
	r.restore(JSON.parse_string(JSON.stringify(t.to_snapshot())))
	assert_eq(r.stage(), 1)
	assert_eq(r.pending_stage_entries().size(), 0)
	r.recompute(f)
	assert_eq(r.pending_stage_entries().size(), 0)
```

- [ ] **Step 2: Run to verify it fails.** `tools/test.ps1 -Test tests/unit/escalation/test_escalation_track.gd`. Expected: exit 1, a load error naming `EscalationTrack` or `GddEscalationRules`.
- [ ] **Step 3: Implement.** Snapshot: `{"stage": int, "applied": [int]}`. Cap the recompute loop at `max_stage() + 1` passes.
- [ ] **Step 4: Run to verify it passes.** `tools/test.ps1 -Test tests/unit/escalation`, then `tools/test.ps1`. Expected: exit 0.
- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/escalation game/tests/helpers game/tests/unit/escalation`
`git commit -m "feat(escalation): milestone-driven escalation track with once-only stage entries"`

---

### Task 21: Rumor pool

Wave: 4

**Files:**
- Create: `game/src/domain/rumors/rumor_definition.gd`, `game/src/domain/rumors/rumor_pool.gd`, and in `game/src/domain/rumors/events/`: `rumor_heard.gd`, `rumor_verified.gd`
- Test: `game/tests/unit/rumors/test_rumor_pool.gd`

**Interfaces:**
- Consumes: `Condition`, `ConditionParser`, `EffectSpec`, `RandomSource`, `ScriptedRandom`, `FakeFactProvider`.
- Produces:
  - `RumorDefinition`: `_init(id: StringName, text: String, truth: StringName)` (asserts truth ∈ `TRUTHS = [true, false, half, cover]` as StringNames), with optional vars `sources: Array[StringName]`, `on_hear: Array[EffectSpec]`, `available: Condition` (null means always) and `verified_by: Condition` (null means verified only by effect).
  - `RumorPool extends Snapshotable` with:
    - `_init(defs: Array[RumorDefinition], rng: RandomSource)`
    - `draw(source_id, facts) -> Result`: the candidates are the unheard rumors whose `sources` contain `source_id` and whose `available` holds, sorted by id. It picks `candidates[rng.randi_range(0, n - 1)]`, marks the rumor heard from `source_id`, records `RumorHeard(id)` and returns ok(`RumorDefinition`). With no candidates it returns err `&"no_rumor"` and does not touch the rng.
    - `mark_heard(id, source := &"") -> bool` (the `add_rumor` effect; false if already heard)
    - `mark_verified(id) -> bool` (false if already verified; records `RumorVerified(id)`)
    - `evaluate_verifications(facts) -> void`: verifies the heard, unverified rumors whose `verified_by` holds
    - `heard() -> Array[StringName]` (in hearing order), `is_heard(id)`, `is_verified(id)`, `heard_from(id) -> StringName`
    - `credibility_visible(id, facts) -> bool` = verified **or** `facts.has_perk(&"perk.read_the_room")` **or** (`heard_from(id) == &"npc.bertha"` and `facts.has_flag(&"flag.bertha_safehouse")`), per gdd §6.8 and `side/14-rumors.md` §1 and §12. Name these ids as constants.
    - `drain_events()`
  - The application applies `on_hear` and charges the drink price. The pool does neither.

- [ ] **Step 1: Write the failing tests**

```gdscript
# test_rumor_pool.gd — architecture.md §4.17, story.md §11 rumors, side/14-rumors.md (credibility)
func _defs() -> Array[RumorDefinition]:
	var a := RumorDefinition.new(&"rumor.r01_poisoned_cup", "…", &"true"); a.sources = [&"npc.bertha"]
	a.verified_by = ConditionParser.parse("has_clue(clue.chalice_pollen)").value
	var b := RumorDefinition.new(&"rumor.r02_varn_ledgers", "…", &"true"); b.sources = [&"npc.bertha"]
	b.available = ConditionParser.parse("ms(ms.a1_audience_done)").value
	var c := RumorDefinition.new(&"rumor.r03_dragon_amell", "…", &"half"); c.sources = [&"npc.bertha", &"npc.tigg_innkeeper"]
	return [a, b, c]
func test_draw_picks_from_sorted_available_unheard() -> void:
	var p := RumorPool.new(_defs(), ScriptedRandom.new([1]))
	var r := p.draw(&"npc.bertha", FakeFactProvider.new())   # candidates r01, r03 → index 1
	assert_eq((r.value as RumorDefinition).id, &"rumor.r03_dragon_amell")
	assert_eq(p.heard_from(&"rumor.r03_dragon_amell"), &"npc.bertha")
	assert_is(p.drain_events()[0], RumorHeard)
func test_draw_never_repeats_and_exhausts() -> void:
	var p := RumorPool.new(_defs(), ScriptedRandom.new([0, 0]))
	var f := FakeFactProvider.new()
	p.draw(&"npc.tigg_innkeeper", f)
	assert_eq(p.draw(&"npc.tigg_innkeeper", f).error_code, &"no_rumor")
func test_mark_heard_without_draw() -> void:
	var p := RumorPool.new(_defs(), ScriptedRandom.new())
	assert_true(p.mark_heard(&"rumor.r02_varn_ledgers"))
	assert_false(p.mark_heard(&"rumor.r02_varn_ledgers"))
	assert_eq(p.heard(), [&"rumor.r02_varn_ledgers"] as Array[StringName])
func test_verification_only_for_heard_and_once() -> void:
	var p := RumorPool.new(_defs(), ScriptedRandom.new())
	var f := FakeFactProvider.new(); f.clues[&"clue.chalice_pollen"] = true
	p.evaluate_verifications(f)
	assert_false(p.is_verified(&"rumor.r01_poisoned_cup"))
	p.mark_heard(&"rumor.r01_poisoned_cup"); p.drain_events()
	p.evaluate_verifications(f); p.evaluate_verifications(f)
	assert_true(p.is_verified(&"rumor.r01_poisoned_cup"))
	assert_eq(p.drain_events().size(), 1)
func test_credibility_rules() -> void:
	var p := RumorPool.new(_defs(), ScriptedRandom.new([0]))
	var f := FakeFactProvider.new()
	p.draw(&"npc.bertha", f)                       # r01 from Bertha
	p.mark_heard(&"rumor.r03_dragon_amell", &"npc.tigg_innkeeper")
	assert_false(p.credibility_visible(&"rumor.r01_poisoned_cup", f))
	f.flags[&"flag.bertha_safehouse"] = true
	assert_true(p.credibility_visible(&"rumor.r01_poisoned_cup", f))
	assert_false(p.credibility_visible(&"rumor.r03_dragon_amell", f))
	f.perks[&"perk.read_the_room"] = true
	assert_true(p.credibility_visible(&"rumor.r03_dragon_amell", f))
func test_snapshot_survives_json_round_trip() -> void:
	var p := RumorPool.new(_defs(), ScriptedRandom.new([0]))
	p.draw(&"npc.bertha", FakeFactProvider.new()); p.mark_verified(&"rumor.r01_poisoned_cup")
	var r := RumorPool.new(_defs(), ScriptedRandom.new())
	r.restore(JSON.parse_string(JSON.stringify(p.to_snapshot())))
	assert_eq(r.heard(), [&"rumor.r01_poisoned_cup"] as Array[StringName])
	assert_eq(r.heard_from(&"rumor.r01_poisoned_cup"), &"npc.bertha")
	assert_true(r.is_verified(&"rumor.r01_poisoned_cup"))
```

- [ ] **Step 2: Run to verify it fails.** `tools/test.ps1 -Test tests/unit/rumors`. Expected: exit 1, a load error naming `RumorDefinition`.
- [ ] **Step 3: Implement.** Snapshot: `{"heard": [String], "heard_from": {String: String}, "verified": [String]}`. The rng state belongs to `GameSession.rng` and is not stored by the pool.
- [ ] **Step 4: Run to verify it passes.** `tools/test.ps1 -Test tests/unit/rumors`, then `tools/test.ps1`. Expected: exit 0.
- [ ] **Step 5: Commit (orchestrator)**
`git add game/src/domain/rumors game/tests/unit/rumors`
`git commit -m "feat(rumors): rumor pool with draw, verification and credibility"`

---

## Coverage map

| Spec section | Tasks |
|---|---|
| architecture §3.1 domain events and outbox | 1, plus every aggregate task (7–12, 16–21) |
| architecture §3.2 `FactsChanged` | 1 |
| architecture §3.4 conditions and effects | 2, 5, 6, 13, 14 |
| architecture §4.2 `rules` | 2, 3, 4, 5, 6, 13, 14 |
| architecture §4.3 `world_state` | 7 |
| architecture §4.4 `escalation` | 12, 20 |
| architecture §4.11 `actors` | 8, 15 |
| architecture §4.12 `inventory` | 11, 17, 18, 19 |
| architecture §4.13 `progression` | 10, 16 |
| architecture §4.14 `factions` | 9 (tier order from 2) |
| architecture §4.17 `rumors` | 21 |
| architecture §9.3 helpers (`ScriptedRandom`, `FakeFactProvider`, `ItemDefBuilder`) | 1, 2, 17 |
| content-format §C condition language | 4, 5, 13 |
| content-format §E effects (and op extensibility) | 6, 14 (+ the "How to add an effect op" note) |
| gdd §6.1 escalation stages, once-only entries | 20 |
| gdd §6.2 Queen's condition and antidote freeze | 12 |
| gdd §6.6 attributes and derived stats | 8 |
| gdd §6.8 XP table, level cap, skill tree, points | 10, 16, 8 (attribute points) |
| gdd §6.9 stacks, slots, protected items, shops, sell 25% | 17, 18, 19, 11 |
| gdd §6.10 check totals (and attribute checks for hazards) | 2 (`CheckSkills`), 15 |
| gdd §6.12 reputation range, tiers, rep_mod | 9 |
| side/14-rumors.md credibility rule | 21 |
