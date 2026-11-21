## ActorSheet: derived stats, hit points and attribute points
## (gdd.md §6.6 derived stats, §6.8 attribute points; architecture.md §4.11).
## Restore validation: test_actor_sheet_restore.gd.
extends GutTest

# GUT reuses one instance of this script for every test, and a lambda copies
# captured locals, so the level lives in a member that `_level_of` reads.
var _level: int = 1


func before_each() -> void:
	_level = 1


func _level_of() -> int:
	return _level


func test_derived_stats() -> void:
	var s := ActorSheet.new(Attributes.new({&"grit": 5, &"agility": 5, &"might": 5}), _level_of)
	assert_eq(s.max_hp(), 155)
	_level = 4
	assert_eq(s.max_hp(), 179)
	assert_eq(s.max_stamina(), 110)
	assert_almost_eq(s.melee_mod(), 1.12, 0.0001)
	assert_almost_eq(s.ranged_mod(), 1.12, 0.0001)
	assert_almost_eq(s.resist(&"poison"), 0.25, 0.0001)
	assert_almost_eq(s.resist(&"cold"), 0.25, 0.0001)
	assert_eq(s.resist(&"fire"), 0.0)


func test_below_three_lowers_melee() -> void:
	var s := ActorSheet.new(Attributes.new({&"might": 2}), _level_of)
	assert_almost_eq(s.melee_mod(), 0.94, 0.0001)


func test_ranged_mod_reads_agility_not_might() -> void:
	var s := ActorSheet.new(Attributes.new({&"might": 9, &"agility": 4}), _level_of)
	assert_almost_eq(s.ranged_mod(), 1.06, 0.0001)


func test_attribute_and_attributes_accessors() -> void:
	var s := ActorSheet.new(Attributes.new({&"wits": 6}), _level_of)
	assert_eq(s.attribute(&"wits"), 6)
	assert_eq(s.attributes().get_value(&"wits"), 6)


func test_damage_heal_clamp_and_events() -> void:
	var s := ActorSheet.new(Attributes.new(), _level_of)   # max 125
	s.damage(200)
	assert_eq(s.current_hp(), 0)
	assert_eq((s.drain_events()[0] as ActorDamaged).amount, 125)
	s.heal(500)
	assert_eq(s.current_hp(), 125)
	s.full_restore()
	assert_eq(s.drain_events().size(), 1)   # heal only; full_restore at max is silent


func test_starts_at_max_hp() -> void:
	var s := ActorSheet.new(Attributes.new(), _level_of)
	assert_eq(s.current_hp(), 125)
	assert_eq(s.drain_events().size(), 0)


func test_damage_and_heal_events_carry_amount_and_resulting_hp() -> void:
	var s := ActorSheet.new(Attributes.new(), _level_of)
	s.damage(30)
	s.heal(10)
	var events := s.drain_events()
	assert_eq(events.size(), 2)
	var hurt := events[0] as ActorDamaged
	var healed := events[1] as ActorHealed
	assert_eq([hurt.amount, hurt.current_hp], [30, 95])
	assert_eq([healed.amount, healed.current_hp], [10, 105])


func test_heal_reports_only_what_was_actually_healed() -> void:
	var s := ActorSheet.new(Attributes.new(), _level_of)
	s.damage(5)
	s.drain_events()
	s.heal(50)
	var healed := s.drain_events()[0] as ActorHealed
	assert_eq([healed.amount, healed.current_hp], [5, 125])


func test_no_event_when_nothing_changed() -> void:
	var s := ActorSheet.new(Attributes.new(), _level_of)
	s.heal(10)
	s.damage(0)
	s.heal(0)
	assert_eq(s.drain_events().size(), 0)
	s.damage(200)
	s.drain_events()
	s.damage(20)
	assert_eq(s.drain_events().size(), 0)


func test_full_restore_heals_to_max() -> void:
	var s := ActorSheet.new(Attributes.new(), _level_of)
	s.damage(100)
	s.drain_events()
	s.full_restore()
	assert_eq(s.current_hp(), 125)
	assert_eq((s.drain_events()[0] as ActorHealed).amount, 100)


func test_a_higher_level_raises_max_hp_but_not_current_hp() -> void:
	var s := ActorSheet.new(Attributes.new(), _level_of)
	_level = 3
	assert_eq(s.max_hp(), 141)
	assert_eq(s.current_hp(), 125)


func test_current_hp_reads_clamped_to_max() -> void:
	var snap := {"attributes": {"might": 3, "agility": 3, "grit": 3, "wits": 3, "presence": 3}, "hp": 999, "points_spent": 0}
	var s := ActorSheet.new(Attributes.new(), _level_of)   # max 125
	assert_true(s.restore(JsonRoundTrip.of(snap)).is_ok(), "hp above max is valid; max depends on the level")
	assert_eq(s.current_hp(), 125)


