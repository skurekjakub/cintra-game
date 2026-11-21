## EffectSpec: one parsed effect of a content file, an op plus its converted arguments
## (content-format.md §E effect arguments; architecture.md §3.4). Immutable by convention.
## `ids` are the content ids among the args, for the content validator's reference check.
class_name EffectSpec
extends RefCounted

var op: StringName = &""
var args: Array = []

var _ids: Array[StringName] = []


func _init(op_name: StringName, op_args: Array, ids: Array[StringName]) -> void:
	op = op_name
	args = op_args
	_ids = ids


## Every content id the effect names, in argument order. A copy: callers may modify it.
func referenced_ids() -> Array[StringName]:
	return _ids.duplicate()
