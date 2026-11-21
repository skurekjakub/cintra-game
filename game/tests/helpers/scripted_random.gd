## Test fake: a RandomSource that replays fixed rolls in order (architecture.md §9.3, §9.6).
## randi_range asserts that the scripted value fits the asked range, and that the
## script is not used up, so a test that rolls more than it scripted fails loudly.
class_name ScriptedRandom
extends RandomSource

var _ints: Array[int] = []
var _floats: Array[float] = []
var _int_index: int = 0
var _float_index: int = 0


func _init(ints: Array[int] = [], floats: Array[float] = []) -> void:
	_ints.assign(ints)
	_floats.assign(floats)


func randi_range(from: int, to: int) -> int:
	assert(_int_index < _ints.size(), "ScriptedRandom: int script exhausted")
	var value: int = _ints[_int_index]
	_int_index += 1
	assert(value >= from and value <= to, "ScriptedRandom: %d is outside [%d, %d]" % [value, from, to])
	return value


func randf() -> float:
	assert(_float_index < _floats.size(), "ScriptedRandom: float script exhausted")
	var value: float = _floats[_float_index]
	_float_index += 1
	return value


func get_state() -> Dictionary:
	return {"int_index": _int_index, "float_index": _float_index}


func set_state(data: Dictionary) -> void:
	assert(data.has("int_index") and data.has("float_index"), "ScriptedRandom state needs int_index and float_index")
	_int_index = int(data["int_index"])
	_float_index = int(data["float_index"])
