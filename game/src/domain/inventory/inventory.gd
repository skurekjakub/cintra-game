## The party's item stacks: counts per item id, capped by each definition's
## stack_max, with key items and documents protected from removal (gdd.md §6.9
## consumables stack, key items and documents; architecture.md §4.12). A failed
## add or remove changes nothing and records nothing.
class_name Inventory
extends Snapshotable

var _catalog: Dictionary[StringName, ItemDefinition] = {}
var _counts: Dictionary[StringName, int] = {}
var _outbox := EventOutbox.new()


## The catalog maps every known item id to its definition and is shared, not copied.
func _init(item_catalog: Dictionary[StringName, ItemDefinition]) -> void:
	_catalog = item_catalog


## Adds `min(n, room_for(id))`. Ok(added). Err `unknown_item`, or `stack_full`
## when there is no room at all (nothing changes, no event). Records ItemAdded.
func add(id: StringName, n: int = 1) -> Result:
	assert(n >= 1, "n must be at least 1")
	if not _catalog.has(id):
		return Result.err(&"unknown_item")
	var space := room_for(id)
	if space == 0:
		return Result.err(&"stack_full")
	var added := mini(n, space)
	_counts[id] = count(id) + added
	_outbox.record(ItemAdded.new(id, added, _counts[id]))
	return Result.ok(added)


## Takes exactly `n`, never a part of it. Ok(n). Err `protected_item` (a key item
## or document without `force`, checked first, even when none is held) or
## `not_enough` (fewer than n held, an unknown id included). A failure changes
## nothing and records nothing. Records ItemRemoved.
func remove(id: StringName, n: int = 1, force: bool = false) -> Result:
	assert(n >= 1, "n must be at least 1")
	if not force and _catalog.has(id) and _catalog[id].is_protected():
		return Result.err(&"protected_item")
	var held := count(id)
	if held < n:
		return Result.err(&"not_enough")
	if held == n:
		_counts.erase(id)
	else:
		_counts[id] = held - n
	_outbox.record(ItemRemoved.new(id, n, count(id)))
	return Result.ok(n)


func count(id: StringName) -> int:
	if _counts.has(id):
		return _counts[id]
	return 0


func has(id: StringName) -> bool:
	return count(id) > 0


## How many more of `id` fit before its stack is full; 0 for an unknown id.
func room_for(id: StringName) -> int:
	if not _catalog.has(id):
		return 0
	return _catalog[id].stack_max - count(id)


## The held ids of one category, sorted alphabetically.
func items_in(category: StringName) -> Array[StringName]:
	var ids: Array[StringName] = []
	for id: StringName in _counts:
		if _catalog[id].category == category:
			ids.append(id)
	return _sorted(ids)


## Every held id, sorted alphabetically.
func all_ids() -> Array[StringName]:
	var ids: Array[StringName] = []
	ids.assign(_counts.keys())
	return _sorted(ids)


## The definition of `id`, or null when the catalog does not know it.
func definition(id: StringName) -> ItemDefinition:
	if _catalog.has(id):
		return _catalog[id]
	return null


func drain_events() -> Array[DomainEvent]:
	return _outbox.drain()


func to_snapshot() -> Dictionary:
	var stored: Dictionary = {}
	for id: StringName in _counts:
		stored[String(id)] = _counts[id]
	return {"counts": stored}


## Replaces all stacks from a snapshot (also one that went through JSON, where
## ints come back as floats). All or nothing: Err `save_invalid` when `counts` is
## missing, an id is not in the catalog, or a count is not an int in
## 1..stack_max; nothing changes then. Emits no events and leaves pending ones alone.
func restore(data: Dictionary) -> Result:
	var reader := SnapshotReader.new(data, "inventory")
	var stored := reader.read_dict("counts")
	var counts: Dictionary[StringName, int] = {}
	for item_name: String in stored.keys():
		var id := StringName(item_name)
		if not _catalog.has(id):
			stored.fail(item_name, "unknown item")
			continue
		counts[id] = stored.read_int(item_name, 1, _catalog[id].stack_max)
	if reader.failed():
		return reader.result()
	_counts = counts
	return Result.ok()


# Sorted by text: Array[StringName].sort() orders by interned pointer instead.
func _sorted(ids: Array[StringName]) -> Array[StringName]:
	ids.sort_custom(func(a: StringName, b: StringName) -> bool: return String(a) < String(b))
	return ids
