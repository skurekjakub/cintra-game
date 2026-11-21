## EffectParser over the §E signature set: content-format.md §E (effects) and architecture.md
## §3.4 (open/closed registry: a new effect op is one signature registration, no parser change).
extends GutTest

var _p := EffectParser.new(ContentFormatEffects.signatures())


func _spec(text: String) -> EffectSpec:
	var r := _p.parse(text)
	assert_true(r.is_ok(), "%s: %s %s" % [text, r.error_code, r.detail])
	if r.is_err():
		return null
	var e: EffectSpec = r.value
	return e


func test_registry_has_exactly_the_35_spec_ops() -> void:
	assert_eq(ContentFormatEffects.signatures().ops().size(), 35)


func test_parses_args_with_types() -> void:
	var e := _spec("give_item(item.dravin_letter, 1)")
	assert_eq(e.op, &"give_item")
	assert_eq(e.args, [&"item.dravin_letter", 1])
	assert_eq(e.referenced_ids(), [&"item.dravin_letter"] as Array[StringName])


func test_negative_and_default_args() -> void:
	assert_eq(_spec("add_crowns(-40)").args, [-40])
	assert_eq(_spec(" add_rep( faction.varn , -10 ) ").args, [&"faction.varn", -10])
	assert_eq(_spec("give_item(item.poultice)").args, [&"item.poultice", 1])
	assert_eq(_spec("heal_player(full)").args, [&"full"])
	assert_eq(_spec("heal_player(25)").args, [25])
	assert_eq(_spec("send_antidote_rider()").args, [])


func test_local_ids_are_not_referenced_ids() -> void:
	var e := _spec("goto_zone(zone.cintra_docks, hatch_landing)")
	assert_eq(e.args, [&"zone.cintra_docks", &"hatch_landing"])
	assert_eq(e.referenced_ids(), [&"zone.cintra_docks"] as Array[StringName])


func test_errors() -> void:
	assert_eq(_p.parse("set_flag flag.a").error_code, &"effect_syntax")
	assert_eq(_p.parse("set_flag(flag.a) extra").error_code, &"effect_syntax")
	assert_eq(_p.parse("teleport(zone.a)").error_code, &"unknown_op")
	assert_eq(_p.parse("set_flag(ms.a)").error_code, &"bad_arg")
	assert_eq(_p.parse("set_act(4)").error_code, &"bad_arg")
	assert_eq(_p.parse("apply_status(soot, 1)").error_code, &"bad_arg")
	assert_eq(_p.parse("set_flag()").error_code, &"bad_arg_count")


func test_error_details_name_the_op() -> void:
	assert_string_contains(_p.parse("teleport(zone.a)").detail, "teleport")
	assert_string_contains(_p.parse("set_flag()").detail, "set_flag")
	assert_string_contains(_p.parse("set_flag(ms.a)").detail, "ms.a")


func test_blank_and_malformed_shapes_are_syntax_errors() -> void:
	assert_eq(_p.parse("").error_code, &"effect_syntax")
	assert_eq(_p.parse("   ").error_code, &"effect_syntax")
	assert_eq(_p.parse("(flag.a)").error_code, &"effect_syntax")
	assert_eq(_p.parse("set_flag(flag.a").error_code, &"effect_syntax")


func test_empty_argument_slots_are_rejected() -> void:
	assert_eq(_p.parse("give_item(item.a,)").error_code, &"bad_arg")
	assert_eq(_p.parse("add_rep(,)").error_code, &"bad_arg")
	assert_eq(_p.parse("add_xp(,)").error_code, &"bad_arg_count")


func test_parse_list_reports_index() -> void:
	var r := _p.parse_list(["set_flag(flag.a)", "nope()"] as Array[String])
	assert_eq(r.error_code, &"unknown_op")
	assert_string_starts_with(r.detail, "#1: ")
	var ok := _p.parse_list(["set_flag(flag.a)", "add_xp(30)"] as Array[String])
	var specs: Array = ok.value
	assert_eq(specs.size(), 2)


func test_parse_list_of_nothing_is_an_empty_list() -> void:
	var r := _p.parse_list([] as Array[String])
	assert_true(r.is_ok())
	var specs: Array = r.value
	assert_true(specs.is_empty())


func test_every_spec_op_parses_with_valid_args() -> void:
	var samples: Array[String] = [
		"set_flag(flag.a)", "clear_flag(flag.a)", "set_var(var.a, 3)", "add_var(var.a, -1)",
		"reach_milestone(ms.a)", "set_act(3)", "give_item(item.a, 2)", "take_item(item.a)",
		"add_crowns(5)", "add_rep(faction.a, 5)", "add_xp(30)", "add_clue(clue.a)",
		"start_quest(quest.a)", "fail_quest(quest.a)", "complete_objective(quest.a, find_it)",
		"start_dialogue(dlg.a)", "start_encounter(enc.a)", "goto_zone(zone.a, door)",
		"unlock_map_node(map.a)", "add_map_pin(map.a)", "recruit(companion.a)",
		"dismiss(companion.a)", "add_ally(ally.a)", "remove_ally(ally.a)", "add_rumor(rumor.a)",
		"verify_rumor(rumor.a)", "heal_player(10)", "damage_player(4)", "apply_status(chill, 2)",
		"play_beat(bell_rings)", "set_checkpoint(inn_bed)", "open_shop(npc.a)",
		"administer_antidote(queen)", "send_antidote_rider()", "game_over(escort_died)",
	]
	var sampled_ops: Array[StringName] = []
	for text: String in samples:
		var r := _p.parse(text)
		assert_true(r.is_ok(), "%s: %s %s" % [text, r.error_code, r.detail])
		sampled_ops.append(StringName(text.left(text.find("("))))
	sampled_ops.sort_custom(func(a: StringName, b: StringName) -> bool: return String(a) < String(b))
	assert_eq(sampled_ops, ContentFormatEffects.signatures().ops(), "one sample per registered op")


func test_new_op_needs_only_a_registered_signature() -> void:
	# The "one handler + one test + one registration line" guarantee: no parser change.
	var sigs := ContentFormatEffects.signatures()
	assert_eq(EffectParser.new(sigs).parse("cancel_journey()").error_code, &"unknown_op")
	sigs.register(EffectSignature.of(&"cancel_journey", [] as Array[String]))
	assert_true(EffectParser.new(sigs).parse("cancel_journey()").is_ok())
