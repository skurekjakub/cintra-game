## The outcome of an operation that can fail in an expected way.
## Expected failures return Result.err(code); programmer errors use assert()
## (architecture.md §4.1, §11 "Errors").
class_name Result
extends RefCounted

var value: Variant:
	get:
		return _value
var error_code: StringName:
	get:
		return _error_code
var detail: String:
	get:
		return _detail

var _value: Variant = null
var _error_code: StringName = &""
var _detail: String = ""


static func ok(result_value: Variant = null) -> Result:
	var r := Result.new()
	r._value = result_value
	return r


static func err(code: StringName, error_detail: String = "") -> Result:
	assert(code != &"", "Result.err needs a non-empty error code")
	var r := Result.new()
	r._error_code = code
	r._detail = error_detail
	return r


func is_ok() -> bool:
	return _error_code == &""


func is_err() -> bool:
	return not is_ok()
