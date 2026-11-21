## FactsChanged: the event a use case publishes after changing facts (architecture.md §3.2).
extends GutTest


func test_is_domain_event_with_source() -> void:
	var e := FactsChanged.new(&"use_case.pick_up")
	assert_is(e, DomainEvent)
	assert_eq(e.source, &"use_case.pick_up")


func test_source_defaults_empty() -> void:
	assert_eq(FactsChanged.new().source, &"")
