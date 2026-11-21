# Narrative and Flow Domains Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the pure domain layer for `quests`, `investigation`, `dialogue`, `companions`, `travel`, `finale` and `endings` as headless-tested `RefCounted` classes.

**Architecture:** Each domain lives in `game/src/domain/<domain>/`. Public classes sit at the root and helpers sit in `_internal/`. Domains see the world only through P1's `FactProvider`, parse nothing themselves (they receive `Condition` and `EffectSpec` values), record `DomainEvent`s in an outbox, and hand effects to the application through `pending_effects()`. A domain references only itself, `shared` and `rules`. The architecture test enforces this.

**Tech Stack:** Godot 4.7.2, statically typed GDScript, GUT 9.7.1, `tools/test.ps1`.

**Spec:** `docs/design/architecture.md` §3.1, §3.4, §4.5–§4.7, §4.9, §4.10, §4.15, §4.16, §11; `docs/design/gdd.md` §6.3, §6.10, §6.11, §6.13, §6.14, §6.15; `docs/design/content-format.md` §C, §D, §E, §F.3, §F.6, §F.7.

## Prerequisite (orchestrator)

Before Wave 1 starts, these tasks from P1's plan (`docs/superpowers/plans/2026-11-21-core-state-domains.md`) must be merged and green:
- Task 1: `EventOutbox`, `ScriptedRandom`
- Task 2: `FactProvider`, `RepTiers`, `CheckSkills`, `FakeFactProvider`
- Task 5: the condition AST
- Task 6: `EffectSpec`
- Task 13: `ConditionParser`
- Task 14: `EffectParser`, `ContentFormatEffects`

No other P1 class is used.

## Consumes from P1

Names are exactly as in P1's "API extensions".

- `EventOutbox` (`domain/shared`): `record(e)`, `drain() -> Array[DomainEvent]`, `is_empty()`. Every aggregate here that emits holds `var _outbox := EventOutbox.new()` and implements `func drain_events() -> Array[DomainEvent]: return _outbox.drain()`.
- `Condition` (abstract): `evaluate(facts: FactProvider) -> bool`, `referenced_ids()`.
- `ConditionParser.parse(text: String) -> Result` (static; holds a `Condition`).
- `EffectSpec._init(op: StringName, args: Array, ids: Array[StringName])`, with `op`, `args` and `referenced_ids()`. Domain code builds one directly when it needs an effect (the bribe in D5). No domain class here parses effects.
- `FactProvider` (abstract, read-only, `domain/rules`). This plan calls `has_flag`, `item_count`, `has_clue`, `has_deduction`, `check_total(skill) -> int`, `rep_tier(id) -> StringName`, `in_party`, `has_perk`, `crowns`, and `finale_value(key) -> StringName`. It uses these constants:
  - `QUEST_INACTIVE`, `QUEST_ACTIVE`, `QUEST_COMPLETED`, `QUEST_FAILED`: `QuestLog.status()` returns exactly these.
  - `FINALE_SEIZED` (`&"seized"`), `FINALE_OATH` (`&"oath"`), `FINALE_ANSELM` (`&"anselm"`): the keys `EndingFactProvider` answers. Seized answers `&"true"` or `&"false"`.
  - `EndingFactProvider` also implements the P1 additions `visited`, `rumor_heard` and `queen_condition`, returning false, false and 0.
- `RepTiers.ORDER` (the tier words) and `CheckSkills.is_check_skill(name)`, which `CheckSpec` uses to validate its skill. That covers the 4 dialogue skills and the 5 attributes.
- Test helpers, reused and not redefined:
  - `FakeFactProvider`. Its fields are `flags`, `milestones`, `clues`, `deductions`, `party`, `perks` (`Dictionary[StringName, bool]`, set with `f.clues[&"clue.x"] = true`), `items`, `check_totals` (`Dictionary[StringName, int]`), `rep_tiers`, `finale` (`Dictionary[StringName, StringName]`), `stage` and `crowns_value`.
  - `ScriptedRandom(ints, floats)`. `get_state()["int_index"]` counts the ints drawn.
  - `ContentFormatEffects.signatures()` (used by `RuleFixtures.fx`).
- Not used: `ItemDefBuilder`, because no narrative domain holds items.

## API extensions (beyond the architecture.md sketches)

1. **Definitions:** this plan follows P1's convention. Required fields go in `_init` (4 parameters or fewer), and optional fields are public typed vars that parsers assign right after construction. As a convenience for tests and parsers, each optional field also has a chainable `with_<field>(value) -> <SameClass>` that sets the var and returns `self`. An optional `Condition` left `null` means "always true".
2. **quests:** `QuestLog._init(catalog: Array[QuestDefinition])`, `QuestLog.complete_objective(quest_id, objective_id) -> Result`, `QuestLog.journal() -> Array[JournalEntry]`, `QuestLog.is_abandoned(id) -> bool`. `QuestDefinition` adds `title`, `giver`, `available`, `xp`, `outcome_completed` and `outcome_failed` (content-format §F.7), plus `stage(id)`, `first_stage_id()` and `stage_after(id)`. `StageTransition(stage, condition)` with `holds(facts)`. `status()` returns only P1's four `QUEST_*` values. A quest closed by `closes_on` (gdd §6.11, "abandoned") reports `QUEST_FAILED` and `is_abandoned() == true`, records `QuestClosed` rather than `QuestFailed`, and does not queue `outcome_failed`.
3. **investigation:** `ClueBoard._init(clues: Array[ClueDefinition], deductions: Array[DeductionDefinition])` and `ClueBoard.deductions_for(theory_id)`. Clue and deduction definitions get `title`. `TheoryDefinition(id, title, suspects)`.
4. **dialogue:**
   - `DialogueRunner._init(def, facts, memory: DialogueMemory)`.
   - Public `DialogueNodeDefinition` (abstract base), `DialogueNodeFactory` (parsers cannot reach the `_internal/` node classes) and `DialogueBranchCase`.
   - `DialogueDefinition` adds `participants` and `faction` (the speaker faction used for `rep_mod`).
   - `DialogueOption` adds `bribe` and `condition_text`.
   - `CheckSpec(skill, dc, pass_node, fail_node)` with `faction` and `with_faction()`. The skill is validated by `CheckSkills.is_check_skill`.
   - `CheckResolver.total()` and `CheckResolver.rep_mod()`.
   - `DialogueView.kind` is one of `line`, `choice`, `continue` or `end` (see the protocol note below). `DialogueOptionView`.
   - `DialogueMemory.lock()` and `DialogueMemory.is_locked()`.
5. **companions:** `Party._init(defs: Array[CompanionDefinition])`, `in_party(id)`, `allies()`, `is_dead(id)`, `skill_bonus(skill)`, `has_ability(ability)`, `set_command()` and `command()`. `retreat(id)` returns `Result` (an error for an escort). `CompanionCommand` is a class holding `enum Kind`.
6. **travel:**
   - `MapEdgeDefinition` gets a passability condition and a forced hazard.
   - `TravelGraph.node()`, `has_node()` and `nodes()`. `neighbors(node)` returns the touching edges.
   - `TravelState._init(start_node)`, `begin_journey(to) -> Result`, `record_encounter(id)`, `add_pin()`, `has_pin()` and `pins()`.
   - `Route`, `EncounterEntryDefinition`, `EncounterModifiers` (including `previous_id`), `EncounterResult` and `EncounterChance`.
   - `EncounterRoller` gets `drain_events()`. At stage 4, rolls use the mountain table (gdd §6.1, stage 4).
7. **finale:**
   - `RitualMeter` adds `apply_true_modifier`, `set_bodyguards`, `bodyguard_down`, `bodyguards_remaining`, `set_fourth_verse_available`, `anselm_killed`, `choose_aftermath`, `seize_vault`, `aldric_state`, `anselm_state` and `record`.
   - `FinaleRecord.resolve(...)`; `FinaleRecord` implements `Snapshotable`.
   - `FinaleChoices._init(meter)`.
   - `FinaleSetup` (static: bodyguard count, modifiers, `configure`).
8. **endings:** `EndingFacts.is_consistent()`, `EndingRule._init(id, priority, condition: Condition)` and `EpilogueDefinition`.

**Contract notes for P3 (application):**
- `pending_effects()` returns the queue and clears it, like `drain_events()`.
- When a dialogue view has `kind == &"continue"`, the use case applies the pending effects and then calls `advance()`.
- `StartFinaleUseCase` calls `FinaleSetup.configure(meter, facts)` once.
- Before calling `seize_vault(coerced)`, the application resolves the Persuade 8 and Intimidate 7 checks for Command the Vault with `CheckResolver`.
- The dialogue parser fills `DialogueDefinition.faction` from the first participant NPC's `faction`.
- After each roll, `TravelUseCase` calls `state.record_encounter(result.entry_id)`.
- `SessionFactProvider.in_party` delegates to `Party.in_party`.
- `SessionFactProvider.finale_value` answers from `FinaleRecord`: `FINALE_SEIZED` → `&"true"` or `&"false"`.
- P1's `CheckTotals` should add `Party.skill_bonus(skill)` (Lore +2 with Maelis, gdd §6.10).

## Global Constraints

- Godot 4.7.2 with GUT 9.7.1. Run tests only through `tools/test.ps1` (`-Test <path>` for one file, no argument for everything). A pass is `Passing Tests N` with exit 0.
- Static typing everywhere. `untyped_declaration` is an error and `unsafe_*` warnings block review. Use typed arrays and dictionaries, and `StringName` for ids (`kind.snake_case`, architecture §8.2).
- Domain files extend `RefCounted` (or a `shared`/`rules` base). No `Node`, signals, `JSON`, `FileAccess`, `OS`, `Time` or `Engine`. Reference only your own domain, `shared` and `rules`. `_internal/` is private to its domain.
- One class per file. File `snake_case.gd` matches `class_name PascalCase`. No inner classes.
- Files: target 200 lines or fewer, hard cap 300. Functions: 30 lines or fewer, 4 parameters or fewer, nesting 3 levels or fewer.
- Each class header comment cites the gdd section it implements. Each test file's header comment names the section it tests.
- Expected failures return `Result.err(code)` with the codes named in each task. Programmer errors (unknown ids passed by code, wrong state) use `assert()`.
- **Events** (P1 convention): each event is a file at `src/domain/<domain>/events/<snake>.gd`, `extends DomainEvent`, with typed fields set in `_init` in the listed order. Fields never use the bare names `old` or `new`. Aggregates hold `var _outbox := EventOutbox.new()`. `drain_events()` returns `_outbox.drain()`. An event is recorded only when state actually changes.
- Snapshots hold only JSON-safe values: `String`, `int`, `bool`, and Arrays or Dictionaries of these. A `StringName` is stored as a `String`. `restore()` must accept the output of `JSON.parse_string(JSON.stringify(snapshot))`, where ints come back as floats, so read numbers with `int()`. `restore()` replaces all state, records no events and queues no effects.
- Commit each `.gd.uid` sidecar with its `.gd`. The commit steps add whole directories for this reason.
- Time enters only as `delta`. No randomness except through an injected `RandomSource`.
- Commits: the implementer does not commit. Each task's last step lists the paths and message for the orchestrator.

## Review Focus

1. **A large `delta` passed to `RitualMeter.tick`** (a frame hitch, or resuming after a pause): every verse counts once, in time order. The meter stops at exactly 4 reversed verses. A simultaneous finish goes to the True Oath. Tests: F2 `test_large_delta_stops_at_fourth_reversed_verse` and `test_tie_goes_to_true_oath`.
2. **A dialogue effect node followed by a branch, check or choice that tests the fact it just set:** the later node must see the new fact. Tests: D4 `test_pause_before_branch_when_effects_pending` and `test_pause_before_choice_when_effects_pending`.
3. **Loading a save:** snapshots pass through JSON, so ints come back as floats and StringNames as Strings. Restore must take that and record nothing. Tests: every `test_restore_from_json_round_trip` and `test_restore_records_nothing` (Q3, I2, D3, C2, T1, F1).
4. **Authored stage chains and cycles:** a next stage that is already satisfied advances in the same `evaluate`, and a cycle stops after 8 advances. Tests: Q2 `test_chained_stages_advance_in_one_evaluate` and `test_cycle_stops_after_eight_advances`.
5. **A journey where every d8 result is gated or repeats:** the roller rerolls at most 3 times, then the road is quiet. It never returns a gated or repeated entry. Tests: T4 `test_requirement_gated_entry_is_rerolled`, `test_previous_result_is_rerolled` and `test_four_failed_tries_give_quiet_road`.

---

## Wave plan

| Wave | Tasks (disjoint files, run in parallel) |
|---|---|
| 1 | S0 |
| 2 | Q1, I1, D1, D3, C1, T1, T3, F1, E1, E2 |
| 3 | Q2, I2, D2, D4, C2, T2, F2 |
| 4 | Q3, D5, T4, F3 |

All paths below are relative to `game/` unless they start with `docs/` or `tools/`.

---

### Task S0: Narrative test fixtures (thin wrappers over P1's helpers)

Wave: 1

This task adds no fakes. P1's `FakeFactProvider` and `ScriptedRandom` are used as they are. It adds two tiny conveniences that P1 does not provide.

**Files:**
- Create: `tests/helpers/narrative/rule_fixtures.gd`, `tests/helpers/narrative/event_names.gd`
- Test: `tests/unit/narrative_helpers/test_narrative_helpers.gd`

**Interfaces:**
- Consumes: P1 `ConditionParser` (static), `EffectParser.new(signatures)`, `ContentFormatEffects.signatures()`, `FakeFactProvider`.
- Produces:
  - `RuleFixtures` (static), where each function asserts that the parse succeeded:
    - `cond(text: String) -> Condition` uses `ConditionParser.parse`.
    - `fx(text: String) -> EffectSpec` uses `EffectParser.new(ContentFormatEffects.signatures())`, built once and cached in a static var.
    - `fxs(texts: Array[String]) -> Array[EffectSpec]`.
  - `EventNames.of(events: Array[DomainEvent]) -> Array` returns each event's `get_script().get_global_name()` as a `String`.

- [ ] **Step 1: Write the failing test**

```gdscript
## Narrative test fixtures (support for gdd §6.3, §6.10–§6.15 tests).
extends GutTest


func test_cond_reads_fake_facts() -> void:
	var f := FakeFactProvider.new()
	f.flags[&"flag.a"] = true
	assert_true(RuleFixtures.cond("flag(flag.a) and not has_clue(clue.x)").evaluate(f))
	f.clues[&"clue.x"] = true
	assert_false(RuleFixtures.cond("flag(flag.a) and not has_clue(clue.x)").evaluate(f))


func test_fx_and_fxs_build_effects() -> void:
	var list := RuleFixtures.fxs(["set_flag(flag.a)", "add_crowns(-21)"])
	assert_eq(list.size(), 2)
	assert_eq(list[0].op, &"set_flag")
	assert_eq(RuleFixtures.fx("add_crowns(-21)").args, [-21])


func test_event_names_lists_global_class_names() -> void:
	var events: Array[DomainEvent] = [FakePingEvent.new("a")]
	assert_eq(EventNames.of(events), ["FakePingEvent"])
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `tools/test.ps1 -Test tests/unit/narrative_helpers/test_narrative_helpers.gd`
Expected: exit 1, with a parse/load error naming `RuleFixtures`.

- [ ] **Step 3: Implement both helpers with the interfaces above**

- [ ] **Step 4: Run the test, then everything**

Run: `tools/test.ps1 -Test tests/unit/narrative_helpers/test_narrative_helpers.gd`, then `tools/test.ps1`
Expected: `Passing Tests 3` from the first command. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/tests/helpers/narrative game/tests/unit/narrative_helpers` with the message `test: add narrative rule fixtures and event-name helper`

---

### Task Q1: Quest definitions

Wave: 2

**Files:**
- Create: `src/domain/quests/quest_definition.gd`, `quest_stage_definition.gd`, `objective_definition.gd`, `stage_transition.gd`, `journal_entry.gd`
- Test: `tests/unit/quests/test_quest_definition.gd`

**Interfaces:**
- Consumes: `Condition`, `EffectSpec`, `FactProvider`; S0 `RuleFixtures`, `EventNames`; P1 `FakeFactProvider`.
- Produces:
  - `ObjectiveDefinition._init(id: StringName, text: String, condition: Condition, optional: bool = false)`, `with_xp(xp: int)`. Fields: `id`, `text`, `condition`, `optional`, `xp = 0`.
  - `StageTransition._init(stage: StringName, condition: Condition = null)`, `holds(facts: FactProvider) -> bool` (a null condition holds).
  - `QuestStageDefinition._init(id: StringName, objectives: Array[ObjectiveDefinition], journal_text: String = "")`, `with_next(next: Array[StageTransition])`, `with_on_complete(effects: Array[EffectSpec])`, `required_objectives() -> Array[ObjectiveDefinition]`, `objective(id) -> ObjectiveDefinition` (null if missing). Fields: `id`, `objectives`, `next = []`, `on_complete = []`, `journal_text`.
  - `QuestDefinition._init(id: StringName, kind: StringName, stages: Array[QuestStageDefinition])`. It asserts that `kind` is `&"main"` or `&"side"`, that `stages` is not empty and that stage ids are unique. Builders: `with_title(String)`, `with_giver(StringName)`, `with_available(Condition)`, `with_closes_on(Condition)`, `with_xp(int)`, `with_outcome_effects(completed: Array[EffectSpec], failed: Array[EffectSpec])`. Queries: `stage(id) -> QuestStageDefinition` (null if missing), `first_stage_id() -> StringName`, `stage_after(id) -> StringName` (the next stage in authored order, `&""` after the last).
  - `JournalEntry._init(quest_id: StringName, stage_id: StringName, text: String)`, a value.

- [ ] **Step 1: Write the failing test**

