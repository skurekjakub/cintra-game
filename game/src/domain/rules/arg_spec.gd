## ArgSpec: one typed argument of a condition call or an effect (content-format.md §C
## call arguments, §E effect arguments; architecture.md §3.4). Grammar of a spec string:
##   id:<kind>[|<kind>...]   an id of one of the kinds, as a StringName
##   int | int:<min>..<max>  an integer (-?[0-9]+), optionally range-checked
##   word:<a>|<b>...         one of the listed words, as a StringName
##   local                   a local id (^[a-z][a-z0-9_]*$), as a StringName
##   int|word:<a>|<b>...     an int if the token is numeric, else one of the words
## A suffix "=<default>" makes the param optional (default converted by the spec itself).
## A trailing "+" makes it variadic (one or more; it must be the last param).
class_name ArgSpec
extends RefCounted

const _MAX_INT_DIGITS: int = 18
const _LOCAL_FIRST: String = "abcdefghijklmnopqrstuvwxyz"
const _LOCAL_REST: String = "abcdefghijklmnopqrstuvwxyz0123456789_"

var spec_text: String = ""
var optional: bool = false
var default_value: Variant = null
var variadic: bool = false

var _id_kinds: Array[StringName] = []
var _words: Array[StringName] = []
var _accepts_int: bool = false
var _has_range: bool = false
var _min: int = 0
var _max: int = 0
var _is_local: bool = false


## Parses a spec string. A malformed spec is a programmer error (assert).
static func parse(spec: String) -> ArgSpec:
	var a := ArgSpec.new()
	a.spec_text = spec
	var body := spec
	if body.ends_with("+"):
		a.variadic = true
		body = body.left(-1)
	var default_text := ""
	var eq := body.find("=")
	if eq >= 0:
		a.optional = true
		default_text = body.substr(eq + 1)
		body = body.left(eq)
	a._parse_body(body)
	if a.optional:
		a._set_default(default_text)
	assert(not (a.variadic and a.optional), "ArgSpec '%s': a variadic param cannot be optional" % spec)
	return a


## Converts one stripped token: ok(StringName | int) or err(&"bad_arg").
func convert(token: String) -> Result:
	if _accepts_int and _is_int_token(token):
		var n := token.to_int()
		if not _has_range or (n >= _min and n <= _max):
			return Result.ok(n)
		return _bad_arg(token)
	if _accepts_name(StringName(token)):
		return Result.ok(StringName(token))
	return _bad_arg(token)


func is_id() -> bool:
	return not _id_kinds.is_empty()


## Converts `tokens` against `specs`: ok(Array of converted values, defaults filled in and
## variadic values flattened in place), err(&"bad_arg_count") or err(&"bad_arg").
static func bind(specs: Array[ArgSpec], tokens: PackedStringArray) -> Result:
	assert(_is_well_formed(specs), "ArgSpec.bind: only the last param may be variadic, and optional params come last")
	if not _count_fits(specs, tokens.size()):
		return Result.err(&"bad_arg_count", "expected %s argument(s), got %d" % [_arity_text(specs), tokens.size()])
	var values: Array = []
	for i: int in specs.size():
		var spec := specs[i]
		if i >= tokens.size():
			values.append(spec.default_value)
			continue
		var stop := tokens.size() if spec.variadic else i + 1
		for t: int in range(i, stop):
			var r := spec.convert(tokens[t])
			if r.is_err():
				return r
			values.append(r.value)
	return Result.ok(values)


## The values (from `bind`) that belong to id specs, variadic ones included.
static func ids_in(specs: Array[ArgSpec], values: Array) -> Array[StringName]:
	var ids: Array[StringName] = []
	for i: int in mini(specs.size(), values.size()):
		var spec := specs[i]
		if not spec.is_id():
			continue
		var stop := values.size() if spec.variadic else i + 1
		for v: int in range(i, stop):
			var id: StringName = values[v]
			ids.append(id)
	return ids


