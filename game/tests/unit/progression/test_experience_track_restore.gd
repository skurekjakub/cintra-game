## ExperienceTrack.restore(): all or nothing, rejecting a bad snapshot with
## save_invalid and leaving XP and spent points unchanged (architecture.md §4
## restore contract, §4.13; gdd.md §6.8 XP cap and skill points).
extends GutTest


func _populated() -> ExperienceTrack:
	var t := ExperienceTrack.new()
	t.grant(800, &"q")
	t.spend_skill_point()
	t.drain_events()
	return t


func test_a_valid_snapshot_restores_ok() -> void:
	var t := _populated()
	var r := ExperienceTrack.new()
	assert_true(r.restore(JsonRoundTrip.of(t.to_snapshot())).is_ok())
	assert_eq(r.to_snapshot(), t.to_snapshot())


func test_the_cap_and_every_earned_point_are_valid() -> void:
	var t := ExperienceTrack.new()
	assert_true(t.restore({"xp": 11550.0, "skill_points_spent": 11.0}).is_ok())
	assert_eq([t.xp(), t.unspent_skill_points()], [11550, 0])


func test_a_missing_key_is_rejected_and_named() -> void:
	var res := ExperienceTrack.new().restore({"xp": 0.0})
	assert_eq(res.error_code, &"save_invalid")
	assert_string_contains(res.detail, "experience_track.skill_points_spent")
	res = ExperienceTrack.new().restore({"skill_points_spent": 0.0})
	assert_string_contains(res.detail, "experience_track.xp")


func test_wrong_types_are_rejected() -> void:
	var t := ExperienceTrack.new()
	assert_eq(t.restore({"xp": 10.5, "skill_points_spent": 0.0}).error_code, &"save_invalid")
	assert_eq(t.restore({"xp": 10.0, "skill_points_spent": "0"}).error_code, &"save_invalid")


func test_out_of_range_values_are_rejected_not_clamped() -> void:
	var t := ExperienceTrack.new()
	for bad: Dictionary in [{"xp": 99999.0, "skill_points_spent": 0.0}, {"xp": -5.0, "skill_points_spent": 0.0},
			{"xp": 0.0, "skill_points_spent": -2.0}]:
		assert_eq(t.restore(bad).error_code, &"save_invalid", str(bad))
	assert_eq([t.xp(), t.unspent_skill_points()], [0, 0])


func test_spending_more_points_than_the_level_earned_is_rejected() -> void:
	var res := ExperienceTrack.new().restore({"xp": 800.0, "skill_points_spent": 3.0})   # level 3 earns 2
	assert_eq(res.error_code, &"save_invalid")
	assert_string_contains(res.detail, "experience_track.skill_points_spent")


func test_a_rejected_restore_changes_nothing_and_records_nothing() -> void:
	var t := _populated()
	var before := t.to_snapshot()
	assert_true(t.restore({"xp": 100.0, "skill_points_spent": 50.0}).is_err())
	assert_eq(t.to_snapshot(), before)
	assert_eq(t.drain_events().size(), 0)
