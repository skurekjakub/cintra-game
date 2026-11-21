## Recorded when the Queen's condition (0–3) really changes (architecture.md
## §4.4; gdd.md §6.2).
class_name QueenConditionChanged
extends DomainEvent

var old_condition: int
var new_condition: int


func _init(before: int, after: int) -> void:
	old_condition = before
	new_condition = after
