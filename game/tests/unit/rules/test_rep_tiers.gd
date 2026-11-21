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
