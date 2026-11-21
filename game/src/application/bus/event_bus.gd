## Typed mediator keyed by event class (the Script), not by strings (architecture.md §3.2).
## Delivery is synchronous and FIFO. Events published while handlers run are queued
## and delivered after the current event; one publish call drains the whole queue.
## Handlers receive events of exactly the subscribed class (no base-class fan-out).
class_name EventBus
extends RefCounted

const DELIVERY_CAP: int = 1000

var _subscriptions: Dictionary[Script, Array] = {}
var _queue: Array[DomainEvent] = []
var _draining: bool = false


func subscribe(event_type: Script, handler: Callable) -> BusSubscription:
	assert(event_type != null, "EventBus.subscribe needs an event class")
	var sub := BusSubscription.new(event_type, handler)
	if not _subscriptions.has(event_type):
		_subscriptions[event_type] = []
	_subscriptions[event_type].append(sub)
	return sub


func publish(event: DomainEvent) -> void:
	assert(event != null, "EventBus.publish needs an event")
	_queue.append(event)
	if not _draining:
		_drain()


func publish_all(events: Array[DomainEvent]) -> void:
	for event: DomainEvent in events:
		publish(event)


## Number of active subscriptions for an event class.
func subscriber_count(event_type: Script) -> int:
	return _active_subscriptions(event_type).size()


func delivery_cap() -> int:
	return DELIVERY_CAP


func _drain() -> void:
	_draining = true
	var deliveries := 0
	var next := 0
	while next < _queue.size():
		var event := _queue[next]
		next += 1
		# Snapshot first: subscriptions added during delivery start with the next event.
		for sub: BusSubscription in _active_subscriptions(event.get_script() as Script):
			if deliveries >= DELIVERY_CAP:
				_reset_queue()
				assert(false, "EventBus delivery cap (%d) reached: an event cycle?" % DELIVERY_CAP)
				return
			deliveries += 1
			sub.deliver(event)
	_reset_queue()


func _reset_queue() -> void:
	_queue.clear()
	_draining = false


## Returns the active subscriptions for a class and prunes the disposed ones.
func _active_subscriptions(event_type: Script) -> Array[BusSubscription]:
	var active: Array[BusSubscription] = []
	if not _subscriptions.has(event_type):
		return active
	for sub: BusSubscription in _subscriptions[event_type]:
		if sub.is_active():
			active.append(sub)
	_subscriptions[event_type] = active.duplicate()
	return active
