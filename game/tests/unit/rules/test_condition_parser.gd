## ConditionParser, ConditionCalls and the condition reader: content-format.md §C (grammar,
## call tables, examples) and architecture.md §3.4.
extends GutTest


func _parse_ok(text: String) -> Condition:
	var r := ConditionParser.parse(text)
	assert_true(r.is_ok(), "%s: %s %s" % [text, r.error_code, r.detail])
	if r.is_err():
		return null
	var c: Condition = r.value
	return c


func _eval(text: String, f: FakeFactProvider) -> bool:
	var c := _parse_ok(text)
	return c.evaluate(f) if c != null else false


func _code(text: String) -> StringName:
	return ConditionParser.parse(text).error_code


func test_spec_examples_parse_and_evaluate() -> void:
	var f := FakeFactProvider.new()
	f.clues[&"clue.chalice_pollen"] = true
	f.check_totals[&"persuade"] = 4
	f.rep_tiers[&"faction.strept"] = &"friendly"
	f.stage = 2
	f.milestones[&"ms.a1_sickroom_done"] = true
	f.milestones[&"ms.a1_ring_done"] = true
	f.quest_stages[&"quest.main_a1"] = &"audience"
	assert_true(_eval("has_clue(clue.chalice_pollen) and skill(persuade) >= 4", f))
	assert_true(_eval("rep_tier(faction.strept) >= friendly or has_item(item.marnadal_torc)", f))
	assert_true(_eval("stage() >= 2 and not flag(flag.strept_guides)", f))
	assert_true(_eval("count_ms(ms.a1_sickroom_done, ms.a1_abbey_done, ms.a1_ring_done) >= 2", f))
	assert_true(_eval("quest_stage(quest.main_a1) == audience", f))


func test_every_call_parses_and_evaluates() -> void:
	var texts: Array[String] = ["true", "false", "flag(flag.a)", "ms(ms.a)", "has_item(item.a)", "has_clue(clue.a)",
			"ded(ded.a)", "perk(perk.a)", "in_party(companion.maelis)", "in_party(ally.aldric)",
			"quest_active(quest.a)", "quest_done(quest.a)", "quest_failed(quest.a)", "visited(zone.a)",
			"rumor_heard(rumor.a)", "finale_seized()", "var(var.a) == 0", "items(item.a) < 3",
			"stat(grit) >= 6", "skill(lore) >= 1", "rep(faction.a) > -10", "stage() >= 0", "level() >= 5",
			"crowns() >= 1", "act() == 2", "queen() <= 2", "count_ms(ms.a, ms.b) >= 1",
			"rep_tier(faction.a) >= wary", "quest_stage(quest.a) == audience", "finale_oath() == true",
			"finale_anselm() != fled"]
	for attribute: StringName in CheckSkills.ATTRIBUTES:
		texts.append("stat(%s) >= 1" % attribute)
	for skill: StringName in CheckSkills.DIALOGUE_SKILLS:
		texts.append("skill(%s) >= 1" % skill)
	for text: String in texts:
		var c := _parse_ok(text)
		if c != null:
			c.evaluate(FakeFactProvider.new())  # a name missing from FactCalls asserts here


func test_precedence_not_and_or() -> void:
	var f := FakeFactProvider.new()
	f.flags[&"flag.b"] = true
	assert_true(_eval("flag(flag.a) and flag(flag.x) or flag(flag.b)", f))
	assert_false(_eval("flag(flag.a) and (flag(flag.x) or flag(flag.b))", f))
	assert_false(_eval("not flag(flag.b) or flag(flag.a)", f))
	assert_true(_eval("not not flag(flag.b)", f))


func test_spacing_and_parens_are_free() -> void:
	var f := FakeFactProvider.new()
	f.stage = 3
	assert_true(_eval("  ((stage()>=3))and(not(flag(flag.x)))  ", f))


func test_true_false_are_literals_without_an_operator() -> void:
	var f := FakeFactProvider.new()
	assert_true(_eval("true and not false", f))
	assert_true(_eval("false or true", f))
	assert_false(_eval("(true) and false", f))


func test_true_as_compare_word() -> void:
	var f := FakeFactProvider.new()
	f.finale[FactProvider.FINALE_OATH] = &"true"
	assert_true(_eval("finale_oath() == true", f))
	assert_true(_eval("true == finale_oath()", f))
	assert_false(_eval("finale_oath() != true", f))


