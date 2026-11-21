## Recorded when an attribute point is spent (architecture.md §4.4; gdd.md §6.6, §6.8).
class_name AttributeIncreased
extends DomainEvent

var attribute: StringName
var new_value: int


func _init(attribute_name: StringName, value_after: int) -> void:
	attribute = attribute_name
	new_value = value_after
