## Recorded when a world flag really flips (architecture.md §4.3; gdd.md §6.1).
class_name FlagChanged
extends DomainEvent

var id: StringName
var value: bool


func _init(flag_id: StringName, flag_value: bool) -> void:
	id = flag_id
	value = flag_value
