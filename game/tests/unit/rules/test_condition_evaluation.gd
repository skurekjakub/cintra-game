## Condition AST evaluation against a FactProvider (content-format.md §C, architecture.md §3.4).
## Nodes are built directly here; the parser comes later.
extends GutTest

const _TIER_ID: StringName = &"faction.strept"


func _ids_in(args: Array) -> Array[StringName]:
	var ids: Array[StringName] = []
	for a: Variant in args:
		var s: StringName = a
		if String(s).contains("."):
			ids.append(s)
	return ids


func _call(n: StringName, args: Array) -> CallCondition:
	return CallCondition.new(n, args, _ids_in(args))


func _val(n: StringName, args: Array, type: StringName) -> CallValue:
	return CallValue.new(n, args, _ids_in(args), type)


func _int(n: int) -> LiteralValue:
	return LiteralValue.new(n, ConditionValue.VALUE_INT)


func _word(w: StringName) -> LiteralValue:
	return LiteralValue.new(w, ConditionValue.VALUE_WORD)


func _tier(t: StringName) -> LiteralValue:
	return LiteralValue.new(t, ConditionValue.VALUE_TIER)


func _as_int(v: ConditionValue, facts: FactProvider) -> int:
	var n: int = v.resolve(facts)
	return n


func _resolve_int(n: StringName, args: Array, facts: FactProvider) -> int:
	return _as_int(_val(n, args, ConditionValue.VALUE_INT), facts)


func _cmp(left: ConditionValue, op: StringName, right: ConditionValue) -> CompareCondition:
	return CompareCondition.new(left, op, right)


func test_flag_and_ms_calls() -> void:
	var f := FakeFactProvider.new()
	f.flags[&"flag.x"] = true
	assert_true(_call(&"flag", [&"flag.x"]).evaluate(f))
	assert_false(_call(&"ms", [&"ms.a1_rat_survived"]).evaluate(f))


func test_has_item_means_at_least_one() -> void:
	var f := FakeFactProvider.new()
	f.items[&"item.iron_key"] = 1
	assert_true(_call(&"has_item", [&"item.iron_key"]).evaluate(f))
	assert_false(_call(&"has_item", [&"item.other"]).evaluate(f))


func test_quest_status_calls() -> void:
	var f := FakeFactProvider.new()
	f.quest_statuses[&"quest.q"] = FactProvider.QUEST_COMPLETED
	assert_true(_call(&"quest_done", [&"quest.q"]).evaluate(f))
	assert_false(_call(&"quest_active", [&"quest.q"]).evaluate(f))
	assert_false(_call(&"quest_failed", [&"quest.q"]).evaluate(f))
	f.quest_statuses[&"quest.q"] = FactProvider.QUEST_FAILED
	assert_true(_call(&"quest_failed", [&"quest.q"]).evaluate(f))
	f.quest_statuses[&"quest.q"] = FactProvider.QUEST_ACTIVE
	assert_true(_call(&"quest_active", [&"quest.q"]).evaluate(f))


func test_remaining_bool_calls_read_their_fact() -> void:
	var f := FakeFactProvider.new()
	f.clues[&"clue.pollen"] = true
	f.deductions[&"ded.poisoned"] = true
	f.perks[&"perk.keen_eye"] = true
	f.party[&"companion.maelis"] = true
	f.visited_zones[&"zone.abbey"] = true
	f.rumors[&"rumor.r01"] = true
	for c: CallCondition in [
			_call(&"has_clue", [&"clue.pollen"]), _call(&"ded", [&"ded.poisoned"]),
			_call(&"perk", [&"perk.keen_eye"]), _call(&"in_party", [&"companion.maelis"]),
			_call(&"visited", [&"zone.abbey"]), _call(&"rumor_heard", [&"rumor.r01"])]:
		assert_true(c.evaluate(f))
	assert_false(_call(&"has_clue", [&"clue.other"]).evaluate(f))
	assert_false(_call(&"in_party", [&"companion.other"]).evaluate(f))


func test_and_or_not_literal() -> void:
	var t := LiteralCondition.new(true)
	var fl := LiteralCondition.new(false)
	var f := FakeFactProvider.new()
	assert_false(AndCondition.new([t, fl] as Array[Condition]).evaluate(f))
	assert_true(AndCondition.new([t, t] as Array[Condition]).evaluate(f))
	assert_true(OrCondition.new([fl, t] as Array[Condition]).evaluate(f))
	assert_false(OrCondition.new([fl, fl] as Array[Condition]).evaluate(f))
	assert_true(NotCondition.new(fl).evaluate(f))
	assert_false(NotCondition.new(t).evaluate(f))


