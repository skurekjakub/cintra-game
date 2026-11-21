# Brief P1 — Plan: core rules and state domains

Follow `docs/orchestration/agents/_planner-common.md`.

Plan slug: `core-state-domains`.

Scope: the pure domain layer for these architecture.md §4 domains: `rules` (the condition language and effect specs; §3.4 and §4.2), `world_state` (§4.3), `escalation` (§4.4), `actors` (§4.11), `inventory` (§4.12), `progression` (§4.13), `factions` (§4.14), `rumors` (§4.17). Also the shared kernel additions these need that A03 did not build: `FactsChanged` and `ScriptedRandom` (see A03's report at `docs/orchestration/agents/A03-project-setup/report.md`, "Not yet created").

Out of scope (other planners): quests, investigation, dialogue, companions, endings, finale, travel, combat, save, and the application, infrastructure and presentation layers.

The condition language and effect specs must match `docs/design/content-format.md` §C and §E exactly; content writers are already authoring against them.
