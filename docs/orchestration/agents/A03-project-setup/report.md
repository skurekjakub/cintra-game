# A03 report: Godot project setup, test harness and tooling

(Saved by the orchestrator from the agent's hand-back. The orchestrator's own changes are marked ORCH.)

Status: DONE. `tools/test.ps1` reports 53/53 passing on Godot 4.7.2 with GUT 9.7.1; the orchestrator re-ran it and got the same result.

## Created
- Root: `CLAUDE.md`, `README.md` (includes the IP note), `tools/test.ps1`, `tools/test.sh`, `tools/content_convert/.gitkeep`, `art-src/.gitkeep`; `.gitignore` gained `game/addons/.godot_ai_update/`.
- `game/project.godot`: Forward+; GUT and Godot AI enabled; `untyped_declaration` = error; `unsafe_*` = warning; addons excluded from the checks.
- `game/.gutconfig.json`; `addons/gut` (9.7.1); `addons/godot_ai` (4.4.2, sha256 verified); the full §10 folder skeleton (94 `.gdkeep` files); `assets/LICENSES.md`.
- Shared kernel `src/domain/shared/`: Result, SeededRandom (seed and state stored as decimal strings so they survive JSON), IdRules, abstract DomainEvent, Snapshotable, RandomSource.
- `src/application/bus/`: EventBus (exact-class delivery, FIFO, re-entrant publishes queued, delivery cap 1000, freed handlers skipped) and BusSubscription.
- Tests: unit/shared, application/bus, architecture (rules checker on synthetic sources + a scan of `res://src`), helpers. Each script has a `.uid` sidecar, which is committed.

## Test runner
- Options: `-Suite unit|application|content|architecture|smoke|all`, `-Test <dir|file>`, `-Name <substr>`, `-Import`. Re-imports automatically when sources are newer than the class cache.
- GUT exits 0 when a script fails to parse. The runners scan the output for parse/load errors and "Nothing was run" and force exit 1.
- Architecture test proven with three temporary violating files: all were detected, then removed.

## Architecture-test rules (beyond architecture §2's enforcement paragraph)
- A domain may reference only itself, `shared` and `rules`; `shared` may not reference `rules`.
- The engine-API ban (Node, SceneTree, Input, FileAccess, JSON, OS, Time, Engine, etc.) covers domain and application.
- No signals in the domain; only presentation may use `Services`; no inner classes; `class_name` must match the file name; comments and strings are ignored by the checker.

## Godot AI
- Launch command taken from the plugin's own `McpClientConfigurator.resolve_attach_launch` (pythonw + uvx pinned `godot-ai==4.4.2` with `--disable-telemetry`); the uv environment is pre-built.
- Telemetry off: the `--disable-telemetry` argument plus editor setting `godot_ai/telemetry_enabled = false`.
- ORCH: the agent wrote a project-scope `.mcp.json` with absolute machine paths. The repo is public, so the orchestrator moved it to Claude Code **local** scope (`claude mcp add-json --scope local`), deleted `.mcp.json`, added it to `.gitignore`, and set editor setting `godot_ai/mcp_client_scope = "local"`. The server connects only while the Godot 4.7.2 editor is open on `game/`.
- ORCH: replaced the hardcoded `C:\Users\skure\...` Godot path in test.ps1, test.sh and CLAUDE.md with `%LOCALAPPDATA%`-relative paths.

## Deviations from architecture.md
1. JUnit output goes to `reports/junit.xml` (§9.2 and §10 say `test-results/`).
2. The extra architecture rules above (all derived from the §2 table and §11).
3. Small kernel API additions: `Result.is_err()`/`detail`, `IdRules.is_known_kind()`/`KINDS`, `EventBus.subscriber_count()`/`delivery_cap()`.
4. Bus tests are in `tests/application/bus/`.
5. Not yet created: FactsChanged, Services, GameComposer, GameContext, Main.tscn, ScriptedRandom, content_version.json.

## Follow-ups
- `.gitignore` ignores `export_presets.cfg`, but architecture §6 needs the Windows preset committed. Remove that line when export work starts.
- Manual: open the project in the 4.7.2 editor (not the 4.7.0 `godot` on PATH) for Godot AI to connect.
