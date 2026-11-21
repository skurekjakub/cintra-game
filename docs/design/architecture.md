# The Lion's Shadow — Software Architecture

Status: v1 (A02, 2026-11-21). Engine: Godot 4.7.2 standard build, statically typed GDScript (D2, C6).
Read this with `gdd.md` (rules) and `content-format.md` (content authoring). **There is no calendar or time system** (C5 revoked). Escalation is milestone-driven (`gdd.md` §6.1).

---

## 1. Goals and constraints

- **Testable core.** All game rules live in plain `RefCounted` classes with no scene tree access. They are unit-tested headless with GUT.
- **Loose coupling.** Bounded domains talk only through public classes and events. One domain never reaches into another's internals.
- **Data-driven content.** Every story fact (items, dialogue, quests, zones, encounters, endings) is a JSON data file with a stable string id, validated by tests.
- **Art-agnostic.** The domain and application layers know nothing about 2D vs 3D, the camera, or the look. The art pick (D3) plugs in only under `presentation/` and `assets/`.
- **Small files, one responsibility each.** SOLID, adapted to GDScript (§11).

## 2. Layers and the dependency rule

```
presentation  ──►  application  ──►  domain
      │                 ▲
      └──► infrastructure ┘   (infrastructure implements application ports)
```

| Layer | Path | Contains | May depend on | Must not |
|---|---|---|---|---|
| **domain** | `res://src/domain/<domain>/` | Entities, value objects, rules, definitions (parsed content types), domain events | `domain/shared`, `domain/rules`, Godot core value types (`String`, `StringName`, `Array`, `Dictionary`, `RefCounted`, `RandomNumberGenerator` through a wrapper) | Use `Node`, `SceneTree`, `Input`, `FileAccess`, `DirAccess`, `ResourceLoader`, `JSON`, autoloads, signals to the UI, or any other domain's `_internal/` |
| **application** | `res://src/application/` | Use cases, policies (event handlers that coordinate domains), the event bus, `GameSession`, ports (abstract interfaces), read-model queries | domain | Use the scene tree, file APIs, or concrete infrastructure classes |
| **infrastructure** | `res://src/infrastructure/` | JSON content loader, schema validator, save-file repository, settings store, Godot adapters | application (ports), domain (definitions) | Reference presentation |
| **presentation** | `res://src/presentation/` | Scenes, nodes, UI, input, camera, VFX, audio, the composition root | everything above | Hold game rules. Presentation decides *how things look*, never *what is true* |

**Enforcement:** `tests/architecture/test_dependency_rule.gd` scans `src/`. It maps every `class_name` to its layer and domain, then fails if any file references a class from an outer layer or from another domain's `_internal/` folder. It also fails if a domain file contains `extends Node`, `get_tree(`, `FileAccess`, `DirAccess`, `Input.`, or `Services`, or if any `src/` file is longer than 300 lines.

**Godot project location:** the Godot project lives in `game/` at the repo root (`res://` = `game/`), keeping docs and tools outside the import scan. Every command below uses `--path game`.

---

## 3. Cross-cutting design

### 3.1 Domain events

`DomainEvent` (`src/domain/shared/domain_event.gd`) is an abstract `RefCounted` base class. Each event is its own small class (`class_name MilestoneReached extends DomainEvent`) with typed, read-only-by-convention fields set in `_init`.

**Domain objects never publish.** A domain aggregate records events in an outbox (`_events: Array[DomainEvent]`) and exposes `drain_events() -> Array[DomainEvent]`. Use cases call domain methods, drain the outbox, and publish to the bus. This keeps the domain free of the bus and keeps event order deterministic.

### 3.2 Event bus (typed)

`EventBus` (`src/application/bus/event_bus.gd`, `RefCounted`) is a mediator keyed by event **class** (the `Script` object), not by strings:

```gdscript
class_name EventBus extends RefCounted
func subscribe(event_type: Script, handler: Callable) -> BusSubscription
func publish(event: DomainEvent) -> void          # synchronous, FIFO
func publish_all(events: Array[DomainEvent]) -> void
```

- Usage: `bus.subscribe(MilestoneReached, _on_milestone)`. The handler casts: `var e := event as MilestoneReached`.
- **Re-entrancy:** events published while handlers are running are queued and delivered after the current event finishes (FIFO). This avoids recursive ordering bugs. One `publish` call drains the whole queue. A cap of 1,000 deliveries per drain catches cycles with an assertion.
- `BusSubscription.dispose()` unsubscribes. Presentation nodes dispose in `_exit_tree()`.
- After every use case, the use case publishes `FactsChanged` once. Condition-driven policies (quests, deductions, map unlocks, act gates) listen to this single event instead of to every fine-grained event.

**Presentation bridge:** `EventBridge` (`src/presentation/bootstrap/event_bridge.gd`, a `Node` child of `Main`) subscribes to the bus and re-emits typed Godot signals for UI nodes (`signal quest_updated(quest_id: StringName)`, …). UI never subscribes to the domain directly. It either connects to the bridge's signals or subscribes through the bridge's `subscribe(event_type, handler, owner_node)`, which auto-disposes when the owner leaves the tree.

### 3.3 Dependency injection and the composition root

- **Constructor injection** for `RefCounted` classes: every dependency is passed to `_init(...)`. No class creates its own collaborators except value objects.
- **Composition root:** `src/presentation/bootstrap/main.gd` (on `Main.tscn`, the main scene) calls `GameComposer.compose(config) -> GameContext`. `GameComposer` is the only class that names concrete infrastructure classes. It builds the content source, loads the content database, the save repository, the settings store, the event bus, the `GameSession`, the use cases, the queries and the policies. `GameContext` is a plain holder with typed fields for all use cases and queries.
- **Scenes:** Godot instantiates scenes itself, so nodes cannot take constructor arguments. Every scene root that needs services implements `setup(ctx: GameContext) -> void`. `ZoneLoader` calls it immediately after instantiation, before `add_child`. Child nodes get their dependencies from their scene root through explicit `setup` calls, not by lookups.

**The one autoload (`Services`).** `src/presentation/bootstrap/services.gd` is registered as the autoload `Services`. It holds only `var context: GameContext` and `func ready() -> bool`. It is justified for one reason: running a single scene from the editor (F6) or the Godot AI plugin bypasses `Main`. In that case a scene root's `_ready()` falls back to `Services.context`, or calls `Services.bootstrap_for_debug()`, which composes a throwaway context with test content.

Rules:
- Only `presentation/` may read `Services`. The architecture test enforces this.
- `Services` is read in scene-root `_ready()` fallbacks only, never in gameplay code paths.
- `Services` contains no state beyond the context reference.

### 3.4 Conditions and effects (shared rules engine)

Content uses one condition language and one effect list everywhere (dialogue, quests, encounters, map edges, escalation stages, endings). The grammar is in `content-format.md` §C and §E.

- `domain/rules` parses and evaluates conditions against an abstract `FactProvider`. It knows nothing about the domains that supply the facts.
- `application/session/session_fact_provider.gd` implements `FactProvider` by reading the `GameSession` aggregates.
- Effects are parsed into `EffectSpec` values (`op` plus typed `args`). `application/effects/effect_dispatcher.gd` holds a registry `Dictionary[StringName, EffectHandler]`. Adding an effect means adding a handler class and registering it in `GameComposer` (open/closed: the dispatcher itself does not change).

