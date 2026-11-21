## ItemDefinition, its payloads and Inventory: stacks, key items and documents,
## room_for, ItemAdded/ItemRemoved events and the JSON-safe snapshot (gdd.md §6.9;
## architecture.md §4.12, §9.3). Restore: test_inventory_restore.gd.
extends GutTest


func _inv() -> Inventory:
	return Inventory.new(ItemDefBuilder.catalog([ItemDefBuilder.item(&"item.poultice", &"consumable", 10, 8),
		ItemDefBuilder.item(&"item.dravin_letter", &"key"), ItemDefBuilder.item(&"item.choir_list", &"document"),
		ItemDefBuilder.item(&"item.arming_sword", &"weapon", 1, 40)] as Array[ItemDefinition]))


# --- ItemDefinition and payloads ---


func test_definition_carries_its_constructor_fields_and_defaults() -> void:
	var d := ItemDefinition.new(&"item.poultice", &"consumable", 10, 8)
	assert_eq([d.id, d.category, d.stack_max, d.price], [&"item.poultice", &"consumable", 10, 8])
	var plain := ItemDefinition.new(&"item.arming_sword", &"weapon")
	assert_eq([plain.stack_max, plain.price], [1, 0])
	assert_eq([plain.display_name, plain.description, plain.equip_slot, plain.readable_text], ["", "", &"", ""])
	assert_eq(plain.tags, [] as Array[StringName])
	assert_null(plain.weapon)
	assert_null(plain.armor)
	assert_null(plain.consumable)


func test_category_and_slot_lists() -> void:
	assert_eq(ItemDefinition.CATEGORIES,
		[&"weapon", &"armor", &"trinket", &"consumable", &"ammo", &"key", &"document"] as Array[StringName])
	assert_eq(ItemDefinition.ITEM_SLOTS, [&"main_hand", &"ranged", &"armor", &"trinket"] as Array[StringName])


func test_only_key_and_document_are_protected() -> void:
	for category: StringName in ItemDefinition.CATEGORIES:
		var expected := category == &"key" or category == &"document"
		assert_eq(ItemDefBuilder.item(&"item.x", category).is_protected(), expected, String(category))


func test_payloads_are_plain_data_with_zero_defaults() -> void:
	var w := ItemWeaponPayload.new()
	assert_eq([w.base, w.damage_type, w.block_pct, w.armor_pen, w.moveset], [0, &"", 0.0, 0, &""])
	w.bonus_vs[&"armored"] = 0.25
	assert_eq(w.bonus_vs[&"armored"], 0.25)
	var a := ItemArmorPayload.new()
	a.resist[&"fire"] = 0.1
	assert_eq([a.armor, a.resist[&"fire"]], [0, 0.1])
	var c := ItemConsumablePayload.new()
	c.effects.append(EffectSpec.new(&"heal_player", [40], [] as Array[StringName]))
	c.use_time = 2.0
	assert_eq([c.effects[0].op, c.use_time], [&"heal_player", 2.0])


func test_builder_makes_a_catalog_keyed_by_id() -> void:
	var cat := ItemDefBuilder.catalog([ItemDefBuilder.item(&"item.a", &"ammo", 20, 1),
		ItemDefBuilder.item(&"item.b", &"trinket")] as Array[ItemDefinition])
	assert_eq(cat.size(), 2)
	assert_eq(cat[&"item.a"].stack_max, 20)
	assert_eq(cat[&"item.b"].category, &"trinket")


# --- add ---


func test_add_count_and_partial_fill() -> void:
	var i := _inv()
	assert_eq(i.add(&"item.poultice", 8).value, 8)
	assert_eq(i.add(&"item.poultice", 5).value, 2)
	assert_eq(i.count(&"item.poultice"), 10)
	assert_eq(i.remove(&"item.poultice", 10).value, 10)
	assert_eq(i.add(&"item.poultice").value, 1, "n defaults to 1")


