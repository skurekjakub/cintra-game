## Test helper: the effect signatures of content-format.md §E, exactly the 35 ops of the spec
## (architecture.md §3.4). The real registry is composed in P3 from the effect handlers; its
## composer test asserts that it holds every op here with the same specs, plus the later ops.
## One `register` line per op. Optional params come last and only the last param may be
## variadic (ArgSpec.bind asserts it).
class_name ContentFormatEffects
extends RefCounted


static func signatures() -> EffectSignatures:
	var registry := EffectSignatures.new()
	_world_state(registry)
	_items_crowns_rep_xp(registry)
	_quests_dialogue_zones_map(registry)
	_party_rumors_player_misc(registry)
	return registry


static func _world_state(registry: EffectSignatures) -> void:
	registry.register(EffectSignature.of(&"set_flag", ["id:flag"]))
	registry.register(EffectSignature.of(&"clear_flag", ["id:flag"]))
	registry.register(EffectSignature.of(&"set_var", ["id:var", "int"]))
	registry.register(EffectSignature.of(&"add_var", ["id:var", "int"]))
	registry.register(EffectSignature.of(&"reach_milestone", ["id:ms"]))
	registry.register(EffectSignature.of(&"set_act", ["int:1..3"]))


static func _items_crowns_rep_xp(registry: EffectSignatures) -> void:
	registry.register(EffectSignature.of(&"give_item", ["id:item", "int=1"]))
	registry.register(EffectSignature.of(&"take_item", ["id:item", "int=1"]))
	registry.register(EffectSignature.of(&"add_crowns", ["int"]))
	registry.register(EffectSignature.of(&"add_rep", ["id:faction", "int"]))
	registry.register(EffectSignature.of(&"add_xp", ["int"]))


static func _quests_dialogue_zones_map(registry: EffectSignatures) -> void:
	registry.register(EffectSignature.of(&"add_clue", ["id:clue"]))
	registry.register(EffectSignature.of(&"start_quest", ["id:quest"]))
	registry.register(EffectSignature.of(&"fail_quest", ["id:quest"]))
	registry.register(EffectSignature.of(&"complete_objective", ["id:quest", "local"]))
	registry.register(EffectSignature.of(&"start_dialogue", ["id:dlg"]))
	registry.register(EffectSignature.of(&"start_encounter", ["id:enc"]))
	registry.register(EffectSignature.of(&"goto_zone", ["id:zone", "local"]))
	registry.register(EffectSignature.of(&"unlock_map_node", ["id:map"]))
	registry.register(EffectSignature.of(&"add_map_pin", ["id:map"]))


static func _party_rumors_player_misc(registry: EffectSignatures) -> void:
	registry.register(EffectSignature.of(&"recruit", ["id:companion"]))
	registry.register(EffectSignature.of(&"dismiss", ["id:companion"]))
	registry.register(EffectSignature.of(&"add_ally", ["id:ally"]))
	registry.register(EffectSignature.of(&"remove_ally", ["id:ally"]))
	registry.register(EffectSignature.of(&"add_rumor", ["id:rumor"]))
	registry.register(EffectSignature.of(&"verify_rumor", ["id:rumor"]))
	registry.register(EffectSignature.of(&"heal_player", ["int|word:full"]))
	registry.register(EffectSignature.of(&"damage_player", ["int"]))
	registry.register(EffectSignature.of(&"apply_status", ["word:poison|burning|bleed|chill", "int"]))
	registry.register(EffectSignature.of(&"play_beat", ["local"]))
	registry.register(EffectSignature.of(&"set_checkpoint", ["local"]))
	registry.register(EffectSignature.of(&"open_shop", ["id:npc"]))
	registry.register(EffectSignature.of(&"administer_antidote", ["word:queen|maelis"]))
	registry.register(EffectSignature.of(&"send_antidote_rider", []))
	registry.register(EffectSignature.of(&"game_over", ["local"]))
