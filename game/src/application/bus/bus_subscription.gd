## A handle returned by EventBus.subscribe. dispose() unsubscribes; presentation
## nodes dispose in _exit_tree() (architecture.md §3.2). The bus prunes disposed
## subscriptions lazily, so the handle needs no reference back to the bus.
class_name BusSubscription
extends RefCounted

var event_type: Script:
	get:
		return _event_type

var _event_type: Script
var _handler: Callable
var _active: bool = true


func _init(type: Script, handler: Callable) -> void:
	_event_type = type
	_handler = handler


func dispose() -> void:
	_active = false


## False once disposed, or once the handler's object has been freed.
func is_active() -> bool:
	return _active and _handler.is_valid()


func deliver(event: DomainEvent) -> void:
	if is_active():
		_handler.call(event)
