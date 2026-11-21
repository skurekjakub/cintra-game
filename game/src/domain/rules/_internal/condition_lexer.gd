## ConditionLexer: splits a content condition into tokens (content-format.md §C grammar).
##   word    [a-z0-9_.]+ not starting with a digit (ids, function names, keywords)
##   int     -?[0-9]+    (a "-" counts only when a digit follows)
##   op      == != <= >= < >
##   lparen, rparen, comma    ( ) ,
## Whitespace is skipped. Any other character, or a lone "=" or "!", is err &"condition_syntax"
## with the detail "pos N: '<char>'".
class_name ConditionLexer
extends RefCounted

const _SPACE: String = " \t\r\n"
const _DIGITS: String = "0123456789"
const _WORD_START: String = "abcdefghijklmnopqrstuvwxyz_."
const _WORD_REST: String = "abcdefghijklmnopqrstuvwxyz0123456789_."
const _TWO_CHAR_OPS: Array[String] = ["==", "!=", "<=", ">="]


## ok(Array[ConditionToken]) ending with an &"end" token, or err(&"condition_syntax").
static func tokenize(text: String) -> Result:
	var tokens: Array[ConditionToken] = []
	var i := 0
	while i < text.length():
		if _SPACE.contains(text[i]):
			i += 1
			continue
		var r := _read_token(text, i)
		if r.is_err():
			return r
		var token: ConditionToken = r.value
		tokens.append(token)
		i += token.text.length()
	tokens.append(ConditionToken.new(&"end", "", text.length()))
	return Result.ok(tokens)


static func _read_token(text: String, pos: int) -> Result:
	var c := text[pos]
	match c:
		"(":
			return _token(&"lparen", c, pos)
		")":
			return _token(&"rparen", c, pos)
		",":
			return _token(&"comma", c, pos)
	if c == "=" or c == "!" or c == "<" or c == ">":
		return _read_op(text, pos)
	if _DIGITS.contains(c) or (c == "-" and _digit_at(text, pos + 1)):
		var digits_from := pos + 1 if c == "-" else pos
		return _span(text, pos, _run_end(text, digits_from, _DIGITS), &"int")
	if _WORD_START.contains(c):
		return _span(text, pos, _run_end(text, pos + 1, _WORD_REST), &"word")
	return _bad_char(text, pos)


static func _read_op(text: String, pos: int) -> Result:
	var two := text.substr(pos, 2)
	if _TWO_CHAR_OPS.has(two):
		return _token(&"op", two, pos)
	var one := text[pos]
	if one == "<" or one == ">":
		return _token(&"op", one, pos)
	return _bad_char(text, pos)


## The index just past the run of `chars` characters that starts at `from`.
static func _run_end(text: String, from: int, chars: String) -> int:
	var end := from
	while end < text.length() and chars.contains(text[end]):
		end += 1
	return end


## The token of `kind` covering text[pos, end).
static func _span(text: String, pos: int, end: int, kind: StringName) -> Result:
	return _token(kind, text.substr(pos, end - pos), pos)


static func _digit_at(text: String, index: int) -> bool:
	return index < text.length() and _DIGITS.contains(text[index])


static func _token(kind: StringName, token_text: String, pos: int) -> Result:
	return Result.ok(ConditionToken.new(kind, token_text, pos))


static func _bad_char(text: String, pos: int) -> Result:
	return Result.err(&"condition_syntax", "pos %d: '%s'" % [pos, text[pos]])
