<#
.SYNOPSIS
  Strict lint gate for res://src: unsafe or untyped GDScript fails the run (CLAUDE.md "Running tests").

.DESCRIPTION
  Godot only prints warnings in the editor, so a headless test run never shows an UNSAFE_*
  warning. This script instead writes game/override.cfg from tools/lint_override.cfg (every
  warning promoted to an error, only res://src included), runs tools/lint_runner.gd, which
  loads every script under res://src, and always deletes override.cfg again. A script that
  carries such a warning does not compile, so the run fails with Godot's own "Parse Error" line.
  The runner also refuses to run when the policy is not in force, so the gate cannot pass vacuously.

.EXAMPLE
  tools/lint.ps1             # lint src; exit 0 = clean
  tools/lint.ps1 -Import     # force a class-cache re-import first

.NOTES
  tools/test.ps1 runs this first unless it gets -NoLint. Same Godot 4.7.2 resolution as
  tools/test.ps1 (set $env:GODOT to override).
#>
[CmdletBinding()]
param(
    [switch]$Import
)

$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$GameDir = Join-Path $RepoRoot 'game'
$Override = Join-Path $GameDir 'override.cfg'
# First of all: a hard-killed earlier run may have left the strict policy behind.
Remove-Item -Path $Override -Force -ErrorAction SilentlyContinue

$DefaultGodot = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7.2-stable_windows_arm64_console.exe'
$Godot = if ($env:GODOT) { $env:GODOT } else { $DefaultGodot }
if (-not (Test-Path $Godot)) { throw "Godot 4.7.2 console binary not found: $Godot (set `$env:GODOT)" }

$Template = Join-Path $PSScriptRoot 'lint_override.cfg'
$Runner = (Join-Path $PSScriptRoot 'lint_runner.gd') -replace '\\', '/'

# The runner resolves class_name globals through the class cache, which only --import builds.
# Same staleness rule as tools/test.ps1 (they share the stamp). Import before the override is
# written so the import never sees it.
$ClassCache = Join-Path $GameDir '.godot/global_script_class_cache.cfg'
$Stamp = Join-Path $GameDir '.godot/test_import.stamp'
$needImport = $Import -or -not (Test-Path $ClassCache) -or -not (Test-Path $Stamp)
if (-not $needImport) {
    $stampTime = (Get-Item $Stamp).LastWriteTimeUtc
    $newer = Get-ChildItem -Path (Join-Path $GameDir 'src'), (Join-Path $GameDir 'tests') -Recurse |
        Where-Object { ($_.PSIsContainer -or $_.Extension -eq '.gd') -and $_.LastWriteTimeUtc -gt $stampTime } |
        Select-Object -First 1
    $needImport = $null -ne $newer
}
if ($needImport) {
    Write-Host '[lint] Importing project (refreshing the class cache)...'
    & $Godot --headless --path $GameDir --import 2>&1 | Out-Null
    Set-Content -Path $Stamp -Value (Get-Date -Format o)
}

# Success is positive: Godot exit code exactly 0, the runner's OK marker seen, and no error
# lines. Anything else (a null exit code, a runner that never ran, stray errors) fails.
$Problems = @('Parse Error', 'Failed to load script', 'SCRIPT ERROR')
$problemLines = [System.Collections.Generic.List[string]]::new()
$sawOk = [System.Collections.Generic.List[string]]::new()
$code = $null
try {
    Copy-Item -Path $Template -Destination $Override -Force
    $ErrorActionPreference = 'Continue'
    & $Godot --headless --path $GameDir -s $Runner 2>&1 | ForEach-Object {
        $line = "$_"
        Write-Host $line
        if ($line.StartsWith('[lint] OK:')) { $sawOk.Add($line) }
        foreach ($p in $Problems) { if ($line.Contains($p)) { $problemLines.Add($line); break } }
    }
    $code = $LASTEXITCODE
} finally {
    Remove-Item -Path $Override -Force -ErrorAction SilentlyContinue
}

$passed = ($null -ne $code) -and ($code -eq 0) -and ($sawOk.Count -gt 0) -and ($problemLines.Count -eq 0)
if (-not $passed) {
    $why = "Godot exit code '$code', OK marker seen: $($sawOk.Count -gt 0), error lines: $($problemLines.Count)"
    Write-Host "[lint] FAILED: $why"
    Write-Host '[lint] exit code 1'
    exit 1
}
Write-Host '[lint] exit code 0'
exit 0