func test_negative_int_compare() -> void:
	var f := FakeFactProvider.new()
	f.reputations[&"faction.varn"] = -20
	assert_true(_eval("rep(faction.varn) <= -10", f))
	assert_false(_eval("rep(faction.varn) > -10", f))


func test_every_operator_evaluates() -> void:
	var f := FakeFactProvider.new()
	f.stage = 2
	assert_true(_eval("stage() == 2 and stage() != 3 and stage() < 3", f))
	assert_true(_eval("stage() <= 2 and stage() > 1 and stage() >= 2", f))
	assert_false(_eval("stage() < 2 or stage() > 2 or stage() != 2", f))


func test_value_on_either_side() -> void:
	var f := FakeFactProvider.new()
	f.stage = 2
	f.rep_tiers[&"faction.strept"] = &"friendly"
	f.rep_tiers[&"faction.varn"] = &"wary"
	assert_true(_eval("1 < stage()", f))
	assert_true(_eval("friendly <= rep_tier(faction.strept)", f))
	assert_true(_eval("rep_tier(faction.strept) > rep_tier(faction.varn)", f))
	assert_true(_eval("stage() == stage()", f))


func test_errors() -> void:
	assert_eq(_code("  "), &"empty_condition")
	assert_eq(_code(""), &"empty_condition")
	assert_eq(_code("flag(flag.a"), &"condition_syntax")
	assert_eq(_code("flag(flag.a) flag(flag.b)"), &"condition_syntax")
	assert_eq(_code("teleport(zone.a)"), &"unknown_call")
	assert_eq(_code("flag(ms.a)"), &"bad_arg")
	assert_eq(_code("flag()"), &"bad_arg_count")
	assert_eq(_code("stage()"), &"bad_call_use")
	assert_eq(_code("flag(flag.a) == 1"), &"bad_call_use")
	assert_eq(_code("stage() >= friendly"), &"bad_compare")
	assert_eq(_code("rep_tier(faction.a) >= beloved"), &"bad_compare")
	assert_eq(_code("quest_stage(quest.a) > audience"), &"bad_compare")
	assert_eq(_code("skill(sneak) >= 2"), &"bad_arg")


func test_syntax_errors() -> void:
	for text: String in ["()", "not", "flag(flag.a) and", "or flag(flag.a)", "flag(flag.a) or or flag(flag.b)",
			"(flag(flag.a)", "flag(flag.a))", "flag(flag.a,)", "flag(,)", "flag(flag.a flag.b)", "stage() >=",
			"stage() >= >= 1", "4x", "friendly", "4", "flag(flag.a) & flag(flag.b)",
			"and(flag(flag.a))", "stage() == not", "true("]:
		assert_eq(_code(text), &"condition_syntax", text)


func test_argument_errors() -> void:
	assert_eq(_code("stage(1)"), &"bad_arg_count")
	assert_eq(_code("flag(flag.a, flag.b)"), &"bad_arg_count")
	assert_eq(_code("count_ms()"), &"bad_arg_count")
	assert_eq(_code("stat(persuade) >= 1"), &"bad_arg")
	assert_eq(_code("skill(might) >= 1"), &"bad_arg")
	assert_eq(_code("count_ms(ms.a, flag.b) >= 1"), &"bad_arg")
	assert_eq(_code("stage() > 99999999999999999999"), &"bad_arg")


func test_call_use_errors() -> void:
	assert_eq(_code("flag(flag.a) == flag(flag.b)"), &"bad_call_use")
	assert_eq(_code("stage() == flag(flag.a)"), &"bad_call_use")
	assert_eq(_code("flag(flag.a) and stage()"), &"bad_call_use")
	assert_eq(_code("finale_oath()"), &"bad_call_use")
	assert_eq(_code("stage() 4"), &"bad_call_use")


