## Recorded when a grant really adds experience, with the amount actually added
## after the level cap (gdd.md §6.8; architecture.md §4.13).
class_name XpGained
extends DomainEvent

var amount: int
var source: StringName


func _init(gained: int, from_source: StringName) -> void:
	amount = gained
	source = from_source
