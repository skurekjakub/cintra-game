## Equipment: the five slots, equip and unequip rules and their error order,
## ItemEquipped/ItemUnequipped events, the armor sum and the JSON-safe snapshot
## (gdd.md §6.9 equipment slots, §6.6 armor; architecture.md §4.12, §9.3).
extends GutTest


# --- equip rules ---


func test_slots_are_the_five_in_order() -> void:
	assert_eq(Equipment.SLOTS, [&"main_hand", &"ranged", &"armor", &"trinket_1", &"trinket_2"] as Array[StringName])


func test_equip_rules() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	assert_eq(e.equip(&"belt", &"item.arming_sword").error_code, &"unknown_slot")
	assert_eq(e.equip(&"main_hand", &"item.mane_cleaver").error_code, &"not_owned")
	assert_eq(e.equip(&"armor", &"item.arming_sword").error_code, &"wrong_slot")
	assert_true(e.equip(&"main_hand", &"item.arming_sword").is_ok())
	assert_true(e.equip(&"trinket_2", &"item.lucky_coin").is_ok())
	assert_eq(e.equip(&"trinket_1", &"item.lucky_coin").error_code, &"already_equipped")


func test_errors_are_checked_in_the_documented_order() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	assert_eq(e.equip(&"belt", &"item.mane_cleaver").error_code, &"unknown_slot", "slot before ownership")
	assert_eq(e.equip(&"armor", &"item.mane_cleaver").error_code, &"not_owned", "ownership before fit")
	e.equip(&"main_hand", &"item.arming_sword")
	assert_eq(e.equip(&"armor", &"item.arming_sword").error_code, &"wrong_slot", "fit before duplicate")


func test_an_item_fits_only_the_slot_it_names() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	assert_eq(e.equip(&"ranged", &"item.arming_sword").error_code, &"wrong_slot")
	assert_eq(e.equip(&"main_hand", &"item.gambeson").error_code, &"wrong_slot")
	assert_eq(e.equip(&"main_hand", &"item.lucky_coin").error_code, &"wrong_slot")
	assert_eq(e.equip(&"armor", &"item.lucky_coin").error_code, &"wrong_slot")


func test_an_item_without_an_equip_slot_fits_nowhere() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	for slot: StringName in Equipment.SLOTS:
		assert_eq(e.equip(slot, &"item.poultice").error_code, &"wrong_slot", String(slot))


func test_a_trinket_fits_either_trinket_slot() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	assert_true(e.equip(&"trinket_1", &"item.lucky_coin").is_ok())
	assert_eq(e.equipped(&"trinket_1"), &"item.lucky_coin")
	e.unequip(&"trinket_1")
	assert_true(e.equip(&"trinket_2", &"item.lucky_coin").is_ok())
	assert_eq(e.equipped(&"trinket_2"), &"item.lucky_coin")


func test_a_failed_equip_changes_nothing_and_records_nothing() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	e.equip(&"main_hand", &"item.arming_sword")
	e.drain_events()
	var before := e.to_snapshot()
	e.equip(&"belt", &"item.spare_sword")
	e.equip(&"main_hand", &"item.mane_cleaver")
	e.equip(&"armor", &"item.spare_sword")
	e.equip(&"armor", &"item.arming_sword")
	assert_eq(e.to_snapshot(), before)
	assert_eq(e.drain_events().size(), 0)


func test_equipping_what_the_slot_already_holds_is_a_quiet_ok() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	e.equip(&"main_hand", &"item.arming_sword")
	e.drain_events()
	assert_true(e.equip(&"main_hand", &"item.arming_sword").is_ok())
	assert_eq(e.equipped(&"main_hand"), &"item.arming_sword")
	assert_eq(e.drain_events().size(), 0, "nothing changed, so nothing is recorded")


# --- equipped, is_equipped, unequip ---


func test_equipped_is_empty_for_a_free_or_unknown_slot() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	assert_eq(e.equipped(&"ranged"), &"")
	assert_eq(e.equipped(&"belt"), &"")
	e.equip(&"armor", &"item.gambeson")
	assert_eq(e.equipped(&"armor"), &"item.gambeson")
	assert_eq(e.equipped(&"ranged"), &"")


func test_is_equipped_looks_through_every_slot() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	assert_false(e.is_equipped(&"item.lucky_coin"))
	e.equip(&"trinket_2", &"item.lucky_coin")
	assert_true(e.is_equipped(&"item.lucky_coin"))
	assert_false(e.is_equipped(&"item.arming_sword"))
	assert_false(e.is_equipped(&""), "an empty slot is not an equipped item")


func test_unequip_empties_the_slot_and_frees_the_item() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	e.equip(&"trinket_2", &"item.lucky_coin")
	e.unequip(&"trinket_2")
	assert_eq(e.equipped(&"trinket_2"), &"")
	assert_false(e.is_equipped(&"item.lucky_coin"))
	assert_true(e.equip(&"trinket_1", &"item.lucky_coin").is_ok(), "the coin is free again")


func test_unequipping_an_empty_slot_does_nothing() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	e.unequip(&"ranged")
	assert_eq(e.drain_events().size(), 0)
	assert_eq(e.to_snapshot(), {"slots": {}})


func test_unequip_leaves_the_other_slots_alone() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	e.equip(&"main_hand", &"item.arming_sword")
	e.equip(&"armor", &"item.gambeson")
	e.unequip(&"main_hand")
	assert_eq(e.equipped(&"armor"), &"item.gambeson")