---

## 4. Bounded domains

Conventions for every domain:
- The public classes sit at the domain root. Helpers sit in `_internal/` and may only be referenced inside the same domain.
- Definitions (`*Definition`) are immutable parsed content types owned by the domain. Infrastructure builds them, and the domain uses them.
- Aggregates that hold saved state implement `Snapshotable` (`to_snapshot() -> Dictionary`, `restore(data: Dictionary) -> void`).
- "Consumes" lists what the application reacts to on the domain's behalf. Domains never subscribe to anything themselves.

### 4.1 `shared` (shared kernel)

- **Responsibility:** primitives used by all domains.
- **API:** `DomainEvent` (abstract), `Result` (`ok(value)`, `err(code: StringName, detail := "")`, `is_ok()`, `value`, `error_code`), `RandomSource` (abstract: `randi_range(a, b) -> int`, `randf() -> float`, `get_state() -> Dictionary`, `set_state(d)`), `SeededRandom extends RandomSource` (wraps `RandomNumberGenerator`), `IdRules` (`static func kind_of(id: StringName) -> StringName`, `static func is_valid(id, kind) -> bool`), `Snapshotable` (abstract).
- **Emits / consumes:** none.
- **Must not know:** any specific game concept.

### 4.2 `rules` (conditions and effect specs)

- **Responsibility:** parse and evaluate the condition language, and parse effect specs. It does not apply effects.
- **API:** `ConditionParser.parse(text: String) -> Result` (holds a `Condition`), `Condition` (abstract: `evaluate(facts: FactProvider) -> bool`, `referenced_ids() -> Array[StringName]`), with AST nodes `AndCondition`, `OrCondition`, `NotCondition`, `CompareCondition`, `CallCondition` in `_internal/`. `FactProvider` is abstract, read-only, with 27 methods, each id parameter a `StringName`: `has_flag`, `get_var`, `has_milestone`, `item_count`, `has_clue`, `has_deduction`, `quest_status`, `quest_stage`, `attribute`, `check_total(skill)`, `reputation`, `rep_tier`, `escalation_stage`, `act`, `in_party`, `has_perk`, `crowns`, `level`, `finale_value(key)`, `visited(zone_id)`, `rumor_heard(rumor_id)`, `queen_condition`, `is_equipped(item_id)`, `is_disguised`, `heard_from(rumor_id, npc_id)`, `map_unlocked(map_id)`, `map_pinned(map_id)`. Also `EffectParser.parse(text: String) -> Result` (holds an `EffectSpec` with `op: StringName`, `args: Array`, `referenced_ids()`), and `EffectSignatures` (the table of valid ops and argument types, used by the parser and by content tests).
- **Emits / consumes:** none.
- **Must not know:** how facts are stored, or what any effect does.

### 4.3 `world_state`

- **Responsibility:** global story facts: boolean flags (`flag.*`), integer variables (`var.*`), write-once milestones (`ms.*`), and the current act.
- **API:** `WorldState` with `set_flag(id, value := true)`, `has_flag(id) -> bool`, `set_var(id, value: int)`, `add_var(id, delta: int)`, `get_var(id) -> int`, `reach_milestone(id) -> bool` (false if already reached), `has_milestone(id)`, `milestones() -> Array[StringName]`, `count_milestones(ids: Array[StringName]) -> int`, `set_act(n: int)`, `act() -> int`, `drain_events()`. Implements `Snapshotable`.
- **Emits:** `FlagChanged(id, value)`, `VarChanged(id, old, new)`, `MilestoneReached(id)`, `ActChanged(old, new)`.
- **Consumes:** set by effects (`set_flag`, `set_var`, `add_var`, `reach_milestone`, `set_act`).
- **Must not know:** what any flag means, quests, escalation.

### 4.4 `escalation` (replaces the removed `calendar`)