```gdscript
## Quest definitions (gdd §6.11, content-format §F.7).
extends GutTest


func _stage(id: StringName) -> QuestStageDefinition:
	var objs: Array[ObjectiveDefinition] = [
		ObjectiveDefinition.new(&"a", "Required", RuleFixtures.cond("flag(flag.a)")),
		ObjectiveDefinition.new(&"b", "Optional", RuleFixtures.cond("flag(flag.b)"), true).with_xp(20),
	]
	return QuestStageDefinition.new(id, objs, "Journal for %s" % id)


func _quest() -> QuestDefinition:
	var stages: Array[QuestStageDefinition] = [_stage(&"survive_the_rat"), _stage(&"audience")]
	return QuestDefinition.new(&"quest.main_a1", &"main", stages)


func test_first_stage_and_stage_after_follow_authored_order() -> void:
	var q := _quest()
	assert_eq(q.first_stage_id(), &"survive_the_rat")
	assert_eq(q.stage_after(&"survive_the_rat"), &"audience")
	assert_eq(q.stage_after(&"audience"), &"")


func test_stage_lookup() -> void:
	assert_eq(_quest().stage(&"audience").journal_text, "Journal for audience")
	assert_null(_quest().stage(&"nope"))


func test_required_objectives_skip_optional() -> void:
	var req := _stage(&"s").required_objectives()
	assert_eq(req.size(), 1)
	assert_eq(req[0].id, &"a")
	assert_eq(_stage(&"s").objective(&"b").xp, 20)


func test_defaults() -> void:
	var q := _quest()
	assert_null(q.closes_on)
	assert_null(q.available)
	assert_eq(q.xp, 0)
	assert_eq(q.outcome_completed.size(), 0)
	assert_eq(q.stage(&"audience").next.size(), 0)


func test_side_quest_builders() -> void:
	var stages: Array[QuestStageDefinition] = [_stage(&"only")]
	var q := QuestDefinition.new(&"quest.side_bertha_debt", &"side", stages) \
		.with_title("Bertha's Debt").with_xp(300) \
		.with_closes_on(RuleFixtures.cond("stage() >= 3")) \
		.with_outcome_effects(RuleFixtures.fxs(["add_rep(faction.ferrymen, 5)"]), [])
	assert_eq(q.kind, &"side")
	assert_eq(q.xp, 300)
	assert_eq(q.outcome_completed[0].op, &"add_rep")


func test_transition_holds() -> void:
	var f := FakeFactProvider.new()
	assert_true(StageTransition.new(&"x").holds(f))
	assert_false(StageTransition.new(&"x", RuleFixtures.cond("flag(flag.a)")).holds(f))
	f.flags[&"flag.a"] = true
	assert_true(StageTransition.new(&"x", RuleFixtures.cond("flag(flag.a)")).holds(f))
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `tools/test.ps1 -Test tests/unit/quests/test_quest_definition.gd`
Expected: FAIL with a parse error because `ObjectiveDefinition` is not declared.

- [ ] **Step 3: Implement the five classes with the signatures above**

- [ ] **Step 4: Run the test, then everything**

Run: `tools/test.ps1 -Test tests/unit/quests/test_quest_definition.gd`, then `tools/test.ps1`
Expected: `Passing Tests 6` from the first command. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/quests game/tests/unit/quests` with the message `feat(quests): quest, stage, objective and transition definitions`

---

### Task Q2: QuestLog progression

Wave: 3

**Files:**
- Create: `src/domain/quests/quest_log.gd`, `src/domain/quests/_internal/quest_progress.gd`, and in `src/domain/quests/events/`: `quest_started.gd`, `objective_completed.gd`, `quest_stage_advanced.gd`, `quest_completed.gd`, `quest_failed.gd`, `quest_closed.gd`
- Test: `tests/unit/quests/test_quest_log.gd`

**Interfaces:**
- Consumes: Q1's definitions; `FactProvider`, `EffectSpec`.
- Produces:
  - Events: `QuestStarted(quest_id)`, `ObjectiveCompleted(quest_id, objective_id, xp: int)`, `QuestStageAdvanced(quest_id, from_stage, to_stage)`, `QuestCompleted(quest_id, xp: int)`, `QuestFailed(quest_id)`, `QuestClosed(quest_id)`. All ids are `StringName`.
  - `QuestLog extends Snapshotable` (snapshot comes in Q3): `_init(catalog: Array[QuestDefinition])`. `start(def: QuestDefinition) -> Result` (`&"quest_already_started"` if the status is not `FactProvider.QUEST_INACTIVE`; asserts the def is in the catalog). `evaluate(facts: FactProvider) -> void`. `fail(id: StringName) -> void` (no-op unless active). `status(id) -> StringName` returns one of P1's `FactProvider.QUEST_INACTIVE`, `QUEST_ACTIVE`, `QUEST_COMPLETED` or `QUEST_FAILED`. `is_abandoned(id) -> bool` is true only for a quest closed by `closes_on`, which also reports `QUEST_FAILED`. `current_stage(id) -> StringName` (`&""` if never started). `active() -> Array[StringName]` (start order). `pending_effects() -> Array[EffectSpec]` (returns and clears). `drain_events()`.
  - `_internal/QuestProgress`: per-quest mutable state with `status`, `abandoned: bool`, `stage`, `done: Dictionary[StringName, bool]` (keys `"<stage>/<objective>"`) and `history: Array[StringName]` (stages entered, in order).

- [ ] **Step 1: Write the failing test**

```gdscript
## QuestLog progression (gdd §6.11; architecture §4.5).
extends GutTest

var facts: FakeFactProvider


func before_each() -> void:
	facts = FakeFactProvider.new()


func _obj(id: StringName, cond: String, optional := false) -> ObjectiveDefinition:
	return ObjectiveDefinition.new(id, String(id), RuleFixtures.cond(cond), optional)


func _main_quest() -> QuestDefinition:
	var s1 := QuestStageDefinition.new(&"survive_the_rat", [
		_obj(&"get_letter", "has_item(item.dravin_letter)"),
		_obj(&"survive", "ms(ms.a1_rat_survived)"),
		_obj(&"learn_poison", "has_clue(clue.courier_foam)", true).with_xp(20),
	] as Array[ObjectiveDefinition], "A courier died.").with_on_complete(RuleFixtures.fxs(["set_flag(flag.s1_done)"]))
	var s2 := QuestStageDefinition.new(&"audience",
		[_obj(&"meet", "ms(ms.a1_audience_done)")] as Array[ObjectiveDefinition], "Meet Kosk.")
	var stages: Array[QuestStageDefinition] = [s1, s2]
	return QuestDefinition.new(&"quest.main_a1", &"main", stages) \
		.with_xp(250).with_outcome_effects(RuleFixtures.fxs(["set_flag(flag.a1_done)"]), RuleFixtures.fxs(["set_flag(flag.a1_failed)"]))


func _log(defs: Array[QuestDefinition]) -> QuestLog:
	var log := QuestLog.new(defs)
	for d: QuestDefinition in defs:
		assert_true(log.start(d).is_ok())
	log.drain_events()
	return log


func _ops(effects: Array[EffectSpec]) -> Array:
	return effects.map(func(e: EffectSpec) -> StringName: return e.op)


func test_start_activates_first_stage() -> void:
	var q := _main_quest()
	var log := QuestLog.new([q] as Array[QuestDefinition])
	assert_eq(log.status(&"quest.main_a1"), FactProvider.QUEST_INACTIVE)
	assert_eq(log.current_stage(&"quest.main_a1"), &"")
	assert_true(log.start(q).is_ok())
	assert_eq(log.status(&"quest.main_a1"), FactProvider.QUEST_ACTIVE)
	assert_eq(log.current_stage(&"quest.main_a1"), &"survive_the_rat")
	assert_eq(EventNames.of(log.drain_events()), ["QuestStarted"])


func test_start_twice_errs() -> void:
	var log := _log([_main_quest()] as Array[QuestDefinition])
	assert_eq(log.start(_main_quest()).error_code, &"quest_already_started")


func test_evaluate_completes_objectives_and_advances() -> void:
	var log := _log([_main_quest()] as Array[QuestDefinition])
	facts.items[&"item.dravin_letter"] = 1
	log.evaluate(facts)
	assert_eq(log.current_stage(&"quest.main_a1"), &"survive_the_rat")
	facts.milestones[&"ms.a1_rat_survived"] = true
	log.evaluate(facts)
	assert_eq(log.current_stage(&"quest.main_a1"), &"audience")
	var ev := log.drain_events()
	assert_eq(EventNames.of(ev), ["ObjectiveCompleted", "ObjectiveCompleted", "QuestStageAdvanced"])
	var adv := ev[2] as QuestStageAdvanced
	assert_eq([adv.from_stage, adv.to_stage], [&"survive_the_rat", &"audience"])
	assert_eq(_ops(log.pending_effects()), [&"set_flag"])
	assert_eq(log.pending_effects().size(), 0)


func test_optional_objective_carries_xp_and_does_not_block() -> void:
	var log := _log([_main_quest()] as Array[QuestDefinition])
	facts.clues[&"clue.courier_foam"] = true
	log.evaluate(facts)
	var ev := log.drain_events()
	assert_eq((ev[0] as ObjectiveCompleted).objective_id, &"learn_poison")
	assert_eq((ev[0] as ObjectiveCompleted).xp, 20)
	assert_eq(log.current_stage(&"quest.main_a1"), &"survive_the_rat")


func test_last_stage_completion_completes_quest() -> void:
	var log := _log([_main_quest()] as Array[QuestDefinition])
	facts.items[&"item.dravin_letter"] = 1
	facts.milestones[&"ms.a1_rat_survived"] = true
	facts.milestones[&"ms.a1_audience_done"] = true
	log.evaluate(facts)
	assert_eq(log.status(&"quest.main_a1"), FactProvider.QUEST_COMPLETED)
	assert_eq(log.active().size(), 0)
	var ev := log.drain_events()
	assert_eq(EventNames.of(ev).back(), "QuestCompleted")
	assert_eq((ev.back() as QuestCompleted).xp, 250)
	assert_eq(_ops(log.pending_effects()), [&"set_flag", &"set_flag"])


func test_conditional_next_picks_first_true_transition() -> void:
	var fork := QuestStageDefinition.new(&"fork", [_obj(&"go", "true")] as Array[ObjectiveDefinition]) \
		.with_next([StageTransition.new(&"left", RuleFixtures.cond("flag(flag.left)")), StageTransition.new(&"right")] as Array[StageTransition])
	var left := QuestStageDefinition.new(&"left", [_obj(&"l", "false")] as Array[ObjectiveDefinition])
	var right := QuestStageDefinition.new(&"right", [_obj(&"r", "false")] as Array[ObjectiveDefinition])
	var q := QuestDefinition.new(&"quest.side_fork", &"side", [fork, left, right] as Array[QuestStageDefinition])
	var log := _log([q] as Array[QuestDefinition])
	log.evaluate(facts)
	assert_eq(log.current_stage(&"quest.side_fork"), &"right")


func test_conditional_next_waits_when_none_holds() -> void:
	var fork := QuestStageDefinition.new(&"fork", [_obj(&"go", "true")] as Array[ObjectiveDefinition]) \
		.with_next([StageTransition.new(&"left", RuleFixtures.cond("flag(flag.left)"))] as Array[StageTransition])
	var left := QuestStageDefinition.new(&"left", [_obj(&"l", "false")] as Array[ObjectiveDefinition])
	var q := QuestDefinition.new(&"quest.side_wait", &"side", [fork, left] as Array[QuestStageDefinition])
	var log := _log([q] as Array[QuestDefinition])
	log.evaluate(facts)
	assert_eq(log.current_stage(&"quest.side_wait"), &"fork")
	facts.flags[&"flag.left"] = true
	log.evaluate(facts)
	assert_eq(log.current_stage(&"quest.side_wait"), &"left")


func test_chained_stages_advance_in_one_evaluate() -> void:
	var log := _log([_main_quest()] as Array[QuestDefinition])
	facts.items[&"item.dravin_letter"] = 1
	facts.milestones[&"ms.a1_rat_survived"] = true
	facts.milestones[&"ms.a1_audience_done"] = true
	log.evaluate(facts)
	assert_eq(log.status(&"quest.main_a1"), FactProvider.QUEST_COMPLETED)


func test_cycle_stops_after_eight_advances() -> void:
	var a := QuestStageDefinition.new(&"a", [_obj(&"x", "true")] as Array[ObjectiveDefinition]) \
		.with_next([StageTransition.new(&"b")] as Array[StageTransition])
	var b := QuestStageDefinition.new(&"b", [_obj(&"y", "true")] as Array[ObjectiveDefinition]) \
		.with_next([StageTransition.new(&"a")] as Array[StageTransition])
	var q := QuestDefinition.new(&"quest.side_loop", &"side", [a, b] as Array[QuestStageDefinition])
	var log := _log([q] as Array[QuestDefinition])
	log.evaluate(facts)
	var advances := EventNames.of(log.drain_events()).filter(func(n: String) -> bool: return n == "QuestStageAdvanced")
	assert_eq(advances.size(), 8)


func test_closes_on_abandons_active_quest() -> void:
	var q := _main_quest().with_closes_on(RuleFixtures.cond("stage() >= 3"))
	var log := _log([q] as Array[QuestDefinition])
	facts.stage = 3
	facts.items[&"item.dravin_letter"] = 1
	log.evaluate(facts)
	assert_eq(log.status(&"quest.main_a1"), FactProvider.QUEST_FAILED)
	assert_true(log.is_abandoned(&"quest.main_a1"))
	assert_eq(EventNames.of(log.drain_events()), ["QuestClosed"])
	assert_eq(log.pending_effects().size(), 0, "closing does not apply outcome_failed")


func test_fail_marks_failed_and_queues_failed_outcome() -> void:
	var log := _log([_main_quest()] as Array[QuestDefinition])
	log.fail(&"quest.main_a1")
	assert_eq(log.status(&"quest.main_a1"), FactProvider.QUEST_FAILED)
	assert_eq(EventNames.of(log.drain_events()), ["QuestFailed"])
	assert_eq(_ops(log.pending_effects()), [&"set_flag"])
	log.fail(&"quest.main_a1")
	assert_eq(log.drain_events().size(), 0)


func test_active_lists_in_start_order() -> void:
	var stages: Array[QuestStageDefinition] = [QuestStageDefinition.new(&"s", [_obj(&"o", "false")] as Array[ObjectiveDefinition])]
	var side := QuestDefinition.new(&"quest.side_x", &"side", stages)
	var log := _log([side, _main_quest()] as Array[QuestDefinition])
	assert_eq(log.active(), [&"quest.side_x", &"quest.main_a1"] as Array[StringName])
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `tools/test.ps1 -Test tests/unit/quests/test_quest_log.gd`
Expected: FAIL with a parse error because `QuestLog` is not declared.

- [ ] **Step 3: Implement `QuestLog`, `QuestProgress` and the six events**

`evaluate(facts)` visits active quests in start order:

```
if def.closes_on and def.closes_on.evaluate(facts): status = QUEST_FAILED; abandoned = true; record QuestClosed; continue
for round in 8:
    for each objective of the current stage not yet done whose condition holds: mark done; record ObjectiveCompleted(xp)
    if any required objective of the current stage is not done: break
    pending += stage.on_complete
    target = stage.next.is_empty() ? def.stage_after(stage) : first transition that holds (or none → break, stay)
    if target == &"": status = completed; record QuestCompleted(def.xp); pending += def.outcome_completed; break
    record QuestStageAdvanced(stage, target); stage = target; history.append(target)
```

A stage whose required objectives are done but no transition holds re-queues its `on_complete` on every later `evaluate`. Prevent that by marking the stage as completed in `QuestProgress` (`stage_completed: bool`, reset on advance).

- [ ] **Step 4: Run the test, then everything**

Run: `tools/test.ps1 -Test tests/unit/quests/test_quest_log.gd`, then `tools/test.ps1`
Expected: `Passing Tests 12` from the first command. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/quests game/tests/unit/quests/test_quest_log.gd` with the message `feat(quests): QuestLog stage machine with objectives, forks, closing and failure`

---

### Task Q3: QuestLog objectives by effect, journal, snapshot

Wave: 4

**Files:**
- Modify: `src/domain/quests/quest_log.gd`, `src/domain/quests/_internal/quest_progress.gd`
- Test: `tests/unit/quests/test_quest_log_persistence.gd`

**Interfaces:**
- Consumes: Q2.
- Produces: `complete_objective(quest_id, objective_id) -> Result` (`&"quest_not_active"`, or `&"unknown_objective"` if the objective is not in the current stage; records `ObjectiveCompleted`; the stage advances on the next `evaluate`). `journal() -> Array[JournalEntry]` (start order, then each quest's history order, using each stage's `journal_text`). `to_snapshot()` and `restore(data)`.
- Snapshot: `{"quests": [{"id": String, "status": String, "abandoned": bool, "stage": String, "stage_completed": bool, "done": [String "stage/objective"], "history": [String]}]}` in start order. `restore` looks up each id in the catalog and asserts that it exists.

- [ ] **Step 1: Write the failing test**

Reuse Q2's `_main_quest()` by copying the builder into this file.

