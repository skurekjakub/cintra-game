## One kind of item: category, stack limit, price, optional equip slot, weapon,
## armor or consumable payload and §J.6 modifiers (gdd.md §6.9 inventory and items;
## content-format.md items, §J.6; architecture.md §4.12). Immutable by convention:
## the required fields go through `_init`; the optional ones are assigned only by
## parsers and tests, right after construction.
class_name ItemDefinition
extends RefCounted

const CATEGORIES: Array[StringName] = [
	&"weapon", &"armor", &"trinket", &"consumable", &"ammo", &"key", &"document",
]
const ITEM_SLOTS: Array[StringName] = [&"main_hand", &"ranged", &"armor", &"trinket"]
## Key items and documents cannot be dropped, sold or destroyed except by scripted effects.
const PROTECTED_CATEGORIES: Array[StringName] = [&"key", &"document"]

var id: StringName
var category: StringName
var stack_max: int
var price: int
var display_name: String = ""
var description: String = ""
## `&""` (not equippable) or one of ITEM_SLOTS.
var equip_slot: StringName = &""
var tags: Array[StringName] = []
var weapon: ItemWeaponPayload = null
var armor: ItemArmorPayload = null
var consumable: ItemConsumablePayload = null
## The §J.6 modifiers of a trinket or armor, flat (the `trinket:` / `armor:` split in
## content only matters to the parser). Empty for an item with no mechanical effect.
var mods: Array[ItemModifier] = []
## The full text of a document.
var readable_text: String = ""


func _init(item_id: StringName, item_category: StringName, max_stack: int = 1, buy_price: int = 0) -> void:
	assert(CATEGORIES.has(item_category), "unknown item category")
	assert(max_stack >= 1, "stack_max must be at least 1")
	assert(buy_price >= 0, "price must not be negative")
	id = item_id
	category = item_category
	stack_max = max_stack
	price = buy_price


## True for a key item or a document: `Inventory.remove` refuses it without `force`.
func is_protected() -> bool:
	return PROTECTED_CATEGORIES.has(category)
