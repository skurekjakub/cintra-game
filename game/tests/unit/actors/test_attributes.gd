## Attributes: the five-attribute value and its creation rules
## (gdd.md §6.6; architecture.md §4.11).
extends GutTest


func test_defaults_are_three() -> void:
	var a := Attributes.new()
	for attr: StringName in CheckSkills.ATTRIBUTES:
		assert_eq(a.get_value(attr), 3)


func test_constants_follow_the_gdd() -> void:
	assert_eq([Attributes.BASE, Attributes.MAX, Attributes.CREATION_POINTS, Attributes.CREATION_CAP], [3, 10, 4, 6])


func test_given_values_override_and_missing_names_stay_three() -> void:
	var a := Attributes.new({&"might": 5, &"wits": 2})
	assert_eq([a.get_value(&"might"), a.get_value(&"wits"), a.get_value(&"grit")], [5, 2, 3])


func test_create_with_four_points() -> void:
	var r := Attributes.create({&"might": 2, &"grit": 2})
	assert_true(r.is_ok())
	var a: Attributes = r.value
	assert_eq(a.get_value(&"might"), 5)
	assert_eq(a.get_value(&"grit"), 5)
	assert_eq(a.get_value(&"agility"), 3)


func test_create_accepts_a_point_cap_of_six() -> void:
	var r := Attributes.create({&"presence": 3, &"wits": 1})
	assert_true(r.is_ok())
	var a: Attributes = r.value
	assert_eq(a.get_value(&"presence"), 6)


func test_create_rejects_wrong_total_cap_and_unknown() -> void:
	assert_eq(Attributes.create({&"might": 3}).error_code, &"wrong_point_total")
	assert_eq(Attributes.create({&"might": 4}).error_code, &"attribute_over_creation_cap")
	assert_eq(Attributes.create({&"luck": 4}).error_code, &"unknown_attribute")


func test_create_rejects_too_many_points_and_negatives() -> void:
	assert_eq(Attributes.create({&"might": 2, &"grit": 3}).error_code, &"wrong_point_total")
	assert_eq(Attributes.create({&"might": 5, &"grit": -1}).error_code, &"wrong_point_total")
	assert_eq(Attributes.create({}).error_code, &"wrong_point_total")


func test_with_point_is_immutable() -> void:
	var a := Attributes.new()
	var b := a.with_point(&"wits")
	assert_eq([a.get_value(&"wits"), b.get_value(&"wits")], [3, 4])
	assert_eq(b.get_value(&"might"), 3)


func test_to_dict_lists_all_five_attributes() -> void:
	var d := Attributes.new({&"grit": 7}).to_dict()
	assert_eq(d.size(), 5)
	assert_eq(d[&"grit"], 7)
	assert_eq(d[&"presence"], 3)


func test_to_dict_is_a_copy() -> void:
	var a := Attributes.new()
	var d := a.to_dict()
	d[&"might"] = 9
	assert_eq(a.get_value(&"might"), 3)
