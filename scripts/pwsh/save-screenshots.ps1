<#
.SYNOPSIS
    Helper script to save telehealth scheduling screenshots into assets/images with standardized filenames.
.DESCRIPTION
    Prompts user to select PNG files (exported from screenshots) and copies/renames them to the repository
  assets/images directory using the required v0.3.3 naming convention. Optionally compresses images if
    they exceed the recommended size threshold (300 KB) using System.Drawing.
.NOTES
    Copyright 2025 Kyle J. Coder
    Apache License 2.0
#>

param(
  [string]$SourceFolder = (Get-Location).Path,
  [string]$TargetFolder = "$(Get-Location)\assets\images",
  [int]$MaxKb = 300
)

Write-Host "🖼️ Telehealth Screenshot Save Utility (v0.3.3)" -ForegroundColor Cyan
Write-Host "Source: $SourceFolder" -ForegroundColor Gray
Write-Host "Target: $TargetFolder" -ForegroundColor Gray

if (!(Test-Path $TargetFolder)) {
  Write-Host "Creating target folder..." -ForegroundColor Yellow
  New-Item -ItemType Directory -Path $TargetFolder -Force | Out-Null
}

$mapping = @{
  "app-landing"                = "app-landing-v0.3.3.png"
  "schedule-grid"              = "schedule-grid-v0.3.3.png"
  "sharepoint-master-schedule" = "sharepoint-master-schedule-v0.3.2.png"
  "approval-flow-architecture" = "approval-flow-architecture-v0.3.2.png"
}

Write-Host "Provide the full path of each screenshot (PNG). Leave blank to skip." -ForegroundColor Yellow
$screens = @()
foreach ($key in $mapping.Keys) {
  $destName = $mapping[$key]
  $inputPath = Read-Host "Path for '$key' screenshot"
  if ([string]::IsNullOrWhiteSpace($inputPath)) { continue }
  if (!(Test-Path $inputPath)) { Write-Warning "File not found: $inputPath"; continue }
  $target = Join-Path $TargetFolder $destName
  Copy-Item $inputPath $target -Force
  $fileInfo = Get-Item $target
  $sizeKb = [math]::Round($fileInfo.Length / 1KB, 2)
  Write-Host "Saved $destName ($sizeKb KB)" -ForegroundColor Green
  $screens += $target
  if ($sizeKb -gt $MaxKb) {
    Write-Host "Compressing $destName (>$MaxKb KB)..." -ForegroundColor Yellow
    try {
      Add-Type -AssemblyName System.Drawing
      $img = [System.Drawing.Image]::FromFile($target)
      $quality = 80
      $enc = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/png' }
      $params = New-Object System.Drawing.Imaging.EncoderParameters
      $params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality, $quality)
      # Re-save as PNG (PNG ignores Quality but keeps pipeline for consistency)
      $img.Save($target, $enc, $params)
      $img.Dispose()
      $newSizeKb = [math]::Round((Get-Item $target).Length / 1KB, 2)
      Write-Host "Compressed to $newSizeKb KB" -ForegroundColor Cyan
    }
    catch {
      Write-Warning "Compression failed: $($_.Exception.Message)"
    }
  }
}

if ($screens.Count -eq 0) {
  Write-Host "No screenshots processed." -ForegroundColor Yellow
}
else {
  Write-Host "Screenshot gallery updated. Confirm images render in README preview." -ForegroundColor Cyan
}