func test_add_to_full_stack_fails_without_event() -> void:
	var i := _inv()
	i.add(&"item.arming_sword")
	i.drain_events()
	var before := i.to_snapshot()
	assert_eq(i.add(&"item.arming_sword").error_code, &"stack_full")
	assert_eq(i.drain_events().size(), 0)
	assert_eq(i.add(&"item.nope").error_code, &"unknown_item")
	assert_eq(i.drain_events().size(), 0)
	assert_eq(i.to_snapshot(), before, "a failed add changes nothing")
	assert_false(i.has(&"item.nope"))


# --- remove ---


func test_remove_rules() -> void:
	var i := _inv()
	i.add(&"item.poultice", 2)
	i.add(&"item.dravin_letter")
	assert_eq(i.remove(&"item.poultice", 3).error_code, &"not_enough")
	assert_eq(i.count(&"item.poultice"), 2)
	assert_eq(i.remove(&"item.dravin_letter").error_code, &"protected_item")
	assert_true(i.remove(&"item.dravin_letter", 1, true).is_ok())
	assert_false(i.has(&"item.dravin_letter"))


func test_failed_remove_changes_nothing_and_records_no_event() -> void:
	var i := _inv()
	i.add(&"item.poultice", 2)
	i.add(&"item.dravin_letter")
	i.add(&"item.choir_list")
	i.drain_events()
	var before := i.to_snapshot()
	assert_eq(i.remove(&"item.poultice", 3).error_code, &"not_enough")
	assert_eq(i.remove(&"item.dravin_letter").error_code, &"protected_item")
	assert_eq(i.remove(&"item.choir_list").error_code, &"protected_item")
	assert_eq(i.remove(&"item.nope").error_code, &"not_enough")
	assert_eq(i.to_snapshot(), before)
	assert_eq(i.drain_events().size(), 0)


func test_force_removes_a_key_item_and_a_document() -> void:
	var i := _inv()
	i.add(&"item.dravin_letter")
	i.add(&"item.choir_list")
	i.drain_events()
	assert_true(i.remove(&"item.dravin_letter", 1, true).is_ok())
	assert_true(i.remove(&"item.choir_list", 1, true).is_ok())
	assert_eq(i.all_ids().size(), 0)
	assert_eq(i.drain_events().size(), 2)


func test_force_does_not_remove_what_is_not_there() -> void:
	var i := _inv()
	assert_eq(i.remove(&"item.dravin_letter", 1, true).error_code, &"not_enough")
	assert_eq(i.drain_events().size(), 0)


func test_remove_returns_the_removed_count_and_defaults_to_one() -> void:
	var i := _inv()
	i.add(&"item.poultice", 5)
	var r := i.remove(&"item.poultice")
	assert_true(r.is_ok())
	assert_eq(r.value, 1)
	assert_eq(i.remove(&"item.poultice", 4).value, 4)
	assert_eq(i.count(&"item.poultice"), 0)


func test_removing_the_last_one_drops_the_id() -> void:
	var i := _inv()
	i.add(&"item.poultice", 2)
	i.remove(&"item.poultice", 2)
	assert_false(i.has(&"item.poultice"))
	assert_eq(i.all_ids().size(), 0)
	assert_eq(i.to_snapshot(), {"counts": {}})


# --- count, has, room_for, definition ---


func test_room_for() -> void:
	var i := _inv()
	assert_eq(i.room_for(&"item.poultice"), 10)
	i.add(&"item.poultice", 4)
	assert_eq(i.room_for(&"item.poultice"), 6)
	i.add(&"item.poultice", 6)
	assert_eq(i.room_for(&"item.poultice"), 0)
	assert_eq(i.room_for(&"item.arming_sword"), 1)
	i.add(&"item.arming_sword")
	assert_eq(i.room_for(&"item.arming_sword"), 0)
	assert_eq(i.room_for(&"item.nope"), 0)


