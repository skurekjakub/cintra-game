## WorldState: flags, bounded vars, write-once milestones and the act counter
## (architecture.md §4.3; content-format.md §E add_var clamps; gdd.md §6.1 write-once milestones).
## Restore validation: test_world_state_restore.gd.
extends GutTest


func test_flags_set_clear_and_event_only_on_change() -> void:
	var w := WorldState.new()
	w.set_flag(&"flag.courier_dead")
	w.set_flag(&"flag.courier_dead")
	assert_true(w.has_flag(&"flag.courier_dead"))
	assert_eq(w.drain_events().size(), 1)
	w.set_flag(&"flag.courier_dead", false)
	assert_false(w.has_flag(&"flag.courier_dead"))
	assert_false((w.drain_events()[0] as FlagChanged).value)


func test_clearing_an_unset_flag_records_nothing() -> void:
	var w := WorldState.new()
	w.set_flag(&"flag.never_set", false)
	assert_false(w.has_flag(&"flag.never_set"))
	assert_eq(w.drain_events().size(), 0)


func test_flag_changed_carries_id_and_value() -> void:
	var w := WorldState.new()
	w.set_flag(&"flag.a")
	var e := w.drain_events()[0] as FlagChanged
	assert_eq(e.id, &"flag.a")
	assert_true(e.value)


func test_add_var_clamps_to_bounds() -> void:
	var w := WorldState.new({&"var.bulbs_recovered": Vector2i(0, 6)})
	w.add_var(&"var.bulbs_recovered", 10)
	assert_eq(w.get_var(&"var.bulbs_recovered"), 6)
	var e := w.drain_events()[0] as VarChanged
	assert_eq([e.old_value, e.new_value], [0, 6])
	w.add_var(&"var.bulbs_recovered", -20)
	assert_eq(w.get_var(&"var.bulbs_recovered"), 0)


func test_add_var_at_the_bound_records_nothing() -> void:
	var w := WorldState.new({&"var.bulbs_recovered": Vector2i(0, 6)})
	w.add_var(&"var.bulbs_recovered", 6)
	w.drain_events()
	w.add_var(&"var.bulbs_recovered", 3)
	assert_eq(w.get_var(&"var.bulbs_recovered"), 6)
	assert_eq(w.drain_events().size(), 0)


func test_set_var_does_not_clamp() -> void:
	var w := WorldState.new({&"var.bulbs_recovered": Vector2i(0, 6)})
	w.set_var(&"var.bulbs_recovered", 99)
	assert_eq(w.get_var(&"var.bulbs_recovered"), 99)


func test_set_var_records_only_a_real_change() -> void:
	var w := WorldState.new()
	w.set_var(&"var.x", 4)
	w.set_var(&"var.x", 4)
	w.set_var(&"var.y", 0)
	var events := w.drain_events()
	assert_eq(events.size(), 1)
	var e := events[0] as VarChanged
	assert_eq(e.id, &"var.x")
	assert_eq([e.old_value, e.new_value], [0, 4])


func test_unbounded_var_and_default_zero() -> void:
	var w := WorldState.new()
	assert_eq(w.get_var(&"var.x"), 0)
	w.add_var(&"var.x", -5)
	assert_eq(w.get_var(&"var.x"), -5)


func test_milestone_write_once_in_order() -> void:
	var w := WorldState.new()
	assert_true(w.reach_milestone(&"ms.a1_rat_survived"))
	assert_false(w.reach_milestone(&"ms.a1_rat_survived"))
	w.reach_milestone(&"ms.a1_audience_done")
	assert_eq(w.milestones(), [&"ms.a1_rat_survived", &"ms.a1_audience_done"] as Array[StringName])
	assert_eq(w.drain_events().size(), 2)
	assert_eq(w.count_milestones([&"ms.a1_audience_done", &"ms.nope"] as Array[StringName]), 1)


func test_milestone_reached_event_carries_id() -> void:
	var w := WorldState.new()
	w.reach_milestone(&"ms.a1_rat_survived")
	assert_true(w.has_milestone(&"ms.a1_rat_survived"))
	assert_false(w.has_milestone(&"ms.nope"))
	var e := w.drain_events()[0] as MilestoneReached
	assert_eq(e.id, &"ms.a1_rat_survived")


func test_act_changes() -> void:
	var w := WorldState.new()
	assert_eq(w.act(), 1)
	w.set_act(2)
	w.set_act(2)
	var events := w.drain_events()
	assert_eq(events.size(), 1)
	assert_eq((events[0] as ActChanged).new_act, 2)
	assert_eq((events[0] as ActChanged).old_act, 1)


func test_drain_empties_the_outbox() -> void:
	var w := WorldState.new()
	w.set_flag(&"flag.a")
	assert_eq(w.drain_events().size(), 1)
	assert_eq(w.drain_events().size(), 0)


func test_snapshot_survives_json_round_trip() -> void:
	var w := WorldState.new()
	w.set_flag(&"flag.a")
	w.set_var(&"var.b", 3)
	w.reach_milestone(&"ms.c")
	w.set_act(2)
	var r := WorldState.new()
	assert_true(r.restore(JsonRoundTrip.of(w.to_snapshot())).is_ok())
	assert_eq(r.to_snapshot(), w.to_snapshot())
	assert_true(r.has_flag(&"flag.a"))
	assert_eq(r.get_var(&"var.b"), 3)
	assert_eq(r.milestones(), [&"ms.c"] as Array[StringName])
	assert_eq(r.act(), 2)
	assert_eq(r.drain_events().size(), 0)


func test_snapshot_shape_stores_only_true_flags_and_plain_values() -> void:
	var w := WorldState.new()
	w.set_flag(&"flag.b")
	w.set_flag(&"flag.a")
	w.set_flag(&"flag.gone")
	w.set_flag(&"flag.gone", false)
	w.set_var(&"var.n", 7)
	w.reach_milestone(&"ms.z")
	w.reach_milestone(&"ms.y")
	var snap := w.to_snapshot()
	assert_eq(snap["flags"], ["flag.a", "flag.b"] as Array[String])
	assert_eq(snap["vars"], {"var.n": 7})
	assert_eq(snap["milestones"], ["ms.z", "ms.y"] as Array[String])
	assert_eq(snap["act"], 1)


func test_restore_keeps_vars_as_ints_after_json() -> void:
	var w := WorldState.new()
	w.set_var(&"var.b", 3)
	var r := WorldState.new()
	assert_true(r.restore(JsonRoundTrip.of(w.to_snapshot())).is_ok())
	var stored: Variant = (r.to_snapshot()["vars"] as Dictionary)["var.b"]
	assert_typeof(stored, TYPE_INT)
	assert_typeof(r.to_snapshot()["act"], TYPE_INT)


func test_restore_replaces_all_state_and_emits_nothing() -> void:
	var src := WorldState.new()
	src.set_flag(&"flag.keep")
	var r := WorldState.new()
	r.set_flag(&"flag.stale")
	r.set_var(&"var.stale", 9)
	r.reach_milestone(&"ms.stale")
	r.set_act(3)
	r.drain_events()
	assert_true(r.restore(JsonRoundTrip.of(src.to_snapshot())).is_ok())
	assert_false(r.has_flag(&"flag.stale"))
	assert_true(r.has_flag(&"flag.keep"))
	assert_eq(r.get_var(&"var.stale"), 0)
	assert_false(r.has_milestone(&"ms.stale"))
	assert_eq(r.act(), 1)
	assert_eq(r.drain_events().size(), 0)
