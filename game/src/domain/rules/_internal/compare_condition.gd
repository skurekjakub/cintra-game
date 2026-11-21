## `value OP value` with OP one of == != < <= > >= (content-format.md §C compare).
## A tier on either side compares by RepTiers.rank. Two ints compare numerically. Two words
## compare with == or != only; the parser guarantees that.
class_name CompareCondition
extends Condition

var _left: ConditionValue
var _op: StringName
var _right: ConditionValue


func _init(left: ConditionValue, op: StringName, right: ConditionValue) -> void:
	_left = left
	_op = op
	_right = right


func evaluate(facts: FactProvider) -> bool:
	if _is_tier(_left) or _is_tier(_right):
		return _compare(_rank(_left, facts), _rank(_right, facts))
	if _left.value_type() == ConditionValue.VALUE_INT:
		return _compare(_int(_left, facts), _int(_right, facts))
	return _words_equal(_word(_left, facts), _word(_right, facts))


func referenced_ids() -> Array[StringName]:
	var out: Array[StringName] = []
	_merge_ids(out, _left.referenced_ids())
	_merge_ids(out, _right.referenced_ids())
	return out


func _compare(a: int, b: int) -> bool:
	match _op:
		&"==":
			return a == b
		&"!=":
			return a != b
		&"<":
			return a < b
		&"<=":
			return a <= b
		&">":
			return a > b
		&">=":
			return a >= b
	assert(false, "unknown comparison operator: %s" % _op)
	return false


func _words_equal(a: StringName, b: StringName) -> bool:
	assert(_op == &"==" or _op == &"!=", "words compare with == or != only, not %s" % _op)
	return (a == b) == (_op == &"==")


func _is_tier(value: ConditionValue) -> bool:
	return value.value_type() == ConditionValue.VALUE_TIER


func _rank(value: ConditionValue, facts: FactProvider) -> int:
	return RepTiers.rank(_word(value, facts))


func _int(value: ConditionValue, facts: FactProvider) -> int:
	var resolved: int = value.resolve(facts)
	return resolved


func _word(value: ConditionValue, facts: FactProvider) -> StringName:
	var resolved: StringName = value.resolve(facts)
	return resolved
