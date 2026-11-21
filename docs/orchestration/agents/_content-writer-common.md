# Common brief — content writers (A04–A07)

You flesh out one slice of the story into game-ready section documents. Four writers run in parallel, one per slice.

## Read first (binding)
- `story.md` — the source outline. It was written as a tabletop campaign; the game is a real-time RPG. Translate tabletop mechanics into game systems.
- `docs/design/gdd.md` — systems, zones per act, act gates, endings, escalation stages. **There is no time mechanic** (no calendar, days, or deadlines); escalation is milestone-driven (gdd §6.1).
- `docs/design/content-format.md` — the template you MUST follow: block schemas, condition language, effects, the shared ids in §G, and the writer checklist in §I.
- `docs/design/architecture.md` §8 (ids) for context.

## What "fleshed out" means
Every section the GDD lists for your slice gets its own file, following content-format.md exactly, with:
- a full location layout a level builder can block out: areas, entrances and exits, cover, hazards, points of interest;
- every NPC with motive, secret, voice notes and barks;
- complete dialogue trees with real lines, not summaries. Investigation scenes need multiple approaches (persuade, intimidate, bribe, evidence, item, faction rep), with checks using the content-format condition language;
- encounters with enemy ids, counts, triggers, waves, and any non-combat alternative;
- items, clues and deductions; the flags set and read; milestones; quest stages;
- failure and branch states, so nothing soft-locks and every branch lands somewhere;
- tone: low-magic dark fantasy, muddy, political, cruel. Monsters are displaced predators or leftover weapons. Keep the story's names, plot truths, and the Oath text verbatim.

You may invent supporting detail (minor NPCs, lines, layouts, small items) consistent with the story and GDD. You must NOT change plot truths in story.md or decisions in the GDD. If something in the GDD seems wrong or contradictory, follow it and log the issue in your report.

## Ids and coordination
- Use the shared ids from content-format.md §G. Never rename them.
- Every NEW id you introduce that another slice might reference (items, flags, milestones, NPCs, factions, enemies) goes in `docs/content/<your-slice>/_ids.md`, as a table with columns id / kind / defined in / meaning. A reconciliation pass merges these later.
- Every id from another slice that you need but that doesn't exist in §G goes under "Expected from other slices" in the same `_ids.md` file.

## Output location and files
- `docs/content/<slice>/NN-<section-slug>.md`, one per section, plus `docs/content/<slice>/_index.md` listing the files in play order with a one-line summary each, plus `_ids.md`.
- Write only inside your own slice folder.
- Run the content-format §I checklist on every file before finishing.

## Rules
- Do NOT commit. Do not touch files outside your slice folder except your own report.
- If a write is blocked, put the content in your final reply.

## Report
`docs/orchestration/agents/<your-id>/report.md`: files written, word count, new ids count, GDD issues found, and open questions you resolved yourself (with your choice). Reply to the orchestrator in two lines at most.
