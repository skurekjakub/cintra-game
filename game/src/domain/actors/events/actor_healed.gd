## Recorded when hit points are really restored (architecture.md §4.11; gdd.md §6.6).
## `amount` is the HP actually gained, after the cap at max HP.
class_name ActorHealed
extends DomainEvent

var amount: int
var current_hp: int


func _init(healed: int, hp_after: int) -> void:
	amount = healed
	current_hp = hp_after
