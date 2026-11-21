## CheckTotals: the dialogue and attribute check total before reputation
## (gdd.md §6.10 check rules, §6.8 Tongue perks; content-format.md §J.6 item mods and
## §J.1 attribute checks; architecture.md §4.11).
extends GutTest

const NO_PERKS: Array[StringName] = []
## A var, not a const: GDScript folds equal constant `[]`s into one, which would
## type this as Array[StringName].
var _no_items: Array[ItemModifier] = []


func _sheet(v: Dictionary[StringName, int]) -> ActorSheet:
	return ActorSheet.new(Attributes.new(v), func() -> int: return 1)


func test_persuade_with_perk() -> void:
	var s := _sheet({&"presence": 5})
	assert_eq(CheckTotals.compute(&"persuade", s, NO_PERKS, _no_items), 5)
	assert_eq(CheckTotals.compute(&"persuade", s, [&"perk.silver_tongue"] as Array[StringName], _no_items), 6)


func test_intimidate_uses_max_of_might_presence() -> void:
	var s := _sheet({&"might": 6, &"presence": 4})
	assert_eq(CheckTotals.compute(&"intimidate", s, NO_PERKS, _no_items), 6)
	assert_eq(CheckTotals.compute(&"intimidate", s, [&"perk.hard_stare"] as Array[StringName], _no_items), 7)


func test_intimidate_takes_presence_when_it_is_higher() -> void:
	var s := _sheet({&"might": 3, &"presence": 5})
	assert_eq(CheckTotals.compute(&"intimidate", s, NO_PERKS, _no_items), 5)


func test_investigate_and_lore() -> void:
	var s := _sheet({&"wits": 4})
	assert_eq(CheckTotals.compute(&"investigate", s, [&"perk.keen_eye"] as Array[StringName], _no_items), 5)
	assert_eq(CheckTotals.compute(&"lore", s, [&"perk.keen_eye"] as Array[StringName], _no_items), 4)


func test_a_perk_only_helps_its_own_skill() -> void:
	var s := _sheet({&"might": 4, &"wits": 4, &"presence": 4})
	var wrong: Array[StringName] = [&"perk.hard_stare", &"perk.keen_eye"]
	assert_eq(CheckTotals.compute(&"persuade", s, wrong, _no_items), 4)
	var other: Array[StringName] = [&"perk.silver_tongue", &"perk.keen_eye"]
	assert_eq(CheckTotals.compute(&"intimidate", s, other, _no_items), 4)
	var more: Array[StringName] = [&"perk.silver_tongue", &"perk.hard_stare"]
	assert_eq(CheckTotals.compute(&"investigate", s, more, _no_items), 4)


func test_attribute_checks_for_hazards() -> void:
	var s := _sheet({&"agility": 5, &"grit": 6})
	assert_eq(CheckTotals.compute(&"agility", s, NO_PERKS, _no_items), 5)
	assert_eq(CheckTotals.compute(&"grit", s, [&"perk.silver_tongue"] as Array[StringName], _no_items), 6)


func test_every_attribute_totals_to_its_own_value() -> void:
	var s := _sheet({&"might": 4, &"agility": 5, &"grit": 6, &"wits": 7, &"presence": 8})
	var every_perk: Array[StringName] = [&"perk.silver_tongue", &"perk.hard_stare", &"perk.keen_eye"]
	var expected: Dictionary[StringName, int] = {&"might": 4, &"agility": 5, &"grit": 6, &"wits": 7, &"presence": 8}
	for attr: StringName in CheckSkills.ATTRIBUTES:
		assert_eq(CheckTotals.compute(attr, s, every_perk, _no_items), expected[attr], String(attr))


func test_the_total_follows_a_raised_attribute() -> void:
	var s := ActorSheet.new(Attributes.new({&"wits": 4}), func() -> int: return 3)
	assert_true(s.spend_attribute_point(&"wits").is_ok())
	assert_eq(CheckTotals.compute(&"lore", s, NO_PERKS, _no_items), 5)


