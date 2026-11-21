## A numeric/enum call used as a side of a comparison, e.g. `stage()` or `rep_tier(faction.x)`
## (content-format.md §C "Numeric or enum calls"). `type` is the call's result type.
class_name CallValue
extends ConditionValue

var _call_name: StringName
var _args: Array
var _ids: Array[StringName] = []
var _type: StringName


func _init(call_name: StringName, args: Array, ids: Array[StringName], type: StringName) -> void:
	_call_name = call_name
	_args = args.duplicate()
	_type = type
	for id: StringName in ids:
		if not _ids.has(id):
			_ids.append(id)


func resolve(facts: FactProvider) -> Variant:
	return FactCalls.value(_call_name, _args, facts)


func value_type() -> StringName:
	return _type


func referenced_ids() -> Array[StringName]:
	var out: Array[StringName] = []
	out.append_array(_ids)
	return out
