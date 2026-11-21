## LevelTable: the XP curve, the level cap and the points earned by level
## (gdd.md §6.8; architecture.md §4.13).
extends GutTest


func test_xp_table_matches_gdd() -> void:
	var expected := [0, 300, 750, 1350, 2100, 3000, 4050, 5250, 6600, 8100, 9750, 11550]
	for l: int in range(1, 13):
		assert_eq(LevelTable.xp_for(l), expected[l - 1], str(l))


func test_level_for() -> void:
	assert_eq([LevelTable.level_for(0), LevelTable.level_for(299), LevelTable.level_for(300),
		LevelTable.level_for(11550), LevelTable.level_for(99999)], [1, 1, 2, 12, 12])


func test_level_for_is_the_inverse_of_xp_for_at_every_boundary() -> void:
	for l: int in range(1, LevelTable.MAX_LEVEL + 1):
		assert_eq(LevelTable.level_for(LevelTable.xp_for(l)), l, "at %d" % l)
		if l > 1:
			assert_eq(LevelTable.level_for(LevelTable.xp_for(l) - 1), l - 1, "just below %d" % l)


func test_constants() -> void:
	assert_eq(LevelTable.MAX_LEVEL, 12)
	assert_eq(LevelTable.max_xp(), 11550)
	assert_eq(LevelTable.max_xp(), LevelTable.xp_for(LevelTable.MAX_LEVEL))
	assert_eq(LevelTable.ATTRIBUTE_POINT_LEVELS, [3, 5, 7, 9, 11] as Array[int])


func test_points_at() -> void:
	assert_eq(LevelTable.skill_points_at(12), 11)
	assert_eq(LevelTable.attribute_points_at(5), 2)
	assert_eq(LevelTable.attribute_points_at(12), 5)


func test_skill_points_are_level_minus_one() -> void:
	assert_eq(LevelTable.skill_points_at(1), 0)
	assert_eq(LevelTable.skill_points_at(2), 1)
	assert_eq(LevelTable.skill_points_at(7), 6)


func test_attribute_points_step_up_on_the_odd_levels_from_three() -> void:
	var expected := [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5]
	for l: int in range(1, 13):
		assert_eq(LevelTable.attribute_points_at(l), expected[l - 1], str(l))


## The actors domain keeps its own copy (it cannot reference progression); this
## keeps the two lists from drifting apart.
func test_attribute_point_levels_match_the_actor_sheets_copy() -> void:
	assert_eq(ActorSheet.ATTRIBUTE_POINT_LEVELS, LevelTable.ATTRIBUTE_POINT_LEVELS)