# --- item mods (content-format.md §J.6) ---


func _mods(list: Array) -> Array[ItemModifier]:
	var out: Array[ItemModifier] = []
	for entry: Array in list:
		var faction: StringName = entry[2] if entry.size() > 2 else &""
		out.append(ItemDefBuilder.mod(entry[0], entry[1], faction))
	return out


func test_check_persuade_applies_to_persuade_only() -> void:
	var s := _sheet({&"presence": 5, &"might": 3, &"wits": 4})
	var mods := _mods([[&"check_persuade", 1]])
	assert_eq(CheckTotals.compute(&"persuade", s, NO_PERKS, mods), 6)
	assert_eq(CheckTotals.compute(&"intimidate", s, NO_PERKS, mods), 5, "presence 5, no bonus")
	assert_eq(CheckTotals.compute(&"investigate", s, NO_PERKS, mods), 4)
	assert_eq(CheckTotals.compute(&"lore", s, NO_PERKS, mods), 4)
	assert_eq(CheckTotals.compute(&"presence", s, NO_PERKS, mods), 5, "not an attribute check")


func test_each_check_mod_matches_its_own_skill() -> void:
	var s := _sheet({&"presence": 4, &"might": 3, &"wits": 4})
	var cases: Dictionary[StringName, StringName] = {
		&"check_persuade": &"persuade", &"check_intimidate": &"intimidate",
		&"check_investigate": &"investigate", &"check_lore": &"lore",
	}
	for mod_name: StringName in cases:
		var mods := _mods([[mod_name, 2]])
		for skill: StringName in CheckSkills.DIALOGUE_SKILLS:
			var expected := 6 if skill == cases[mod_name] else 4
			assert_eq(CheckTotals.compute(skill, s, NO_PERKS, mods), expected, "%s on %s" % [mod_name, skill])


func test_check_all_applies_to_dialogue_and_attribute_checks() -> void:
	var s := _sheet({&"presence": 5, &"agility": 4})
	var mods := _mods([[&"check_all", 2]])
	assert_eq(CheckTotals.compute(&"persuade", s, NO_PERKS, mods), 7)
	assert_eq(CheckTotals.compute(&"agility", s, NO_PERKS, mods), 6, "§J.1: attribute checks take item bonuses")


func test_a_vs_faction_mod_adds_nothing() -> void:
	var s := _sheet({&"presence": 5, &"agility": 4})
	var mods := _mods([[&"check_all", 2, &"faction.crown"], [&"check_persuade", 3, &"faction.strept"]])
	assert_eq(CheckTotals.compute(&"persuade", s, NO_PERKS, mods), 5, "speaker-dependent: left to CheckResolver")
	assert_eq(CheckTotals.compute(&"agility", s, NO_PERKS, mods), 4)


func test_mods_stack_with_each_other_and_with_the_perk() -> void:
	var s := _sheet({&"presence": 5})
	var mods := _mods([[&"check_all", 2], [&"check_persuade", 1], [&"check_lore", 4]])
	var perks: Array[StringName] = [&"perk.silver_tongue"]
	assert_eq(CheckTotals.compute(&"persuade", s, perks, mods), 9)


func test_a_negative_mod_lowers_the_total() -> void:
	var s := _sheet({&"presence": 5})
	assert_eq(CheckTotals.compute(&"persuade", s, NO_PERKS, _mods([[&"check_all", -2]])), 3)


func test_non_check_mods_add_nothing() -> void:
	var s := _sheet({&"presence": 5, &"agility": 4})
	var mods := _mods([
		[&"armor", 3], [&"max_hp", 10], [&"bleed_buildup_pct", -25],
		[&"chill_rate_pct", 5], [&"stamina_regen_pct", 10],
	])
	assert_eq(CheckTotals.compute(&"persuade", s, NO_PERKS, mods), 5)
	assert_eq(CheckTotals.compute(&"agility", s, NO_PERKS, mods), 4)
