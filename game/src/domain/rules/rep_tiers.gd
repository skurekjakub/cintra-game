## The ordered reputation tier names, lowest to highest (gdd.md §6.12, content-format.md §C) and the
## rep_mod each adds to social checks (gdd.md §6.10). The numeric ranges that map a score to a tier
## belong to the factions domain.
class_name RepTiers
extends RefCounted

const ORDER: Array[StringName] = [&"hostile", &"wary", &"neutral", &"friendly", &"allied"]
## Hostile -2, Wary -1, Neutral 0, Friendly +1, Allied +2 (gdd.md §6.10).
const _REP_MODS: Dictionary[StringName, int] = {
	&"hostile": -2, &"wary": -1, &"neutral": 0, &"friendly": 1, &"allied": 2,
}


## Position of `tier` in ORDER (hostile = 0 … allied = 4), or -1 if it is not a tier.
static func rank(tier: StringName) -> int:
	return ORDER.find(tier)


static func is_tier(word: StringName) -> bool:
	return ORDER.has(word)


## The rep_mod `tier` adds to social checks (gdd.md §6.10), or 0 when `tier` is not one of ORDER.
static func rep_mod(tier: StringName) -> int:
	return _REP_MODS.get(tier, 0)
