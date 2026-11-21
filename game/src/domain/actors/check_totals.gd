## The total behind a dialogue or attribute check: the attribute (or attributes)
## it rests on plus its +1 Tongue perk (gdd.md §6.10 check rules, §6.8 Tongue
## perks; architecture.md §4.11). The reputation modifier is not included,
## CheckResolver adds it.
##
## The gdd names no unconditional item bonus, so `items` adds nothing today. The
## parameter stays because architecture §4.11 lists it in the signature.
## Modifiers that depend on the speaker or the party (Kosk's writ and the Strept
## badge, Lore +2 with Maelis in the party) are not unconditional either. They
## belong to the application layer (SessionFactProvider and CheckResolver), not here.
class_name CheckTotals
extends RefCounted

## The perk that adds +1 to a check, keyed by the skill it helps (gdd.md §6.8).
## Attribute checks and Lore have no perk.
const PERK_BONUSES: Dictionary[StringName, StringName] = {
	&"persuade": &"perk.silver_tongue",
	&"intimidate": &"perk.hard_stare",
	&"investigate": &"perk.keen_eye",
}
const PERK_BONUS := 1


## `skill` is any name `CheckSkills.is_check_skill` accepts: a dialogue skill or
## an attribute. Persuade rests on Presence, Intimidate on the higher of Might
## and Presence, Investigate and Lore on Wits, and an attribute check on that
## attribute. `perks` holds the perk ids the player owns. `_items` is unused (see
## the header).
static func compute(
	skill: StringName, sheet: ActorSheet, perks: Array[StringName], _items: Array[StringName]
) -> int:
	assert(CheckSkills.is_check_skill(skill), "unknown check skill")
	return _base(skill, sheet) + _perk_bonus(skill, perks)


static func _base(skill: StringName, sheet: ActorSheet) -> int:
	match skill:
		&"persuade":
			return sheet.attribute(&"presence")
		&"intimidate":
			return maxi(sheet.attribute(&"might"), sheet.attribute(&"presence"))
		&"investigate", &"lore":
			return sheet.attribute(&"wits")
	return sheet.attribute(skill)


static func _perk_bonus(skill: StringName, perks: Array[StringName]) -> int:
	if PERK_BONUSES.has(skill) and perks.has(PERK_BONUSES[skill]):
		return PERK_BONUS
	return 0
