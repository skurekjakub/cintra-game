## The weapon profile of an item: data only, combat reads it (gdd.md §6.9 items;
## content-format.md items; architecture.md §4.12). Plain vars, immutable by
## convention: only parsers and tests assign them after construction.
class_name ItemWeaponPayload
extends RefCounted

var base: int = 0
var damage_type: StringName = &""
var block_pct: float = 0.0
var armor_pen: int = 0
var bonus_vs: Dictionary[StringName, float] = {}
var moveset: StringName = &""
