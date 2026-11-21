## CheckSkills: the names a skill or attribute check may use (gdd.md §6.10, §6.6).
extends GutTest


func test_dialogue_skills_and_attributes_are_check_skills() -> void:
	for n: StringName in [&"persuade", &"lore", &"agility", &"grit", &"presence"]:
		assert_true(CheckSkills.is_check_skill(n), String(n))
	assert_false(CheckSkills.is_check_skill(&"stealth"))
	assert_true(CheckSkills.is_attribute(&"wits"))
	assert_false(CheckSkills.is_dialogue_skill(&"wits"))


func test_lists_hold_the_gdd_names() -> void:
	assert_eq(CheckSkills.DIALOGUE_SKILLS, [&"persuade", &"intimidate", &"investigate", &"lore"] as Array[StringName])
	assert_eq(CheckSkills.ATTRIBUTES, [&"might", &"agility", &"grit", &"wits", &"presence"] as Array[StringName])


func test_dialogue_skill_is_not_an_attribute() -> void:
	assert_true(CheckSkills.is_dialogue_skill(&"intimidate"))
	assert_false(CheckSkills.is_attribute(&"intimidate"))
