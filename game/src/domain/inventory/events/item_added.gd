## Recorded when items really enter the inventory; `added` is what fitted, never
## 0, and `total` the count afterwards (architecture.md §4.12; gdd.md §6.9).
class_name ItemAdded
extends DomainEvent

var id: StringName
var added: int
var total: int


func _init(item_id: StringName, amount: int, new_total: int) -> void:
	id = item_id
	added = amount
	total = new_total
