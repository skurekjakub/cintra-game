## Published by a use case after it changed any fact a condition may read (architecture.md §3.2).
## The source names the use case, for logs and for tests that tell causes apart.
class_name FactsChanged
extends DomainEvent

var source: StringName


func _init(event_source: StringName = &"") -> void:
	source = event_source
