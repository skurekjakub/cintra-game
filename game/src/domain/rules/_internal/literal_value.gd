## A constant side of a comparison: an int, a tier word such as &"friendly", or a bare enum
## word such as &"audience" (content-format.md §C "value").
class_name LiteralValue
extends ConditionValue

var _value: Variant
var _type: StringName


func _init(value: Variant, type: StringName) -> void:
	assert(type in [VALUE_INT, VALUE_TIER, VALUE_WORD], "unknown value type: %s" % type)
	if type == VALUE_INT:
		assert(typeof(value) == TYPE_INT, "an int literal must hold an int")
	else:
		assert(typeof(value) == TYPE_STRING_NAME, "a tier or word literal must hold a StringName")
	assert(type != VALUE_TIER or RepTiers.ORDER.has(value), "not a reputation tier: %s" % value)
	_value = value
	_type = type


func resolve(_facts: FactProvider) -> Variant:
	return _value


func value_type() -> StringName:
	return _type


func referenced_ids() -> Array[StringName]:
	return []
