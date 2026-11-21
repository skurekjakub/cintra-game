## The total behind a dialogue or attribute check: the attribute (or attributes)
## it rests on, its +1 Tongue perk and the item modifiers that apply to everyone
## (gdd.md §6.10 check rules, §6.8 Tongue perks; content-format.md §J.1 attribute
## checks, §J.6 item mods; architecture.md §4.11). The reputation modifier is not
## included, CheckResolver adds it.
##
## Item mods count when they have no `vs_faction`: `check_all` (dialogue and
## attribute checks alike) and `check_<skill>` for the four dialogue skills. A mod
## with a `vs_faction` (the Kosk badge) depends on the speaker, and so does Lore +2
## with Maelis in the party. Those belong to the application layer
## (SessionFactProvider and CheckResolver), not here.
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
## attribute. `perks` holds the perk ids the player owns. `mods` are the equipped
## items' modifiers (`Equipment.equipped_mods()`); mods that do not apply are ignored.
static func compute(
	skill: StringName, sheet: ActorSheet, perks: Array[StringName], mods: Array[ItemModifier]
) -> int:
	assert(CheckSkills.is_check_skill(skill), "unknown check skill")
	return _base(skill, sheet) + _perk_bonus(skill, perks) + _item_bonus(skill, mods)


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


static func _item_bonus(skill: StringName, mods: Array[ItemModifier]) -> int:
	var total := 0
	for m: ItemModifier in mods:
		if m.vs_faction == &"" and _applies(m.mod, skill):
			total += m.value
	return total


static func _applies(mod_name: StringName, skill: StringName) -> bool:
	if mod_name == &"check_all":
		return true
	return CheckSkills.is_dialogue_skill(skill) and mod_name == StringName("check_" + skill)