static func _is_well_formed(specs: Array[ArgSpec]) -> bool:
	var seen_optional := false
	for i: int in specs.size():
		if specs[i].variadic and i != specs.size() - 1:
			return false
		if specs[i].optional:
			seen_optional = true
		elif seen_optional:
			return false
	return true


static func _required_count(specs: Array[ArgSpec]) -> int:
	var required := 0
	for spec: ArgSpec in specs:
		if not spec.optional:
			required += 1
	return required


static func _count_fits(specs: Array[ArgSpec], count: int) -> bool:
	var open_ended := not specs.is_empty() and specs[-1].variadic
	return count >= _required_count(specs) and (open_ended or count <= specs.size())


static func _arity_text(specs: Array[ArgSpec]) -> String:
	var required := _required_count(specs)
	if not specs.is_empty() and specs[-1].variadic:
		return "at least %d" % required
	if required == specs.size():
		return str(required)
	return "%d to %d" % [required, specs.size()]


static func _is_int_token(token: String) -> bool:
	var digits := token.substr(1) if token.begins_with("-") else token
	if digits.is_empty() or digits.length() > _MAX_INT_DIGITS:
		return false
	for c: String in digits:
		if not "0123456789".contains(c):
			return false
	return true


static func _is_local_id(token: String) -> bool:
	if token.is_empty() or not _LOCAL_FIRST.contains(token[0]):
		return false
	for c: String in token:
		if not _LOCAL_REST.contains(c):
			return false
	return true


func _accepts_name(word: StringName) -> bool:
	if _is_local:
		return _is_local_id(String(word))
	for kind: StringName in _id_kinds:
		if IdRules.is_valid(word, kind):
			return true
	return _words.has(word)


func _bad_arg(token: String) -> Result:
	return Result.err(&"bad_arg", "bad argument '%s' for spec '%s'" % [token, spec_text])


func _parse_body(body: String) -> void:
	var colon := body.find(":")
	var head := body if colon < 0 else body.left(colon)
	var rest := "" if colon < 0 else body.substr(colon + 1)
	match head:
		"id":
			_id_kinds = _kind_list(rest)
		"int":
			_accepts_int = true
			if colon >= 0:
				_parse_range(rest)
		"word":
			_words = _name_list(rest)
		"local":
			assert(colon < 0, "ArgSpec '%s': 'local' takes no parameters" % spec_text)
			_is_local = true
		"int|word":
			_accepts_int = true
			_words = _name_list(rest)
		_:
			assert(false, "ArgSpec '%s': unknown spec kind '%s'" % [spec_text, head])


func _set_default(default_text: String) -> void:
	var r := self.convert(default_text)  # bare convert() is the global builtin
	assert(r.is_ok(), "ArgSpec '%s': default '%s' does not satisfy the spec" % [spec_text, default_text])
	default_value = r.value


func _parse_range(text: String) -> void:
	var bounds := text.split("..")
	assert(bounds.size() == 2 and _is_int_token(bounds[0]) and _is_int_token(bounds[1]),
			"ArgSpec '%s': int range must look like <min>..<max>" % spec_text)
	_min = bounds[0].to_int()
	_max = bounds[1].to_int()
	assert(_min <= _max, "ArgSpec '%s': empty int range" % spec_text)
	_has_range = true


func _name_list(text: String) -> Array[StringName]:
	var names: Array[StringName] = []
	for part: String in text.split("|"):
		assert(not part.is_empty(), "ArgSpec '%s': empty word in list" % spec_text)
		names.append(StringName(part))
	return names


func _kind_list(text: String) -> Array[StringName]:
	var kinds := _name_list(text)
	for kind: StringName in kinds:
		assert(IdRules.is_known_kind(kind), "ArgSpec '%s': unknown id kind '%s'" % [spec_text, kind])
	return kinds
