## Recorded the first time a write-once milestone is reached (architecture.md §4.3; gdd.md §6.1).
class_name MilestoneReached
extends DomainEvent

var id: StringName


func _init(milestone_id: StringName) -> void:
	id = milestone_id
