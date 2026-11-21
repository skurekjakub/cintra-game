# The Lion's Shadow

A single-player, real-time action RPG of court intrigue. You play a hired sword who is handed a letter half the kingdom would kill for. You investigate a poisoning at the court of Cintra, fight through mud and iron, and choose between five endings. The story outline is in `story.md`, and the design is in `docs/design/`.

Status: early development. The project skeleton, the shared kernel, the event bus and the test harness exist. Gameplay is being built domain by domain.

## Requirements

- Godot **4.7.2** (the standard build, not .NET). The console binary is needed for test output on Windows.
- Windows PC (keyboard and mouse, or a gamepad).
- Optional, for AI tooling: `uv` (needed by the Godot AI editor plugin).

## Run

Open `game/project.godot` in Godot 4.7.2. There is no playable scene yet. Once `scenes/main/Main.tscn` exists, press F5 to run it.

## Test

```powershell
tools/test.ps1                      # all tests, headless (PowerShell)
tools/test.ps1 -Suite unit          # one suite
tools/test.ps1 -Test tests/unit/shared/test_result.gd
```

```bash
tools/test.sh                       # Git Bash
```

The scripts use `$env:GODOT` if it is set. Otherwise they use the 4.7.2 path that `CLAUDE.md` documents. They write JUnit XML to `reports/junit.xml`.

## Layout

- `game/`: the Godot project (`src/` code by layer, `content/` JSON data, `scenes/`, `assets/`, `tests/`).
- `docs/`: the design docs, the content scripts and orchestration notes.
- `tools/`: the test runners and the future content converter.
- `art-src/`: Blender sources, kept outside the Godot import scan.

## IP note

The story borrows place names from Andrzej Sapkowski's Witcher setting (Cintra, Attre, Sodden, Brugge, Verden, Mag Turga, the Yaruga, Marnadal) and some generic creature names (drowners). Every character, the plot and every asset are original. This is an unofficial fan project, not affiliated with or endorsed by Andrzej Sapkowski or CD PROJEKT. It uses none of CD PROJEKT's assets, UI or visual likeness.

## Third-party

- [GUT](https://github.com/bitwes/Gut) 9.7.1 (MIT), in `game/addons/gut/`.
- [Godot AI](https://github.com/hi-godot/godot-ai) 4.4.2 (MIT), an editor-only plugin in `game/addons/godot_ai/`.
