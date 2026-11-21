## FactProvider port and its FakeFactProvider test double (architecture.md §3.4, §4.2).
extends GutTest


func test_fact_provider_is_abstract() -> void:
	assert_true((FactProvider as Script).is_abstract())


func test_fake_is_a_fact_provider() -> void:
	assert_is(FakeFactProvider.new(), FactProvider)


func test_fake_defaults() -> void:
	var f := FakeFactProvider.new()
	assert_false(f.has_flag(&"flag.x"))
	assert_eq(f.attribute(&"might"), 3)
	assert_eq(f.quest_status(&"quest.main_a1"), FactProvider.QUEST_INACTIVE)
	assert_eq(f.rep_tier(&"faction.crown"), &"neutral")
	assert_eq(f.finale_value(FactProvider.FINALE_OATH), &"none")
	assert_eq(f.act(), 1)


func test_fake_remaining_defaults() -> void:
	var f := FakeFactProvider.new()
	assert_eq(f.get_var(&"var.x"), 0)
	assert_false(f.has_milestone(&"ms.x"))
	assert_eq(f.item_count(&"item.x"), 0)
	assert_false(f.has_clue(&"clue.x"))
	assert_false(f.has_deduction(&"ded.x"))
	assert_eq(f.quest_stage(&"quest.x"), &"")
	assert_eq(f.check_total(&"persuade"), 0)
	assert_eq(f.reputation(&"faction.crown"), 0)
	assert_eq(f.escalation_stage(), 0)
	assert_false(f.in_party(&"companion.x"))
	assert_false(f.has_perk(&"perk.x"))
	assert_eq(f.crowns(), 0)
	assert_eq(f.level(), 1)
	assert_eq(f.finale_value(FactProvider.FINALE_SEIZED), &"false")
	assert_eq(f.finale_value(FactProvider.FINALE_ANSELM), &"alive")
	assert_false(f.visited(&"zone.x"))
	assert_false(f.rumor_heard(&"rumor.x"))
	assert_eq(f.queen_condition(), 0)


func test_fake_returns_configured_values() -> void:
	var f := FakeFactProvider.new()
	f.flags[&"flag.x"] = true
	f.items[&"item.poultice"] = 2
	f.stage = 3
	assert_true(f.has_flag(&"flag.x"))
	assert_eq(f.item_count(&"item.poultice"), 2)
	assert_eq(f.escalation_stage(), 3)


func test_fake_returns_configured_maps() -> void:
	var f := FakeFactProvider.new()
	f.vars[&"var.v"] = 7
	f.milestones[&"ms.m"] = true
	f.clues[&"clue.c"] = true
	f.deductions[&"ded.d"] = true
	f.attributes[&"wits"] = 5
	f.check_totals[&"lore"] = 9
	f.reputations[&"faction.varn"] = -20
	f.rep_tiers[&"faction.varn"] = &"wary"
	f.quest_statuses[&"quest.q"] = FactProvider.QUEST_ACTIVE
	f.quest_stages[&"quest.q"] = &"audience"
	f.party[&"companion.c"] = true
	f.perks[&"perk.p"] = true
	f.visited_zones[&"zone.z"] = true
	f.rumors[&"rumor.r01"] = true
	f.finale[FactProvider.FINALE_ANSELM] = &"fled"
	assert_eq(f.get_var(&"var.v"), 7)
	assert_true(f.has_milestone(&"ms.m"))
	assert_true(f.has_clue(&"clue.c"))
	assert_true(f.has_deduction(&"ded.d"))
	assert_eq(f.attribute(&"wits"), 5)
	assert_eq(f.check_total(&"lore"), 9)
	assert_eq(f.reputation(&"faction.varn"), -20)
	assert_eq(f.rep_tier(&"faction.varn"), &"wary")
	assert_eq(f.quest_status(&"quest.q"), FactProvider.QUEST_ACTIVE)
	assert_eq(f.quest_stage(&"quest.q"), &"audience")
	assert_true(f.in_party(&"companion.c"))
	assert_true(f.has_perk(&"perk.p"))
	assert_true(f.visited(&"zone.z"))
	assert_true(f.rumor_heard(&"rumor.r01"))
	assert_eq(f.finale_value(FactProvider.FINALE_ANSELM), &"fled")


func test_fake_j1_defaults_and_configured_values() -> void:
	var f := FakeFactProvider.new()
	assert_false(f.is_equipped(&"item.x"))
	assert_false(f.is_disguised())
	assert_false(f.heard_from(&"rumor.x", &"npc.x"))
	assert_false(f.map_unlocked(&"map.x"))
	assert_false(f.map_pinned(&"map.x"))
	f.equipped_items[&"item.x"] = true
	f.disguised_value = true
	f.heard_sources[&"rumor.x"] = [&"npc.x"]
	f.unlocked_maps[&"map.x"] = true
	f.pinned_maps[&"map.y"] = true
	assert_true(f.is_equipped(&"item.x"))
	assert_true(f.is_disguised())
	assert_true(f.heard_from(&"rumor.x", &"npc.x"))
	assert_false(f.heard_from(&"rumor.x", &"npc.y"))
	assert_true(f.map_unlocked(&"map.x"))
	assert_false(f.map_pinned(&"map.x"))
	assert_true(f.map_pinned(&"map.y"))


func test_fake_returns_configured_scalars() -> void:
	var f := FakeFactProvider.new()
	f.act_value = 2
	f.crowns_value = 120
	f.level_value = 4
	f.queen_value = 2
	assert_eq(f.act(), 2)
	assert_eq(f.crowns(), 120)
	assert_eq(f.level(), 4)
	assert_eq(f.queen_condition(), 2)


func test_quest_and_finale_constants() -> void:
	assert_eq(FactProvider.QUEST_INACTIVE, &"inactive")
	assert_eq(FactProvider.QUEST_ACTIVE, &"active")
	assert_eq(FactProvider.QUEST_COMPLETED, &"completed")
	assert_eq(FactProvider.QUEST_FAILED, &"failed")
	assert_eq(FactProvider.FINALE_SEIZED, &"seized")
	assert_eq(FactProvider.FINALE_OATH, &"oath")
	assert_eq(FactProvider.FINALE_ANSELM, &"anselm")
