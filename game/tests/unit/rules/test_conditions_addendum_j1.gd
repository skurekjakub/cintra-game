## Addendum §J.1 (content-format.md): the calls equipped, disguised, heard_from, map_unlocked and
## map_pinned, plus the two parser hardenings (a compare needs a call; closed word sets).
extends GutTest


func _parse(text: String) -> Condition:
	var r := ConditionParser.parse(text)
	assert_true(r.is_ok(), "%s: %s %s" % [text, r.error_code, r.detail])
	if r.is_err():
		return null
	var c: Condition = r.value
	return c


func _eval(text: String, f: FakeFactProvider) -> bool:
	var c := _parse(text)
	return c.evaluate(f) if c != null else false


func _code(text: String) -> StringName:
	return ConditionParser.parse(text).error_code


func test_equipped_evaluates() -> void:
	var f := FakeFactProvider.new()
	assert_false(_eval("equipped(item.kosk_badge)", f))
	f.equipped_items[&"item.kosk_badge"] = true
	assert_true(_eval("equipped(item.kosk_badge)", f))
	assert_false(_eval("equipped(item.choir_robe)", f))


func test_disguised_evaluates() -> void:
	var f := FakeFactProvider.new()
	assert_false(_eval("disguised()", f))
	f.disguised_value = true
	assert_true(_eval("disguised()", f))
	assert_false(_eval("not disguised()", f))


func test_heard_from_evaluates_per_source() -> void:
	var f := FakeFactProvider.new()
	assert_false(_eval("heard_from(rumor.r12_morrow_gull, npc.bertha)", f))
	f.heard_sources[&"rumor.r12_morrow_gull"] = [&"npc.bertha"]
	assert_true(_eval("heard_from(rumor.r12_morrow_gull, npc.bertha)", f))
	assert_false(_eval("heard_from(rumor.r12_morrow_gull, npc.jorun)", f))
	assert_false(_eval("heard_from(rumor.r13_other, npc.bertha)", f))


func test_map_calls_evaluate() -> void:
	var f := FakeFactProvider.new()
	assert_false(_eval("map_unlocked(map.silver_mine)", f))
	assert_false(_eval("map_pinned(map.silver_mine)", f))
	f.unlocked_maps[&"map.silver_mine"] = true
	assert_true(_eval("map_unlocked(map.silver_mine)", f))
	assert_false(_eval("map_pinned(map.silver_mine)", f))
	f.pinned_maps[&"map.silver_mine"] = true
	assert_true(_eval("map_pinned(map.silver_mine)", f))
	assert_false(_eval("map_unlocked(map.other)", f))


func test_heard_from_references_both_ids() -> void:
	var c := _parse("heard_from(rumor.r12_morrow_gull, npc.bertha)")
	if c == null:
		return
	assert_eq(c.referenced_ids(), [&"rumor.r12_morrow_gull", &"npc.bertha"] as Array[StringName])


func test_new_calls_reference_their_ids() -> void:
	var c := _parse("equipped(item.a) and map_pinned(map.b) and map_unlocked(map.b) and disguised()")
	if c == null:
		return
	assert_eq(c.referenced_ids(), [&"item.a", &"map.b"] as Array[StringName])


func test_heard_from_arity_errors() -> void:
	assert_eq(_code("heard_from(rumor.a)"), &"bad_arg_count")
	assert_eq(_code("heard_from()"), &"bad_arg_count")
	assert_eq(_code("heard_from(rumor.a, npc.b, npc.c)"), &"bad_arg_count")
	assert_eq(_code("equipped()"), &"bad_arg_count")
	assert_eq(_code("equipped(item.a, item.b)"), &"bad_arg_count")
	assert_eq(_code("disguised(item.a)"), &"bad_arg_count")
	assert_eq(_code("map_pinned(map.a, map.b)"), &"bad_arg_count")


func test_new_calls_check_id_kinds() -> void:
	assert_eq(_code("equipped(npc.bertha)"), &"bad_arg")
	assert_eq(_code("heard_from(npc.bertha, rumor.a)"), &"bad_arg")
	assert_eq(_code("heard_from(rumor.a, item.b)"), &"bad_arg")
	assert_eq(_code("map_unlocked(zone.a)"), &"bad_arg")
	assert_eq(_code("map_pinned(item.a)"), &"bad_arg")


func test_new_calls_are_booleans_not_values() -> void:
	for call_name: StringName in [&"equipped", &"disguised", &"heard_from", &"map_unlocked", &"map_pinned"]:
		assert_eq(ConditionCalls.returns(call_name), &"bool", String(call_name))
	assert_eq(_code("disguised() == true"), &"bad_call_use")
	assert_eq(_code("equipped(item.a) >= 1"), &"bad_call_use")


func test_call_table_declares_several_specs() -> void:
	var specs := ConditionCalls.params(&"heard_from")
	assert_eq(specs.size(), 2)
	assert_true(specs[0].convert("rumor.r01").is_ok())
	assert_true(specs[0].convert("npc.bertha").is_err())
	assert_true(specs[1].convert("npc.bertha").is_ok())
	assert_true(specs[1].convert("rumor.r01").is_err())
	assert_eq(ConditionCalls.params(&"disguised").size(), 0)
	assert_eq(ConditionCalls.params(&"equipped").size(), 1)
	assert_eq(ConditionCalls.params(&"in_party").size(), 1)
	assert_true(ConditionCalls.params(&"count_ms")[0].variadic)


