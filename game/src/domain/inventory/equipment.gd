## What the player wears and wields: one item id per equipment slot, checked
## against what the inventory owns and what each item fits (gdd.md §6.9 equipment
## slots, §6.6 armor sum; architecture.md §4.12). Equipping does not take the item
## out of the inventory. A failed equip changes nothing and records nothing.
## Whoever removes the last copy of an equipped item (selling, take_item) must
## unequip it first.
## To move an item between slots (e.g. `trinket_1` → `trinket_2`), the use case unequips it first.
## `QuickSlots.assign`, by contrast, moves.
class_name Equipment
extends Snapshotable

const SLOTS: Array[StringName] = [&"main_hand", &"ranged", &"armor", &"trinket_1", &"trinket_2"]
## The slots that take an item whose equip_slot is `trinket`.
const TRINKET_SLOTS: Array[StringName] = [&"trinket_1", &"trinket_2"]

var _inventory: Inventory
## Occupied slots only: slot -> item id.
var _worn: Dictionary[StringName, StringName] = {}
var _outbox := EventOutbox.new()


func _init(inventory: Inventory) -> void:
	_inventory = inventory


## Puts an owned item into a slot. Err, checked in this order: `unknown_slot`,
## `not_owned`, `wrong_slot` (the item's equip_slot does not fit the slot; a
## `trinket` fits trinket_1 and trinket_2), `already_equipped` (the same id sits in
## another slot). Equipping what the slot already holds is a quiet Ok. Over an
## occupied slot it records ItemUnequipped(slot, old id) and then ItemEquipped.
func equip(slot: StringName, id: StringName) -> Result:
	if not SLOTS.has(slot):
		return Result.err(&"unknown_slot")
	if not _inventory.has(id):
		return Result.err(&"not_owned")
	if not _fits(slot, _inventory.definition(id)):
		return Result.err(&"wrong_slot")
	if equipped(slot) == id:
		return Result.ok()
	if is_equipped(id):
		return Result.err(&"already_equipped")
	unequip(slot)
	_worn[slot] = id
	_outbox.record(ItemEquipped.new(slot, id))
	return Result.ok()


## Empties a slot and records ItemUnequipped; an empty slot is left alone.
func unequip(slot: StringName) -> void:
	assert(SLOTS.has(slot), "unknown equipment slot")
	if not _worn.has(slot):
		return
	var old_id := _worn[slot]
	_worn.erase(slot)
	_outbox.record(ItemUnequipped.new(slot, old_id))


## The item id in a slot, `&""` when it is empty (or not a slot).
func equipped(slot: StringName) -> StringName:
	if _worn.has(slot):
		return _worn[slot]
	return &""


func is_equipped(id: StringName) -> bool:
	return _worn.values().has(id)


## The sum of `armor.armor` over every equipped item that has an armor payload.
func armor_total() -> int:
	var total := 0
	for id: StringName in _worn.values():
		var def := _inventory.definition(id)
		if def != null and def.armor != null:
			total += def.armor.armor
	return total


func drain_events() -> Array[DomainEvent]:
	return _outbox.drain()


func to_snapshot() -> Dictionary:
	var stored: Dictionary = {}
	for slot: StringName in _worn:
		stored[String(slot)] = String(_worn[slot])
	return {"slots": stored}


## Replaces every slot from a snapshot (also one that went through JSON). A slot
## name that is not a slot and an empty id are dropped; the ids are not checked
## against the inventory, which may be restored later. Emits no events and leaves
## pending ones alone.
func restore(data: Dictionary) -> void:
	_worn.clear()
	var stored: Dictionary = data["slots"]
	for slot_name: String in stored:
		var slot := StringName(slot_name)
		var item_name: String = stored[slot_name]
		if SLOTS.has(slot) and item_name != "":
			_worn[slot] = StringName(item_name)


func _fits(slot: StringName, def: ItemDefinition) -> bool:
	if def.equip_slot == &"trinket":
		return TRINKET_SLOTS.has(slot)
	return def.equip_slot == slot
