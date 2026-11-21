## Recorded when a world variable really changes value, after any clamping
## (architecture.md §4.3; content-format.md §E).
class_name VarChanged
extends DomainEvent

var id: StringName
var old_value: int
var new_value: int


func _init(var_id: StringName, before: int, after: int) -> void:
	id = var_id
	old_value = before
	new_value = after
