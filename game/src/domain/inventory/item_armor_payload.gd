## The armor profile of an item: data only (gdd.md §6.9 items; content-format.md
## items; architecture.md §4.12). Plain vars, immutable by convention: only
## parsers and tests assign them after construction.
class_name ItemArmorPayload
extends RefCounted

var armor: int = 0
var resist: Dictionary[StringName, float] = {}
