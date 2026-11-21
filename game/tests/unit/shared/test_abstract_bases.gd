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
	b.restore(a.to_snapshot())
	assert_is(b, Snapshotable)
	assert_eq(b.count, 5)
