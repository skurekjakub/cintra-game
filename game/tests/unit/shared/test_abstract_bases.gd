## The shared kernel's abstract bases cannot be instantiated (architecture.md §4.1, §11 "L").
extends GutTest


func test_domain_event_is_abstract() -> void:
	assert_true((DomainEvent as Script).is_abstract())


func test_random_source_is_abstract() -> void:
	assert_true((RandomSource as Script).is_abstract())


func test_snapshotable_is_abstract() -> void:
	assert_true((Snapshotable as Script).is_abstract())


func test_snapshotable_subclass_round_trips() -> void:
	var a := FakeCounter.new()
	a.count = 5
	var b := FakeCounter.new()
	var r: Result = b.restore(JsonRoundTrip.of(a.to_snapshot()))
	assert_true(r.is_ok())
	assert_is(b, Snapshotable)
	assert_eq(b.count, 5)


func test_snapshotable_restore_rejects_a_bad_snapshot_unchanged() -> void:
	var b := FakeCounter.new()
	b.count = 5
	var r: Result = b.restore({"count": 2.5})
	assert_eq(r.error_code, &"save_invalid")
	assert_eq(b.count, 5)
