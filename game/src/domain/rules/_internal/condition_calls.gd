## ConditionCalls: the table of condition calls, their result type and their argument specs
## (content-format.md §C "Boolean calls" and "Numeric or enum calls"; architecture.md §3.4).
## FactCalls evaluates the same names, so a call added here needs a branch there.
## Result types: &"bool", ConditionValue.VALUE_INT/VALUE_TIER/VALUE_WORD (&"int", &"tier", &"word").
## A spec string is an ArgSpec; "" means the call takes no argument.
class_name ConditionCalls
extends RefCounted

const BOOL: StringName = &"bool"

const _BOOL_CALLS: Dictionary[StringName, String] = {
	&"flag": "id:flag",
	&"ms": "id:ms",
	&"has_item": "id:item",
	&"has_clue": "id:clue",
	&"ded": "id:ded",
	&"perk": "id:perk",
	&"in_party": "id:companion|ally",
	&"quest_active": "id:quest",
	&"quest_done": "id:quest",
	&"quest_failed": "id:quest",
	&"visited": "id:zone",
	&"rumor_heard": "id:rumor",
	&"finale_seized": "",
}
const _INT_CALLS: Dictionary[StringName, String] = {
	&"var": "id:var",
	&"items": "id:item",
	&"rep": "id:faction",
	&"stage": "",
	&"act": "",
	&"level": "",
	&"crowns": "",
	&"queen": "",
	&"count_ms": "id:ms+",
}
const _TIER_CALLS: Dictionary[StringName, String] = {
	&"rep_tier": "id:faction",
}
const _WORD_CALLS: Dictionary[StringName, String] = {
	&"quest_stage": "id:quest",
	&"finale_oath": "",
	&"finale_anselm": "",
}

static var _returns: Dictionary[StringName, StringName] = {}
static var _spec_texts: Dictionary[StringName, String] = {}


## The result type of `call_name` (see the header), or &"" when the call is unknown.
static func returns(call_name: StringName) -> StringName:
	_ensure_built()
	return _returns.get(call_name, &"")


## One ArgSpec per parameter of `call_name`. Empty for a call without arguments and for an unknown call.
static func params(call_name: StringName) -> Array[ArgSpec]:
	_ensure_built()
	var specs: Array[ArgSpec] = []
	var spec_text: String = _spec_texts.get(call_name, "")
	if not spec_text.is_empty():
		specs.append(ArgSpec.parse(spec_text))
	return specs


static func _ensure_built() -> void:
	if not _returns.is_empty():
		return
	_register(BOOL, _BOOL_CALLS)
	_register(ConditionValue.VALUE_INT, _INT_CALLS)
	_register(ConditionValue.VALUE_INT, {
		&"stat": "word:" + "|".join(CheckSkills.ATTRIBUTES),
		&"skill": "word:" + "|".join(CheckSkills.DIALOGUE_SKILLS),
	})
	_register(ConditionValue.VALUE_TIER, _TIER_CALLS)
	_register(ConditionValue.VALUE_WORD, _WORD_CALLS)


static func _register(result_type: StringName, calls: Dictionary[StringName, String]) -> void:
	for call_name: StringName in calls:
		assert(not _returns.has(call_name), "ConditionCalls: '%s' is registered twice" % call_name)
		_returns[call_name] = result_type
		_spec_texts[call_name] = calls[call_name]
