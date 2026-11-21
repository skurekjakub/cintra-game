## One faction: its name, starting reputation and the lower bound of each tier
## (gdd.md §6.12; architecture.md §4.5). Immutable by convention: only parsers and
## tests assign `thresholds`, right after construction.
class_name FactionDefinition
extends RefCounted

var id: StringName
var display_name: String
var start: int
## Lower bound of each tier above hostile. A score below `wary` is hostile.
var thresholds: Dictionary[StringName, int] = {&"wary": -49, &"neutral": -9, &"friendly": 10, &"allied": 50}


func _init(faction_id: StringName, title: String, start_value: int = 0) -> void:
	id = faction_id
	display_name = title
	start = start_value


## The highest tier whose lower bound `value` reaches, else the lowest tier (hostile).
func tier_for(value: int) -> StringName:
	for rank: int in range(RepTiers.ORDER.size() - 1, 0, -1):
		var tier: StringName = RepTiers.ORDER[rank]
		if thresholds.has(tier):
			var lower_bound: int = thresholds[tier]
			if value >= lower_bound:
				return tier
	return RepTiers.ORDER[0]