```gdscript
## QuestLog persistence and journal (gdd §6.11, §6.16).
extends GutTest
# _obj and _main_quest exactly as in test_quest_log.gd

func test_complete_objective_marks_done_and_next_evaluate_advances() -> void:
	var log := QuestLog.new([_main_quest()] as Array[QuestDefinition])
	log.start(_main_quest())
	assert_true(log.complete_objective(&"quest.main_a1", &"get_letter").is_ok())
	assert_true(log.complete_objective(&"quest.main_a1", &"survive").is_ok())
	log.evaluate(FakeFactProvider.new())
	assert_eq(log.current_stage(&"quest.main_a1"), &"audience")


func test_complete_objective_errors() -> void:
	var log := QuestLog.new([_main_quest()] as Array[QuestDefinition])
	assert_eq(log.complete_objective(&"quest.main_a1", &"get_letter").error_code, &"quest_not_active")
	log.start(_main_quest())
	assert_eq(log.complete_objective(&"quest.main_a1", &"meet").error_code, &"unknown_objective")


func test_journal_lists_entered_stages_in_order() -> void:
	var log := QuestLog.new([_main_quest()] as Array[QuestDefinition])
	log.start(_main_quest())
	log.complete_objective(&"quest.main_a1", &"get_letter")
	log.complete_objective(&"quest.main_a1", &"survive")
	log.evaluate(FakeFactProvider.new())
	var j := log.journal()
	assert_eq(j.size(), 2)
	assert_eq([j[0].stage_id, j[1].stage_id], [&"survive_the_rat", &"audience"])
	assert_eq(j[1].text, "Meet Kosk.")


func test_restore_from_json_round_trip() -> void:
	var log := QuestLog.new([_main_quest()] as Array[QuestDefinition])
	log.start(_main_quest())
	log.complete_objective(&"quest.main_a1", &"get_letter")
	var data: Dictionary = JSON.parse_string(JSON.stringify(log.to_snapshot()))
	var copy := QuestLog.new([_main_quest()] as Array[QuestDefinition])
	copy.restore(data)
	assert_eq(copy.status(&"quest.main_a1"), FactProvider.QUEST_ACTIVE)
	assert_eq(copy.current_stage(&"quest.main_a1"), &"survive_the_rat")
	var f := FakeFactProvider.new()
	f.items[&"item.dravin_letter"] = 1
	copy.evaluate(f)
	assert_eq(copy.drain_events().size(), 0, "get_letter was already done")


func test_restore_records_nothing() -> void:
	var log := QuestLog.new([_main_quest()] as Array[QuestDefinition])
	log.start(_main_quest())
	var copy := QuestLog.new([_main_quest()] as Array[QuestDefinition])
	copy.restore(log.to_snapshot())
	assert_eq(copy.drain_events().size(), 0)
	assert_eq(copy.pending_effects().size(), 0)
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `tools/test.ps1 -Test tests/unit/quests/test_quest_log_persistence.gd`
Expected: FAIL with "Invalid call. Nonexistent function 'complete_objective'".

- [ ] **Step 3: Implement `complete_objective`, `journal`, `to_snapshot` and `restore` in `quest_log.gd`**

If `quest_log.gd` passes 200 lines, move the snapshot encoding into `QuestProgress.to_dict()` and `QuestProgress.from_dict()`.

- [ ] **Step 4: Run the quests suite, then everything**

Run: `tools/test.ps1 -Test tests/unit/quests`, then `tools/test.ps1`
Expected: all quests tests pass (23). The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/quests game/tests/unit/quests/test_quest_log_persistence.gd` with the message `feat(quests): objective completion by effect, journal and snapshot`

---

### Task I1: Investigation definitions and clue board

Wave: 2

**Files:**
- Create: `src/domain/investigation/clue_definition.gd`, `deduction_definition.gd`, `theory_definition.gd`, `clue_board.gd`, `events/clue_discovered.gd`
- Test: `tests/unit/investigation/test_clue_board.gd`

**Interfaces:**
- Consumes: `Condition`; S0 `RuleFixtures`, `EventNames`; P1 `FakeFactProvider`.
- Produces:
  - `ClueDefinition._init(id, theory_id, title: String, text: String)`, `with_supports(Array[StringName])`, `with_refutes(Array[StringName])`, `with_xp(int)`. Fields: `id`, `theory_id`, `title`, `text`, `supports`, `refutes`, `xp = 0` (0 = the act default chosen by `XpPolicy`).
  - `DeductionDefinition._init(id, theory_id, condition: Condition, text: String)`, `with_title(String)`, `with_xp(int)`.
  - `TheoryDefinition._init(id, title: String, suspects: Array[StringName])`.
  - `ClueDiscovered(clue_id: StringName)`.
  - `ClueBoard extends Snapshotable` (snapshot comes in I2): `_init(clues: Array[ClueDefinition], deductions: Array[DeductionDefinition])`. `add_clue(id) -> bool` (asserts the id is known; returns false if the clue is already found; records `ClueDiscovered` when new). `has_clue(id)`. `clues_for(theory_id) -> Array[StringName]` (found clues, discovery order). `suspect_standing(theory_id, suspect_id) -> int` (found clues of that theory that support the suspect minus those that refute). `drain_events()`.

- [ ] **Step 1: Write the failing test**

```gdscript
## Investigation board: clues and suspect standing (gdd §6.11).
extends GutTest


func _board() -> ClueBoard:
	var clues: Array[ClueDefinition] = [
		ClueDefinition.new(&"clue.chalice_pollen", &"theory.poisoner", "Pollen", "Grey lily pollen.").with_supports([&"anselm"] as Array[StringName]),
		ClueDefinition.new(&"clue.taster_gold", &"theory.poisoner", "Gold", "Taster's gold.").with_supports([&"pell"] as Array[StringName]),
		ClueDefinition.new(&"clue.varn_ledgers", &"theory.poisoner", "Ledgers", "Toll theft.").with_refutes([&"varn"] as Array[StringName]),
		ClueDefinition.new(&"clue.pale_feather", &"theory.choir", "Feather", "A pale feather.").with_supports([&"anselm"] as Array[StringName]),
	]
	return ClueBoard.new(clues, [] as Array[DeductionDefinition])


func test_add_clue_once() -> void:
	var b := _board()
	assert_true(b.add_clue(&"clue.chalice_pollen"))
	assert_false(b.add_clue(&"clue.chalice_pollen"))
	assert_true(b.has_clue(&"clue.chalice_pollen"))
	assert_false(b.has_clue(&"clue.taster_gold"))
	var ev := b.drain_events()
	assert_eq(ev.size(), 1)
	assert_eq((ev[0] as ClueDiscovered).clue_id, &"clue.chalice_pollen")


func test_clues_for_theory_in_discovery_order() -> void:
	var b := _board()
	b.add_clue(&"clue.varn_ledgers")
	b.add_clue(&"clue.pale_feather")
	b.add_clue(&"clue.chalice_pollen")
	assert_eq(b.clues_for(&"theory.poisoner"), [&"clue.varn_ledgers", &"clue.chalice_pollen"] as Array[StringName])
	assert_eq(b.clues_for(&"theory.choir"), [&"clue.pale_feather"] as Array[StringName])


func test_suspect_standing_is_supports_minus_refutes_within_theory() -> void:
	var b := _board()
	for id: StringName in [&"clue.chalice_pollen", &"clue.varn_ledgers", &"clue.pale_feather"]:
		b.add_clue(id)
	assert_eq(b.suspect_standing(&"theory.poisoner", &"anselm"), 1)
	assert_eq(b.suspect_standing(&"theory.poisoner", &"varn"), -1)
	assert_eq(b.suspect_standing(&"theory.poisoner", &"raimund"), 0)
	assert_eq(b.suspect_standing(&"theory.poisoner", &"pell"), 0, "taster_gold not found yet")


func test_theory_definition_holds_suspects() -> void:
	var t := TheoryDefinition.new(&"theory.poisoner", "Who is poisoning the Queen?", [&"varn", &"pell", &"anselm", &"raimund"] as Array[StringName])
	assert_eq(t.suspects.size(), 4)
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `tools/test.ps1 -Test tests/unit/investigation/test_clue_board.gd`
Expected: FAIL with a parse error because `ClueDefinition` is not declared.

- [ ] **Step 3: Implement the five classes with the signatures above**

- [ ] **Step 4: Run the test, then everything**

Run: `tools/test.ps1 -Test tests/unit/investigation/test_clue_board.gd`, then `tools/test.ps1`
Expected: `Passing Tests 4` from the first command. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/investigation game/tests/unit/investigation` with the message `feat(investigation): clue, deduction and theory definitions; ClueBoard clues and standing`

---

### Task I2: Deductions and board snapshot

Wave: 3

**Files:**
- Modify: `src/domain/investigation/clue_board.gd`
- Create: `src/domain/investigation/events/deduction_unlocked.gd`
- Test: `tests/unit/investigation/test_clue_board_deductions.gd`

**Interfaces:**
- Consumes: I1; `FactProvider`.
- Produces: `DeductionUnlocked(deduction_id)`. `evaluate_deductions(facts) -> void` makes one pass over the deductions in constructor order and unlocks each locked deduction whose condition holds. `DeductionPolicy` reruns on `FactsChanged`, so a chain settles through the application's fixed point. Also `has_deduction(id) -> bool`, `deductions_for(theory_id) -> Array[StringName]` (unlock order) and `to_snapshot()`/`restore()` with the format `{"clues": [String], "deductions": [String]}`, both in discovery order.

- [ ] **Step 1: Write the failing test**

```gdscript
## Deductions (gdd §6.11: a deduction unlocks automatically when its clue condition holds).
extends GutTest


func _board() -> ClueBoard:
	var clues: Array[ClueDefinition] = [ClueDefinition.new(&"clue.varn_ledgers", &"theory.poisoner", "Ledgers", "t")]
	var deds: Array[DeductionDefinition] = [
		DeductionDefinition.new(&"ded.varn_thief_not_poisoner", &"theory.poisoner", RuleFixtures.cond("has_clue(clue.varn_ledgers)"), "Varn is a thief."),
		DeductionDefinition.new(&"ded.choir_exists", &"theory.choir", RuleFixtures.cond("has_clue(clue.pale_feather) and has_clue(clue.route_map_oak)"), "The Choir exists."),
	]
	return ClueBoard.new(clues, deds)


func test_deduction_unlocks_once_when_condition_holds() -> void:
	var b := _board()
	var f := FakeFactProvider.new()
	b.evaluate_deductions(f)
	assert_false(b.has_deduction(&"ded.varn_thief_not_poisoner"))
	f.clues[&"clue.varn_ledgers"] = true
	b.evaluate_deductions(f)
	b.evaluate_deductions(f)
	assert_true(b.has_deduction(&"ded.varn_thief_not_poisoner"))
	var ev := b.drain_events()
	assert_eq(ev.size(), 1)
	assert_eq((ev[0] as DeductionUnlocked).deduction_id, &"ded.varn_thief_not_poisoner")
	assert_eq(b.deductions_for(&"theory.poisoner"), [&"ded.varn_thief_not_poisoner"] as Array[StringName])
	assert_eq(b.deductions_for(&"theory.choir").size(), 0)


func test_restore_from_json_round_trip() -> void:
	var b := _board()
	b.add_clue(&"clue.varn_ledgers")
	var f := FakeFactProvider.new()
	f.clues[&"clue.varn_ledgers"] = true
	b.evaluate_deductions(f)
	var copy := _board()
	copy.restore(JSON.parse_string(JSON.stringify(b.to_snapshot())))
	assert_true(copy.has_clue(&"clue.varn_ledgers"))
	assert_true(copy.has_deduction(&"ded.varn_thief_not_poisoner"))
	assert_eq(copy.clues_for(&"theory.poisoner"), [&"clue.varn_ledgers"] as Array[StringName])


func test_restore_records_nothing() -> void:
	var b := _board()
	b.add_clue(&"clue.varn_ledgers")
	var copy := _board()
	copy.restore(b.to_snapshot())
	assert_eq(copy.drain_events().size(), 0)
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `tools/test.ps1 -Test tests/unit/investigation/test_clue_board_deductions.gd`
Expected: FAIL with "Nonexistent function 'evaluate_deductions'".

- [ ] **Step 3: Implement the methods and `DeductionUnlocked`**

- [ ] **Step 4: Run the investigation suite, then everything**

Run: `tools/test.ps1 -Test tests/unit/investigation`, then `tools/test.ps1`
Expected: 7 investigation tests pass. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/investigation game/tests/unit/investigation/test_clue_board_deductions.gd` with the message `feat(investigation): deductions and board snapshot`

---

### Task D1: Dialogue definitions

Wave: 2

**Files:**
- Create in `src/domain/dialogue/`: `check_spec.gd`, `dialogue_option.gd`, `dialogue_branch_case.gd`, `dialogue_node_definition.gd`, `dialogue_node_factory.gd`, `dialogue_definition.gd`
- Create in `src/domain/dialogue/_internal/`: `line_node.gd`, `choice_node.gd`, `check_node.gd`, `branch_node.gd`, `effect_node.gd`, `end_node.gd`
- Test: `tests/unit/dialogue/test_dialogue_definition.gd`

**Interfaces:**
- Consumes: `Condition`, `EffectSpec`; S0 `RuleFixtures`, `EventNames`; P1 `FakeFactProvider`.
- Produces:
  - `CheckSpec._init(skill: StringName, dc: int, pass_node: StringName = &"", fail_node: StringName = &"")`. It asserts `CheckSkills.is_check_skill(skill)` (the 4 dialogue skills or the 5 attributes, as P1 defines them). Field `faction: StringName = &""`. `with_faction(faction) -> CheckSpec` returns a **new** spec and leaves the original unchanged.
  - `DialogueOption._init(id: StringName, text: String, next: StringName = &"")`. Builders: `with_condition(condition: Condition, source_text: String)` (sets `condition` and `condition_text`), `with_tag(StringName)`, `with_check(CheckSpec)`, `with_show_locked(bool)`, `with_once(bool)`, `with_effects(Array[EffectSpec])`, `with_bribe(int)`. Defaults: `condition = null`, `condition_text = ""`, `tag = &""`, `check = null`, `show_locked = false`, `once = false`, `effects = []`, `bribe = 0`.
  - `DialogueBranchCase._init(condition: Condition, next: StringName)`.
  - `@abstract DialogueNodeDefinition`: fields `id: StringName`, `effects: Array[EffectSpec] = []` and `direction: String = ""`. `@abstract func kind() -> StringName`. `with_effects(Array[EffectSpec]) -> DialogueNodeDefinition` and `with_direction(String) -> DialogueNodeDefinition`.
  - Internal nodes (each `extends DialogueNodeDefinition`):
    - `LineNode(id, speaker: StringName, text: String, next: StringName)`, kind `&"line"`
    - `ChoiceNode(id, options: Array[DialogueOption])`, kind `&"choice"`
    - `CheckNode(id, check: CheckSpec)`, kind `&"check"`
    - `BranchNode(id, cases: Array[DialogueBranchCase], else_node: StringName)`, kind `&"branch"`
    - `EffectNode(id, next: StringName)`, kind `&"effect"`; its effects are the base `effects`
    - `EndNode(id)`, kind `&"end"`
  - `DialogueNodeFactory` (static): `line(id, speaker, text, next)`, `choice(id, options)`, `check(id, spec)`, `branch(id, cases, else_node)`, `effect(id, effects: Array[EffectSpec], next)`, `end(id)`. Each returns a `DialogueNodeDefinition`.
  - `DialogueDefinition._init(id: StringName, start_node: StringName, nodes: Dictionary[StringName, DialogueNodeDefinition])`. It asserts that `start_node` is in `nodes`. Builders: `with_participants(Array[StringName])`, `with_faction(StringName)`. `node(id) -> DialogueNodeDefinition` asserts that the node exists.

- [ ] **Step 1: Write the failing test**

```gdscript
## Dialogue definitions (gdd §6.10; content-format §D, §F.3).
extends GutTest


func _bertha() -> DialogueDefinition:
	var foam := DialogueOption.new(&"foam", "That froth isn't drink. [Investigate]").with_tag(&"investigate") \
		.with_check(CheckSpec.new(&"investigate", 4, &"foam_pass", &"foam_fail")).with_once(true)
	var options: Array[DialogueOption] = [DialogueOption.new(&"who", "Who was he?", &"who_answer"), foam, DialogueOption.new(&"leave", "Keep your door barred.", &"bye")]
	var cases: Array[DialogueBranchCase] = [DialogueBranchCase.new(RuleFixtures.cond("flag(flag.letter_taken)"), &"who_letter")]
	var nodes: Dictionary[StringName, DialogueNodeDefinition] = {
		&"greet": DialogueNodeFactory.line(&"greet", &"npc.bertha", "He came in coughing froth.", &"hub").with_direction("Wiping her hands."),
		&"hub": DialogueNodeFactory.choice(&"hub", options),
		&"foam_pass": DialogueNodeFactory.effect(&"foam_pass", RuleFixtures.fxs(["add_clue(clue.courier_foam)"]), &"hub"),
		&"who_answer": DialogueNodeFactory.branch(&"who_answer", cases, &"who_plain"),
		&"bye": DialogueNodeFactory.end(&"bye"),
	}
	return DialogueDefinition.new(&"dlg.bertha_intro", &"greet", nodes).with_participants([&"npc.bertha"] as Array[StringName])


func test_factory_builds_each_kind() -> void:
	var d := _bertha()
	assert_eq(d.node(&"greet").kind(), &"line")
	assert_eq(d.node(&"hub").kind(), &"choice")
	assert_eq(d.node(&"foam_pass").kind(), &"effect")
	assert_eq(d.node(&"who_answer").kind(), &"branch")
	assert_eq(d.node(&"bye").kind(), &"end")
	assert_eq(DialogueNodeFactory.check(&"c", CheckSpec.new(&"lore", 6, &"a", &"b")).kind(), &"check")


func test_line_fields_and_direction() -> void:
	var line := _bertha().node(&"greet") as LineNode
	assert_eq(line.speaker, &"npc.bertha")
	assert_eq(line.next, &"hub")
	assert_eq(line.direction, "Wiping her hands.")


func test_option_defaults() -> void:
	var o := DialogueOption.new(&"who", "Who was he?", &"who_answer")
	assert_null(o.condition)
	assert_null(o.check)
	assert_false(o.show_locked)
	assert_false(o.once)
	assert_eq(o.tag, &"")
	assert_eq(o.bribe, 0)
	assert_eq(o.effects.size(), 0)


func test_check_option_carries_pass_and_fail() -> void:
	var foam := (_bertha().node(&"hub") as ChoiceNode).options[1]
	assert_eq(foam.check.dc, 4)
	assert_eq([foam.check.pass_node, foam.check.fail_node], [&"foam_pass", &"foam_fail"])
	assert_true(foam.once)


func test_with_faction_copies() -> void:
	var a := CheckSpec.new(&"persuade", 6)
	var b := a.with_faction(&"faction.crown")
	assert_eq(a.faction, &"")
	assert_eq(b.faction, &"faction.crown")
	assert_eq(b.dc, 6)


func test_definition_defaults() -> void:
	var d := _bertha()
	assert_eq(d.start_node, &"greet")
	assert_eq(d.faction, &"")
	assert_eq(d.participants, [&"npc.bertha"] as Array[StringName])
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `tools/test.ps1 -Test tests/unit/dialogue/test_dialogue_definition.gd`
Expected: FAIL with a parse error because `DialogueOption` is not declared.

- [ ] **Step 3: Implement the twelve classes with the signatures above**

- [ ] **Step 4: Run the test, then everything**

Run: `tools/test.ps1 -Test tests/unit/dialogue/test_dialogue_definition.gd`, then `tools/test.ps1`
Expected: `Passing Tests 6` from the first command. The full suite passes with exit 0. The architecture test confirms that only dialogue files reference `_internal/` nodes.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/dialogue game/tests/unit/dialogue` with the message `feat(dialogue): dialogue, node, option and check definitions with a public node factory`

---

### Task D3: DialogueMemory

