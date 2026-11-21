# Orchestration State — The Lion's Shadow (cintra-game)

## >>> RESUME HERE AFTER COMPACTION (snapshot 2026-11-21, night) <<<
The orchestrator works from the main checkout `C:/Users/skure/repositories/cintra-game` (branch main). The core-state worktree is merged, so remove it once nothing needs its ledger.

**Done:**
- **P1 core domain layer, MERGED to main** (b5d29c4, 512 tests, lint clean).
  - Final review rulings FR-1..FR-8 are in the ledger `.worktrees/core-state/.superpowers/sdd/2026-11-21-core-state-domains/progress.md`.
  - Extra tasks done: J1 (§J.1 conditions), R1 (`restore() -> Result`), J6 (§J.6 item mods).
  - P2/P3 carry-forwards: the section "P1 final review" at the end of this file.
- **A10 environment:** 6 rounds, env-r6.png, committed fa801e4. Not yet at Elliot level: sparse play area, blurry far wall and foreground, 35 fps against a 60 target.
- **Skill `crafting-game-assets`:** TDD done over 2 rounds; see `docs/skill-tests/crafting-game-assets/RESULTS.md`.
  - Round 1: the method-stacking skill FAILED (the baseline won, the full skill came last).
  - Round 2: the rewritten skill (game-scale spec, `audit_sprite.py` gates, an INDEPENDENT critic run by the orchestrator) won 34 against 29/28/23.
  - The critic round is the main lever.

**In flight:**
- **A14, Hale witcher still sprite** (opus, agent a91faf1a23453c3c9, brief `docs/orchestration/agents/A14-hale-sprite/brief.md`). When it reports: run 2 independent critic rounds, each critic given the spec, and rule on any conflicts with numbers. Relay the critiques to A14 via SendMessage. Then animate him (an A12-style brief).
- **Waiting on the user:** feedback on the Bertha animation (dda3332, clips in `docs/art-direction/spike/bertha-*`). Is the idle too subtle? Is a front-only walk acceptable, or do they want angled directions?

**Done this session (late):**
- A12: Bertha idle + walk, lit in scene (dda3332).
- A13: D8 witcher revision (2b8cace). Its action items:
  - the `blame` id kind;
  - a stigma domain and save section before P4;
  - the content-format status line;
  - the rewrite wave for the other 39 sections, using the `story-witcher.md` table.

**Next (in order):**
1. **Art queue:**
   - A11 lighting/post TD: 60 fps, fill the play area, design the far wall and foreground.
   - A12 sprite animator: player, Bertha, enemies; idle/walk/attack sheets using the skill loop (artist → 2 independent-critic rounds → gates → blind check in the scene).
2. **Vertical slice:** write P4, the Drowned Rat slice plan. It covers the P2/P3 subset the slice needs, combat, and the HD-2D presentation. Execute it sequentially, then STOP for the user's visual refinement (D6).
3. **Later:** the deferred P1 tasks (16, 19, 20, 21), the full P2/P3 plans, and the XP rebalance.

**User constraints recap:** no questions except art; orchestrator only; sequential implementation; stop at the vertical slice (D6) for visual refinement; triple-A visual bar (orchestrator gates every render); commit per chunk and push; Elliot = target look (fully 3D world + pixel sprites), Aldermere = proof code-made sprites can be great.

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
| D6 | **STOP at the first vertical slice** (the Drowned Rat playable end to end) so the user can refine the visuals before the rest of the game is built. Build only what the slice needs; no full-game P2/P3 execution before the user signs off on the slice. | user, 2026-11-21 |
| D7 | The skill experiment is **primarily about pixel-art generation**. Player and character sprites **stay sprites**. A real **3D asset modelling pipeline** (Blender, for environment and props, replacing placeholder assets) is likely later, as its own bootstrap. The barrel arm (D0/D1) is a side probe that feeds that later pipeline, not the focus. That pipeline's core job is to **lock one art direction (asset style and post-processing) and reproduce it faithfully across a wide variety of assets**, so it needs a style guide, a shared material and lighting kit, and a consistency gate, not one-off hero assets. | user, 2026-11-21 |
| D8 | **The protagonist is a WITCHER, and the whole story is him being treated like dirt for it** ("the main character shud be a witcher obviously, and the entire story should be him getting shit on for being a witcher, duh"). He is an original witcher: not Geralt, and nothing of CDPR's named characters, schools or quests. Prejudice becomes a real system ("witcher stigma"), plus a story-spine rewrite and a full rewrite of the slice. A13 does the design, the spine, the slice and a per-section work order. The other 39 sections are rewritten in a later wave. The player sprite becomes a witcher (A12, after Bertha). | user, 2026-11-21 |
| D3b | Reference game identified: **The Adventures of Elliot: The Millennium Tales** (Square Enix 2025, HD-2D, UE). Technique: fully 3D world + pixel characters, "rolling cylinder" world curve, character/VFX lights, DOF. Refs saved locally in docs/art-direction/reference/ (gitignored). | orchestrator research, 2026-11-21 |
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
| A05-content-act2 | Act II sandbox sections + twist | DONE 23af503 (issues in report → A08) |
| A08-content-reconcile | Cross-slice id reconciliation, apply orchestrator rulings, content-format §J addendum, _registry.md, balance note | DONE f84f301 (0 errors/40 files; world/ map + tables; XP is ~3.5× over budget → rebalance after the slice) | agents/A08-content-reconcile/brief.md | (final msg → save) | agents/A05-content-act2/brief.md | agents/A05-content-act2/report.md |
| A06-content-act3 | Act III + finale + endings | DONE 82ef406 (issues + reconciliation list in report → A08) | agents/A06-content-act3/brief.md | agents/A06-content-act3/report.md |
| A07-content-side | 12 side quests, travel events, rumors | DONE f246017 (format issues listed in report → A08) | agents/A07-content-side/brief.md | agents/A07-content-side/report.md |

