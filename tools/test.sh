#!/usr/bin/env bash
# Runs the GUT test suite headless on Godot 4.7.2 (architecture.md section 9.2).
# Git Bash twin of tools/test.ps1.
#
#   tools/test.sh                                   # all suites
#   tools/test.sh -s unit                           # one suite: unit|application|content|architecture|smoke
#   tools/test.sh -t tests/unit/shared              # one directory (recursive)
#   tools/test.sh -t tests/unit/shared/test_result.gd [-n err_keeps_code]
#   tools/test.sh -i                                # force a re-import first
#
# -t accepts res:// paths or paths relative to game/ or to the repo root.
# JUnit XML goes to reports/junit.xml. The exit code is Godot's (0 = all passed).
set -u

DEFAULT_GODOT="${LOCALAPPDATA:-}\\Microsoft\\WinGet\\Packages\\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\\Godot_v4.7.2-stable_windows_arm64_console.exe"
GODOT_BIN="${GODOT:-$DEFAULT_GODOT}"
if command -v cygpath >/dev/null 2>&1; then GODOT_BIN="$(cygpath -u "$GODOT_BIN")"; fi
[ -f "$GODOT_BIN" ] || { echo "Godot 4.7.2 console binary not found: $GODOT_BIN (set \$GODOT)" >&2; exit 2; }

suite="all"; test_path=""; test_name=""; force_import=0
while getopts "s:t:n:i" opt; do
  case "$opt" in
    s) suite="$OPTARG" ;;
    t) test_path="$OPTARG" ;;
    n) test_name="$OPTARG" ;;
    i) force_import=1 ;;
    *) echo "usage: $0 [-s suite] [-t path] [-n test_name] [-i]" >&2; exit 2 ;;
  esac
done

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
game_dir="$repo_root/game"
mkdir -p "$repo_root/reports"
junit="$repo_root/reports/junit.xml"
if command -v cygpath >/dev/null 2>&1; then
  game_arg="$(cygpath -m "$game_dir")"; junit="$(cygpath -m "$junit")"
else
  game_arg="$game_dir"
fi

to_res() {
  local p="${1//\\//}"
  case "$p" in res://*) echo "$p"; return ;; esac
  p="${p#./}"; p="${p#game/}"
  echo "res://$p"
}

# class_name lookups need an up-to-date global class cache, which only --import builds.
cache="$game_dir/.godot/global_script_class_cache.cfg"
stamp="$game_dir/.godot/test_import.stamp"
need_import=$force_import
if [ ! -f "$cache" ] || [ ! -f "$stamp" ]; then
  need_import=1
elif [ -n "$(find "$game_dir/src" "$game_dir/tests" \( -name '*.gd' -o -type d \) -newer "$stamp" -print -quit)" ]; then
  need_import=1
fi
if [ "$need_import" -eq 1 ]; then
  echo "[test] Importing project (refreshing the class cache)..."
  "$GODOT_BIN" --headless --path "$game_arg" --import >/dev/null 2>&1
  date -u +%FT%TZ > "$stamp"
fi

args=(--headless --path "$game_arg" -s res://addons/gut/gut_cmdln.gd -gconfig=res://.gutconfig.json "-gjunit_xml_file=$junit" -gexit)
if [ -n "$test_path" ]; then
  res="$(to_res "$test_path")"; fs="$game_dir/${res#res://}"
  if [ -d "$fs" ]; then args+=(-gdir= "-gdir=$res" -ginclude_subdirs)
  elif [ -f "$fs" ]; then args+=(-gdir= "-gtest=$res")
  else echo "Test path not found: $test_path ($fs)" >&2; exit 2; fi
elif [ "$suite" != "all" ]; then
  args+=(-gdir= "-gdir=res://tests/$suite" -ginclude_subdirs)
fi
[ -n "$test_name" ] && args+=("-gunit_test_name=$test_name")

# GUT skips a script that fails to parse and can then exit 0 ("Nothing was run").
# Scan the output so a broken script always fails the run.
log="$(mktemp)"
"$GODOT_BIN" "${args[@]}" 2>&1 | tee "$log"
code=${PIPESTATUS[0]}
if [ "$code" -eq 0 ] && grep -qE 'Parse Error|Failed to load script|Nothing was run|does not extend GutTest' "$log"; then
  echo "[test] FAILED: a test or source script failed to load (see Parse Error lines above)"
  code=1
fi
rm -f "$log"
echo "[test] exit code $code, JUnit: $junit"
exit "$code"
