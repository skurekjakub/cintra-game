# Brief P2 — Plan: narrative and flow domains

Follow `docs/orchestration/agents/_planner-common.md`.

Plan slug: `narrative-domains`.

Scope: the pure domain layer for these architecture.md §4 domains: `quests` (§4.5), `investigation` (§4.6), `dialogue` (§4.7), `companions` (§4.16), `travel` (§4.15, including the encounter roll and the escalation swap rule), `finale` (§4.9, the real-time ritual meter, driven by `delta`), `endings` (§4.10, the resolver for all 5 endings, with a test proving each is reachable and the conditions exclusive or prioritised per gdd §6.15).

These domains consume `rules` (conditions and effects), `world_state`, and `shared`, which planner P1 is planning in parallel from the same architecture.md sketches. Reference those APIs exactly as architecture.md §3.4, §4.2 and §4.3 define them. Add a "Consumes from P1" list at the top naming every P1 class and method you rely on.

Dialogue node, choice and check structures must match `docs/design/content-format.md` §D and §F.3; quest and clue structures must match §F.6 and §F.7.

Out of scope: rules, world_state, escalation, actors, inventory, progression, factions, rumors (P1); combat and save; the application, infrastructure and presentation layers.
