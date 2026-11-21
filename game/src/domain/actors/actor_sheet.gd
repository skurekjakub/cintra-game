## The player's attributes, derived stats and hit points outside combat, plus
## the attribute points earned by level (gdd.md §6.6 derived stats, §6.8
## attribute points; architecture.md §4.11). The level comes from a provider, so
## the sheet never knows how experience works. Records an event only when state
## really changes.
class_name ActorSheet
extends Snapshotable

## Levels that grant one attribute point (gdd.md §6.6). The progression domain
## keeps its own copy; a test keeps the two equal.
const ATTRIBUTE_POINT_LEVELS: Array[int] = [3, 5, 7, 9, 11]
const BASE_HP := 80
const HP_PER_GRIT := 15
const HP_PER_LEVEL := 8
const BASE_STAMINA := 85
const STAMINA_PER_AGILITY := 5
const MOD_PER_POINT := 0.06
const RESIST_PER_GRIT := 0.05
const GRIT_RESISTED: Array[StringName] = [&"poison", &"cold"]

var _attrs: Attributes
var _level_provider: Callable
var _hp: int
var _points_spent: int = 0
var _outbox := EventOutbox.new()


## `level_provider` is a Callable that returns the current level as an int.
## Hit points start at the maximum.
func _init(attrs: Attributes, level_provider: Callable) -> void:
	_attrs = attrs
	_level_provider = level_provider
	_hp = max_hp()


func attributes() -> Attributes:
	return _attrs


func attribute(attr_name: StringName) -> int:
	return _attrs.get_value(attr_name)


func max_hp() -> int:
	return BASE_HP + HP_PER_GRIT * attribute(&"grit") + HP_PER_LEVEL * (_level() - 1)


func max_stamina() -> int:
	return BASE_STAMINA + STAMINA_PER_AGILITY * attribute(&"agility")


## +6% per Might above 3, -6% per point below.
func melee_mod() -> float:
	return 1.0 + MOD_PER_POINT * (attribute(&"might") - Attributes.BASE)


## +6% per Agility above 3 (the crossbow).
func ranged_mod() -> float:
	return 1.0 + MOD_PER_POINT * (attribute(&"agility") - Attributes.BASE)


## 5% x Grit against poison and cold, nothing against other damage types.
func resist(type: StringName) -> float:
	if GRIT_RESISTED.has(type):
		return RESIST_PER_GRIT * attribute(&"grit")
	return 0.0


func current_hp() -> int:
	return mini(_hp, max_hp())


## Restores up to `amount` HP, capped at max HP. Records the HP actually gained.
func heal(amount: int) -> void:
	assert(amount >= 0, "heal amount must not be negative")
	var before := current_hp()
	var gained := mini(amount, max_hp() - before)
	if gained <= 0:
		return
	_hp = before + gained
	_outbox.record(ActorHealed.new(gained, _hp))


## Removes up to `amount` HP, floored at 0. Records the HP actually lost.
func damage(amount: int) -> void:
	assert(amount >= 0, "damage amount must not be negative")
	var before := current_hp()
	var lost := mini(amount, before)
	if lost <= 0:
		return
	_hp = before - lost
	_outbox.record(ActorDamaged.new(lost, _hp))


func full_restore() -> void:
	heal(max_hp() - current_hp())


## Errors: &"unknown_attribute", &"no_attribute_points", &"attribute_at_max".
func spend_attribute_point(attr: StringName) -> Result:
	if not CheckSkills.is_attribute(attr):
		return Result.err(&"unknown_attribute")
	if unspent_attribute_points() <= 0:
		return Result.err(&"no_attribute_points")
	if attribute(attr) >= Attributes.MAX:
		return Result.err(&"attribute_at_max")
	_attrs = _attrs.with_point(attr)
	_points_spent += 1
	_outbox.record(AttributeIncreased.new(attr, attribute(attr)))
	return Result.ok()


## Points earned at the current level minus the points already spent.
func unspent_attribute_points() -> int:
	var level := _level()
	var earned := 0
	for point_level: int in ATTRIBUTE_POINT_LEVELS:
		if point_level <= level:
			earned += 1
	return earned - _points_spent


func drain_events() -> Array[DomainEvent]:
	return _outbox.drain()


func to_snapshot() -> Dictionary:
	var attr_values: Dictionary = {}
	var current := _attrs.to_dict()
	for attr: StringName in current:
		attr_values[String(attr)] = current[attr]
	return {"attributes": attr_values, "hp": current_hp(), "points_spent": _points_spent}


## Replaces all state from a snapshot (also one that went through JSON, where
## ints come back as floats). Emits no events.
func restore(data: Dictionary) -> void:
	var stored_attrs: Dictionary = data["attributes"]
	var values: Dictionary[StringName, int] = {}
	for attr_name: String in stored_attrs:
		var stored: float = stored_attrs[attr_name]
		values[StringName(attr_name)] = int(stored)
	_attrs = Attributes.new(values)
	var stored_hp: float = data["hp"]
	_hp = int(stored_hp)
	var stored_spent: float = data["points_spent"]
	_points_spent = int(stored_spent)


func _level() -> int:
	var level: int = _level_provider.call()
	assert(level >= 1, "level starts at 1")
	return level
