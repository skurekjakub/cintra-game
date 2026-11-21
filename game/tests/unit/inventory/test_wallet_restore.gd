## Wallet.restore(): all or nothing, rejecting a bad snapshot with save_invalid
## and leaving the balance unchanged (architecture.md §4 restore contract, §4.12).
extends GutTest


func _populated() -> Wallet:
	var w := Wallet.new(30)
	w.add(5)
	w.drain_events()
	return w


func test_a_valid_snapshot_restores_ok() -> void:
	var w := _populated()
	var r := Wallet.new()
	var res := r.restore(JsonRoundTrip.of(w.to_snapshot()))
	assert_true(res.is_ok())
	assert_eq(r.to_snapshot(), w.to_snapshot())


func test_a_missing_key_is_rejected_and_named() -> void:
	var res := Wallet.new().restore({})
	assert_eq(res.error_code, &"save_invalid")
	assert_string_contains(res.detail, "wallet.crowns")


func test_wrong_types_are_rejected() -> void:
	assert_eq(Wallet.new().restore({"crowns": "42"}).error_code, &"save_invalid")
	assert_eq(Wallet.new().restore({"crowns": 2.5}).error_code, &"save_invalid")


func test_a_negative_balance_is_rejected_not_clamped() -> void:
	var w := Wallet.new(5)
	var res := w.restore({"crowns": -10.0})
	assert_eq(res.error_code, &"save_invalid")
	assert_string_contains(res.detail, "wallet.crowns")
	assert_eq(w.balance(), 5)


func test_a_rejected_restore_changes_nothing_and_records_nothing() -> void:
	var w := _populated()
	var before := w.to_snapshot()
	assert_true(w.restore({"crowns": -1.0}).is_err())
	assert_eq(w.to_snapshot(), before)
	assert_eq(w.drain_events().size(), 0)
