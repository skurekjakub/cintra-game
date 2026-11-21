# A10 environment round: render the Drowned Rat shot (MSAA 2x) and build the local side-by-side
# against ref-02 (the compare file is gitignored).
# Usage: powershell -File art-src/env/render_round.ps1 -Round 1 [-Import]
param([int]$Round = 1, [switch]$Import)
$ErrorActionPreference = "Continue"
$repo = Resolve-Path "$PSScriptRoot\..\.."
$godot = $env:GODOT
if (-not $godot) {
    $godot = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7.2-stable_windows_arm64_console.exe"
}
$spike = "$repo\docs\art-direction\spike"
$out = "$spike\env-r$Round.png"
if ($Import) {
    & $godot --headless --path "$repo\game" --import 2>&1 | Select-Object -Last 2
}
& $godot --path "$repo\game" res://spikes/hd2d/shot_runner.tscn -- --shot=drowned_rat --out=$out --msaa=2 --frames=120 2>&1 |
    Select-String -Pattern "saved|ERROR|error|SCRIPT|Vulkan|device" | Select-Object -First 25
Get-ChildItem "$spike\env-r${Round}_vp*.png" -ErrorAction SilentlyContinue | Remove-Item
python "$PSScriptRoot\compare.py" $out "$repo\docs\art-direction\reference\ref-02-forest-combat.png" "$spike\compare-env-r$Round.png"
