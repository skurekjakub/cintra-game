## Inventory.restore(): the JSON round trip, and all or nothing, rejecting a bad
## snapshot with save_invalid and leaving every stack unchanged (architecture.md
## §4 restore contract, §4.12, §9.3; gdd.md §6.9 stack limits).
extends GutTest


func _inv() -> Inventory:
	return Inventory.new(ItemDefBuilder.catalog([ItemDefBuilder.item(&"item.poultice", &"consumable", 10, 8),
		ItemDefBuilder.item(&"item.dravin_letter", &"key"), ItemDefBuilder.item(&"item.choir_list", &"document"),
		ItemDefBuilder.item(&"item.arming_sword", &"weapon", 1, 40)] as Array[ItemDefinition]))


func _populated() -> Inventory:
	var i := _inv()
	i.add(&"item.poultice", 3)
	i.add(&"item.choir_list")
	i.drain_events()
	return i


func _rejects(counts: Variant) -> String:
	var res := _inv().restore({"counts": counts})
	assert_eq(res.error_code, &"save_invalid", str(counts))
	return res.detail


func test_snapshot_survives_json_round_trip() -> void:
	var i := _populated()
	var r := _inv()
	assert_true(r.restore(JsonRoundTrip.of(i.to_snapshot())).is_ok())
	assert_eq(r.to_snapshot(), i.to_snapshot())
	assert_eq(r.count(&"item.poultice"), 3)
	var counts: Dictionary = r.to_snapshot()["counts"]
	assert_eq(typeof(counts["item.poultice"]), TYPE_INT, "restored counts are ints, not the floats JSON gives")


func test_restore_replaces_state_and_emits_nothing() -> void:
	var r := _inv()
	r.add(&"item.arming_sword")
	assert_true(r.restore({"counts": {"item.poultice": 4.0}}).is_ok())
	assert_false(r.has(&"item.arming_sword"))
	assert_eq(r.count(&"item.poultice"), 4)
	assert_eq(r.drain_events().size(), 1, "restore leaves the pending add event and records none")


func test_a_full_stack_is_valid() -> void:
	var r := _inv()
	assert_true(r.restore({"counts": {"item.poultice": 10.0, "item.arming_sword": 1.0}}).is_ok())
	assert_eq(r.room_for(&"item.poultice"), 0)


func test_a_missing_key_is_rejected_and_named() -> void:
	var res := _inv().restore({})
	assert_eq(res.error_code, &"save_invalid")
	assert_string_contains(res.detail, "inventory.counts")


func test_an_unknown_item_is_rejected_not_dropped() -> void:
	assert_string_contains(_rejects({"item.gone_from_catalog": 3.0, "item.dravin_letter": 1.0}),
		"inventory.counts.item.gone_from_catalog")


func test_wrong_types_are_rejected() -> void:
	_rejects({"item.poultice": 2.5})
	_rejects({"item.poultice": "2"})
	_rejects([])


func test_a_count_below_one_is_rejected_not_dropped() -> void:
	assert_string_contains(_rejects({"item.poultice": 0.0}), "inventory.counts.item.poultice")
	assert_string_contains(_rejects({"item.choir_list": -2.0}), "inventory.counts.item.choir_list")


func test_a_count_above_the_stack_limit_is_rejected_not_cut() -> void:
	assert_string_contains(_rejects({"item.poultice": 25.0}), "inventory.counts.item.poultice")
	assert_string_contains(_rejects({"item.arming_sword": 2.0}), "inventory.counts.item.arming_sword")


func test_a_rejected_restore_changes_nothing_and_records_nothing() -> void:
	var i := _populated()
	var before := i.to_snapshot()
	assert_true(i.restore({"counts": {"item.poultice": 4.0, "item.arming_sword": 2.0}}).is_err())
	assert_eq(i.to_snapshot(), before)
	assert_eq(i.drain_events().size(), 0)
