## One side of a comparison in a condition: a literal or a numeric/enum call
## (content-format.md §C "value", architecture.md §3.4).
## value_type() is one of VALUE_INT, VALUE_TIER or VALUE_WORD. The names avoid TYPE_*,
## which would shadow the global Variant.Type constants inside this class and its subclasses.
@abstract
class_name ConditionValue
extends RefCounted

const VALUE_INT: StringName = &"int"
const VALUE_TIER: StringName = &"tier"
const VALUE_WORD: StringName = &"word"


## The value against `facts`: an int for VALUE_INT, a StringName for VALUE_TIER and VALUE_WORD.
@abstract func resolve(facts: FactProvider) -> Variant


@abstract func value_type() -> StringName


## Every content id the value names, in first-seen order, without duplicates.
@abstract func referenced_ids() -> Array[StringName]
