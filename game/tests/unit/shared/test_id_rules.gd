## IdRules: global ids are `kind.snake_case` (architecture.md §4.1, §8.2).
extends GutTest


func test_kind_of_returns_prefix() -> void:
	assert_eq(IdRules.kind_of(&"item.iron_key"), &"item")
	assert_eq(IdRules.kind_of(&"ms.a1_audience_done"), &"ms")


func test_kind_of_without_dot_is_empty() -> void:
	assert_eq(IdRules.kind_of(&"iron_key"), &"")
	assert_eq(IdRules.kind_of(&""), &"")


func test_valid_id_of_expected_kind() -> void:
	assert_true(IdRules.is_valid(&"item.iron_key", &"item"))
	assert_true(IdRules.is_valid(&"rumor.r01_poisoned_cup", &"rumor"))


func test_wrong_kind_is_invalid() -> void:
	assert_false(IdRules.is_valid(&"item.iron_key", &"npc"))


func test_any_known_kind_when_kind_omitted() -> void:
	assert_true(IdRules.is_valid(&"ded.anselm_lied"))
	assert_false(IdRules.is_valid(&"spell.fireball"))


func test_unknown_kind_is_invalid_even_if_requested() -> void:
	assert_false(IdRules.is_valid(&"spell.fireball", &"spell"))


func test_bad_suffixes_are_invalid() -> void:
	for bad: StringName in [&"item.", &"item.Iron_Key", &"item.iron-key", &"item.iron.key", &"item.iron key", &"Item.iron_key"]:
		assert_false(IdRules.is_valid(bad), "expected invalid: %s" % bad)


func test_every_documented_kind_is_known() -> void:
	var documented: Array[StringName] = [&"item", &"npc", &"zone", &"dlg", &"quest", &"clue", &"ded",
		&"flag", &"var", &"ms", &"enemy", &"enc", &"faction", &"perk", &"rumor", &"map", &"edge",
		&"esc", &"ending", &"companion", &"ally", &"event"]
	for kind: StringName in documented:
		assert_true(IdRules.is_known_kind(kind), "kind %s" % kind)
