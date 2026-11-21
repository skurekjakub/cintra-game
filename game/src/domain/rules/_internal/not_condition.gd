## `not <condition>` (content-format.md §C unary).
class_name NotCondition
extends Condition

var _child: Condition


func _init(child: Condition) -> void:
	_child = child


func evaluate(facts: FactProvider) -> bool:
	return not _child.evaluate(facts)


func referenced_ids() -> Array[StringName]:
	return _child.referenced_ids()
