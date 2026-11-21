## ArgSpec: typed argument specs (content-format.md §C call arguments, §E effect arguments;
## architecture.md §3.4).
extends GutTest


func test_id_spec_checks_kind() -> void:
	var s := ArgSpec.parse("id:item")
	assert_eq(s.convert("item.iron_key").value, &"item.iron_key")
	assert_eq(s.convert("flag.x").error_code, &"bad_arg")
	assert_eq(s.convert("item.Bad").error_code, &"bad_arg")


func test_multi_kind_id() -> void:
	var s := ArgSpec.parse("id:companion|ally")
	assert_true(s.convert("ally.aldric").is_ok())
	assert_true(s.convert("companion.maelis").is_ok())
	assert_eq(s.convert("npc.maelis").error_code, &"bad_arg")


func test_int_negative_and_range() -> void:
	assert_eq(ArgSpec.parse("int").convert("-40").value, -40)
	assert_eq(ArgSpec.parse("int:1..3").convert("4").error_code, &"bad_arg")
	assert_eq(ArgSpec.parse("int").convert("4x").error_code, &"bad_arg")


func test_int_range_is_inclusive_and_may_be_negative() -> void:
	var s := ArgSpec.parse("int:-5..3")
	assert_eq(s.convert("-5").value, -5)
	assert_eq(s.convert("3").value, 3)
	assert_eq(s.convert("-6").error_code, &"bad_arg")
	assert_eq(s.convert("4").error_code, &"bad_arg")


func test_int_rejects_non_canonical_numbers() -> void:
	var s := ArgSpec.parse("int")
	for token: String in ["", "-", "+5", "1.5", " 5", "5 ", "--5", "item.a"]:
		assert_eq(s.convert(token).error_code, &"bad_arg", "'%s'" % token)


func test_word_and_union() -> void:
	assert_eq(ArgSpec.parse("word:queen|maelis").convert("maelis").value, &"maelis")
	var u := ArgSpec.parse("int|word:full")
	assert_eq(u.convert("full").value, &"full")
	assert_eq(u.convert("40").value, 40)
	assert_eq(u.convert("half").error_code, &"bad_arg")


func test_word_rejects_unlisted_and_ints() -> void:
	var s := ArgSpec.parse("word:poison|burning")
	assert_eq(s.convert("chill").error_code, &"bad_arg")
	assert_eq(s.convert("3").error_code, &"bad_arg")


func test_local_id() -> void:
	assert_eq(ArgSpec.parse("local").convert("door_kicked").value, &"door_kicked")
	assert_eq(ArgSpec.parse("local").convert("Door").error_code, &"bad_arg")


func test_local_id_rejects_digit_start_dots_and_empty() -> void:
	var s := ArgSpec.parse("local")
	for token: String in ["", "1door", "_door", "door.kicked", "door kicked", "door-kicked"]:
		assert_eq(s.convert(token).error_code, &"bad_arg", "'%s'" % token)
	assert_true(s.convert("a1_b2").is_ok())


func test_bad_arg_detail_names_token_and_spec() -> void:
	var r := ArgSpec.parse("id:item").convert("flag.x")
	assert_true(r.detail.contains("flag.x"), r.detail)
	assert_true(r.detail.contains("id:item"), r.detail)


func test_fields_describe_the_spec() -> void:
	var plain := ArgSpec.parse("id:item")
	assert_eq(plain.spec_text, "id:item")
	assert_false(plain.optional)
	assert_false(plain.variadic)
	assert_true(plain.is_id())
	var counted := ArgSpec.parse("int=1")
	assert_true(counted.optional)
	assert_eq(counted.default_value, 1)
	assert_false(counted.is_id())
	var many := ArgSpec.parse("id:ms+")
	assert_true(many.variadic)
	assert_false(many.optional)
	assert_true(many.is_id())
	assert_false(ArgSpec.parse("word:a|b").is_id())
	assert_false(ArgSpec.parse("local").is_id())


func test_optional_int_with_range_validates_the_given_token() -> void:
	var s := ArgSpec.parse("int:1..9=1")
	assert_true(s.optional)
	assert_eq(s.default_value, 1)
	assert_eq(s.convert("9").value, 9)
	assert_eq(s.convert("10").error_code, &"bad_arg")


