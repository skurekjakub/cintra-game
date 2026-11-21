# Orchestration State — The Lion's Shadow (cintra-game)

Single source of truth for progress. The orchestrator re-reads this file after any context compaction.
Update after every decision, dispatch, and report.

## Working rules (from user, 2026-11-21)
- Orchestrator only coordinates; implementation work goes to subagents.
- Every subagent gets a written brief in `docs/orchestration/agents/<id>/brief.md` and writes its report to `.../report.md`.
- TDD with automated tests; SOLID; small single-responsibility modules; domain-split, loosely coupled.
- Use researched AI tooling: Godot MCP (Coding-Solo, registered), Blender MCP (ahujasid, registered), Godot AI plugin (per-project, pending project creation).
- Goal: a playable game covering the whole story in `story.md`; each section must be fleshed out (design + content).
- **No more questions to the user except the art-style pick. Implement everything autonomously.** (user, 2026-11-21) Brainstorming gate lifted by this opt-out.
- Git: public repo https://github.com/skurekjakub/cintra-game (branch `main`). **Commit sensibly per chunk and push.** Subagents do NOT commit (parallel agents share the tree); the orchestrator verifies each report and commits only that agent's paths, then pushes.

## Phase
**Phase 1 — Design & architecture docs (parallel with art pick).** Domain code may start before the art pick; presentation/asset work waits for it.

## Decisions (user's own words → decision)
| # | Decision | Source |
|---|---|---|
| D1 | Genre: real-time RPG. Ignore tabletop framing (d20, sessions, table mechanics). | user, 2026-11-21 |
| D2 | Engine: Godot 4.7.2 (installed). | user (asked to set up Godot project) |
| D3 | Art direction: choose from 5 options presented in an artifact with visual mockups. | user — PENDING choice |
| D4 | **No time mechanic.** No calendar, day counter, or deadlines. Escalation is driven by story milestones; travel has no time cost; endings depend on choices and outcomes. A real-time ritual meter inside the finale boss fight is allowed (combat, not calendar). A02 told by message. | user, 2026-11-21 |

## Open questions
- Only the art-style pick (D3) remains for the user. Q1 (party vs single) was asked but the user then opted out of questions; resolved as orchestrator call C2.
- IP note: story uses place names from Sapkowski's Witcher setting (Cintra, Attre, Sodden, Brugge, Verden, Mag Turga, Yaruga, Marnadal, drowners). Repo is public at user's request. Characters/plot are original; never use CD Projekt assets/look. Mention to user once.

## Orchestrator calls (my calls, logged for user review)
- C1 Asset strategy: no image-generation tool; assets are procedural (Blender MCP Python / Godot shaders) or CC0 (Poly Haven, Kenney, Quaternius).
- C2 One controllable protagonist (an original character, a hired sword); story companions (Maelis, Dravin, Hesk's war-band, Aldric in finale) are AI-controlled followers for stretches.
- C3 Real-time action combat (light/heavy attack, block, dodge, stamina, crossbow); game pauses only for menus/dialogue.
- C4 World structure: hub-and-zones (discrete scenes per location) with a travel map; travel spends days. Not a seamless open world.
- ~~C5 90-day calendar~~ **REVOKED by user (D4).**
- C6 Tech: Godot 4.7.2 standard (no .NET) → statically typed GDScript. Domain logic in plain RefCounted classes with no scene-tree dependency so it is unit-testable headless. Content is data-driven (versioned data files validated by tests).
- C7 Delivery order: vertical slice (Act I scene 1, the Drowned Rat) end-to-end first, then expand act by act.
- C8 Platform: Windows PC, keyboard+mouse and gamepad.

## Agents
| id | task | status | brief | report |
|---|---|---|---|---|
| A01-art-options | Build 5 art-direction mockup artifact | dispatched | agents/A01-art-options/brief.md | agents/A01-art-options/report.md |
| A02-design-architecture | GDD + architecture + content template | dispatched | agents/A02-design-architecture/brief.md | agents/A02-design-architecture/report.md |

## Artifacts
- (none yet)

## Commits
- c5eaf01 story outline + orchestration state (pushed)

## Next steps
1. A01 returns → show the user the art artifact (only question allowed). Commit docs/art-direction.
2. A02 returns → review, commit docs/design. Then wave 2 in parallel:
   - A03 project setup: Godot project, test framework + headless runner script, Godot AI plugin, folder skeleton, `.mcp.json`, CLAUDE.md for the repo.
   - A04–A07 content writers: act1, act2, act3, side quests (per content-format.md). Also the 90-day calendar/escalation and travel/rumor tables.
3. After A03: writing-plans → implementation plan per domain (docs/plans/), then subagent-driven TDD by domain, starting with the vertical slice.
4. After the art pick: art bible + asset pipeline agent (Blender MCP), presentation layer.
