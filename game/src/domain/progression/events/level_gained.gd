## Recorded once for each level the character reaches, in order, after the
## XpGained that caused it (gdd.md §6.8; architecture.md §4.13).
class_name LevelGained
extends DomainEvent

var new_level: int


func _init(reached: int) -> void:
	new_level = reached
