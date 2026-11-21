## ReputationLedger and FactionDefinition: reputation range and tiers (gdd.md §6.12),
## rep_mod by tier (gdd.md §6.10), events and snapshot (architecture.md §4.5, §9.3).
extends GutTest


func _ledger() -> ReputationLedger:
	return ReputationLedger.new([FactionDefinition.new(&"faction.crown", "Crown"),
		FactionDefinition.new(&"faction.strept", "Strept", -10)] as Array[FactionDefinition])


func test_start_values_and_tier() -> void:
	var l := _ledger()
	assert_eq(l.value(&"faction.strept"), -10)
	assert_eq(l.tier(&"faction.strept"), &"wary")
	assert_eq(l.value(&"faction.crown"), 0)
	assert_eq(l.tier(&"faction.crown"), &"neutral")


func test_constructing_records_no_events() -> void:
	assert_eq(_ledger().drain_events().size(), 0)


func test_definition_carries_id_name_and_start() -> void:
	var d := FactionDefinition.new(&"faction.strept", "Strept", -10)
	assert_eq([d.id, d.display_name, d.start], [&"faction.strept", "Strept", -10])
	assert_eq(FactionDefinition.new(&"faction.x", "X").start, 0)


func test_default_thresholds_are_the_lower_bounds() -> void:
	var d := FactionDefinition.new(&"faction.x", "X")
	assert_eq(d.thresholds, {&"wary": -49, &"neutral": -9, &"friendly": 10, &"allied": 50})


func test_tier_boundaries() -> void:
	var d := FactionDefinition.new(&"faction.x", "X")
	var cases := {-100: &"hostile", -50: &"hostile", -49: &"wary", -10: &"wary", -9: &"neutral",
		9: &"neutral", 10: &"friendly", 49: &"friendly", 50: &"allied", 100: &"allied"}
	for v: int in cases:
		assert_eq(d.tier_for(v), cases[v], str(v))


func test_custom_thresholds_move_the_boundaries() -> void:
	var d := FactionDefinition.new(&"faction.x", "X")
	d.thresholds = {&"wary": -20, &"neutral": -5, &"friendly": 30, &"allied": 80}
	assert_eq(d.tier_for(-21), &"hostile")
	assert_eq(d.tier_for(-20), &"wary")
	assert_eq(d.tier_for(29), &"neutral")
	assert_eq(d.tier_for(30), &"friendly")
	assert_eq(d.tier_for(80), &"allied")


func test_add_clamps_and_emits() -> void:
	var l := _ledger()
	l.add(&"faction.crown", 150)
	assert_eq(l.value(&"faction.crown"), 100)
	var events := l.drain_events()
	assert_eq(events.size(), 2)
	assert_eq((events[1] as ReputationTierChanged).new_tier, &"allied")
	l.add(&"faction.crown", 5)
	assert_eq(l.drain_events().size(), 0)


func test_add_clamps_at_the_floor() -> void:
	var l := _ledger()
	l.add(&"faction.crown", -150)
	assert_eq(l.value(&"faction.crown"), -100)
	assert_eq(l.tier(&"faction.crown"), &"hostile")


func test_reputation_changed_carries_id_and_values() -> void:
	var l := _ledger()
	l.add(&"faction.crown", 150)
	var e := l.drain_events()[0] as ReputationChanged
	assert_eq(e.id, &"faction.crown")
	assert_eq([e.old_value, e.new_value], [0, 100])


func test_tier_changed_carries_id_and_tiers_in_order() -> void:
	var l := _ledger()
	l.add(&"faction.crown", -60)
	var events := l.drain_events()
	assert_eq(events.size(), 2)
	assert_true(events[0] is ReputationChanged)
	var e := events[1] as ReputationTierChanged
	assert_eq(e.id, &"faction.crown")
	assert_eq([e.old_tier, e.new_tier], [&"neutral", &"hostile"])


func test_change_inside_a_tier_emits_only_the_value_event() -> void:
	var l := _ledger()
	l.add(&"faction.crown", 5)
	var events := l.drain_events()
	assert_eq(events.size(), 1)
	assert_true(events[0] is ReputationChanged)


func test_zero_delta_emits_nothing() -> void:
	var l := _ledger()
	l.add(&"faction.crown", 0)
	assert_eq(l.drain_events().size(), 0)


