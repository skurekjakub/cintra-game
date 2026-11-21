## Recorded when an item really enters an equipment slot (architecture.md §4.12;
## gdd.md §6.9 equipment slots).
class_name ItemEquipped
extends DomainEvent

var slot: StringName
var id: StringName


func _init(equip_slot: StringName, item_id: StringName) -> void:
	slot = equip_slot
	id = item_id
