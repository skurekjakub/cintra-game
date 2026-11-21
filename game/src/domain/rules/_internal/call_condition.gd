## A boolean call such as `flag(flag.x)` or `quest_done(quest.q)` (content-format.md §C
## "Boolean calls"). `args` are the bound arguments, `ids` the content ids among them.
class_name CallCondition
extends Condition

var _call_name: StringName
var _args: Array
var _ids: Array[StringName] = []


func _init(call_name: StringName, args: Array, ids: Array[StringName]) -> void:
	_call_name = call_name
	_args = args.duplicate()
	_merge_ids(_ids, ids)


func evaluate(facts: FactProvider) -> bool:
	return FactCalls.truth(_call_name, _args, facts)


func referenced_ids() -> Array[StringName]:
	var out: Array[StringName] = []
	out.append_array(_ids)
	return out
