## ActorSheet.restore(): all or nothing, rejecting a bad snapshot with
## save_invalid and leaving attributes, HP and spent points unchanged
## (architecture.md §4 restore contract, §4.11; gdd.md §6.6 attributes 0..10).
extends GutTest

var _level: int = 3


func before_each() -> void:
	_level = 3


func _level_of() -> int:
	return _level


func _valid() -> Dictionary:
	return {"attributes": {"might": 4.0, "agility": 3.0, "grit": 5.0, "wits": 3.0, "presence": 3.0},
			"hp": 100.0, "points_spent": 1.0}


func _populated() -> ActorSheet:
	var s := ActorSheet.new(Attributes.new({&"might": 6}), _level_of)
	s.spend_attribute_point(&"grit")
	s.damage(30)
	s.drain_events()
	return s


func test_a_valid_snapshot_restores_ok() -> void:
	var s := _populated()
	var r := ActorSheet.new(Attributes.new(), _level_of)
	assert_true(r.restore(JsonRoundTrip.of(s.to_snapshot())).is_ok())
	assert_eq(r.to_snapshot(), s.to_snapshot())
	assert_true(r.restore(_valid()).is_ok())


func test_a_missing_key_is_rejected_and_named() -> void:
	for key: String in ["attributes", "hp", "points_spent"]:
		var data := _valid()
		data.erase(key)
		var res := ActorSheet.new(Attributes.new(), _level_of).restore(data)
		assert_eq(res.error_code, &"save_invalid")
		assert_string_contains(res.detail, "actor_sheet.%s" % key)


func test_a_missing_attribute_is_rejected_and_named() -> void:
	var data := _valid()
	(data["attributes"] as Dictionary).erase("wits")
	var res := ActorSheet.new(Attributes.new(), _level_of).restore(data)
	assert_eq(res.error_code, &"save_invalid")
	assert_string_contains(res.detail, "actor_sheet.attributes.wits")


func test_an_unknown_attribute_is_rejected() -> void:
	var data := _valid()
	(data["attributes"] as Dictionary)["luck"] = 3.0
	var res := ActorSheet.new(Attributes.new(), _level_of).restore(data)
	assert_eq(res.error_code, &"save_invalid")
	assert_string_contains(res.detail, "actor_sheet.attributes.luck")


func test_wrong_types_are_rejected() -> void:
	for patch: Dictionary in [{"hp": 10.5}, {"hp": "10"}, {"points_spent": true}, {"attributes": []}]:
		var data := _valid()
		data.merge(patch, true)
		var res := ActorSheet.new(Attributes.new(), _level_of).restore(data)
		assert_eq(res.error_code, &"save_invalid", str(patch))


func test_out_of_range_values_are_rejected() -> void:
	for patch: Dictionary in [{"hp": -1.0}, {"points_spent": -1.0}, {"points_spent": 6.0}]:
		var data := _valid()
		data.merge(patch, true)
		var res := ActorSheet.new(Attributes.new(), _level_of).restore(data)
		assert_eq(res.error_code, &"save_invalid", str(patch))
	for value: float in [11.0, -1.0]:
		var data := _valid()
		(data["attributes"] as Dictionary)["might"] = value
		var res := ActorSheet.new(Attributes.new(), _level_of).restore(data)
		assert_string_contains(res.detail, "actor_sheet.attributes.might")


func test_a_rejected_restore_changes_nothing_and_records_nothing() -> void:
	var s := _populated()
	var before := s.to_snapshot()
	var data := _valid()
	data["points_spent"] = 99.0
	assert_true(s.restore(data).is_err())
	assert_eq(s.to_snapshot(), before)
	assert_eq(s.drain_events().size(), 0)
