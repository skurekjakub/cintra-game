## The ordered reputation tier names, lowest to highest (gdd.md §6.12, content-format.md §C).
## The numeric ranges that map a score to a tier belong to the factions domain.
class_name RepTiers
extends RefCounted

const ORDER: Array[StringName] = [&"hostile", &"wary", &"neutral", &"friendly", &"allied"]


## Position of `tier` in ORDER (hostile = 0 … allied = 4), or -1 if it is not a tier.
static func rank(tier: StringName) -> int:
	return ORDER.find(tier)


static func is_tier(word: StringName) -> bool:
	return ORDER.has(word)
