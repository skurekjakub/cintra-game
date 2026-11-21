## QueenCondition: the Queen's derived condition (gdd.md §6.2; architecture.md
## §4.9, §9.3): formula, antidote freeze, improvement on milestones, events and
## the JSON-safe snapshot.
extends GutTest


func test_formula() -> void:
	var cases := [[0, 0, 0], [1, 0, 1], [2, 1, 1], [1, 2, 0], [3, 0, 3], [4, 0, 3], [4, 2, 1]]
	for c: Array in cases:
		var stage: int = c[0]
		var mitigations: int = c[1]
		var expected: int = c[2]
		var q := QueenCondition.new()
		q.recompute(stage, mitigations)
		assert_eq(q.condition(), expected, str(c))


func test_starts_at_zero_and_not_administered() -> void:
	var q := QueenCondition.new()
	assert_eq(q.condition(), 0)
	assert_false(q.antidote_administered())
	assert_eq(q.drain_events().size(), 0)


func test_change_event_only_on_change() -> void:
	var q := QueenCondition.new()
	q.recompute(2, 0)
	q.recompute(2, 0)
	var events := q.drain_events()
	assert_eq(events.size(), 1)
	assert_eq((events[0] as QueenConditionChanged).new_condition, 2)


func test_change_event_carries_old_and_new_condition_in_order() -> void:
	var q := QueenCondition.new()
	q.recompute(1, 0)
	q.recompute(3, 0)
	q.recompute(3, 2)
	var events := q.drain_events()
	assert_eq(events.size(), 3)
	var pairs: Array = []
	for e in events:
		var changed := e as QueenConditionChanged
		pairs.append([changed.old_condition, changed.new_condition])
	assert_eq(pairs, [[0, 1], [1, 3], [3, 1]])


func test_recompute_to_the_same_value_from_zero_records_nothing() -> void:
	var q := QueenCondition.new()
	q.recompute(0, 0)
	q.recompute(1, 5)
	assert_eq(q.condition(), 0)
	assert_eq(q.drain_events().size(), 0)


func test_antidote_freezes_then_improves_to_zero() -> void:
	var q := QueenCondition.new()
	q.recompute(2, 0)
	q.administer_antidote()
	q.administer_antidote()
	q.recompute(4, 0)
	assert_eq(q.condition(), 2)
	q.improve_on_milestone()
	q.improve_on_milestone()
	q.improve_on_milestone()
	assert_eq(q.condition(), 0)
	assert_true(q.resolve_survival())


func test_antidote_is_recorded_once_and_does_not_change_the_condition() -> void:
	var q := QueenCondition.new()
	q.recompute(2, 0)
	q.drain_events()
	q.administer_antidote()
	q.administer_antidote()
	var events := q.drain_events()
	assert_eq(events.size(), 1)
	assert_true(events[0] is AntidoteAdministered)
	assert_eq(q.condition(), 2)
	assert_true(q.antidote_administered())


func test_improvement_records_one_event_per_step_and_none_at_zero() -> void:
	var q := QueenCondition.new()
	q.recompute(1, 0)
	q.administer_antidote()
	q.drain_events()
	q.improve_on_milestone()
	q.improve_on_milestone()
	var events := q.drain_events()
	assert_eq(events.size(), 1)
	var changed := events[0] as QueenConditionChanged
	assert_eq([changed.old_condition, changed.new_condition], [1, 0])


func test_improve_before_antidote_does_nothing() -> void:
	var q := QueenCondition.new()
	q.recompute(3, 0)
	q.drain_events()
	q.improve_on_milestone()
	assert_eq(q.condition(), 3)
	assert_false(q.resolve_survival())
	assert_eq(q.drain_events().size(), 0)


func test_snapshot_survives_json_round_trip() -> void:
	var q := QueenCondition.new()
	q.recompute(3, 1)
	q.administer_antidote()
	var r := QueenCondition.new()
	r.restore(JsonRoundTrip.of(q.to_snapshot()))
	assert_eq(r.to_snapshot(), q.to_snapshot())
	assert_eq(r.condition(), 2)
	assert_true(r.antidote_administered())


func test_snapshot_shape() -> void:
	var q := QueenCondition.new()
	q.recompute(2, 0)
	assert_eq(q.to_snapshot(), {"condition": 2, "administered": false})


func test_restore_replaces_state_and_records_no_events() -> void:
	var source := QueenCondition.new()
	source.recompute(1, 0)
	var q := QueenCondition.new()
	q.recompute(3, 0)
	q.administer_antidote()
	q.drain_events()
	q.restore(JsonRoundTrip.of(source.to_snapshot()))
	assert_eq(q.condition(), 1)
	assert_false(q.antidote_administered())
	assert_eq(q.drain_events().size(), 0)
	q.recompute(3, 0)
	assert_eq(q.condition(), 3, "the restored (unfrozen) state is live again")
