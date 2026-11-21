<#
.SYNOPSIS
  Runs the GUT test suite headless on Godot 4.7.2 (architecture.md section 9.2).

.EXAMPLE
  tools/test.ps1                                   # all suites
  tools/test.ps1 -Suite unit                       # one suite
  tools/test.ps1 -Test tests/unit/shared           # one directory (recursive)
  tools/test.ps1 -Test tests/unit/shared/test_result.gd
  tools/test.ps1 -Test tests/unit/shared/test_result.gd -Name err_keeps_code
  tools/test.ps1 -Import                           # force a re-import first
  tools/test.ps1 -NoLint                           # skip the strict lint gate (faster iteration)

.NOTES
  Unless -NoLint is given, tools/lint.ps1 runs first and a lint failure fails the run before
  any test starts (unsafe or untyped code under res://src, see CLAUDE.md).
  -Test accepts res:// paths or paths relative to game/ or to the repo root.
  JUnit XML goes to reports/junit.xml. The exit code is Godot's (0 = all passed).
#>
[CmdletBinding()]
param(
    [ValidateSet('all', 'unit', 'application', 'content', 'architecture', 'smoke')]
    [string]$Suite = 'all',
    [string]$Test = '',
    [string]$Name = '',
    [switch]$Import,
    [switch]$NoLint
)

$ErrorActionPreference = 'Stop'

$DefaultGodot = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7.2-stable_windows_arm64_console.exe'
$Godot = if ($env:GODOT) { $env:GODOT } else { $DefaultGodot }
if (-not (Test-Path $Godot)) { throw "Godot 4.7.2 console binary not found: $Godot (set `$env:GODOT)" }

$RepoRoot = Split-Path -Parent $PSScriptRoot
$GameDir = Join-Path $RepoRoot 'game'
$ReportsDir = Join-Path $RepoRoot 'reports'
New-Item -ItemType Directory -Force $ReportsDir | Out-Null
$JunitFile = (Join-Path $ReportsDir 'junit.xml') -replace '\\', '/'

function ConvertTo-ResPath([string]$Path) {
    if ($Path.StartsWith('res://')) { return $Path }
    $p = $Path -replace '\\', '/'
    $p = $p.TrimStart('.', '/')
    if ($p.StartsWith('game/')) { $p = $p.Substring(5) }
    return "res://$p"
}

# class_name lookups need an up-to-date global class cache, which only --import builds.
# Re-import when the cache is missing or any script changed since the last import.
$ClassCache = Join-Path $GameDir '.godot/global_script_class_cache.cfg'
$Stamp = Join-Path $GameDir '.godot/test_import.stamp'
$needImport = $Import -or -not (Test-Path $ClassCache) -or -not (Test-Path $Stamp)
if (-not $needImport) {
    $stampTime = (Get-Item $Stamp).LastWriteTimeUtc
    # Directories count too: deleting a script updates its folder's timestamp.
    $newer = Get-ChildItem -Path (Join-Path $GameDir 'src'), (Join-Path $GameDir 'tests') -Recurse |
        Where-Object { ($_.PSIsContainer -or $_.Extension -eq '.gd') -and $_.LastWriteTimeUtc -gt $stampTime } |
        Select-Object -First 1
    $needImport = $null -ne $newer
}
if ($needImport) {
    Write-Host '[test] Importing project (refreshing the class cache)...'
    & $Godot --headless --path $GameDir --import 2>&1 | Out-Null
    Set-Content -Path $Stamp -Value (Get-Date -Format o)
}

# Strict lint gate: unsafe or untyped code under res://src fails the run (tools/lint.ps1).
# It runs after the import above, so its class cache is fresh, and before any test.
if (-not $NoLint) {
    & (Join-Path $PSScriptRoot 'lint.ps1')
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[test] FAILED: lint gate failed (exit $LASTEXITCODE). Fix the errors above, or use -NoLint while iterating."
        exit 1
    }
}

$GutArgs = @('--headless', '--path', $GameDir, '-s', 'res://addons/gut/gut_cmdln.gd',
    '-gconfig=res://.gutconfig.json', "-gjunit_xml_file=$JunitFile", '-gexit')

if ($Test) {
    $res = ConvertTo-ResPath $Test
    $fsPath = Join-Path $GameDir ($res.Substring(6))
    if (Test-Path $fsPath -PathType Container) {
        $GutArgs += @('-gdir=', "-gdir=$res", '-ginclude_subdirs')
    } elseif (Test-Path $fsPath -PathType Leaf) {
        $GutArgs += @('-gdir=', "-gtest=$res")
    } else {
        throw "Test path not found: $Test ($fsPath)"
    }
} elseif ($Suite -ne 'all') {
    $GutArgs += @('-gdir=', "-gdir=res://tests/$Suite", '-ginclude_subdirs')
}
if ($Name) { $GutArgs += "-gunit_test_name=$Name" }

# GUT skips a test script that fails to parse and can then report "Nothing was run"
# with exit code 0. Scan the output so a broken script always fails the run.
$BrokenPatterns = @('Parse Error', 'Failed to load script', 'Nothing was run', 'does not extend GutTest')
$broken = [System.Collections.Generic.List[string]]::new()
$ErrorActionPreference = 'Continue'
& $Godot @GutArgs 2>&1 | ForEach-Object {
    $line = "$_"
    Write-Host $line
    foreach ($p in $BrokenPatterns) { if ($line.Contains($p)) { $broken.Add($line); break } }
}
$code = $LASTEXITCODE
if ($code -eq 0 -and $broken.Count -gt 0) {
    Write-Host "[test] FAILED: $($broken.Count) load/parse problem line(s), first: $($broken[0])"
    $code = 1
}
Write-Host "[test] exit code $code, JUnit: $JunitFile"
exit $code
