## WorldState.restore(): all or nothing, rejecting a bad snapshot with
## save_invalid and leaving flags, vars, milestones and the act unchanged
## (architecture.md §4 restore contract, §4.3; gdd.md §6.1 acts 1..3, write-once
## milestones).
extends GutTest


func _valid() -> Dictionary:
	return {"flags": ["flag.a"], "vars": {"var.b": 3.0, "var.debt": -4.0}, "milestones": ["ms.c", "ms.d"], "act": 2.0}


func _populated() -> WorldState:
	var w := WorldState.new()
	w.set_flag(&"flag.keep")
	w.set_var(&"var.n", 7)
	w.reach_milestone(&"ms.z")
	w.set_act(2)
	w.drain_events()
	return w


func _rejects(patch: Dictionary) -> String:
	var data := _valid()
	data.merge(patch, true)
	var res := WorldState.new().restore(data)
	assert_eq(res.error_code, &"save_invalid", str(patch))
	return res.detail


func test_a_valid_snapshot_restores_ok() -> void:
	var w := _populated()
	var r := WorldState.new()
	assert_true(r.restore(JsonRoundTrip.of(w.to_snapshot())).is_ok())
	assert_eq(r.to_snapshot(), w.to_snapshot())
	assert_true(r.restore(_valid()).is_ok())
	assert_eq(r.get_var(&"var.debt"), -4)


func test_a_missing_key_is_rejected_and_named() -> void:
	for key: String in ["flags", "vars", "milestones", "act"]:
		var data := _valid()
		data.erase(key)
		var res := WorldState.new().restore(data)
		assert_eq(res.error_code, &"save_invalid")
		assert_string_contains(res.detail, "world_state.%s" % key)


func test_wrong_types_are_rejected() -> void:
	assert_string_contains(_rejects({"flags": [3.0]}), "world_state.flags[0]")
	assert_string_contains(_rejects({"vars": {"var.b": 2.5}}), "world_state.vars.var.b")
	assert_string_contains(_rejects({"vars": {"var.b": "3"}}), "world_state.vars.var.b")
	_rejects({"milestones": "ms.c"})
	_rejects({"act": "2"})


func test_an_act_outside_one_to_three_is_rejected() -> void:
	assert_string_contains(_rejects({"act": 7.0}), "world_state.act")
	_rejects({"act": 0.0})


func test_empty_or_repeated_ids_are_rejected() -> void:
	assert_string_contains(_rejects({"milestones": ["ms.c", "ms.c"]}), "world_state.milestones[1]")
	_rejects({"flags": [""]})


func test_a_rejected_restore_changes_nothing_and_records_nothing() -> void:
	var w := _populated()
	var before := w.to_snapshot()
	var data := _valid()
	data["act"] = 7.0
	assert_true(w.restore(data).is_err())
	assert_eq(w.to_snapshot(), before)
	assert_eq(w.drain_events().size(), 0)
