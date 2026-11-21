## Result: the shared success-or-error value (architecture.md §4.1, §11 "Errors").
extends GutTest


func test_ok_holds_value() -> void:
	var r := Result.ok(42)
	assert_true(r.is_ok())
	assert_false(r.is_err())
	assert_eq(r.value, 42)
	assert_eq(r.error_code, &"")


func test_ok_without_value_is_null() -> void:
	var r := Result.ok()
	assert_true(r.is_ok())
	assert_null(r.value)


func test_err_keeps_code_and_detail() -> void:
	var r := Result.err(&"item_not_found", "item.iron_key")
	assert_false(r.is_ok())
	assert_true(r.is_err())
	assert_eq(r.error_code, &"item_not_found")
	assert_eq(r.detail, "item.iron_key")
	assert_null(r.value)


func test_err_detail_defaults_to_empty() -> void:
	var r := Result.err(&"nope")
	assert_eq(r.detail, "")
