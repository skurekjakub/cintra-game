#!/usr/bin/env bash
# Strict lint gate for res://src: unsafe or untyped GDScript fails the run (CLAUDE.md "Running tests").
# Git Bash twin of tools/lint.ps1.
#
# Godot only prints warnings in the editor, so a headless test run never shows an UNSAFE_*
# warning. This script instead writes game/override.cfg from tools/lint_override.cfg (every
# warning promoted to an error, only res://src included), runs tools/lint_runner.gd, which
# loads every script under res://src, and always deletes override.cfg again. A script that
# carries such a warning does not compile, so the run fails with Godot's own "Parse Error" line.
#
#   tools/lint.sh        # lint src; exit 0 = clean
#   tools/lint.sh -i     # force a class-cache re-import first
#
# tools/test.sh runs this first unless it gets -L. Same Godot 4.7.2 resolution as tools/test.sh.
set -u

DEFAULT_GODOT="${LOCALAPPDATA:-}\\Microsoft\\WinGet\\Packages\\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\\Godot_v4.7.2-stable_windows_arm64_console.exe"
GODOT_BIN="${GODOT:-$DEFAULT_GODOT}"
if command -v cygpath >/dev/null 2>&1; then GODOT_BIN="$(cygpath -u "$GODOT_BIN")"; fi
[ -f "$GODOT_BIN" ] || { echo "Godot 4.7.2 console binary not found: $GODOT_BIN (set \$GODOT)" >&2; exit 2; }

force_import=0
while getopts "i" opt; do
  case "$opt" in
    i) force_import=1 ;;
    *) echo "usage: $0 [-i]" >&2; exit 2 ;;
  esac
done

tools_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$tools_dir/.." && pwd)"
game_dir="$repo_root/game"
template="$tools_dir/lint_override.cfg"
override="$game_dir/override.cfg"
if command -v cygpath >/dev/null 2>&1; then
  game_arg="$(cygpath -m "$game_dir")"; runner="$(cygpath -m "$tools_dir/lint_runner.gd")"
else
  game_arg="$game_dir"; runner="$tools_dir/lint_runner.gd"
fi

# The runner resolves class_name globals through the class cache, which only --import builds.
# Same staleness rule as tools/test.sh (they share the stamp). Import before the override is
# written so the import never sees it.
cache="$game_dir/.godot/global_script_class_cache.cfg"
stamp="$game_dir/.godot/test_import.stamp"
need_import=$force_import
if [ ! -f "$cache" ] || [ ! -f "$stamp" ]; then
  need_import=1
elif [ -n "$(find "$game_dir/src" "$game_dir/tests" \( -name '*.gd' -o -type d \) -newer "$stamp" -print -quit)" ]; then
  need_import=1
fi
if [ "$need_import" -eq 1 ]; then
  echo "[lint] Importing project (refreshing the class cache)..."
  "$GODOT_BIN" --headless --path "$game_arg" --import >/dev/null 2>&1
  date -u +%FT%TZ > "$stamp"
fi

# Always remove the override, however this script ends.
log="$(mktemp)"
cleanup() { rm -f "$override" "$log"; }
trap cleanup EXIT
trap 'exit 130' INT TERM

cp "$template" "$override"
"$GODOT_BIN" --headless --path "$game_arg" -s "$runner" 2>&1 | tee "$log"
code=${PIPESTATUS[0]}

# Godot can exit 0 even when the runner never ran (for example if it failed to parse), so
# success needs the runner's OK marker and no error lines, not just exit code 0.
if [ "$code" -eq 0 ] && grep -qE 'Parse Error|Failed to load script|SCRIPT ERROR' "$log"; then
  echo "[lint] FAILED: Godot reported script errors (see lines above)"
  code=1
elif [ "$code" -eq 0 ] && ! grep -q '^\[lint\] OK:' "$log"; then
  echo "[lint] FAILED: the runner did not report OK (it may not have run)"
  code=1
fi
echo "[lint] exit code $code"
exit "$code"