func test_crossing_several_tiers_emits_one_tier_event() -> void:
	var l := _ledger()
	l.add(&"faction.crown", 60)
	var events := l.drain_events()
	assert_eq(events.size(), 2)
	var e := events[1] as ReputationTierChanged
	assert_eq([e.old_tier, e.new_tier], [&"neutral", &"allied"])


func test_factions_are_independent() -> void:
	var l := _ledger()
	l.add(&"faction.crown", 20)
	assert_eq(l.value(&"faction.strept"), -10)
	assert_eq(l.tier(&"faction.strept"), &"wary")


func test_rep_mod_by_tier() -> void:
	var l := _ledger()
	assert_eq(l.rep_mod(&"faction.crown"), 0)
	assert_eq(l.rep_mod(&"faction.strept"), -1)
	l.add(&"faction.crown", 15)
	assert_eq(l.rep_mod(&"faction.crown"), 1)
	l.add(&"faction.strept", -45)
	assert_eq(l.rep_mod(&"faction.strept"), -2)


func test_rep_mod_allied_is_plus_two() -> void:
	var l := _ledger()
	l.add(&"faction.crown", 50)
	assert_eq(l.rep_mod(&"faction.crown"), 2)


func test_snapshot_survives_json_round_trip() -> void:
	var l := _ledger()
	l.add(&"faction.crown", 15)
	var r := _ledger()
	r.restore(JsonRoundTrip.of(l.to_snapshot()))
	assert_eq(r.to_snapshot(), l.to_snapshot())
	assert_eq(r.value(&"faction.crown"), 15)
	assert_eq(r.value(&"faction.strept"), -10)


func test_snapshot_shape_is_string_keys_and_int_values() -> void:
	var l := _ledger()
	l.add(&"faction.crown", 15)
	assert_eq(l.to_snapshot(), {"values": {"faction.crown": 15, "faction.strept": -10}})


func test_restore_replaces_state_and_emits_nothing() -> void:
	var src := _ledger()
	src.add(&"faction.crown", 30)
	var r := _ledger()
	r.add(&"faction.strept", 40)
	r.drain_events()
	r.restore(JsonRoundTrip.of(src.to_snapshot()))
	assert_eq(r.value(&"faction.crown"), 30)
	assert_eq(r.value(&"faction.strept"), -10)
	assert_eq(r.drain_events().size(), 0)


func test_restore_does_not_touch_pending_events() -> void:
	var l := _ledger()
	l.add(&"faction.crown", 5)
	l.restore(JsonRoundTrip.of(_ledger().to_snapshot()))
	assert_eq(l.drain_events().size(), 1)
	assert_eq(l.value(&"faction.crown"), 0)


func test_restore_keeps_start_for_a_faction_missing_from_the_snapshot() -> void:
	var l := _ledger()
	l.add(&"faction.strept", 30)
	l.restore({"values": {"faction.crown": 7.0}})
	assert_eq(l.value(&"faction.crown"), 7)
	assert_eq(l.value(&"faction.strept"), -10)


func test_restore_ignores_a_faction_the_ledger_does_not_define() -> void:
	var l := _ledger()
	l.restore({"values": {"faction.crown": 7.0, "faction.gone": 90.0}})
	assert_eq(l.to_snapshot(), {"values": {"faction.crown": 7, "faction.strept": -10}})


func test_queries_on_an_unknown_faction_are_lenient() -> void:
	var l := _ledger()
	assert_eq(l.value(&"faction.nobody"), 0)
	assert_eq(l.tier(&"faction.nobody"), &"neutral")
	assert_eq(l.rep_mod(&"faction.nobody"), 0)
	assert_eq(l.rep_mod(&"faction.nobody"), RepTiers.rep_mod(l.tier(&"faction.nobody")))


func test_unknown_faction_queries_change_nothing() -> void:
	var l := _ledger()
	var before := l.to_snapshot()
	l.value(&"faction.nobody")
	l.tier(&"faction.nobody")
	l.rep_mod(&"faction.nobody")
	assert_eq(l.to_snapshot(), before)
	assert_eq(l.drain_events().size(), 0)


func test_rep_mod_matches_the_shared_table_for_every_tier() -> void:
	var l := _ledger()
	for score: int in [-100, -20, 0, 20, 100]:
		l.add(&"faction.crown", score - l.value(&"faction.crown"))
		assert_eq(l.rep_mod(&"faction.crown"), RepTiers.rep_mod(l.tier(&"faction.crown")), str(score))
