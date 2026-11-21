# Brief A03 — Godot project setup, test harness, tooling

## Goal
Create the Godot 4.7.2 project skeleton exactly as `docs/design/architecture.md` specifies, with a working headless test harness, the architecture-boundary test, and the AI tooling wired up. When you finish, `tools/test.ps1` exits 0 and runs real tests.

## Read first
- `docs/design/architecture.md` (binding): especially §2 layers, §3 cross-cutting, §8 data, §9 testing, §10 folder layout, §11 coding standards, §12 tooling.
- `docs/design/gdd.md` §1–5 for context only.
- `docs/orchestration/STATE.md` decisions and calls.

## Environment facts
- Godot 4.7.2 console exe: `C:\Users\skure\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7.2-stable_windows_arm64_console.exe`. Do NOT use the `godot` on PATH; it may be 4.7.0.
- Windows 11 ARM64. PowerShell 7 and Git Bash are available, plus uv/uvx, node and git. No MSVC build tools.
- Godot MCP (Coding-Solo) and Blender MCP are registered globally for Claude Code. Their tools may not be loaded in your session; that's fine.
- Downloaded archives are untrusted: extract each into its own new empty directory under the scratchpad (`C:\Users\skure\AppData\Local\Temp\claude\f82cef077b1ec211\fe7622d7-f626-4cfc-b340-9272070adc79\scratchpad`), inspect, then copy only the addon folder into the project.

## Tasks
1. Create the project in `game/` (`project.godot`: name "The Lion's Shadow", Forward+ renderer for now (the art pick may change it), typed-GDScript warnings raised to errors where architecture §11 says so). Create the folder skeleton from architecture §10, with `.gdkeep` files in otherwise empty folders.
2. Install GUT 9.7.1 (or the latest release on its Godot 4.7 line) into `game/addons/gut/`. Add `game/.gutconfig.json`. Verify it runs headless on 4.7.2; if it doesn't, switch to GdUnit4 and update architecture.md §9 accordingly.
3. `tools/test.ps1`: imports when needed, runs all tests headless, writes JUnit XML to `reports/` (gitignored), exits non-zero on failure. Support running one directory or one file via a parameter. Add `tools/test.sh` for Git Bash too.
4. Walking skeleton, done test-first: the shared kernel pieces from architecture §4.1 that everything else needs (for example `Id`/result types, whatever the doc defines), plus the typed event bus from §3.2, each with unit tests written first (red, then green). Keep them minimal but real.
5. Architecture test (`tests/architecture/`) per architecture §9, which fails if:
   - `src/domain` references Node/scene-tree/engine singletons in the forbidden list;
   - a layer imports an outer layer;
   - a domain reaches into another domain's internals;
   - a file exceeds the line cap.
   Prove it works by temporarily adding a violating file, seeing it fail, then removing it.
6. Godot AI plugin (hi-godot/godot-ai, latest release, `godot-ai-v4-plugin.zip`): install into `game/addons/godot_ai/` and enable it in project.godot. Telemetry: turn it off at the project or editor level if the plugin offers a setting; otherwise document `GODOT_AI_DISABLE_TELEMETRY=true`. The plugin's Claude Code configuration normally comes from a dock button (GUI). Check whether there is a headless or CLI way (read its README and source). If there is, configure Claude Code at **project** scope (`.mcp.json` in repo root). If not, leave clear steps in your report; do not hand-write a bare `http://127.0.0.1:8000/mcp` entry, because the plugin docs say that cannot authenticate.
7. A repo-root `CLAUDE.md` (concise, under 120 lines): how to run tests, the Godot exe path rule, the layer and dependency rules, TDD rule, file size cap, where state and briefs live (`docs/orchestration/`), "subagents do not commit". Plus a short `README.md` (what the game is, how to run, how to test, the IP note about Sapkowski place names).
8. Make sure `.gitignore` (repo root) covers `game/.godot/`, `reports/`, and anything else the project generates. Check that `git status` shows no generated junk.

## Rules
- TDD: write each test first and watch it fail before you implement.
- Static typing everywhere. One class per file.
- Do NOT commit; the orchestrator commits. Do not touch `docs/content/` or `docs/art-direction/` (other agents own them).
- If any write is blocked, put that content in your final reply instead.

## Report
Write `docs/orchestration/agents/A03-project-setup/report.md`:
- files and folders created;
- the exact test command and its last output summary (number of tests passing);
- GUT vs GdUnit4 outcome;
- Godot AI configuration status and any manual step left for the orchestrator;
- deviations from architecture.md, with the reason for each.

Reply to the orchestrator in three lines at most.
