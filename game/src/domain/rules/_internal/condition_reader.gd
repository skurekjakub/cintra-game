## ConditionReader: recursive-descent reader that turns the tokens of a content condition into a
## Condition tree (content-format.md §C grammar; architecture.md §3.4). Every rule returns a Result,
## and the first error stops the read.
##   or      := and ( "or" and )*
##   and     := unary ( "and" unary )*
##   unary   := "not" unary | atom
##   atom    := "(" or ")" | "true" | "false" | bool_call | compare
##   compare := value OP value        value := INT | value_call | WORD
## `true`/`false` are a literal only when no operator follows; otherwise they are compare words
## (`finale_oath() == true`). The keywords and/or/not are recognised before the call rule, so
## `not(` and `and(` are never calls. Errors: condition_syntax, unknown_call, bad_arg_count,
## bad_arg, bad_call_use and bad_compare; each detail names the offending text. The type rules of a
## compare (a call on one side, closed word sets, tiers) live in CompareChecker.
class_name ConditionReader
extends RefCounted

const _KEYWORDS: Array[String] = ["and", "or", "not"]
const _BOOL_WORDS: Array[String] = ["true", "false"]
const _EQUALITY_OPS: Array[String] = ["==", "!="]

var _text: String
var _tokens: Array[ConditionToken]
var _i: int = 0


## `source` is the condition text and `tokens` its ConditionLexer tokens (ending with &"end").
func _init(source: String, tokens: Array[ConditionToken]) -> void:
	_text = source
	_tokens = tokens


## ok(Condition) when the tokens form exactly one condition, else the first error.
func read_all() -> Result:
	var r := _read_or()
	if r.is_ok() and _peek().kind != &"end":
		return _syntax("'and', 'or' or the end of the condition")
	return r


func _read_or() -> Result:
	return _read_joined("or", _read_and)


func _read_and() -> Result:
	return _read_joined("and", _read_unary)


## operand (keyword operand)*, as an OrCondition or AndCondition (a lone operand is returned as is).
func _read_joined(keyword: String, read_operand: Callable) -> Result:
	var items: Array[Condition] = []
	var more := true
	while more:
		var r: Result = read_operand.call()
		if r.is_err():
			return r
		var item: Condition = r.value
		items.append(item)
		more = _take_word(keyword)
	if items.size() == 1:
		return Result.ok(items[0])
	if keyword == "or":
		return Result.ok(OrCondition.new(items))
	return Result.ok(AndCondition.new(items))


func _read_unary() -> Result:
	if not _take_word("not"):
		return _read_atom()
	var r := _read_unary()
	if r.is_err():
		return r
	var child: Condition = r.value
	return Result.ok(NotCondition.new(child))


func _read_atom() -> Result:
	var t := _peek()
	if t.kind == &"lparen":
		return _read_group()
	if t.kind == &"word" and _BOOL_WORDS.has(t.text) and _peek(1).kind != &"op":
		_advance()
		return Result.ok(LiteralCondition.new(t.text == "true"))
	var at := _i
	var r := _read_operand("a condition")
	if r.is_err():
		return r
	var first: Variant = r.value
	var has_op := _peek().kind == &"op"
	if first is Condition:
		return _bad_use(at, "a boolean call cannot be compared") if has_op else r
	var left: ConditionValue = first
	if has_op:
		return _read_compare(left, at)
	if left is CallValue:
		return _bad_use(at, "a value call must be compared with a value")
	return _syntax("a comparison operator")


func _read_group() -> Result:
	_advance()
	var r := _read_or()
	if r.is_err():
		return r
	if not _take(&"rparen"):
		return _syntax("')'")
	return r


## The comparison whose left side is `left` (read from token `left_at`); the next token is the operator.
func _read_compare(left: ConditionValue, left_at: int) -> Result:
	var op_name := _advance().text
	var right_at := _i
	var r := _read_operand("a value")
	if r.is_err():
		return r
	var second: Variant = r.value
	if second is Condition:
		return _bad_use(right_at, "a boolean call cannot be compared")
	var right: ConditionValue = second
	var fit := CompareChecker.fit(left, _tokens[left_at].text, right, _tokens[right_at].text)
	if fit.is_err():
		return _bad_compare(left_at, fit.detail)
	var pair: Array[ConditionValue] = fit.value
	if pair[0].value_type() == ConditionValue.VALUE_WORD and not _EQUALITY_OPS.has(op_name):
		return _bad_compare(left_at, "words compare with == or != only")
	return Result.ok(CompareCondition.new(pair[0], StringName(op_name), pair[1]))


