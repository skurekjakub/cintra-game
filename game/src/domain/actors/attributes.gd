## The five attributes as an immutable value: Might, Agility, Grit, Wits and
## Presence. Each starts at 3; character creation adds 4 points with none above 6,
## and the absolute maximum is 10 (gdd.md §6.6; architecture.md §4.4).
class_name Attributes
extends RefCounted

const BASE := 3
const MAX := 10
const CREATION_POINTS := 4
const CREATION_CAP := 6

var _values: Dictionary[StringName, int] = {}


## `values` overrides the default of 3 for the names it lists.
func _init(values: Dictionary[StringName, int] = {}) -> void:
	for attr: StringName in CheckSkills.ATTRIBUTES:
		_values[attr] = BASE
	for attr: StringName in values:
		assert(CheckSkills.is_attribute(attr), "unknown attribute")
		var given: int = values[attr]
		assert(given >= 0 and given <= MAX, "attribute value must be 0..%d" % MAX)
		_values[attr] = given


## The attributes a new character gets from `bonus` (points added to each base
## of 3). Errors: &"unknown_attribute", &"wrong_point_total" (the sum must be 4,
## no negatives) and &"attribute_over_creation_cap" (a value above 6).
static func create(bonus: Dictionary[StringName, int]) -> Result:
	var code := _creation_error(bonus)
	if code != &"":
		return Result.err(code)
	var values: Dictionary[StringName, int] = {}
	for attr: StringName in bonus:
		values[attr] = BASE + bonus[attr]
	return Result.ok(Attributes.new(values))


func get_value(attr: StringName) -> int:
	assert(_values.has(attr), "unknown attribute")
	return _values[attr]


## A copy with `attr` one higher. The caller checks the cap of 10 first.
func with_point(attr: StringName) -> Attributes:
	assert(get_value(attr) < MAX, "attribute is already at the maximum")
	var next: Dictionary[StringName, int] = _values.duplicate()
	next[attr] += 1
	return Attributes.new(next)


func to_dict() -> Dictionary[StringName, int]:
	var copy: Dictionary[StringName, int] = _values.duplicate()
	return copy


## The error code that makes `bonus` an invalid creation spread, or &"" if it is valid.
static func _creation_error(bonus: Dictionary[StringName, int]) -> StringName:
	for attr: StringName in bonus:
		if not CheckSkills.is_attribute(attr):
			return &"unknown_attribute"
	var total := 0
	for attr: StringName in bonus:
		var points: int = bonus[attr]
		if points < 0:
			return &"wrong_point_total"
		total += points
	if total != CREATION_POINTS:
		return &"wrong_point_total"
	for attr: StringName in bonus:
		if BASE + bonus[attr] > CREATION_CAP:
			return &"attribute_over_creation_cap"
	return &""
