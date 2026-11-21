## The `true` / `false` condition (content-format.md §C atom).
class_name LiteralCondition
extends Condition

var _value: bool


func _init(value: bool) -> void:
	_value = value


func evaluate(_facts: FactProvider) -> bool:
	return _value


func referenced_ids() -> Array[StringName]:
	return []