| P1-plan-core-state | Plan: rules, world_state, escalation, actors, inventory, progression, factions, rumors (+FactsChanged, ScriptedRandom) | DONE c68afe8 | agents/P1-plan-core-state/brief.md | agents/P1-plan-core-state/report.md |
| P2-plan-narrative | Plan: quests, investigation, dialogue, companions, travel, finale, endings | DONE 0a40369 (gated on P1 tasks 1,2,5,6,13,14) | agents/P2-plan-narrative/brief.md | agents/P2-plan-narrative/report.md |
| P3-plan-app-infra | Plan: save, application layer, infra, composer/Services/Main.tscn, md→JSON converter, content validation tests | DONE 27620bf (58 tasks, 15 waves; W1–3 independent of P1/P2) | agents/P3-plan-app-infra/brief.md | agents/P3-plan-app-infra/report.md |

Common planner brief: agents/_planner-common.md. Plans → docs/superpowers/plans/2026-11-21-*.md. Execution: subagent-driven-development, ONE task at a time (D5): implementer → reviewer → orchestrator commits → next task.
| A10-env-artist | Rebuild the Drowned Rat environment to shipped-HD-2D quality (Blender bespoke architecture, plank floor, Poly Haven props, dressing, depth layers, shafts, grade), ≥6 rounds with env-log.md critiques | dispatched (opus) | agents/A10-env-artist/brief.md | (final msg → save) |
| — | Art specialist queue after A10: A11 lighting/post TD → A12 sprite animator (Hale attack/walk, warden, Maelis, thugs) | queued | | |
| A09-art-spike | HD-2D Godot render spike — DONE 4ef40da (handoff; below the bar: toy props, tiled-box floor, dark walls, no shafts, no animations). Earlier status:  (Drowned Rat + Karak Ostrel shots, 3+ iterations) + art-bible.md | running; the user saw r1 and was unhappy → detailed critique sent (too dark, tiny unreadable chars → CC0 KayKit/Quaternius rigs at 96–128 px, invisible floor ornament, camera too far, blown bloom, blob props, crude portrait). Quality over speed; compare-*.png side by side (gitignored). 2nd ref (forest combat) saved at docs/art-direction/reference/ref-02-forest-combat.png (gitignored; image.png was overwritten, so ref-01 survives only in A09's notes). USER CORRECTION: the world is FULLY 3D rendered (smooth, detailed materials); ONLY characters are pixel sprites (my "pixel textures on the world" read was wrong and was retracted). Also: strong tilt-shift DOF, volumetric fog and particles. A09 may download web HD-2D refs into reference/ for local study | agents/A09-art-spike/brief.md | (final msg → save) |

## Visual quality gate (user, 2026-11-21): "I refuse to accept any other prototype than something that looks just as production triple-A quality"
- The orchestrator reviews every render against the Elliot and Aldermere refs before the user sees anything. Anything below a shipped-HD-2D level is rejected and sent back with a written critique. No "work in progress" shows to the user.
- If A09 stalls or its context degrades, split the art into fresh specialist agents run in sequence: (1) character sprite artist, (2) environment modeller (Blender), (3) lighting and post TD (Godot), each with a focused brief and the reference set.

## Sprite pipeline (user: sprites are "trash", "absolute disaster", 2026-11-21)
- Stopped primitive/hand-coded sprites.
- Path A (running in A09): CC0 rigged models (KayKit Adventurers/Skeletons, Quaternius) → Blender ortho render at the target pixel size with closest filtering, toon bands + rim, fixed-palette quantization, 1-px outline, 8 directions → sheets + JSON. First deliverable: `docs/art-direction/spike/char-player-test.png`.
- **Path C, now PRIMARY:** hand-authored palette-indexed pixel maps in code, compiled to PNG sheets. Proof: "Lanterns of Aldermere" (Claude Code, one prompt, all sprites generated in code; refs at docs/art-direction/reference/ref-aldermere-*.png). Craft rules sent: chibi proportions, hue-shifted ramps, selective coloured outlines, top-left light, distinct silhouettes, manual anti-aliasing, idle/walk/attack/hurt sets. Iterate the player idle ≥3× before anything else.
- Path A is now the fallback.
- Path B (pending the user's key): PixelLab MCP (`npm i -g pixellab-mcp`, `PIXELLAB_SECRET`, tools pixflux/bitforge/rotate/animate_with_text). Paid credits (pixellab.ai). Asked the user for a key.

## Implementation runs
| Plan | Worktree / branch | Ledger | Status |
|---|---|---|---|
| core-state-domains (P1, 21 tasks) | `.worktrees/core-state` / `feat/core-state` (base e141bef) | `.worktrees/core-state/.superpowers/sdd/2026-11-21-core-state-domains/progress.md` | pre-flight done (21 rulings, all accepted); Task 1 running |

P1 pre-flight rulings that change names P2/P3 consume: `ExperienceTrack.attribute_points_earned()` (not unspent_attribute_points), `FakeFactProvider.reputations` field, `ConditionValue.VALUE_INT/VALUE_TIER/VALUE_WORD`, `EscalationStageChanged(old_stage, new_stage)`, `FactsChanged` in `shared/events/`, the `JsonRoundTrip` test helper. Carry these into the P2/P3 dispatches.

Note: the harness moved the orchestrator's working directory into the worktree. Main-checkout commits (content, art, plans) use `git -C C:\Users\skure\repositories\cintra-game ...`.

## Roadmap (revised for D6 — stop at vertical slice)
1. P1 core-state: Tasks 1–15, 17, 18 (16, 19, 20, 21 deferred).
2. P4 vertical-slice plan (write after A09 delivers the art bible): the slice subset of P2 (dialogue, quests) and P3 (converter + loader for act1/01, session, save), plus the combat domain and the HD-2D presentation of the Drowned Rat (taproom, yard/mudflats).
3. Execute P4 sequentially → playable slice → **STOP and hand to the user for visual refinement.**
4. Only after sign-off: the rest of P1/P2/P3 and the acts.

## Old roadmap (superseded)
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

## P1 final review (opus, 2026-11-21): READY AFTER FIXES. Carry-forwards for P2/P3
Rulings FR-1 to FR-8 are in the core-state ledger. The fix wave is running, then task R1-restore (`restore()` returns Result, reject policy), then J6-items, then merge.

**P2:**
- Correct the `Party.skill_bonus` note: CheckTotals cannot reference companions, so P3 SessionFactProvider owns it.
- CheckResolver must not add rep_mod to attribute checks (§J.1). Use `RepTiers.rep_mod`.
- New aggregates use the R1 `restore() -> Result` contract.
- EndingFactProvider covers all 27 FactProvider methods.

**P3:**
- SessionFactProvider and OptimisticFactProvider map the five §J.1 methods. `is_disguised` needs `ZoneDefinition.disguise_tag` plus equipment and inventory, and is not designed yet. ReachableFacts needs a key scheme for the two-argument `heard_from`.
- Effect handlers:
  - `give_item` hitting `stack_full` is a no-op;
  - `take_item` of an item not held is a no-op, and a partial take is `remove(id, mini(n, count), true)`;
  - unequip before the last copy leaves;
  - `add_crowns(-N)` calls `spend(N)`, pre-checked or rolled back by snapshot.
- `start_encounter` takes two arguments (needs FR-2), so the composer test expects the changed spec.
- Load copies aggregates as a group: Equipment and QuickSlots hold their Inventory, and ActorSheet holds the XP callable.
- The fingerprint must sort keys, because snapshot dictionaries keep insertion order.
- `IdRules.KINDS` gets `theory` and `epilogue`.
- QuickSlots has no outbox (M8).
- `quest_stage` words are not cross-referenced (M7).
