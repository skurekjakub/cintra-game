<#
.SYNOPSIS
  Strict lint gate for res://src: unsafe or untyped GDScript fails the run (CLAUDE.md "Running tests").

.DESCRIPTION
  Godot only prints warnings in the editor, so a headless test run never shows an UNSAFE_*
  warning. This script instead writes game/override.cfg from tools/lint_override.cfg (every
  warning promoted to an error, only res://src included), runs tools/lint_runner.gd, which
  loads every script under res://src, and always deletes override.cfg again. A script that
  carries such a warning does not compile, so the run fails with Godot's own "Parse Error" line.

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

$DefaultGodot = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7.2-stable_windows_arm64_console.exe'
$Godot = if ($env:GODOT) { $env:GODOT } else { $DefaultGodot }
if (-not (Test-Path $Godot)) { throw "Godot 4.7.2 console binary not found: $Godot (set `$env:GODOT)" }

$RepoRoot = Split-Path -Parent $PSScriptRoot
$GameDir = Join-Path $RepoRoot 'game'
$Template = Join-Path $PSScriptRoot 'lint_override.cfg'
$Runner = (Join-Path $PSScriptRoot 'lint_runner.gd') -replace '\\', '/'
$Override = Join-Path $GameDir 'override.cfg'

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

# Godot can exit 0 even when the runner never ran (for example if it failed to parse), so
# success needs the runner's OK marker and no error lines, not just exit code 0.
$Problems = @('Parse Error', 'Failed to load script', 'SCRIPT ERROR')
$problemLines = [System.Collections.Generic.List[string]]::new()
$sawOk = [System.Collections.Generic.List[string]]::new()
$code = 1
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

if ($code -eq 0 -and $problemLines.Count -gt 0) {
    Write-Host "[lint] FAILED: $($problemLines.Count) error line(s), first: $($problemLines[0])"
    $code = 1
} elseif ($code -eq 0 -and $sawOk.Count -eq 0) {
    Write-Host '[lint] FAILED: the runner did not report OK (it may not have run)'
    $code = 1
}
Write-Host "[lint] exit code $code"
exit $code