Wave: 2

**Files:**
- Create: `src/domain/dialogue/dialogue_memory.gd`
- Test: `tests/unit/dialogue/test_dialogue_memory.gd`

**Interfaces:**
- Produces: `DialogueMemory extends Snapshotable` with `lock(dialogue_id: StringName, option_id: StringName) -> void` and `is_locked(dialogue_id, option_id) -> bool`. The snapshot is `{"locked": [String "dlg.x/option"]}`, sorted.

- [ ] **Step 1: Write the failing test**

```gdscript
## Options locked with `once` across conversations (gdd §6.10; content-format §D).
extends GutTest


func test_lock_is_per_dialogue_and_option() -> void:
	var m := DialogueMemory.new()
	m.lock(&"dlg.bertha_intro", &"foam")
	assert_true(m.is_locked(&"dlg.bertha_intro", &"foam"))
	assert_false(m.is_locked(&"dlg.bertha_intro", &"who"))
	assert_false(m.is_locked(&"dlg.other", &"foam"))


func test_restore_from_json_round_trip() -> void:
	var m := DialogueMemory.new()
	m.lock(&"dlg.b", &"z")
	m.lock(&"dlg.a", &"y")
	assert_eq(m.to_snapshot(), {"locked": ["dlg.a/y", "dlg.b/z"]})
	var copy := DialogueMemory.new()
	copy.restore(JSON.parse_string(JSON.stringify(m.to_snapshot())))
	assert_true(copy.is_locked(&"dlg.a", &"y"))
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `tools/test.ps1 -Test tests/unit/dialogue/test_dialogue_memory.gd`
Expected: FAIL with a parse error because `DialogueMemory` is not declared.

- [ ] **Step 3: Implement `DialogueMemory`**

- [ ] **Step 4: Run the test, then everything**

Expected: `Passing Tests 2`. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/dialogue/dialogue_memory.gd game/tests/unit/dialogue/test_dialogue_memory.gd` with the message `feat(dialogue): DialogueMemory for permanent once-locks`

---

### Task D2: CheckResolver

Wave: 3

**Files:**
- Create: `src/domain/dialogue/check_resolver.gd`
- Test: `tests/unit/dialogue/test_check_resolver.gd`

**Interfaces:**
- Consumes: D1 `CheckSpec`; `FactProvider.check_total` and `FactProvider.rep_tier`.
- Produces: static `rep_mod(tier: StringName) -> int` (hostile −2, wary −1, neutral 0, friendly +1, allied +2). Static `total(check: CheckSpec, facts: FactProvider) -> int` = `facts.check_total(check.skill)` plus `rep_mod(facts.rep_tier(check.faction))`, where `rep_tier` is not called when the faction is `&""`. Static `resolve(check, facts) -> bool` is `total >= check.dc`.

- [ ] **Step 1: Write the failing test**

```gdscript
## Deterministic checks: total = skill + rep_mod >= DC (gdd §6.10).
extends GutTest


func test_rep_mod_by_tier() -> void:
	assert_eq(CheckResolver.rep_mod(&"hostile"), -2)
	assert_eq(CheckResolver.rep_mod(&"wary"), -1)
	assert_eq(CheckResolver.rep_mod(&"neutral"), 0)
	assert_eq(CheckResolver.rep_mod(&"friendly"), 1)
	assert_eq(CheckResolver.rep_mod(&"allied"), 2)


func test_pass_at_exactly_dc() -> void:
	var f := FakeFactProvider.new()
	f.check_totals[&"investigate"] = 4
	assert_true(CheckResolver.resolve(CheckSpec.new(&"investigate", 4), f))
	f.check_totals[&"investigate"] = 3
	assert_false(CheckResolver.resolve(CheckSpec.new(&"investigate", 4), f))


func test_faction_tier_adjusts_total() -> void:
	var f := FakeFactProvider.new()
	f.check_totals[&"persuade"] = 5
	f.rep_tiers[&"faction.crown"] = &"friendly"
	f.rep_tiers[&"faction.strept"] = &"hostile"
	var crown := CheckSpec.new(&"persuade", 6).with_faction(&"faction.crown")
	var strept := CheckSpec.new(&"persuade", 4).with_faction(&"faction.strept")
	assert_eq(CheckResolver.total(crown, f), 6)
	assert_true(CheckResolver.resolve(crown, f))
	assert_eq(CheckResolver.total(strept, f), 3)
	assert_false(CheckResolver.resolve(strept, f))
	assert_eq(CheckResolver.total(CheckSpec.new(&"persuade", 6), f), 5)
```

- [ ] **Step 2: Run the test to verify it fails**

Expected: FAIL with a parse error because `CheckResolver` is not declared.

- [ ] **Step 3: Implement `CheckResolver`**

- [ ] **Step 4: Run the test, then everything**

Expected: `Passing Tests 3`. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/dialogue/check_resolver.gd game/tests/unit/dialogue/test_check_resolver.gd` with the message `feat(dialogue): CheckResolver with reputation modifier`

---

### Task D4: DialogueRunner traversal

Wave: 3

**Files:**
- Create in `src/domain/dialogue/`: `dialogue_runner.gd`, `dialogue_view.gd`, `dialogue_option_view.gd`, `events/dialogue_started.gd`, `events/dialogue_node_entered.gd`, `events/dialogue_ended.gd`
- Test: `tests/unit/dialogue/test_dialogue_runner.gd`

**Interfaces:**
- Consumes: D1 definitions, D3 `DialogueMemory`; `FactProvider`, `EffectSpec`.
- Produces:
  - Events: `DialogueStarted(dialogue_id)`, `DialogueNodeEntered(dialogue_id, node_id)`, `DialogueEnded(dialogue_id, end_node)`.
  - `DialogueOptionView._init(id: StringName, text: String, enabled: bool, requirement_text: String)` with a `tag` field set by `with_tag`.
  - `DialogueView` is immutable. Fields: `kind: StringName` (`&"line"`, `&"choice"`, `&"continue"` or `&"end"`), `node_id`, `speaker: StringName`, `text: String`, `direction: String`, `options: Array[DialogueOptionView]`. Static constructors: `line(node_id, speaker, text, direction)`, `choice(node_id, options)`, `pause(node_id)` (kind `&"continue"`), `ended(node_id)`.
  - `DialogueRunner._init(def: DialogueDefinition, facts: FactProvider, memory: DialogueMemory)`. `start() -> DialogueView`. `advance() -> DialogueView` (valid at a line or a `continue`; asserts otherwise). `choose(option_id) -> DialogueView` (valid only for a visible, enabled option at a choice; asserts otherwise). `is_finished() -> bool`. `pending_effects() -> Array[EffectSpec]` (returns and clears). `drain_events()`.
  - In D4, option visibility covers only conditions: a false condition hides the option, unless it has `show_locked`, in which case it shows with `enabled = false` and `requirement_text = condition_text`. D5 adds bribes, checks and locks.

- [ ] **Step 1: Write the failing test**

```gdscript
## DialogueRunner traversal (gdd §6.10; content-format §D: node effects apply on entry,
## option effects apply when chosen, before next).
extends GutTest

var facts: FakeFactProvider


func before_each() -> void:
	facts = FakeFactProvider.new()


func _run(nodes: Dictionary[StringName, DialogueNodeDefinition], start: StringName) -> DialogueRunner:
	return DialogueRunner.new(DialogueDefinition.new(&"dlg.t", start, nodes), facts, DialogueMemory.new())


func _ops(r: DialogueRunner) -> Array:
	return r.pending_effects().map(func(e: EffectSpec) -> StringName: return e.op)


func test_start_shows_first_line() -> void:
	var r := _run({&"a": DialogueNodeFactory.line(&"a", &"npc.bertha", "Hello.", &"z"), &"z": DialogueNodeFactory.end(&"z")}, &"a")
	var v := r.start()
	assert_eq([v.kind, v.speaker, v.text], [&"line", &"npc.bertha", "Hello."])
	assert_eq(EventNames.of(r.drain_events()), ["DialogueStarted", "DialogueNodeEntered"])


func test_advance_from_line_to_choice_lists_visible_options() -> void:
	var opts: Array[DialogueOption] = [
		DialogueOption.new(&"ask", "Ask.", &"z"),
		DialogueOption.new(&"secret", "Secret.", &"z").with_condition(RuleFixtures.cond("flag(flag.s)"), "flag(flag.s)"),
		DialogueOption.new(&"hint", "Hint.", &"z").with_condition(RuleFixtures.cond("has_clue(clue.x)"), "has_clue(clue.x)").with_show_locked(true),
	]
	var r := _run({&"a": DialogueNodeFactory.line(&"a", &"player", "Hm.", &"c"), &"c": DialogueNodeFactory.choice(&"c", opts), &"z": DialogueNodeFactory.end(&"z")}, &"a")
	r.start()
	var v := r.advance()
	assert_eq(v.kind, &"choice")
	assert_eq(v.options.size(), 2)
	assert_eq([v.options[0].id, v.options[0].enabled], [&"ask", true])
	assert_eq([v.options[1].id, v.options[1].enabled, v.options[1].requirement_text], [&"hint", false, "has_clue(clue.x)"])


func test_choose_queues_option_effects_before_entered_node_effects() -> void:
	var opts: Array[DialogueOption] = [DialogueOption.new(&"go", "Go.", &"l").with_effects(RuleFixtures.fxs(["set_flag(flag.a)"]))]
	var nodes: Dictionary[StringName, DialogueNodeDefinition] = {
		&"c": DialogueNodeFactory.choice(&"c", opts),
		&"l": DialogueNodeFactory.line(&"l", &"npc.bertha", "Done.", &"z").with_effects(RuleFixtures.fxs(["add_clue(clue.x)"])),
		&"z": DialogueNodeFactory.end(&"z"),
	}
	var r := _run(nodes, &"c")
	r.start()
	var v := r.choose(&"go")
	assert_eq(v.kind, &"line")
	assert_eq(_ops(r), [&"set_flag", &"add_clue"])


func test_effect_node_auto_advances_to_line() -> void:
	var r := _run({&"e": DialogueNodeFactory.effect(&"e", RuleFixtures.fxs(["set_flag(flag.a)"]), &"l"), &"l": DialogueNodeFactory.line(&"l", &"player", "x", &"z"), &"z": DialogueNodeFactory.end(&"z")}, &"e")
	assert_eq(r.start().kind, &"line")
	assert_eq(_ops(r), [&"set_flag"])


func test_branch_picks_first_true_case_else_fallback() -> void:
	var cases: Array[DialogueBranchCase] = [DialogueBranchCase.new(RuleFixtures.cond("flag(flag.a)"), &"yes")]
	var nodes: Dictionary[StringName, DialogueNodeDefinition] = {
		&"b": DialogueNodeFactory.branch(&"b", cases, &"no"),
		&"yes": DialogueNodeFactory.line(&"yes", &"player", "yes", &"z"),
		&"no": DialogueNodeFactory.line(&"no", &"player", "no", &"z"),
		&"z": DialogueNodeFactory.end(&"z"),
	}
	assert_eq(_run(nodes, &"b").start().text, "no")
	facts.flags[&"flag.a"] = true
	assert_eq(_run(nodes, &"b").start().text, "yes")


func test_pause_before_branch_when_effects_pending() -> void:
	var cases: Array[DialogueBranchCase] = [DialogueBranchCase.new(RuleFixtures.cond("flag(flag.a)"), &"yes")]
	var nodes: Dictionary[StringName, DialogueNodeDefinition] = {
		&"e": DialogueNodeFactory.effect(&"e", RuleFixtures.fxs(["set_flag(flag.a)"]), &"b"),
		&"b": DialogueNodeFactory.branch(&"b", cases, &"no"),
		&"yes": DialogueNodeFactory.line(&"yes", &"player", "yes", &"z"),
		&"no": DialogueNodeFactory.line(&"no", &"player", "no", &"z"),
		&"z": DialogueNodeFactory.end(&"z"),
	}
	var r := _run(nodes, &"e")
	assert_eq(r.start().kind, &"continue")
	assert_eq(_ops(r), [&"set_flag"])
	facts.flags[&"flag.a"] = true   # the use case applied the effect
	assert_eq(r.advance().text, "yes")


func test_pause_before_choice_when_effects_pending() -> void:
	var opts: Array[DialogueOption] = [
		DialogueOption.new(&"new", "New.", &"z").with_condition(RuleFixtures.cond("flag(flag.a)"), "flag(flag.a)"),
		DialogueOption.new(&"bye", "Bye.", &"z"),
	]
	var r := _run({&"e": DialogueNodeFactory.effect(&"e", RuleFixtures.fxs(["set_flag(flag.a)"]), &"c"), &"c": DialogueNodeFactory.choice(&"c", opts), &"z": DialogueNodeFactory.end(&"z")}, &"e")
	assert_eq(r.start().kind, &"continue")
	r.pending_effects()
	facts.flags[&"flag.a"] = true
	assert_eq(r.advance().options.size(), 2)


func test_end_node_finishes() -> void:
	var r := _run({&"l": DialogueNodeFactory.line(&"l", &"player", "x", &"bye"), &"bye": DialogueNodeFactory.end(&"bye")}, &"l")
	r.start()
	r.drain_events()
	var v := r.advance()
	assert_eq(v.kind, &"end")
	assert_true(r.is_finished())
	var ev := r.drain_events()
	assert_eq(EventNames.of(ev), ["DialogueNodeEntered", "DialogueEnded"])
	assert_eq((ev[1] as DialogueEnded).end_node, &"bye")
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `tools/test.ps1 -Test tests/unit/dialogue/test_dialogue_runner.gd`
Expected: FAIL with a parse error because `DialogueRunner` is not declared.

- [ ] **Step 3: Implement the runner, views and events**

Entering nodes works like this (`_enter(node_id)`):

```
for step in 64 (assert if exceeded: an authored effect/branch loop):
    node = def.node(node_id)
    if node.kind() in [choice, branch, check] and not _pending.is_empty():
        _paused_at = node_id; return DialogueView.pause(node_id)
    record DialogueNodeEntered; _pending.append_array(node.effects)
    node_id = handler for node.kind() (returns the next id to auto-enter, or returns a view to stop at)
```

Dispatch through a `Dictionary[StringName, Callable]` keyed by `kind()`, not a `match` ladder (architecture §11 "O"). Here `line` returns a line view, `choice` returns a choice view, `effect` gives `next`, `branch` gives the first true case or `else_node`, and `end` records `DialogueEnded`, sets finished and returns `ended`. D5 registers `check`. `advance()` at a `continue` re-enters `_paused_at` without re-pausing (the use case has drained the queue). `start()` records `DialogueStarted` before entering `start_node`.

- [ ] **Step 4: Run the test, then everything**

Expected: `Passing Tests 8`. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/dialogue game/tests/unit/dialogue/test_dialogue_runner.gd` with the message `feat(dialogue): DialogueRunner traversal, views and continue pause`

---

### Task D5: Checks, lockouts and bribes in the runner

Wave: 4

**Files:**
- Modify: `src/domain/dialogue/dialogue_runner.gd`
- Create: `src/domain/dialogue/events/check_resolved.gd`, `src/domain/dialogue/_internal/option_presenter.gd`, `src/domain/dialogue/_internal/bribe_cost.gd`
- Test: `tests/unit/dialogue/test_dialogue_runner_checks.gd`

**Interfaces:**
- Consumes: D2 `CheckResolver`, D3 `DialogueMemory`, D4 runner; `EffectSpec`.
- Produces:
  - `CheckResolved(skill: StringName, dc: int, passed: bool)`.
  - `_internal/BribeCost.cost(base: int, facts) -> int` = `roundi(base * 0.7)` if `facts.has_perk(&"perk.haggler")`, else `base`.
  - `_internal/OptionPresenter.present(...) -> Array[DialogueOptionView]` holds the visibility rules below. The runner calls it.
- Rules (gdd §6.10, content-format §D), applied to each option in authored order:
  1. `bribe > 0` and `facts.crowns() < BribeCost.cost(bribe)`: hidden.
  2. A false condition: hidden, or shown disabled with `requirement_text = condition_text` if `show_locked`.
  3. Locked in this conversation (a failed check, or a `once` option chosen): shown disabled with `requirement_text = ""`.
  4. Otherwise, if locked in `DialogueMemory` from an earlier conversation: hidden.
  5. Otherwise enabled.
- On `choose(option)`:
  - If it has a check, resolve it with `check.with_faction(def.faction)` when `check.faction == &""`, record `CheckResolved`, and on a fail add the option to the conversation locks.
  - If `once`, add it to the conversation locks and `memory.lock(def.id, option.id)`, whatever the outcome.
  - If it has a bribe, queue `EffectSpec.new(&"add_crowns", [-cost], [] as Array[StringName])` first.
  - Then queue the option's effects.
  - Then enter `check.pass_node` or `check.fail_node`, or `next`.
- A `check` node resolves the same way (with an event, and no lock) and auto-enters `pass_node` or `fail_node`.

- [ ] **Step 1: Write the failing test**

```gdscript
## Checks, lockouts and bribes (gdd §6.10; content-format §D).
extends GutTest

var facts: FakeFactProvider
var memory: DialogueMemory


func before_each() -> void:
	facts = FakeFactProvider.new()
	memory = DialogueMemory.new()


func _hub(extra: Array[DialogueOption]) -> DialogueDefinition:
	var opts: Array[DialogueOption] = [DialogueOption.new(&"foam", "Froth. [Investigate]") \
		.with_check(CheckSpec.new(&"investigate", 4, &"pass", &"fail")).with_once(true)]
	opts.append_array(extra)
	opts.append(DialogueOption.new(&"leave", "Bye.", &"bye"))
	var nodes: Dictionary[StringName, DialogueNodeDefinition] = {
		&"hub": DialogueNodeFactory.choice(&"hub", opts),
		&"pass": DialogueNodeFactory.line(&"pass", &"player", "Poison.", &"hub"),
		&"fail": DialogueNodeFactory.line(&"fail", &"npc.bertha", "Looks like death to me, love.", &"hub"),
		&"bye": DialogueNodeFactory.end(&"bye"),
	}
	return DialogueDefinition.new(&"dlg.bertha_intro", &"hub", nodes)


func _option(v: DialogueView, id: StringName) -> DialogueOptionView:
	for o: DialogueOptionView in v.options:
		if o.id == id:
			return o
	return null