- **Responsibility:** the escalation stage (0–4) derived from milestones, the one-time stage-entry effect lists, and the Queen's condition.
- **API:** `EscalationTrack` (`_init(rules: EscalationRules)`, `recompute(facts: FactProvider) -> int` which raises the stage to the highest stage whose condition holds and never lowers it, `stage() -> int`, `pending_stage_entries() -> Array[EscalationStageDefinition]` with each stage's entry effects returned exactly once, `mark_entry_applied(stage)`), `EscalationRules` (an ordered `Array[EscalationStageDefinition]` holding `stage`, `condition: Condition`, `on_enter: Array[EffectSpec]`, `card_text`). Also `QueenCondition` (`_init()`, `recompute(stage: int, mitigations: int) -> void`, `administer_antidote() -> void` which freezes the condition, `improve_on_milestone() -> void`, `condition() -> int` (0–3), `antidote_administered() -> bool`, `resolve_survival() -> bool`). Both implement `Snapshotable`.
- **Emits:** `EscalationStageChanged(old, new)`, `QueenConditionChanged(old, new)`, `AntidoteAdministered()`.
- **Consumes (via `EscalationPolicy` and `QueenPolicy`):** `FactsChanged`, `MilestoneReached`, `FlagChanged(flag.chalice_secured | flag.food_taster_exposed)`.
- **Must not know:** quests, travel, the UI, any notion of time.

### 4.5 `quests`

- **Responsibility:** quest definitions, quest state machines, objectives, journal entries.
- **API:** `QuestDefinition` (`id`, `kind` main/side, `stages: Array[QuestStageDefinition]`, `closes_on: Condition`), `QuestStageDefinition` (`id`, `objectives: Array[ObjectiveDefinition]`, `next: Array[StageTransition]`, `on_complete: Array[EffectSpec]`, `journal_text`), `ObjectiveDefinition` (`id`, `text`, `condition`, `optional`, `xp`). Also `QuestLog` (`start(def) -> Result`, `evaluate(facts: FactProvider) -> void` which completes objectives whose conditions hold and advances stages with a fixed-point cap of 8, `fail(id)`, `status(id) -> StringName`, `current_stage(id) -> StringName`, `active() -> Array[StringName]`, `pending_effects() -> Array[EffectSpec]` which the application then applies, `drain_events()`), and `JournalEntry` (a value). Implements `Snapshotable`.
- **Emits:** `QuestStarted`, `ObjectiveCompleted`, `QuestStageAdvanced`, `QuestCompleted`, `QuestFailed`, `QuestClosed`.
- **Consumes (via `QuestProgressPolicy`):** `FactsChanged`.
- **Must not know:** dialogue, inventory internals, presentation. It sees the world only through `FactProvider`.

### 4.6 `investigation`

- **Responsibility:** clues, theories, suspects, deductions (the investigation board).
- **API:** `ClueDefinition` (`id`, `theory_id`, `supports: Array[StringName]`, `refutes: Array[StringName]`, `text`, `xp`), `DeductionDefinition` (`id`, `theory_id`, `condition`, `text`, `xp`), `TheoryDefinition`. Also `ClueBoard` (`add_clue(id) -> bool`, `has_clue(id)`, `evaluate_deductions(facts) -> void`, `has_deduction(id)`, `suspect_standing(theory_id, suspect_id) -> int` (supports minus refutes), `clues_for(theory_id)`, `drain_events()`). Implements `Snapshotable`.
- **Emits:** `ClueDiscovered(id)`, `DeductionUnlocked(id)`.
- **Consumes (via `DeductionPolicy`):** `FactsChanged`.
- **Must not know:** quests, dialogue, items (an item-based condition goes through `FactProvider`).

### 4.7 `dialogue`

- **Responsibility:** running a dialogue graph: node traversal, option visibility, deterministic checks, the once-per-conversation lockouts.
- **API:** `DialogueDefinition` (`id`, `start_node`, `nodes: Dictionary[StringName, DialogueNodeDefinition]`), node definition types in `_internal/` (`LineNode`, `ChoiceNode`, `CheckNode`, `BranchNode`, `EffectNode`, `EndNode`), and `DialogueOption` (`id`, `text`, `condition`, `tag`, `check`, `show_locked`, `once`, `effects`, `next`). Also `DialogueRunner` (`_init(def, facts: FactProvider)`, `start() -> DialogueView`, `choose(option_id) -> DialogueView`, `advance() -> DialogueView`, `is_finished() -> bool`, `pending_effects() -> Array[EffectSpec]`, `drain_events()`), `DialogueView` (an immutable DTO: speaker, text, options with `enabled` and `requirement_text`), and `CheckResolver.resolve(check: CheckSpec, facts) -> bool` where `total = facts.check_total(skill) + rep_mod >= dc`. `DialogueMemory` holds options locked with `once` across conversations and implements `Snapshotable`.
- **Emits:** `DialogueStarted(id)`, `DialogueNodeEntered(dialogue_id, node_id)`, `CheckResolved(skill, dc, passed)`, `DialogueEnded(id, end_node)`.
- **Consumes:** none (it is driven by use cases).
- **Must not know:** how effects are applied, the UI, voice or audio, combat.

### 4.8 `combat`

- **Responsibility:** real-time combat rules as pure state machines and formulas: the action state machine, stamina, poise, status effects, damage, attack tokens, enemy decision-making, yielding, encounter completion.
- **API:**
  - `CombatProfile` (a value: max HP, armor, poise, resist table, tags, governing attribute value, difficulty multipliers).
  - `AttackDefinition` (id, mult, poise, damage type, stamina, timings, status buildup), `WeaponProfile` (base, type, block_pct, armor_pen, bonus_vs).
  - `Combatant` (`_init(id, profile)`, `tick(delta: float)`, `try_start(action: StringName) -> bool`, `state() -> StringName`, `health() -> HealthPool`, `stamina() -> StaminaPool`, `poise() -> PoiseMeter`, `statuses() -> StatusSet`, `drain_events()`).
  - `ActionStateMachine` (a data-driven transition table, `can_enter(action)`, `enter(action)`, `tick(delta)`, `parry_window_open()`).
  - `DamageCalculator.resolve(hit: HitContext) -> HitResult` (static, the formula from `gdd.md` §6.4).
  - `AttackTokenPool` (`request(enemy_id) -> bool`, `release(enemy_id)`, `capacity`).
  - `EnemyBrain` (`_init(behavior: EnemyBehaviorDefinition, rng: RandomSource)`, `decide(p: PerceptionSnapshot) -> EnemyIntent` (approach, attack, circle, retreat, block, ranged, special, yield)).
  - `CombatEncounter` (`_init(def: EncounterDefinition)`, `register(combatant)`, `on_defeated(id)`, `is_complete() -> bool`, `outcome() -> StringName` (won, yielded, fled), `xp_awarded() -> int`).
  - `EnemyDefinition`, `EncounterDefinition`.
- **Emits:** `DamageApplied(attacker, target, amount, type, crit)`, `HitBlocked`, `HitParried`, `CombatantStaggered`, `GuardBroken`, `StatusApplied`, `CombatantDowned`, `CombatantDefeated(id, enemy_def_id, how)`, `EnemyYielded`, `EncounterCompleted(id, outcome)`.
- **Consumes:** driven by `ResolveHitUseCase` and by presentation ticks through `CombatantComponent`.
- **Must not know:** physics, hitboxes, animation names, 2D vs 3D, attributes (the application maps the actor sheet to a `CombatProfile`), XP rules.

### 4.9 `finale`

- **Responsibility:** the real-time ritual meter of the Lock Chamber fight and the record of the finale's outcome. This is the only gameplay timer in the game.
- **API:** `RitualMeter` (`_init(t_rev: float, t_true: float)`, `apply_modifier(id: StringName, factor: float)`, `tick(delta)`, `free_aldric() -> Result`, `aldric_hit()` (resets the current verse's progress), `set_aldric_channeling(active: bool)`, `reversed_verses() -> int`, `true_verses() -> int`, `phase() -> StringName`, `drain_events()`), `FinaleRecord` (`oath: StringName` (true/reversed/none), `anselm: StringName` (alive/dead/fled), `vault_seized: bool`, `coerced: bool`, `is_resolved()`), `FinaleChoices` (`can_command_vault(facts) -> bool`).
- **Emits:** `ReversedVerseCompleted(n)`, `TrueVerseCompleted(n)`, `AnselmTransformed`, `FinaleResolved(record)`.
- **Must not know:** endings (it only produces the record), the HUD.

### 4.10 `endings`

- **Responsibility:** the pure ending resolver and the selection of epilogue slides.
- **API:** `EndingFacts` (a value: `queen_alive`, `oath`, `anselm`, `vault_seized`, plus extra epilogue flags), `EndingRule` (id, priority, `matches(facts) -> bool`), `EndingResolver` (`_init(rules: Array[EndingRule])`, `resolve(f: EndingFacts) -> Result` which returns an error if no rule matches, `all_ids()`), `EpilogueSelector.select(ending_id, facts: FactProvider, defs) -> Array[StringName]`.
- **Emits:** `EndingResolved(id)`.
- **Must not know:** how the facts came about, presentation.

### 4.11 `actors` (stats)

- **Responsibility:** the player's attributes, derived stats, current HP and stamina outside combat, and check totals for dialogue.
- **API:** `Attributes` (a value with 5 ints, `with_point(attr) -> Attributes`), `ActorSheet` (`_init(attrs, level_provider: Callable)`, `max_hp()`, `max_stamina()`, `melee_mod()`, `ranged_mod()`, `resist(type)`, `current_hp()`, `heal(n)`, `damage(n)`, `full_restore()`, `spend_attribute_point(attr) -> Result`, `unspent_attribute_points()`), `CheckTotals.compute(skill, sheet, perks: Array[StringName], items: Array[StringName]) -> int`. Implements `Snapshotable`.
- **Emits:** `AttributeIncreased`, `ActorHealed`, `ActorDamaged` (outside combat, from hazards).
- **Must not know:** combat state machines, XP, the UI.

### 4.12 `inventory`

- **Responsibility:** item stacks, equipment slots, quick slots, crowns, shop transactions.
- **API:** `ItemDefinition` (id, category, stack_max, price, equip_slot, weapon or armor or consumable payload, tags such as `key`/`document`), `Inventory` (`add(id, n := 1) -> Result`, `remove(id, n := 1) -> Result`, `count(id) -> int`, `has(id) -> bool`, `items_in(category)`), `Equipment` (`equip(slot, id) -> Result`, `unequip(slot)`, `equipped(slot) -> StringName`), `QuickSlots`, `Wallet` (`add(n)`, `spend(n) -> Result`, `balance()`), `Shop` (`buy(item_id, price_mod: float) -> Result`, `sell(item_id) -> Result`). Key and document items refuse `remove` unless `force := true` is passed (used only by scripted effects). All implement `Snapshotable`.
- **Emits:** `ItemAdded`, `ItemRemoved`, `ItemEquipped`, `ItemUnequipped`, `CrownsChanged`.
- **Must not know:** quests, dialogue, combat formulas (it exposes weapon profiles as data only).

### 4.13 `progression`

- **Responsibility:** XP, levels, the skill tree and perks.
- **API:** `LevelTable` (`xp_for(level) -> int`, `level_for(xp) -> int`, cap 12), `ExperienceTrack` (`grant(amount, source: StringName) -> void`, `xp()`, `level()`, `unspent_skill_points()`, `attribute_points_earned()`), `SkillTreeDefinition`, `SkillTree` (`can_unlock(perk_id) -> Result`, `unlock(perk_id) -> Result`, `has(perk_id)`, `points_in(branch)`). Implements `Snapshotable`.
- **Emits:** `XpGained(amount, source)`, `LevelGained(new_level)`, `PerkUnlocked(id)`.
- **Consumes (via `XpPolicy`):** `QuestCompleted`, `ObjectiveCompleted`, `ClueDiscovered`, `DeductionUnlocked`, `CheckResolved(passed)`, `CombatantDefeated`, `EnemyYielded`, `ZoneFirstVisited`.
- **Must not know:** what perks do. Effects of perks are read by other code through `FactProvider.has_perk` or by the application mappers.

### 4.14 `factions`

- **Responsibility:** reputation values and tiers.
- **API:** `FactionDefinition` (id, name, start, tier thresholds), `ReputationLedger` (`add(faction_id, delta: int) -> void` which clamps to ±100, `value(id) -> int`, `tier(id) -> StringName`, `rep_mod(id) -> int`). Implements `Snapshotable`.
- **Emits:** `ReputationChanged(id, old, new)`, `ReputationTierChanged(id, old_tier, new_tier)`.
- **Must not know:** quests, dialogue, the consequences of each tier (those are content conditions).

### 4.15 `travel`

- **Responsibility:** the map graph, unlocking nodes, passable edges, deterministic routing, encounter rolls by terrain, the escalation encounter rule.
- **API:** `TravelGraph` (`_init(nodes: Array[MapNodeDefinition], edges: Array[MapEdgeDefinition])`, `neighbors(node)`), `TravelState` (`current_node()`, `unlock(node_id)`, `is_unlocked(node_id)`, `move_to(node_id)`, `previous_encounter()`; Snapshotable), `RoutePlanner.plan(graph, state, from, to, facts: FactProvider) -> Result` (a `Route` with edges, the majority terrain and any forced hazards), `EncounterTableDefinition` (per terrain: 8 entries plus an escalation pool), `EncounterRoller` (`_init(tables, rng: RandomSource)`, `roll(route: Route, facts: FactProvider, escalation_stage: int, modifiers: EncounterModifiers) -> EncounterResult`, which applies the chance formula, the d8, the stage ≥ 2 d6 replacement, and the requirement and repeat rerolls).
- **Emits:** `NodeUnlocked(id)`, `JourneyStarted(from, to)`, `EncounterRolled(result)`, `JourneyCompleted(to)`.
- **Consumes (via `MapUnlockPolicy`):** `FactsChanged`.
- **Must not know:** the scenes for arenas, combat, the UI.

### 4.16 `companions`

- **Responsibility:** party membership (one combat companion plus scripted allies), downed and retreated state, companion field abilities as data.
- **API:** `CompanionDefinition`, `Party` (`recruit(id) -> Result`, `dismiss(id)`, `active_companion() -> StringName`, `has(id) -> bool`, `set_downed(id)`, `revive(id)`, `retreat(id)`, `reset_for_zone()`, `kill_scripted(id)`), `CompanionCommand` (an enum: follow, hold, focus). Implements `Snapshotable`.
- **Emits:** `CompanionJoined`, `CompanionLeft`, `CompanionDowned`, `CompanionRevived`, `CompanionDied`.
- **Must not know:** AI movement (presentation), quest logic.

### 4.17 `rumors`

- **Responsibility:** the tavern rumor pool, heard and verified state.
- **API:** `RumorDefinition` (id, text, truth (true/false/half/cover), sources, `on_hear` effects, `available` condition), `RumorPool` (`_init(defs, rng)`, `draw(source_id, facts) -> Result` (an unheard, available rumor), `mark_verified(id)`, `heard() -> Array[StringName]`, `credibility_visible(id, facts) -> bool`). Implements `Snapshotable`.
- **Emits:** `RumorHeard(id)`, `RumorVerified(id)`.
- **Must not know:** the economy (the application charges the drink price through `Wallet`).

### 4.18 `save`

- **Responsibility:** the save snapshot format and the version migrations. It contains no I/O.
- **API:** `SaveSnapshot` (`save_version: int`, `content_version: String`, `meta: SaveMeta` (slot, label, zone, spawn, act, stage, playtime_seconds, utc string), `sections: Dictionary[StringName, Dictionary]`), `SaveMigrator` (`_init(migrations: Array[SaveMigration])`, `migrate(raw: Dictionary) -> Result` which upgrades step by step to the current version), `SaveMigration` (abstract: `from_version()`, `apply(raw) -> Dictionary`), `SaveSchema` (`validate(raw) -> Result`: required sections and types).
- **Must not know:** files, JSON text, the internals of other domains (sections are opaque dictionaries owned by their domains).

---

## 5. Application layer

### 5.1 `GameSession`

`src/application/session/game_session.gd` is the aggregate root that holds one instance of each stateful domain object: `world: WorldState`, `escalation: EscalationTrack`, `queen: QueenCondition`, `quests: QuestLog`, `board: ClueBoard`, `dialogue_memory: DialogueMemory`, `sheet: ActorSheet`, `inventory`, `equipment`, `quick_slots`, `wallet`, `xp: ExperienceTrack`, `skills: SkillTree`, `reputation: ReputationLedger`, `travel: TravelState`, `party: Party`, `rumors: RumorPool`, `finale: FinaleRecord`, `rng: SeededRandom`, `location: SessionLocation` (zone and spawn). It has no logic beyond `snapshot()` and `restore()` delegation.

`SessionFactProvider extends FactProvider` reads only from `GameSession` and `ContentDatabase`.

### 5.2 Ports (abstract classes in `src/application/ports/`)

| Port | Methods | Implemented by |
|---|---|---|
| `ContentSource` | `load_all() -> Result` (holding a `ContentDatabase`) | `JsonContentSource` (infra), `InMemoryContentSource` (tests) |
| `SaveRepository` | `write(slot, snapshot: Dictionary) -> Result`, `read(slot) -> Result`, `list() -> Array[SaveMeta]`, `delete(slot)` | `JsonFileSaveRepository`, `InMemorySaveRepository` |
| `SettingsStore` | `load() -> GameSettings`, `save(s: GameSettings) -> Result` | `ConfigFileSettingsStore` |
| `WallClock` | `now_utc_string() -> String` (save metadata only, no gameplay use) | `OsWallClock`, `FixedWallClock` |
| `Logger` | `info`, `warn`, `error` | `GodotLogger`, `CapturingLogger` |

`ContentDatabase` (in `application/content/`) holds typed catalogs: `items: Dictionary[StringName, ItemDefinition]`, `enemies`, `encounters`, `dialogues`, `quests`, `clues`, `deductions`, `theories`, `factions`, `zones: Dictionary[StringName, ZoneDefinition]`, `map_nodes`, `map_edges`, `encounter_tables`, `rumors`, `skills`, `companions`, `escalation`, `endings`, `epilogues`, `npcs`, plus `get_*` accessors that return `Result`.

### 5.3 Use cases (`src/application/use_cases/<area>/`)

Each use case is one class with one public `execute(...) -> Result`. It calls domain objects, applies effects through `EffectDispatcher`, drains and publishes events, then publishes `FactsChanged`.

| Area | Use cases |
|---|---|
| session | `StartNewGameUseCase(name, attributes)`, `SaveGameUseCase(slot)`, `LoadGameUseCase(slot)`, `ApplyEffectsUseCase(effects, source)` |
| zones | `EnterZoneUseCase(zone_id, spawn_id)`, `ExitZoneUseCase(exit_id)`, `InteractUseCase(interactable_id)`, `TriggerZoneEventUseCase(trigger_id)`, `RestUseCase(rest_point_id)` |
| dialogue | `StartDialogueUseCase(dialogue_id)`, `ChooseDialogueOptionUseCase(option_id)`, `AdvanceDialogueUseCase()` |
| combat | `StartEncounterUseCase(encounter_id)`, `ResolveHitUseCase(attacker_id, target_id, attack_id, hit_flags)`, `TickCombatUseCase(delta)` (status effects and tokens), `ResolveYieldUseCase(enemy_id, spare: bool)`, `EndEncounterUseCase()` |
| finale | `StartFinaleUseCase()`, `TickFinaleUseCase(delta)`, `FreeAldricUseCase()`, `FinaleChoiceUseCase(choice_id)` (pursue / shield / command), `ResolveEndingUseCase()` |
| inventory | `PickUpItemUseCase`, `UseItemUseCase(item_id)`, `EquipItemUseCase(slot, item_id)`, `AssignQuickSlotUseCase`, `BuyItemUseCase`, `SellItemUseCase` |
| progression | `SpendSkillPointUseCase(perk_id)`, `SpendAttributePointUseCase(attr)` |
| travel | `PlanJourneyUseCase(to) -> Route` (a query), `TravelUseCase(to)` (rolls the encounter and returns `EncounterResult` for presentation), `ResolveEventCardUseCase(card_id, option_id)` |
| rumors | `BuyRumorUseCase(source_id)` |
| companions | `RecruitCompanionUseCase`, `CommandCompanionUseCase`, `ReviveCompanionUseCase` |
| antidote | `SendAntidoteByRiderUseCase`, `AdministerAntidoteUseCase(target: queen/maelis)`, `SellAntidoteUseCase` |

### 5.4 Policies (`src/application/policies/`)

Policies subscribe to the bus in `GameComposer` and coordinate between domains. Each policy is one class with a single handler concern.

| Policy | Listens to | Does |
|---|---|---|
| `EscalationPolicy` | `FactsChanged` | `escalation.recompute(facts)`. For each pending stage entry, applies its `on_enter` effects and publishes the stage card request |
| `QueenPolicy` | `EscalationStageChanged`, `FlagChanged`, `MilestoneReached` | Recomputes `QueenCondition`. Improves it on milestones once the antidote is administered |
| `QuestProgressPolicy` | `FactsChanged` | `quests.evaluate(facts)` and applies pending stage effects |
| `DeductionPolicy` | `FactsChanged` | `board.evaluate_deductions(facts)` |
| `MapUnlockPolicy` | `FactsChanged` | Unlocks map nodes whose `unlock` condition holds |
| `ActGatePolicy` | `FactsChanged` | When act gate conditions hold, unlocks the gate action (Fair, Return to Cintra) |
| `XpPolicy` | (see §4.13) | `xp.grant(...)` with source multipliers (travel ×0.5) |
| `RiderPolicy` | `MilestoneReached` | Delivers or intercepts an antidote sent by rider (`gdd.md` §6.2) |
| `MaelisPoisonPolicy` | `EscalationStageChanged`, `RestTaken` | Schedules and resolves the Maelis poisoning event |
| `AutosavePolicy` | `ZoneEntered`, `EscalationStageChanged`, `ActChanged`, `CheckpointReached` | Calls `SaveGameUseCase(&"auto")` (rotating) |

**Fixed point:** `FactsChanged` handlers may apply effects that change facts. The use case's wrapper republishes `FactsChanged` until no policy reports a change, capped at 8 rounds. Reaching the cap is an assertion failure, and a content test makes it unreachable for authored content.

### 5.5 Queries (read models for the UI)

Queries return plain DTO classes and never mutate: `JournalQuery`, `InvestigationBoardQuery`, `InventoryQuery`, `CharacterQuery`, `MapQuery` (visible nodes and pins, passable flags, route preview), `FactionQuery`, `RumorQuery`, `EscalationQuery` (stage, cards seen, Queen condition label), `SaveSlotsQuery`.

---

## 6. Infrastructure layer

| Class | Path | Role |
|---|---|---|
| `JsonContentSource` | `infrastructure/content/` | Scans `res://content/<kind>/*.json` with `DirAccess`. Parses with `JSON.parse_string`. Validates each file against `res://content/_schemas/<kind>.schema.json`. Builds definitions through per-kind parsers. Fails the whole load and lists every error |
| `SchemaValidator` | `infrastructure/content/` | Validates against a documented subset of JSON Schema: `type`, `required`, `properties`, `additionalProperties`, `enum`, `pattern`, `minimum`, `maximum`, `items`, `minItems`, `maxItems`, `$ref` (local `#/definitions`), plus custom `x-id-kind` (the value is an id of that kind), `x-condition` (the value must parse as a condition), `x-effects` (an array of strings that parse as effects) |
| `<Kind>Parser` (e.g. `ItemParser`, `DialogueParser`) | `infrastructure/content/parsers/` | Dictionary → domain definition. Integers are read through `JsonReader.get_int()` (Godot's JSON returns floats, so it checks for integral values) |
| `ContentCrossReferencer` | `infrastructure/content/` | After loading, checks that every referenced id exists (used by the loader in debug builds and by content tests) |
| `JsonFileSaveRepository` | `infrastructure/save/` | `user://saves/<slot>.json`. Atomic write (`<slot>.json.tmp`, then `DirAccess.rename`). Keeps one `.bak` |
| `ConfigFileSettingsStore` | `infrastructure/settings/` | `user://settings.cfg`: input remaps, audio, accessibility, difficulty |
| `InputRemapApplier` | `infrastructure/godot/` | Applies stored bindings to `InputMap` at startup |
| `OsWallClock`, `GodotLogger` | `infrastructure/godot/` | Port adapters |

**Export note:** JSON files are not imported resources. The Windows export preset must list `content/*.json` (and `_schemas`) in `include_filter`. A smoke test of the exported build checks that content loads.

---

## 7. Presentation layer

```
src/presentation/
  bootstrap/   main.gd (composition root), game_composer.gd, game_context.gd, services.gd (autoload), event_bridge.gd
  zones/       zone_loader.gd, zone_root.gd (base script for every zone scene), spawn_point.gd, zone_exit.gd,
               interactable.gd, trigger_volume.gd, checkpoint.gd, hazard_area.gd, stealth_guard.gd
  actors/      player_controller.gd, combatant_component.gd, hitbox.gd, hurtbox.gd, enemy_controller.gd,
               companion_controller.gd, npc.gd, actor_animator.gd   [ART: 2D or 3D variants]
  camera/      [ART] camera rig(s), lock-on
  ui/          hud/, dialogue/, journal/, inventory/, map/, character/, menus/, escalation_card/, finale_hud/, toasts/
  input/       input_actions.gd (action-name constants), input_glyphs.gd (keyboard or pad prompts)
  vfx/  audio/
```

- **Zone scenes** live in `res://scenes/zones/<zone_id>.tscn`. Their root uses `zone_root.gd` with `@export var zone_id: StringName`. `ZoneRoot.setup(ctx)` wires child interactables (each has `@export var interactable_id: StringName` that matches the zone JSON).
- **Zone JSON is the source of truth** for which interactables, triggers, spawns and exits exist and what they do. The scene places them. Content tests check that every id in the zone JSON has a node in the scene, and vice versa (a scene smoke test, §9.5).
- **Combat wiring:** `CombatantComponent` holds a domain `Combatant` and calls `combatant.tick(delta)` in `_physics_process`. `Hitbox` overlaps call `ResolveHitUseCase`. The resulting events (via the bridge) drive hit reactions and animation. `EnemyController` asks `EnemyBrain.decide()` every 0.2 s and performs the intent with navigation and animation.
- **Input:** all actions are named in `project.godot`'s Input Map (`move_*`, `attack_light`, `attack_heavy`, `block`, `dodge`, `kick`, `aim`, `fire`, `interact`, `crouch`, `lock_on`, `quick_1..4`, `menu_*`). Presentation reads actions, never raw keys.
- **[ART] plug-in:** `actors/`, `camera/`, `vfx/`, the UI skins, and `scenes/` are the only places that change with D3. Ranges and cone sizes in data are in meters. A 2D choice maps 1 m to a fixed pixel scale constant in `presentation/actors/world_scale.gd`.

---

## 8. Data

### 8.1 Format: JSON (not `.tres`)

| Criterion | JSON | `.tres` Resources |
|---|---|---|
| Authoring by agents and the markdown→data converter | Plain text, any tool can write it | Needs Godot resource syntax, `ext_resource` ids, UIDs |
| Diffs and merge conflicts (parallel agents) | Clean, one file per entity | Noisy: UID and id churn |
| Loading headless without import | `FileAccess` + `JSON` | Needs import and the script class cache |
| Typing | Lost at parse time, recovered by schema validation and typed definition classes | Native |
| Engine coupling | None in the domain (definitions are plain classes) | Definitions would be `Resource` subclasses |

**Decision:** JSON with schema validation. Typing is restored at the boundary by the parsers, which produce typed domain definitions. `.tres` is used only for presentation assets (materials, themes, animation libraries).

### 8.2 Ids

- Global, stable, lowercase, dotted with the kind as a prefix: `item.iron_key`, `npc.kosk`, `zone.drowned_rat`, `dlg.bertha_intro`, `quest.main_a1`, `clue.chalice_pollen`, `ded.anselm_lied`, `flag.chalice_secured`, `var.bulbs_recovered`, `ms.a1_audience_done`, `enemy.choir_thug`, `enc.rat_thugs`, `faction.crown`, `perk.quick_reload`, `rumor.r01_poisoned_cup`, `map.tigg`, `edge.tigg_ferrymen`, `esc.v_black_river`, `ending.lion_holds`, `companion.maelis`, `ally.aldric`, `event.ford_marnadal`.
- Pattern: `^(kind)\.[a-z0-9_]+$`. Ids never change once committed. A rename needs a save migration.
- Local ids inside a file (dialogue node ids, quest stage ids, option ids) are `snake_case`, unique within the file, and referenced as `<file_id>/<local_id>` from outside if ever needed.
- Typed as `StringName` in code.

### 8.3 Layout and versioning

`res://content/<kind>/<id_suffix>.json`, one entity per file. The file name must equal the id suffix (tested). Kinds: `items/`, `enemies/`, `encounters/`, `encounter_tables/`, `npcs/`, `dialogues/`, `quests/`, `clues/`, `deductions/`, `theories/`, `factions/`, `zones/`, `map/nodes/`, `map/edges/`, `rumors/`, `skills/`, `companions/`, `escalation/`, `endings/`, `epilogues/`, `event_cards/`, `flags/` (declarations of `flag.`/`var.`/`ms.` ids, one file per section), `sections/` (section front matter and branch guarantees), plus `_schemas/` and `content_version.json` (a semver string recorded in saves).

The markdown content files (`docs/content/**`) are converted to these JSON files by a later tool step (`content-format.md` §H).

---

## 9. Testing

### 9.1 Framework: GUT 9.7.1 (`godot_4_7` branch)

**Research (2026-11-21):**
- GUT lists v9.7.1 on the `godot_4_7` branch for Godot 4.7.x, with docs at gut.readthedocs.io/en/v9.7.0. GUT's main branch targets 4.6.
- GdUnit4 v6.2.x lists Godot 4.5–4.7.1 support, and its master is moving to v7.0.0 (4.7 and 4.8-dev).

**Choice: GUT 9.7.1, vendored into `game/addons/gut/` from the `godot_4_7` branch tag.** Rationale:
1. A release line dedicated to 4.7.x. GdUnit4's table lists 4.7/4.7.1 but not 4.7.2 explicitly, and it is in the middle of a major-version transition.
2. The headless CLI is a single Godot command with proper exit codes (0 pass, 1 fail) and JUnit XML output. There is no wrapper script, so it works the same from PowerShell, bash, CI and the Godot MCP.
3. Pure GDScript, with doubles, stubs, spies, parameterized tests and an input sender for scene smoke tests. That is enough for this architecture, where most tests are plain `RefCounted` unit tests.

Fallback: if GUT 9.7.1 breaks on 4.7.2, switch to GdUnit4 v6.2.x. Tests are plain `extends GutTest` with `assert_eq` and friends, and a mechanical port is feasible.

### 9.2 Commands

The `godot` on `PATH` (`C:\Users\skure\.local\bin\godot`) reports **4.7.0**. Use the 4.7.2 **console** binary (the console build is needed for stdout on Windows), the same one the Godot MCP uses:

```powershell
$env:GODOT = "C:\Users\skure\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7.2-stable_windows_arm64_console.exe"

# once per fresh checkout, or after adding class_name scripts (builds the global class cache):
& $env:GODOT --headless --path game --import

# all tests:
& $env:GODOT --headless --path game -s res://addons/gut/gut_cmdln.gd -gconfig=res://.gutconfig.json -gexit

# one suite / one file / one test:
& $env:GODOT --headless --path game -s res://addons/gut/gut_cmdln.gd -gdir=res://tests/unit/escalation -ginclude_subdirs -gexit
& $env:GODOT --headless --path game -s res://addons/gut/gut_cmdln.gd -gtest=res://tests/unit/escalation/test_escalation_track.gd -gexit
& $env:GODOT --headless --path game -s res://addons/gut/gut_cmdln.gd -gtest=res://tests/unit/escalation/test_escalation_track.gd -gunit_test_name=never_decreases -gexit
```

`game/.gutconfig.json`:

```json
{
  "dirs": ["res://tests/unit", "res://tests/application", "res://tests/content", "res://tests/architecture", "res://tests/smoke"],
  "include_subdirs": true,
  "prefix": "test_",
  "suffix": ".gd",
  "should_exit": true,
  "log_level": 1
}
```

`tools/test.ps1` (repo root; implementers create it in the first task) wraps this and adds `-gjunit_xml_file=<absolute repo path>/test-results/junit.xml`. It takes `-Suite unit|application|content|architecture|smoke|all` and `-Test <path>`, runs `--import` automatically when `game/.godot/` is missing, and passes Godot's exit code through. `test-results/` and `game/.godot/` are git-ignored.

### 9.3 Test layout and kinds

```
game/tests/
  unit/<domain>/test_<class>.gd          # pure domain, no scene tree, fast; most tests live here
  application/test_<use_case|policy>.gd  # use cases and policies over a real GameSession + in-memory ports + fixture content
  content/                                # validation of the real content set
  architecture/test_dependency_rule.gd   # layer and domain boundaries, file size, forbidden APIs
  smoke/test_<scene>.gd                   # instantiate scenes headless, a few frames, no errors
  fixtures/content/                       # a tiny self-consistent content set for application tests
  helpers/                                # builders (SessionBuilder, ItemDefBuilder…), fakes (InMemoryContentSource, InMemorySaveRepository, ScriptedRandom, FakeFactProvider, CapturingLogger)
```

### 9.4 Content validation tests (`tests/content/`)

| Test | Checks |
|---|---|
| `test_schemas.gd` | Every JSON file is valid against its kind's schema. The file name equals the id suffix |
| `test_references.gd` | Every id referenced (fields marked `x-id-kind`, condition call arguments, effect arguments) exists in the content database |
| `test_conditions_and_effects_parse.gd` | Every condition and effect string parses, and every effect op exists with the right argument types |
| `test_dialogue_graphs.gd` | Every node is reachable from `start`, every `next` exists, every non-end path reaches an `end`, and every choice node has an option that is always available (no dead ends) |
| `test_quests_completable.gd` | **Monotone reachability:** starting from the new-game facts, repeatedly collect every effect whose guarding condition is satisfiable under the reachable fact set (treating `not` as satisfiable, an over-approximation) until a fixed point. Every main-quest stage and every required objective must become satisfiable. Every side quest must be completable |
| `test_act_gates.gd` | Each act gate is reachable through at least one path that contains no check above the max attainable value, no fight-or-fail branch, and no item that can be lost |
| `test_endings.gd` | `EndingResolver` over the full product of {queen_alive} × {oath} × {anselm} × {vault_seized}: exactly one ending per valid combination, and every one of the 5 endings is produced. Plus content reachability: each ending's facts are reachable (antidote administered and lost, command rite clue, pursue and shield choices) |
| `test_xp_budget.gd` | XP available by end of Act I ≥ 1350, Acts I+II ≥ 5250, total ≥ 11550 × 1.15 |
| `test_escalation_reachable.gd` | Stages 1–4 are all reachable, and their conditions reference only milestones |
| `test_map.gd` | Every node is reachable from `map.cintra` once all unlock conditions are satisfiable. Every edge terrain has an encounter table with 8 entries and a pool of 3 or more |
| `test_zone_scene_parity.gd` (smoke) | Every interactable, trigger, spawn and exit id in the zone JSON exists as a node in the zone scene, and the reverse |

### 9.5 Smoke tests

`tests/smoke/` instantiates `Main.tscn` with fixture content, starts a new game, loads each slice zone through `ZoneLoader`, simulates 120 physics frames, and asserts no errors (`CapturingLogger`) and the required nodes. One scripted run goes through the slice's flee path with GUT's input sender. Smoke tests are few and slow, and they run last.

### 9.6 TDD workflow (binding for implementers)

1. Each task starts with a **failing** test in the right folder, run with `tools/test.ps1 -Test <file>`, and confirmed red for the expected reason.
2. Write the minimum code to pass. Run the domain's suite, then everything.
3. Refactor with the suite green. Keep the file and function size limits (§11).
4. A task's report lists the tests added and the final full-suite output (pass counts).
5. No domain or application class merges without unit tests for every public method and each rule in `gdd.md` it implements (name the section in the test file's header comment).
6. Tests are deterministic: inject `ScriptedRandom` or `SeededRandom(seed)`, tick time manually (`combatant.tick(0.1)`), and never `await` real time in unit tests.
7. Content changes run `tools/test.ps1 -Suite content` before handing back.
8. After scene work, use the Godot MCP to run the project and read the debug output (§12). Zero script errors is part of done.

---

## 10. Folder layout

```
cintra-game/
  story.md
  docs/            design/, content/ (markdown content per section), orchestration/, art-direction/
  tools/           test.ps1, test.sh, content_convert/ (markdown → JSON converter, later task)
  art-src/         .blend sources and Blender MCP scripts (outside the Godot import scan)
  test-results/    (git-ignored)
  game/                                   # res://
    project.godot
    .gutconfig.json
    addons/
      gut/                                # GUT 9.7.1 (vendored)
      godot_ai/                           # Godot AI plugin (per project, editor only, excluded from export)
    src/
      domain/
        shared/ rules/ world_state/ escalation/ quests/ investigation/ dialogue/ combat/ finale/
        endings/ actors/ inventory/ progression/ factions/ travel/ companions/ rumors/ save/
          <domain>/_internal/             # domain-private helpers
      application/
        bus/ session/ ports/ content/ effects/ effects/handlers/ use_cases/<area>/ policies/ queries/
      infrastructure/
        content/ content/parsers/ save/ settings/ godot/
      presentation/
        bootstrap/ zones/ actors/ camera/ ui/ input/ vfx/ audio/
    scenes/
      main/Main.tscn
      zones/<zone_id>.tscn
      arenas/<arena_id>.tscn
      actors/  ui/
    content/
      _schemas/ items/ enemies/ encounters/ encounter_tables/ npcs/ dialogues/ quests/ clues/
      deductions/ theories/ factions/ zones/ map/nodes/ map/edges/ rumors/ skills/ companions/
      escalation/ endings/ epilogues/ event_cards/ flags/ sections/ content_version.json
    assets/
      models/ textures/ materials/ shaders/ audio/ fonts/ ui/   LICENSES.md (source and license per CC0 asset)
    tests/
      unit/ application/ content/ architecture/ smoke/ fixtures/ helpers/
```

---

## 11. Coding standards

**Typing (enforced by project settings, `debug/gdscript/warnings/*`):**
- `untyped_declaration` = Error.
- `unsafe_property_access`, `unsafe_method_access`, `unsafe_cast`, `unsafe_call_argument` = Warn. These are treated as review blockers.
- Lint gate: under `res://src` the `unsafe_*` warnings are errors, together with the rest of the policy in `tools/lint_override.cfg` (`unused_*`, `shadowed_*`, and so on), enforced by `tools/lint.ps1` / `tools/lint.sh`, which `tools/test.*` run before any test.
- `inferred_declaration` = Ignore. `:=` is allowed when the type is obvious on the right-hand side.
- Every variable, parameter and return is typed. Use typed arrays and dictionaries (`Array[StringName]`, `Dictionary[StringName, int]`). Use `StringName` for ids.

**Files and naming:**
- One class per file. No inner classes. File `snake_case.gd`, `class_name PascalCase`, and the two match.
- Suffixes: `*Definition` (content types), `*UseCase`, `*Policy`, `*Query`, `*Repository` / `*Store` / `*Source` (ports), technology-prefixed adapters (`JsonFileSaveRepository`), events as past-tense nouns (`QuestStarted`). Test file `test_<file>.gd`.
- Private members start with `_`. Constants `UPPER_SNAKE`. Signals past tense (`hit_landed`).
- No `get_node("../..")` and no string node paths in logic. Use `%UniqueName` or `@export` node references.

**Size:** target ≤ 200 lines per file, hard limit 300 (tested). Functions ≤ 30 lines, ≤ 4 parameters (bundle more into a value object). Nesting ≤ 3 levels.

**Errors:** expected failures return `Result.err(code)`. Programmer errors use `assert()`. Never `push_error` and continue silently in domain code.

**SOLID in GDScript:**
- **S:** one reason to change per class. A use case does one thing. Each policy reacts to one concern.
- **O:** extend through registries, not `match` ladders: `EffectDispatcher` handlers, encounter-kind handlers, dialogue node handlers and migration steps are registered in `GameComposer`.
- **L:** abstract bases use Godot 4.5+ `@abstract` classes and methods. Subclasses honor the base contract (they never return an error where the base promises success).
- **I:** keep ports narrow. `FactProvider` is read-only. UI gets queries, not aggregates.
- **D:** depend on abstract ports and inject them through `_init` (or `setup(ctx)` for nodes). Only `GameComposer` names concrete infrastructure.

**Other:**
- No global state except the `Services` autoload (§3.3).
- No real-time waits in the domain. Time enters only as a `delta` argument (combat, finale).
- Comments explain *why*. Each domain class's header comment cites the `gdd.md` section it implements.

---

## 12. Tooling

### 12.1 Godot MCP (Coding-Solo), registered globally

The server is configured with `GODOT_PATH` = the 4.7.2 arm64 console binary. Tools include `get_godot_version`, `launch_editor`, `run_project`, `get_debug_output`, `stop_project`, `get_project_info`, `list_projects`, `create_scene`, `add_node`, `load_sprite`, `save_scene`, `get_uid`, `update_project_uids`, `export_mesh_library`.

How implementers use it:
- **Run and read errors:** after any scene or presentation change, call `run_project` (project path `game/`), exercise the flow, call `get_debug_output`, then `stop_project`. A clean debug output is part of the definition of done.
- **Quick scene scaffolds** (`create_scene`, `add_node`, `save_scene`) for simple trees. Complex scenes use the Godot AI plugin.
- **After moving files**, call `update_project_uids`.
- It does not replace GUT. Tests still run through `tools/test.ps1`.

### 12.2 Godot AI plugin (hi-godot/godot-ai), per project

- **Install** (first presentation task): download the GitHub release into `game/addons/godot_ai/` (never extract over an existing folder; use the dock's **Update** button). Enable it under Project Settings → Plugins. It requires Godot 4.7+ and `uv` on `PATH`. In the dock, press **Configure** for Claude Code (or set `godot_ai/mcp_client_scope` to project scope). The client connects over stdio through `godot-ai attach`. The server uses port 8000 and the editor WebSocket uses 9500. Set `GODOT_AI_DISABLE_TELEMETRY=true`.
- **Use for** live editor work that is awkward as text: building and wiring zone scenes, setting node properties, connecting signals, UI layout and themes, materials, animation, particles, camera and environment setup, and inspecting the live scene tree.
- **Do not use it** to write gameplay or domain scripts outside TDD. Scripts are still created as files with tests first. The plugin's `script_create` and `script_patch` are allowed only for presentation glue that has a smoke test.
- Exclude `addons/godot_ai/` from export presets. The editor must be open with the project for the plugin to work.

### 12.3 Blender MCP (ahujasid), registered globally

- **Requires** Blender running with the BlenderMCP add-on connected (sidebar → BlenderMCP → Connect). Tools: `get_scene_info`, `get_object_info`, `get_viewport_screenshot`, `execute_blender_code`, Poly Haven search and download.
- **Policy (C1):** assets are procedural (Python through `execute_blender_code`) or CC0 (Poly Haven, Kenney, Quaternius). Do **not** use the Hyper3D or Rodin AI generation or Sketchfab downloads. Record the source and license of every asset in `game/assets/LICENSES.md`.
- **Pipeline:** generation scripts and `.blend` files go to `art-src/<category>/`. Export glTF 2.0 binary (`.glb`, +Y up, 1 unit = 1 m, applied transforms) to `game/assets/models/<category>/<asset_id>.glb`. Godot imports it. If D3 picks a 2D style, Blender renders sprite sheets to `game/assets/textures/sprites/` instead.
- **[ART]:** asset work waits for D3 (STATE.md phase note).

---

## 13. Risks and notes

- **GUT on 4.7.2:** GUT's 4.7 release line is listed for 4.7.x. Verify with the first test run, and fall back to GdUnit4 v6.2.x (§9.1).
- **Two Godot binaries:** the `PATH` `godot` (4.7.0) and the MCP binary (4.7.2) differ. Always use `$env:GODOT`. Using the 4.7.0 editor on this project may rewrite files with 4.7.0 serialization.
- **Global class cache:** headless runs on a fresh checkout need `--import` first, or `class_name` lookups fail. `tools/test.ps1` handles this.
- **Godot JSON numbers are floats:** parsers must go through `JsonReader.get_int` to avoid `1.0` vs `1` bugs in ids, counts and DCs.
- **The fixed point of `FactsChanged`** needs authored content without effect cycles. The content test guards it.
- **The domain combat state machine plus presentation physics** are the most integration-sensitive part. Prototype in the slice before scaling to enemy variety.
