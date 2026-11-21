## CompareChecker: the type rules of a comparison `value OP value` (content-format.md §C compare,
## §J.1; architecture.md §3.4). ConditionReader calls it once both sides are read. The rules:
##   - at least one side is a call (`finale_oath == true` forgot its parentheses, and two
##     literals never change);
##   - a bare word next to a tier becomes a tier literal and must be a reputation tier;
##   - both sides end up with the same value type;
##   - a bare word next to a call with a closed word set (ConditionCalls.words) is one of those words.
## Every failure is err(&"bad_compare") whose detail is the reason; the reader adds the compare's span.
## `left_text` and `right_text` are the first token of each side: the call name of a call, the word of a bare word.
class_name CompareChecker
extends RefCounted


## ok([left, right]) with bare tier words turned into tier literals, or err(&"bad_compare").
static func fit(left: ConditionValue, left_text: String, right: ConditionValue, right_text: String) -> Result:
	if not (left is CallValue or right is CallValue):
		return _bad("a comparison needs a call on at least one side (is a '()' missing?)")
	var l := _bare_word_as_tier(left, left_text, right)
	var r := _bare_word_as_tier(right, right_text, left)
	if l.is_err() or r.is_err():
		return l if l.is_err() else r
	var left_fit: ConditionValue = l.value
	var right_fit: ConditionValue = r.value
	if left_fit.value_type() != right_fit.value_type():
		return _bad("cannot compare %s with %s" % [left_fit.value_type(), right_fit.value_type()])
	var outside := _outside_closed_set(left_fit, left_text, right_fit, right_text)
	if not outside.is_empty():
		return _bad(outside)
	var pair: Array[ConditionValue] = [left_fit, right_fit]
	return Result.ok(pair)


static func _bare_word_as_tier(value: ConditionValue, text: String, other: ConditionValue) -> Result:
	if not _is_bare_word(value) or other.value_type() != ConditionValue.VALUE_TIER:
		return Result.ok(value)
	var word := StringName(text)
	if not RepTiers.is_tier(word):
		return _bad("'%s' is not a reputation tier" % word)
	return Result.ok(LiteralValue.new(word, ConditionValue.VALUE_TIER))


## The reason a bare word beside a closed-word call is not allowed, or "" when the pair is fine.
static func _outside_closed_set(left: ConditionValue, left_text: String,
		right: ConditionValue, right_text: String) -> String:
	var reason := _word_reason(left, left_text, right, right_text)
	return reason if not reason.is_empty() else _word_reason(right, right_text, left, left_text)


static func _word_reason(call_side: ConditionValue, call_text: String,
		other: ConditionValue, other_text: String) -> String:
	if not (call_side is CallValue and _is_bare_word(other)):
		return ""
	var allowed := ConditionCalls.words(StringName(call_text))
	if allowed.is_empty() or allowed.has(StringName(other_text)):
		return ""
	return "'%s' is not one of %s() words (%s)" % [other_text, call_text, " | ".join(allowed)]


static func _is_bare_word(value: ConditionValue) -> bool:
	return value is LiteralValue and value.value_type() == ConditionValue.VALUE_WORD


static func _bad(reason: String) -> Result:
	return Result.err(&"bad_compare", reason)