func test_call_table_closed_words() -> void:
	assert_eq(ConditionCalls.words(&"finale_oath"), [&"true", &"reversed", &"none"] as Array[StringName])
	assert_eq(ConditionCalls.words(&"finale_anselm"), [&"alive", &"dead", &"fled"] as Array[StringName])
	assert_eq(ConditionCalls.words(&"quest_stage"), [] as Array[StringName])
	assert_eq(ConditionCalls.words(&"flag"), [] as Array[StringName])
	assert_eq(ConditionCalls.words(&"teleport"), [] as Array[StringName])


func test_compare_without_a_call_is_bad_compare() -> void:
	assert_eq(_code("finale_oath == true"), &"bad_compare")
	assert_eq(_code("true == finale_oath"), &"bad_compare")
	assert_eq(_code("1 == 1"), &"bad_compare")
	assert_eq(_code("1 < 2"), &"bad_compare")
	assert_eq(_code("true == true"), &"bad_compare")
	assert_eq(_code("friendly == friendly"), &"bad_compare")
	assert_eq(_code("alive != dead"), &"bad_compare")
	assert_eq(_code("finale_oath == true and flag(flag.a)"), &"bad_compare")


func test_compare_without_a_call_names_the_text() -> void:
	var r := ConditionParser.parse("finale_oath == true")
	assert_string_contains(r.detail, "finale_oath == true")
	assert_string_contains(r.detail, "call")
	var nested := ConditionParser.parse("flag(flag.a) and (finale_oath == true)")
	assert_eq(nested.error_code, &"bad_compare")
	assert_string_contains(nested.detail, "finale_oath == true")


func test_compare_with_a_call_stays_valid() -> void:
	var f := FakeFactProvider.new()
	f.finale[FactProvider.FINALE_OATH] = &"true"
	assert_true(_eval("finale_oath() == true", f))
	assert_true(_eval("true == finale_oath()", f))
	assert_true(_eval("stage() == 0", f))
	assert_true(_eval("0 == stage()", f))


func test_closed_word_set_rejects_other_words() -> void:
	assert_eq(_code("finale_oath() == maybe"), &"bad_compare")
	assert_eq(_code("finale_oath() != maybe"), &"bad_compare")
	assert_eq(_code("maybe == finale_oath()"), &"bad_compare")
	assert_eq(_code("finale_oath() == fled"), &"bad_compare")
	assert_eq(_code("finale_anselm() == true"), &"bad_compare")
	assert_eq(_code("finale_anselm() == alive_and_well"), &"bad_compare")
	var r := ConditionParser.parse("finale_oath() == maybe")
	assert_string_contains(r.detail, "maybe")
	assert_string_contains(r.detail, "finale_oath() == maybe")


func test_closed_word_set_accepts_every_member() -> void:
	var f := FakeFactProvider.new()
	for word: StringName in [&"true", &"reversed", &"none"]:
		f.finale[FactProvider.FINALE_OATH] = word
		assert_true(_eval("finale_oath() == %s" % word, f), String(word))
		assert_true(_eval("%s == finale_oath()" % word, f), String(word))
	for word: StringName in [&"alive", &"dead", &"fled"]:
		f.finale[FactProvider.FINALE_ANSELM] = word
		assert_true(_eval("finale_anselm() == %s" % word, f), String(word))
		assert_false(_eval("finale_anselm() != %s" % word, f), String(word))
	assert_true(_eval("finale_anselm() == fled", f))


func test_quest_stage_words_stay_open() -> void:
	var f := FakeFactProvider.new()
	f.quest_stages[&"quest.x"] = &"anything_goes"
	assert_true(_eval("quest_stage(quest.x) == anything_goes", f))
	assert_true(_eval("quest_stage(quest.x) != somewhere_else", f))


func test_two_word_calls_with_different_word_sets_are_bad_compare() -> void:
	assert_eq(_code("finale_oath() == finale_anselm()"), &"bad_compare")
	assert_eq(_code("finale_anselm() != finale_oath()"), &"bad_compare")
	assert_eq(_code("quest_stage(quest.a) == finale_oath()"), &"bad_compare")
	assert_eq(_code("finale_oath() == quest_stage(quest.a)"), &"bad_compare")
	var r := ConditionParser.parse("finale_oath() == finale_anselm()")
	assert_string_contains(r.detail, "finale_oath")
	assert_string_contains(r.detail, "finale_anselm")


func test_two_open_word_calls_compare() -> void:
	var f := FakeFactProvider.new()
	f.quest_stages[&"quest.a"] = &"audience"
	f.quest_stages[&"quest.b"] = &"audience"
	assert_true(_eval("quest_stage(quest.a) == quest_stage(quest.b)", f))
	f.quest_stages[&"quest.b"] = &"epilogue"
	assert_true(_eval("quest_stage(quest.a) != quest_stage(quest.b)", f))


func test_two_word_calls_with_the_same_closed_set_compare() -> void:
	var f := FakeFactProvider.new()
	f.finale[FactProvider.FINALE_OATH] = &"true"
	assert_true(_eval("finale_oath() == finale_oath()", f))


func test_content_probe_real_conditions_parse() -> void:
	var texts: Array[String] = [
		"equipped(item.choir_robe) and has_item(item.pale_feather)",
		"disguised()",
		"map_pinned(map.silver_mine)",
		"heard_from(rumor.r18_brzezina_lodge, npc.bertha)",
		"not equipped(item.kosk_badge)",
	]
	var f := FakeFactProvider.new()
	for text: String in texts:
		var c := _parse(text)
		if c != null:
			c.evaluate(f)  # a name missing from FactCalls asserts here
