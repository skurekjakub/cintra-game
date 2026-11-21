## CheckTotals: the dialogue and attribute check total before reputation
## (gdd.md §6.10 check rules, §6.8 Tongue perks; architecture.md §4.11).
extends GutTest

const NO_PERKS: Array[StringName] = []
const NO_ITEMS: Array[StringName] = []


func _sheet(v: Dictionary[StringName, int]) -> ActorSheet:
	return ActorSheet.new(Attributes.new(v), func() -> int: return 1)


func test_persuade_with_perk() -> void:
	var s := _sheet({&"presence": 5})
	assert_eq(CheckTotals.compute(&"persuade", s, NO_PERKS, NO_ITEMS), 5)
	assert_eq(CheckTotals.compute(&"persuade", s, [&"perk.silver_tongue"] as Array[StringName], NO_ITEMS), 6)


func test_intimidate_uses_max_of_might_presence() -> void:
	var s := _sheet({&"might": 6, &"presence": 4})
	assert_eq(CheckTotals.compute(&"intimidate", s, NO_PERKS, NO_ITEMS), 6)
	assert_eq(CheckTotals.compute(&"intimidate", s, [&"perk.hard_stare"] as Array[StringName], NO_ITEMS), 7)


func test_intimidate_takes_presence_when_it_is_higher() -> void:
	var s := _sheet({&"might": 3, &"presence": 5})
	assert_eq(CheckTotals.compute(&"intimidate", s, NO_PERKS, NO_ITEMS), 5)


func test_investigate_and_lore() -> void:
	var s := _sheet({&"wits": 4})
	assert_eq(CheckTotals.compute(&"investigate", s, [&"perk.keen_eye"] as Array[StringName], NO_ITEMS), 5)
	assert_eq(CheckTotals.compute(&"lore", s, [&"perk.keen_eye"] as Array[StringName], NO_ITEMS), 4)


func test_a_perk_only_helps_its_own_skill() -> void:
	var s := _sheet({&"might": 4, &"wits": 4, &"presence": 4})
	var wrong: Array[StringName] = [&"perk.hard_stare", &"perk.keen_eye"]
	assert_eq(CheckTotals.compute(&"persuade", s, wrong, NO_ITEMS), 4)
	var other: Array[StringName] = [&"perk.silver_tongue", &"perk.keen_eye"]
	assert_eq(CheckTotals.compute(&"intimidate", s, other, NO_ITEMS), 4)
	var more: Array[StringName] = [&"perk.silver_tongue", &"perk.hard_stare"]
	assert_eq(CheckTotals.compute(&"investigate", s, more, NO_ITEMS), 4)


func test_attribute_checks_for_hazards() -> void:
	var s := _sheet({&"agility": 5, &"grit": 6})
	assert_eq(CheckTotals.compute(&"agility", s, NO_PERKS, NO_ITEMS), 5)
	assert_eq(CheckTotals.compute(&"grit", s, [&"perk.silver_tongue"] as Array[StringName], NO_ITEMS), 6)


func test_every_attribute_totals_to_its_own_value() -> void:
	var s := _sheet({&"might": 4, &"agility": 5, &"grit": 6, &"wits": 7, &"presence": 8})
	var every_perk: Array[StringName] = [&"perk.silver_tongue", &"perk.hard_stare", &"perk.keen_eye"]
	var expected: Dictionary[StringName, int] = {&"might": 4, &"agility": 5, &"grit": 6, &"wits": 7, &"presence": 8}
	for attr: StringName in CheckSkills.ATTRIBUTES:
		assert_eq(CheckTotals.compute(attr, s, every_perk, NO_ITEMS), expected[attr], String(attr))


func test_the_total_follows_a_raised_attribute() -> void:
	var s := ActorSheet.new(Attributes.new({&"wits": 4}), func() -> int: return 3)
	assert_true(s.spend_attribute_point(&"wits").is_ok())
	assert_eq(CheckTotals.compute(&"lore", s, NO_PERKS, NO_ITEMS), 5)
