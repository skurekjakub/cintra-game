## What using a consumable does: its effects, how long using it takes and whether it
## may sit in a quick slot (gdd.md §6.4 quick items, §6.9 consumables;
## content-format.md items, §E effects and §J.6; architecture.md §4.12). Plain vars,
## immutable by convention: only parsers and tests assign them after construction.
class_name ItemConsumablePayload
extends RefCounted

var effects: Array[EffectSpec] = []
var use_time: float = 0.0
## False for a consumable that is only used through an interactable (§J.6).
var quick_slot: bool = true
