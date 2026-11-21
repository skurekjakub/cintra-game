## Recorded when an item really leaves an equipment slot, by unequip or because
## another item takes its place; `id` is the item that left (architecture.md §4.12;
## gdd.md §6.9 equipment slots).
class_name ItemUnequipped
extends DomainEvent

var slot: StringName
var id: StringName


func _init(equip_slot: StringName, item_id: StringName) -> void:
	slot = equip_slot
	id = item_id
