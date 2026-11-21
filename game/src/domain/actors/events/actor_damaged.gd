## Recorded when hit points are really lost (architecture.md §4.4; gdd.md §6.6).
## `amount` is the HP actually lost, after the floor at 0.
class_name ActorDamaged
extends DomainEvent

var amount: int
var current_hp: int


func _init(lost: int, hp_after: int) -> void:
	amount = lost
	current_hp = hp_after
