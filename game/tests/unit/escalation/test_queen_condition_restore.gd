## QueenCondition.restore(): all or nothing, rejecting a bad snapshot with
## save_invalid and leaving the condition unchanged (architecture.md §4 restore
## contract, §4.4; gdd.md §6.2 condition 0..3).
extends GutTest


func _populated() -> QueenCondition:
	var q := QueenCondition.new()
	q.recompute(3, 1)
	q.administer_antidote()
	q.drain_events()
	return q


func test_a_valid_snapshot_restores_ok() -> void:
	var q := _populated()
	var r := QueenCondition.new()
	assert_true(r.restore(JsonRoundTrip.of(q.to_snapshot())).is_ok())
	assert_eq(r.to_snapshot(), q.to_snapshot())


func test_a_missing_key_is_rejected_and_named() -> void:
	var res := QueenCondition.new().restore({"condition": 1.0})
	assert_eq(res.error_code, &"save_invalid")
	assert_string_contains(res.detail, "queen_condition.administered")
	res = QueenCondition.new().restore({"administered": false})
	assert_string_contains(res.detail, "queen_condition.condition")


func test_wrong_types_are_rejected() -> void:
	var q := QueenCondition.new()
	assert_eq(q.restore({"condition": 1.5, "administered": false}).error_code, &"save_invalid")
	assert_eq(q.restore({"condition": 1.0, "administered": 0.0}).error_code, &"save_invalid")
	assert_eq(q.restore({"condition": "1", "administered": false}).error_code, &"save_invalid")


func test_a_condition_outside_zero_to_three_is_rejected_not_clamped() -> void:
	var q := QueenCondition.new()
	var res := q.restore({"condition": 4.0, "administered": false})
	assert_eq(res.error_code, &"save_invalid")
	assert_string_contains(res.detail, "queen_condition.condition")
	assert_eq(q.restore({"condition": -1.0, "administered": false}).error_code, &"save_invalid")
	assert_eq(q.condition(), 0)


func test_a_rejected_restore_changes_nothing_and_records_nothing() -> void:
	var q := _populated()
	var before := q.to_snapshot()
	assert_true(q.restore({"condition": 9.0, "administered": false}).is_err())
	assert_eq(q.to_snapshot(), before)
	assert_eq(q.drain_events().size(), 0)