func test_option_check_pass_goes_to_pass_node_and_records_event() -> void:
	facts.check_totals[&"investigate"] = 4
	var r := DialogueRunner.new(_hub([] as Array[DialogueOption]), facts, memory)
	r.start()
	r.drain_events()
	assert_eq(r.choose(&"foam").text, "Poison.")
	var ev := r.drain_events().filter(func(e: DomainEvent) -> bool: return e is CheckResolved)
	assert_eq([(ev[0] as CheckResolved).skill, (ev[0] as CheckResolved).dc, (ev[0] as CheckResolved).passed], [&"investigate", 4, true])


func test_failed_check_disables_option_for_rest_of_conversation() -> void:
	facts.check_totals[&"investigate"] = 3
	var r := DialogueRunner.new(_hub([] as Array[DialogueOption]), facts, memory)
	r.start()
	assert_eq(r.choose(&"foam").text, "Looks like death to me, love.")
	var v := r.advance()
	assert_false(_option(v, &"foam").enabled)


func test_once_option_hidden_in_next_conversation() -> void:
	facts.check_totals[&"investigate"] = 3
	var r := DialogueRunner.new(_hub([] as Array[DialogueOption]), facts, memory)
	r.start()
	r.choose(&"foam")
	assert_true(memory.is_locked(&"dlg.bertha_intro", &"foam"))
	var again := DialogueRunner.new(_hub([] as Array[DialogueOption]), facts, memory).start()
	assert_null(_option(again, &"foam"))


func test_non_once_failed_check_is_available_in_new_conversation() -> void:
	var retry: Array[DialogueOption] = [DialogueOption.new(&"press", "Press. [Persuade]").with_check(CheckSpec.new(&"persuade", 6, &"pass", &"fail"))]
	var r := DialogueRunner.new(_hub(retry), facts, memory)
	r.start()
	r.choose(&"press")
	var again := DialogueRunner.new(_hub(retry), facts, memory).start()
	assert_true(_option(again, &"press").enabled)


func test_check_uses_dialogue_faction_rep_mod() -> void:
	facts.check_totals[&"persuade"] = 5
	facts.rep_tiers[&"faction.crown"] = &"friendly"
	var opts: Array[DialogueOption] = [DialogueOption.new(&"p", "P.").with_check(CheckSpec.new(&"persuade", 6, &"pass", &"fail"))]
	var nodes: Dictionary[StringName, DialogueNodeDefinition] = {
		&"hub": DialogueNodeFactory.choice(&"hub", opts),
		&"pass": DialogueNodeFactory.end(&"pass"), &"fail": DialogueNodeFactory.end(&"fail"),
	}
	var r := DialogueRunner.new(DialogueDefinition.new(&"dlg.k", &"hub", nodes).with_faction(&"faction.crown"), facts, memory)
	r.start()
	assert_eq(r.choose(&"p").node_id, &"pass")


func test_check_node_branches_without_locking() -> void:
	facts.check_totals[&"lore"] = 6
	var nodes: Dictionary[StringName, DialogueNodeDefinition] = {
		&"c": DialogueNodeFactory.check(&"c", CheckSpec.new(&"lore", 6, &"ok", &"no")),
		&"ok": DialogueNodeFactory.end(&"ok"), &"no": DialogueNodeFactory.end(&"no"),
	}
	var r := DialogueRunner.new(DialogueDefinition.new(&"dlg.c", &"c", nodes), facts, memory)
	assert_eq(r.start().node_id, &"ok")


func test_bribe_hidden_when_player_cannot_pay() -> void:
	var bribe: Array[DialogueOption] = [DialogueOption.new(&"pay", "[Bribe 30]", &"bye").with_tag(&"bribe").with_bribe(30)]
	facts.crowns_value = 29
	assert_null(_option(DialogueRunner.new(_hub(bribe), facts, memory).start(), &"pay"))
	facts.crowns_value = 30
	assert_true(_option(DialogueRunner.new(_hub(bribe), facts, memory).start(), &"pay").enabled)


func test_bribe_with_haggler_costs_seventy_percent_and_pays_first() -> void:
	var bribe: Array[DialogueOption] = [DialogueOption.new(&"pay", "[Bribe 30]", &"bye").with_bribe(30).with_effects(RuleFixtures.fxs(["set_flag(flag.thug_walked)"]))]
	facts.perks[&"perk.haggler"] = true
	facts.crowns_value = 21
	var r := DialogueRunner.new(_hub(bribe), facts, memory)
	r.start()
	r.choose(&"pay")
	var fx := r.pending_effects()
	assert_eq(fx[0].op, &"add_crowns")
	assert_eq(fx[0].args, RuleFixtures.fx("add_crowns(-21)").args)
	assert_eq(fx[1].op, &"set_flag")
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `tools/test.ps1 -Test tests/unit/dialogue/test_dialogue_runner_checks.gd`
Expected: FAIL with a parse error because `CheckResolved` is not declared.

- [ ] **Step 3: Implement `CheckResolved`, `BribeCost`, `OptionPresenter`, the check-node handler and the `choose` rules above**

Keep `dialogue_runner.gd` at 200 lines or fewer by moving option visibility into `OptionPresenter`.

- [ ] **Step 4: Run the dialogue suite, then everything**

Run: `tools/test.ps1 -Test tests/unit/dialogue`, then `tools/test.ps1`
Expected: 27 dialogue tests pass. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/dialogue game/tests/unit/dialogue/test_dialogue_runner_checks.gd` with the message `feat(dialogue): checks, once-locks, show_locked and bribes`

---

### Task C1: Party membership

Wave: 2

**Files:**
- Create in `src/domain/companions/`: `companion_definition.gd`, `companion_command.gd`, `party.gd`, `events/companion_joined.gd`, `events/companion_left.gd`
- Test: `tests/unit/companions/test_party.gd`

**Interfaces:**
- Consumes: shared `IdRules`, `Result`.
- Produces:
  - `CompanionDefinition._init(id: StringName, display_name: String)`. Builders: `with_role(StringName)`, `with_abilities(Array[StringName])`, `with_skill_bonuses(Dictionary[StringName, int])`, `with_revive_window(float)` (default `30.0`; Aldric 20, gdd §6.13), `with_escort(bool)` (default false). `is_combat_companion() -> bool` is true when `IdRules.kind_of(id) == &"companion"`.
  - `CompanionCommand` (`RefCounted`) with `enum Kind { FOLLOW, HOLD, FOCUS }`, static `to_name(k: Kind) -> StringName` (`&"follow"`, `&"hold"`, `&"focus"`) and static `from_name(n: StringName) -> Kind`.
  - `CompanionJoined(companion_id)`, `CompanionLeft(companion_id)`.
  - `Party extends Snapshotable` (snapshot comes in C2): `_init(defs: Array[CompanionDefinition])`.
    - `recruit(id) -> Result`. Errors: `&"not_a_companion"` (kind is not `companion` or `ally`), `&"unknown_companion"`, `&"already_in_party"`, `&"companion_dead"` (the dead set is added in C2; check it here against an empty set). A combat companion replaces the active one, recording `CompanionLeft(old)` and then `CompanionJoined(new)`. Allies stack.
    - `dismiss(id) -> void` records `CompanionLeft` (a no-op for non-members).
    - `active_companion() -> StringName` (`&""` if none), `allies() -> Array[StringName]` (recruit order), `has(id) -> bool`.
    - `set_command(k: CompanionCommand.Kind)`, `command() -> CompanionCommand.Kind` (default `FOLLOW`), `drain_events()`.

- [ ] **Step 1: Write the failing test**

```gdscript
## Party membership: one combat companion, any number of scripted allies (gdd §6.13).
extends GutTest


func _party() -> Party:
	var defs: Array[CompanionDefinition] = [
		CompanionDefinition.new(&"companion.maelis", "Sister Maelis").with_skill_bonuses({&"lore": 2} as Dictionary[StringName, int]),
		CompanionDefinition.new(&"companion.dravin", "Dravin Ostrel").with_abilities([&"mountain_guide", &"dwarven_doors"] as Array[StringName]),
		CompanionDefinition.new(&"ally.aldric", "Prince Aldric").with_escort(true).with_revive_window(20.0),
		CompanionDefinition.new(&"ally.strept_warband", "Hesk's war-band"),
	]
	return Party.new(defs)


func test_recruit_companion_becomes_active() -> void:
	var p := _party()
	assert_true(p.recruit(&"companion.maelis").is_ok())
	assert_eq(p.active_companion(), &"companion.maelis")
	assert_true(p.has(&"companion.maelis"))
	assert_eq((p.drain_events()[0] as CompanionJoined).companion_id, &"companion.maelis")


func test_second_companion_replaces_first() -> void:
	var p := _party()
	p.recruit(&"companion.maelis")
	p.drain_events()
	p.recruit(&"companion.dravin")
	assert_eq(p.active_companion(), &"companion.dravin")
	assert_false(p.has(&"companion.maelis"))
	var ev := p.drain_events()
	assert_true(ev[0] is CompanionLeft and ev[1] is CompanionJoined)
	assert_eq((ev[0] as CompanionLeft).companion_id, &"companion.maelis")


func test_allies_stack_beside_companion() -> void:
	var p := _party()
	p.recruit(&"companion.maelis")
	p.recruit(&"ally.aldric")
	p.recruit(&"ally.strept_warband")
	assert_eq(p.allies(), [&"ally.aldric", &"ally.strept_warband"] as Array[StringName])
	assert_eq(p.active_companion(), &"companion.maelis")


func test_recruit_errors() -> void:
	var p := _party()
	assert_eq(p.recruit(&"npc.bertha").error_code, &"not_a_companion")
	assert_eq(p.recruit(&"companion.ghost").error_code, &"unknown_companion")
	p.recruit(&"ally.aldric")
	assert_eq(p.recruit(&"ally.aldric").error_code, &"already_in_party")


func test_dismiss() -> void:
	var p := _party()
	p.recruit(&"companion.maelis")
	p.drain_events()
	p.dismiss(&"companion.maelis")
	assert_eq(p.active_companion(), &"")
	assert_true(p.drain_events()[0] is CompanionLeft)
	p.dismiss(&"companion.maelis")
	assert_eq(p.drain_events().size(), 0)


func test_command_defaults_to_follow_and_names_round_trip() -> void:
	var p := _party()
	assert_eq(p.command(), CompanionCommand.Kind.FOLLOW)
	p.set_command(CompanionCommand.Kind.FOCUS)
	assert_eq(CompanionCommand.to_name(p.command()), &"focus")
	assert_eq(CompanionCommand.from_name(&"hold"), CompanionCommand.Kind.HOLD)
```

- [ ] **Step 2: Run the test to verify it fails**

Expected: FAIL with a parse error because `CompanionDefinition` is not declared.

- [ ] **Step 3: Implement the five classes**

- [ ] **Step 4: Run the test, then everything**

Expected: `Passing Tests 6`. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/companions game/tests/unit/companions` with the message `feat(companions): companion definitions, commands and party membership`

---

### Task C2: Downed, retreat, scripted death, bonuses, snapshot

Wave: 3

**Files:**
- Modify: `src/domain/companions/party.gd`
- Create in `src/domain/companions/events/`: `companion_downed.gd`, `companion_revived.gd`, `companion_died.gd`
- Test: `tests/unit/companions/test_party_states.gd`

**Interfaces:**
- Consumes: C1.
- Produces:
  - `CompanionDowned(id)`, `CompanionRevived(id)`, `CompanionDied(id)`.
  - `set_downed(id)` (asserts `has`; records the event only on the change). `revive(id)` (only if downed; records the event). `retreat(id) -> Result` (the member stays in the party but is not present; err `&"escort_lost"` for an escort definition, and then the state is unchanged).
  - `reset_for_zone()` clears downed and retreated. `kill_scripted(id)` removes the member, marks it dead and records `CompanionDied`. `is_dead(id)`.
  - `in_party(id) -> bool` means `has(id)` and not retreated (content-format §C `in_party`).
  - `skill_bonus(skill: StringName) -> int` sums `skill_bonuses` over `in_party` members. `has_ability(ability) -> bool` checks `in_party` members.
  - Snapshot: `{"active": String, "allies": [String], "downed": [String], "retreated": [String], "dead": [String], "command": String}`.

- [ ] **Step 1: Write the failing test**

```gdscript
## Downed, retreat and the scripted Maelis death (gdd §6.13, §6.2).
extends GutTest
# _party() exactly as in test_party.gd

func test_downed_member_is_still_in_party_and_revives() -> void:
	var p := _party()
	p.recruit(&"companion.maelis")
	p.drain_events()
	p.set_downed(&"companion.maelis")
	assert_true(p.in_party(&"companion.maelis"))
	p.revive(&"companion.maelis")
	p.revive(&"companion.maelis")
	assert_eq(EventNames.of(p.drain_events()), ["CompanionDowned", "CompanionRevived"])


func test_retreat_leaves_party_until_next_zone() -> void:
	var p := _party()
	p.recruit(&"companion.maelis")
	p.set_downed(&"companion.maelis")
	assert_true(p.retreat(&"companion.maelis").is_ok())
	assert_false(p.in_party(&"companion.maelis"))
	assert_true(p.has(&"companion.maelis"))
	p.reset_for_zone()
	assert_true(p.in_party(&"companion.maelis"))


func test_escort_cannot_retreat() -> void:
	var p := _party()
	p.recruit(&"ally.aldric")
	assert_eq(p.retreat(&"ally.aldric").error_code, &"escort_lost")
	assert_true(p.in_party(&"ally.aldric"))


func test_kill_scripted_is_permanent() -> void:
	var p := _party()
	p.recruit(&"companion.maelis")
	p.drain_events()
	p.kill_scripted(&"companion.maelis")
	assert_false(p.has(&"companion.maelis"))
	assert_true(p.is_dead(&"companion.maelis"))
	assert_true(p.drain_events()[0] is CompanionDied)
	assert_eq(p.recruit(&"companion.maelis").error_code, &"companion_dead")


func test_skill_bonus_and_abilities_need_presence() -> void:
	var p := _party()
	p.recruit(&"companion.maelis")
	assert_eq(p.skill_bonus(&"lore"), 2)
	assert_eq(p.skill_bonus(&"persuade"), 0)
	p.set_downed(&"companion.maelis")
	p.retreat(&"companion.maelis")
	assert_eq(p.skill_bonus(&"lore"), 0)
	p.recruit(&"companion.dravin")
	assert_true(p.has_ability(&"mountain_guide"))


func test_restore_from_json_round_trip() -> void:
	var p := _party()
	p.recruit(&"companion.dravin")
	p.recruit(&"ally.aldric")
	p.set_downed(&"ally.aldric")
	p.set_command(CompanionCommand.Kind.HOLD)
	p.recruit(&"companion.maelis")
	p.kill_scripted(&"companion.maelis")
	var copy := _party()
	copy.restore(JSON.parse_string(JSON.stringify(p.to_snapshot())))
	assert_eq(copy.active_companion(), &"")
	assert_eq(copy.allies(), [&"ally.aldric"] as Array[StringName])
	assert_true(copy.is_dead(&"companion.maelis"))
	assert_eq(copy.command(), CompanionCommand.Kind.HOLD)


func test_restore_records_nothing() -> void:
	var p := _party()
	p.recruit(&"companion.dravin")
	var copy := _party()
	copy.restore(p.to_snapshot())
	assert_eq(copy.drain_events().size(), 0)
```

(In the round-trip test, recruiting Maelis replaces Dravin, and killing her then leaves no active companion.)

- [ ] **Step 2: Run the test to verify it fails**

Expected: FAIL with "Nonexistent function 'set_downed'".

- [ ] **Step 3: Implement the methods and events**

- [ ] **Step 4: Run the companions suite, then everything**

Expected: 13 companions tests pass. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/companions game/tests/unit/companions/test_party_states.gd` with the message `feat(companions): downed, retreat, scripted death, bonuses and snapshot`

---

### Task T1: Map graph and travel state

Wave: 2

**Files:**
- Create in `src/domain/travel/`: `map_node_definition.gd`, `map_edge_definition.gd`, `travel_graph.gd`, `travel_state.gd`, `events/node_unlocked.gd`, `events/journey_started.gd`, `events/journey_completed.gd`
- Test: `tests/unit/travel/test_travel_graph.gd`, `tests/unit/travel/test_travel_state.gd`

**Interfaces:**
- Consumes: `Condition`, `FactProvider`, `Result`; S0 `RuleFixtures`, `EventNames`; P1 `FakeFactProvider`.
- Produces:
  - `MapNodeDefinition._init(id, display_name: String)`, `with_unlock(Condition)`.
  - `MapEdgeDefinition._init(id: StringName, node_a: StringName, node_b: StringName, terrain: StringName)`. It asserts that the terrain is `lowlands`, `valley` or `mountain`. Builders: `with_condition(Condition)` (passability) and `with_hazard(event_id: StringName, condition: Condition)`. Queries: `other_end(node) -> StringName`, `touches(node) -> bool`, `is_passable(facts) -> bool` (a null condition means passable), `hazard_applies(facts) -> bool` (a hazard is set and its condition is null or true).
  - `TravelGraph._init(nodes: Array[MapNodeDefinition], edges: Array[MapEdgeDefinition])` asserts that both endpoints exist. Queries: `neighbors(node) -> Array[MapEdgeDefinition]` (the touching edges, sorted by `other_end` id, then by edge id), `node(id) -> MapNodeDefinition` (null if missing), `has_node(id)`, `nodes()`.
  - Events: `NodeUnlocked(node_id)`, `JourneyStarted(from_node, to_node)`, `JourneyCompleted(to_node)`.
  - `TravelState extends Snapshotable`: `_init(start_node)` (the start is unlocked and current). Methods:
    - `unlock(id) -> bool` (true if new; records `NodeUnlocked`), `is_unlocked(id)`, `unlocked_nodes() -> Array[StringName]` (sorted), `current_node()`.
    - `begin_journey(to) -> Result` (`&"node_locked"`, `&"already_there"`; records `JourneyStarted(current, to)`).
    - `move_to(id)` (asserts the node is unlocked; sets current; records `JourneyCompleted`).
    - `previous_encounter() -> StringName` (`&""` at start), `record_encounter(id)` (pass `&""` for a quiet road).
    - `add_pin(id) -> bool`, `has_pin(id)`, `pins() -> Array[StringName]` (sorted).
    - Snapshot: `{"current": String, "unlocked": [String], "pins": [String], "previous": String}`.

- [ ] **Step 1: Write the failing tests**

```gdscript
## Map graph (gdd §6.3 "Edge passability", §7.5).
extends GutTest


