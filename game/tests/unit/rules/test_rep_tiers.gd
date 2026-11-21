## RepTiers: the ordered reputation tier names (gdd.md §6.12, content-format.md §C).
extends GutTest


func test_order_is_hostile_to_allied() -> void:
	assert_true(RepTiers.rank(&"hostile") < RepTiers.rank(&"wary"))
	assert_true(RepTiers.rank(&"friendly") < RepTiers.rank(&"allied"))
	assert_eq(RepTiers.rank(&"neutral"), 2)


func test_order_constant_lists_every_tier_in_order() -> void:
	assert_eq(RepTiers.ORDER, [&"hostile", &"wary", &"neutral", &"friendly", &"allied"] as Array[StringName])


func test_unknown_tier_ranks_minus_one() -> void:
	assert_eq(RepTiers.rank(&"beloved"), -1)
	assert_false(RepTiers.is_tier(&"beloved"))


func test_every_listed_tier_is_a_tier() -> void:
	for tier: StringName in RepTiers.ORDER:
		assert_true(RepTiers.is_tier(tier), String(tier))


func test_rep_mod_for_every_tier() -> void:
	var expected: Dictionary[StringName, int] = {
		&"hostile": -2, &"wary": -1, &"neutral": 0, &"friendly": 1, &"allied": 2,
	}
	for tier: StringName in RepTiers.ORDER:
		assert_eq(RepTiers.rep_mod(tier), expected[tier], String(tier))
	assert_eq(expected.size(), RepTiers.ORDER.size())


func test_rep_mod_rises_with_rank() -> void:
	for rank: int in range(1, RepTiers.ORDER.size()):
		assert_true(RepTiers.rep_mod(RepTiers.ORDER[rank]) > RepTiers.rep_mod(RepTiers.ORDER[rank - 1]))


func test_rep_mod_of_a_non_tier_is_zero() -> void:
	assert_eq(RepTiers.rep_mod(&"beloved"), 0)
