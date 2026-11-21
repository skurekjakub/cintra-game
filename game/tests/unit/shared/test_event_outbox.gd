## EventOutbox: where aggregates record events until a use case drains them (architecture.md §3.1).
extends GutTest


func test_drain_returns_in_order_and_empties() -> void:
	var o := EventOutbox.new()
	o.record(FakePingEvent.new("a"))
	o.record(FakePingEvent.new("b"))
	var out := o.drain()
	assert_eq(out.size(), 2)
	assert_eq((out[0] as FakePingEvent).label, "a")
	assert_eq((out[1] as FakePingEvent).label, "b")
	assert_true(o.is_empty())
	assert_eq(o.drain().size(), 0)


func test_is_empty_tracks_recording() -> void:
	var o := EventOutbox.new()
	assert_true(o.is_empty())
	o.record(FakePingEvent.new("a"))
	assert_false(o.is_empty())
