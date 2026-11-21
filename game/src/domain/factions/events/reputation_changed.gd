## Recorded when a faction's reputation really changes value, after clamping
## to -100..100 (architecture.md §4.14; gdd.md §6.12).
class_name ReputationChanged
extends DomainEvent

var id: StringName
var old_value: int
var new_value: int


func _init(faction_id: StringName, before: int, after: int) -> void:
	id = faction_id
	old_value = before
	new_value = after
