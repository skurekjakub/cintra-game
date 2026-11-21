## The names a check may use: the four dialogue skills (gdd.md §6.10) and the five
## attributes (gdd.md §6.6, attribute checks for hazards and dialogue).
class_name CheckSkills
extends RefCounted

const DIALOGUE_SKILLS: Array[StringName] = [&"persuade", &"intimidate", &"investigate", &"lore"]
const ATTRIBUTES: Array[StringName] = [&"might", &"agility", &"grit", &"wits", &"presence"]


static func is_attribute(n: StringName) -> bool:
	return ATTRIBUTES.has(n)


static func is_dialogue_skill(n: StringName) -> bool:
	return DIALOGUE_SKILLS.has(n)


## True for a dialogue skill or an attribute.
static func is_check_skill(n: StringName) -> bool:
	return is_dialogue_skill(n) or is_attribute(n)
