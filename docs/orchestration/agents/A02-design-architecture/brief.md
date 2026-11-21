# Brief A02 — Game design doc + architecture

## Goal
Produce two documents that every later implementation and content agent will build from:
1. `docs/design/gdd.md` — Game Design Document.
2. `docs/design/architecture.md` — software architecture.
3. `docs/design/content-format.md` — the template content writers fill in per story section, mapping narrative to the data the game loads.

Documents only. Do not create the Godot project or write product code. Do not commit (the orchestrator commits).

## Inputs
- `story.md` (repo root): the story outline. It was written as a tabletop campaign; the game is a **real-time RPG**. Drop tabletop mechanics (d20 tables, sessions, candles on the table) and translate them into real-time game systems (for example, the finale's four candles become a timed four-stage ritual meter).
- `docs/orchestration/STATE.md`: decisions D1–D3 and orchestrator calls C1–C8. These are binding. Art direction (D3) is not chosen yet, so keep the GDD and architecture camera- and art-agnostic. Note where the art pick plugs in.

## GDD must cover
- Pillars (3–4), player fantasy, core loop (moment-to-moment, per-zone, per-day/calendar, per-act).
- Systems, each with rules concrete enough to implement and test: calendar/clock and escalation thresholds; Queen's health track; travel (map, days spent, encounter rolls by terrain, escalation rule under 30 days); combat (player moveset, stamina, damage, enemy archetypes from the story: thugs, feral hounds, assassins, wyvern, revenants, drowners, wolves, frost trolls, soot-hound/war-construct, iron-wardens, Choir zealots, Ash-Bound Zealot boss); progression (levels 1–12, XP sources, a small skill tree); inventory and key items (Iron-Key, torc, cipher, ledger, antidote, bulbs, Mane-Cleaver, etc.); dialogue (branching, skill/item/flag checks, persuasion/intimidation/bribe); quests and journal (main + 12 side quests, clue tracking for the investigation); factions and reputation (Crown/Kosk, Varn, Attre/Raimund, Strept/Hesk, Ferrymen/Jory, Pale Choir, Abbey/Maelis, Wenna); companions; rumors; endings resolver (5 endings from story §9 as explicit boolean conditions); save/load; difficulty and accessibility basics.
- Structure: a list of every zone/scene per act, with the act gates (Act II needs antidote + proof + true verse).
- Scope tiers: what the vertical slice contains (Act I scene 1, Drowned Rat ambush and escape over the mudflats) versus the full game.

## Architecture must cover
- Layers: `domain/` (pure, engine-light typed GDScript RefCounted, no Node/scene-tree use, fully unit-tested), `application/` (use cases and orchestration services), `infrastructure/` (save files, data loading, Godot adapters), `presentation/` (scenes, UI, input, VFX). Dependency rule: inward only.
- Bounded domains with explicit public interfaces and no cross-domain internals: e.g. `calendar`, `world_state/flags`, `quests`, `dialogue`, `combat`, `actors/stats`, `inventory`, `progression`, `factions`, `travel`, `endings`, `save`. For each, list its responsibility, public API sketch (class names and methods), the events it emits and consumes, and what it must not know about.
- Communication: a typed event bus (signals) or mediator; dependency injection via a composition root (no global singletons except one thin service-locator autoload if justified; explain).
- Data: content stored as data files (pick JSON or Godot `.tres` Resources and justify; IDs as stable string keys), loaded by an infrastructure loader, validated by schema tests.
- Testing strategy: test framework choice for Godot 4.7 (research GUT vs GdUnit4 current support; pick one with justification and the headless CLI command that runs it); unit tests per domain; content validation tests (every referenced ID exists, every quest completable, every ending reachable); integration tests for use cases; a few scene smoke tests. TDD workflow expectations for implementers.
- Folder layout for the Godot project (`res://src/<layer>/<domain>/...`, `res://tests/...`, `res://content/...`, `res://assets/...`, `res://addons/...`).
- Coding standards: static typing everywhere, file and class naming, one class per file, maximum file size guideline, SOLID notes specific to GDScript.
- Tooling: Godot MCP (Coding-Solo, registered globally; runs the project and reads errors), Godot AI plugin (hi-godot/godot-ai, per-project addon in `addons/godot_ai/`, live editor control; needs Godot 4.7+ and uv), Blender MCP (asset creation). Describe how implementers use each.

## content-format.md must define
A per-section template (markdown with structured blocks) covering: scene summary, location layout, NPCs present with motives, dialogue trees (nodes, choices, conditions, effects), encounters (enemy IDs, counts, triggers), items and clues, flags set and read, calendar cost, quest hooks, failure states and branches. Writers will produce `docs/content/act1/01-drowned-rat.md` and so on. A later conversion step turns these into data files, so make the template unambiguous.

## Report
Write `docs/orchestration/agents/A02-design-architecture/report.md`: files produced, key decisions (with one-line rationale each), test framework choice + run command, and open risks. Reply to the orchestrator in two lines at most.
