## Test fake: a FactProvider whose facts tests set directly through public fields
## (architecture.md §4.2, §9.3). Missing keys fall back to neutral defaults.
## The reputation score map is `reputations`, because `reputation(id)` is the method.
class_name FakeFactProvider
extends FactProvider

var flags: Dictionary[StringName, bool] = {}
var milestones: Dictionary[StringName, bool] = {}
var clues: Dictionary[StringName, bool] = {}
var deductions: Dictionary[StringName, bool] = {}
var party: Dictionary[StringName, bool] = {}
var perks: Dictionary[StringName, bool] = {}
var visited_zones: Dictionary[StringName, bool] = {}
var rumors: Dictionary[StringName, bool] = {}
var equipped_items: Dictionary[StringName, bool] = {}
var unlocked_maps: Dictionary[StringName, bool] = {}
var pinned_maps: Dictionary[StringName, bool] = {}
## rumor id -> the npc ids it was heard from.
var heard_sources: Dictionary[StringName, Array] = {}

var vars: Dictionary[StringName, int] = {}
var items: Dictionary[StringName, int] = {}
var attributes: Dictionary[StringName, int] = {}
var check_totals: Dictionary[StringName, int] = {}
var reputations: Dictionary[StringName, int] = {}

var quest_statuses: Dictionary[StringName, StringName] = {}
var quest_stages: Dictionary[StringName, StringName] = {}
var rep_tiers: Dictionary[StringName, StringName] = {}
var finale: Dictionary[StringName, StringName] = {}

var stage: int = 0
var act_value: int = 1
var crowns_value: int = 0
var level_value: int = 1
var queen_value: int = 0
var disguised_value: bool = false


func has_flag(id: StringName) -> bool:
	return flags.get(id, false)


func get_var(id: StringName) -> int:
	return vars.get(id, 0)


func has_milestone(id: StringName) -> bool:
	return milestones.get(id, false)


func item_count(id: StringName) -> int:
	return items.get(id, 0)


func has_clue(id: StringName) -> bool:
	return clues.get(id, false)


func has_deduction(id: StringName) -> bool:
	return deductions.get(id, false)


func quest_status(id: StringName) -> StringName:
	return quest_statuses.get(id, QUEST_INACTIVE)


func quest_stage(id: StringName) -> StringName:
	return quest_stages.get(id, &"")


func attribute(attr: StringName) -> int:
	return attributes.get(attr, 3)


func check_total(skill: StringName) -> int:
	return check_totals.get(skill, 0)


func reputation(id: StringName) -> int:
	return reputations.get(id, 0)


func rep_tier(id: StringName) -> StringName:
	return rep_tiers.get(id, &"neutral")


func escalation_stage() -> int:
	return stage


func act() -> int:
	return act_value


func in_party(id: StringName) -> bool:
	return party.get(id, false)


func has_perk(id: StringName) -> bool:
	return perks.get(id, false)


func crowns() -> int:
	return crowns_value


func level() -> int:
	return level_value


func finale_value(key: StringName) -> StringName:
	return finale.get(key, _finale_default(key))


func visited(zone_id: StringName) -> bool:
	return visited_zones.get(zone_id, false)


func rumor_heard(rumor_id: StringName) -> bool:
	return rumors.get(rumor_id, false)


func queen_condition() -> int:
	return queen_value


func is_equipped(item_id: StringName) -> bool:
	return equipped_items.get(item_id, false)


func is_disguised() -> bool:
	return disguised_value


func heard_from(rumor_id: StringName, npc_id: StringName) -> bool:
	var sources: Array = heard_sources.get(rumor_id, [])
	return sources.has(npc_id)


func map_unlocked(map_id: StringName) -> bool:
	return unlocked_maps.get(map_id, false)


func map_pinned(map_id: StringName) -> bool:
	return pinned_maps.get(map_id, false)


func _finale_default(key: StringName) -> StringName:
	match key:
		FINALE_SEIZED:
			return &"false"
		FINALE_OATH:
			return &"none"
		FINALE_ANSELM:
			return &"alive"
	return &""
