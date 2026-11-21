## The player's experience, level and skill points (gdd.md §6.8 progression;
## architecture.md §4.13). Attribute points are only counted as earned here;
## spending them belongs to ActorSheet. Records an event only when state really
## changes.
class_name ExperienceTrack
extends Snapshotable

var _xp: int = 0
var _skill_points_spent: int = 0
var _outbox := EventOutbox.new()


## Adds experience, capped at LevelTable.max_xp(); the excess is discarded.
## Records XpGained with the amount actually added (nothing when that is 0),
## then one LevelGained for each level crossed, in order.
func grant(amount: int, source: StringName) -> void:
	assert(amount >= 0, "amount must not be negative")
	var added := mini(amount, LevelTable.max_xp() - _xp)
	if added <= 0:
		return
	var old_level := level()
	_xp += added
	_outbox.record(XpGained.new(added, source))
	for reached: int in range(old_level + 1, level() + 1):
		_outbox.record(LevelGained.new(reached))


func xp() -> int:
	return _xp


func level() -> int:
	return LevelTable.level_for(_xp)


## Skill points earned by the current level minus the points already spent.
func unspent_skill_points() -> int:
	return LevelTable.skill_points_at(level()) - _skill_points_spent


## Attribute points earned by the current level. Progression cannot know what
## was spent; ActorSheet subtracts its own spending.
func attribute_points_earned() -> int:
	return LevelTable.attribute_points_at(level())


## Err `no_skill_points` when none is left to spend.
func spend_skill_point() -> Result:
	if unspent_skill_points() <= 0:
		return Result.err(&"no_skill_points")
	_skill_points_spent += 1
	return Result.ok()


func drain_events() -> Array[DomainEvent]:
	return _outbox.drain()


func to_snapshot() -> Dictionary:
	return {"xp": _xp, "skill_points_spent": _skill_points_spent}


## Replaces all state from a snapshot (also one that went through JSON, where
## ints come back as floats), clamping XP to 0..max and the spent points to the
## points earned. Emits no events and leaves pending ones alone.
func restore(data: Dictionary) -> void:
	var stored_xp: float = data["xp"]
	var stored_spent: float = data["skill_points_spent"]
	_xp = clampi(int(stored_xp), 0, LevelTable.max_xp())
	_skill_points_spent = clampi(int(stored_spent), 0, LevelTable.skill_points_at(level()))
