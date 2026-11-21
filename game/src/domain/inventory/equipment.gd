## What the player wears and wields: one item id per equipment slot, checked
## against what the inventory owns and what each item fits (gdd.md §6.9 equipment
## slots, §6.6 armor sum; content-format.md §J.6 item mods; architecture.md §4.12).
## Equipping does not take the item out of the inventory. A failed equip changes
## nothing and records nothing.
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


## The sum of `armor.armor` over every equipped item that has an armor payload,
## plus every `armor` mod without a `vs_faction` on an equipped item (§J.6).
func armor_total() -> int:
	var total := 0
	for id: StringName in _worn.values():
		var def := _inventory.definition(id)
		if def != null and def.armor != null:
			total += def.armor.armor
	for m: ItemModifier in equipped_mods():
		if m.mod == &"armor" and m.vs_faction == &"":
			total += m.value
	return total


## The mods of every equipped item (content-format.md §J.6), in SLOTS order and,
## within an item, in its `mods` order. Callers filter by `mod` and `vs_faction`.
func equipped_mods() -> Array[ItemModifier]:
	var mods: Array[ItemModifier] = []
	for slot: StringName in SLOTS:
		var def := _inventory.definition(equipped(slot))
		if def != null:
			mods.append_array(def.mods)
	return mods


func drain_events() -> Array[DomainEvent]:
	return _outbox.drain()


func to_snapshot() -> Dictionary:
	var stored: Dictionary = {}
	for slot: StringName in _worn:
		stored[String(slot)] = String(_worn[slot])
	return {"slots": stored}


## Replaces every slot from a snapshot (also one that went through JSON). All or
## nothing: Err `save_invalid` when `slots` is missing, a key is not a slot, an id
## is empty or not in the catalog, an item does not fit its slot, or one id sits
## in two slots; nothing changes then. Ownership is not checked: the inventory may
## be restored later. Emits no events and leaves pending ones alone.
func restore(data: Dictionary) -> Result:
	var reader := SnapshotReader.new(data, "equipment")
	var stored := reader.read_dict("slots")
	var worn: Dictionary[StringName, StringName] = {}
	for slot_name: String in stored.keys():
		var id := _read_slot(stored, slot_name)
		if worn.values().has(id):
			stored.fail(slot_name, "%s is already in another slot" % id)
		worn[StringName(slot_name)] = id
	if reader.failed():
		return reader.result()
	_worn = worn
	return Result.ok()


func _fits(slot: StringName, def: ItemDefinition) -> bool:
	if def.equip_slot == &"trinket":
		return TRINKET_SLOTS.has(slot)
	return def.equip_slot == slot


# The item id saved for one slot, checked against the slots and the catalog.
func _read_slot(stored: SnapshotReader, slot_name: String) -> StringName:
	if not SLOTS.has(StringName(slot_name)):
		stored.fail(slot_name, "unknown slot")
		return &""
	var id := StringName(stored.read_string(slot_name))
	var def := _inventory.definition(id)
	if def == null:
		stored.fail(slot_name, "unknown item '%s'" % id)
	elif not _fits(StringName(slot_name), def):
		stored.fail(slot_name, "%s does not fit this slot" % id)
	return id
