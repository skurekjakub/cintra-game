## Test helper: builds item definitions and catalogs for the inventory domain's
## tests (architecture.md §9.3, §4.12).
## Usage: Inventory.new(ItemDefBuilder.catalog([ItemDefBuilder.item(&"item.x", &"ammo", 20)] as Array[ItemDefinition])).
class_name ItemDefBuilder
extends RefCounted


static func item(id: StringName, category: StringName, stack_max: int = 1, price: int = 0) -> ItemDefinition:
	return ItemDefinition.new(id, category, stack_max, price)


static func catalog(defs: Array[ItemDefinition]) -> Dictionary[StringName, ItemDefinition]:
	var by_id: Dictionary[StringName, ItemDefinition] = {}
	for def: ItemDefinition in defs:
		assert(not by_id.has(def.id), "duplicate item id")
		by_id[def.id] = def
	return by_id
