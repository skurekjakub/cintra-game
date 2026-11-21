## Test helper event.
class_name FakePongEvent
extends DomainEvent

var label: String


func _init(event_label: String = "") -> void:
	label = event_label
