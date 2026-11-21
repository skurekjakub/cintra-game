## EventBus: typed, synchronous, FIFO mediator keyed by event class (architecture.md §3.2).
extends GutTest

var _bus: EventBus
var _log: Array[String]


func before_each() -> void:
	_bus = EventBus.new()
	_log = []


func _recorder(tag: String) -> Callable:
	return func(e: DomainEvent) -> void:
		_log.append("%s:%s" % [tag, _label_of(e)])


func _label_of(e: DomainEvent) -> String:
	if e is FakePingEvent:
		return (e as FakePingEvent).label
	return (e as FakePongEvent).label


func test_delivers_to_subscriber_of_that_type() -> void:
	_bus.subscribe(FakePingEvent, _recorder("a"))
	_bus.publish(FakePingEvent.new("1"))
	assert_eq(_log, ["a:1"])


func test_does_not_deliver_other_types() -> void:
	_bus.subscribe(FakePongEvent, _recorder("pong"))
	_bus.publish(FakePingEvent.new("1"))
	assert_eq(_log, [])


func test_handlers_run_in_subscription_order() -> void:
	_bus.subscribe(FakePingEvent, _recorder("a"))
	_bus.subscribe(FakePingEvent, _recorder("b"))
	_bus.publish(FakePingEvent.new("1"))
	assert_eq(_log, ["a:1", "b:1"])


func test_publish_all_keeps_order() -> void:
	_bus.subscribe(FakePingEvent, _recorder("ping"))
	_bus.subscribe(FakePongEvent, _recorder("pong"))
	var events: Array[DomainEvent] = [FakePingEvent.new("1"), FakePongEvent.new("2"), FakePingEvent.new("3")]
	_bus.publish_all(events)
	assert_eq(_log, ["ping:1", "pong:2", "ping:3"])


func test_dispose_unsubscribes() -> void:
	var sub := _bus.subscribe(FakePingEvent, _recorder("a"))
	sub.dispose()
	_bus.publish(FakePingEvent.new("1"))
	assert_eq(_log, [])
	assert_false(sub.is_active())
	assert_eq(_bus.subscriber_count(FakePingEvent), 0)


func test_dispose_twice_is_harmless() -> void:
	var sub := _bus.subscribe(FakePingEvent, _recorder("a"))
	sub.dispose()
	sub.dispose()
	assert_eq(_bus.subscriber_count(FakePingEvent), 0)


func test_events_published_by_handlers_are_queued_fifo() -> void:
	# Nested publish must wait until every handler of the current event has run.
	_bus.subscribe(FakePingEvent, func(e: DomainEvent) -> void:
		_log.append("first:" + _label_of(e))
		_bus.publish(FakePongEvent.new("from_" + _label_of(e))))
	_bus.subscribe(FakePingEvent, _recorder("second"))
	_bus.subscribe(FakePongEvent, _recorder("pong"))
	_bus.publish(FakePingEvent.new("1"))
	assert_eq(_log, ["first:1", "second:1", "pong:from_1"])


func test_handler_disposing_a_later_handler_skips_it() -> void:
	var holder: Array[BusSubscription] = []
	_bus.subscribe(FakePingEvent, func(_e: DomainEvent) -> void: holder[0].dispose())
	holder.append(_bus.subscribe(FakePingEvent, _recorder("late")))
	_bus.publish(FakePingEvent.new("1"))
	assert_eq(_log, [])


func test_subscribing_during_delivery_takes_effect_next_event() -> void:
	_bus.subscribe(FakePingEvent, func(_e: DomainEvent) -> void:
		if _bus.subscriber_count(FakePingEvent) == 1:
			_bus.subscribe(FakePingEvent, _recorder("new")))
	_bus.publish(FakePingEvent.new("1"))
	assert_eq(_log, [])
	_bus.publish(FakePingEvent.new("2"))
	assert_eq(_log, ["new:2"])


func test_skips_handlers_whose_object_was_freed() -> void:
	var node := Node.new()
	_bus.subscribe(FakePingEvent, node.queue_free)
	node.free()
	_bus.subscribe(FakePingEvent, _recorder("alive"))
	_bus.publish(FakePingEvent.new("1"))
	assert_eq(_log, ["alive:1"])
	assert_eq(_bus.subscriber_count(FakePingEvent), 1)


func test_delivery_cap_stops_cycles_and_bus_recovers() -> void:
	_bus.subscribe(FakePingEvent, func(_e: DomainEvent) -> void: _bus.publish(FakePingEvent.new("again")))
	_bus.publish(FakePingEvent.new("1"))
	assert_engine_error("delivery cap")
	assert_eq(_bus.delivery_cap(), 1000)
	_bus.subscribe(FakePongEvent, _recorder("ok"))
	_bus.publish(FakePongEvent.new("after"))
	assert_has(_log, "ok:after", "bus still delivers after hitting the cap")
