# Brief P3 — Plan: application, infrastructure, content pipeline, save

Follow `docs/orchestration/agents/_planner-common.md`.

Plan slug: `app-infra-content-pipeline`.

Scope:
- The `save` domain (§4.18): snapshot and restore across domains through `Snapshotable`.
- The application layer (§5): `GameSession`, ports, use cases, policies, queries, and the rule re-evaluation fixpoint (capped at 8 rounds).
- The infrastructure layer (§6): JSON content loader plus typed parsers per content kind, save-file adapter, and the Godot adapters named in §6.
- The composition root (`GameComposer`, `GameContext`) and the `Services` autoload (§3.3), plus a minimal `Main.tscn` boot scene that composes the game and shows a placeholder.
- The **markdown→JSON content converter** in `tools/content_convert/` (content-format.md §H). Pick the converter's language and justify it (GDScript run headless, or Python run with `python -I`; no third-party packages unless vendored), and test it TDD with fixtures.
- Content validation tests (§9.4): ids resolve, quests completable, act gates passable, endings reachable, no effect cycles.
- `content_version.json` and save versioning (§8.3).

The domain APIs come from planners P1 (rules, world_state, escalation, actors, inventory, progression, factions, rumors) and P2 (quests, investigation, dialogue, companions, travel, finale, endings), who plan in parallel from the same architecture.md sketches. Reference their APIs exactly as architecture.md defines them. Add a "Consumes from P1/P2" list. Order the waves so that work needing a P1 or P2 class is marked with that dependency. The orchestrator schedules it after the class exists.

Out of scope: combat and the presentation layer beyond Main.tscn (that is the vertical-slice plan, which waits for the art pick).