func test_count_and_has() -> void:
	var i := _inv()
	assert_eq(i.count(&"item.poultice"), 0)
	assert_false(i.has(&"item.poultice"))
	i.add(&"item.poultice")
	assert_true(i.has(&"item.poultice"))
	assert_eq(i.count(&"item.nope"), 0)
	assert_false(i.has(&"item.nope"))


func test_definition_lookup() -> void:
	var i := _inv()
	var d := i.definition(&"item.poultice")
	assert_eq(d.price, 8)
	assert_eq(d.stack_max, 10)
	assert_null(i.definition(&"item.nope"))


# --- items_in, all_ids ---


func test_items_in_category_sorted() -> void:
	var i := _inv()
	i.add(&"item.choir_list")
	i.add(&"item.poultice")
	assert_eq(i.items_in(&"document"), [&"item.choir_list"] as Array[StringName])
	assert_eq(i.all_ids(), [&"item.choir_list", &"item.poultice"] as Array[StringName])


func test_sorting_is_alphabetical_whatever_the_insert_order() -> void:
	var cat := ItemDefBuilder.catalog([ItemDefBuilder.item(&"item.zeta", &"consumable", 5),
		ItemDefBuilder.item(&"item.alpha", &"consumable", 5), ItemDefBuilder.item(&"item.mid", &"consumable", 5),
		ItemDefBuilder.item(&"item.beta", &"consumable", 5), ItemDefBuilder.item(&"item.sword", &"weapon")] as Array[ItemDefinition])
	var i := Inventory.new(cat)
	for id: StringName in [&"item.zeta", &"item.sword", &"item.mid", &"item.alpha", &"item.beta"]:
		i.add(id)
	assert_eq(i.items_in(&"consumable"),
		[&"item.alpha", &"item.beta", &"item.mid", &"item.zeta"] as Array[StringName])
	assert_eq(i.all_ids(),
		[&"item.alpha", &"item.beta", &"item.mid", &"item.sword", &"item.zeta"] as Array[StringName])


func test_items_in_lists_only_held_items_of_that_category() -> void:
	var i := _inv()
	assert_eq(i.items_in(&"consumable").size(), 0)
	i.add(&"item.poultice")
	i.add(&"item.arming_sword")
	assert_eq(i.items_in(&"consumable"), [&"item.poultice"] as Array[StringName])
	assert_eq(i.items_in(&"weapon"), [&"item.arming_sword"] as Array[StringName])
	assert_eq(i.items_in(&"key").size(), 0)


# --- events ---


func test_events() -> void:
	var i := _inv()
	i.add(&"item.poultice", 2)
	i.remove(&"item.poultice")
	var e := i.drain_events()
	assert_eq([(e[0] as ItemAdded).total, (e[1] as ItemRemoved).total], [2, 1])


func test_event_fields() -> void:
	var i := _inv()
	i.add(&"item.poultice", 8)
	i.add(&"item.poultice", 5)
	i.remove(&"item.poultice", 4)
	var e := i.drain_events()
	assert_eq(e.size(), 3)
	var first := e[0] as ItemAdded
	var capped := e[1] as ItemAdded
	var gone := e[2] as ItemRemoved
	assert_eq([first.id, first.added, first.total], [&"item.poultice", 8, 8])
	assert_eq([capped.id, capped.added, capped.total], [&"item.poultice", 2, 10], "a partial add reports what fitted")
	assert_eq([gone.id, gone.removed, gone.total], [&"item.poultice", 4, 6])


func test_drain_empties_the_outbox_and_a_new_inventory_has_no_events() -> void:
	assert_eq(_inv().drain_events().size(), 0)
	var i := _inv()
	i.add(&"item.poultice")
	assert_eq(i.drain_events().size(), 1)
	assert_eq(i.drain_events().size(), 0)


# --- snapshot ---


func test_snapshot_shape() -> void:
	var i := _inv()
	assert_eq(i.to_snapshot(), {"counts": {}})
	i.add(&"item.poultice", 3)
	i.add(&"item.dravin_letter")
	assert_eq(i.to_snapshot(), {"counts": {"item.poultice": 3, "item.dravin_letter": 1}})

