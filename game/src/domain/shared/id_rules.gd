## Global id rules: `kind.suffix`, lowercase, suffix of [a-z0-9_] (architecture.md §8.2).
class_name IdRules
extends RefCounted

## The id kinds listed in architecture.md §8.2. Add a kind here when the content
## format introduces one.
const KINDS: Array[StringName] = [
	&"item", &"npc", &"zone", &"dlg", &"quest", &"clue", &"ded", &"flag", &"var", &"ms",
	&"enemy", &"enc", &"faction", &"perk", &"rumor", &"map", &"edge", &"esc", &"ending",
	&"companion", &"ally", &"event",
]
const _SUFFIX_CHARS: String = "abcdefghijklmnopqrstuvwxyz0123456789_"


## Returns the kind prefix of an id, or &"" if the id has no dot.
static func kind_of(id: StringName) -> StringName:
	var text := String(id)
	var dot := text.find(".")
	if dot <= 0:
		return &""
	return StringName(text.substr(0, dot))


static func is_known_kind(kind: StringName) -> bool:
	return KINDS.has(kind)


## True if `id` is well formed and of `kind` (or of any known kind when `kind` is empty).
static func is_valid(id: StringName, kind: StringName = &"") -> bool:
	var actual := kind_of(id)
	if not is_known_kind(actual):
		return false
	if kind != &"" and actual != kind:
		return false
	var suffix := String(id).substr(String(actual).length() + 1)
	return _is_valid_suffix(suffix)


static func _is_valid_suffix(suffix: String) -> bool:
	if suffix.is_empty():
		return false
	for c: String in suffix:
		if not _SUFFIX_CHARS.contains(c):
			return false
	return true
