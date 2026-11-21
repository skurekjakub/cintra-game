## ReputationLedger.restore(): all or nothing, rejecting a bad snapshot with
## save_invalid and leaving every score unchanged (architecture.md §4 restore
## contract, §4.14; gdd.md §6.12 reputation -100..100).
extends GutTest


func _ledger() -> ReputationLedger:
	return ReputationLedger.new([FactionDefinition.new(&"faction.crown", "Crown"),
		FactionDefinition.new(&"faction.strept", "Strept", -10)] as Array[FactionDefinition])


func _populated() -> ReputationLedger:
	var l := _ledger()
	l.add(&"faction.crown", 25)
	l.add(&"faction.strept", -30)
	l.drain_events()
	return l


func test_a_valid_snapshot_restores_ok() -> void:
	var l := _populated()
	var r := _ledger()
	assert_true(r.restore(JsonRoundTrip.of(l.to_snapshot())).is_ok())
	assert_eq(r.to_snapshot(), l.to_snapshot())


func test_a_missing_key_is_rejected_and_named() -> void:
	var res := _ledger().restore({})
	assert_eq(res.error_code, &"save_invalid")
	assert_string_contains(res.detail, "reputation_ledger.values")


func test_a_faction_missing_from_the_snapshot_is_rejected() -> void:
	var l := _ledger()
	l.add(&"faction.strept", 30)
	var res := l.restore({"values": {"faction.crown": 7.0}})
	assert_eq(res.error_code, &"save_invalid")
	assert_string_contains(res.detail, "reputation_ledger.values.faction.strept")
	assert_eq([l.value(&"faction.crown"), l.value(&"faction.strept")], [0, 20])


func test_a_faction_the_ledger_does_not_define_is_rejected() -> void:
	var res := _ledger().restore({"values": {"faction.crown": 7.0, "faction.strept": 0.0, "faction.gone": 90.0}})
	assert_eq(res.error_code, &"save_invalid")
	assert_string_contains(res.detail, "reputation_ledger.values.faction.gone")


func test_wrong_types_are_rejected() -> void:
	for bad: Variant in [{"faction.crown": 7.5, "faction.strept": 0.0}, {"faction.crown": "7", "faction.strept": 0.0}, []]:
		assert_eq(_ledger().restore({"values": bad}).error_code, &"save_invalid", str(bad))


func test_a_score_outside_the_range_is_rejected_not_clamped() -> void:
	for score: float in [101.0, -101.0]:
		var res := _ledger().restore({"values": {"faction.crown": score, "faction.strept": 0.0}})
		assert_eq(res.error_code, &"save_invalid", str(score))
		assert_string_contains(res.detail, "reputation_ledger.values.faction.crown")


func test_a_rejected_restore_changes_nothing_and_records_nothing() -> void:
	var l := _populated()
	var before := l.to_snapshot()
	assert_true(l.restore({"values": {"faction.crown": 0.0, "faction.strept": 500.0}}).is_err())
	assert_eq(l.to_snapshot(), before)
	assert_eq(l.drain_events().size(), 0)