func test_compare_type_errors() -> void:
	assert_eq(_code("finale_oath() == 1"), &"bad_compare")
	assert_eq(_code("quest_stage(quest.a) == rep_tier(faction.a)"), &"bad_compare")
	assert_eq(_code("rep_tier(faction.a) == 2"), &"bad_compare")
	for op_name: String in ["<", "<=", ">", ">="]:
		assert_eq(_code("quest_stage(quest.a) %s audience" % op_name), &"bad_compare", op_name)
		assert_eq(_code("finale_anselm() %s fled" % op_name), &"bad_compare", op_name)
	assert_eq(_code("beloved <= rep_tier(faction.a)"), &"bad_compare")
	assert_eq(_code("friendly >= wary"), &"bad_compare")


func test_error_details_name_the_offending_text() -> void:
	assert_string_contains(ConditionParser.parse("teleport(zone.a)").detail, "teleport")
	assert_string_contains(ConditionParser.parse("flag(ms.a)").detail, "ms.a")
	assert_string_contains(ConditionParser.parse("flag()").detail, "flag")
	assert_string_contains(ConditionParser.parse("stage()").detail, "stage()")
	assert_string_contains(ConditionParser.parse("flag(flag.a) == 1").detail, "flag(flag.a)")
	assert_string_contains(ConditionParser.parse("stage() >= friendly").detail, "stage() >= friendly")
	assert_string_contains(ConditionParser.parse("rep_tier(faction.a) >= beloved").detail, "beloved")
	assert_string_contains(ConditionParser.parse("flag(flag.a) flag(flag.b)").detail, "flag")
	assert_string_contains(ConditionParser.parse("flag(flag.a) & x").detail, "&")


func test_referenced_ids() -> void:
	var c := _parse_ok("has_clue(clue.a) and count_ms(ms.b, ms.c) >= 1 and stage() > 0")
	if c == null:
		return
	assert_eq(c.referenced_ids(), [&"clue.a", &"ms.b", &"ms.c"] as Array[StringName])


func test_referenced_ids_skip_words_and_repeat_once() -> void:
	var c := _parse_ok("rep_tier(faction.a) >= friendly or flag(flag.x) or not flag(flag.x)")
	if c == null:
		return
	assert_eq(c.referenced_ids(), [&"faction.a", &"flag.x"] as Array[StringName])


func test_call_table_return_types() -> void:
	assert_eq(ConditionCalls.returns(&"flag"), &"bool")
	assert_eq(ConditionCalls.returns(&"finale_seized"), &"bool")
	assert_eq(ConditionCalls.returns(&"count_ms"), &"int")
	assert_eq(ConditionCalls.returns(&"stat"), &"int")
	assert_eq(ConditionCalls.returns(&"rep_tier"), &"tier")
	assert_eq(ConditionCalls.returns(&"quest_stage"), &"word")
	assert_eq(ConditionCalls.returns(&"finale_oath"), &"word")
	assert_eq(ConditionCalls.returns(&"teleport"), &"")
	assert_eq(ConditionCalls.returns(&"and"), &"")


func test_call_table_params() -> void:
	assert_eq(ConditionCalls.params(&"finale_seized").size(), 0)
	assert_eq(ConditionCalls.params(&"stage").size(), 0)
	assert_eq(ConditionCalls.params(&"flag").size(), 1)
	assert_eq(ConditionCalls.params(&"teleport").size(), 0)
	var count_ms := ConditionCalls.params(&"count_ms")
	assert_eq(count_ms.size(), 1)
	assert_true(count_ms[0].variadic)
	assert_true(ConditionCalls.params(&"in_party")[0].convert("ally.aldric").is_ok())
	assert_true(ConditionCalls.params(&"in_party")[0].convert("companion.maelis").is_ok())
	assert_true(ConditionCalls.params(&"in_party")[0].convert("item.x").is_err())


func test_stat_and_skill_params_follow_check_skills() -> void:
	var stat := ConditionCalls.params(&"stat")[0]
	var skill := ConditionCalls.params(&"skill")[0]
	for attribute: StringName in CheckSkills.ATTRIBUTES:
		assert_true(stat.convert(String(attribute)).is_ok(), String(attribute))
		assert_true(skill.convert(String(attribute)).is_err(), String(attribute))
	for dialogue_skill: StringName in CheckSkills.DIALOGUE_SKILLS:
		assert_true(skill.convert(String(dialogue_skill)).is_ok(), String(dialogue_skill))
		assert_true(stat.convert(String(dialogue_skill)).is_err(), String(dialogue_skill))