func test_and_or_evaluate_children_against_the_facts() -> void:
	var f := FakeFactProvider.new()
	f.flags[&"flag.a"] = true
	var a := _call(&"flag", [&"flag.a"])
	var b := _call(&"flag", [&"flag.b"])
	assert_false(AndCondition.new([a, b] as Array[Condition]).evaluate(f))
	assert_true(OrCondition.new([b, a] as Array[Condition]).evaluate(f))
	assert_true(NotCondition.new(b).evaluate(f))


func test_int_compare() -> void:
	var f := FakeFactProvider.new()
	f.stage = 2
	var stage := _val(&"stage", [], ConditionValue.VALUE_INT)
	assert_true(_cmp(stage, &">=", _int(2)).evaluate(f))
	assert_true(_cmp(stage, &"==", _int(2)).evaluate(f))
	assert_true(_cmp(stage, &"<=", _int(2)).evaluate(f))
	assert_false(_cmp(stage, &"!=", _int(2)).evaluate(f))
	assert_false(_cmp(stage, &">", _int(2)).evaluate(f))
	assert_false(_cmp(stage, &"<", _int(2)).evaluate(f))
	assert_true(_cmp(stage, &"<", _int(3)).evaluate(f))


func test_negative_int_compare() -> void:
	var f := FakeFactProvider.new()
	f.reputations[&"faction.varn"] = -20
	var rep := _val(&"rep", [&"faction.varn"], ConditionValue.VALUE_INT)
	assert_true(_cmp(rep, &"<", _int(-10)).evaluate(f))
	assert_false(_cmp(rep, &">=", _int(0)).evaluate(f))


func test_numeric_calls_read_their_fact() -> void:
	var f := FakeFactProvider.new()
	f.vars[&"var.bribes"] = 4
	f.items[&"item.torch"] = 3
	f.attributes[&"wits"] = 6
	f.check_totals[&"persuade"] = 5
	f.act_value = 2
	f.level_value = 7
	f.crowns_value = 120
	f.queen_value = 3
	assert_eq(_resolve_int(&"var", [&"var.bribes"], f), 4)
	assert_eq(_resolve_int(&"items", [&"item.torch"], f), 3)
	assert_eq(_resolve_int(&"stat", [&"wits"], f), 6)
	assert_eq(_resolve_int(&"skill", [&"persuade"], f), 5)
	assert_eq(_resolve_int(&"act", [], f), 2)
	assert_eq(_resolve_int(&"level", [], f), 7)
	assert_eq(_resolve_int(&"crowns", [], f), 120)
	assert_eq(_resolve_int(&"queen", [], f), 3)


func test_tier_compare_uses_order() -> void:
	var f := FakeFactProvider.new()
	f.rep_tiers[_TIER_ID] = &"allied"
	var left := _val(&"rep_tier", [_TIER_ID], ConditionValue.VALUE_TIER)
	assert_true(_cmp(left, &">=", _tier(&"friendly")).evaluate(f))
	assert_false(_cmp(left, &"<", _tier(&"wary")).evaluate(f))
	assert_true(_cmp(left, &"==", _tier(&"allied")).evaluate(f))
	assert_true(_cmp(left, &"!=", _tier(&"hostile")).evaluate(f))


func test_tier_compare_is_by_rank_not_by_text() -> void:
	# Alphabetically "allied" < "hostile", but allied outranks hostile.
	var f := FakeFactProvider.new()
	f.rep_tiers[_TIER_ID] = &"hostile"
	var left := _val(&"rep_tier", [_TIER_ID], ConditionValue.VALUE_TIER)
	assert_true(_cmp(left, &"<", _tier(&"allied")).evaluate(f))
	assert_false(_cmp(left, &">", _tier(&"wary")).evaluate(f))


func test_word_compare_allows_equality_only() -> void:
	var f := FakeFactProvider.new()
	f.quest_stages[&"quest.main_a1"] = &"audience"
	var stage := _val(&"quest_stage", [&"quest.main_a1"], ConditionValue.VALUE_WORD)
	assert_true(_cmp(stage, &"==", _word(&"audience")).evaluate(f))
	assert_false(_cmp(stage, &"!=", _word(&"audience")).evaluate(f))
	assert_true(_cmp(stage, &"!=", _word(&"sickroom")).evaluate(f))


