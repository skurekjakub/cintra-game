## The player's crowns (gdd.md §6.9 currency; architecture.md §4.12). A failed
## spend changes nothing and records nothing; an amount of 0 is not a change.
## The add_crowns(N) handler calls spend(-N) when N < 0, so a price the player
## cannot pay fails (content-format.md §E).
class_name Wallet
extends Snapshotable

var _crowns: int = 0
var _outbox := EventOutbox.new()


func _init(start: int = 0) -> void:
	assert(start >= 0, "start must not be negative")
	_crowns = start


## Adds crowns. Records CrownsChanged unless n is 0.
func add(n: int) -> void:
	assert(n >= 0, "n must not be negative")
	_change_by(n)


## Takes crowns. Err `insufficient_crowns` (balance unchanged, no event) when
## the balance is below n. Spending 0 succeeds and records nothing.
func spend(n: int) -> Result:
	assert(n >= 0, "n must not be negative")
	if n > _crowns:
		return Result.err(&"insufficient_crowns")
	_change_by(-n)
	return Result.ok()


func balance() -> int:
	return _crowns


func drain_events() -> Array[DomainEvent]:
	return _outbox.drain()


func to_snapshot() -> Dictionary:
	return {"crowns": _crowns}


## Replaces the balance from a snapshot (also one that went through JSON, where
## ints come back as floats), clamping a negative value to 0. Emits no events
## and leaves pending ones alone.
func restore(data: Dictionary) -> void:
	var stored: float = data["crowns"]
	_crowns = maxi(int(stored), 0)


func _change_by(delta: int) -> void:
	if delta == 0:
		return
	var before := _crowns
	_crowns += delta
	_outbox.record(CrownsChanged.new(before, _crowns))
