## Maps the content-format.md §C call names onto FactProvider reads (architecture.md §3.4).
## `truth` serves the boolean calls and `value` the numeric/enum calls. The parser has already
## checked names and argument counts, so an unknown name here is a programmer error.
## `args` holds the bound call arguments: ids and words as StringName.
class_name FactCalls
extends RefCounted

const _QUEST_STATUS_CALLS: Dictionary[StringName, StringName] = {
	&"quest_active": FactProvider.QUEST_ACTIVE,
	&"quest_done": FactProvider.QUEST_COMPLETED,
	&"quest_failed": FactProvider.QUEST_FAILED,
}


static func truth(call_name: StringName, args: Array, facts: FactProvider) -> bool:
	if _QUEST_STATUS_CALLS.has(call_name):
		return facts.quest_status(_id(args)) == _QUEST_STATUS_CALLS[call_name]
	match call_name:
		&"flag":
			return facts.has_flag(_id(args))
		&"ms":
			return facts.has_milestone(_id(args))
		&"has_item":
			return facts.item_count(_id(args)) >= 1
		&"has_clue":
			return facts.has_clue(_id(args))
		&"ded":
			return facts.has_deduction(_id(args))
		&"perk":
			return facts.has_perk(_id(args))
		&"in_party":
			return facts.in_party(_id(args))
		&"visited":
			return facts.visited(_id(args))
		&"rumor_heard":
			return facts.rumor_heard(_id(args))
		&"finale_seized":
			return facts.finale_value(FactProvider.FINALE_SEIZED) == &"true"
	assert(false, "unknown boolean call: %s" % call_name)
	return false


## An int for the numeric calls, a StringName for `rep_tier`, `quest_stage` and the finale calls.
static func value(call_name: StringName, args: Array, facts: FactProvider) -> Variant:
	match call_name:
		&"var":
			return facts.get_var(_id(args))
		&"items":
			return facts.item_count(_id(args))
		&"stat":
			return facts.attribute(_id(args))
		&"skill":
			return facts.check_total(_id(args))
		&"rep":
			return facts.reputation(_id(args))
		&"rep_tier":
			return facts.rep_tier(_id(args))
		&"quest_stage":
			return facts.quest_stage(_id(args))
		&"count_ms":
			return _count_ms(args, facts)
	return _global_value(call_name, facts)


## The calls that take no argument.
static func _global_value(call_name: StringName, facts: FactProvider) -> Variant:
	match call_name:
		&"stage":
			return facts.escalation_stage()
		&"act":
			return facts.act()
		&"level":
			return facts.level()
		&"crowns":
			return facts.crowns()
		&"queen":
			return facts.queen_condition()
		&"finale_oath":
			return facts.finale_value(FactProvider.FINALE_OATH)
		&"finale_anselm":
			return facts.finale_value(FactProvider.FINALE_ANSELM)
	assert(false, "unknown value call: %s" % call_name)
	return null


static func _count_ms(args: Array, facts: FactProvider) -> int:
	var reached: int = 0
	for arg: Variant in args:
		var id: StringName = arg
		if facts.has_milestone(id):
			reached += 1
	return reached


static func _id(args: Array) -> StringName:
	var id: StringName = args[0]
	return id
