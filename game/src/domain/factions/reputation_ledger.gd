## Every faction's reputation, -100 to 100, its tier and the rep_mod a tier adds
## to social checks (gdd.md §6.12 reputation and tiers, §6.10 rep_mod;
## architecture.md §4.5). Records an event only when state really changes.
class_name ReputationLedger
extends Snapshotable

const MIN_REP := -100
const MAX_REP := 100
const REP_MODS: Dictionary[StringName, int] = {
	&"hostile": -2, &"wary": -1, &"neutral": 0, &"friendly": 1, &"allied": 2,
}

var _defs: Dictionary[StringName, FactionDefinition] = {}
var _values: Dictionary[StringName, int] = {}
var _outbox := EventOutbox.new()


## Each faction starts at its definition's `start`.
func _init(defs: Array[FactionDefinition]) -> void:
	for def: FactionDefinition in defs:
		assert(not _defs.has(def.id), "duplicate faction id")
		assert(def.start >= MIN_REP and def.start <= MAX_REP, "start must be within -100..100")
		_defs[def.id] = def
		_values[def.id] = def.start


## Adds `delta`, clamped to -100..100. Records the value change, then the tier
## change when the faction crossed into another tier.
func add(faction_id: StringName, delta: int) -> void:
	assert(_defs.has(faction_id), "unknown faction")
	var old_value := value(faction_id)
	var new_value := clampi(old_value + delta, MIN_REP, MAX_REP)
	if new_value == old_value:
		return
	var old_tier := tier(faction_id)
	_values[faction_id] = new_value
	_outbox.record(ReputationChanged.new(faction_id, old_value, new_value))
	var new_tier := tier(faction_id)
	if new_tier != old_tier:
		_outbox.record(ReputationTierChanged.new(faction_id, old_tier, new_tier))


func value(faction_id: StringName) -> int:
	assert(_values.has(faction_id), "unknown faction")
	return _values[faction_id]


func tier(faction_id: StringName) -> StringName:
	assert(_defs.has(faction_id), "unknown faction")
	return _defs[faction_id].tier_for(value(faction_id))


## Friendly +1, Allied +2, Wary -1, Hostile -2, Neutral 0 (gdd.md §6.10).
func rep_mod(faction_id: StringName) -> int:
	return REP_MODS[tier(faction_id)]


func drain_events() -> Array[DomainEvent]:
	return _outbox.drain()


func to_snapshot() -> Dictionary:
	var stored: Dictionary = {}
	for id: StringName in _values:
		stored[String(id)] = _values[id]
	return {"values": stored}


## Replaces all state from a snapshot (also one that went through JSON, where
## ints come back as floats). A faction missing from the snapshot goes back to
## its start; an id this ledger does not define is ignored. Emits no events.
func restore(data: Dictionary) -> void:
	for id: StringName in _defs:
		_values[id] = _defs[id].start
	var stored: Dictionary = data["values"]
	for faction_name: String in stored:
		var id := StringName(faction_name)
		if _defs.has(id):
			var amount: float = stored[faction_name]
			_values[id] = clampi(int(amount), MIN_REP, MAX_REP)