# --- events ---


func test_equipping_a_free_slot_records_one_event() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	e.equip(&"main_hand", &"item.arming_sword")
	var ev := e.drain_events()
	assert_eq(ev.size(), 1)
	assert_is(ev[0], ItemEquipped)
	var equipped_event: ItemEquipped = ev[0]
	assert_eq([equipped_event.slot, equipped_event.id], [&"main_hand", &"item.arming_sword"])
	assert_eq(e.drain_events().size(), 0, "drain empties the outbox")


func test_swap_emits_unequip_then_equip() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	e.equip(&"main_hand", &"item.arming_sword")
	e.drain_events()
	e.equip(&"main_hand", &"item.spare_sword")
	var ev := e.drain_events()
	assert_eq(ev.size(), 2)
	assert_is(ev[0], ItemUnequipped)
	assert_is(ev[1], ItemEquipped)


func test_swap_events_carry_slot_and_item() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	e.equip(&"main_hand", &"item.arming_sword")
	e.drain_events()
	e.equip(&"main_hand", &"item.spare_sword")
	var ev := e.drain_events()
	var gone: ItemUnequipped = ev[0]
	var came: ItemEquipped = ev[1]
	assert_eq([gone.slot, gone.id], [&"main_hand", &"item.arming_sword"])
	assert_eq([came.slot, came.id], [&"main_hand", &"item.spare_sword"])
	assert_eq(e.equipped(&"main_hand"), &"item.spare_sword")


func test_unequip_records_the_item_that_left() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	e.equip(&"armor", &"item.gambeson")
	e.drain_events()
	e.unequip(&"armor")
	var ev := e.drain_events()
	assert_eq(ev.size(), 1)
	assert_is(ev[0], ItemUnequipped)
	var gone: ItemUnequipped = ev[0]
	assert_eq([gone.slot, gone.id], [&"armor", &"item.gambeson"])


# --- armor total (gdd §6.6) ---


func test_armor_total() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())   # gambeson armor 10
	e.equip(&"armor", &"item.gambeson")
	assert_eq(e.armor_total(), 10)


func test_armor_total_is_zero_without_armor() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	assert_eq(e.armor_total(), 0)
	e.equip(&"main_hand", &"item.arming_sword")
	assert_eq(e.armor_total(), 0, "a sword has no armor payload")
	e.equip(&"armor", &"item.gambeson")
	e.unequip(&"armor")
	assert_eq(e.armor_total(), 0)


func test_armor_total_sums_every_equipped_armor_payload() -> void:
	var charm := ItemDefBuilder.item(&"item.iron_charm", &"trinket", 1, 30)
	charm.equip_slot = &"trinket"
	charm.armor = ItemArmorPayload.new()
	charm.armor.armor = 3
	var gambeson := ItemDefBuilder.item(&"item.gambeson", &"armor", 1, 60)
	gambeson.equip_slot = &"armor"
	gambeson.armor = ItemArmorPayload.new()
	gambeson.armor.armor = 10
	var inv := Inventory.new(ItemDefBuilder.catalog([charm, gambeson] as Array[ItemDefinition]))
	inv.add(&"item.iron_charm")
	inv.add(&"item.gambeson")
	var e := Equipment.new(inv)
	e.equip(&"armor", &"item.gambeson")
	e.equip(&"trinket_1", &"item.iron_charm")
	assert_eq(e.armor_total(), 13)


# --- snapshot ---


func test_snapshot_shape() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	assert_eq(e.to_snapshot(), {"slots": {}})
	e.equip(&"armor", &"item.gambeson")
	e.equip(&"trinket_2", &"item.lucky_coin")
	assert_eq(e.to_snapshot(), {"slots": {"armor": "item.gambeson", "trinket_2": "item.lucky_coin"}})


func test_snapshot_survives_json_round_trip() -> void:
	var inv := ItemDefBuilder.gear_inventory()
	var e := Equipment.new(inv)
	e.equip(&"armor", &"item.gambeson")
	e.equip(&"main_hand", &"item.arming_sword")
	var r := Equipment.new(inv)
	r.restore(JsonRoundTrip.of(e.to_snapshot()))
	assert_eq(r.to_snapshot(), e.to_snapshot())
	assert_eq(r.equipped(&"armor"), &"item.gambeson")
	assert_eq(r.armor_total(), 10)


func test_restore_replaces_all_state_and_emits_nothing() -> void:
	var inv := ItemDefBuilder.gear_inventory()
	var saved := Equipment.new(inv)
	saved.equip(&"armor", &"item.gambeson")
	var r := Equipment.new(inv)
	r.equip(&"main_hand", &"item.arming_sword")
	r.restore(JsonRoundTrip.of(saved.to_snapshot()))
	assert_eq(r.equipped(&"main_hand"), &"", "the old slot is cleared")
	assert_eq(r.equipped(&"armor"), &"item.gambeson")
	assert_eq(r.drain_events().size(), 1, "restore leaves the pending equip event and records none")


func test_restore_skips_unknown_slots_and_empty_ids() -> void:
	var r := Equipment.new(ItemDefBuilder.gear_inventory())
	r.restore({"slots": {"belt": "item.gambeson", "armor": "", "main_hand": "item.arming_sword"}})
	assert_eq(r.to_snapshot(), {"slots": {"main_hand": "item.arming_sword"}})
