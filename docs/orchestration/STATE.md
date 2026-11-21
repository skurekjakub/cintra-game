# Orchestration State — The Lion's Shadow (cintra-game)

Single source of truth for progress. The orchestrator re-reads this file after any context compaction.
Update after every decision, dispatch, and report.

## Working rules (from user, 2026-11-21)
- Orchestrator only coordinates; implementation work goes to subagents.
- Every subagent gets a written brief in `docs/orchestration/agents/<id>/brief.md` and writes its report to `.../report.md`.
- TDD with automated tests; SOLID; small single-responsibility modules; domain-split, loosely coupled.
- Use researched AI tooling: Godot MCP (Coding-Solo, registered), Blender MCP (ahujasid, registered), Godot AI plugin (per-project, pending project creation).
- Goal: a playable game covering the whole story in `story.md`; each section must be fleshed out (design + content).

## Phase
**Phase 0 — Brainstorming / design (HARD GATE: no project scaffolding or product code until the user approves the written design).**

## Decisions (user's own words → decision)
| # | Decision | Source |
|---|---|---|
| D1 | Genre: real-time RPG. Ignore tabletop framing (d20, sessions, table mechanics). | user, 2026-11-21 |
| D2 | Engine: Godot 4.7.2 (installed). | user (asked to set up Godot project) |
| D3 | Art direction: choose from 5 options presented in an artifact with visual mockups. | user — PENDING choice |

## Open questions (to ask user, one at a time)
- Q1: single protagonist vs controllable party/companions — ASKED 2026-11-21
- Q2: camera/perspective (likely answered by art choice)
- Q3: scope/length expectation, combat feel, save system, platform (PC only?)
- Q4: IP note — story uses place names from Sapkowski's Witcher setting (Cintra, Attre, Sodden, Brugge, Verden, Mag Turga, Yaruga, Marnadal, drowners). Fine for a personal project; flag before any public release.

## Orchestrator calls (my calls, not user-approved yet)
- Asset strategy: no image-generation tool available; assets must be procedural (Blender MCP scripts / Godot shaders) or CC0 (Poly Haven, Kenney, Quaternius). Art options are rated on feasibility for that.

## Agents
| id | task | status | brief | report |
|---|---|---|---|---|
| A01-art-options | Build 5 art-direction mockup artifact | dispatched | agents/A01-art-options/brief.md | agents/A01-art-options/report.md |

## Artifacts
- (none yet)

## Next steps
1. Get Q1 answer; continue brainstorming playback.
2. User picks art direction from A01 artifact.
3. Write design doc `docs/superpowers/specs/2026-11-21-lions-shadow-design.md`; builder-check subagent; user approval.
4. Then: writing-plans skill → implementation plan → subagent-driven TDD execution.