func _graph() -> TravelGraph:
	var nodes: Array[MapNodeDefinition] = [
		MapNodeDefinition.new(&"map.ferrymen_camp", "Ferrymen's Camp"),
		MapNodeDefinition.new(&"map.marnadal_field", "Marnadal Field"),
		MapNodeDefinition.new(&"map.grey_ferry", "Grey Ferry"),
	]
	var edges: Array[MapEdgeDefinition] = [
		MapEdgeDefinition.new(&"edge.ferrymen_grey", &"map.ferrymen_camp", &"map.grey_ferry", &"valley"),
		MapEdgeDefinition.new(&"edge.ferrymen_field", &"map.ferrymen_camp", &"map.marnadal_field", &"valley") \
			.with_hazard(&"event.ford_marnadal", RuleFixtures.cond("not flag(flag.jory_crossing_granted)")),
	]
	return TravelGraph.new(nodes, edges)


func test_neighbors_sorted_by_other_end() -> void:
	var n := _graph().neighbors(&"map.ferrymen_camp")
	assert_eq(n.size(), 2)
	assert_eq(n[0].other_end(&"map.ferrymen_camp"), &"map.grey_ferry")
	assert_eq(n[1].other_end(&"map.ferrymen_camp"), &"map.marnadal_field")
	assert_eq(_graph().neighbors(&"map.grey_ferry").size(), 1)


func test_edge_passability_and_hazard() -> void:
	var f := FakeFactProvider.new()
	var ford := _graph().neighbors(&"map.marnadal_field")[0]
	assert_true(ford.is_passable(f))
	assert_true(ford.hazard_applies(f))
	f.flags[&"flag.jory_crossing_granted"] = true
	assert_false(ford.hazard_applies(f))
	var barge := MapEdgeDefinition.new(&"edge.barge", &"map.ferrymen_camp", &"map.attre", &"valley") \
		.with_condition(RuleFixtures.cond("rep_tier(faction.ferrymen) >= allied"))
	assert_false(barge.is_passable(f))


func test_node_lookup() -> void:
	assert_true(_graph().has_node(&"map.grey_ferry"))
	assert_null(_graph().node(&"map.nowhere"))
	assert_eq(_graph().nodes().size(), 3)
```

```gdscript
## Travel state: unlocks, position, pins, previous encounter (gdd §6.3).
extends GutTest


func test_start_node_is_unlocked_and_current() -> void:
	var s := TravelState.new(&"map.cintra")
	assert_eq(s.current_node(), &"map.cintra")
	assert_true(s.is_unlocked(&"map.cintra"))
	assert_eq(s.previous_encounter(), &"")


func test_unlock_once() -> void:
	var s := TravelState.new(&"map.cintra")
	assert_true(s.unlock(&"map.tigg"))
	assert_false(s.unlock(&"map.tigg"))
	var ev := s.drain_events()
	assert_eq(ev.size(), 1)
	assert_eq((ev[0] as NodeUnlocked).node_id, &"map.tigg")


func test_journey_events_and_errors() -> void:
	var s := TravelState.new(&"map.cintra")
	assert_eq(s.begin_journey(&"map.tigg").error_code, &"node_locked")
	assert_eq(s.begin_journey(&"map.cintra").error_code, &"already_there")
	s.unlock(&"map.tigg")
	s.drain_events()
	assert_true(s.begin_journey(&"map.tigg").is_ok())
	s.move_to(&"map.tigg")
	var ev := s.drain_events()
	assert_eq([(ev[0] as JourneyStarted).from_node, (ev[0] as JourneyStarted).to_node], [&"map.cintra", &"map.tigg"])
	assert_eq((ev[1] as JourneyCompleted).to_node, &"map.tigg")
	assert_eq(s.current_node(), &"map.tigg")


func test_pins_and_previous_encounter() -> void:
	var s := TravelState.new(&"map.cintra")
	assert_true(s.add_pin(&"map.witchs_mere"))
	assert_false(s.add_pin(&"map.witchs_mere"))
	assert_true(s.has_pin(&"map.witchs_mere"))
	s.record_encounter(&"event.l1_tax_collectors")
	assert_eq(s.previous_encounter(), &"event.l1_tax_collectors")


func test_restore_from_json_round_trip() -> void:
	var s := TravelState.new(&"map.cintra")
	s.unlock(&"map.tigg")
	s.move_to(&"map.tigg")
	s.add_pin(&"map.barrows")
	s.record_encounter(&"enc.wolves")
	var copy := TravelState.new(&"map.cintra")
	copy.restore(JSON.parse_string(JSON.stringify(s.to_snapshot())))
	assert_eq(copy.current_node(), &"map.tigg")
	assert_eq(copy.unlocked_nodes(), [&"map.cintra", &"map.tigg"] as Array[StringName])
	assert_true(copy.has_pin(&"map.barrows"))
	assert_eq(copy.previous_encounter(), &"enc.wolves")


func test_restore_records_nothing() -> void:
	var s := TravelState.new(&"map.cintra")
	s.unlock(&"map.tigg")
	var copy := TravelState.new(&"map.cintra")
	copy.restore(s.to_snapshot())
	assert_eq(copy.drain_events().size(), 0)
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `tools/test.ps1 -Test tests/unit/travel`
Expected: FAIL with a parse error because `MapNodeDefinition` is not declared.

- [ ] **Step 3: Implement the seven classes**

- [ ] **Step 4: Run the tests, then everything**

Expected: 9 travel tests pass. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/travel game/tests/unit/travel` with the message `feat(travel): map graph, edges with passability and hazards, travel state`

---

### Task T3: Encounter tables, modifiers, results and chance

Wave: 2

**Files:**
- Create in `src/domain/travel/`: `encounter_entry_definition.gd`, `encounter_table_definition.gd`, `encounter_modifiers.gd`, `encounter_result.gd`, `encounter_chance.gd`
- Test: `tests/unit/travel/test_encounter_chance.gd`

**Interfaces:**
- Consumes: `Condition`, `FactProvider`, `IdRules`; S0 `RuleFixtures`, `EventNames`; P1 `FakeFactProvider`.
- Produces:
  - `EncounterEntryDefinition._init(id: StringName, kind: StringName)`. `kind` is one of `combat`, `event_card`, `discovery`, `hazard` or `pool` (the slot-8 marker). `with_requires(Condition)`. `is_available(facts) -> bool`. `is_escalation() -> bool` is true when `IdRules.kind_of(id) == &"esc"`.
  - `EncounterTableDefinition._init(terrain: StringName, entries: Array[EncounterEntryDefinition], pool: Array[EncounterEntryDefinition])`. It asserts `entries.size() == 8`, `entries[7].kind == &"pool"` and a non-empty `pool` (gdd §6.3: "d8 = 8" draws from the pool). `entry(slot: int) -> EncounterEntryDefinition` is 1-based.
  - `EncounterModifiers._init(pathfinder: bool = false, forest_guide: bool = false, previous_id: StringName = &"")`. Static `from_facts(facts, previous_id) -> EncounterModifiers` reads `has_perk(&"perk.pathfinder")` and `in_party(&"ally.forest_guide")`.
  - `EncounterResult._init(kind: StringName, entry_id: StringName, terrain: StringName, slot: int)`, `with_escalated(bool)`. Static `quiet(terrain) -> EncounterResult` (kind `&"quiet"`, entry `&""`, slot 0). `is_quiet()`.
  - `EncounterChance.compute(edge_count: int, has_valley_edge: bool, modifiers: EncounterModifiers) -> float`: `min(0.35 + 0.10 * (edge_count - 1), 0.75)`, minus 0.15 with pathfinder, minus 0.15 with forest_guide when there is a valley edge, then `max(chance, 0.05)`.

- [ ] **Step 1: Write the failing test**

```gdscript
## Encounter chance and tables (gdd §6.3 "Encounter check").
extends GutTest


func _chance(edges: int, valley := false, mods := EncounterModifiers.new()) -> float:
	return EncounterChance.compute(edges, valley, mods)


func test_base_chance_grows_per_edge_and_caps() -> void:
	assert_almost_eq(_chance(1), 0.35, 0.0001)
	assert_almost_eq(_chance(3), 0.55, 0.0001)
	assert_almost_eq(_chance(5), 0.75, 0.0001)
	assert_almost_eq(_chance(6), 0.75, 0.0001)


func test_pathfinder_and_forest_guide() -> void:
	assert_almost_eq(_chance(1, false, EncounterModifiers.new(true)), 0.20, 0.0001)
	assert_almost_eq(_chance(3, true, EncounterModifiers.new(false, true)), 0.40, 0.0001)
	assert_almost_eq(_chance(3, false, EncounterModifiers.new(false, true)), 0.55, 0.0001)


func test_floor_is_five_percent() -> void:
	assert_almost_eq(_chance(1, true, EncounterModifiers.new(true, true)), 0.05, 0.0001)


func test_from_facts_reads_perk_and_guide() -> void:
	var f := FakeFactProvider.new()
	f.perks[&"perk.pathfinder"] = true
	f.party[&"ally.forest_guide"] = true
	var m := EncounterModifiers.from_facts(f, &"enc.wolves")
	assert_true(m.pathfinder and m.forest_guide)
	assert_eq(m.previous_id, &"enc.wolves")


func test_table_slots_are_one_based_and_slot_eight_is_pool() -> void:
	var entries: Array[EncounterEntryDefinition] = []
	for i in 7:
		entries.append(EncounterEntryDefinition.new(StringName("event.l%d" % (i + 1)), &"event_card"))
	entries.append(EncounterEntryDefinition.new(&"esc.l_slot", &"pool"))
	var pool: Array[EncounterEntryDefinition] = [EncounterEntryDefinition.new(&"esc.l_withered_line", &"event_card")]
	var t := EncounterTableDefinition.new(&"lowlands", entries, pool)
	assert_eq(t.entry(1).id, &"event.l1")
	assert_eq(t.entry(8).kind, &"pool")
	assert_true(t.pool[0].is_escalation())
	assert_false(t.entry(1).is_escalation())


func test_quiet_result() -> void:
	var q := EncounterResult.quiet(&"valley")
	assert_true(q.is_quiet())
	assert_eq([q.entry_id, q.slot, q.terrain], [&"", 0, &"valley"])
```

- [ ] **Step 2: Run the test to verify it fails**

Expected: FAIL with a parse error because `EncounterChance` is not declared.

- [ ] **Step 3: Implement the five classes**

- [ ] **Step 4: Run the test, then everything**

Expected: `Passing Tests 6`. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/travel game/tests/unit/travel/test_encounter_chance.gd` with the message `feat(travel): encounter tables, modifiers, results and chance formula`

---

### Task T2: Route and RoutePlanner

Wave: 3

**Files:**
- Create: `src/domain/travel/route.gd`, `src/domain/travel/route_planner.gd`
- Test: `tests/unit/travel/test_route_planner.gd`

