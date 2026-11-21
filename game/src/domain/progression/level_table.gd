## The XP curve, the level cap and the points earned by level
## (gdd.md §6.8 progression; architecture.md §4.13). Pure functions, no state.
class_name LevelTable
extends RefCounted

const MAX_LEVEL := 12
## Levels that grant one attribute point (gdd.md §6.8). The actors domain keeps
## its own copy; a test keeps the two equal.
const ATTRIBUTE_POINT_LEVELS: Array[int] = [3, 5, 7, 9, 11]


## Cumulative XP needed to reach `level` (1..12): 75 x (L - 1) x (L + 2).
static func xp_for(level: int) -> int:
	assert(level >= 1 and level <= MAX_LEVEL, "level must be within 1..12")
	return 75 * (level - 1) * (level + 2)


## The highest level whose XP requirement `xp` meets, capped at MAX_LEVEL.
static func level_for(xp: int) -> int:
	var reached := 1
	while reached < MAX_LEVEL and xp >= xp_for(reached + 1):
		reached += 1
	return reached


## The XP at the level cap (11550); experience above it is discarded.
static func max_xp() -> int:
	return xp_for(MAX_LEVEL)


## Skill points earned up to `level`: one per level from 2 up (11 at the cap).
static func skill_points_at(level: int) -> int:
	assert(level >= 1 and level <= MAX_LEVEL, "level must be within 1..12")
	return level - 1


## Attribute points earned up to `level`: one at each of ATTRIBUTE_POINT_LEVELS.
static func attribute_points_at(level: int) -> int:
	assert(level >= 1 and level <= MAX_LEVEL, "level must be within 1..12")
	var earned := 0
	for point_level: int in ATTRIBUTE_POINT_LEVELS:
		if point_level <= level:
			earned += 1
	return earned
