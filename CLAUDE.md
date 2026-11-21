# CLAUDE.md: The Lion's Shadow (cintra-game)

A real-time action RPG in Godot 4.7.2 with statically typed GDScript. The Godot project lives in `game/` (`res://` = `game/`).
Binding design docs: `docs/design/gdd.md` (rules), `docs/design/architecture.md` (code), `docs/design/content-format.md` (content).

## Godot binary: always 4.7.2

The `godot` on `PATH` may be 4.7.0. Never use it: it can rewrite project files with 4.7.0 serialization. Use the console build:

```powershell
$env:GODOT = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7.2-stable_windows_arm64_console.exe"
& $env:GODOT --headless --path game --import   # rebuild the class cache by hand (test scripts do it for you)
```

## Running tests (GUT 9.7.1, headless)

```powershell
tools/test.ps1                                         # everything
tools/test.ps1 -Suite unit                             # unit | application | content | architecture | smoke
tools/test.ps1 -Test tests/unit/shared                 # one directory, recursive
tools/test.ps1 -Test tests/unit/shared/test_result.gd  # one file
tools/test.ps1 -Test tests/unit/shared/test_result.gd -Name err_keeps   # tests whose name contains the text
tools/test.ps1 -Import                                 # force a re-import first
tools/test.ps1 -NoLint                                 # skip the lint gate while iterating
tools/lint.ps1                                         # the lint gate alone
```

Git Bash: `tools/test.sh [-s suite] [-t path] [-n name] [-i] [-L]` (`-L` = no lint) and `tools/lint.sh`.
- Exit code 0 means everything passed. JUnit XML goes to `reports/junit.xml` (git-ignored).
- The scripts re-import automatically when a `.gd` file under `src/` or `tests/` changed, because new `class_name`s need the class cache.
- A script that fails to parse fails the run. GUT alone would skip it and exit 0.
- **Lint gate:** every run first compiles all of `src/` with the `unsafe_*`, `untyped_declaration`, `unused_*`, `shadowed_*` and the other default-on GDScript warnings promoted to errors (headless Godot never prints warnings, so this is the only enforcement). Violations print Godot's `Parse Error` line and fail the run before any test. Fix them with typed locals; a justified exception takes `@warning_ignore("name")` on that line. The policy is `tools/lint_override.cfg`, copied temporarily to `game/override.cfg` (git-ignored), and only `res://src` is linted, not `tests/` or `addons/`.

## TDD (binding)

1. Write the test first in the right folder, run it with `-Test <file>`, and see it fail for the expected reason.
2. Write the minimum code to pass. Run the domain's suite, then everything.
3. Refactor while the suite stays green. A report lists the tests added and the final full-suite pass count.
4. Tests are deterministic: inject `SeededRandom(seed)` or a scripted source, pass time as `delta`, and never `await` real time in unit tests.

Test layout: `tests/unit/<domain>/`, `tests/application/`, `tests/content/`, `tests/architecture/`, `tests/smoke/`, plus `tests/helpers/` (fakes and builders) and `tests/fixtures/`.

## Layers and dependency rule (architecture.md §2)

```
presentation ──► application ──► domain
      └──► infrastructure ──┘   (infrastructure implements application ports)
```

| Layer | Path | May use | Must not |
|---|---|---|---|
| domain | `src/domain/<domain>/` | its own domain, `domain/shared`, `domain/rules`, Godot core value types | `Node`, `SceneTree`/`get_tree`, `Input`, `FileAccess`, `DirAccess`, `ResourceLoader`, `JSON`, `OS`, `Time`, `Engine`, `Services`, signals, other domains |
| application | `src/application/` | domain | scene tree, file APIs, concrete infrastructure classes |
| infrastructure | `src/infrastructure/` | application ports, domain definitions | presentation |
| presentation | `src/presentation/` | everything | holding game rules |

- A domain's public classes sit at its root. Helpers go in `<domain>/_internal/` and are private to that domain.
- Domain objects never publish. They record `DomainEvent`s in an outbox (`drain_events()`), and use cases publish them on the `EventBus`.
- Constructor injection everywhere. `GameComposer` is the only class that names concrete infrastructure.
- The only autoload is `Services`, and only presentation may read it (in scene-root `_ready()` fallbacks).
- `tests/architecture/test_dependency_rule.gd` enforces all of this and runs with every suite.

## Coding standards (architecture.md §11)

- Static typing everywhere. `untyped_declaration` is an error. `unsafe_*` warnings are review blockers. Use typed arrays and dictionaries, and `StringName` for ids.
- One class per file, no inner classes. `snake_case.gd` matches `class_name PascalCase`.
- **File size:** aim for 200 lines or fewer. The hard cap is 300 lines and it is tested. Functions stay at 30 lines or fewer with 4 parameters or fewer, and nesting stays at 3 levels or fewer.
- Expected failures return `Result.err(code)`. Programmer errors use `assert()`.
- Abstract bases use `@abstract`. Ids follow `kind.snake_case` (see `IdRules`).
- Each domain class's header comment cites the `gdd.md` section it implements.

## Shared kernel and bus (already built)

- `src/domain/shared/`: `Result`, `DomainEvent`, `Snapshotable`, `RandomSource`, `SeededRandom`, `IdRules`.
- `src/application/bus/`: `EventBus` (typed by event class, synchronous, FIFO, re-entrant publishes queued, delivery cap of 1000) and `BusSubscription`.

## Tooling

- **Godot MCP** (Coding-Solo, global): after scene or presentation work, `run_project` on `game/`, then `get_debug_output`, then `stop_project`. Zero script errors is part of done.
- **Godot AI plugin** (`game/addons/godot_ai/`, registered at Claude Code **local** scope; no committed `.mcp.json`, because the launch command holds machine paths. On a new machine, use the dock's Configure button with scope = local): needs the Godot 4.7.2 editor open on `game/`. Use it for scene wiring, UI, materials and animation. Do not use it to write gameplay or domain scripts outside TDD. Telemetry is off.
- **Blender MCP** (global): assets are procedural or CC0 only. Record each one in `game/assets/LICENSES.md`. Sources go in `art-src/`.

## Orchestration

- State, decisions and the agent table: `docs/orchestration/STATE.md`.
- Briefs and reports: `docs/orchestration/agents/<id>/brief.md` and `report.md`.
- **Commits:** on `main`, subagents do not commit (several agents share that tree); the orchestrator verifies each report and commits only that agent's paths. In an implementation worktree (`.worktrees/<plan>`, branch `feat/<plan>`), exactly one implementer runs at a time and commits its own task; the orchestrator pushes and merges.
- Plan execution ledgers: `.superpowers/sdd/<plan>/progress.md` inside the worktree (git-ignored); milestones are mirrored in `docs/orchestration/STATE.md`.
- Only touch the paths your brief owns. `docs/content/` and `docs/art-direction/` belong to their own agents.
