## A parsed content condition: a boolean expression tree over world facts
## (content-format.md §C, architecture.md §3.4). The nodes live in `_internal/`; the
## ConditionParser builds them. Evaluation is pure: it only reads through a FactProvider.
@abstract
class_name Condition
extends RefCounted


## True when the condition holds against `facts`.
@abstract func evaluate(facts: FactProvider) -> bool


## Every content id the condition names, in first-seen order, without duplicates.
@abstract func referenced_ids() -> Array[StringName]


## Appends each id of `more` to `into` unless `into` already holds it.
static func _merge_ids(into: Array[StringName], more: Array[StringName]) -> void:
	for id: StringName in more:
		if not into.has(id):
			into.append(id)
