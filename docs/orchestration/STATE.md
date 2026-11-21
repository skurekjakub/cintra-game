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
| D3a | **Art style = HD-2D like the user's reference screenshot** (`image.png`, a commercial game frame; style only, gitignored, never publish). Pixel-art sprite characters in a detailed, lit 3D world; high 3/4 top-down camera; purple ambient + warm torch pools; bloom, DOF, vignette; ornate gothic HUD. All 5 canvas options were rejected ("all of those look like crap"). Proof via a real Godot render spike (A09) + `docs/design/art-bible.md`. | user, 2026-11-21 |
| D5 | **Implementation runs SEQUENTIALLY**: one implementer subagent at a time (plus its reviewer), no parallel fan-out of implementers. Plan "waves" are just ordering. | user, 2026-11-21 |
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
| A01-art-options | Build 5 art-direction mockup artifact | DONE, committed 8812c02. Awaiting user pick | agents/A01-art-options/brief.md | agents/A01-art-options/report.md |
| A02-design-architecture | GDD + architecture + content template | DONE (report saved by orchestrator; agent's write was blocked) | agents/A02-design-architecture/brief.md | agents/A02-design-architecture/report.md |
| A03-project-setup | Godot project in game/, GUT, tools/test.ps1, shared kernel + event bus (TDD), architecture test, Godot AI plugin, CLAUDE.md, README | DONE 8f426ef (53 tests green, re-verified). godot-ai moved to LOCAL scope by orch (no .mcp.json in public repo) | agents/A03-project-setup/brief.md | agents/A03-project-setup/report.md |
| A04-content-act1 | Act I sections (01-drowned-rat = vertical slice) | DONE 708d63f (issues list in report → A08) | agents/A04-content-act1/brief.md | agents/A04-content-act1/report.md |
| A05-content-act2 | Act II sandbox sections + twist | dispatched | agents/A05-content-act2/brief.md | agents/A05-content-act2/report.md |
| A06-content-act3 | Act III + finale + endings | DONE 82ef406 (issues + reconciliation list in report → A08) | agents/A06-content-act3/brief.md | agents/A06-content-act3/report.md |
| A07-content-side | 12 side quests, travel events, rumors | DONE f246017 (format issues listed in report → A08) | agents/A07-content-side/brief.md | agents/A07-content-side/report.md |

| P1-plan-core-state | Plan: rules, world_state, escalation, actors, inventory, progression, factions, rumors (+FactsChanged, ScriptedRandom) | DONE c68afe8 | agents/P1-plan-core-state/brief.md | agents/P1-plan-core-state/report.md |
| P2-plan-narrative | Plan: quests, investigation, dialogue, companions, travel, finale, endings | DONE 0a40369 (gated on P1 tasks 1,2,5,6,13,14) | agents/P2-plan-narrative/brief.md | agents/P2-plan-narrative/report.md |
| P3-plan-app-infra | Plan: save, application layer, infra, composer/Services/Main.tscn, md→JSON converter, content validation tests | dispatched | agents/P3-plan-app-infra/brief.md | (in final msg → save) |

Common planner brief: agents/_planner-common.md. Plans → docs/superpowers/plans/2026-11-21-*.md. Execution: subagent-driven-development, ONE task at a time (D5): implementer → reviewer → orchestrator commits → next task.
| A09-art-spike | HD-2D Godot render spike (Drowned Rat + Karak Ostrel shots, 3+ iterations) + art-bible.md | dispatched | agents/A09-art-spike/brief.md | (final msg → save) |

## Implementation runs
| Plan | Worktree / branch | Ledger | Status |
|---|---|---|---|
| core-state-domains (P1, 21 tasks) | `.worktrees/core-state` / `feat/core-state` (base e141bef) | `.worktrees/core-state/.superpowers/sdd/2026-11-21-core-state-domains/progress.md` | pre-flight scan running |

Note: the harness moved the orchestrator's working directory into the worktree. Main-checkout commits (content, art, plans) use `git -C C:\Users\skure\repositories\cintra-game ...`.

## Roadmap
- M1 Foundations: P1 → P2 → P3 plans executed (P3 waves gated on P1/P2 classes). Content reconciliation (A08) in parallel.
- M2 Vertical slice: (needs art pick) art bible + asset pipeline, combat domain + presentation, the Drowned Rat playable end to end.
- M3 Act I complete → M4 Act II → M5 Act III + endings → M6 side quests, polish, export.

Common content-writer brief: agents/_content-writer-common.md. Writers log new cross-slice ids in docs/content/<slice>/_ids.md → needs a reconciliation agent after all four finish.

## Key design facts (from A02; details in docs/design/)
- Godot project lives in `game/`. Content = JSON (converted from docs/content markdown via a converter spec'd in content-format.md §H; converter has NO owner yet).
- Test: GUT 9.7.1; `tools/test.ps1` (A03). Always use 4.7.2 exe via $env:GODOT; PATH `godot` may be 4.7.0.
- Escalation stage 0–4, milestone-driven. Act II gate = antidote line resolved + proof + true verse.
- Only autoload: `Services`. Composition root injects everything else. Architecture test enforces layers + 300-line cap.

## Artifacts
- Art options: https://claude.ai/artifact/NAEiH8W5Fuz9ihX3chUVze (src docs/art-direction/art-options.html). 1 Lantern Diorama (iso low-poly), 2 Woodcut Chronicle (engraving shader), 3 Lo-Fi Dread (late-90s 3D), 4 Grim Naturalism (scans), 5 Illuminated Manuscript (2D).

## Harness note
Subagents cannot write report .md files (harness block). They return the report in their final message and the orchestrator saves it to agents/<id>/report.md.

## Commits
- c5eaf01 story outline + orchestration state (pushed)
- 5ea1127 GDD, architecture, content format (pushed)

## Next steps
1. A01 returns → show the user the art artifact (only question allowed). Commit docs/art-direction.
2. Wave 2 running (A03–A07). As each returns: verify, commit its paths only, push, and update this table.
3. After A04–A07: A08 id reconciliation + content review; A09 markdown→JSON converter (TDD) + content validation tests.
4. After A03: writing-plans → implementation plan per domain (docs/plans/), then subagent-driven TDD by domain, starting with the vertical slice (01-drowned-rat).
4. After the art pick: art bible + asset pipeline agent (Blender MCP), presentation layer.
