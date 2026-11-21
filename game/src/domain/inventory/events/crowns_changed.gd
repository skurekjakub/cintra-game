## Recorded when the crowns balance really changes (never for an amount of 0)
## (architecture.md §4.7; gdd.md §6.9).
class_name CrownsChanged
extends DomainEvent

var old_balance: int
var new_balance: int


func _init(before: int, after: int) -> void:
	old_balance = before
	new_balance = after