**Interfaces:**
- Consumes: T1 `TravelGraph`, `TravelState`, `MapEdgeDefinition`; `FactProvider`.
- Produces:
  - `Route._init(nodes: Array[StringName], edges: Array[MapEdgeDefinition])`, `with_forced_hazards(Array[StringName])`. Fields: `nodes`, `edges`, `terrain` (computed in `_init`: the terrain held by the most edges; on a tie, the tied terrain whose last occurrence comes latest on the route, which is the last edge's terrain whenever that terrain is tied), `forced_hazards` (event ids in route order). Methods: `edge_count() -> int`, `has_terrain(t) -> bool`, `mountain_edges() -> int`.
  - `RoutePlanner.plan(graph, state, from, to, facts) -> Result` (static), holding a `Route`. Errors: `&"unknown_node"` (`from` or `to` not in the graph), `&"already_there"`, `&"node_locked"` (`to` not unlocked), `&"no_route"`.
- Algorithm (gdd §6.3: shortest by edge count; ties by fewest mountain edges, then alphabetically by node id). Run a BFS over unlocked nodes through edges where `is_passable(facts)`. For each node, keep the best path among paths of the shortest length. Compare candidates by `(mountain_edges, node-id sequence compared element by element)`. Optimal substructure holds because the comparison is first additive and then lexicographic over equal-length prefixes. Visit neighbours in `graph.neighbors()` order. Forced hazards are the `hazard_applies(facts)` edges of the chosen path, in path order.

- [ ] **Step 1: Write the failing test**

```gdscript
## Deterministic routing (gdd §6.3 "Journey", "Edge passability").
extends GutTest

var facts: FakeFactProvider


func before_each() -> void:
	facts = FakeFactProvider.new()


func _edge(a: String, b: String, terrain: StringName) -> MapEdgeDefinition:
	return MapEdgeDefinition.new(StringName("edge.%s_%s" % [a, b]), StringName("map." + a), StringName("map." + b), terrain)


func _plan(edges: Array[MapEdgeDefinition], to: String, locked: Array[String] = []) -> Result:
	var ids: Dictionary[StringName, bool] = {}
	for e: MapEdgeDefinition in edges:
		ids[e.node_a] = true
		ids[e.node_b] = true
	var nodes: Array[MapNodeDefinition] = []
	var state := TravelState.new(&"map.a")
	for id: StringName in ids:
		nodes.append(MapNodeDefinition.new(id, String(id)))
		if not locked.has(String(id).trim_prefix("map.")):
			state.unlock(id)
	return RoutePlanner.plan(TravelGraph.new(nodes, edges), state, &"map.a", StringName("map." + to), facts)


func test_shortest_by_edge_count() -> void:
	var r := _plan([_edge("a", "b", &"lowlands"), _edge("b", "c", &"lowlands"), _edge("c", "d", &"lowlands"), _edge("a", "d", &"valley")] as Array[MapEdgeDefinition], "d")
	assert_eq((r.value as Route).nodes, [&"map.a", &"map.d"] as Array[StringName])


func test_tie_prefers_fewer_mountain_edges() -> void:
	var r := _plan([_edge("a", "b", &"mountain"), _edge("b", "d", &"lowlands"), _edge("a", "c", &"lowlands"), _edge("c", "d", &"lowlands")] as Array[MapEdgeDefinition], "d")
	assert_eq((r.value as Route).nodes, [&"map.a", &"map.c", &"map.d"] as Array[StringName])


func test_tie_then_alphabetical_by_node_id() -> void:
	var r := _plan([_edge("a", "c", &"lowlands"), _edge("c", "d", &"lowlands"), _edge("a", "b", &"lowlands"), _edge("b", "d", &"lowlands")] as Array[MapEdgeDefinition], "d")
	assert_eq((r.value as Route).nodes, [&"map.a", &"map.b", &"map.d"] as Array[StringName])


func test_impassable_edge_and_locked_node_are_avoided() -> void:
	var blocked := _edge("a", "d", &"lowlands").with_condition(RuleFixtures.cond("flag(flag.open)"))
	var r := _plan([blocked, _edge("a", "b", &"lowlands"), _edge("b", "d", &"lowlands"), _edge("a", "c", &"lowlands"), _edge("c", "d", &"lowlands")] as Array[MapEdgeDefinition], "d", ["b"])
	assert_eq((r.value as Route).nodes, [&"map.a", &"map.c", &"map.d"] as Array[StringName])


func test_errors() -> void:
	var edges: Array[MapEdgeDefinition] = [_edge("a", "b", &"lowlands").with_condition(RuleFixtures.cond("false")), _edge("c", "e", &"lowlands")]
	assert_eq(_plan(edges, "b").error_code, &"no_route")
	assert_eq(_plan(edges, "a").error_code, &"already_there")
	assert_eq(_plan(edges, "zzz").error_code, &"unknown_node")
	assert_eq(_plan(edges, "c", ["c"]).error_code, &"node_locked")


func test_majority_terrain_and_tie_to_last_edge() -> void:
	var r := _plan([_edge("a", "b", &"valley"), _edge("b", "c", &"lowlands"), _edge("c", "d", &"valley")] as Array[MapEdgeDefinition], "d")
	assert_eq((r.value as Route).terrain, &"valley")
	var t := _plan([_edge("a", "b", &"lowlands"), _edge("b", "c", &"mountain")] as Array[MapEdgeDefinition], "c")
	assert_eq((t.value as Route).terrain, &"mountain")
	assert_eq((t.value as Route).mountain_edges(), 1)


func test_forced_hazards_in_route_order() -> void:
	var ford := _edge("b", "c", &"valley").with_hazard(&"event.ford_marnadal", RuleFixtures.cond("not flag(flag.jory_crossing_granted)"))
	var pass := _edge("a", "b", &"mountain").with_hazard(&"event.snow_choked_pass", RuleFixtures.cond("stage() >= 2"))
	facts.stage = 2
	var r := _plan([pass, ford] as Array[MapEdgeDefinition], "c")
	assert_eq((r.value as Route).forced_hazards, [&"event.snow_choked_pass", &"event.ford_marnadal"] as Array[StringName])
	facts.flags[&"flag.jory_crossing_granted"] = true
	assert_eq((_plan([pass, ford] as Array[MapEdgeDefinition], "c").value as Route).forced_hazards, [&"event.snow_choked_pass"] as Array[StringName])
```

- [ ] **Step 2: Run the test to verify it fails**

Expected: FAIL with a parse error because `RoutePlanner` is not declared.

- [ ] **Step 3: Implement `Route` and `RoutePlanner`**

- [ ] **Step 4: Run the travel suite, then everything**

Expected: 22 travel tests pass. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/travel game/tests/unit/travel/test_route_planner.gd` with the message `feat(travel): deterministic RoutePlanner with terrain majority and forced hazards`

---

### Task T4: EncounterRoller

Wave: 4

**Files:**
- Create: `src/domain/travel/encounter_roller.gd`, `src/domain/travel/events/encounter_rolled.gd`
- Test: `tests/unit/travel/test_encounter_roller.gd`

**Interfaces:**
- Consumes: T2 `Route`; T3 tables, modifiers, result and chance; `RandomSource`; `FactProvider`; P1 test helper `ScriptedRandom`.
- Produces: `EncounterRolled(result: EncounterResult)`. `EncounterRoller._init(tables: Array[EncounterTableDefinition], rng: RandomSource)` asserts one table per terrain. `roll(route, facts, escalation_stage: int, modifiers) -> EncounterResult` records `EncounterRolled` for every roll, quiet ones included. `drain_events()`.
- Draw order (pinned, so the seed fixes the result; gdd §6.3):

```
terrain = escalation_stage >= 4 ? &"mountain" : route.terrain      # gdd §6.1 stage 4: mountain tables only
chance = EncounterChance.compute(route.edge_count(), route.has_terrain(&"valley"), modifiers)
if rng.randf() >= chance: return quiet(terrain)
repeat 4 times (1 roll + up to 3 rerolls):
    slot = rng.randi_range(1, 8); escalated = false
    if slot == 8: entry = pool[rng.randi_range(0, pool.size() - 1)]; escalated = true
    else:
        entry = table.entry(slot)
        if escalation_stage >= 2 and not entry.is_escalation():
            if rng.randi_range(1, 6) <= 2: entry = pool[rng.randi_range(0, pool.size() - 1)]; escalated = true
    if entry.is_available(facts) and entry.id != modifiers.previous_id: return result(entry.kind, entry.id, terrain, slot).with_escalated(escalated)
return quiet(terrain)
```

- [ ] **Step 1: Write the failing test**

```gdscript
## Encounter roll: chance, d8, stage >= 2 d6 replacement, reroll rules (gdd §6.3).
extends GutTest

var facts: FakeFactProvider


func before_each() -> void:
	facts = FakeFactProvider.new()


func _table(terrain: StringName, prefix: String, pool_ids: Array[StringName]) -> EncounterTableDefinition:
	var entries: Array[EncounterEntryDefinition] = []
	for i in 7:
		entries.append(EncounterEntryDefinition.new(StringName("event.%s%d" % [prefix, i + 1]), &"event_card"))
	entries[3] = EncounterEntryDefinition.new(entries[3].id, &"event_card").with_requires(RuleFixtures.cond("not flag(flag.roost_resolved)"))
	entries.append(EncounterEntryDefinition.new(StringName("esc.%s_slot" % prefix), &"pool"))
	var pool: Array[EncounterEntryDefinition] = []
	for id: StringName in pool_ids:
		pool.append(EncounterEntryDefinition.new(id, &"combat"))
	return EncounterTableDefinition.new(terrain, entries, pool)


func _roller(ints: Array[int], floats: Array[float] = [0.0]) -> EncounterRoller:
	var tables: Array[EncounterTableDefinition] = [
		_table(&"lowlands", "l", [&"esc.l_withered_line", &"esc.l_feather_proclamations", &"esc.l_refugee_column"] as Array[StringName]),
		_table(&"mountain", "m", [&"esc.m_blue_fires", &"esc.m_tremor", &"esc.m_stray_warden"] as Array[StringName]),
	]
	return EncounterRoller.new(tables, ScriptedRandom.new(ints, floats))


func _route(edges := 1) -> Route:
	var list: Array[MapEdgeDefinition] = []
	for i in edges:
		list.append(MapEdgeDefinition.new(StringName("edge.e%d" % i), StringName("map.n%d" % i), StringName("map.n%d" % (i + 1)), &"lowlands"))
	return Route.new([] as Array[StringName], list)


func test_no_encounter_when_draw_reaches_chance() -> void:
	var r := _roller([], [0.35]).roll(_route(), facts, 0, EncounterModifiers.new())
	assert_true(r.is_quiet())


func test_d8_selects_slot_and_no_d6_below_stage_two() -> void:
	var dice := ScriptedRandom.new([3], [0.0])
	var tables: Array[EncounterTableDefinition] = [_table(&"lowlands", "l", [&"esc.l_withered_line"] as Array[StringName])]
	var r := EncounterRoller.new(tables, dice).roll(_route(), facts, 1, EncounterModifiers.new())
	assert_eq([r.entry_id, r.slot, r.escalated, r.terrain], [&"event.l3", 3, false, &"lowlands"])
	assert_eq(int(dice.get_state()["int_index"]), 1, "no d6 drawn below stage 2")


func test_stage_two_d6_one_or_two_replaces_with_pool() -> void:
	var r := _roller([3, 2, 1]).roll(_route(), facts, 2, EncounterModifiers.new())
	assert_eq([r.entry_id, r.escalated], [&"esc.l_feather_proclamations", true])


func test_stage_two_d6_three_to_six_keeps_entry() -> void:
	assert_eq(_roller([3, 3]).roll(_route(), facts, 2, EncounterModifiers.new()).entry_id, &"event.l3")


func test_slot_eight_draws_pool_without_d6() -> void:
	var r := _roller([8, 2]).roll(_route(), facts, 2, EncounterModifiers.new())
	assert_eq([r.entry_id, r.slot, r.escalated], [&"esc.l_refugee_column", 8, true])


func test_requirement_gated_entry_is_rerolled() -> void:
	facts.flags[&"flag.roost_resolved"] = true
	assert_eq(_roller([4, 5]).roll(_route(), facts, 0, EncounterModifiers.new()).entry_id, &"event.l5")


func test_previous_result_is_rerolled() -> void:
	var r := _roller([3, 6]).roll(_route(), facts, 0, EncounterModifiers.new(false, false, &"event.l3"))
	assert_eq(r.entry_id, &"event.l6")


func test_four_failed_tries_give_quiet_road() -> void:
	var r := _roller([3, 3, 3, 3]).roll(_route(), facts, 0, EncounterModifiers.new(false, false, &"event.l3"))
	assert_true(r.is_quiet())


func test_stage_four_uses_mountain_table() -> void:
	var r := _roller([1, 6]).roll(_route(), facts, 4, EncounterModifiers.new())
	assert_eq([r.entry_id, r.terrain], [&"event.m1", &"mountain"])


func test_roll_records_event() -> void:
	var roller := _roller([], [0.99])
	roller.roll(_route(), facts, 0, EncounterModifiers.new())
	var ev := roller.drain_events()
	assert_eq(ev.size(), 1)
	assert_true((ev[0] as EncounterRolled).result.is_quiet())


func test_reproducible_from_seed() -> void:
	var tables: Array[EncounterTableDefinition] = [_table(&"lowlands", "l", [&"esc.l_withered_line"] as Array[StringName])]
	var a := EncounterRoller.new(tables, SeededRandom.new(42)).roll(_route(4), facts, 2, EncounterModifiers.new())
	var b := EncounterRoller.new(tables, SeededRandom.new(42)).roll(_route(4), facts, 2, EncounterModifiers.new())
	assert_eq(a.entry_id, b.entry_id)
```

- [ ] **Step 2: Run the test to verify it fails**

Expected: FAIL with a parse error because `EncounterRoller` is not declared.

- [ ] **Step 3: Implement `EncounterRoller` (the draw order above) and `EncounterRolled`**

- [ ] **Step 4: Run the travel suite, then everything**

Expected: 33 travel tests pass. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/travel game/tests/unit/travel/test_encounter_roller.gd` with the message `feat(travel): EncounterRoller with escalation rule and rerolls`

---

### Task F1: FinaleRecord

Wave: 2

**Files:**
- Create: `src/domain/finale/finale_record.gd`
- Test: `tests/unit/finale/test_finale_record.gd`

**Interfaces:**
- Produces: `FinaleRecord extends Snapshotable`. Fields: `oath: StringName = &"none"` (`true`, `reversed` or `none`), `anselm: StringName = &"alive"` (`alive`, `dead` or `fled`), `vault_seized = false`, `coerced = false`. `resolve(oath, anselm, vault_seized: bool, coerced: bool) -> void` asserts valid values and that the record is not already resolved. `is_resolved() -> bool`. Snapshot: `{"resolved": bool, "oath": String, "anselm": String, "vault_seized": bool, "coerced": bool}`.

- [ ] **Step 1: Write the failing test**

```gdscript
## The finale's outcome record (gdd §6.14, read by §6.15).
extends GutTest


func test_unresolved_defaults() -> void:
	var r := FinaleRecord.new()
	assert_false(r.is_resolved())
	assert_eq([r.oath, r.anselm, r.vault_seized, r.coerced], [&"none", &"alive", false, false])


func test_resolve_sets_outcome() -> void:
	var r := FinaleRecord.new()
	r.resolve(&"reversed", &"fled", false, false)
	assert_true(r.is_resolved())
	assert_eq([r.oath, r.anselm], [&"reversed", &"fled"])


func test_restore_from_json_round_trip() -> void:
	var r := FinaleRecord.new()
	r.resolve(&"none", &"alive", true, true)
	var copy := FinaleRecord.new()
	copy.restore(JSON.parse_string(JSON.stringify(r.to_snapshot())))
	assert_true(copy.is_resolved())
	assert_eq([copy.oath, copy.vault_seized, copy.coerced], [&"none", true, true])
```

- [ ] **Step 2: Run the test to verify it fails**

Expected: FAIL with a parse error because `FinaleRecord` is not declared.

- [ ] **Step 3: Implement `FinaleRecord`**

- [ ] **Step 4: Run the test, then everything**

Expected: `Passing Tests 3`. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/finale/finale_record.gd game/tests/unit/finale/test_finale_record.gd` with the message `feat(finale): FinaleRecord`

---

### Task F2: RitualMeter timers and FinaleSetup

Wave: 3

**Files:**
- Create in `src/domain/finale/`: `ritual_meter.gd`, `_internal/verse_clock.gd`, `finale_setup.gd`, `events/reversed_verse_completed.gd`, `events/true_verse_completed.gd`, `events/anselm_transformed.gd`, `events/finale_resolved.gd`
- Test: `tests/unit/finale/test_ritual_meter.gd`, `tests/unit/finale/test_finale_setup.gd`

**Interfaces:**
- Consumes: F1 `FinaleRecord`; `FactProvider`, `Result`.
- Produces:
  - Events: `ReversedVerseCompleted(n: int)`, `TrueVerseCompleted(n: int)`, `AnselmTransformed()`, `FinaleResolved(record: FinaleRecord)`.
  - `_internal/VerseClock._init(duration: float)`: `set_factor(id, factor)` (keyed, so the same id does not stack), `effective_duration()`, `time_to_next()`, `advance(dt) -> bool` (true when a verse completed, which resets elapsed to 0; use an epsilon of 1e-6), `reset_progress()`.
  - `RitualMeter._init(t_rev: float, t_true: float)`:
    - Modifiers: `apply_modifier(id, factor)` (scales T_rev), `apply_true_modifier(id, factor)` (scales T_true).
    - Bodyguards: `set_bodyguards(n)`, `bodyguard_down()`, `bodyguards_remaining() -> int`.
    - `free_aldric() -> Result`. Errors: `&"ritual_over"`, `&"aldric_not_held"`, `&"bodyguards_remain"`. On success, `aldric_state` becomes `channeling`.
    - Aldric: `set_aldric_channeling(active)` (switches between `channeling` and `freed`; a no-op while `held`), `aldric_hit()` (resets the current true verse's progress), `set_fourth_verse_available(bool)` (default true).
    - Anselm: `anselm_killed()`.
    - Ticking: `tick(delta)`.
    - Queries: `reversed_verses()`, `true_verses()`, `phase() -> StringName` (`&"ritual"`, `&"aftermath"` or `&"resolved"`), `aldric_state() -> StringName` (`held`, `freed` or `channeling`), `anselm_state() -> StringName` (`human`, `zealot`, `dead` or `fled`), `record() -> FinaleRecord` (null until resolved), `drain_events()`.
  - `FinaleSetup` (static):
    - `bodyguard_count(facts) -> int` = `max(2, 6 - 2*in_party(ally.strept_warband) - 2*has_flag(flag.choir_list_exposed) - 2*has_perk(perk.kingmaker))`.
    - `reversed_factor(facts) -> float` = 1.25 if `in_party(companion.dravin)` and `item_count(item.iron_key) >= 1`, else 1.0.
    - `true_factor(facts) -> float` = 0.8 if `in_party(companion.maelis)` and `rep_tier(faction.abbey) == &"allied"`, else 1.0.
    - `configure(meter, facts) -> void` calls `set_bodyguards`, `apply_modifier(&"gear_brake", ...)`, `apply_true_modifier(&"maelis_channel", ...)` and `set_fourth_verse_available(item_count(item.true_fourth_verse) >= 1)`.
- Tick algorithm (gdd §6.14 rules 1–7 and 9). A simultaneous finish goes to the true verse:

```
remaining = delta
while remaining > 0 and phase == ritual:
    true_running = aldric == channeling and true_verses < 4 and (true_verses < 3 or fourth_available)
    t_r = rev.time_to_next(); t_t = true_running ? tru.time_to_next() : INF
    step = min(remaining, t_r, t_t); remaining -= step
    true_done = true_running and tru.advance(step); rev_done = rev.advance(step)
    if true_done: true_verses += 1; record TrueVerseCompleted; if true_verses == 4: resolve(true, anselm_alive_or_dead, false, false); break
    if rev_done: reversed_verses += 1; record ReversedVerseCompleted
        if reversed_verses == 3 and anselm == human: anselm = zealot; record AnselmTransformed
        if reversed_verses == 4: if anselm == dead: resolve(reversed, dead, false, false) else phase = aftermath
```

Resolving creates the `FinaleRecord`, sets the phase to `resolved` and records `FinaleResolved` last. The anselm mapping is `human`/`zealot` → `alive`, `dead` → `dead`, `fled` → `fled`.

- [ ] **Step 1: Write the failing tests**

```gdscript
## The finale ritual meter (gdd §6.14; Normal T_rev 50 s, T_true 20 s, §6.17).
extends GutTest


func _meter(t_rev := 50.0, t_true := 20.0) -> RitualMeter:
	var m := RitualMeter.new(t_rev, t_true)
	m.set_bodyguards(0)
	return m


func test_reversed_verse_completes_every_t_rev() -> void:
	var m := _meter()
	m.tick(49.5)
	assert_eq(m.reversed_verses(), 0)
	m.tick(0.5)
	assert_eq(m.reversed_verses(), 1)
	assert_eq((m.drain_events()[0] as ReversedVerseCompleted).n, 1)


func test_gear_brake_multiplies_t_rev_once_per_id() -> void:
	var m := _meter()
	m.apply_modifier(&"gear_brake", 1.25)
	m.apply_modifier(&"gear_brake", 1.25)
	m.tick(62.0)
	assert_eq(m.reversed_verses(), 0)
	m.tick(0.5)
	assert_eq(m.reversed_verses(), 1)


func test_anselm_transforms_at_third_reversed_verse() -> void:
	var m := _meter()
	m.tick(150.0)
	assert_eq(m.anselm_state(), &"zealot")
	assert_eq(EventNames.of(m.drain_events()), ["ReversedVerseCompleted", "ReversedVerseCompleted", "ReversedVerseCompleted", "AnselmTransformed"])


func test_anselm_killed_early_never_transforms_and_timer_runs() -> void:
	var m := _meter()
	m.anselm_killed()
	m.tick(150.0)
	assert_eq(m.reversed_verses(), 3)
	assert_eq(m.anselm_state(), &"dead")
	assert_false(EventNames.of(m.drain_events()).has("AnselmTransformed"))


func test_free_aldric_needs_bodyguards_down() -> void:
	var m := RitualMeter.new(50.0, 20.0)
	m.set_bodyguards(2)
	assert_eq(m.free_aldric().error_code, &"bodyguards_remain")
	m.bodyguard_down()
	m.bodyguard_down()
	assert_true(m.free_aldric().is_ok())
	assert_eq(m.aldric_state(), &"channeling")
	assert_eq(m.free_aldric().error_code, &"aldric_not_held")


func test_true_verse_every_t_true_and_pause_keeps_progress() -> void:
	var m := _meter()
	m.free_aldric()
	m.tick(10.0)
	m.set_aldric_channeling(false)
	m.tick(10.0)
	assert_eq(m.true_verses(), 0)
	m.set_aldric_channeling(true)
	m.tick(10.0)
	assert_eq(m.true_verses(), 1)


func test_aldric_hit_resets_current_verse() -> void:
	var m := _meter()
	m.free_aldric()
	m.tick(15.0)
	m.aldric_hit()
	m.tick(15.0)
	assert_eq(m.true_verses(), 0)
	m.tick(5.0)
	assert_eq(m.true_verses(), 1)


func test_true_modifier_shortens_t_true() -> void:
	var m := _meter()
	m.apply_true_modifier(&"maelis_channel", 0.8)
	m.free_aldric()
	m.tick(16.0)
	assert_eq(m.true_verses(), 1)


func test_win_when_fourth_true_before_fourth_reversed() -> void:
	var m := _meter()
	m.free_aldric()
	m.tick(80.0)
	assert_eq([m.true_verses(), m.reversed_verses(), m.phase()], [4, 1, &"resolved"])
	assert_eq([m.record().oath, m.record().anselm, m.record().vault_seized], [&"true", &"alive", false])
	assert_eq(EventNames.of(m.drain_events()).back(), "FinaleResolved")
	m.tick(100.0)
	assert_eq(m.reversed_verses(), 1)


func test_tie_goes_to_true_oath() -> void:
	var m := _meter(20.0, 20.0)
	m.free_aldric()
	m.tick(80.0)
	assert_eq([m.true_verses(), m.reversed_verses(), m.record().oath], [4, 3, &"true"])


func test_loss_enters_aftermath() -> void:
	var m := _meter()
	m.tick(200.0)
	assert_eq([m.reversed_verses(), m.phase()], [4, &"aftermath"])
	assert_null(m.record())


func test_loss_with_anselm_dead_resolves_at_once() -> void:
	var m := _meter()
	m.anselm_killed()
	m.tick(200.0)
	assert_eq(m.phase(), &"resolved")
	assert_eq([m.record().oath, m.record().anselm], [&"reversed", &"dead"])


func test_large_delta_stops_at_fourth_reversed_verse() -> void:
	var m := _meter()
	m.tick(1000.0)
	assert_eq(m.reversed_verses(), 4)
	var n := EventNames.of(m.drain_events()).filter(func(s: String) -> bool: return s == "ReversedVerseCompleted")
	assert_eq(n.size(), 4)


func test_without_fourth_verse_aldric_stops_at_three() -> void:
	var m := _meter()
	m.set_fourth_verse_available(false)
	m.free_aldric()
	m.tick(199.0)
	assert_eq(m.true_verses(), 3)
	m.tick(1.0)
	assert_eq(m.phase(), &"aftermath")
```

```gdscript
## Finale set-up from facts (gdd §6.14 rules 2-4, §6.13).
extends GutTest


func test_bodyguards_base_six_minus_two_each_minimum_two() -> void:
	var f := FakeFactProvider.new()
	assert_eq(FinaleSetup.bodyguard_count(f), 6)
	f.party[&"ally.strept_warband"] = true
	assert_eq(FinaleSetup.bodyguard_count(f), 4)
	f.flags[&"flag.choir_list_exposed"] = true
	f.perks[&"perk.kingmaker"] = true
	assert_eq(FinaleSetup.bodyguard_count(f), 2)


func test_gear_brake_needs_dravin_and_iron_key() -> void:
	var f := FakeFactProvider.new()
	f.party[&"companion.dravin"] = true
	assert_eq(FinaleSetup.reversed_factor(f), 1.0)
	f.items[&"item.iron_key"] = 1
	assert_eq(FinaleSetup.reversed_factor(f), 1.25)


func test_maelis_channel_needs_abbey_allied() -> void:
	var f := FakeFactProvider.new()
	f.party[&"companion.maelis"] = true
	f.rep_tiers[&"faction.abbey"] = &"friendly"
	assert_eq(FinaleSetup.true_factor(f), 1.0)
	f.rep_tiers[&"faction.abbey"] = &"allied"
	assert_almost_eq(FinaleSetup.true_factor(f), 0.8, 0.0001)


func test_configure_applies_everything() -> void:
	var f := FakeFactProvider.new()
	f.items[&"item.true_fourth_verse"] = 1
	var m := RitualMeter.new(50.0, 20.0)
	FinaleSetup.configure(m, f)
	assert_eq(m.bodyguards_remaining(), 6)
	assert_eq(m.free_aldric().error_code, &"bodyguards_remain")
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `tools/test.ps1 -Test tests/unit/finale`
Expected: FAIL with a parse error because `RitualMeter` is not declared.

- [ ] **Step 3: Implement `VerseClock`, `RitualMeter` (the tick algorithm above), `FinaleSetup` and the four events**

- [ ] **Step 4: Run the finale suite, then everything**

Expected: 21 finale tests pass. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/finale game/tests/unit/finale` with the message `feat(finale): RitualMeter verse timers, transformation, win and loss; FinaleSetup`

---

### Task F3: Aftermath, Command the Vault, FinaleChoices

Wave: 4

**Files:**
- Modify: `src/domain/finale/ritual_meter.gd`
- Create: `src/domain/finale/finale_choices.gd`
- Test: `tests/unit/finale/test_finale_choices.gd`

**Interfaces:**
- Consumes: F2.
- Produces:
  - `RitualMeter.choose_aftermath(choice: StringName) -> Result`. `&"pursue"` resolves `(reversed, dead)` and `&"shield"` resolves `(reversed, fled)`. Errors: `&"not_in_aftermath"`, `&"unknown_choice"`.
  - `anselm_killed()` during the aftermath resolves `(reversed, dead)`.
  - `seize_vault(coerced: bool) -> Result`. Errors: `&"ritual_over"`, `&"aldric_not_held"` (Aldric is still held), `&"true_verse_begun"` (`true_verses >= 1`). It resolves `(none, alive or dead, true, coerced)` and stops the reversed timer.
  - `FinaleChoices._init(meter: RitualMeter)`. `can_command_vault(facts) -> bool` is true iff `facts.has_clue(&"clue.vault_command_rite")`, `facts.in_party(&"companion.dravin")`, `meter.phase() == &"ritual"`, `meter.aldric_state() != &"held"` and `meter.true_verses() == 0` (gdd §6.14 rule 8).

- [ ] **Step 1: Write the failing test**

```gdscript
## Aftermath choice and Command the Vault (gdd §6.14 rules 7-8).
extends GutTest


func _meter() -> RitualMeter:
	var m := RitualMeter.new(50.0, 20.0)
	m.set_bodyguards(0)
	return m


func test_pursue_kills_anselm() -> void:
	var m := _meter()
	m.tick(200.0)
	assert_true(m.choose_aftermath(&"pursue").is_ok())
	assert_eq([m.record().oath, m.record().anselm], [&"reversed", &"dead"])


func test_shield_lets_anselm_flee() -> void:
	var m := _meter()
	m.tick(200.0)
	m.choose_aftermath(&"shield")
	assert_eq(m.record().anselm, &"fled")
	assert_eq(m.anselm_state(), &"fled")


func test_aftermath_errors() -> void:
	var m := _meter()
	assert_eq(m.choose_aftermath(&"pursue").error_code, &"not_in_aftermath")
	m.tick(200.0)
	assert_eq(m.choose_aftermath(&"flee").error_code, &"unknown_choice")


func test_killing_anselm_in_aftermath_resolves_dead() -> void:
	var m := _meter()
	m.tick(200.0)
	m.anselm_killed()
	assert_eq(m.record().anselm, &"dead")


func test_seize_vault_resolves_with_coercion() -> void:
	var m := _meter()
	assert_eq(m.seize_vault(false).error_code, &"aldric_not_held")
	m.free_aldric()
	m.tick(10.0)
	assert_true(m.seize_vault(true).is_ok())
	assert_eq([m.record().oath, m.record().vault_seized, m.record().coerced, m.record().anselm], [&"none", true, true, &"alive"])
	m.tick(500.0)
	assert_eq(m.reversed_verses(), 0)


func test_seize_vault_refused_after_first_true_verse() -> void:
	var m := _meter()
	m.free_aldric()
	m.tick(20.0)
	assert_eq(m.seize_vault(false).error_code, &"true_verse_begun")


func test_can_command_vault_needs_rite_dravin_and_window() -> void:
	var m := _meter()
	var f := FakeFactProvider.new()
	var c := FinaleChoices.new(m)
	f.clues[&"clue.vault_command_rite"] = true
	f.party[&"companion.dravin"] = true
	assert_false(c.can_command_vault(f), "Aldric still held")
	m.free_aldric()
	assert_true(c.can_command_vault(f))
	f.party.clear()
	assert_false(c.can_command_vault(f))
	f.party[&"companion.dravin"] = true
	m.tick(20.0)
	assert_false(c.can_command_vault(f), "first true verse done")
```

- [ ] **Step 2: Run the test to verify it fails**

Expected: FAIL with a parse error because `FinaleChoices` is not declared.

- [ ] **Step 3: Implement the three meter methods and `FinaleChoices`**

If `ritual_meter.gd` passes 200 lines, move the resolve and record mapping into `_internal/finale_outcome.gd`.

- [ ] **Step 4: Run the finale suite, then everything**

Expected: 28 finale tests pass. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/finale game/tests/unit/finale/test_finale_choices.gd` with the message `feat(finale): aftermath choice, Command the Vault and FinaleChoices`

---

### Task E1: Ending resolver

Wave: 2

**Files:**
- Create in `src/domain/endings/`: `ending_facts.gd`, `ending_rule.gd`, `ending_resolver.gd`, `events/ending_resolved.gd`, `_internal/ending_fact_provider.gd`
- Test: `tests/unit/endings/test_ending_resolver.gd`

**Interfaces:**
- Consumes: `Condition`, `FactProvider`, `Result`; S0 `RuleFixtures`, `EventNames`; P1 `FakeFactProvider`.
- Produces:
  - `EndingFacts._init(queen_alive: bool, oath: StringName, anselm: StringName, vault_seized: bool)` asserts that `oath` is `true`, `reversed` or `none` and that `anselm` is `alive`, `dead` or `fled`. `is_consistent() -> bool` is true for `vault_seized and oath == none`, for `not vault_seized and oath == true`, and for `not vault_seized and oath == reversed and anselm != alive`. The gdd §6.14 outcomes produce no other combination.
  - `_internal/EndingFactProvider extends FactProvider` wraps an `EndingFacts`. `has_flag(&"flag.queen_alive")` returns `queen_alive`. `finale_value(FactProvider.FINALE_OATH)` returns `oath`, `finale_value(FactProvider.FINALE_ANSELM)` returns `anselm`, and `finale_value(FactProvider.FINALE_SEIZED)` returns `&"true"` or `&"false"`. Every other method, including `visited`, `rumor_heard` and `queen_condition`, returns false, 0 or `&""`.
  - `EndingRule._init(id: StringName, priority: int, condition: Condition)`, `matches(facts: EndingFacts) -> bool`.
  - `EndingResolved(ending_id)`.
  - `EndingResolver._init(rules: Array[EndingRule])` sorts by priority ascending (ties by id) and asserts unique ids. `resolve(f) -> Result` returns ok with the first matching id and records `EndingResolved`, or `&"no_ending_matches"` with no event. `all_ids() -> Array[StringName]` is in priority order. `drain_events()`.

- [ ] **Step 1: Write the failing test**

```gdscript
## Ending resolver, first match wins (gdd §6.15).
extends GutTest

const IDS: Array[StringName] = [&"ending.bitter_bargain", &"ending.shattered_lock", &"ending.ashes_and_iron", &"ending.lion_holds", &"ending.boy_king"]


func _gdd_rules() -> Array[EndingRule]:
	# Deliberately out of priority order.
	return [
		EndingRule.new(&"ending.boy_king", 5, RuleFixtures.cond("finale_oath() == true and not flag(flag.queen_alive)")),
		EndingRule.new(&"ending.bitter_bargain", 1, RuleFixtures.cond("finale_seized()")),
		EndingRule.new(&"ending.lion_holds", 4, RuleFixtures.cond("finale_oath() == true and flag(flag.queen_alive)")),
		EndingRule.new(&"ending.shattered_lock", 2, RuleFixtures.cond("finale_oath() == reversed and finale_anselm() == dead")),
		EndingRule.new(&"ending.ashes_and_iron", 3, RuleFixtures.cond("finale_oath() == reversed and finale_anselm() == fled")),
	]


func _expected(f: EndingFacts) -> StringName:
	if f.vault_seized:
		return &"ending.bitter_bargain"
	if f.oath == &"reversed":
		return &"ending.shattered_lock" if f.anselm == &"dead" else &"ending.ashes_and_iron"
	return &"ending.lion_holds" if f.queen_alive else &"ending.boy_king"


func test_each_gdd_row() -> void:
	var r := EndingResolver.new(_gdd_rules())
	assert_eq(r.resolve(EndingFacts.new(true, &"none", &"alive", true)).value, &"ending.bitter_bargain")
	assert_eq(r.resolve(EndingFacts.new(true, &"reversed", &"dead", false)).value, &"ending.shattered_lock")
	assert_eq(r.resolve(EndingFacts.new(false, &"reversed", &"fled", false)).value, &"ending.ashes_and_iron")
	assert_eq(r.resolve(EndingFacts.new(true, &"true", &"alive", false)).value, &"ending.lion_holds")
	assert_eq(r.resolve(EndingFacts.new(false, &"true", &"dead", false)).value, &"ending.boy_king")


func test_exhaustive_product_every_ending_reachable_and_exclusive() -> void:
	var rules := _gdd_rules()
	var r := EndingResolver.new(rules)
	var produced: Dictionary[StringName, bool] = {}
	for queen: bool in [true, false]:
		for oath: StringName in [&"true", &"reversed", &"none"]:
			for anselm: StringName in [&"alive", &"dead", &"fled"]:
				for seized: bool in [true, false]:
					var f := EndingFacts.new(queen, oath, anselm, seized)
					var res := r.resolve(f)
					if not f.is_consistent():
						continue
					assert_true(res.is_ok(), "no ending for %s" % [[queen, oath, anselm, seized]])
					assert_eq(res.value, _expected(f))
					produced[res.value] = true
					var hits := rules.filter(func(rule: EndingRule) -> bool: return rule.matches(f))
					assert_eq(hits.size(), 1, "rules overlap for %s" % [[queen, oath, anselm, seized]])
	assert_eq(produced.size(), 5)


func test_priority_first_match_wins() -> void:
	var r := EndingResolver.new(_gdd_rules())
	assert_eq(r.resolve(EndingFacts.new(true, &"true", &"alive", true)).value, &"ending.bitter_bargain")


func test_no_match_is_error_without_event() -> void:
	var r := EndingResolver.new(_gdd_rules())
	var res := r.resolve(EndingFacts.new(true, &"none", &"alive", false))
	assert_eq(res.error_code, &"no_ending_matches")
	assert_eq(r.drain_events().size(), 0)


func test_resolve_records_event_and_ids_in_priority_order() -> void:
	var r := EndingResolver.new(_gdd_rules())
	r.resolve(EndingFacts.new(true, &"true", &"alive", false))
	assert_eq((r.drain_events()[0] as EndingResolved).ending_id, &"ending.lion_holds")
	assert_eq(r.all_ids(), IDS)
```

- [ ] **Step 2: Run the test to verify it fails**

Expected: FAIL with a parse error because `EndingRule` is not declared.

- [ ] **Step 3: Implement the five classes**

`EndingFactProvider` copies every abstract method signature from `src/domain/rules/fact_provider.gd`.

- [ ] **Step 4: Run the test, then everything**

Expected: `Passing Tests 5`. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/endings game/tests/unit/endings` with the message `feat(endings): EndingFacts, EndingRule and EndingResolver`

---

### Task E2: Epilogue selection

Wave: 2

**Files:**
- Create: `src/domain/endings/epilogue_definition.gd`, `src/domain/endings/epilogue_selector.gd`
- Test: `tests/unit/endings/test_epilogue_selector.gd`

**Interfaces:**
- Consumes: `Condition`, `FactProvider`; S0 `RuleFixtures`, `EventNames`; P1 `FakeFactProvider`.
- Produces: `EpilogueDefinition._init(id: StringName, ending_ids: Array[StringName], condition: Condition, order: int)`, `with_text(String)`. An empty `ending_ids` applies to every ending. `EpilogueSelector.select(ending_id, facts, defs: Array[EpilogueDefinition]) -> Array[StringName]` (static) returns the ids of the defs that apply to the ending and whose condition is null or true, sorted by `order` and then by id.

- [ ] **Step 1: Write the failing test**

```gdscript
## Epilogue variants chosen by extra flags (gdd §6.15 "Epilogue variants").
extends GutTest


func _defs() -> Array[EpilogueDefinition]:
	return [
		EpilogueDefinition.new(&"epilogue.maelis_alive", [] as Array[StringName], RuleFixtures.cond("in_party(companion.maelis)"), 20),
		EpilogueDefinition.new(&"epilogue.strept_peace", [] as Array[StringName], RuleFixtures.cond("rep_tier(faction.strept) >= friendly"), 10),
		EpilogueDefinition.new(&"epilogue.coerced_heir", [&"ending.bitter_bargain"] as Array[StringName], RuleFixtures.cond("flag(flag.aldric_coerced)"), 5),
		EpilogueDefinition.new(&"epilogue.lion_court", [&"ending.lion_holds"] as Array[StringName], null, 1),
	]


func test_filters_by_ending_and_condition_sorted_by_order() -> void:
	var f := FakeFactProvider.new()
	f.rep_tiers[&"faction.strept"] = &"friendly"
	f.party[&"companion.maelis"] = true
	assert_eq(EpilogueSelector.select(&"ending.lion_holds", f, _defs()), [&"epilogue.lion_court", &"epilogue.strept_peace", &"epilogue.maelis_alive"] as Array[StringName])


func test_ending_specific_variant_needs_its_flag() -> void:
	var f := FakeFactProvider.new()
	assert_eq(EpilogueSelector.select(&"ending.bitter_bargain", f, _defs()).size(), 0)
	f.flags[&"flag.aldric_coerced"] = true
	assert_eq(EpilogueSelector.select(&"ending.bitter_bargain", f, _defs()), [&"epilogue.coerced_heir"] as Array[StringName])
```

- [ ] **Step 2: Run the test to verify it fails**

Expected: FAIL with a parse error because `EpilogueDefinition` is not declared.

- [ ] **Step 3: Implement both classes**

- [ ] **Step 4: Run the test, then everything**

Expected: `Passing Tests 2`. The full suite passes with exit 0.

- [ ] **Step 5: Commit (orchestrator)**

`git add game/src/domain/endings/epilogue_definition.gd game/src/domain/endings/epilogue_selector.gd game/tests/unit/endings/test_epilogue_selector.gd` with the message `feat(endings): epilogue definitions and selector`

---

## Coverage map

| Spec section | Tasks |
|---|---|
| architecture §3.1 (outbox events), §11 (standards) | every task; the event classes in Q2, I1, I2, D4, D5, C1, C2, T1, T4, F2, E1 |
| architecture §4.5 `quests`; gdd §6.11 quest model; content-format §F.7 | Q1, Q2, Q3 |
| architecture §4.6 `investigation`; gdd §6.11 board; content-format §F.6 | I1, I2 |
| architecture §4.7 `dialogue`; gdd §6.10; content-format §D, §F.3 | D1, D2, D3, D4, D5 |
| architecture §4.16 `companions`; gdd §6.13 (and the Maelis death of §6.2) | C1, C2 |
| architecture §4.15 `travel`; gdd §6.3 map, passability, routing | T1, T2 |
| gdd §6.3 encounter check, d8, escalation rule, rerolls; §6.1 stage 4 tables | T3, T4 |
| architecture §4.9 `finale`; gdd §6.14 rules 1–9; §6.17 timings | F1, F2, F3 |
| architecture §4.10 `endings`; gdd §6.15 resolver and epilogues | E1, E2 |
| gdd §6.16 save (domain sections) | Q3, I2, D3, C2, T1, F1 |
| architecture §9.6 deterministic tests | S0, plus P1's `ScriptedRandom` and `SeededRandom` in T4 |

## Known gaps (left to other plans or content)

- `event_card` resolution (content-format §F.9) has no domain owner in architecture §4. `ResolveEventCardUseCase` (P3) can evaluate cards with `CheckResolver` and the same Haggler bribe rule (`roundi(base * 0.7)`).
- gdd §6.1 stage 2, "Drowner encounters ×2 weight on valley tables", does not fit a uniform d8. It needs a design or content decision (for example, a second drowner slot in the stage-2 valley table data).
- gdd §6.3 names `companion.forest_guide`, but §6.13 defines `ally.forest_guide`. This plan uses `ally.forest_guide`.
- The pathfinder perk's "once per journey, Wits 5 to avoid a hostile encounter" is an application step after the roll.
- `epilogue.*` is not a kind in `IdRules.KINDS`. Content and P3 must add it or choose another prefix.