## One side of a comparison, or a boolean call used as a whole atom. ok(ConditionValue) for an
## INT, a bare WORD or a value call, ok(CallCondition) for a boolean call. `expected` words the
## syntax error.
func _read_operand(expected: String) -> Result:
	var t := _peek()
	if t.kind == &"int":
		return _read_int()
	if t.kind != &"word" or _KEYWORDS.has(t.text):
		return _syntax(expected)
	if _peek(1).kind == &"lparen":
		return _read_call()
	_advance()
	return Result.ok(LiteralValue.new(StringName(t.text), ConditionValue.VALUE_WORD))


func _read_int() -> Result:
	var r := ArgSpec.parse("int").convert(_advance().text)
	if r.is_err():
		return r
	var n: int = r.value
	return Result.ok(LiteralValue.new(n, ConditionValue.VALUE_INT))


## name "(" [arg ("," arg)*] ")": ok(CallCondition) for a boolean call, else ok(CallValue).
func _read_call() -> Result:
	var name_token := _advance()
	var call_name := StringName(name_token.text)
	var result_type := ConditionCalls.returns(call_name)
	if result_type == &"":
		return Result.err(&"unknown_call", "unknown call '%s' at pos %d" % [call_name, name_token.pos])
	var arg_read := _read_arg_texts()
	if arg_read.is_err():
		return arg_read
	var arg_texts: PackedStringArray = arg_read.value
	var specs := ConditionCalls.params(call_name)
	var bound := ArgSpec.bind(specs, arg_texts)
	if bound.is_err():
		return Result.err(bound.error_code, "%s(): %s" % [call_name, bound.detail])
	var args: Array = bound.value
	var ids := ArgSpec.ids_in(specs, args)
	if result_type == ConditionCalls.BOOL:
		return Result.ok(CallCondition.new(call_name, args, ids))
	return Result.ok(CallValue.new(call_name, args, ids, result_type))


## "(" [arg ("," arg)*] ")": ok(PackedStringArray of the argument texts). An argument is one id, word or int.
func _read_arg_texts() -> Result:
	_advance()
	var texts := PackedStringArray()
	if _take(&"rparen"):
		return Result.ok(texts)
	var more := true
	while more:
		if _peek().kind != &"word" and _peek().kind != &"int":
			return _syntax("an argument")
		texts.append(_advance().text)
		more = _take(&"comma")
	if not _take(&"rparen"):
		return _syntax("',' or ')'")
	return Result.ok(texts)


## The token `ahead` places after the current one; the &"end" token repeats.
func _peek(ahead: int = 0) -> ConditionToken:
	return _tokens[mini(_i + ahead, _tokens.size() - 1)]


## Consumes and returns the current token. The &"end" token is never consumed.
func _advance() -> ConditionToken:
	var t := _tokens[_i]
	if t.kind != &"end":
		_i += 1
	return t


func _take(kind: StringName) -> bool:
	if _peek().kind != kind:
		return false
	_advance()
	return true


func _take_word(word: String) -> bool:
	var t := _peek()
	if t.kind != &"word" or t.text != word:
		return false
	_advance()
	return true


## The condition text from token `from` up to the next unread token.
func _span(from: int) -> String:
	var start := _tokens[from].pos
	return _text.substr(start, _tokens[_i].pos - start).strip_edges()


func _syntax(expected: String) -> Result:
	var t := _peek()
	var found := "the end of the condition" if t.kind == &"end" else "'%s'" % t.text
	return Result.err(&"condition_syntax", "pos %d: expected %s, found %s" % [t.pos, expected, found])


func _bad_use(from: int, reason: String) -> Result:
	return Result.err(&"bad_call_use", "'%s': %s" % [_span(from), reason])


func _bad_compare(from: int, reason: String) -> Result:
	return Result.err(&"bad_compare", "'%s': %s" % [_span(from), reason])
