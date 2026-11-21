## ConditionParser: turns a content condition string into a Condition tree (content-format.md §C
## condition language; architecture.md §3.4). It lexes with ConditionLexer, then reads with
## ConditionReader, which validates call names, argument specs (ConditionCalls) and comparison types.
class_name ConditionParser
extends RefCounted


## ok(Condition), or err with one of &"empty_condition" (blank text), &"condition_syntax",
## &"unknown_call", &"bad_arg_count", &"bad_arg", &"bad_call_use" or &"bad_compare".
## The detail names the offending text.
static func parse(text: String) -> Result:
	var lexed := ConditionLexer.tokenize(text)
	if lexed.is_err():
		return lexed
	var tokens: Array[ConditionToken] = lexed.value
	if tokens.size() == 1:
		return Result.err(&"empty_condition", "the condition is blank")
	return ConditionReader.new(text, tokens).read_all()
