## ExperienceTrack: XP, level-ups, the cap, skill and attribute points earned
## (gdd.md §6.8; architecture.md §4.13, §9.3). Spending attribute points belongs
## to ActorSheet, so the track only reports how many were earned. Restore
## validation: test_experience_track_restore.gd.
extends GutTest


func test_starts_at_level_one_with_nothing() -> void:
	var t := ExperienceTrack.new()
	assert_eq([t.xp(), t.level(), t.unspent_skill_points(), t.attribute_points_earned()], [0, 1, 0, 0])
	assert_eq(t.drain_events().size(), 0)


func test_grant_levels_up_with_events() -> void:
	var t := ExperienceTrack.new()
	t.grant(1350, &"quest")
	assert_eq(t.level(), 4)
	var events := t.drain_events()
	assert_eq((events[0] as XpGained).amount, 1350)
	assert_eq([(events[1] as LevelGained).new_level, (events[3] as LevelGained).new_level], [2, 4])


func test_grant_records_xp_then_one_level_event_per_level_in_order() -> void:
	var t := ExperienceTrack.new()
	t.grant(1350, &"quest")
	var events := t.drain_events()
	assert_eq(events.size(), 4)
	assert_true(events[0] is XpGained)
	var levels: Array[int] = []
	for i: int in range(1, events.size()):
		var gained := events[i] as LevelGained
		levels.append(gained.new_level)
	assert_eq(levels, [2, 3, 4] as Array[int])


func test_xp_gained_carries_amount_and_source() -> void:
	var t := ExperienceTrack.new()
	t.grant(40, &"clue")
	var e := t.drain_events()[0] as XpGained
	assert_eq(e.amount, 40)
	assert_eq(e.source, &"clue")


func test_grant_inside_a_level_records_only_xp_gained() -> void:
	var t := ExperienceTrack.new()
	t.grant(100, &"clue")
	var events := t.drain_events()
	assert_eq(events.size(), 1)
	assert_true(events[0] is XpGained)
	assert_eq([t.xp(), t.level()], [100, 1])


func test_grants_accumulate_and_a_later_grant_crosses_the_next_level() -> void:
	var t := ExperienceTrack.new()
	t.grant(200, &"a")
	t.drain_events()
	t.grant(150, &"b")
	assert_eq([t.xp(), t.level()], [350, 2])
	var events := t.drain_events()
	assert_eq(events.size(), 2)
	assert_eq((events[1] as LevelGained).new_level, 2)


func test_cap_discards_excess() -> void:
	var t := ExperienceTrack.new()
	t.grant(20000, &"cheat")
	assert_eq(t.xp(), 11550)
	assert_eq((t.drain_events()[0] as XpGained).amount, 11550)
	t.grant(10, &"quest")
	assert_eq(t.drain_events().size(), 0)


func test_grant_that_reaches_the_cap_reports_only_the_xp_actually_added() -> void:
	var t := ExperienceTrack.new()
	t.grant(11000, &"a")
	assert_eq(t.level(), 11)
	t.drain_events()
	t.grant(1000, &"b")
	assert_eq([t.xp(), t.level()], [11550, 12])
	var events := t.drain_events()
	assert_eq(events.size(), 2)
	assert_eq((events[0] as XpGained).amount, 550)
	assert_eq((events[1] as LevelGained).new_level, 12)


func test_zero_grant_is_silent() -> void:
	var t := ExperienceTrack.new()
	t.grant(0, &"x")
	assert_eq(t.drain_events().size(), 0)
	assert_eq(t.xp(), 0)


func test_skill_points() -> void:
	var t := ExperienceTrack.new()
	t.grant(1350, &"q")
	assert_eq(t.unspent_skill_points(), 3)
	assert_true(t.spend_skill_point().is_ok())
	assert_eq(t.unspent_skill_points(), 2)
	t.spend_skill_point()
	t.spend_skill_point()
	assert_eq(t.spend_skill_point().error_code, &"no_skill_points")


func test_spending_with_no_points_fails_and_changes_nothing() -> void:
	var t := ExperienceTrack.new()
	var r := t.spend_skill_point()
	assert_true(r.is_err())
	assert_eq(r.error_code, &"no_skill_points")
	assert_eq(t.unspent_skill_points(), 0)
	t.grant(300, &"q")
	assert_eq(t.unspent_skill_points(), 1)


func test_a_level_up_adds_a_skill_point_on_top_of_the_unspent_ones() -> void:
	var t := ExperienceTrack.new()
	t.grant(300, &"q")
	t.spend_skill_point()
	t.grant(450, &"q")
	assert_eq(t.level(), 3)
	assert_eq(t.unspent_skill_points(), 1)


func test_spending_records_no_event() -> void:
	var t := ExperienceTrack.new()
	t.grant(300, &"q")
	t.drain_events()
	t.spend_skill_point()
	assert_eq(t.drain_events().size(), 0)


func test_eleven_skill_points_at_the_cap() -> void:
	var t := ExperienceTrack.new()
	t.grant(99999, &"cheat")
	assert_eq(t.unspent_skill_points(), 11)


func test_attribute_points_earned_follow_the_level_and_ignore_spending() -> void:
	var t := ExperienceTrack.new()
	t.grant(300, &"q")
	assert_eq(t.attribute_points_earned(), 0)
	t.grant(450, &"q")
	assert_eq(t.level(), 3)
	assert_eq(t.attribute_points_earned(), 1)
	t.spend_skill_point()
	assert_eq(t.attribute_points_earned(), 1)
	t.grant(1350, &"q")
	assert_eq([t.level(), t.attribute_points_earned()], [5, 2])
	t.grant(99999, &"cheat")
	assert_eq(t.attribute_points_earned(), 5)


func test_snapshot_survives_json_round_trip() -> void:
	var t := ExperienceTrack.new()
	t.grant(800, &"q")
	t.spend_skill_point()
	var r := ExperienceTrack.new()
	assert_true(r.restore(JsonRoundTrip.of(t.to_snapshot())).is_ok())
	assert_eq(r.to_snapshot(), t.to_snapshot())
	assert_eq([r.xp(), r.level(), r.unspent_skill_points()], [800, 3, 1])


func test_snapshot_shape() -> void:
	var t := ExperienceTrack.new()
	t.grant(800, &"q")
	t.spend_skill_point()
	assert_eq(t.to_snapshot(), {"xp": 800, "skill_points_spent": 1})


func test_restore_accepts_a_snapshot_that_never_went_through_json() -> void:
	var t := ExperienceTrack.new()
	t.grant(800, &"q")
	t.spend_skill_point()
	var r := ExperienceTrack.new()
	assert_true(r.restore(t.to_snapshot()).is_ok())
	assert_eq(r.to_snapshot(), t.to_snapshot())


func test_restore_replaces_state_and_emits_nothing() -> void:
	var src := ExperienceTrack.new()
	src.grant(300, &"q")
	var r := ExperienceTrack.new()
	r.grant(5000, &"q")
	r.spend_skill_point()
	r.drain_events()
	assert_true(r.restore(JsonRoundTrip.of(src.to_snapshot())).is_ok())
	assert_eq([r.xp(), r.level(), r.unspent_skill_points()], [300, 2, 1])
	assert_eq(r.drain_events().size(), 0)


func test_restore_does_not_touch_pending_events() -> void:
	var t := ExperienceTrack.new()
	t.grant(100, &"q")
	t.restore(JsonRoundTrip.of(ExperienceTrack.new().to_snapshot()))
	assert_eq(t.drain_events().size(), 1)
	assert_eq(t.xp(), 0)

