## QuickSlots.restore(): all or nothing, rejecting a bad snapshot with
## save_invalid and leaving every slot unchanged (architecture.md §4 restore
## contract, §4.12; gdd.md §6.4 four quick slots, §6.9 consumables). Ownership is
## not checked: the inventory may be restored after the slots.
extends GutTest


func _populated() -> QuickSlots:
	var q := QuickSlots.new(ItemDefBuilder.gear_inventory())
	q.assign(2, &"item.poultice")
	return q


func _rejects(slots: Variant) -> String:
	var res := QuickSlots.new(ItemDefBuilder.gear_inventory()).restore({"slots": slots})
	assert_eq(res.error_code, &"save_invalid", str(slots))
	return res.detail


func test_a_valid_snapshot_restores_ok() -> void:
	var q := _populated()
	var r := QuickSlots.new(ItemDefBuilder.gear_inventory())
	assert_true(r.restore(JsonRoundTrip.of(q.to_snapshot())).is_ok())
	assert_eq(r.to_snapshot(), q.to_snapshot())


func test_a_missing_key_is_rejected_and_named() -> void:
	var res := QuickSlots.new(ItemDefBuilder.gear_inventory()).restore({})
	assert_eq(res.error_code, &"save_invalid")
	assert_string_contains(res.detail, "quick_slots.slots")


func test_a_short_or_long_slot_list_is_rejected_not_padded() -> void:
	assert_string_contains(_rejects(["item.poultice"]), "quick_slots.slots")
	assert_string_contains(_rejects(["", "", "", "", "item.poultice"]), "quick_slots.slots")


func test_wrong_types_are_rejected() -> void:
	assert_string_contains(_rejects(["", 3.0, "", ""]), "quick_slots.slots[1]")
	_rejects({"0": "item.poultice"})


func test_an_item_the_catalog_does_not_know_is_rejected() -> void:
	assert_string_contains(_rejects(["", "", "item.gone", ""]), "quick_slots.slots[2]")


func test_an_item_that_is_not_a_consumable_is_rejected() -> void:
	assert_string_contains(_rejects(["item.arming_sword", "", "", ""]), "quick_slots.slots[0]")


func test_one_item_in_two_slots_is_rejected() -> void:
	assert_string_contains(_rejects(["item.poultice", "", "", "item.poultice"]), "quick_slots.slots[3]")


func test_a_rejected_restore_changes_nothing() -> void:
	var q := _populated()
	var before := q.to_snapshot()
	assert_true(q.restore({"slots": ["item.poultice", "", ""]}).is_err())
	assert_eq(q.to_snapshot(), before)
