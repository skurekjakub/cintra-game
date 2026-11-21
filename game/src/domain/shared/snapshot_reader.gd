## Reads one saved section for restore(): typed values with range checks, keeping
## the first problem with its path, so restore() can validate everything before it
## changes anything (architecture.md §4 "Conventions for every domain", restore
## contract). JSON numbers arrive as floats: an integral float is an int, 2.5 is
## not. A failed read returns a neutral value; check failed() before using any.
## Usage: var r := SnapshotReader.new(data, "wallet"); var n := r.read_int("crowns",
## 0, SnapshotReader.INT_MAX); if r.failed(): return r.result()
class_name SnapshotReader
extends RefCounted

const ERROR_CODE: StringName = &"save_invalid"
const INT_MAX: int = 9223372036854775807
const INT_MIN: int = -9223372036854775807 - 1
## A float at or beyond this magnitude does not convert to an int safely.
const _FLOAT_INT_LIMIT: float = 9.0e18

var _data: Dictionary
var _path: String
## The reader that keeps the first problem: null on the root, which keeps its own.
var _root: SnapshotReader
var _first_error: String = ""


## `path` is the section name for a root reader; read_dict() builds the children.
func _init(data: Dictionary, path: String, root: SnapshotReader = null) -> void:
	_data = data
	_path = path
	_root = root


func failed() -> bool:
	return _sink()._first_error != ""


## Ok when nothing failed, otherwise Err `save_invalid` with "<path>.<key>: <reason>".
func result() -> Result:
	if failed():
		return Result.err(ERROR_CODE, _sink()._first_error)
	return Result.ok()


## Records a problem with `key` under this reader's path (only the first one is kept).
func fail(key: String, reason: String) -> void:
	var sink := _sink()
	if sink._first_error == "":
		sink._first_error = "%s.%s: %s" % [_path, key, reason]


func has(key: String) -> bool:
	return _data.has(key)


## The keys of this dictionary; a key that is not a non-empty String fails.
func keys() -> Array[String]:
	var names: Array[String] = []
	for key: Variant in _data:
		var key_name: String = key if typeof(key) == TYPE_STRING else ""
		if key_name == "":
			fail(str(key), "key must be a non-empty string")
			continue
		names.append(key_name)
	return names


func read_int(key: String, min_value: int, max_value: int) -> int:
	if not _require(key):
		return min_value
	return int_value(_data[key], key, min_value, max_value)


func read_bool(key: String) -> bool:
	if not _require(key) or not _is_type(_data[key], TYPE_BOOL, key):
		return false
	var flag: bool = _data[key]
	return flag


func read_string(key: String) -> String:
	if not _require(key):
		return ""
	return string_value(_data[key], key)


## A child reader for a nested dictionary; its problems carry the full path.
func read_dict(key: String) -> SnapshotReader:
	var nested: Dictionary = {}
	if _require(key) and _is_type(_data[key], TYPE_DICTIONARY, key):
		nested = _data[key]
	return SnapshotReader.new(nested, "%s.%s" % [_path, key], _sink())


func read_array(key: String) -> Array:
	if not _require(key) or not _is_type(_data[key], TYPE_ARRAY, key):
		return []
	var list: Array = _data[key]
	return list


## A list of ids: every entry a non-empty String, none repeated.
func read_ids(key: String) -> Array[StringName]:
	var ids: Array[StringName] = []
	var list := read_array(key)
	for i: int in list.size():
		var label := "%s[%d]" % [key, i]
		var id := StringName(string_value(list[i], label))
		if id == &"":
			fail(label, "empty id")
		elif ids.has(id):
			fail(label, "repeated id %s" % id)
		ids.append(id)
	return ids


## Checks a value read elsewhere (an array entry) as an int in min..max.
func int_value(value: Variant, key: String, min_value: int, max_value: int) -> int:
	var number: int = min_value
	if typeof(value) == TYPE_INT:
		number = value
	elif typeof(value) == TYPE_FLOAT:
		var real: float = value
		if real != floorf(real):
			fail(key, "%s is not an integer" % real)
			return min_value
		if absf(real) >= _FLOAT_INT_LIMIT:
			fail(key, "%s is out of range" % real)
			return min_value
		number = int(real)
	else:
		fail(key, "expected an integer, got %s" % type_string(typeof(value)))
		return min_value
	if number < min_value or number > max_value:
		fail(key, "%d is outside %d..%d" % [number, min_value, max_value])
		return min_value
	return number


## Checks a value read elsewhere (an array entry) as a String.
func string_value(value: Variant, key: String) -> String:
	if not _is_type(value, TYPE_STRING, key):
		return ""
	var text: String = value
	return text


func _require(key: String) -> bool:
	if _data.has(key):
		return true
	fail(key, "missing")
	return false


func _is_type(value: Variant, type: Variant.Type, key: String) -> bool:
	if typeof(value) == type:
		return true
	fail(key, "expected %s, got %s" % [type_string(type), type_string(typeof(value))])
	return false


func _sink() -> SnapshotReader:
	if _root != null:
		return _root
	return self
