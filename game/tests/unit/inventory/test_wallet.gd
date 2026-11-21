## Wallet: the crowns balance, add/spend, CrownsChanged events and the JSON-safe
## snapshot (gdd.md §6.9 crowns; content-format.md §E add_crowns; architecture.md
## §4.7, §9.3).
extends GutTest


func test_add_and_spend() -> void:
	var w := Wallet.new(30)
	w.add(10)
	assert_true(w.spend(40).is_ok())
	assert_eq(w.balance(), 0)
	assert_eq(w.drain_events().size(), 2)


func test_starts_at_zero_by_default() -> void:
	var w := Wallet.new()
	assert_eq(w.balance(), 0)
	assert_eq(w.drain_events().size(), 0)


func test_constructor_start_is_not_an_event() -> void:
	var w := Wallet.new(30)
	assert_eq(w.balance(), 30)
	assert_eq(w.drain_events().size(), 0)


func test_overspend_fails_without_change() -> void:
	var w := Wallet.new(30)
	var r := w.spend(31)
	assert_true(r.is_err())
	assert_eq(r.error_code, &"insufficient_crowns")
	assert_eq(w.balance(), 30)
	assert_eq(w.drain_events().size(), 0)


func test_spend_exact_balance_succeeds() -> void:
	var w := Wallet.new(30)
	assert_true(w.spend(30).is_ok())
	assert_eq(w.balance(), 0)


func test_events_carry_old_and_new_balance_in_order() -> void:
	var w := Wallet.new(30)
	w.add(10)
	w.spend(25)
	var events := w.drain_events()
	assert_eq(events.size(), 2)
	var gained := events[0] as CrownsChanged
	var spent := events[1] as CrownsChanged
	assert_eq([gained.old_balance, gained.new_balance], [30, 40])
	assert_eq([spent.old_balance, spent.new_balance], [40, 15])


func test_zero_amounts_change_nothing_and_record_nothing() -> void:
	var w := Wallet.new(30)
	w.add(0)
	assert_true(w.spend(0).is_ok())
	assert_eq(w.balance(), 30)
	assert_eq(w.drain_events().size(), 0)


func test_drain_empties_the_outbox() -> void:
	var w := Wallet.new()
	w.add(5)
	assert_eq(w.drain_events().size(), 1)
	assert_eq(w.drain_events().size(), 0)


func test_snapshot_shape() -> void:
	assert_eq(Wallet.new(42).to_snapshot(), {"crowns": 42})


func test_snapshot_survives_json_round_trip() -> void:
	var w := Wallet.new(42)
	var r := Wallet.new()
	r.restore(JsonRoundTrip.of(w.to_snapshot()))
	assert_eq(r.to_snapshot(), w.to_snapshot())
	assert_eq(r.balance(), 42)


func test_restore_replaces_state_and_emits_nothing() -> void:
	var r := Wallet.new(5)
	r.add(1)
	r.restore({"crowns": 42.0})
	assert_eq(r.balance(), 42)
	assert_eq(typeof(r.to_snapshot()["crowns"]), TYPE_INT)
	var events := r.drain_events()
	assert_eq(events.size(), 1, "restore leaves the pending add event and records none")


func test_restore_clamps_a_negative_balance_to_zero() -> void:
	var r := Wallet.new(5)
	r.restore({"crowns": -10.0})
	assert_eq(r.balance(), 0)