func test_bind_fills_default_and_counts() -> void:
	var specs: Array[ArgSpec] = [ArgSpec.parse("id:item"), ArgSpec.parse("int=1")]
	assert_eq(ArgSpec.bind(specs, PackedStringArray(["item.poultice"])).value, [&"item.poultice", 1])
	assert_eq(ArgSpec.bind(specs, PackedStringArray([])).error_code, &"bad_arg_count")
	assert_eq(ArgSpec.bind(specs, PackedStringArray(["item.a", "1", "2"])).error_code, &"bad_arg_count")


func test_bind_converts_every_token() -> void:
	var specs: Array[ArgSpec] = [ArgSpec.parse("id:item"), ArgSpec.parse("int=1")]
	assert_eq(ArgSpec.bind(specs, PackedStringArray(["item.poultice", "3"])).value, [&"item.poultice", 3])


func test_bind_reports_bad_arg_with_the_token() -> void:
	var specs: Array[ArgSpec] = [ArgSpec.parse("id:item"), ArgSpec.parse("int=1")]
	var r := ArgSpec.bind(specs, PackedStringArray(["flag.x", "3"]))
	assert_eq(r.error_code, &"bad_arg")
	assert_true(r.detail.contains("flag.x"), r.detail)
	assert_eq(ArgSpec.bind(specs, PackedStringArray(["item.a", "x"])).error_code, &"bad_arg")


func test_bind_with_no_specs_takes_no_tokens() -> void:
	var specs: Array[ArgSpec] = []
	var ok := ArgSpec.bind(specs, PackedStringArray([]))
	assert_true(ok.is_ok())
	var vals: Array = ok.value
	assert_eq(vals.size(), 0)
	assert_eq(ArgSpec.bind(specs, PackedStringArray(["x"])).error_code, &"bad_arg_count")


func test_bind_mixed_kinds_keeps_order() -> void:
	var specs: Array[ArgSpec] = [ArgSpec.parse("word:poison|burning"), ArgSpec.parse("int")]
	assert_eq(ArgSpec.bind(specs, PackedStringArray(["burning", "-2"])).value, [&"burning", -2])


func test_variadic_needs_one_or_more() -> void:
	var specs: Array[ArgSpec] = [ArgSpec.parse("id:ms+")]
	var r := ArgSpec.bind(specs, PackedStringArray(["ms.a", "ms.b", "ms.c"]))
	var vals: Array = r.value
	assert_eq(vals.size(), 3)
	assert_eq(ArgSpec.ids_in(specs, vals), [&"ms.a", &"ms.b", &"ms.c"] as Array[StringName])
	assert_eq(ArgSpec.bind(specs, PackedStringArray([])).error_code, &"bad_arg_count")


func test_variadic_checks_every_token() -> void:
	var specs: Array[ArgSpec] = [ArgSpec.parse("id:ms+")]
	var r := ArgSpec.bind(specs, PackedStringArray(["ms.a", "flag.b"]))
	assert_eq(r.error_code, &"bad_arg")
	assert_true(r.detail.contains("flag.b"), r.detail)


func test_variadic_after_fixed_params() -> void:
	var specs: Array[ArgSpec] = [ArgSpec.parse("int"), ArgSpec.parse("id:ms+")]
	var r := ArgSpec.bind(specs, PackedStringArray(["2", "ms.a", "ms.b"]))
	var vals: Array = r.value
	assert_eq(vals, [2, &"ms.a", &"ms.b"])
	assert_eq(ArgSpec.ids_in(specs, vals), [&"ms.a", &"ms.b"] as Array[StringName])
	assert_eq(ArgSpec.bind(specs, PackedStringArray(["2"])).error_code, &"bad_arg_count")


func test_ids_in_skips_non_id_values() -> void:
	var specs: Array[ArgSpec] = [ArgSpec.parse("id:quest"), ArgSpec.parse("local")]
	var r := ArgSpec.bind(specs, PackedStringArray(["quest.main_a1", "door_kicked"]))
	var vals: Array = r.value
	assert_eq(ArgSpec.ids_in(specs, vals), [&"quest.main_a1"] as Array[StringName])
