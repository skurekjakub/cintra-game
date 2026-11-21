## ItemModifier: one §J.6 item modifier, a {mod, value, vs_faction} value that
## inventory and actors both read from `rules` (content-format.md §J.6 items,
## §J.1 attribute checks; gdd.md §6.10 check rules; architecture.md §4.2).
extends GutTest


func _ok(mod_name: StringName, amount: int, faction: StringName = &"") -> ItemModifier:
	var r := ItemModifier.create(mod_name, amount, faction)
	assert_true(r.is_ok(), "%s should be valid" % mod_name)
	var m: ItemModifier = r.value
	return m


func test_mods_lists_exactly_the_j6_names() -> void:
	var expected: Array[StringName] = [
		&"check_persuade", &"check_intimidate", &"check_investigate", &"check_lore", &"check_all",
		&"bleed_buildup_pct", &"chill_rate_pct", &"armor", &"max_hp", &"stamina_regen_pct",
	]
	assert_eq(ItemModifier.MODS, expected)


func test_every_dialogue_skill_has_its_check_mod() -> void:
	for skill: StringName in CheckSkills.DIALOGUE_SKILLS:
		assert_true(ItemModifier.MODS.has(StringName("check_" + skill)), String(skill))


func test_create_keeps_the_fields() -> void:
	var m := _ok(&"check_persuade", 1)
	assert_eq([m.mod, m.value, m.vs_faction], [&"check_persuade", 1, &""])


func test_vs_faction_is_optional_and_kept_when_given() -> void:
	var m := _ok(&"check_all", -2, &"faction.strept")
	assert_eq([m.mod, m.value, m.vs_faction], [&"check_all", -2, &"faction.strept"])


func test_every_listed_mod_is_accepted() -> void:
	for name: StringName in ItemModifier.MODS:
		assert_true(ItemModifier.create(name, 5).is_ok(), String(name))


func test_zero_and_negative_values_are_accepted() -> void:
	assert_eq(_ok(&"armor", 0).value, 0)
	assert_eq(_ok(&"chill_rate_pct", -50).value, -50)


func test_an_unknown_mod_is_rejected() -> void:
	for name: StringName in [&"check_stealth", &"Armor", &"", &"check_agility"]:
		assert_eq(ItemModifier.create(name, 1).error_code, &"unknown_mod", "'%s'" % name)


func test_a_vs_faction_that_is_not_a_faction_id_is_rejected() -> void:
	for bad: StringName in [&"npc.kosk", &"crown", &"faction.", &"faction.Crown", &"faction.a-b", &"item.faction"]:
		assert_eq(ItemModifier.create(&"check_all", 2, bad).error_code, &"bad_arg", "'%s'" % bad)


func test_an_unknown_mod_is_reported_before_a_bad_faction() -> void:
	assert_eq(ItemModifier.create(&"nope", 1, &"npc.kosk").error_code, &"unknown_mod")
