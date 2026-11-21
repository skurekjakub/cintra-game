## `a and b and ...` (content-format.md §C). Stops at the first false child.
class_name AndCondition
extends Condition

var _children: Array[Condition]


func _init(children: Array[Condition]) -> void:
	_children = children.duplicate()


func evaluate(facts: FactProvider) -> bool:
	for child: Condition in _children:
		if not child.evaluate(facts):
			return false
	return true


func referenced_ids() -> Array[StringName]:
	var out: Array[StringName] = []
	for child: Condition in _children:
		_merge_ids(out, child.referenced_ids())
	return out
