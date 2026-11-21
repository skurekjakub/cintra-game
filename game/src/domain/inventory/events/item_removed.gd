## Recorded when items really leave the inventory; `removed` is what was taken,
## never 0, and `total` the count afterwards (architecture.md §4.12; gdd.md §6.9).
class_name ItemRemoved
extends DomainEvent

var id: StringName
var removed: int
var total: int


func _init(item_id: StringName, amount: int, new_total: int) -> void:
	id = item_id
	removed = amount
	total = new_total
