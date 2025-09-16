<#
  Workspace Inventory Generator (parser-safe simplified version)
  Outputs: WORKSPACE_INVENTORY.md at repository root
  Captures: Directories & files (including hidden) with basic metadata
  Usage: pwsh -File .\scripts\pwsh\generate-inventory.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root = Get-Location
$output = Join-Path $root 'WORKSPACE_INVENTORY.md'

Write-Host ('Generating workspace inventory from: ' + $root) -ForegroundColor Cyan

# Collect items
$items = Get-ChildItem -Force -Recurse | Sort-Object FullName
$total = $items.Count
$dirs = ($items | Where-Object { $_.PSIsContainer }).Count
$files = $total - $dirs

$sb = [System.Text.StringBuilder]::new()
function AddLine([string]$t) { [void]$sb.AppendLine($t) }

AddLine '# Workspace Inventory'
AddLine ('Generated: ' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz'))
AddLine ''
AddLine '## Summary'
AddLine ('Root: ' + $root.Path)
AddLine ('Total Items: ' + $total)
AddLine ('Directories: ' + $dirs)
AddLine ('Files: ' + $files)
AddLine ''

# Directory tree (basic fallback)
AddLine '## Tree (Directories)'
AddLine '```text'
Get-ChildItem -Force -Recurse -Directory | Sort-Object FullName | ForEach-Object {
  $rel = $_.FullName.Substring($root.Path.Length + 1)
  $depth = ($rel -split '[\\/]').Count
  $indent = ' ' * (($depth - 1) * 2)
  AddLine ($indent + '[' + $_.Name + ']/')
}
AddLine '```'
AddLine ''

# Flat list
AddLine '## Flat Listing'
AddLine 'Path | Type | SizeBytes | Depth | LastWriteUtc'
AddLine '---- | ---- | --------- | ----- | ------------'
foreach ($i in $items) {
  try { $rel = $i.FullName.Substring($root.Path.Length + 1) } catch { continue }
  $rel = $rel -replace '\\', '/'
  $type = if ($i.PSIsContainer) { 'dir' } else { 'file' }
  $size = if ($i.PSIsContainer) { '' } else { $i.Length }
  $depth = ($rel -split '/').Count
  $ts = $i.LastWriteTimeUtc.ToString('yyyy-MM-ddTHH:mm:ssZ')
  $relEsc = $rel -replace '\|', '/'
  AddLine ($relEsc + ' | ' + $type + ' | ' + $size + ' | ' + $depth + ' | ' + $ts)
}

AddLine ''
AddLine '---'
AddLine '*End of inventory*'

[IO.File]::WriteAllText($output, $sb.ToString(), [System.Text.Encoding]::UTF8)
if (Test-Path $output) {
  Write-Host ('Inventory written to ' + $output) -ForegroundColor Green
  Get-Item $output | Select-Object FullName, Length, LastWriteTime
}
else {
  Write-Host ('Failed to create inventory file at ' + $output) -ForegroundColor Red
}
