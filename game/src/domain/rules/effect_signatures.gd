## EffectSignatures: the registry of effect ops and their signatures (architecture.md §3.4
## open/closed registry: a new effect is one `register` call, no parser change; content-format.md
## §E). An instance is filled by the effect handlers; `ops()` feeds the schema and error messages.
class_name EffectSignatures
extends RefCounted

var _by_op: Dictionary[StringName, EffectSignature] = {}


## Adds `sig`. Registering the same op twice is a programmer error.
func register(sig: EffectSignature) -> void:
	assert(not _by_op.has(sig.op), "EffectSignatures: op '%s' is already registered" % sig.op)
	_by_op[sig.op] = sig


func has_op(op: StringName) -> bool:
	return _by_op.has(op)


## The signature of `op`, or null when the op is unknown.
func get_signature(op: StringName) -> EffectSignature:
	return _by_op.get(op)


## Every registered op, alphabetical. Sorted by text: Array[StringName].sort() orders by
## interned pointer, which is unspecified.
func ops() -> Array[StringName]:
	var names: Array[StringName] = []
	names.assign(_by_op.keys())
	names.sort_custom(func(a: StringName, b: StringName) -> bool: return String(a) < String(b))
	return names
