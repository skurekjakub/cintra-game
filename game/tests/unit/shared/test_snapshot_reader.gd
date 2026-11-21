## SnapshotReader: typed, range-checked reads of a saved section that keep the
## first problem with its path, for an all-or-nothing restore() (architecture.md
## §4 "Conventions for every domain", restore contract).
extends GutTest


func test_reads_ints_from_ints_and_integral_floats() -> void:
	var r := SnapshotReader.new({"a": 3, "b": 4.0}, "sec")
	assert_eq(r.read_int("a", 0, 10), 3)
	assert_eq(r.read_int("b", 0, 10), 4)
	assert_typeof(r.read_int("b", 0, 10), TYPE_INT)
	assert_false(r.failed())
	assert_true(r.result().is_ok())


func test_a_fractional_float_is_not_an_int() -> void:
	var r := SnapshotReader.new({"a": 2.5}, "sec")
	r.read_int("a", 0, 10)
	assert_true(r.failed())
	assert_eq(r.result().error_code, &"save_invalid")
	assert_string_contains(r.result().detail, "sec.a:")


func test_a_missing_key_names_the_path() -> void:
	var r := SnapshotReader.new({}, "wallet")
	r.read_int("crowns", 0, 10)
	assert_eq(r.result().error_code, &"save_invalid")
	assert_eq(r.result().detail, "wallet.crowns: missing")


func test_wrong_types_fail() -> void:
	var data := {"i": "3", "b": 1, "s": 5, "d": [], "a": {}, "t": true}
	var r := SnapshotReader.new(data, "sec")
	r.read_int("t", 0, 10)
	assert_true(r.failed(), "a bool is not an int")
	for check: Callable in [
			func(x: SnapshotReader) -> void: x.read_int("i", 0, 10),
			func(x: SnapshotReader) -> void: x.read_bool("b"),
			func(x: SnapshotReader) -> void: x.read_string("s"),
			func(x: SnapshotReader) -> void: x.read_dict("d"),
			func(x: SnapshotReader) -> void: x.read_array("a")]:
		var fresh := SnapshotReader.new(data, "sec")
		check.call(fresh)
		assert_true(fresh.failed())


func test_out_of_range_fails_with_the_range() -> void:
	var r := SnapshotReader.new({"act": 7.0}, "world_state")
	r.read_int("act", 1, 3)
	assert_string_contains(r.result().detail, "world_state.act:")
	assert_string_contains(r.result().detail, "1..3")


func test_huge_floats_are_out_of_range() -> void:
	var r := SnapshotReader.new({"a": 1.0e30}, "sec")
	r.read_int("a", 0, SnapshotReader.INT_MAX)
	assert_true(r.failed())


func test_reads_bool_string_and_array() -> void:
	var r := SnapshotReader.new({"b": true, "s": "x", "a": [1, 2]}, "sec")
	assert_true(r.read_bool("b"))
	assert_eq(r.read_string("s"), "x")
	assert_eq(r.read_array("a"), [1, 2])
	assert_false(r.failed())


func test_a_child_reports_its_full_path_to_the_root() -> void:
	var r := SnapshotReader.new({"attributes": {"might": 11.0}}, "actor_sheet")
	var child := r.read_dict("attributes")
	child.read_int("might", 0, 10)
	assert_true(r.failed())
	assert_string_contains(r.result().detail, "actor_sheet.attributes.might:")


func test_only_the_first_problem_is_kept() -> void:
	var r := SnapshotReader.new({}, "sec")
	r.read_int("first", 0, 1)
	r.read_int("second", 0, 1)
	r.fail("third", "custom")
	assert_eq(r.result().detail, "sec.first: missing")


func test_fail_records_a_custom_reason() -> void:
	var r := SnapshotReader.new({"counts": {}}, "inventory")
	r.read_dict("counts").fail("item.gone", "unknown item")
	assert_eq(r.result().detail, "inventory.counts.item.gone: unknown item")


func test_keys_are_strings_and_non_empty() -> void:
	var ok := SnapshotReader.new({"a": 1, "b": 2}, "sec")
	var names := ok.keys()
	names.sort()
	assert_eq(names, ["a", "b"] as Array[String])
	assert_false(ok.failed())
	assert_true(_fails(func(x: SnapshotReader) -> void: x.keys(), {1: 2}))
	assert_true(_fails(func(x: SnapshotReader) -> void: x.keys(), {"": 2}))


func test_read_ids_gives_unique_non_empty_ids() -> void:
	var r := SnapshotReader.new({"flags": ["flag.a", "flag.b"]}, "sec")
	assert_eq(r.read_ids("flags"), [&"flag.a", &"flag.b"] as Array[StringName])
	assert_false(r.failed())
	assert_true(_fails(func(x: SnapshotReader) -> void: x.read_ids("f"), {"f": ["flag.a", "flag.a"]}))
	assert_true(_fails(func(x: SnapshotReader) -> void: x.read_ids("f"), {"f": [""]}))
	assert_true(_fails(func(x: SnapshotReader) -> void: x.read_ids("f"), {"f": [3]}))


func test_value_helpers_check_values_held_elsewhere() -> void:
	var r := SnapshotReader.new({}, "quick_slots")
	assert_eq(r.int_value(2.0, "n", 0, 3), 2)
	assert_eq(r.string_value("item.x", "slots[0]"), "item.x")
	assert_false(r.failed())
	r.string_value(4, "slots[1]")
	assert_string_contains(r.result().detail, "quick_slots.slots[1]:")


func _fails(check: Callable, data: Dictionary) -> bool:
	var r := SnapshotReader.new(data, "sec")
	check.call(r)
	return r.failed()
