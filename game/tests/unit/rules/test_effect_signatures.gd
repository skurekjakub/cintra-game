## EffectSignature, EffectSignatures and EffectSpec: the open/closed effect registry
## (architecture.md §3.4; content-format.md §E effect arguments).
extends GutTest


func test_of_parses_param_specs() -> void:
	var s := EffectSignature.of(&"give_item", ["id:item", "int=1"])
	assert_eq(s.op, &"give_item")
	assert_eq(s.params.size(), 2)
	assert_true(s.params[1].optional)


func test_of_keeps_param_order_and_spec_text() -> void:
	var s := EffectSignature.of(&"move", ["id:map", "local", "int:0..9"])
	assert_eq(s.params.size(), 3)
	assert_true(s.params[0].is_id())
	assert_eq(s.params[1].spec_text, "local")
	assert_eq(s.params[2].spec_text, "int:0..9")


func test_of_with_no_params_is_a_nullary_effect() -> void:
	var s := EffectSignature.of(&"end_day", [])
	assert_eq(s.op, &"end_day")
	assert_true(s.params.is_empty())


func test_of_supports_variadic_last_param() -> void:
	var s := EffectSignature.of(&"set_flags", ["id:flag+"])
	assert_true(s.params[0].variadic)


func test_signature_params_bind_through_arg_spec() -> void:
	var s := EffectSignature.of(&"give_item", ["id:item", "int=1"])
	var r := ArgSpec.bind(s.params, PackedStringArray(["item.poultice"]))
	assert_true(r.is_ok())
	var values: Array = r.value
	assert_eq(values, [&"item.poultice", 1])


func test_registry_lookup_and_sorted_ops() -> void:
	var r := EffectSignatures.new()
	r.register(EffectSignature.of(&"set_flag", ["id:flag"]))
	r.register(EffectSignature.of(&"add_xp", ["int"]))
	assert_true(r.has_op(&"set_flag"))
	assert_null(r.get_signature(&"nope"))
	assert_eq(r.ops(), [&"add_xp", &"set_flag"] as Array[StringName])


func test_get_signature_returns_the_registered_object() -> void:
	var r := EffectSignatures.new()
	var s := EffectSignature.of(&"add_xp", ["int"])
	r.register(s)
	assert_same(r.get_signature(&"add_xp"), s)
	assert_false(r.has_op(&"nope"))


func test_empty_registry_has_no_ops() -> void:
	var r := EffectSignatures.new()
	assert_true(r.ops().is_empty())
	assert_false(r.has_op(&"add_xp"))


func test_ops_are_alphabetical_whatever_the_registration_order() -> void:
	# Array[StringName].sort() orders by interned pointer, so this guards the text order.
	var names: Array[StringName] = [
		&"set_flag", &"give_item", &"add_xp", &"zzz_last", &"add_rep", &"move_party", &"a",
	]
	var r := EffectSignatures.new()
	for n: StringName in names:
		r.register(EffectSignature.of(n, []))
	var expected: Array[StringName] = [
		&"a", &"add_rep", &"add_xp", &"give_item", &"move_party", &"set_flag", &"zzz_last",
	]
	assert_eq(r.ops(), expected)
	names.reverse()
	var r2 := EffectSignatures.new()
	for n: StringName in names:
		r2.register(EffectSignature.of(n, []))
	assert_eq(r2.ops(), expected)


func test_ops_returns_a_fresh_array_each_call() -> void:
	var r := EffectSignatures.new()
	r.register(EffectSignature.of(&"add_xp", ["int"]))
	var first := r.ops()
	first.append(&"intruder")
	assert_eq(r.ops(), [&"add_xp"] as Array[StringName])


func test_effect_spec_holds_values() -> void:
	var e := EffectSpec.new(&"give_item", [&"item.poultice", 2], [&"item.poultice"] as Array[StringName])
	assert_eq(e.op, &"give_item")
	assert_eq(e.args[1], 2)
	assert_eq(e.referenced_ids(), [&"item.poultice"] as Array[StringName])


func test_effect_spec_without_ids_references_nothing() -> void:
	var e := EffectSpec.new(&"add_xp", [50], [] as Array[StringName])
	assert_eq(e.args, [50])
	assert_true(e.referenced_ids().is_empty())


func test_effect_spec_referenced_ids_is_a_copy() -> void:
	var e := EffectSpec.new(&"give_item", [&"item.poultice", 2], [&"item.poultice"] as Array[StringName])
	var ids := e.referenced_ids()
	ids.append(&"item.other")
	assert_eq(e.referenced_ids(), [&"item.poultice"] as Array[StringName])
