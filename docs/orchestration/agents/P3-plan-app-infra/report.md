# P3 report: application, infrastructure, content pipeline plan

(Saved by the orchestrator from the agent's hand-back.)

Plan: `docs/superpowers/plans/2026-11-21-app-infra-content-pipeline.md`, 58 tasks (1–57 + 43a), 15 waves, ~1,280 lines.
- W1–3 (no P1/P2 dependency): save domain, ContentDatabase, JsonReader, schema validator, content reader, application events, session aggregates, JSON schemas, JsonContentSource, cross-referencer, save repo, settings/adapters, system data from the gdd tables, fixture content, the Python converter.
- W4: parsers (need P1 rules + P1/P2 definitions), real-content checks, reachability helpers.
- W5–9: GameSession, SessionFactProvider, pump/fixpoint (8 rounds), dispatcher, handlers.
- W10–12: policies, PolicySet, use cases, queries. W13–15: composer, Services + Main.tscn + smoke test, the real content conversion run.

Converter: Python run with `python -I`, vendored PyYAML 6.0.4 with resolvers rebuilt to the YAML 1.2 core schema (tested: `on`, `yes`/`no`, dates, `1:30` stay strings).

Inputs applied: shared EffectSignatures registry via `register(handler)`; EffectParser instance; P1 helpers reused; P1 quest status values; application-owned check modifiers (Task 36); unequip before sell; stage 3 keeps the full condition; P2 contracts (pending_effects drains, dialogue `continue`, DialogueNodeFactory, `faction`, `record_encounter`, `Party.skill_bonus`, `FinaleSetup.configure`); event cards = data in `domain/travel/` + parser + query + use case; pathfinder Wits 5 in the travel use case; IdRules kinds `theory`, `epilogue` in Task 6; §J ops get handlers in Task 43a.

API extensions: `Logger` port → `GameLogger` (Godot ≥4.5 has a native `Logger`); a generic ContentDatabase store (enemies and encounters stay raw records until the vertical-slice plan); non-domain definitions in `application/content/definitions`; new `game_rules.json` (new-game setup, act gates, XP, prices, antidote numbers, rumor price, finale timers); `_source` metadata on records; save sections `SessionLocation`, `ZoneMemory`, `PlayerProfile`; `SaveSchema(required_sections)`; milestones `ms.act1_gate_met`/`ms.act2_gate_met`; `flags/system.json`; TwistResolutionPolicy, ZoneSignalUseCase, ZoneQuery; speaker context on SessionFactProvider.

Gaps/risks: map nodes/edges, encounter tables and epilogue data had no author → the orchestrator assigned them to A08 (`docs/content/world/`); the real-content suite stays red until A08 finishes; the conditional Varn penalty; planner calls: rumor price 5, and "officials" for Kosk's writ = crown or varn faction NPCs; some P2 shapes are assumed (FinaleRecord setters, choice API), so implementers follow the built code; combat XP and combat use cases are deferred to the vertical-slice plan.
