## Recorded when a reputation change moves a faction into a different tier
## (architecture.md §4.5; gdd.md §6.12). Follows the ReputationChanged it belongs to.
class_name ReputationTierChanged
extends DomainEvent

var id: StringName
var old_tier: StringName
var new_tier: StringName


func _init(faction_id: StringName, before: StringName, after: StringName) -> void:
	id = faction_id
	old_tier = before
	new_tier = after
