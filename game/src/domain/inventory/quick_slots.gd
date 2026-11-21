## The four quick item slots, each holding a consumable id or nothing (gdd.md §6.4
## quick items, §6.9 consumables; architecture.md §4.12). A slot keeps its id when
## the stack runs out: the use case checks the inventory count before using it.
class_name QuickSlots
extends Snapshotable

const SIZE: int = 4

var _inventory: Inventory
var _slots: Array[StringName] = []


func _init(inventory: Inventory) -> void:
	_inventory = inventory
	_slots.resize(SIZE)
	_slots.fill(&"")


## Puts an owned consumable into a slot. Err, checked in this order: `bad_index`,
## `not_owned`, `not_consumable`. An id already in another slot moves, leaving
## that slot empty; a failure changes nothing.
func assign(index: int, id: StringName) -> Result:
	if index < 0 or index >= SIZE:
		return Result.err(&"bad_index")
	if not _inventory.has(id):
		return Result.err(&"not_owned")
	if _inventory.definition(id).category != &"consumable":
		return Result.err(&"not_consumable")
	var previous := _slots.find(id)
	if previous != -1:
		_slots[previous] = &""
	_slots[index] = id
	return Result.ok()


func clear(index: int) -> void:
	assert(index >= 0 and index < SIZE, "quick slot index out of range")
	_slots[index] = &""


## The item id in a slot, `&""` when it is empty.
func item_at(index: int) -> StringName:
	assert(index >= 0 and index < SIZE, "quick slot index out of range")
	return _slots[index]


func to_snapshot() -> Dictionary:
	var stored: Array = []
	for id: StringName in _slots:
		stored.append(String(id))
	return {"slots": stored}


## Replaces every slot from a snapshot (also one that went through JSON). All or
## nothing: Err `save_invalid` when `slots` is missing or not a list of exactly
## SIZE strings, an id is not a consumable in the catalog, or one id sits in two
## slots; nothing changes then. `""` is an empty slot. Ownership is not checked:
## the inventory may be restored later.
func restore(data: Dictionary) -> Result:
	var reader := SnapshotReader.new(data, "quick_slots")
	var stored := reader.read_array("slots")
	if not reader.failed() and stored.size() != SIZE:
		reader.fail("slots", "expected %d entries, got %d" % [SIZE, stored.size()])
	var slots: Array[StringName] = []
	for i: int in stored.size():
		var label := "slots[%d]" % i
		var id := StringName(reader.string_value(stored[i], label))
		if id != &"" and slots.has(id):
			reader.fail(label, "%s is already in another slot" % id)
		elif id != &"" and not _is_consumable(id):
			reader.fail(label, "%s is not a known consumable" % id)
		slots.append(id)
	if reader.failed():
		return reader.result()
	_slots = slots
	return Result.ok()


func _is_consumable(id: StringName) -> bool:
	var def := _inventory.definition(id)
	return def != null and def.category == &"consumable"
