## Item modifiers on definitions and equipment: ItemDefinition.mods,
## Equipment.equipped_mods() order and content, and the armor mods that
## armor_total() adds (content-format.md §J.6 items; gdd.md §6.6 armor sum,
## §6.9 items; architecture.md §4.12). Mods are definitions, not state: they are
## not part of any snapshot.
extends GutTest


func _inventory(defs: Array[ItemDefinition]) -> Inventory:
	var inv := Inventory.new(ItemDefBuilder.catalog(defs))
	for def: ItemDefinition in defs:
		inv.add(def.id)
	return inv


func test_a_definition_has_no_mods_by_default() -> void:
	assert_eq(ItemDefBuilder.item(&"item.x", &"trinket").mods.size(), 0)


func test_a_consumable_payload_fits_a_quick_slot_by_default() -> void:
	assert_true(ItemConsumablePayload.new().quick_slot)


func test_equipped_mods_is_empty_with_nothing_equipped() -> void:
	var e := Equipment.new(ItemDefBuilder.gear_inventory())
	assert_eq(e.equipped_mods().size(), 0)


func test_equipped_mods_follow_slot_order_not_equip_order() -> void:
	var badge := ItemDefBuilder.trinket(&"item.kosk_badge", [
		ItemDefBuilder.mod(&"check_all", 2, &"faction.crown"),
		ItemDefBuilder.mod(&"check_all", -2, &"faction.strept"),
	] as Array[ItemModifier])
	var ring := ItemDefBuilder.trinket(&"item.ring", [ItemDefBuilder.mod(&"max_hp", 5)] as Array[ItemModifier])
	var mail := ItemDefBuilder.item(&"item.mail", &"armor", 1, 50)
	mail.equip_slot = &"armor"
	ItemDefBuilder.with_mods(mail, [ItemDefBuilder.mod(&"chill_rate_pct", -20)] as Array[ItemModifier])
	var e := Equipment.new(_inventory([badge, ring, mail] as Array[ItemDefinition]))
	e.equip(&"trinket_2", &"item.ring")
	e.equip(&"trinket_1", &"item.kosk_badge")
	e.equip(&"armor", &"item.mail")
	var seen: Array = []
	for m: ItemModifier in e.equipped_mods():
		seen.append([m.mod, m.value, m.vs_faction])
	assert_eq(seen, [
		[&"chill_rate_pct", -20, &""],
		[&"check_all", 2, &"faction.crown"],
		[&"check_all", -2, &"faction.strept"],
		[&"max_hp", 5, &""],
	])


func test_unequipping_drops_the_mods() -> void:
	var ring := ItemDefBuilder.trinket(&"item.ring", [ItemDefBuilder.mod(&"max_hp", 5)] as Array[ItemModifier])
	var e := Equipment.new(_inventory([ring] as Array[ItemDefinition]))
	e.equip(&"trinket_1", &"item.ring")
	assert_eq(e.equipped_mods().size(), 1)
	e.unequip(&"trinket_1")
	assert_eq(e.equipped_mods().size(), 0)


func test_armor_total_counts_an_armor_mod_on_an_equipped_trinket() -> void:
	var charm := ItemDefBuilder.trinket(&"item.iron_charm", [ItemDefBuilder.mod(&"armor", 2)] as Array[ItemModifier])
	var e := Equipment.new(_inventory([charm] as Array[ItemDefinition]))
	e.equip(&"trinket_1", &"item.iron_charm")
	assert_eq(e.armor_total(), 2, "the mod counts although the trinket has no armor payload")


func test_armor_total_adds_payload_and_armor_mods_together() -> void:
	var mail := ItemDefBuilder.item(&"item.mail", &"armor", 1, 50)
	mail.equip_slot = &"armor"
	mail.armor = ItemArmorPayload.new()
	mail.armor.armor = 10
	ItemDefBuilder.with_mods(mail, [ItemDefBuilder.mod(&"armor", 1)] as Array[ItemModifier])
	var charm := ItemDefBuilder.trinket(&"item.iron_charm", [ItemDefBuilder.mod(&"armor", 2)] as Array[ItemModifier])
	var e := Equipment.new(_inventory([mail, charm] as Array[ItemDefinition]))
	e.equip(&"armor", &"item.mail")
	e.equip(&"trinket_1", &"item.iron_charm")
	assert_eq(e.armor_total(), 13)


func test_armor_total_ignores_faction_bound_and_other_mods() -> void:
	var charm := ItemDefBuilder.trinket(&"item.iron_charm", [
		ItemDefBuilder.mod(&"armor", 4, &"faction.crown"),
		ItemDefBuilder.mod(&"max_hp", 9),
		ItemDefBuilder.mod(&"check_all", 1),
	] as Array[ItemModifier])
	var e := Equipment.new(_inventory([charm] as Array[ItemDefinition]))
	e.equip(&"trinket_1", &"item.iron_charm")
	assert_eq(e.armor_total(), 0)


func test_an_armor_mod_can_lower_the_total() -> void:
	var cursed := ItemDefBuilder.trinket(&"item.cursed", [ItemDefBuilder.mod(&"armor", -3)] as Array[ItemModifier])
	var e := Equipment.new(_inventory([cursed] as Array[ItemDefinition]))
	e.equip(&"trinket_1", &"item.cursed")
	assert_eq(e.armor_total(), -3)


func test_mods_are_not_part_of_the_equipment_snapshot() -> void:
	var ring := ItemDefBuilder.trinket(&"item.ring", [ItemDefBuilder.mod(&"max_hp", 5)] as Array[ItemModifier])
	var inv := _inventory([ring] as Array[ItemDefinition])
	var e := Equipment.new(inv)
	e.equip(&"trinket_1", &"item.ring")
	assert_eq(e.to_snapshot(), {"slots": {"trinket_1": "item.ring"}})
	var r := Equipment.new(inv)
	assert_true(r.restore(JsonRoundTrip.of(e.to_snapshot())).is_ok())
	assert_eq(r.equipped_mods().size(), 1, "mods come back through the catalog")
