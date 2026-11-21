## Equipment.restore(): all or nothing, rejecting a bad snapshot with
## save_invalid and leaving every slot unchanged (architecture.md §4 restore
## contract, §4.12; gdd.md §6.9 equipment slots). Ownership is not checked: the
## inventory may be restored after the equipment.
extends GutTest


func _populated() -> Equipment:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	e.equip(&"armor", &"item.gambeson")
	e.equip(&"trinket_2", &"item.lucky_coin")
	e.drain_events()
	return e


func _rejects(slots: Variant) -> String:
	var res := Equipment.new(ItemDefBuilder.gear_inventory()).restore({"slots": slots})
	assert_eq(res.error_code, &"save_invalid", str(slots))
	return res.detail


func test_a_valid_snapshot_restores_ok() -> void:
	var e := _populated()
	var r := Equipment.new(ItemDefBuilder.gear_inventory())
	assert_true(r.restore(JsonRoundTrip.of(e.to_snapshot())).is_ok())
	assert_eq(r.to_snapshot(), e.to_snapshot())


func test_an_item_the_inventory_does_not_hold_is_still_valid() -> void:
	var r := Equipment.new(ItemDefBuilder.gear_inventory())
	assert_true(r.restore({"slots": {"main_hand": "item.mane_cleaver"}}).is_ok())
	assert_eq(r.equipped(&"main_hand"), &"item.mane_cleaver")


func test_a_missing_key_is_rejected_and_named() -> void:
	var res := Equipment.new(ItemDefBuilder.gear_inventory()).restore({})
	assert_eq(res.error_code, &"save_invalid")
	assert_string_contains(res.detail, "equipment.slots")


func test_an_unknown_slot_is_rejected_not_dropped() -> void:
	assert_string_contains(_rejects({"belt": "item.gambeson", "main_hand": "item.arming_sword"}), "equipment.slots.belt")


func test_wrong_types_and_empty_ids_are_rejected() -> void:
	_rejects({"armor": 3.0})
	_rejects([])
	assert_string_contains(_rejects({"armor": ""}), "equipment.slots.armor")


func test_an_item_the_catalog_does_not_know_is_rejected() -> void:
	assert_string_contains(_rejects({"armor": "item.gone"}), "equipment.slots.armor")


func test_an_item_in_a_slot_it_does_not_fit_is_rejected() -> void:
	assert_string_contains(_rejects({"armor": "item.arming_sword"}), "equipment.slots.armor")


func test_one_item_in_two_slots_is_rejected() -> void:
	_rejects({"trinket_1": "item.lucky_coin", "trinket_2": "item.lucky_coin"})


func test_a_rejected_restore_changes_nothing_and_records_nothing() -> void:
	var e := _populated()
	var before := e.to_snapshot()
	assert_true(e.restore({"slots": {"main_hand": "item.arming_sword", "belt": "item.gambeson"}}).is_err())
	assert_eq(e.to_snapshot(), before)
	assert_eq(e.drain_events().size(), 0)
