## EffectSignature: the typed parameter list of one effect op (content-format.md §E effect
## arguments; architecture.md §3.4 open/closed registry). Built from ArgSpec strings, in order.
class_name EffectSignature
extends RefCounted

var op: StringName = &""
var params: Array[ArgSpec] = []


## Builds a signature from the op name and one spec string per parameter (see ArgSpec).
## A malformed spec is a programmer error (ArgSpec.parse asserts).
static func of(op_name: StringName, param_specs: Array[String]) -> EffectSignature:
	var sig := EffectSignature.new()
	sig.op = op_name
	for spec: String in param_specs:
		sig.params.append(ArgSpec.parse(spec))
	return sig
