## The Queen's condition, a derived value rather than a timer (gdd.md §6.2;
## architecture.md §4.4). While the antidote is not administered it is
## clamp(min(stage, 3) - mitigations, 0, 3). Once administered it freezes and
## improves by one step per later milestone, down to 0 (Weak). Surviving the
## Act II twist is exactly "the antidote was administered".
class_name QueenCondition
extends Snapshotable

const MAX_CONDITION: int = 3

var _condition: int = 0
var _administered: bool = false
var _outbox := EventOutbox.new()


## Re-derives the condition from the escalation stage and the Act I
## mitigations. Records QueenConditionChanged only on a real change. Does
## nothing once the antidote is administered (the condition is frozen).
func recompute(stage: int, mitigations: int) -> void:
	if _administered:
		return
	_set_condition(clampi(mini(stage, MAX_CONDITION) - mitigations, 0, MAX_CONDITION))


## Freezes the condition at its current value and records AntidoteAdministered
## once. A repeat call is a no-op.
func administer_antidote() -> void:
	if _administered:
		return
	_administered = true
	_outbox.record(AntidoteAdministered.new())


## Improves the condition by one step (never below 0). Only after the antidote.
func improve_on_milestone() -> void:
	if not _administered:
		return
	_set_condition(maxi(_condition - 1, 0))


## 0 (Weak) to 3 (Comatose).
func condition() -> int:
	return _condition


func antidote_administered() -> bool:
	return _administered


## Twist resolution (gdd.md §6.2): the Queen lives iff the antidote was
## administered (flag.queen_alive = flag.antidote_administered).
func resolve_survival() -> bool:
	return _administered


func drain_events() -> Array[DomainEvent]:
	return _outbox.drain()


func to_snapshot() -> Dictionary:
	return {"condition": _condition, "administered": _administered}


## Replaces all state from a snapshot (also one that went through JSON, where
## ints come back as floats). Emits no events and leaves pending ones alone.
func restore(data: Dictionary) -> void:
	var stored: float = data["condition"]
	var administered: bool = data["administered"]
	_condition = clampi(int(stored), 0, MAX_CONDITION)
	_administered = administered


func _set_condition(value: int) -> void:
	if value == _condition:
		return
	var before := _condition
	_condition = value
	_outbox.record(QueenConditionChanged.new(before, _condition))