func test_finale_values_are_words() -> void:
	var f := FakeFactProvider.new()
	f.finale[FactProvider.FINALE_OATH] = &"reversed"
	f.finale[FactProvider.FINALE_ANSELM] = &"fled"
	var oath := _val(&"finale_oath", [], ConditionValue.VALUE_WORD)
	var anselm := _val(&"finale_anselm", [], ConditionValue.VALUE_WORD)
	assert_true(_cmp(oath, &"==", _word(&"reversed")).evaluate(f))
	assert_true(_cmp(anselm, &"==", _word(&"fled")).evaluate(f))
	assert_true(_cmp(anselm, &"!=", _word(&"dead")).evaluate(f))


func test_count_ms_counts_reached() -> void:
	var f := FakeFactProvider.new()
	f.milestones[&"ms.a"] = true
	f.milestones[&"ms.c"] = true
	var ids: Array = [&"ms.a", &"ms.b", &"ms.c"]
	var v := _val(&"count_ms", ids, ConditionValue.VALUE_INT)
	assert_eq(_as_int(v, f), 2)
	assert_true(_cmp(v, &">=", _int(2)).evaluate(f))
	assert_false(_cmp(v, &">=", _int(3)).evaluate(f))


func test_finale_seized_reads_finale_value() -> void:
	var f := FakeFactProvider.new()
	assert_false(_call(&"finale_seized", []).evaluate(f))
	f.finale[FactProvider.FINALE_SEIZED] = &"true"
	assert_true(_call(&"finale_seized", []).evaluate(f))


func test_value_types() -> void:
	assert_eq(_int(1).value_type(), ConditionValue.VALUE_INT)
	assert_eq(_tier(&"wary").value_type(), ConditionValue.VALUE_TIER)
	assert_eq(_word(&"audience").value_type(), ConditionValue.VALUE_WORD)
	assert_eq(_val(&"stage", [], ConditionValue.VALUE_INT).value_type(), ConditionValue.VALUE_INT)
	assert_eq(ConditionValue.VALUE_INT, &"int")
	assert_eq(ConditionValue.VALUE_TIER, &"tier")
	assert_eq(ConditionValue.VALUE_WORD, &"word")


func test_referenced_ids_dedup_in_order() -> void:
	var c := AndCondition.new([
		_call(&"flag", [&"flag.a"]), _call(&"flag", [&"flag.a"]), _call(&"ms", [&"ms.b"])
	] as Array[Condition])
	assert_eq(c.referenced_ids(), [&"flag.a", &"ms.b"] as Array[StringName])


func test_referenced_ids_through_or_not_and_compare() -> void:
	var rep := _val(&"rep", [&"faction.varn"], ConditionValue.VALUE_INT)
	var cmp := _cmp(rep, &"<", _int(0))
	var tier := _val(&"rep_tier", [&"faction.varn"], ConditionValue.VALUE_TIER)
	var cmp2 := _cmp(tier, &">=", _tier(&"wary"))
	var c := OrCondition.new([
		NotCondition.new(_call(&"flag", [&"flag.z"])), cmp, cmp2, LiteralCondition.new(true)
	] as Array[Condition])
	assert_eq(c.referenced_ids(), [&"flag.z", &"faction.varn"] as Array[StringName])


func test_referenced_ids_of_compare_covers_both_sides_once() -> void:
	var left := _val(&"items", [&"item.a"], ConditionValue.VALUE_INT)
	var right := _val(&"items", [&"item.a"], ConditionValue.VALUE_INT)
	var c := _cmp(left, &">", right)
	assert_eq(c.referenced_ids(), [&"item.a"] as Array[StringName])


func test_referenced_ids_of_calls_dedup_and_literals_have_none() -> void:
	var ids: Array = [&"ms.a", &"ms.b", &"ms.a"]
	var v := _val(&"count_ms", ids, ConditionValue.VALUE_INT)
	assert_eq(v.referenced_ids(), [&"ms.a", &"ms.b"] as Array[StringName])
	assert_eq(_call(&"count_ms", ids).referenced_ids(), [&"ms.a", &"ms.b"] as Array[StringName])
	assert_eq(_int(3).referenced_ids(), [] as Array[StringName])
	assert_eq(_tier(&"wary").referenced_ids(), [] as Array[StringName])
	assert_eq(LiteralCondition.new(true).referenced_ids(), [] as Array[StringName])


func test_referenced_ids_returns_a_copy() -> void:
	var c := _call(&"flag", [&"flag.a"])
	var first := c.referenced_ids()
	first.append(&"flag.zzz")
	assert_eq(c.referenced_ids(), [&"flag.a"] as Array[StringName])
