## The story's global facts: flags, bounded integer variables, write-once
## milestones and the current act (architecture.md §4.3; content-format.md §E;
## gdd.md §6.1). Records an event only when state really changes.
class_name WorldState
extends Snapshotable

const FIRST_ACT := 1
const LAST_ACT := 3

var _bounds: Dictionary[StringName, Vector2i] = {}
var _flags: Dictionary[StringName, bool] = {}
var _vars: Dictionary[StringName, int] = {}
var _reached: Array[StringName] = []
var _act: int = FIRST_ACT
var _outbox := EventOutbox.new()


## `var_bounds` maps a var id to its inclusive (min, max); `add_var` clamps to it.
func _init(var_bounds: Dictionary[StringName, Vector2i] = {}) -> void:
	for id: StringName in var_bounds:
		var range_limits: Vector2i = var_bounds[id]
		assert(range_limits.x <= range_limits.y, "var bounds must have min <= max")
	_bounds = var_bounds.duplicate()


func set_flag(id: StringName, value: bool = true) -> void:
	if has_flag(id) == value:
		return
	if value:
		_flags[id] = true
	else:
		_flags.erase(id)
	_outbox.record(FlagChanged.new(id, value))


func has_flag(id: StringName) -> bool:
	return _flags.has(id)


## Sets the var exactly, ignoring any bounds.
func set_var(id: StringName, value: int) -> void:
	var before := get_var(id)
	if before == value:
		return
	_vars[id] = value
	_outbox.record(VarChanged.new(id, before, value))


## Adds `delta`, clamping to the var's bounds when it has them.
func add_var(id: StringName, delta: int) -> void:
	var target := get_var(id) + delta
	if _bounds.has(id):
		var limits: Vector2i = _bounds[id]
		target = clampi(target, limits.x, limits.y)
	set_var(id, target)


func get_var(id: StringName) -> int:
	return _vars.get(id, 0)


## True the first time; later calls change nothing and return false.
func reach_milestone(id: StringName) -> bool:
	if has_milestone(id):
		return false
	_reached.append(id)
	_outbox.record(MilestoneReached.new(id))
	return true


func has_milestone(id: StringName) -> bool:
	return _reached.has(id)


## Reached milestones in the order they were reached.
func milestones() -> Array[StringName]:
	return _reached.duplicate()


func count_milestones(ids: Array[StringName]) -> int:
	var total := 0
	for id: StringName in ids:
		if has_milestone(id):
			total += 1
	return total


func set_act(n: int) -> void:
	assert(n >= FIRST_ACT and n <= LAST_ACT, "act must be 1..3")
	if n == _act:
		return
	var before := _act
	_act = n
	_outbox.record(ActChanged.new(before, n))


func act() -> int:
	return _act


func drain_events() -> Array[DomainEvent]:
	return _outbox.drain()


func to_snapshot() -> Dictionary:
	var flag_ids: Array[StringName] = _flags.keys()
	flag_ids.sort_custom(func(a: StringName, b: StringName) -> bool: return String(a) < String(b))
	var flag_names: Array[String] = []
	for id: StringName in flag_ids:
		flag_names.append(String(id))
	var var_values: Dictionary = {}
	for id: StringName in _vars:
		var_values[String(id)] = _vars[id]
	var milestone_names: Array[String] = []
	for id: StringName in _reached:
		milestone_names.append(String(id))
	return {"flags": flag_names, "vars": var_values, "milestones": milestone_names, "act": _act}


## Replaces all state from a snapshot (also one that went through JSON, where
## ints come back as floats). Emits no events.
func restore(data: Dictionary) -> void:
	_flags.clear()
	_vars.clear()
	_reached.clear()
	var flag_names: Array = data["flags"]
	for flag_name: String in flag_names:
		_flags[StringName(flag_name)] = true
	var var_values: Dictionary = data["vars"]
	for var_name: String in var_values:
		var stored: float = var_values[var_name]
		_vars[StringName(var_name)] = int(stored)
	var milestone_names: Array = data["milestones"]
	for milestone_name: String in milestone_names:
		_reached.append(StringName(milestone_name))
	var stored_act: float = data["act"]
	_act = int(stored_act)
