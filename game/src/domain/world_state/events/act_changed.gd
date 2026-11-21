## Recorded when the story act really changes (architecture.md §4.3; gdd.md §6.1).
class_name ActChanged
extends DomainEvent

var old_act: int
var new_act: int


func _init(before: int, after: int) -> void:
	old_act = before
	new_act = after
