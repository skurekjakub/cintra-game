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


## An inventory that owns: an arming sword and a spare sword (weapons, main_hand),
## a gambeson (armor 10, armor slot), a lucky coin (trinket) and 2 poultices
## (consumable). The catalog also knows a mane cleaver (weapon, main_hand) that is
## not owned. Shared by the equipment and quick slot tests.
static func gear_inventory() -> Inventory:
	var sword := item(&"item.arming_sword", &"weapon", 1, 40)
	sword.equip_slot = &"main_hand"
	var spare := item(&"item.spare_sword", &"weapon", 1, 25)
	spare.equip_slot = &"main_hand"
	var gambeson := item(&"item.gambeson", &"armor", 1, 60)
	gambeson.equip_slot = &"armor"
	gambeson.armor = ItemArmorPayload.new()
	gambeson.armor.armor = 10
	var coin := item(&"item.lucky_coin", &"trinket", 1, 15)
	coin.equip_slot = &"trinket"
	var poultice := item(&"item.poultice", &"consumable", 10, 8)
	var cleaver := item(&"item.mane_cleaver", &"weapon", 1, 90)
	cleaver.equip_slot = &"main_hand"
	var inv := Inventory.new(catalog([sword, spare, gambeson, coin, poultice, cleaver] as Array[ItemDefinition]))
	for id: StringName in [&"item.arming_sword", &"item.spare_sword", &"item.gambeson", &"item.lucky_coin"]:
		inv.add(id)
	inv.add(&"item.poultice", 2)
	return inv
