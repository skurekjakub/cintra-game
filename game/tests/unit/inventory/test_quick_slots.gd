## QuickSlots: the four quick item slots, assign rules and their error order, moving
## an id between slots, and the JSON-safe snapshot (gdd.md §6.4 quick items, §6.9
## consumables; architecture.md §4.12, §9.3).
extends GutTest


func test_size_is_four() -> void:
	assert_eq(QuickSlots.SIZE, 4)


func test_slots_start_empty() -> void:
	var q := QuickSlots.new(ItemDefBuilder.gear_inventory())
	for i: int in QuickSlots.SIZE:
		assert_eq(q.item_at(i), &"", "slot %d" % i)


func test_assign_rules_and_move() -> void:
	var q := QuickSlots.new(ItemDefBuilder.gear_inventory())
	assert_eq(q.assign(4, &"item.poultice").error_code, &"bad_index")
	assert_eq(q.assign(0, &"item.arming_sword").error_code, &"not_consumable")
	q.assign(0, &"item.poultice")
	q.assign(2, &"item.poultice")
	assert_eq([q.item_at(0), q.item_at(2)], [&"", &"item.poultice"])


func test_bad_index_covers_both_ends() -> void:
	var q := QuickSlots.new(ItemDefBuilder.gear_inventory())
	assert_eq(q.assign(-1, &"item.poultice").error_code, &"bad_index")
	assert_eq(q.assign(QuickSlots.SIZE, &"item.poultice").error_code, &"bad_index")
	assert_true(q.assign(QuickSlots.SIZE - 1, &"item.poultice").is_ok())


func test_errors_are_checked_in_the_documented_order() -> void:
	var q := QuickSlots.new(ItemDefBuilder.gear_inventory())
	assert_eq(q.assign(9, &"item.mane_cleaver").error_code, &"bad_index", "index before ownership")
	assert_eq(q.assign(0, &"item.mane_cleaver").error_code, &"not_owned", "ownership before category")
	assert_eq(q.assign(0, &"item.nope").error_code, &"not_owned", "an unknown id is not owned either")


func test_only_a_consumable_can_be_assigned() -> void:
	var q := QuickSlots.new(ItemDefBuilder.gear_inventory())
	for id: StringName in [&"item.arming_sword", &"item.gambeson", &"item.lucky_coin"]:
		assert_eq(q.assign(0, id).error_code, &"not_consumable", String(id))
	assert_eq(q.item_at(0), &"")


func test_a_failed_assign_changes_nothing() -> void:
	var q := QuickSlots.new(ItemDefBuilder.gear_inventory())
	q.assign(1, &"item.poultice")
	var before := q.to_snapshot()
	q.assign(1, &"item.arming_sword")
	q.assign(7, &"item.poultice")
	q.assign(1, &"item.mane_cleaver")
	assert_eq(q.to_snapshot(), before)
	assert_eq(q.item_at(1), &"item.poultice")


func test_assign_onto_an_occupied_slot_replaces_it() -> void:
	var poultice := ItemDefBuilder.item(&"item.poultice", &"consumable", 10, 8)
	var tonic := ItemDefBuilder.item(&"item.tonic", &"consumable", 5, 12)
	var inv := Inventory.new(ItemDefBuilder.catalog([poultice, tonic] as Array[ItemDefinition]))
	inv.add(&"item.poultice")
	inv.add(&"item.tonic")
	var q := QuickSlots.new(inv)
	q.assign(0, &"item.poultice")
	assert_true(q.assign(0, &"item.tonic").is_ok())
	assert_eq(q.item_at(0), &"item.tonic")


func test_assigning_the_same_id_to_its_own_slot_keeps_it() -> void:
	var q := QuickSlots.new(ItemDefBuilder.gear_inventory())
	q.assign(3, &"item.poultice")
	assert_true(q.assign(3, &"item.poultice").is_ok())
	assert_eq(q.item_at(3), &"item.poultice")


func test_clear_empties_one_slot() -> void:
	var q := QuickSlots.new(ItemDefBuilder.gear_inventory())
	q.assign(0, &"item.poultice")
	q.clear(0)
	assert_eq(q.item_at(0), &"")
	q.clear(1)
	assert_eq(q.to_snapshot(), {"slots": ["", "", "", ""]})


func test_a_slot_keeps_its_id_when_the_stack_runs_out() -> void:
	var inv := ItemDefBuilder.gear_inventory()
	var q := QuickSlots.new(inv)
	q.assign(0, &"item.poultice")
	inv.remove(&"item.poultice", 2)
	assert_eq(inv.count(&"item.poultice"), 0)
	assert_eq(q.item_at(0), &"item.poultice", "the use case checks the count, not the slot")


# --- snapshot ---


func test_snapshot_shape() -> void:
	var q := QuickSlots.new(ItemDefBuilder.gear_inventory())
	assert_eq(q.to_snapshot(), {"slots": ["", "", "", ""]})
	q.assign(2, &"item.poultice")
	assert_eq(q.to_snapshot(), {"slots": ["", "", "item.poultice", ""]})


func test_snapshot_survives_json_round_trip() -> void:
	var inv := ItemDefBuilder.gear_inventory()
	var q := QuickSlots.new(inv)
	q.assign(1, &"item.poultice")
	var r := QuickSlots.new(inv)
	r.restore(JsonRoundTrip.of(q.to_snapshot()))
	assert_eq(r.to_snapshot(), q.to_snapshot())
	assert_eq(r.item_at(1), &"item.poultice")


func test_restore_replaces_all_state() -> void:
	var inv := ItemDefBuilder.gear_inventory()
	var saved := QuickSlots.new(inv)
	saved.assign(3, &"item.poultice")
	var r := QuickSlots.new(inv)
	r.assign(0, &"item.poultice")
	r.restore(JsonRoundTrip.of(saved.to_snapshot()))
	assert_eq([r.item_at(0), r.item_at(3)], [&"", &"item.poultice"])


func test_restore_tolerates_a_short_or_long_slot_list() -> void:
	var r := QuickSlots.new(ItemDefBuilder.gear_inventory())
	r.restore({"slots": ["item.poultice"]})
	assert_eq(r.to_snapshot(), {"slots": ["item.poultice", "", "", ""]})
	r.restore({"slots": ["", "", "", "", "item.poultice"]})
	assert_eq(r.to_snapshot(), {"slots": ["", "", "", ""]})
