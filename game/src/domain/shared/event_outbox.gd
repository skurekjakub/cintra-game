## Where an aggregate records its domain events until a use case drains and
## publishes them. Domain objects never publish themselves (architecture.md §3.1).
class_name EventOutbox
extends RefCounted

var _events: Array[DomainEvent] = []


func record(event: DomainEvent) -> void:
	_events.append(event)


## Returns the recorded events in order and leaves the outbox empty.
func drain() -> Array[DomainEvent]:
	var drained: Array[DomainEvent] = _events
	_events = []
	return drained


func is_empty() -> bool:
	return _events.is_empty()