func test_attribute_points_by_level() -> void:
	var s := ActorSheet.new(Attributes.new(), _level_of)
	_level = 2
	assert_eq(s.spend_attribute_point(&"grit").error_code, &"no_attribute_points")
	_level = 3
	assert_true(s.spend_attribute_point(&"grit").is_ok())
	assert_eq(s.attribute(&"grit"), 4)
	assert_eq(s.unspent_attribute_points(), 0)
	_level = 11
	assert_eq(s.unspent_attribute_points(), 4)


func test_unspent_points_follow_the_gdd_levels() -> void:
	var s := ActorSheet.new(Attributes.new(), _level_of)
	var expected: Dictionary[int, int] = {1: 0, 2: 0, 3: 1, 4: 1, 5: 2, 6: 2, 7: 3, 8: 3, 9: 4, 10: 4, 11: 5, 12: 5}
	for level: int in expected:
		_level = level
		assert_eq(s.unspent_attribute_points(), expected[level], "level %d" % level)


func test_attribute_point_levels_constant() -> void:
	assert_eq(ActorSheet.ATTRIBUTE_POINT_LEVELS, [3, 5, 7, 9, 11] as Array[int])


func test_spending_records_an_event_and_raises_the_derived_stat() -> void:
	_level = 3
	var s := ActorSheet.new(Attributes.new(), _level_of)
	assert_true(s.spend_attribute_point(&"grit").is_ok())
	var e := s.drain_events()[0] as AttributeIncreased
	assert_eq([e.attribute, e.new_value], [&"grit", 4])
	assert_eq(s.max_hp(), 80 + 15 * 4 + 16)


func test_spending_rejects_unknown_attribute_without_changes() -> void:
	_level = 3
	var s := ActorSheet.new(Attributes.new(), _level_of)
	assert_eq(s.spend_attribute_point(&"luck").error_code, &"unknown_attribute")
	assert_eq(s.unspent_attribute_points(), 1)
	assert_eq(s.drain_events().size(), 0)


func test_a_failed_spend_records_nothing() -> void:
	var s := ActorSheet.new(Attributes.new(), _level_of)
	s.spend_attribute_point(&"grit")
	assert_eq(s.drain_events().size(), 0)
	assert_eq(s.attribute(&"grit"), 3)


func test_attribute_cap_ten() -> void:
	var s := ActorSheet.new(Attributes.new({&"might": 10}), _level_of)
	_level = 3
	assert_eq(s.spend_attribute_point(&"might").error_code, &"attribute_at_max")
	assert_eq(s.unspent_attribute_points(), 1)


func test_drain_empties_the_outbox() -> void:
	var s := ActorSheet.new(Attributes.new(), _level_of)
	s.damage(1)
	assert_eq(s.drain_events().size(), 1)
	assert_eq(s.drain_events().size(), 0)


func test_snapshot_survives_json_round_trip() -> void:
	_level = 5
	var s := ActorSheet.new(Attributes.new({&"wits": 6}), _level_of)
	s.spend_attribute_point(&"wits")
	s.damage(10)
	var r := ActorSheet.new(Attributes.new(), _level_of)
	assert_true(r.restore(JsonRoundTrip.of(s.to_snapshot())).is_ok())
	assert_eq(r.to_snapshot(), s.to_snapshot())
	assert_eq(r.attribute(&"wits"), 7)
	assert_eq(r.current_hp(), s.current_hp())
	assert_eq(r.unspent_attribute_points(), 1)


func test_snapshot_shape() -> void:
	_level = 3
	var s := ActorSheet.new(Attributes.new({&"might": 4}), _level_of)
	s.spend_attribute_point(&"grit")
	s.damage(20)
	var snap := s.to_snapshot()
	assert_eq(snap["hp"], 121)   # started at max 141; the grit point raises max but not current hp
	assert_eq(snap["points_spent"], 1)
	assert_eq(snap["attributes"], {"might": 4, "agility": 3, "grit": 4, "wits": 3, "presence": 3})


func test_restore_replaces_state_and_emits_nothing() -> void:
	_level = 3
	var src := ActorSheet.new(Attributes.new({&"might": 6}), _level_of)
	src.damage(40)
	var r := ActorSheet.new(Attributes.new({&"wits": 9}), _level_of)
	r.spend_attribute_point(&"presence")
	r.damage(5)
	r.drain_events()
	assert_true(r.restore(JsonRoundTrip.of(src.to_snapshot())).is_ok())
	assert_eq([r.attribute(&"might"), r.attribute(&"wits"), r.attribute(&"presence")], [6, 3, 3])
	assert_eq(r.unspent_attribute_points(), 1)
	assert_eq(r.current_hp(), src.current_hp())
	assert_eq(r.drain_events().size(), 0)
