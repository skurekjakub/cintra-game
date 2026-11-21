## `a or b or ...` (content-format.md §C). Stops at the first true child.
class_name OrCondition
extends Condition

var _children: Array[Condition]


func _init(children: Array[Condition]) -> void:
	_children = children.duplicate()


func evaluate(facts: FactProvider) -> bool:
	for child: Condition in _children:
		if child.evaluate(facts):
			return true
	return false


func referenced_ids() -> Array[StringName]:
	var out: Array[StringName] = []
	for child: Condition in _children:
		_merge_ids(out, child.referenced_ids())
	return out
