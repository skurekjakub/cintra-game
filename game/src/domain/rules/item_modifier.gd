## One item modifier: a `{mod, value, vs_faction}` entry of an item's `mods` list
## (content-format.md §J.6 items; gdd.md §6.10 check rules; architecture.md §4.2,
## §4.11, §4.12). It lives in `rules` because both `inventory` (which holds it on an
## ItemDefinition) and `actors` (CheckTotals) read it, and they may not reference
## each other. An immutable value: build it with `create`, which validates it.
## `vs_faction` is `&""` when the mod applies to everyone; otherwise it names the
## faction of the speaker it applies to (the application layer resolves that).
class_name ItemModifier
extends RefCounted

## Exactly the mod names of content-format.md §J.6.
const MODS: Array[StringName] = [
	&"check_persuade", &"check_intimidate", &"check_investigate", &"check_lore", &"check_all",
	&"bleed_buildup_pct", &"chill_rate_pct", &"armor", &"max_hp", &"stamina_regen_pct",
]

var mod: StringName:
	get:
		return _mod
var value: int:
	get:
		return _value
var vs_faction: StringName:
	get:
		return _vs_faction

var _mod: StringName = &""
var _value: int = 0
var _vs_faction: StringName = &""


## Err `unknown_mod` when `mod_name` is not in MODS, `bad_arg` when `faction` is
## neither `&""` nor a `faction.` id. Any int is a valid `amount`.
static func create(mod_name: StringName, amount: int, faction: StringName = &"") -> Result:
	if not MODS.has(mod_name):
		return Result.err(&"unknown_mod", String(mod_name))
	if faction != &"" and not IdRules.is_valid(faction, &"faction"):
		return Result.err(&"bad_arg", "vs_faction: %s" % faction)
	var made := ItemModifier.new()
	made._mod = mod_name
	made._value = amount
	made._vs_faction = faction
	return Result.ok(made)
