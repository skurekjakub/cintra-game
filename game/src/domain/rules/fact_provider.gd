## Read-only port through which conditions and rules see the world, so `rules` knows
## nothing about the domains that supply the facts (architecture.md §3.4, §4.2).
## The application's SessionFactProvider implements it; tests use FakeFactProvider.
@abstract
class_name FactProvider
extends RefCounted

## Values `quest_status` returns. QuestLog.status() must return these same values.
const QUEST_INACTIVE: StringName = &"inactive"
const QUEST_ACTIVE: StringName = &"active"
const QUEST_COMPLETED: StringName = &"completed"
const QUEST_FAILED: StringName = &"failed"

## Keys of `finale_value`. seized returns &"true"/&"false", oath returns
## &"true"/&"reversed"/&"none", anselm returns &"alive"/&"dead"/&"fled".
const FINALE_SEIZED: StringName = &"seized"
const FINALE_OATH: StringName = &"oath"
const FINALE_ANSELM: StringName = &"anselm"


@abstract func has_flag(id: StringName) -> bool


@abstract func get_var(id: StringName) -> int


@abstract func has_milestone(id: StringName) -> bool


@abstract func item_count(id: StringName) -> int


@abstract func has_clue(id: StringName) -> bool


@abstract func has_deduction(id: StringName) -> bool


## One of the QUEST_* values.
@abstract func quest_status(id: StringName) -> StringName


## The quest's current stage id, or &"" when it has none.
@abstract func quest_stage(id: StringName) -> StringName


## The player's attribute score (might, agility, grit, wits, presence).
@abstract func attribute(attr: StringName) -> int


## The total used by a check of `skill` (a dialogue skill or an attribute).
@abstract func check_total(skill: StringName) -> int


@abstract func reputation(id: StringName) -> int


## One of the RepTiers.ORDER names.
@abstract func rep_tier(id: StringName) -> StringName


@abstract func escalation_stage() -> int


@abstract func act() -> int


@abstract func in_party(id: StringName) -> bool


@abstract func has_perk(id: StringName) -> bool


@abstract func crowns() -> int


@abstract func level() -> int


## `key` is one of the FINALE_* constants.
@abstract func finale_value(key: StringName) -> StringName


@abstract func visited(zone_id: StringName) -> bool


@abstract func rumor_heard(rumor_id: StringName) -> bool


@abstract func queen_condition() -> int
