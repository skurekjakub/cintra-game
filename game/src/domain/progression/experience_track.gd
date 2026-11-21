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
## ints come back as floats). All or nothing: Err `save_invalid` on a missing key,
## a wrong type, XP outside 0..max or more skill points spent than that XP's
## level earned, and nothing changes. Emits no events and leaves pending ones alone.
func restore(data: Dictionary) -> Result:
	var reader := SnapshotReader.new(data, "experience_track")
	var stored_xp := reader.read_int("xp", 0, LevelTable.max_xp())
	var earned := LevelTable.skill_points_at(LevelTable.level_for(stored_xp))
	var spent := reader.read_int("skill_points_spent", 0, earned)
	if reader.failed():
		return reader.result()
	_xp = stored_xp
	_skill_points_spent = spent
	return Result.ok()
