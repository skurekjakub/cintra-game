## What using a consumable does: its effects and how long using it takes
## (gdd.md §6.9 consumables; content-format.md items and §E effects;
## architecture.md §4.12). Plain vars, immutable by convention: only parsers and
## tests assign them after construction.
class_name ItemConsumablePayload
extends RefCounted

var effects: Array[EffectSpec] = []
var use_time: float = 0.0
