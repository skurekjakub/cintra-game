# Common brief — planners (P1–P3)

You write ONE implementation plan for a subsystem of The Lion's Shadow (Godot 4.7.2, typed GDScript, GUT 9.7.1). Implementer subagents execute your plan task by task with TDD. Each implementer sees only their own task plus the plan header, so the plan carries every decision they cannot make alone.

## Read first
1. The writing-plans skill: `C:\Users\skure\.claude\plugins\cache\claude-plugins-official\superpowers\7.0.0\skills\writing-plans\SKILL.md`. Follow its header, task structure, step granularity, self-review and proportion rules exactly. Ignore its "Execution Handoff" section: execution is already decided (subagent-driven), and the orchestrator handles it.
2. `CLAUDE.md` (repo root): commands, layer rules, coding standards, file caps.
3. `docs/design/architecture.md` (binding spec): use its API sketches, class names, event names, folder paths and id rules **verbatim**. Other planners are planning neighbouring subsystems in parallel against the same sketches, so do not rename or re-shape a public API. If a sketch is incomplete, extend it minimally and list the extensions under "API extensions" at the top of your plan.
4. `docs/design/gdd.md`: the rules and numbers. Copy exact values into the tests.
5. The existing code in `game/src/` and `game/tests/` (shared kernel, EventBus, test helpers, the architecture test). Build on it.

## Plan rules
- Save to `docs/superpowers/plans/2026-11-21-<plan-slug>.md`.
- Commit steps: write them as `git add <paths>` + the commit message only. The implementer does NOT commit; the orchestrator commits per task. Mark each commit step "(orchestrator)".
- The test command is `tools/test.ps1 -Test <path>` (and `tools/test.ps1` for everything). The expected output is `Passing Tests N` / exit 0, or a named failure for red steps.
- Respect the 300-line cap per file (aim for 200 lines or fewer) and one class per file.
- Group tasks into **waves**: tasks in the same wave touch disjoint files and can run in parallel; a later wave depends only on earlier waves. Mark each task with `Wave: N`.
- At the end, add a "Coverage map" table: each gdd/architecture section in your scope → the task ids that implement it.

## Output
Write the plan file only. Do not write product code. Do not commit.
Return your report in your **final message** (subagents cannot write report files): the plan path, task count, waves, API extensions you made, and gaps or risks. Keep it under 25 lines.
