## EffectParser: turns a content effect string, `op(arg, arg)`, into an EffectSpec (content-format.md
## §E effects; architecture.md §3.4 open/closed registry). It knows no op: the op's name, argument
## kinds and defaults all come from the EffectSignatures it was given, so a new effect op needs only
## a signature registration here, never a parser change.
class_name EffectParser
extends RefCounted

var _signatures: EffectSignatures


func _init(signatures: EffectSignatures) -> void:
	_signatures = signatures


## ok(EffectSpec), or err with &"effect_syntax" (not of the shape `op(...)`, or text after the
## closing `)`), &"unknown_op", &"bad_arg_count" or &"bad_arg". The detail names the op.
## The whole text is stripped first, then the op name before `(`, then each argument.
func parse(text: String) -> Result:
	var source := text.strip_edges()
	var open := source.find("(")
	if open <= 0 or not source.ends_with(")"):
		return Result.err(&"effect_syntax", "expected op(args), got '%s'" % source)
	var op_name := StringName(source.left(open).strip_edges())
	var sig := _signatures.get_signature(op_name)
	if sig == null:
		return Result.err(&"unknown_op", "unknown effect op '%s'" % op_name)
	var args_text := source.substr(open + 1, source.length() - open - 2)
	var bound := ArgSpec.bind(sig.params, _split_args(args_text))
	if bound.is_err():
		return Result.err(bound.error_code, "%s: %s" % [op_name, bound.detail])
	var values: Array = bound.value
	return Result.ok(EffectSpec.new(op_name, values, ArgSpec.ids_in(sig.params, values)))


## ok(Array[EffectSpec]) in list order, or the first error with "#<index>: " put before its detail.
func parse_list(texts: Array[String]) -> Result:
	var specs: Array[EffectSpec] = []
	for i: int in texts.size():
		var r := parse(texts[i])
		if r.is_err():
			return Result.err(r.error_code, "#%d: %s" % [i, r.detail])
		var spec: EffectSpec = r.value
		specs.append(spec)
	return Result.ok(specs)


## `a, b` becomes ["a", "b"] (each stripped). Blank text is no arguments at all.
static func _split_args(args_text: String) -> PackedStringArray:
	var stripped := args_text.strip_edges()
	var tokens := PackedStringArray()
	if stripped.is_empty():
		return tokens
	for part: String in stripped.split(","):
		tokens.append(part.strip_edges())
	return tokens
